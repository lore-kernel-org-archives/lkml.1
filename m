Return-Path: <linux-kernel-owner+w=401wt.eu-S1760575AbXGNIlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760575AbXGNIlt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 04:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752286AbXGNIln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 04:41:43 -0400
Received: from www.osadl.org ([213.239.205.134]:35277 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751708AbXGNIlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 04:41:42 -0400
Subject: [PATCH] X86_64: hpet tsc calibration fix broken smi detection logic
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@suse.de>,
       Stable Team <stable@kernel.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain
Date: Sat, 14 Jul 2007 10:41:39 +0200
Message-Id: <1184402499.12353.340.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
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

--- a/arch/x86_64/kernel/hpet.c
+++ b/arch/x86_64/kernel/hpet.c
@@ -190,7 +190,7 @@ int hpet_reenable(void)
  */
 
 #define TICK_COUNT 100000000
-#define TICK_MIN   5000
+#define SMI_THRESHOLD 50000
 #define MAX_TRIES  5
 
 /*
@@ -205,7 +205,7 @@ static void __init read_hpet_tsc(int *hpet, int *tsc)
 		tsc1 = get_cycles_sync();
 		hpet1 = hpet_readl(HPET_COUNTER);
 		tsc2 = get_cycles_sync();
-		if (tsc2 - tsc1 > TICK_MIN)
+		if ((tsc2 - tsc1) < SMI_TRESHOLD)
 			break;
 	}
 	*hpet = hpet1;


