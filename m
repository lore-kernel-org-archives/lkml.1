Return-Path: <linux-kernel-owner+w=401wt.eu-S1758235AbYAGQfB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758235AbYAGQfB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 11:35:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756973AbYAGQew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 11:34:52 -0500
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:35969 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755584AbYAGQeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 11:34:50 -0500
Subject: Hang on bootup when installing cpu idle menu
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Adam Belay <abelay@novell.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain
Date: Mon, 07 Jan 2008 11:33:41 -0500
Message-Id: <1199723621.26343.15.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've notice this hang on bootup every so often. Sometimes it hangs for a
second and sometimes it can hang for hours. Always at the same location.
This is a soft hang. That is, interrupts are still enabled, and I'm able
to perform a sysrq-t.

Here's the problem child:

Call Trace:
 [<c062cd67>] schedule_timeout+0x75/0x93
 [<c062cd9f>] schedule_timeout_uninterruptible+0x1a/0x1c
 [<c043ca12>] msleep+0x15/0x1b
 [<c0407726>] cpu_idle_wait+0x80/0xe0
 [<c05bbfa7>] cpuidle_uninstall_idle_handler+0x28/0x2a
 [<c05bc148>] cpuidle_switch_governor+0x20/0xd9
 [<c05bc2eb>] cpuidle_register_governor+0x6d/0xa6
 [<c076fb04>] init_menu+0x12/0x14
 [<c074e535>] kernel_init+0x154/0x2d1
 [<c0409dc7>] kernel_thread_helper+0x7/0x10


This happens after it installed cpu_idle_ladder, and later while
installing cpu_idle_menu it hangs. But it's not the menu that is the
problem. But it looks like the cpu_idle_wait is.

In cpu_idle from process_32.c we have:

		while (!need_resched()) {
			void (*idle)(void);

			if (__get_cpu_var(cpu_idle_state))
				__get_cpu_var(cpu_idle_state) = 0;

			check_pgt_cache();
			rmb();
			idle = pm_idle;

			if (!idle)
				idle = default_idle;

			if (cpu_is_offline(cpu))
				play_dead();

			__get_cpu_var(irq_stat).idle_timestamp = jiffies;
			idle();
		}

and in cpu_idle_wait:

	set_cpus_allowed(current, cpumask_of_cpu(this_cpu));
	put_cpu();

	cpus_clear(map);
	for_each_online_cpu(cpu) {
		per_cpu(cpu_idle_state, cpu) = 1;
		cpu_set(cpu, map);
	}

	__get_cpu_var(cpu_idle_state) = 0;

	wmb();
	do {
		ssleep(1);
		for_each_online_cpu(cpu) {
			if (cpu_isset(cpu, map) && !per_cpu(cpu_idle_state, cpu))
				cpu_clear(cpu, map);
		}
		cpus_and(map, map, cpu_online_map);
	} while (!cpus_empty(map));


Basically, we set cpu_idle_state to one for each online cpu. Clear the
cpu that is currently running. Then keep sleeping and wait till each cpu
passes the cpu_idle and clears the cpu_idle_state per_cpu variable.

The problem I see here, especially in boot up, is that it doesn't check
to see if a cpu is already idle.  So if a CPU is idle and NO_HZ is set
(yes I have that set), we can shut down an online CPU if there's no
interrupts to run nor any threads to run. Which is the case on bootup.

I first thought about adding an "in_idle" per_cpu variable to check, but
then I'm thinking that this can cause other races. Because this is used
in the idle governor code, and that code can also be a module, we might
remove the idle code when CPUS are still using it.  So perhaps a simple
smp_call_function to an empty function might be good enough. Something
like this?

---
 arch/x86/kernel/process_32.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linux-compile-i386.git/arch/x86/kernel/process_32.c
===================================================================
--- linux-compile-i386.git.orig/arch/x86/kernel/process_32.c	2008-01-03 17:25:46.000000000 -0500
+++ linux-compile-i386.git/arch/x86/kernel/process_32.c	2008-01-07 11:15:39.000000000 -0500
@@ -204,6 +204,10 @@ void cpu_idle(void)
 	}
 }
 
+static void do_nothing(void *unused)
+{
+}
+
 void cpu_idle_wait(void)
 {
 	unsigned int cpu, this_cpu = get_cpu();
@@ -221,6 +225,10 @@ void cpu_idle_wait(void)
 	__get_cpu_var(cpu_idle_state) = 0;
 
 	wmb();
+
+	/* make sure all CPUs are awake */
+	smp_call_function(do_nothing, NULL, 0, 0);
+
 	do {
 		ssleep(1);
 		for_each_online_cpu(cpu) {



Thoughts?

Disclaimer: I've been seeing this when working with the mcount patches.
So I haven't seen it on a vanilla git repo. But... I haven't been
booting vanilla git repos, and this hang doesn't look related to mcount.
Another problem is that this hang only happens once every 100 boots or
so.

-- Steve


