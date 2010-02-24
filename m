Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757969Ab0BXUFX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 15:05:23 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:63303 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757743Ab0BXUFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 15:05:19 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: paulmck@linux.vnet.ibm.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com
Subject: [PATCH 03/10] cgroups: __rcu annotations
Date: Wed, 24 Feb 2010 21:03:59 +0100
Message-Id: <1267041846-10469-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1267041846-10469-1-git-send-email-arnd@arndb.de>
References: <1267041846-10469-1-git-send-email-arnd@arndb.de>
In-Reply-To: <20100223180127.GF6700@linux.vnet.ibm.com>
References: <20100223180127.GF6700@linux.vnet.ibm.com>
X-Provags-ID: V01U2FsdGVkX18h8y3UpQuix7UNQ3cjJf9iCV3D9zUl5zsD1RI
 DW+2qbyJ5H+krHSjTKIq2YSWiVALnnlDJQJJBF7zPITSzf47Qi
 UPj9s42WHxQyNd6F3dznA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/cgroup.h |    6 ++--
 include/linux/sched.h  |    2 +-
 kernel/cgroup.c        |   63 +++++++++++++++++++++++++----------------------
 kernel/cpuset.c        |    2 +-
 4 files changed, 38 insertions(+), 35 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 0008dee..832092d 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -66,7 +66,7 @@ struct cgroup_subsys_state {
 
 	unsigned long flags;
 	/* ID for this css, if possible */
-	struct css_id *id;
+	struct css_id __rcu *id;
 };
 
 /* bits in struct cgroup_subsys_state flags field */
@@ -190,7 +190,7 @@ struct cgroup {
 	struct list_head children;	/* my children */
 
 	struct cgroup *parent;		/* my parent */
-	struct dentry *dentry;	  	/* cgroup fs entry, RCU protected */
+	struct dentry __rcu *dentry;	/* cgroup fs entry, RCU protected */
 
 	/* Private pointers for each registered subsystem */
 	struct cgroup_subsys_state *subsys[CGROUP_SUBSYS_COUNT];
@@ -486,7 +486,7 @@ static inline struct cgroup_subsys_state *cgroup_subsys_state(
 static inline struct cgroup_subsys_state *task_subsys_state(
 	struct task_struct *task, int subsys_id)
 {
-	return rcu_dereference(task->cgroups->subsys[subsys_id]);
+	return rcu_dereference(task->cgroups)->subsys[subsys_id];
 }
 
 static inline struct cgroup* task_cgroup(struct task_struct *task,
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 78efe7c..038e16f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1489,7 +1489,7 @@ struct task_struct {
 #endif
 #ifdef CONFIG_CGROUPS
 	/* Control Group info protected by css_set_lock */
-	struct css_set *cgroups;
+	struct css_set __rcu *cgroups;
 	/* cg_list protected by css_set_lock and tsk->alloc_lock */
 	struct list_head cg_list;
 #endif
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index aa3bee5..e0f379e 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -127,7 +127,7 @@ struct css_id {
 	 * is called after synchronize_rcu(). But for safe use, css_is_removed()
 	 * css_tryget() should be used for avoiding race.
 	 */
-	struct cgroup_subsys_state *css;
+	struct cgroup_subsys_state __rcu *css;
 	/*
 	 * ID of this css.
 	 */
@@ -605,7 +605,7 @@ static struct cgroup *task_cgroup_from_root(struct task_struct *task,
 	 * task can't change groups, so the only thing that can happen
 	 * is that it exits and its css is set back to init_css_set.
 	 */
-	css = task->cgroups;
+	css = __rcu_dereference(task->cgroups);
 	if (css == &init_css_set) {
 		res = &root->top_cgroup;
 	} else {
@@ -850,7 +850,7 @@ static void cgroup_d_remove_dir(struct dentry *dentry)
  *
  * CGRP_WAIT_ON_RMDIR flag is set under cgroup's inode->i_mutex;
  */
-DECLARE_WAIT_QUEUE_HEAD(cgroup_rmdir_waitq);
+static DECLARE_WAIT_QUEUE_HEAD(cgroup_rmdir_waitq);
 
 static void cgroup_wakeup_rmdir_waiter(struct cgroup *cgrp)
 {
@@ -1081,9 +1081,11 @@ static int cgroup_remount(struct super_block *sb, int *flags, char *data)
 	struct cgroupfs_root *root = sb->s_fs_info;
 	struct cgroup *cgrp = &root->top_cgroup;
 	struct cgroup_sb_opts opts;
+	struct dentry *dentry;
 
 	lock_kernel();
-	mutex_lock(&cgrp->dentry->d_inode->i_mutex);
+	dentry = __rcu_dereference(cgrp->dentry);
+	mutex_lock(&dentry->d_inode->i_mutex);
 	mutex_lock(&cgroup_mutex);
 
 	/* See what subsystems are wanted */
@@ -1116,7 +1118,7 @@ static int cgroup_remount(struct super_block *sb, int *flags, char *data)
 	kfree(opts.release_agent);
 	kfree(opts.name);
 	mutex_unlock(&cgroup_mutex);
-	mutex_unlock(&cgrp->dentry->d_inode->i_mutex);
+	mutex_unlock(&dentry->d_inode->i_mutex);
 	unlock_kernel();
 	return ret;
 }
@@ -1375,7 +1377,7 @@ static int cgroup_get_sb(struct file_system_type *fs_type,
 		root_count++;
 
 		sb->s_root->d_fsdata = root_cgrp;
-		root->top_cgroup.dentry = sb->s_root;
+		__rcu_assign_pointer(root->top_cgroup.dentry, sb->s_root);
 
 		/* Link the top cgroup in this hierarchy into all
 		 * the css_set objects */
@@ -1513,7 +1515,7 @@ int cgroup_path(const struct cgroup *cgrp, char *buf, int buflen)
 		int len = dentry->d_name.len;
 		if ((start -= len) < buf)
 			return -ENAMETOOLONG;
-		memcpy(start, cgrp->dentry->d_name.name, len);
+		memcpy(start, dentry->d_name.name, len);
 		cgrp = cgrp->parent;
 		if (!cgrp)
 			break;
@@ -1559,7 +1561,7 @@ int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
 	}
 
 	task_lock(tsk);
-	cg = tsk->cgroups;
+	cg = __rcu_dereference(tsk->cgroups);
 	get_css_set(cg);
 	task_unlock(tsk);
 	/*
@@ -1986,7 +1988,7 @@ static int cgroup_create_dir(struct cgroup *cgrp, struct dentry *dentry,
 	struct dentry *parent;
 	int error = 0;
 
-	parent = cgrp->parent->dentry;
+	parent = __rcu_dereference(cgrp->parent->dentry);
 	error = cgroup_create_file(dentry, S_IFDIR | mode, cgrp->root->sb);
 	if (!error) {
 		dentry->d_fsdata = cgrp;
@@ -2030,7 +2032,7 @@ int cgroup_add_file(struct cgroup *cgrp,
 		       struct cgroup_subsys *subsys,
 		       const struct cftype *cft)
 {
-	struct dentry *dir = cgrp->dentry;
+	struct dentry *dir = __rcu_dereference(cgrp->dentry);
 	struct dentry *dentry;
 	int error;
 	mode_t mode;
@@ -2135,7 +2137,7 @@ static void cgroup_enable_task_cg_lists(void)
 		 * entry won't be deleted though the process has exited.
 		 */
 		if (!(p->flags & PF_EXITING) && list_empty(&p->cg_list))
-			list_add(&p->cg_list, &p->cgroups->tasks);
+			list_add(&p->cg_list, &__rcu_dereference(p->cgroups)->tasks);
 		task_unlock(p);
 	} while_each_thread(g, p);
 	write_unlock(&css_set_lock);
@@ -2828,7 +2830,7 @@ static int cgroup_populate_dir(struct cgroup *cgrp)
 	struct cgroup_subsys *ss;
 
 	/* First clear out any existing files */
-	cgroup_clear_directory(cgrp->dentry);
+	cgroup_clear_directory(__rcu_dereference(cgrp->dentry));
 
 	err = cgroup_add_files(cgrp, NULL, files, ARRAY_SIZE(files));
 	if (err < 0)
@@ -2852,7 +2854,7 @@ static int cgroup_populate_dir(struct cgroup *cgrp)
 		 * from RCU-read-side without locks.
 		 */
 		if (css->id)
-			rcu_assign_pointer(css->id->css, css);
+			rcu_assign_pointer(__rcu_dereference(css->id)->css, css);
 	}
 
 	return 0;
@@ -2960,13 +2962,13 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 		goto err_remove;
 
 	/* The cgroup directory was pre-locked for us */
-	BUG_ON(!mutex_is_locked(&cgrp->dentry->d_inode->i_mutex));
+	BUG_ON(!mutex_is_locked(&__rcu_dereference(cgrp->dentry)->d_inode->i_mutex));
 
 	err = cgroup_populate_dir(cgrp);
 	/* If err < 0, we have a half-filled directory - oh well ;) */
 
 	mutex_unlock(&cgroup_mutex);
-	mutex_unlock(&cgrp->dentry->d_inode->i_mutex);
+	mutex_unlock(&__rcu_dereference(cgrp->dentry)->d_inode->i_mutex);
 
 	return 0;
 
@@ -3164,8 +3166,8 @@ again:
 	list_del(&cgrp->sibling);
 	cgroup_unlock_hierarchy(cgrp->root);
 
-	spin_lock(&cgrp->dentry->d_lock);
-	d = dget(cgrp->dentry);
+	spin_lock(&__rcu_dereference(cgrp->dentry)->d_lock);
+	d = dget(__rcu_dereference(cgrp->dentry));
 	spin_unlock(&d->d_lock);
 
 	cgroup_d_remove_dir(d);
@@ -3203,7 +3205,7 @@ static void __init cgroup_init_subsys(struct cgroup_subsys *ss)
 	/* At system boot, before all subsystems have been
 	 * registered, no tasks have been forked, so we don't
 	 * need to invoke fork callbacks here. */
-	BUG_ON(!list_empty(&init_task.tasks));
+	BUG_ON(!list_empty_rcu(&init_task.tasks));
 
 	mutex_init(&ss->hierarchy_mutex);
 	lockdep_set_class(&ss->hierarchy_mutex, &ss->subsys_key);
@@ -3226,7 +3228,7 @@ int __init cgroup_init_early(void)
 	css_set_count = 1;
 	init_cgroup_root(&rootnode);
 	root_count = 1;
-	init_task.cgroups = &init_css_set;
+	__rcu_assign_pointer(init_task.cgroups, &init_css_set);
 
 	init_css_set_link.cg = &init_css_set;
 	init_css_set_link.cgrp = dummytop;
@@ -3425,7 +3427,7 @@ void cgroup_fork(struct task_struct *child)
 {
 	task_lock(current);
 	child->cgroups = current->cgroups;
-	get_css_set(child->cgroups);
+	get_css_set(__rcu_dereference(child->cgroups));
 	task_unlock(current);
 	INIT_LIST_HEAD(&child->cg_list);
 }
@@ -3465,7 +3467,8 @@ void cgroup_post_fork(struct task_struct *child)
 		write_lock(&css_set_lock);
 		task_lock(child);
 		if (list_empty(&child->cg_list))
-			list_add(&child->cg_list, &child->cgroups->tasks);
+			list_add(&child->cg_list,
+				 &__rcu_dereference(child->cgroups)->tasks);
 		task_unlock(child);
 		write_unlock(&css_set_lock);
 	}
@@ -3532,8 +3535,8 @@ void cgroup_exit(struct task_struct *tsk, int run_callbacks)
 
 	/* Reassign the task to the init_css_set. */
 	task_lock(tsk);
-	cg = tsk->cgroups;
-	tsk->cgroups = &init_css_set;
+	cg = __rcu_dereference(tsk->cgroups);
+	__rcu_assign_pointer(tsk->cgroups, &init_css_set);
 	task_unlock(tsk);
 	if (cg)
 		put_css_set_taskexit(cg);
@@ -3583,19 +3586,19 @@ int cgroup_clone(struct task_struct *tsk, struct cgroup_subsys *subsys,
 	/* Keep the cgroup alive */
 	task_lock(tsk);
 	parent = task_cgroup(tsk, subsys->subsys_id);
-	cg = tsk->cgroups;
+	cg = __rcu_dereference(tsk->cgroups);
 	get_css_set(cg);
 	task_unlock(tsk);
 
 	mutex_unlock(&cgroup_mutex);
 
 	/* Now do the VFS work to create a cgroup */
-	inode = parent->dentry->d_inode;
+	inode = __rcu_dereference(parent->dentry)->d_inode;
 
 	/* Hold the parent directory mutex across this operation to
 	 * stop anyone else deleting the new cgroup */
 	mutex_lock(&inode->i_mutex);
-	dentry = lookup_one_len(nodename, parent->dentry, strlen(nodename));
+	dentry = lookup_one_len(nodename, __rcu_dereference(parent->dentry), strlen(nodename));
 	if (IS_ERR(dentry)) {
 		printk(KERN_INFO
 		       "cgroup: Couldn't allocate dentry for %s: %ld\n", nodename,
@@ -3864,7 +3867,7 @@ static void __free_css_id_cb(struct rcu_head *head)
 
 void free_css_id(struct cgroup_subsys *ss, struct cgroup_subsys_state *css)
 {
-	struct css_id *id = css->id;
+	struct css_id *id = __rcu_dereference(css->id);
 	/* When this is called before css_id initialization, id can be NULL */
 	if (!id)
 		return;
@@ -3941,8 +3944,8 @@ static int __init cgroup_subsys_init_idr(struct cgroup_subsys *ss)
 		return PTR_ERR(newid);
 
 	newid->stack[0] = newid->id;
-	newid->css = rootcss;
-	rootcss->id = newid;
+	__rcu_assign_pointer(newid->css, rootcss);
+	__rcu_assign_pointer(rootcss->id, newid);
 	return 0;
 }
 
@@ -3957,7 +3960,7 @@ static int alloc_css_id(struct cgroup_subsys *ss, struct cgroup *parent,
 	parent_css = parent->subsys[subsys_id];
 	child_css = child->subsys[subsys_id];
 	depth = css_depth(parent_css) + 1;
-	parent_id = parent_css->id;
+	parent_id = __rcu_dereference(parent_css->id);
 
 	child_id = get_new_cssid(ss, depth);
 	if (IS_ERR(child_id))
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index ba401fa..42d4851 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2434,7 +2434,7 @@ void cpuset_print_task_mems_allowed(struct task_struct *tsk)
 {
 	struct dentry *dentry;
 
-	dentry = task_cs(tsk)->css.cgroup->dentry;
+	dentry = __rcu_dereference(task_cs(tsk)->css.cgroup->dentry);
 	spin_lock(&cpuset_buffer_lock);
 	snprintf(cpuset_name, CPUSET_NAME_LEN,
 		 dentry ? (const char *)dentry->d_name.name : "/");
-- 
1.6.3.3

