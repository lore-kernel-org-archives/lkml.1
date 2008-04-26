Return-Path: <linux-kernel-owner+w=401wt.eu-S1758273AbYDZXFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758273AbYDZXFl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 19:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752148AbYDZXFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 19:05:31 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:57973 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbYDZXFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 19:05:31 -0400
Date: Sun, 27 Apr 2008 00:04:41 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Ingo Molnar <mingo@elte.hu>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Justin Mattock <justinmattock@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: spinlock lockup on CPU#0
In-Reply-To: <20080426191432.GA2927@elte.hu>
Message-ID: <Pine.LNX.4.64.0804262340130.26624@blonde.site>
References: <dd18b0c30804231841m3bbfab44x53d635b7ea6fc58d@mail.gmail.com>
 <20080426112907.77613dee.akpm@linux-foundation.org> <20080426191432.GA2927@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Apr 2008, Ingo Molnar wrote:
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > > Hopefully the numbers are right, and hopefully this provides enough 
> > > info to help the kernel out
> > 
> > Well that's cute.  At a guess I'd say that acpi_processor_idle() 
> > managed to call sched_clock_idle_wakeup_event() with local interrupts 
> > enabled.  We took an interrupt with rq->lock held and things went 
> > downhill from there.
> > 
> > Can you add this please, see if it triggers?
> 
> there's fixes pending in this area. The main fix would be the one below.
> 
> 	Ingo
> 
> ---------------->
> Subject: idle (arch, acpi and apm) and lockdep
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Fri, 25 Apr 2008 17:39:01 +0200

Oh good, thanks, I see you've just asked Linus to pull that idle fix.

Thanks to Peter for the fix, and to Justin for calling attention to it:
this freeze has been plaguing me on one x86_32 box since I put -git8
on, and I've just verified that it's the same as what's been plaguing
me on that machine since 2.6.25-mm1 came out.

Andrew, here's a belated hotfix for 2.6.25-mm1, running nicely at last:

Peter Zijlstra's "idle (arch, acpi and apm) and lockdep" fix to
recent x86 freezes - adapted to 2.6.25-mm1 by omitting merges
from process_32.c and process_64.c into process.c.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---

 arch/x86/kernel/apm_32.c      |    3 +++
 arch/x86/kernel/process_32.c  |   27 +++++++++++++++------------
 arch/x86/kernel/process_64.c  |    8 +++-----
 drivers/acpi/processor_idle.c |   19 +++++++++----------
 include/asm-x86/processor.h   |    1 +
 5 files changed, 31 insertions(+), 27 deletions(-)

--- 2.6.25-mm1/arch/x86/kernel/apm_32.c	2008-04-18 12:18:09.000000000 +0100
+++ linux/arch/x86/kernel/apm_32.c	2008-04-26 22:17:06.000000000 +0100
@@ -904,6 +904,7 @@ recalc:
 			original_pm_idle();
 		else
 			default_idle();
+		local_irq_disable();
 		jiffies_since_last_check = jiffies - last_jiffies;
 		if (jiffies_since_last_check > idle_period)
 			goto recalc;
@@ -911,6 +912,8 @@ recalc:
 
 	if (apm_idle_done)
 		apm_do_busy();
+
+	local_irq_enable();
 }
 
 /**
--- 2.6.25-mm1/arch/x86/kernel/process_32.c	2008-04-18 12:18:09.000000000 +0100
+++ linux/arch/x86/kernel/process_32.c	2008-04-26 22:29:36.000000000 +0100
@@ -111,12 +111,10 @@ void default_idle(void)
 		 */
 		smp_mb();
 
-		local_irq_disable();
-		if (!need_resched()) {
+		if (!need_resched())
 			safe_halt();	/* enables interrupts racelessly */
-			local_irq_disable();
-		}
-		local_irq_enable();
+		else
+			local_irq_enable();
 		current_thread_info()->status |= TS_POLLING;
 	} else {
 		local_irq_enable();
@@ -196,6 +194,7 @@ void cpu_idle(void)
 			if (cpu_is_offline(cpu))
 				play_dead();
 
+			local_irq_disable();
 			__get_cpu_var(irq_stat).idle_timestamp = jiffies;
 			/* Don't trace irqs off for idle */
 			stop_critical_timings();
@@ -245,18 +244,22 @@ void mwait_idle_with_hints(unsigned long
 		__monitor((void *)&current_thread_info()->flags, 0, 0);
 		smp_mb();
 		if (!need_resched())
-			__sti_mwait(ax, cx);
-		else
-			local_irq_enable();
-	} else
-		local_irq_enable();
+			__mwait(ax, cx);
+	}
 }
 
 /* Default MONITOR/MWAIT with no hints, used for default C1 state */
 static void mwait_idle(void)
 {
-	local_irq_enable();
-	mwait_idle_with_hints(0, 0);
+	if (!need_resched()) {
+		__monitor((void *)&current_thread_info()->flags, 0, 0);
+		smp_mb();
+		if (!need_resched())
+			__sti_mwait(0, 0);
+		else
+			local_irq_enable();
+	} else
+		local_irq_enable();
 }
 
 static int __cpuinit mwait_usable(const struct cpuinfo_x86 *c)
--- 2.6.25-mm1/arch/x86/kernel/process_64.c	2008-04-18 12:18:09.000000000 +0100
+++ linux/arch/x86/kernel/process_64.c	2008-04-26 22:19:29.000000000 +0100
@@ -106,12 +106,10 @@ void default_idle(void)
 	 * test NEED_RESCHED:
 	 */
 	smp_mb();
-	local_irq_disable();
-	if (!need_resched()) {
+	if (!need_resched())
 		safe_halt();	/* enables interrupts racelessly */
-		local_irq_disable();
-	}
-	local_irq_enable();
+	else
+		local_irq_enable();
 	current_thread_info()->status |= TS_POLLING;
 }
 
--- 2.6.25-mm1/drivers/acpi/processor_idle.c	2008-04-18 12:18:10.000000000 +0100
+++ linux/drivers/acpi/processor_idle.c	2008-04-26 22:17:06.000000000 +0100
@@ -436,13 +436,12 @@ static void acpi_processor_idle(void)
 
 	cx = pr->power.state;
 	if (!cx || acpi_idle_suspend) {
-		if (pm_idle_save)
-			pm_idle_save();
-		else
+		if (pm_idle_save) {
+			pm_idle_save(); /* enables IRQs */
+		} else {
 			acpi_safe_halt();
-
-		if (irqs_disabled())
 			local_irq_enable();
+		}
 
 		return;
 	}
@@ -538,10 +537,12 @@ static void acpi_processor_idle(void)
 		 * Use the appropriate idle routine, the one that would
 		 * be used without acpi C-states.
 		 */
-		if (pm_idle_save)
-			pm_idle_save();
-		else
+		if (pm_idle_save) {
+			pm_idle_save(); /* enables IRQs */
+		} else {
 			acpi_safe_halt();
+			local_irq_enable();
+		}
 
 		/*
 		 * TBD: Can't get time duration while in C1, as resumes
@@ -552,8 +553,6 @@ static void acpi_processor_idle(void)
 		 *       skew otherwise.
 		 */
 		sleep_ticks = 0xFFFFFFFF;
-		if (irqs_disabled())
-			local_irq_enable();
 
 		break;
 
--- 2.6.25-mm1/include/asm-x86/processor.h	2008-04-18 12:18:34.000000000 +0100
+++ linux/include/asm-x86/processor.h	2008-04-26 22:17:06.000000000 +0100
@@ -726,6 +726,7 @@ static inline void __mwait(unsigned long
 
 static inline void __sti_mwait(unsigned long eax, unsigned long ecx)
 {
+	trace_hardirqs_on();
 	/* "mwait %eax, %ecx;" */
 	asm volatile("sti; .byte 0x0f, 0x01, 0xc9;"
 		     :: "a" (eax), "c" (ecx));
