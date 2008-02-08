Return-Path: <linux-kernel-owner+w=401wt.eu-S933975AbYBHBGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933975AbYBHBGj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 20:06:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757830AbYBHBGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 20:06:31 -0500
Received: from mga01.intel.com ([192.55.52.88]:40209 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756873AbYBHBGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 20:06:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,318,1199692800"; 
   d="scan'208";a="515115210"
Date: Thu, 7 Feb 2008 17:05:50 -0800
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "Brown, Len" <len.brown@intel.com>, Adam Belay <abelay@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Andi Kleen <ak@suse.de>
Subject: [PATCH] x86: Simplify cpu_idle_wait
Message-ID: <20080208010550.GA8090@linux-os.sc.intel.com>
References: <1199759244.26343.35.camel@localhost.localdomain> <20080108033329.GI2998@bingen.suse.de> <1199911330.975.3.camel@localhost.localdomain> <B5B0CFF685D7DF46A05CF1678CFB42ED20E00653@orsmsx423.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B5B0CFF685D7DF46A05CF1678CFB42ED20E00653@orsmsx423.amr.corp.intel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Earlier commit 40d6a146629b98d8e322b6f9332b182c7cbff3df
added smp_call_function in cpu_idle_wait() to kick cpus that are in tickless
idle. Looking at cpu_idle_wait code at that time, code seemed to be
over-engineered for a case which is rarely used (while changing idle handler).

Below is a simplified version of cpu_idle_wait, which just makes
a dummy smp_call_function to all cpus, to make them come out of old idle handler
and start using the new idle handler. It eliminates code in the idle loop
to handle cpu_idle_wait.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Index: linux-2.6.25-rc/arch/x86/kernel/process_32.c
===================================================================
--- linux-2.6.25-rc.orig/arch/x86/kernel/process_32.c
+++ linux-2.6.25-rc/arch/x86/kernel/process_32.c
@@ -82,7 +82,6 @@ unsigned long thread_saved_pc(struct tas
  */
 void (*pm_idle)(void);
 EXPORT_SYMBOL(pm_idle);
-static DEFINE_PER_CPU(unsigned int, cpu_idle_state);
 
 void disable_hlt(void)
 {
@@ -181,9 +180,6 @@ void cpu_idle(void)
 		while (!need_resched()) {
 			void (*idle)(void);
 
-			if (__get_cpu_var(cpu_idle_state))
-				__get_cpu_var(cpu_idle_state) = 0;
-
 			check_pgt_cache();
 			rmb();
 			idle = pm_idle;
@@ -208,40 +204,19 @@ static void do_nothing(void *unused)
 {
 }
 
+/*
+ * cpu_idle_wait - Used to ensure that all the CPUs discard old value of
+ * pm_idle and update to new pm_idle value. Required while changing pm_idle
+ * handler on SMP systems.
+ *
+ * Caller must have changed pm_idle to the new value before the call. Old
+ * pm_idle value will not be used by any CPU after the return of this function.
+ */
 void cpu_idle_wait(void)
 {
-	unsigned int cpu, this_cpu = get_cpu();
-	cpumask_t map, tmp = current->cpus_allowed;
-
-	set_cpus_allowed(current, cpumask_of_cpu(this_cpu));
-	put_cpu();
-
-	cpus_clear(map);
-	for_each_online_cpu(cpu) {
-		per_cpu(cpu_idle_state, cpu) = 1;
-		cpu_set(cpu, map);
-	}
-
-	__get_cpu_var(cpu_idle_state) = 0;
-
-	wmb();
-	do {
-		ssleep(1);
-		for_each_online_cpu(cpu) {
-			if (cpu_isset(cpu, map) && !per_cpu(cpu_idle_state, cpu))
-				cpu_clear(cpu, map);
-		}
-		cpus_and(map, map, cpu_online_map);
-		/*
-		 * We waited 1 sec, if a CPU still did not call idle
-		 * it may be because it is in idle and not waking up
-		 * because it has nothing to do.
-		 * Give all the remaining CPUS a kick.
-		 */
-		smp_call_function_mask(map, do_nothing, 0, 0);
-	} while (!cpus_empty(map));
-
-	set_cpus_allowed(current, tmp);
+	smp_mb();
+	/* kick all the CPUs so that they exit out of pm_idle */
+	smp_call_function(do_nothing, NULL, 0, 0);
 }
 EXPORT_SYMBOL_GPL(cpu_idle_wait);
 
Index: linux-2.6.25-rc/arch/x86/kernel/process_64.c
===================================================================
--- linux-2.6.25-rc.orig/arch/x86/kernel/process_64.c
+++ linux-2.6.25-rc/arch/x86/kernel/process_64.c
@@ -64,7 +64,6 @@ EXPORT_SYMBOL(boot_option_idle_override)
  */
 void (*pm_idle)(void);
 EXPORT_SYMBOL(pm_idle);
-static DEFINE_PER_CPU(unsigned int, cpu_idle_state);
 
 static ATOMIC_NOTIFIER_HEAD(idle_notifier);
 
@@ -139,41 +138,19 @@ static void do_nothing(void *unused)
 {
 }
 
+/*
+ * cpu_idle_wait - Used to ensure that all the CPUs discard old value of
+ * pm_idle and update to new pm_idle value. Required while changing pm_idle
+ * handler on SMP systems.
+ *
+ * Caller must have changed pm_idle to the new value before the call. Old
+ * pm_idle value will not be used by any CPU after the return of this function.
+ */
 void cpu_idle_wait(void)
 {
-	unsigned int cpu, this_cpu = get_cpu();
-	cpumask_t map, tmp = current->cpus_allowed;
-
-	set_cpus_allowed(current, cpumask_of_cpu(this_cpu));
-	put_cpu();
-
-	cpus_clear(map);
-	for_each_online_cpu(cpu) {
-		per_cpu(cpu_idle_state, cpu) = 1;
-		cpu_set(cpu, map);
-	}
-
-	__get_cpu_var(cpu_idle_state) = 0;
-
-	wmb();
-	do {
-		ssleep(1);
-		for_each_online_cpu(cpu) {
-			if (cpu_isset(cpu, map) &&
-					!per_cpu(cpu_idle_state, cpu))
-				cpu_clear(cpu, map);
-		}
-		cpus_and(map, map, cpu_online_map);
-		/*
-		 * We waited 1 sec, if a CPU still did not call idle
-		 * it may be because it is in idle and not waking up
-		 * because it has nothing to do.
-		 * Give all the remaining CPUS a kick.
-		 */
-		smp_call_function_mask(map, do_nothing, 0, 0);
-	} while (!cpus_empty(map));
-
-	set_cpus_allowed(current, tmp);
+	smp_mb();
+	/* kick all the CPUs so that they exit out of pm_idle */
+	smp_call_function(do_nothing, NULL, 0, 0);
 }
 EXPORT_SYMBOL_GPL(cpu_idle_wait);
 
@@ -215,9 +192,6 @@ void cpu_idle (void)
 		while (!need_resched()) {
 			void (*idle)(void);
 
-			if (__get_cpu_var(cpu_idle_state))
-				__get_cpu_var(cpu_idle_state) = 0;
-
 			tick_nohz_stop_sched_tick();
 
 			rmb();
