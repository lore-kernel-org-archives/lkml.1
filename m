Return-Path: <linux-kernel-owner+w=401wt.eu-S1762634AbYFLNo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762634AbYFLNo5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 09:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762051AbYFLNnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 09:43:51 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:54240 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762006AbYFLNns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 09:43:48 -0400
Message-Id: <20080612134204.097928479@kerlabs.com>
References: <20080612133126.335618468@kerlabs.com>
User-Agent: quilt/0.46-1
Date: Thu, 12 Jun 2008 15:31:29 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Joel.Becker@oracle.com
Cc: Louis.Rilling@kerlabs.com, linux-kernel@vger.kernel.org,
       ocfs2-devel@oss.oracle.com
Subject: [PATCH 3/3][BUGFIX] configfs: Fix deadlock with racing rmdir() and rename()
Content-Disposition: inline; filename=configfs-fix-rmdir-vs-rename-deadlock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the deadlock between racing sys_rename() and configfs_rmdir().

The idea is to avoid locking i_mutexes of default groups in
configfs_detach_prep(), and rely instead on the new configfs_dirent_lock to
protect against configfs_dirent's linkage mutations. To ensure that an mkdir()
racing with rmdir() will not create new items in a to-be-removed default group,
we make configfs_new_dirent() check for the CONFIGFS_USET_DROPPING flag right
before linking the new dirent, and return error if the flag is set. This makes
racing mkdir()/symlink()/dir_open() fail in places where errors could already
happen, resp. in (attach_item()|attach_group())/create_link()/new_dirent().

configfs_depend() remains safe since it locks all the path from configfs root,
and is thus mutually exclusive with rmdir().

An advantage of this is that now detach_groups() unconditionnaly takes the
default groups i_mutex, which makes it more consistent with populate_groups().

Signed-off-by: Louis Rilling <Louis.Rilling@kerlabs.com>
---
 fs/configfs/dir.c |   44 ++++++++++++++++++++++++--------------------
 1 file changed, 24 insertions(+), 20 deletions(-)

Index: b/fs/configfs/dir.c
===================================================================
--- a/fs/configfs/dir.c	2008-06-12 13:45:18.000000000 +0200
+++ b/fs/configfs/dir.c	2008-06-12 13:50:10.000000000 +0200
@@ -38,6 +38,9 @@
 DECLARE_RWSEM(configfs_rename_sem);
 /*
  * Protects configfs_dirent traversals against linkage mutations
+ * Protects setting of CONFIGFS_USET_DROPPING: checking the flag
+ * unlocked is not reliable unless in detach_groups called from
+ * rmdir/unregister and from configfs_attach_group
  * Can be used as an alternative to taking the concerned i_mutex
  */
 DEFINE_SPINLOCK(configfs_dirent_lock);
@@ -86,6 +89,11 @@ static struct configfs_dirent *configfs_
 	INIT_LIST_HEAD(&sd->s_links);
 	INIT_LIST_HEAD(&sd->s_children);
 	spin_lock(&configfs_dirent_lock);
+	if (parent_sd->s_type & CONFIGFS_USET_DROPPING) {
+		spin_unlock(&configfs_dirent_lock);
+		kmem_cache_free(configfs_dir_cachep, sd);
+		return ERR_PTR(-ENOENT);
+	}
 	list_add(&sd->s_sibling, &parent_sd->s_children);
 	spin_unlock(&configfs_dirent_lock);
 	sd->s_element = element;
@@ -345,11 +353,11 @@ static struct dentry * configfs_lookup(s
 
 /*
  * Only subdirectories count here.  Files (CONFIGFS_NOT_PINNED) are
- * attributes and are removed by rmdir().  We recurse, taking i_mutex
- * on all children that are candidates for default detach.  If the
- * result is clean, then configfs_detach_group() will handle dropping
- * i_mutex.  If there is an error, the caller will clean up the i_mutex
- * holders via configfs_detach_rollback().
+ * attributes and are removed by rmdir().  We recurse, setting
+ * CONFIGFS_USET_DROPPING on all children that are candidates for
+ * default detach.
+ * If there is an error, the caller will reset the flags via
+ * configfs_detach_rollback().
  */
 static int configfs_detach_prep(struct dentry *dentry)
 {
@@ -366,8 +374,7 @@ static int configfs_detach_prep(struct d
 		if (sd->s_type & CONFIGFS_NOT_PINNED)
 			continue;
 		if (sd->s_type & CONFIGFS_USET_DEFAULT) {
-			mutex_lock(&sd->s_dentry->d_inode->i_mutex);
-			/* Mark that we've taken i_mutex */
+			/* Mark that we're trying to drop the group */
 			sd->s_type |= CONFIGFS_USET_DROPPING;
 
 			/*
@@ -388,7 +395,7 @@ out:
 }
 
 /*
- * Walk the tree, dropping i_mutex wherever CONFIGFS_USET_DROPPING is
+ * Walk the tree, resetting CONFIGFS_USET_DROPPING wherever it was
  * set.
  */
 static void configfs_detach_rollback(struct dentry *dentry)
@@ -399,11 +406,7 @@ static void configfs_detach_rollback(str
 	list_for_each_entry(sd, &parent_sd->s_children, s_sibling) {
 		if (sd->s_type & CONFIGFS_USET_DEFAULT) {
 			configfs_detach_rollback(sd->s_dentry);
-
-			if (sd->s_type & CONFIGFS_USET_DROPPING) {
-				sd->s_type &= ~CONFIGFS_USET_DROPPING;
-				mutex_unlock(&sd->s_dentry->d_inode->i_mutex);
-			}
+			sd->s_type &= ~CONFIGFS_USET_DROPPING;
 		}
 	}
 }
@@ -482,16 +485,12 @@ static void detach_groups(struct config_
 
 		child = sd->s_dentry;
 
+		mutex_lock(&child->d_inode->i_mutex);
+
 		configfs_detach_group(sd->s_element);
 		child->d_inode->i_flags |= S_DEAD;
 
-		/*
-		 * From rmdir/unregister, a configfs_detach_prep() pass
-		 * has taken our i_mutex for us.  Drop it.
-		 * From mkdir/register cleanup, there is no sem held.
-		 */
-		if (sd->s_type & CONFIGFS_USET_DROPPING)
-			mutex_unlock(&child->d_inode->i_mutex);
+		mutex_unlock(&child->d_inode->i_mutex);
 
 		d_delete(child);
 		dput(child);
@@ -1177,12 +1176,15 @@ static int configfs_rmdir(struct inode *
 		return -EINVAL;
 	}
 
+	spin_lock(&configfs_dirent_lock);
 	ret = configfs_detach_prep(dentry);
 	if (ret) {
 		configfs_detach_rollback(dentry);
+		spin_unlock(&configfs_dirent_lock);
 		config_item_put(parent_item);
 		return ret;
 	}
+	spin_unlock(&configfs_dirent_lock);
 
 	/* Get a working ref for the duration of this function */
 	item = configfs_get_config_item(dentry);
@@ -1474,9 +1476,11 @@ void configfs_unregister_subsystem(struc
 	mutex_lock_nested(&configfs_sb->s_root->d_inode->i_mutex,
 			  I_MUTEX_PARENT);
 	mutex_lock_nested(&dentry->d_inode->i_mutex, I_MUTEX_CHILD);
+	spin_lock(&configfs_dirent_lock);
 	if (configfs_detach_prep(dentry)) {
 		printk(KERN_ERR "configfs: Tried to unregister non-empty subsystem!\n");
 	}
+	spin_unlock(&configfs_dirent_lock);
 	configfs_detach_group(&group->cg_item);
 	dentry->d_inode->i_flags |= S_DEAD;
 	mutex_unlock(&dentry->d_inode->i_mutex);

-- 
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

