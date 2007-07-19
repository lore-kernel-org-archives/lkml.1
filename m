Return-Path: <linux-kernel-owner+w=401wt.eu-S935956AbXGSKGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935956AbXGSKGg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 06:06:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759322AbXGSJzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:55:25 -0400
Received: from cantor.suse.de ([195.135.220.2]:35365 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350AbXGSJzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:55:12 -0400
From: Andi Kleen <ak@suse.de>
References: <200707191154.642492000@suse.de>
In-Reply-To: <200707191154.642492000@suse.de>
To: tglx@linutronix.de, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [22/58] x86_64: hpet tsc calibration fix broken smi  detection logic
Message-Id: <20070719095507.6122014E06@wotan.suse.de>
Date: Thu, 19 Jul 2007 11:55:07 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Thomas Gleixner <tglx@linutronix.de>
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
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/kernel/hpet.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux/arch/x86_64/kernel/hpet.c
===================================================================
--- linux.orig/arch/x86_64/kernel/hpet.c
+++ linux/arch/x86_64/kernel/hpet.c
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
