Return-Path: <linux-kernel-owner+w=401wt.eu-S1756382AbYICVh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756382AbYICVh5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 17:37:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755633AbYICVhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 17:37:32 -0400
Received: from www.tglx.de ([62.245.132.106]:41381 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752894AbYICVhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 17:37:31 -0400
Message-Id: <20080903212753.124357845@linutronix.de>
References: <20080903212735.713411776@linutronix.de>
User-Agent: quilt/0.46-1
Date: Wed, 03 Sep 2008 21:36:50 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Shaohua Li <shaohua.li@intel.com>,
       "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>,
       Dmitry Nezhevenko <dion@inhex.net>
Subject: [patch 1/6] clockevents: Prevent clockevent event_handler ending up
	handler_noop
Content-Disposition: inline; filename=cev.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a ordering related problem with clockevents code, due to which
clockevents_register_device() called after tickless/highres switch
will not work. The new clockevent ends up with clockevents_handle_noop as
event handler, resulting in no timer activity.

The problematic path seems to be

* old device already has hrtimer_interrupt as the event_handler
* new clockevent device registers with a higher rating
* tick_check_new_device() is called
  * clockevents_exchange_device() gets called
    * old->event_handler is set to clockevents_handle_noop
  * tick_setup_device() is called for the new device
    * which sets new->event_handler using the old->event_handler which is noop.

Change the ordering so that new device inherits the proper handler.

This does not have any issue in normal case as most likely all the clockevent
devices are setup before the highres switch. But, can potentially be affecting
some corner case where HPET force detect happens after the highres switch.
This was a problem with HPET in MSI mode code that we have been experimenting
with.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 include/linux/clockchips.h |    2 ++
 kernel/time/clockevents.c  |    3 +--
 kernel/time/tick-common.c  |    1 +
 3 files changed, 4 insertions(+), 2 deletions(-)

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

-- 

