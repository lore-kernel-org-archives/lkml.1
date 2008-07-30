Return-Path: <linux-kernel-owner+w=401wt.eu-S1759591AbYG3Sul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759591AbYG3Sul (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 14:50:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753467AbYG3Su1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 14:50:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55305 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688AbYG3SuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 14:50:24 -0400
Date: Wed, 30 Jul 2008 20:50:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Glauber Costa <gcosta@redhat.com>
Cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
       x86@kernel.org
Subject: Re: [GIT-PULL] time.c integration
Message-ID: <20080730185007.GB26389@elte.hu>
References: <200807290103.m6T13vt3000862@file.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807290103.m6T13vt3000862@file.rdu.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Glauber Costa <gcosta@redhat.com> wrote:

> Ingo, please pull the latest master git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/glommer/linux-2.6-x86-integration.git master
> 
> into your tree
> 
> 
> It contains code to integrate time_32.c and time_64.c into time.c

btw., this diffstat initially scared me:

>  arch/x86/Makefile                                |    4 -
>  arch/x86/kernel/Makefile                         |    2 +-
>  arch/x86/kernel/acpi/cstate.c                    |    3 +-
>  arch/x86/kernel/cpu/common_64.c                  |    9 ++
>  arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c       |   10 ++-
>  arch/x86/kernel/cpu/cpufreq/powernow-k8.c        |   15 ++-
>  arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c |   12 ++-
>  arch/x86/kernel/cpu/cpufreq/speedstep-ich.c      |    3 +-
>  arch/x86/kernel/cpu/intel_cacheinfo.c            |    3 +-
>  arch/x86/kernel/io_apic_64.c                     |    6 +-
>  arch/x86/kernel/irqinit_64.c                     |   59 +++++-----
>  arch/x86/kernel/ldt.c                            |    6 +-
>  arch/x86/kernel/microcode.c                      |   17 ++-
>  arch/x86/kernel/reboot.c                         |   11 ++-
>  arch/x86/kernel/setup_percpu.c                   |   21 ++++
>  arch/x86/kernel/{time_32.c => time.c}            |   66 +++++++++++-
>  arch/x86/kernel/time_64.c                        |  126 ----------------------
>  drivers/acpi/processor_throttling.c              |   11 ++-
>  drivers/char/pcmcia/ipwireless/hardware.c        |    2 +-
>  drivers/firmware/dcdbas.c                        |    3 +-
>  drivers/misc/sgi-xp/xpc_main.c                   |    3 +-
>  include/asm-x86/segment.h                        |    6 -
>  include/linux/cpumask.h                          |   63 +++++++----
>  kernel/cpu.c                                     |   25 -----
>  kernel/time/tick-common.c                        |    8 +-
>  kernel/trace/trace_sysprof.c                     |    4 +-
>  lib/smp_processor_id.c                           |    5 +-
>  net/sunrpc/svc.c                                 |    3 +-
>  28 files changed, 247 insertions(+), 259 deletions(-)
>  rename arch/x86/kernel/{time_32.c => time.c} (70%)
>  delete mode 100644 arch/x86/kernel/time_64.c

but what i pulled looked a lot saner:

 arch/x86/Makefile               |    4 -
 arch/x86/kernel/Makefile        |    2 +-
 arch/x86/kernel/cpu/common_64.c |    9 ++
 arch/x86/kernel/io_apic_64.c    |    6 +-
 arch/x86/kernel/irqinit_64.c    |   59 ++++++------
 arch/x86/kernel/time.c          |  191 +++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/time_32.c       |  135 ---------------------------
 arch/x86/kernel/time_64.c       |  126 --------------------------
 include/asm-x86/segment.h       |    6 --
 9 files changed, 235 insertions(+), 303 deletions(-)

why the discrepancy?

another thing is, the integration commit itself is not done correctly. 
You change both time_32.c and time_64.c while unifying them. The proper 
way to unify is to change both files _prior_ the unification, to make 
them bit for bit identical, _then_ rename them in one mechanic move that 
cannot break anything.

that way things like the thing below wouldnt need laborous slice & 
compare but would be obvious: for example you've removed copyright 
notices from time_64.c. Please dont do that - keep the unification of 
all copyrights in the new time.c.

Also, please do smaller steps while bringing both time_32.c and 
time_64.c up into their final forms (and do it in multiple commits), and 
make sure each step compiles on their respective defconfig. time.c 
details are historically fragile, i'd not be surprised if this series 
was the target of bisection efforts.

	Ingo

--- time_64.c	2008-07-30 20:44:17.000000000 +0200
+++ arch/x86/kernel/time.c	2008-07-30 20:44:20.000000000 +0200
@@ -1,81 +1,50 @@
 /*
- *  "High Precision Event Timer" based timekeeping.
+ *  Copyright (C) 1991, 1992, 1995  Linus Torvalds
  *
- *  Copyright (c) 1991,1992,1995  Linus Torvalds
- *  Copyright (c) 1994  Alan Modra
- *  Copyright (c) 1995  Markus Kuhn
- *  Copyright (c) 1996  Ingo Molnar
- *  Copyright (c) 1998  Andrea Arcangeli
- *  Copyright (c) 2002,2006  Vojtech Pavlik
- *  Copyright (c) 2003  Andi Kleen
- *  RTC support code taken from arch/i386/kernel/timers/time_hpet.c
+ * This file contains the PC-specific time handling details:
+ * reading the RTC at bootup, etc..
+ * 1994-07-02    Alan Modra
+ *	fixed set_rtc_mmss, fixed time.year for >= 2000, new mktime
+ * 1995-03-26    Markus Kuhn
+ *      fixed 500 ms bug at call to set_rtc_mmss, fixed DS12887
+ *      precision CMOS clock update
+ * 1996-05-03    Ingo Molnar
+ *      fixed time warps in do_[slow|fast]_gettimeoffset()
+ * 1997-09-10	Updated NTP code according to technical memorandum Jan '96
+ *		"A Kernel Model for Precision Timekeeping" by Dave Mills
+ * 1998-09-05    (Various)
+ *	More robust do_fast_gettimeoffset() algorithm implemented
+ *	(works with APM, Cyrix 6x86MX and Centaur C6),
+ *	monotonic gettimeofday() with fast_get_timeoffset(),
+ *	drift-proof precision TSC calibration on boot
+ *	(C. Scott Ananian <cananian@alumni.princeton.edu>, Andrew D.
+ *	Balsa <andrebalsa@altern.org>, Philip Gladstone <philip@raptor.com>;
+ *	ported from 2.0.35 Jumbo-9 by Michael Krause <m.krause@tu-harburg.de>).
+ * 1998-12-16    Andrea Arcangeli
+ *	Fixed Jumbo-9 code in 2.1.131: do_gettimeofday was missing 1 jiffy
+ *	because was not accounting lost_ticks.
+ * 1998-12-24 Copyright (C) 1998  Andrea Arcangeli
+ *	Fixed a xtime SMP race (we need the xtime_lock rw spinlock to
+ *	serialize accesses to xtime/lost_ticks).
  */
 
-#include <linux/clockchips.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
-#include <linux/module.h>
 #include <linux/time.h>
+#include <linux/mca.h>
 
-#include <asm/i8253.h>
+#include <asm/arch_hooks.h>
 #include <asm/hpet.h>
-#include <asm/nmi.h>
-#include <asm/vgtod.h>
 #include <asm/time.h>
+#include <asm/nmi.h>
 #include <asm/timer.h>
-#include <asm/arch_hooks.h>
 
 #include "do_timer.h"
 
-volatile unsigned long __jiffies __section_jiffies = INITIAL_JIFFIES;
 int timer_ack;
 
-unsigned long profile_pc(struct pt_regs *regs)
-{
-	unsigned long pc = instruction_pointer(regs);
-
-#ifdef CONFIG_SMP
-	/* Assume the lock function has either no stack frame or a copy
-	   of flags from PUSHF
-	   Eflags always has bits 22 and up cleared unlike kernel addresses. */
-	if (!user_mode_vm(regs) && in_lock_functions(pc)) {
-#ifdef CONFIG_FRAME_POINTER
-		return *(unsigned long *)(regs->bp + sizeof(long));
-#endif
-		unsigned long *sp = (unsigned long *)regs->sp;
-		if (sp[0] >> 22)
-			return sp[0];
-		if (sp[1] >> 22)
-			return sp[1];
-	}
-#endif
-	return pc;
-}
-EXPORT_SYMBOL(profile_pc);
-
-irqreturn_t timer_interrupt(int irq, void *dev_id)
-{
-	add_pda(irq0_irqs, 1);
-
-#ifdef CONFIG_X86_IO_APIC
-	if (timer_ack) {
-		spin_lock(&i8259A_lock);
-		outb(0x0c, PIC_MASTER_OCW3);
-		inb(PIC_MASTER_POLL);
-		spin_unlock(&i8259A_lock);
-	}
-#endif
-	do_timer_interrupt_hook();
-
-#ifdef CONFIG_MCA
-	if (MCA_bus) {
-		u8 irq_v = inb_p(0x61);       /* read the current state */
-		outb_p(irq_v|0x80, 0x61);     /* reset the IRQ */
-	}
-#endif
-
-	return IRQ_HANDLED;
-}
+#ifdef CONFIG_X86_64
+volatile unsigned long __jiffies __section_jiffies = INITIAL_JIFFIES;
 
 /* calibrate_cpu is used on systems with fixed rate TSCs to determine
  * processor frequency */
@@ -122,19 +91,102 @@ unsigned long __init calibrate_cpu(void)
 
 	return pmc_now * tsc_khz / (tsc_now - tsc_start);
 }
+#endif
 
+unsigned long profile_pc(struct pt_regs *regs)
+{
+	unsigned long pc = instruction_pointer(regs);
+
+#ifdef CONFIG_SMP
+	if (!user_mode_vm(regs) && in_lock_functions(pc)) {
+#ifdef CONFIG_FRAME_POINTER
+		return *(unsigned long *)(regs->bp + sizeof(long));
+#else
+		unsigned long *sp = (unsigned long *)&regs->sp;
+
+		/* Return address is either directly at stack pointer
+		   or above a saved flags. Eflags has bits 22-31 zero,
+		   kernel addresses don't. */
+		if (sp[0] >> 22)
+			return sp[0];
+		if (sp[1] >> 22)
+			return sp[1];
+#endif
+	}
+#endif
+	return pc;
+}
+EXPORT_SYMBOL(profile_pc);
+
+/*
+ * This is the same as the above, except we _also_ save the current
+ * Time Stamp Counter value at the time of the timer interrupt, so that
+ * we later on can estimate the time of day more exactly.
+ */
+irqreturn_t timer_interrupt(int irq, void *dev_id)
+{
+	/* Keep nmi watchdog up to date */
+#ifdef CONFIG_X86_32
+	per_cpu(irq_stat, smp_processor_id()).irq0_irqs++;
+#else
+	add_pda(irq0_irqs, 1);
+#endif
+
+#ifdef CONFIG_X86_IO_APIC
+	if (timer_ack) {
+		/*
+		 * Subtle, when I/O APICs are used we have to ack timer IRQ
+		 * manually to deassert NMI lines for the watchdog if run
+		 * on an 82489DX-based system.
+		 */
+		spin_lock(&i8259A_lock);
+		outb(0x0c, PIC_MASTER_OCW3);
+		/* Ack the IRQ; AEOI will end it automatically. */
+		inb(PIC_MASTER_POLL);
+		spin_unlock(&i8259A_lock);
+	}
+#endif
+
+	do_timer_interrupt_hook();
+
+#ifdef CONFIG_MCA
+	if (MCA_bus) {
+		/* The PS/2 uses level-triggered interrupts.  You can't
+		turn them off, nor would you want to (any attempt to
+		enable edge-triggered interrupts usually gets intercepted by a
+		special hardware circuit).  Hence we have to acknowledge
+		the timer interrupt.  Through some incredibly stupid
+		design idea, the reset for IRQ 0 is done by setting the
+		high bit of the PPI port B (0x61).  Note that some PS/2s,
+		notably the 55SX, work fine if this is removed.  */
+
+		u8 irq_v = inb_p(0x61);	/* read the current state */
+		outb_p(irq_v|0x80, 0x61);	/* reset the IRQ */
+	}
+#endif
+
+	return IRQ_HANDLED;
+}
+
+/* Duplicate of time_init() below, with hpet_enable part added */
 void __init hpet_time_init(void)
 {
 	if (!hpet_enable())
 		setup_pit_timer();
-
 	time_init_hook();
 }
 
+/*
+ * This is called directly from init code; we must delay timer setup in the
+ * HPET case as we can't make the decision to turn on HPET this early in the
+ * boot process.
+ *
+ * The chosen time_init function will usually be hpet_time_init, above, but
+ * in the case of virtual hardware, an alternative function may be substituted.
+ */
 void __init time_init(void)
 {
 	pre_time_init_hook();
 	tsc_init();
-
 	late_time_init = choose_time_init();
 }
