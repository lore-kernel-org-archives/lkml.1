Return-Path: <linux-kernel-owner+w=401wt.eu-S1755012AbZCNLRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012AbZCNLRv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 07:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754101AbZCNLRa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 07:17:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:47072 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754476AbZCNLR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 07:17:28 -0400
Subject: [PATCH] cpuset: fix cpuset vs PF_THREAD_BOUND weirdness
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: David Rientjes <rientjes@google.com>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, balbir@in.ibm.com,
       menage@google.com, vatsa@linux.vnet.ibm.com,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.0903140233510.457@chino.kir.corp.google.com>
References: <200903122251.n2CMpvpT014007@imap1.linux-foundation.org>
	 <alpine.DEB.2.00.0903121619540.19505@chino.kir.corp.google.com>
	 <20090313134635.GE17927@linux.vnet.ibm.com>
	 <alpine.DEB.2.00.0903131143040.17621@chino.kir.corp.google.com>
	 <20090314092345.GA3339@linux.vnet.ibm.com>
	 <alpine.DEB.2.00.0903140233510.457@chino.kir.corp.google.com>
Content-Type: text/plain
Date: Sat, 14 Mar 2009 12:17:14 +0100
Message-Id: <1237029434.8939.68.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-03-14 at 02:53 -0700, David Rientjes wrote:
> On Sat, 14 Mar 2009, Dhaval Giani wrote:
> 
> > No. I do not agree. PF_THREAD_BOUND is a special case and should be
> > treated as such.
> 
> Userspace has no knowledge of PF_THREAD_BOUND tasks.

FWIW its exposed in /proc/$pid/stat and I know of user-space actually
using it.

> > There already exists an inconsistency. An example on a
> > recent-ish tip kernel.
> > 
> > [root@llm11 cpuset]# mkdir a
> > [root@llm11 cpuset]# echo 3 > a/cpuset.cpus
> > [root@llm11 cpuset]# echo 0 > a/cpuset.mems
> > [root@llm11 cpuset]# echo 12 > a/tasks
> > [root@llm11 cpuset]# cd a/
> > [root@llm11 a]# echo 2 > cpuset.cpus
> > [root@llm11 a]# cat cpuset.cpus
> > 2
> > [root@llm11 a]# taskset -pc 12
> > pid 12's current affinity list: 3
> > [root@llm11 a]#
> > 
> > As per your explanation, it is reasonable to expect that the cpu
> > affinity of pid 12 has now been set to CPU 2 but that is not the
> case.
> > 
> 
> Wrong, I said the consistency is that if a task is successfully attached 
> to a cpuset, then its set of allowed cpus has been altered to conform to 
> the cpuset's settings when it is attached.  Otherwise, it fails.
> 
> In your example, it would now be impossible to attach pid 12 to cpuset `a' 
> if it were not already a member.  The consistency exists at the time a 
> task is _attached_ to a cpuset, not because of its membership.  I think 
> this is where you're misunderstanding the long-standing behavior of 
> cpusets.

David, I'm not sure what you're arguing.

Letting a kernel thread in a subset, but then not letting it back out
again seems really weird to me, esp. since PF_THREAD_BOUND is a fairly
recent thing.

I do feel we need to address this issue because its terribly
counter-intuitive.

Furthermore, I do think Dhaval's patch is on the right path by changing
can_attach to check for a subset and attach to ignore the error on
PF_THREAD_BOUND.

However, I don't think its quite enough, we should furthermore fail
update_cpumask(), when it contains such a PF_THREAD_BOUND task and we're
removing the cpu its bound to from the mask, with -EBUSY.

So let me propose the following patch:

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
Index: linux-2.6/kernel/cpuset.c
===================================================================
--- linux-2.6.orig/kernel/cpuset.c
+++ linux-2.6/kernel/cpuset.c
@@ -884,10 +884,11 @@ static int cpuset_test_cpumask(struct ta
  * We don't need to re-check for the cgroup/cpuset membership, since we're
  * holding cgroup_lock() at this point.
  */
-static void cpuset_change_cpumask(struct task_struct *tsk,
-				  struct cgroup_scanner *scan)
+static int cpuset_change_cpumask(struct task_struct *tsk,
+				 struct cgroup_scanner *scan)
 {
 	set_cpus_allowed_ptr(tsk, ((cgroup_cs(scan->cg))->cpus_allowed));
+	return 0;
 }
 
 /**
@@ -911,9 +912,39 @@ static void update_tasks_cpumask(struct 
 	scan.test_task = cpuset_test_cpumask;
 	scan.process_task = cpuset_change_cpumask;
 	scan.heap = heap;
+
 	cgroup_scan_tasks(&scan);
 }
 
+static int cpuset_test_thread(struct task_struct *tsk,
+			      struct cgroup_scanner *scan)
+{
+	return tsk->flags & PF_THREAD_BOUND;
+}
+
+static int cpuset_validate_thread(struct task_struct *tsk,
+				  struct cgroup_scanner *scan)
+{
+	struct cpumask *new_mask = scan->data;
+
+	if (!cpumask_subset(&tsk->cpus_allowed, new_mask))
+		return -EBUSY;
+
+	return 0;
+}
+
+static int validate_cpumask(struct cpuset *cs, struct cpumask *new_mask)
+{
+	struct cgroup_scanner scan;
+
+	scan.cg = cs->css.cgroup;
+	scan.test_task = cpuset_test_thread;
+	scan.process_task = cpuset_validate_thread;
+	scan.data = new_mask;
+
+	return cgroup_scan_tasks(&scan);
+}
+
 /**
  * update_cpumask - update the cpus_allowed mask of a cpuset and all tasks in it
  * @cs: the cpuset to consider
@@ -954,6 +985,10 @@ static int update_cpumask(struct cpuset 
 	if (cpumask_equal(cs->cpus_allowed, trialcs->cpus_allowed))
 		return 0;
 
+	retval = validate_cpumask(cs, trailcs->cpus_allowed);
+	if (retval < 0)
+		return retval;
+
 	retval = heap_init(&heap, PAGE_SIZE, GFP_KERNEL, NULL);
 	if (retval)
 		return retval;
@@ -1362,7 +1397,7 @@ static int cpuset_can_attach(struct cgro
 
 	if (tsk->flags & PF_THREAD_BOUND) {
 		mutex_lock(&callback_mutex);
-		if (!cpumask_equal(&tsk->cpus_allowed, cs->cpus_allowed))
+		if (!cpumask_subset(&tsk->cpus_allowed, cs->cpus_allowed))
 			ret = -EINVAL;
 		mutex_unlock(&callback_mutex);
 	}
@@ -1388,7 +1423,12 @@ static void cpuset_attach(struct cgroup_
 		mutex_unlock(&callback_mutex);
 	}
 	err = set_cpus_allowed_ptr(tsk, cpus_attach);
-	if (err)
+	/*
+	 * In cpuset_can_attach we confirmed that a PF_THREAD_BOUND's CPUs
+	 * are a subset of the cpuset's. In this case set_cpus_allowed_ptr
+	 * will fail. We are fine with it and ignore that failure.
+	 */
+	if (err & !(tsk->flags & PF_THREAD_BOUND))
 		return;
 
 	from = oldcs->mems_allowed;
Index: linux-2.6/include/linux/cgroup.h
===================================================================
--- linux-2.6.orig/include/linux/cgroup.h
+++ linux-2.6/include/linux/cgroup.h
@@ -316,9 +316,10 @@ struct cftype {
 struct cgroup_scanner {
 	struct cgroup *cg;
 	int (*test_task)(struct task_struct *p, struct cgroup_scanner *scan);
-	void (*process_task)(struct task_struct *p,
+	int (*process_task)(struct task_struct *p,
 			struct cgroup_scanner *scan);
 	struct ptr_heap *heap;
+	struct void *data;
 };
 
 /* Add a new file to the given cgroup directory. Should only be
Index: linux-2.6/kernel/cgroup.c
===================================================================
--- linux-2.6.orig/kernel/cgroup.c
+++ linux-2.6/kernel/cgroup.c
@@ -1980,6 +1980,7 @@ int cgroup_scan_tasks(struct cgroup_scan
 	}
 	cgroup_iter_end(scan->cg, &it);
 
+	retval = 0;
 	if (heap->size) {
 		for (i = 0; i < heap->size; i++) {
 			struct task_struct *q = heap->ptrs[i];
@@ -1988,8 +1989,10 @@ int cgroup_scan_tasks(struct cgroup_scan
 				latest_task = q;
 			}
 			/* Process the task per the caller's callback */
-			scan->process_task(q, scan);
+			retval = scan->process_task(q, scan);
 			put_task_struct(q);
+			if (retval < 0)
+				break;
 		}
 		/*
 		 * If we had to process any tasks at all, scan again
@@ -2002,7 +2005,7 @@ int cgroup_scan_tasks(struct cgroup_scan
 	}
 	if (heap == &tmp_heap)
 		heap_free(&tmp_heap);
-	return 0;
+	return retval;
 }
 
 /*


