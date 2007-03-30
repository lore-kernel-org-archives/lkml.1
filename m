Return-Path: <linux-kernel-owner+w=401wt.eu-S1751581AbXC3Sre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581AbXC3Sre (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 14:47:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751696AbXC3Sre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 14:47:34 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:1201 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751657AbXC3Srb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 14:47:31 -0400
Message-Id: <20070330184616.429016225@mvista.com>
References: <20070330184541.583153763@mvista.com>
User-Agent: quilt/0.46-1
Date: Fri, 30 Mar 2007 11:45:50 -0700
From: Daniel Walker <dwalker@mvista.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, johnstul@us.ibm.com
Content-Disposition: inline; filename=clocksource_use_inited_lists.patch
Subject: [PATCH 9/9] clocksource: refactor duplicate registration checking
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Refactors the duplicate registration checking. This makes it based on the
clocksource structure list state. I was able to drop some if statements
making the registration code path slightly smaller and faster, and remove
some looping which was endemic of the first version of this check.

Signed-Off-By: Daniel Walker <dwalker@mvista.com>

---
 include/linux/clocksource.h |    2 +-
 kernel/time/clocksource.c   |   30 ++++++++++++++++++------------
 kernel/time/jiffies.c       |    1 +
 3 files changed, 20 insertions(+), 13 deletions(-)

Index: linux-2.6.20/include/linux/clocksource.h
===================================================================
--- linux-2.6.20.orig/include/linux/clocksource.h
+++ linux-2.6.20/include/linux/clocksource.h
@@ -26,7 +26,7 @@ struct clocksource;
  *	Provides mostly state-free accessors to the underlying hardware.
  *
  * @name:		ptr to clocksource name
- * @list:		list head for registration
+ * @list:		list head for registration, must be initialized.
  * @rating:		rating value for selection (higher is better)
  *			To avoid rating inflation the following
  *			list should give you a guide as to how
Index: linux-2.6.20/kernel/time/clocksource.c
===================================================================
--- linux-2.6.20.orig/kernel/time/clocksource.c
+++ linux-2.6.20/kernel/time/clocksource.c
@@ -232,7 +232,7 @@ static struct clocksource *select_clocks
 /*
  * Enqueue the clocksource sorted by rating
  */
-static int clocksource_enqueue(struct clocksource *c)
+static void clocksource_enqueue(struct clocksource *c)
 {
 	struct list_head *tmp, *entry = &clocksource_list;
 
@@ -240,8 +240,7 @@ static int clocksource_enqueue(struct cl
 		struct clocksource *cs;
 
 		cs = list_entry(tmp, struct clocksource, list);
-		if (cs == c)
-			return -EBUSY;
+
 		/* Keep track of the place, where to insert */
 		if (cs->rating >= c->rating)
 			entry = tmp;
@@ -252,28 +251,35 @@ static int clocksource_enqueue(struct cl
 	    !strcmp(c->name, override_name))
 		clocksource_override = c;
 
-	return 0;
 }
 
 /**
  * clocksource_register - Used to install new clocksources
  * @t:		clocksource to be registered
  *
- * Returns -EBUSY if registration fails, zero otherwise.
+ * Always returns zero.
  */
 int clocksource_register(struct clocksource *c)
 {
 	unsigned long flags;
-	int ret;
+
+	/*
+	 * This BUGON indicates that either the clocksource has been
+	 * registered already, or the list element hasn't been properly
+	 * initialized.
+	 */
+	BUG_ON(!list_empty(&c->list));
 
 	spin_lock_irqsave(&clocksource_lock, flags);
-	ret = clocksource_enqueue(c);
-	if (!ret)
-		next_clocksource = select_clocksource();
+
+	clocksource_enqueue(c);
+	next_clocksource = select_clocksource();
+
 	spin_unlock_irqrestore(&clocksource_lock, flags);
-	if (!ret)
-		clocksource_check_watchdog(c);
-	return ret;
+
+	clocksource_check_watchdog(c);
+
+	return 0;
 }
 EXPORT_SYMBOL(clocksource_register);
 
Index: linux-2.6.20/kernel/time/jiffies.c
===================================================================
--- linux-2.6.20.orig/kernel/time/jiffies.c
+++ linux-2.6.20/kernel/time/jiffies.c
@@ -62,6 +62,7 @@ struct clocksource clocksource_jiffies =
 	.mask		= 0xffffffff, /*32bits*/
 	.mult		= NSEC_PER_JIFFY << JIFFIES_SHIFT, /* details above */
 	.shift		= JIFFIES_SHIFT,
+	.list		= LIST_HEAD_INIT(clocksource_jiffies.list),
 };
 
 static int __init init_jiffies_clocksource(void)

-- 
