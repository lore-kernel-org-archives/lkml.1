Return-Path: <linux-kernel-owner+w=401wt.eu-S1756717AbYICVik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717AbYICVik (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 17:38:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755467AbYICVhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 17:37:40 -0400
Received: from www.tglx.de ([62.245.132.106]:41398 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755933AbYICVhj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 17:37:39 -0400
Message-Id: <20080903212753.288544061@linutronix.de>
References: <20080903212735.713411776@linutronix.de>
User-Agent: quilt/0.46-1
Date: Wed, 03 Sep 2008 21:37:08 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>,
       Dmitry Nezhevenko <dion@inhex.net>
Subject: [patch 4/6] clockevents: prevent multiple init/shutdown
Content-Disposition: inline;
	filename=clockevents-prevent-multiple-init-shutdown.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While chasing the C1E/HPET bugreports I went through the clock events
code inch by inch and found that the broadcast device can be initialized
and shutdown multiple times. Multiple shutdowns are not critical, but
useless waste of time. Multiple initializations are simply broken. Another
CPU might have the device in use already after the first initialization and
the second init could just render it unusable again.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/tick-broadcast.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

Index: linux-2.6/kernel/time/tick-broadcast.c
===================================================================
--- linux-2.6.orig/kernel/time/tick-broadcast.c
+++ linux-2.6/kernel/time/tick-broadcast.c
@@ -210,7 +210,7 @@ static void tick_do_broadcast_on_off(voi
 	struct clock_event_device *bc, *dev;
 	struct tick_device *td;
 	unsigned long flags, *reason = why;
-	int cpu;
+	int cpu, bc_stopped;
 
 	spin_lock_irqsave(&tick_broadcast_lock, flags);
 
@@ -228,6 +228,8 @@ static void tick_do_broadcast_on_off(voi
 	if (!tick_device_is_functional(dev))
 		goto out;
 
+	bc_stopped = cpus_empty(tick_broadcast_mask);
+
 	switch (*reason) {
 	case CLOCK_EVT_NOTIFY_BROADCAST_ON:
 	case CLOCK_EVT_NOTIFY_BROADCAST_FORCE:
@@ -250,9 +252,10 @@ static void tick_do_broadcast_on_off(voi
 		break;
 	}
 
-	if (cpus_empty(tick_broadcast_mask))
-		clockevents_set_mode(bc, CLOCK_EVT_MODE_SHUTDOWN);
-	else {
+	if (cpus_empty(tick_broadcast_mask)) {
+		if (!bc_stopped)
+			clockevents_set_mode(bc, CLOCK_EVT_MODE_SHUTDOWN);
+	} else if (bc_stopped) {
 		if (tick_broadcast_device.mode == TICKDEV_MODE_PERIODIC)
 			tick_broadcast_start_periodic(bc);
 		else
@@ -501,9 +504,12 @@ static void tick_broadcast_clear_oneshot
  */
 void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
 {
-	bc->event_handler = tick_handle_oneshot_broadcast;
-	clockevents_set_mode(bc, CLOCK_EVT_MODE_ONESHOT);
-	bc->next_event.tv64 = KTIME_MAX;
+	/* Set it up only once ! */
+	if (bc->event_handler != tick_handle_oneshot_broadcast) {
+		bc->event_handler = tick_handle_oneshot_broadcast;
+		clockevents_set_mode(bc, CLOCK_EVT_MODE_ONESHOT);
+		bc->next_event.tv64 = KTIME_MAX;
+	}
 }
 
 /*

-- 

