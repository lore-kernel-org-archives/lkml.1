Return-Path: <linux-kernel-owner+w=401wt.eu-S1758712AbXJJVv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758712AbXJJVv6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 17:51:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757623AbXJJVpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 17:45:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34240 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757483AbXJJVpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 17:45:12 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 22/31] IGET: Stop the MINIX filesystem from using iget() and
	read_inode() [try #3]
To: hch@infradead.org, viro@ftp.linux.org.uk, torvalds@osdl.org, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       dhowells@redhat.com
Date: Wed, 10 Oct 2007 22:45:00 +0100
Message-ID: <20071010214500.17535.86223.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071010214308.17535.5406.stgit@warthog.procyon.org.uk>
References: <20071010214308.17535.5406.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stop the MINIX filesystem from using iget() and read_inode().  Replace
minix_read_inode() with minix_iget(), and call that instead of iget().
minix_iget() then uses iget_locked() directly and returns a proper error code
instead of an inode in the event of an error.

minix_fill_super() returns any error incurred when getting the root inode
instead of EINVAL.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/minix/inode.c |   43 +++++++++++++++++++++++++++++--------------
 fs/minix/minix.h |    1 +
 fs/minix/namei.c |    7 +++----
 3 files changed, 33 insertions(+), 18 deletions(-)

diff --git a/fs/minix/inode.c b/fs/minix/inode.c
index 43668d7..ee329f8 100644
--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
@@ -18,7 +18,6 @@
 #include <linux/highuid.h>
 #include <linux/vfs.h>
 
-static void minix_read_inode(struct inode * inode);
 static int minix_write_inode(struct inode * inode, int wait);
 static int minix_statfs(struct dentry *dentry, struct kstatfs *buf);
 static int minix_remount (struct super_block * sb, int * flags, char * data);
@@ -96,7 +95,6 @@ static void destroy_inodecache(void)
 static const struct super_operations minix_sops = {
 	.alloc_inode	= minix_alloc_inode,
 	.destroy_inode	= minix_destroy_inode,
-	.read_inode	= minix_read_inode,
 	.write_inode	= minix_write_inode,
 	.delete_inode	= minix_delete_inode,
 	.put_super	= minix_put_super,
@@ -149,6 +147,7 @@ static int minix_fill_super(struct super_block *s, void *data, int silent)
 	unsigned long i, block;
 	struct inode *root_inode;
 	struct minix_sb_info *sbi;
+	int ret = -EINVAL;
 
 	sbi = kzalloc(sizeof(struct minix_sb_info), GFP_KERNEL);
 	if (!sbi)
@@ -246,10 +245,13 @@ static int minix_fill_super(struct super_block *s, void *data, int silent)
 
 	/* set up enough so that it can read an inode */
 	s->s_op = &minix_sops;
-	root_inode = iget(s, MINIX_ROOT_INO);
-	if (!root_inode || is_bad_inode(root_inode))
+	root_inode = minix_iget(s, MINIX_ROOT_INO);
+	if (IS_ERR(root_inode)) {
+		ret = PTR_ERR(root_inode);
 		goto out_no_root;
+	}
 
+	ret = -ENOMEM;
 	s->s_root = d_alloc_root(root_inode);
 	if (!s->s_root)
 		goto out_iput;
@@ -290,6 +292,7 @@ out_freemap:
 	goto out_release;
 
 out_no_map:
+	ret = -ENOMEM;
 	if (!silent)
 		printk("MINIX-fs: can't allocate map\n");
 	goto out_release;
@@ -316,7 +319,7 @@ out_bad_sb:
 out:
 	s->s_fs_info = NULL;
 	kfree(sbi);
-	return -EINVAL;
+	return ret;
 }
 
 static int minix_statfs(struct dentry *dentry, struct kstatfs *buf)
@@ -394,7 +397,7 @@ void minix_set_inode(struct inode *inode, dev_t rdev)
 /*
  * The minix V1 function to read an inode.
  */
-static void V1_minix_read_inode(struct inode * inode)
+static struct inode *V1_minix_iget(struct inode * inode)
 {
 	struct buffer_head * bh;
 	struct minix_inode * raw_inode;
@@ -403,8 +406,8 @@ static void V1_minix_read_inode(struct inode * inode)
 
 	raw_inode = minix_V1_raw_inode(inode->i_sb, inode->i_ino, &bh);
 	if (!raw_inode) {
-		make_bad_inode(inode);
-		return;
+		iget_failed(inode);
+		return ERR_PTR(-EIO);
 	}
 	inode->i_mode = raw_inode->i_mode;
 	inode->i_uid = (uid_t)raw_inode->i_uid;
@@ -420,12 +423,14 @@ static void V1_minix_read_inode(struct inode * inode)
 		minix_inode->u.i1_data[i] = raw_inode->i_zone[i];
 	minix_set_inode(inode, old_decode_dev(raw_inode->i_zone[0]));
 	brelse(bh);
+	unlock_new_inode(inode);
+	return inode;
 }
 
 /*
  * The minix V2 function to read an inode.
  */
-static void V2_minix_read_inode(struct inode * inode)
+static struct inode *V2_minix_iget(struct inode * inode)
 {
 	struct buffer_head * bh;
 	struct minix2_inode * raw_inode;
@@ -434,8 +439,8 @@ static void V2_minix_read_inode(struct inode * inode)
 
 	raw_inode = minix_V2_raw_inode(inode->i_sb, inode->i_ino, &bh);
 	if (!raw_inode) {
-		make_bad_inode(inode);
-		return;
+		iget_failed(inode);
+		return ERR_PTR(-EIO);
 	}
 	inode->i_mode = raw_inode->i_mode;
 	inode->i_uid = (uid_t)raw_inode->i_uid;
@@ -453,17 +458,27 @@ static void V2_minix_read_inode(struct inode * inode)
 		minix_inode->u.i2_data[i] = raw_inode->i_zone[i];
 	minix_set_inode(inode, old_decode_dev(raw_inode->i_zone[0]));
 	brelse(bh);
+	unlock_new_inode(inode);
+	return inode;
 }
 
 /*
  * The global function to read an inode.
  */
-static void minix_read_inode(struct inode * inode)
+struct inode *minix_iget(struct super_block *sb, unsigned long ino)
 {
+	struct inode *inode;
+
+	inode = iget_locked(sb, ino);
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+	if (!(inode->i_state & I_NEW))
+		return inode;
+
 	if (INODE_VERSION(inode) == MINIX_V1)
-		V1_minix_read_inode(inode);
+		return V1_minix_iget(inode);
 	else
-		V2_minix_read_inode(inode);
+		return V2_minix_iget(inode);
 }
 
 /*
diff --git a/fs/minix/minix.h b/fs/minix/minix.h
index 73ef84f..3ee2242 100644
--- a/fs/minix/minix.h
+++ b/fs/minix/minix.h
@@ -45,6 +45,7 @@ struct minix_sb_info {
 	unsigned short s_version;
 };
 
+extern struct inode *minix_iget(struct super_block *, unsigned long);
 extern struct minix_inode * minix_V1_raw_inode(struct super_block *, ino_t, struct buffer_head **);
 extern struct minix2_inode * minix_V2_raw_inode(struct super_block *, ino_t, struct buffer_head **);
 extern struct inode * minix_new_inode(const struct inode * dir, int * error);
diff --git a/fs/minix/namei.c b/fs/minix/namei.c
index f4aa7a9..3b1684a 100644
--- a/fs/minix/namei.c
+++ b/fs/minix/namei.c
@@ -54,10 +54,9 @@ static struct dentry *minix_lookup(struct inode * dir, struct dentry *dentry, st
 
 	ino = minix_inode_by_name(dentry);
 	if (ino) {
-		inode = iget(dir->i_sb, ino);
- 
-		if (!inode)
-			return ERR_PTR(-EACCES);
+		inode = minix_iget(dir->i_sb, ino);
+ 		if (IS_ERR(inode))
+			return ERR_CAST(inode);
 	}
 	d_add(dentry, inode);
 	return NULL;

