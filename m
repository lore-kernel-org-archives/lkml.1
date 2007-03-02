Return-Path: <linux-kernel-owner+w=401wt.eu-S1422729AbXCBCyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422729AbXCBCyp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 21:54:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422734AbXCBCyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 21:54:44 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:53695 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422732AbXCBCyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 21:54:40 -0500
Date: Thu, 1 Mar 2007 18:54:38 -0800
Message-Id: <200703020254.l222sc8H009662@zach-dev.vmware.com>
Subject: [PATCH 3/9] Vmi cpu cycles.patch
From: Zachary Amsden <zach@vmware.com>
To: Andi Kleen <ak@muc.de>, Linus Torvalds <torvalds@osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>, Dan Hecht <dhecht@vmware.com>,
       Dan Arai <arai@vmware.com>, Andrew Morton <akpm@osdl.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>
Cc: Daniel Hecht <dhecht@vmware.com>
X-OriginalArrivalTime: 02 Mar 2007 02:54:38.0914 (UTC) FILETIME=[1E646220:01C75C76]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In order to share the common code in tsc.c which does CPU Khz calibration, we
need to make an accurate value of CPU speed available to the tsc.c code.
This value loses a lot of precision in a VM because of the timing differences
with real hardware, but we need it to be as precise as possible so the guest
can make accurate time calculations with the cycle counters.

Signed-off-by: Zachary Amsden <zach@vmware.com>

diff -r b8b315c897bb arch/i386/kernel/vmi.c
--- a/arch/i386/kernel/vmi.c	Tue Feb 27 14:04:43 2007 -0800
+++ b/arch/i386/kernel/vmi.c	Tue Feb 27 14:06:46 2007 -0800
@@ -874,6 +874,7 @@ static inline int __init activate_vmi(vo
 		paravirt_ops.setup_secondary_clock = vmi_timer_setup_secondary_alarm;
 #endif
 		paravirt_ops.get_scheduled_cycles = vmi_get_sched_cycles;
+ 		paravirt_ops.get_cpu_khz = vmi_cpu_khz;
 	}
 	if (!disable_noidle)
 		para_fill(safe_halt, Halt);
diff -r b8b315c897bb arch/i386/kernel/vmitime.c
--- a/arch/i386/kernel/vmitime.c	Tue Feb 27 14:04:43 2007 -0800
+++ b/arch/i386/kernel/vmitime.c	Tue Feb 27 14:06:46 2007 -0800
@@ -177,6 +177,15 @@ unsigned long long vmi_get_sched_cycles(
 	return read_available_cycles();
 }
 
+unsigned long vmi_cpu_khz(void)
+{
+	unsigned long long khz;
+
+	khz = vmi_timer_ops.get_cycle_frequency();
+	(void)do_div(khz, 1000);
+	return khz;
+}
+
 void __init vmi_time_init(void)
 {
 	unsigned long long cycles_per_sec, cycles_per_msec;
@@ -206,7 +215,6 @@ void __init vmi_time_init(void)
 	(void)do_div(cycles_per_alarm, alarm_hz);
 	cycles_per_msec = cycles_per_sec;
 	(void)do_div(cycles_per_msec, 1000);
-	cpu_khz = cycles_per_msec;
 
 	printk(KERN_WARNING "VMI timer cycles/sec = %llu ; cycles/jiffy = %llu ;"
 	       "cycles/alarm = %llu\n", cycles_per_sec, cycles_per_jiffy,
diff -r b8b315c897bb include/asm-i386/vmi_time.h
--- a/include/asm-i386/vmi_time.h	Tue Feb 27 14:04:43 2007 -0800
+++ b/include/asm-i386/vmi_time.h	Tue Feb 27 14:06:46 2007 -0800
@@ -50,6 +50,7 @@ extern unsigned long vmi_get_wallclock(v
 extern unsigned long vmi_get_wallclock(void);
 extern int vmi_set_wallclock(unsigned long now);
 extern unsigned long long vmi_get_sched_cycles(void);
+extern unsigned long vmi_cpu_khz(void);
 
 #ifdef CONFIG_X86_LOCAL_APIC
 extern void __init vmi_timer_setup_boot_alarm(void);
diff -r b8b315c897bb arch/i386/kernel/paravirt.c
--- a/arch/i386/kernel/paravirt.c	Tue Feb 27 14:04:43 2007 -0800
+++ b/arch/i386/kernel/paravirt.c	Tue Feb 27 14:08:59 2007 -0800
@@ -522,6 +522,7 @@ struct paravirt_ops paravirt_ops = {
 	.read_tsc = native_read_tsc,
 	.read_pmc = native_read_pmc,
 	.get_scheduled_cycles = native_read_tsc,
+	.get_cpu_khz = native_calculate_cpu_khz,
 	.load_tr_desc = native_load_tr_desc,
 	.set_ldt = native_set_ldt,
 	.load_gdt = native_load_gdt,
diff -r b8b315c897bb arch/i386/kernel/tsc.c
--- a/arch/i386/kernel/tsc.c	Tue Feb 27 14:04:43 2007 -0800
+++ b/arch/i386/kernel/tsc.c	Tue Feb 27 14:09:23 2007 -0800
@@ -117,7 +117,7 @@ unsigned long long sched_clock(void)
 	return cycles_2_ns(this_offset);
 }
 
-static unsigned long calculate_cpu_khz(void)
+unsigned long native_calculate_cpu_khz(void)
 {
 	unsigned long long start, end;
 	unsigned long count;
diff -r b8b315c897bb include/asm-i386/paravirt.h
--- a/include/asm-i386/paravirt.h	Tue Feb 27 14:04:43 2007 -0800
+++ b/include/asm-i386/paravirt.h	Tue Feb 27 14:10:25 2007 -0800
@@ -95,6 +95,7 @@ struct paravirt_ops
 	u64 (*read_tsc)(void);
 	u64 (*read_pmc)(void);
  	u64 (*get_scheduled_cycles)(void);
+	unsigned long (*get_cpu_khz)(void);
 
 	void (*load_tr_desc)(void);
 	void (*load_gdt)(const struct Xgt_desc_struct *);
@@ -275,6 +276,7 @@ static inline void halt(void)
 #define rdtscll(val) (val = paravirt_ops.read_tsc())
 
 #define get_scheduled_cycles(val) (val = paravirt_ops.get_scheduled_cycles())
+#define calculate_cpu_khz() (paravirt_ops.get_cpu_khz())
 
 #define write_tsc(val1,val2) wrmsr(0x10, val1, val2)
 
diff -r b8b315c897bb include/asm-i386/timer.h
--- a/include/asm-i386/timer.h	Tue Feb 27 14:04:43 2007 -0800
+++ b/include/asm-i386/timer.h	Tue Feb 27 14:11:35 2007 -0800
@@ -7,6 +7,7 @@
 
 void setup_pit_timer(void);
 unsigned long long native_sched_clock(void);
+unsigned long native_calculate_cpu_khz(void);
 
 /* Modifiers for buggy PIT handling */
 extern int pit_latch_buggy;
@@ -17,6 +18,7 @@ extern int recalibrate_cpu_khz(void);
 
 #ifndef CONFIG_PARAVIRT
 #define get_scheduled_cycles(val) rdtscll(val)
+#define calculate_cpu_khz() native_calculate_cpu_khz()
 #endif
 
 #endif
