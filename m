Return-Path: <linux-kernel-owner+w=401wt.eu-S1757341AbZKMTtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341AbZKMTtf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 14:49:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757001AbZKMTta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 14:49:30 -0500
Received: from hera.kernel.org ([140.211.167.34]:35995 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756929AbZKMTt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 14:49:29 -0500
Date: Fri, 13 Nov 2009 19:49:01 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       linus.walleij@stericsson.com, johnstul@us.ibm.com, mikpe@it.uu.se,
       ralf@linux-mips.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       linus.walleij@stericsson.com, johnstul@us.ibm.com, mikpe@it.uu.se,
       ralf@linux-mips.org, tglx@linutronix.de
In-Reply-To: <20091111134229.766673305@linutronix.de>
References: <20091111134229.766673305@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] clocksource: Provide a generic mult/shift factor calculation
Message-ID: <tip-7d2f944a2b836c69a9d260a0a5f0d1720d57fdff@git.kernel.org>
Git-Commit-ID: 7d2f944a2b836c69a9d260a0a5f0d1720d57fdff
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7d2f944a2b836c69a9d260a0a5f0d1720d57fdff
Gitweb:     http://git.kernel.org/tip/7d2f944a2b836c69a9d260a0a5f0d1720d57fdff
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 11 Nov 2009 14:05:29 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 13 Nov 2009 20:46:23 +0100

clocksource: Provide a generic mult/shift factor calculation

MIPS has two functions to calculcate the mult/shift factors for clock
sources and clock events at run time. ARM needs such functions as
well.

Implement a function which calculates the mult/shift factors based on
the frequencies to which and from which is converted. The function
also has a parameter to specify the minimum conversion range in
seconds. This range is guaranteed not to produce a 64bit overflow when
a value is multiplied with the calculated mult factor. The larger the
conversion range the less becomes the conversion accuracy.

Provide two inline wrappers which handle clock events and clock
sources. For clock events the "from" frequency is nano seconds per
second which corresponds to 1GHz and "to" is the device frequency. For
clock sources "from" is the device frequency and "to" is nano seconds
per second.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Mikael Pettersson <mikpe@it.uu.se>
Acked-by: Ralf Baechle <ralf@linux-mips.org>
Acked-by: Linus Walleij <linus.walleij@stericsson.com>
Cc: John Stultz <johnstul@us.ibm.com>
LKML-Reference: <20091111134229.766673305@linutronix.de>
---
 include/linux/clockchips.h  |    7 +++++
 include/linux/clocksource.h |   10 ++++++++
 kernel/time/clocksource.c   |   53 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 70 insertions(+), 0 deletions(-)

diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
index 3b58410..4d438b0 100644
--- a/include/linux/clockchips.h
+++ b/include/linux/clockchips.h
@@ -130,6 +130,13 @@ extern int clockevents_program_event(struct clock_event_device *dev,
 
 extern void clockevents_handle_noop(struct clock_event_device *dev);
 
+static inline void
+clockevents_calc_mult_shift(struct clock_event_device *ce, u32 freq, u32 minsec)
+{
+	return clocks_calc_mult_shift(&ce->mult, &ce->shift, NSEC_PER_SEC,
+				      freq, minsec);
+}
+
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
 extern void clockevents_notify(unsigned long reason, void *arg);
 #else
diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 83d2fbd..f57f882 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -279,6 +279,16 @@ extern void clocksource_resume(void);
 extern struct clocksource * __init __weak clocksource_default_clock(void);
 extern void clocksource_mark_unstable(struct clocksource *cs);
 
+extern void
+clocks_calc_mult_shift(u32 *mult, u32 *shift, u32 from, u32 to, u32 minsec);
+
+static inline void
+clocksource_calc_mult_shift(struct clocksource *cs, u32 freq, u32 minsec)
+{
+	return clocks_calc_mult_shift(&cs->mult, &cs->shift, freq,
+				      NSEC_PER_SEC, minsec);
+}
+
 #ifdef CONFIG_GENERIC_TIME_VSYSCALL
 extern void update_vsyscall(struct timespec *ts, struct clocksource *c);
 extern void update_vsyscall_tz(void);
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 5e18c6a..407c089 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -107,6 +107,59 @@ u64 timecounter_cyc2time(struct timecounter *tc,
 }
 EXPORT_SYMBOL(timecounter_cyc2time);
 
+/**
+ * clocks_calc_mult_shift - calculate mult/shift factors for scaled math of clocks
+ * @mult:	pointer to mult variable
+ * @shift:	pointer to shift variable
+ * @from:	frequency to convert from
+ * @to:		frequency to convert to
+ * @minsec:	guaranteed runtime conversion range in seconds
+ *
+ * The function evaluates the shift/mult pair for the scaled math
+ * operations of clocksources and clockevents.
+ *
+ * @to and @from are frequency values in HZ. For clock sources @to is
+ * NSEC_PER_SEC == 1GHz and @from is the counter frequency. For clock
+ * event @to is the counter frequency and @from is NSEC_PER_SEC.
+ *
+ * The @minsec conversion range argument controls the time frame in
+ * seconds which must be covered by the runtime conversion with the
+ * calculated mult and shift factors. This guarantees that no 64bit
+ * overflow happens when the input value of the conversion is
+ * multiplied with the calculated mult factor. Larger ranges may
+ * reduce the conversion accuracy by chosing smaller mult and shift
+ * factors.
+ */
+void
+clocks_calc_mult_shift(u32 *mult, u32 *shift, u32 from, u32 to, u32 minsec)
+{
+	u64 tmp;
+	u32 sft, sftacc= 32;
+
+	/*
+	 * Calculate the shift factor which is limiting the conversion
+	 * range:
+	 */
+	tmp = ((u64)minsec * from) >> 32;
+	while (tmp) {
+		tmp >>=1;
+		sftacc--;
+	}
+
+	/*
+	 * Find the conversion shift/mult pair which has the best
+	 * accuracy and fits the maxsec conversion range:
+	 */
+	for (sft = 32; sft > 0; sft--) {
+		tmp = (u64) to << sft;
+		do_div(tmp, from);
+		if ((tmp >> sftacc) == 0)
+			break;
+	}
+	*mult = tmp;
+	*shift = sft;
+}
+
 /*[Clocksource internal variables]---------
  * curr_clocksource:
  *	currently selected clocksource.
