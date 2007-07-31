Return-Path: <linux-kernel-owner+w=401wt.eu-S1764247AbXGaOVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764247AbXGaOVH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 10:21:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763847AbXGaOUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 10:20:37 -0400
Received: from flvpn.ccur.com ([66.10.65.2]:54325 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763518AbXGaOUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 10:20:33 -0400
Date: Tue, 31 Jul 2007 10:19:41 -0400
From: Joe Korty <joe.korty@ccur.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sven-Thorsten Dietrich <sdietrich@novell.com>,
       "H. Peter Anvin" <hpa@zytor.com>, mingo@elte.hu, tglx@linutronix.de,
       linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       jason.baietto@ccur.com
Subject: Re: [PATCH] expand /proc/interrupts to include missing vectors, v3
Message-ID: <20070731141941.GA3112@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
References: <20070726180522.GA1486@tsunami.ccur.com> <46A8EE78.4040702@zytor.com> <1185816797.3170.1.camel@sven.thebigcorporation.com> <20070730123206.abeab890.akpm@linux-foundation.org> <20070731001718.GA14295@tsunami.ccur.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070731001718.GA14295@tsunami.ccur.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ changes from v2:
    added documentation
    merged some #ifdef CONFIG_SMP's
]

Add missing IRQs and IRQ descriptions to /proc/interrupts.

/proc/interrupts is most useful when it displays every
IRQ vector in use by the system, not just those somebody
thought would be interesting.

This patch inserts the following vector displays to the
i386 and x86_64 platforms, as appropriate:
	
	rescheduling interrupts
	TLB flush interrupts
	function call interrupts
	thermal event interrupts
	threshold interrupts
	spurious interrupts

A threshold interrupt occurs when ECC memory correction
is occuring at too high a frequency.  Thresholds are used
by the ECC hardware as occasional ECC failures are part
of normal operation, but long sequences of ECC failures
usually indicate a memory chip that is about to fail.

Thermal event interrupts occur when a temperature threshold
has been exceeded for some CPU chip.  IIRC, thermal interrupts
can also be generated when the temperature drops back to
the normal range.

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
--- 2.6.23-rc1-git7.orig/arch/i386/kernel/apic.c	2007-07-30 19:08:05.000000000 -0400
+++ 2.6.23-rc1-git7/arch/i386/kernel/apic.c	2007-07-30 19:08:07.000000000 -0400
@@ -1280,6 +1280,7 @@
 	printk(KERN_INFO "spurious APIC interrupt on CPU#%d, "
 	       "should never happen.\n", smp_processor_id());
 	irq_exit();
+	__get_cpu_var(irq_stat).irq_spur_counts++;
 }
 
 /*
Index: 2.6.23-rc1-git7/arch/i386/kernel/cpu/mcheck/p4.c
===================================================================
--- 2.6.23-rc1-git7.orig/arch/i386/kernel/cpu/mcheck/p4.c	2007-07-30 19:08:05.000000000 -0400
+++ 2.6.23-rc1-git7/arch/i386/kernel/cpu/mcheck/p4.c	2007-07-30 19:08:07.000000000 -0400
@@ -62,6 +62,7 @@
 	irq_enter();
 	vendor_thermal_interrupt(regs);
 	irq_exit();
+	__get_cpu_var(irq_stat).irq_thermal_counts++;
 }
 
 /* P4/Xeon Thermal regulation detect and init */
Index: 2.6.23-rc1-git7/arch/i386/kernel/irq.c
===================================================================
--- 2.6.23-rc1-git7.orig/arch/i386/kernel/irq.c	2007-07-30 19:08:05.000000000 -0400
+++ 2.6.23-rc1-git7/arch/i386/kernel/irq.c	2007-07-31 09:40:58.000000000 -0400
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
+				per_cpu(irq_stat,j).irq_spur_counts);
+		seq_printf(p, "  Spurious interrupts\n");
 		seq_printf(p, "ERR: %10u\n", atomic_read(&irq_err_count));
 #if defined(CONFIG_X86_IO_APIC)
 		seq_printf(p, "MIS: %10u\n", atomic_read(&irq_mis_count));
Index: 2.6.23-rc1-git7/arch/i386/kernel/smp.c
===================================================================
--- 2.6.23-rc1-git7.orig/arch/i386/kernel/smp.c	2007-07-30 19:08:05.000000000 -0400
+++ 2.6.23-rc1-git7/arch/i386/kernel/smp.c	2007-07-30 19:08:07.000000000 -0400
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
@@ -666,6 +668,7 @@
 		mb();
 		atomic_inc(&call_data->finished);
 	}
+	__get_cpu_var(irq_stat).irq_call_counts++;
 }
 
 static int convert_apicid_to_cpu(int apic_id)
Index: 2.6.23-rc1-git7/arch/x86_64/kernel/apic.c
===================================================================
--- 2.6.23-rc1-git7.orig/arch/x86_64/kernel/apic.c	2007-07-30 19:08:05.000000000 -0400
+++ 2.6.23-rc1-git7/arch/x86_64/kernel/apic.c	2007-07-30 19:08:07.000000000 -0400
@@ -1118,6 +1118,7 @@
 asmlinkage void smp_spurious_interrupt(void)
 {
 	unsigned int v;
+
 	exit_idle();
 	irq_enter();
 	/*
@@ -1130,6 +1131,7 @@
 		ack_APIC_irq();
 
 	irq_exit();
+	add_pda(irq_spur_counts, 1);
 }
 
 /*
Index: 2.6.23-rc1-git7/arch/x86_64/kernel/irq.c
===================================================================
--- 2.6.23-rc1-git7.orig/arch/x86_64/kernel/irq.c	2007-07-30 19:08:05.000000000 -0400
+++ 2.6.23-rc1-git7/arch/x86_64/kernel/irq.c	2007-07-31 09:41:14.000000000 -0400
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
+			seq_printf(p, "%10u ", cpu_pda(j)->irq_spur_counts);
+		seq_printf(p, "  Spurious interrupts\n");
 		seq_printf(p, "ERR: %10u\n", atomic_read(&irq_err_count));
 	}
 	return 0;
Index: 2.6.23-rc1-git7/arch/x86_64/kernel/mce_amd.c
===================================================================
--- 2.6.23-rc1-git7.orig/arch/x86_64/kernel/mce_amd.c	2007-07-30 19:08:05.000000000 -0400
+++ 2.6.23-rc1-git7/arch/x86_64/kernel/mce_amd.c	2007-07-30 19:08:07.000000000 -0400
@@ -238,6 +238,7 @@
 	}
 out:
 	irq_exit();
+	add_pda(irq_threshold_counts, 1);
 }
 
 /*
Index: 2.6.23-rc1-git7/arch/x86_64/kernel/mce_intel.c
===================================================================
--- 2.6.23-rc1-git7.orig/arch/x86_64/kernel/mce_intel.c	2007-07-30 19:08:05.000000000 -0400
+++ 2.6.23-rc1-git7/arch/x86_64/kernel/mce_intel.c	2007-07-30 19:08:07.000000000 -0400
@@ -27,6 +27,7 @@
 		mce_log_therm_throt_event(smp_processor_id(), msr_val);
 
 	irq_exit();
+	add_pda(irq_thermal_counts, 1);
 }
 
 static void __cpuinit intel_init_thermal(struct cpuinfo_x86 *c)
Index: 2.6.23-rc1-git7/arch/x86_64/kernel/smp.c
===================================================================
--- 2.6.23-rc1-git7.orig/arch/x86_64/kernel/smp.c	2007-07-30 19:08:05.000000000 -0400
+++ 2.6.23-rc1-git7/arch/x86_64/kernel/smp.c	2007-07-30 19:08:07.000000000 -0400
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
@@ -519,5 +521,6 @@
 		mb();
 		atomic_inc(&call_data->finished);
 	}
+	add_pda(irq_call_counts, 1);
 }
 
Index: 2.6.23-rc1-git7/include/asm-i386/hardirq.h
===================================================================
--- 2.6.23-rc1-git7.orig/include/asm-i386/hardirq.h	2007-07-30 19:08:05.000000000 -0400
+++ 2.6.23-rc1-git7/include/asm-i386/hardirq.h	2007-07-30 19:08:07.000000000 -0400
@@ -9,6 +9,11 @@
 	unsigned long idle_timestamp;
 	unsigned int __nmi_count;	/* arch dependent */
 	unsigned int apic_timer_irqs;	/* arch dependent */
+	unsigned int irq_resched_counts;
+	unsigned int irq_call_counts;
+	unsigned int irq_tlb_counts;
+	unsigned int irq_thermal_counts;
+	unsigned int irq_spur_counts;
 } ____cacheline_aligned irq_cpustat_t;
 
 DECLARE_PER_CPU(irq_cpustat_t, irq_stat);
Index: 2.6.23-rc1-git7/include/asm-x86_64/pda.h
===================================================================
--- 2.6.23-rc1-git7.orig/include/asm-x86_64/pda.h	2007-07-30 19:08:05.000000000 -0400
+++ 2.6.23-rc1-git7/include/asm-x86_64/pda.h	2007-07-30 19:08:07.000000000 -0400
@@ -29,6 +29,12 @@
 	short isidle;
 	struct mm_struct *active_mm;
 	unsigned apic_timer_irqs;
+	unsigned irq_resched_counts;
+	unsigned irq_call_counts;
+	unsigned irq_tlb_counts;
+	unsigned irq_thermal_counts;
+	unsigned irq_threshold_counts;
+	unsigned irq_spur_counts;
 } ____cacheline_aligned_in_smp;
 
 extern struct x8664_pda *_cpu_pda[];
Index: 2.6.23-rc1-git7/arch/i386/mach-voyager/voyager_smp.c
===================================================================
--- 2.6.23-rc1-git7.orig/arch/i386/mach-voyager/voyager_smp.c	2007-07-30 19:08:05.000000000 -0400
+++ 2.6.23-rc1-git7/arch/i386/mach-voyager/voyager_smp.c	2007-07-30 19:08:07.000000000 -0400
@@ -1042,6 +1042,7 @@
 		mb();
 		clear_bit(cpu, &call_data->finished);
 	}
+	__get_cpu_var(irq_stat).irq_call_counts++;
 }
 
 static int
Index: 2.6.23-rc1-git7/arch/i386/xen/smp.c
===================================================================
--- 2.6.23-rc1-git7.orig/arch/i386/xen/smp.c	2007-07-30 19:08:05.000000000 -0400
+++ 2.6.23-rc1-git7/arch/i386/xen/smp.c	2007-07-30 19:08:07.000000000 -0400
@@ -352,6 +352,7 @@
 		mb();		/* commit everything before setting finished */
 		atomic_inc(&call_data->finished);
 	}
+	__get_cpu_var(irq_stat).irq_call_counts++;
 
 	return IRQ_HANDLED;
 }
Index: 2.6.23-rc1-git7/Documentation/filesystems/proc.txt
===================================================================
--- 2.6.23-rc1-git7.orig/Documentation/filesystems/proc.txt	2007-07-30 17:32:48.000000000 -0400
+++ 2.6.23-rc1-git7/Documentation/filesystems/proc.txt	2007-07-31 10:12:48.000000000 -0400
@@ -347,7 +347,37 @@
 the IO-APIC automatically retry the transmission, so it should not be a big
 problem, but you should read the SMP-FAQ.
 
-In this context it could be interesting to note the new irq directory in 2.4.
+In 2.6.2* /proc/interrupts was expanded again.  This time the goal was for
+/proc/interrupts to display every IRQ vector in use by the system, not
+just those considered 'most important'.  The new vectors are:
+
+  THR -- a threshold interrupt occurs when ECC memory correction is
+  occuring at too high a frequency.  Threshold interrupt machinery is
+  often put into the ECC logic, as occasional ECC memory failures are
+  part of normal memory operation, but sequences of ECC failures over
+  some short interval usually indicate a memory chip that is about to fail.
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
