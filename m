Return-Path: <linux-kernel-owner+w=401wt.eu-S1754713AbZBIVQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbZBIVQk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 16:16:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753969AbZBIVQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 16:16:29 -0500
Received: from mx2.redhat.com ([66.187.237.31]:36388 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753898AbZBIVQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 16:16:28 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH -v1 02/11] fsnotify: add group priorities
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, hch@infradead.org, alan@lxorguk.ukuu.org.uk,
       sfr@canb.auug.org.au, john@johnmccutchan.com, rlove@rlove.org,
       malware-list@lists.printk.net, akpm@linux-foundation.org
Date: Mon, 09 Feb 2009 16:15:32 -0500
Message-ID: <20090209211532.8985.3927.stgit@paris.rdu.redhat.com>
In-Reply-To: <20090209211525.8985.13887.stgit@paris.rdu.redhat.com>
References: <20090209211525.8985.13887.stgit@paris.rdu.redhat.com>
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

 fs/notify/group.c                |   27 ++++++++++++++++++++++-----
 include/linux/fsnotify_backend.h |    3 ++-
 2 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/fs/notify/group.c b/fs/notify/group.c
index a877929..d7cabe5 100644
--- a/fs/notify/group.c
+++ b/fs/notify/group.c
@@ -49,8 +49,21 @@ void fsnotify_recalc_global_mask(void)
 
 static void fsnotify_add_group(struct fsnotify_group *group)
 {
-	list_add_rcu(&group->group_list, &fsnotify_groups);
+	int priority = group->priority;
+	struct fsnotify_group *group_iter;
+
 	group->evicted = 0;
+	list_for_each_entry(group_iter, &fsnotify_groups, group_list) {
+		/* insert in front of this one? */
+		if (priority < group_iter->priority) {
+			/* I used list_add_tail() to insert in front of group_iter...  */
+			list_add_tail_rcu(&group->group_list, &group_iter->group_list);
+			return;
+		}
+	}
+
+	/* apparently we need to be the last entry */
+	list_add_tail_rcu(&group->group_list, &fsnotify_groups);
 }
 
 void fsnotify_get_group(struct fsnotify_group *group)
@@ -98,14 +111,16 @@ void fsnotify_put_group(struct fsnotify_group *group)
 	}
 }
 
-static struct fsnotify_group *fsnotify_find_group(unsigned int group_num, __u64 mask, const struct fsnotify_ops *ops)
+static struct fsnotify_group *fsnotify_find_group(unsigned int priority, unsigned int group_num,
+						  __u64 mask, const struct fsnotify_ops *ops)
 {
 	struct fsnotify_group *group_iter;
 	struct fsnotify_group *group = NULL;
 
 	list_for_each_entry_rcu(group_iter, &fsnotify_groups, group_list) {
-		if (group_iter->group_num == group_num) {
+		if (group_iter->priority == priority) {
 			if ((group_iter->mask == mask) &&
+			    (group_iter->group_num == group_num) &&
 			    (group_iter->ops == ops)) {
 				fsnotify_get_group(group_iter);
 				group = group_iter;
@@ -121,7 +136,8 @@ static struct fsnotify_group *fsnotify_find_group(unsigned int group_num, __u64
  * the allocation and the initialization, but this is only called when notification
  * systems make changes, so why make it more complex?
  */
-struct fsnotify_group *fsnotify_obtain_group(unsigned int group_num, __u64 mask, const struct fsnotify_ops *ops)
+struct fsnotify_group *fsnotify_obtain_group(unsigned int priority, unsigned int group_num,
+					     __u64 mask, const struct fsnotify_ops *ops)
 {
 	struct fsnotify_group *group, *tgroup;
 
@@ -131,13 +147,14 @@ struct fsnotify_group *fsnotify_obtain_group(unsigned int group_num, __u64 mask,
 
 	atomic_set(&group->refcnt, 1);
 
+	group->priority = priority;
 	group->group_num = group_num;
 	group->mask = mask;
 
 	group->ops = ops;
 
 	mutex_lock(&fsnotify_grp_mutex);
-	tgroup = fsnotify_find_group(group_num, mask, ops);
+	tgroup = fsnotify_find_group(priority, group_num, mask, ops);
 	/* we raced and something else inserted the same group */
 	if (tgroup) {
 		mutex_unlock(&fsnotify_grp_mutex);
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 98ffcd6..e156df5 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -86,6 +86,7 @@ struct fsnotify_group {
 
 	const struct fsnotify_ops *ops;	/* how this group handles things */
 
+	unsigned int priority;		/* order this group should receive msgs.  low first */
 	unsigned int evicted	:1;	/* has this group been evicted? */
 
 	/* groups can define private fields here */
@@ -129,7 +130,7 @@ extern void fsnotify(struct inode *to_tell, __u64 mask, void *data, int data_is)
 
 /* called from fsnotify interfaces, such as fanotify or dnotify */
 extern void fsnotify_recalc_global_mask(void);
-extern struct fsnotify_group *fsnotify_obtain_group(unsigned int group_num, __u64 mask, const struct fsnotify_ops *ops);
+extern struct fsnotify_group *fsnotify_obtain_group(unsigned int priority, unsigned int group_num, __u64 mask, const struct fsnotify_ops *ops);
 extern void fsnotify_put_group(struct fsnotify_group *group);
 extern void fsnotify_get_group(struct fsnotify_group *group);
 

