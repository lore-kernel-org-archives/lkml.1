Return-Path: <linux-kernel-owner+w=401wt.eu-S1754086AbYKYRWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086AbYKYRWm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 12:22:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753637AbYKYRVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 12:21:53 -0500
Received: from mx2.redhat.com ([66.187.237.31]:36587 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752750AbYKYRVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 12:21:46 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH -v3 6/8] fsnotify: add group priorities
To: linux-kernel@vger.kernel.org, malware-list@lists.printk.net
Cc: viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, arjan@infradead.org, hch@infradead.org,
       a.p.zijlstra@chello.nl
Date: Tue, 25 Nov 2008 12:21:23 -0500
Message-ID: <20081125172123.17115.31274.stgit@paris.rdu.redhat.com>
In-Reply-To: <20081125171714.17115.82625.stgit@paris.rdu.redhat.com>
References: <20081125171714.17115.82625.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preperation for blocking fsnotify calls group priorities must be added.
When multiple groups request the same event type the lowest priority group
will receive the notification first.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/group.c                |   28 ++++++++++++++++++++++++----
 include/linux/fsnotify_backend.h |    4 +++-
 2 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/fs/notify/group.c b/fs/notify/group.c
index dcc0547..bb8d6c6 100644
--- a/fs/notify/group.c
+++ b/fs/notify/group.c
@@ -79,15 +79,17 @@ void fsnotify_put_group(struct fsnotify_group *group)
 	return;
 }
 
-struct fsnotify_group *fsnotify_find_group(unsigned int group_num, unsigned long mask, struct fsnotify_ops *ops)
+struct fsnotify_group *fsnotify_find_group(unsigned int priority, unsigned int group_num,
+					   unsigned long mask, struct fsnotify_ops *ops)
 {
 	struct fsnotify_group *group_iter;
 	struct fsnotify_group *group = NULL;
 
 	mutex_lock(&fsnotify_grp_mutex);
 	list_for_each_entry_rcu(group_iter, &fsnotify_groups, group_list) {
-		if (group_iter->group_num == group_num) {
+		if (group_iter->priority == priority) {
 			if ((group_iter->mask == mask) &&
+			    (group_iter->group_num == group_num) &&
 			    (group_iter->ops == ops)) {
 				fsnotify_get_group(group_iter);
 				group = group_iter;
@@ -105,6 +107,7 @@ struct fsnotify_group *fsnotify_find_group(unsigned int group_num, unsigned long
 
 	atomic_set(&group->refcnt, 1);
 
+	group->priority = priority;
 	group->group_num = group_num;
 	group->mask = mask;
 
@@ -114,9 +117,26 @@ struct fsnotify_group *fsnotify_find_group(unsigned int group_num, unsigned long
 
 	group->ops = ops;
 
-	/* add it */
-	list_add_rcu(&group->group_list, &fsnotify_groups);
+	/* Do we need to be the first entry? */
+	if (list_empty(&fsnotify_groups)) {
+		list_add_rcu(&group->group_list, &fsnotify_groups);
+		goto out;
+	}
+
+	list_for_each_entry(group_iter, &fsnotify_groups, group_list) {
+		/* insert in front of this one? */
+		if (priority < group_iter->priority) {
+			/* I used list_add_tail() to insert in front of group_iter...  */
+			list_add_tail_rcu(&group->group_list, &group_iter->group_list);
+			break;
+		}
 
+		/* are we at the end?  if so insert at end */
+		if (list_is_last(&group_iter->group_list, &fsnotify_groups)) {
+			list_add_tail_rcu(&group->group_list, &fsnotify_groups);
+			break;
+		}
+	}
 out:
 	mutex_unlock(&fsnotify_grp_mutex);
 	fsnotify_recalc_global_mask();
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 6a7b95c..e0b5528 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -57,6 +57,8 @@ struct fsnotify_group {
 	struct mutex notification_mutex;/* protect the notification_list */
 	struct list_head notification_list;	/* list of event_holder this group needs to send to userspace */
 	wait_queue_head_t notification_waitq;	/* read() on the notification file blocks on this waitq */
+
+	unsigned int priority;		/* order this group should receive msgs.  low first */
 };
 
 #ifdef CONFIG_FSNOTIFY
@@ -67,7 +69,7 @@ extern void fsnotify(struct file *file, struct dentry *dentry, struct inode *ino
 /* called from fsnotify interfaces, such as fanotify or dnotify */
 extern void fsnotify_recalc_global_mask(void);
 extern void fsnotify_get_group(struct fsnotify_group *group);
-extern struct fsnotify_group *fsnotify_find_group(unsigned int group_num, unsigned long mask, struct fsnotify_ops *ops);
+extern struct fsnotify_group *fsnotify_find_group(unsigned int priority, unsigned int group_num, unsigned long mask, struct fsnotify_ops *ops);
 extern void fsnotify_put_group(struct fsnotify_group *group);
 #else
 

