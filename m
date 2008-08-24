Return-Path: <linux-kernel-owner+w=401wt.eu-S1757155AbYHXJIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757155AbYHXJIp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 05:08:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755287AbYHXJD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 05:03:27 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:44068 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755225AbYHXJDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 05:03:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=geZaIz6502Bmw790O39iu03Y2zAKu/VGTEDaznuVT2jnqqURv0W76VA6ePkpSsBbgy
         ZzyAgxsJZkWo0itRt6RxxR8OggGamtbze37a30UvHjPOwC192tp+jF70HJVfBwRdXR1B
         Q88eUn0+Fuk9Wa3SxHHv7wpme2q7tCIXtnP/4=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 16/18] x86: apic copy calibrate_APIC_clock to each other in apic_32/64.c
Date: Sun, 24 Aug 2008 02:01:54 -0700
Message-Id: <1219568516-681-17-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1219568516-681-1-git-send-email-yhlu.kernel@gmail.com>
References: <1219568516-681-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/apic_32.c |   86 ++++++++++++++++++
 arch/x86/kernel/apic_64.c |  215 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 301 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index d357038..b21b772 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -424,6 +424,90 @@ static void __cpuinit setup_APIC_timer(void)
 	clockevents_register_device(levt);
 }
 
+#ifdef CONFIG_X86_64
+/*
+ * In this function we calibrate APIC bus clocks to the external
+ * timer. Unfortunately we cannot use jiffies and the timer irq
+ * to calibrate, since some later bootup code depends on getting
+ * the first irq? Ugh.
+ *
+ * We want to do the calibration only once since we
+ * want to have local timer irqs syncron. CPUs connected
+ * by the same APIC bus have the very same bus frequency.
+ * And we want to have irqs off anyways, no accidental
+ * APIC irq that way.
+ */
+
+#define TICK_COUNT 100000000
+
+static int __init calibrate_APIC_clock(void)
+{
+	unsigned apic, apic_start;
+	unsigned long tsc, tsc_start;
+	int result;
+
+	local_irq_disable();
+
+	/*
+	 * Put whatever arbitrary (but long enough) timeout
+	 * value into the APIC clock, we just want to get the
+	 * counter running for calibration.
+	 *
+	 * No interrupt enable !
+	 */
+	__setup_APIC_LVTT(250000000, 0, 0);
+
+	apic_start = apic_read(APIC_TMCCT);
+#ifdef CONFIG_X86_PM_TIMER
+	if (apic_calibrate_pmtmr && pmtmr_ioport) {
+		pmtimer_wait(5000);  /* 5ms wait */
+		apic = apic_read(APIC_TMCCT);
+		result = (apic_start - apic) * 1000L / 5;
+	} else
+#endif
+	{
+		rdtscll(tsc_start);
+
+		do {
+			apic = apic_read(APIC_TMCCT);
+			rdtscll(tsc);
+		} while ((tsc - tsc_start) < TICK_COUNT &&
+				(apic_start - apic) < TICK_COUNT);
+
+		result = (apic_start - apic) * 1000L * tsc_khz /
+					(tsc - tsc_start);
+	}
+
+	local_irq_enable();
+
+	printk(KERN_DEBUG "APIC timer calibration result %d\n", result);
+
+	printk(KERN_INFO "Detected %d.%03d MHz APIC timer.\n",
+		result / 1000 / 1000, result / 1000 % 1000);
+
+	/* Calculate the scaled math multiplication factor */
+	lapic_clockevent.mult = div_sc(result, NSEC_PER_SEC,
+				       lapic_clockevent.shift);
+	lapic_clockevent.max_delta_ns =
+		clockevent_delta2ns(0x7FFFFF, &lapic_clockevent);
+	lapic_clockevent.min_delta_ns =
+		clockevent_delta2ns(0xF, &lapic_clockevent);
+
+	calibration_result = (result * APIC_DIVISOR) / HZ;
+
+	/*
+	 * Do a sanity check on the APIC calibration result
+	 */
+	if (calibration_result < (1000000 / HZ)) {
+		printk(KERN_WARNING
+			"APIC frequency too slow, disabling apic timer\n");
+		return -1;
+	}
+
+	return 0;
+}
+
+#else
 /*
  * In this functions we calibrate APIC bus clocks to the external timer.
  *
@@ -635,6 +719,8 @@ static int __init calibrate_APIC_clock(void)
 	return 0;
 }
 
+#endif
+
 /*
  * Setup the boot APIC
  *
diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index c728885..6e99af5 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -478,6 +478,7 @@ static void __cpuinit setup_APIC_timer(void)
 	clockevents_register_device(levt);
 }
 
+#ifdef CONFIG_X86_64
 /*
  * In this function we calibrate APIC bus clocks to the external
  * timer. Unfortunately we cannot use jiffies and the timer irq
@@ -560,6 +561,220 @@ static int __init calibrate_APIC_clock(void)
 	return 0;
 }
 
+#else
+/*
+ * In this functions we calibrate APIC bus clocks to the external timer.
+ *
+ * We want to do the calibration only once since we want to have local timer
+ * irqs syncron. CPUs connected by the same APIC bus have the very same bus
+ * frequency.
+ *
+ * This was previously done by reading the PIT/HPET and waiting for a wrap
+ * around to find out, that a tick has elapsed. I have a box, where the PIT
+ * readout is broken, so it never gets out of the wait loop again. This was
+ * also reported by others.
+ *
+ * Monitoring the jiffies value is inaccurate and the clockevents
+ * infrastructure allows us to do a simple substitution of the interrupt
+ * handler.
+ *
+ * The calibration routine also uses the pm_timer when possible, as the PIT
+ * happens to run way too slow (factor 2.3 on my VAIO CoreDuo, which goes
+ * back to normal later in the boot process).
+ */
+
+#define LAPIC_CAL_LOOPS		(HZ/10)
+
+static __initdata int lapic_cal_loops = -1;
+static __initdata long lapic_cal_t1, lapic_cal_t2;
+static __initdata unsigned long long lapic_cal_tsc1, lapic_cal_tsc2;
+static __initdata unsigned long lapic_cal_pm1, lapic_cal_pm2;
+static __initdata unsigned long lapic_cal_j1, lapic_cal_j2;
+
+/*
+ * Temporary interrupt handler.
+ */
+static void __init lapic_cal_handler(struct clock_event_device *dev)
+{
+	unsigned long long tsc = 0;
+	long tapic = apic_read(APIC_TMCCT);
+	unsigned long pm = acpi_pm_read_early();
+
+	if (cpu_has_tsc)
+		rdtscll(tsc);
+
+	switch (lapic_cal_loops++) {
+	case 0:
+		lapic_cal_t1 = tapic;
+		lapic_cal_tsc1 = tsc;
+		lapic_cal_pm1 = pm;
+		lapic_cal_j1 = jiffies;
+		break;
+
+	case LAPIC_CAL_LOOPS:
+		lapic_cal_t2 = tapic;
+		lapic_cal_tsc2 = tsc;
+		if (pm < lapic_cal_pm1)
+			pm += ACPI_PM_OVRRUN;
+		lapic_cal_pm2 = pm;
+		lapic_cal_j2 = jiffies;
+		break;
+	}
+}
+
+static int __init calibrate_APIC_clock(void)
+{
+	struct clock_event_device *levt = &__get_cpu_var(lapic_events);
+	const long pm_100ms = PMTMR_TICKS_PER_SEC/10;
+	const long pm_thresh = pm_100ms/100;
+	void (*real_handler)(struct clock_event_device *dev);
+	unsigned long deltaj;
+	long delta, deltapm;
+	int pm_referenced = 0;
+
+	local_irq_disable();
+
+	/* Replace the global interrupt handler */
+	real_handler = global_clock_event->event_handler;
+	global_clock_event->event_handler = lapic_cal_handler;
+
+	/*
+	 * Setup the APIC counter to 1e9. There is no way the lapic
+	 * can underflow in the 100ms detection time frame
+	 */
+	__setup_APIC_LVTT(1000000000, 0, 0);
+
+	/* Let the interrupts run */
+	local_irq_enable();
+
+	while (lapic_cal_loops <= LAPIC_CAL_LOOPS)
+		cpu_relax();
+
+	local_irq_disable();
+
+	/* Restore the real event handler */
+	global_clock_event->event_handler = real_handler;
+
+	/* Build delta t1-t2 as apic timer counts down */
+	delta = lapic_cal_t1 - lapic_cal_t2;
+	apic_printk(APIC_VERBOSE, "... lapic delta = %ld\n", delta);
+
+	/* Check, if the PM timer is available */
+	deltapm = lapic_cal_pm2 - lapic_cal_pm1;
+	apic_printk(APIC_VERBOSE, "... PM timer delta = %ld\n", deltapm);
+
+	if (deltapm) {
+		unsigned long mult;
+		u64 res;
+
+		mult = clocksource_hz2mult(PMTMR_TICKS_PER_SEC, 22);
+
+		if (deltapm > (pm_100ms - pm_thresh) &&
+		    deltapm < (pm_100ms + pm_thresh)) {
+			apic_printk(APIC_VERBOSE, "... PM timer result ok\n");
+		} else {
+			res = (((u64) deltapm) *  mult) >> 22;
+			do_div(res, 1000000);
+			printk(KERN_WARNING "APIC calibration not consistent "
+			       "with PM Timer: %ldms instead of 100ms\n",
+			       (long)res);
+			/* Correct the lapic counter value */
+			res = (((u64) delta) * pm_100ms);
+			do_div(res, deltapm);
+			printk(KERN_INFO "APIC delta adjusted to PM-Timer: "
+			       "%lu (%ld)\n", (unsigned long) res, delta);
+			delta = (long) res;
+		}
+		pm_referenced = 1;
+	}
+
+	/* Calculate the scaled math multiplication factor */
+	lapic_clockevent.mult = div_sc(delta, TICK_NSEC * LAPIC_CAL_LOOPS,
+				       lapic_clockevent.shift);
+	lapic_clockevent.max_delta_ns =
+		clockevent_delta2ns(0x7FFFFF, &lapic_clockevent);
+	lapic_clockevent.min_delta_ns =
+		clockevent_delta2ns(0xF, &lapic_clockevent);
+
+	calibration_result = (delta * APIC_DIVISOR) / LAPIC_CAL_LOOPS;
+
+	apic_printk(APIC_VERBOSE, "..... delta %ld\n", delta);
+	apic_printk(APIC_VERBOSE, "..... mult: %ld\n", lapic_clockevent.mult);
+	apic_printk(APIC_VERBOSE, "..... calibration result: %u\n",
+		    calibration_result);
+
+	if (cpu_has_tsc) {
+		delta = (long)(lapic_cal_tsc2 - lapic_cal_tsc1);
+		apic_printk(APIC_VERBOSE, "..... CPU clock speed is "
+			    "%ld.%04ld MHz.\n",
+			    (delta / LAPIC_CAL_LOOPS) / (1000000 / HZ),
+			    (delta / LAPIC_CAL_LOOPS) % (1000000 / HZ));
+	}
+
+	apic_printk(APIC_VERBOSE, "..... host bus clock speed is "
+		    "%u.%04u MHz.\n",
+		    calibration_result / (1000000 / HZ),
+		    calibration_result % (1000000 / HZ));
+
+	/*
+	 * Do a sanity check on the APIC calibration result
+	 */
+	if (calibration_result < (1000000 / HZ)) {
+		local_irq_enable();
+		printk(KERN_WARNING
+		       "APIC frequency too slow, disabling apic timer\n");
+		return -1;
+	}
+
+	levt->features &= ~CLOCK_EVT_FEAT_DUMMY;
+
+	/* We trust the pm timer based calibration */
+	if (!pm_referenced) {
+		apic_printk(APIC_VERBOSE, "... verify APIC timer\n");
+
+		/*
+		 * Setup the apic timer manually
+		 */
+		levt->event_handler = lapic_cal_handler;
+		lapic_timer_setup(CLOCK_EVT_MODE_PERIODIC, levt);
+		lapic_cal_loops = -1;
+
+		/* Let the interrupts run */
+		local_irq_enable();
+
+		while (lapic_cal_loops <= LAPIC_CAL_LOOPS)
+			cpu_relax();
+
+		local_irq_disable();
+
+		/* Stop the lapic timer */
+		lapic_timer_setup(CLOCK_EVT_MODE_SHUTDOWN, levt);
+
+		local_irq_enable();
+
+		/* Jiffies delta */
+		deltaj = lapic_cal_j2 - lapic_cal_j1;
+		apic_printk(APIC_VERBOSE, "... jiffies delta = %lu\n", deltaj);
+
+		/* Check, if the jiffies result is consistent */
+		if (deltaj >= LAPIC_CAL_LOOPS-2 && deltaj <= LAPIC_CAL_LOOPS+2)
+			apic_printk(APIC_VERBOSE, "... jiffies result ok\n");
+		else
+			levt->features |= CLOCK_EVT_FEAT_DUMMY;
+	} else
+		local_irq_enable();
+
+	if (levt->features & CLOCK_EVT_FEAT_DUMMY) {
+		printk(KERN_WARNING
+		       "APIC timer disabled due to verification failure.\n");
+			return -1;
+	}
+
+	return 0;
+}
+
+#endif
+
 /*
  * Setup the boot APIC
  *
-- 
1.5.4.5

