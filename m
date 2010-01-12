Return-Path: <linux-kernel-owner+w=401wt.eu-S1753533Ab0ALNUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab0ALNUy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 08:20:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753071Ab0ALNUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 08:20:53 -0500
Received: from www.tglx.de ([62.245.132.106]:32791 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752367Ab0ALNUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 08:20:53 -0500
Date: Tue, 12 Jan 2010 14:20:26 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Xiaotian Feng <dfeng@redhat.com>
cc: linux-kernel@vger.kernel.org, Magnus Damm <damm@igel.co.jp>,
       H Hartley Sweeten <hsweeten@visionengravers.com>
Subject: Re: [PATCH] clockevent: don't remove broadcast device when cpu is
 dead
In-Reply-To: <1262834564-13033-1-git-send-email-dfeng@redhat.com>
Message-ID: <alpine.LFD.2.00.1001121300190.6420@localhost.localdomain>
References: <1262834564-13033-1-git-send-email-dfeng@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jan 2010, Xiaotian Feng wrote:

> Marc reported BUG during shutdown, after debugging, kernel is trying
> to remove a broadcast device which mode is CLOCK_EVT_MODE_ONESHOT.
> 
> The root cause for this bug is that in clockevents_notify,
> "cpumask_weight(dev->cpumask) == 1" is always true even if dev is a

Why is cpumask_weight(dev->cpumask) == 1 always true when we shutdown
a non boot cpu ?

The broadcast device is not a per cpu device and the cpumask should
not only contain the CPU which is shut down !

The patch is papering over the real problem.

Marc, can you please apply the following debug patch and provide the
dmesg outputs from boot and shutdown ?

Thanks,

	tglx
---

Index: linux-2.6-tip/kernel/time/clockevents.c
===================================================================
--- linux-2.6-tip.orig/kernel/time/clockevents.c
+++ linux-2.6-tip/kernel/time/clockevents.c
@@ -186,7 +186,7 @@ void clockevents_register_device(struct 
 	BUG_ON(!dev->cpumask);
 
 	raw_spin_lock_irqsave(&clockevents_lock, flags);
-
+	printk(KERN_ERR "CE register %p %s\n", dev, dev->name);
 	list_add(&dev->list, &clockevent_devices);
 	clockevents_do_notify(CLOCK_EVT_NOTIFY_ADD, dev);
 	clockevents_notify_released();
@@ -220,6 +220,7 @@ void clockevents_exchange_device(struct 
 	 * released list and do a notify add later.
 	 */
 	if (old) {
+		printk(KERN_INFO "CE Release %p %s\n", old, old->name);
 		clockevents_set_mode(old, CLOCK_EVT_MODE_UNUSED);
 		list_del(&old->list);
 		list_add(&old->list, &clockevents_released);
@@ -260,6 +261,13 @@ void clockevents_notify(unsigned long re
 		list_for_each_entry_safe(dev, tmp, &clockevent_devices, list) {
 			if (cpumask_test_cpu(cpu, dev->cpumask) &&
 			    cpumask_weight(dev->cpumask) == 1) {
+				if (dev->mode != CLOCK_EVT_MODE_UNUSED) {
+					printk(KERN_INFO
+					       "CE Remove %p %s bc: %d\n",
+					       dev, dev->name,
+					       tick_is_broadcast_device(dev));
+					continue;
+				}
 				BUG_ON(dev->mode != CLOCK_EVT_MODE_UNUSED);
 				list_del(&dev->list);
 			}
Index: linux-2.6-tip/kernel/time/tick-broadcast.c
===================================================================
--- linux-2.6-tip.orig/kernel/time/tick-broadcast.c
+++ linux-2.6-tip/kernel/time/tick-broadcast.c
@@ -72,6 +72,8 @@ int tick_check_broadcast_device(struct c
 	     (dev->features & CLOCK_EVT_FEAT_C3STOP))
 		return 0;
 
+	printk(KERN_INFO "CE set broadcast %p %s\n", dev, dev->name);
+
 	clockevents_exchange_device(NULL, dev);
 	tick_broadcast_device.evtdev = dev;
 	if (!cpumask_empty(tick_get_broadcast_mask()))
