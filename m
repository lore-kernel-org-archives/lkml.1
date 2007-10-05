Return-Path: <linux-kernel-owner+w=401wt.eu-S1764193AbXJEUht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764193AbXJEUht (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 16:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763271AbXJEUhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 16:37:41 -0400
Received: from www.tglx.de ([62.245.132.106]:39260 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761765AbXJEUhk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 16:37:40 -0400
Date: Fri, 5 Oct 2007 22:37:07 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
cc: Andi Kleen <ak@suse.de>, Arjan van de Ven <arjan@infradead.org>,
       David Bahi <dbahi@novell.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Gregory Haskins <GHaskins@novell.com>
Subject: RE: nmi_watchdog fix for x86_64 to be more like i386
In-Reply-To: <653FFBB4508B9042B5D43DC9E18836F501797305@scsmsx415.amr.corp.intel.com>
Message-ID: <alpine.LRH.0.999.0710052230480.10191@www.tglx.de>
References: <46FA4A800200006C000192FE@sinclair.provo.novell.com>
 <200710020007.09864.ak@suse.de> <alpine.LFD.0.9999.0710020043450.20478@localhost.localdomain>
 <200710020751.42994.ak@suse.de> <alpine.LFD.0.9999.0710020815370.3348@localhost.localdomain>
 <653FFBB4508B9042B5D43DC9E18836F501797305@scsmsx415.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Oct 2007, Pallipadi, Venkatesh wrote:
> >-----Original Message-----
> >From: linux-kernel-owner@vger.kernel.org 
> >[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of 
> >Thomas Gleixner
> >Sent: Monday, October 01, 2007 11:19 PM
> >To: Andi Kleen
> >Cc: Arjan van de Ven; David Bahi; LKML; 
> >linux-rt-users@vger.kernel.org; Andrew Morton; Ingo Molnar; 
> >Gregory Haskins
> >Subject: Re: nmi_watchdog fix for x86_64 to be more like i386
> >
> >>
> >> The only workaround for chipsets ignoring IRQ affinity would 
> >be to keep
> >> track on which CPU irq 0 happens and then restart APIC timer 
> >interrupts
> >> on the others (or send IPIs) as needed. But that would be 
> >fairly ugly.
> >
> >The clock events code does handle this already. The broadcast 
> >interrupt 
> >can come in on any cpu. It's just the nmi watchdog which would 
> >be affected 
> >by that.
> >
> 
> Probably we can workaround this by keeping track of IRQ0 count at percpu
> level and
> use local apic timer + this percpu counter in NMI. Or just increment
> local
> apic timer count in IRQ0 with nohz enabled.

No, I tried that. It's ugly.

The per cpu accounting is the correct way to go if we want to take
care of those systems, which ignore the CPU0 binding of irq0.

See patch against the x86 tree below.

	tglx

-------------------->
commit 093976c7ad206a008bd5de4619f40f6bca4a79c3
Author: Thomas Gleixner <tglx@inhelltoy.tec.linutronix.de>
Date:   Fri Oct 5 22:19:18 2007 +0200

    x86: Fix irq0 / local apic timer accounting
    
    The clock events merge introduced a change to the nmi watchdog code to
    handle the not longer increasing local apic timer count in the
    broadcast mode. This is fine for UP, but on SMP it pampers over a
    stuck CPU which is not handling the broadcast interrupt due to the
    unconditional sum up of local apic timer count and irq0 count.
    
    To cover all cases we need to keep track on which CPU irq0 is
    handled. In theory this is CPU#0 due to the explicit disabling of irq
    balancing for irq0, but there are systems which ignore this on the
    hardware level. The per cpu irq0 accounting allows us to remove the
    irq0 to CPU0 binding as well.
    
    Add a per cpu counter for irq0 and evaluate this instead of the global
    irq0 count in the nmi watchdog code.
    
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

diff --git a/arch/x86/kernel/nmi_32.c b/arch/x86/kernel/nmi_32.c
index c7227e2..95d3fc2 100644
--- a/arch/x86/kernel/nmi_32.c
+++ b/arch/x86/kernel/nmi_32.c
@@ -353,7 +353,8 @@ __kprobes int nmi_watchdog_tick(struct pt_regs * regs, unsigned reason)
 	 * Take the local apic timer and PIT/HPET into account. We don't
 	 * know which one is active, when we have highres/dyntick on
 	 */
-	sum = per_cpu(irq_stat, cpu).apic_timer_irqs + kstat_cpu(cpu).irqs[0];
+	sum = per_cpu(irq_stat, cpu).apic_timer_irqs +
+		per_cpu(irq_stat, cpu).irq0_irqs;
 
 	/* if the none of the timers isn't firing, this cpu isn't doing much */
 	if (!touched && last_irq_sums[cpu] == sum) {
diff --git a/arch/x86/kernel/time_32.c b/arch/x86/kernel/time_32.c
index 19a6c67..3571d0a 100644
--- a/arch/x86/kernel/time_32.c
+++ b/arch/x86/kernel/time_32.c
@@ -157,6 +157,9 @@ EXPORT_SYMBOL(profile_pc);
  */
 irqreturn_t timer_interrupt(int irq, void *dev_id)
 {
+	/* Keep nmi watchdog up to date */
+	per_cpu(irq_stat, cpu).irq0_irqs++;
+
 #ifdef CONFIG_X86_IO_APIC
 	if (timer_ack) {
 		/*
diff --git a/include/asm-x86/hardirq_32.h b/include/asm-x86/hardirq_32.h
index ed7cf97..9188635 100644
--- a/include/asm-x86/hardirq_32.h
+++ b/include/asm-x86/hardirq_32.h
@@ -9,6 +9,7 @@ typedef struct {
 	unsigned long idle_timestamp;
 	unsigned int __nmi_count;	/* arch dependent */
 	unsigned int apic_timer_irqs;	/* arch dependent */
+	unsigned int irq0_irqs;
 } ____cacheline_aligned irq_cpustat_t;
 
 DECLARE_PER_CPU(irq_cpustat_t, irq_stat);

