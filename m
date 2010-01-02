Return-Path: <linux-kernel-owner+w=401wt.eu-S1751568Ab0ABSqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751568Ab0ABSqY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 13:46:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751202Ab0ABSqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 13:46:23 -0500
Received: from casper.infradead.org ([85.118.1.10]:43900 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab0ABSqW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 13:46:22 -0500
Date: Sat, 2 Jan 2010 10:48:53 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] timer: Introduce mod_timer_msec()
Message-ID: <20100102104853.28505e39@infradead.org>
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

>From 247f568d09e22fb5041f49b23bf2d5414c1299db Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sat, 2 Jan 2010 10:37:57 -0800
Subject: [PATCH] timer: Introduce mod_timer_msec()

It is a common paradigm in drivers to want to set/change a timer
for a relative amount of milliseconds.

This patch adds a mod_timer_msec() API function to make this easier
and to remove the awareness of both "jiffies" and the HZ value from
various drivers that don't care about such implementation detail.

Conversion of various users of the API are done in separate patches
that will go via the various maintainers separately.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 include/linux/timer.h |    1 +
 kernel/timer.c        |   20 ++++++++++++++++++++
 2 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/include/linux/timer.h b/include/linux/timer.h
index a2d1eb6..763f58f 100644
--- a/include/linux/timer.h
+++ b/include/linux/timer.h
@@ -162,6 +162,7 @@ static inline int timer_pending(const struct timer_list * timer)
 extern void add_timer_on(struct timer_list *timer, int cpu);
 extern int del_timer(struct timer_list * timer);
 extern int mod_timer(struct timer_list *timer, unsigned long expires);
+extern int mod_timer_msec(struct timer_list *timer, unsigned long delay_ms);
 extern int mod_timer_pending(struct timer_list *timer, unsigned long expires);
 extern int mod_timer_pinned(struct timer_list *timer, unsigned long expires);
 
diff --git a/kernel/timer.c b/kernel/timer.c
index 15533b7..c061cc2 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -749,6 +749,26 @@ int mod_timer(struct timer_list *timer, unsigned long expires)
 EXPORT_SYMBOL(mod_timer);
 
 /**
+ * mod_timer_msec - modify a timer's timeout, using relative milliseconds
+ * @timer: the timer to be modified
+ * @delay_ms: the desired minimum delay in milliseconds
+ *
+ * Changes the timeout of a timer similar to mod_timer().
+ *
+ * mod_timer_msec() takes relative milliseconds rather than absolute
+ * jiffies as argument.
+ *
+ * The function returns whether it has modified a pending timer or not.
+ * (ie. mod_timer_msec() of an inactive timer returns 0, mod_timer_msec() of
+ * an active timer returns 1.)
+ */
+int mod_timer_msec(struct timer_list *timer, unsigned long delay_ms)
+{
+	return mod_timer(timer, msecs_to_jiffies(delay_ms));
+}
+EXPORT_SYMBOL(mod_timer_msec);
+
+/**
  * mod_timer_pinned - modify a timer's timeout
  * @timer: the timer to be modified
  * @expires: new timeout in jiffies
-- 
1.6.2.5



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
