Return-Path: <linux-kernel-owner+w=401wt.eu-S1755996AbYG2SNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996AbYG2SNX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 14:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750885AbYG2SNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 14:13:13 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:48366 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbYG2SNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 14:13:12 -0400
Date: Tue, 29 Jul 2008 19:12:47 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Andrew Morton <akpm@linux-foundation.org>
cc: Erez Zadok <ezk@cs.sunysb.edu>, linux-kernel@vger.kernel.org
Subject: [PATCH -mm] unionfs: build fixes
Message-ID: <Pine.LNX.4.64.0807291907440.13365@blonde.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get unionfs building and working in mmotm with the 2.6.27-rc1 VFS changes:
permission() has been replaced by inode_permission() without nameidata arg;
unionfs_permission() without nameidata arg; vfs_symlink() without mode arg;
LOOKUP_ACCESS no longer defined; and kmem_cache_create() no longer passes
kmem_cachep to the init_once() constructor.

Note: while okay for inclusion in -mm for now, unionfs_permission() mods
will need review and perhaps correction by Erez: without a nameidata arg,
some locking vanishes from unionfs_permission(), and a MNT_NOEXEC check on
its lower_inode; I have not studied the VFS changes enough to tell whether
that amounts to a real issue for unionfs, or just removal of dead code.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Erez Zadok <ezk@cs.sunysb.edu>
---
This should follow git-unionfs.patch
I notice my unionfs-fix-memory-leak.patch
and fsstack-fsstack_copy_inode_size-locking.patch
are currently commented out, yet I don't recall the
mm-commits dispatch rider bringing me a telegram to explain why?

 fs/unionfs/dirhelper.c |    2 +-
 fs/unionfs/inode.c     |   16 +++-------------
 fs/unionfs/lookup.c    |    5 +----
 fs/unionfs/sioq.c      |    2 +-
 fs/unionfs/super.c     |    2 +-
 5 files changed, 7 insertions(+), 20 deletions(-)

--- mmotm.orig/fs/unionfs/dirhelper.c	2008-07-29 17:47:09.000000000 +0100
+++ mmotm/fs/unionfs/dirhelper.c	2008-07-29 18:26:12.000000000 +0100
@@ -110,7 +110,7 @@ int delete_whiteouts(struct dentry *dent
 	lower_dir = lower_dir_dentry->d_inode;
 	BUG_ON(!S_ISDIR(lower_dir->i_mode));
 
-	if (!permission(lower_dir, MAY_WRITE | MAY_EXEC, NULL)) {
+	if (!inode_permission(lower_dir, MAY_WRITE | MAY_EXEC)) {
 		err = do_delete_whiteouts(dentry, bindex, namelist);
 	} else {
 		args.deletewh.namelist = namelist;
--- mmotm.orig/fs/unionfs/inode.c	2008-07-29 18:21:46.000000000 +0100
+++ mmotm/fs/unionfs/inode.c	2008-07-29 18:26:12.000000000 +0100
@@ -462,7 +462,6 @@ static int unionfs_symlink(struct inode 
 	struct dentry *lower_parent_dentry = NULL;
 	char *name = NULL;
 	int valid = 0;
-	umode_t mode;
 
 	unionfs_read_lock(dentry->d_sb, UNIONFS_SMUTEX_CHILD);
 	unionfs_lock_dentry(dentry, UNIONFS_DMUTEX_CHILD);
@@ -497,9 +496,7 @@ static int unionfs_symlink(struct inode 
 		goto out;
 	}
 
-	mode = S_IALLUGO;
-	err = vfs_symlink(lower_parent_dentry->d_inode, lower_dentry,
-			  symname, mode);
+	err = vfs_symlink(lower_parent_dentry->d_inode, lower_dentry, symname);
 	if (!err) {
 		err = PTR_ERR(unionfs_interpose(dentry, parent->i_sb, 0));
 		if (!err) {
@@ -872,8 +869,7 @@ static void unionfs_put_link(struct dent
  * unionfs_permission, or anything it calls, will use stale branch
  * information.
  */
-static int unionfs_permission(struct inode *inode, int mask,
-			      struct nameidata *nd)
+static int unionfs_permission(struct inode *inode, int mask)
 {
 	struct inode *lower_inode = NULL;
 	int err = 0;
@@ -881,9 +877,6 @@ static int unionfs_permission(struct ino
 	const int is_file = !S_ISDIR(inode->i_mode);
 	const int write_mask = (mask & MAY_WRITE) && !(mask & MAY_READ);
 
-	if (nd)
-		unionfs_lock_dentry(nd->path.dentry, UNIONFS_DMUTEX_CHILD);
-
 	if (!UNIONFS_I(inode)->lower_inodes) {
 		if (is_file)	/* dirs can be unlinked but chdir'ed to */
 			err = -ESTALE;	/* force revalidate */
@@ -923,7 +916,7 @@ static int unionfs_permission(struct ino
 		 * readonly, because those conditions should lead to a
 		 * copyup taking place later on.
 		 */
-		err = permission(lower_inode, mask, nd);
+		err = inode_permission(lower_inode, mask);
 		if (err && bindex > 0) {
 			umode_t mode = lower_inode->i_mode;
 			if (is_robranch_super(inode->i_sb, bindex) &&
@@ -955,9 +948,6 @@ static int unionfs_permission(struct ino
 
 out:
 	unionfs_check_inode(inode);
-	unionfs_check_nd(nd);
-	if (nd)
-		unionfs_unlock_dentry(nd->path.dentry);
 	return err;
 }
 
--- mmotm.orig/fs/unionfs/lookup.c	2008-07-29 18:21:46.000000000 +0100
+++ mmotm/fs/unionfs/lookup.c	2008-07-29 18:26:12.000000000 +0100
@@ -47,7 +47,7 @@ static noinline_for_stack int is_opaque_
 
 	mutex_lock(&lower_inode->i_mutex);
 
-	if (!permission(lower_inode, MAY_EXEC, NULL)) {
+	if (!inode_permission(lower_inode, MAY_EXEC)) {
 		wh_lower_dentry =
 			lookup_one_len(UNIONFS_DIR_OPAQUE, lower_dentry,
 				       sizeof(UNIONFS_DIR_OPAQUE) - 1);
@@ -635,9 +635,6 @@ int init_lower_nd(struct nameidata *nd, 
 		nd->intent.open.file = file;
 #endif /* ALLOC_LOWER_ND_FILE */
 		break;
-	case LOOKUP_ACCESS:
-		nd->flags = flags;
-		break;
 	default:
 		/*
 		 * We should never get here, for now.
--- mmotm.orig/fs/unionfs/sioq.c	2008-07-29 18:21:46.000000000 +0100
+++ mmotm/fs/unionfs/sioq.c	2008-07-29 18:26:12.000000000 +0100
@@ -87,7 +87,7 @@ void __unionfs_symlink(struct work_struc
 	struct sioq_args *args = container_of(work, struct sioq_args, work);
 	struct symlink_args *s = &args->symlink;
 
-	args->err = vfs_symlink(s->parent, s->dentry, s->symbuf, s->mode);
+	args->err = vfs_symlink(s->parent, s->dentry, s->symbuf);
 	complete(&args->comp);
 }
 
--- mmotm.orig/fs/unionfs/super.c	2008-07-29 18:21:46.000000000 +0100
+++ mmotm/fs/unionfs/super.c	2008-07-29 18:26:12.000000000 +0100
@@ -904,7 +904,7 @@ static void unionfs_destroy_inode(struct
 }
 
 /* unionfs inode cache constructor */
-static void init_once(struct kmem_cache *cachep, void *obj)
+static void init_once(void *obj)
 {
 	struct unionfs_inode_info *i = obj;
 
