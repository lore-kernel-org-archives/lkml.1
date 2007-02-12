Return-Path: <linux-kernel-owner+w=401wt.eu-S933086AbXBLHuJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933086AbXBLHuJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 02:50:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933077AbXBLHuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 02:50:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49599 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933076AbXBLHhw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 02:37:52 -0500
From: Andi Kleen <ak@suse.de>
References: <20070212837.963446000@suse.de>
In-Reply-To: <20070212837.963446000@suse.de>
To: Ingo Molnar <mingo@elte.hu>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH x86 for review II] [5/39] i386: improve sched_clock() on i686
Message-Id: <20070212073751.4B49F13D7F@wotan.suse.de>
Date: Mon, 12 Feb 2007 08:37:51 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Ingo Molnar <mingo@elte.hu>

Clean up sched_clock() on i686: it will use the TSC if available and falls
back to jiffies only if the user asked for it to be disabled via notsc or
the CPU calibration code didnt figure out the right cpu_khz.

This generally makes the scheduler timestamps more finegrained, on all
hardware.  (the current scheduler is pretty resistant against asynchronous
sched_clock() values on different CPUs, it will allow at most up to a jiffy
of jitter.)

Also simplify sched_clock()'s check for TSC availability: propagate the
desire and ability to use the TSC into the tsc_disable flag, previously
this flag only indicated whether the notsc option was passed.  This makes
the rare low-res sched_clock() codepath a single branch off a read-mostly
flag.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/i386/kernel/tsc.c  |   22 ++++++++++++++--------
 include/asm-i386/bugs.h |    2 +-
 2 files changed, 15 insertions(+), 9 deletions(-)

Index: linux/arch/i386/kernel/tsc.c
===================================================================
--- linux.orig/arch/i386/kernel/tsc.c
+++ linux/arch/i386/kernel/tsc.c
@@ -112,13 +112,10 @@ unsigned long long sched_clock(void)
 		return (*custom_sched_clock)();
 
 	/*
-	 * in the NUMA case we dont use the TSC as they are not
-	 * synchronized across all CPUs.
+	 * Fall back to jiffies if there's no TSC available:
 	 */
-#ifndef CONFIG_NUMA
-	if (!cpu_khz || check_tsc_unstable())
-#endif
-		/* no locking but a rare wrong value is not a big deal */
+	if (unlikely(tsc_disable))
+		/* No locking but a rare wrong value is not a big deal: */
 		return (jiffies_64 - INITIAL_JIFFIES) * (1000000000 / HZ);
 
 	/* read the Time Stamp Counter: */
@@ -198,13 +195,13 @@ EXPORT_SYMBOL(recalibrate_cpu_khz);
 void __init tsc_init(void)
 {
 	if (!cpu_has_tsc || tsc_disable)
-		return;
+		goto out_no_tsc;
 
 	cpu_khz = calculate_cpu_khz();
 	tsc_khz = cpu_khz;
 
 	if (!cpu_khz)
-		return;
+		goto out_no_tsc;
 
 	printk("Detected %lu.%03lu MHz processor.\n",
 				(unsigned long)cpu_khz / 1000,
@@ -212,6 +209,15 @@ void __init tsc_init(void)
 
 	set_cyc2ns_scale(cpu_khz);
 	use_tsc_delay();
+	return;
+
+out_no_tsc:
+	/*
+	 * Set the tsc_disable flag if there's no TSC support, this
+	 * makes it a fast flag for the kernel to see whether it
+	 * should be using the TSC.
+	 */
+	tsc_disable = 1;
 }
 
 #ifdef CONFIG_CPU_FREQ
Index: linux/include/asm-i386/bugs.h
===================================================================
--- linux.orig/include/asm-i386/bugs.h
+++ linux/include/asm-i386/bugs.h
@@ -160,7 +160,7 @@ static void __init check_config(void)
  * If we configured ourselves for a TSC, we'd better have one!
  */
 #ifdef CONFIG_X86_TSC
-	if (!cpu_has_tsc)
+	if (!cpu_has_tsc && !tsc_disable)
 		panic("Kernel compiled for Pentium+, requires TSC feature!");
 #endif
 
