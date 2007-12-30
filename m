Return-Path: <linux-kernel-owner+w=401wt.eu-S1757467AbXL3OKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757467AbXL3OKh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 09:10:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755450AbXL3OKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 09:10:30 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55028 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752380AbXL3OK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 09:10:29 -0500
Date: Sun, 30 Dec 2007 15:08:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch?] s2ram + P4 + tsc = annoyance
Message-ID: <20071230140815.GA27858@elte.hu>
References: <1198745736.4235.23.camel@homer.simson.net> <1198779574.4425.50.camel@homer.simson.net> <20071230140456.GJ16946@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071230140456.GJ16946@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> ok, i prefer this fix a bit more. (we dont want to set last_tsc 
> outside of the sync_lock - which your initial patch does)

i've added your patch to x86.git - thanks Mike! (patch below) I think 
this would be too dangerous for v2.6.24 though - we can put it back into 
-stable for 2.6.24.1, once it had more testing?

	Ingo

----------------->
Subject: x86: fix: s2ram + P4 + tsc = annoyance
From: Mike Galbraith <efault@gmx.de>

s2ram recently became useful here, except for the kernel's annoying
habit of disabling my P4's perfectly good TSC.

[  107.894470] CPU 1 is now offline
[  107.894474] SMP alternatives: switching to UP code
[  107.895832] CPU0 attaching sched-domain:
[  107.895836]  domain 0: span 1
[  107.895838]   groups: 1
[  107.896097] CPU1 is down
[    3.726156] Intel machine check architecture supported.
[    3.726165] Intel machine check reporting enabled on CPU#0.
[    3.726167] CPU0: Intel P4/Xeon Extended MCE MSRs (12) available
[    3.726170] CPU0: Thermal monitoring enabled
[    3.726175] Back to C!
[    3.726708] Force enabled HPET at resume
[    3.726775] Enabling non-boot CPUs ...
[    3.727049] CPU0 attaching NULL sched-domain.
[    3.727165] SMP alternatives: switching to SMP code
[    3.727858] Booting processor 1/1 eip 3000
[    3.727862] CPU 1 irqstacks, hard=b042f000 soft=b042d000
[    3.738173] Initializing CPU#1
[    3.798912] Calibrating delay using timer specific routine.. 5986.12 BogoMIPS (lpj=2993061)
[    3.798920] CPU: After generic identify, caps: bfebfbff 00000000 00000000 00000000 00004400 00000000 00000000 00000000
[    3.798931] CPU: Trace cache: 12K uops, L1 D cache: 8K
[    3.798934] CPU: L2 cache: 512K
[    3.798936] CPU: Physical Processor ID: 0
[    3.798938] CPU: After all inits, caps: bfebfbff 00000000 00000000 0000b080 00004400 00000000 00000000 00000000
[    3.798946] Intel machine check architecture supported.
[    3.798952] Intel machine check reporting enabled on CPU#1.
[    3.798955] CPU1: Intel P4/Xeon Extended MCE MSRs (12) available
[    3.798959] CPU1: Thermal monitoring enabled
[    3.799161] CPU1: Intel(R) Pentium(R) 4 CPU 3.00GHz stepping 09
[    3.799187] checking TSC synchronization [CPU#0 -> CPU#1]:
[    3.819181] Measured 63588552840 cycles TSC warp between CPUs, turning off TSC clock.
[    3.819184] Marking TSC unstable due to: check_tsc_sync_source failed.

If check_tsc_warp() is called after initial boot, and the TSC has in the
meantime been set (BIOS, user, silicon, elves) to a value lower than the
last stored/stale value, we blame the TSC.  Reset to pristine condition
after every test.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/tsc_sync.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

Index: linux-x86.q/arch/x86/kernel/tsc_sync.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/tsc_sync.c
+++ linux-x86.q/arch/x86/kernel/tsc_sync.c
@@ -129,24 +129,24 @@ void __cpuinit check_tsc_sync_source(int
 	while (atomic_read(&stop_count) != cpus-1)
 		cpu_relax();
 
-	/*
-	 * Reset it - just in case we boot another CPU later:
-	 */
-	atomic_set(&start_count, 0);
-
 	if (nr_warps) {
 		printk("\n");
 		printk(KERN_WARNING "Measured %Ld cycles TSC warp between CPUs,"
 				    " turning off TSC clock.\n", max_warp);
 		mark_tsc_unstable("check_tsc_sync_source failed");
-		nr_warps = 0;
-		max_warp = 0;
-		last_tsc = 0;
 	} else {
 		printk(" passed.\n");
 	}
 
 	/*
+	 * Reset it - just in case we boot another CPU later:
+	 */
+	atomic_set(&start_count, 0);
+	nr_warps = 0;
+	max_warp = 0;
+	last_tsc = 0;
+
+	/*
 	 * Let the target continue with the bootup:
 	 */
 	atomic_inc(&stop_count);
