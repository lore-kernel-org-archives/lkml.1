Return-Path: <linux-kernel-owner+w=401wt.eu-S1422740AbXCGRNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422740AbXCGRNA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:13:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422743AbXCGRNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:13:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57218 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422740AbXCGRM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:12:59 -0500
Date: Wed, 7 Mar 2007 18:12:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [patch] CPU hotplug: call check_tsc_sync_source() with irqs off
Message-ID: <20070307171230.GA21593@elte.hu>
References: <Pine.LNX.4.64.0703062050570.5963@woody.linux-foundation.org> <45EEB66C.9090901@googlemail.com> <Pine.LNX.4.64.0703070827490.5963@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703070827490.5963@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> [ Ingo and Thomas added to Cc, because I think this is them.. ]
> 
> Ingo, I think this came in during commit 95492e4646, "x86: rewrite SMP 
> TSC sync code".

yeah.

> > I get this while
> > echo shutdown > /sys/power/disk; echo disk > /sys/power/state
> > 
> > BUG: using smp_processor_id() in preemptible [00000001] code: swsusp_shutdown/3359
> > caller is check_tsc_sync_source+0x1b/0xef

Michal, could you try the patch below?

	Ingo

----------------------------->
Subject: [patch] CPU hotplug: call check_tsc_sync_source() with irqs off
From: Ingo Molnar <mingo@elte.hu>

check_tsc_sync_source() depends on being called with irqs disabled (it 
checks whether the TSC is coherent across two specific CPUs). This is 
incidentally true during bootup, but not during cpu hotplug __cpu_up(). 
This got found via smp_processor_id() debugging.

disable irqs explicitly and remove the unconditional enabling of 
interrupts. Add touch_nmi_watchdog() to the cpu_online_map busy loop.

this bug is present both on i386 and on x86_64.

Reported-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/i386/kernel/smpboot.c   |   16 ++++++++++------
 arch/x86_64/kernel/smpboot.c |    5 ++++-
 2 files changed, 14 insertions(+), 7 deletions(-)

Index: linux/arch/i386/kernel/smpboot.c
===================================================================
--- linux.orig/arch/i386/kernel/smpboot.c
+++ linux/arch/i386/kernel/smpboot.c
@@ -50,6 +50,7 @@
 #include <linux/notifier.h>
 #include <linux/cpu.h>
 #include <linux/percpu.h>
+#include <linux/nmi.h>
 
 #include <linux/delay.h>
 #include <linux/mc146818rtc.h>
@@ -1283,8 +1284,9 @@ void __cpu_die(unsigned int cpu)
 
 int __cpuinit __cpu_up(unsigned int cpu)
 {
+	unsigned long flags;
 #ifdef CONFIG_HOTPLUG_CPU
-	int ret=0;
+	int ret = 0;
 
 	/*
 	 * We do warm boot only on cpus that had booted earlier
@@ -1302,23 +1304,25 @@ int __cpuinit __cpu_up(unsigned int cpu)
 	/* In case one didn't come up */
 	if (!cpu_isset(cpu, cpu_callin_map)) {
 		printk(KERN_DEBUG "skipping cpu%d, didn't come online\n", cpu);
-		local_irq_enable();
 		return -EIO;
 	}
 
-	local_irq_enable();
-
 	per_cpu(cpu_state, cpu) = CPU_UP_PREPARE;
 	/* Unleash the CPU! */
 	cpu_set(cpu, smp_commenced_mask);
 
 	/*
-	 * Check TSC synchronization with the AP:
+	 * Check TSC synchronization with the AP (keep irqs disabled
+	 * while doing so):
 	 */
+	local_irq_save(flags);
 	check_tsc_sync_source(cpu);
+	local_irq_restore(flags);
 
-	while (!cpu_isset(cpu, cpu_online_map))
+	while (!cpu_isset(cpu, cpu_online_map)) {
 		cpu_relax();
+		touch_nmi_watchdog();
+	}
 
 #ifdef CONFIG_X86_GENERICARCH
 	if (num_online_cpus() > 8 && genapic == &apic_default)
Index: linux/arch/x86_64/kernel/smpboot.c
===================================================================
--- linux.orig/arch/x86_64/kernel/smpboot.c
+++ linux/arch/x86_64/kernel/smpboot.c
@@ -923,8 +923,9 @@ void __init smp_prepare_boot_cpu(void)
  */
 int __cpuinit __cpu_up(unsigned int cpu)
 {
-	int err;
 	int apicid = cpu_present_to_apicid(cpu);
+	unsigned long flags;
+	int err;
 
 	WARN_ON(irqs_disabled());
 
@@ -958,7 +959,9 @@ int __cpuinit __cpu_up(unsigned int cpu)
 	/*
   	 * Make sure and check TSC sync:
  	 */
+	local_irq_save(flags);
 	check_tsc_sync_source(cpu);
+	local_irq_restore(flags);
 
 	while (!cpu_isset(cpu, cpu_online_map))
 		cpu_relax();
