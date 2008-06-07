Return-Path: <linux-kernel-owner+w=401wt.eu-S1764292AbYFGBZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764292AbYFGBZK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 21:25:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759527AbYFGBJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 21:09:47 -0400
Received: from sous-sol.org ([216.99.217.87]:42564 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758893AbYFGBJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 21:09:31 -0400
Message-Id: <20080607010615.046585013@sous-sol.org>
References: <20080607010215.358296706@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 18:02:40 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 25/50] x86: fix setup of cyc2ns in tsc_64.c
Content-Disposition: inline; filename=x86-fix-setup-of-cyc2ns-in-tsc_64.c.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Thomas Gleixner <tglx@linutronix.de>

upstream commit: b6db80ee1331e7beaeb91b4b3d946dd16c72e388

When the TSC is calibrated against the PIT due to the nonavailability
of PMTIMER/HPET or due to SMI interference then the setup of the per
CPU cyc2ns variables is skipped. This is unlikely to happen but it
would definitely render sched_clock() unusable.

This was introduced with commit 53d517cdbaac704352b3d0c10fecb99e0b54572e

    x86: scale cyc_2_nsec according to CPU frequency

Update the per CPU cyc2ns variables in all exit pathes of tsc_calibrate.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@kernel.org
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 arch/x86/kernel/tsc_64.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/tsc_64.c
+++ b/arch/x86/kernel/tsc_64.c
@@ -227,14 +227,14 @@ void __init tsc_calibrate(void)
 	/* hpet or pmtimer available ? */
 	if (!hpet && !pm1 && !pm2) {
 		printk(KERN_INFO "TSC calibrated against PIT\n");
-		return;
+		goto out;
 	}
 
 	/* Check, whether the sampling was disturbed by an SMI */
 	if (tsc1 == ULONG_MAX || tsc2 == ULONG_MAX) {
 		printk(KERN_WARNING "TSC calibration disturbed by SMI, "
 		       "using PIT calibration result\n");
-		return;
+		goto out;
 	}
 
 	tsc2 = (tsc2 - tsc1) * 1000000L;
@@ -255,6 +255,7 @@ void __init tsc_calibrate(void)
 
 	tsc_khz = tsc2 / tsc1;
 
+out:
 	for_each_possible_cpu(cpu)
 		set_cyc2ns_scale(tsc_khz, cpu);
 }

-- 
