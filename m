Return-Path: <linux-kernel-owner+w=401wt.eu-S932581AbXAaDj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932581AbXAaDj4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 22:39:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932584AbXAaDiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 22:38:51 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:65216 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932573AbXAaDib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 22:38:31 -0500
Message-Id: <20070131033808.674919283@mvista.com>
References: <20070131033710.420168478@mvista.com>
User-Agent: quilt/0.46.mv-1
Date: Tue, 30 Jan 2007 19:37:28 -0800
From: Daniel Walker <dwalker@mvista.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, johnstul@us.ibm.com
Subject: [PATCH 18/23] clocksource: i386 update for new flags
Content-Disposition: inline; filename=clocksource-i386-add-flags.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Update i386 for new flags.

Signed-Off-By: Daniel Walker <dwalker@mvista.com>

---
 arch/i386/kernel/hpet.c    |    1 -
 arch/i386/kernel/i8253.c   |    1 +
 arch/i386/kernel/tsc.c     |   23 +++++++++++------------
 arch/i386/kernel/vmitime.c |    2 +-
 4 files changed, 13 insertions(+), 14 deletions(-)

Index: linux-2.6.19/arch/i386/kernel/hpet.c
===================================================================
--- linux-2.6.19.orig/arch/i386/kernel/hpet.c
+++ linux-2.6.19/arch/i386/kernel/hpet.c
@@ -287,7 +287,6 @@ static struct clocksource clocksource_hp
 	.read		= read_hpet,
 	.mask		= HPET_MASK,
 	.shift		= HPET_SHIFT,
-	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
 static int __init init_hpet_clocksource(void)
Index: linux-2.6.19/arch/i386/kernel/i8253.c
===================================================================
--- linux-2.6.19.orig/arch/i386/kernel/i8253.c
+++ linux-2.6.19/arch/i386/kernel/i8253.c
@@ -183,6 +183,7 @@ static struct clocksource clocksource_pi
 	.rating = 110,
 	.read	= pit_read,
 	.mask	= CLOCKSOURCE_MASK(32),
+	.flags	= CLOCKSOURCE_NOT_ATOMIC,
 	.mult	= 0,
 	.shift	= 20,
 };
Index: linux-2.6.19/arch/i386/kernel/tsc.c
===================================================================
--- linux-2.6.19.orig/arch/i386/kernel/tsc.c
+++ linux-2.6.19/arch/i386/kernel/tsc.c
@@ -306,8 +306,7 @@ static struct clocksource clocksource_ts
 	.mask			= CLOCKSOURCE_MASK(64),
 	.mult			= 0, /* to be set */
 	.shift			= 22,
-	.flags			= CLOCK_SOURCE_IS_CONTINUOUS |
-				  CLOCK_SOURCE_MUST_VERIFY,
+	.flags			= CLOCKSOURCE_64BITS | CLOCKSOURCE_PM_AFFECTED,
 };
 
 /*
@@ -316,10 +315,8 @@ static struct clocksource clocksource_ts
 void mark_tsc_unstable(void)
 {
 	/* check to see if we should switch to the safe clocksource: */
-	if (unlikely(!tsc_unstable && clocksource_tsc.rating != 0)) {
-		clocksource_tsc.rating = 0;
-		clocksource_rating_change(&clocksource_tsc);
-	}
+	if (unlikely(!tsc_unstable))
+		clocksource_mark_unstable(&clocksource_tsc);
 
 	tsc_unstable = 1;
 }
@@ -434,17 +431,19 @@ static int __init init_tsc_clocksource(v
 		/* check blacklist */
 		dmi_check_system(bad_tsc_dmi_table);
 
-		if (unsynchronized_tsc()) /* mark unstable if unsynced */
+		if (unsynchronized_tsc()) { /* mark unstable if unsynced */
 			mark_tsc_unstable();
+			clocksource_tsc.flags |= CLOCKSOURCE_UNSTABLE;
+		}
 		check_geode_tsc_reliable();
 		current_tsc_khz = tsc_khz;
 		clocksource_tsc.mult = clocksource_khz2mult(current_tsc_khz,
 							clocksource_tsc.shift);
-		/* lower the rating if we already know its unstable: */
-		if (check_tsc_unstable()) {
-			clocksource_tsc.rating = 0;
-			clocksource_tsc.flags &= ~CLOCK_SOURCE_IS_CONTINUOUS;
-		}
+
+		/* flags as unstable if we already know its unstable: */
+		if (check_tsc_unstable())
+			clocksource_tsc.flags |= CLOCKSOURCE_UNSTABLE |
+						 CLOCKSOURCE_NOT_CONTINUOUS;
 
 		init_timer(&verify_tsc_freq_timer);
 		verify_tsc_freq_timer.function = verify_tsc_freq;
Index: linux-2.6.19/arch/i386/kernel/vmitime.c
===================================================================
--- linux-2.6.19.orig/arch/i386/kernel/vmitime.c
+++ linux-2.6.19/arch/i386/kernel/vmitime.c
@@ -115,7 +115,7 @@ static struct clocksource clocksource_vm
 	.mask			= CLOCKSOURCE_MASK(64),
 	.mult			= 0, /* to be set */
 	.shift			= 22,
-	.flags			= CLOCK_SOURCE_IS_CONTINUOUS,
+	.flags			= CLOCKSOURCE_64BITS,
 };
 
 

-- 
