Return-Path: <linux-kernel-owner+w=401wt.eu-S1762819AbXJYQpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762819AbXJYQpA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 12:45:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756760AbXJYQgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 12:36:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42580 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756295AbXJYQgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 12:36:17 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 26/31] IGET: Stop the SYSV filesystem from using iget() and
	read_inode() [try #5]
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       dhowells@redhat.com
Date: Thu, 25 Oct 2007 17:36:11 +0100
Message-ID: <20071025163611.5057.21644.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071025163352.5057.59344.stgit@warthog.procyon.org.uk>
References: <20071025163352.5057.59344.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stop the SYSV filesystem from using iget() and read_inode().  Replace
sysv_read_inode() with sysv_iget(), and call that instead of iget().
sysv_iget() then uses iget_locked() directly and returns a proper error code
instead of an inode in the event of an error.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/sysv/inode.c |   25 ++++++++++++++++---------
 fs/sysv/namei.c |    6 +++---
 fs/sysv/super.c |    4 ++--
 fs/sysv/sysv.h  |    1 +
 4 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/fs/sysv/inode.c b/fs/sysv/inode.c
index 81ec6c5..c5d60de 100644
--- a/fs/sysv/inode.c
+++ b/fs/sysv/inode.c
@@ -169,20 +169,27 @@ void sysv_set_inode(struct inode *inode, dev_t rdev)
 		init_special_inode(inode, inode->i_mode, rdev);
 }
 
-static void sysv_read_inode(struct inode *inode)
+struct inode *sysv_iget(struct super_block *sb, unsigned int ino)
 {
-	struct super_block * sb = inode->i_sb;
 	struct sysv_sb_info * sbi = SYSV_SB(sb);
 	struct buffer_head * bh;
 	struct sysv_inode * raw_inode;
 	struct sysv_inode_info * si;
-	unsigned int block, ino = inode->i_ino;
+	struct inode *inode;
+	unsigned int block;
 
 	if (!ino || ino > sbi->s_ninodes) {
 		printk("Bad inode number on dev %s: %d is out of range\n",
-		       inode->i_sb->s_id, ino);
-		goto bad_inode;
+		       sb->s_id, ino);
+		return ERR_PTR(-EIO);
 	}
+
+	inode = iget_locked(sb, ino);
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+	if (!(inode->i_state & I_NEW))
+		return inode;
+
 	raw_inode = sysv_raw_inode(sb, ino, &bh);
 	if (!raw_inode) {
 		printk("Major problem: unable to read inode from dev %s\n",
@@ -214,11 +221,12 @@ static void sysv_read_inode(struct inode *inode)
 			       old_decode_dev(fs32_to_cpu(sbi, si->i_data[0])));
 	else
 		sysv_set_inode(inode, 0);
-	return;
+	unlock_new_inode(inode);
+	return inode;
 
 bad_inode:
-	make_bad_inode(inode);
-	return;
+	iget_failed(inode);
+	return ERR_PTR(-EIO);
 }
 
 static struct buffer_head * sysv_update_inode(struct inode * inode)
@@ -328,7 +336,6 @@ static void init_once(struct kmem_cache *cachep, void *p)
 const struct super_operations sysv_sops = {
 	.alloc_inode	= sysv_alloc_inode,
 	.destroy_inode	= sysv_destroy_inode,
-	.read_inode	= sysv_read_inode,
 	.write_inode	= sysv_write_inode,
 	.delete_inode	= sysv_delete_inode,
 	.put_super	= sysv_put_super,
diff --git a/fs/sysv/namei.c b/fs/sysv/namei.c
index 6bd850b..a1f1ef3 100644
--- a/fs/sysv/namei.c
+++ b/fs/sysv/namei.c
@@ -53,9 +53,9 @@ static struct dentry *sysv_lookup(struct inode * dir, struct dentry * dentry, st
 	ino = sysv_inode_by_name(dentry);
 
 	if (ino) {
-		inode = iget(dir->i_sb, ino);
-		if (!inode)
-			return ERR_PTR(-EACCES);
+		inode = sysv_iget(dir->i_sb, ino);
+		if (IS_ERR(inode))
+			return ERR_CAST(inode);
 	}
 	d_add(dentry, inode);
 	return NULL;
diff --git a/fs/sysv/super.c b/fs/sysv/super.c
index 6f9707a..a92d104 100644
--- a/fs/sysv/super.c
+++ b/fs/sysv/super.c
@@ -332,8 +332,8 @@ static int complete_read_super(struct super_block *sb, int silent, int size)
 	sb->s_magic = SYSV_MAGIC_BASE + sbi->s_type;
 	/* set up enough so that it can read an inode */
 	sb->s_op = &sysv_sops;
-	root_inode = iget(sb,SYSV_ROOT_INO);
-	if (!root_inode || is_bad_inode(root_inode)) {
+	root_inode = sysv_iget(sb,SYSV_ROOT_INO);
+	if (IS_ERR(root_inode)) {
 		printk("SysV FS: get root inode failed\n");
 		return 0;
 	}
diff --git a/fs/sysv/sysv.h b/fs/sysv/sysv.h
index 64c03bd..42d51d1 100644
--- a/fs/sysv/sysv.h
+++ b/fs/sysv/sysv.h
@@ -141,6 +141,7 @@ extern int __sysv_write_begin(struct file *file, struct address_space *mapping,
 			struct page **pagep, void **fsdata);
 
 /* inode.c */
+extern struct inode *sysv_iget(struct super_block *, unsigned int);
 extern int sysv_write_inode(struct inode *, int);
 extern int sysv_sync_inode(struct inode *);
 extern int sysv_sync_file(struct file *, struct dentry *, int);

