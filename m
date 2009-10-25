Return-Path: <linux-kernel-owner+w=401wt.eu-S1754227AbZJYU1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227AbZJYU1X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 16:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754193AbZJYU1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 16:27:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48675 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754212AbZJYU1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 16:27:17 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 5/5] fsnotify: add groups to fsnotify_inode_groups when
	registering inode watch
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: agruen@suse.de
Date: Sun, 25 Oct 2009 16:27:20 -0400
Message-ID: <20091025202719.11501.63937.stgit@paris.rdu.redhat.com>
In-Reply-To: <20091025202655.11501.70437.stgit@paris.rdu.redhat.com>
References: <20091025202655.11501.70437.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently all fsnotify groups are added immediately to the
fsnotify_inode_groups list upon creation.  This means, even groups with no
watches (common for audit) will be on the global tracking list and will
get checked for every event.  This patch adds groups to the global list on
when the first inode mark is added to the group.

Signed-of-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/fsnotify.h   |    2 ++
 fs/notify/group.c      |   18 ++++++++----------
 fs/notify/inode_mark.c |    7 +++++++
 3 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/fs/notify/fsnotify.h b/fs/notify/fsnotify.h
index ec5aee4..5bd2241 100644
--- a/fs/notify/fsnotify.h
+++ b/fs/notify/fsnotify.h
@@ -16,6 +16,8 @@ extern __u32 fsnotify_inode_mask;
 /* destroy all events sitting in this groups notification queue */
 extern void fsnotify_flush_notify(struct fsnotify_group *group);
 
+/* add a group to the inode group list */
+extern void fsnotify_add_inode_group(struct fsnotify_group *group);
 /* final kfree of a group */
 extern void fsnotify_final_destroy_group(struct fsnotify_group *group);
 
diff --git a/fs/notify/group.c b/fs/notify/group.c
index f8c2f0f..ac74e91 100644
--- a/fs/notify/group.c
+++ b/fs/notify/group.c
@@ -77,12 +77,15 @@ void fsnotify_recalc_group_mask(struct fsnotify_group *group)
 		fsnotify_recalc_global_mask();
 }
 
-static void fsnotify_add_group(struct fsnotify_group *group)
+void fsnotify_add_inode_group(struct fsnotify_group *group)
 {
-	BUG_ON(!mutex_is_locked(&fsnotify_grp_mutex));
+	mutex_lock(&fsnotify_grp_mutex);
 
+	if (!group->on_inode_group_list)
+		list_add_tail_rcu(&group->inode_group_list, &fsnotify_inode_groups);
 	group->on_inode_group_list = 1;
-	list_add_tail_rcu(&group->inode_group_list, &fsnotify_inode_groups);
+
+	mutex_unlock(&fsnotify_grp_mutex);
 }
 
 /*
@@ -189,7 +192,6 @@ struct fsnotify_group *fsnotify_alloc_group(__u32 mask,
 	 */
 	atomic_set(&group->num_marks, 1);
 
-
 	group->mask = mask;
 
 	mutex_init(&group->notification_mutex);
@@ -197,17 +199,13 @@ struct fsnotify_group *fsnotify_alloc_group(__u32 mask,
 	init_waitqueue_head(&group->notification_waitq);
 	group->max_events = UINT_MAX;
 
+	INIT_LIST_HEAD(&group->inode_group_list);
+
 	spin_lock_init(&group->mark_lock);
 	INIT_LIST_HEAD(&group->mark_entries);
 
 	group->ops = ops;
 
-	mutex_lock(&fsnotify_grp_mutex);
-
-	fsnotify_add_group(group);
-
-	mutex_unlock(&fsnotify_grp_mutex);
-
 	if (mask)
 		fsnotify_recalc_global_mask();
 
diff --git a/fs/notify/inode_mark.c b/fs/notify/inode_mark.c
index 574c5c6..42b3f39 100644
--- a/fs/notify/inode_mark.c
+++ b/fs/notify/inode_mark.c
@@ -324,6 +324,13 @@ int fsnotify_add_mark(struct fsnotify_mark_entry *entry,
 		return -EINVAL;
 
 	/*
+	 * if this group isn't being testing for inode type events we need
+	 * to start testing
+	 */
+	if (unlikely(list_empty(&group->inode_group_list)))
+		fsnotify_add_inode_group(group);
+
+	/*
 	 * LOCKING ORDER!!!!
 	 * entry->lock
 	 * group->mark_lock

