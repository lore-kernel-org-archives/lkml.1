Return-Path: <linux-kernel-owner+w=401wt.eu-S932583AbXAaDjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932583AbXAaDjX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 22:39:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932587AbXAaDi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 22:38:57 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:65251 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932585AbXAaDis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 22:38:48 -0500
Message-Id: <20070131033805.498958666@mvista.com>
References: <20070131033710.420168478@mvista.com>
User-Agent: quilt/0.46.mv-1
Date: Tue, 30 Jan 2007 19:37:18 -0800
From: Daniel Walker <dwalker@mvista.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, johnstul@us.ibm.com
Subject: [PATCH 08/23] clocksource: drop duplicate register checking
Content-Disposition: inline; filename=clocksource_list_init.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is something Thomas already dropped, and I'm just sticking
with that .. If you register your clocksource _twice_ your kernel will
likely not work correctly (and might crash).

Signed-Off-By: Daniel Walker <dwalker@mvista.com>

---
 kernel/time/clocksource.c |   19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

Index: linux-2.6.19/kernel/time/clocksource.c
===================================================================
--- linux-2.6.19.orig/kernel/time/clocksource.c
+++ linux-2.6.19/kernel/time/clocksource.c
@@ -186,16 +186,12 @@ int clocksource_register(struct clocksou
 	unsigned long flags;
 
 	spin_lock_irqsave(&clocksource_lock, flags);
-	if (unlikely(!list_empty(&c->list) && __is_registered(c->name))) {
-		printk("register_clocksource: Cannot register %s clocksource. "
-		       "Already registered!", c->name);
-		ret = -EBUSY;
-	} else {
-		INIT_LIST_HEAD(&c->list);
- 		__sorted_list_add(c);
-		/* scan the registered clocksources, and pick the best one */
-		next_clocksource = select_clocksource();
-	}
+ 	__sorted_list_add(c);
+
+	/*
+	 * scan the registered clocksources, and pick the best one
+	 */
+	next_clocksource = select_clocksource();
 	spin_unlock_irqrestore(&clocksource_lock, flags);
 	return ret;
 }
@@ -212,9 +208,6 @@ void clocksource_rating_change(struct cl
 {
 	unsigned long flags;
 
-	if (unlikely(list_empty(&c->list)))
-		return;
-
   	spin_lock_irqsave(&clocksource_lock, flags);
 
 	/*

-- 
