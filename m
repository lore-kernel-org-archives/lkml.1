Return-Path: <linux-kernel-owner+w=401wt.eu-S1763153AbXGOQH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763153AbXGOQH0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 12:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762252AbXGOQEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 12:04:54 -0400
Received: from www.osadl.org ([213.239.205.134]:42532 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762614AbXGOQEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 12:04:53 -0400
Message-Id: <20070715155540.817635663@inhelltoy.tec.linutronix.de>
References: <20070715155510.341941668@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sun, 15 Jul 2007 16:10:45 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@suse.de>, Chris Wright <chrisw@sous-sol.org>
Subject: [patch-mm 04/33] X86_64: hpet tsc calibration fix broken smi
	detection logic
Content-Disposition: inline;
	filename=x86_64-hpet-tsc-calibration-fix-broken-smi-detection-logic.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The current SMI detection logic in read_hpet_tsc() makes sure,
that when a SMI happens between the read of the HPET counter and
the read of the TSC, this wrong value is used for TSC calibration.

This is not the intention of the function. The comparison must ensure,
that we do _NOT_ use such a value.

Fix the check to use calibration values where delta of the two TSC reads
is smaller than a reasonable threshold.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>

---
 arch/x86_64/kernel/hpet.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.22-rc6-mm/arch/x86_64/kernel/hpet.c
===================================================================
--- linux-2.6.22-rc6-mm.orig/arch/x86_64/kernel/hpet.c	2007-07-15 17:26:54.000000000 +0200
+++ linux-2.6.22-rc6-mm/arch/x86_64/kernel/hpet.c	2007-07-15 17:49:05.000000000 +0200
@@ -190,7 +190,7 @@ int hpet_reenable(void)
  */
 
 #define TICK_COUNT 100000000
-#define TICK_MIN   5000
+#define SMI_THRESHOLD 50000
 #define MAX_TRIES  5
 
 /*
@@ -205,7 +205,7 @@ static void __init read_hpet_tsc(int *hp
 		tsc1 = get_cycles_sync();
 		hpet1 = hpet_readl(HPET_COUNTER);
 		tsc2 = get_cycles_sync();
-		if (tsc2 - tsc1 > TICK_MIN)
+		if ((tsc2 - tsc1) < SMI_THRESHOLD)
 			break;
 	}
 	*hpet = hpet1;

-- 

