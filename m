Return-Path: <linux-kernel-owner+w=401wt.eu-S932572AbXAaDiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932572AbXAaDiu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 22:38:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932584AbXAaDit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 22:38:49 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:65208 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932572AbXAaDi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 22:38:27 -0500
Message-Id: <20070131033804.231844793@mvista.com>
References: <20070131033710.420168478@mvista.com>
User-Agent: quilt/0.46.mv-1
Date: Tue, 30 Jan 2007 19:37:14 -0800
From: Daniel Walker <dwalker@mvista.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, johnstul@us.ibm.com, tglx@linutronix.de,
       mingo@elte.hu
Subject: [PATCH 04/23] clocksource: drop time-x86_64-tsc-fixup-clocksource-changes.patch
Content-Disposition: inline; filename=drop-time-x86_64-tsc-fixup-clocksource-changes.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Drop.

Signed-Off-By: Daniel Walker <dwalker@mvista.com>

---
 arch/x86_64/kernel/tsc.c |   31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

Index: linux-2.6.19/arch/x86_64/kernel/tsc.c
===================================================================
--- linux-2.6.19.orig/arch/x86_64/kernel/tsc.c
+++ linux-2.6.19/arch/x86_64/kernel/tsc.c
@@ -46,6 +46,13 @@ static inline int check_tsc_unstable(voi
 {
 	return tsc_unstable;
 }
+
+void mark_tsc_unstable(void)
+{
+	tsc_unstable = 1;
+}
+EXPORT_SYMBOL_GPL(mark_tsc_unstable);
+
 #ifdef CONFIG_CPU_FREQ
 
 /* Frequency scaling support. Adjust the TSC based timer when the cpu frequency
@@ -174,6 +181,9 @@ __setup("notsc", notsc_setup);
 
 
 /* clock source code: */
+
+static int tsc_update_callback(void);
+
 static cycle_t read_tsc(void)
 {
 	cycle_t ret = (cycle_t)get_cycles_sync();
@@ -192,23 +202,24 @@ static struct clocksource clocksource_ts
 	.read			= read_tsc,
 	.mask			= CLOCKSOURCE_MASK(64),
 	.shift			= 22,
+	.update_callback	= tsc_update_callback,
 	.flags			= CLOCK_SOURCE_IS_CONTINUOUS |
 				  CLOCK_SOURCE_MUST_VERIFY,
 	.vread			= vread_tsc,
 };
 
-void mark_tsc_unstable(void)
+static int tsc_update_callback(void)
 {
-	if (!tsc_unstable) {
-		tsc_unstable = 1;
-		/* Change only the rating, when not registered */
-		if (clocksource_tsc.mult)
-			clocksource_change_rating(&clocksource_tsc, 0);
-		else
-			clocksource_tsc.rating = 0;
+	int change = 0;
+
+	/* check to see if we should switch to the safe clocksource: */
+	if (clocksource_tsc.rating != 50 && check_tsc_unstable()) {
+		clocksource_tsc.rating = 50;
+		clocksource_reselect();
+		change = 1;
 	}
+	return change;
 }
-EXPORT_SYMBOL_GPL(mark_tsc_unstable);
 
 static int __init init_tsc_clocksource(void)
 {
@@ -216,7 +227,7 @@ static int __init init_tsc_clocksource(v
 		clocksource_tsc.mult = clocksource_khz2mult(cpu_khz,
 							clocksource_tsc.shift);
 		if (check_tsc_unstable())
-			clocksource_tsc.rating = 0;
+			clocksource_tsc.rating = 50;
 
 		return clocksource_register(&clocksource_tsc);
 	}

-- 
