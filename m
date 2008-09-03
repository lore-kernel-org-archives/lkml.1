Return-Path: <linux-kernel-owner+w=401wt.eu-S1754580AbYICVho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580AbYICVho (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 17:37:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755323AbYICVhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 17:37:25 -0400
Received: from www.tglx.de ([62.245.132.106]:41368 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754472AbYICVhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 17:37:23 -0400
Message-Id: <20080903212753.179385364@linutronix.de>
References: <20080903212735.713411776@linutronix.de>
User-Agent: quilt/0.46-1
Date: Wed, 03 Sep 2008 21:36:57 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>,
       Dmitry Nezhevenko <dion@inhex.net>
Subject: [patch 2/6] clockevents: prevent endless loop in periodic broadcast
	handler
Content-Disposition: inline; filename=clockevents-fix-broadcast-mode.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The reprogramming of the periodic broadcast handler was broken,
when the first programming returned -ETIME. The clockevents code
stores the new expiry value in the clock events device next_event field
only when the programming time has not been elapsed yet. The loop in
question calculates the new expiry value from the next_event value
and therefor never increases.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/tick-broadcast.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

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

-- 

