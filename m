Return-Path: <linux-kernel-owner+w=401wt.eu-S932334AbXBNOoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932334AbXBNOoA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 09:44:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932332AbXBNOoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 09:44:00 -0500
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:45415 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932331AbXBNOn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 09:43:59 -0500
Date: Wed, 14 Feb 2007 20:13:50 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: akpm@osdl.org, paulmck@us.ibm.com, mingo@elte.hu
Cc: vatsa@in.ibm.com, dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, oleg@tv-sign.ru, rjw@sisk.pl,
       kiran@scalex86.org
Subject: [RFC PATCH(Experimental) 3/4] Revert changes to sched.c and slab.c
Message-ID: <20070214144350.GC19789@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20070214144031.GA15257@in.ibm.com> <20070214144229.GA19789@in.ibm.com> <20070214144305.GB19789@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070214144305.GB19789@in.ibm.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the per-subsystem hotcpu mutexes from sched and
slab subsystems.

Signed-off-by : Gautham R Shenoy <ego@in.ibm.com>
--
kernel/sched.c |   16 ----------------
 mm/slab.c      |    6 ------
 2 files changed, 22 deletions(-)

Index: hotplug/kernel/sched.c
===================================================================
--- hotplug.orig/kernel/sched.c
+++ hotplug/kernel/sched.c
@@ -280,7 +280,6 @@ struct rq {
 };
 
 static DEFINE_PER_CPU(struct rq, runqueues);
-static DEFINE_MUTEX(sched_hotcpu_mutex);
 
 static inline int cpu_of(struct rq *rq)
 {
@@ -4454,13 +4453,11 @@ long sched_setaffinity(pid_t pid, cpumas
 	struct task_struct *p;
 	int retval;
 
-	mutex_lock(&sched_hotcpu_mutex);
 	read_lock(&tasklist_lock);
 
 	p = find_process_by_pid(pid);
 	if (!p) {
 		read_unlock(&tasklist_lock);
-		mutex_unlock(&sched_hotcpu_mutex);
 		return -ESRCH;
 	}
 
@@ -4487,7 +4484,6 @@ long sched_setaffinity(pid_t pid, cpumas
 
 out_unlock:
 	put_task_struct(p);
-	mutex_unlock(&sched_hotcpu_mutex);
 	return retval;
 }
 
@@ -4544,7 +4540,6 @@ long sched_getaffinity(pid_t pid, cpumas
 	struct task_struct *p;
 	int retval;
 
-	mutex_lock(&sched_hotcpu_mutex);
 	read_lock(&tasklist_lock);
 
 	retval = -ESRCH;
@@ -4560,7 +4555,6 @@ long sched_getaffinity(pid_t pid, cpumas
 
 out_unlock:
 	read_unlock(&tasklist_lock);
-	mutex_unlock(&sched_hotcpu_mutex);
 	if (retval)
 		return retval;
 
@@ -5483,9 +5477,6 @@ migration_call(struct notifier_block *nf
 	struct rq *rq;
 
 	switch (action) {
-	case CPU_LOCK_ACQUIRE:
-		mutex_lock(&sched_hotcpu_mutex);
-		break;
 
 	case CPU_UP_PREPARE:
 		p = kthread_create(migration_thread, hcpu, "migration/%d",cpu);
@@ -5549,9 +5540,6 @@ migration_call(struct notifier_block *nf
 		rq->migration_thread = NULL;
 		break;
 #endif
-	case CPU_LOCK_RELEASE:
-		mutex_unlock(&sched_hotcpu_mutex);
-		break;
 	}
 	return NOTIFY_OK;
 }
@@ -6895,10 +6883,8 @@ int arch_reinit_sched_domains(void)
 {
 	int err;
 
-	mutex_lock(&sched_hotcpu_mutex);
 	detach_destroy_domains(&cpu_online_map);
 	err = arch_init_sched_domains(&cpu_online_map);
-	mutex_unlock(&sched_hotcpu_mutex);
 
 	return err;
 }
@@ -7003,12 +6989,10 @@ void __init sched_init_smp(void)
 {
 	cpumask_t non_isolated_cpus;
 
-	mutex_lock(&sched_hotcpu_mutex);
 	arch_init_sched_domains(&cpu_online_map);
 	cpus_andnot(non_isolated_cpus, cpu_possible_map, cpu_isolated_map);
 	if (cpus_empty(non_isolated_cpus))
 		cpu_set(smp_processor_id(), non_isolated_cpus);
-	mutex_unlock(&sched_hotcpu_mutex);
 	/* XXX: Theoretical race here - CPU may be hotplugged now */
 	hotcpu_notifier(update_sched_domains, 0);
 
Index: hotplug/mm/slab.c
===================================================================
--- hotplug.orig/mm/slab.c
+++ hotplug/mm/slab.c
@@ -1179,9 +1179,6 @@ static int __cpuinit cpuup_callback(stru
 	int memsize = sizeof(struct kmem_list3);
 
 	switch (action) {
-	case CPU_LOCK_ACQUIRE:
-		mutex_lock(&cache_chain_mutex);
-		break;
 	case CPU_UP_PREPARE:
 		/*
 		 * We need to do this right in the beginning since
@@ -1342,9 +1339,6 @@ free_array_cache:
 			drain_freelist(cachep, l3, l3->free_objects);
 		}
 		break;
-	case CPU_LOCK_RELEASE:
-		mutex_unlock(&cache_chain_mutex);
-		break;
 	}
 	return NOTIFY_OK;
 bad:
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
