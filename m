Return-Path: <linux-kernel-owner+w=401wt.eu-S1753314AbYGUPxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314AbYGUPxd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 11:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751748AbYGUPxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 11:53:16 -0400
Received: from linux-m68k.xs4all.nl ([82.95.193.92]:48235 "EHLO
	scrub.xs4all.nl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751509AbYGUPxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 11:53:15 -0400
Message-Id: <20080721030306.837057486@linux-m68k.org>
References: <20080721030005.559625052@linux-m68k.org>
User-Agent: quilt/0.46-1
Date: Mon, 21 Jul 2008 05:00:06 +0200
From: zippel@linux-m68k.org
To: akpm@linux-foundation.org
Cc: johnstul@us.ibm.com, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] clocksource: keep track of original clocksource frequency
Content-Disposition: inline; filename=clocksource_mult_orig
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Stultz <johnstul@us.ibm.com>

The clocksource frequency is represented by
clocksource->mult/2^(clocksource->shift).  Currently, when NTP makes
adjustments to the clock frequency, they are made directly to the mult value.

This has the drawback that once changed, we cannot know what the orignal mult
value was, or how much adjustment has been applied.

This property causes problems in calculating proper ntp intervals when
switching back and forth between clocksources.

This patch separates the current mult value into a mult and mult_orig pair. 
The mult_orig value stays constant, while the ntp clocksource adjustments are
done only to the mult value.

This allows for correct ntp interval calculation and additionally lays the
groundwork for a new notion of time, what I'm calling the monotonic-raw time,
which is introduced in a following patch.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Signed-off-by: Roman Zippel <zippel@linux-m68k.org>
---
 include/linux/clocksource.h |   11 +++++++----
 kernel/time/clocksource.c   |    3 +++
 kernel/time/jiffies.c       |    1 +
 3 files changed, 11 insertions(+), 4 deletions(-)

Index: linux-2.6/include/linux/clocksource.h
===================================================================
--- linux-2.6.orig/include/linux/clocksource.h
+++ linux-2.6/include/linux/clocksource.h
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
+	u32 mult_orig;
 	u32 shift;
 	unsigned long flags;
 	cycle_t (*vread)(void);
@@ -201,16 +203,17 @@ static inline void clocksource_calculate
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
 
Index: linux-2.6/kernel/time/clocksource.c
===================================================================
--- linux-2.6.orig/kernel/time/clocksource.c
+++ linux-2.6/kernel/time/clocksource.c
@@ -325,6 +325,9 @@ int clocksource_register(struct clocksou
 	unsigned long flags;
 	int ret;
 
+	/* save mult_orig on registration */
+	c->mult_orig = c->mult;
+
 	spin_lock_irqsave(&clocksource_lock, flags);
 	ret = clocksource_enqueue(c);
 	if (!ret)
Index: linux-2.6/kernel/time/jiffies.c
===================================================================
--- linux-2.6.orig/kernel/time/jiffies.c
+++ linux-2.6/kernel/time/jiffies.c
@@ -61,6 +61,7 @@ struct clocksource clocksource_jiffies =
 	.read		= jiffies_read,
 	.mask		= 0xffffffff, /*32bits*/
 	.mult		= NSEC_PER_JIFFY << JIFFIES_SHIFT, /* details above */
+	.mult_orig	= NSEC_PER_JIFFY << JIFFIES_SHIFT,
 	.shift		= JIFFIES_SHIFT,
 };
 

-- 

