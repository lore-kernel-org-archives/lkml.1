Return-Path: <linux-kernel-owner+w=401wt.eu-S932590AbXAaDkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932590AbXAaDkJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 22:40:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932594AbXAaDj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 22:39:59 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:65268 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932573AbXAaDiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 22:38:55 -0500
Message-Id: <20070131033806.795135512@mvista.com>
References: <20070131033710.420168478@mvista.com>
User-Agent: quilt/0.46.mv-1
Date: Tue, 30 Jan 2007 19:37:22 -0800
From: Daniel Walker <dwalker@mvista.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, johnstul@us.ibm.com
Subject: [PATCH 12/23] clocksource: add clocksource_get_clock()
Content-Disposition: inline; filename=clocksource_add_get_clock.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

One new API call clocksource_get_clock() which allows clocks to be selected
based on their name, or if the name is null the highest rated clock is returned.

Signed-Off-By: Daniel Walker <dwalker@mvista.com>

---
 include/linux/clocksource.h |   12 ++++++++++++
 kernel/time/clocksource.c   |   18 ++++++++++++++++++
 2 files changed, 30 insertions(+)

Index: linux-2.6.19/include/linux/clocksource.h
===================================================================
--- linux-2.6.19.orig/include/linux/clocksource.h
+++ linux-2.6.19/include/linux/clocksource.h
@@ -234,6 +234,18 @@ static inline void clocksource_calculate
 extern struct clocksource *clocksource_get_next(void);
 extern int clocksource_register(struct clocksource*);
 extern void clocksource_rating_change(struct clocksource*);
+extern struct clocksource * clocksource_get_clock(char*);
+
+/**
+ * clocksource_get_best_clock - Finds highest rated clocksource
+ *
+ * Returns the highest rated clocksource. If none are register the
+ * jiffies clock is returned.
+ */
+static inline struct clocksource * clocksource_get_best_clock(void)
+{
+	return clocksource_get_clock(NULL);
+}
 
 #ifdef CONFIG_GENERIC_TIME_VSYSCALL
 extern void update_vsyscall(struct timespec *ts, struct clocksource *c);
Index: linux-2.6.19/kernel/time/clocksource.c
===================================================================
--- linux-2.6.19.orig/kernel/time/clocksource.c
+++ linux-2.6.19/kernel/time/clocksource.c
@@ -132,6 +132,24 @@ static inline struct clocksource * __get
 }
 
 /**
+ * clocksource_get_clock - Finds a specific clocksource
+ * @name:		name of the clocksource to return
+ *
+ * Returns the clocksource if registered, zero otherwise.
+ */
+struct clocksource * clocksource_get_clock(char * name)
+{
+	struct clocksource * ret;
+	unsigned long flags;
+
+	spin_lock_irqsave(&clocksource_lock, flags);
+	ret = __get_clock(name);
+	spin_unlock_irqrestore(&clocksource_lock, flags);
+	return ret;
+}
+
+
+/**
  * select_clocksource - Finds the best registered clocksource.
  *
  * Private function. Must hold clocksource_lock when called.

-- 
