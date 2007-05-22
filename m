Return-Path: <linux-kernel-owner+w=401wt.eu-S934266AbXEVLwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934266AbXEVLwl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 07:52:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760489AbXEVLwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 07:52:33 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:3132 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760042AbXEVLwc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 07:52:32 -0400
Date: Tue, 22 May 2007 13:52:10 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: john stultz <johnstul@us.ibm.com>
cc: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Elimar Riesebieter <riesebie@lxtec.de>
Subject: Re: [RFC][PATCH] do_div_signed()
In-Reply-To: <1179800853.5910.59.camel@localhost>
Message-ID: <Pine.LNX.4.64.0705221343440.1817@scrub.home>
References: <1179800853.5910.59.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 21 May 2007, john stultz wrote:

> Here's a quick pass at adding do_div_signed() which provides a signed
> version of do_div, avoiding having do_div users hack around signed
> issues (like in ntp.c).
> 
> It probably could be optimized further, so let me know if you have any
> suggestions.
> 
> 
> Other thoughts?

Did I mention that this API could use a little cleanup? :)
Below is what I had in mind, this makes it more clear what types the 
functions are working on. As bonus I cleaned up the i386 div64 
implementation to get rid of the ugly asm casts, so gcc can do better 
register allocation and generate better code.

bye, Roman


Signed-off-by: Roman Zippel <zippel@linux-m68k.org>

---
 include/asm-generic/div64.h |   14 ++++++++++++++
 include/asm-i386/div64.h    |   20 ++++++++++++++++++++
 include/linux/calc64.h      |   28 ++++++++++++++++++++++++++++
 kernel/time.c               |   26 +++++++-------------------
 kernel/time/ntp.c           |   21 +++++----------------
 lib/div64.c                 |   21 ++++++++++++++++++++-
 6 files changed, 94 insertions(+), 36 deletions(-)

Index: linux-2.6/include/asm-generic/div64.h
===================================================================
--- linux-2.6.orig/include/asm-generic/div64.h
+++ linux-2.6/include/asm-generic/div64.h
@@ -35,6 +35,20 @@ static inline uint64_t div64_64(uint64_t
 	return dividend / divisor;
 }
 
+static inline u64 div_u64_rem(u64 dividend, u32 divisor, u32 *remainder)
+{
+	*remainder = dividend % divisor;
+	return dividend / divisor;
+}
+#define div_u64_rem	div_u64_rem
+
+static inline s64 div_s64_rem(s64 dividend, s32 divisor, s32 *remainder)
+{
+	*remainder = dividend % divisor;
+	return dividend / divisor;
+}
+#define div_s64_rem	div_s64_rem
+
 #elif BITS_PER_LONG == 32
 
 extern uint32_t __div64_32(uint64_t *dividend, uint32_t divisor);
Index: linux-2.6/include/asm-i386/div64.h
===================================================================
--- linux-2.6.orig/include/asm-i386/div64.h
+++ linux-2.6/include/asm-i386/div64.h
@@ -48,5 +48,25 @@ div_ll_X_l_rem(long long divs, long div,
 
 }
 
+static inline u64 div_u64_rem(u64 dividend, u32 divisor, u32 *remainder)
+{
+	union {
+		u64 v64;
+		u32 v32[2];
+	} d = { dividend };
+	u32 upper;
+
+	upper = d.v32[1];
+	if (upper) {
+		upper = d.v32[1] % divisor;
+		d.v32[1] = d.v32[1] / divisor;
+	}
+	asm ("divl %2" : "=a" (d.v32[0]), "=d" (*remainder) :
+		"rm" (divisor), "0" (d.v32[0]), "1" (upper));
+	return d.v64;
+}
+#define div_u64_rem	div_u64_rem
+
 extern uint64_t div64_64(uint64_t dividend, uint64_t divisor);
+
 #endif
Index: linux-2.6/include/linux/calc64.h
===================================================================
--- linux-2.6.orig/include/linux/calc64.h
+++ linux-2.6/include/linux/calc64.h
@@ -46,4 +46,32 @@ static inline long div_long_long_rem_sig
 	return res;
 }
 
+#ifndef div_u64_rem
+static inline u64 div_u64_rem(u64 dividend, u32 divisor, u32 *remainder)
+{
+	*remainder = do_div(dividend, divisor);
+	return dividend;
+}
+#endif
+
+#ifndef div_u64
+static inline u64 div_u64(u64 dividend, u32 divisor)
+{
+	u32 remainder;
+	return div_u64_rem(dividend, divisor, &remainder);
+}
+#endif
+
+#ifndef div_s64_rem
+extern s64 div_s64_rem(s64 dividend, s32 divisor, s32 *remainder);
+#endif
+
+#ifndef div_s64
+static inline s64 div_s64(s64 dividend, s32 divisor)
+{
+	s32 remainder;
+	return div_s64_rem(dividend, divisor, &remainder);
+}
+#endif
+
 #endif
Index: linux-2.6/kernel/time.c
===================================================================
--- linux-2.6.orig/kernel/time.c
+++ linux-2.6/kernel/time.c
@@ -661,9 +661,7 @@ clock_t jiffies_to_clock_t(long x)
 #if (TICK_NSEC % (NSEC_PER_SEC / USER_HZ)) == 0
 	return x / (HZ / USER_HZ);
 #else
-	u64 tmp = (u64)x * TICK_NSEC;
-	do_div(tmp, (NSEC_PER_SEC / USER_HZ));
-	return (long)tmp;
+	return div_u64((u64)x * TICK_NSEC, NSEC_PER_SEC / USER_HZ);
 #endif
 }
 EXPORT_SYMBOL(jiffies_to_clock_t);
@@ -675,16 +673,12 @@ unsigned long clock_t_to_jiffies(unsigne
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
@@ -692,17 +686,15 @@ EXPORT_SYMBOL(clock_t_to_jiffies);
 u64 jiffies_64_to_clock_t(u64 x)
 {
 #if (TICK_NSEC % (NSEC_PER_SEC / USER_HZ)) == 0
-	do_div(x, HZ / USER_HZ);
+	return div_u64(x, HZ / USER_HZ);
 #else
 	/*
 	 * There are better ways that don't overflow early,
 	 * but even this doesn't overflow in hundreds of years
 	 * in 64 bits, so..
 	 */
-	x *= TICK_NSEC;
-	do_div(x, (NSEC_PER_SEC / USER_HZ));
+	return div_u64(x * TICK_NSEC, NSEC_PER_SEC / USER_HZ);
 #endif
-	return x;
 }
 
 EXPORT_SYMBOL(jiffies_64_to_clock_t);
@@ -710,21 +702,17 @@ EXPORT_SYMBOL(jiffies_64_to_clock_t);
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
--- linux-2.6.orig/kernel/time/ntp.c
+++ linux-2.6/kernel/time/ntp.c
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
@@ -197,7 +195,7 @@ void __attribute__ ((weak)) notify_arch_
 int do_adjtimex(struct timex *txc)
 {
 	long mtemp, save_adjust, rem;
-	s64 freq_adj, temp64;
+	s64 freq_adj;
 	int result;
 
 	/* In order to modify anything, you gotta be super-user! */
@@ -300,17 +298,8 @@ int do_adjtimex(struct timex *txc)
 		    freq_adj = time_offset * mtemp;
 		    freq_adj = shift_right(freq_adj, time_constant * 2 +
 					   (SHIFT_PLL + 2) * 2 - SHIFT_NSEC);
-		    if (mtemp >= MINSEC && (time_status & STA_FLL || mtemp > MAXSEC)) {
-			temp64 = time_offset << (SHIFT_NSEC - SHIFT_FLL);
-			if (time_offset < 0) {
-			    temp64 = -temp64;
-			    do_div(temp64, mtemp);
-			    freq_adj -= temp64;
-			} else {
-			    do_div(temp64, mtemp);
-			    freq_adj += temp64;
-			}
-		    }
+		    if (mtemp >= MINSEC && (time_status & STA_FLL || mtemp > MAXSEC))
+			freq_adj += div_s64(time_offset << (SHIFT_NSEC - SHIFT_FLL), mtemp);
 		    freq_adj += time_freq;
 		    freq_adj = min(freq_adj, (s64)MAXFREQ_NSEC);
 		    time_freq = max(freq_adj, (s64)-MAXFREQ_NSEC);
Index: linux-2.6/lib/div64.c
===================================================================
--- linux-2.6.orig/lib/div64.c
+++ linux-2.6/lib/div64.c
@@ -18,7 +18,7 @@
 
 #include <linux/types.h>
 #include <linux/module.h>
-#include <asm/div64.h>
+#include <linux/calc64.h>
 
 /* Not needed on 64bit architectures */
 #if BITS_PER_LONG == 32
@@ -78,4 +78,23 @@ uint64_t div64_64(uint64_t dividend, uin
 }
 EXPORT_SYMBOL(div64_64);
 
+#ifndef div_s64_rem
+s64 div_s64_rem(s64 dividend, s32 divisor, s32 *remainder)
+{
+	u64 quotient;
+
+	if (dividend < 0) {
+		quotient = div_u64_rem(-dividend, abs(divisor), (u32 *)remainder);
+		*remainder = -*remainder;
+		if (divisor > 0)
+			quotient = -quotient;
+	} else {
+		quotient = div_u64_rem(dividend, abs(divisor), (u32 *)remainder);
+		if (divisor < 0)
+			quotient = -quotient;
+	}
+	return quotient;
+}
+#endif
+
 #endif /* BITS_PER_LONG == 32 */
