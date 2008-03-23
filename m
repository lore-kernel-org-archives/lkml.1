Return-Path: <linux-kernel-owner+w=401wt.eu-S1758456AbYCWJN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758456AbYCWJN3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 05:13:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761437AbYCWJC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 05:02:27 -0400
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:52512 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934054AbYCWJCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 05:02:22 -0400
Date: Sun, 23 Mar 2008 14:32:15 +0530
From: Ankita Garg <ankita@in.ibm.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RT] [PATCH] Make scheduler root_domain modular
	(sched_classspecific)
Message-ID: <20080323090215.GA8082@in.ibm.com>
Reply-To: Ankita Garg <ankita@in.ibm.com>
Mail-Followup-To: Ankita Garg <ankita@in.ibm.com>,
	Gregory Haskins <ghaskins@novell.com>,
	linux-rt-users <linux-rt-users@vger.kernel.org>,
	Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <20080322142915.GA9478@in.ibm.com> <47E511D4.BA47.005A.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47E511D4.BA47.005A.0@novell.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gregory,

On Sat, Mar 22, 2008 at 12:04:04PM -0600, Gregory Haskins wrote:
> >>> On Sat, Mar 22, 2008 at 10:29 AM, in message
> <20080322142915.GA9478@in.ibm.com>, Ankita Garg <ankita@in.ibm.com> wrote: 
> > Hello,
> > 
> > Thanks Gregory for clarifying my question on root_domains infrastructure. 
> > What
> > I was effectively mentioning on irc the other day was to make the 
> > root_domain
> > infrastructure modular, ie sched_class specific. Currently, only rt is 
> > making
> > use of this infrasture. Making it modular would enable ease of extension to
> > other sched_classes if required. Trivial patch to that effect.
> > 
> > Patch compile and boot tested.
> 
> Hi Ankita,
>   Very nice, thanks!  Couple of minor nits and further cleanup opportunities inline, but otherwise:
>
> Acked-by: Gregory Haskins <ghaskins@novell.com>
> 
> > 
The changes you have suggested are consistent with what we do for rt_rq
and cfs_rq. Here is the patch with these modifications.
 

Signed-off-by: Ankita Garg <ankita@in.ibm.com> 

Index: linux-2.6.24.3-rt3/kernel/sched.c
===================================================================
--- linux-2.6.24.3-rt3.orig/kernel/sched.c	2008-03-21 22:57:04.000000000 +0530
+++ linux-2.6.24.3-rt3/kernel/sched.c	2008-03-23 14:09:22.000000000 +0530
@@ -337,22 +337,27 @@
  * object.
  *
  */
-struct root_domain {
-	atomic_t refcount;
-	cpumask_t span;
-	cpumask_t online;
 
+struct rt_root_domain {
 	/*
 	 * The "RT overload" flag: it gets set if a CPU has more than
 	 * one runnable RT task.
 	 */
-	cpumask_t rto_mask;
-	atomic_t rto_count;
+	cpumask_t overload_mask;
+	atomic_t overload_count;
 #ifdef CONFIG_SMP
 	struct cpupri cpupri;
 #endif
 };
 
+struct root_domain {
+	atomic_t refcount;
+	cpumask_t span;
+	cpumask_t online;
+
+	struct rt_root_domain rt;
+};
+
 /*
  * By default the system creates a single root-domain with all cpus as
  * members (mimicking the global state we have today).
@@ -6332,7 +6337,7 @@
 	cpus_clear(rd->span);
 	cpus_clear(rd->online);
 
-	cpupri_init(&rd->cpupri);
+	cpupri_init(&rd->rt.cpupri);
 
 }
 
Index: linux-2.6.24.3-rt3/kernel/sched_rt.c
===================================================================
--- linux-2.6.24.3-rt3.orig/kernel/sched_rt.c	2008-03-21 22:57:04.000000000 +0530
+++ linux-2.6.24.3-rt3/kernel/sched_rt.c	2008-03-23 14:12:45.000000000 +0530
@@ -7,12 +7,12 @@
 
 static inline int rt_overloaded(struct rq *rq)
 {
-	return atomic_read(&rq->rd->rto_count);
+	return atomic_read(&rq->rd->rt.overload_count);
 }
 
 static inline void rt_set_overload(struct rq *rq)
 {
-	cpu_set(rq->cpu, rq->rd->rto_mask);
+	cpu_set(rq->cpu, rq->rd->rt.overload_mask);
 	/*
 	 * Make sure the mask is visible before we set
 	 * the overload count. That is checked to determine
@@ -21,14 +21,14 @@
 	 * updated yet.
 	 */
 	wmb();
-	atomic_inc(&rq->rd->rto_count);
+	atomic_inc(&rq->rd->rt.overload_count);
 }
 
 static inline void rt_clear_overload(struct rq *rq)
 {
 	/* the order here really doesn't matter */
-	atomic_dec(&rq->rd->rto_count);
-	cpu_clear(rq->cpu, rq->rd->rto_mask);
+	atomic_dec(&rq->rd->rt.overload_count);
+	cpu_clear(rq->cpu, rq->rd->rt.overload_mask);
 }
 
 static void update_rt_migration(struct rq *rq)
@@ -78,7 +78,7 @@
 #ifdef CONFIG_SMP
 	if (p->prio < rq->rt.highest_prio) {
 		rq->rt.highest_prio = p->prio;
-		cpupri_set(&rq->rd->cpupri, rq->cpu, p->prio);
+		cpupri_set(&rq->rd->rt.cpupri, rq->cpu, p->prio);
 	}
 	if (p->nr_cpus_allowed > 1)
 		rq->rt.rt_nr_migratory++;
@@ -114,7 +114,7 @@
 	}
 
 	if (rq->rt.highest_prio != highest_prio)
-		cpupri_set(&rq->rd->cpupri, rq->cpu, rq->rt.highest_prio);
+		cpupri_set(&rq->rd->rt.cpupri, rq->cpu, rq->rt.highest_prio);
 
 	update_rt_migration(rq);
 #endif /* CONFIG_SMP */
@@ -363,7 +363,7 @@
 {
 	int count;
 
-	count = cpupri_find(&task_rq(task)->rd->cpupri, task, lowest_mask);
+	count = cpupri_find(&task_rq(task)->rd->rt.cpupri, task, lowest_mask);
 
 	/*
 	 * cpupri cannot efficiently tell us how many bits are set, so it only
@@ -599,7 +599,7 @@
 
 	next = pick_next_task_rt(this_rq);
 
-	for_each_cpu_mask(cpu, this_rq->rd->rto_mask) {
+	for_each_cpu_mask(cpu, this_rq->rd->rt.overload_mask) {
 		if (this_cpu == cpu)
 			continue;
 
@@ -763,7 +763,7 @@
 	if (rq->rt.overloaded)
 		rt_set_overload(rq);
 
-	cpupri_set(&rq->rd->cpupri, rq->cpu, rq->rt.highest_prio);
+	cpupri_set(&rq->rd->rt.cpupri, rq->cpu, rq->rt.highest_prio);
 }
 
 /* Assumes rq->lock is held */
@@ -772,7 +772,7 @@
 	if (rq->rt.overloaded)
 		rt_clear_overload(rq);
 
-	cpupri_set(&rq->rd->cpupri, rq->cpu, CPUPRI_INVALID);
+	cpupri_set(&rq->rd->rt.cpupri, rq->cpu, CPUPRI_INVALID);
 }
 
 /*

-- 
Regards,
Ankita Garg (ankita@in.ibm.com)
Linux Technology Center
IBM India Systems & Technology Labs, 
Bangalore, India   
