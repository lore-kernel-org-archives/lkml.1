Return-Path: <linux-kernel-owner+w=401wt.eu-S1753478AbXL0Izs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478AbXL0Izs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 03:55:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751471AbXL0Izl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 03:55:41 -0500
Received: from mail.gmx.net ([213.165.64.20]:47709 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751003AbXL0Izk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 03:55:40 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/Eo5krcWnE97YYpp0hABLElKIByCk9QQxWFKP05j
	12DpT0KJ2K8btJ
Subject: [patch?] s2ram + P4 + tsc = annoyance
From: Mike Galbraith <efault@gmx.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain
Date: Thu, 27 Dec 2007 09:55:36 +0100
Message-Id: <1198745736.4235.23.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

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

I wonder why I'm the only guy in the galaxy experiencing this.  Does
everybody else's clock continue to move forward across resume or
something?  Anyway, I asked it to please stop doing that, and it
complied without even exploding (unlike crabby APICs).

diff --git a/arch/x86/kernel/tsc_sync.c b/arch/x86/kernel/tsc_sync.c
index 9125efe..7b74969 100644
--- a/arch/x86/kernel/tsc_sync.c
+++ b/arch/x86/kernel/tsc_sync.c
@@ -46,7 +46,7 @@ static __cpuinit void check_tsc_warp(void)
 	cycles_t start, now, prev, end;
 	int i;
 
-	start = get_cycles_sync();
+	start = last_tsc = get_cycles_sync();
 	/*
 	 * The measurement runs for 20 msecs:
 	 */


