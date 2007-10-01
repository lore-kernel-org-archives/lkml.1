Return-Path: <linux-kernel-owner+w=401wt.eu-S1756862AbXJANRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862AbXJANRj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 09:17:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754244AbXJANLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 09:11:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43419 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753772AbXJANLQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 09:11:16 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 20/30] IGET: Stop JFS from using iget() and read_inode()
To: hch@infradead.org, viro@ftp.linux.org.uk, torvalds@osdl.org, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       dhowells@redhat.com
Date: Mon, 01 Oct 2007 14:11:04 +0100
Message-ID: <20071001131104.29339.78301.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071001130921.29339.72876.stgit@warthog.procyon.org.uk>
References: <20071001130921.29339.72876.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stop the JFS filesystem from using iget() and read_inode().  Replace
jfs_read_inode() with jfs_iget(), and call that instead of iget().
jfs_iget() then uses iget_locked() directly and returns a proper error code
instead of an inode in the event of an error.

jfs_fill_super() returns any error incurred when getting the root inode
instead of EINVAL.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/jfs/inode.c     |   20 ++++++++++++++++----
 fs/jfs/jfs_inode.h |    2 +-
 fs/jfs/namei.c     |   34 ++++++++++++++--------------------
 fs/jfs/super.c     |   15 +++++++++------
 4 files changed, 40 insertions(+), 31 deletions(-)

diff --git a/fs/jfs/inode.c b/fs/jfs/inode.c
index 3467dde..5081e76 100644
--- a/fs/jfs/inode.c
+++ b/fs/jfs/inode.c
@@ -31,11 +31,21 @@
 #include "jfs_debug.h"
 
 
-void jfs_read_inode(struct inode *inode)
+struct inode *jfs_iget(struct super_block *sb, unsigned long ino)
 {
-	if (diRead(inode)) {
-		make_bad_inode(inode);
-		return;
+	struct inode *inode;
+	int ret;
+
+	inode = iget_locked(sb, ino);
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+	if (!(inode->i_state & I_NEW))
+		return inode;
+
+	ret = diRead(inode);
+	if (ret < 0) {
+		iget_failed(inode);
+		return ERR_PTR(ret);
 	}
 
 	if (S_ISREG(inode->i_mode)) {
@@ -55,6 +65,8 @@ void jfs_read_inode(struct inode *inode)
 		inode->i_op = &jfs_file_inode_operations;
 		init_special_inode(inode, inode->i_mode, inode->i_rdev);
 	}
+	unlock_new_inode(inode);
+	return inode;
 }
 
 /*
diff --git a/fs/jfs/jfs_inode.h b/fs/jfs/jfs_inode.h
index f0ec72b..71ea106 100644
--- a/fs/jfs/jfs_inode.h
+++ b/fs/jfs/jfs_inode.h
@@ -22,7 +22,7 @@ extern struct inode *ialloc(struct inode *, umode_t);
 extern int jfs_fsync(struct file *, struct dentry *, int);
 extern int jfs_ioctl(struct inode *, struct file *,
 			unsigned int, unsigned long);
-extern void jfs_read_inode(struct inode *);
+extern struct inode *jfs_iget(struct super_block *, unsigned long);
 extern int jfs_commit_inode(struct inode *, int);
 extern int jfs_write_inode(struct inode*, int);
 extern void jfs_delete_inode(struct inode *);
diff --git a/fs/jfs/namei.c b/fs/jfs/namei.c
index 932797b..c436c8a 100644
--- a/fs/jfs/namei.c
+++ b/fs/jfs/namei.c
@@ -1461,12 +1461,10 @@ static struct dentry *jfs_lookup(struct inode *dip, struct dentry *dentry, struc
 		}
 	}
 
-	ip = iget(dip->i_sb, inum);
-	if (ip == NULL || is_bad_inode(ip)) {
+	ip = jfs_iget(dip->i_sb, inum);
+	if (IS_ERR(ip)) {
 		jfs_err("jfs_lookup: iget failed on inum %d", (uint) inum);
-		if (ip)
-			iput(ip);
-		return ERR_PTR(-EACCES);
+		return ERR_PTR(PTR_ERR(ip));
 	}
 
 	dentry = d_splice_alias(ip, dentry);
@@ -1487,12 +1485,11 @@ struct dentry *jfs_get_dentry(struct super_block *sb, void *vobjp)
 
 	if (ino == 0)
 		return ERR_PTR(-ESTALE);
-	inode = iget(sb, ino);
-	if (inode == NULL)
-		return ERR_PTR(-ENOMEM);
+	inode = jfs_iget(sb, ino);
+	if (IS_ERR(inode))
+		return ERR_PTR(PTR_ERR(inode));
 
-	if (is_bad_inode(inode) ||
-	    (generation && inode->i_generation != generation)) {
+	if (generation && inode->i_generation != generation) {
 	    	result = ERR_PTR(-ESTALE);
 		goto out_iput;
 	}
@@ -1518,17 +1515,14 @@ struct dentry *jfs_get_parent(struct dentry *dentry)
 
 	parent_ino =
 		le32_to_cpu(JFS_IP(dentry->d_inode)->i_dtroot.header.idotdot);
-	inode = iget(sb, parent_ino);
-	if (inode) {
-		if (is_bad_inode(inode)) {
+	inode = jfs_iget(sb, parent_ino);
+	if (IS_ERR(inode)) {
+		parent = ERR_PTR(PTR_ERR(inode));
+	} else {
+		parent = d_alloc_anon(inode);
+		if (!parent) {
+			parent = ERR_PTR(-ENOMEM);
 			iput(inode);
-			parent = ERR_PTR(-EACCES);
-		} else {
-			parent = d_alloc_anon(inode);
-			if (!parent) {
-				parent = ERR_PTR(-ENOMEM);
-				iput(inode);
-			}
 		}
 	}
 
diff --git a/fs/jfs/super.c b/fs/jfs/super.c
index 4b372f5..f499634 100644
--- a/fs/jfs/super.c
+++ b/fs/jfs/super.c
@@ -414,7 +414,7 @@ static int jfs_fill_super(struct super_block *sb, void *data, int silent)
 	struct inode *inode;
 	int rc;
 	s64 newLVSize = 0;
-	int flag;
+	int flag, ret = -EINVAL;
 
 	jfs_info("In jfs_read_super: s_flags=0x%lx", sb->s_flags);
 
@@ -461,8 +461,10 @@ static int jfs_fill_super(struct super_block *sb, void *data, int silent)
 	 * Initialize direct-mapping inode/address-space
 	 */
 	inode = new_inode(sb);
-	if (inode == NULL)
+	if (inode == NULL) {
+		ret = -ENOMEM;
 		goto out_kfree;
+	}
 	inode->i_ino = 0;
 	inode->i_nlink = 1;
 	inode->i_size = sb->s_bdev->bd_inode->i_size;
@@ -494,9 +496,11 @@ static int jfs_fill_super(struct super_block *sb, void *data, int silent)
 
 	sb->s_magic = JFS_SUPER_MAGIC;
 
-	inode = iget(sb, ROOT_I);
-	if (!inode || is_bad_inode(inode))
+	inode = jfs_iget(sb, ROOT_I);
+	if (IS_ERR(inode)) {
+		ret = PTR_ERR(inode);
 		goto out_no_root;
+	}
 	sb->s_root = d_alloc_root(inode);
 	if (!sb->s_root)
 		goto out_no_root;
@@ -536,7 +540,7 @@ out_kfree:
 	if (sbi->nls_tab)
 		unload_nls(sbi->nls_tab);
 	kfree(sbi);
-	return -EINVAL;
+	return ret;
 }
 
 static void jfs_write_super_lockfs(struct super_block *sb)
@@ -720,7 +724,6 @@ out:
 static const struct super_operations jfs_super_operations = {
 	.alloc_inode	= jfs_alloc_inode,
 	.destroy_inode	= jfs_destroy_inode,
-	.read_inode	= jfs_read_inode,
 	.dirty_inode	= jfs_dirty_inode,
 	.write_inode	= jfs_write_inode,
 	.delete_inode	= jfs_delete_inode,

