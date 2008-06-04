Return-Path: <linux-kernel-owner+w=401wt.eu-S1755310AbYFDAlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310AbYFDAlX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 20:41:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751925AbYFDAlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 20:41:13 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:52043 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751753AbYFDAlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 20:41:13 -0400
Subject: [RFC PATCH] x86:Use cpu_khz for loops_per_jiffy calculation
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Dan Hecht <dhecht@vmware.com>,
       Tim Mann <mann@vmware.com>, Zachary Amsden <zach@vmware.com>,
       Sahil Rihan <srihan@vmware.com>
Content-Type: text/plain
Organization: VMware INC.
Date: Tue, 03 Jun 2008 17:41:09 -0700
Message-Id: <1212540069.19290.57.camel@promb-2n-dhcp368.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On X86 platform we can use the value of cpu_khz computed during tsc calibration
to calculate the loops_per_jiffy value. Its very important to keep the error in
lpj values to minimum as any error in that may result in kernel panic in
check_timer. 
In virtualization environment on a highly overloaded host, the guest delay
calibration may sometimes result in errors beyond the ~50% that timer_irq_works
can handle, resulting in the guest panicking.

This change could also help large MP systems in reducing their booting time.

Patch also does some formating changes to lpj_setup code to now have a single
printk to print the calculated bogomips value.

On top of current git.

Signed-off-by: Alok N Kataria <akataria@vmware.com>

Index: linux-2.6/arch/x86/kernel/time_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/time_64.c	2008-05-23 16:56:24.000000000 -0700
+++ linux-2.6/arch/x86/kernel/time_64.c	2008-06-03 17:28:46.000000000 -0700
@@ -123,6 +123,8 @@
 		(boot_cpu_data.x86_vendor == X86_VENDOR_AMD))
 		cpu_khz = calculate_cpu_khz();
 
+	lpj_tsc = ((unsigned long)cpu_khz * 1000)/HZ;
+
 	if (unsynchronized_tsc())
 		mark_tsc_unstable("TSCs unsynchronized");
 
Index: linux-2.6/include/linux/delay.h
===================================================================
--- linux-2.6.orig/include/linux/delay.h	2008-05-23 16:56:24.000000000 -0700
+++ linux-2.6/include/linux/delay.h	2008-06-03 17:28:46.000000000 -0700
@@ -41,6 +41,7 @@
 #define ndelay(x) ndelay(x)
 #endif
 
+extern unsigned long lpj_tsc;
 void calibrate_delay(void);
 void msleep(unsigned int msecs);
 unsigned long msleep_interruptible(unsigned int msecs);
Index: linux-2.6/init/calibrate.c
===================================================================
--- linux-2.6.orig/init/calibrate.c	2008-05-23 16:56:24.000000000 -0700
+++ linux-2.6/init/calibrate.c	2008-06-03 17:28:46.000000000 -0700
@@ -9,6 +9,7 @@
 #include <linux/init.h>
 #include <linux/timex.h>
 
+unsigned long lpj_tsc;
 unsigned long preset_lpj;
 static int __init lpj_setup(char *str)
 {
@@ -118,16 +119,14 @@
 
 	if (preset_lpj) {
 		loops_per_jiffy = preset_lpj;
-		printk("Calibrating delay loop (skipped)... "
-			"%lu.%02lu BogoMIPS preset\n",
-			loops_per_jiffy/(500000/HZ),
-			(loops_per_jiffy/(5000/HZ)) % 100);
+		printk("Calibrating delay loop skipped, "
+			"using preset value.. ");
+	} else if (lpj_tsc) {
+		loops_per_jiffy = lpj_tsc;
+		printk("Calibrating delay loop skipped, "
+			"using value calculated from tsc.. ");
 	} else if ((loops_per_jiffy = calibrate_delay_direct()) != 0) {
 		printk("Calibrating delay using timer specific routine.. ");
-		printk("%lu.%02lu BogoMIPS (lpj=%lu)\n",
-			loops_per_jiffy/(500000/HZ),
-			(loops_per_jiffy/(5000/HZ)) % 100,
-			loops_per_jiffy);
 	} else {
 		loops_per_jiffy = (1<<12);
 
@@ -161,12 +160,7 @@
 			if (jiffies != ticks)	/* longer than 1 tick */
 				loops_per_jiffy &= ~loopbit;
 		}
-
-		/* Round the value and print it */
-		printk("%lu.%02lu BogoMIPS (lpj=%lu)\n",
-			loops_per_jiffy/(500000/HZ),
-			(loops_per_jiffy/(5000/HZ)) % 100,
-			loops_per_jiffy);
 	}
-
+	printk("%lu.%02lu BogoMIPS (lpj=%lu)\n", loops_per_jiffy/(500000/HZ),
+		(loops_per_jiffy/(5000/HZ)) % 100, loops_per_jiffy);
 }
Index: linux-2.6/arch/x86/kernel/tsc_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/tsc_32.c	2008-05-27 12:28:16.000000000 -0700
+++ linux-2.6/arch/x86/kernel/tsc_32.c	2008-06-03 17:28:46.000000000 -0700
@@ -401,6 +401,7 @@
 void __init tsc_init(void)
 {
 	int cpu;
+	u64 lpj;
 
 	if (!cpu_has_tsc || tsc_disabled) {
 		/* Disable the TSC in case of !cpu_has_tsc */
@@ -421,6 +422,10 @@
 		return;
 	}
 
+	lpj = ((u64)cpu_khz * 1000);
+	do_div(lpj, HZ);
+	lpj_tsc = lpj;
+
 	printk("Detected %lu.%03lu MHz processor.\n",
 				(unsigned long)cpu_khz / 1000,
 				(unsigned long)cpu_khz % 1000);


