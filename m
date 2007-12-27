Return-Path: <linux-kernel-owner+w=401wt.eu-S1754169AbXL0STs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169AbXL0STs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 13:19:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751611AbXL0STl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 13:19:41 -0500
Received: from mail.gmx.net ([213.165.64.20]:59546 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751427AbXL0STk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 13:19:40 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18nhCdprGInZIiBhLeoTcyCYORU1pGzdEPMIqWBBx
	GF5SbNU4U0uLT8
Subject: Re: [patch?] s2ram + P4 + tsc = annoyance
From: Mike Galbraith <efault@gmx.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1198745736.4235.23.camel@homer.simson.net>
References: <1198745736.4235.23.camel@homer.simson.net>
Content-Type: text/plain
Date: Thu, 27 Dec 2007 19:19:34 +0100
Message-Id: <1198779574.4425.50.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Or, reset to pristine prior to testing, though that's more lines to
accomplish the same thing.  Either way, or some other way...

If check_tsc_warp() is called after initial boot, and the TSC has in the
meantime been set (BIOS, user, silicon, elves) to a value lower than the
last stored/stale value, we blame the TSC.  Reset to pristine condition
after every test.

Signed-off-by: Mike Galbraith <efault@gmx.de>

diff --git a/arch/x86/kernel/tsc_sync.c b/arch/x86/kernel/tsc_sync.c
index 9125efe..05d8f25 100644
--- a/arch/x86/kernel/tsc_sync.c
+++ b/arch/x86/kernel/tsc_sync.c
@@ -129,24 +129,24 @@ void __cpuinit check_tsc_sync_source(int cpu)
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


