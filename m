Return-Path: <linux-kernel-owner+w=401wt.eu-S1756261AbZHNGF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261AbZHNGF0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 02:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756000AbZHNGFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 02:05:25 -0400
Received: from www.tglx.de ([62.245.132.106]:36756 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756252AbZHNGFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 02:05:22 -0400
Date: Fri, 14 Aug 2009 08:05:10 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Suresh Siddha <suresh.b.siddha@intel.com>
cc: mingo@elte.hu, hpa@zytor.com, linux-kernel@vger.kernel.org,
       venkatesh.pallipadi@intel.com, len.brown@intel.com
Subject: Re: [patch] clockevents_notify() need to be called with irq's
 enabled
In-Reply-To: <1250203681.27006.10842.camel@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0908140753370.1283@localhost.localdomain>
References: <1250203681.27006.10842.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Aug 2009, Suresh Siddha wrote:

> From: Suresh Siddha <suresh.b.siddha@intel.com>
> Subject: clockevents_notify() need to be called with irq's enabled
> 
> Currently clockevents_notify() is called with interrupts enabled at some
> places and interrupts disabled at some other places.

The only place I can see which calls clockevents_notify with
interrupts enabled is the hrtimer cpu hotplug code.

I'm a bit wary to enable interrupts all over the place in sensitive
corners like ACPI idle code ...

Why don't we just do the obvious and take clockevents_lock irqsave ?

Thanks,

	tglx
---
diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index a6dcd67..e43c4b6 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -137,11 +137,12 @@ int clockevents_program_event(struct clock_event_device *dev, ktime_t expires,
  */
 int clockevents_register_notifier(struct notifier_block *nb)
 {
+	unsigned long flags;
 	int ret;
 
-	spin_lock(&clockevents_lock);
+	spin_lock_irqsave(&clockevents_lock, flags);
 	ret = raw_notifier_chain_register(&clockevents_chain, nb);
-	spin_unlock(&clockevents_lock);
+	spin_unlock_irqrestore(&clockevents_lock, flags);
 
 	return ret;
 }
@@ -181,13 +182,13 @@ void clockevents_register_device(struct clock_event_device *dev)
 	BUG_ON(dev->mode != CLOCK_EVT_MODE_UNUSED);
 	BUG_ON(!dev->cpumask);
 
-	spin_lock(&clockevents_lock);
+	spin_lock_irqsave(&clockevents_lock, flags);
 
 	list_add(&dev->list, &clockevent_devices);
 	clockevents_do_notify(CLOCK_EVT_NOTIFY_ADD, dev);
 	clockevents_notify_released();
 
-	spin_unlock(&clockevents_lock);
+	spin_lock_irqrestore(&clockevents_lock, flags);
 }
 EXPORT_SYMBOL_GPL(clockevents_register_device);
 
@@ -235,8 +236,9 @@ void clockevents_exchange_device(struct clock_event_device *old,
 void clockevents_notify(unsigned long reason, void *arg)
 {
 	struct list_head *node, *tmp;
+	unsigned long flags;
 
-	spin_lock(&clockevents_lock);
+	spin_lock_irqsave(&clockevents_lock, flags);
 	clockevents_do_notify(reason, arg);
 
 	switch (reason) {
@@ -251,7 +253,7 @@ void clockevents_notify(unsigned long reason, void *arg)
 	default:
 		break;
 	}
-	spin_unlock(&clockevents_lock);
+	spin_unlock_irqrestore(&clockevents_lock, flags);
 }
 EXPORT_SYMBOL_GPL(clockevents_notify);
 #endif



 
