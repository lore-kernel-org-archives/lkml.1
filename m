Return-Path: <linux-kernel-owner+w=401wt.eu-S1760997AbYEEXNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760997AbYEEXNT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 19:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752030AbYEEXNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 19:13:10 -0400
Received: from mail.ift.unesp.br ([200.145.46.3]:56982 "EHLO mail.ift.unesp.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752569AbYEEXNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 19:13:08 -0400
Date: Mon, 5 May 2008 20:11:22 -0300
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, venkatesh.pallipadi@intel.com
Subject: x86: Clean up computation of HPET .mult variables
Message-ID: <20080505231016.GA29072@beyonder.ift.unesp.br>
Mail-Followup-To: linux-kernel@vger.kernel.org, tglx@linutronix.de,
	venkatesh.pallipadi@intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While reading through the HPET code I realized that the
computation of .mult variables could be done with less
lines of code, resulting in a 1.6% text size saving
for hpet.o

So I propose the following patch, which applies against 
today's Linus -git tree.


>From 0c6507e400e9ca5f7f14331e18f8c12baf75a9d3 Mon Sep 17 00:00:00 2001
From: Carlos R. Mafra <crmafra@ift.unesp.br>
Date: Mon, 5 May 2008 19:38:53 -0300
Subject: [PATCH] x86: Clean up computation of HPET .mult variables

The computation of clocksource_hpet.mult

       tmp = (u64)hpet_period << HPET_SHIFT;
       do_div(tmp, FSEC_PER_NSEC);
       clocksource_hpet.mult = (u32)tmp;

can be streamlined if we note that it is equal to

       clocksource_hpet.mult = div_sc(hpet_period, FSEC_PER_NSEC, HPET_SHIFT);

Furthermore, the computation of hpet_clockevent.mult

       uint64_t hpet_freq;

       hpet_freq = 1000000000000000ULL;
       do_div(hpet_freq, hpet_period);
       hpet_clockevent.mult = div_sc((unsigned long) hpet_freq,
                                     NSEC_PER_SEC, hpet_clockevent.shift);

can also be streamlined with the observation that hpet_period and hpet_freq are
inverse to each other (in proper units).

So instead of computing hpet_freq and using (schematically)
div_sc(hpet_freq, 10^9, shift) we use the trick of calling with the
arguments in reverse order, div_sc(10^6, hpet_period, shift).

The different power of ten is due to frequency being in Hertz (1/sec)
and the period being in units of femtosecond. Explicitly,

mult = (hpet_freq * 2^shift)/10^9    (before)
mult = (10^6 * 2^shift)/hpet_period  (after)

because hpet_freq = 10^15/hpet_period.

The comments in the code are also updated to reflect the changes.

As a result,

   text    data     bss     dec     hex filename
   2957     425      92    3474     d92 arch/x86/kernel/hpet.o
   3006     425      92    3523     dc3 arch/x86/kernel/hpet.o.old

a 1.6% reduction in text size.

Signed-off-by: Carlos R. Mafra <crmafra@ift.unesp.br>
---
 arch/x86/kernel/hpet.c |   43 ++++++++++++++++++-------------------------
 1 files changed, 18 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 9b5cfcd..ea230ec 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -17,7 +17,7 @@
 
 /* FSEC = 10^-15
    NSEC = 10^-9 */
-#define FSEC_PER_NSEC	1000000
+#define FSEC_PER_NSEC	1000000L
 
 /*
  * HPET address is set in acpi/boot.c, when an ACPI entry exists
@@ -206,20 +206,19 @@ static void hpet_enable_legacy_int(void)
 
 static void hpet_legacy_clockevent_register(void)
 {
-	uint64_t hpet_freq;
-
 	/* Start HPET legacy interrupts */
 	hpet_enable_legacy_int();
 
 	/*
-	 * The period is a femto seconds value. We need to calculate the
-	 * scaled math multiplication factor for nanosecond to hpet tick
-	 * conversion.
+	 * The mult factor is defined as (include/linux/clockchips.h)
+	 *  mult/2^shift = cyc/ns (in contrast to ns/cyc in clocksource.h)
+	 * hpet_period is in units of femtoseconds (per cycle), so
+	 *  mult/2^shift = cyc/ns = 10^6/hpet_period
+	 *  mult = (10^6 * 2^shift)/hpet_period
+	 *  mult = (FSEC_PER_NSEC << hpet_clockevent.shift)/hpet_period
 	 */
-	hpet_freq = 1000000000000000ULL;
-	do_div(hpet_freq, hpet_period);
-	hpet_clockevent.mult = div_sc((unsigned long) hpet_freq,
-				      NSEC_PER_SEC, hpet_clockevent.shift);
+	hpet_clockevent.mult = div_sc((unsigned long) FSEC_PER_NSEC,
+				      hpet_period, hpet_clockevent.shift);
 	/* Calculate the min / max delta */
 	hpet_clockevent.max_delta_ns = clockevent_delta2ns(0x7FFFFFFF,
 							   &hpet_clockevent);
@@ -324,7 +323,7 @@ static struct clocksource clocksource_hpet = {
 
 static int hpet_clocksource_register(void)
 {
-	u64 tmp, start, now;
+	u64 start, now;
 	cycle_t t1;
 
 	/* Start the counter */
@@ -351,21 +350,15 @@ static int hpet_clocksource_register(void)
 		return -ENODEV;
 	}
 
-	/* Initialize and register HPET clocksource
-	 *
-	 * hpet period is in femto seconds per cycle
-	 * so we need to convert this to ns/cyc units
-	 * approximated by mult/2^shift
-	 *
-	 *  fsec/cyc * 1nsec/1000000fsec = nsec/cyc = mult/2^shift
-	 *  fsec/cyc * 1ns/1000000fsec * 2^shift = mult
-	 *  fsec/cyc * 2^shift * 1nsec/1000000fsec = mult
-	 *  (fsec/cyc << shift)/1000000 = mult
-	 *  (hpet_period << shift)/FSEC_PER_NSEC = mult
+	/*
+	 * The definition of mult is (include/linux/clocksource.h)
+	 * mult/2^shift = ns/cyc and hpet_period is in units of fsec/cyc
+	 * so we first need to convert hpet_period to ns/cyc units:
+	 *  mult/2^shift = ns/cyc = hpet_period/10^6
+	 *  mult = (hpet_period * 2^shift)/10^6
+	 *  mult = (hpet_period << shift)/FSEC_PER_NSEC
 	 */
-	tmp = (u64)hpet_period << HPET_SHIFT;
-	do_div(tmp, FSEC_PER_NSEC);
-	clocksource_hpet.mult = (u32)tmp;
+	clocksource_hpet.mult = div_sc(hpet_period, FSEC_PER_NSEC, HPET_SHIFT);
 
 	clocksource_register(&clocksource_hpet);
 
-- 
1.5.4.3

