Return-Path: <linux-kernel-owner+w=401wt.eu-S932390AbZHUTqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932390AbZHUTqU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 15:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932176AbZHUTqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 15:46:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:40625 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932118AbZHUTqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 15:46:18 -0400
Date: Fri, 21 Aug 2009 19:45:49 GMT
From: tip-bot for john stultz <johnstul@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dvhltc@us.ibm.com, hpa@zytor.com,
       mingo@redhat.com, andi@firstfloor.org, johnstul@us.ibm.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, dvhltc@us.ibm.com,
       linux-kernel@vger.kernel.org, andi@firstfloor.org, johnstul@us.ibm.com,
       tglx@linutronix.de
In-Reply-To: <1250734414.6897.5.camel@localhost.localdomain>
References: <1250734414.6897.5.camel@localhost.localdomain>
Subject: [tip:timers/core] time: Introduce CLOCK_REALTIME_COARSE
Message-ID: <tip-da15cfdae03351c689736f8d142618592e3cebc3@git.kernel.org>
Git-Commit-ID: da15cfdae03351c689736f8d142618592e3cebc3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 21 Aug 2009 19:45:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  da15cfdae03351c689736f8d142618592e3cebc3
Gitweb:     http://git.kernel.org/tip/da15cfdae03351c689736f8d142618592e3cebc3
Author:     john stultz <johnstul@us.ibm.com>
AuthorDate: Wed, 19 Aug 2009 19:13:34 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 21 Aug 2009 21:43:46 +0200

time: Introduce CLOCK_REALTIME_COARSE

After talking with some application writers who want very fast, but not
fine-grained timestamps, I decided to try to implement new clock_ids
to clock_gettime(): CLOCK_REALTIME_COARSE and CLOCK_MONOTONIC_COARSE
which returns the time at the last tick. This is very fast as we don't
have to access any hardware (which can be very painful if you're using
something like the acpi_pm clocksource), and we can even use the vdso
clock_gettime() method to avoid the syscall. The only trade off is you
only get low-res tick grained time resolution.

This isn't a new idea, I know Ingo has a patch in the -rt tree that made
the vsyscall gettimeofday() return coarse grained time when the
vsyscall64 sysctrl was set to 2. However this affects all applications
on a system.

With this method, applications can choose the proper speed/granularity
trade-off for themselves.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: nikolag@ca.ibm.com
Cc: Darren Hart <dvhltc@us.ibm.com>
Cc: arjan@infradead.org
Cc: jonathan@jonmasters.org
LKML-Reference: <1250734414.6897.5.camel@localhost.localdomain>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>



---
 arch/x86/include/asm/vgtod.h   |    1 +
 arch/x86/kernel/vsyscall_64.c  |    1 +
 arch/x86/vdso/vclock_gettime.c |   39 ++++++++++++++++++++++++++++++++++++---
 include/linux/time.h           |    4 ++++
 kernel/posix-timers.c          |   35 +++++++++++++++++++++++++++++++++++
 kernel/time/timekeeping.c      |   21 +++++++++++++++++++++
 6 files changed, 98 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/vgtod.h b/arch/x86/include/asm/vgtod.h
index dc27a69..3d61e20 100644
--- a/arch/x86/include/asm/vgtod.h
+++ b/arch/x86/include/asm/vgtod.h
@@ -21,6 +21,7 @@ struct vsyscall_gtod_data {
 		u32	shift;
 	} clock;
 	struct timespec wall_to_monotonic;
+	struct timespec wall_time_coarse;
 };
 extern struct vsyscall_gtod_data __vsyscall_gtod_data
 __section_vsyscall_gtod_data;
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 25ee06a..cf53a78 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -87,6 +87,7 @@ void update_vsyscall(struct timespec *wall_time, struct clocksource *clock)
 	vsyscall_gtod_data.wall_time_sec = wall_time->tv_sec;
 	vsyscall_gtod_data.wall_time_nsec = wall_time->tv_nsec;
 	vsyscall_gtod_data.wall_to_monotonic = wall_to_monotonic;
+	vsyscall_gtod_data.wall_time_coarse = __current_kernel_time();
 	write_sequnlock_irqrestore(&vsyscall_gtod_data.lock, flags);
 }
 
diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
index 6a40b78..ee55754 100644
--- a/arch/x86/vdso/vclock_gettime.c
+++ b/arch/x86/vdso/vclock_gettime.c
@@ -86,14 +86,47 @@ notrace static noinline int do_monotonic(struct timespec *ts)
 	return 0;
 }
 
+notrace static noinline int do_realtime_coarse(struct timespec *ts)
+{
+	unsigned long seq;
+	do {
+		seq = read_seqbegin(&gtod->lock);
+		ts->tv_sec = gtod->wall_time_coarse.tv_sec;
+		ts->tv_nsec = gtod->wall_time_coarse.tv_nsec;
+	} while (unlikely(read_seqretry(&gtod->lock, seq)));
+	return 0;
+}
+
+notrace static noinline int do_monotonic_coarse(struct timespec *ts)
+{
+	unsigned long seq, ns, secs;
+	do {
+		seq = read_seqbegin(&gtod->lock);
+		secs = gtod->wall_time_coarse.tv_sec;
+		ns = gtod->wall_time_coarse.tv_nsec;
+		secs += gtod->wall_to_monotonic.tv_sec;
+		ns += gtod->wall_to_monotonic.tv_nsec;
+	} while (unlikely(read_seqretry(&gtod->lock, seq)));
+	vset_normalized_timespec(ts, secs, ns);
+	return 0;
+}
+
 notrace int __vdso_clock_gettime(clockid_t clock, struct timespec *ts)
 {
-	if (likely(gtod->sysctl_enabled && gtod->clock.vread))
+	if (likely(gtod->sysctl_enabled))
 		switch (clock) {
 		case CLOCK_REALTIME:
-			return do_realtime(ts);
+			if (likely(gtod->clock.vread))
+				return do_realtime(ts);
+			break;
 		case CLOCK_MONOTONIC:
-			return do_monotonic(ts);
+			if (likely(gtod->clock.vread))
+				return do_monotonic(ts);
+			break;
+		case CLOCK_REALTIME_COARSE:
+			return do_realtime_coarse(ts);
+		case CLOCK_MONOTONIC_COARSE:
+			return do_monotonic_coarse(ts);
 		}
 	return vdso_fallback_gettime(clock, ts);
 }
diff --git a/include/linux/time.h b/include/linux/time.h
index f505988..256232f 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -110,6 +110,8 @@ extern int timekeeping_suspended;
 
 unsigned long get_seconds(void);
 struct timespec current_kernel_time(void);
+struct timespec __current_kernel_time(void); /* does not hold xtime_lock */
+struct timespec get_monotonic_coarse(void);
 
 #define CURRENT_TIME		(current_kernel_time())
 #define CURRENT_TIME_SEC	((struct timespec) { get_seconds(), 0 })
@@ -243,6 +245,8 @@ struct itimerval {
 #define CLOCK_PROCESS_CPUTIME_ID	2
 #define CLOCK_THREAD_CPUTIME_ID		3
 #define CLOCK_MONOTONIC_RAW		4
+#define CLOCK_REALTIME_COARSE		5
+#define CLOCK_MONOTONIC_COARSE		6
 
 /*
  * The IDs of various hardware clocks:
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index d089d05..4954407 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -242,6 +242,25 @@ static int posix_get_monotonic_raw(clockid_t which_clock, struct timespec *tp)
 	return 0;
 }
 
+
+static int posix_get_realtime_coarse(clockid_t which_clock, struct timespec *tp)
+{
+	*tp = current_kernel_time();
+	return 0;
+}
+
+static int posix_get_monotonic_coarse(clockid_t which_clock,
+						struct timespec *tp)
+{
+	*tp = get_monotonic_coarse();
+	return 0;
+}
+
+int posix_get_coarse_res(const clockid_t which_clock, struct timespec *tp)
+{
+	*tp = ktime_to_timespec(KTIME_LOW_RES);
+	return 0;
+}
 /*
  * Initialize everything, well, just everything in Posix clocks/timers ;)
  */
@@ -262,10 +281,26 @@ static __init int init_posix_timers(void)
 		.timer_create = no_timer_create,
 		.nsleep = no_nsleep,
 	};
+	struct k_clock clock_realtime_coarse = {
+		.clock_getres = posix_get_coarse_res,
+		.clock_get = posix_get_realtime_coarse,
+		.clock_set = do_posix_clock_nosettime,
+		.timer_create = no_timer_create,
+		.nsleep = no_nsleep,
+	};
+	struct k_clock clock_monotonic_coarse = {
+		.clock_getres = posix_get_coarse_res,
+		.clock_get = posix_get_monotonic_coarse,
+		.clock_set = do_posix_clock_nosettime,
+		.timer_create = no_timer_create,
+		.nsleep = no_nsleep,
+	};
 
 	register_posix_clock(CLOCK_REALTIME, &clock_realtime);
 	register_posix_clock(CLOCK_MONOTONIC, &clock_monotonic);
 	register_posix_clock(CLOCK_MONOTONIC_RAW, &clock_monotonic_raw);
+	register_posix_clock(CLOCK_REALTIME_COARSE, &clock_realtime_coarse);
+	register_posix_clock(CLOCK_MONOTONIC_COARSE, &clock_monotonic_coarse);
 
 	posix_timers_cache = kmem_cache_create("posix_timers_cache",
 					sizeof (struct k_itimer), 0, SLAB_PANIC,
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 15e06de..03cbeb3 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -847,6 +847,10 @@ unsigned long get_seconds(void)
 }
 EXPORT_SYMBOL(get_seconds);
 
+struct timespec __current_kernel_time(void)
+{
+	return xtime_cache;
+}
 
 struct timespec current_kernel_time(void)
 {
@@ -862,3 +866,20 @@ struct timespec current_kernel_time(void)
 	return now;
 }
 EXPORT_SYMBOL(current_kernel_time);
+
+struct timespec get_monotonic_coarse(void)
+{
+	struct timespec now, mono;
+	unsigned long seq;
+
+	do {
+		seq = read_seqbegin(&xtime_lock);
+
+		now = xtime_cache;
+		mono = wall_to_monotonic;
+	} while (read_seqretry(&xtime_lock, seq));
+
+	set_normalized_timespec(&now, now.tv_sec + mono.tv_sec,
+				now.tv_nsec + mono.tv_nsec);
+	return now;
+}
