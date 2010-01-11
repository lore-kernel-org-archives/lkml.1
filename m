Return-Path: <linux-kernel-owner+w=401wt.eu-S1751641Ab0AKV1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751641Ab0AKV1T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 16:27:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751477Ab0AKV1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 16:27:16 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:50852 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab0AKV1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 16:27:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=pnAxAOfB4J3NVtxlzl6SIbsoiPgU8EnM+OvDs8fz3X+bD/3ReZFIPtZtVdBYZ78A/V
         KI+E9Cw0Q7FNaRRb+v2vfMqLRe2JZsv1nZBdS0wRk3dpqIT83Rg2zfVD4uCXoS3kU+pT
         jh6IPHudoTkgk8DL/VVpBDFjaOnzF42Jmn+mI=
From: John Kacur <jkacur@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Cc: Clark Williams <williams@redhat.com>, John Kacur <jkacur@redhat.com>
Subject: [PATCH 01/26] xtime_lock: Convert atomic_seqlock to raw_seqlock, fix up all users
Date: Mon, 11 Jan 2010 22:26:31 +0100
Message-Id: <1263245216-14754-2-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1263245216-14754-1-git-send-email-jkacur@redhat.com>
References: <1263245216-14754-1-git-send-email-jkacur@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rewritten from 5a950072e4c1036abcdb35610d053e49bdde55c9

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 arch/alpha/kernel/time.c     |    4 +-
 arch/arm/kernel/time.c       |   12 +++++-----
 arch/blackfin/kernel/time.c  |    4 +-
 arch/cris/kernel/time.c      |    4 +-
 arch/frv/kernel/time.c       |    4 +-
 arch/h8300/kernel/time.c     |    4 +-
 arch/ia64/kernel/time.c      |    4 +-
 arch/ia64/xen/time.c         |    4 +-
 arch/m32r/kernel/time.c      |    4 +-
 arch/m68knommu/kernel/time.c |    4 +-
 arch/mn10300/kernel/time.c   |    4 +-
 arch/parisc/kernel/time.c    |    8 +++---
 arch/powerpc/kernel/time.c   |    4 +-
 arch/sparc/kernel/pcic.c     |    8 +++---
 arch/sparc/kernel/time_32.c  |   12 +++++-----
 arch/xtensa/kernel/time.c    |    4 +-
 include/linux/time.h         |    2 +-
 kernel/hrtimer.c             |    8 +++---
 kernel/time.c                |    8 +++---
 kernel/time/ntp.c            |    8 +++---
 kernel/time/tick-common.c    |    8 +++---
 kernel/time/tick-sched.c     |   12 +++++-----
 kernel/time/timekeeping.c    |   50 +++++++++++++++++++++---------------------
 23 files changed, 92 insertions(+), 92 deletions(-)

diff --git a/arch/alpha/kernel/time.c b/arch/alpha/kernel/time.c
index 5d08266..760dd1b 100644
--- a/arch/alpha/kernel/time.c
+++ b/arch/alpha/kernel/time.c
@@ -106,7 +106,7 @@ irqreturn_t timer_interrupt(int irq, void *dev)
 	profile_tick(CPU_PROFILING);
 #endif
 
-	write_seqlock(&xtime_lock);
+	write_raw_seqlock(&xtime_lock);
 
 	/*
 	 * Calculate how many ticks have passed since the last update,
@@ -136,7 +136,7 @@ irqreturn_t timer_interrupt(int irq, void *dev)
 		state.last_rtc_update = xtime.tv_sec - (tmp ? 600 : 0);
 	}
 
-	write_sequnlock(&xtime_lock);
+	write_raw_sequnlock(&xtime_lock);
 
 #ifndef CONFIG_SMP
 	while (nticks--)
diff --git a/arch/arm/kernel/time.c b/arch/arm/kernel/time.c
index d38cdf2..3654ecf 100644
--- a/arch/arm/kernel/time.c
+++ b/arch/arm/kernel/time.c
@@ -245,11 +245,11 @@ void do_gettimeofday(struct timeval *tv)
 	unsigned long usec, sec;
 
 	do {
-		seq = read_seqbegin_irqsave(&xtime_lock, flags);
+		seq = read_raw_seqbegin_irqsave(&xtime_lock, flags);
 		usec = system_timer->offset();
 		sec = xtime.tv_sec;
 		usec += xtime.tv_nsec / 1000;
-	} while (read_seqretry_irqrestore(&xtime_lock, seq, flags));
+	} while (read_raw_seqretry_irqrestore(&xtime_lock, seq, flags));
 
 	/* usec may have gone up a lot: be safe */
 	while (usec >= 1000000) {
@@ -271,7 +271,7 @@ int do_settimeofday(struct timespec *tv)
 	if ((unsigned long)tv->tv_nsec >= NSEC_PER_SEC)
 		return -EINVAL;
 
-	write_seqlock_irq(&xtime_lock);
+	write_raw_seqlock_irq(&xtime_lock);
 	/*
 	 * This is revolting. We need to set "xtime" correctly. However, the
 	 * value in this location is the value at the most recent update of
@@ -287,7 +287,7 @@ int do_settimeofday(struct timespec *tv)
 	set_normalized_timespec(&wall_to_monotonic, wtm_sec, wtm_nsec);
 
 	ntp_clear();
-	write_sequnlock_irq(&xtime_lock);
+	write_raw_sequnlock_irq(&xtime_lock);
 	clock_was_set();
 	return 0;
 }
@@ -337,9 +337,9 @@ void timer_tick(void)
 	profile_tick(CPU_PROFILING);
 	do_leds();
 	do_set_rtc();
-	write_seqlock(&xtime_lock);
+	write_raw_seqlock(&xtime_lock);
 	do_timer(1);
-	write_sequnlock(&xtime_lock);
+	write_raw_sequnlock(&xtime_lock);
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(get_irq_regs()));
 #endif
diff --git a/arch/blackfin/kernel/time.c b/arch/blackfin/kernel/time.c
index 13c1ee3..8ded01f 100644
--- a/arch/blackfin/kernel/time.c
+++ b/arch/blackfin/kernel/time.c
@@ -129,7 +129,7 @@ irqreturn_t timer_interrupt(int irq, void *dummy)
 	/* last time the cmos clock got updated */
 	static long last_rtc_update;
 
-	write_seqlock(&xtime_lock);
+	write_raw_seqlock(&xtime_lock);
 	do_timer(1);
 
 	/*
@@ -149,7 +149,7 @@ irqreturn_t timer_interrupt(int irq, void *dummy)
 			/* Do it again in 60s. */
 			last_rtc_update = xtime.tv_sec - 600;
 	}
-	write_sequnlock(&xtime_lock);
+	write_raw_sequnlock(&xtime_lock);
 
 #ifdef CONFIG_IPIPE
 	update_root_process_times(get_irq_regs());
diff --git a/arch/cris/kernel/time.c b/arch/cris/kernel/time.c
index 074fe7d..58d2a1a 100644
--- a/arch/cris/kernel/time.c
+++ b/arch/cris/kernel/time.c
@@ -87,7 +87,7 @@ int do_settimeofday(struct timespec *tv)
 	if ((unsigned long)tv->tv_nsec >= NSEC_PER_SEC)
 		return -EINVAL;
 
-	write_seqlock_irq(&xtime_lock);
+	write_raw_seqlock_irq(&xtime_lock);
 	/*
 	 * This is revolting. We need to set "xtime" correctly. However, the
 	 * value in this location is the value at the most recent update of
@@ -103,7 +103,7 @@ int do_settimeofday(struct timespec *tv)
 	set_normalized_timespec(&wall_to_monotonic, wtm_sec, wtm_nsec);
 
 	ntp_clear();
-	write_sequnlock_irq(&xtime_lock);
+	write_raw_sequnlock_irq(&xtime_lock);
 	clock_was_set();
 	return 0;
 }
diff --git a/arch/frv/kernel/time.c b/arch/frv/kernel/time.c
index fb0ce75..82943ba 100644
--- a/arch/frv/kernel/time.c
+++ b/arch/frv/kernel/time.c
@@ -70,7 +70,7 @@ static irqreturn_t timer_interrupt(int irq, void *dummy)
 	 * the irq version of write_lock because as just said we have irq
 	 * locally disabled. -arca
 	 */
-	write_seqlock(&xtime_lock);
+	write_raw_seqlock(&xtime_lock);
 
 	do_timer(1);
 
@@ -96,7 +96,7 @@ static irqreturn_t timer_interrupt(int irq, void *dummy)
 	__set_LEDS(n);
 #endif /* CONFIG_HEARTBEAT */
 
-	write_sequnlock(&xtime_lock);
+	write_raw_sequnlock(&xtime_lock);
 
 	update_process_times(user_mode(get_irq_regs()));
 
diff --git a/arch/h8300/kernel/time.c b/arch/h8300/kernel/time.c
index 7f2d6cf..d08012c 100644
--- a/arch/h8300/kernel/time.c
+++ b/arch/h8300/kernel/time.c
@@ -35,9 +35,9 @@ void h8300_timer_tick(void)
 {
 	if (current->pid)
 		profile_tick(CPU_PROFILING);
-	write_seqlock(&xtime_lock);
+	write_raw_seqlock(&xtime_lock);
 	do_timer(1);
-	write_sequnlock(&xtime_lock);
+	write_raw_sequnlock(&xtime_lock);
 	update_process_times(user_mode(get_irq_regs()));
 }
 
diff --git a/arch/ia64/kernel/time.c b/arch/ia64/kernel/time.c
index a35c661..bf9daaa 100644
--- a/arch/ia64/kernel/time.c
+++ b/arch/ia64/kernel/time.c
@@ -197,10 +197,10 @@ timer_interrupt (int irq, void *dev_id)
 			 * another CPU. We need to avoid to SMP race by acquiring the
 			 * xtime_lock.
 			 */
-			write_seqlock(&xtime_lock);
+			write_raw_seqlock(&xtime_lock);
 			do_timer(1);
 			local_cpu_data->itm_next = new_itm;
-			write_sequnlock(&xtime_lock);
+			write_raw_sequnlock(&xtime_lock);
 		} else
 			local_cpu_data->itm_next = new_itm;
 
diff --git a/arch/ia64/xen/time.c b/arch/ia64/xen/time.c
index c1c5445..f681845 100644
--- a/arch/ia64/xen/time.c
+++ b/arch/ia64/xen/time.c
@@ -140,10 +140,10 @@ consider_steal_time(unsigned long new_itm)
 		delta_itm += local_cpu_data->itm_delta * (stolen + blocked);
 
 		if (cpu == time_keeper_id) {
-			write_seqlock(&xtime_lock);
+			write_raw_seqlock(&xtime_lock);
 			do_timer(stolen + blocked);
 			local_cpu_data->itm_next = delta_itm + new_itm;
-			write_sequnlock(&xtime_lock);
+			write_raw_sequnlock(&xtime_lock);
 		} else {
 			local_cpu_data->itm_next = delta_itm + new_itm;
 		}
diff --git a/arch/m32r/kernel/time.c b/arch/m32r/kernel/time.c
index 9cedcef..47632ca 100644
--- a/arch/m32r/kernel/time.c
+++ b/arch/m32r/kernel/time.c
@@ -143,7 +143,7 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
 	 * CMOS clock accordingly every ~11 minutes. Set_rtc_mmss() has to be
 	 * called as close as possible to 500 ms before the new second starts.
 	 */
-	write_seqlock(&xtime_lock);
+	write_raw_seqlock(&xtime_lock);
 	if (ntp_synced()
 		&& xtime.tv_sec > last_rtc_update + 660
 		&& (xtime.tv_nsec / 1000) >= 500000 - ((unsigned)TICK_SIZE) / 2
@@ -154,7 +154,7 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
 		else	/* do it again in 60 s */
 			last_rtc_update = xtime.tv_sec - 600;
 	}
-	write_sequnlock(&xtime_lock);
+	write_raw_sequnlock(&xtime_lock);
 	/* As we return to user mode fire off the other CPU schedulers..
 	   this is basically because we don't yet share IRQ's around.
 	   This message is rigged to be safe on the 386 - basically it's
diff --git a/arch/m68knommu/kernel/time.c b/arch/m68knommu/kernel/time.c
index a90acf5..f8eb60f 100644
--- a/arch/m68knommu/kernel/time.c
+++ b/arch/m68knommu/kernel/time.c
@@ -44,11 +44,11 @@ irqreturn_t arch_timer_interrupt(int irq, void *dummy)
 	if (current->pid)
 		profile_tick(CPU_PROFILING);
 
-	write_seqlock(&xtime_lock);
+	write_raw_seqlock(&xtime_lock);
 
 	do_timer(1);
 
-	write_sequnlock(&xtime_lock);
+	write_raw_sequnlock(&xtime_lock);
 
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(get_irq_regs()));
diff --git a/arch/mn10300/kernel/time.c b/arch/mn10300/kernel/time.c
index 395caf0..82e6bb8 100644
--- a/arch/mn10300/kernel/time.c
+++ b/arch/mn10300/kernel/time.c
@@ -99,7 +99,7 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
 {
 	unsigned tsc, elapse;
 
-	write_seqlock(&xtime_lock);
+	write_raw_seqlock(&xtime_lock);
 
 	while (tsc = get_cycles(),
 	       elapse = mn10300_last_tsc - tsc, /* time elapsed since last
@@ -114,7 +114,7 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
 		check_rtc_time();
 	}
 
-	write_sequnlock(&xtime_lock);
+	write_raw_sequnlock(&xtime_lock);
 
 	update_process_times(user_mode(get_irq_regs()));
 
diff --git a/arch/parisc/kernel/time.c b/arch/parisc/kernel/time.c
index a79c6f9..52c8cf7 100644
--- a/arch/parisc/kernel/time.c
+++ b/arch/parisc/kernel/time.c
@@ -163,9 +163,9 @@ irqreturn_t __irq_entry timer_interrupt(int irq, void *dev_id)
 	}
 
 	if (cpu == 0) {
-		write_seqlock(&xtime_lock);
+		write_raw_seqlock(&xtime_lock);
 		do_timer(ticks_elapsed);
-		write_sequnlock(&xtime_lock);
+		write_raw_sequnlock(&xtime_lock);
 	}
 
 	return IRQ_HANDLED;
@@ -268,12 +268,12 @@ void __init time_init(void)
 	if (pdc_tod_read(&tod_data) == 0) {
 		unsigned long flags;
 
-		write_seqlock_irqsave(&xtime_lock, flags);
+		write_raw_seqlock_irqsave(&xtime_lock, flags);
 		xtime.tv_sec = tod_data.tod_sec;
 		xtime.tv_nsec = tod_data.tod_usec * 1000;
 		set_normalized_timespec(&wall_to_monotonic,
 		                        -xtime.tv_sec, -xtime.tv_nsec);
-		write_sequnlock_irqrestore(&xtime_lock, flags);
+		write_raw_sequnlock_irqrestore(&xtime_lock, flags);
 	} else {
 		printk(KERN_ERR "Error reading tod clock\n");
 	        xtime.tv_sec = 0;
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 9ba2cc8..b24bfa3 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -1040,7 +1040,7 @@ void __init time_init(void)
 	/* Save the current timebase to pretty up CONFIG_PRINTK_TIME */
 	boot_tb = get_tb_or_rtc();
 
-	write_seqlock_irqsave(&xtime_lock, flags);
+	write_raw_seqlock_irqsave(&xtime_lock, flags);
 
 	/* If platform provided a timezone (pmac), we correct the time */
         if (timezone_offset) {
@@ -1054,7 +1054,7 @@ void __init time_init(void)
 	vdso_data->stamp_xsec = (u64) xtime.tv_sec * XSEC_PER_SEC;
 	vdso_data->tb_to_xs = tb_to_xs;
 
-	write_sequnlock_irqrestore(&xtime_lock, flags);
+	write_raw_sequnlock_irqrestore(&xtime_lock, flags);
 
 	/* Start the decrementer on CPUs that have manual control
 	 * such as BookE
diff --git a/arch/sparc/kernel/pcic.c b/arch/sparc/kernel/pcic.c
index 85e7037..ad60d3b 100644
--- a/arch/sparc/kernel/pcic.c
+++ b/arch/sparc/kernel/pcic.c
@@ -703,10 +703,10 @@ static void pcic_clear_clock_irq(void)
 
 static irqreturn_t pcic_timer_handler (int irq, void *h)
 {
-	write_seqlock(&xtime_lock);	/* Dummy, to show that we remember */
+	write_raw_seqlock(&xtime_lock);	/* Dummy, to show that we remember */
 	pcic_clear_clock_irq();
 	do_timer(1);
-	write_sequnlock(&xtime_lock);
+	write_raw_sequnlock(&xtime_lock);
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(get_irq_regs()));
 #endif
@@ -766,7 +766,7 @@ static void pci_do_gettimeofday(struct timeval *tv)
 	unsigned long max_ntp_tick = tick_usec - tickadj;
 
 	do {
-		seq = read_seqbegin_irqsave(&xtime_lock, flags);
+		seq = read_raw_seqbegin_irqsave(&xtime_lock, flags);
 		usec = do_gettimeoffset();
 
 		/*
@@ -779,7 +779,7 @@ static void pci_do_gettimeofday(struct timeval *tv)
 
 		sec = xtime.tv_sec;
 		usec += (xtime.tv_nsec / 1000);
-	} while (read_seqretry_irqrestore(&xtime_lock, seq, flags));
+	} while (read_raw_seqretry_irqrestore(&xtime_lock, seq, flags));
 
 	while (usec >= 1000000) {
 		usec -= 1000000;
diff --git a/arch/sparc/kernel/time_32.c b/arch/sparc/kernel/time_32.c
index 5b2f595..c581970 100644
--- a/arch/sparc/kernel/time_32.c
+++ b/arch/sparc/kernel/time_32.c
@@ -93,7 +93,7 @@ static irqreturn_t timer_interrupt(int dummy, void *dev_id)
 #endif
 
 	/* Protect counter clear so that do_gettimeoffset works */
-	write_seqlock(&xtime_lock);
+	write_raw_seqlock(&xtime_lock);
 
 	clear_clock_irq();
 
@@ -109,7 +109,7 @@ static irqreturn_t timer_interrupt(int dummy, void *dev_id)
 	  else
 	    last_rtc_update = xtime.tv_sec - 600; /* do it again in 60 s */
 	}
-	write_sequnlock(&xtime_lock);
+	write_raw_sequnlock(&xtime_lock);
 
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(get_irq_regs()));
@@ -248,7 +248,7 @@ void do_gettimeofday(struct timeval *tv)
 	unsigned long max_ntp_tick = tick_usec - tickadj;
 
 	do {
-		seq = read_seqbegin_irqsave(&xtime_lock, flags);
+		seq = read_raw_seqbegin_irqsave(&xtime_lock, flags);
 		usec = do_gettimeoffset();
 
 		/*
@@ -261,7 +261,7 @@ void do_gettimeofday(struct timeval *tv)
 
 		sec = xtime.tv_sec;
 		usec += (xtime.tv_nsec / 1000);
-	} while (read_seqretry_irqrestore(&xtime_lock, seq, flags));
+	} while (read_raw_seqretry_irqrestore(&xtime_lock, seq, flags));
 
 	while (usec >= 1000000) {
 		usec -= 1000000;
@@ -278,9 +278,9 @@ int do_settimeofday(struct timespec *tv)
 {
 	int ret;
 
-	write_seqlock_irq(&xtime_lock);
+	write_raw_seqlock_irq(&xtime_lock);
 	ret = bus_do_settimeofday(tv);
-	write_sequnlock_irq(&xtime_lock);
+	write_raw_sequnlock_irq(&xtime_lock);
 	clock_was_set();
 	return ret;
 }
diff --git a/arch/xtensa/kernel/time.c b/arch/xtensa/kernel/time.c
index 19f7df3..e8184d5 100644
--- a/arch/xtensa/kernel/time.c
+++ b/arch/xtensa/kernel/time.c
@@ -101,7 +101,7 @@ again:
 		update_process_times(user_mode(get_irq_regs()));
 #endif
 
-		write_seqlock(&xtime_lock);
+		write_raw_seqlock(&xtime_lock);
 
 		do_timer(1); /* Linux handler in kernel/timer.c */
 
@@ -110,7 +110,7 @@ again:
 		next += CCOUNT_PER_JIFFY;
 		set_linux_timer(next);
 
-		write_sequnlock(&xtime_lock);
+		write_raw_sequnlock(&xtime_lock);
 	}
 
 	/* Allow platform to do something useful (Wdog). */
diff --git a/include/linux/time.h b/include/linux/time.h
index 6e026e4..49278a9 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -99,7 +99,7 @@ static inline struct timespec timespec_sub(struct timespec lhs,
 
 extern struct timespec xtime;
 extern struct timespec wall_to_monotonic;
-extern seqlock_t xtime_lock;
+extern raw_seqlock_t xtime_lock;
 
 extern void read_persistent_clock(struct timespec *ts);
 extern void read_boot_clock(struct timespec *ts);
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 0086628..54cf84f 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -88,10 +88,10 @@ static void hrtimer_get_softirq_time(struct hrtimer_cpu_base *base)
 	unsigned long seq;
 
 	do {
-		seq = read_seqbegin(&xtime_lock);
+		seq = read_raw_seqbegin(&xtime_lock);
 		xts = current_kernel_time();
 		tom = wall_to_monotonic;
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (read_raw_seqretry(&xtime_lock, seq));
 
 	xtim = timespec_to_ktime(xts);
 	tomono = timespec_to_ktime(tom);
@@ -619,11 +619,11 @@ static void retrigger_next_event(void *arg)
 		return;
 
 	do {
-		seq = read_seqbegin(&xtime_lock);
+		seq = read_raw_seqbegin(&xtime_lock);
 		set_normalized_timespec(&realtime_offset,
 					-wall_to_monotonic.tv_sec,
 					-wall_to_monotonic.tv_nsec);
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (read_raw_seqretry(&xtime_lock, seq));
 
 	base = &__get_cpu_var(hrtimer_bases);
 
diff --git a/kernel/time.c b/kernel/time.c
index 8047980..adbe583 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -133,11 +133,11 @@ SYSCALL_DEFINE2(gettimeofday, struct timeval __user *, tv,
  */
 static inline void warp_clock(void)
 {
-	write_seqlock_irq(&xtime_lock);
+	write_raw_seqlock_irq(&xtime_lock);
 	wall_to_monotonic.tv_sec -= sys_tz.tz_minuteswest * 60;
 	xtime.tv_sec += sys_tz.tz_minuteswest * 60;
 	update_xtime_cache(0);
-	write_sequnlock_irq(&xtime_lock);
+	write_raw_sequnlock_irq(&xtime_lock);
 	clock_was_set();
 }
 
@@ -699,9 +699,9 @@ u64 get_jiffies_64(void)
 	u64 ret;
 
 	do {
-		seq = read_seqbegin(&xtime_lock);
+		seq = read_raw_seqbegin(&xtime_lock);
 		ret = jiffies_64;
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (read_raw_seqretry(&xtime_lock, seq));
 	return ret;
 }
 EXPORT_SYMBOL(get_jiffies_64);
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 4800f93..ed2aec1 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -188,7 +188,7 @@ static enum hrtimer_restart ntp_leap_second(struct hrtimer *timer)
 {
 	enum hrtimer_restart res = HRTIMER_NORESTART;
 
-	write_seqlock(&xtime_lock);
+	write_raw_seqlock(&xtime_lock);
 
 	switch (time_state) {
 	case TIME_OK:
@@ -218,7 +218,7 @@ static enum hrtimer_restart ntp_leap_second(struct hrtimer *timer)
 		break;
 	}
 
-	write_sequnlock(&xtime_lock);
+	write_raw_sequnlock(&xtime_lock);
 
 	return res;
 }
@@ -476,7 +476,7 @@ int do_adjtimex(struct timex *txc)
 
 	getnstimeofday(&ts);
 
-	write_seqlock_irq(&xtime_lock);
+	write_raw_seqlock_irq(&xtime_lock);
 
 	if (txc->modes & ADJ_ADJTIME) {
 		long save_adjust = time_adjust;
@@ -524,7 +524,7 @@ int do_adjtimex(struct timex *txc)
 	txc->errcnt	   = 0;
 	txc->stbcnt	   = 0;
 
-	write_sequnlock_irq(&xtime_lock);
+	write_raw_sequnlock_irq(&xtime_lock);
 
 	txc->time.tv_sec = ts.tv_sec;
 	txc->time.tv_usec = ts.tv_nsec;
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index b6b898d..01165a7 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -60,13 +60,13 @@ int tick_is_oneshot_available(void)
 static void tick_periodic(int cpu)
 {
 	if (tick_do_timer_cpu == cpu) {
-		write_seqlock(&xtime_lock);
+		write_raw_seqlock(&xtime_lock);
 
 		/* Keep track of the next tick event */
 		tick_next_period = ktime_add(tick_next_period, tick_period);
 
 		do_timer(1);
-		write_sequnlock(&xtime_lock);
+		write_raw_sequnlock(&xtime_lock);
 	}
 
 	update_process_times(user_mode(get_irq_regs()));
@@ -127,9 +127,9 @@ void tick_setup_periodic(struct clock_event_device *dev, int broadcast)
 		ktime_t next;
 
 		do {
-			seq = read_seqbegin(&xtime_lock);
+			seq = read_raw_seqbegin(&xtime_lock);
 			next = tick_next_period;
-		} while (read_seqretry(&xtime_lock, seq));
+		} while (read_raw_seqretry(&xtime_lock, seq));
 
 		clockevents_set_mode(dev, CLOCK_EVT_MODE_ONESHOT);
 
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index f992762..bc625d9 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -57,7 +57,7 @@ static void tick_do_update_jiffies64(ktime_t now)
 		return;
 
 	/* Reevalute with xtime_lock held */
-	write_seqlock(&xtime_lock);
+	write_raw_seqlock(&xtime_lock);
 
 	delta = ktime_sub(now, last_jiffies_update);
 	if (delta.tv64 >= tick_period.tv64) {
@@ -80,7 +80,7 @@ static void tick_do_update_jiffies64(ktime_t now)
 		/* Keep the tick_next_period variable up to date */
 		tick_next_period = ktime_add(last_jiffies_update, tick_period);
 	}
-	write_sequnlock(&xtime_lock);
+	write_raw_sequnlock(&xtime_lock);
 }
 
 /*
@@ -90,12 +90,12 @@ static ktime_t tick_init_jiffy_update(void)
 {
 	ktime_t period;
 
-	write_seqlock(&xtime_lock);
+	write_raw_seqlock(&xtime_lock);
 	/* Did we start the jiffies update yet ? */
 	if (last_jiffies_update.tv64 == 0)
 		last_jiffies_update = tick_next_period;
 	period = last_jiffies_update;
-	write_sequnlock(&xtime_lock);
+	write_raw_sequnlock(&xtime_lock);
 	return period;
 }
 
@@ -265,11 +265,11 @@ void tick_nohz_stop_sched_tick(int inidle)
 	ts->idle_calls++;
 	/* Read jiffies and the time when jiffies were updated last */
 	do {
-		seq = read_seqbegin(&xtime_lock);
+		seq = read_raw_seqbegin(&xtime_lock);
 		last_update = last_jiffies_update;
 		last_jiffies = jiffies;
 		time_delta = timekeeping_max_deferment();
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (read_raw_seqretry(&xtime_lock, seq));
 
 	if (rcu_needs_cpu(cpu) || printk_needs_cpu(cpu) ||
 	    arch_needs_cpu(cpu)) {
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 7faaa32..005217e 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -135,7 +135,7 @@ static inline s64 timekeeping_get_ns_raw(void)
  * This read-write spinlock protects us from races in SMP while
  * playing with xtime.
  */
-__cacheline_aligned_in_smp DEFINE_SEQLOCK(xtime_lock);
+__cacheline_aligned_in_smp DEFINE_RAW_SEQLOCK(xtime_lock);
 
 
 /*
@@ -226,7 +226,7 @@ void getnstimeofday(struct timespec *ts)
 	WARN_ON(timekeeping_suspended);
 
 	do {
-		seq = read_seqbegin(&xtime_lock);
+		seq = read_raw_seqbegin(&xtime_lock);
 
 		*ts = xtime;
 		nsecs = timekeeping_get_ns();
@@ -234,7 +234,7 @@ void getnstimeofday(struct timespec *ts)
 		/* If arch requires, add in gettimeoffset() */
 		nsecs += arch_gettimeoffset();
 
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (read_raw_seqretry(&xtime_lock, seq));
 
 	timespec_add_ns(ts, nsecs);
 }
@@ -249,12 +249,12 @@ ktime_t ktime_get(void)
 	WARN_ON(timekeeping_suspended);
 
 	do {
-		seq = read_seqbegin(&xtime_lock);
+		seq = read_raw_seqbegin(&xtime_lock);
 		secs = xtime.tv_sec + wall_to_monotonic.tv_sec;
 		nsecs = xtime.tv_nsec + wall_to_monotonic.tv_nsec;
 		nsecs += timekeeping_get_ns();
 
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (read_raw_seqretry(&xtime_lock, seq));
 	/*
 	 * Use ktime_set/ktime_add_ns to create a proper ktime on
 	 * 32-bit architectures without CONFIG_KTIME_SCALAR.
@@ -280,12 +280,12 @@ void ktime_get_ts(struct timespec *ts)
 	WARN_ON(timekeeping_suspended);
 
 	do {
-		seq = read_seqbegin(&xtime_lock);
+		seq = read_raw_seqbegin(&xtime_lock);
 		*ts = xtime;
 		tomono = wall_to_monotonic;
 		nsecs = timekeeping_get_ns();
 
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (read_raw_seqretry(&xtime_lock, seq));
 
 	set_normalized_timespec(ts, ts->tv_sec + tomono.tv_sec,
 				ts->tv_nsec + tomono.tv_nsec + nsecs);
@@ -322,7 +322,7 @@ int do_settimeofday(struct timespec *tv)
 	if ((unsigned long)tv->tv_nsec >= NSEC_PER_SEC)
 		return -EINVAL;
 
-	write_seqlock_irqsave(&xtime_lock, flags);
+	write_raw_seqlock_irqsave(&xtime_lock, flags);
 
 	timekeeping_forward_now();
 
@@ -339,7 +339,7 @@ int do_settimeofday(struct timespec *tv)
 
 	update_vsyscall(&xtime, timekeeper.clock, timekeeper.mult);
 
-	write_sequnlock_irqrestore(&xtime_lock, flags);
+	write_raw_sequnlock_irqrestore(&xtime_lock, flags);
 
 	/* signal hrtimers about time change */
 	clock_was_set();
@@ -418,11 +418,11 @@ void ktime_get_ts(struct timespec *ts)
 	unsigned long seq;
 
 	do {
-		seq = read_seqbegin(&xtime_lock);
+		seq = read_raw_seqbegin(&xtime_lock);
 		getnstimeofday(ts);
 		tomono = wall_to_monotonic;
 
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (read_raw_seqretry(&xtime_lock, seq));
 
 	set_normalized_timespec(ts, ts->tv_sec + tomono.tv_sec,
 				ts->tv_nsec + tomono.tv_nsec);
@@ -458,11 +458,11 @@ void getrawmonotonic(struct timespec *ts)
 	s64 nsecs;
 
 	do {
-		seq = read_seqbegin(&xtime_lock);
+		seq = read_raw_seqbegin(&xtime_lock);
 		nsecs = timekeeping_get_ns_raw();
 		*ts = raw_time;
 
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (read_raw_seqretry(&xtime_lock, seq));
 
 	timespec_add_ns(ts, nsecs);
 }
@@ -478,11 +478,11 @@ int timekeeping_valid_for_hres(void)
 	int ret;
 
 	do {
-		seq = read_seqbegin(&xtime_lock);
+		seq = read_raw_seqbegin(&xtime_lock);
 
 		ret = timekeeper.clock->flags & CLOCK_SOURCE_VALID_FOR_HRES;
 
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (read_raw_seqretry(&xtime_lock, seq));
 
 	return ret;
 }
@@ -540,7 +540,7 @@ void __init timekeeping_init(void)
 	read_persistent_clock(&now);
 	read_boot_clock(&boot);
 
-	write_seqlock_irqsave(&xtime_lock, flags);
+	write_raw_seqlock_irqsave(&xtime_lock, flags);
 
 	ntp_init();
 
@@ -562,7 +562,7 @@ void __init timekeeping_init(void)
 	update_xtime_cache(0);
 	total_sleep_time.tv_sec = 0;
 	total_sleep_time.tv_nsec = 0;
-	write_sequnlock_irqrestore(&xtime_lock, flags);
+	write_raw_sequnlock_irqrestore(&xtime_lock, flags);
 }
 
 /* time in seconds when suspend began */
@@ -585,7 +585,7 @@ static int timekeeping_resume(struct sys_device *dev)
 
 	clocksource_resume();
 
-	write_seqlock_irqsave(&xtime_lock, flags);
+	write_raw_seqlock_irqsave(&xtime_lock, flags);
 
 	if (timespec_compare(&ts, &timekeeping_suspend_time) > 0) {
 		ts = timespec_sub(ts, timekeeping_suspend_time);
@@ -598,7 +598,7 @@ static int timekeeping_resume(struct sys_device *dev)
 	timekeeper.clock->cycle_last = timekeeper.clock->read(timekeeper.clock);
 	timekeeper.ntp_error = 0;
 	timekeeping_suspended = 0;
-	write_sequnlock_irqrestore(&xtime_lock, flags);
+	write_raw_sequnlock_irqrestore(&xtime_lock, flags);
 
 	touch_softlockup_watchdog();
 
@@ -616,10 +616,10 @@ static int timekeeping_suspend(struct sys_device *dev, pm_message_t state)
 
 	read_persistent_clock(&timekeeping_suspend_time);
 
-	write_seqlock_irqsave(&xtime_lock, flags);
+	write_raw_seqlock_irqsave(&xtime_lock, flags);
 	timekeeping_forward_now();
 	timekeeping_suspended = 1;
-	write_sequnlock_irqrestore(&xtime_lock, flags);
+	write_raw_sequnlock_irqrestore(&xtime_lock, flags);
 
 	clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL);
 
@@ -907,10 +907,10 @@ struct timespec current_kernel_time(void)
 	unsigned long seq;
 
 	do {
-		seq = read_seqbegin(&xtime_lock);
+		seq = read_raw_seqbegin(&xtime_lock);
 
 		now = xtime_cache;
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (read_raw_seqretry(&xtime_lock, seq));
 
 	return now;
 }
@@ -922,11 +922,11 @@ struct timespec get_monotonic_coarse(void)
 	unsigned long seq;
 
 	do {
-		seq = read_seqbegin(&xtime_lock);
+		seq = read_raw_seqbegin(&xtime_lock);
 
 		now = xtime_cache;
 		mono = wall_to_monotonic;
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (read_raw_seqretry(&xtime_lock, seq));
 
 	set_normalized_timespec(&now, now.tv_sec + mono.tv_sec,
 				now.tv_nsec + mono.tv_nsec);
-- 
1.6.5.2

