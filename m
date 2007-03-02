Return-Path: <linux-kernel-owner+w=401wt.eu-S1422726AbXCBCyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422726AbXCBCyS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 21:54:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422727AbXCBCyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 21:54:18 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:53678 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422726AbXCBCyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 21:54:16 -0500
Date: Thu, 1 Mar 2007 18:54:14 -0800
Message-Id: <200703020254.l222sDUV009650@zach-dev.vmware.com>
Subject: [PATCH 1/9] Vmi timer fixes round two.patch
From: Zachary Amsden <zach@vmware.com>
To: Andi Kleen <ak@muc.de>, Linus Torvalds <torvalds@osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>, Dan Hecht <dhecht@vmware.com>,
       Dan Arai <arai@vmware.com>, Andrew Morton <akpm@osdl.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>
CC: Dan Hecht <dhecht@vmware.com>
X-OriginalArrivalTime: 02 Mar 2007 02:54:14.0639 (UTC) FILETIME=[0FEC4FF0:01C75C76]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Critical bugfixes for the VMI-Timer code.

1) Do not setup a one shot alarm if we are keeping the periodic alarm
armed.  Additionally, since the periodic alarm can be run at a lower
rate than HZ, let's fixup the guard to the no-idle-hz mode appropriately.
This fixes the bug where the no-idle-hz mode might have a higher interrupt
rate than the non-idle case.

2) The interrupt handler can no longer adjust xtime due to nested lock
acquisition.  Drop this.  We don't need to check for wallclock time at
every tick, it can be done in userspace instead.

3) Add a bypass to disable noidle operation.  This is useful as a last
minute workaround, or testing measure.

4) The code to skip the IO_APIC timer testing (no_timer_check) should be
conditional on IO_APIC, not SMP, since UP kernels can have this configured
in as well.

Signed-off-by: Dan Hecht <dhecht@vmware.com>
Signed-off-by: Zachary Amsden <zach@vmware.com>

diff -r f62ebe3ba01c arch/i386/kernel/vmi.c
--- a/arch/i386/kernel/vmi.c	Tue Feb 27 14:01:28 2007 -0800
+++ b/arch/i386/kernel/vmi.c	Tue Feb 27 14:12:46 2007 -0800
@@ -54,6 +54,7 @@ static int disable_sep;
 static int disable_sep;
 static int disable_tsc;
 static int disable_mtrr;
+static int disable_noidle;
 
 /* Cached VMI operations */
 struct {
@@ -255,7 +256,6 @@ static void vmi_nop(void)
 }
 
 /* For NO_IDLE_HZ, we stop the clock when halting the kernel */
-#ifdef CONFIG_NO_IDLE_HZ
 static fastcall void vmi_safe_halt(void)
 {
 	int idle = vmi_stop_hz_timer();
@@ -266,7 +266,6 @@ static fastcall void vmi_safe_halt(void)
 		local_irq_enable();
 	}
 }
-#endif
 
 #ifdef CONFIG_DEBUG_PAGE_TYPE
 
@@ -742,12 +741,7 @@ static inline int __init activate_vmi(vo
 		     (char *)paravirt_ops.save_fl);
 	patch_offset(&irq_save_disable_callout[IRQ_PATCH_DISABLE],
 		     (char *)paravirt_ops.irq_disable);
-#ifndef CONFIG_NO_IDLE_HZ
-	para_fill(safe_halt, Halt);
-#else
-	vmi_ops.halt = vmi_get_function(VMI_CALL_Halt);
-	paravirt_ops.safe_halt = vmi_safe_halt;
-#endif
+
 	para_fill(wbinvd, WBINVD);
 	/* paravirt_ops.read_msr = vmi_rdmsr */
 	/* paravirt_ops.write_msr = vmi_wrmsr */
@@ -881,6 +875,12 @@ static inline int __init activate_vmi(vo
 #endif
 		custom_sched_clock = vmi_sched_clock;
 	}
+	if (!disable_noidle)
+		para_fill(safe_halt, Halt);
+	else {
+		vmi_ops.halt = vmi_get_function(VMI_CALL_Halt);
+		paravirt_ops.safe_halt = vmi_safe_halt;
+	}
 
 	/*
 	 * Alternative instruction rewriting doesn't happen soon enough
@@ -914,9 +914,11 @@ void __init vmi_init(void)
 
 	local_irq_save(flags);
 	activate_vmi();
-#ifdef CONFIG_SMP
+
+#ifdef CONFIG_X86_IO_APIC
 	no_timer_check = 1;
 #endif
+
 	local_irq_restore(flags & X86_EFLAGS_IF);
 }
 
@@ -942,7 +944,8 @@ static int __init parse_vmi(char *arg)
 	} else if (!strcmp(arg, "disable_mtrr")) {
 		clear_bit(X86_FEATURE_MTRR, boot_cpu_data.x86_capability);
 		disable_mtrr = 1;
-	}
+	} else if (!strcmp(arg, "disable_noidle"))
+		disable_noidle = 1;
 	return 0;
 }
 
diff -r f62ebe3ba01c arch/i386/kernel/vmitime.c
--- a/arch/i386/kernel/vmitime.c	Tue Feb 27 14:01:28 2007 -0800
+++ b/arch/i386/kernel/vmitime.c	Tue Feb 27 14:12:01 2007 -0800
@@ -276,15 +276,12 @@ static void vmi_account_real_cycles(unsi
 
 	cycles_not_accounted = cur_real_cycles - real_cycles_accounted_system;
 	while (cycles_not_accounted >= cycles_per_jiffy) {
-		/* systems wide jiffies and wallclock. */
+		/* systems wide jiffies. */
 		do_timer(1);
 
 		cycles_not_accounted -= cycles_per_jiffy;
 		real_cycles_accounted_system += cycles_per_jiffy;
 	}
-
-	if (vmi_timer_ops.wallclock_updated())
-		update_xtime_from_wallclock();
 
 	write_sequnlock(&xtime_lock);
 }
@@ -380,7 +377,6 @@ int vmi_stop_hz_timer(void)
 	unsigned long seq, next;
 	unsigned long long real_cycles_expiry;
 	int cpu = smp_processor_id();
-	int idle;
 
 	BUG_ON(!irqs_disabled());
 	if (sysctl_hz_timer != 0)
@@ -388,13 +384,13 @@ int vmi_stop_hz_timer(void)
 
 	cpu_set(cpu, nohz_cpu_mask);
 	smp_mb();
+
 	if (rcu_needs_cpu(cpu) || local_softirq_pending() ||
-	    (next = next_timer_interrupt(), time_before_eq(next, jiffies))) {
+	    (next = next_timer_interrupt(), 
+	     time_before_eq(next, jiffies + HZ/CONFIG_VMI_ALARM_HZ))) {
 		cpu_clear(cpu, nohz_cpu_mask);
-		next = jiffies;
-		idle = 0;
-	} else
-		idle = 1;
+		return 0;
+	}
 
 	/* Convert jiffies to the real cycle counter. */
 	do {
@@ -404,17 +400,13 @@ int vmi_stop_hz_timer(void)
 	} while (read_seqretry(&xtime_lock, seq));
 
 	/* This cpu is going idle. Disable the periodic alarm. */
-	if (idle) {
-		vmi_timer_ops.cancel_alarm(VMI_CYCLES_AVAILABLE);
-		per_cpu(idle_start_jiffies, cpu) = jiffies;
-	}
-
+	vmi_timer_ops.cancel_alarm(VMI_CYCLES_AVAILABLE);
+	per_cpu(idle_start_jiffies, cpu) = jiffies;
 	/* Set the real time alarm to expire at the next event. */
 	vmi_timer_ops.set_alarm(
-		      VMI_ALARM_WIRING | VMI_ALARM_IS_ONESHOT | VMI_CYCLES_REAL,
-		      real_cycles_expiry, 0);
-
-	return idle;
+		VMI_ALARM_WIRING | VMI_ALARM_IS_ONESHOT | VMI_CYCLES_REAL,
+		real_cycles_expiry, 0);
+	return 1;
 }
 
 static void vmi_reenable_hz_timer(int cpu)
