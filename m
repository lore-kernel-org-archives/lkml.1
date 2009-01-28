Return-Path: <linux-kernel-owner+w=401wt.eu-S1755223AbZA1SS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223AbZA1SS7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 13:18:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751823AbZA1SSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 13:18:38 -0500
Received: from bohort.kerlabs.com ([62.160.40.57]:36541 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbZA1SSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 13:18:36 -0500
From: Louis Rilling <louis.rilling@kerlabs.com>
To: Joel Becker <Joel.Becker@oracle.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cluster-devel@redhat.com, swhiteho@redhat.com, peterz@infradead.org,
       Louis Rilling <louis.rilling@kerlabs.com>
Subject: [PATCH 1/2] configfs: Silence lockdep on mkdir() and rmdir()
Date: Wed, 28 Jan 2009 19:18:32 +0100
Message-Id: <1233166713-9668-2-git-send-email-louis.rilling@kerlabs.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1233166713-9668-1-git-send-email-louis.rilling@kerlabs.com>
References: <1233166713-9668-1-git-send-email-louis.rilling@kerlabs.com>
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

Changelog:
- put s_depth logic in separate functions and remove #ifdef LOCKDEP in the
  hooked functions.
- quiet checkpatch

Signed-off-by: Louis Rilling <louis.rilling@kerlabs.com>
---
 fs/configfs/configfs_internal.h |    3 +
 fs/configfs/dir.c               |   90 +++++++++++++++++++++++++++++++++++++++
 fs/configfs/inode.c             |   38 ++++++++++++++++
 3 files changed, 131 insertions(+), 0 deletions(-)

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
index 8e93341..836596b 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -78,6 +78,92 @@ static struct dentry_operations configfs_dentry_ops = {
 	.d_delete	= configfs_d_delete,
 };
 
+#ifdef CONFIG_LOCKDEP
+
+/*
+ * Helpers to make lockdep happy with our recursive locking of default groups'
+ * inodes (see configfs_attach_group() and configfs_detach_group()).
+ * We put default groups i_mutexes in separate classes according to their depth
+ * from the youngest non-default group ancestor.
+ *
+ * For a non-default group A having default groups A/B, A/C, and A/C/D, default
+ * groups A/B and A/C will have their inode's mutex in class
+ * default_group_class[0], and default group A/C/D will be in
+ * default_group_class[1].
+ *
+ * The lock classes are declared and assigned in inode.c, according to the
+ * s_depth value.
+ * The s_depth value is initialized to -1, adjusted to >= 0 when attaching
+ * default groups, and reset to -1 when all default groups are attached. During
+ * attachment, if configfs_create() sees s_depth > 0, the lock class of the new
+ * inode's mutex is set to default_group_class[s_depth - 1].
+ */
+
+static void configfs_init_dirent_depth(struct configfs_dirent *sd)
+{
+	sd->s_depth = -1;
+}
+
+static void configfs_set_dir_dirent_depth(struct configfs_dirent *parent_sd,
+					  struct configfs_dirent *sd)
+{
+	int parent_depth = parent_sd->s_depth;
+
+	if (parent_depth >= 0)
+		sd->s_depth = parent_depth + 1;
+}
+
+static void
+configfs_adjust_dir_dirent_depth_before_populate(struct configfs_dirent *sd)
+{
+	/*
+	 * item's i_mutex class is already setup, so s_depth is now only
+	 * used to set new sub-directories s_depth, which is always done
+	 * with item's i_mutex locked.
+	 */
+	/*
+	 *  sd->s_depth == -1 iff we are a non default group.
+	 *  else (we are a default group) sd->s_depth > 0 (see
+	 *  create_dir()).
+	 */
+	if (sd->s_depth == -1)
+		/*
+		 * We are a non default group and we are going to create
+		 * default groups.
+		 */
+		sd->s_depth = 0;
+}
+
+static void
+configfs_adjust_dir_dirent_depth_after_populate(struct configfs_dirent *sd)
+{
+	/* We will not create default groups anymore. */
+	sd->s_depth = -1;
+}
+
+#else /* CONFIG_LOCKDEP */
+
+static void configfs_init_dirent_depth(struct configfs_dirent *sd)
+{
+}
+
+static void configfs_set_dir_dirent_depth(struct configfs_dirent *parent_sd,
+					  struct configfs_dirent *sd)
+{
+}
+
+static void
+configfs_adjust_dir_dirent_depth_before_populate(struct configfs_dirent *sd)
+{
+}
+
+static void
+configfs_adjust_dir_dirent_depth_after_populate(struct configfs_dirent *sd)
+{
+}
+
+#endif /* CONFIG_LOCKDEP */
+
 /*
  * Allocates a new configfs_dirent and links it to the parent configfs_dirent
  */
@@ -94,6 +180,7 @@ static struct configfs_dirent *configfs_new_dirent(struct configfs_dirent * pare
 	INIT_LIST_HEAD(&sd->s_links);
 	INIT_LIST_HEAD(&sd->s_children);
 	sd->s_element = element;
+	configfs_init_dirent_depth(sd);
 	spin_lock(&configfs_dirent_lock);
 	if (parent_sd->s_type & CONFIGFS_USET_DROPPING) {
 		spin_unlock(&configfs_dirent_lock);
@@ -187,6 +274,7 @@ static int create_dir(struct config_item * k, struct dentry * p,
 		error = configfs_make_dirent(p->d_fsdata, d, k, mode,
 					     CONFIGFS_DIR | CONFIGFS_USET_CREATING);
 	if (!error) {
+		configfs_set_dir_dirent_depth(p->d_fsdata, d->d_fsdata);
 		error = configfs_create(d, mode, init_dir);
 		if (!error) {
 			inc_nlink(p->d_inode);
@@ -789,11 +877,13 @@ static int configfs_attach_group(struct config_item *parent_item,
 		 * error, as rmdir() would.
 		 */
 		mutex_lock_nested(&dentry->d_inode->i_mutex, I_MUTEX_CHILD);
+		configfs_adjust_dir_dirent_depth_before_populate(sd);
 		ret = populate_groups(to_config_group(item));
 		if (ret) {
 			configfs_detach_item(item);
 			dentry->d_inode->i_flags |= S_DEAD;
 		}
+		configfs_adjust_dir_dirent_depth_after_populate(sd);
 		mutex_unlock(&dentry->d_inode->i_mutex);
 		if (ret)
 			d_delete(dentry);
diff --git a/fs/configfs/inode.c b/fs/configfs/inode.c
index 5d349d3..4921e74 100644
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
@@ -150,6 +155,38 @@ struct inode * configfs_new_inode(mode_t mode, struct configfs_dirent * sd)
 	return inode;
 }
 
+#ifdef CONFIG_LOCKDEP
+
+static void configfs_set_inode_lock_class(struct configfs_dirent *sd,
+					  struct inode *inode)
+{
+	int depth = sd->s_depth;
+
+	if (depth > 0) {
+		if (depth <= ARRAY_SIZE(default_group_class)) {
+			lockdep_set_class(&inode->i_mutex,
+					  &default_group_class[depth - 1]);
+		} else {
+			/*
+			 * In practice the maximum level of locking depth is
+			 * already reached. Just inform about possible reasons.
+			 */
+			printk(KERN_INFO "configfs: Too many levels of inodes"
+			       " for the locking correctness validator.\n");
+			printk(KERN_INFO "Spurious warnings may appear.\n");
+		}
+	}
+}
+
+#else /* CONFIG_LOCKDEP */
+
+static void configfs_set_inode_lock_class(struct configfs_dirent *sd,
+					  struct inode *inode)
+{
+}
+
+#endif /* CONFIG_LOCKDEP */
+
 int configfs_create(struct dentry * dentry, int mode, int (*init)(struct inode *))
 {
 	int error = 0;
@@ -162,6 +199,7 @@ int configfs_create(struct dentry * dentry, int mode, int (*init)(struct inode *
 					struct inode *p_inode = dentry->d_parent->d_inode;
 					p_inode->i_mtime = p_inode->i_ctime = CURRENT_TIME;
 				}
+				configfs_set_inode_lock_class(sd, inode);
 				goto Proceed;
 			}
 			else
-- 
1.5.6.5

