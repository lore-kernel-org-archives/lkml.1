Return-Path: <linux-kernel-owner+w=401wt.eu-S1762351AbXGaVIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762351AbXGaVIA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 17:08:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755340AbXGaVHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 17:07:38 -0400
Received: from users.ccur.com ([66.10.65.2]:59440 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753455AbXGaVHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 17:07:34 -0400
Date: Tue, 31 Jul 2007 17:06:32 -0400
From: Joe Korty <joe.korty@ccur.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sven-Thorsten Dietrich <sdietrich@novell.com>,
       "H. Peter Anvin" <hpa@zytor.com>, mingo@elte.hu, tglx@linutronix.de,
       linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       jason.baietto@ccur.com
Subject: [PATCH] expand /proc/interrupts to include missing vectors, v4
Message-ID: <20070731210632.GA13866@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
References: <20070726180522.GA1486@tsunami.ccur.com> <46A8EE78.4040702@zytor.com> <1185816797.3170.1.camel@sven.thebigcorporation.com> <20070730123206.abeab890.akpm@linux-foundation.org> <20070731001718.GA14295@tsunami.ccur.com> <20070731141941.GA3112@tsunami.ccur.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070731141941.GA3112@tsunami.ccur.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ v3-v4 changelog:
    s/irq_spur_counts/irq_spurious_counts/g (Andrew Morton)
    tweaked documentation (Andi Kleen)
    moved increments before irq_exit as appropriate (Andi Kleen)
    whitespace cleanup (Andi Kleen)
]

Add missing IRQs and IRQ descriptions to /proc/interrupts,
version 4.

/proc/interrupts is most useful when it displays every
IRQ vector in use by the system, not just those somebody
thought would be interesting.

This patch inserts the following vector displays to the
i386 and x86_64 platforms.
	
	rescheduling interrupts
	TLB flush interrupts
	function call interrupts
	thermal event interrupts
	threshold interrupts
	spurious interrupts

A threshold interrupt occurs when ECC memory correction
is occuring at too high a frequency.  Thresholds are used
by the ECC hardware as occasional ECC corrections are part
of normal operation (alpha particles), but long sequences
of ECC corrections usually indicate a memory chip that
is about to fail.  Note that not every system has ECC
threshold logic, and those that do, can require it to
be specifically enabled.

Thermal event interrupts occur when a temperature threshold
has been exceeded for some CPU chip.  I am not sure,
but I think a thermal interrupt is also generated when
the temperature drops back to a normal level.

A spurious interrupt is an interrupt that was raised then
lowered by the device before it could be fully processed
by the APIC.  Hence the apic sees the interrupt but does
not know what device it came from.  For this case the APIC
hardware will assume a vector of 0xff.

Rescheduling, call, and TLB flush interrupts are sent from
one CPU to another per the needs of the OS.  Typically,
their statistics would be used to discover interrupt
flooding.

Signed-off-by: Joe Korty <joe.korty@ccur.com>

Index: 2.6.23-rc1-git7/arch/i386/kernel/apic.c
===================================================================
--- 2.6.23-rc1-git7.orig/arch/i386/kernel/apic.c	2007-07-31 16:31:09.000000000 -0400
+++ 2.6.23-rc1-git7/arch/i386/kernel/apic.c	2007-07-31 16:45:30.000000000 -0400
@@ -1279,6 +1279,7 @@
 	/* see sw-dev-man vol 3, chapter 7.4.13.5 */
 	printk(KERN_INFO "spurious APIC interrupt on CPU#%d, "
 	       "should never happen.\n", smp_processor_id());
+	__get_cpu_var(irq_stat).irq_spurious_counts++;
 	irq_exit();
 }
 
Index: 2.6.23-rc1-git7/arch/i386/kernel/cpu/mcheck/p4.c
===================================================================
--- 2.6.23-rc1-git7.orig/arch/i386/kernel/cpu/mcheck/p4.c	2007-07-31 16:31:09.000000000 -0400
+++ 2.6.23-rc1-git7/arch/i386/kernel/cpu/mcheck/p4.c	2007-07-31 16:45:30.000000000 -0400
@@ -61,6 +61,7 @@
 {
 	irq_enter();
 	vendor_thermal_interrupt(regs);
+	__get_cpu_var(irq_stat).irq_thermal_counts++;
 	irq_exit();
 }
 
Index: 2.6.23-rc1-git7/arch/i386/kernel/irq.c
===================================================================
--- 2.6.23-rc1-git7.orig/arch/i386/kernel/irq.c	2007-07-31 16:31:09.000000000 -0400
+++ 2.6.23-rc1-git7/arch/i386/kernel/irq.c	2007-07-31 16:45:30.000000000 -0400
@@ -284,14 +284,41 @@
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
Index: 2.6.23-rc1-git7/arch/i386/kernel/smp.c
===================================================================
--- 2.6.23-rc1-git7.orig/arch/i386/kernel/smp.c	2007-07-31 16:31:09.000000000 -0400
+++ 2.6.23-rc1-git7/arch/i386/kernel/smp.c	2007-07-31 16:45:30.000000000 -0400
@@ -342,6 +342,7 @@
 	smp_mb__after_clear_bit();
 out:
 	put_cpu_no_resched();
+	__get_cpu_var(irq_stat).irq_tlb_counts++;
 }
 
 void native_flush_tlb_others(const cpumask_t *cpumaskp, struct mm_struct *mm,
@@ -640,6 +641,7 @@
 fastcall void smp_reschedule_interrupt(struct pt_regs *regs)
 {
 	ack_APIC_irq();
+	__get_cpu_var(irq_stat).irq_resched_counts++;
 }
 
 fastcall void smp_call_function_interrupt(struct pt_regs *regs)
@@ -660,6 +662,7 @@
 	 */
 	irq_enter();
 	(*func)(info);
+	__get_cpu_var(irq_stat).irq_call_counts++;
 	irq_exit();
 
 	if (wait) {
Index: 2.6.23-rc1-git7/arch/x86_64/kernel/apic.c
===================================================================
--- 2.6.23-rc1-git7.orig/arch/x86_64/kernel/apic.c	2007-07-31 16:31:09.000000000 -0400
+++ 2.6.23-rc1-git7/arch/x86_64/kernel/apic.c	2007-07-31 16:45:30.000000000 -0400
@@ -1129,6 +1129,7 @@
 	if (v & (1 << (SPURIOUS_APIC_VECTOR & 0x1f)))
 		ack_APIC_irq();
 
+	add_pda(irq_spurious_counts, 1);
 	irq_exit();
 }
 
Index: 2.6.23-rc1-git7/arch/x86_64/kernel/irq.c
===================================================================
--- 2.6.23-rc1-git7.orig/arch/x86_64/kernel/irq.c	2007-07-31 16:31:09.000000000 -0400
+++ 2.6.23-rc1-git7/arch/x86_64/kernel/irq.c	2007-07-31 16:45:30.000000000 -0400
@@ -88,11 +88,37 @@
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
Index: 2.6.23-rc1-git7/arch/x86_64/kernel/mce_amd.c
===================================================================
--- 2.6.23-rc1-git7.orig/arch/x86_64/kernel/mce_amd.c	2007-07-31 16:31:09.000000000 -0400
+++ 2.6.23-rc1-git7/arch/x86_64/kernel/mce_amd.c	2007-07-31 16:45:30.000000000 -0400
@@ -237,6 +237,7 @@
 		}
 	}
 out:
+	add_pda(irq_threshold_counts, 1);
 	irq_exit();
 }
 
Index: 2.6.23-rc1-git7/arch/x86_64/kernel/mce_intel.c
===================================================================
--- 2.6.23-rc1-git7.orig/arch/x86_64/kernel/mce_intel.c	2007-07-31 16:31:09.000000000 -0400
+++ 2.6.23-rc1-git7/arch/x86_64/kernel/mce_intel.c	2007-07-31 16:45:30.000000000 -0400
@@ -26,6 +26,7 @@
 	if (therm_throt_process(msr_val & 1))
 		mce_log_therm_throt_event(smp_processor_id(), msr_val);
 
+	add_pda(irq_thermal_counts, 1);
 	irq_exit();
 }
 
Index: 2.6.23-rc1-git7/arch/x86_64/kernel/smp.c
===================================================================
--- 2.6.23-rc1-git7.orig/arch/x86_64/kernel/smp.c	2007-07-31 16:31:09.000000000 -0400
+++ 2.6.23-rc1-git7/arch/x86_64/kernel/smp.c	2007-07-31 16:45:30.000000000 -0400
@@ -163,6 +163,7 @@
 out:
 	ack_APIC_irq();
 	cpu_clear(cpu, f->flush_cpumask);
+	add_pda(irq_tlb_counts, 1);
 }
 
 static void flush_tlb_others(cpumask_t cpumask, struct mm_struct *mm,
@@ -493,6 +494,7 @@
 asmlinkage void smp_reschedule_interrupt(void)
 {
 	ack_APIC_irq();
+	add_pda(irq_resched_counts, 1);
 }
 
 asmlinkage void smp_call_function_interrupt(void)
@@ -514,6 +516,7 @@
 	exit_idle();
 	irq_enter();
 	(*func)(info);
+	add_pda(irq_call_counts, 1);
 	irq_exit();
 	if (wait) {
 		mb();
Index: 2.6.23-rc1-git7/include/asm-i386/hardirq.h
===================================================================
--- 2.6.23-rc1-git7.orig/include/asm-i386/hardirq.h	2007-07-31 16:31:09.000000000 -0400
+++ 2.6.23-rc1-git7/include/asm-i386/hardirq.h	2007-07-31 16:45:30.000000000 -0400
@@ -9,6 +9,11 @@
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
Index: 2.6.23-rc1-git7/include/asm-x86_64/pda.h
===================================================================
--- 2.6.23-rc1-git7.orig/include/asm-x86_64/pda.h	2007-07-31 16:31:09.000000000 -0400
+++ 2.6.23-rc1-git7/include/asm-x86_64/pda.h	2007-07-31 16:45:30.000000000 -0400
@@ -29,6 +29,12 @@
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
Index: 2.6.23-rc1-git7/arch/i386/mach-voyager/voyager_smp.c
===================================================================
--- 2.6.23-rc1-git7.orig/arch/i386/mach-voyager/voyager_smp.c	2007-07-31 16:31:09.000000000 -0400
+++ 2.6.23-rc1-git7/arch/i386/mach-voyager/voyager_smp.c	2007-07-31 16:45:30.000000000 -0400
@@ -1037,6 +1037,7 @@
 	 */
 	irq_enter();
 	(*func)(info);
+	__get_cpu_var(irq_stat).irq_call_counts++;
 	irq_exit();
 	if (wait) {
 		mb();
Index: 2.6.23-rc1-git7/arch/i386/xen/smp.c
===================================================================
--- 2.6.23-rc1-git7.orig/arch/i386/xen/smp.c	2007-07-31 16:31:09.000000000 -0400
+++ 2.6.23-rc1-git7/arch/i386/xen/smp.c	2007-07-31 16:45:30.000000000 -0400
@@ -346,6 +346,7 @@
 	 */
 	irq_enter();
 	(*func)(info);
+	__get_cpu_var(irq_stat).irq_call_counts++;
 	irq_exit();
 
 	if (wait) {
Index: 2.6.23-rc1-git7/Documentation/filesystems/proc.txt
===================================================================
--- 2.6.23-rc1-git7.orig/Documentation/filesystems/proc.txt	2007-07-31 16:31:09.000000000 -0400
+++ 2.6.23-rc1-git7/Documentation/filesystems/proc.txt	2007-07-31 16:45:30.000000000 -0400
@@ -347,7 +347,40 @@
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

