Return-Path: <linux-kernel-owner+w=401wt.eu-S1756703AbYCMBCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703AbYCMBCy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 21:02:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755295AbYCMBBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 21:01:43 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:53903 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753490AbYCMBBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 21:01:40 -0400
Message-Id: <20080313004902.986157906@linux-m68k.org>
References: <20080313002235.351414762@linux-m68k.org>
User-Agent: quilt/0.46-1
Date: Thu, 13 Mar 2008 01:22:39 +0100
From: zippel@linux-m68k.org
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [PATCH 4/4] remove div_long_long_rem
Content-Disposition: inline; filename=div_long_long
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86 is the only arch right now, which provides an optimized for
div_long_long_rem and it has the downside that one has to be very
careful that the divide doesn't overflow.
The API is a little akward, as the arguments for the unsigned divide
are signed. The signed version also doesn't handle a negative divisor
and produces worse code on 64bit archs.
There is little incentive to keep this API alive, so this converts the
few users to the new API.

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>

---
 arch/mips/kernel/binfmt_elfn32.c |    5 ++-
 arch/mips/kernel/binfmt_elfo32.c |    5 ++-
 drivers/char/mmtimer.c           |   24 ++++++++-----------
 include/asm-x86/div64.h          |   19 ---------------
 include/linux/calc64.h           |   49 ---------------------------------------
 include/linux/jiffies.h          |    2 -
 kernel/posix-cpu-timers.c        |   11 +++-----
 kernel/time.c                    |   25 +++++++++++--------
 kernel/time/ntp.c                |    6 +---
 mm/slub.c                        |    9 +++----
 10 files changed, 44 insertions(+), 111 deletions(-)

Index: linux-2.6/arch/mips/kernel/binfmt_elfn32.c
===================================================================
--- linux-2.6.orig/arch/mips/kernel/binfmt_elfn32.c	2008-03-12 17:20:15.000000000 +0100
+++ linux-2.6/arch/mips/kernel/binfmt_elfn32.c	2008-03-12 17:21:47.000000000 +0100
@@ -54,6 +54,7 @@ typedef elf_fpreg_t elf_fpregset_t[ELF_N
 #include <linux/module.h>
 #include <linux/elfcore.h>
 #include <linux/compat.h>
+#include <linux/math64.h>
 
 #define elf_prstatus elf_prstatus32
 struct elf_prstatus32
@@ -102,8 +103,8 @@ jiffies_to_compat_timeval(unsigned long 
 	 * one divide.
 	 */
 	u64 nsec = (u64)jiffies * TICK_NSEC;
-	long rem;
-	value->tv_sec = div_long_long_rem(nsec, NSEC_PER_SEC, &rem);
+	u32 rem;
+	value->tv_sec = div_u64_rem(nsec, NSEC_PER_SEC, &rem);
 	value->tv_usec = rem / NSEC_PER_USEC;
 }
 
Index: linux-2.6/arch/mips/kernel/binfmt_elfo32.c
===================================================================
--- linux-2.6.orig/arch/mips/kernel/binfmt_elfo32.c	2008-03-12 17:20:16.000000000 +0100
+++ linux-2.6/arch/mips/kernel/binfmt_elfo32.c	2008-03-12 17:21:47.000000000 +0100
@@ -56,6 +56,7 @@ typedef elf_fpreg_t elf_fpregset_t[ELF_N
 #include <linux/module.h>
 #include <linux/elfcore.h>
 #include <linux/compat.h>
+#include <linux/math64.h>
 
 #define elf_prstatus elf_prstatus32
 struct elf_prstatus32
@@ -104,8 +105,8 @@ jiffies_to_compat_timeval(unsigned long 
 	 * one divide.
 	 */
 	u64 nsec = (u64)jiffies * TICK_NSEC;
-	long rem;
-	value->tv_sec = div_long_long_rem(nsec, NSEC_PER_SEC, &rem);
+	u32 rem;
+	value->tv_sec = div_u64_rem(nsec, NSEC_PER_SEC, &rem);
 	value->tv_usec = rem / NSEC_PER_USEC;
 }
 
Index: linux-2.6/drivers/char/mmtimer.c
===================================================================
--- linux-2.6.orig/drivers/char/mmtimer.c	2008-03-12 17:20:15.000000000 +0100
+++ linux-2.6/drivers/char/mmtimer.c	2008-03-12 17:21:47.000000000 +0100
@@ -30,6 +30,8 @@
 #include <linux/miscdevice.h>
 #include <linux/posix-timers.h>
 #include <linux/interrupt.h>
+#include <linux/time.h>
+#include <linux/math64.h>
 
 #include <asm/uaccess.h>
 #include <asm/sn/addrs.h>
@@ -366,8 +368,8 @@ static int sgi_clock_get(clockid_t clock
 
 	nsec = rtc_time() * sgi_clock_period
 			+ sgi_clock_offset.tv_nsec;
-	tp->tv_sec = div_long_long_rem(nsec, NSEC_PER_SEC, &tp->tv_nsec)
-			+ sgi_clock_offset.tv_sec;
+	*tp = ns_to_timespec(nsec);
+	tp->tv_sec += sgi_clock_offset.tv_sec;
 	return 0;
 };
 
@@ -375,11 +377,11 @@ static int sgi_clock_set(clockid_t clock
 {
 
 	u64 nsec;
-	u64 rem;
+	u32 rem;
 
 	nsec = rtc_time() * sgi_clock_period;
 
-	sgi_clock_offset.tv_sec = tp->tv_sec - div_long_long_rem(nsec, NSEC_PER_SEC, &rem);
+	sgi_clock_offset.tv_sec = tp->tv_sec - div_u64_rem(nsec, NSEC_PER_SEC, &rem);
 
 	if (rem <= tp->tv_nsec)
 		sgi_clock_offset.tv_nsec = tp->tv_sec - rem;
@@ -532,9 +534,6 @@ static int sgi_timer_del(struct k_itimer
 	return 0;
 }
 
-#define timespec_to_ns(x) ((x).tv_nsec + (x).tv_sec * NSEC_PER_SEC)
-#define ns_to_timespec(ts, nsec) (ts).tv_sec = div_long_long_rem(nsec, NSEC_PER_SEC, &(ts).tv_nsec)
-
 /* Assumption: it_lock is already held with irq's disabled */
 static void sgi_timer_get(struct k_itimer *timr, struct itimerspec *cur_setting)
 {
@@ -547,9 +546,8 @@ static void sgi_timer_get(struct k_itime
 		return;
 	}
 
-	ns_to_timespec(cur_setting->it_interval, timr->it.mmtimer.incr * sgi_clock_period);
-	ns_to_timespec(cur_setting->it_value, (timr->it.mmtimer.expires - rtc_time())* sgi_clock_period);
-	return;
+	cur_setting->it_interval = ns_to_timespec(timr->it.mmtimer.incr * sgi_clock_period);
+	cur_setting->it_value = ns_to_timespec((timr->it.mmtimer.expires - rtc_time()) * sgi_clock_period);
 }
 
 
@@ -568,8 +566,8 @@ static int sgi_timer_set(struct k_itimer
 		sgi_timer_get(timr, old_setting);
 
 	sgi_timer_del(timr);
-	when = timespec_to_ns(new_setting->it_value);
-	period = timespec_to_ns(new_setting->it_interval);
+	when = timespec_to_ns(&new_setting->it_value);
+	period = timespec_to_ns(&new_setting->it_interval);
 
 	if (when == 0)
 		/* Clear timer */
@@ -580,7 +578,7 @@ static int sgi_timer_set(struct k_itimer
 		unsigned long now;
 
 		getnstimeofday(&n);
-		now = timespec_to_ns(n);
+		now = timespec_to_ns(&n);
 		if (when > now)
 			when -= now;
 		else
Index: linux-2.6/include/asm-x86/div64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/div64.h	2008-03-12 17:20:15.000000000 +0100
+++ linux-2.6/include/asm-x86/div64.h	2008-03-12 17:21:47.000000000 +0100
@@ -31,25 +31,6 @@
 	__mod; \
 })
 
-/*
- * (long)X = ((long long)divs) / (long)div
- * (long)rem = ((long long)divs) % (long)div
- *
- * Warning, this will do an exception if X overflows.
- */
-#define div_long_long_rem(a,b,c) div_ll_X_l_rem(a,b,c)
-
-static inline long
-div_ll_X_l_rem(long long divs, long div, long *rem)
-{
-	long dum2;
-      __asm__("divl %2":"=a"(dum2), "=d"(*rem)
-      :	"rm"(div), "A"(divs));
-
-	return dum2;
-
-}
-
 static inline u64 div_u64_rem(u64 dividend, u32 divisor, u32 *remainder)
 {
 	union {
Index: linux-2.6/include/linux/calc64.h
===================================================================
--- linux-2.6.orig/include/linux/calc64.h	2008-03-12 17:20:15.000000000 +0100
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,49 +0,0 @@
-#ifndef _LINUX_CALC64_H
-#define _LINUX_CALC64_H
-
-#include <linux/types.h>
-#include <asm/div64.h>
-
-/*
- * This is a generic macro which is used when the architecture
- * specific div64.h does not provide a optimized one.
- *
- * The 64bit dividend is divided by the divisor (data type long), the
- * result is returned and the remainder stored in the variable
- * referenced by remainder (data type long *). In contrast to the
- * do_div macro the dividend is kept intact.
- */
-#ifndef div_long_long_rem
-#define div_long_long_rem(dividend, divisor, remainder)	\
-	do_div_llr((dividend), divisor, remainder)
-
-static inline unsigned long do_div_llr(const long long dividend,
-				       const long divisor, long *remainder)
-{
-	u64 result = dividend;
-
-	*(remainder) = do_div(result, divisor);
-	return (unsigned long) result;
-}
-#endif
-
-/*
- * Sign aware variation of the above. On some architectures a
- * negative dividend leads to an divide overflow exception, which
- * is avoided by the sign check.
- */
-static inline long div_long_long_rem_signed(const long long dividend,
-					    const long divisor, long *remainder)
-{
-	long res;
-
-	if (unlikely(dividend < 0)) {
-		res = -div_long_long_rem(-dividend, divisor, remainder);
-		*remainder = -(*remainder);
-	} else
-		res = div_long_long_rem(dividend, divisor, remainder);
-
-	return res;
-}
-
-#endif
Index: linux-2.6/include/linux/jiffies.h
===================================================================
--- linux-2.6.orig/include/linux/jiffies.h	2008-03-12 17:20:15.000000000 +0100
+++ linux-2.6/include/linux/jiffies.h	2008-03-12 17:21:47.000000000 +0100
@@ -1,7 +1,7 @@
 #ifndef _LINUX_JIFFIES_H
 #define _LINUX_JIFFIES_H
 
-#include <linux/calc64.h>
+#include <linux/math64.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/time.h>
Index: linux-2.6/kernel/posix-cpu-timers.c
===================================================================
--- linux-2.6.orig/kernel/posix-cpu-timers.c	2008-03-12 17:20:16.000000000 +0100
+++ linux-2.6/kernel/posix-cpu-timers.c	2008-03-12 17:21:47.000000000 +0100
@@ -4,8 +4,9 @@
 
 #include <linux/sched.h>
 #include <linux/posix-timers.h>
-#include <asm/uaccess.h>
 #include <linux/errno.h>
+#include <linux/math64.h>
+#include <asm/uaccess.h>
 
 static int check_clock(const clockid_t which_clock)
 {
@@ -47,12 +48,10 @@ static void sample_to_timespec(const clo
 			       union cpu_time_count cpu,
 			       struct timespec *tp)
 {
-	if (CPUCLOCK_WHICH(which_clock) == CPUCLOCK_SCHED) {
-		tp->tv_sec = div_long_long_rem(cpu.sched,
-					       NSEC_PER_SEC, &tp->tv_nsec);
-	} else {
+	if (CPUCLOCK_WHICH(which_clock) == CPUCLOCK_SCHED)
+		*tp = ns_to_timespec(cpu.sched);
+	else
 		cputime_to_timespec(cpu.cpu, tp);
-	}
 }
 
 static inline int cpu_time_before(const clockid_t which_clock,
Index: linux-2.6/kernel/time.c
===================================================================
--- linux-2.6.orig/kernel/time.c	2008-03-12 17:20:16.000000000 +0100
+++ linux-2.6/kernel/time.c	2008-03-12 17:21:47.000000000 +0100
@@ -390,13 +390,17 @@ void set_normalized_timespec(struct time
 struct timespec ns_to_timespec(const s64 nsec)
 {
 	struct timespec ts;
+	s32 rem;
 
 	if (!nsec)
 		return (struct timespec) {0, 0};
 
-	ts.tv_sec = div_long_long_rem_signed(nsec, NSEC_PER_SEC, &ts.tv_nsec);
-	if (unlikely(nsec < 0))
-		set_normalized_timespec(&ts, ts.tv_sec, ts.tv_nsec);
+	ts.tv_sec = div_s64_rem(nsec, NSEC_PER_SEC, &rem);
+	if (unlikely(rem < 0)) {
+		ts.tv_sec--;
+		rem += NSEC_PER_SEC;
+	}
+	ts.tv_nsec = rem;
 
 	return ts;
 }
@@ -526,8 +530,10 @@ jiffies_to_timespec(const unsigned long 
 	 * Convert jiffies to nanoseconds and separate with
 	 * one divide.
 	 */
-	u64 nsec = (u64)jiffies * TICK_NSEC;
-	value->tv_sec = div_long_long_rem(nsec, NSEC_PER_SEC, &value->tv_nsec);
+	u32 rem;
+	value->tv_sec = div_u64_rem((u64)jiffies * TICK_NSEC,
+				    NSEC_PER_SEC, &rem);
+	value->tv_nsec = rem;
 }
 EXPORT_SYMBOL(jiffies_to_timespec);
 
@@ -565,12 +571,11 @@ void jiffies_to_timeval(const unsigned l
 	 * Convert jiffies to nanoseconds and separate with
 	 * one divide.
 	 */
-	u64 nsec = (u64)jiffies * TICK_NSEC;
-	long tv_usec;
+	u32 rem;
 
-	value->tv_sec = div_long_long_rem(nsec, NSEC_PER_SEC, &tv_usec);
-	tv_usec /= NSEC_PER_USEC;
-	value->tv_usec = tv_usec;
+	value->tv_sec = div_u64_rem((u64)jiffies * TICK_NSEC,
+				    NSEC_PER_SEC, &rem);
+	value->tv_usec = rem / NSEC_PER_USEC;
 }
 EXPORT_SYMBOL(jiffies_to_timeval);
 
Index: linux-2.6/kernel/time/ntp.c
===================================================================
--- linux-2.6.orig/kernel/time/ntp.c	2008-03-12 17:20:16.000000000 +0100
+++ linux-2.6/kernel/time/ntp.c	2008-03-12 17:21:47.000000000 +0100
@@ -234,7 +234,7 @@ static inline void notify_cmos_timer(voi
  */
 int do_adjtimex(struct timex *txc)
 {
-	long mtemp, save_adjust, rem;
+	long mtemp, save_adjust;
 	s64 freq_adj;
 	int result;
 
@@ -345,9 +345,7 @@ int do_adjtimex(struct timex *txc)
 		    freq_adj += time_freq;
 		    freq_adj = min(freq_adj, (s64)MAXFREQ_NSEC);
 		    time_freq = max(freq_adj, (s64)-MAXFREQ_NSEC);
-		    time_offset = div_long_long_rem_signed(time_offset,
-							   NTP_INTERVAL_FREQ,
-							   &rem);
+		    time_offset = div_s64(time_offset, NTP_INTERVAL_FREQ);
 		    time_offset <<= SHIFT_UPDATE;
 		} /* STA_PLL */
 	    } /* txc->modes & ADJ_OFFSET */
Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2008-03-12 17:20:15.000000000 +0100
+++ linux-2.6/mm/slub.c	2008-03-12 17:21:47.000000000 +0100
@@ -21,6 +21,7 @@
 #include <linux/ctype.h>
 #include <linux/kallsyms.h>
 #include <linux/memory.h>
+#include <linux/math64.h>
 
 /*
  * Lock order:
@@ -3515,12 +3516,10 @@ static int list_locations(struct kmem_ca
 			len += sprintf(buf + len, "<not-available>");
 
 		if (l->sum_time != l->min_time) {
-			unsigned long remainder;
-
 			len += sprintf(buf + len, " age=%ld/%ld/%ld",
-			l->min_time,
-			div_long_long_rem(l->sum_time, l->count, &remainder),
-			l->max_time);
+				l->min_time,
+				(long)div_u64(l->sum_time, l->count),
+				l->max_time);
 		} else
 			len += sprintf(buf + len, " age=%ld",
 				l->min_time);

-- 

