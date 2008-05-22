Return-Path: <linux-kernel-owner+w=401wt.eu-S935119AbYEVLxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935119AbYEVLxz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 07:53:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761389AbYEVLw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 07:52:58 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:37527 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759992AbYEVLwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 07:52:30 -0400
Message-Id: <20080522114947.692141425@kerlabs.com>
References: <20080522114048.265996107@kerlabs.com>
User-Agent: quilt/0.46-1
Date: Thu, 22 May 2008 13:40:51 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Joel.Becker@oracle.com
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
       Louis Rilling <Louis.Rilling@kerlabs.com>
Subject: [RFC][PATCH 3/4] configfs: Make nested default groups creations lockdep-friendly
Content-Disposition: inline; filename=configfs-make-default-group-creation-lockep-friendly-2.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When creating a config_group (resp. registering a subsystem) with nested default
groups, lockdep raises a warning since it sees a lock recursion of class
I_MUTEX_CHILD in populate_groups().

This patch makes such default groups creations lockdep-friendly by increasing
the i_mutex sub-class from I_MUTEX_CHILD onwards when descending the default
groups tree.

With this patch the depth of default group trees is limited to
MAX_LOCKDEP_SUBCLASSES - I_MUTEX_CHILD - 1 == 3. This limit is removed when not
compiling lockdep.

Signed-off-by: Louis Rilling <Louis.Rilling@kerlabs.com>
---
 fs/configfs/configfs_internal.h |    3 +
 fs/configfs/dir.c               |   61 ++++++++++++++++++++++++++++++++++------
 fs/configfs/mount.c             |    3 +
 3 files changed, 59 insertions(+), 8 deletions(-)



Index: b/fs/configfs/configfs_internal.h
===================================================================
--- a/fs/configfs/configfs_internal.h	2008-05-21 09:40:25.000000000 +0200
+++ b/fs/configfs/configfs_internal.h	2008-05-22 12:38:02.000000000 +0200
@@ -38,6 +38,9 @@ struct configfs_dirent {
 	umode_t			s_mode;
 	struct dentry		* s_dentry;
 	struct iattr		* s_iattr;
+#ifdef CONFIG_LOCKDEP
+	int 			s_lock_level;
+#endif
 };
 
 #define CONFIGFS_ROOT		0x0001
Index: b/fs/configfs/dir.c
===================================================================
--- a/fs/configfs/dir.c	2008-05-21 09:40:25.000000000 +0200
+++ b/fs/configfs/dir.c	2008-05-22 12:59:23.000000000 +0200
@@ -36,6 +36,37 @@
 
 DECLARE_RWSEM(configfs_rename_sem);
 
+#ifdef CONFIG_LOCKDEP
+static inline int set_dirent_lock_level(struct configfs_dirent *prev_sd,
+					struct configfs_dirent *sd)
+{
+	int lock_level = prev_sd->s_lock_level + 1;
+	if (lock_level + I_MUTEX_CHILD < MAX_LOCKDEP_SUBCLASSES) {
+		sd->s_lock_level = lock_level;
+		return lock_level;
+	}
+	sd->s_lock_level = -1;
+	return -ELOOP;
+}
+
+static inline void reset_dirent_lock_level(struct configfs_dirent *sd)
+{
+	sd->s_lock_level = -1;
+}
+
+#else /* CONFIG_LOCKDEP */
+
+static inline int set_dirent_lock_level(struct configfs_dirent *prev_sd,
+					struct configfs_dirent *sd)
+{
+	return 0;
+}
+
+static inline void reset_dirent_lock_level(struct configfs_dirent *sd)
+{
+}
+#endif /* CONFIG_LOCKDEP */
+
 static void configfs_d_iput(struct dentry * dentry,
 			    struct inode * inode)
 {
@@ -533,6 +564,10 @@ static int populate_groups(struct config
 {
 	struct config_group *new_group;
 	struct dentry *dentry = group->cg_item.ci_dentry;
+	struct configfs_dirent *sd = dentry->d_fsdata;
+	struct configfs_dirent *parent_sd =
+		group->cg_item.ci_parent->ci_dentry->d_fsdata;
+	int lock_level;
 	int ret = 0;
 	int i;
 
@@ -546,17 +581,27 @@ static int populate_groups(struct config
 		 * That said, taking our i_mutex is closer to mkdir
 		 * emulation, and shouldn't hurt.
 		 */
-		mutex_lock_nested(&dentry->d_inode->i_mutex, I_MUTEX_CHILD);
+		/* lock_level starts at zero for the non default group */
+		lock_level = set_dirent_lock_level(parent_sd, sd);
+		if (lock_level < 0) {
+			/* Too deeply nested default groups */
+			ret = lock_level;
+		} else {
+			mutex_lock_nested(&dentry->d_inode->i_mutex,
+					  I_MUTEX_CHILD + lock_level);
 
-		for (i = 0; group->default_groups[i]; i++) {
-			new_group = group->default_groups[i];
+			for (i = 0; group->default_groups[i]; i++) {
+				new_group = group->default_groups[i];
 
-			ret = create_default_group(group, new_group);
-			if (ret)
-				break;
-		}
+				ret = create_default_group(group, new_group);
+				if (ret)
+					break;
+			}
 
-		mutex_unlock(&dentry->d_inode->i_mutex);
+			mutex_unlock(&dentry->d_inode->i_mutex);
+			/* Reset for future sub-group creations */
+			reset_dirent_lock_level(sd);
+		}
 	}
 
 	if (ret)
Index: b/fs/configfs/mount.c
===================================================================
--- a/fs/configfs/mount.c	2008-05-21 09:40:25.000000000 +0200
+++ b/fs/configfs/mount.c	2008-05-22 12:38:02.000000000 +0200
@@ -64,6 +64,9 @@ static struct configfs_dirent configfs_r
 	.s_element	= &configfs_root_group.cg_item,
 	.s_type		= CONFIGFS_ROOT,
 	.s_iattr	= NULL,
+#ifdef CONFIG_LOCKDEP
+	.s_lock_level	= -1,
+#endif
 };
 
 static int configfs_fill_super(struct super_block *sb, void *data, int silent)

-- 
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

