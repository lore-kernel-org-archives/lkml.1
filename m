Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752362AbYLRSBD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362AbYLRSBD (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 13:01:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbYLRSAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 13:00:23 -0500
Received: from bohort.kerlabs.com ([62.160.40.57]:40654 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412AbYLRSAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 13:00:21 -0500
From: Louis Rilling <louis.rilling@kerlabs.com>
To: Joel Becker <Joel.Becker@oracle.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        cluster-devel@redhat.com, swhiteho@redhat.com, peterz@infradead.org,
        Louis Rilling <louis.rilling@kerlabs.com>
Subject: [PATCH 1/2] configfs: Silence lockdep on mkdir() and rmdir()
Date: Thu, 18 Dec 2008 19:00:17 +0100
Message-Id: <1229623218-8056-2-git-send-email-louis.rilling@kerlabs.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <20081218111536.GR19128@hawkmoon.kerlabs.com>
References: <20081218111536.GR19128@hawkmoon.kerlabs.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When attaching default groups (subdirs) of a new group (in mkdir() or
in configfs_register()), configfs recursively takes inode's mutexes
along the path from the parent of the new group to the default
subdirs. This is needed to ensure that the VFS will not race with
operations on these sub-dirs. This is safe for the following reasons:

- the VFS allows one to lock first an inode and second one of its
  children (The lock subclasses for this pattern are respectively
  I_MUTEX_PARENT and I_MUTEX_CHILD);
- from this rule any inode path can be recursively locked in
  descending order as long as it stays under a single mountpoint and
  does not follow symlinks.

Unfortunately lockdep does not know (yet?) how to handle such
recursion.

I've tried to use Peter Zijlstra's lock_set_subclass() helper to
upgrade i_mutexes from I_MUTEX_CHILD to I_MUTEX_PARENT when we know
that we might recursively lock some of their descendant, but this
usage does not seem to fit the purpose of lock_set_subclass() because
it leads to several i_mutex locked with subclass I_MUTEX_PARENT by
the same task.

>From inside configfs it is not possible to serialize those recursive
locking with a top-level one, because mkdir() and rmdir() are already
called with inodes locked by the VFS. So using some
mutex_lock_nest_lock() is not an option.

I am proposing two solutions:
1) one that wraps recursive mutex_lock()s with
   lockdep_off()/lockdep_on().
2) (as suggested earlier by Peter Zijlstra) one that puts the
   i_mutexes recursively locked in different classes based on their
   depth from the top-level config_group created. This
   induces an arbitrary limit (MAX_LOCK_DEPTH - 2 == 46) on the
   nesting of configfs default groups whenever lockdep is activated
   but this limit looks reasonably high. Unfortunately, this also
   isolates VFS operations on configfs default groups from the others
   and thus lowers the chances to detect locking issues.

Nobody likes solution 1), what I can understand.

This patch implements solution 2). However lockdep is still not happy with
configfs_depend_item(). Next patch reworks the locking of
configfs_depend_item() and finally makes lockdep happy.

Signed-off-by: Louis Rilling <louis.rilling@kerlabs.com>
---
 fs/configfs/configfs_internal.h |    3 +++
 fs/configfs/dir.c               |   39 +++++++++++++++++++++++++++++++++++++++
 fs/configfs/inode.c             |   28 ++++++++++++++++++++++++++++
 3 files changed, 70 insertions(+), 0 deletions(-)

diff --git a/fs/configfs/configfs_internal.h b/fs/configfs/configfs_internal.h
index 762d287..da6061a 100644
--- a/fs/configfs/configfs_internal.h
+++ b/fs/configfs/configfs_internal.h
@@ -39,6 +39,9 @@ struct configfs_dirent {
 	umode_t			s_mode;
 	struct dentry		* s_dentry;
 	struct iattr		* s_iattr;
+#ifdef CONFIG_LOCKDEP
+	int			s_depth;
+#endif
 };
 
 #define CONFIGFS_ROOT		0x0001
diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index 8e93341..f21be74 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -94,6 +94,9 @@ static struct configfs_dirent *configfs_new_dirent(struct configfs_dirent * pare
 	INIT_LIST_HEAD(&sd->s_links);
 	INIT_LIST_HEAD(&sd->s_children);
 	sd->s_element = element;
+#ifdef CONFIG_LOCKDEP
+	sd->s_depth = -1;
+#endif
 	spin_lock(&configfs_dirent_lock);
 	if (parent_sd->s_type & CONFIGFS_USET_DROPPING) {
 		spin_unlock(&configfs_dirent_lock);
@@ -176,6 +179,17 @@ static int init_symlink(struct inode * inode)
 	return 0;
 }
 
+#ifdef CONFIG_LOCKDEP
+static void configfs_set_dir_dirent_depth(struct configfs_dirent *parent_sd,
+					  struct configfs_dirent *sd)
+{
+	int parent_depth = parent_sd->s_depth;
+
+	if (parent_depth >= 0)
+		sd->s_depth = parent_depth + 1;
+}
+#endif
+
 static int create_dir(struct config_item * k, struct dentry * p,
 		      struct dentry * d)
 {
@@ -187,6 +201,9 @@ static int create_dir(struct config_item * k, struct dentry * p,
 		error = configfs_make_dirent(p->d_fsdata, d, k, mode,
 					     CONFIGFS_DIR | CONFIGFS_USET_CREATING);
 	if (!error) {
+#ifdef CONFIG_LOCKDEP
+		configfs_set_dir_dirent_depth(p->d_fsdata, d->d_fsdata);
+#endif
 		error = configfs_create(d, mode, init_dir);
 		if (!error) {
 			inc_nlink(p->d_inode);
@@ -789,11 +806,33 @@ static int configfs_attach_group(struct config_item *parent_item,
 		 * error, as rmdir() would.
 		 */
 		mutex_lock_nested(&dentry->d_inode->i_mutex, I_MUTEX_CHILD);
+#ifdef CONFIG_LOCKDEP
+		/*
+		 * item's i_mutex class is already setup, so s_depth is now only
+		 * used to set new sub-directories s_depth, which is always done
+		 * with item's i_mutex locked.
+		 */
+		/*
+		 *  sd->s_depth == -1 iff we are a non default group.
+		 *  else (we are a default group) sd->s_depth > 0 (see
+		 *  create_dir()).
+		 */
+		if (sd->s_depth == -1)
+			/*
+			 * We are a non default group and we are going to create
+			 * default groups.
+			 */
+			sd->s_depth = 0;
+#endif
 		ret = populate_groups(to_config_group(item));
 		if (ret) {
 			configfs_detach_item(item);
 			dentry->d_inode->i_flags |= S_DEAD;
 		}
+#ifdef CONFIG_LOCKDEP
+		/* We will not create default groups anymore. */
+		sd->s_depth = -1;
+#endif
 		mutex_unlock(&dentry->d_inode->i_mutex);
 		if (ret)
 			d_delete(dentry);
diff --git a/fs/configfs/inode.c b/fs/configfs/inode.c
index 4803ccc..5e66b40 100644
--- a/fs/configfs/inode.c
+++ b/fs/configfs/inode.c
@@ -33,10 +33,15 @@
 #include <linux/backing-dev.h>
 #include <linux/capability.h>
 #include <linux/sched.h>
+#include <linux/lockdep.h>
 
 #include <linux/configfs.h>
 #include "configfs_internal.h"
 
+#ifdef CONFIG_LOCKDEP
+static struct lock_class_key default_group_class[MAX_LOCK_DEPTH];
+#endif
+
 extern struct super_block * configfs_sb;
 
 static const struct address_space_operations configfs_aops = {
@@ -153,6 +158,26 @@ struct inode * configfs_new_inode(mode_t mode, struct configfs_dirent * sd)
 	return inode;
 }
 
+#ifdef CONFIG_LOCKDEP
+static void configfs_set_inode_lock_class(struct configfs_dirent *sd,
+					  struct inode *inode)
+{
+	if (sd->s_depth > 0) {
+		if (sd->s_depth <= ARRAY_SIZE(default_group_class)) {
+			lockdep_set_class(&inode->i_mutex,
+					  &default_group_class[sd->s_depth - 1]);
+		} else {
+			/*
+			 * In practice the maximum level of locking depth is
+			 * already reached. Just inform about possible reasons.
+			 */
+			printk("configfs: Too many levels of inodes for the locking correctness validator.\n");
+			printk("Spurious warnings may appear.\n"); 
+		}
+	}
+}
+#endif
+
 int configfs_create(struct dentry * dentry, int mode, int (*init)(struct inode *))
 {
 	int error = 0;
@@ -165,6 +190,9 @@ int configfs_create(struct dentry * dentry, int mode, int (*init)(struct inode *
 					struct inode *p_inode = dentry->d_parent->d_inode;
 					p_inode->i_mtime = p_inode->i_ctime = CURRENT_TIME;
 				}
+#ifdef CONFIG_LOCKDEP
+				configfs_set_inode_lock_class(sd, inode);
+#endif
 				goto Proceed;
 			}
 			else
-- 
1.5.6.5

