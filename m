Return-Path: <linux-kernel-owner+w=401wt.eu-S1752654AbXBFDws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654AbXBFDws (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 22:52:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752673AbXBFDws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 22:52:48 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:49469 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752647AbXBFDwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 22:52:42 -0500
Date: Mon, 5 Feb 2007 19:52:40 -0800
Message-Id: <200702060352.l163qeAf000727@zach-dev.vmware.com>
Subject: [PATCH 2/11] Sched clock paravirt op
From: Zachary Amsden <zach@vmware.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@muc.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>
X-OriginalArrivalTime: 06 Feb 2007 03:52:40.0846 (UTC) FILETIME=[3FDF0AE0:01C749A2]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff -r 3e746c0ebcdf arch/i386/kernel/paravirt.c
--- a/arch/i386/kernel/paravirt.c	Fri Feb 02 13:54:53 2007 -0800
+++ b/arch/i386/kernel/paravirt.c	Fri Feb 02 15:27:50 2007 -0800
@@ -32,6 +32,7 @@
 #include <asm/fixmap.h>
 #include <asm/apic.h>
 #include <asm/tlbflush.h>
+#include <asm/timer.h>
 
 /* nop stub */
 static void native_nop(void)
@@ -523,6 +524,8 @@ struct paravirt_ops paravirt_ops = {
 	.write_msr = native_write_msr,
 	.read_tsc = native_read_tsc,
 	.read_pmc = native_read_pmc,
+	.get_scheduled_cycles = native_read_tsc,
+	.get_cpu_khz = native_calculate_cpu_khz,
 	.load_tr_desc = native_load_tr_desc,
 	.set_ldt = native_set_ldt,
 	.load_gdt = native_load_gdt,
diff -r 3e746c0ebcdf arch/i386/kernel/tsc.c
--- a/arch/i386/kernel/tsc.c	Fri Feb 02 13:54:53 2007 -0800
+++ b/arch/i386/kernel/tsc.c	Fri Feb 02 13:54:53 2007 -0800
@@ -14,6 +14,7 @@
 #include <asm/delay.h>
 #include <asm/tsc.h>
 #include <asm/io.h>
+#include <asm/timer.h>
 
 #include "mach_timer.h"
 
@@ -102,9 +103,6 @@ unsigned long long sched_clock(void)
 {
 	unsigned long long this_offset;
 
-	if (unlikely(custom_sched_clock))
-		return (*custom_sched_clock)();
-
 	/*
 	 * Fall back to jiffies if there's no TSC available:
 	 */
@@ -113,13 +111,13 @@ unsigned long long sched_clock(void)
 		return (jiffies_64 - INITIAL_JIFFIES) * (1000000000 / HZ);
 
 	/* read the Time Stamp Counter: */
-	rdtscll(this_offset);
+	get_scheduled_cycles(this_offset);
 
 	/* return the value in ns */
 	return cycles_2_ns(this_offset);
 }
 
-static unsigned long calculate_cpu_khz(void)
+unsigned long native_calculate_cpu_khz(void)
 {
 	unsigned long long start, end;
 	unsigned long count;
diff -r 3e746c0ebcdf arch/i386/kernel/vmi.c
--- a/arch/i386/kernel/vmi.c	Fri Feb 02 13:54:53 2007 -0800
+++ b/arch/i386/kernel/vmi.c	Fri Feb 02 15:32:20 2007 -0800
@@ -880,7 +880,7 @@ static int __init activate_vmi(void)
 		paravirt_ops.setup_boot_clock = vmi_timer_setup_boot_alarm;
 		paravirt_ops.setup_secondary_clock = vmi_timer_setup_secondary_alarm;
 #endif
-		custom_sched_clock = vmi_sched_clock;
+		paravirt_ops.get_scheduled_cycles = vmi_get_sched_cycles;
 	}
 
 	/*
diff -r 3e746c0ebcdf include/asm-i386/paravirt.h
--- a/include/asm-i386/paravirt.h	Fri Feb 02 13:54:53 2007 -0800
+++ b/include/asm-i386/paravirt.h	Fri Feb 02 15:27:50 2007 -0800
@@ -94,6 +94,8 @@ struct paravirt_ops
 
 	u64 (fastcall *read_tsc)(void);
 	u64 (fastcall *read_pmc)(void);
+	u64 (*get_scheduled_cycles)(void);
+	unsigned long (*get_cpu_khz)(void);
 
 	void (fastcall *load_tr_desc)(void);
 	void (fastcall *load_gdt)(const struct Xgt_desc_struct *);
@@ -273,6 +275,9 @@ static inline void halt(void)
 
 #define rdtscll(val) (val = paravirt_ops.read_tsc())
 
+#define get_scheduled_cycles(val) (val = paravirt_ops.get_scheduled_cycles())
+#define calculate_cpu_khz() (paravirt_ops.get_cpu_khz())
+
 #define write_tsc(val1,val2) wrmsr(0x10, val1, val2)
 
 #define rdpmc(counter,low,high) do {				\
diff -r 3e746c0ebcdf include/asm-i386/time.h
--- a/include/asm-i386/time.h	Fri Feb 02 13:54:53 2007 -0800
+++ b/include/asm-i386/time.h	Fri Feb 02 15:27:50 2007 -0800
@@ -30,7 +30,6 @@ static inline int native_set_wallclock(u
 
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
-extern unsigned long long native_sched_clock(void);
 #else /* !CONFIG_PARAVIRT */
 
 #define get_wallclock() native_get_wallclock()
diff -r 3e746c0ebcdf include/asm-i386/timer.h
--- a/include/asm-i386/timer.h	Fri Feb 02 13:54:53 2007 -0800
+++ b/include/asm-i386/timer.h	Fri Feb 02 13:54:53 2007 -0800
@@ -4,13 +4,21 @@
 #include <linux/pm.h>
 
 #define TICK_SIZE (tick_nsec / 1000)
+
 void setup_pit_timer(void);
+unsigned long long native_sched_clock(void);
+unsigned long native_calculate_cpu_khz(void);
+
 /* Modifiers for buggy PIT handling */
 extern int pit_latch_buggy;
 extern int timer_ack;
 extern int no_timer_check;
-extern unsigned long long (*custom_sched_clock)(void);
 extern int no_sync_cmos_clock;
 extern int recalibrate_cpu_khz(void);
 
+#ifndef CONFIG_PARAVIRT
+#define get_scheduled_cycles(val) rdtscll(val)
+#define calculate_cpu_khz() native_calculate_cpu_khz()
 #endif
+
+#endif
diff -r 3e746c0ebcdf arch/i386/kernel/vmitime.c
--- a/arch/i386/kernel/vmitime.c	Fri Feb 02 13:54:53 2007 -0800
+++ b/arch/i386/kernel/vmitime.c	Fri Feb 02 15:31:35 2007 -0800
@@ -170,7 +170,7 @@ int vmi_set_wallclock(unsigned long now)
 	return -1;
 }
 
-unsigned long long vmi_sched_clock(void)
+unsigned long long vmi_get_sched_cycles(void)
 {
 	return read_available_cycles();
 }
diff -r 3e746c0ebcdf include/asm-i386/vmi_time.h
--- a/include/asm-i386/vmi_time.h	Fri Feb 02 13:54:53 2007 -0800
+++ b/include/asm-i386/vmi_time.h	Fri Feb 02 15:31:53 2007 -0800
@@ -49,7 +49,7 @@ extern void __init vmi_time_init(void);
 extern void __init vmi_time_init(void);
 extern unsigned long vmi_get_wallclock(void);
 extern int vmi_set_wallclock(unsigned long now);
-extern unsigned long long vmi_sched_clock(void);
+extern unsigned long long vmi_get_sched_cycles(void);
 
 #ifdef CONFIG_X86_LOCAL_APIC
 extern void __init vmi_timer_setup_boot_alarm(void);
