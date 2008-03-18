Return-Path: <linux-kernel-owner+w=401wt.eu-S1758875AbYCSTrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758875AbYCSTrP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 15:47:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753351AbYCSTcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:32:19 -0400
Received: from over.ny.us.ibm.com ([32.97.182.150]:52910 "EHLO
	over.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755567AbYCSTcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:32:06 -0400
Subject: [PATCH 1/2] Keep track of original clocksource frequency
From: john stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Content-Type: text/plain
Date: Tue, 18 Mar 2008 15:11:19 -0700
Message-Id: <1205878279.28128.114.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's my earlier mult/adj split patch reworked as suggested by Roman to
instead just introduce mult_orig.

Andrew, if there are not major objections, could you add it to your
2.6.26 pending list?

thanks
-john


The clocksource frequency is represented by
clocksource->mult/2^(clocksource->shift). Currently, when NTP makes
adjustments to the clock frequency, they are made directly to the mult
value.

This has the drawback that once changed, we cannot know what the orignal
mult value was, or how much adjustment has been applied.

This property causes problems in calculating proper ntp intervals when
switching back and forth between clocksources. 

This patch separates the current mult value into a mult and mult_orig
pair. The mult_orig value stays constant, while the ntp clocksource
adjustments are done only to the mult value.

This allows for correct ntp interval calculation and additionally lays
the groundwork for a new notion of time, what I'm calling the
monotonic-raw time, which is introduced in a following patch.

Signed-off-by: John Stultz <johnstul@us.ibm.com>

diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index cde2b9f..b282b79 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -45,7 +45,8 @@ struct clocksource;
  * @read:		returns a cycle value
  * @mask:		bitmask for two's complement
  *			subtraction of non 64 bit counters
- * @mult:		cycle to nanosecond multiplier
+ * @mult:		cycle to nanosecond multiplier (adjusted by NTP)
+ * @mult_orig:		cycle to nanosecond multiplier (unadjusted by NTP)
  * @shift:		cycle to nanosecond divisor (power of two)
  * @flags:		flags describing special properties
  * @vread:		vsyscall based read
@@ -63,6 +64,7 @@ struct clocksource {
 	cycle_t (*read)(void);
 	cycle_t mask;
 	u32 mult;
+	s32 mult_orig;
 	u32 shift;
 	unsigned long flags;
 	cycle_t (*vread)(void);
@@ -201,16 +203,17 @@ static inline void clocksource_calculate_interval(struct clocksource *c,
 {
 	u64 tmp;
 
-	/* XXX - All of this could use a whole lot of optimization */
+	/* Do the ns -> cycle conversion first, using original mult */
 	tmp = length_nsec;
 	tmp <<= c->shift;
-	tmp += c->mult/2;
-	do_div(tmp, c->mult);
+	tmp += c->mult_orig/2;
+	do_div(tmp, c->mult_orig);
 
 	c->cycle_interval = (cycle_t)tmp;
 	if (c->cycle_interval == 0)
 		c->cycle_interval = 1;
 
+	/* Go back from cycles -> shifted ns, this time use ntp adjused mult */
 	c->xtime_interval = (u64)c->cycle_interval * c->mult;
 }
 
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 548c436..7a4a1b4 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -309,6 +309,9 @@ int clocksource_register(struct clocksource *c)
 	unsigned long flags;
 	int ret;
 
+	/* save mult_orig on registration */
+	c->mult_orig = c->mult;
+
 	spin_lock_irqsave(&clocksource_lock, flags);
 	ret = clocksource_enqueue(c);
 	if (!ret)
diff --git a/kernel/time/jiffies.c b/kernel/time/jiffies.c
index 4c256fd..1ca9955 100644
--- a/kernel/time/jiffies.c
+++ b/kernel/time/jiffies.c
@@ -61,6 +61,7 @@ struct clocksource clocksource_jiffies = {
 	.read		= jiffies_read,
 	.mask		= 0xffffffff, /*32bits*/
 	.mult		= NSEC_PER_JIFFY << JIFFIES_SHIFT, /* details above */
+	.mult_orig	= NSEC_PER_JIFFY << JIFFIES_SHIFT,
 	.shift		= JIFFIES_SHIFT,
 };
 


