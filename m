Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932948Ab0BCVHq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 16:07:46 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:40334 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932856Ab0BCVHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 16:07:14 -0500
X-Spam-ASN: 
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: linux-kernel@vger.kernel.org
Cc: linuxpps@ml.enneenne.com, "Nikita V\. Youshchenko" <yoush@cs.msu.su>,
       stas@lvk.cs.msu.su, Alexander Gordeev <lasaine@lvk.cs.msu.su>,
       Rodolfo Giometti <giometti@enneenne.com>,
       Rodolfo Giometti <giometti@linux.it>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Rik van Riel <riel@redhat.com>
Subject: [PATCH 1/5] ntp: add hardpps implementation
Date: Wed,  3 Feb 2010 23:56:47 +0300
Message-Id: <c90af235d8e68733f04b5365d1be2380ccb23569.1265228858.git.lasaine@lvk.cs.msu.su>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <cover.1265228858.git.lasaine@lvk.cs.msu.su>
References: <cover.1265228858.git.lasaine@lvk.cs.msu.su>
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit adds hardpps() implementation based upon the original one
from the NTPv4 reference kernel code. However, it is highly optimized
towards very fast syncronization and maximum stickness to PPS signal.
The typical error is less then a microsecond.
To make it sync faster I had to throw away exponential phase filter so
that the full phase offset is corrected immediately. Then I also had to
throw away median phase filter because it gives a bigger error itself
if used without exponential filter.
Maybe we will find an appropriate filtering scheme in the future but
it's not necessary if the signal quality is ok.

Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
---
 drivers/pps/Kconfig   |    1 +
 include/linux/timex.h |    1 +
 kernel/time/Kconfig   |    7 +
 kernel/time/ntp.c     |  346 ++++++++++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 349 insertions(+), 6 deletions(-)

diff --git a/drivers/pps/Kconfig b/drivers/pps/Kconfig
index cc2eb8e..2bd4f65 100644
--- a/drivers/pps/Kconfig
+++ b/drivers/pps/Kconfig
@@ -7,6 +7,7 @@ menu "PPS support"
 config PPS
 	tristate "PPS support"
 	depends on EXPERIMENTAL
+	select NTP_PPS
 	---help---
 	  PPS (Pulse Per Second) is a special pulse provided by some GPS
 	  antennae. Userland can use it to get a high-precision time
diff --git a/include/linux/timex.h b/include/linux/timex.h
index e6967d1..9efa3a8 100644
--- a/include/linux/timex.h
+++ b/include/linux/timex.h
@@ -274,6 +274,7 @@ extern u64 tick_length;
 extern void second_overflow(void);
 extern void update_ntp_one_tick(void);
 extern int do_adjtimex(struct timex *);
+extern void hardpps(const struct timespec *, s64);
 
 /* Don't use! Compatibility define for existing users. */
 #define tickadj	(500/HZ ? : 1)
diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
index 95ed429..2da4900 100644
--- a/kernel/time/Kconfig
+++ b/kernel/time/Kconfig
@@ -27,3 +27,10 @@ config GENERIC_CLOCKEVENTS_BUILD
 	default y
 	depends on GENERIC_CLOCKEVENTS || GENERIC_CLOCKEVENTS_MIGR
 
+config NTP_PPS
+	bool "PPS kernel consumer support"
+	depends on PPS
+	help
+	  This option adds support for direct in-kernel time
+	  syncronization using an external PPS signal.
+
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 4800f93..8cd20ad 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -14,6 +14,7 @@
 #include <linux/timex.h>
 #include <linux/time.h>
 #include <linux/mm.h>
+#include <linux/module.h>
 
 /*
  * NTP timekeeping variables:
@@ -74,6 +75,40 @@ long				time_adjust;
 /* constant (boot-param configurable) NTP tick adjustment (upscaled)	*/
 static s64			ntp_tick_adj;
 
+#ifdef CONFIG_NTP_PPS
+/*
+ * The following variables are used when a pulse-per-second (PPS) signal
+ * is available and connected via a modem control lead. They establish
+ * the engineering parameters of the clock discipline loop when
+ * controlled by the PPS signal.
+ */
+#define PPS_FAVG	2	/* min freq avg interval (s) (shift) */
+#define PPS_FAVGDEF	8	/* default freq avg interval (s) (shift) */
+#define PPS_FAVGMAX	15	/* max freq avg interval (s) (shift) */
+#define PPS_VALID	120	/* PPS signal watchdog max (s) */
+#define PPS_MAXWANDER	100000	/* max PPS wander (ns/s) */
+#define PPS_POPCORN	2	/* popcorn spike threshold (shift) */
+
+long pps_tf[3];			/* phase median filter */
+s64 pps_freq;			/* scaled frequency offset (ns/s) */
+s64 pps_fcount;			/* frequency accumulator */
+long pps_jitter;		/* nominal jitter (ns) */
+long pps_stabil;		/* nominal stability (scaled ns/s) */
+int pps_valid;			/* signal watchdog counter */
+int pps_shift;			/* nominal interval duration (s) (shift) */
+int pps_shiftmax;		/* max interval duration (s) (shift) */
+int pps_intcnt;			/* interval counter */
+
+/*
+ * PPS signal quality monitors
+ */
+long pps_calcnt;		/* calibration intervals */
+long pps_jitcnt;		/* jitter limit exceeded */
+long pps_stbcnt;		/* stability limit exceeded */
+long pps_errcnt;		/* calibration errors */
+
+#endif /* CONFIG_NTP_PPS */
+
 /*
  * NTP methods:
  */
@@ -177,6 +212,15 @@ void ntp_clear(void)
 
 	tick_length	= tick_length_base;
 	time_offset	= 0;
+#ifdef CONFIG_NTP_PPS
+	pps_shift = PPS_FAVG;
+	pps_shiftmax = PPS_FAVGDEF;
+	pps_tf[0] = 0;
+	pps_tf[1] = 0;
+	pps_tf[2] = 0;
+	pps_fcount = 0;
+	pps_freq = 0;
+#endif /* CONFIG_NTP_PPS */
 }
 
 /*
@@ -233,8 +277,6 @@ static enum hrtimer_restart ntp_leap_second(struct hrtimer *timer)
  */
 void second_overflow(void)
 {
-	s64 delta;
-
 	/* Bump the maxerror field */
 	time_maxerror += MAXFREQ / NSEC_PER_USEC;
 	if (time_maxerror > NTP_PHASE_LIMIT) {
@@ -248,9 +290,27 @@ void second_overflow(void)
 	 */
 	tick_length	 = tick_length_base;
 
-	delta		 = shift_right(time_offset, SHIFT_PLL + time_constant);
-	time_offset	-= delta;
-	tick_length	+= delta;
+#ifdef CONFIG_NTP_PPS
+	if (time_status & STA_PPSTIME && time_status & STA_PPSSIGNAL) {
+		tick_length	+= time_offset;
+		time_offset	 = 0;
+	} else
+#endif /* CONFIG_NTP_PPS */
+	{
+		s64 delta;
+		delta		 =
+			shift_right(time_offset, SHIFT_PLL + time_constant);
+		time_offset	-= delta;
+		tick_length	+= delta;
+	}
+
+#ifdef	CONFIG_NTP_PPS
+	if (pps_valid > 0)
+		pps_valid--;
+	else
+		time_status &= ~(STA_PPSSIGNAL | STA_PPSJITTER |
+				 STA_PPSWANDER | STA_PPSERROR);
+#endif /* CONFIG_NTP_PPS */
 
 	if (!time_adjust)
 		return;
@@ -361,6 +421,12 @@ static inline void process_adj_status(struct timex *txc, struct timespec *ts)
 	if ((time_status & STA_PLL) && !(txc->status & STA_PLL)) {
 		time_state = TIME_OK;
 		time_status = STA_UNSYNC;
+#ifdef CONFIG_NTP_PPS
+		/* the PPS calibration interval may end
+		   surprisingly early */
+		pps_shift = PPS_FAVG;
+		pps_intcnt = 0;
+#endif /* CONFIG_NTP_PPS */
 	}
 
 	/*
@@ -410,6 +476,9 @@ static inline void process_adjtimex_modes(struct timex *txc, struct timespec *ts
 		time_freq = txc->freq * PPM_SCALE;
 		time_freq = min(time_freq, MAXFREQ_SCALED);
 		time_freq = max(time_freq, -MAXFREQ_SCALED);
+#ifdef CONFIG_NTP_PPS
+		pps_freq = time_freq;
+#endif /* CONFIG_NTP_PPS */
 	}
 
 	if (txc->modes & ADJ_MAXERROR)
@@ -500,7 +569,23 @@ int do_adjtimex(struct timex *txc)
 	}
 
 	result = time_state;	/* mostly `TIME_OK' */
-	if (time_status & (STA_UNSYNC|STA_CLOCKERR))
+	if ((time_status & (STA_UNSYNC|STA_CLOCKERR))
+#ifdef CONFIG_NTP_PPS
+	    /* PPS signal lost when either PPS time or PPS frequency
+	     * synchronization requested
+	     */
+	    || ((time_status & (STA_PPSFREQ|STA_PPSTIME))
+		&& !(time_status & STA_PPSSIGNAL))
+	    /* PPS jitter exceeded when PPS time synchronization requested */
+	    || ((time_status & (STA_PPSTIME|STA_PPSJITTER))
+		== (STA_PPSTIME|STA_PPSJITTER))
+	    /* PPS wander exceeded or calibration error when PPS frequency
+	     * synchronization requested
+	     */
+	    || ((time_status & STA_PPSFREQ)
+		&& (time_status & (STA_PPSWANDER|STA_PPSERROR)))
+#endif /* CONFIG_NTP_PPS */
+			)
 		result = TIME_ERROR;
 
 	txc->freq	   = shift_right((time_freq >> PPM_SCALE_INV_SHIFT) *
@@ -514,6 +599,19 @@ int do_adjtimex(struct timex *txc)
 	txc->tick	   = tick_usec;
 	txc->tai	   = time_tai;
 
+#ifdef CONFIG_NTP_PPS
+	txc->ppsfreq	   = shift_right((pps_freq >> PPM_SCALE_INV_SHIFT) *
+					 PPM_SCALE_INV, NTP_SCALE_SHIFT);
+	txc->jitter	   = pps_jitter;
+	if (!(time_status & STA_NANO))
+		txc->jitter /= NSEC_PER_USEC;
+	txc->shift	   = pps_shift;
+	txc->stabil	   = pps_stabil;
+	txc->jitcnt	   = pps_jitcnt;
+	txc->calcnt	   = pps_calcnt;
+	txc->errcnt	   = pps_errcnt;
+	txc->stbcnt	   = pps_stbcnt;
+#else /* !CONFIG_NTP_PPS */
 	/* PPS is not implemented, so these are zero */
 	txc->ppsfreq	   = 0;
 	txc->jitter	   = 0;
@@ -523,6 +621,7 @@ int do_adjtimex(struct timex *txc)
 	txc->calcnt	   = 0;
 	txc->errcnt	   = 0;
 	txc->stbcnt	   = 0;
+#endif /* CONFIG_NTP_PPS */
 
 	write_sequnlock_irq(&xtime_lock);
 
@@ -536,6 +635,241 @@ int do_adjtimex(struct timex *txc)
 	return result;
 }
 
+#ifdef	CONFIG_NTP_PPS
+
+/* normalize the timestamp so that nsec is in the
+   ( -NSEC_PER_SEC / 2, NSEC_PER_SEC / 2 ] interval */
+static inline struct timespec pps_normalize_ts(struct timespec ts)
+{
+	if (ts.tv_nsec > (NSEC_PER_SEC >> 1)) {
+		ts.tv_nsec -= NSEC_PER_SEC;
+		ts.tv_sec++;
+	}
+
+	return ts;
+}
+
+/* use exponential average as an estimate for the phase correction */
+static inline long pps_phase_filter_get(long *jitter)
+{
+	*jitter = pps_tf[0] - pps_tf[1];
+	if (*jitter < 0)
+		*jitter = -*jitter;
+
+	return (3 * pps_tf[0] + pps_tf[1]) >> 2;
+}
+
+/* add the sample to the phase filter */
+static inline void pps_phase_filter_add(long err)
+{
+	pps_tf[2] = pps_tf[1];
+	pps_tf[1] = pps_tf[0];
+	pps_tf[0] = err;
+}
+
+/* decrease frequency calibration interval length */
+static inline void pps_dec_freq_interval(void)
+{
+	if (--pps_intcnt <= -4) {
+		pps_intcnt = -4;
+		if (pps_shift > PPS_FAVG) {
+			pps_shift--;
+			pps_intcnt = 0;
+		}
+	}
+}
+
+/* update frequency based on PPS signal
+ * returns the difference between old and new frequency values
+ */
+static long hardpps_update_freq(s64 nsec)
+{
+	struct timespec freq_norm;
+	long delta, delta_mod;
+	s64 ftemp;
+
+	pps_fcount += nsec;
+	freq_norm = pps_normalize_ts(ns_to_timespec(pps_fcount));
+
+	/* check if the current frequency interval is not finished */
+	if (freq_norm.tv_sec < (1 << pps_shift))
+		return 0;
+
+	/*
+	 * At the end of the calibration interval the difference between
+	 * the first and last counter values becomes the scaled
+	 * frequency. It will later be divided by the length of the
+	 * interval to determine the frequency update. If the frequency
+	 * exceeds a sanity threshold, or if the actual calibration
+	 * interval is not equal to the expected length, the data are
+	 * discarded. We can tolerate a modest loss of data here without
+	 * degrading frequency accuracy.
+	 */
+	pps_calcnt++;
+	pps_fcount = 0;
+	/* check if the frequency interval was too long */
+	if (freq_norm.tv_sec > (2 << pps_shift)) {
+		time_status |= STA_PPSERROR;
+		pps_errcnt++;
+		pps_dec_freq_interval();
+		pr_err("hardpps: PPSERROR: interval too long - %ld s\n",
+				freq_norm.tv_sec);
+		return 0;
+	}
+
+	/*
+	 * Here the raw frequency offset and wander (stability) is
+	 * calculated. If the wander is less than the wander threshold
+	 * for four consecutive averaging intervals, the interval is
+	 * doubled; if it is greater than the threshold for four
+	 * consecutive intervals, the interval is halved. The scaled
+	 * frequency offset is converted to frequency offset. The
+	 * stability metric is calculated as the average of recent
+	 * frequency changes, but is used only for performance
+	 * monitoring.
+	 */
+	ftemp = div_s64(((s64)(-freq_norm.tv_nsec)) << NTP_SCALE_SHIFT,
+			freq_norm.tv_sec);
+	delta = shift_right(ftemp - pps_freq, NTP_SCALE_SHIFT);
+	pps_freq = ftemp;
+	if (delta > PPS_MAXWANDER || delta < -PPS_MAXWANDER) {
+		pr_warning("hardpps: PPSWANDER: change=%ld\n", delta);
+		time_status |= STA_PPSWANDER;
+		pps_stbcnt++;
+		pps_dec_freq_interval();
+	} else {	/* good sample */
+		if (++pps_intcnt >= 4) {
+			pps_intcnt = 4;
+			if (pps_shift < pps_shiftmax) {
+				pps_shift++;
+				pps_intcnt = 0;
+			}
+		}
+	}
+
+	delta_mod = delta;
+	if (delta_mod < 0)
+		delta_mod = -delta_mod;
+	pps_stabil += (div_s64(((s64)delta_mod) <<
+				(NTP_SCALE_SHIFT - SHIFT_USEC),
+				NSEC_PER_USEC) - pps_stabil) >> PPS_FAVG;
+
+	/*
+	 * If enabled, the system clock frequency is updated.
+	 */
+	if ((time_status & STA_PPSFREQ) != 0 &&
+	    (time_status & STA_FREQHOLD) == 0) {
+		time_freq = pps_freq;
+		ntp_update_frequency();
+	}
+
+	return delta;
+}
+
+/* correct phase error against PPS signal */
+static void hardpps_update_phase(long error)
+{
+	long correction = -error;
+	long jitter;
+
+	/* add the sample to the median filter */
+	pps_phase_filter_add(correction);
+	/* TODO: test various filters then use the return value in the
+	 * next line */
+	pps_phase_filter_get(&jitter);
+
+	/*
+	 * Nominal jitter is due to PPS signal noise and interrupt
+	 * latency. If it exceeds the popcorn threshold, the sample is
+	 * discarded. otherwise, if so enabled, the time offset is
+	 * updated. We can tolerate a modest loss of data here without
+	 * much degrading time accuracy.
+	 */
+	if (jitter > (pps_jitter << PPS_POPCORN)) {
+		pr_warning("hardpps: PPSJITTER: jitter=%ld, limit=%ld\n",
+		       jitter, (pps_jitter << PPS_POPCORN));
+		time_status |= STA_PPSJITTER;
+		pps_jitcnt++;
+	} else if (time_status & STA_PPSTIME) {
+		/* correct the time using the phase offset */
+		time_offset = div_s64(((s64)correction) << NTP_SCALE_SHIFT,
+				NTP_INTERVAL_FREQ);
+		/* cancel running adjtime() */
+		time_adjust = 0;
+	}
+	/* update jitter */
+	pps_jitter += (jitter - pps_jitter) >> PPS_FAVG;
+}
+
+/*
+ * hardpps() - discipline CPU clock oscillator to external PPS signal
+ *
+ * This routine is called at each PPS interrupt in order to discipline
+ * the CPU clock oscillator to the PPS signal. There are two independent
+ * first-order feedback loops, one for the phase, the other for the
+ * frequency. The phase loop measures and grooms the PPS phase offset
+ * and leaves it in a handy spot for the seconds overflow routine. The
+ * frequency loop averages successive PPS phase differences and
+ * calculates the PPS frequency offset, which is also processed by the
+ * seconds overflow routine. The code requires the caller to capture the
+ * time and architecture-dependent hardware counter values in
+ * nanoseconds at the on-time PPS signal transition.
+ *
+ * Note that, on some Unix systems this routine runs at an interrupt
+ * priority level higher than the timer interrupt routine second_overflow().
+ * Therefore, the variables used are distinct from the second_overflow()
+ * variables, except for the actual time and frequency variables, which
+ * are determined by this routine and updated atomically.
+ */
+void hardpps(const struct timespec *p_ts, s64 nsec)
+{
+	struct timespec ts_norm, freq_norm;
+
+	ts_norm = pps_normalize_ts(*p_ts);
+	freq_norm = pps_normalize_ts(ns_to_timespec(nsec));
+
+	/*
+	 * The signal is first processed by a range gate and frequency
+	 * discriminator. The range gate rejects noise spikes outside
+	 * the range +-500 us. The frequency discriminator rejects input
+	 * signals with apparent frequency outside the range 1 +-500
+	 * PPM. If two hits occur in the same second, we ignore the
+	 * later hit; if not and a hit occurs outside the range gate,
+	 * keep the later hit for later comparison, but do not process
+	 * it.
+	 */
+
+	write_seqlock_irq(&xtime_lock);
+
+	/* clear the error bits, they will be set again if needed */
+	time_status &= ~(STA_PPSJITTER | STA_PPSWANDER | STA_PPSERROR);
+
+	/* indicate signal presence */
+	time_status |= STA_PPSSIGNAL;
+	pps_valid = PPS_VALID;
+
+	/* check the signal */
+	if ((nsec < NSEC_PER_SEC - MAXFREQ) ||
+			(freq_norm.tv_nsec > MAXFREQ * freq_norm.tv_sec) ||
+			(freq_norm.tv_nsec < -MAXFREQ * freq_norm.tv_sec)) {
+		time_status |= STA_PPSJITTER;
+		pps_fcount = 0;
+		write_sequnlock_irq(&xtime_lock);
+		pr_err("hardpps: PPSJITTER: bad pulse\n");
+		return;
+	}
+
+	/* signal is ok */
+
+	hardpps_update_freq(nsec);
+	hardpps_update_phase(ts_norm.tv_nsec);
+
+	write_sequnlock_irq(&xtime_lock);
+}
+EXPORT_SYMBOL(hardpps);
+
+#endif	/* CONFIG_NTP_PPS */
+
 static int __init ntp_tick_adj_setup(char *str)
 {
 	ntp_tick_adj = simple_strtol(str, NULL, 0);
-- 
1.6.5

