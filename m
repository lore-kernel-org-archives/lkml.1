Return-Path: <linux-kernel-owner+w=401wt.eu-S1755691AbXGGGgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691AbXGGGgy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 02:36:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752140AbXGGGgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 02:36:45 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:11526 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735AbXGGGgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 02:36:44 -0400
Date: Fri, 6 Jul 2007 23:36:15 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Teigland <teigland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mark Fasheh <mark.fasheh@oracle.com>
Subject: [PATCH] configfs: Convert subsystem semaphore to mutex
Message-ID: <20070707063615.GA23394@ca-server1.us.oracle.com>
Mail-Followup-To: Satyam Sharma <ssatyam@cse.iitk.ac.in>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	David Teigland <teigland@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mark Fasheh <mark.fasheh@oracle.com>
References: <20070704110701.28503.95359.sendpatchset@cselinux1.cse.iitk.ac.in> <20070704110711.28503.26591.sendpatchset@cselinux1.cse.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070704110711.28503.26591.sendpatchset@cselinux1.cse.iitk.ac.in>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever come to perfection.
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Rewritten so that it applies to mainline and names the filed su_mutex.
 This will appear in my tree.]

Convert the su_sem member of struct configfs_subsystem to a struct
mutex, as that's what it is. Also convert all the users and update
Documentation/configfs.txt and Documentation/configfs_example.c
accordingly.

Inspired-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 Documentation/filesystems/configfs/configfs.txt    |   18 +++++++++---------
 .../filesystems/configfs/configfs_example.c        |    2 +-
 fs/configfs/dir.c                                  |   16 ++++++++--------
 fs/dlm/config.c                                    |    6 +++---
 fs/ocfs2/cluster/nodemanager.c                     |    2 +-
 include/linux/configfs.h                           |    4 ++--
 6 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/Documentation/filesystems/configfs/configfs.txt b/Documentation/filesystems/configfs/configfs.txt
index b34cdb5..21f038e 100644
--- a/Documentation/filesystems/configfs/configfs.txt
+++ b/Documentation/filesystems/configfs/configfs.txt
@@ -280,18 +280,18 @@ tells configfs to make the subsystem app
 
 	struct configfs_subsystem {
 		struct config_group	su_group;
-		struct semaphore	su_sem;
+		struct mutex		su_mutex;
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
@@ -303,7 +303,7 @@ subsystem/group and the simple_child ite
 shows a trivial object displaying and storing an attribute, and a simple
 group creating and destroying these children.
 
-[Hierarchy Navigation and the Subsystem Semaphore]
+[Hierarchy Navigation and the Subsystem Mutex]
 
 There is an extra bonus that configfs provides.  The config_groups and
 config_items are arranged in a hierarchy due to the fact that they
@@ -314,19 +314,19 @@ and config_item->ci_parent structure mem
 
 A subsystem can navigate the cg_children list and the ci_parent pointer
 to see the tree created by the subsystem.  This can race with configfs'
-management of the hierarchy, so configfs uses the subsystem semaphore to
+management of the hierarchy, so configfs uses the subsystem mutex to
 protect modifications.  Whenever a subsystem wants to navigate the
 hierarchy, it must do so under the protection of the subsystem
-semaphore.
+mutex.
 
-A subsystem will be prevented from acquiring the semaphore while a newly
+A subsystem will be prevented from acquiring the mutex while a newly
 allocated item has not been linked into this hierarchy.   Similarly, it
-will not be able to acquire the semaphore while a dropping item has not
+will not be able to acquire the mutex while a dropping item has not
 yet been unlinked.  This means that an item's ci_parent pointer will
 never be NULL while the item is in configfs, and that an item will only
 be in its parent's cg_children list for the same duration.  This allows
 a subsystem to trust ci_parent and cg_children while they hold the
-semaphore.
+mutex.
 
 [Item Aggregation Via symlink(2)]
 
diff --git a/Documentation/filesystems/configfs/configfs_example.c b/Documentation/filesystems/configfs/configfs_example.c
index 2d6a14a..e56d492 100644
--- a/Documentation/filesystems/configfs/configfs_example.c
+++ b/Documentation/filesystems/configfs/configfs_example.c
@@ -453,7 +453,7 @@ static int __init configfs_example_init(
 		subsys = example_subsys[i];
 
 		config_group_init(&subsys->su_group);
-		init_MUTEX(&subsys->su_sem);
+		mutex_init(&subsys->su_mutex);
 		ret = configfs_register_subsystem(subsys);
 		if (ret) {
 			printk(KERN_ERR "Error %d while registering subsystem %s\n",
diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index 5e6e37e..d3b1dbb 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -562,7 +562,7 @@ static int populate_groups(struct config
 
 /*
  * All of link_obj/unlink_obj/link_group/unlink_group require that
- * subsys->su_sem is held.
+ * subsys->su_mutex is held.
  */
 
 static void unlink_obj(struct config_item *item)
@@ -783,7 +783,7 @@ static int configfs_mkdir(struct inode *
 
 	snprintf(name, dentry->d_name.len + 1, "%s", dentry->d_name.name);
 
-	down(&subsys->su_sem);
+	mutex_lock(&subsys->su_mutex);
 	group = NULL;
 	item = NULL;
 	if (type->ct_group_ops->make_group) {
@@ -797,7 +797,7 @@ static int configfs_mkdir(struct inode *
 		if (item)
 			link_obj(parent_item, item);
 	}
-	up(&subsys->su_sem);
+	mutex_unlock(&subsys->su_mutex);
 
 	kfree(name);
 	if (!item) {
@@ -841,13 +841,13 @@ static int configfs_mkdir(struct inode *
 out_unlink:
 	if (ret) {
 		/* Tear down everything we built up */
-		down(&subsys->su_sem);
+		mutex_lock(&subsys->su_mutex);
 		if (group)
 			unlink_group(group);
 		else
 			unlink_obj(item);
 		client_drop_item(parent_item, item);
-		up(&subsys->su_sem);
+		mutex_unlock(&subsys->su_mutex);
 
 		if (module_got)
 			module_put(owner);
@@ -910,17 +910,17 @@ static int configfs_rmdir(struct inode *
 	if (sd->s_type & CONFIGFS_USET_DIR) {
 		configfs_detach_group(item);
 
-		down(&subsys->su_sem);
+		mutex_lock(&subsys->su_mutex);
 		unlink_group(to_config_group(item));
 	} else {
 		configfs_detach_item(item);
 
-		down(&subsys->su_sem);
+		mutex_lock(&subsys->su_mutex);
 		unlink_obj(item);
 	}
 
 	client_drop_item(parent_item, item);
-	up(&subsys->su_sem);
+	mutex_unlock(&subsys->su_mutex);
 
 	/* Drop our reference from above */
 	config_item_put(item);
diff --git a/fs/dlm/config.c b/fs/dlm/config.c
index 822abdc..bf93f97 100644
--- a/fs/dlm/config.c
+++ b/fs/dlm/config.c
@@ -609,7 +609,7 @@ static struct clusters clusters_root = {
 int dlm_config_init(void)
 {
 	config_group_init(&clusters_root.subsys.su_group);
-	init_MUTEX(&clusters_root.subsys.su_sem);
+	mutex_init(&clusters_root.subsys.su_mutex);
 	return configfs_register_subsystem(&clusters_root.subsys);
 }
 
@@ -767,7 +767,7 @@ static struct comm *get_comm(int nodeid,
 	if (!comm_list)
 		return NULL;
 
-	down(&clusters_root.subsys.su_sem);
+	mutex_lock(&clusters_root.subsys.su_mutex);
 
 	list_for_each_entry(i, &comm_list->cg_children, ci_entry) {
 		cm = to_comm(i);
@@ -785,7 +785,7 @@ static struct comm *get_comm(int nodeid,
 			break;
 		}
 	}
-	up(&clusters_root.subsys.su_sem);
+	mutex_unlock(&clusters_root.subsys.su_mutex);
 
 	if (found)
 		config_item_get(i);
diff --git a/fs/ocfs2/cluster/nodemanager.c b/fs/ocfs2/cluster/nodemanager.c
index 9f5ad0f..48b77d1 100644
--- a/fs/ocfs2/cluster/nodemanager.c
+++ b/fs/ocfs2/cluster/nodemanager.c
@@ -934,7 +934,7 @@ static int __init init_o2nm(void)
 		goto out_sysctl;
 
 	config_group_init(&o2nm_cluster_group.cs_subsys.su_group);
-	init_MUTEX(&o2nm_cluster_group.cs_subsys.su_sem);
+	mutex_init(&o2nm_cluster_group.cs_subsys.su_mutex);
 	ret = configfs_register_subsystem(&o2nm_cluster_group.cs_subsys);
 	if (ret) {
 		printk(KERN_ERR "nodemanager: Registration returned %d\n", ret);
diff --git a/include/linux/configfs.h b/include/linux/configfs.h
index fef6f3d..798c0c1 100644
--- a/include/linux/configfs.h
+++ b/include/linux/configfs.h
@@ -40,9 +40,9 @@ #ifdef __KERNEL__
 #include <linux/types.h>
 #include <linux/list.h>
 #include <linux/kref.h>
+#include <linux/mutex.h>
 
 #include <asm/atomic.h>
-#include <asm/semaphore.h>
 
 #define CONFIGFS_ITEM_NAME_LEN	20
 
@@ -162,7 +162,7 @@ struct configfs_group_operations {
 
 struct configfs_subsystem {
 	struct config_group	su_group;
-	struct semaphore	su_sem;
+	struct mutex		su_mutex;
 };
 
 static inline struct configfs_subsystem *to_configfs_subsystem(struct config_group *group)
-- 
1.4.2.3

-- 

"The first requisite of a good citizen in this republic of ours
 is that he shall be able and willing to pull his weight."
	- Theodore Roosevelt

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
