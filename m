Return-Path: <linux-kernel-owner+w=401wt.eu-S1754187AbZJYU1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbZJYU1L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 16:27:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754149AbZJYU1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 16:27:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62031 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754142AbZJYU1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 16:27:05 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 3/5] fsnotify: rename fsnotify_groups to fsnotify_inode_groups
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: agruen@suse.de
Date: Sun, 25 Oct 2009 16:27:07 -0400
Message-ID: <20091025202707.11501.65133.stgit@paris.rdu.redhat.com>
In-Reply-To: <20091025202655.11501.70437.stgit@paris.rdu.redhat.com>
References: <20091025202655.11501.70437.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simple renaming patch.  fsnotify is about to support mount point listeners
so I am renaming fsnotify_groups and fsnotify_mask to indicate these are lists
used only for groups which have watches on inodes.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/fsnotify.c             |    6 +++---
 fs/notify/fsnotify.h             |    8 ++++----
 fs/notify/group.c                |   30 +++++++++++++++++++-----------
 include/linux/fsnotify_backend.h |    6 +++---
 4 files changed, 29 insertions(+), 21 deletions(-)

diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index d4b0272..30655d1 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -147,10 +147,10 @@ void fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is, const
 	/* global tests shouldn't care about events on child only the specific event */
 	__u32 test_mask = (mask & ~FS_EVENT_ON_CHILD);
 
-	if (list_empty(&fsnotify_groups))
+	if (list_empty(&fsnotify_inode_groups))
 		return;
 
-	if (!(test_mask & fsnotify_mask))
+	if (!(test_mask & fsnotify_inode_mask))
 		return;
 
 	if (!(test_mask & to_tell->i_fsnotify_mask))
@@ -161,7 +161,7 @@ void fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is, const
 	 * anything other than walk the list so it's crazy to pre-allocate.
 	 */
 	idx = srcu_read_lock(&fsnotify_grp_srcu);
-	list_for_each_entry_rcu(group, &fsnotify_groups, group_list) {
+	list_for_each_entry_rcu(group, &fsnotify_inode_groups, inode_group_list) {
 		if (test_mask & group->mask) {
 			if (!group->ops->should_send_event(group, to_tell, mask,
 							   data, data_is))
diff --git a/fs/notify/fsnotify.h b/fs/notify/fsnotify.h
index 4dc2408..ec5aee4 100644
--- a/fs/notify/fsnotify.h
+++ b/fs/notify/fsnotify.h
@@ -8,10 +8,10 @@
 
 /* protects reads of fsnotify_groups */
 extern struct srcu_struct fsnotify_grp_srcu;
-/* all groups which receive fsnotify events */
-extern struct list_head fsnotify_groups;
-/* all bitwise OR of all event types (FS_*) for all fsnotify_groups */
-extern __u32 fsnotify_mask;
+/* all groups which receive inode fsnotify events */
+extern struct list_head fsnotify_inode_groups;
+/* all bitwise OR of all event types (FS_*) for all fsnotify_inode_groups */
+extern __u32 fsnotify_inode_mask;
 
 /* destroy all events sitting in this groups notification queue */
 extern void fsnotify_flush_notify(struct fsnotify_group *group);
diff --git a/fs/notify/group.c b/fs/notify/group.c
index 1d20d26..73d2c30 100644
--- a/fs/notify/group.c
+++ b/fs/notify/group.c
@@ -33,9 +33,9 @@ static DEFINE_MUTEX(fsnotify_grp_mutex);
 /* protects reads while running the fsnotify_groups list */
 struct srcu_struct fsnotify_grp_srcu;
 /* all groups registered to receive filesystem notifications */
-LIST_HEAD(fsnotify_groups);
+LIST_HEAD(fsnotify_inode_groups);
 /* bitwise OR of all events (FS_*) interesting to some group on this system */
-__u32 fsnotify_mask;
+__u32 fsnotify_inode_mask;
 
 /*
  * When a new group registers or changes it's set of interesting events
@@ -48,10 +48,10 @@ void fsnotify_recalc_global_mask(void)
 	int idx;
 
 	idx = srcu_read_lock(&fsnotify_grp_srcu);
-	list_for_each_entry_rcu(group, &fsnotify_groups, group_list)
+	list_for_each_entry_rcu(group, &fsnotify_inode_groups, inode_group_list)
 		mask |= group->mask;
 	srcu_read_unlock(&fsnotify_grp_srcu, idx);
-	fsnotify_mask = mask;
+	fsnotify_inode_mask = mask;
 }
 
 /*
@@ -77,6 +77,17 @@ void fsnotify_recalc_group_mask(struct fsnotify_group *group)
 		fsnotify_recalc_global_mask();
 }
 
+static void fsnotify_add_group(struct fsnotify_group *group)
+{
+	BUG_ON(!mutex_is_locked(&fsnotify_grp_mutex));
+
+	group->on_inode_group_list = 1;
+	/* being on the fsnotify_groups list holds one num_marks */
+	atomic_inc(&group->num_marks);
+
+	list_add_tail_rcu(&group->inode_group_list, &fsnotify_inode_groups);
+}
+
 /*
  * Final freeing of a group
  */
@@ -118,9 +129,9 @@ static void __fsnotify_evict_group(struct fsnotify_group *group)
 {
 	BUG_ON(!mutex_is_locked(&fsnotify_grp_mutex));
 
-	if (group->on_group_list)
-		list_del_rcu(&group->group_list);
-	group->on_group_list = 0;
+	if (group->on_inode_group_list)
+		list_del_rcu(&group->inode_group_list);
+	group->on_inode_group_list = 0;
 }
 
 /*
@@ -189,10 +200,7 @@ struct fsnotify_group *fsnotify_alloc_group(__u32 mask,
 
 	mutex_lock(&fsnotify_grp_mutex);
 
-	list_add_rcu(&group->group_list, &fsnotify_groups);
-	group->on_group_list = 1;
-	/* being on the fsnotify_groups list holds one num_marks */
-	atomic_inc(&group->num_marks);
+	fsnotify_add_group(group);
 
 	mutex_unlock(&fsnotify_grp_mutex);
 
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 7d3c03e..5d2854d 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -95,10 +95,10 @@ struct fsnotify_ops {
 struct fsnotify_group {
 	/*
 	 * global list of all groups receiving events from fsnotify.
-	 * anchored by fsnotify_groups and protected by either fsnotify_grp_mutex
+	 * anchored by fsnotify_inode_groups and protected by either fsnotify_grp_mutex
 	 * or fsnotify_grp_srcu depending on write vs read.
 	 */
-	struct list_head group_list;
+	struct list_head inode_group_list;
 
 	/*
 	 * Defines all of the event types in which this group is interested.
@@ -136,7 +136,7 @@ struct fsnotify_group {
 	struct list_head mark_entries;	/* all inode mark entries for this group */
 
 	/* prevents double list_del of group_list.  protected by global fsnotify_grp_mutex */
-	bool on_group_list;
+	bool on_inode_group_list;
 
 	/* groups can define private fields here or use the void *private */
 	union {

