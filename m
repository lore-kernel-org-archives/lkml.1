Return-Path: <linux-kernel-owner+w=401wt.eu-S1754550AbYKLQN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550AbYKLQN0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 11:13:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752817AbYKLQLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 11:11:34 -0500
Received: from mx2.redhat.com ([66.187.237.31]:45329 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752703AbYKLQL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 11:11:28 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH =-v3 09/21] fanotify: add group priorities
To: linux-kernel@vger.kernel.org, malware-list@lists.printk.net
Cc: viro@zeniv.linux.org.uk, alan@lxorguk.ukuu.org.uk, arjan@infradead.org,
       greg@kroah.com, tytso@mit.edu, akpm@linux-foundation.org
Date: Wed, 12 Nov 2008 11:11:14 -0500
Message-ID: <20081112161114.25434.20865.stgit@paris.rdu.redhat.com>
In-Reply-To: <20081112161002.25434.82358.stgit@paris.rdu.redhat.com>
References: <20081112161002.25434.82358.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preperation for blocking fanotify calls group priorities must be added.
async events will be sent as quickly as possible without waiting for a
response.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/group.c          |   30 ++++++++++++++++++++++++------
 include/linux/fanotify.h   |    5 ++++-
 net/fanotify/af_fanotify.c |    2 +-
 3 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/fs/notify/group.c b/fs/notify/group.c
index 21037cc..37b8630 100644
--- a/fs/notify/group.c
+++ b/fs/notify/group.c
@@ -42,15 +42,16 @@ void fanotify_get_group(struct fanotify_group *group)
 	atomic_inc(&group->refcnt);
 }
 
-struct fanotify_group *fanotify_find_group(unsigned int group_num, unsigned int mask)
+struct fanotify_group *fanotify_find_group(unsigned int priority, unsigned int group_num, unsigned int mask)
 {
 	struct fanotify_group *group_iter;
 	struct fanotify_group *group = NULL;
 
 	mutex_lock(&fanotify_grp_mutex);
 	list_for_each_entry_rcu(group_iter, &fanotify_groups, group_list) {
-		if (group_iter->group_num == group_num) {
-			if (group_iter->mask == mask) {
+		if (group_iter->priority == priority) {
+			if ((group_iter->mask == mask) &&
+			    (group_iter->group_num == group_num)) {
 				fanotify_get_group(group_iter);
 				group = group_iter;
 			} else
@@ -69,6 +70,7 @@ struct fanotify_group *fanotify_find_group(unsigned int group_num, unsigned int
 
 	group->group_num = group_num;
 	group->mask = mask;
+	group->priority = priority;
 
 	mutex_init(&group->notification_mutex);
 	INIT_LIST_HEAD(&group->notification_list);
@@ -77,9 +79,26 @@ struct fanotify_group *fanotify_find_group(unsigned int group_num, unsigned int
 	mutex_init(&group->fastpath_mutex);
 	INIT_LIST_HEAD(&group->fastpath_entries);
 
-	/* add it */
-	list_add_rcu(&group->group_list, &fanotify_groups);
+	/* Do we need to be the first entry? */
+	if (list_empty(&fanotify_groups)) {
+		list_add_rcu(&group->group_list, &fanotify_groups);
+		goto out;
+	}
+
+	list_for_each_entry(group_iter, &fanotify_groups, group_list) {
+		/* insert in front of this one? */
+		if (priority < group_iter->priority) {
+			/* I used list_add_tail() to insert in front of group_iter...  */
+			list_add_tail_rcu(&group->group_list, &group_iter->group_list);
+			break;
+		}
 
+		/* are we at the end?  if so insert at end */
+		if (list_is_last(&group_iter->group_list, &fanotify_groups)) {
+			list_add_tail_rcu(&group->group_list, &fanotify_groups);
+			break;
+		}
+	}
 out:
 	mutex_unlock(&fanotify_grp_mutex);
 	return group;
@@ -100,7 +119,6 @@ void fanotify_put_group(struct fanotify_group *group)
 {
 	mutex_lock(&fanotify_grp_mutex);
 	if (atomic_dec_and_test(&group->refcnt)) {
-
 		list_del_rcu(&group->group_list);
 		mutex_unlock(&fanotify_grp_mutex);
 
diff --git a/include/linux/fanotify.h b/include/linux/fanotify.h
index 0646840..ae16b17 100644
--- a/include/linux/fanotify.h
+++ b/include/linux/fanotify.h
@@ -37,6 +37,7 @@
 #include <linux/types.h>
 
 struct fanotify_addr {
+	__u32 priority;
         __u32 group_num;
         __u32 mask;
         __u32 timeout;
@@ -84,6 +85,8 @@ struct fanotify_group {
 	/* stores all fastapth entries assoc with this group so they can be cleaned on unregister */
 	struct mutex fastpath_mutex;	/* protect fastpath_entries list */
 	struct list_head fastpath_entries; /* all fastpath entries for this group */
+
+	unsigned int priority;		/* order this group should receive msgs.  low first */
 };
 
 #ifdef CONFIG_FANOTIFY
@@ -92,7 +95,7 @@ extern void fanotify(struct file *file, unsigned int mask);
 extern void fanotify_inode_delete(struct inode *inode);
 
 extern void fanotify_get_group(struct fanotify_group *group);
-extern struct fanotify_group *fanotify_find_group(unsigned int group_num, unsigned int mask);
+extern struct fanotify_group *fanotify_find_group(unsigned int priority, unsigned int group_num, unsigned int mask);
 extern void fanotify_put_group(struct fanotify_group *group);
 
 /* things called from the socket */
diff --git a/net/fanotify/af_fanotify.c b/net/fanotify/af_fanotify.c
index 6f2357c..3b7283e 100644
--- a/net/fanotify/af_fanotify.c
+++ b/net/fanotify/af_fanotify.c
@@ -145,7 +145,7 @@ static int fan_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
 		return -EINVAL;
 
 	fan_sock = fan_sk(sock->sk);
-	fan_sock->group = fanotify_find_group(fan_addr->group_num, fan_addr->mask);
+	fan_sock->group = fanotify_find_group(fan_addr->priority, fan_addr->group_num, fan_addr->mask);
 
 	if (IS_ERR(fan_sock->group))
 		return PTR_ERR(fan_sock->group);

