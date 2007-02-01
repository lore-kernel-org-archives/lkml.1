Return-Path: <linux-kernel-owner+w=401wt.eu-S1422782AbXBALNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422782AbXBALNu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 06:13:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422797AbXBALMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 06:12:38 -0500
Received: from styx.suse.cz ([82.119.242.94]:53742 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751730AbXBALMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 06:12:34 -0500
Message-Id: <20070201103753.944245000@jet.suse.cz>
References: <20070201095952.589234000@jet.suse.cz>
User-Agent: quilt/0.44-16.5
Date: Thu, 01 Feb 2007 10:59:58 +0100
From: jbohac@suse.cz
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, Jiri Bohac <jbohac@suse.cz>,
       Vojtech Pavlik <vojtech@suse.cz>, ssouhlal@freebsd.org,
       arjan@infradead.org, tglx@linutronix.de, johnstul@us.ibm.com,
       zippel@linux-m68k.org, andrea@suse.de
Subject: [patch 6/9] Add the "Master Timer"
Content-Disposition: inline; filename=add_master_timer
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Master Timer (MT) is a reliable, monotonic, constantly growing 64 bit timer. At
present, PM timer or HPET can be used as the Master Timer.

None of them is 64 bit (HPET migt be, but not always), so we access them
through the get_master_timer64() and update_master_timer64() functions
that take care of the wraparounds. update_master_timer64() needs to be
called once in a while, at least once every period of the corresponding
hardware timer (a couple minutes for HPET, cca 3-4 seconds for PM). This
will be done from the main timer handler.

While the hardware MT is reliable and monotonic, it is slow to read. We
want to approximate it using the TSC. guess_mt() does just that, using a
lot of per-cpu calibration data.

Signed-off-by: Jiri Bohac <jbohac@suse.cz>

Index: linux-2.6.20-rc5/arch/x86_64/kernel/time.c
===================================================================
--- linux-2.6.20-rc5.orig/arch/x86_64/kernel/time.c
+++ linux-2.6.20-rc5/arch/x86_64/kernel/time.c
@@ -54,9 +54,14 @@ static char *timename = NULL;
 DEFINE_SPINLOCK(rtc_lock);
 EXPORT_SYMBOL(rtc_lock);
 DEFINE_SPINLOCK(i8253_lock);
+DEFINE_SEQLOCK(mt_lock);
+
+DEFINE_SPINLOCK(monotonic_mt_lock);
+static u64 last_monotonic_mt;
 
 int nohpet __initdata = 0;
 static int notsc __initdata = 0;
+static int nomonotonic __initdata = 0;
 
 #define USEC_PER_TICK (USEC_PER_SEC / HZ)
 #define NSEC_PER_TICK (NSEC_PER_SEC / HZ)
@@ -65,14 +70,18 @@ static int notsc __initdata = 0;
 #define NS_SCALE	10 /* 2^10, carefully chosen */
 #define US_SCALE	32 /* 2^32, arbitralrily chosen */
 
-unsigned int cpu_khz;					/* TSC clocks / usec, not used here */
+unsigned int cpu_khz;		/* TSC clocks / usec, not used here */
+static s64 mt_per_tick;		/* master timer ticks per jiffie */
+static u64 __mt;		/* master timer */
+static u32 __mt_last;		/* value last read from read_master_timer() when updating timer caches */
+
+u32 (*read_master_timer)(void);
+
 EXPORT_SYMBOL(cpu_khz);
 static unsigned long hpet_period;			/* fsecs / HPET clock */
 unsigned long hpet_tick;				/* HPET clocks / interrupt */
 int hpet_use_timer;				/* Use counter of hpet for time keeping, otherwise PIT */
-unsigned long vxtime_hz = PIT_TICK_RATE;
 int report_lost_ticks;				/* command line option */
-unsigned long long monotonic_base;
 
 struct vxtime_data __vxtime __section_vxtime;	/* for vsyscalls */
 
@@ -80,6 +89,137 @@ volatile unsigned long __jiffies __secti
 struct timespec __xtime __section_xtime;
 struct timezone __sys_tz __section_sys_tz;
 
+#define TSC_SLOPE_DECAY	16
+
+
+/*
+ * set the 64-bit master timer to a given value
+ */
+static inline void set_master_timer64(u64 t)
+{
+	unsigned long flags;
+
+	write_seqlock_irqsave(&mt_lock, flags);
+
+	__mt_last = read_master_timer();
+	__mt = t;
+
+	write_sequnlock_irqrestore(&mt_lock, flags);
+}
+
+/*
+ * add/subtract a number of ticks from the 64-bit master timer
+ */
+static inline void add_master_timer64(s64 t)
+{
+	unsigned long flags;
+	write_seqlock_irqsave(&mt_lock, flags);
+	__mt += t;
+	write_sequnlock_irqrestore(&mt_lock, flags);
+}
+
+/*
+ * get the 64-bit non-overflowing master timer based on current
+ * master timer reading
+ */
+static u64 get_master_timer64(void)
+{
+	u64 ret;
+	u32 delta, now;
+	unsigned long seq;
+	do {
+		seq = read_seqbegin(&mt_lock);
+
+		now = read_master_timer();
+		delta = now - __mt_last;
+		ret = __mt + delta;
+
+
+	} while (read_seqretry(&mt_lock, seq));
+
+	return ret;
+}
+
+/*
+ * get and update the 64-bit non-overflowing master timer based on current
+ * master timer reading
+ *
+ * This needs to be called often enough to prevent the MT from overflowing.
+ * Doing this from the main timer handler is enough. Other places can call
+ * get_master_timer64() instead, avoiding unnecessary contention.
+ */
+static u64 update_master_timer64(void)
+{
+	u32 delta, now;
+	unsigned long flags;
+	write_seqlock_irqsave(&mt_lock, flags);
+
+	now = read_master_timer();
+	delta = now - __mt_last;
+	__mt_last = now;
+	__mt += delta;
+
+	write_sequnlock_irqrestore(&mt_lock, flags);
+
+	return __mt;
+}
+
+/*
+ * estimates the current value of the master timer, based on the TSC
+ */
+static inline u64 __guess_mt(u64 tsc, int cpu)
+{
+	return (((tsc - vxtime.cpu[cpu].tsc_last) * vxtime.cpu[cpu].tsc_slope)
+			>> TSC_SLOPE_SCALE) + vxtime.cpu[cpu].mt_base;
+}
+
+/*
+ * estimates the current value of the master timer, based on the TSC
+ * and corrects the estimate to make it monotonic even across CPUs if needed.
+ */
+
+static inline u64 guess_mt(u64 tsc, int cpu)
+{
+	u64 mt;
+
+	if (unlikely(vxtime.mode == VXTIME_MT || vxtime.cpu[cpu].tsc_invalid))
+		mt = max(get_master_timer64(), vxtime.cpu[cpu].last_mt_guess);
+	else
+		mt = __guess_mt(tsc, cpu);
+
+	if (mt < last_monotonic_mt)
+		mt = last_monotonic_mt;
+
+	return mt;
+}
+
+static inline void update_monotonic_mt(u64 mt)
+{
+	unsigned long flags;
+
+	if (vxtime.mode != VXTIME_TSCM)
+		return;
+
+	spin_lock_irqsave(&monotonic_mt_lock, flags);
+
+	if (mt > last_monotonic_mt)
+		last_monotonic_mt = mt;
+
+	spin_unlock_irqrestore(&monotonic_mt_lock, flags);
+}
+
+static u32 read_master_timer_hpet(void)
+{
+	return hpet_readl(HPET_COUNTER);
+}
+
+static u32 read_master_timer_pm(void)
+{
+	/* the shift ensures u32 wraparound at the time	of
+	   the 24-bit counter wraparound */
+	return inl(pmtmr_ioport) << 8;
+}
+
 /*
  * do_gettimeoffset() returns microseconds since last timer interrupt was
  * triggered by hardware. A memory read of HPET is slower than a register read

--
