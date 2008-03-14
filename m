Return-Path: <linux-kernel-owner+w=401wt.eu-S1759189AbYCNUBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759189AbYCNUBs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 16:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756843AbYCNUBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 16:01:05 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:48226 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755507AbYCNUBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 16:01:01 -0400
Message-Id: <20080314195737.153531685@linux-m68k.org>
References: <20080314184001.695807682@linux-m68k.org>
User-Agent: quilt/0.46-1
Date: Fri, 14 Mar 2008 19:40:08 +0100
From: zippel@linux-m68k.org
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, johnstul@us.ibm.com
Subject: [PATCH 7/8] Remove current_tick_length()
Content-Disposition: inline; filename=tick_length
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

current_tick_length used to do a little more, but now it just returns
tick_length, which we can also access directly at the few places, where
it's needed.

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>

---
 include/linux/timex.h     |    4 ++--
 kernel/time/ntp.c         |   16 ++--------------
 kernel/time/timekeeping.c |    5 ++---
 3 files changed, 6 insertions(+), 19 deletions(-)

Index: linux-2.6-mm/include/linux/timex.h
===================================================================
--- linux-2.6-mm.orig/include/linux/timex.h
+++ linux-2.6-mm/include/linux/timex.h
@@ -234,8 +234,8 @@ static inline int ntp_synced(void)
 #endif
 #define NTP_INTERVAL_LENGTH (NSEC_PER_SEC/NTP_INTERVAL_FREQ)
 
-/* Returns how long ticks are at present, in ns / 2^(SHIFT_SCALE-10). */
-extern u64 current_tick_length(void);
+/* Returns how long ticks are at present, in ns / 2^NTP_SCALE_SHIFT. */
+extern u64 tick_length;
 
 extern void second_overflow(void);
 extern void update_ntp_one_tick(void);
Index: linux-2.6-mm/kernel/time/ntp.c
===================================================================
--- linux-2.6-mm.orig/kernel/time/ntp.c
+++ linux-2.6-mm/kernel/time/ntp.c
@@ -23,7 +23,8 @@
  */
 unsigned long tick_usec = TICK_USEC; 		/* USER_HZ period (usec) */
 unsigned long tick_nsec;			/* ACTHZ period (nsec) */
-static u64 tick_length, tick_length_base;
+u64 tick_length;
+static u64 tick_length_base;
 
 #define MAX_TICKADJ		500		/* microsecs */
 #define MAX_TICKADJ_SCALED	(((u64)(MAX_TICKADJ * NSEC_PER_USEC) << \
@@ -203,19 +204,6 @@ void second_overflow(void)
 	}
 }
 
-/*
- * Return how long ticks are at the moment, that is, how much time
- * update_wall_time_one_tick will add to xtime next time we call it
- * (assuming no calls to do_adjtimex in the meantime).
- * The return value is in fixed-point nanoseconds shifted by the
- * specified number of bits to the right of the binary point.
- * This function has no side-effects.
- */
-u64 current_tick_length(void)
-{
-	return tick_length;
-}
-
 #ifdef CONFIG_GENERIC_CMOS_UPDATE
 
 /* Disable the cmos update - used by virtualization and embedded */
Index: linux-2.6-mm/kernel/time/timekeeping.c
===================================================================
--- linux-2.6-mm.orig/kernel/time/timekeeping.c
+++ linux-2.6-mm/kernel/time/timekeeping.c
@@ -374,8 +374,7 @@ static __always_inline int clocksource_b
 	 * Now calculate the error in (1 << look_ahead) ticks, but first
 	 * remove the single look ahead already included in the error.
 	 */
-	tick_error = current_tick_length() >>
-		(NTP_SCALE_SHIFT - clock->shift + 1);
+	tick_error = tick_length >> (NTP_SCALE_SHIFT - clock->shift + 1);
 	tick_error -= clock->xtime_interval >> 1;
 	error = ((error - tick_error) >> look_ahead) + tick_error;
 
@@ -467,7 +466,7 @@ void update_wall_time(void)
 		}
 
 		/* accumulate error between NTP and clock interval */
-		clock->error += current_tick_length();
+		clock->error += tick_length;
 		clock->error -= clock->xtime_interval << (NTP_SCALE_SHIFT - clock->shift);
 	}
 

-- 

