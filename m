Return-Path: <linux-kernel-owner+w=401wt.eu-S1756608AbYCMBCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608AbYCMBCj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 21:02:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755282AbYCMBBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 21:01:42 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:53902 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753819AbYCMBBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 21:01:40 -0400
Message-Id: <20080313004902.866970953@linux-m68k.org>
References: <20080313002235.351414762@linux-m68k.org>
User-Agent: quilt/0.46-1
Date: Thu, 13 Mar 2008 01:22:37 +0100
From: zippel@linux-m68k.org
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [PATCH 2/4] convert a few do_div user
Content-Disposition: inline; filename=div64_2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts a few users of do_div to div_[su]64 and this demonstrates
nicely how it can reduce some expressions to one-liners.

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>

---
 kernel/time.c     |   29 +++++++++--------------------
 kernel/time/ntp.c |   25 ++++++-------------------
 2 files changed, 15 insertions(+), 39 deletions(-)

Index: linux-2.6/kernel/time.c
===================================================================
--- linux-2.6.orig/kernel/time.c	2008-03-11 17:15:14.000000000 +0100
+++ linux-2.6/kernel/time.c	2008-03-12 21:21:20.000000000 +0100
@@ -35,6 +35,7 @@
 #include <linux/syscalls.h>
 #include <linux/security.h>
 #include <linux/fs.h>
+#include <linux/math64.h>
 
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
@@ -585,9 +586,7 @@ clock_t jiffies_to_clock_t(long x)
 	return x / (HZ / USER_HZ);
 # endif
 #else
-	u64 tmp = (u64)x * TICK_NSEC;
-	do_div(tmp, (NSEC_PER_SEC / USER_HZ));
-	return (long)tmp;
+	return div_u64((u64)x * TICK_NSEC, NSEC_PER_SEC / USER_HZ);
 #endif
 }
 EXPORT_SYMBOL(jiffies_to_clock_t);
@@ -599,16 +598,12 @@ unsigned long clock_t_to_jiffies(unsigne
 		return ~0UL;
 	return x * (HZ / USER_HZ);
 #else
-	u64 jif;
-
 	/* Don't worry about loss of precision here .. */
 	if (x >= ~0UL / HZ * USER_HZ)
 		return ~0UL;
 
 	/* .. but do try to contain it here */
-	jif = x * (u64) HZ;
-	do_div(jif, USER_HZ);
-	return jif;
+	return div_u64((u64)x * HZ, USER_HZ);
 #endif
 }
 EXPORT_SYMBOL(clock_t_to_jiffies);
@@ -617,10 +612,9 @@ u64 jiffies_64_to_clock_t(u64 x)
 {
 #if (TICK_NSEC % (NSEC_PER_SEC / USER_HZ)) == 0
 # if HZ < USER_HZ
-	x *= USER_HZ;
-	do_div(x, HZ);
+	x = div_u64(x * USER_HZ, HZ);
 # elif HZ > USER_HZ
-	do_div(x, HZ / USER_HZ);
+	x = div_u64(x, HZ / USER_HZ);
 # else
 	/* Nothing to do */
 # endif
@@ -630,8 +624,7 @@ u64 jiffies_64_to_clock_t(u64 x)
 	 * but even this doesn't overflow in hundreds of years
 	 * in 64 bits, so..
 	 */
-	x *= TICK_NSEC;
-	do_div(x, (NSEC_PER_SEC / USER_HZ));
+	x = div_u64(x * TICK_NSEC, (NSEC_PER_SEC / USER_HZ));
 #endif
 	return x;
 }
@@ -640,21 +633,17 @@ EXPORT_SYMBOL(jiffies_64_to_clock_t);
 u64 nsec_to_clock_t(u64 x)
 {
 #if (NSEC_PER_SEC % USER_HZ) == 0
-	do_div(x, (NSEC_PER_SEC / USER_HZ));
+	return div_u64(x, NSEC_PER_SEC / USER_HZ);
 #elif (USER_HZ % 512) == 0
-	x *= USER_HZ/512;
-	do_div(x, (NSEC_PER_SEC / 512));
+	return div_u64(x * USER_HZ / 512, NSEC_PER_SEC / 512);
 #else
 	/*
          * max relative error 5.7e-8 (1.8s per year) for USER_HZ <= 1024,
          * overflow after 64.99 years.
          * exact for HZ=60, 72, 90, 120, 144, 180, 300, 600, 900, ...
          */
-	x *= 9;
-	do_div(x, (unsigned long)((9ull * NSEC_PER_SEC + (USER_HZ/2)) /
-				  USER_HZ));
+	return div_u64(x * 9, (9ull * NSEC_PER_SEC + (USER_HZ / 2)) / USER_HZ);
 #endif
-	return x;
 }
 
 #if (BITS_PER_LONG < 64)
Index: linux-2.6/kernel/time/ntp.c
===================================================================
--- linux-2.6.orig/kernel/time/ntp.c	2008-03-11 17:15:14.000000000 +0100
+++ linux-2.6/kernel/time/ntp.c	2008-03-12 21:21:20.000000000 +0100
@@ -15,7 +15,7 @@
 #include <linux/jiffies.h>
 #include <linux/hrtimer.h>
 #include <linux/capability.h>
-#include <asm/div64.h>
+#include <linux/math64.h>
 #include <asm/timex.h>
 
 /*
@@ -53,10 +53,8 @@ static void ntp_update_frequency(void)
 
 	tick_length_base = second_length;
 
-	do_div(second_length, HZ);
-	tick_nsec = second_length >> TICK_LENGTH_SHIFT;
-
-	do_div(tick_length_base, NTP_INTERVAL_FREQ);
+	tick_nsec = div_u64(second_length, HZ) >> TICK_LENGTH_SHIFT;
+	tick_length_base = div_u64(tick_length_base, NTP_INTERVAL_FREQ);
 }
 
 /**
@@ -237,7 +235,7 @@ static inline void notify_cmos_timer(voi
 int do_adjtimex(struct timex *txc)
 {
 	long mtemp, save_adjust, rem;
-	s64 freq_adj, temp64;
+	s64 freq_adj;
 	int result;
 
 	/* In order to modify anything, you gotta be super-user! */
@@ -342,19 +340,8 @@ int do_adjtimex(struct timex *txc)
 		    freq_adj = time_offset * mtemp;
 		    freq_adj = shift_right(freq_adj, time_constant * 2 +
 					   (SHIFT_PLL + 2) * 2 - SHIFT_NSEC);
-		    if (mtemp >= MINSEC && (time_status & STA_FLL || mtemp > MAXSEC)) {
-			u64 utemp64;
-			temp64 = time_offset << (SHIFT_NSEC - SHIFT_FLL);
-			if (time_offset < 0) {
-			    utemp64 = -temp64;
-			    do_div(utemp64, mtemp);
-			    freq_adj -= utemp64;
-			} else {
-			    utemp64 = temp64;
-			    do_div(utemp64, mtemp);
-			    freq_adj += utemp64;
-			}
-		    }
+		    if (mtemp >= MINSEC && (time_status & STA_FLL || mtemp > MAXSEC))
+			freq_adj += div_s64(time_offset << (SHIFT_NSEC - SHIFT_FLL), mtemp);
 		    freq_adj += time_freq;
 		    freq_adj = min(freq_adj, (s64)MAXFREQ_NSEC);
 		    time_freq = max(freq_adj, (s64)-MAXFREQ_NSEC);

-- 

