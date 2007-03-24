Return-Path: <linux-kernel-owner+w=401wt.eu-S1750894AbXCXVzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750894AbXCXVzX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 17:55:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751480AbXCXVzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 17:55:23 -0400
Received: from www.osadl.org ([213.239.205.134]:36131 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750897AbXCXVzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 17:55:22 -0400
Subject: [PATCH] i386: Prevent early access to TSC to avoid crash on
	TSCless systems
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, john stultz <johnstul@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@stusta.de>,
       Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain
Date: Sat, 24 Mar 2007 23:02:49 +0100
Message-Id: <1174773769.10840.450.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

commit f9690982b8c2f9a2c65acdc113e758ec356676a3 removed the check for
cpu_khz from sched_clock(), which prevented early access to the TSC by
non obvious magic.

This is harmless as long as the CPU has a TSC. On TSCless systems this
results in an illegal instruction trap.

Replace tsc_disabled and tsc_unstable by tsc_enabled, which is only set
when the tsc is available and not unstable.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

diff --git a/arch/i386/kernel/tsc.c b/arch/i386/kernel/tsc.c
index 0e65f7a..6cb8f53 100644
--- a/arch/i386/kernel/tsc.c
+++ b/arch/i386/kernel/tsc.c
@@ -18,6 +18,8 @@
 
 #include "mach_timer.h"
 
+static int tsc_enabled;
+
 /*
  * On some systems the TSC frequency does not
  * change with the cpu frequency. So we need
@@ -105,7 +107,7 @@ unsigned long long sched_clock(void)
 	/*
 	 * Fall back to jiffies if there's no TSC available:
 	 */
-	if (tsc_unstable || unlikely(tsc_disable))
+	if (unlikely(!tsc_enabled))
 		/* No locking but a rare wrong value is not a big deal: */
 		return (jiffies_64 - INITIAL_JIFFIES) * (1000000000 / HZ);
 
@@ -283,6 +285,7 @@ void mark_tsc_unstable(void)
 {
 	if (!tsc_unstable) {
 		tsc_unstable = 1;
+		tsc_enabled = 0;
 		/* Can be called before registration */
 		if (clocksource_tsc.mult)
 			clocksource_change_rating(&clocksource_tsc, 0);
@@ -383,7 +386,9 @@ void __init tsc_init(void)
 	if (check_tsc_unstable()) {
 		clocksource_tsc.rating = 0;
 		clocksource_tsc.flags &= ~CLOCK_SOURCE_IS_CONTINUOUS;
-	}
+	} else
+		tsc_enabled = 1;
+
 	clocksource_register(&clocksource_tsc);
 
 	return;




