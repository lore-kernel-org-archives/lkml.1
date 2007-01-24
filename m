Return-Path: <linux-kernel-owner+w=401wt.eu-S1752015AbXAXRW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015AbXAXRW6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 12:22:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752036AbXAXRW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 12:22:58 -0500
Received: from h155.mvista.com ([63.81.120.158]:37157 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbXAXRW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 12:22:56 -0500
Subject: Re: [patch 00/46] High resolution timer / dynamic tick update
From: Daniel Walker <dwalker@mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: tglx@linutronix.de, Andrew Morton <akpm@osdl.org>,
       LKML <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>,
       Arjan van de Veen <arjan@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>
In-Reply-To: <20070124160046.GA24798@elte.hu>
References: <20070123211159.178138000@localhost.localdomain>
	 <1169604991.19471.95.camel@imap.mvista.com>
	 <20070124070701.GA17654@elte.hu>
	 <1169631016.19471.175.camel@imap.mvista.com>
	 <20070124095157.GA21346@elte.hu>
	 <1169634220.19471.197.camel@imap.mvista.com>
	 <1169637237.21181.164.camel@localhost.localdomain>
	 <1169654001.19471.231.camel@imap.mvista.com>
	 <20070124160046.GA24798@elte.hu>
Content-Type: text/plain
Date: Wed, 24 Jan 2007 09:21:37 -0800
Message-Id: <1169659297.19471.247.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-01-24 at 17:00 +0100, Ingo Molnar wrote:
> you are also misunderstand the change. While the TSC is the only 
> unstable clocksource right now, the previous code tied the TSC to the
> >pm-timer< clocksource. This change makes it generic, hence the TSC can
> be verified by a hpet-only system (no pm-timer) as well. Systems without 
> a pm-timer and with a TSC are quite common. So it solves a real problem.

Here is an example of what I was talking about in my last email . This
is a TSC specific clock verify ontop of -mm + my patches. It will use
and acpi_pm or and hpet (or pit or whatever) . Clearly the
implementation details could be worked on but the clock access would
remain largely the same.

Signed-Off-By: Daniel Walker <dwalker@mvista.com>

---
 arch/i386/kernel/tsc.c      |   93 ++++++++++++++++++++------------------------
 include/linux/clocksource.h |    5 ++
 2 files changed, 49 insertions(+), 49 deletions(-)

Index: linux-2.6.19/arch/i386/kernel/tsc.c
===================================================================
--- linux-2.6.19.orig/arch/i386/kernel/tsc.c
+++ linux-2.6.19/arch/i386/kernel/tsc.c
@@ -343,7 +343,7 @@ static struct clocksource clocksource_ts
 	.mask			= CLOCKSOURCE_MASK(64),
 	.mult			= 0, /* to be set */
 	.shift			= 22,
-	.flags			= CLOCKSOURCE_64BITS,
+	.flags			= CLOCKSOURCE_64BITS | CLOCKSOURCE_PM_AFFECTED,
 	.list			= LIST_HEAD_INIT(clocksource_tsc.list),
 };
 
@@ -382,55 +382,54 @@ static struct dmi_system_id __initdata b
 	 {}
 };
 
-#define TSC_FREQ_CHECK_INTERVAL MSEC_PER_SEC
+#define WATCHDOG_TRESHOLD (NSEC_PER_SEC >> 4)
+#define TSC_FREQ_CHECK_INTERVAL (MSEC_PER_SEC/2)
 static struct timer_list verify_tsc_freq_timer;
 static unsigned long pm_multiplier;
+struct clocksource *verify_clock;
+
 
 /* XXX - Probably should add locking */
 static void verify_tsc_freq(unsigned long unused)
 {
-	static u64 last_tsc;
-	static unsigned long last_jiffies, last_pm;
+	static unsigned long last_jiffies;
+	static cycle_t last_tsc, last_verify;
 
-	u64 now_tsc, interval_tsc, tmp;
-	unsigned long now_jiffies, interval_jiffies, pm, pm_delta;
+	cycle_t now_tsc, interval_tsc, verify_clock_now, interval_verify;
+	unsigned long now_jiffies, interval_jiffies;
+	s64 ns_tsc, ns_verify, clock_diff;
 
 	if (check_tsc_unstable())
 		return;
 
-	rdtscll(now_tsc);
 	now_jiffies = jiffies;
-	pm = acpi_pm_read_early();
+
+	now_tsc = clocksource_read(&clocksource_tsc);
+	verify_clock_now = clocksource_read(verify_clock);
 
 	if (!last_jiffies)
 		goto out;
 
-	interval_tsc = now_tsc - last_tsc;
-	interval_tsc *= HZ;
-	do_div(interval_tsc, cpu_khz*1000);
-
-	if (pm == last_pm) {
-		interval_jiffies = now_jiffies - last_jiffies;
-	} else {
-		if (pm < last_pm)
-			pm_delta = (pm + ACPI_PM_OVRRUN) - last_pm;
-		else
-			pm_delta = pm - last_pm;
-		tmp = (((u64) pm_delta) * pm_multiplier) >> 22;
-		do_div(tmp, (NSEC_PER_SEC/HZ));
-		interval_jiffies = (unsigned long) tmp;
-	}
 
-	if (interval_tsc < (interval_jiffies * 3 / 4)) {
+	interval_tsc = clocksource_subtract(&clocksource_tsc, last_tsc, now_tsc);
+	interval_verify = clocksource_subtract(verify_clock, last_verify,
+					       verify_clock_now);
+
+	ns_tsc = cyc2ns(&clocksource_tsc, interval_tsc);
+	ns_verify = cyc2ns(verify_clock, interval_verify);
+
+	clock_diff = ns_tsc - ns_verify;
+	if (abs(clock_diff) > WATCHDOG_TRESHOLD) {
 		printk("TSC appears to be running slowly. "
-		       "Marking it as unstable\n");
+		       "Marking it as unstable");
 		mark_tsc_unstable();
 		return;
 	}
 out:
 	last_tsc = now_tsc;
 	last_jiffies = now_jiffies;
-	last_pm = pm;
+	last_verify = verify_clock_now;
+
 	/* set us up to go off on the next interval: */
 	mod_timer(&verify_tsc_freq_timer,
 		jiffies + msecs_to_jiffies(TSC_FREQ_CHECK_INTERVAL));
@@ -471,29 +470,6 @@ static int __init init_tsc_clocksource(v
 		if (check_tsc_unstable())
 			clocksource_tsc.flags |= CLOCKSOURCE_UNSTABLE;
 
-		/*
-		 * Mark TSC unsuitable for high resolution timers, when
-		 * pm_timer is not available as a fallback. TSC has so many
-		 * pitfalls: frequency changes, stop in idle ...  When we
-		 * switch to high resolution mode we can not longer detect a
-		 * firmware caused frequency change, as the emulated tick uses
-		 * TSC as reference. This results in a circular dependency.
-		 * Switch only to high resolution mode, if pm_timer or such is
-		 * available.
-		 */
-		if (!pmtmr_ioport) {
-			mark_tsc_unstable();
-			clocksource_tsc.flags &= CLOCKSOURCE_UNSTABLE;
-		}
-
-		pm_multiplier = clocksource_hz2mult(PMTMR_TICKS_PER_SEC, 22);
-
-		init_timer(&verify_tsc_freq_timer);
-		verify_tsc_freq_timer.function = verify_tsc_freq;
-		verify_tsc_freq_timer.expires =
-			jiffies + msecs_to_jiffies(TSC_FREQ_CHECK_INTERVAL);
-		add_timer(&verify_tsc_freq_timer);
-
 		return clocksource_register(&clocksource_tsc);
 	}
 
@@ -501,3 +477,22 @@ static int __init init_tsc_clocksource(v
 }
 
 fs_initcall(init_tsc_clocksource);
+
+void tsc_verify_init(void)
+{
+	verify_clock = clocksource_get_clock(NULL, CLOCKSOURCE_PM_AFFECTED);
+	if (!verify_clock) {
+		printk("TSC: Verify clock not found!\n");
+		return;
+	}
+
+	printk("TSC: selected %s for TSC verification\n", verify_clock->name);
+
+	init_timer(&verify_tsc_freq_timer);
+	verify_tsc_freq_timer.function = verify_tsc_freq;
+	verify_tsc_freq_timer.expires =
+		jiffies + msecs_to_jiffies(TSC_FREQ_CHECK_INTERVAL);
+	add_timer(&verify_tsc_freq_timer);
+
+}
+device_initcall(tsc_verify_init);
Index: linux-2.6.19/include/linux/clocksource.h
===================================================================
--- linux-2.6.19.orig/include/linux/clocksource.h
+++ linux-2.6.19/include/linux/clocksource.h
@@ -207,6 +207,11 @@ static inline s64 cyc2ns(struct clocksou
 	return ret;
 }
 
+static inline s64 clocksource_subtract(struct clocksource* cs, s64 start, s64 stop)
+{
+	return ((stop - start) & cs->mask);
+}
+
 /**
  * clocksource_calculate_interval - Calculates a clocksource interval struct
  *


