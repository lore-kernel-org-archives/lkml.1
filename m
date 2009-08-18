Return-Path: <linux-kernel-owner+w=401wt.eu-S1752550AbZHRX7E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550AbZHRX7E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 19:59:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752476AbZHRX7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 19:59:00 -0400
Received: from smtp-out.google.com ([216.239.33.17]:27997 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbZHRX66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 19:58:58 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:subject:to:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=QosJijKZ8jbJCctmQeIPzuGgc+EBzorbF2iDJ7k1ml/rHNn5Y20SzabVXndCVsCuY
	mCIwzElcg3GbmaQ1mxTKg==
From: Paul Menage <menage@google.com>
Subject: [PATCH 6/8] Lets ss->can_attach and ss->attach do whole threadgroups
	at a time
To: akpm@linux-foundation.org, bblum@andrew.cmu.edu, lizf@cn.fujitsu.com
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Date: Tue, 18 Aug 2009 16:58:38 -0700
Message-ID: <20090818235837.22531.86001.stgit@menage.mtv.corp.google.com>
In-Reply-To: <20090818235059.22531.42618.stgit@menage.mtv.corp.google.com>
References: <20090818235059.22531.42618.stgit@menage.mtv.corp.google.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Blum <bblum@google.com>


Lets ss->can_attach and ss->attach do whole threadgroups at a time

This patch alters the ss->can_attach and ss->attach functions to be able to
deal with a whole threadgroup at a time, for use in cgroup_attach_proc. (This
is a pre-patch to cgroup-procs-writable.patch.)

Currently, new mode of the attach function can only tell the subsystem about
the old cgroup of the threadgroup leader. No subsystem currently needs that
information for each thread that's being moved, but if one were to be added
(for example, one that counts tasks within a group) this bit would need to be
reworked a bit to tell the subsystem the right information.

Signed-off-by: Ben Blum <bblum@google.com>
Signed-off-by: Paul Menage <menage@google.com>

---

 Documentation/cgroups/cgroups.txt |   12 +++++--
 include/linux/cgroup.h            |    7 ++--
 kernel/cgroup.c                   |    4 +-
 kernel/cgroup_freezer.c           |   15 ++++++++
 kernel/cpuset.c                   |   66 +++++++++++++++++++++++++++++--------
 kernel/ns_cgroup.c                |   16 ++++++++-
 kernel/sched.c                    |   35 ++++++++++++++++++--
 mm/memcontrol.c                   |    3 +-
 security/device_cgroup.c          |    3 +-
 9 files changed, 131 insertions(+), 30 deletions(-)

diff --git a/Documentation/cgroups/cgroups.txt b/Documentation/cgroups/cgroups.txt
index 4bccfc1..455d4e6 100644
--- a/Documentation/cgroups/cgroups.txt
+++ b/Documentation/cgroups/cgroups.txt
@@ -521,7 +521,7 @@ rmdir() will fail with it. From this behavior, pre_destroy() can be
 called multiple times against a cgroup.
 
 int can_attach(struct cgroup_subsys *ss, struct cgroup *cgrp,
-	       struct task_struct *task)
+	       struct task_struct *task, bool threadgroup)
 (cgroup_mutex held by caller)
 
 Called prior to moving a task into a cgroup; if the subsystem
@@ -529,14 +529,20 @@ returns an error, this will abort the attach operation.  If a NULL
 task is passed, then a successful result indicates that *any*
 unspecified task can be moved into the cgroup. Note that this isn't
 called on a fork. If this method returns 0 (success) then this should
-remain valid while the caller holds cgroup_mutex.
+remain valid while the caller holds cgroup_mutex. If threadgroup is
+true, then a successful result indicates that all threads in the given
+thread's threadgroup can be moved together.
 
 void attach(struct cgroup_subsys *ss, struct cgroup *cgrp,
-	    struct cgroup *old_cgrp, struct task_struct *task)
+	    struct cgroup *old_cgrp, struct task_struct *task,
+	    bool threadgroup)
 (cgroup_mutex held by caller)
 
 Called after the task has been attached to the cgroup, to allow any
 post-attachment activity that requires memory allocations or blocking.
+If threadgroup is true, the subsystem should take care of all threads
+in the specified thread's threadgroup. Currently does not support any
+subsystem that might need the old_cgrp for every thread in the group.
 
 void fork(struct cgroup_subsy *ss, struct task_struct *task)
 
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 3ac78a2..b62bb92 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -425,10 +425,11 @@ struct cgroup_subsys {
 						  struct cgroup *cgrp);
 	int (*pre_destroy)(struct cgroup_subsys *ss, struct cgroup *cgrp);
 	void (*destroy)(struct cgroup_subsys *ss, struct cgroup *cgrp);
-	int (*can_attach)(struct cgroup_subsys *ss,
-			  struct cgroup *cgrp, struct task_struct *tsk);
+	int (*can_attach)(struct cgroup_subsys *ss, struct cgroup *cgrp,
+			  struct task_struct *tsk, bool threadgroup);
 	void (*attach)(struct cgroup_subsys *ss, struct cgroup *cgrp,
-			struct cgroup *old_cgrp, struct task_struct *tsk);
+			struct cgroup *old_cgrp, struct task_struct *tsk,
+			bool threadgroup);
 	void (*fork)(struct cgroup_subsys *ss, struct task_struct *task);
 	void (*exit)(struct cgroup_subsys *ss, struct task_struct *task);
 	int (*populate)(struct cgroup_subsys *ss,
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 9f9e154..fb3ba27 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1552,7 +1552,7 @@ int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
 
 	for_each_subsys(root, ss) {
 		if (ss->can_attach) {
-			retval = ss->can_attach(ss, cgrp, tsk);
+			retval = ss->can_attach(ss, cgrp, tsk, false);
 			if (retval)
 				return retval;
 		}
@@ -1590,7 +1590,7 @@ int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
 
 	for_each_subsys(root, ss) {
 		if (ss->attach)
-			ss->attach(ss, cgrp, oldcgrp, tsk);
+			ss->attach(ss, cgrp, oldcgrp, tsk, false);
 	}
 	set_bit(CGRP_RELEASABLE, &oldcgrp->flags);
 	synchronize_rcu();
diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
index fb249e2..59e9ef6 100644
--- a/kernel/cgroup_freezer.c
+++ b/kernel/cgroup_freezer.c
@@ -159,7 +159,7 @@ static bool is_task_frozen_enough(struct task_struct *task)
  */
 static int freezer_can_attach(struct cgroup_subsys *ss,
 			      struct cgroup *new_cgroup,
-			      struct task_struct *task)
+			      struct task_struct *task, bool threadgroup)
 {
 	struct freezer *freezer;
 
@@ -177,6 +177,19 @@ static int freezer_can_attach(struct cgroup_subsys *ss,
 	if (freezer->state == CGROUP_FROZEN)
 		return -EBUSY;
 
+	if (threadgroup) {
+		struct task_struct *c;
+
+		rcu_read_lock();
+		list_for_each_entry_rcu(c, &task->thread_group, thread_group) {
+			if (is_task_frozen_enough(c)) {
+				rcu_read_unlock();
+				return -EBUSY;
+			}
+		}
+		rcu_read_unlock();
+	}
+
 	return 0;
 }
 
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 7e75a41..b5cb469 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1324,9 +1324,10 @@ static int fmeter_getrate(struct fmeter *fmp)
 static cpumask_var_t cpus_attach;
 
 /* Called by cgroups to determine if a cpuset is usable; cgroup_mutex held */
-static int cpuset_can_attach(struct cgroup_subsys *ss,
-			     struct cgroup *cont, struct task_struct *tsk)
+static int cpuset_can_attach(struct cgroup_subsys *ss, struct cgroup *cont,
+			     struct task_struct *tsk, bool threadgroup)
 {
+	int ret;
 	struct cpuset *cs = cgroup_cs(cont);
 
 	if (cpumask_empty(cs->cpus_allowed) || nodes_empty(cs->mems_allowed))
@@ -1343,18 +1344,51 @@ static int cpuset_can_attach(struct cgroup_subsys *ss,
 	if (tsk->flags & PF_THREAD_BOUND)
 		return -EINVAL;
 
-	return security_task_setscheduler(tsk, 0, NULL);
+	ret = security_task_setscheduler(tsk, 0, NULL);
+	if (ret)
+		return ret;
+	if (threadgroup) {
+		struct task_struct *c;
+
+		rcu_read_lock();
+		list_for_each_entry_rcu(c, &tsk->thread_group, thread_group) {
+			ret = security_task_setscheduler(c, 0, NULL);
+			if (ret) {
+				rcu_read_unlock();
+				return ret;
+			}
+		}
+		rcu_read_unlock();
+	}
+	return 0;
+}
+
+static void cpuset_attach_task(struct task_struct *tsk, nodemask_t *to,
+			       struct cpuset *cs)
+{
+	int err;
+	/*
+	 * can_attach beforehand should guarantee that this doesn't fail.
+	 * TODO: have a better way to handle failure here
+	 */
+	err = set_cpus_allowed_ptr(tsk, cpus_attach);
+	WARN_ON_ONCE(err);
+
+	task_lock(tsk);
+	cpuset_change_task_nodemask(tsk, to);
+	task_unlock(tsk);
+	cpuset_update_task_spread_flag(cs, tsk);
+
 }
 
-static void cpuset_attach(struct cgroup_subsys *ss,
-			  struct cgroup *cont, struct cgroup *oldcont,
-			  struct task_struct *tsk)
+static void cpuset_attach(struct cgroup_subsys *ss, struct cgroup *cont,
+			  struct cgroup *oldcont, struct task_struct *tsk,
+			  bool threadgroup)
 {
 	nodemask_t from, to;
 	struct mm_struct *mm;
 	struct cpuset *cs = cgroup_cs(cont);
 	struct cpuset *oldcs = cgroup_cs(oldcont);
-	int err;
 
 	if (cs == &top_cpuset) {
 		cpumask_copy(cpus_attach, cpu_possible_mask);
@@ -1363,15 +1397,19 @@ static void cpuset_attach(struct cgroup_subsys *ss,
 		guarantee_online_cpus(cs, cpus_attach);
 		guarantee_online_mems(cs, &to);
 	}
-	err = set_cpus_allowed_ptr(tsk, cpus_attach);
-	if (err)
-		return;
 
-	task_lock(tsk);
-	cpuset_change_task_nodemask(tsk, &to);
-	task_unlock(tsk);
-	cpuset_update_task_spread_flag(cs, tsk);
+	/* do per-task migration stuff possibly for each in the threadgroup */
+	cpuset_attach_task(tsk, &to, cs);
+	if (threadgroup) {
+		struct task_struct *c;
+		rcu_read_lock();
+		list_for_each_entry_rcu(c, &tsk->thread_group, thread_group) {
+			cpuset_attach_task(c, &to, cs);
+		}
+		rcu_read_unlock();
+	}
 
+	/* change mm; only needs to be done once even if threadgroup */
 	from = oldcs->mems_allowed;
 	to = cs->mems_allowed;
 	mm = get_task_mm(tsk);
diff --git a/kernel/ns_cgroup.c b/kernel/ns_cgroup.c
index 5aa854f..2a5dfec 100644
--- a/kernel/ns_cgroup.c
+++ b/kernel/ns_cgroup.c
@@ -42,8 +42,8 @@ int ns_cgroup_clone(struct task_struct *task, struct pid *pid)
  *       (hence either you are in the same cgroup as task, or in an
  *        ancestor cgroup thereof)
  */
-static int ns_can_attach(struct cgroup_subsys *ss,
-		struct cgroup *new_cgroup, struct task_struct *task)
+static int ns_can_attach(struct cgroup_subsys *ss, struct cgroup *new_cgroup,
+			 struct task_struct *task, bool threadgroup)
 {
 	if (current != task) {
 		if (!capable(CAP_SYS_ADMIN))
@@ -56,6 +56,18 @@ static int ns_can_attach(struct cgroup_subsys *ss,
 	if (!cgroup_is_descendant(new_cgroup, task))
 		return -EPERM;
 
+	if (threadgroup) {
+		struct task_struct *c;
+		rcu_read_lock();
+		list_for_each_entry_rcu(c, &task->thread_group, thread_group) {
+			if (!cgroup_is_descendant(new_cgroup, c)) {
+				rcu_read_unlock();
+				return -EPERM;
+			}
+		}
+		rcu_read_unlock();
+	}
+
 	return 0;
 }
 
diff --git a/kernel/sched.c b/kernel/sched.c
index a2f8788..b7e3541 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -10336,8 +10336,7 @@ cpu_cgroup_destroy(struct cgroup_subsys *ss, struct cgroup *cgrp)
 }
 
 static int
-cpu_cgroup_can_attach(struct cgroup_subsys *ss, struct cgroup *cgrp,
-		      struct task_struct *tsk)
+cpu_cgroup_can_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
 {
 #ifdef CONFIG_RT_GROUP_SCHED
 	if (!sched_rt_can_attach(cgroup_tg(cgrp), tsk))
@@ -10347,15 +10346,45 @@ cpu_cgroup_can_attach(struct cgroup_subsys *ss, struct cgroup *cgrp,
 	if (tsk->sched_class != &fair_sched_class)
 		return -EINVAL;
 #endif
+	return 0;
+}
 
+static int
+cpu_cgroup_can_attach(struct cgroup_subsys *ss, struct cgroup *cgrp,
+		      struct task_struct *tsk, bool threadgroup)
+{
+	int retval = cpu_cgroup_can_attach_task(cgrp, tsk);
+	if (retval)
+		return retval;
+	if (threadgroup) {
+		struct task_struct *c;
+		rcu_read_lock();
+		list_for_each_entry_rcu(c, &tsk->thread_group, thread_group) {
+			retval = cpu_cgroup_can_attach_task(cgrp, c);
+			if (retval) {
+				rcu_read_unlock();
+				return retval;
+			}
+		}
+		rcu_read_unlock();
+	}
 	return 0;
 }
 
 static void
 cpu_cgroup_attach(struct cgroup_subsys *ss, struct cgroup *cgrp,
-			struct cgroup *old_cont, struct task_struct *tsk)
+		  struct cgroup *old_cont, struct task_struct *tsk
+		  bool threadgroup)
 {
 	sched_move_task(tsk);
+	if (threadgroup) {
+		struct task_struct *c;
+		rcu_read_lock();
+		list_for_each_entry_rcu(c, &tsk->thread_group, thread_group) {
+			sched_move_task(c);
+		}
+		rcu_read_unlock();
+	}
 }
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4f51885..53498d1 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3128,7 +3128,8 @@ static int mem_cgroup_populate(struct cgroup_subsys *ss,
 static void mem_cgroup_move_task(struct cgroup_subsys *ss,
 				struct cgroup *cont,
 				struct cgroup *old_cont,
-				struct task_struct *p)
+				struct task_struct *p,
+				bool threadgroup)
 {
 	mutex_lock(&memcg_tasklist);
 	/*
diff --git a/security/device_cgroup.c b/security/device_cgroup.c
index b8186ba..6cf8fd2 100644
--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -61,7 +61,8 @@ static inline struct dev_cgroup *task_devcgroup(struct task_struct *task)
 struct cgroup_subsys devices_subsys;
 
 static int devcgroup_can_attach(struct cgroup_subsys *ss,
-		struct cgroup *new_cgroup, struct task_struct *task)
+		struct cgroup *new_cgroup, struct task_struct *task,
+		bool threadgroup)
 {
 	if (current != task && !capable(CAP_SYS_ADMIN))
 			return -EPERM;

