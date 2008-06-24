Return-Path: <linux-kernel-owner+w=401wt.eu-S1753334AbYFXBWG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334AbYFXBWG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 21:22:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751260AbYFXBV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 21:21:58 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:41389 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750924AbYFXBV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 21:21:57 -0400
Subject: Re: [RFC PATCH] x86:Use cpu_khz for loops_per_jiffy calculation
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Daniel Hecht <dhecht@vmware.com>,
       Tim Mann <mann@vmware.com>, Zach Amsden <zach@vmware.com>,
       Sahil Rihan <srihan@vmware.com>
In-Reply-To: <20080623234728.GA17297@elte.hu>
References: <1212540069.19290.57.camel@promb-2n-dhcp368.eng.vmware.com>
	 <20080603182014.79a38d03@infradead.org>
	 <35f686220806032101h103152dat841818982aaa5052@mail.gmail.com>
	 <20080604061637.6bab3f67@infradead.org>
	 <1213924953.27983.52.camel@promb-2n-dhcp368.eng.vmware.com>
	 <20080620113922.GG7439@elte.hu>
	 <1213999593.31598.52.camel@promb-2n-dhcp368.eng.vmware.com>
	 <20080623232149.GA22926@elte.hu>
	 <1214264070.3882.22.camel@promb-2n-dhcp368.eng.vmware.com>
	 <20080623234728.GA17297@elte.hu>
Content-Type: text/plain
Organization: VMware INC.
Date: Mon, 23 Jun 2008 18:21:56 -0700
Message-Id: <1214270516.3882.39.camel@promb-2n-dhcp368.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-23 at 16:47 -0700, Ingo Molnar wrote:
> * Alok Kataria <akataria@vmware.com> wrote:
> 
> > IMO, lpj_tsc explains how is this variable initialized. But thinking
> > about it, maybe we should rename it to "lpj_timer" ?
> 
> ok. But instead of 'lpj_timer' i'd suggest to use something like
> 'lpj_fine' - as this really is about finegrained measurements.

Ok.
> 
> I'd suggest a delta patch against tip/master that renames all those
> tsc_* variables to fine_*. So tsc_rate_min would become fine_rate_min,
> etc.

Ingo, tsc_rate_min etc are related to the timer rate so calling it
fine_rate_min would be confusing IMO. Instead i call it as
timer_rate_min. 
Below is the patch on tip/master.
Tested on both 32 and 64 bit environment, tree works fine for me. 

--
As suggested by Ingo, remove all references to tsc from init/calibrate.c

TSC is x86 specific, and using tsc in variable names in a generic file should
be avoided. lpj_tsc is now called lpj_fine, since it is related to fine tuning
of lpj value. Also tsc_rate_*  is called timer_rate_*

Signed-off-by: Alok N Kataria <akataria@vmware.com>

Index: linux-x86-tree.git/arch/x86/kernel/time_64.c
===================================================================
--- linux-x86-tree.git.orig/arch/x86/kernel/time_64.c	2008-06-23 17:24:07.000000000 -0700
+++ linux-x86-tree.git/arch/x86/kernel/time_64.c	2008-06-23 17:50:51.000000000 -0700
@@ -123,7 +123,7 @@
 		(boot_cpu_data.x86_vendor == X86_VENDOR_AMD))
 		cpu_khz = calculate_cpu_khz();
 
-	lpj_tsc = ((unsigned long)tsc_khz * 1000)/HZ;
+	lpj_fine = ((unsigned long)tsc_khz * 1000)/HZ;
 
 	if (unsynchronized_tsc())
 		mark_tsc_unstable("TSCs unsynchronized");
Index: linux-x86-tree.git/arch/x86/kernel/tsc_32.c
===================================================================
--- linux-x86-tree.git.orig/arch/x86/kernel/tsc_32.c	2008-06-23 17:24:07.000000000 -0700
+++ linux-x86-tree.git/arch/x86/kernel/tsc_32.c	2008-06-23 17:50:58.000000000 -0700
@@ -419,7 +419,7 @@
 
 	lpj = ((u64)tsc_khz * 1000);
 	do_div(lpj, HZ);
-	lpj_tsc = lpj;
+	lpj_fine = lpj;
 
 	/* now allow native_sched_clock() to use rdtsc */
 	tsc_disabled = 0;
Index: linux-x86-tree.git/include/linux/delay.h
===================================================================
--- linux-x86-tree.git.orig/include/linux/delay.h	2008-06-23 17:24:26.000000000 -0700
+++ linux-x86-tree.git/include/linux/delay.h	2008-06-23 17:51:08.000000000 -0700
@@ -41,7 +41,7 @@
 #define ndelay(x) ndelay(x)
 #endif
 
-extern unsigned long lpj_tsc;
+extern unsigned long lpj_fine;
 void calibrate_delay(void);
 void msleep(unsigned int msecs);
 unsigned long msleep_interruptible(unsigned int msecs);
Index: linux-x86-tree.git/init/calibrate.c
===================================================================
--- linux-x86-tree.git.orig/init/calibrate.c	2008-06-23 17:24:26.000000000 -0700
+++ linux-x86-tree.git/init/calibrate.c	2008-06-23 18:05:38.000000000 -0700
@@ -10,7 +10,7 @@
 #include <linux/timex.h>
 #include <linux/smp.h>
 
-unsigned long lpj_tsc;
+unsigned long lpj_fine;
 unsigned long preset_lpj;
 static int __init lpj_setup(char *str)
 {
@@ -35,9 +35,9 @@
 	unsigned long pre_start, start, post_start;
 	unsigned long pre_end, end, post_end;
 	unsigned long start_jiffies;
-	unsigned long tsc_rate_min, tsc_rate_max;
-	unsigned long good_tsc_sum = 0;
-	unsigned long good_tsc_count = 0;
+	unsigned long timer_rate_min, timer_rate_max;
+	unsigned long good_timer_sum = 0;
+	unsigned long good_timer_count = 0;
 	int i;
 
 	if (read_current_timer(&pre_start) < 0 )
@@ -81,22 +81,24 @@
 		}
 		read_current_timer(&post_end);
 
-		tsc_rate_max = (post_end - pre_start) / DELAY_CALIBRATION_TICKS;
-		tsc_rate_min = (pre_end - post_start) / DELAY_CALIBRATION_TICKS;
+		timer_rate_max = (post_end - pre_start) /
+					DELAY_CALIBRATION_TICKS;
+		timer_rate_min = (pre_end - post_start) /
+					DELAY_CALIBRATION_TICKS;
 
 		/*
-	 	 * If the upper limit and lower limit of the tsc_rate is
+		 * If the upper limit and lower limit of the timer_rate is
 		 * >= 12.5% apart, redo calibration.
 		 */
 		if (pre_start != 0 && pre_end != 0 &&
-		    (tsc_rate_max - tsc_rate_min) < (tsc_rate_max >> 3)) {
-			good_tsc_count++;
-			good_tsc_sum += tsc_rate_max;
+		    (timer_rate_max - timer_rate_min) < (timer_rate_max >> 3)) {
+			good_timer_count++;
+			good_timer_sum += timer_rate_max;
 		}
 	}
 
-	if (good_tsc_count)
-		return (good_tsc_sum/good_tsc_count);
+	if (good_timer_count)
+		return (good_timer_sum/good_timer_count);
 
 	printk(KERN_WARNING "calibrate_delay_direct() failed to get a good "
 	       "estimate for loops_per_jiffy.\nProbably due to long platform interrupts. Consider using \"lpj=\" boot option.\n");
@@ -111,8 +113,8 @@
  * bit takes on average 1.5/HZ seconds.  This (like the original) is a little
  * better than 1%
  * For the boot cpu we can skip the delay calibration and assign it a value
- * calculated based on the tsc frequency.
- * For the rest of the CPUs we cannot assume that the tsc frequency is same as
+ * calculated based on the timer frequency.
+ * For the rest of the CPUs we cannot assume that the timer frequency is same as
  * the cpu frequency, hence do the calibration for those.
  */
 #define LPS_PREC 8
@@ -126,11 +128,11 @@
 		loops_per_jiffy = preset_lpj;
 		printk(KERN_INFO
 			"Calibrating delay loop (skipped) preset value.. ");
-	} else if ((smp_processor_id() == 0) && lpj_tsc) {
-		loops_per_jiffy = lpj_tsc;
+	} else if ((smp_processor_id() == 0) && lpj_fine) {
+		loops_per_jiffy = lpj_fine;
 		printk(KERN_INFO
 			"Calibrating delay loop (skipped), "
-			"using tsc calculated value.. ");
+			"value calculated using timer frequency.. ");
 	} else if ((loops_per_jiffy = calibrate_delay_direct()) != 0) {
 		printk(KERN_INFO
 			"Calibrating delay using timer specific routine.. ");


