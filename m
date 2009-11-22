Return-Path: <linux-kernel-owner+w=401wt.eu-S1755847AbZKVXjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847AbZKVXjT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 18:39:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755758AbZKVXjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 18:39:18 -0500
Received: from casper.infradead.org ([85.118.1.10]:40278 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755732AbZKVXjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 18:39:18 -0500
Date: Sun, 22 Nov 2009 15:41:11 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, alan@linux.intel.com
Subject: [patch] timer: Add a mod_timer_msec() API function
Message-ID: <20091122154111.197e1a8a@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: timer: add a mod_timer_msec() API function
From: Arjan van de Ven <arjan@linux.intel.com>

There is a common pattern in the kernel, where the caller wants
to set a timer a specified number of milliseconds into the future.

The typical solution then ends up

mod_timer(&timer, jiffies + msecs_to_jiffies(msec_amount));

or

mod_timer(&timer, jiffies + HZ/some_value);

This patch aims to simplify this pattern for the caller, and at
the same time, make for a more power-friendly API.

The new pattern for identical behavior will be

mod_timer_msec(&timer, msec_amount, 0);

while

mod_timer_msec(&time, msec_amount, 100);

would give the kernel 100 milliseconds of slack to find a power
friendly time to group timers into one CPU wakeup.

A patch to convert a number of users, to show how the API is used,
will be sent as reply to this email.


Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

diff --git a/include/linux/timer.h b/include/linux/timer.h
index a2d1eb6..006d4da 100644
--- a/include/linux/timer.h
+++ b/include/linux/timer.h
@@ -162,6 +162,7 @@ static inline int timer_pending(const struct timer_list * timer)
 extern void add_timer_on(struct timer_list *timer, int cpu);
 extern int del_timer(struct timer_list * timer);
 extern int mod_timer(struct timer_list *timer, unsigned long expires);
+extern int mod_timer_msec(struct timer_list *timer, unsigned long delay_ms, unsigned long slack_ms);
 extern int mod_timer_pending(struct timer_list *timer, unsigned long expires);
 extern int mod_timer_pinned(struct timer_list *timer, unsigned long expires);
 
diff --git a/kernel/timer.c b/kernel/timer.c
index 5db5a8d..c9d5cbf 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -751,6 +751,47 @@ int mod_timer(struct timer_list *timer, unsigned long expires)
 EXPORT_SYMBOL(mod_timer);
 
 /**
+ * mod_timer_msec - modify a timer's timeout, using relative milliseconds
+ * @timer: the timer to be modified
+ * @delay_ms: the desired minimum delay in milliseconds
+ * @slack_ms: the amount of slack is ok in firing the timer
+ *
+ * Changes the timeout of a timer similar to mod_timer().
+ *
+ * mod_timer_msec() takes relative milliseconds rather than absolute
+ * jiffies as argument and also takes a "slack" amount, which is
+ * an explicit permission to treat the time of the timer as less
+ * precise in order to allow grouping of timers.
+ *
+ * The function returns whether it has modified a pending timer or not.
+ * (ie. mod_timer() of an inactive timer returns 0, mod_timer() of an
+ * active timer returns 1.)
+ */
+int mod_timer_msec(struct timer_list *timer, unsigned long delay_ms, unsigned long slack_ms)
+{
+	unsigned long next_jiffies, max_jiffies;
+	unsigned long rounded_jiffies;
+
+	next_jiffies = jiffies + msecs_to_jiffies(delay_ms);
+	max_jiffies = jiffies + msecs_to_jiffies(delay_ms + slack_ms);
+	rounded_jiffies = round_jiffies(next_jiffies);
+
+	/* check if rounding up next_jiffies is within the max */
+	if (rounded_jiffies <= max_jiffies && rounded_jiffies >= next_jiffies) {
+		next_jiffies = rounded_jiffies;
+	} else {
+		/* regular rounding failed; try a rounding to multiple-of-16 */
+		rounded_jiffies = (next_jiffies + 15) & ~0xF;
+		if (rounded_jiffies <= max_jiffies)
+			next_jiffies = rounded_jiffies;
+	}
+
+	return mod_timer(timer, next_jiffies);
+}
+EXPORT_SYMBOL_GPL(mod_timer_msec);
+
+
+/**
  * mod_timer_pinned - modify a timer's timeout
  * @timer: the timer to be modified
  * @expires: new timeout in jiffies


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
