Return-Path: <linux-kernel-owner+w=401wt.eu-S1755939AbXIUWez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939AbXIUWez (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763374AbXIUWcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:32:12 -0400
Received: from ns2.suse.de ([195.135.220.15]:40451 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763123AbXIUWcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:32:08 -0400
From: Andi Kleen <ak@suse.de>
References: <200709221231.836138000@suse.de>
In-Reply-To: <200709221231.836138000@suse.de>
To: joe.korty@ccur.com, thockin@hockin.org, ak@suse.de, mingo@elte.hu,
       hpa@zytor.com, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [7/50] x86: expand /proc/interrupts to include missing vectors, v2
Message-Id: <20070921223205.51E0113DCD@wotan.suse.de>
Date: Sat, 22 Sep 2007 00:32:05 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Joe Korty <joe.korty@ccur.com>

Add missing IRQs and IRQ descriptions to /proc/interrupts.

/proc/interrupts is most useful when it displays every IRQ vector in use by
the system, not just those somebody thought would be interesting.

This patch inserts the following vector displays to the i386 and x86_64
platforms, as appropriate:

	rescheduling interrupts
	TLB flush interrupts
	function call interrupts
	thermal event interrupts
	threshold interrupts
	spurious interrupts

A threshold interrupt occurs when ECC memory correction is occuring at too
high a frequency.  Thresholds are used by the ECC hardware as occasional
ECC failures are part of normal operation, but long sequences of ECC
failures usually indicate a memory chip that is about to fail.

Thermal event interrupts occur when a temperature threshold has been
exceeded for some CPU chip.  IIRC, a thermal interrupt is also generated
when the temperature drops back to a normal level.

A spurious interrupt is an interrupt that was raised then lowered by the
device before it could be fully processed by the APIC.  Hence the apic sees
the interrupt but does not know what device it came from.  For this case
the APIC hardware will assume a vector of 0xff.

Rescheduling, call, and TLB flush interrupts are sent from one CPU to
another per the needs of the OS.  Typically, their statistics would be used
to discover if an interrupt flood of the given type has been occuring.

AK: merged v2 and v4 which had some more tweaks

Signed-off-by: Joe Korty <joe.korty@ccur.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Tim Hockin <thockin@hockin.org>
Cc: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt   |   35 ++++++++++++++++++++++++++++++++++-
 arch/i386/kernel/apic.c              |    1 +
 arch/i386/kernel/cpu/mcheck/p4.c     |    1 +
 arch/i386/kernel/irq.c               |   31 +++++++++++++++++++++++++++++--
 arch/i386/kernel/smp.c               |    3 +++
 arch/i386/mach-voyager/voyager_smp.c |    1 +
 arch/i386/xen/smp.c                  |    1 +
 arch/x86_64/kernel/apic.c            |    1 +
 arch/x86_64/kernel/irq.c             |   30 ++++++++++++++++++++++++++++--
 arch/x86_64/kernel/mce_amd.c         |    1 +
 arch/x86_64/kernel/mce_intel.c       |    1 +
 arch/x86_64/kernel/smp.c             |    3 +++
 include/asm-i386/hardirq.h           |    5 +++++
 include/asm-x86_64/pda.h             |    6 ++++++
 14 files changed, 115 insertions(+), 5 deletions(-)

Index: linux/arch/i386/kernel/apic.c
===================================================================
--- linux.orig/arch/i386/kernel/apic.c
+++ linux/arch/i386/kernel/apic.c
@@ -1277,6 +1277,7 @@ void smp_spurious_interrupt(struct pt_re
 	/* see sw-dev-man vol 3, chapter 7.4.13.5 */
 	printk(KERN_INFO "spurious APIC interrupt on CPU#%d, "
 	       "should never happen.\n", smp_processor_id());
+	__get_cpu_var(irq_stat).irq_spurious_counts++;
 	irq_exit();
 }
 
Index: linux/arch/i386/kernel/cpu/mcheck/p4.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/mcheck/p4.c
+++ linux/arch/i386/kernel/cpu/mcheck/p4.c
@@ -61,6 +61,7 @@ fastcall void smp_thermal_interrupt(stru
 {
 	irq_enter();
 	vendor_thermal_interrupt(regs);
+	__get_cpu_var(irq_stat).irq_thermal_counts++;
 	irq_exit();
 }
 
Index: linux/arch/i386/kernel/irq.c
===================================================================
--- linux.orig/arch/i386/kernel/irq.c
+++ linux/arch/i386/kernel/irq.c
@@ -284,14 +284,41 @@ skip:
 		seq_printf(p, "NMI: ");
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ", nmi_count(j));
-		seq_putc(p, '\n');
+		seq_printf(p, "  Non-maskable interrupts\n");
 #ifdef CONFIG_X86_LOCAL_APIC
 		seq_printf(p, "LOC: ");
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ",
 				per_cpu(irq_stat,j).apic_timer_irqs);
-		seq_putc(p, '\n');
+		seq_printf(p, "  Local interrupts\n");
 #endif
+#ifdef CONFIG_SMP
+		seq_printf(p, "RES: ");
+		for_each_online_cpu(j)
+			seq_printf(p, "%10u ",
+				per_cpu(irq_stat,j).irq_resched_counts);
+		seq_printf(p, "  Rescheduling interrupts\n");
+		seq_printf(p, "CAL: ");
+		for_each_online_cpu(j)
+			seq_printf(p, "%10u ",
+				per_cpu(irq_stat,j).irq_call_counts);
+		seq_printf(p, "  function call interrupts\n");
+		seq_printf(p, "TLB: ");
+		for_each_online_cpu(j)
+			seq_printf(p, "%10u ",
+				per_cpu(irq_stat,j).irq_tlb_counts);
+		seq_printf(p, "  TLB shootdowns\n");
+#endif
+		seq_printf(p, "TRM: ");
+		for_each_online_cpu(j)
+			seq_printf(p, "%10u ",
+				per_cpu(irq_stat,j).irq_thermal_counts);
+		seq_printf(p, "  Thermal event interrupts\n");
+		seq_printf(p, "SPU: ");
+		for_each_online_cpu(j)
+			seq_printf(p, "%10u ",
+				per_cpu(irq_stat,j).irq_spurious_counts);
+		seq_printf(p, "  Spurious interrupts\n");
 		seq_printf(p, "ERR: %10u\n", atomic_read(&irq_err_count));
 #if defined(CONFIG_X86_IO_APIC)
 		seq_printf(p, "MIS: %10u\n", atomic_read(&irq_mis_count));
Index: linux/arch/i386/kernel/smp.c
===================================================================
--- linux.orig/arch/i386/kernel/smp.c
+++ linux/arch/i386/kernel/smp.c
@@ -342,6 +342,7 @@ fastcall void smp_invalidate_interrupt(s
 	smp_mb__after_clear_bit();
 out:
 	put_cpu_no_resched();
+	__get_cpu_var(irq_stat).irq_tlb_counts++;
 }
 
 void native_flush_tlb_others(const cpumask_t *cpumaskp, struct mm_struct *mm,
@@ -640,6 +641,7 @@ static void native_smp_send_stop(void)
 fastcall void smp_reschedule_interrupt(struct pt_regs *regs)
 {
 	ack_APIC_irq();
+	__get_cpu_var(irq_stat).irq_resched_counts++;
 }
 
 fastcall void smp_call_function_interrupt(struct pt_regs *regs)
@@ -660,6 +662,7 @@ fastcall void smp_call_function_interrup
 	 */
 	irq_enter();
 	(*func)(info);
+	__get_cpu_var(irq_stat).irq_call_counts++;
 	irq_exit();
 
 	if (wait) {
Index: linux/arch/i386/mach-voyager/voyager_smp.c
===================================================================
--- linux.orig/arch/i386/mach-voyager/voyager_smp.c
+++ linux/arch/i386/mach-voyager/voyager_smp.c
@@ -1037,6 +1037,7 @@ smp_call_function_interrupt(void)
 	 */
 	irq_enter();
 	(*func)(info);
+	__get_cpu_var(irq_stat).irq_call_counts++;
 	irq_exit();
 	if (wait) {
 		mb();
Index: linux/arch/i386/xen/smp.c
===================================================================
--- linux.orig/arch/i386/xen/smp.c
+++ linux/arch/i386/xen/smp.c
@@ -346,6 +346,7 @@ static irqreturn_t xen_call_function_int
 	 */
 	irq_enter();
 	(*func)(info);
+	__get_cpu_var(irq_stat).irq_call_counts++;
 	irq_exit();
 
 	if (wait) {
Index: linux/arch/x86_64/kernel/apic.c
===================================================================
--- linux.orig/arch/x86_64/kernel/apic.c
+++ linux/arch/x86_64/kernel/apic.c
@@ -1117,6 +1117,7 @@ asmlinkage void smp_spurious_interrupt(v
 	if (v & (1 << (SPURIOUS_APIC_VECTOR & 0x1f)))
 		ack_APIC_irq();
 
+	add_pda(irq_spurious_counts, 1);
 	irq_exit();
 }
 
Index: linux/arch/x86_64/kernel/irq.c
===================================================================
--- linux.orig/arch/x86_64/kernel/irq.c
+++ linux/arch/x86_64/kernel/irq.c
@@ -88,11 +88,37 @@ skip:
 		seq_printf(p, "NMI: ");
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ", cpu_pda(j)->__nmi_count);
-		seq_putc(p, '\n');
+		seq_printf(p, "  Non-maskable interrupts\n");
 		seq_printf(p, "LOC: ");
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ", cpu_pda(j)->apic_timer_irqs);
-		seq_putc(p, '\n');
+		seq_printf(p, "  Local interrupts\n");
+#ifdef CONFIG_SMP
+		seq_printf(p, "RES: ");
+		for_each_online_cpu(j)
+			seq_printf(p, "%10u ", cpu_pda(j)->irq_resched_counts);
+		seq_printf(p, "  Rescheduling interrupts\n");
+		seq_printf(p, "CAL: ");
+		for_each_online_cpu(j)
+			seq_printf(p, "%10u ", cpu_pda(j)->irq_call_counts);
+		seq_printf(p, "  function call interrupts\n");
+		seq_printf(p, "TLB: ");
+		for_each_online_cpu(j)
+			seq_printf(p, "%10u ", cpu_pda(j)->irq_tlb_counts);
+		seq_printf(p, "  TLB shootdowns\n");
+#endif
+		seq_printf(p, "TRM: ");
+		for_each_online_cpu(j)
+			seq_printf(p, "%10u ", cpu_pda(j)->irq_thermal_counts);
+		seq_printf(p, "  Thermal event interrupts\n");
+		seq_printf(p, "THR: ");
+		for_each_online_cpu(j)
+			seq_printf(p, "%10u ", cpu_pda(j)->irq_threshold_counts);
+		seq_printf(p, "  Threshold APIC interrupts\n");
+		seq_printf(p, "SPU: ");
+		for_each_online_cpu(j)
+			seq_printf(p, "%10u ", cpu_pda(j)->irq_spurious_counts);
+		seq_printf(p, "  Spurious interrupts\n");
 		seq_printf(p, "ERR: %10u\n", atomic_read(&irq_err_count));
 	}
 	return 0;
Index: linux/arch/x86_64/kernel/mce_amd.c
===================================================================
--- linux.orig/arch/x86_64/kernel/mce_amd.c
+++ linux/arch/x86_64/kernel/mce_amd.c
@@ -237,6 +237,7 @@ asmlinkage void mce_threshold_interrupt(
 		}
 	}
 out:
+	add_pda(irq_threshold_counts, 1);
 	irq_exit();
 }
 
Index: linux/arch/x86_64/kernel/mce_intel.c
===================================================================
--- linux.orig/arch/x86_64/kernel/mce_intel.c
+++ linux/arch/x86_64/kernel/mce_intel.c
@@ -26,6 +26,7 @@ asmlinkage void smp_thermal_interrupt(vo
 	if (therm_throt_process(msr_val & 1))
 		mce_log_therm_throt_event(smp_processor_id(), msr_val);
 
+	add_pda(irq_thermal_counts, 1);
 	irq_exit();
 }
 
Index: linux/arch/x86_64/kernel/smp.c
===================================================================
--- linux.orig/arch/x86_64/kernel/smp.c
+++ linux/arch/x86_64/kernel/smp.c
@@ -163,6 +163,7 @@ asmlinkage void smp_invalidate_interrupt
 out:
 	ack_APIC_irq();
 	cpu_clear(cpu, f->flush_cpumask);
+	add_pda(irq_tlb_counts, 1);
 }
 
 static void flush_tlb_others(cpumask_t cpumask, struct mm_struct *mm,
@@ -493,6 +494,7 @@ void smp_send_stop(void)
 asmlinkage void smp_reschedule_interrupt(void)
 {
 	ack_APIC_irq();
+	add_pda(irq_resched_counts, 1);
 }
 
 asmlinkage void smp_call_function_interrupt(void)
@@ -514,6 +516,7 @@ asmlinkage void smp_call_function_interr
 	exit_idle();
 	irq_enter();
 	(*func)(info);
+	add_pda(irq_call_counts, 1);
 	irq_exit();
 	if (wait) {
 		mb();
Index: linux/include/asm-i386/hardirq.h
===================================================================
--- linux.orig/include/asm-i386/hardirq.h
+++ linux/include/asm-i386/hardirq.h
@@ -9,6 +9,11 @@ typedef struct {
 	unsigned long idle_timestamp;
 	unsigned int __nmi_count;	/* arch dependent */
 	unsigned int apic_timer_irqs;	/* arch dependent */
+	unsigned int irq_resched_counts;
+	unsigned int irq_call_counts;
+	unsigned int irq_tlb_counts;
+	unsigned int irq_thermal_counts;
+	unsigned int irq_spurious_counts;
 } ____cacheline_aligned irq_cpustat_t;
 
 DECLARE_PER_CPU(irq_cpustat_t, irq_stat);
Index: linux/include/asm-x86_64/pda.h
===================================================================
--- linux.orig/include/asm-x86_64/pda.h
+++ linux/include/asm-x86_64/pda.h
@@ -29,6 +29,12 @@ struct x8664_pda {
 	short isidle;
 	struct mm_struct *active_mm;
 	unsigned apic_timer_irqs;
+	unsigned irq_resched_counts;
+	unsigned irq_call_counts;
+	unsigned irq_tlb_counts;
+	unsigned irq_thermal_counts;
+	unsigned irq_threshold_counts;
+	unsigned irq_spurious_counts;
 } ____cacheline_aligned_in_smp;
 
 extern struct x8664_pda *_cpu_pda[];
Index: linux/Documentation/filesystems/proc.txt
===================================================================
--- linux.orig/Documentation/filesystems/proc.txt
+++ linux/Documentation/filesystems/proc.txt
@@ -347,7 +347,40 @@ connects the CPUs in a SMP system. This 
 the IO-APIC automatically retry the transmission, so it should not be a big
 problem, but you should read the SMP-FAQ.
 
-In this context it could be interesting to note the new irq directory in 2.4.
+In 2.6.2* /proc/interrupts was expanded again.  This time the goal was for
+/proc/interrupts to display every IRQ vector in use by the system, not
+just those considered 'most important'.  The new vectors are:
+
+  THR -- a threshold interrupt occurs when ECC memory correction is occuring
+  at too high a frequency.  Threshold interrupt machinery is often put
+  into the ECC logic, as occasional ECC memory corrections are part of
+  normal operation (due to random alpha particles), but sequences of
+  ECC corrections or outright failures over some short interval usually
+  indicate a memory chip that is about to fail.  Note that not every
+  platform has ECC threshold logic, and those that do generally require
+  it to be explicitly turned on.
+
+  TRM -- a thermal event interrupt occurs when a temperature threshold
+  has been exceeded for some CPU chip.  This interrupt may also be generated
+  when the temperature drops back to normal.
+
+  SPU -- a spurious interrupt is some interrupt that was raised then lowered
+  by some IO device before it could be fully processed by the APIC.  Hence
+  the APIC sees the interrupt but does not know what device it came from.
+  For this case the APIC will generate the interrupt with a IRQ vector
+  of 0xff.
+
+  RES, CAL, TLB -- rescheduling, call and tlb flush interrupts are
+  sent from one CPU to another per the needs of the OS.  Typically,
+  their statistics are used by kernel developers and interested users to
+  determine the occurance of interrupt floods of the given type.
+
+The above IRQ vectors are displayed only when relevent.  For example,
+the threshold vector does not exist on x86_64 platforms.  Others are
+suppressed when the system is a uniprocessor.  As of this writing, only
+i386 and x86_64 platforms support the new IRQ vector displays.
+
+Of some interest is the introduction of the /proc/irq directory to 2.4.
 It could be used to set IRQ to CPU affinity, this means that you can "hook" an
 IRQ to only one CPU, or to exclude a CPU of handling IRQs. The contents of the
 irq subdir is one subdir for each IRQ, and one file; prof_cpu_mask
