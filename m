Return-Path: <linux-kernel-owner+w=401wt.eu-S1753964AbYFTBWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964AbYFTBWp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 21:22:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751340AbYFTBWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 21:22:35 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:47627 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751333AbYFTBWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 21:22:34 -0400
Subject: Re: [RFC PATCH] x86:Use cpu_khz for loops_per_jiffy calculation
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Arjan van de Ven <arjan@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Daniel Hecht <dhecht@vmware.com>,
       Tim Mann <mann@vmware.com>, Zach Amsden <zach@vmware.com>,
       Sahil Rihan <srihan@vmware.com>
In-Reply-To: <20080604061637.6bab3f67@infradead.org>
References: <1212540069.19290.57.camel@promb-2n-dhcp368.eng.vmware.com>
	 <20080603182014.79a38d03@infradead.org>
	 <35f686220806032101h103152dat841818982aaa5052@mail.gmail.com>
	 <20080604061637.6bab3f67@infradead.org>
Content-Type: text/plain
Organization: VMware INC.
Date: Thu, 19 Jun 2008 18:22:33 -0700
Message-Id: <1213924953.27983.52.camel@promb-2n-dhcp368.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arjan,

I have modified the patch to use the pre-calculated value only for the
boot processor. 

Please have a look.
Patch is on top of today's git.

--
On X86 platform we can use the value of tsc_khz computed during tsc calibration
to calculate the loops_per_jiffy value. Its very important to keep the error in
lpj values to minimum as any error in that may result in kernel panic in
check_timer. 
In virtualization environment, On a highly overloaded host the guest delay
calibration may sometimes result in errors beyond the ~50% that timer_irq_works
can handle, resulting in the guest panicking.

Does some formating changes to lpj_setup code to now have a single printk to
print the bogomips value.

We do this only for the boot processor because the AP's can have different
base frequencies or the BIOS might boot a AP at a different frequency.

Signed-off-by: Alok N Kataria <akataria@vmware.com>

Index: linux-2.6/arch/x86/kernel/time_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/time_64.c	2008-06-09 10:19:20.000000000 -0700
+++ linux-2.6/arch/x86/kernel/time_64.c	2008-06-19 17:22:53.000000000 -0700
@@ -123,6 +123,8 @@
 		(boot_cpu_data.x86_vendor == X86_VENDOR_AMD))
 		cpu_khz = calculate_cpu_khz();
 
+	lpj_tsc = ((unsigned long)tsc_khz * 1000)/HZ;
+
 	if (unsynchronized_tsc())
 		mark_tsc_unstable("TSCs unsynchronized");
 
Index: linux-2.6/include/linux/delay.h
===================================================================
--- linux-2.6.orig/include/linux/delay.h	2008-06-09 10:19:20.000000000 -0700
+++ linux-2.6/include/linux/delay.h	2008-06-19 17:22:28.000000000 -0700
@@ -41,6 +41,7 @@
 #define ndelay(x) ndelay(x)
 #endif
 
+extern unsigned long lpj_tsc;
 void calibrate_delay(void);
 void msleep(unsigned int msecs);
 unsigned long msleep_interruptible(unsigned int msecs);
Index: linux-2.6/init/calibrate.c
===================================================================
--- linux-2.6.orig/init/calibrate.c	2008-06-09 10:19:20.000000000 -0700
+++ linux-2.6/init/calibrate.c	2008-06-19 18:21:12.000000000 -0700
@@ -8,7 +8,9 @@
 #include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/timex.h>
+#include <linux/smp.h>
 
+unsigned long lpj_tsc;
 unsigned long preset_lpj;
 static int __init lpj_setup(char *str)
 {
@@ -108,6 +110,10 @@
  * This is the number of bits of precision for the loops_per_jiffy.  Each
  * bit takes on average 1.5/HZ seconds.  This (like the original) is a little
  * better than 1%
+ * For the boot cpu we can skip the delay calibration and assign it a value
+ * calculated based on the tsc frequency.
+ * For the rest of the CPUs we cannot assume that the tsc frequency is same as
+ * the cpu frequency, hence do the calibration for those.
  */
 #define LPS_PREC 8
 
@@ -118,16 +124,15 @@
 
 	if (preset_lpj) {
 		loops_per_jiffy = preset_lpj;
-		printk("Calibrating delay loop (skipped)... "
-			"%lu.%02lu BogoMIPS preset\n",
-			loops_per_jiffy/(500000/HZ),
-			(loops_per_jiffy/(5000/HZ)) % 100);
+		printk(KERN_DEBUG "Calibrating delay loop skipped, "
+				"using preset value.. ");
+	} else if ((smp_processor_id() == 0) && lpj_tsc) {
+		loops_per_jiffy = lpj_tsc;
+		printk(KERN_DEBUG "Calibrating delay loop skipped, "
+				"using value calculated from tsc.. ");
 	} else if ((loops_per_jiffy = calibrate_delay_direct()) != 0) {
-		printk("Calibrating delay using timer specific routine.. ");
-		printk("%lu.%02lu BogoMIPS (lpj=%lu)\n",
-			loops_per_jiffy/(500000/HZ),
-			(loops_per_jiffy/(5000/HZ)) % 100,
-			loops_per_jiffy);
+		printk(KERN_DEBUG "Calibrating delay using timer "
+				 "specific routine.. ");
 	} else {
 		loops_per_jiffy = (1<<12);
 
@@ -161,12 +166,8 @@
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
+	printk(KERN_DEBUG "%lu.%02lu BogoMIPS (lpj=%lu)\n",
+			loops_per_jiffy/(500000/HZ),
+			(loops_per_jiffy/(5000/HZ)) % 100, loops_per_jiffy);
 }
Index: linux-2.6/arch/x86/kernel/tsc_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/tsc_32.c	2008-06-09 10:19:20.000000000 -0700
+++ linux-2.6/arch/x86/kernel/tsc_32.c	2008-06-19 17:23:42.000000000 -0700
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
 
+	lpj = ((u64)tsc_khz * 1000);
+	do_div(lpj, HZ);
+	lpj_tsc = lpj;
+
 	printk("Detected %lu.%03lu MHz processor.\n",
 				(unsigned long)cpu_khz / 1000,
 				(unsigned long)cpu_khz % 1000);


