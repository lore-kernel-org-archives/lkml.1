Return-Path: <linux-kernel-owner+w=401wt.eu-S1757430AbZEJWKD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430AbZEJWKD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 18:10:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756541AbZEJWH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 18:07:29 -0400
Received: from smtp-out.google.com ([216.239.45.13]:10318 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756446AbZEJWH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 18:07:27 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=GldN3vtWjdZQA7qZUOZ/5KjShfUlKWYn1nlLZMuABmSTlW16mZNeW65h4G8GvcFdB
	mbGiqEiXHk34g2Kc66A5A==
Date: Sun, 10 May 2009 15:07:23 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Mel Gorman <mel@csn.ul.ie>, Peter Ziljstra <a.p.ziljstra@chello.nl>,
       Christoph Lameter <cl@linux-foundation.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, San Mehat <san@android.com>,
       =?UTF-8?Q?Arve_Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
       linux-kernel@vger.kernel.org
Subject: [patch 09/11 -mmotm] oom: return vm size of oom killed task
In-Reply-To: <alpine.DEB.2.00.0905101458430.18804@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.0905101502270.18804@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0905101458430.18804@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's not optimal to continuously loop in the page allocator if the oom
killer fails to kill a task.  Thus, it's necessary to report how many
pages may be freed when the task finally exits to determine if any
progress has been made.

This also changes the TIF_MEMDIE exception in select_bad_process().  If
a task is found with this thread flag set, yet it has already detached
its memory, then an additional task is chosen since we are still out of
memory.

total_vm is used instead of the file and anon rss since this is what the
badness scoring heuristic is based on and it may be possible to oom kill
a task with no rss causing the page allocator to believe no progress has
been made.

Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 include/linux/oom.h |    3 +-
 mm/oom_kill.c       |   76 +++++++++++++++++++++++++++++++++++---------------
 2 files changed, 55 insertions(+), 24 deletions(-)

diff --git a/include/linux/oom.h b/include/linux/oom.h
--- a/include/linux/oom.h
+++ b/include/linux/oom.h
@@ -26,7 +26,8 @@ enum oom_constraint {
 extern int try_set_zone_oom(struct zonelist *zonelist, gfp_t gfp_flags);
 extern void clear_zonelist_oom(struct zonelist *zonelist, gfp_t gfp_flags);
 
-extern void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask, int order);
+extern unsigned long out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
+				   int order);
 extern int register_oom_notifier(struct notifier_block *nb);
 extern int unregister_oom_notifier(struct notifier_block *nb);
 
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -204,12 +204,13 @@ static inline enum oom_constraint constrained_alloc(struct zonelist *zonelist,
  * (not docbooked, we don't want this one cluttering up the manual)
  */
 static struct task_struct *select_bad_process(unsigned long *ppoints,
-						struct mem_cgroup *mem)
+				unsigned long *freed, struct mem_cgroup *mem)
 {
 	struct task_struct *g, *p;
 	struct task_struct *chosen = NULL;
 	struct timespec uptime;
 	*ppoints = 0;
+	*freed = 0;
 
 	do_posix_clock_monotonic_gettime(&uptime);
 	do_each_thread(g, p) {
@@ -236,8 +237,14 @@ static struct task_struct *select_bad_process(unsigned long *ppoints,
 		 * blocked waiting for another task which itself is waiting
 		 * for memory. Is there a better alternative?
 		 */
-		if (test_tsk_thread_flag(p, TIF_MEMDIE))
-			return ERR_PTR(-1UL);
+		if (test_tsk_thread_flag(p, TIF_MEMDIE)) {
+			task_lock(p);
+			if (p->mm)
+				*freed = p->mm->total_vm;
+			task_unlock(p);
+			if (*freed)
+				return ERR_PTR(-1UL);
+		}
 
 		/*
 		 * This is in the process of releasing memory so wait for it
@@ -250,8 +257,14 @@ static struct task_struct *select_bad_process(unsigned long *ppoints,
 		 * Otherwise we could get an easy OOM deadlock.
 		 */
 		if (p->flags & PF_EXITING) {
-			if (p != current)
-				return ERR_PTR(-1UL);
+			if (p != current) {
+				task_lock(p);
+				if (p->mm)
+					*freed = p->mm->total_vm;
+				task_unlock(p);
+				if (*freed)
+					return ERR_PTR(-1UL);
+			}
 
 			chosen = p;
 			*ppoints = ULONG_MAX;
@@ -346,7 +359,7 @@ static void __oom_kill_task(struct task_struct *p, int verbose)
 	force_sig(SIGKILL, p);
 }
 
-static int oom_kill_task(struct task_struct *p)
+static int oom_kill_task(struct task_struct *p, unsigned long *freed)
 {
 	struct mm_struct *mm;
 	struct task_struct *g, *q;
@@ -357,6 +370,7 @@ static int oom_kill_task(struct task_struct *p)
 		task_unlock(p);
 		return 1;
 	}
+	*freed = mm->total_vm;
 	task_unlock(p);
 	__oom_kill_task(p, 1);
 
@@ -375,10 +389,12 @@ static int oom_kill_task(struct task_struct *p)
 
 static int oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 			    unsigned long points, struct mem_cgroup *mem,
-			    const char *message)
+			    unsigned long *freed, const char *message)
 {
 	struct task_struct *c;
 
+
+	*freed = 0;
 	if (printk_ratelimit()) {
 		task_lock(current);
 		printk(KERN_WARNING "%s invoked oom-killer: "
@@ -399,8 +415,14 @@ static int oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 	 * its children or threads, just set TIF_MEMDIE so it can die quickly
 	 */
 	if (p->flags & PF_EXITING) {
-		__oom_kill_task(p, 0);
-		return 0;
+		task_lock(p);
+		if (p->mm)
+			*freed = p->mm->total_vm;
+		task_unlock(p);
+		if (*freed) {
+			__oom_kill_task(p, 0);
+			return 0;
+		}
 	}
 
 	printk(KERN_ERR "%s: kill process %d (%s) score %li or a child\n",
@@ -410,28 +432,29 @@ static int oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 	list_for_each_entry(c, &p->children, sibling) {
 		if (c->mm == p->mm)
 			continue;
-		if (!oom_kill_task(c))
+		if (!oom_kill_task(c, freed))
 			return 0;
 	}
-	return oom_kill_task(p);
+	return oom_kill_task(p, freed);
 }
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR
 void mem_cgroup_out_of_memory(struct mem_cgroup *mem, gfp_t gfp_mask)
 {
 	unsigned long points = 0;
+	unsigned long freed;
 	struct task_struct *p;
 
 	read_lock(&tasklist_lock);
 retry:
-	p = select_bad_process(&points, mem);
+	p = select_bad_process(&points, &freed, mem);
 	if (PTR_ERR(p) == -1UL)
 		goto out;
 
 	if (!p)
 		p = current;
 
-	if (oom_kill_process(p, gfp_mask, 0, points, mem,
+	if (oom_kill_process(p, gfp_mask, 0, points, mem, &freed,
 				"Memory cgroup out of memory"))
 		goto retry;
 out:
@@ -506,24 +529,25 @@ void clear_zonelist_oom(struct zonelist *zonelist, gfp_t gfp_mask)
 /*
  * Must be called with tasklist_lock held for read.
  */
-static void __out_of_memory(gfp_t gfp_mask, int order)
+static unsigned long __out_of_memory(gfp_t gfp_mask, int order)
 {
 	struct task_struct *p;
 	unsigned long points;
+	unsigned long freed = 0;
 
 	if (sysctl_oom_kill_allocating_task)
 		if (!oom_kill_process(current, gfp_mask, order, 0, NULL,
-				"Out of memory (oom_kill_allocating_task)"))
-			return;
+			&freed, "Out of memory (oom_kill_allocating_task)"))
+			return freed;
 retry:
 	/*
 	 * Rambo mode: Shoot down a process and hope it solves whatever
 	 * issues we may have.
 	 */
-	p = select_bad_process(&points, NULL);
+	p = select_bad_process(&points, &freed, NULL);
 
 	if (PTR_ERR(p) == -1UL)
-		return;
+		return freed;
 
 	/* Found nothing?!?! Either we hang forever, or we panic. */
 	if (!p) {
@@ -531,9 +555,10 @@ retry:
 		panic("Out of memory and no killable processes...\n");
 	}
 
-	if (oom_kill_process(p, gfp_mask, order, points, NULL,
+	if (oom_kill_process(p, gfp_mask, order, points, NULL, &freed,
 			     "Out of memory"))
 		goto retry;
+	return freed;
 }
 
 /*
@@ -582,8 +607,12 @@ rest_and_return:
  * killing a random task (bad), letting the system crash (worse)
  * OR try to be smart about which process to kill. Note that we
  * don't have to be perfect here, we just have to be good.
+ *
+ * Returns the number of pages that will be freed from a killed
+ * task, if any.
  */
-void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask, int order)
+unsigned long out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
+			    int order)
 {
 	unsigned long freed = 0;
 	enum oom_constraint constraint;
@@ -591,7 +620,7 @@ void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask, int order)
 	blocking_notifier_call_chain(&oom_notify_list, 0, &freed);
 	if (freed > 0)
 		/* Got some memory back in the last second. */
-		return;
+		return freed;
 
 	if (sysctl_panic_on_oom == 2)
 		panic("out of memory. Compulsory panic_on_oom is selected.\n");
@@ -605,7 +634,7 @@ void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask, int order)
 
 	switch (constraint) {
 	case CONSTRAINT_MEMORY_POLICY:
-		oom_kill_process(current, gfp_mask, order, 0, NULL,
+		oom_kill_process(current, gfp_mask, order, 0, NULL, &freed,
 				"No available memory (MPOL_BIND)");
 		break;
 
@@ -614,7 +643,7 @@ void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask, int order)
 			panic("out of memory. panic_on_oom is selected\n");
 		/* Fall-through */
 	case CONSTRAINT_CPUSET:
-		__out_of_memory(gfp_mask, order);
+		freed = __out_of_memory(gfp_mask, order);
 		break;
 	}
 
@@ -626,4 +655,5 @@ void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask, int order)
 	 */
 	if (!test_thread_flag(TIF_MEMDIE))
 		schedule_timeout_uninterruptible(1);
+	return freed;
 }
