Return-Path: <linux-kernel-owner+w=401wt.eu-S2992456AbXEAEDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992456AbXEAEDm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 00:03:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946476AbXEAEBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 00:01:30 -0400
Received: from ns1.suse.de ([195.135.220.2]:60919 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946311AbXEAD6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 23:58:05 -0400
From: Andi Kleen <ak@suse.de>
References: <20070501557.815359000@suse.de>
In-Reply-To: <20070501557.815359000@suse.de>
To: dpreed@reed.com, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [7/30] x86_64: Avoid overflows during apic timer calibration
Message-Id: <20070501035804.940A313CAF@wotan.suse.de>
Date: Tue,  1 May 2007 05:58:04 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: David P. Reed <dpreed@reed.com>

- Use 64bit TSC calculations to avoid handling overflow
- Use 32bit unsigned arithmetic for the APIC timer. This
way overflows are handled correctly.
- Fix exit check of loop to account for apic timer counting down

Signed-off-by: dpreed@reed.com
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/kernel/apic.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

Index: linux/arch/x86_64/kernel/apic.c
===================================================================
--- linux.orig/arch/x86_64/kernel/apic.c
+++ linux/arch/x86_64/kernel/apic.c
@@ -839,14 +839,15 @@ static void setup_APIC_timer(unsigned in
 
 static int __init calibrate_APIC_clock(void)
 {
-	int apic, apic_start, tsc, tsc_start;
+	unsigned apic, apic_start;
+	unsigned long tsc, tsc_start;
 	int result;
 	/*
 	 * Put whatever arbitrary (but long enough) timeout
 	 * value into the APIC clock, we just want to get the
 	 * counter running for calibration.
 	 */
-	__setup_APIC_LVTT(1000000000);
+	__setup_APIC_LVTT(4000000000);
 
 	apic_start = apic_read(APIC_TMCCT);
 #ifdef CONFIG_X86_PM_TIMER
@@ -857,13 +858,13 @@ static int __init calibrate_APIC_clock(v
 	} else
 #endif
 	{
-		rdtscl(tsc_start);
+		rdtscll(tsc_start);
 
 		do {
 			apic = apic_read(APIC_TMCCT);
-			rdtscl(tsc);
+			rdtscll(tsc);
 		} while ((tsc - tsc_start) < TICK_COUNT &&
-				(apic - apic_start) < TICK_COUNT);
+				(apic_start - apic) < TICK_COUNT);
 
 		result = (apic_start - apic) * 1000L * tsc_khz /
 					(tsc - tsc_start);
