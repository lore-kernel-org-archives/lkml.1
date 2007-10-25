Return-Path: <linux-kernel-owner+w=401wt.eu-S1762389AbXJYQmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762389AbXJYQmq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 12:42:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753064AbXJYQgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 12:36:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42560 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752415AbXJYQf5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 12:35:57 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 21/31] IGET: Stop JFS from using iget() and read_inode() [try
	#5]
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       dhowells@redhat.com
Date: Thu, 25 Oct 2007 17:35:46 +0100
Message-ID: <20071025163546.5057.38050.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071025163352.5057.59344.stgit@warthog.procyon.org.uk>
References: <20071025163352.5057.59344.stgit@warthog.procyon.org.uk>
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
Acked-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
---

 fs/jfs/inode.c     |   20 ++++++++++++++++----
 fs/jfs/jfs_inode.h |    2 +-
 fs/jfs/namei.c     |   34 ++++++++++++++--------------------
 fs/jfs/super.c     |   15 +++++++++------
 4 files changed, 40 insertions(+), 31 deletions(-)

diff --git a/fs/jfs/inode.c b/fs/jfs/inode.c
index 4672013..2103397 100644
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
index 8e2cf2c..95a6a11 100644
--- a/fs/jfs/jfs_inode.h
+++ b/fs/jfs/jfs_inode.h
@@ -24,7 +24,7 @@ extern struct inode *ialloc(struct inode *, umode_t);
 extern int jfs_fsync(struct file *, struct dentry *, int);
 extern int jfs_ioctl(struct inode *, struct file *,
 			unsigned int, unsigned long);
-extern void jfs_read_inode(struct inode *);
+extern struct inode *jfs_iget(struct super_block *, unsigned long);
 extern int jfs_commit_inode(struct inode *, int);
 extern int jfs_write_inode(struct inode*, int);
 extern void jfs_delete_inode(struct inode *);
diff --git a/fs/jfs/namei.c b/fs/jfs/namei.c
index 4e0a849..4be6939 100644
--- a/fs/jfs/namei.c
+++ b/fs/jfs/namei.c
@@ -1462,12 +1462,10 @@ static struct dentry *jfs_lookup(struct inode *dip, struct dentry *dentry, struc
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
+		return ERR_CAST(ip);
 	}
 
 	dentry = d_splice_alias(ip, dentry);
@@ -1485,12 +1483,11 @@ static struct inode *jfs_nfs_get_inode(struct super_block *sb,
 
 	if (ino == 0)
 		return ERR_PTR(-ESTALE);
-	inode = iget(sb, ino);
-	if (inode == NULL)
-		return ERR_PTR(-ENOMEM);
+	inode = jfs_iget(sb, ino);
+	if (IS_ERR(inode))
+		return ERR_CAST(inode);
 
-	if (is_bad_inode(inode) ||
-	    (generation && inode->i_generation != generation)) {
+	if (generation && inode->i_generation != generation) {
 		iput(inode);
 		return ERR_PTR(-ESTALE);
 	}
@@ -1521,17 +1518,14 @@ struct dentry *jfs_get_parent(struct dentry *dentry)
 
 	parent_ino =
 		le32_to_cpu(JFS_IP(dentry->d_inode)->i_dtroot.header.idotdot);
-	inode = iget(sb, parent_ino);
-	if (inode) {
-		if (is_bad_inode(inode)) {
+	inode = jfs_iget(sb, parent_ino);
+	if (IS_ERR(inode)) {
+		parent = ERR_CAST(inode);
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
index 314bb4f..428b1ca 100644
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

