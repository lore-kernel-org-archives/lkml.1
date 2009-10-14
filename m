Return-Path: <linux-kernel-owner+w=401wt.eu-S932347AbZJNT3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932347AbZJNT3S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 15:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758901AbZJNT3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 15:29:17 -0400
Received: from claw.goop.org ([74.207.240.146]:55263 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757127AbZJNT3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 15:29:16 -0400
From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Xen-devel <xen-devel@lists.xensource.com>, kurt.hackel@oracle.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Avi Kivity <avi@redhat.com>, the arch/x86 maintainers <x86@kernel.org>,
       Chris Mason <chris.mason@oracle.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Andi Kleen <ak@linux.intel.com>, John Wright <john.wright@hp.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 03/12] x86/vsyscall: use common implementation for vgettimeofday
Date: Wed, 14 Oct 2009 12:28:27 -0700
Message-Id: <1255548516-15260-4-git-send-email-jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1255548516-15260-1-git-send-email-jeremy.fitzhardinge@citrix.com>
References: <1255548516-15260-1-git-send-email-jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two implementations of vgettimeofday; one as a vsyscall
and one in the vdso.  The are functionally identical, but the code
is duplicated in two more-or-less equivalent forms.

The vdso implementation is also shared with the vdso vclock_gettime.

To unify the two implementations, the vdso code is hoisted into vgtod.h
as inline functions, and the callers modified accordingly.  Because
vdso and vsyscall have different ways to access struct vsyscall_gtod_data,
it is passed into each function.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: John Wright <john.wright@hp.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/vgtod.h   |   64 +++++++++++++++++++++++++++++++++++++++-
 arch/x86/kernel/vsyscall_64.c  |   61 +-------------------------------------
 arch/x86/vdso/vclock_gettime.c |   46 ++---------------------------
 3 files changed, 67 insertions(+), 104 deletions(-)

diff --git a/arch/x86/include/asm/vgtod.h b/arch/x86/include/asm/vgtod.h
index dc27a69..9045ea4 100644
--- a/arch/x86/include/asm/vgtod.h
+++ b/arch/x86/include/asm/vgtod.h
@@ -1,9 +1,11 @@
 #ifndef _ASM_X86_VGTOD_H
 #define _ASM_X86_VGTOD_H
 
-#include <asm/vsyscall.h>
 #include <linux/clocksource.h>
 
+#include <asm/vsyscall.h>
+#include <asm/unistd.h>
+
 struct vsyscall_gtod_data {
 	seqlock_t	lock;
 
@@ -26,4 +28,64 @@ extern struct vsyscall_gtod_data __vsyscall_gtod_data
 __section_vsyscall_gtod_data;
 extern struct vsyscall_gtod_data vsyscall_gtod_data;
 
+/* 
+ * Common implementation of vdso/vsyscall time functions.  This code
+ * is used in usermode, exported via either vdso or vsyscall.  Because
+ * of this, it must be inlined rather than linked, hence implemented
+ * in a .h as inline functions.
+ */
+notrace static __always_inline
+long vgetns(const struct vsyscall_gtod_data *gtod)
+{
+	long v;
+	cycles_t (*vread)(void);
+
+	vread = gtod->clock.vread;
+	v = (vread() - gtod->clock.cycle_last) & gtod->clock.mask;
+	return (v * gtod->clock.mult) >> gtod->clock.shift;
+}
+
+notrace static __always_inline
+int __do_realtime(const struct vsyscall_gtod_data *gtod,
+		  struct timespec *ts)
+{
+	unsigned long seq, ns;
+	do {
+		seq = read_seqbegin(&gtod->lock);
+		ts->tv_sec = gtod->wall_time_sec;
+		ts->tv_nsec = gtod->wall_time_nsec;
+		ns = vgetns(gtod);
+	} while (unlikely(read_seqretry(&gtod->lock, seq)));
+	timespec_add_ns(ts, ns);
+	return 0;
+}
+
+notrace static __always_inline
+int __do_vgettimeofday(const struct vsyscall_gtod_data *gtod,
+		       struct timeval *tv, struct timezone *tz)
+{
+	long ret;
+
+	if (likely(gtod->sysctl_enabled && gtod->clock.vread)) {
+		if (likely(tv != NULL)) {
+			BUILD_BUG_ON(offsetof(struct timeval, tv_usec) !=
+				     offsetof(struct timespec, tv_nsec) ||
+				     sizeof(*tv) != sizeof(struct timespec));
+			__do_realtime(gtod, (struct timespec *)tv);
+			tv->tv_usec /= 1000;
+		}
+
+		if (unlikely(tz != NULL)) {
+			/* Avoid memcpy. Some old compilers fail to inline it */
+			tz->tz_minuteswest = gtod->sys_tz.tz_minuteswest;
+			tz->tz_dsttime = gtod->sys_tz.tz_dsttime;
+		}
+		return 0;
+	}
+
+	asm("syscall" : "=a" (ret) :
+	    "0" (__NR_gettimeofday), "D" (tv), "S" (tz) : "memory");
+	return ret;
+}
+
 #endif /* _ASM_X86_VGTOD_H */
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index f71dda9..e19a60e 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -90,24 +90,6 @@ void update_vsyscall(struct timespec *wall_time, struct clocksource *clock)
 	write_sequnlock_irqrestore(&vsyscall_gtod_data.lock, flags);
 }
 
-/* RED-PEN may want to readd seq locking, but then the variable should be
- * write-once.
- */
-static __always_inline void do_get_tz(struct timezone * tz)
-{
-	*tz = __vsyscall_gtod_data.sys_tz;
-}
-
-static __always_inline int gettimeofday(struct timeval *tv, struct timezone *tz)
-{
-	int ret;
-	asm volatile("syscall"
-		: "=a" (ret)
-		: "0" (__NR_gettimeofday),"D" (tv),"S" (tz)
-		: __syscall_clobber );
-	return ret;
-}
-
 static __always_inline long time_syscall(long *t)
 {
 	long secs;
@@ -117,50 +99,9 @@ static __always_inline long time_syscall(long *t)
 	return secs;
 }
 
-static __always_inline void do_vgettimeofday(struct timeval * tv)
-{
-	cycle_t now, base, mask, cycle_delta;
-	unsigned seq;
-	unsigned long mult, shift, nsec;
-	cycle_t (*vread)(void);
-	do {
-		seq = read_seqbegin(&__vsyscall_gtod_data.lock);
-
-		vread = __vsyscall_gtod_data.clock.vread;
-		if (unlikely(!__vsyscall_gtod_data.sysctl_enabled || !vread)) {
-			gettimeofday(tv,NULL);
-			return;
-		}
-
-		now = vread();
-		base = __vsyscall_gtod_data.clock.cycle_last;
-		mask = __vsyscall_gtod_data.clock.mask;
-		mult = __vsyscall_gtod_data.clock.mult;
-		shift = __vsyscall_gtod_data.clock.shift;
-
-		tv->tv_sec = __vsyscall_gtod_data.wall_time_sec;
-		nsec = __vsyscall_gtod_data.wall_time_nsec;
-	} while (read_seqretry(&__vsyscall_gtod_data.lock, seq));
-
-	/* calculate interval: */
-	cycle_delta = (now - base) & mask;
-	/* convert to nsecs: */
-	nsec += (cycle_delta * mult) >> shift;
-
-	while (nsec >= NSEC_PER_SEC) {
-		tv->tv_sec += 1;
-		nsec -= NSEC_PER_SEC;
-	}
-	tv->tv_usec = nsec / NSEC_PER_USEC;
-}
-
 int __vsyscall(0) vgettimeofday(struct timeval * tv, struct timezone * tz)
 {
-	if (tv)
-		do_vgettimeofday(tv);
-	if (tz)
-		do_get_tz(tz);
-	return 0;
+	return __do_vgettimeofday(&__vsyscall_gtod_data, tv, tz);
 }
 
 /* This will break when the xtime seconds get inaccurate, but that is
diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
index 6a40b78..723a84f 100644
--- a/arch/x86/vdso/vclock_gettime.c
+++ b/arch/x86/vdso/vclock_gettime.c
@@ -34,28 +34,6 @@ notrace static long vdso_fallback_gettime(long clock, struct timespec *ts)
 	return ret;
 }
 
-notrace static inline long vgetns(void)
-{
-	long v;
-	cycles_t (*vread)(void);
-	vread = gtod->clock.vread;
-	v = (vread() - gtod->clock.cycle_last) & gtod->clock.mask;
-	return (v * gtod->clock.mult) >> gtod->clock.shift;
-}
-
-notrace static noinline int do_realtime(struct timespec *ts)
-{
-	unsigned long seq, ns;
-	do {
-		seq = read_seqbegin(&gtod->lock);
-		ts->tv_sec = gtod->wall_time_sec;
-		ts->tv_nsec = gtod->wall_time_nsec;
-		ns = vgetns();
-	} while (unlikely(read_seqretry(&gtod->lock, seq)));
-	timespec_add_ns(ts, ns);
-	return 0;
-}
-
 /* Copy of the version in kernel/time.c which we cannot directly access */
 notrace static void
 vset_normalized_timespec(struct timespec *ts, long sec, long nsec)
@@ -78,7 +56,7 @@ notrace static noinline int do_monotonic(struct timespec *ts)
 	do {
 		seq = read_seqbegin(&gtod->lock);
 		secs = gtod->wall_time_sec;
-		ns = gtod->wall_time_nsec + vgetns();
+		ns = gtod->wall_time_nsec + vgetns(gtod);
 		secs += gtod->wall_to_monotonic.tv_sec;
 		ns += gtod->wall_to_monotonic.tv_nsec;
 	} while (unlikely(read_seqretry(&gtod->lock, seq)));
@@ -91,7 +69,7 @@ notrace int __vdso_clock_gettime(clockid_t clock, struct timespec *ts)
 	if (likely(gtod->sysctl_enabled && gtod->clock.vread))
 		switch (clock) {
 		case CLOCK_REALTIME:
-			return do_realtime(ts);
+			return __do_realtime(gtod, ts);
 		case CLOCK_MONOTONIC:
 			return do_monotonic(ts);
 		}
@@ -102,25 +80,7 @@ int clock_gettime(clockid_t, struct timespec *)
 
 notrace int __vdso_gettimeofday(struct timeval *tv, struct timezone *tz)
 {
-	long ret;
-	if (likely(gtod->sysctl_enabled && gtod->clock.vread)) {
-		if (likely(tv != NULL)) {
-			BUILD_BUG_ON(offsetof(struct timeval, tv_usec) !=
-				     offsetof(struct timespec, tv_nsec) ||
-				     sizeof(*tv) != sizeof(struct timespec));
-			do_realtime((struct timespec *)tv);
-			tv->tv_usec /= 1000;
-		}
-		if (unlikely(tz != NULL)) {
-			/* Avoid memcpy. Some old compilers fail to inline it */
-			tz->tz_minuteswest = gtod->sys_tz.tz_minuteswest;
-			tz->tz_dsttime = gtod->sys_tz.tz_dsttime;
-		}
-		return 0;
-	}
-	asm("syscall" : "=a" (ret) :
-	    "0" (__NR_gettimeofday), "D" (tv), "S" (tz) : "memory");
-	return ret;
+	return __do_vgettimeofday(gtod, tv, tz);
 }
 int gettimeofday(struct timeval *, struct timezone *)
 	__attribute__((weak, alias("__vdso_gettimeofday")));
-- 
1.6.2.5

