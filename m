Return-Path: <linux-kernel-owner+w=401wt.eu-S1757786AbXJJVsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757786AbXJJVsN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 17:48:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757363AbXJJVoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 17:44:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38430 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757017AbXJJVoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 17:44:15 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 11/31] IGET: Stop EFS from using iget() and read_inode() [try
	#3]
To: hch@infradead.org, viro@ftp.linux.org.uk, torvalds@osdl.org, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       dhowells@redhat.com
Date: Wed, 10 Oct 2007 22:44:04 +0100
Message-ID: <20071010214404.17535.10872.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071010214308.17535.5406.stgit@warthog.procyon.org.uk>
References: <20071010214308.17535.5406.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stop the EFS filesystem from using iget() and read_inode().  Replace
efs_read_inode() with efs_iget(), and call that instead of iget().
efs_iget() then uses iget_locked() directly and returns a proper error code
instead of an inode in the event of an error.

efs_fill_super() returns any error incurred when getting the root inode
instead of EACCES.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/efs/inode.c         |   25 +++++++++++++++++--------
 fs/efs/namei.c         |   23 ++++++++++++-----------
 fs/efs/super.c         |   18 ++++++++++++------
 include/linux/efs_fs.h |    2 +-
 4 files changed, 42 insertions(+), 26 deletions(-)

diff --git a/fs/efs/inode.c b/fs/efs/inode.c
index 174696f..627c302 100644
--- a/fs/efs/inode.c
+++ b/fs/efs/inode.c
@@ -45,17 +45,26 @@ static inline void extent_copy(efs_extent *src, efs_extent *dst) {
 	return;
 }
 
-void efs_read_inode(struct inode *inode)
+struct inode *efs_iget(struct super_block *super, unsigned long ino)
 {
 	int i, inode_index;
 	dev_t device;
 	u32 rdev;
 	struct buffer_head *bh;
-	struct efs_sb_info    *sb = SUPER_INFO(inode->i_sb);
-	struct efs_inode_info *in = INODE_INFO(inode);
+	struct efs_sb_info    *sb = SUPER_INFO(super);
+	struct efs_inode_info *in;
 	efs_block_t block, offset;
 	struct efs_dinode *efs_inode;
-  
+	struct inode *inode;
+
+	inode = iget_locked(super, ino);
+	if (IS_ERR(inode))
+		return ERR_PTR(-ENOMEM);
+	if (!(inode->i_state & I_NEW))
+		return inode;
+
+	in = INODE_INFO(inode);
+
 	/*
 	** EFS layout:
 	**
@@ -159,13 +168,13 @@ void efs_read_inode(struct inode *inode)
 			break;
 	}
 
-	return;
+	unlock_new_inode(inode);
+	return inode;
         
 read_inode_error:
 	printk(KERN_WARNING "EFS: failed to read inode %lu\n", inode->i_ino);
-	make_bad_inode(inode);
-
-	return;
+	iget_failed(inode);
+	return ERR_PTR(-EIO);
 }
 
 static inline efs_block_t
diff --git a/fs/efs/namei.c b/fs/efs/namei.c
index 5276b19..77d7106 100644
--- a/fs/efs/namei.c
+++ b/fs/efs/namei.c
@@ -64,9 +64,10 @@ struct dentry *efs_lookup(struct inode *dir, struct dentry *dentry, struct namei
 	lock_kernel();
 	inodenum = efs_find_entry(dir, dentry->d_name.name, dentry->d_name.len);
 	if (inodenum) {
-		if (!(inode = iget(dir->i_sb, inodenum))) {
+		inode = efs_iget(dir->i_sb, inodenum);
+		if (IS_ERR(inode)) {
 			unlock_kernel();
-			return ERR_PTR(-EACCES);
+			return ERR_CAST(inode);
 		}
 	}
 	unlock_kernel();
@@ -85,12 +86,11 @@ struct dentry *efs_get_dentry(struct super_block *sb, void *vobjp)
 
 	if (ino == 0)
 		return ERR_PTR(-ESTALE);
-	inode = iget(sb, ino);
-	if (inode == NULL)
-		return ERR_PTR(-ENOMEM);
+	inode = efs_iget(sb, ino);
+	if (IS_ERR(inode))
+		return ERR_CAST(inode);
 
-	if (is_bad_inode(inode) ||
-	    (generation && inode->i_generation != generation)) {
+	if (generation && inode->i_generation != generation) {
 	    	result = ERR_PTR(-ESTALE);
 		goto out_iput;
 	}
@@ -112,7 +112,7 @@ struct dentry *efs_get_parent(struct dentry *child)
 	struct dentry *parent;
 	struct inode *inode;
 	efs_ino_t ino;
-	int error;
+	long error;
 
 	lock_kernel();
 
@@ -121,10 +121,11 @@ struct dentry *efs_get_parent(struct dentry *child)
 	if (!ino)
 		goto fail;
 
-	error = -EACCES;
-	inode = iget(child->d_inode->i_sb, ino);
-	if (!inode)
+	inode = efs_iget(child->d_inode->i_sb, ino);
+	if (IS_ERR(inode)) {
+		error = PTR_ERR(inode);
 		goto fail;
+	}
 
 	error = -ENOMEM;
 	parent = d_alloc_anon(inode);
diff --git a/fs/efs/super.c b/fs/efs/super.c
index ce4acb8..685279d 100644
--- a/fs/efs/super.c
+++ b/fs/efs/super.c
@@ -107,7 +107,6 @@ static int efs_remount(struct super_block *sb, int *flags, char *data)
 static const struct super_operations efs_superblock_operations = {
 	.alloc_inode	= efs_alloc_inode,
 	.destroy_inode	= efs_destroy_inode,
-	.read_inode	= efs_read_inode,
 	.put_super	= efs_put_super,
 	.statfs		= efs_statfs,
 	.remount_fs	= efs_remount,
@@ -246,6 +245,7 @@ static int efs_fill_super(struct super_block *s, void *d, int silent)
 	struct efs_sb_info *sb;
 	struct buffer_head *bh;
 	struct inode *root;
+	int ret = -EINVAL;
 
  	sb = kzalloc(sizeof(struct efs_sb_info), GFP_KERNEL);
 	if (!sb)
@@ -302,12 +302,18 @@ static int efs_fill_super(struct super_block *s, void *d, int silent)
 	}
 	s->s_op   = &efs_superblock_operations;
 	s->s_export_op = &efs_export_ops;
-	root = iget(s, EFS_ROOTINODE);
-	s->s_root = d_alloc_root(root);
- 
-	if (!(s->s_root)) {
+	root = efs_iget(s, EFS_ROOTINODE);
+	if (IS_ERR(root)) {
 		printk(KERN_ERR "EFS: get root inode failed\n");
+		ret = PTR_ERR(root);
+		goto out_no_fs;
+	}
+
+	s->s_root = d_alloc_root(root); 
+	if (!(s->s_root)) {
+		printk(KERN_ERR "EFS: get root dentry failed\n");
 		iput(root);
+		ret = -ENOMEM;
 		goto out_no_fs;
 	}
 
@@ -317,7 +323,7 @@ out_no_fs_ul:
 out_no_fs:
 	s->s_fs_info = NULL;
 	kfree(sb);
-	return -EINVAL;
+	return ret;
 }
 
 static int efs_statfs(struct dentry *dentry, struct kstatfs *buf) {
diff --git a/include/linux/efs_fs.h b/include/linux/efs_fs.h
index 16cb25c..18b725f 100644
--- a/include/linux/efs_fs.h
+++ b/include/linux/efs_fs.h
@@ -40,7 +40,7 @@ extern const struct inode_operations efs_dir_inode_operations;
 extern const struct file_operations efs_dir_operations;
 extern const struct address_space_operations efs_symlink_aops;
 
-extern void efs_read_inode(struct inode *);
+extern struct inode *efs_iget(struct super_block *, unsigned long);
 extern efs_block_t efs_map_block(struct inode *, efs_block_t);
 extern int efs_get_block(struct inode *, sector_t, struct buffer_head *, int);
 

