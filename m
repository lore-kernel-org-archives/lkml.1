Return-Path: <linux-kernel-owner+w=401wt.eu-S1759404AbZCSSHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759404AbZCSSHm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 14:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757526AbZCSSG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 14:06:56 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45990 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755435AbZCSSGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 14:06:53 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 03/13] fsnotify: add group priorities
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, hch@infradead.org, alan@lxorguk.ukuu.org.uk,
       sfr@canb.auug.org.au, john@johnmccutchan.com, rlove@rlove.org,
       akpm@linux-foundation.org
Date: Thu, 19 Mar 2009 14:05:08 -0400
Message-ID: <20090319180508.17449.35048.stgit@paris.rdu.redhat.com>
In-Reply-To: <20090319180456.17449.76663.stgit@paris.rdu.redhat.com>
References: <20090319180456.17449.76663.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This introduces an ordering to fnotify groups.  It's most interesting because
an HSM would need to run before a typical access notifier.  And an access
control system would need to run between the two.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/group.c                |   29 ++++++++++++++++++++++-------
 include/linux/fsnotify_backend.h |    4 +++-
 2 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/fs/notify/group.c b/fs/notify/group.c
index 88d040b..dd1d18d 100644
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
 
 static void fsnotify_get_group(struct fsnotify_group *group)
@@ -101,8 +114,8 @@ void fsnotify_put_group(struct fsnotify_group *group)
 	fsnotify_destroy_group(group);
 }
 
-static struct fsnotify_group *fsnotify_find_group(unsigned int group_num, __u32 mask,
-						  const struct fsnotify_ops *ops)
+static struct fsnotify_group *fsnotify_find_group(unsigned int priority, unsigned int group_num,
+						  __u32 mask, const struct fsnotify_ops *ops)
 {
 	struct fsnotify_group *group_iter;
 	struct fsnotify_group *group = NULL;
@@ -110,8 +123,9 @@ static struct fsnotify_group *fsnotify_find_group(unsigned int group_num, __u32
 	BUG_ON(!mutex_is_locked(&fsnotify_grp_mutex));
 
 	list_for_each_entry_rcu(group_iter, &fsnotify_groups, group_list) {
-		if (group_iter->group_num == group_num) {
+		if (group_iter->priority == priority) {
 			if ((group_iter->mask == mask) &&
+			    (group_iter->group_num == group_num) &&
 			    (group_iter->ops == ops)) {
 				fsnotify_get_group(group_iter);
 				group = group_iter;
@@ -131,8 +145,8 @@ static struct fsnotify_group *fsnotify_find_group(unsigned int group_num, __u32
  * the allocation and the initialization, but this is only called when notification
  * systems make changes, so why make it more complex?
  */
-struct fsnotify_group *fsnotify_obtain_group(unsigned int group_num, __u32 mask,
-					     const struct fsnotify_ops *ops)
+struct fsnotify_group *fsnotify_obtain_group(unsigned int priority, unsigned int group_num,
+					     __u32 mask, const struct fsnotify_ops *ops)
 {
 	struct fsnotify_group *group, *tgroup;
 
@@ -142,13 +156,14 @@ struct fsnotify_group *fsnotify_obtain_group(unsigned int group_num, __u32 mask,
 
 	atomic_set(&group->refcnt, 1);
 
+	group->priority = priority;
 	group->group_num = group_num;
 	group->mask = mask;
 
 	group->ops = ops;
 
 	mutex_lock(&fsnotify_grp_mutex);
-	tgroup = fsnotify_find_group(group_num, mask, ops);
+	tgroup = fsnotify_find_group(priority, group_num, mask, ops);
 	if (tgroup) {
 		/* group already exists */
 		mutex_unlock(&fsnotify_grp_mutex);
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 0523333..a349691 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -76,6 +76,7 @@ struct fsnotify_group {
 
 	const struct fsnotify_ops *ops;	/* how this group handles things */
 
+	unsigned int priority;		/* order this group should receive msgs.  low first */
 	unsigned int evicted:1;		/* has this group been evicted? */
 
 	/* groups can define private fields here */
@@ -115,7 +116,8 @@ extern void fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is)
 
 /* called from fsnotify interfaces, such as fanotify or dnotify */
 extern void fsnotify_recalc_global_mask(void);
-extern struct fsnotify_group *fsnotify_obtain_group(unsigned int group_num, __u32 mask, const struct fsnotify_ops *ops);
+extern struct fsnotify_group *fsnotify_obtain_group(unsigned int priority, unsigned int group_num,
+						    __u32 mask, const struct fsnotify_ops *ops);
 extern void fsnotify_put_group(struct fsnotify_group *group);
 
 extern void fsnotify_get_event(struct fsnotify_event *event);

