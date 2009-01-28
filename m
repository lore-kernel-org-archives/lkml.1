Return-Path: <linux-kernel-owner+w=401wt.eu-S1753527AbZA1STc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbZA1STc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 13:19:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752006AbZA1SSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 13:18:39 -0500
Received: from bohort.kerlabs.com ([62.160.40.57]:52967 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbZA1SSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 13:18:36 -0500
From: Louis Rilling <louis.rilling@kerlabs.com>
To: Joel Becker <Joel.Becker@oracle.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cluster-devel@redhat.com, swhiteho@redhat.com, peterz@infradead.org,
       Louis Rilling <louis.rilling@kerlabs.com>
Subject: [PATCH 2/2] configfs: Rework configfs_depend_item() locking and make lockdep happy
Date: Wed, 28 Jan 2009 19:18:33 +0100
Message-Id: <1233166713-9668-3-git-send-email-louis.rilling@kerlabs.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1233166713-9668-1-git-send-email-louis.rilling@kerlabs.com>
References: <1233166713-9668-1-git-send-email-louis.rilling@kerlabs.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

configfs_depend_item() recursively locks all inodes mutex from configfs root to
the target item, which makes lockdep unhappy. The purpose of this recursive
locking is to ensure that the item tree can be safely parsed and that the target
item, if found, is not about to leave.

This patch reworks configfs_depend_item() locking using configfs_dirent_lock.
Since configfs_dirent_lock protects all changes to the configfs_dirent tree, and
protects tagging of items to be removed, this lock can be used instead of the
inodes mutex lock chain.
This needs that the check for dependents be done atomically with
CONFIGFS_USET_DROPPING tagging.

Now lockdep looks happy with configfs.

Changelog:
- added the following note to explain why configfs_depend_prep() is correct
  when examining attaching items:
+ * Note: items in the middle of attachment start with s_type = 0
+ * (configfs_new_dirent()), and configfs_make_dirent() (called from
+ * create_dir()) sets s_type = CONFIGFS_DIR|CONFIGFS_USET_CREATING. In both
+ * cases the item is ignored. Since s_type is an int, we rely on the CPU to
+ * atomically update the value, without making configfs_make_dirent() take
+ * configfs_dirent_lock.

- fixed parenthesis on pattern !a & b && c --> !(a & b) && c
- quiet checkpatch

Signed-off-by: Louis Rilling <louis.rilling@kerlabs.com>
---
 fs/configfs/dir.c |   98 ++++++++++++++++++++++++-----------------------------
 1 files changed, 44 insertions(+), 54 deletions(-)

diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index 836596b..2739514 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -1006,11 +1006,11 @@ static int configfs_dump(struct configfs_dirent *sd, int level)
  * Note, btw, that this can be called at *any* time, even when a configfs
  * subsystem isn't registered, or when configfs is loading or unloading.
  * Just like configfs_register_subsystem().  So we take the same
- * precautions.  We pin the filesystem.  We lock each i_mutex _in_order_
- * on our way down the tree.  If we can find the target item in the
+ * precautions.  We pin the filesystem.  We lock configfs_dirent_lock.
+ * If we can find the target item in the
  * configfs tree, it must be part of the subsystem tree as well, so we
- * do not need the subsystem semaphore.  Holding the i_mutex chain locks
- * out mkdir() and rmdir(), who might be racing us.
+ * do not need the subsystem semaphore.  Holding configfs_dirent_lock helps
+ * locking out mkdir() and rmdir(), who might be racing us.
  */
 
 /*
@@ -1023,17 +1023,23 @@ static int configfs_dump(struct configfs_dirent *sd, int level)
  * do that so we can unlock it if we find nothing.
  *
  * Here we do a depth-first search of the dentry hierarchy looking for
- * our object.  We take i_mutex on each step of the way down.  IT IS
- * ESSENTIAL THAT i_mutex LOCKING IS ORDERED.  If we come back up a branch,
- * we'll drop the i_mutex.
+ * our object.
+ * We deliberately ignore items tagged as dropping since they are virtually
+ * dead, as well as items in the middle of attachment since they virtually
+ * do not exist yet. This completes the locking out of racing mkdir() and
+ * rmdir().
+ * Note: items in the middle of attachment start with s_type = 0
+ * (configfs_new_dirent()), and configfs_make_dirent() (called from
+ * create_dir()) sets s_type = CONFIGFS_DIR|CONFIGFS_USET_CREATING. In both
+ * cases the item is ignored. Since s_type is an int, we rely on the CPU to
+ * atomically update the value, without making configfs_make_dirent() take
+ * configfs_dirent_lock.
  *
- * If the target is not found, -ENOENT is bubbled up and we have released
- * all locks.  If the target was found, the locks will be cleared by
- * configfs_depend_rollback().
+ * If the target is not found, -ENOENT is bubbled up.
  *
  * This adds a requirement that all config_items be unique!
  *
- * This is recursive because the locking traversal is tricky.  There isn't
+ * This is recursive.  There isn't
  * much on the stack, though, so folks that need this function - be careful
  * about your stack!  Patches will be accepted to make it iterative.
  */
@@ -1045,13 +1051,13 @@ static int configfs_depend_prep(struct dentry *origin,
 
 	BUG_ON(!origin || !sd);
 
-	/* Lock this guy on the way down */
-	mutex_lock(&sd->s_dentry->d_inode->i_mutex);
 	if (sd->s_element == target)  /* Boo-yah */
 		goto out;
 
 	list_for_each_entry(child_sd, &sd->s_children, s_sibling) {
-		if (child_sd->s_type & CONFIGFS_DIR) {
+		if ((child_sd->s_type & CONFIGFS_DIR) &&
+		    !(child_sd->s_type & CONFIGFS_USET_DROPPING) &&
+		    !(child_sd->s_type & CONFIGFS_USET_CREATING)) {
 			ret = configfs_depend_prep(child_sd->s_dentry,
 						   target);
 			if (!ret)
@@ -1060,33 +1066,12 @@ static int configfs_depend_prep(struct dentry *origin,
 	}
 
 	/* We looped all our children and didn't find target */
-	mutex_unlock(&sd->s_dentry->d_inode->i_mutex);
 	ret = -ENOENT;
 
 out:
 	return ret;
 }
 
-/*
- * This is ONLY called if configfs_depend_prep() did its job.  So we can
- * trust the entire path from item back up to origin.
- *
- * We walk backwards from item, unlocking each i_mutex.  We finish by
- * unlocking origin.
- */
-static void configfs_depend_rollback(struct dentry *origin,
-				     struct config_item *item)
-{
-	struct dentry *dentry = item->ci_dentry;
-
-	while (dentry != origin) {
-		mutex_unlock(&dentry->d_inode->i_mutex);
-		dentry = dentry->d_parent;
-	}
-
-	mutex_unlock(&origin->d_inode->i_mutex);
-}
-
 int configfs_depend_item(struct configfs_subsystem *subsys,
 			 struct config_item *target)
 {
@@ -1127,17 +1112,21 @@ int configfs_depend_item(struct configfs_subsystem *subsys,
 
 	/* Ok, now we can trust subsys/s_item */
 
-	/* Scan the tree, locking i_mutex recursively, return 0 if found */
+	spin_lock(&configfs_dirent_lock);
+	/* Scan the tree, return 0 if found */
 	ret = configfs_depend_prep(subsys_sd->s_dentry, target);
 	if (ret)
-		goto out_unlock_fs;
+		goto out_unlock_dirent_lock;
 
-	/* We hold all i_mutexes from the subsystem down to the target */
+	/*
+	 * We are sure that the item is not about to be removed by rmdir(), and
+	 * not in the middle of attachment by mkdir().
+	 */
 	p = target->ci_dentry->d_fsdata;
 	p->s_dependent_count += 1;
 
-	configfs_depend_rollback(subsys_sd->s_dentry, target);
-
+out_unlock_dirent_lock:
+	spin_unlock(&configfs_dirent_lock);
 out_unlock_fs:
 	mutex_unlock(&configfs_sb->s_root->d_inode->i_mutex);
 
@@ -1162,10 +1151,10 @@ void configfs_undepend_item(struct configfs_subsystem *subsys,
 	struct configfs_dirent *sd;
 
 	/*
-	 * Since we can trust everything is pinned, we just need i_mutex
-	 * on the item.
+	 * Since we can trust everything is pinned, we just need
+	 * configfs_dirent_lock.
 	 */
-	mutex_lock(&target->ci_dentry->d_inode->i_mutex);
+	spin_lock(&configfs_dirent_lock);
 
 	sd = target->ci_dentry->d_fsdata;
 	BUG_ON(sd->s_dependent_count < 1);
@@ -1176,7 +1165,7 @@ void configfs_undepend_item(struct configfs_subsystem *subsys,
 	 * After this unlock, we cannot trust the item to stay alive!
 	 * DO NOT REFERENCE item after this unlock.
 	 */
-	mutex_unlock(&target->ci_dentry->d_inode->i_mutex);
+	spin_unlock(&configfs_dirent_lock);
 }
 EXPORT_SYMBOL(configfs_undepend_item);
 
@@ -1376,13 +1365,6 @@ static int configfs_rmdir(struct inode *dir, struct dentry *dentry)
 	if (sd->s_type & CONFIGFS_USET_DEFAULT)
 		return -EPERM;
 
-	/*
-	 * Here's where we check for dependents.  We're protected by
-	 * i_mutex.
-	 */
-	if (sd->s_dependent_count)
-		return -EBUSY;
-
 	/* Get a working ref until we have the child */
 	parent_item = configfs_get_config_item(dentry->d_parent);
 	subsys = to_config_group(parent_item)->cg_subsys;
@@ -1406,9 +1388,17 @@ static int configfs_rmdir(struct inode *dir, struct dentry *dentry)
 
 		mutex_lock(&configfs_symlink_mutex);
 		spin_lock(&configfs_dirent_lock);
-		ret = configfs_detach_prep(dentry, &wait_mutex);
-		if (ret)
-			configfs_detach_rollback(dentry);
+		/*
+		 * Here's where we check for dependents.  We're protected by
+		 * configfs_dirent_lock.
+		 * If no dependent, atomically tag the item as dropping.
+		 */
+		ret = sd->s_dependent_count ? -EBUSY : 0;
+		if (!ret) {
+			ret = configfs_detach_prep(dentry, &wait_mutex);
+			if (ret)
+				configfs_detach_rollback(dentry);
+		}
 		spin_unlock(&configfs_dirent_lock);
 		mutex_unlock(&configfs_symlink_mutex);
 
-- 
1.5.6.5

