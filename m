Return-Path: <linux-kernel-owner+w=401wt.eu-S933146AbXAWWOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933146AbXAWWOm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 17:14:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933145AbXAWWL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 17:11:59 -0500
Received: from www.osadl.org ([213.239.205.134]:35829 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933146AbXAWWAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 17:00:53 -0500
Message-Id: <20070123211204.553722000@localhost.localdomain>
References: <20070123211159.178138000@localhost.localdomain>
Date: Tue, 23 Jan 2007 22:01:07 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       John Stultz <johnstul@us.ibm.com>,
       Arjan van de Veen <arjan@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: [patch 12/46] clocksource: replace is_continuous by a flag field
Content-Disposition: inline;
	filename=clocksource-use-flags-instead-of-is-continuous.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Using a flag filed allows to encode more than one information into
a variable. Preparatory patch for the generic clocksource verification.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>

---
 arch/i386/kernel/hpet.c          |    2 +-
 arch/i386/kernel/tsc.c           |    7 +++++--
 drivers/clocksource/acpi_pm.c    |    3 ++-
 drivers/clocksource/cyclone.c    |    2 +-
 drivers/clocksource/scx200_hrt.c |    2 +-
 include/linux/clocksource.h      |   10 ++++++++--
 kernel/time/jiffies.c            |    1 -
 kernel/timer.c                   |    2 +-
 8 files changed, 19 insertions(+), 10 deletions(-)

Index: linux-2.6.20-rc4-mm1-bo/arch/i386/kernel/hpet.c
===================================================================
--- linux-2.6.20-rc4-mm1-bo.orig/arch/i386/kernel/hpet.c
+++ linux-2.6.20-rc4-mm1-bo/arch/i386/kernel/hpet.c
@@ -26,7 +26,7 @@ static struct clocksource clocksource_hp
 	.mask		= HPET_MASK,
 	.mult		= 0, /* set below */
 	.shift		= HPET_SHIFT,
-	.is_continuous	= 1,
+	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
 static int __init init_hpet_clocksource(void)
Index: linux-2.6.20-rc4-mm1-bo/arch/i386/kernel/tsc.c
===================================================================
--- linux-2.6.20-rc4-mm1-bo.orig/arch/i386/kernel/tsc.c
+++ linux-2.6.20-rc4-mm1-bo/arch/i386/kernel/tsc.c
@@ -314,7 +314,8 @@ static struct clocksource clocksource_ts
 	.mult			= 0, /* to be set */
 	.shift			= 22,
 	.update_callback	= tsc_update_callback,
-	.is_continuous		= 1,
+	.flags			= CLOCK_SOURCE_IS_CONTINUOUS |
+				  CLOCK_SOURCE_MUST_VERIFY,
 };
 
 static int tsc_update_callback(void)
@@ -435,8 +436,10 @@ static int __init init_tsc_clocksource(v
 		clocksource_tsc.mult = clocksource_khz2mult(current_tsc_khz,
 							clocksource_tsc.shift);
 		/* lower the rating if we already know its unstable: */
-		if (check_tsc_unstable())
+		if (check_tsc_unstable()) {
 			clocksource_tsc.rating = 0;
+			clocksource_tsc.flags &= ~CLOCK_SOURCE_IS_CONTINUOUS;
+		}
 
 		init_timer(&verify_tsc_freq_timer);
 		verify_tsc_freq_timer.function = verify_tsc_freq;
Index: linux-2.6.20-rc4-mm1-bo/drivers/clocksource/acpi_pm.c
===================================================================
--- linux-2.6.20-rc4-mm1-bo.orig/drivers/clocksource/acpi_pm.c
+++ linux-2.6.20-rc4-mm1-bo/drivers/clocksource/acpi_pm.c
@@ -72,7 +72,8 @@ static struct clocksource clocksource_ac
 	.mask		= (cycle_t)ACPI_PM_MASK,
 	.mult		= 0, /*to be caluclated*/
 	.shift		= 22,
-	.is_continuous	= 1,
+	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
+
 };
 
 
Index: linux-2.6.20-rc4-mm1-bo/drivers/clocksource/cyclone.c
===================================================================
--- linux-2.6.20-rc4-mm1-bo.orig/drivers/clocksource/cyclone.c
+++ linux-2.6.20-rc4-mm1-bo/drivers/clocksource/cyclone.c
@@ -31,7 +31,7 @@ static struct clocksource clocksource_cy
 	.mask		= CYCLONE_TIMER_MASK,
 	.mult		= 10,
 	.shift		= 0,
-	.is_continuous	= 1,
+	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
 static int __init init_cyclone_clocksource(void)
Index: linux-2.6.20-rc4-mm1-bo/drivers/clocksource/scx200_hrt.c
===================================================================
--- linux-2.6.20-rc4-mm1-bo.orig/drivers/clocksource/scx200_hrt.c
+++ linux-2.6.20-rc4-mm1-bo/drivers/clocksource/scx200_hrt.c
@@ -57,7 +57,7 @@ static struct clocksource cs_hrt = {
 	.rating		= 250,
 	.read		= read_hrt,
 	.mask		= CLOCKSOURCE_MASK(32),
-	.is_continuous	= 1,
+	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 	/* mult, shift are set based on mhz27 flag */
 };
 
Index: linux-2.6.20-rc4-mm1-bo/include/linux/clocksource.h
===================================================================
--- linux-2.6.20-rc4-mm1-bo.orig/include/linux/clocksource.h
+++ linux-2.6.20-rc4-mm1-bo/include/linux/clocksource.h
@@ -45,7 +45,7 @@ typedef u64 cycle_t;
  * @mult:		cycle to nanosecond multiplier
  * @shift:		cycle to nanosecond divisor (power of two)
  * @update_callback:	called when safe to alter clocksource values
- * @is_continuous:	defines if clocksource is free-running.
+ * @flags:		flags describing special properties
  * @cycle_interval:	Used internally by timekeeping core, please ignore.
  * @xtime_interval:	Used internally by timekeeping core, please ignore.
  */
@@ -58,7 +58,7 @@ struct clocksource {
 	u32 mult;
 	u32 shift;
 	int (*update_callback)(void);
-	int is_continuous;
+	unsigned long flags;
 
 	/* timekeeping specific data, ignore */
 	cycle_t cycle_last, cycle_interval;
@@ -66,6 +66,12 @@ struct clocksource {
 	s64 error;
 };
 
+/*
+ * Clock source flags bits::
+ */
+#define CLOCK_SOURCE_IS_CONTINUOUS	0x01
+#define CLOCK_SOURCE_MUST_VERIFY	0x02
+
 /* simplify initialization of mask field */
 #define CLOCKSOURCE_MASK(bits) (cycle_t)(bits<64 ? ((1ULL<<bits)-1) : -1)
 
Index: linux-2.6.20-rc4-mm1-bo/kernel/time/jiffies.c
===================================================================
--- linux-2.6.20-rc4-mm1-bo.orig/kernel/time/jiffies.c
+++ linux-2.6.20-rc4-mm1-bo/kernel/time/jiffies.c
@@ -62,7 +62,6 @@ struct clocksource clocksource_jiffies =
 	.mask		= 0xffffffff, /*32bits*/
 	.mult		= NSEC_PER_JIFFY << JIFFIES_SHIFT, /* details above */
 	.shift		= JIFFIES_SHIFT,
-	.is_continuous	= 0, /* tick based, not free running */
 };
 
 static int __init init_jiffies_clocksource(void)
Index: linux-2.6.20-rc4-mm1-bo/kernel/timer.c
===================================================================
--- linux-2.6.20-rc4-mm1-bo.orig/kernel/timer.c
+++ linux-2.6.20-rc4-mm1-bo/kernel/timer.c
@@ -871,7 +871,7 @@ int timekeeping_is_continuous(void)
 	do {
 		seq = read_seqbegin(&xtime_lock);
 
-		ret = clock->is_continuous;
+		ret = clock->flags & CLOCK_SOURCE_IS_CONTINUOUS;
 
 	} while (read_seqretry(&xtime_lock, seq));
 

--

