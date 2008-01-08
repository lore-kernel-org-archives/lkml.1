Return-Path: <linux-kernel-owner+w=401wt.eu-S1758017AbYAHC2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758017AbYAHC2a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 21:28:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752758AbYAHC2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 21:28:21 -0500
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:55552 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659AbYAHC2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 21:28:20 -0500
Subject: [RFC PATCH] kick sleeping idle CPUS on cpu_idle_wait
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>,
       "Brown, Len" <len.brown@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Adam Belay <abelay@novell.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain
Date: Mon, 07 Jan 2008 21:27:24 -0500
Message-Id: <1199759244.26343.35.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Sometimes cpu_idle_wait gets stuck because it might miss CPUS that are
already in idle, have no tasks waiting to run and have no interrupts
going to them.  This is common on bootup when switching cpu idle
governors.

This patch accounts for CPUs already in idle.

Background:
-----------
I notice this while developing the mcount patches, that every once in a
while the system would hang. Looking deeper, the hang was always at boot
up when registering init_menu of the cpu_idle menu governor. Talking
with Thomas Gliexner, we discovered that one of the CPUS had no timer
events scheduled for it and it was in idle (running with NO_HZ). So the
CPU would not set the cpu_idle_state bit.

Hitting sysrq-t a few times would eventually route the interrupt to the
stuck CPU and the system would continue.

Note, I would have used the PDA isidle but that is set after the
cpu_idle_state bit is cleared, and would leave a window open where we
may miss being kicked.

hmm, looking closer at this, we still have a small race window between
clearing the cpu_idle_state and disabling interrupts (hence the RFC).

    CPU0:                          CPU 1:
  ---------                       ---------
 cpu_idle_wait():                 cpu_idle():
      |                           __cpu_cpu_var(is_idle) = 1;
      |                           if (__get_cpu_var(cpu_idle_state)) /* == 0 */
 per_cpu(cpu_idle_state, 1) = 1;         |
 if (per_cpu(is_idle, 1)) /* == 1 */     |
 smp_call_function(1)                    |
      |                             receives ipi and runs do_nothing.
 wait on map == empty               idle();
   /* waits forever */


So really we need interrupts off for most of this then. One might think
that we could simply clear the cpu_idle_state from do_nothing, but I'm
assuming that cpu_idle governors can be removed, and this might cause a
race that a governor might be used after the module was removed.

One solution I think is that we could keep calling do_nothing to all the
bits of map that are still set in the cpu_idle_wait() loop. That would
work too.

Thoughts?


Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/x86/kernel/process_32.c |   36 ++++++++++++++++++++++++++++++++----
 arch/x86/kernel/process_64.c |   28 ++++++++++++++++++++++++----
 2 files changed, 56 insertions(+), 8 deletions(-)

Index: linus.git/arch/x86/kernel/process_32.c
===================================================================
--- linus.git.orig/arch/x86/kernel/process_32.c	2005-09-11 20:05:46.000000000 -0400
+++ linus.git/arch/x86/kernel/process_32.c	2008-01-07 20:42:24.000000000 -0500
@@ -83,6 +83,7 @@ unsigned long thread_saved_pc(struct tas
 void (*pm_idle)(void);
 EXPORT_SYMBOL(pm_idle);
 static DEFINE_PER_CPU(unsigned int, cpu_idle_state);
+static DEFINE_PER_CPU(unsigned int, in_idle);
 
 void disable_hlt(void)
 {
@@ -178,6 +179,12 @@ void cpu_idle(void)
 	/* endless idle loop with no priority at all */
 	while (1) {
 		tick_nohz_stop_sched_tick();
+		__get_cpu_var(in_idle) = 1;
+		/*
+		 * Make sure in_idle is seen by others
+		 * before cpu_idle_state is set (and read)
+		 */
+		smp_mb();
 		while (!need_resched()) {
 			void (*idle)(void);
 
@@ -197,6 +204,7 @@ void cpu_idle(void)
 			__get_cpu_var(irq_stat).idle_timestamp = jiffies;
 			idle();
 		}
+		__get_cpu_var(in_idle) = 0;
 		tick_nohz_restart_sched_tick();
 		preempt_enable_no_resched();
 		schedule();
@@ -204,6 +212,10 @@ void cpu_idle(void)
 	}
 }
 
+static void do_nothing(void *unused)
+{
+}
+
 void cpu_idle_wait(void)
 {
 	unsigned int cpu, this_cpu = get_cpu();
@@ -212,15 +224,31 @@ void cpu_idle_wait(void)
 	set_cpus_allowed(current, cpumask_of_cpu(this_cpu));
 	put_cpu();
 
+	for_each_online_cpu(cpu)
+		per_cpu(cpu_idle_state, cpu) = 1;
+
+	__get_cpu_var(cpu_idle_state) = 0;
+
+	/*
+	 * Make cpu_idle_state viewable by other CPUs
+	 * and be able to read in_idle of other CPUs.
+	 */
+	smp_mb();
+
+	/* Wake up any CPUs that are already in idle */
 	cpus_clear(map);
 	for_each_online_cpu(cpu) {
-		per_cpu(cpu_idle_state, cpu) = 1;
-		cpu_set(cpu, map);
+		if (per_cpu(in_idle, cpu))
+			cpu_set(cpu, map);
 	}
+	smp_call_function_mask(map, do_nothing, 0, 0);
 
-	__get_cpu_var(cpu_idle_state) = 0;
+	cpus_clear(map);
+	for_each_online_cpu(cpu) {
+		if (per_cpu(cpu_idle_state, cpu))
+			cpu_set(cpu, map);
+	}
 
-	wmb();
 	do {
 		ssleep(1);
 		for_each_online_cpu(cpu) {
Index: linus.git/arch/x86/kernel/process_64.c
===================================================================
--- linus.git.orig/arch/x86/kernel/process_64.c	2007-10-19 12:30:44.000000000 -0400
+++ linus.git/arch/x86/kernel/process_64.c	2008-01-07 20:47:34.000000000 -0500
@@ -65,6 +65,7 @@ EXPORT_SYMBOL(boot_option_idle_override)
 void (*pm_idle)(void);
 EXPORT_SYMBOL(pm_idle);
 static DEFINE_PER_CPU(unsigned int, cpu_idle_state);
+static DEFINE_PER_CPU(unsigned int, in_idle);
 
 static ATOMIC_NOTIFIER_HEAD(idle_notifier);
 
@@ -135,6 +136,10 @@ static void poll_idle (void)
 	cpu_relax();
 }
 
+static void do_nothing(void *unused)
+{
+}
+
 void cpu_idle_wait(void)
 {
 	unsigned int cpu, this_cpu = get_cpu();
@@ -143,15 +148,30 @@ void cpu_idle_wait(void)
 	set_cpus_allowed(current, cpumask_of_cpu(this_cpu));
 	put_cpu();
 
+	for_each_online_cpu(cpu)
+		per_cpu(cpu_idle_state, cpu) = 1;
+	__get_cpu_var(cpu_idle_state) = 0;
+
+	/*
+	 * Make cpu_idle_state viewable by other CPUs
+	 * and be able to read in_idle of other CPUs.
+	 */
+	smp_mb();
+
+	/* Wake up any CPUs that are already in idle */
 	cpus_clear(map);
 	for_each_online_cpu(cpu) {
-		per_cpu(cpu_idle_state, cpu) = 1;
-		cpu_set(cpu, map);
+		if (per_cpu(in_idle, cpu))
+			cpu_set(cpu, map);
 	}
+	smp_call_function_mask(map, do_nothing, 0, 0);
 
-	__get_cpu_var(cpu_idle_state) = 0;
+	cpus_clear(map);
+	for_each_online_cpu(cpu) {
+		if (per_cpu(cpu_idle_state, cpu))
+			cpu_set(cpu, map);
+	}
 
-	wmb();
 	do {
 		ssleep(1);
 		for_each_online_cpu(cpu) {


