Return-Path: <linux-kernel-owner+w=401wt.eu-S1422807AbXBALOB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422807AbXBALOB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 06:14:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422805AbXBALNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 06:13:53 -0500
Received: from styx.suse.cz ([82.119.242.94]:53762 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751783AbXBALMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 06:12:35 -0500
Message-Id: <20070201103754.281474000@jet.suse.cz>
References: <20070201095952.589234000@jet.suse.cz>
User-Agent: quilt/0.44-16.5
Date: Thu, 01 Feb 2007 11:00:01 +0100
From: jbohac@suse.cz
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, Jiri Bohac <jbohac@suse.cz>,
       Vojtech Pavlik <vojtech@suse.cz>, ssouhlal@freebsd.org,
       arjan@infradead.org, tglx@linutronix.de, johnstul@us.ibm.com,
       zippel@linux-m68k.org, andrea@suse.de
Subject: [patch 9/9] Make use of the Master Timer
Content-Disposition: inline; filename=use_master_timer
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make use of the whole Master Timer infrastructure in gettimeofday, 
monotonic_clock, etc.

Also make the vsyscall version of gettimeofday use the guess_mt() if
possible.

Signed-off-by: Jiri Bohac <jbohac@suse.cz>

Index: linux-2.6.20-rc5/arch/x86_64/kernel/time.c
===================================================================
--- linux-2.6.20-rc5.orig/arch/x86_64/kernel/time.c
+++ linux-2.6.20-rc5/arch/x86_64/kernel/time.c
@@ -341,27 +341,48 @@ inline u64 mt_to_nsec(u64 mt)
 }
 
 /*
- * do_gettimeoffset() returns microseconds since last timer interrupt was
+ * do_gettimeoffset() returns nanoseconds since last timer interrupt was
  * triggered by hardware. A memory read of HPET is slower than a register read
  * of TSC, but much more reliable. It's also synchronized to the timer
  * interrupt. Note that do_gettimeoffset() may return more than hpet_tick, if a
  * timer interrupt has happened already, but vxtime.trigger wasn't updated yet.
  * This is not a problem, because jiffies hasn't updated either. They are bound
  * together by xtime_lock.
+ *
+ * If used_mt is not null, it will be filled with the master timer value
+ * used for the calculation
  */
 
-static inline unsigned int do_gettimeoffset_tsc(void)
+static inline s64 do_gettimeoffset(u64 *used_mt)
 {
-	unsigned long t;
-	unsigned long x;
-	t = get_cycles_sync();
-	if (t < vxtime.last_tsc) 
-		t = vxtime.last_tsc; /* hack */
-	x = ((t - vxtime.last_tsc) * vxtime.tsc_quot) >> US_SCALE;
-	return x;
-}
+	int cpu = 0;
+	u64 tsc = 0, mt;
+	switch (vxtime.mode) {
+
+		case VXTIME_TSC:
+			rdtscll(tsc);
+                        break;
+
+                case VXTIME_TSCP:
+                        rdtscpll(tsc, cpu);
+			cpu &= 0xfff;
+			break;
 
-unsigned int (*do_gettimeoffset)(void) = do_gettimeoffset_tsc;
+		case VXTIME_TSCS:
+		case VXTIME_TSCM:
+			preempt_disable();
+			cpu = smp_processor_id();
+			rdtscll(tsc);
+			preempt_enable();
+			break;
+	}
+
+	mt = guess_mt(tsc, cpu);
+	if (used_mt)
+		*used_mt = mt;
+
+	return (((s64)(mt - vxtime.mt_wall)) * (s64)vxtime.mt_q) >> 32;
+}
 
 /*
  * This version of gettimeofday() has microsecond resolution and better than
@@ -372,28 +393,32 @@ unsigned int (*do_gettimeoffset)(void) =
 void do_gettimeofday(struct timeval *tv)
 {
 	unsigned long seq;
- 	unsigned int sec, usec;
+	unsigned int sec;
+	int nsec;
+	u64 mt;
 
 	do {
 		seq = read_seqbegin(&xtime_lock);
 
 		sec = xtime.tv_sec;
-		usec = xtime.tv_nsec / NSEC_PER_USEC;
+		nsec = xtime.tv_nsec;
 
-		/* i386 does some correction here to keep the clock 
-		   monotonous even when ntpd is fixing drift.
-		   But they didn't work for me, there is a non monotonic
-		   clock anyways with ntp.
-		   I dropped all corrections now until a real solution can
-		   be found. Note when you fix it here you need to do the same
-		   in arch/x86_64/kernel/vsyscall.c and export all needed
-		   variables in vmlinux.lds. -AK */ 
-		usec += do_gettimeoffset();
+		nsec += max(do_gettimeoffset(&mt), vxtime.ns_drift);
 
 	} while (read_seqretry(&xtime_lock, seq));
 
-	tv->tv_sec = sec + usec / USEC_PER_SEC;
-	tv->tv_usec = usec % USEC_PER_SEC;
+	/* this must be done outside the seqlock loop. Until the loop has finished,
+	the mt may be completely wrong, calculated from incosistent data */
+	update_monotonic_mt(mt);
+
+	sec += nsec / NSEC_PER_SEC;
+	nsec %= NSEC_PER_SEC;
+	if (nsec < 0) {
+		--sec;
+		nsec += NSEC_PER_SEC;
+	}
+	tv->tv_sec = sec;
+	tv->tv_usec = nsec / NSEC_PER_USEC;
 }
 
 EXPORT_SYMBOL(do_gettimeofday);
@@ -408,13 +433,13 @@ int do_settimeofday(struct timespec *tv)
 {
 	time_t wtm_sec, sec = tv->tv_sec;
 	long wtm_nsec, nsec = tv->tv_nsec;
+	unsigned long flags;
 
 	if ((unsigned long)tv->tv_nsec >= NSEC_PER_SEC)
 		return -EINVAL;
+	write_seqlock_irqsave(&xtime_lock, flags);
 
-	write_seqlock_irq(&xtime_lock);
-
-	nsec -= do_gettimeoffset() * NSEC_PER_USEC;
+	nsec -= do_gettimeoffset(NULL);
 
 	wtm_sec  = wall_to_monotonic.tv_sec + (xtime.tv_sec - sec);
 	wtm_nsec = wall_to_monotonic.tv_nsec + (xtime.tv_nsec - nsec);
@@ -424,7 +449,7 @@ int do_settimeofday(struct timespec *tv)
 
 	ntp_clear();
 
-	write_sequnlock_irq(&xtime_lock);
+	write_sequnlock_irqrestore(&xtime_lock, flags);
 	clock_was_set();
 	return 0;
 }
@@ -519,27 +544,32 @@ static void set_rtc_mmss(unsigned long n
 	spin_unlock(&rtc_lock);
 }
 
-
 /* monotonic_clock(): returns # of nanoseconds passed since time_init()
  *		Note: This function is required to return accurate
  *		time even in the absence of multiple timer ticks.
  */
-static inline unsigned long long cycles_2_ns(unsigned long long cyc);
 unsigned long long monotonic_clock(void)
 {
-	unsigned long seq;
- 	u32 last_offset, this_offset, offset;
-	unsigned long long base;
+	int cpu;
+	unsigned long flags;
+	u64 t;
 
-		do {
-			seq = read_seqbegin(&xtime_lock);
+	/* any code that modifies the per-CPU variables used in guess_mt
+	   will always run on this CPU, so we don't need to lock the xtime_lock
+	   here. If we did, it would create a deadlock on debug printks (and
+	   possibly elsewhere) called from other critical sections protected by
+	   the lock */
 
-			last_offset = vxtime.last_tsc;
-			base = monotonic_base;
-		} while (read_seqretry(&xtime_lock, seq));
-		this_offset = get_cycles_sync();
-		offset = cycles_2_ns(this_offset - last_offset);
-	return base + offset;
+	local_irq_save(flags);
+
+	cpu = smp_processor_id();
+	rdtscll(t);
+	t = guess_mt(t, cpu);
+	update_monotonic_mt(t);
+
+	local_irq_restore(flags);
+
+	return mt_to_nsec(t);
 }
 EXPORT_SYMBOL(monotonic_clock);
 
@@ -573,62 +603,54 @@ static noinline void handle_lost_ticks(i
 void main_timer_handler(void)
 {
 	static unsigned long rtc_update = 0;
-	unsigned long tsc;
-	int delay = 0, offset = 0, lost = 0;
-
-/*
- * Here we are in the timer irq handler. We have irqs locally disabled (so we
- * don't need spin_lock_irqsave()) but we don't know if the timer_bh is running
- * on the other CPU, so we need a lock. We also need to lock the vsyscall
- * variables, because both do_timer() and us change them -arca+vojtech
- */
-
-	write_seqlock(&xtime_lock);
+	unsigned long flags;
+	u64 mt;
+	int ticks, i;
+	u64 xtime_nsecs, mt_ticks;
 
-	if (vxtime.hpet_address)
-		offset = hpet_readl(HPET_COUNTER);
+	write_seqlock_irqsave(&xtime_lock, flags);
 
-	if (hpet_use_timer) {
-		/* if we're using the hpet timer functionality,
-		 * we can more accurately know the counter value
-		 * when the timer interrupt occured.
-		 */
-		offset = hpet_readl(HPET_T0_CMP) - hpet_tick;
-		delay = hpet_readl(HPET_COUNTER) - offset;
+	mt = update_master_timer64();
+	ticks = (mt - vxtime.mt_wall + mt_per_tick / 2) / mt_per_tick;
+	mt_ticks = ticks * mt_per_tick;
+
+	if (ticks > 1) {
+		handle_lost_ticks(ticks - 1);
+		jiffies += ticks - 1;
 	}
 
-	tsc = get_cycles_sync();
-
-		offset = (((tsc - vxtime.last_tsc) *
-			   vxtime.tsc_quot) >> US_SCALE) - USEC_PER_TICK;
 
-		if (offset < 0)
-			offset = 0;
+/*
+ * Do the timer stuff.
+ * NTP will cause the actual increment of xtime to be slightly different from
+ * NSEC_PER_TICK, so we set xtime.ns_drift to the difference. This will be used
+ * by do_gettimeofday() to make sure the time stays monotonic.
+ */
 
-		if (offset > USEC_PER_TICK) {
-			lost = offset / USEC_PER_TICK;
-			offset %= USEC_PER_TICK;
+	xtime_nsecs = xtime.tv_sec * NSEC_PER_SEC + xtime.tv_nsec;
+	for (i = 0; i < ticks; ++i)
+		do_timer(1);
+	xtime_nsecs = xtime.tv_sec * NSEC_PER_SEC + xtime.tv_nsec - xtime_nsecs;
 
-		monotonic_base += cycles_2_ns(tsc - vxtime.last_tsc);
+	vxtime.ns_drift = (mt_ticks * mtq >> 32) - xtime_nsecs;
+	vxtime.mt_wall += mt_ticks;
 
-		vxtime.last_tsc = tsc - vxtime.quot * delay / vxtime.tsc_quot;
+/*
+ * If we have an externally synchronized Linux clock, then update CMOS clock
+ * accordingly every ~11 minutes. set_rtc_mmss() will be called in the jiffy
+ * closest to exactly 500 ms before the next second. If the update fails, we
+ * don't care, as it'll be updated on the next turn, and the problem (time way
+ * off) isn't likely to go away much sooner anyway.
+ */
 
-		if ((((tsc - vxtime.last_tsc) *
-		      vxtime.tsc_quot) >> US_SCALE) < offset)
-			vxtime.last_tsc = tsc -
-				(((long) offset << US_SCALE) / vxtime.tsc_quot) - 1;
+	if (ntp_synced() && xtime.tv_sec > rtc_update &&
+		abs(xtime.tv_nsec - 500000000) <= tick_nsec / 2) {
+		set_rtc_mmss(xtime.tv_sec);
+		rtc_update = xtime.tv_sec + 660;
 	}
 
-	if (lost > 0)
-		handle_lost_ticks(lost);
-	else
-		lost = 0;
-
-/*
- * Do the timer stuff.
- */
+	write_sequnlock_irqrestore(&xtime_lock, flags);
 
-	do_timer(lost + 1);
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(get_irq_regs()));
 #endif
@@ -642,21 +664,6 @@ void main_timer_handler(void)
 	if (!using_apic_timer)
 		smp_local_timer_interrupt();
 
-/*
- * If we have an externally synchronized Linux clock, then update CMOS clock
- * accordingly every ~11 minutes. set_rtc_mmss() will be called in the jiffy
- * closest to exactly 500 ms before the next second. If the update fails, we
- * don't care, as it'll be updated on the next turn, and the problem (time way
- * off) isn't likely to go away much sooner anyway.
- */
-
-	if (ntp_synced() && xtime.tv_sec > rtc_update &&
-		abs(xtime.tv_nsec - 500000000) <= tick_nsec / 2) {
-		set_rtc_mmss(xtime.tv_sec);
-		rtc_update = xtime.tv_sec + 660;
-	}
- 
-	write_sequnlock(&xtime_lock);
 }
 
 static irqreturn_t timer_interrupt(int irq, void *dev_id)
@@ -669,24 +676,9 @@ static irqreturn_t timer_interrupt(int i
 	return IRQ_HANDLED;
 }
 
-static unsigned int cyc2ns_scale __read_mostly;
-
-static inline void set_cyc2ns_scale(unsigned long cpu_khz)
-{
-	cyc2ns_scale = (NSEC_PER_MSEC << NS_SCALE) / cpu_khz;
-}
-
-static inline unsigned long long cycles_2_ns(unsigned long long cyc)
-{
-	return (cyc * cyc2ns_scale) >> NS_SCALE;
-}
-
 unsigned long long sched_clock(void)
 {
-	unsigned long a = 0;
-
-	rdtscll(a);
-	return cycles_2_ns(a);
+	return monotonic_clock();
 }
 
 static unsigned long get_cmos_time(void)
Index: linux-2.6.20-rc5/arch/x86_64/kernel/vsyscall.c
===================================================================
--- linux-2.6.20-rc5.orig/arch/x86_64/kernel/vsyscall.c
+++ linux-2.6.20-rc5/arch/x86_64/kernel/vsyscall.c
@@ -61,24 +61,35 @@ static __always_inline void timeval_norm
 	}
 }
 
-static __always_inline void do_vgettimeofday(struct timeval * tv)
+static __always_inline u64 __guess_mt(u64 tsc, int cpu)
 {
-	long sequence, t;
-	unsigned long sec, usec;
+	return (((tsc - __vxtime.cpu[cpu].tsc_last) * __vxtime.cpu[cpu].tsc_slope)
+			>> TSC_SLOPE_SCALE) + __vxtime.cpu[cpu].mt_base;
+}
+
+#define USEC_PER_TICK (USEC_PER_SEC / HZ)
+static __always_inline s64 __do_gettimeoffset(u64 tsc, int cpu)
+{
+	return (((s64)(__guess_mt(tsc, cpu) - __vxtime.mt_wall)) * (s64)__vxtime.mt_q) >> 32;
+}
+
+static __always_inline void do_vgettimeofday(struct timeval * tv, u64 tsc, int cpu)
+{
+	unsigned int sec;
+	s64 nsec;
 
-	do {
-		sequence = read_seqbegin(&__xtime_lock);
-		
-		sec = __xtime.tv_sec;
-		usec = __xtime.tv_nsec / 1000;
-
-			usec += ((readl((void __iomem *)
-				   fix_to_virt(VSYSCALL_HPET) + 0xf0) -
-				  __vxtime.last) * __vxtime.quot) >> 32;
-	} while (read_seqretry(&__xtime_lock, sequence));
+	sec = __xtime.tv_sec;
+	nsec = __xtime.tv_nsec;
+	nsec +=	max(__do_gettimeoffset(tsc, cpu), __vxtime.drift);
 
-	tv->tv_sec = sec + usec / 1000000;
-	tv->tv_usec = usec % 1000000;
+	sec += nsec / NSEC_PER_SEC;
+	nsec %= NSEC_PER_SEC;
+	if (nsec < 0) {
+		--sec;
+		nsec += NSEC_PER_SEC;
+	}
+	tv->tv_sec = sec;
+	tv->tv_usec = nsec / NSEC_PER_USEC;
 }
 
 /* RED-PEN may want to readd seq locking, but then the variable should be write-once. */
@@ -107,10 +118,39 @@ static __always_inline long time_syscall
 
 int __vsyscall(0) vgettimeofday(struct timeval * tv, struct timezone * tz)
 {
-	if (!__sysctl_vsyscall)
+	int cpu = 0;
+	u64 tsc;
+	unsigned long seq;
+	int do_syscall = !__sysctl_vsyscall;
+
+	if (tv && !do_syscall)
+		switch (__vxtime.mode) {
+			case VXTIME_TSC:
+			case VXTIME_TSCP:
+				do {
+					seq = read_seqbegin(&__xtime_lock);
+
+					if (__vxtime.mode == VXTIME_TSC)
+						rdtscll(tsc);
+					else {
+						rdtscpll(tsc, cpu);
+						cpu &= 0xfff;
+					}
+
+					if (unlikely(__vxtime.cpu[cpu].tsc_invalid))
+						do_syscall = 1;
+					else
+						do_vgettimeofday(tv, tsc, cpu);
+
+				} while (read_seqretry(&__xtime_lock, seq));
+				break;
+			default:
+				do_syscall = 1;
+		}
+
+	if (do_syscall)
 		return gettimeofday(tv,tz);
-	if (tv)
-		do_vgettimeofday(tv);
+
 	if (tz)
 		do_get_tz(tz);
 	return 0;

--
