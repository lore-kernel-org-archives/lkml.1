Return-Path: <linux-kernel-owner+w=401wt.eu-S1754357Ab0AIVfE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357Ab0AIVfE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 16:35:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754120Ab0AIVfD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 16:35:03 -0500
Received: from casper.infradead.org ([85.118.1.10]:56008 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105Ab0AIVfA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 16:35:00 -0500
Date: Sat, 9 Jan 2010 13:37:44 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: tglx@tglx.de, mingo@elte.hu, Cyrill Gorcunov <gorcunov@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, akpm@linux-foundation.org
Subject: [PATCH] timers: Introduce the concept of timer slack for legacy
 timers
Message-ID: <20100109133744.29829988@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From d3bc98c6d3dbb202aeed9719cd6fc215907907e7 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sat, 9 Jan 2010 13:30:38 -0800
Subject: [PATCH] timers: Introduce the concept of timer slack for legacy timers

While HR timers have had the concept of timer slack for quite some time
now, the legacy timers lacked this concept, and had to make do with
round_jiffies() and friends.

Timer slack is important for power management; grouping timers reduces
the number of wakeups which in turn reduces power consumption.

This patch introduces timer slack to the legacy timers using the following
pieces:
* A slack field in the timer struct
* An api (set_timer_slack) that callers can use to set explicit timer slack
* A default slack of 0.4% of the requested delay for callers that do not set
  any explicit slack
* Rounding code that is part of mod_timer() that tries to
  group timers around jiffies values every 'power of two'
  (so quick timers will group around every 2, but longer timers
  will group around every 4, 8, 16, 32 etc)

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 include/linux/timer.h |   10 +++++++-
 kernel/timer.c        |   56 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 65 insertions(+), 1 deletions(-)

diff --git a/include/linux/timer.h b/include/linux/timer.h
index 763f58f..ea074d7 100644
--- a/include/linux/timer.h
+++ b/include/linux/timer.h
@@ -10,13 +10,19 @@
 struct tvec_base;
 
 struct timer_list {
+	/*
+	 * All fields that change during normal runtime grouped to the
+	 * same cacheline
+	 */
 	struct list_head entry;
 	unsigned long expires;
+	struct tvec_base *base;
 
 	void (*function)(unsigned long);
 	unsigned long data;
 
-	struct tvec_base *base;
+	int slack;
+
 #ifdef CONFIG_TIMER_STATS
 	void *start_site;
 	char start_comm[16];
@@ -166,6 +172,8 @@ extern int mod_timer_msec(struct timer_list *timer, unsigned long delay_ms);
 extern int mod_timer_pending(struct timer_list *timer, unsigned long expires);
 extern int mod_timer_pinned(struct timer_list *timer, unsigned long expires);
 
+extern void set_timer_slack(struct timer_list *time, int slack_hz);
+
 #define TIMER_NOT_PINNED	0
 #define TIMER_PINNED		1
 /*
diff --git a/kernel/timer.c b/kernel/timer.c
index 0efd9fa..c252e3f 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -318,6 +318,24 @@ unsigned long round_jiffies_up_relative(unsigned long j)
 }
 EXPORT_SYMBOL_GPL(round_jiffies_up_relative);
 
+/**
+ * set_timer_slack - set the allowed slack for a timer
+ * @slack_hz: the amount of time (in jiffies) allowed for rounding
+ *
+ * Set the amount of time, in jiffies, that a certain timer has
+ * in terms of slack. By setting this value, the timer subsystem
+ * will schedule the actual timer somewhere between
+ * the time mod_timer() asks for, and that time plus the slack.
+ *
+ * By setting the slack to -1, a percentage of the delay is used
+ * instead.
+ */
+void set_timer_slack(struct timer_list *timer, int slack_hz)
+{
+	timer->slack = slack_hz;
+}
+EXPORT_SYMBOL_GPL(set_timer_slack);
+
 
 static inline void set_running_timer(struct tvec_base *base,
 					struct timer_list *timer)
@@ -549,6 +567,7 @@ static void __init_timer(struct timer_list *timer,
 {
 	timer->entry.next = NULL;
 	timer->base = __raw_get_cpu_var(tvec_bases);
+	timer->slack = -1;
 #ifdef CONFIG_TIMER_STATS
 	timer->start_site = NULL;
 	timer->start_pid = -1;
@@ -714,6 +733,41 @@ int mod_timer_pending(struct timer_list *timer, unsigned long expires)
 }
 EXPORT_SYMBOL(mod_timer_pending);
 
+/*
+ * Decide where to put the timer while taking the slack into account
+ *
+ * Algorithm:
+ *   1) calculate the maximum (absolute) time
+ *   2) calculate the highest bit where the expires and new max are different
+ *   3) use this bit to make a mask
+ *   4) use the bitmask to round down the maximum time, so that all last
+ *      bits are zeros
+ */
+static inline
+unsigned long apply_slack(struct timer_list *timer, unsigned long expires)
+{
+	unsigned long expires_limit, mask;
+	int bit;
+
+	expires_limit = expires + timer->slack;
+
+	if (timer->slack < 0) /* auto slack: use 0.4% */
+		expires_limit = expires + (expires - jiffies)/256;
+
+	mask = expires ^ expires_limit;
+
+	if (mask == 0)
+		return expires;
+
+	bit = find_last_bit(&mask, BITS_PER_LONG);
+
+	mask = (1 << bit) - 1;
+
+	expires_limit = expires_limit & ~(mask);
+
+	return expires_limit;
+}
+
 /**
  * mod_timer - modify a timer's timeout
  * @timer: the timer to be modified
@@ -744,6 +798,8 @@ int mod_timer(struct timer_list *timer, unsigned long expires)
 	if (timer_pending(timer) && timer->expires == expires)
 		return 1;
 
+	expires = apply_slack(timer, expires);
+
 	return __mod_timer(timer, expires, false, TIMER_NOT_PINNED);
 }
 EXPORT_SYMBOL(mod_timer);
-- 
1.6.2.5



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
