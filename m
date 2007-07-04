Return-Path: <linux-kernel-owner+w=401wt.eu-S1760922AbXGDLYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760922AbXGDLYu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 07:24:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756338AbXGDLYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 07:24:43 -0400
Received: from mail4.iitk.ac.in ([203.197.196.4]:41268 "EHLO mail4.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755964AbXGDLYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 07:24:42 -0400
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
Date: Wed, 04 Jul 2007 16:37:16 +0530
Message-Id: <20070704110716.28503.52627.sendpatchset@cselinux1.cse.iitk.ac.in>
In-Reply-To: <20070704110701.28503.95359.sendpatchset@cselinux1.cse.iitk.ac.in>
References: <20070704110701.28503.95359.sendpatchset@cselinux1.cse.iitk.ac.in>
Subject: [PATCH -mm 3/3] configfs+dlm: Rename config_group_find_obj and state semantics clearly
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Satyam Sharma <ssatyam@cse.iitk.ac.in>

[3/3] configfs+dlm: Rename config_group_find_obj and state semantics clearly

[ Ok, this might sound like a gratuitous patch, but I believe there are
good reasons for it. ]

Configfs being based upon sysfs code, config_group_find_obj() is probably
so named because of the similar kset_find_obj() in sysfs. However,
"kobject"s in sysfs become "config_item"s in configfs, so let's call it
config_group_find_item() instead, for sake of uniformity, and make
corresponding change in the users of this function.

BTW a crucial difference between kset_find_obj and config_group_find_item
is in locking expectations. kset_find_obj does its locking by itself, but
config_group_find_item expects the *caller* to do the locking. The reason
for this: kset's have their own locks, config_group's don't but instead
rely on the subsystem mutex. And, subsystem needn't necessarily be around
when config_group_find_item() is called.

So let's state these locking semantics explicitly, and rectify the comment,
otherwise bugs could continue to occur in future, as they did in the past
(refer commit d82b8191e238 in gfs2-2.6-fixes.git).

[ I also took the opportunity to fix some bad whitespace and
double-empty lines. ]

Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Cc: Joel Becker <joel.becker@oracle.com>
Cc: David Teigland <teigland@redhat.com>

---

 fs/configfs/item.c       |   18 ++++++++----------
 fs/dlm/config.c          |    2 +-
 include/linux/configfs.h |    8 ++------
 3 files changed, 11 insertions(+), 17 deletions(-)

---

diff -ruNp a/fs/configfs/item.c b/fs/configfs/item.c
--- a/fs/configfs/item.c	2007-06-28 17:32:57.000000000 +0530
+++ b/fs/configfs/item.c	2007-07-03 19:42:00.000000000 +0530
@@ -183,27 +183,25 @@ void config_group_init(struct config_gro
 	INIT_LIST_HEAD(&group->cg_children);
 }
 
-
 /**
- *	config_group_find_obj - search for item in group.
+ *	config_group_find_item - search for item in group.
  *	@group:	group we're looking in.
  *	@name:	item's name.
  *
- *	Lock group via @group->cg_subsys, and iterate over @group->cg_list,
- *	looking for a matching config_item. If matching item is found
- *	take a reference and return the item.
+ *	Iterate over @group->cg_list, looking for a matching config_item.
+ *	If matching item is found take a reference and return the item.
+ *	Caller must have locked group via @group->cg_subsys->su_mtx.
  */
-struct config_item *config_group_find_obj(struct config_group *group,
-					  const char * name)
+struct config_item *config_group_find_item(struct config_group *group,
+					   const char *name)
 {
 	struct list_head * entry;
 	struct config_item * ret = NULL;
 
-        /* XXX LOCKING! */
 	list_for_each(entry,&group->cg_children) {
 		struct config_item * item = to_item(entry);
 		if (config_item_name(item) &&
-                    !strcmp(config_item_name(item), name)) {
+		    !strcmp(config_item_name(item), name)) {
 			ret = config_item_get(item);
 			break;
 		}
@@ -215,4 +213,4 @@ EXPORT_SYMBOL(config_item_init);
 EXPORT_SYMBOL(config_group_init);
 EXPORT_SYMBOL(config_item_get);
 EXPORT_SYMBOL(config_item_put);
-EXPORT_SYMBOL(config_group_find_obj);
+EXPORT_SYMBOL(config_group_find_item);
diff -ruNp a/fs/dlm/config.c b/fs/dlm/config.c
--- a/fs/dlm/config.c	2007-07-03 18:52:25.000000000 +0530
+++ b/fs/dlm/config.c	2007-07-03 19:43:57.000000000 +0530
@@ -752,7 +752,7 @@ static struct space *get_space(char *nam
 		return NULL;
 
 	mutex_lock(&space_list->cg_subsys->su_mtx);
-	i = config_group_find_obj(space_list, name);
+	i = config_group_find_item(space_list, name);
 	mutex_unlock(&space_list->cg_subsys->su_mtx);
 
 	return to_space(i);
diff -ruNp a/include/linux/configfs.h b/include/linux/configfs.h
--- a/include/linux/configfs.h	2007-07-03 18:52:25.000000000 +0530
+++ b/include/linux/configfs.h	2007-07-03 19:46:56.000000000 +0530
@@ -85,12 +85,10 @@ struct config_item_type {
 	struct configfs_attribute		**ct_attrs;
 };
 
-
 /**
  *	group - a group of config_items of a specific type, belonging
  *	to a specific subsystem.
  */
-
 struct config_group {
 	struct config_item		cg_item;
 	struct list_head		cg_children;
@@ -98,13 +96,11 @@ struct config_group {
 	struct config_group		**default_groups;
 };
 
-
 extern void config_group_init(struct config_group *group);
 extern void config_group_init_type_name(struct config_group *group,
 					const char *name,
 					struct config_item_type *type);
 
-
 static inline struct config_group *to_config_group(struct config_item *item)
 {
 	return item ? container_of(item,struct config_group,cg_item) : NULL;
@@ -120,8 +116,8 @@ static inline void config_group_put(stru
 	config_item_put(&group->cg_item);
 }
 
-extern struct config_item *config_group_find_obj(struct config_group *, const char *);
-
+extern struct config_item *config_group_find_item(struct config_group *,
+						  const char *);
 
 struct configfs_attribute {
 	const char		*ca_name;
