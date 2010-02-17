Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191Ab0BQSsU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 13:48:20 -0500
Received: from www.tglx.de ([62.245.132.106]:42285 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592Ab0BQSsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 13:48:15 -0500
Message-Id: <20100217184155.923972510@linutronix.de>
User-Agent: quilt/0.47-1
Date: Wed, 17 Feb 2010 18:47:57 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linux-Arch <linux-arch@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       John Stultz <johnstul@us.ibm.com>
Subject: [patch 5/5] x86: Convert vsyscall gtod lock to raw_seqlock
References: <20100217183740.486724334@linutronix.de>
Content-Disposition: inline;
	filename=x86-convert-xsyscall-gtod-lock-to-raw-seqlock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vsyscall gtod seqlock is taken in the same context as xtime_lock and
therefor cannot be converted to a sleeping lock in preempt-rt.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/vgtod.h   |    2 +-
 arch/x86/kernel/vsyscall_64.c  |   14 +++++++-------
 arch/x86/vdso/vclock_gettime.c |   16 ++++++++--------
 3 files changed, 16 insertions(+), 16 deletions(-)

Index: linux-2.6-tip/arch/x86/include/asm/vgtod.h
===================================================================
--- linux-2.6-tip.orig/arch/x86/include/asm/vgtod.h
+++ linux-2.6-tip/arch/x86/include/asm/vgtod.h
@@ -5,7 +5,7 @@
 #include <linux/clocksource.h>
 
 struct vsyscall_gtod_data {
-	seqlock_t	lock;
+	raw_seqlock_t lock;
 
 	/* open coded 'struct timespec' */
 	time_t		wall_time_sec;
Index: linux-2.6-tip/arch/x86/kernel/vsyscall_64.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/vsyscall_64.c
+++ linux-2.6-tip/arch/x86/kernel/vsyscall_64.c
@@ -59,7 +59,7 @@ int __vgetcpu_mode __section_vgetcpu_mod
 
 struct vsyscall_gtod_data __vsyscall_gtod_data __section_vsyscall_gtod_data =
 {
-	.lock = __SEQLOCK_UNLOCKED(__vsyscall_gtod_data.lock),
+	.lock = __RAW_SEQLOCK_UNLOCKED(__vsyscall_gtod_data.lock),
 	.sysctl_enabled = 1,
 };
 
@@ -67,10 +67,10 @@ void update_vsyscall_tz(void)
 {
 	unsigned long flags;
 
-	write_seqlock_irqsave(&vsyscall_gtod_data.lock, flags);
+	write_raw_seqlock_irqsave(&vsyscall_gtod_data.lock, flags);
 	/* sys_tz has changed */
 	vsyscall_gtod_data.sys_tz = sys_tz;
-	write_sequnlock_irqrestore(&vsyscall_gtod_data.lock, flags);
+	write_raw_sequnlock_irqrestore(&vsyscall_gtod_data.lock, flags);
 }
 
 void update_vsyscall(struct timespec *wall_time, struct clocksource *clock,
@@ -78,7 +78,7 @@ void update_vsyscall(struct timespec *wa
 {
 	unsigned long flags;
 
-	write_seqlock_irqsave(&vsyscall_gtod_data.lock, flags);
+	write_raw_seqlock_irqsave(&vsyscall_gtod_data.lock, flags);
 	/* copy vsyscall data */
 	vsyscall_gtod_data.clock.vread = clock->vread;
 	vsyscall_gtod_data.clock.cycle_last = clock->cycle_last;
@@ -89,7 +89,7 @@ void update_vsyscall(struct timespec *wa
 	vsyscall_gtod_data.wall_time_nsec = wall_time->tv_nsec;
 	vsyscall_gtod_data.wall_to_monotonic = wall_to_monotonic;
 	vsyscall_gtod_data.wall_time_coarse = __current_kernel_time();
-	write_sequnlock_irqrestore(&vsyscall_gtod_data.lock, flags);
+	write_raw_sequnlock_irqrestore(&vsyscall_gtod_data.lock, flags);
 }
 
 /* RED-PEN may want to readd seq locking, but then the variable should be
@@ -126,7 +126,7 @@ static __always_inline void do_vgettimeo
 	unsigned long mult, shift, nsec;
 	cycle_t (*vread)(void);
 	do {
-		seq = read_seqbegin(&__vsyscall_gtod_data.lock);
+		seq = read_raw_seqbegin(&__vsyscall_gtod_data.lock);
 
 		vread = __vsyscall_gtod_data.clock.vread;
 		if (unlikely(!__vsyscall_gtod_data.sysctl_enabled || !vread)) {
@@ -142,7 +142,7 @@ static __always_inline void do_vgettimeo
 
 		tv->tv_sec = __vsyscall_gtod_data.wall_time_sec;
 		nsec = __vsyscall_gtod_data.wall_time_nsec;
-	} while (read_seqretry(&__vsyscall_gtod_data.lock, seq));
+	} while (read_raw_seqretry(&__vsyscall_gtod_data.lock, seq));
 
 	/* calculate interval: */
 	cycle_delta = (now - base) & mask;
Index: linux-2.6-tip/arch/x86/vdso/vclock_gettime.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/vdso/vclock_gettime.c
+++ linux-2.6-tip/arch/x86/vdso/vclock_gettime.c
@@ -47,11 +47,11 @@ notrace static noinline int do_realtime(
 {
 	unsigned long seq, ns;
 	do {
-		seq = read_seqbegin(&gtod->lock);
+		seq = read_raw_seqbegin(&gtod->lock);
 		ts->tv_sec = gtod->wall_time_sec;
 		ts->tv_nsec = gtod->wall_time_nsec;
 		ns = vgetns();
-	} while (unlikely(read_seqretry(&gtod->lock, seq)));
+	} while (unlikely(read_raw_seqretry(&gtod->lock, seq)));
 	timespec_add_ns(ts, ns);
 	return 0;
 }
@@ -76,12 +76,12 @@ notrace static noinline int do_monotonic
 {
 	unsigned long seq, ns, secs;
 	do {
-		seq = read_seqbegin(&gtod->lock);
+		seq = read_raw_seqbegin(&gtod->lock);
 		secs = gtod->wall_time_sec;
 		ns = gtod->wall_time_nsec + vgetns();
 		secs += gtod->wall_to_monotonic.tv_sec;
 		ns += gtod->wall_to_monotonic.tv_nsec;
-	} while (unlikely(read_seqretry(&gtod->lock, seq)));
+	} while (unlikely(read_raw_seqretry(&gtod->lock, seq)));
 	vset_normalized_timespec(ts, secs, ns);
 	return 0;
 }
@@ -90,10 +90,10 @@ notrace static noinline int do_realtime_
 {
 	unsigned long seq;
 	do {
-		seq = read_seqbegin(&gtod->lock);
+		seq = read_raw_seqbegin(&gtod->lock);
 		ts->tv_sec = gtod->wall_time_coarse.tv_sec;
 		ts->tv_nsec = gtod->wall_time_coarse.tv_nsec;
-	} while (unlikely(read_seqretry(&gtod->lock, seq)));
+	} while (unlikely(read_raw_seqretry(&gtod->lock, seq)));
 	return 0;
 }
 
@@ -101,12 +101,12 @@ notrace static noinline int do_monotonic
 {
 	unsigned long seq, ns, secs;
 	do {
-		seq = read_seqbegin(&gtod->lock);
+		seq = read_raw_seqbegin(&gtod->lock);
 		secs = gtod->wall_time_coarse.tv_sec;
 		ns = gtod->wall_time_coarse.tv_nsec;
 		secs += gtod->wall_to_monotonic.tv_sec;
 		ns += gtod->wall_to_monotonic.tv_nsec;
-	} while (unlikely(read_seqretry(&gtod->lock, seq)));
+	} while (unlikely(read_raw_seqretry(&gtod->lock, seq)));
 	vset_normalized_timespec(ts, secs, ns);
 	return 0;
 }


