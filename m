Return-Path: <linux-kernel-owner+w=401wt.eu-S1754147AbZJYU1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147AbZJYU1F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 16:27:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754117AbZJYU1D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 16:27:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57520 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754114AbZJYU07 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 16:26:59 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 2/5] fsnotify: fsnotify_obtain_group should be
	fsnotify_alloc_group
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: agruen@suse.de
Date: Sun, 25 Oct 2009 16:27:01 -0400
Message-ID: <20091025202701.11501.40246.stgit@paris.rdu.redhat.com>
In-Reply-To: <20091025202655.11501.70437.stgit@paris.rdu.redhat.com>
References: <20091025202655.11501.70437.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fsnotify_obtain_group was intended to be able to find an already existing
group.  Nothing uses that functionality.  This just renames it to
fsnotify_alloc_group so it is clear what it is doing.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/dnotify/dnotify.c      |    2 +-
 fs/notify/group.c                |   10 +++-------
 fs/notify/inotify/inotify_user.c |    2 +-
 include/linux/fsnotify_backend.h |    4 ++--
 kernel/audit_tree.c              |    2 +-
 kernel/audit_watch.c             |    4 ++--
 6 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/fs/notify/dnotify/dnotify.c b/fs/notify/dnotify/dnotify.c
index 8c568a0..9781bcc 100644
--- a/fs/notify/dnotify/dnotify.c
+++ b/fs/notify/dnotify/dnotify.c
@@ -432,7 +432,7 @@ static int __init dnotify_init(void)
 	dnotify_struct_cache = KMEM_CACHE(dnotify_struct, SLAB_PANIC);
 	dnotify_mark_entry_cache = KMEM_CACHE(dnotify_mark_entry, SLAB_PANIC);
 
-	dnotify_group = fsnotify_obtain_group(0, &dnotify_fsnotify_ops);
+	dnotify_group = fsnotify_alloc_group(0, &dnotify_fsnotify_ops);
 	if (IS_ERR(dnotify_group))
 		panic("unable to allocate fsnotify group for dnotify\n");
 	return 0;
diff --git a/fs/notify/group.c b/fs/notify/group.c
index 934860e..1d20d26 100644
--- a/fs/notify/group.c
+++ b/fs/notify/group.c
@@ -162,16 +162,13 @@ void fsnotify_put_group(struct fsnotify_group *group)
 }
 
 /*
- * Either finds an existing group which matches the group_num, mask, and ops or
- * creates a new group and adds it to the global group list.  In either case we
- * take a reference for the group returned.
+ * Create a new fsnotify_group and hold a reference for the group returned.
  */
-struct fsnotify_group *fsnotify_obtain_group(__u32 mask,
-					     const struct fsnotify_ops *ops)
+struct fsnotify_group *fsnotify_alloc_group(__u32 mask,
+					    const struct fsnotify_ops *ops)
 {
 	struct fsnotify_group *group;
 
-	/* very low use, simpler locking if we just always alloc */
 	group = kzalloc(sizeof(struct fsnotify_group), GFP_KERNEL);
 	if (!group)
 		return ERR_PTR(-ENOMEM);
@@ -192,7 +189,6 @@ struct fsnotify_group *fsnotify_obtain_group(__u32 mask,
 
 	mutex_lock(&fsnotify_grp_mutex);
 
-	/* group not found, add a new one */
 	list_add_rcu(&group->group_list, &fsnotify_groups);
 	group->on_group_list = 1;
 	/* being on the fsnotify_groups list holds one num_marks */
diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index 4393043..c0ba6cb 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -709,7 +709,7 @@ static struct fsnotify_group *inotify_new_group(struct user_struct *user, unsign
 {
 	struct fsnotify_group *group;
 
-	group = fsnotify_obtain_group(0, &inotify_fsnotify_ops);
+	group = fsnotify_alloc_group(0, &inotify_fsnotify_ops);
 	if (IS_ERR(group))
 		return group;
 
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 57e503d..7d3c03e 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -305,11 +305,11 @@ static inline void __fsnotify_d_instantiate(struct dentry *dentry, struct inode
 /* must call when a group changes its ->mask */
 extern void fsnotify_recalc_global_mask(void);
 /* get a reference to an existing or create a new group */
-extern struct fsnotify_group *fsnotify_obtain_group(__u32 mask,
+extern struct fsnotify_group *fsnotify_alloc_group(__u32 mask,
 						    const struct fsnotify_ops *ops);
 /* run all marks associated with this group and update group->mask */
 extern void fsnotify_recalc_group_mask(struct fsnotify_group *group);
-/* drop reference on a group from fsnotify_obtain_group */
+/* drop reference on a group from fsnotify_alloc_group */
 extern void fsnotify_put_group(struct fsnotify_group *group);
 
 /* take a reference to an event */
diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
index d9aab73..f8f3ac3 100644
--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@ -976,7 +976,7 @@ static int __init audit_tree_init(void)
 {
 	int i;
 
-	audit_tree_group = fsnotify_obtain_group(0, &audit_tree_ops);
+	audit_tree_group = fsnotify_alloc_group(0, &audit_tree_ops);
 	if (IS_ERR(audit_tree_group))
 		audit_panic("cannot initialize inotify handle for rectree watches");
 
diff --git a/kernel/audit_watch.c b/kernel/audit_watch.c
index 10ec0e2..57898b3 100644
--- a/kernel/audit_watch.c
+++ b/kernel/audit_watch.c
@@ -576,8 +576,8 @@ static const struct fsnotify_ops audit_watch_fsnotify_ops = {
 
 static int __init audit_watch_init(void)
 {
-	audit_watch_group = fsnotify_obtain_group(AUDIT_FS_WATCH,
-						  &audit_watch_fsnotify_ops);
+	audit_watch_group = fsnotify_alloc_group(AUDIT_FS_WATCH,
+						 &audit_watch_fsnotify_ops);
 	if (IS_ERR(audit_watch_group)) {
 		audit_watch_group = NULL;
 		audit_panic("cannot create audit fsnotify group");

