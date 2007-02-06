Return-Path: <linux-kernel-owner+w=401wt.eu-S1752718AbXBFDyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718AbXBFDyo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 22:54:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752698AbXBFDyB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 22:54:01 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:40390 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752647AbXBFDxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 22:53:25 -0500
Date: Mon, 5 Feb 2007 19:53:23 -0800
Message-Id: <200702060353.l163rNP7000763@zach-dev.vmware.com>
Subject: [PATCH 8/11] Add a CPU KHZ calibration function to paravirt-ops
From: Zachary Amsden <zach@vmware.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@muc.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>
X-OriginalArrivalTime: 06 Feb 2007 03:53:23.0538 (UTC) FILETIME=[59515320:01C749A2]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a paravirtualized way to get the CPU clock frequency; this allows much
of the code in tsc.c to be shared between all paravirt implementations.

Subject: Add a CPU KHZ calibration function to paravirt-ops
Signed-off-by: Zachary Amsden <zach@vmware.com>

diff -r a08f195aa92a arch/i386/kernel/vmi.c
--- a/arch/i386/kernel/vmi.c	Fri Feb 02 16:30:59 2007 -0800
+++ b/arch/i386/kernel/vmi.c	Fri Feb 02 16:31:45 2007 -0800
@@ -881,6 +881,7 @@ static int __init activate_vmi(void)
 		paravirt_ops.setup_secondary_clock = vmi_timer_setup_secondary_alarm;
 #endif
 		paravirt_ops.get_scheduled_cycles = vmi_get_sched_cycles;
+ 		paravirt_ops.get_cpu_khz = vmi_cpu_khz;
 	}
 
 	/*
diff -r a08f195aa92a arch/i386/kernel/vmitime.c
--- a/arch/i386/kernel/vmitime.c	Fri Feb 02 16:30:59 2007 -0800
+++ b/arch/i386/kernel/vmitime.c	Fri Feb 02 16:30:59 2007 -0800
@@ -175,6 +175,15 @@ unsigned long long vmi_get_sched_cycles(
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
@@ -204,7 +213,6 @@ void __init vmi_time_init(void)
 	(void)do_div(cycles_per_alarm, alarm_hz);
 	cycles_per_msec = cycles_per_sec;
 	(void)do_div(cycles_per_msec, 1000);
-	cpu_khz = cycles_per_msec;
 
 	printk(KERN_WARNING "VMI timer cycles/sec = %llu ; cycles/jiffy = %llu ;"
 	       "cycles/alarm = %llu\n", cycles_per_sec, cycles_per_jiffy,
diff -r a08f195aa92a include/asm-i386/vmi_time.h
--- a/include/asm-i386/vmi_time.h	Fri Feb 02 16:30:59 2007 -0800
+++ b/include/asm-i386/vmi_time.h	Fri Feb 02 16:31:24 2007 -0800
@@ -50,6 +50,7 @@ extern unsigned long vmi_get_wallclock(v
 extern unsigned long vmi_get_wallclock(void);
 extern int vmi_set_wallclock(unsigned long now);
 extern unsigned long long vmi_get_sched_cycles(void);
+extern unsigned long vmi_cpu_khz(void);
 
 #ifdef CONFIG_X86_LOCAL_APIC
 extern void __init vmi_timer_setup_boot_alarm(void);
