Return-Path: <linux-kernel-owner+w=401wt.eu-S1762562AbYBPB1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762562AbYBPB1L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 20:27:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756880AbYBPB06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 20:26:58 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:39237 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754713AbYBPB05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 20:26:57 -0500
Subject: [PATCH 1/3] split clocksource mult into mult and mult_adj
From: John Stultz <johnstul@us.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Josip Loncaric <josip@lanl.gov>, Roman Zippel <zippel@linux-m68k.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain
Date: Fri, 15 Feb 2008 17:26:31 -0800
Message-Id: <1203125191.6275.20.camel@jstultz-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The clocksource frequency is represented by
clocksource->mult/2^(clocksource->shift). Currently, when NTP makes
adjustments to the clock frequency, they are made directly to the mult
value.

This has the drawback that once changed, we cannot know what the orignal
mult value was, or how much adjustment has been applied.

This property causes problems in calculating proper ntp intervals when
switching back and forth between clocksources. 

This patch separates the current mult value into a mult and mult_adj
pair. The mult value stays constant, while the ntp clocksource
adjustments are done only to the mult_adj value.

This allows for correct ntp interval calculation and additionally lays
the groundwork for a new notion of time, what I'm calling the
monotonic-raw time, which is introduced in a following patch.

Thoughts or comments would be appreciated.

thanks
-john

Signed-off-by: John Stultz <johnstul@us.ibm.com>

diff --git a/arch/ia64/kernel/time.c b/arch/ia64/kernel/time.c
index 17fda52..37851e1 100644
--- a/arch/ia64/kernel/time.c
+++ b/arch/ia64/kernel/time.c
@@ -357,7 +357,7 @@ void update_vsyscall(struct timespec *wall, struct clocksource *c)
 
         /* copy fsyscall clock data */
         fsyscall_gtod_data.clk_mask = c->mask;
-        fsyscall_gtod_data.clk_mult = c->mult;
+        fsyscall_gtod_data.clk_mult = c->mult + c->mult_adj;
         fsyscall_gtod_data.clk_shift = c->shift;
         fsyscall_gtod_data.clk_fsys_mmio = c->fsys_mmio;
         fsyscall_gtod_data.clk_cycle_last = c->cycle_last;
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 3b26fbd..36aa8da 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -814,7 +814,7 @@ void update_vsyscall(struct timespec *wall_time, struct clocksource *clock)
 
 	/* XXX this assumes clock->shift == 22 */
 	/* 4611686018 ~= 2^(20+64-22) / 1e9 */
-	t2x = (u64) clock->mult * 4611686018ULL;
+	t2x = (u64) (clock->mult + clock->mult_adj) * 4611686018ULL;
 	stamp_xsec = (u64) xtime.tv_nsec * XSEC_PER_SEC;
 	do_div(stamp_xsec, 1000000000);
 	stamp_xsec += (u64) xtime.tv_sec * XSEC_PER_SEC;
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 3f82427..14afd48 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -83,7 +83,7 @@ void update_vsyscall(struct timespec *wall_time, struct clocksource *clock)
 	vsyscall_gtod_data.clock.vread = clock->vread;
 	vsyscall_gtod_data.clock.cycle_last = clock->cycle_last;
 	vsyscall_gtod_data.clock.mask = clock->mask;
-	vsyscall_gtod_data.clock.mult = clock->mult;
+	vsyscall_gtod_data.clock.mult = clock->mult + clock->mult_adj;
 	vsyscall_gtod_data.clock.shift = clock->shift;
 	vsyscall_gtod_data.wall_time_sec = wall_time->tv_sec;
 	vsyscall_gtod_data.wall_time_nsec = wall_time->tv_nsec;
diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 85778a4..e917a30 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -45,7 +45,8 @@ struct clocksource;
  * @read:		returns a cycle value
  * @mask:		bitmask for two's complement
  *			subtraction of non 64 bit counters
- * @mult:		cycle to nanosecond multiplier
+ * @mult:		cycle to nanosecond multiplier (unadjusted)
+ * @mult_adj:		NTP adjustment factor added to the multiplier
  * @shift:		cycle to nanosecond divisor (power of two)
  * @flags:		flags describing special properties
  * @vread:		vsyscall based read
@@ -63,6 +64,7 @@ struct clocksource {
 	cycle_t (*read)(void);
 	cycle_t mask;
 	u32 mult;
+	s32 mult_adj;
 	u32 shift;
 	unsigned long flags;
 	cycle_t (*vread)(void);
@@ -179,7 +181,7 @@ static inline cycle_t clocksource_read(struct clocksource *cs)
 static inline s64 cyc2ns(struct clocksource *cs, cycle_t cycles)
 {
 	u64 ret = (u64)cycles;
-	ret = (ret * cs->mult) >> cs->shift;
+	ret = (ret * (cs->mult + cs->mult_adj)) >> cs->shift;
 	return ret;
 }
 
@@ -199,7 +201,7 @@ static inline void clocksource_calculate_interval(struct clocksource *c,
 {
 	u64 tmp;
 
-	/* XXX - All of this could use a whole lot of optimization */
+	/* Do the ns -> cycle conversion first, ignoring mult_adj */
 	tmp = length_nsec;
 	tmp <<= c->shift;
 	tmp += c->mult/2;
@@ -209,7 +211,8 @@ static inline void clocksource_calculate_interval(struct clocksource *c,
 	if (c->cycle_interval == 0)
 		c->cycle_interval = 1;
 
-	c->xtime_interval = (u64)c->cycle_interval * c->mult;
+	/* Go back from cycles -> shifted ns, this time include mult_adj */
+	c->xtime_interval = (u64)c->cycle_interval * (c->mult + c->mult_adj);
 }
 
 
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 1af9fb0..5b11b0f 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -426,7 +426,7 @@ static void clocksource_adjust(s64 offset)
 	} else
 		return;
 
-	clock->mult += adj;
+	clock->mult_adj += adj;
 	clock->xtime_interval += interval;
 	clock->xtime_nsec -= offset;
 	clock->error -= (interval - offset) <<


