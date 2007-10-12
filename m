Return-Path: <linux-kernel-owner+w=401wt.eu-S932520AbXJLQJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932520AbXJLQJk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:09:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759888AbXJLQGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:06:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43745 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760212AbXJLQGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:06:07 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 08/52] CRED: Pass credentials down to ext2 inode allocator
To: viro@ftp.linux.org.uk
Cc: kwc@citi.umich.edu, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Fri, 12 Oct 2007 17:06:00 +0100
Message-ID: <20071012160600.15119.80980.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
References: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pass credentials down to the ext2 inode allocator.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/ext2/ext2.h   |    2 +-
 fs/ext2/ialloc.c |    6 +++---
 fs/ext2/namei.c  |   12 ++++++++----
 3 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
index 47d68aa..e6d3c3d 100644
--- a/fs/ext2/ext2.h
+++ b/fs/ext2/ext2.h
@@ -116,7 +116,7 @@ extern void ext2_set_link(struct inode *, struct ext2_dir_entry_2 *, struct page
 extern int ext2_sync_file (struct file *, struct dentry *, int);
 
 /* ialloc.c */
-extern struct inode * ext2_new_inode (struct inode *, int);
+extern struct inode * ext2_new_inode (struct inode *, int, struct cred *);
 extern void ext2_free_inode (struct inode *);
 extern unsigned long ext2_count_free_inodes (struct super_block *);
 extern void ext2_check_inodes_bitmap (struct super_block *);
diff --git a/fs/ext2/ialloc.c b/fs/ext2/ialloc.c
index 03b9287..8775a8e 100644
--- a/fs/ext2/ialloc.c
+++ b/fs/ext2/ialloc.c
@@ -445,7 +445,7 @@ found:
 	return group;
 }
 
-struct inode *ext2_new_inode(struct inode *dir, int mode)
+struct inode *ext2_new_inode(struct inode *dir, int mode, struct cred *cred)
 {
 	struct super_block *sb;
 	struct buffer_head *bitmap_bh = NULL;
@@ -562,7 +562,7 @@ got:
 
 	sb->s_dirt = 1;
 	mark_buffer_dirty(bh2);
-	inode->i_uid = current->cred->uid;
+	inode->i_uid = cred->uid;
 	if (test_opt (sb, GRPID))
 		inode->i_gid = dir->i_gid;
 	else if (dir->i_mode & S_ISGID) {
@@ -570,7 +570,7 @@ got:
 		if (S_ISDIR(mode))
 			mode |= S_ISGID;
 	} else
-		inode->i_gid = current->cred->gid;
+		inode->i_gid = cred->gid;
 	inode->i_mode = mode;
 
 	inode->i_ino = ino;
diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
index 80c97fd..821a2c3 100644
--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -105,7 +105,8 @@ struct dentry *ext2_get_parent(struct dentry *child)
  */
 static int ext2_create (struct inode * dir, struct dentry * dentry, int mode, struct nameidata *nd)
 {
-	struct inode * inode = ext2_new_inode (dir, mode);
+	struct cred *cred = current->cred;
+	struct inode * inode = ext2_new_inode (dir, mode, cred);
 	int err = PTR_ERR(inode);
 	if (!IS_ERR(inode)) {
 		inode->i_op = &ext2_file_inode_operations;
@@ -127,13 +128,14 @@ static int ext2_create (struct inode * dir, struct dentry * dentry, int mode, st
 
 static int ext2_mknod (struct inode * dir, struct dentry *dentry, int mode, dev_t rdev)
 {
+	struct cred *cred = current->cred;
 	struct inode * inode;
 	int err;
 
 	if (!new_valid_dev(rdev))
 		return -EINVAL;
 
-	inode = ext2_new_inode (dir, mode);
+	inode = ext2_new_inode (dir, mode, cred);
 	err = PTR_ERR(inode);
 	if (!IS_ERR(inode)) {
 		init_special_inode(inode, inode->i_mode, rdev);
@@ -149,6 +151,7 @@ static int ext2_mknod (struct inode * dir, struct dentry *dentry, int mode, dev_
 static int ext2_symlink (struct inode * dir, struct dentry * dentry,
 	const char * symname)
 {
+	struct cred *cred = current->cred;
 	struct super_block * sb = dir->i_sb;
 	int err = -ENAMETOOLONG;
 	unsigned l = strlen(symname)+1;
@@ -157,7 +160,7 @@ static int ext2_symlink (struct inode * dir, struct dentry * dentry,
 	if (l > sb->s_blocksize)
 		goto out;
 
-	inode = ext2_new_inode (dir, S_IFLNK | S_IRWXUGO);
+	inode = ext2_new_inode (dir, S_IFLNK | S_IRWXUGO, cred);
 	err = PTR_ERR(inode);
 	if (IS_ERR(inode))
 		goto out;
@@ -207,6 +210,7 @@ static int ext2_link (struct dentry * old_dentry, struct inode * dir,
 
 static int ext2_mkdir(struct inode * dir, struct dentry * dentry, int mode)
 {
+	struct cred *cred = current->cred;
 	struct inode * inode;
 	int err = -EMLINK;
 
@@ -215,7 +219,7 @@ static int ext2_mkdir(struct inode * dir, struct dentry * dentry, int mode)
 
 	inode_inc_link_count(dir);
 
-	inode = ext2_new_inode (dir, S_IFDIR | mode);
+	inode = ext2_new_inode (dir, S_IFDIR | mode, cred);
 	err = PTR_ERR(inode);
 	if (IS_ERR(inode))
 		goto out_dir;

