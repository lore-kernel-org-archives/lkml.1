Return-Path: <linux-kernel-owner+w=401wt.eu-S1756302AbZKKOF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302AbZKKOF6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 09:05:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756181AbZKKOF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 09:05:56 -0500
Received: from www.tglx.de ([62.245.132.106]:47103 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756152AbZKKOFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 09:05:54 -0500
Message-Id: <20091111134229.807255074@linutronix.de>
User-Agent: quilt/0.47-1
Date: Wed, 11 Nov 2009 14:05:34 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Mikael Pettersson <mikpe@it.uu.se>, Ralf Baechle <ralf@linux-mips.org>,
       Linus Walleij <linus.walleij@stericsson.com>,
       John Stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 3/3] mips: Use generic mult/shift factor calculation for clocks
References: <20091111134018.393422332@linutronix.de>
Content-Disposition: inline;
	filename=mips-use-generic-shift-mult-calculation.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the MIPS functions of mult/shift factor calculation for clock
events and clock sources with inline functions which call the generic
functions. The minimum guaranteed conversion range is set to 4 seconds
which corresponds to the current MIPS implementation.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Mikael Pettersson <mikpe@it.uu.se>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/mips/include/asm/time.h |   14 +++++++++++---
 arch/mips/kernel/time.c      |   33 ---------------------------------
 2 files changed, 11 insertions(+), 36 deletions(-)

Index: linux-2.6-tip/arch/mips/include/asm/time.h
===================================================================
--- linux-2.6-tip.orig/arch/mips/include/asm/time.h
+++ linux-2.6-tip/arch/mips/include/asm/time.h
@@ -84,8 +84,16 @@ static inline int init_mips_clocksource(
 #endif
 }
 
-extern void clocksource_set_clock(struct clocksource *cs, unsigned int clock);
-extern void clockevent_set_clock(struct clock_event_device *cd,
-		unsigned int clock);
+static inline void clocksource_set_clock(struct clocksource *cs,
+					 unsigned int clock)
+{
+	clocksource_calc_mult_shift(cs, clock, 4);
+}
+
+static inline void clockevent_set_clock(struct clock_event_device *cd,
+					unsigned int clock)
+{
+	clockevents_calc_mult_shift(cd, clock, 4);
+}
 
 #endif /* _ASM_TIME_H */
Index: linux-2.6-tip/arch/mips/kernel/time.c
===================================================================
--- linux-2.6-tip.orig/arch/mips/kernel/time.c
+++ linux-2.6-tip/arch/mips/kernel/time.c
@@ -71,39 +71,6 @@ EXPORT_SYMBOL(perf_irq);
 
 unsigned int mips_hpt_frequency;
 
-void __init clocksource_set_clock(struct clocksource *cs, unsigned int clock)
-{
-	u64 temp;
-	u32 shift;
-
-	/* Find a shift value */
-	for (shift = 32; shift > 0; shift--) {
-		temp = (u64) NSEC_PER_SEC << shift;
-		do_div(temp, clock);
-		if ((temp >> 32) == 0)
-			break;
-	}
-	cs->shift = shift;
-	cs->mult = (u32) temp;
-}
-
-void __cpuinit clockevent_set_clock(struct clock_event_device *cd,
-	unsigned int clock)
-{
-	u64 temp;
-	u32 shift;
-
-	/* Find a shift value */
-	for (shift = 32; shift > 0; shift--) {
-		temp = (u64) clock << shift;
-		do_div(temp, NSEC_PER_SEC);
-		if ((temp >> 32) == 0)
-			break;
-	}
-	cd->shift = shift;
-	cd->mult = (u32) temp;
-}
-
 /*
  * This function exists in order to cause an error due to a duplicate
  * definition if platform code should have its own implementation.  The hook


