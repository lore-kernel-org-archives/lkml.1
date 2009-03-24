Return-Path: <linux-kernel-owner+w=401wt.eu-S1755978AbZCXBfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978AbZCXBfU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 21:35:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752856AbZCXBfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 21:35:05 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:57818 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbZCXBfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 21:35:04 -0400
Subject: [RFC][PATCH] Logarithmic Timekeeping Accumulation
From: John Stultz <johnstul@us.ibm.com>
To: Linux-kernel <linux-kernel@vger.kernel.org>
Cc: Clark Williams <williams@redhat.com>, Steven Rostedt <srostedt@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Roman Zippel <zippel@linux-m68k.org>
Content-Type: text/plain
Date: Mon, 23 Mar 2009 18:28:22 -0700
Message-Id: <1237858102.7068.20.camel@jstultz-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Accumulating one tick at a time works well unless we're using NOHZ. Then
it can be an issue, since we may have to run through the loop a few
thousand times, which can increase timer interrupt caused latency.

The current solution was to accumulate in half-second intervals with
NOHZ. This kept the number of loops down, however it did slightly change
how we make NTP adjustments. While not an issue with NTPd users, as NTPd
makes adjustments over a longer period of time, other adjtimex() users
have noticed the half-second granularity with which we can apply
frequency changes to the clock.

For instance, if a application tries to apply a 100ppm frequency
correction for 20ms to correct a 2us offset, with NOHZ they either get
no correction, or a 50us correction.

Now, there will always be some granularity error for applying frequency
corrections. However with users sensitive to this error have seen a
50-500x increase with NOHZ compared to running without NOHZ.

So I figured I'd try another approach then just simply increasing the
interval. My approach is to consume the time interval logarithmically.
This reduces the number of times  through the loop needed keeping
latency down, while still preserving the original granularity error for
adjtimex() changes.

This has been lightly tested and appears to work correctly, but I'd
appreciate any feedback or comments on the idea and code. 

Signed-off-by: John Stultz <johnstul@us.ibm.com>


diff --git a/include/linux/timex.h b/include/linux/timex.h
index 998a55d..680c412 100644
--- a/include/linux/timex.h
+++ b/include/linux/timex.h
@@ -241,11 +241,7 @@ static inline int ntp_synced(void)
 
 #define NTP_SCALE_SHIFT		32
 
-#ifdef CONFIG_NO_HZ
-#define NTP_INTERVAL_FREQ  (2)
-#else
 #define NTP_INTERVAL_FREQ  (HZ)
-#endif
 #define NTP_INTERVAL_LENGTH (NSEC_PER_SEC/NTP_INTERVAL_FREQ)
 
 /* Returns how long ticks are at present, in ns / 2^NTP_SCALE_SHIFT. */
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 900f1b6..dffe668 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -480,6 +480,7 @@ static void clocksource_adjust(s64 offset)
 void update_wall_time(void)
 {
 	cycle_t offset;
+	int shift = 1;
 
 	/* Make sure we're fully resumed: */
 	if (unlikely(timekeeping_suspended))
@@ -492,30 +493,47 @@ void update_wall_time(void)
 #endif
 	clock->xtime_nsec = (s64)xtime.tv_nsec << clock->shift;
 
+
+	/*
+	 * If NO_HZ is enabled, we may spend too much time in the
+	 * accumulation loop. So try to accumulate logrithmically
+	 */
+	while (offset > (clock->cycle_interval << shift))
+		shift++;
+	shift--;
+
 	/* normally this loop will run just once, however in the
 	 * case of lost or late ticks, it will accumulate correctly.
 	 */
 	while (offset >= clock->cycle_interval) {
+		if (offset < clock->cycle_interval<<shift) {
+			shift--;
+			continue;
+		}
 		/* accumulate one interval */
-		offset -= clock->cycle_interval;
-		clock->cycle_last += clock->cycle_interval;
+		offset -= clock->cycle_interval << shift;
+		clock->cycle_last += clock->cycle_interval << shift;
 
-		clock->xtime_nsec += clock->xtime_interval;
+		clock->xtime_nsec += clock->xtime_interval << shift;
 		if (clock->xtime_nsec >= (u64)NSEC_PER_SEC << clock->shift) {
 			clock->xtime_nsec -= (u64)NSEC_PER_SEC << clock->shift;
 			xtime.tv_sec++;
 			second_overflow();
 		}
 
-		clock->raw_time.tv_nsec += clock->raw_interval;
+		clock->raw_time.tv_nsec += clock->raw_interval << shift;
 		if (clock->raw_time.tv_nsec >= NSEC_PER_SEC) {
 			clock->raw_time.tv_nsec -= NSEC_PER_SEC;
 			clock->raw_time.tv_sec++;
 		}
 
 		/* accumulate error between NTP and clock interval */
-		clock->error += tick_length;
-		clock->error -= clock->xtime_interval << (NTP_SCALE_SHIFT - clock->shift);
+		clock->error += tick_length << shift;
+		clock->error -= (clock->xtime_interval
+				<< (NTP_SCALE_SHIFT - clock->shift))
+					<< shift;
+		if (shift > 0) /*don't roll under!*/
+			shift--;
 	}
 
 	/* correct the clock when NTP error is too big */


