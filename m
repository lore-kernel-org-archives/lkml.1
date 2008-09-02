Return-Path: <linux-kernel-owner+w=401wt.eu-S1754618AbYIBXUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618AbYIBXUg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 19:20:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753046AbYIBXU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 19:20:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:51672 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764AbYIBXU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 19:20:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,320,1217833200"; 
   d="scan'208";a="434893656"
Date: Tue, 2 Sep 2008 16:20:15 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, shaohua.li@intel.com
Subject: [PATCH] Prevent clockevent event_handler ending up handler_noop
Message-ID: <20080902232015.GA3180@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
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

---
 include/linux/clockchips.h |    2 ++
 kernel/time/clockevents.c  |    3 +--
 kernel/time/tick-common.c  |    1 +
 3 files changed, 4 insertions(+), 2 deletions(-)

Index: tip/kernel/time/clockevents.c
===================================================================
--- tip.orig/kernel/time/clockevents.c	2008-09-02 13:26:35.000000000 -0700
+++ tip/kernel/time/clockevents.c	2008-09-02 15:24:13.000000000 -0700
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
Index: tip/kernel/time/tick-common.c
===================================================================
--- tip.orig/kernel/time/tick-common.c	2008-09-02 13:26:35.000000000 -0700
+++ tip/kernel/time/tick-common.c	2008-09-02 15:24:13.000000000 -0700
@@ -161,6 +161,7 @@ static void tick_setup_device(struct tic
 	} else {
 		handler = td->evtdev->event_handler;
 		next_event = td->evtdev->next_event;
+		td->evtdev->event_handler = clockevents_handle_noop;
 	}
 
 	td->evtdev = newdev;
Index: tip/include/linux/clockchips.h
===================================================================
--- tip.orig/include/linux/clockchips.h	2008-09-02 13:26:34.000000000 -0700
+++ tip/include/linux/clockchips.h	2008-09-02 15:24:13.000000000 -0700
@@ -127,6 +127,8 @@ extern int clockevents_register_notifier
 extern int clockevents_program_event(struct clock_event_device *dev,
 				     ktime_t expires, ktime_t now);
 
+extern void clockevents_handle_noop(struct clock_event_device *dev);
+
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
 extern void clockevents_notify(unsigned long reason, void *arg);
 #else
