Return-Path: <linux-kernel-owner+w=401wt.eu-S932130AbYDOVAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130AbYDOVAe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 17:00:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752947AbYDOVAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 17:00:24 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:54432 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421AbYDOVAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 17:00:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Y29FLdzYg6Mxks0e7BhPzlATpilTM+ItDTKnaxaoqxgRmuOkIxg2iz2O9+pX5mHQ+eLoa1PdbnbWUhH6diDd5p7LCXqWoambfBELbu++1zclh2unkeGJGx5u9RWTumAoBrzVALTtigDau0A0IYA4PFWQ4pK/dm9nfHAku5OnWLA=
Subject: [PATCH, cleanup] hrtimer: use div64_64() in ktime_divns()
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       dmitry.adamushko@gmail.com
Content-Type: text/plain
Date: Tue, 15 Apr 2008 23:00:20 +0200
Message-Id: <1208293220.5372.11.camel@earth>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ I apologize, the previous message was sent with a wrong subject. Fixed here ]


Unless I'm overlooking some subtle difference this change may simplify
code a bit.

---

From: Dmitry Adamushko <dmitry.adamushko@gmail.com>    
Subject: hrtimer: use div64_64() in ktime_divns()
    
ktime_divns() (as is now) re-implements the logic behind div64_64() so
let's just make use of div64_64().

Also add a few explicit type conversions for ktime_divns() callers.

Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>

---

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 1ad56a7..49888a9 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -20,6 +20,7 @@
 #include <linux/init.h>
 #include <linux/list.h>
 #include <linux/wait.h>
+#include <asm/div64.h>
 
 struct hrtimer_clock_base;
 struct hrtimer_cpu_base;
@@ -331,11 +332,10 @@ extern void hrtimer_run_pending(void);
 /* Bootup initialization: */
 extern void __init hrtimers_init(void);
 
-#if BITS_PER_LONG < 64
-extern u64 ktime_divns(const ktime_t kt, s64 div);
-#else /* BITS_PER_LONG < 64 */
-# define ktime_divns(kt, div)		(u64)((kt).tv64 / (div))
-#endif
+static inline u64 ktime_divns(const ktime_t kt, u64 div)
+{
+	return div64_64((u64)ktime_to_ns(kt), div);
+}
 
 /* Show pending timers: */
 extern void sysrq_timer_list_show(void);
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 98bee01..bfb0f94 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -252,8 +252,7 @@ lock_hrtimer_base(const struct hrtimer *timer, unsigned long *flags)
  * Functions for the union type storage format of ktime_t which are
  * too large for inlining:
  */
-#if BITS_PER_LONG < 64
-# ifndef CONFIG_KTIME_SCALAR
+#if BITS_PER_LONG < 64 && !defined(CONFIG_KTIME_SCALAR)
 /**
  * ktime_add_ns - Add a scalar nanoseconds value to a ktime_t variable
  * @kt:		addend
@@ -301,29 +300,7 @@ ktime_t ktime_sub_ns(const ktime_t kt, u64 nsec)
 }
 
 EXPORT_SYMBOL_GPL(ktime_sub_ns);
-# endif /* !CONFIG_KTIME_SCALAR */
-
-/*
- * Divide a ktime value by a nanosecond value
- */
-u64 ktime_divns(const ktime_t kt, s64 div)
-{
-	u64 dclc, inc, dns;
-	int sft = 0;
-
-	dclc = dns = ktime_to_ns(kt);
-	inc = div;
-	/* Make sure the divisor is less than 2^32: */
-	while (div >> 32) {
-		sft++;
-		div >>= 1;
-	}
-	dclc >>= sft;
-	do_div(dclc, (unsigned long) div);
-
-	return dclc;
-}
-#endif /* BITS_PER_LONG >= 64 */
+#endif /* BITS_PER_LONG >= 64 && !CONFIG_KTIME_SCALAR */
 
 /*
  * Add two ktime values and do a safety check for overflow:
@@ -698,7 +675,7 @@ u64 hrtimer_forward(struct hrtimer *timer, ktime_t now, ktime_t interval)
 		interval.tv64 = timer->base->resolution.tv64;
 
 	if (unlikely(delta.tv64 >= interval.tv64)) {
-		s64 incr = ktime_to_ns(interval);
+		u64 incr = (u64)ktime_to_ns(interval);
 
 		orun = ktime_divns(delta, incr);
 		timer->expires = ktime_add_ns(timer->expires, incr * orun);
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 686da82..d3098d3 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -60,9 +60,9 @@ static void tick_do_update_jiffies64(ktime_t now)
 
 		/* Slow path for long timeouts */
 		if (unlikely(delta.tv64 >= tick_period.tv64)) {
-			s64 incr = ktime_to_ns(tick_period);
+			u64 incr = (u64)ktime_to_ns(tick_period);
 
-			ticks = ktime_divns(delta, incr);
+			ticks = (unsigned long)ktime_divns(delta, incr);
 
 			last_jiffies_update = ktime_add_ns(last_jiffies_update,
 							   incr * ticks);


