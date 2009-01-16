Return-Path: <linux-kernel-owner+w=401wt.eu-S1760587AbZAPDec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760587AbZAPDec (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 22:34:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755171AbZAPDeW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 22:34:22 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57607 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755156AbZAPDeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 22:34:20 -0500
Message-ID: <4970000E.7040902@cn.fujitsu.com>
Date: Fri, 16 Jan 2009 11:33:34 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: miaox@cn.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpuset: fix possible deadlock in async_rebuild_sched_domains
References: <496FEFCA.9050908@cn.fujitsu.com>
In-Reply-To: <496FEFCA.9050908@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


But queuing a work to an other thread is adding some overhead for cpuset.
And a new separate workqueue thread is wasteful, this thread is sleeping
at most time.

This is an effective fix:

This patch add cgroup_queue_defer_work(). And the works will be deferring
processed with cgroup_mutex released. And this patch just add very very
little overhead for cgroup_unlock()'s fast path.

Lai

From: Lai Jiangshan <laijs@cn.fujitsu.com>

Lockdep reported some possible circular locking info when we tested cpuset on
NUMA/fake NUMA box.

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.29-rc1-00224-ga652504 #111
-------------------------------------------------------
bash/2968 is trying to acquire lock:
 (events){--..}, at: [<ffffffff8024c8cd>] flush_work+0x24/0xd8

but task is already holding lock:
 (cgroup_mutex){--..}, at: [<ffffffff8026ad1e>] cgroup_lock_live_group+0x12/0x29

which lock already depends on the new lock.
......
-------------------------------------------------------

Steps to reproduce:
# mkdir /dev/cpuset
# mount -t cpuset xxx /dev/cpuset
# mkdir /dev/cpuset/0
# echo 0 > /dev/cpuset/0/cpus
# echo 0 > /dev/cpuset/0/mems
# echo 1 > /dev/cpuset/0/memory_migrate
# cat /dev/zero > /dev/null &
# echo $! > /dev/cpuset/0/tasks

This is because async_rebuild_sched_domains has the following lock sequence:
run_workqueue(async_rebuild_sched_domains)
	-> do_rebuild_sched_domains -> cgroup_lock

But, attaching tasks when memory_migrate is set has following:
cgroup_lock_live_group(cgroup_tasks_write)
	-> do_migrate_pages -> flush_work

This can be fixed by using a separate workqueue thread.

But queuing a work to an other thread is adding some overhead for cpuset.
And a new separate workqueue thread is wasteful, this thread is sleeping
at most time.

This patch add cgroup_queue_defer_work(). And the works will be deferring
processed with cgroup_mutex released. And this patch just add very very
little overhead for cgroup_unlock()'s fast path.

Reported-by: Miao Xie <miaox@cn.fujitsu.com>
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Max Krasnyansky <maxk@qualcomm.com>
---
 include/linux/cgroup.h |   13 ++++
 kernel/cgroup.c        |  139 ++++++++++++++++++++++++++++++++++---------------
 kernel/cpuset.c        |   28 ++++-----
 3 files changed, 125 insertions(+), 55 deletions(-)
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index e267e62..bb025ad 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -437,6 +437,19 @@ void cgroup_iter_end(struct cgroup *cgrp, struct cgroup_iter *it);
 int cgroup_scan_tasks(struct cgroup_scanner *scan);
 int cgroup_attach_task(struct cgroup *, struct task_struct *);
 
+struct cgroup_defer_work {
+	struct list_head list;
+	void (*func)(struct cgroup_defer_work *);
+};
+
+#define CGROUP_DEFER_WORK(name, function)		\
+	struct cgroup_defer_work name = {		\
+		.list = LIST_HEAD_INIT((name).list),	\
+		.func = (function),			\
+	};
+
+int cgroup_queue_defer_work(struct cgroup_defer_work *defer_work);
+
 #else /* !CONFIG_CGROUPS */
 
 static inline int cgroup_init_early(void) { return 0; }
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index c298310..3036723 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -540,6 +540,7 @@ void cgroup_lock(void)
 	mutex_lock(&cgroup_mutex);
 }
 
+static void cgroup_flush_defer_work_locked(void);
 /**
  * cgroup_unlock - release lock on cgroup changes
  *
@@ -547,9 +548,67 @@ void cgroup_lock(void)
  */
 void cgroup_unlock(void)
 {
+	cgroup_flush_defer_work_locked();
 	mutex_unlock(&cgroup_mutex);
 }
 
+static LIST_HEAD(defer_work_list);
+
+/* flush deferred works with cgroup_mutex released */
+static void cgroup_flush_defer_work_locked(void)
+{
+	static bool running_dely_work;
+
+	if (likely(list_empty(&defer_work_list)))
+		return;
+
+	/*
+	 * Insure it's not recursive and also
+	 * insure deferred works are run orderly.
+	 */
+	if (running_dely_work)
+		return;
+	running_dely_work = true;
+
+	for ( ; ; ) {
+		struct cgroup_defer_work *defer_work;
+
+		defer_work = list_first_entry(&defer_work_list,
+				struct cgroup_defer_work, list);
+		list_del_init(&defer_work->list);
+		mutex_unlock(&cgroup_mutex);
+
+		defer_work->func(defer_work);
+
+		mutex_lock(&cgroup_mutex);
+		if (list_empty(&defer_work_list))
+			break;
+	}
+
+	running_dely_work = false;
+}
+
+/**
+ * cgroup_queue_defer_work - queue a deferred work
+ * @defer_work: work to queue
+ *
+ * Returns 0 if @defer_work was already on the queue, non-zero otherwise.
+ *
+ * Must called when cgroup_mutex held.
+ * The defered work will be run after cgroup_mutex released.
+ */
+int cgroup_queue_defer_work(struct cgroup_defer_work *defer_work)
+{
+	int ret = 0;
+
+	if (list_empty(&defer_work->list)) {
+		list_add_tail(&defer_work->list, &defer_work_list);
+		ret = 1;
+	}
+
+	return ret;
+}
+
 /*
  * A couple of forward declarations required, due to cyclic reference loop:
  * cgroup_mkdir -> cgroup_create -> cgroup_populate_dir ->
@@ -616,7 +675,7 @@ static void cgroup_diput(struct dentry *dentry, struct inode *inode)
 		 * agent */
 		synchronize_rcu();
 
-		mutex_lock(&cgroup_mutex);
+		cgroup_lock();
 		/*
 		 * Release the subsystem state objects.
 		 */
@@ -624,7 +683,7 @@ static void cgroup_diput(struct dentry *dentry, struct inode *inode)
 			ss->destroy(ss, cgrp);
 
 		cgrp->root->number_of_cgroups--;
-		mutex_unlock(&cgroup_mutex);
+		cgroup_unlock();
 
 		/*
 		 * Drop the active superblock reference that we took when we
@@ -761,14 +820,14 @@ static int cgroup_show_options(struct seq_file *seq, struct vfsmount *vfs)
 	struct cgroupfs_root *root = vfs->mnt_sb->s_fs_info;
 	struct cgroup_subsys *ss;
 
-	mutex_lock(&cgroup_mutex);
+	cgroup_lock();
 	for_each_subsys(root, ss)
 		seq_printf(seq, ",%s", ss->name);
 	if (test_bit(ROOT_NOPREFIX, &root->flags))
 		seq_puts(seq, ",noprefix");
 	if (strlen(root->release_agent_path))
 		seq_printf(seq, ",release_agent=%s", root->release_agent_path);
-	mutex_unlock(&cgroup_mutex);
+	cgroup_unlock();
 	return 0;
 }
 
@@ -843,7 +902,7 @@ static int cgroup_remount(struct super_block *sb, int *flags, char *data)
 	struct cgroup_sb_opts opts;
 
 	mutex_lock(&cgrp->dentry->d_inode->i_mutex);
-	mutex_lock(&cgroup_mutex);
+	cgroup_lock();
 
 	/* See what subsystems are wanted */
 	ret = parse_cgroupfs_options(data, &opts);
@@ -867,7 +926,7 @@ static int cgroup_remount(struct super_block *sb, int *flags, char *data)
  out_unlock:
 	if (opts.release_agent)
 		kfree(opts.release_agent);
-	mutex_unlock(&cgroup_mutex);
+	cgroup_unlock();
 	mutex_unlock(&cgrp->dentry->d_inode->i_mutex);
 	return ret;
 }
@@ -1015,7 +1074,7 @@ static int cgroup_get_sb(struct file_system_type *fs_type,
 		inode = sb->s_root->d_inode;
 
 		mutex_lock(&inode->i_mutex);
-		mutex_lock(&cgroup_mutex);
+		cgroup_lock();
 
 		/*
 		 * We're accessing css_set_count without locking
@@ -1026,14 +1085,14 @@ static int cgroup_get_sb(struct file_system_type *fs_type,
 		 */
 		ret = allocate_cg_links(css_set_count, &tmp_cg_links);
 		if (ret) {
-			mutex_unlock(&cgroup_mutex);
+			cgroup_unlock();
 			mutex_unlock(&inode->i_mutex);
 			goto drop_new_super;
 		}
 
 		ret = rebind_subsystems(root, root->subsys_bits);
 		if (ret == -EBUSY) {
-			mutex_unlock(&cgroup_mutex);
+			cgroup_unlock();
 			mutex_unlock(&inode->i_mutex);
 			goto free_cg_links;
 		}
@@ -1068,7 +1127,7 @@ static int cgroup_get_sb(struct file_system_type *fs_type,
 
 		cgroup_populate_dir(root_cgrp);
 		mutex_unlock(&inode->i_mutex);
-		mutex_unlock(&cgroup_mutex);
+		cgroup_unlock();
 	}
 
 	return simple_set_mnt(mnt, sb);
@@ -1094,7 +1153,7 @@ static void cgroup_kill_sb(struct super_block *sb) {
 	BUG_ON(!list_empty(&cgrp->children));
 	BUG_ON(!list_empty(&cgrp->sibling));
 
-	mutex_lock(&cgroup_mutex);
+	cgroup_lock();
 
 	/* Rebind all subsystems back to the default hierarchy */
 	ret = rebind_subsystems(root, 0);
@@ -1118,7 +1177,7 @@ static void cgroup_kill_sb(struct super_block *sb) {
 	list_del(&root->root_list);
 	root_count--;
 
-	mutex_unlock(&cgroup_mutex);
+	cgroup_unlock();
 
 	kfree(root);
 	kill_litter_super(sb);
@@ -1345,9 +1404,9 @@ enum cgroup_filetype {
  */
 bool cgroup_lock_live_group(struct cgroup *cgrp)
 {
-	mutex_lock(&cgroup_mutex);
+	cgroup_lock();
 	if (cgroup_is_removed(cgrp)) {
-		mutex_unlock(&cgroup_mutex);
+		cgroup_unlock();
 		return false;
 	}
 	return true;
@@ -2392,7 +2451,7 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 	 * fs */
 	atomic_inc(&sb->s_active);
 
-	mutex_lock(&cgroup_mutex);
+	cgroup_lock();
 
 	init_cgroup_housekeeping(cgrp);
 
@@ -2427,7 +2486,7 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 	err = cgroup_populate_dir(cgrp);
 	/* If err < 0, we have a half-filled directory - oh well ;) */
 
-	mutex_unlock(&cgroup_mutex);
+	cgroup_unlock();
 	mutex_unlock(&cgrp->dentry->d_inode->i_mutex);
 
 	return 0;
@@ -2444,7 +2503,7 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 			ss->destroy(ss, cgrp);
 	}
 
-	mutex_unlock(&cgroup_mutex);
+	cgroup_unlock();
 
 	/* Release the reference count that we took on the superblock */
 	deactivate_super(sb);
@@ -2550,16 +2609,16 @@ static int cgroup_rmdir(struct inode *unused_dir, struct dentry *dentry)
 
 	/* the vfs holds both inode->i_mutex already */
 
-	mutex_lock(&cgroup_mutex);
+	cgroup_lock();
 	if (atomic_read(&cgrp->count) != 0) {
-		mutex_unlock(&cgroup_mutex);
+		cgroup_unlock();
 		return -EBUSY;
 	}
 	if (!list_empty(&cgrp->children)) {
-		mutex_unlock(&cgroup_mutex);
+		cgroup_unlock();
 		return -EBUSY;
 	}
-	mutex_unlock(&cgroup_mutex);
+	cgroup_unlock();
 
 	/*
 	 * Call pre_destroy handlers of subsys. Notify subsystems
@@ -2567,13 +2626,13 @@ static int cgroup_rmdir(struct inode *unused_dir, struct dentry *dentry)
 	 */
 	cgroup_call_pre_destroy(cgrp);
 
-	mutex_lock(&cgroup_mutex);
+	cgroup_lock();
 	parent = cgrp->parent;
 
 	if (atomic_read(&cgrp->count)
 	    || !list_empty(&cgrp->children)
 	    || !cgroup_clear_css_refs(cgrp)) {
-		mutex_unlock(&cgroup_mutex);
+		cgroup_unlock();
 		return -EBUSY;
 	}
 
@@ -2598,7 +2657,7 @@ static int cgroup_rmdir(struct inode *unused_dir, struct dentry *dentry)
 	set_bit(CGRP_RELEASABLE, &parent->flags);
 	check_for_release(parent);
 
-	mutex_unlock(&cgroup_mutex);
+	cgroup_unlock();
 	return 0;
 }
 
@@ -2752,7 +2811,7 @@ static int proc_cgroup_show(struct seq_file *m, void *v)
 
 	retval = 0;
 
-	mutex_lock(&cgroup_mutex);
+	cgroup_lock();
 
 	for_each_active_root(root) {
 		struct cgroup_subsys *ss;
@@ -2774,7 +2833,7 @@ static int proc_cgroup_show(struct seq_file *m, void *v)
 	}
 
 out_unlock:
-	mutex_unlock(&cgroup_mutex);
+	cgroup_unlock();
 	put_task_struct(tsk);
 out_free:
 	kfree(buf);
@@ -2801,14 +2860,14 @@ static int proc_cgroupstats_show(struct seq_file *m, void *v)
 	int i;
 
 	seq_puts(m, "#subsys_name\thierarchy\tnum_cgroups\tenabled\n");
-	mutex_lock(&cgroup_mutex);
+	cgroup_lock();
 	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
 		struct cgroup_subsys *ss = subsys[i];
 		seq_printf(m, "%s\t%lu\t%d\t%d\n",
 			   ss->name, ss->root->subsys_bits,
 			   ss->root->number_of_cgroups, !ss->disabled);
 	}
-	mutex_unlock(&cgroup_mutex);
+	cgroup_unlock();
 	return 0;
 }
 
@@ -2984,11 +3043,11 @@ int cgroup_clone(struct task_struct *tsk, struct cgroup_subsys *subsys,
 
 	/* First figure out what hierarchy and cgroup we're dealing
 	 * with, and pin them so we can drop cgroup_mutex */
-	mutex_lock(&cgroup_mutex);
+	cgroup_lock();
  again:
 	root = subsys->root;
 	if (root == &rootnode) {
-		mutex_unlock(&cgroup_mutex);
+		cgroup_unlock();
 		return 0;
 	}
 	task_lock(tsk);
@@ -2998,14 +3057,14 @@ int cgroup_clone(struct task_struct *tsk, struct cgroup_subsys *subsys,
 	/* Pin the hierarchy */
 	if (!atomic_inc_not_zero(&parent->root->sb->s_active)) {
 		/* We race with the final deactivate_super() */
-		mutex_unlock(&cgroup_mutex);
+		cgroup_unlock();
 		return 0;
 	}
 
 	/* Keep the cgroup alive */
 	get_css_set(cg);
 	task_unlock(tsk);
-	mutex_unlock(&cgroup_mutex);
+	cgroup_unlock();
 
 	/* Now do the VFS work to create a cgroup */
 	inode = parent->dentry->d_inode;
@@ -3036,7 +3095,7 @@ int cgroup_clone(struct task_struct *tsk, struct cgroup_subsys *subsys,
 	/* The cgroup now exists. Retake cgroup_mutex and check
 	 * that we're still in the same state that we thought we
 	 * were. */
-	mutex_lock(&cgroup_mutex);
+	cgroup_lock();
 	if ((root != subsys->root) ||
 	    (parent != task_cgroup(tsk, subsys->subsys_id))) {
 		/* Aargh, we raced ... */
@@ -3061,14 +3120,14 @@ int cgroup_clone(struct task_struct *tsk, struct cgroup_subsys *subsys,
 
 	/* All seems fine. Finish by moving the task into the new cgroup */
 	ret = cgroup_attach_task(child, tsk);
-	mutex_unlock(&cgroup_mutex);
+	cgroup_unlock();
 
  out_release:
 	mutex_unlock(&inode->i_mutex);
 
-	mutex_lock(&cgroup_mutex);
+	cgroup_lock();
 	put_css_set(cg);
-	mutex_unlock(&cgroup_mutex);
+	cgroup_unlock();
 	deactivate_super(parent->root->sb);
 	return ret;
 }
@@ -3162,7 +3221,7 @@ void __css_put(struct cgroup_subsys_state *css)
 static void cgroup_release_agent(struct work_struct *work)
 {
 	BUG_ON(work != &release_agent_work);
-	mutex_lock(&cgroup_mutex);
+	cgroup_lock();
 	spin_lock(&release_list_lock);
 	while (!list_empty(&release_list)) {
 		char *argv[3], *envp[3];
@@ -3196,16 +3255,16 @@ static void cgroup_release_agent(struct work_struct *work)
 		/* Drop the lock while we invoke the usermode helper,
 		 * since the exec could involve hitting disk and hence
 		 * be a slow process */
-		mutex_unlock(&cgroup_mutex);
+		cgroup_unlock();
 		call_usermodehelper(argv[0], argv, envp, UMH_WAIT_EXEC);
-		mutex_lock(&cgroup_mutex);
+		cgroup_lock();
  continue_free:
 		kfree(pathbuf);
 		kfree(agentbuf);
 		spin_lock(&release_list_lock);
 	}
 	spin_unlock(&release_list_lock);
-	mutex_unlock(&cgroup_mutex);
+	cgroup_unlock();
 }
 
 static int __init cgroup_disable(char *str)
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 647c77a..f2dedb0 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -57,7 +57,6 @@
 #include <asm/uaccess.h>
 #include <asm/atomic.h>
 #include <linux/mutex.h>
-#include <linux/workqueue.h>
 #include <linux/cgroup.h>
 
 /*
@@ -789,7 +788,7 @@ done:
  * to the cpuset pseudo-filesystem, because it cannot be called
  * from code that already holds cgroup_mutex.
  */
-static void do_rebuild_sched_domains(struct work_struct *unused)
+static void do_rebuild_sched_domains(struct cgroup_defer_work *unused)
 {
 	struct sched_domain_attr *attr;
 	struct cpumask *doms;
@@ -808,10 +807,10 @@ static void do_rebuild_sched_domains(struct work_struct *unused)
 	put_online_cpus();
 }
 
-static DECLARE_WORK(rebuild_sched_domains_work, do_rebuild_sched_domains);
+static CGROUP_DEFER_WORK(rebuild_sched_domains_work, do_rebuild_sched_domains);
 
 /*
- * Rebuild scheduler domains, asynchronously via workqueue.
+ * Rebuild scheduler domains, defer it after cgroup_lock released.
  *
  * If the flag 'sched_load_balance' of any cpuset with non-empty
  * 'cpus' changes, or if the 'cpus' allowed changes in any cpuset
@@ -826,19 +825,18 @@ static DECLARE_WORK(rebuild_sched_domains_work, do_rebuild_sched_domains);
  *
  * So in order to avoid an ABBA deadlock, the cpuset code handling
  * these user changes delegates the actual sched domain rebuilding
- * to a separate workqueue thread, which ends up processing the
- * above do_rebuild_sched_domains() function.
+ * to a deferred work queue, and cgroup_unlock() will flush the deferred
+ * work queue and process the above do_rebuild_sched_domains() function.
  */
-static void async_rebuild_sched_domains(void)
+static void defer_rebuild_sched_domains(void)
 {
-	schedule_work(&rebuild_sched_domains_work);
+	cgroup_queue_defer_work(&rebuild_sched_domains_work);
 }
 
 /*
  * Accomplishes the same scheduler domain rebuild as the above
- * async_rebuild_sched_domains(), however it directly calls the
- * rebuild routine synchronously rather than calling it via an
- * asynchronous work thread.
+ * defer_rebuild_sched_domains(), however it directly calls the
+ * rebuild routine synchronously rather than deferring it.
  *
  * This can only be called from code that is not holding
  * cgroup_mutex (not nested in a cgroup_lock() call.)
@@ -965,7 +963,7 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 	heap_free(&heap);
 
 	if (is_load_balanced)
-		async_rebuild_sched_domains();
+		defer_rebuild_sched_domains();
 	return 0;
 }
 
@@ -1191,7 +1189,7 @@ static int update_relax_domain_level(struct cpuset *cs, s64 val)
 		cs->relax_domain_level = val;
 		if (!cpumask_empty(cs->cpus_allowed) &&
 		    is_sched_load_balance(cs))
-			async_rebuild_sched_domains();
+			defer_rebuild_sched_domains();
 	}
 
 	return 0;
@@ -1234,7 +1232,7 @@ static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
 	mutex_unlock(&callback_mutex);
 
 	if (!cpumask_empty(trialcs->cpus_allowed) && balance_flag_changed)
-		async_rebuild_sched_domains();
+		defer_rebuild_sched_domains();
 
 out:
 	free_trial_cpuset(trialcs);
@@ -1821,7 +1819,7 @@ static struct cgroup_subsys_state *cpuset_create(
 /*
  * If the cpuset being removed has its flag 'sched_load_balance'
  * enabled, then simulate turning sched_load_balance off, which
- * will call async_rebuild_sched_domains().
+ * will call defer_rebuild_sched_domains().
  */
 
 static void cpuset_destroy(struct cgroup_subsys *ss, struct cgroup *cont)

