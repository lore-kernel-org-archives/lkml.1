Return-Path: <linux-kernel-owner+w=401wt.eu-S932594AbXAaDkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932594AbXAaDkJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 22:40:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932585AbXAaDj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 22:39:58 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:65321 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932597AbXAaDj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 22:39:29 -0500
Message-Id: <20070131033809.298987113@mvista.com>
References: <20070131033710.420168478@mvista.com>
User-Agent: quilt/0.46.mv-1
Date: Tue, 30 Jan 2007 19:37:30 -0800
From: Daniel Walker <dwalker@mvista.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, johnstul@us.ibm.com
Subject: [PATCH 20/23] clocksource: x86_64 update for new flags
Content-Disposition: inline; filename=clocksource-x86_64-add-flags.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Update x86_64 for new flags.

Signed-Off-By: Daniel Walker <dwalker@mvista.com>

---
 arch/x86_64/kernel/hpet.c |    1 -
 arch/x86_64/kernel/tsc.c  |   11 ++++-------
 2 files changed, 4 insertions(+), 8 deletions(-)

Index: linux-2.6.19/arch/x86_64/kernel/hpet.c
===================================================================
--- linux-2.6.19.orig/arch/x86_64/kernel/hpet.c
+++ linux-2.6.19/arch/x86_64/kernel/hpet.c
@@ -470,7 +470,6 @@ struct clocksource clocksource_hpet = {
 	.mask		= (cycle_t)HPET_MASK,
 	.mult		= 0, /* set below */
 	.shift		= HPET_SHIFT,
-	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 	.vread		= vread_hpet,
 };
 
Index: linux-2.6.19/arch/x86_64/kernel/tsc.c
===================================================================
--- linux-2.6.19.orig/arch/x86_64/kernel/tsc.c
+++ linux-2.6.19/arch/x86_64/kernel/tsc.c
@@ -195,18 +195,15 @@ static struct clocksource clocksource_ts
 	.read			= read_tsc,
 	.mask			= CLOCKSOURCE_MASK(64),
 	.shift			= 22,
-	.flags			= CLOCK_SOURCE_IS_CONTINUOUS |
-				  CLOCK_SOURCE_MUST_VERIFY,
+	.flags                  = CLOCKSOURCE_64BITS | CLOCKSOURCE_PM_AFFECTED,
 	.vread			= vread_tsc,
 };
 
 void mark_tsc_unstable(void)
 {
 	/* check to see if we should switch to the safe clocksource: */
-	if (unlikely(!tsc_unstable && clocksource_tsc.rating != 50)) {
-		clocksource_tsc.rating = 50;
-		clocksource_rating_change(&clocksource_tsc);
-	}
+	if (unlikely(!tsc_unstable && clocksource_tsc.rating != 50))
+		clocksource_tsc.flags |= CLOCKSOURCE_UNSTABLE;
 
 	tsc_unstable = 1;
 }
@@ -218,7 +215,7 @@ static int __init init_tsc_clocksource(v
 		clocksource_tsc.mult = clocksource_khz2mult(cpu_khz,
 							clocksource_tsc.shift);
 		if (check_tsc_unstable())
-			clocksource_tsc.rating = 50;
+			clocksource_tsc.flags |= CLOCKSOURCE_UNSTABLE;
 
 		return clocksource_register(&clocksource_tsc);
 	}

-- 
