Return-Path: <linux-kernel-owner+w=401wt.eu-S933022AbXAWFyL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933022AbXAWFyL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 00:54:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933021AbXAWFx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 00:53:57 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:2717 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933022AbXAWFxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 00:53:48 -0500
Message-Id: <20070123055347.343994209@mvista.com>
References: <20070123055255.338254780@mvista.com>
User-Agent: quilt/0.46.mv-1
Date: Mon, 22 Jan 2007 21:53:04 -0800
From: Daniel Walker <dwalker@mvista.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 09/12] clocksource: initialize list value
Content-Disposition: inline; filename=clocksource_list_init.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A change to clocksource initialization. If the list field is initialized 
it allows clocksource_register to complete faster since it doesn't have 
to scan the list of clocks doing strcmp on each looking for duplicates.

Signed-Off-By: Daniel Walker <dwalker@mvista.com>

---
 kernel/time/clocksource.c |    3 +--
 kernel/time/jiffies.c     |    1 +
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.19/kernel/time/clocksource.c
===================================================================
--- linux-2.6.19.orig/kernel/time/clocksource.c
+++ linux-2.6.19/kernel/time/clocksource.c
@@ -186,12 +186,11 @@ int clocksource_register(struct clocksou
 	unsigned long flags;
 
 	spin_lock_irqsave(&clocksource_lock, flags);
-	if (unlikely(!list_empty(&c->list) && __is_registered(c->name))) {
+	if (unlikely(!list_empty(&c->list))) {
 		printk("register_clocksource: Cannot register %s clocksource. "
 		       "Already registered!", c->name);
 		ret = -EBUSY;
 	} else {
-		INIT_LIST_HEAD(&c->list);
  		__sorted_list_add(c);
 		/* scan the registered clocksources, and pick the best one */
 		next_clocksource = select_clocksource();
Index: linux-2.6.19/kernel/time/jiffies.c
===================================================================
--- linux-2.6.19.orig/kernel/time/jiffies.c
+++ linux-2.6.19/kernel/time/jiffies.c
@@ -63,6 +63,7 @@ struct clocksource clocksource_jiffies =
 	.mult		= NSEC_PER_JIFFY << JIFFIES_SHIFT, /* details above */
 	.shift		= JIFFIES_SHIFT,
 	.is_continuous	= 0, /* tick based, not free running */
+	.list		= LIST_HEAD_INIT(clocksource_jiffies.list),
 };
 
 static int __init init_jiffies_clocksource(void)

-- 
