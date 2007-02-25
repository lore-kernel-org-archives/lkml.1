Return-Path: <linux-kernel-owner+w=401wt.eu-S1752318AbXBYFN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318AbXBYFN4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 00:13:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752321AbXBYFN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 00:13:56 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54184
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752318AbXBYFNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 00:13:55 -0500
Date: Sat, 24 Feb 2007 21:13:53 -0800 (PST)
Message-Id: <20070224.211353.74752521.davem@davemloft.net>
To: johnstul@us.ibm.com
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org, peter.keilty@hp.com
Subject: generic one-shot bug (was Re: sparc generic time / clockevents)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070223.163428.104033815.davem@davemloft.net>
References: <20070223.015520.125893182.davem@davemloft.net>
	<1172260279.6261.20.camel@localhost>
	<20070223.163428.104033815.davem@davemloft.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


As I suspected, the one-shot code wasn't very well tested and I'd be
the one to debug this thing on sparc64 :-)

When a timer exceeds the timer period, the one-shot handling code does
the following loop:

	for (;;) {
		ktime_t next = ktime_add(dev->next_event, tick_period);

		if (!clockevents_program_event(dev, next, ktime_get()))
			return;
		tick_periodic(cpu);
	}

So it just keeps running tick_periodic() until we "catch up".

Problem is, if clockevents_program_event() gets a "next" time in the
past, the very case where we'll loop, it DOES NOT update
dev->next_event.  It returns the error before doing so.

As a result of this, we'll loop forever here, the softlockup watchdog
will trigger, and the system will wedge completely.

I was getting a softlockup and immediate system hang, so to debug this
I kept a history of the last 8 TSC values when tick_periodic() was
invoked.  At softlockup trigger, I'd dump the log.  And what I saw
were TSC deltas that we so tiny as to be just enough to indicate
tick_periodic() was running in a tight loop :-)

I propose the following fix, which I'm about to test.

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 4500e34..0986a2b 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -77,6 +77,7 @@ static void tick_periodic(int cpu)
 void tick_handle_periodic(struct clock_event_device *dev)
 {
 	int cpu = smp_processor_id();
+	ktime_t next;
 
 	tick_periodic(cpu);
 
@@ -86,12 +87,12 @@ void tick_handle_periodic(struct clock_event_device *dev)
 	 * Setup the next period for devices, which do not have
 	 * periodic mode:
 	 */
+	next = ktime_add(dev->next_event, tick_period);
 	for (;;) {
-		ktime_t next = ktime_add(dev->next_event, tick_period);
-
 		if (!clockevents_program_event(dev, next, ktime_get()))
 			return;
 		tick_periodic(cpu);
+		next = ktime_add(next, tick_period);
 	}
 }
 
