Return-Path: <linux-kernel-owner+w=401wt.eu-S1761896AbXGDLK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761896AbXGDLK1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 07:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761334AbXGDLIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 07:08:16 -0400
Received: from mail4.iitk.ac.in ([203.197.196.4]:57171 "EHLO mail4.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759019AbXGDLIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 07:08:04 -0400
X-Virus-Scanner: This message was checked by NOD32 Antivirus system
	for Linux Server. For more information on NOD32 Antivirus System,
	please, visit our website: http://www.nod32.com/.
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Joel Becker <joel.becker@oracle.com>,
       Satyam Sharma <ssatyam@cse.iitk.ac.in>,
       David Teigland <david.teigland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mark Fasheh <mark.fasheh@oracle.com>
Date: Wed, 04 Jul 2007 16:37:11 +0530
Message-Id: <20070704110711.28503.26591.sendpatchset@cselinux1.cse.iitk.ac.in>
In-Reply-To: <20070704110701.28503.95359.sendpatchset@cselinux1.cse.iitk.ac.in>
References: <20070704110701.28503.95359.sendpatchset@cselinux1.cse.iitk.ac.in>
Subject: [PATCH -mm 2/3] configfs+dlm+ocfs2: Convert subsystem semaphore to mutex
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Satyam Sharma <ssatyam@cse.iitk.ac.in>

[2/3] configfs+dlm+ocfs2: Convert subsystem semaphore to mutex

Convert the su_sem member of struct configfs_subsystem to a struct mutex,
as that's what it is. Also convert all the users and update
Documentation/configfs.txt and Documentation/configfs_example.c accordingly.

[ This patch touches three different trees (configfs, dlm and ocfs2)
and I thought of splitting this up, but I guess there's little point in
splitting into smaller patches that won't even build without each other. ]

Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Cc: Joel Becker <joel.becker@oracle.com>
Cc: Mark Fasheh <mark.fasheh@oracle.com>
Cc: David Teigland <teigland@redhat.com>

---

 Documentation/filesystems/configfs/configfs.txt       |   20 ++++++++----------
 Documentation/filesystems/configfs/configfs_example.c |    2 -
 fs/configfs/dir.c                                     |   16 +++++++-------
 fs/dlm/config.c                                       |   10 ++++-----
 fs/ocfs2/cluster/nodemanager.c                        |    2 -
 include/linux/configfs.h                              |    5 +---
 6 files changed, 26 insertions(+), 29 deletions(-)

---

diff -ruNp a/Documentation/filesystems/configfs/configfs_example.c b/Documentation/filesystems/configfs/configfs_example.c
--- a/Documentation/filesystems/configfs/configfs_example.c	2007-04-26 08:38:32.000000000 +0530
+++ b/Documentation/filesystems/configfs/configfs_example.c	2007-07-03 18:38:28.000000000 +0530
@@ -453,7 +453,7 @@ static int __init configfs_example_init(
 		subsys = example_subsys[i];
 
 		config_group_init(&subsys->su_group);
-		init_MUTEX(&subsys->su_sem);
+		mutex_init(&subsys->su_mtx);
 		ret = configfs_register_subsystem(subsys);
 		if (ret) {
 			printk(KERN_ERR "Error %d while registering subsystem %s\n",
diff -ruNp a/Documentation/filesystems/configfs/configfs.txt b/Documentation/filesystems/configfs/configfs.txt
--- a/Documentation/filesystems/configfs/configfs.txt	2007-06-28 17:31:57.000000000 +0530
+++ b/Documentation/filesystems/configfs/configfs.txt	2007-07-03 18:38:28.000000000 +0530
@@ -292,18 +292,18 @@ tells configfs to make the subsystem app
 
 	struct configfs_subsystem {
 		struct config_group	su_group;
-		struct semaphore	su_sem;
+		struct mutex		su_mtx;
 	};
 
 	int configfs_register_subsystem(struct configfs_subsystem *subsys);
 	void configfs_unregister_subsystem(struct configfs_subsystem *subsys);
 
-	A subsystem consists of a toplevel config_group and a semaphore.
+	A subsystem consists of a toplevel config_group and a mutex.
 The group is where child config_items are created.  For a subsystem,
 this group is usually defined statically.  Before calling
 configfs_register_subsystem(), the subsystem must have initialized the
 group via the usual group _init() functions, and it must also have
-initialized the semaphore.
+initialized the mutex.
 	When the register call returns, the subsystem is live, and it
 will be visible via configfs.  At that point, mkdir(2) can be called and
 the subsystem must be ready for it.
@@ -315,7 +315,7 @@ subsystem/group and the simple_child ite
 shows a trivial object displaying and storing an attribute, and a simple
 group creating and destroying these children.
 
-[Hierarchy Navigation and the Subsystem Semaphore]
+[Hierarchy Navigation and the Subsystem Mutex]
 
 There is an extra bonus that configfs provides.  The config_groups and
 config_items are arranged in a hierarchy due to the fact that they
@@ -326,19 +326,17 @@ and config_item->ci_parent structure mem
 
 A subsystem can navigate the cg_children list and the ci_parent pointer
 to see the tree created by the subsystem.  This can race with configfs'
-management of the hierarchy, so configfs uses the subsystem semaphore to
+management of the hierarchy, so configfs uses the subsystem mutex to
 protect modifications.  Whenever a subsystem wants to navigate the
-hierarchy, it must do so under the protection of the subsystem
-semaphore.
+hierarchy, it must do so under the protection of the subsystem mutex.
 
-A subsystem will be prevented from acquiring the semaphore while a newly
+A subsystem will be prevented from acquiring the mutex while a newly
 allocated item has not been linked into this hierarchy.   Similarly, it
-will not be able to acquire the semaphore while a dropping item has not
+will not be able to acquire the mutex while a dropping item has not
 yet been unlinked.  This means that an item's ci_parent pointer will
 never be NULL while the item is in configfs, and that an item will only
 be in its parent's cg_children list for the same duration.  This allows
-a subsystem to trust ci_parent and cg_children while they hold the
-semaphore.
+a subsystem to trust ci_parent and cg_children while they hold the mutex.
 
 [Item Aggregation Via symlink(2)]
 
diff -ruNp a/fs/configfs/dir.c b/fs/configfs/dir.c
--- a/fs/configfs/dir.c	2007-06-28 17:32:57.000000000 +0530
+++ b/fs/configfs/dir.c	2007-07-03 18:44:07.000000000 +0530
@@ -566,7 +566,7 @@ static int populate_groups(struct config
 
 /*
  * All of link_obj/unlink_obj/link_group/unlink_group require that
- * subsys->su_sem is held.
+ * subsys->su_mtx is held.
  */
 
 static void unlink_obj(struct config_item *item)
@@ -1042,7 +1042,7 @@ static int configfs_mkdir(struct inode *
 
 	snprintf(name, dentry->d_name.len + 1, "%s", dentry->d_name.name);
 
-	down(&subsys->su_sem);
+	mutex_lock(&subsys->su_mtx);
 	group = NULL;
 	item = NULL;
 	if (type->ct_group_ops->make_group) {
@@ -1056,7 +1056,7 @@ static int configfs_mkdir(struct inode *
 		if (item)
 			link_obj(parent_item, item);
 	}
-	up(&subsys->su_sem);
+	mutex_unlock(&subsys->su_mtx);
 
 	kfree(name);
 	if (!item) {
@@ -1100,7 +1100,7 @@ static int configfs_mkdir(struct inode *
 out_unlink:
 	if (ret) {
 		/* Tear down everything we built up */
-		down(&subsys->su_sem);
+		mutex_lock(&subsys->su_mtx);
 
 		client_disconnect_notify(parent_item, item);
 		if (group)
@@ -1109,7 +1109,7 @@ out_unlink:
 			unlink_obj(item);
 		client_drop_item(parent_item, item);
 
-		up(&subsys->su_sem);
+		mutex_unlock(&subsys->su_mtx);
 
 		if (module_got)
 			module_put(owner);
@@ -1179,19 +1179,19 @@ static int configfs_rmdir(struct inode *
 	if (sd->s_type & CONFIGFS_USET_DIR) {
 		configfs_detach_group(item);
 
-		down(&subsys->su_sem);
+		mutex_lock(&subsys->su_mtx);
 		client_disconnect_notify(parent_item, item);
 		unlink_group(to_config_group(item));
 	} else {
 		configfs_detach_item(item);
 
-		down(&subsys->su_sem);
+		mutex_lock(&subsys->su_mtx);
 		client_disconnect_notify(parent_item, item);
 		unlink_obj(item);
 	}
 
 	client_drop_item(parent_item, item);
-	up(&subsys->su_sem);
+	mutex_unlock(&subsys->su_mtx);
 
 	/* Drop our reference from above */
 	config_item_put(item);
diff -ruNp a/fs/dlm/config.c b/fs/dlm/config.c
--- a/fs/dlm/config.c	2007-07-03 18:35:03.000000000 +0530
+++ b/fs/dlm/config.c	2007-07-03 18:38:28.000000000 +0530
@@ -607,7 +607,7 @@ static struct clusters clusters_root = {
 int dlm_config_init(void)
 {
 	config_group_init(&clusters_root.subsys.su_group);
-	init_MUTEX(&clusters_root.subsys.su_sem);
+	mutex_init(&clusters_root.subsys.su_mtx);
 	return configfs_register_subsystem(&clusters_root.subsys);
 }
 
@@ -751,9 +751,9 @@ static struct space *get_space(char *nam
 	if (!space_list)
 		return NULL;
 
-	down(&space_list->cg_subsys->su_sem);
+	mutex_lock(&space_list->cg_subsys->su_mtx);
 	i = config_group_find_obj(space_list, name);
-	up(&space_list->cg_subsys->su_sem);
+	mutex_unlock(&space_list->cg_subsys->su_mtx);
 
 	return to_space(i);
 }
@@ -772,7 +772,7 @@ static struct comm *get_comm(int nodeid,
 	if (!comm_list)
 		return NULL;
 
-	down(&clusters_root.subsys.su_sem);
+	mutex_lock(&clusters_root.subsys.su_mtx);
 
 	list_for_each_entry(i, &comm_list->cg_children, ci_entry) {
 		cm = to_comm(i);
@@ -792,7 +792,7 @@ static struct comm *get_comm(int nodeid,
 			break;
 		}
 	}
-	up(&clusters_root.subsys.su_sem);
+	mutex_unlock(&clusters_root.subsys.su_mtx);
 
 	if (!found)
 		cm = NULL;
diff -ruNp a/fs/ocfs2/cluster/nodemanager.c b/fs/ocfs2/cluster/nodemanager.c
--- a/fs/ocfs2/cluster/nodemanager.c	2007-06-28 17:33:07.000000000 +0530
+++ b/fs/ocfs2/cluster/nodemanager.c	2007-07-03 18:38:28.000000000 +0530
@@ -974,7 +974,7 @@ static int __init init_o2nm(void)
 		goto out_sysctl;
 
 	config_group_init(&o2nm_cluster_group.cs_subsys.su_group);
-	init_MUTEX(&o2nm_cluster_group.cs_subsys.su_sem);
+	mutex_init(&o2nm_cluster_group.cs_subsys.su_mtx);
 	ret = configfs_register_subsystem(&o2nm_cluster_group.cs_subsys);
 	if (ret) {
 		printk(KERN_ERR "nodemanager: Registration returned %d\n", ret);
diff -ruNp a/include/linux/configfs.h b/include/linux/configfs.h
--- a/include/linux/configfs.h	2007-07-03 18:35:03.000000000 +0530
+++ b/include/linux/configfs.h	2007-07-03 18:38:28.000000000 +0530
@@ -40,9 +40,8 @@
 #include <linux/types.h>
 #include <linux/list.h>
 #include <linux/kref.h>
-
+#include <linux/mutex.h>
 #include <asm/atomic.h>
-#include <asm/semaphore.h>
 
 #define CONFIGFS_ITEM_NAME_LEN	20
 
@@ -178,7 +177,7 @@ struct configfs_group_operations {
 
 struct configfs_subsystem {
 	struct config_group	su_group;
-	struct semaphore	su_sem;
+	struct mutex		su_mtx;
 };
 
 static inline struct configfs_subsystem *to_configfs_subsystem(struct config_group *group)
