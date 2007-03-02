Return-Path: <linux-kernel-owner+w=401wt.eu-S1422727AbXCBCyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422727AbXCBCyg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 21:54:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422729AbXCBCyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 21:54:36 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:53687 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422727AbXCBCya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 21:54:30 -0500
Date: Thu, 1 Mar 2007 18:54:24 -0800
Message-Id: <200703020254.l222sOaM009656@zach-dev.vmware.com>
Subject: [PATCH 2/9] Sched clock paravirt op fix.patch
From: Zachary Amsden <zach@vmware.com>
To: Andi Kleen <ak@muc.de>, Linus Torvalds <torvalds@osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>, Dan Hecht <dhecht@vmware.com>,
       Dan Arai <arai@vmware.com>, Andrew Morton <akpm@osdl.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>
CC: Daniel Walker <dwalker@mvista.com>
CC: Daniel Hecht <dhecht@vmware.com>
X-OriginalArrivalTime: 02 Mar 2007 02:54:28.0807 (UTC) FILETIME=[185E2D70:01C75C76]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The custom_sched_clock hook is broken.  The result from sched_clock needs to be
in nanoseconds, not in CPU cycles.  The TSC is insufficient for this purpose,
because TSC is poorly defined in a virtual environment, and mostly represents
real world time instead of scheduled process time (which can be interrupted
without notice when a virtual machine is descheduled).

To make the scheduler consistent, we must expose a different nature of time,
that is scheduled time.  So deprecate this custom_sched_clock hack and turn it
into a paravirt-op, as it should have been all along.  This allows the tsc.c
code which converts cycles to nanoseconds to be shared by all paravirt-ops
backends.

It is unfortunate to add a new paravirt-op, but this is a very distinct
abstraction which is clearly different for all virtual machine implementations,
and it gets rid of an ugly indirect function which I ashamedly admit I hacked
in to try to get this to work earlier, and then even got in the wrong units.

Please apply.

Signed-off-by: Zachary Amsden <zach@vmware.com>

diff -r d58e6ddfdfa9 arch/i386/kernel/paravirt.c
--- a/arch/i386/kernel/paravirt.c	Thu Feb 15 23:52:41 2007 -0800
+++ b/arch/i386/kernel/paravirt.c	Fri Feb 16 00:04:39 2007 -0800
@@ -32,6 +32,7 @@
 #include <asm/fixmap.h>
 #include <asm/apic.h>
 #include <asm/tlbflush.h>
+#include <asm/timer.h>
 
 /* nop stub */
 static void native_nop(void)
@@ -520,6 +521,7 @@ struct paravirt_ops paravirt_ops = {
 	.write_msr = native_write_msr,
 	.read_tsc = native_read_tsc,
 	.read_pmc = native_read_pmc,
+	.get_scheduled_cycles = native_read_tsc,
 	.load_tr_desc = native_load_tr_desc,
 	.set_ldt = native_set_ldt,
 	.load_gdt = native_load_gdt,
diff -r d58e6ddfdfa9 arch/i386/kernel/tsc.c
--- a/arch/i386/kernel/tsc.c	Thu Feb 15 23:52:41 2007 -0800
+++ b/arch/i386/kernel/tsc.c	Fri Feb 16 00:06:34 2007 -0800
@@ -14,6 +14,7 @@
 #include <asm/delay.h>
 #include <asm/tsc.h>
 #include <asm/io.h>
+#include <asm/timer.h>
 
 #include "mach_timer.h"
 
@@ -108,9 +109,6 @@ unsigned long long sched_clock(void)
 {
 	unsigned long long this_offset;
 
-	if (unlikely(custom_sched_clock))
-		return (*custom_sched_clock)();
-
 	/*
 	 * Fall back to jiffies if there's no TSC available:
 	 */
@@ -119,7 +117,7 @@ unsigned long long sched_clock(void)
 		return (jiffies_64 - INITIAL_JIFFIES) * (1000000000 / HZ);
 
 	/* read the Time Stamp Counter: */
-	rdtscll(this_offset);
+	get_scheduled_cycles(this_offset);
 
 	/* return the value in ns */
 	return cycles_2_ns(this_offset);
diff -r d58e6ddfdfa9 arch/i386/kernel/vmi.c
--- a/arch/i386/kernel/vmi.c	Thu Feb 15 23:52:41 2007 -0800
+++ b/arch/i386/kernel/vmi.c	Fri Feb 16 00:02:48 2007 -0800
@@ -873,7 +873,7 @@ static inline int __init activate_vmi(vo
 		paravirt_ops.setup_boot_clock = vmi_timer_setup_boot_alarm;
 		paravirt_ops.setup_secondary_clock = vmi_timer_setup_secondary_alarm;
 #endif
-		custom_sched_clock = vmi_sched_clock;
+		paravirt_ops.get_scheduled_cycles = vmi_get_sched_cycles;
 	}
 	if (!disable_noidle)
 		para_fill(safe_halt, Halt);
diff -r d58e6ddfdfa9 arch/i386/kernel/vmitime.c
--- a/arch/i386/kernel/vmitime.c	Thu Feb 15 23:52:41 2007 -0800
+++ b/arch/i386/kernel/vmitime.c	Fri Feb 16 00:02:48 2007 -0800
@@ -172,7 +172,7 @@ int vmi_set_wallclock(unsigned long now)
 	return -1;
 }
 
-unsigned long long vmi_sched_clock(void)
+unsigned long long vmi_get_sched_cycles(void)
 {
 	return read_available_cycles();
 }
diff -r d58e6ddfdfa9 include/asm-i386/paravirt.h
--- a/include/asm-i386/paravirt.h	Thu Feb 15 23:52:41 2007 -0800
+++ b/include/asm-i386/paravirt.h	Fri Feb 16 00:07:22 2007 -0800
@@ -94,6 +94,7 @@ struct paravirt_ops
 
 	u64 (*read_tsc)(void);
 	u64 (*read_pmc)(void);
+ 	u64 (*get_scheduled_cycles)(void);
 
 	void (*load_tr_desc)(void);
 	void (*load_gdt)(const struct Xgt_desc_struct *);
@@ -273,6 +274,8 @@ static inline void halt(void)
 
 #define rdtscll(val) (val = paravirt_ops.read_tsc())
 
+#define get_scheduled_cycles(val) (val = paravirt_ops.get_scheduled_cycles())
+
 #define write_tsc(val1,val2) wrmsr(0x10, val1, val2)
 
 #define rdpmc(counter,low,high) do {				\
diff -r d58e6ddfdfa9 include/asm-i386/time.h
--- a/include/asm-i386/time.h	Thu Feb 15 23:52:41 2007 -0800
+++ b/include/asm-i386/time.h	Fri Feb 16 00:02:48 2007 -0800
@@ -30,7 +30,6 @@ static inline int native_set_wallclock(u
 
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
-extern unsigned long long native_sched_clock(void);
 #else /* !CONFIG_PARAVIRT */
 
 #define get_wallclock() native_get_wallclock()
diff -r d58e6ddfdfa9 include/asm-i386/timer.h
--- a/include/asm-i386/timer.h	Thu Feb 15 23:52:41 2007 -0800
+++ b/include/asm-i386/timer.h	Fri Feb 16 00:05:13 2007 -0800
@@ -4,13 +4,19 @@
 #include <linux/pm.h>
 
 #define TICK_SIZE (tick_nsec / 1000)
+
 void setup_pit_timer(void);
+unsigned long long native_sched_clock(void);
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
 #endif
+
+#endif
diff -r d58e6ddfdfa9 include/asm-i386/vmi_time.h
--- a/include/asm-i386/vmi_time.h	Thu Feb 15 23:52:41 2007 -0800
+++ b/include/asm-i386/vmi_time.h	Fri Feb 16 00:02:48 2007 -0800
@@ -49,7 +49,7 @@ extern void __init vmi_time_init(void);
 extern void __init vmi_time_init(void);
 extern unsigned long vmi_get_wallclock(void);
 extern int vmi_set_wallclock(unsigned long now);
-extern unsigned long long vmi_sched_clock(void);
+extern unsigned long long vmi_get_sched_cycles(void);
 
 #ifdef CONFIG_X86_LOCAL_APIC
 extern void __init vmi_timer_setup_boot_alarm(void);
