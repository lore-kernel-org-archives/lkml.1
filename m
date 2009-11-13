Return-Path: <linux-kernel-owner+w=401wt.eu-S932218AbZKMTto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932218AbZKMTto (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 14:49:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757145AbZKMTtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 14:49:39 -0500
Received: from hera.kernel.org ([140.211.167.34]:36003 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757343AbZKMTtg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 14:49:36 -0500
Date: Fri, 13 Nov 2009 19:49:17 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       linus.walleij@stericsson.com, johnstul@us.ibm.com, mikpe@it.uu.se,
       ralf@linux-mips.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       linus.walleij@stericsson.com, johnstul@us.ibm.com, mikpe@it.uu.se,
       ralf@linux-mips.org, tglx@linutronix.de
In-Reply-To: <20091111134229.807255074@linutronix.de>
References: <20091111134229.807255074@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] mips: Use generic mult/shift factor calculation for clocks
Message-ID: <tip-e3a4fab0c0c30e21e104712f4e9cb39f175d0f21@git.kernel.org>
Git-Commit-ID: e3a4fab0c0c30e21e104712f4e9cb39f175d0f21
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e3a4fab0c0c30e21e104712f4e9cb39f175d0f21
Gitweb:     http://git.kernel.org/tip/e3a4fab0c0c30e21e104712f4e9cb39f175d0f21
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 11 Nov 2009 14:05:34 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 13 Nov 2009 20:46:24 +0100

mips: Use generic mult/shift factor calculation for clocks

Replace the MIPS functions of mult/shift factor calculation for clock
events and clock sources with inline functions which call the generic
functions. The minimum guaranteed conversion range is set to 4 seconds
which corresponds to the current MIPS implementation.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Mikael Pettersson <mikpe@it.uu.se>
Acked-by: Ralf Baechle <ralf@linux-mips.org>
Acked-by: Linus Walleij <linus.walleij@stericsson.com>
Cc: John Stultz <johnstul@us.ibm.com>
LKML-Reference: <20091111134229.807255074@linutronix.de>
---
 arch/mips/include/asm/time.h |   14 +++++++++++---
 arch/mips/kernel/time.c      |   33 ---------------------------------
 2 files changed, 11 insertions(+), 36 deletions(-)

diff --git a/arch/mips/include/asm/time.h b/arch/mips/include/asm/time.h
index df6a430..c7f1bfe 100644
--- a/arch/mips/include/asm/time.h
+++ b/arch/mips/include/asm/time.h
@@ -84,8 +84,16 @@ static inline int init_mips_clocksource(void)
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
diff --git a/arch/mips/kernel/time.c b/arch/mips/kernel/time.c
index 1f467d5..fb74974 100644
--- a/arch/mips/kernel/time.c
+++ b/arch/mips/kernel/time.c
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
