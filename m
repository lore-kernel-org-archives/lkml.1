Return-Path: <linux-kernel-owner+w=401wt.eu-S1757234AbYDJQzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757234AbYDJQzt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 12:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756259AbYDJQzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 12:55:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:5269 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756252AbYDJQzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 12:55:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,636,1199692800"; 
   d="scan'208";a="314535952"
Date: Thu, 10 Apr 2008 09:49:58 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, "Brown, Len" <len.brown@intel.com>,
       Adam Belay <abelay@novell.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Len Brown <lenb@kernel.org>, rjw@sisk.pl
Subject: Re: [PATCH] x86: Simplify cpu_idle_wait
Message-ID: <20080410164958.GA24586@linux-os.sc.intel.com>
References: <1199759244.26343.35.camel@localhost.localdomain> <B5B0CFF685D7DF46A05CF1678CFB42ED20E00653@orsmsx423.amr.corp.intel.com> <20080208010550.GA8090@linux-os.sc.intel.com> <200802081128.48621.ak@suse.de> <20080208172430.GA8302@linux-os.sc.intel.com> <alpine.LFD.1.00.0802091029400.3145@apollo.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802091029400.3145@apollo.tec.linutronix.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 09, 2008 at 02:33:21AM -0700, Thomas Gleixner wrote:
>    On Fri, 8 Feb 2008, Venki Pallipadi wrote:
> 
>    > On Fri, Feb 08, 2008 at 11:28:48AM +0100, Andi Kleen wrote:
>    > >
>    > > > - set_cpus_allowed(current, tmp);
>    > > > + smp_mb();
>    > > > + /* kick all the CPUs so that they exit out of pm_idle */
>    > > > + smp_call_function(do_nothing, NULL, 0, 0);
>    > >
>    > > I think the last argument (wait) needs to be 1 to make sure it is
>    > > synchronous (for 32/64) Otherwise the patch looks great.
>    >
>    > Yes. Below is the updated patch
> 
>    Applied. Thanks,
> 
>             tglx

thomas/ingo/hpa,

Looks like this patch never made it to mainline.

The earlier patch does not apply cleanly to mainline any more. Below is the
updated patch.

Thanks,
Venki


As a bonus, this patch seems to resolve the bug reported here
http://bugzilla.kernel.org/show_bug.cgi?id=10093

The bug was causing once-in-few-reboots 10-15 sec wait during boot on certain
laptops. 



Earlier commit 40d6a146629b98d8e322b6f9332b182c7cbff3df
added smp_call_function in cpu_idle_wait() to kick cpus that are in tickless
idle. Looking at cpu_idle_wait code at that time, code seemed to be
over-engineered for a case which is rarely used (while changing idle handler).

Below is a simplified version of cpu_idle_wait, which just makes
a dummy smp_call_function to all cpus, to make them come out of old idle handler
and start using the new idle handler. It eliminates code in the idle loop
to handle cpu_idle_wait.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

---
 arch/x86/kernel/process_32.c |   47 ++++++++++---------------------------------
 arch/x86/kernel/process_64.c |   47 ++++++++++---------------------------------
 2 files changed, 22 insertions(+), 72 deletions(-)

Index: linux-2.6/arch/x86/kernel/process_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/process_32.c	2008-03-24 04:40:54.000000000 -0700
+++ linux-2.6/arch/x86/kernel/process_32.c	2008-04-09 10:06:03.000000000 -0700
@@ -82,7 +82,6 @@ unsigned long thread_saved_pc(struct tas
  */
 void (*pm_idle)(void);
 EXPORT_SYMBOL(pm_idle);
-static DEFINE_PER_CPU(unsigned int, cpu_idle_state);
 
 void disable_hlt(void)
 {
@@ -190,9 +189,6 @@ void cpu_idle(void)
 		while (!need_resched()) {
 			void (*idle)(void);
 
-			if (__get_cpu_var(cpu_idle_state))
-				__get_cpu_var(cpu_idle_state) = 0;
-
 			check_pgt_cache();
 			rmb();
 			idle = pm_idle;
@@ -220,40 +216,19 @@ static void do_nothing(void *unused)
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
-		smp_call_function_mask(map, do_nothing, NULL, 0);
-	} while (!cpus_empty(map));
-
-	set_cpus_allowed(current, tmp);
+	smp_mb();
+	/* kick all the CPUs so that they exit out of pm_idle */
+	smp_call_function(do_nothing, NULL, 0, 1);
 }
 EXPORT_SYMBOL_GPL(cpu_idle_wait);
 
Index: linux-2.6/arch/x86/kernel/process_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/process_64.c	2008-03-24 04:40:54.000000000 -0700
+++ linux-2.6/arch/x86/kernel/process_64.c	2008-04-09 10:07:48.000000000 -0700
@@ -63,7 +63,6 @@ EXPORT_SYMBOL(boot_option_idle_override)
  */
 void (*pm_idle)(void);
 EXPORT_SYMBOL(pm_idle);
-static DEFINE_PER_CPU(unsigned int, cpu_idle_state);
 
 static ATOMIC_NOTIFIER_HEAD(idle_notifier);
 
@@ -173,9 +172,6 @@ void cpu_idle(void)
 		while (!need_resched()) {
 			void (*idle)(void);
 
-			if (__get_cpu_var(cpu_idle_state))
-				__get_cpu_var(cpu_idle_state) = 0;
-
 			rmb();
 			idle = pm_idle;
 			if (!idle)
@@ -207,40 +203,19 @@ static void do_nothing(void *unused)
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
+	smp_call_function(do_nothing, NULL, 0, 1);
 }
 EXPORT_SYMBOL_GPL(cpu_idle_wait);
 
