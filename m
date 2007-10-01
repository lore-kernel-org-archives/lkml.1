Return-Path: <linux-kernel-owner+w=401wt.eu-S1754990AbXJAVST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990AbXJAVST (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 17:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752761AbXJAVSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 17:18:09 -0400
Received: from www.tglx.de ([62.245.132.106]:53733 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752457AbXJAVSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 17:18:08 -0400
Date: Mon, 1 Oct 2007 23:17:22 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arjan van de Ven <arjan@infradead.org>
cc: Andi Kleen <ak@suse.de>, David Bahi <dbahi@novell.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-rt-users@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Gregory Haskins <GHaskins@novell.com>
Subject: Re: nmi_watchdog fix for x86_64 to be more like i386
In-Reply-To: <20071001125626.32eb6d0b@laptopd505.fenrus.org>
Message-ID: <alpine.LFD.0.9999.0710012207270.20478@localhost.localdomain>
References: <46FA4A800200006C000192FE@sinclair.provo.novell.com> <200710011936.01528.ak@suse.de> <alpine.LFD.0.9999.0710012052310.20478@localhost.localdomain> <200710012116.59356.ak@suse.de> <alpine.LFD.0.9999.0710012124420.20478@localhost.localdomain>
 <20071001125626.32eb6d0b@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Oct 2007, Arjan van de Ven wrote:
> > > I already did this here by checking for cpu != 0. But it also needs
> > > either tracking or forbidding migrations of irq 0. I can take care
> > > of the patch.
> > 
> > I was thinking about the same fix. On i386 we already have the irq 
> > migration / balancing of irq 0 disabled. That's why we setup IRQ0 with
> > IRQ_NOBALANCING.
> 
> btw doing this is a problem if the user decides to hot(un)plug cpu 0...
> he then can't move the irqs away to do that

IRQ_NOBALANCING is not preventing cpu unplug. It moves the affinity to the 
next CPU, but the check in NMI watchdog for CPU == 0 would not longer 
work.

Fix below. Post .23 material. I work out a separate one for the x8664 
clock events series.

	tglx

------------>

[PATCH] i386: Fix nmi watchdog per cpu timer irq accounting

The clock events patches changed the interrupt distribution and the
local apic timer interrupt accounting for the broadcast case. The per
cpu clock events handler of the cpu, which runs the broadcast
interrupt, is executed directly in the broadcast irq context. This
does not invoke the low level arch code, which does the local apic
timer irq accounting. The work around for false positives in the nmi
watchdog was to add the irq0 interrupts (broadcast device) to the
local apic timer interrupts. This falsifies the results for the CPUs
which are not handling the broadcast interrupt, i.e. stuck CPUs might
be not detected, as noticed by Andi Kleen.

It would be possible to move the clockevents handler invocation of the
CPU which runs the broadcast interrupt into the tick device broadcast
function, but this would require to handle the per cpu device to this
function and perform the direct operation in the clock device specific
architecture code. Right now this is only i386 and x86_64, but MIPS is
on the way to use the broadcast mode as well.

Introduce a weak function tick_broadcast_account(), which allows x86
to adjust the local apic timer interrupt counter in the case when the
cpu local timer handler has been invoked. This keeps the cpu local
handler decision and invocation in the common code and allows x86 to
handle the nmi watchdog accounting correctly.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

diff --git a/arch/i386/kernel/apic.c b/arch/i386/kernel/apic.c
index 3d67ae1..180dde8 100644
--- a/arch/i386/kernel/apic.c
+++ b/arch/i386/kernel/apic.c
@@ -283,6 +283,16 @@ static void lapic_timer_broadcast(cpumask_t mask)
 }
 
 /*
+ * Called from the broadcasting code to keep the local apic timer irq
+ * accounting straight for the nmi watchdog. Is called with interrupts
+ * disabled.
+ */
+void tick_broadcast_account(int cpu)
+{
+	per_cpu(irq_stat, cpu).apic_timer_irqs++;
+}
+
+/*
  * Setup the local APIC timer for this CPU. Copy the initilized values
  * of the boot CPU and register the clock event in the framework.
  */
diff --git a/arch/i386/kernel/nmi.c b/arch/i386/kernel/nmi.c
index c7227e2..03cdcaf 100644
--- a/arch/i386/kernel/nmi.c
+++ b/arch/i386/kernel/nmi.c
@@ -349,11 +349,7 @@ __kprobes int nmi_watchdog_tick(struct pt_regs * regs, unsigned reason)
 		cpu_clear(cpu, backtrace_mask);
 	}
 
-	/*
-	 * Take the local apic timer and PIT/HPET into account. We don't
-	 * know which one is active, when we have highres/dyntick on
-	 */
-	sum = per_cpu(irq_stat, cpu).apic_timer_irqs + kstat_cpu(cpu).irqs[0];
+	sum = per_cpu(irq_stat, cpu).apic_timer_irqs;
 
 	/* if the none of the timers isn't firing, this cpu isn't doing much */
 	if (!touched && last_irq_sums[cpu] == sum) {
diff --git a/include/linux/tick.h b/include/linux/tick.h
index 9a7252e..99b3021 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -73,6 +73,7 @@ static inline void tick_cancel_sched_timer(int cpu) { }
 # ifdef CONFIG_GENERIC_CLOCKEVENTS_BROADCAST
 extern struct tick_device *tick_get_broadcast_device(void);
 extern cpumask_t *tick_get_broadcast_mask(void);
+extern void tick_broadcast_account(int cpu);
 
 #  ifdef CONFIG_TICK_ONESHOT
 extern cpumask_t *tick_get_broadcast_oneshot_mask(void);
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 0962e05..43d0085 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -123,6 +123,16 @@ int tick_device_uses_broadcast(struct clock_event_device *dev, int cpu)
 }
 
 /*
+ * Weak function for cpu local interrupt accounting. Used by x86 to
+ * keep the lapic accounting correct for nmi_watchdog.
+ *
+ * Must be called with interrupts disabled.
+ */
+void __attribute__((weak)) tick_broadcast_account(int cpu)
+{
+}
+
+/*
  * Broadcast the event to the cpus, which are set in the mask
  */
 int tick_do_broadcast(cpumask_t mask)
@@ -137,6 +147,7 @@ int tick_do_broadcast(cpumask_t mask)
 		cpu_clear(cpu, mask);
 		td = &per_cpu(tick_cpu_device, cpu);
 		td->evtdev->event_handler(td->evtdev);
+		tick_broadcast_account(cpu);
 		ret = 1;
 	}
 
