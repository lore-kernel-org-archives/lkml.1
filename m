Return-Path: <linux-kernel-owner+w=401wt.eu-S965054AbXC1RiI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965054AbXC1RiI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 13:38:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965122AbXC1RiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 13:38:08 -0400
Received: from sp604001mt.neufgp.fr ([84.96.92.60]:54439 "EHLO Smtp.neuf.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965054AbXC1RiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 13:38:07 -0400
Date: Wed, 28 Mar 2007 19:33:23 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
Subject: [PATCH] x86_64 : vsyscall_gtod_data diet and vgettimeofday() fix
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>, Linux kernel <linux-kernel@vger.kernel.org>
Message-id: <460AA6E3.50109@cosmosbay.com>
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_OTBHeBKI8vyLDPllo7UP4w)"
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--Boundary_(ID_OTBHeBKI8vyLDPllo7UP4w)
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT

Hi Andrew

This patch should be applied after x86_64 : fix vtime() vsyscall

Thank you

[PATCH] x86_64 : vsyscall_gtod_data diet and vgettimeofday() fix

Current vsyscall_gtod_data is large (3 or 4 cache lines dirtied at timer 
interrupt). We can shrink it to exactly 64 bytes (1 cache line on AMD64)

Instead of copying a whole struct clocksource, we copy only needed fields.

I deleted an unused field : offset_base

This patch fixes one oddity in vgettimeofday(): It can returns a timeval with 
tv_usec = 1000000. Maybe not a bug, but why not doing the right thing ?

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>


--Boundary_(ID_OTBHeBKI8vyLDPllo7UP4w)
Content-type: text/plain; name=vsyscall_gtod_data_diet.patch
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=vsyscall_gtod_data_diet.patch

--- linux-2.6.21-rc5/arch/x86_64/kernel/vsyscall.c
+++ linux-2.6.21-rc5-ed/arch/x86_64/kernel/vsyscall.c
@@ -46,13 +46,28 @@
 #define __vsyscall(nr) __attribute__ ((unused,__section__(".vsyscall_" #nr)))
 #define __syscall_clobber "r11","rcx","memory"
 
+/*
+ * vsyscall_gtod_data contains data that is :
+ * - readonly from vsyscalls
+ * - writen by timer interrupt or systcl (/proc/sys/kernel/vsyscall64)
+ * Try to keep this structure as small as possible to avoid cache line ping pongs
+ */
 struct vsyscall_gtod_data_t {
-	seqlock_t lock;
-	int sysctl_enabled;
-	struct timeval wall_time_tv;
+	seqlock_t	lock;
+
+	/* open coded 'struct timespec' */
+	time_t		wall_time_sec;
+	u32		wall_time_nsec;
+
+	int		sysctl_enabled;
 	struct timezone sys_tz;
-	cycle_t offset_base;
-	struct clocksource clock;
+	struct { /* extract of a clocksource struct */
+		cycle_t (*vread)(void);
+		cycle_t	cycle_last;
+		cycle_t	mask;
+		u32	mult;
+		u32	shift;
+	} clock;
 };
 int __vgetcpu_mode __section_vgetcpu_mode;
 
@@ -68,9 +83,13 @@ void update_vsyscall(struct timespec *wa
 
 	write_seqlock_irqsave(&vsyscall_gtod_data.lock, flags);
 	/* copy vsyscall data */
-	vsyscall_gtod_data.clock = *clock;
-	vsyscall_gtod_data.wall_time_tv.tv_sec = wall_time->tv_sec;
-	vsyscall_gtod_data.wall_time_tv.tv_usec = wall_time->tv_nsec/1000;
+	vsyscall_gtod_data.clock.vread = clock->vread;
+	vsyscall_gtod_data.clock.cycle_last = clock->cycle_last;
+	vsyscall_gtod_data.clock.mask = clock->mask;
+	vsyscall_gtod_data.clock.mult = clock->mult;
+	vsyscall_gtod_data.clock.shift = clock->shift;
+	vsyscall_gtod_data.wall_time_sec = wall_time->tv_sec;
+	vsyscall_gtod_data.wall_time_nsec = wall_time->tv_nsec;
 	vsyscall_gtod_data.sys_tz = sys_tz;
 	write_sequnlock_irqrestore(&vsyscall_gtod_data.lock, flags);
 }
@@ -105,7 +124,8 @@ static __always_inline long time_syscall
 static __always_inline void do_vgettimeofday(struct timeval * tv)
 {
 	cycle_t now, base, mask, cycle_delta;
-	unsigned long seq, mult, shift, nsec_delta;
+	unsigned seq;
+	unsigned long mult, shift, nsec;
 	cycle_t (*vread)(void);
 	do {
 		seq = read_seqbegin(&__vsyscall_gtod_data.lock);
@@ -121,21 +141,20 @@ static __always_inline void do_vgettimeo
 		mult = __vsyscall_gtod_data.clock.mult;
 		shift = __vsyscall_gtod_data.clock.shift;
 
-		*tv = __vsyscall_gtod_data.wall_time_tv;
-
+		tv->tv_sec = __vsyscall_gtod_data.wall_time_sec;
+		nsec = __vsyscall_gtod_data.wall_time_nsec;
 	} while (read_seqretry(&__vsyscall_gtod_data.lock, seq));
 
 	/* calculate interval: */
 	cycle_delta = (now - base) & mask;
 	/* convert to nsecs: */
-	nsec_delta = (cycle_delta * mult) >> shift;
+	nsec += (cycle_delta * mult) >> shift;
 
-	/* convert to usecs and add to timespec: */
-	tv->tv_usec += nsec_delta / NSEC_PER_USEC;
-	while (tv->tv_usec > USEC_PER_SEC) {
+	while (nsec >= NSEC_PER_SEC) {
 		tv->tv_sec += 1;
-		tv->tv_usec -= USEC_PER_SEC;
+		nsec -= NSEC_PER_SEC;
 	}
+	tv->tv_usec = nsec / NSEC_PER_USEC;
 }
 
 int __vsyscall(0) vgettimeofday(struct timeval * tv, struct timezone * tz)
@@ -152,7 +171,7 @@ time_t __vsyscall(1) vtime(time_t *t)
 	time_t result;
 	if (!__vsyscall_gtod_data.sysctl_enabled)
 		return time_syscall(t);
-	result = __vsyscall_gtod_data.wall_time_tv.tv_sec;
+	result = __vsyscall_gtod_data.wall_time_sec;
 	if (t)
 		*t = result;
 	return result;

--Boundary_(ID_OTBHeBKI8vyLDPllo7UP4w)--
