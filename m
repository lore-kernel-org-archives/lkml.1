Return-Path: <linux-kernel-owner+w=401wt.eu-S1754295AbYIKO0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295AbYIKO0W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 10:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752217AbYIKO0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 10:26:13 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61710 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751986AbYIKO0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 10:26:12 -0400
Message-ID: <48C929DF.3050009@cn.fujitsu.com>
Date: Thu, 11 Sep 2008 22:23:27 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH -mm 2/2] cgroup: fold struct cg_cgroup_link into struct
 css_set
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


one struct cg_cgroup_link per link is very waste.
This way need to allocate struct cg_cgroup_link for
(css_set_count * hierarchy_count) times. And it will bring fragments
for memory allocation.

This patch fold struct cg_cgroup_link into struct css_set, use
cgroup_link[hierarchy_id] for every hierarchy's cgroup's link.

This patch removes lots of line of code. remove struct cg_cgroup_link
and corresponding code.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 4f281c5..f4ec055 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -173,18 +173,18 @@ struct css_set {
 	struct list_head tasks;
 
 	/*
-	 * List of cg_cgroup_link objects on link chains from
-	 * cgroups referenced from this css_set. Protected by
-	 * css_set_lock
-	 */
-	struct list_head cg_links;
-
-	/*
 	 * Set of subsystem states, one for each subsystem. This array
 	 * is immutable after creation apart from the init_css_set
 	 * during subsystem registration (at boot time).
 	 */
 	struct cgroup_subsys_state *subsys[CGROUP_SUBSYS_COUNT];
+
+	/*
+	 * List running through cgroup_link[hierarchy_id] associated with a
+	 * cgroup of the corresponding hierarchy, anchored on
+	 * cgroup->css_sets. Protected by css_set_lock.
+	 */
+	struct list_head cgroup_link[CGROUP_SUBSYS_COUNT];
 };
 
 /*
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 4bd5560..6c833d1 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -227,21 +227,6 @@ static void cgroup_release_agent(struct work_struct *work);
 static DECLARE_WORK(release_agent_work, cgroup_release_agent);
 static void check_for_release(struct cgroup *cgrp);
 
-/* Link structure for associating css_set objects with cgroups */
-struct cg_cgroup_link {
-	/*
-	 * List running through cg_cgroup_links associated with a
-	 * cgroup, anchored on cgroup->css_sets
-	 */
-	struct list_head cgrp_link_list;
-	/*
-	 * List running through cg_cgroup_links pointing at a
-	 * single css_set object, anchored on css_set->cg_links
-	 */
-	struct list_head cg_link_list;
-	struct css_set *cg;
-};
-
 /* The default css_set - used by init and its children prior to any
  * hierarchies being mounted. It contains a pointer to the root state
  * for each subsystem. Also used to anchor the list of css_sets. Not
@@ -250,7 +235,6 @@ struct cg_cgroup_link {
  */
 
 static struct css_set init_css_set;
-static struct cg_cgroup_link init_css_set_link;
 
 /* css_set_lock protects the list of css_set objects, and the
  * chain of tasks off each css_set.  Nests outside task->alloc_lock
@@ -304,18 +288,13 @@ static int use_task_css_set_links __read_mostly;
  */
 static void unlink_css_set(struct css_set *cg)
 {
-	struct cg_cgroup_link *link;
-	struct cg_cgroup_link *saved_link;
+	int i;
+	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++)
+		if (!list_empty(&cg->cgroup_link[i]))
+			list_del(&cg->cgroup_link[i]);
 
 	hlist_del(&cg->hlist);
 	css_set_count--;
-
-	list_for_each_entry_safe(link, saved_link, &cg->cg_links,
-				 cg_link_list) {
-		list_del(&link->cg_link_list);
-		list_del(&link->cgrp_link_list);
-		kfree(link);
-	}
 }
 
 static void __put_css_set(struct css_set *cg, int taskexit)
@@ -419,38 +398,6 @@ static struct css_set *find_existing_css_set(
 	return NULL;
 }
 
-static void free_cg_links(struct list_head *tmp)
-{
-	struct cg_cgroup_link *link;
-	struct cg_cgroup_link *saved_link;
-
-	list_for_each_entry_safe(link, saved_link, tmp, cgrp_link_list) {
-		list_del(&link->cgrp_link_list);
-		kfree(link);
-	}
-}
-
-/*
- * allocate_cg_links() allocates "count" cg_cgroup_link structures
- * and chains them on tmp through their cgrp_link_list fields. Returns 0 on
- * success or a negative error
- */
-static int allocate_cg_links(int count, struct list_head *tmp)
-{
-	struct cg_cgroup_link *link;
-	int i;
-	INIT_LIST_HEAD(tmp);
-	for (i = 0; i < count; i++) {
-		link = kmalloc(sizeof(*link), GFP_KERNEL);
-		if (!link) {
-			free_cg_links(tmp);
-			return -ENOMEM;
-		}
-		list_add(&link->cgrp_link_list, tmp);
-	}
-	return 0;
-}
-
 /*
  * find_css_set() takes an existing cgroup group and a
  * cgroup object, and returns a css_set object that's
@@ -465,9 +412,6 @@ static struct css_set *find_css_set(
 	struct cgroup_subsys_state *template[CGROUP_SUBSYS_COUNT];
 	int i;
 
-	struct list_head tmp_cg_links;
-	struct cg_cgroup_link *link;
-
 	struct hlist_head *hhead;
 
 	/* First see if we already have a cgroup group that matches
@@ -485,16 +429,11 @@ static struct css_set *find_css_set(
 	if (!res)
 		return NULL;
 
-	/* Allocate all the cg_cgroup_link objects that we'll need */
-	if (allocate_cg_links(root_count, &tmp_cg_links) < 0) {
-		kfree(res);
-		return NULL;
-	}
-
 	atomic_set(&res->refcount, 1);
-	INIT_LIST_HEAD(&res->cg_links);
 	INIT_LIST_HEAD(&res->tasks);
 	INIT_HLIST_NODE(&res->hlist);
+	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++)
+		INIT_LIST_HEAD(&res->cgroup_link[i]);
 
 	/* Copy the set of subsystem state objects generated in
 	 * find_existing_css_set() */
@@ -512,28 +451,15 @@ static struct css_set *find_css_set(
 		 * hierarchy
 		 */
 		if (ss->root->subsys_list.next == &ss->sibling) {
-			BUG_ON(list_empty(&tmp_cg_links));
-			link = list_entry(tmp_cg_links.next,
-					  struct cg_cgroup_link,
-					  cgrp_link_list);
-			list_del(&link->cgrp_link_list);
-			list_add(&link->cgrp_link_list, &cgrp->css_sets);
-			link->cg = res;
-			list_add(&link->cg_link_list, &res->cg_links);
+			list_add(&res->cgroup_link[ss->root->hierarchy_id],
+					&cgrp->css_sets);
 		}
 	}
 	if (list_empty(&rootnode.subsys_list)) {
-		link = list_entry(tmp_cg_links.next,
-				  struct cg_cgroup_link,
-				  cgrp_link_list);
-		list_del(&link->cgrp_link_list);
-		list_add(&link->cgrp_link_list, &dummytop->css_sets);
-		link->cg = res;
-		list_add(&link->cg_link_list, &res->cg_links);
+		list_add(&res->cgroup_link[rootnode.hierarchy_id],
+				&dummytop->css_sets);
 	}
 
-	BUG_ON(!list_empty(&tmp_cg_links));
-
 	css_set_count++;
 
 	/* Add this cgroup group to the hash table */
@@ -1019,7 +945,6 @@ static int cgroup_get_sb(struct file_system_type *fs_type,
 	int ret = 0;
 	struct super_block *sb;
 	struct cgroupfs_root *root;
-	struct list_head tmp_cg_links;
 
 	/* First find the desired set of subsystems */
 	ret = parse_cgroupfs_options(data, &opts);
@@ -1072,20 +997,6 @@ static int cgroup_get_sb(struct file_system_type *fs_type,
 		mutex_lock(&inode->i_mutex);
 		mutex_lock(&cgroup_mutex);
 
-		/*
-		 * We're accessing css_set_count without locking
-		 * css_set_lock here, but that's OK - it can only be
-		 * increased by someone holding cgroup_lock, and
-		 * that's us. The worst that can happen is that we
-		 * have some link structures left over
-		 */
-		ret = allocate_cg_links(css_set_count, &tmp_cg_links);
-		if (ret) {
-			mutex_unlock(&cgroup_mutex);
-			mutex_unlock(&inode->i_mutex);
-			goto drop_new_super;
-		}
-
 		ret = rebind_subsystems(root, root->subsys_bits);
 		if (ret == -EBUSY) {
 			mutex_unlock(&cgroup_mutex);
@@ -1112,23 +1023,12 @@ static int cgroup_get_sb(struct file_system_type *fs_type,
 			struct css_set *cg;
 
 			hlist_for_each_entry(cg, node, hhead, hlist) {
-				struct cg_cgroup_link *link;
-
-				BUG_ON(list_empty(&tmp_cg_links));
-				link = list_entry(tmp_cg_links.next,
-						  struct cg_cgroup_link,
-						  cgrp_link_list);
-				list_del(&link->cgrp_link_list);
-				link->cg = cg;
-				list_add(&link->cgrp_link_list,
+				list_add(&cg->cgroup_link[root->hierarchy_id],
 					 &root->top_cgroup.css_sets);
-				list_add(&link->cg_link_list, &cg->cg_links);
 			}
 		}
 		write_unlock(&css_set_lock);
 
-		free_cg_links(&tmp_cg_links);
-
 		BUG_ON(!list_empty(&cgrp->sibling));
 		BUG_ON(!list_empty(&cgrp->children));
 		BUG_ON(root->number_of_cgroups != 1);
@@ -1143,7 +1043,6 @@ static int cgroup_get_sb(struct file_system_type *fs_type,
  drop_new_super:
 	up_write(&sb->s_umount);
 	deactivate_super(sb);
-	free_cg_links(&tmp_cg_links);
 	return ret;
 }
 
@@ -1151,8 +1050,7 @@ static void cgroup_kill_sb(struct super_block *sb) {
 	struct cgroupfs_root *root = sb->s_fs_info;
 	struct cgroup *cgrp = &root->top_cgroup;
 	int ret;
-	struct cg_cgroup_link *link;
-	struct cg_cgroup_link *saved_link;
+	struct list_head *pos, *next_save;
 
 	BUG_ON(!root);
 
@@ -1172,13 +1070,8 @@ static void cgroup_kill_sb(struct super_block *sb) {
 	 * root cgroup
 	 */
 	write_lock(&css_set_lock);
-
-	list_for_each_entry_safe(link, saved_link, &cgrp->css_sets,
-				 cgrp_link_list) {
-		list_del(&link->cg_link_list);
-		list_del(&link->cgrp_link_list);
-		kfree(link);
-	}
+	list_for_each_safe(pos, next_save, &cgrp->css_sets)
+		list_del_init(pos);
 	write_unlock(&css_set_lock);
 
 	if (!list_empty(&root->root_list)) {
@@ -1795,12 +1688,12 @@ int cgroup_add_files(struct cgroup *cgrp,
 int cgroup_task_count(const struct cgroup *cgrp)
 {
 	int count = 0;
-	struct cg_cgroup_link *link;
+	int index = cgrp->root->hierarchy_id;
+	struct css_set *cg;
 
 	read_lock(&css_set_lock);
-	list_for_each_entry(link, &cgrp->css_sets, cgrp_link_list) {
-		count += atomic_read(&link->cg->refcount);
-	}
+	list_for_each_entry(cg, &cgrp->css_sets, cgroup_link[index])
+		count += atomic_read(&cg->refcount);
 	read_unlock(&css_set_lock);
 	return count;
 }
@@ -1813,7 +1706,7 @@ static void cgroup_advance_iter(struct cgroup *cgrp,
 					  struct cgroup_iter *it)
 {
 	struct list_head *l = it->cg_link;
-	struct cg_cgroup_link *link;
+	int index = cgrp->root->hierarchy_id;
 	struct css_set *cg;
 
 	/* Advance to the next non-empty css_set */
@@ -1823,8 +1716,7 @@ static void cgroup_advance_iter(struct cgroup *cgrp,
 			it->cg_link = NULL;
 			return;
 		}
-		link = list_entry(l, struct cg_cgroup_link, cgrp_link_list);
-		cg = link->cg;
+		cg = list_entry(l, struct css_set, cgroup_link[index]);
 	} while (list_empty(&cg->tasks));
 	it->cg_link = l;
 	it->task = cg->tasks.next;
@@ -1887,7 +1779,7 @@ struct task_struct *cgroup_iter_next(struct cgroup *cgrp,
 	l = l->next;
 	if (l == &res->cgroups->tasks) {
 		/* We reached the end of this task list - move on to
-		 * the next cg_cgroup_link */
+		 * the next css_set */
 		cgroup_advance_iter(cgrp, it);
 	} else {
 		it->task = l;
@@ -2640,9 +2532,10 @@ int __init cgroup_init_early(void)
 {
 	int i;
 	atomic_set(&init_css_set.refcount, 1);
-	INIT_LIST_HEAD(&init_css_set.cg_links);
 	INIT_LIST_HEAD(&init_css_set.tasks);
 	INIT_HLIST_NODE(&init_css_set.hlist);
+	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++)
+		INIT_LIST_HEAD(&init_css_set.cgroup_link[i]);
 	css_set_count = 1;
 	init_cgroup_root(&rootnode);
 	list_add(&rootnode.root_list, &roots);
@@ -2650,11 +2543,8 @@ int __init cgroup_init_early(void)
 	root_count = 1;
 	init_task.cgroups = &init_css_set;
 
-	init_css_set_link.cg = &init_css_set;
-	list_add(&init_css_set_link.cgrp_link_list,
+	list_add(&init_css_set.cgroup_link[rootnode.hierarchy_id],
 		 &rootnode.top_cgroup.css_sets);
-	list_add(&init_css_set_link.cg_link_list,
-		 &init_css_set.cg_links);
 
 	for (i = 0; i < CSS_SET_TABLE_SIZE; i++)
 		INIT_HLIST_HEAD(&css_set_table[i]);



