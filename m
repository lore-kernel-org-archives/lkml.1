Return-Path: <linux-kernel-owner+w=401wt.eu-S1756661AbYLKLvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661AbYLKLvO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 06:51:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754908AbYLKLu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 06:50:58 -0500
Received: from rv-out-0506.google.com ([209.85.198.230]:3602 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754790AbYLKLu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 06:50:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=a322QCXxj/gqWiUE2S9QyqFhKOlQ51OlBB3A5T5FQXB9qtDRdSWSBkjBxe8F+lS7Ve
         k5GbP5y3pBW59ze4coeYWmJh3f7s6Ce2vIbSI62FuOD7r2D+LpZJk0md1/UtZxChcgRQ
         LgXGiFc864SPFq2FXRQFxYa6I6WfNYIEjXqTs=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, johnstul@us.ibm.com, lethal@linux-sh.org,
       tglx@linutronix.de, Magnus Damm <magnus.damm@gmail.com>,
       mingo@redhat.com
Date: Thu, 11 Dec 2008 20:49:09 +0900
Message-Id: <20081211114909.17624.85712.sendpatchset@rx1.opensource.se>
Subject: [PATCH] clocksource: add enable() and disable() callbacks
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@igel.co.jp>

Add enable() and disable() callbacks for clocksources. This allows
us to put unused clocksources in power save mode. The functions
clocksource_enable() and clocksource_disable() wrap the callbacks
and are inserted in the timekeeping code to enable before use and
disable after switching to a new clocksource.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
Acked-by: John Stultz <johnstul@us.ibm.com>
---

 Same as before, but applies on top of the new read() patch.

 include/linux/clocksource.h |   31 +++++++++++++++++++++++++++++++
 kernel/time/timekeeping.c   |   12 +++++++++---
 2 files changed, 40 insertions(+), 3 deletions(-)

--- 0005/include/linux/clocksource.h
+++ work/include/linux/clocksource.h	2008-12-11 19:52:25.000000000 +0900
@@ -43,6 +43,8 @@ struct clocksource;
  *				The ideal clocksource. A must-use where
  *				available.
  * @read:		returns a cycle value, passes clocksource as argument
+ * @enable:		optional function to enable the clocksource
+ * @disable:		optional function to disable the clocksource
  * @mask:		bitmask for two's complement
  *			subtraction of non 64 bit counters
  * @mult:		cycle to nanosecond multiplier (adjusted by NTP)
@@ -62,6 +64,8 @@ struct clocksource {
 	struct list_head list;
 	int rating;
 	cycle_t (*read)(struct clocksource *cs);
+	int (*enable)(struct clocksource *cs);
+	void (*disable)(struct clocksource *cs);
 	cycle_t mask;
 	u32 mult;
 	u32 mult_orig;
@@ -174,6 +178,33 @@ static inline cycle_t clocksource_read(s
 }
 
 /**
+ * clocksource_enable: - enable clocksource
+ * @cs:		pointer to clocksource
+ *
+ * Enables the specified clocksource. The clocksource callback
+ * function should start up the hardware and setup mult and field
+ * members of struct clocksource to reflect hardware capabilities.
+ */
+static inline int clocksource_enable(struct clocksource *cs)
+{
+	return cs->enable ? cs->enable(cs) : 0;
+}
+
+/**
+ * clocksource_disable: - disable clocksource
+ * @cs:		pointer to clocksource
+ *
+ * Disables the specified clocksource. The clocksource callback
+ * function should power down the now unused hardware block to
+ * save power.
+ */
+static inline void clocksource_disable(struct clocksource *cs)
+{
+	if (cs->disable)
+		cs->disable(cs);
+}
+
+/**
  * cyc2ns - converts clocksource cycles to nanoseconds
  * @cs:		Pointer to clocksource
  * @cycles:	Cycles
--- 0004/kernel/time/timekeeping.c
+++ work/kernel/time/timekeeping.c	2008-12-11 19:51:16.000000000 +0900
@@ -184,7 +184,7 @@ EXPORT_SYMBOL(do_settimeofday);
  */
 static void change_clocksource(void)
 {
-	struct clocksource *new;
+	struct clocksource *new, *old;
 
 	new = clocksource_get_next();
 
@@ -193,11 +193,16 @@ static void change_clocksource(void)
 
 	clocksource_forward_now();
 
-	new->raw_time = clock->raw_time;
+	if (clocksource_enable(new))
+		return;
 
+	new->raw_time = clock->raw_time;
+	old = clock;
 	clock = new;
+	clocksource_disable(old);
+
 	clock->cycle_last = 0;
-	clock->cycle_last = clocksource_read(new);
+	clock->cycle_last = clocksource_read(clock);
 	clock->error = 0;
 	clock->xtime_nsec = 0;
 	clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
@@ -293,6 +298,7 @@ void __init timekeeping_init(void)
 	ntp_init();
 
 	clock = clocksource_get_next();
+	clocksource_enable(clock);
 	clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
 	clock->cycle_last = clocksource_read(clock);
 
