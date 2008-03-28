Return-Path: <linux-kernel-owner+w=401wt.eu-S1758239AbYC1Ca7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758239AbYC1Ca7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 22:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757411AbYC1CaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 22:30:22 -0400
Received: from relay2.sgi.com ([192.48.171.30]:39792 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757370AbYC1CaT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 22:30:19 -0400
Message-Id: <20080328023018.739400000@polaris-admin.engr.sgi.com>
References: <20080328023018.264203000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 27 Mar 2008 19:30:20 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] sched: add new set_cpus_allowed_ptr function v2
Content-Disposition: inline; filename=add-set_cpus_allowed_ptr
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new function that accepts a pointer to the "newly allowed cpus"
cpumask argument.

int set_cpus_allowed_ptr(struct task_struct *p, const cpumask_t *new_mask)

The current set_cpus_allowed() function is modified to use the above
but this does not result in an ABI change.  And with some compiler
optimization help, it may not introduce any additional overhead.

Additionally, to enforce the read only nature of the new_mask arg, the
"const" property is migrated to sub-functions called by set_cpus_allowed.
This silences compiler warnings.

Based on:
	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
	git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git

Signed-off-by: Mike Travis <travis@sgi.com>
---
v2: fixed EXPORT_SYMBOL for set_cpus_allowed_ptr()
---
 include/linux/sched.h |   15 +++++++++++----
 kernel/sched.c        |   16 ++++++++--------
 kernel/sched_rt.c     |    3 ++-
 3 files changed, 21 insertions(+), 13 deletions(-)

--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -891,7 +891,8 @@ struct sched_class {
 	void (*set_curr_task) (struct rq *rq);
 	void (*task_tick) (struct rq *rq, struct task_struct *p, int queued);
 	void (*task_new) (struct rq *rq, struct task_struct *p);
-	void (*set_cpus_allowed)(struct task_struct *p, cpumask_t *newmask);
+	void (*set_cpus_allowed)(struct task_struct *p,
+				 const cpumask_t *newmask);
 
 	void (*join_domain)(struct rq *rq);
 	void (*leave_domain)(struct rq *rq);
@@ -1503,15 +1504,21 @@ static inline void put_task_struct(struc
 #define used_math() tsk_used_math(current)
 
 #ifdef CONFIG_SMP
-extern int set_cpus_allowed(struct task_struct *p, cpumask_t new_mask);
+extern int set_cpus_allowed_ptr(struct task_struct *p,
+				const cpumask_t *new_mask);
 #else
-static inline int set_cpus_allowed(struct task_struct *p, cpumask_t new_mask)
+static inline int set_cpus_allowed_ptr(struct task_struct *p,
+				       const cpumask_t *new_mask)
 {
-	if (!cpu_isset(0, new_mask))
+	if (!cpu_isset(0, *new_mask))
 		return -EINVAL;
 	return 0;
 }
 #endif
+static inline int set_cpus_allowed(struct task_struct *p, cpumask_t new_mask)
+{
+	return set_cpus_allowed_ptr(p, &new_mask);
+}
 
 extern unsigned long long sched_clock(void);
 
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -5601,7 +5601,7 @@ static inline void sched_init_granularit
  * task must not exit() & deallocate itself prematurely. The
  * call is not atomic; no spinlocks may be held.
  */
-int set_cpus_allowed(struct task_struct *p, cpumask_t new_mask)
+int set_cpus_allowed_ptr(struct task_struct *p, const cpumask_t *new_mask)
 {
 	struct migration_req req;
 	unsigned long flags;
@@ -5609,23 +5609,23 @@ int set_cpus_allowed(struct task_struct 
 	int ret = 0;
 
 	rq = task_rq_lock(p, &flags);
-	if (!cpus_intersects(new_mask, cpu_online_map)) {
+	if (!cpus_intersects(*new_mask, cpu_online_map)) {
 		ret = -EINVAL;
 		goto out;
 	}
 
 	if (p->sched_class->set_cpus_allowed)
-		p->sched_class->set_cpus_allowed(p, &new_mask);
+		p->sched_class->set_cpus_allowed(p, new_mask);
 	else {
-		p->cpus_allowed = new_mask;
-		p->rt.nr_cpus_allowed = cpus_weight(new_mask);
+		p->cpus_allowed = *new_mask;
+		p->rt.nr_cpus_allowed = cpus_weight(*new_mask);
 	}
 
 	/* Can the task run on the task's current CPU? If so, we're done */
-	if (cpu_isset(task_cpu(p), new_mask))
+	if (cpu_isset(task_cpu(p), *new_mask))
 		goto out;
 
-	if (migrate_task(p, any_online_cpu(new_mask), &req)) {
+	if (migrate_task(p, any_online_cpu(*new_mask), &req)) {
 		/* Need help from migration thread: drop lock and wait. */
 		task_rq_unlock(rq, &flags);
 		wake_up_process(rq->migration_thread);
@@ -5638,7 +5638,7 @@ out:
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(set_cpus_allowed);
+EXPORT_SYMBOL_GPL(set_cpus_allowed_ptr);
 
 /*
  * Move (not current) task off this cpu, onto dest cpu. We're doing
--- linux-2.6.orig/kernel/sched_rt.c
+++ linux-2.6/kernel/sched_rt.c
@@ -1123,7 +1123,8 @@ move_one_task_rt(struct rq *this_rq, int
 	return 0;
 }
 
-static void set_cpus_allowed_rt(struct task_struct *p, cpumask_t *new_mask)
+static void set_cpus_allowed_rt(struct task_struct *p,
+				const cpumask_t *new_mask)
 {
 	int weight = cpus_weight(*new_mask);
 

-- 
