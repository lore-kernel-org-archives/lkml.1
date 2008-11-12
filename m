Return-Path: <linux-kernel-owner+w=401wt.eu-S1754663AbYKLQQP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663AbYKLQQP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 11:16:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751714AbYKLQMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 11:12:25 -0500
Received: from mx2.redhat.com ([66.187.237.31]:45442 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609AbYKLQMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 11:12:20 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH =-v3 19/21] fanotify: evict misbehaving clients
To: linux-kernel@vger.kernel.org, malware-list@lists.printk.net
Cc: viro@zeniv.linux.org.uk, alan@lxorguk.ukuu.org.uk, arjan@infradead.org,
       greg@kroah.com, tytso@mit.edu, akpm@linux-foundation.org
Date: Wed, 12 Nov 2008 11:12:06 -0500
Message-ID: <20081112161206.25434.71743.stgit@paris.rdu.redhat.com>
In-Reply-To: <20081112161002.25434.82358.stgit@paris.rdu.redhat.com>
References: <20081112161002.25434.82358.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fanotify clients that fail to respond to access requests withing their
timeout or which registered for read permissions checking but fail to then
set fastpaths on O_NONBLOCK files should be evicted.  I don't want
misbehaving clients to be able to bring down the system.

This patch tracks the number of times we hit one of these catagories.  If
we have 10 more misses than hits we will evict the group from the global
fanotify group list.

Signed-off-by: Eric Paris <eparis@redhat.com>

register for read permission checks and do not then
set fastpaths on
---

 fs/notify/access.c       |   35 +++++++++++++++++++++++++++++++++++
 fs/notify/fanotify.h     |    1 +
 fs/notify/group.c        |   21 ++++++++++++++++++++-
 include/linux/fanotify.h |    6 +++++-
 4 files changed, 61 insertions(+), 2 deletions(-)

diff --git a/fs/notify/access.c b/fs/notify/access.c
index 0c04a60..73b40e1 100644
--- a/fs/notify/access.c
+++ b/fs/notify/access.c
@@ -29,6 +29,35 @@
 #include <linux/fanotify.h>
 #include "fanotify.h"
 
+static inline void userspace_success(struct fanotify_group *group)
+{
+	if (likely(group->misbehave_count == 0))
+		return;
+
+	spin_lock(&group->misbehave_lock);
+	if (group->misbehave_count > 0)
+		group->misbehave_count--;
+	spin_unlock(&group->misbehave_lock);
+}
+
+static inline void userspace_error(struct fanotify_group *group)
+{
+	int evict = 0;
+	spin_lock(&group->misbehave_lock);
+	group->misbehave_count++;
+	if (group->misbehave_count > 10) {
+		group->misbehave_count = 10;
+		evict = 1;
+		/* don't allow it to wrap */
+		if (unlikely(group->misbehave_count >= INT_MAX))
+			group->misbehave_count = 10;
+	}
+	spin_unlock(&group->misbehave_lock);
+
+	if (evict)
+		fanotify_evict_group(group);
+}
+
 int fanotify_add_event_to_access(struct fanotify_group *group, struct fanotify_event *event)
 {
 	struct fanotify_event_holder *holder;
@@ -83,6 +112,10 @@ retry:
 		}
 		mutex_unlock(&group->access_mutex);
 
+		/* we timed out, userspace screwed up */
+		if (!ret) {
+			userspace_error(group);
+		}
 		/*
 		 * if we took a signal, return ERESTARTSYS
 		 * if we timed out userspace is broken so return ALLOW
@@ -90,6 +123,8 @@ retry:
 		return ret;
 	}
 
+	userspace_success(group);
+
 	/* userspace responded, convert to something usable */
 	spin_lock(&event->response_lock);
 	switch (event->response) {
diff --git a/fs/notify/fanotify.h b/fs/notify/fanotify.h
index a370ff9..b31e19a 100644
--- a/fs/notify/fanotify.h
+++ b/fs/notify/fanotify.h
@@ -82,6 +82,7 @@ struct fanotify_fastpath_entry {
 
 extern struct srcu_struct fanotify_grp_srcu_struct;
 extern struct list_head fanotify_groups;
+extern void fanotify_evict_group(struct fanotify_group *group);
 
 extern int fanotify_check_notif_queue(struct fanotify_group *group);
 extern void fanotify_get_event(struct fanotify_event *event);
diff --git a/fs/notify/group.c b/fs/notify/group.c
index 650f31e..377195c 100644
--- a/fs/notify/group.c
+++ b/fs/notify/group.c
@@ -86,6 +86,10 @@ struct fanotify_group *fanotify_find_group(unsigned int priority, unsigned int g
 
 	group->timeout = 5000;
 
+	group->evicted = 0;
+	spin_lock_init(&group->misbehave_lock);
+	group->misbehave_count = 0;
+
 	/* Do we need to be the first entry? */
 	if (list_empty(&fanotify_groups)) {
 		list_add_rcu(&group->group_list, &fanotify_groups);
@@ -125,11 +129,26 @@ void fanotify_kill_group(struct fanotify_group *group)
 	kfree(group);
 }
 
+/*
+ * called when a group is misbehaving and needs to be kicked out.  group will
+ * not get really cleared up until clients exit, but it won't be able to hurt
+ * the system any more.
+ */
+void fanotify_evict_group(struct fanotify_group *group)
+{
+	mutex_lock(&fanotify_grp_mutex);
+	if (!group->evicted)
+		list_del_rcu(&group->group_list);
+	group->evicted = 1;
+	mutex_unlock(&fanotify_grp_mutex);
+}
+
 void fanotify_put_group(struct fanotify_group *group)
 {
 	mutex_lock(&fanotify_grp_mutex);
 	if (atomic_dec_and_test(&group->refcnt)) {
-		list_del_rcu(&group->group_list);
+		if (!group->evicted)
+			list_del_rcu(&group->group_list);
 		mutex_unlock(&fanotify_grp_mutex);
 
 		synchronize_srcu(&fanotify_grp_srcu_struct);
diff --git a/include/linux/fanotify.h b/include/linux/fanotify.h
index c6a2a3c..7a7bef6 100644
--- a/include/linux/fanotify.h
+++ b/include/linux/fanotify.h
@@ -104,7 +104,8 @@ struct fanotify_so_access {
 struct fanotify_group {
 	struct list_head group_list;	/* list of all groups on the system */
 	unsigned int group_num;		/* the 'name' of the event */
-	unsigned int mask;			/* mask of events this group cares about */
+	unsigned int mask;		/* mask of events this group cares about */
+	unsigned int evicted;		/* 1 if this group has been evicted for misbehaving */
 	atomic_t refcnt;		/* num of processes with a special file open */
 
 	/* needed to send notification to userspace */
@@ -124,6 +125,9 @@ struct fanotify_group {
 
 	unsigned int timeout;		/* timeout to wait for access requests in msec */
 
+	unsigned int misbehave_count;	/* net misbehaviours.  increment on failure, dec on success */
+	spinlock_t misbehave_lock;	/* protect misbehave_count */
+
 	unsigned int priority;		/* order this group should receive msgs.  low first */
 };
 

