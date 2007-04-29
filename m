Return-Path: <linux-kernel-owner+w=401wt.eu-S1756344AbXD2K6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344AbXD2K6M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 06:58:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756367AbXD2K5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 06:57:50 -0400
Received: from mx1.suse.de ([195.135.220.2]:52221 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756344AbXD2Kxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 06:53:39 -0400
From: Andi Kleen <ak@suse.de>
References: <200704291252.514680000@suse.de>
In-Reply-To: <200704291252.514680000@suse.de>
To: Eric Dumazet <dada1@cosmosbay.com>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [44/48] x86_64: vsyscall_gtod_data diet and vgettimeofday() fix
Message-Id: <20070429105334.AE68A151C5@wotan.suse.de>
Date: Sun, 29 Apr 2007 12:53:34 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Eric Dumazet <dada1@cosmosbay.com>

Current vsyscall_gtod_data is large (3 or 4 cache lines dirtied at timer 
interrupt). We can shrink it to exactly 64 bytes (1 cache line on AMD64)

Instead of copying a whole struct clocksource, we copy only needed fields.

I deleted an unused field : offset_base

This patch fixes one oddity in vgettimeofday(): It can returns a timeval with 
tv_usec = 1000000. Maybe not a bug, but why not doing the right thing ?

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Signed-off-by: Andi Kleen <ak@suse.de>



---
 arch/x86_64/kernel/vsyscall.c |   53 ++++++++++++++++++++++++++++--------------
 1 file changed, 36 insertions(+), 17 deletions(-)

Index: linux/arch/x86_64/kernel/vsyscall.c
===================================================================
--- linux.orig/arch/x86_64/kernel/vsyscall.c
+++ linux/arch/x86_64/kernel/vsyscall.c
@@ -51,13 +51,28 @@
 	  asm("" : "=r" (v) : "0" (x)); \
 	  ((v - VSYSCALL_FIRST_PAGE) + __pa_symbol(&__vsyscall_0)); })
 
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
 
@@ -73,9 +88,13 @@ void update_vsyscall(struct timespec *wa
 
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
@@ -110,7 +129,8 @@ static __always_inline long time_syscall
 static __always_inline void do_vgettimeofday(struct timeval * tv)
 {
 	cycle_t now, base, mask, cycle_delta;
-	unsigned long seq, mult, shift, nsec_delta;
+	unsigned seq;
+	unsigned long mult, shift, nsec;
 	cycle_t (*vread)(void);
 	do {
 		seq = read_seqbegin(&__vsyscall_gtod_data.lock);
@@ -126,21 +146,20 @@ static __always_inline void do_vgettimeo
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
@@ -159,7 +178,7 @@ time_t __vsyscall(1) vtime(time_t *t)
 	time_t result;
 	if (unlikely(!__vsyscall_gtod_data.sysctl_enabled))
 		return time_syscall(t);
-	result = __vsyscall_gtod_data.wall_time_tv.tv_sec;
+	result = __vsyscall_gtod_data.wall_time_sec;
 	if (t)
 		*t = result;
 	return result;
