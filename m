Return-Path: <linux-kernel-owner+w=401wt.eu-S1753983AbYICKF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983AbYICKF0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 06:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751598AbYICKFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 06:05:14 -0400
Received: from www.tglx.de ([62.245.132.106]:42790 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877AbYICKFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 06:05:12 -0400
Date: Wed, 3 Sep 2008 12:04:58 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
cc: herton@mandriva.com.br,
       Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.27-rc5 doesn't boot on a Pavilion laptop
In-Reply-To: <20080902175544.131bc54e@doriath.conectiva>
Message-ID: <alpine.LFD.1.10.0809031202290.3243@apollo.tec.linutronix.de>
References: <20080902163532.436f8fbd@doriath.conectiva> <alpine.LFD.1.10.0809022208320.3243@apollo.tec.linutronix.de> <20080902175544.131bc54e@doriath.conectiva>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Sep 2008, Luiz Fernando N. Capitulino wrote:
> """
> PCI: Using ACPI for IRQ routing
> DMAR:parse DMAR table failure.
> """
> 
>  Also, after about 10 minutes I get the same backtrace as reported in
> the ticket above... It's the same bug then.

Venki found a nasty bug in the clock events code which might be
related to this. I found one as well. Can you please apply the combo
of those fixes to current mainline and test it ?

Thanks,

	tglx
-----
Index: linux-2.6/include/linux/clockchips.h
===================================================================
--- linux-2.6.orig/include/linux/clockchips.h
+++ linux-2.6/include/linux/clockchips.h
@@ -127,6 +127,8 @@ extern int clockevents_register_notifier
 extern int clockevents_program_event(struct clock_event_device *dev,
 				     ktime_t expires, ktime_t now);
 
+extern void clockevents_handle_noop(struct clock_event_device *dev);
+
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
 extern void clockevents_notify(unsigned long reason, void *arg);
 #else
Index: linux-2.6/kernel/time/clockevents.c
===================================================================
--- linux-2.6.orig/kernel/time/clockevents.c
+++ linux-2.6/kernel/time/clockevents.c
@@ -177,7 +177,7 @@ void clockevents_register_device(struct 
 /*
  * Noop handler when we shut down an event device
  */
-static void clockevents_handle_noop(struct clock_event_device *dev)
+void clockevents_handle_noop(struct clock_event_device *dev)
 {
 }
 
@@ -199,7 +199,6 @@ void clockevents_exchange_device(struct 
 	 * released list and do a notify add later.
 	 */
 	if (old) {
-		old->event_handler = clockevents_handle_noop;
 		clockevents_set_mode(old, CLOCK_EVT_MODE_UNUSED);
 		list_del(&old->list);
 		list_add(&old->list, &clockevents_released);
Index: linux-2.6/kernel/time/tick-common.c
===================================================================
--- linux-2.6.orig/kernel/time/tick-common.c
+++ linux-2.6/kernel/time/tick-common.c
@@ -161,6 +161,7 @@ static void tick_setup_device(struct tic
 	} else {
 		handler = td->evtdev->event_handler;
 		next_event = td->evtdev->next_event;
+		td->evtdev->event_handler = clockevents_handle_noop;
 	}
 
 	td->evtdev = newdev;
Index: linux-2.6/kernel/time/tick-broadcast.c
===================================================================
--- linux-2.6.orig/kernel/time/tick-broadcast.c
+++ linux-2.6/kernel/time/tick-broadcast.c
@@ -175,6 +175,8 @@ static void tick_do_periodic_broadcast(v
  */
 static void tick_handle_periodic_broadcast(struct clock_event_device *dev)
 {
+	ktime_t next;
+
 	tick_do_periodic_broadcast();
 
 	/*
@@ -185,10 +187,13 @@ static void tick_handle_periodic_broadca
 
 	/*
 	 * Setup the next period for devices, which do not have
-	 * periodic mode:
+	 * periodic mode. We read dev->next_event first and add to it
+	 * when the event alrady expired. clockevents_program_event()
+	 * sets dev->next_event only when the event is really
+	 * programmed to the device.
 	 */
-	for (;;) {
-		ktime_t next = ktime_add(dev->next_event, tick_period);
+	for (next = dev->next_event; ;) {
+		next = ktime_add(next, tick_period);
 
 		if (!clockevents_program_event(dev, next, ktime_get()))
 			return;
Index: linux-2.6/kernel/time/tick-oneshot.c
===================================================================
--- linux-2.6.orig/kernel/time/tick-oneshot.c
+++ linux-2.6/kernel/time/tick-oneshot.c
@@ -23,11 +23,11 @@
 #include "tick-internal.h"
 
 /**
- * tick_program_event
+ * tick_program_event internal worker function
  */
-int tick_program_event(ktime_t expires, int force)
+static int __tick_program_event(struct clock_event_device *dev,
+				ktime_t expires, int force)
 {
-	struct clock_event_device *dev = __get_cpu_var(tick_cpu_device).evtdev;
 	ktime_t now = ktime_get();
 
 	while (1) {
@@ -41,6 +41,16 @@ int tick_program_event(ktime_t expires, 
 }
 
 /**
+ * tick_program_event
+ */
+int tick_program_event(ktime_t expires, int force)
+{
+	struct clock_event_device *dev = __get_cpu_var(tick_cpu_device).evtdev;
+
+	return __tick_program_event(dev, expires, force);
+}
+
+/**
  * tick_resume_onshot - resume oneshot mode
  */
 void tick_resume_oneshot(void)
@@ -61,7 +71,7 @@ void tick_setup_oneshot(struct clock_eve
 {
 	newdev->event_handler = handler;
 	clockevents_set_mode(newdev, CLOCK_EVT_MODE_ONESHOT);
-	clockevents_program_event(newdev, next_event, ktime_get());
+	__tick_program_event(newdev, next_event, 1);
 }
 
 /**
