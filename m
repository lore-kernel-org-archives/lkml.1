Return-Path: <linux-kernel-owner+w=401wt.eu-S1761852AbXJDQFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761852AbXJDQFy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 12:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760168AbXJDP6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 11:58:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45711 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759585AbXJDP6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 11:58:31 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 21/32] IGET: Stop JFFS2 from using iget() and read_inode()
	[try #2]
To: hch@infradead.org, viro@ftp.linux.org.uk, torvalds@osdl.org, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       dhowells@redhat.com
Date: Thu, 04 Oct 2007 16:57:49 +0100
Message-ID: <20071004155749.2814.67604.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071004155602.2814.47731.stgit@warthog.procyon.org.uk>
References: <20071004155602.2814.47731.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stop the JFFS2 filesystem from using iget() and read_inode().  Replace
jffs2_read_inode() with jffs2_iget(), and call that instead of iget().
jffs2_iget() then uses iget_locked() directly and returns a proper error code
instead of an inode in the event of an error.

jffs2_do_fill_super() returns any error incurred when getting the root inode
instead of EINVAL.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/jffs2/dir.c      |    6 +++--
 fs/jffs2/fs.c       |   56 ++++++++++++++++++++++++++++++++-------------------
 fs/jffs2/os-linux.h |    2 +-
 fs/jffs2/super.c    |    1 -
 4 files changed, 39 insertions(+), 26 deletions(-)

diff --git a/fs/jffs2/dir.c b/fs/jffs2/dir.c
index c1dfca3..ca0add3 100644
--- a/fs/jffs2/dir.c
+++ b/fs/jffs2/dir.c
@@ -101,10 +101,10 @@ static struct dentry *jffs2_lookup(struct inode *dir_i, struct dentry *target,
 		ino = fd->ino;
 	up(&dir_f->sem);
 	if (ino) {
-		inode = iget(dir_i->i_sb, ino);
-		if (!inode) {
+		inode = jffs2_iget(dir_i->i_sb, ino);
+		if (IS_ERR(inode)) {
 			printk(KERN_WARNING "iget() failed for ino #%u\n", ino);
-			return (ERR_PTR(-EIO));
+			return ERR_CAST(inode);
 		}
 	}
 
diff --git a/fs/jffs2/fs.c b/fs/jffs2/fs.c
index 8bc727b..900be8b 100644
--- a/fs/jffs2/fs.c
+++ b/fs/jffs2/fs.c
@@ -227,16 +227,23 @@ void jffs2_clear_inode (struct inode *inode)
 	jffs2_do_clear_inode(c, f);
 }
 
-void jffs2_read_inode (struct inode *inode)
+struct inode *jffs2_iget(struct super_block *sb, unsigned long ino)
 {
 	struct jffs2_inode_info *f;
 	struct jffs2_sb_info *c;
 	struct jffs2_raw_inode latest_node;
 	union jffs2_device_node jdev;
+	struct inode *inode;
 	dev_t rdev = 0;
 	int ret;
 
-	D1(printk(KERN_DEBUG "jffs2_read_inode(): inode->i_ino == %lu\n", inode->i_ino));
+	D1(printk(KERN_DEBUG "jffs2_iget(): ino == %lu\n", ino));
+
+	inode = iget_locked(sb, ino);
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+	if (!(inode->i_state & I_NEW))
+		return inode;
 
 	f = JFFS2_INODE_INFO(inode);
 	c = JFFS2_SB_INFO(inode->i_sb);
@@ -247,9 +254,9 @@ void jffs2_read_inode (struct inode *inode)
 	ret = jffs2_do_read_inode(c, f, inode->i_ino, &latest_node);
 
 	if (ret) {
-		make_bad_inode(inode);
 		up(&f->sem);
-		return;
+		iget_failed(inode);
+		return ERR_PTR(ret);
 	}
 	inode->i_mode = jemode_to_cpu(latest_node.mode);
 	inode->i_uid = je16_to_cpu(latest_node.uid);
@@ -300,19 +307,14 @@ void jffs2_read_inode (struct inode *inode)
 		if (f->metadata->size != sizeof(jdev.old) &&
 		    f->metadata->size != sizeof(jdev.new)) {
 			printk(KERN_NOTICE "Device node has strange size %d\n", f->metadata->size);
-			up(&f->sem);
-			jffs2_do_clear_inode(c, f);
-			make_bad_inode(inode);
-			return;
+			goto error_io;
 		}
 		D1(printk(KERN_DEBUG "Reading device numbers from flash\n"));
-		if (jffs2_read_dnode(c, f, f->metadata, (char *)&jdev, 0, f->metadata->size) < 0) {
+		ret = jffs2_read_dnode(c, f, f->metadata, (char *)&jdev, 0, f->metadata->size);
+		if (ret < 0) {
 			/* Eep */
 			printk(KERN_NOTICE "Read device numbers for inode %lu failed\n", (unsigned long)inode->i_ino);
-			up(&f->sem);
-			jffs2_do_clear_inode(c, f);
-			make_bad_inode(inode);
-			return;
+			goto error;
 		}
 		if (f->metadata->size == sizeof(jdev.old))
 			rdev = old_decode_dev(je16_to_cpu(jdev.old));
@@ -332,6 +334,16 @@ void jffs2_read_inode (struct inode *inode)
 	up(&f->sem);
 
 	D1(printk(KERN_DEBUG "jffs2_read_inode() returning\n"));
+	unlock_new_inode(inode);
+	return inode;
+
+error_io:
+	ret = -EIO;
+error:
+	up(&f->sem);
+	jffs2_do_clear_inode(c, f);
+	iget_failed(inode);
+	return ERR_PTR(ret);
 }
 
 void jffs2_dirty_inode(struct inode *inode)
@@ -511,15 +523,16 @@ int jffs2_do_fill_super(struct super_block *sb, void *data, int silent)
 	if ((ret = jffs2_do_mount_fs(c)))
 		goto out_inohash;
 
-	ret = -EINVAL;
-
 	D1(printk(KERN_DEBUG "jffs2_do_fill_super(): Getting root inode\n"));
-	root_i = iget(sb, 1);
-	if (is_bad_inode(root_i)) {
+	root_i = jffs2_iget(sb, 1);
+	if (IS_ERR(root_i)) {
 		D1(printk(KERN_WARNING "get root inode failed\n"));
-		goto out_root_i;
+		ret = PTR_ERR(root_i);
+		goto out_root;
 	}
 
+	ret = -ENOMEM;
+
 	D1(printk(KERN_DEBUG "jffs2_do_fill_super(): d_alloc_root()\n"));
 	sb->s_root = d_alloc_root(root_i);
 	if (!sb->s_root)
@@ -535,6 +548,7 @@ int jffs2_do_fill_super(struct super_block *sb, void *data, int silent)
 
  out_root_i:
 	iput(root_i);
+out_root:
 	jffs2_free_ino_caches(c);
 	jffs2_free_raw_node_refs(c);
 	if (jffs2_blocks_use_vmalloc(c))
@@ -604,9 +618,9 @@ struct jffs2_inode_info *jffs2_gc_fetch_inode(struct jffs2_sb_info *c,
 		   jffs2_do_unlink() would need the alloc_sem and we have it.
 		   Just iget() it, and if read_inode() is necessary that's OK.
 		*/
-		inode = iget(OFNI_BS_2SFFJ(c), inum);
-		if (!inode)
-			return ERR_PTR(-ENOMEM);
+		inode = jffs2_iget(OFNI_BS_2SFFJ(c), inum);
+		if (IS_ERR(inode))
+			return ERR_CAST(inode);
 	}
 	if (is_bad_inode(inode)) {
 		printk(KERN_NOTICE "Eep. read_inode() failed for ino #%u. nlink %d\n",
diff --git a/fs/jffs2/os-linux.h b/fs/jffs2/os-linux.h
index 80daea9..c1ca2f9 100644
--- a/fs/jffs2/os-linux.h
+++ b/fs/jffs2/os-linux.h
@@ -174,7 +174,7 @@ extern const struct inode_operations jffs2_symlink_inode_operations;
 
 /* fs.c */
 int jffs2_setattr (struct dentry *, struct iattr *);
-void jffs2_read_inode (struct inode *);
+struct inode *jffs2_iget(struct super_block *, unsigned long);
 void jffs2_clear_inode (struct inode *);
 void jffs2_dirty_inode(struct inode *inode);
 struct inode *jffs2_new_inode (struct inode *dir_i, int mode,
diff --git a/fs/jffs2/super.c b/fs/jffs2/super.c
index be2b70c..d7d2ff6 100644
--- a/fs/jffs2/super.c
+++ b/fs/jffs2/super.c
@@ -65,7 +65,6 @@ static const struct super_operations jffs2_super_operations =
 {
 	.alloc_inode =	jffs2_alloc_inode,
 	.destroy_inode =jffs2_destroy_inode,
-	.read_inode =	jffs2_read_inode,
 	.put_super =	jffs2_put_super,
 	.write_super =	jffs2_write_super,
 	.statfs =	jffs2_statfs,

