Return-Path: <linux-kernel-owner+w=401wt.eu-S1758249AbYE2Nzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758249AbYE2Nzr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 09:55:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757213AbYE2Nvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 09:51:32 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46153 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757072AbYE2NvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 09:51:06 -0400
Message-Id: <20080529135015.946555205@szeredi.hu>
References: <20080529134903.615127628@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 29 May 2008 15:49:17 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: jmorris@namei.org, sds@tycho.nsa.gov, eparis@redhat.com,
       casey@schaufler-ca.com, agruen@suse.de, jjohansen@suse.de,
       penguin-kernel@I-love.SAKURA.ne.jp, hch@infradead.org,
       viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org
Subject: [patch 14/15] vfs: more path_permission() conversions
Content-Disposition: inline; filename=path_permission_more.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Use path_permission() instead of dentry_permission() from may_delete()
may_create() and vfs_rename().

dentry_permission() is now only called from lookup_one_len() and
path_permission().

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namei.c |   39 ++++++++++++++++++++++-----------------
 1 file changed, 22 insertions(+), 17 deletions(-)

Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c	2008-05-29 12:20:55.000000000 +0200
+++ linux-2.6/fs/namei.c	2008-05-29 12:20:56.000000000 +0200
@@ -1475,10 +1475,10 @@ static inline int check_sticky(struct in
  * 10. We don't allow removal of NFS sillyrenamed files; it's handled by
  *     nfs_async_unlink().
  */
-static int may_delete(struct dentry *dir_dentry, struct dentry *victim,
+static int may_delete(struct path *dir_path, struct dentry *victim,
 		      int isdir)
 {
-	struct inode *dir = dir_dentry->d_inode;
+	struct inode *dir = dir_path->dentry->d_inode;
 	int error;
 
 	if (!victim->d_inode)
@@ -1487,7 +1487,7 @@ static int may_delete(struct dentry *dir
 	BUG_ON(victim->d_parent->d_inode != dir);
 	audit_inode_child(victim->d_name.name, victim, dir);
 
-	error = dentry_permission(dir_dentry, MAY_DELETE);
+	error = path_permission(dir_path, MAY_DELETE);
 	if (error)
 		return error;
 	if (IS_APPEND(dir))
@@ -1517,13 +1517,13 @@ static int may_delete(struct dentry *dir
  *  3. We should have write and exec permissions on dir
  *  4. We can't do it if dir is immutable (done in permission())
  */
-static inline int may_create(struct dentry *dir_dentry, struct dentry *child)
+static inline int may_create(struct path *dir_path, struct dentry *child)
 {
 	if (child->d_inode)
 		return -EEXIST;
-	if (IS_DEADDIR(dir_dentry->d_inode))
+	if (IS_DEADDIR(dir_path->dentry->d_inode))
 		return -ENOENT;
-	return dentry_permission(dir_dentry, MAY_CREATE);
+	return path_permission(dir_path, MAY_CREATE);
 }
 
 /* 
@@ -1590,7 +1590,7 @@ static int vfs_create(struct path *dir_p
 		      int mode,	struct nameidata *nd)
 {
 	struct inode *dir = dir_path->dentry->d_inode;
-	int error = may_create(dir_path->dentry, dentry);
+	int error = may_create(dir_path, dentry);
 
 	if (error)
 		return error;
@@ -2048,7 +2048,7 @@ static int vfs_mknod(struct path *dir_pa
 		     int mode, dev_t dev)
 {
 	struct inode *dir = dir_path->dentry->d_inode;
-	int error = may_create(dir_path->dentry, dentry);
+	int error = may_create(dir_path, dentry);
 
 	if (error)
 		return error;
@@ -2146,7 +2146,7 @@ asmlinkage long sys_mknod(const char __u
 static int vfs_mkdir(struct path *dir_path, struct dentry *dentry, int mode)
 {
 	struct inode *dir = dir_path->dentry->d_inode;
-	int error = may_create(dir_path->dentry, dentry);
+	int error = may_create(dir_path, dentry);
 
 	if (error)
 		return error;
@@ -2247,7 +2247,7 @@ void dentry_unhash(struct dentry *dentry
 static int vfs_rmdir(struct path *dir_path, struct dentry *dentry)
 {
 	struct inode *dir = dir_path->dentry->d_inode;
-	int error = may_delete(dir_path->dentry, dentry, 1);
+	int error = may_delete(dir_path, dentry, 1);
 
 	if (error)
 		return error;
@@ -2341,7 +2341,7 @@ asmlinkage long sys_rmdir(const char __u
 static int vfs_unlink(struct path *dir_path, struct dentry *dentry)
 {
 	struct inode *dir = dir_path->dentry->d_inode;
-	int error = may_delete(dir_path->dentry, dentry, 0);
+	int error = may_delete(dir_path, dentry, 0);
 
 	if (error)
 		return error;
@@ -2456,7 +2456,7 @@ static int vfs_symlink(struct path *dir_
 		       const char *oldname)
 {
 	struct inode *dir = dir_path->dentry->d_inode;
-	int error = may_create(dir_path->dentry, dentry);
+	int error = may_create(dir_path, dentry);
 
 	if (error)
 		return error;
@@ -2541,7 +2541,7 @@ static int vfs_link(struct dentry *old_d
 	if (!inode)
 		return -ENOENT;
 
-	error = may_create(new_dir_path->dentry, new_dentry);
+	error = may_create(new_dir_path, new_dentry);
 	if (error)
 		return error;
 
@@ -2741,14 +2741,14 @@ static int vfs_rename(struct path *old_d
 	if (old_dentry->d_inode == new_dentry->d_inode)
  		return 0;
  
-	error = may_delete(old_dir_path->dentry, old_dentry, is_dir);
+	error = may_delete(old_dir_path, old_dentry, is_dir);
 	if (error)
 		return error;
 
 	if (!new_dentry->d_inode)
-		error = may_create(new_dir_path->dentry, new_dentry);
+		error = may_create(new_dir_path, new_dentry);
 	else
-		error = may_delete(new_dir_path->dentry, new_dentry, is_dir);
+		error = may_delete(new_dir_path, new_dentry, is_dir);
 	if (error)
 		return error;
 
@@ -2760,7 +2760,12 @@ static int vfs_rename(struct path *old_d
 	 * we'll need to flip '..'.
 	 */
 	if (is_dir && new_dir != old_dir) {
-		error = dentry_permission(old_dentry, MAY_MOVE_DIR);
+		struct path old_path = {
+			.mnt = old_dir_path->mnt,
+			.dentry = old_dentry,
+		};
+
+		error = path_permission(&old_path, MAY_MOVE_DIR);
 		if (error)
 			return error;
 	}

--
