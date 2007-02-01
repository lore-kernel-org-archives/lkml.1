Return-Path: <linux-kernel-owner+w=401wt.eu-S1422848AbXBANCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422848AbXBANCz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 08:02:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422844AbXBANCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 08:02:55 -0500
Received: from www.osadl.org ([213.239.205.134]:45246 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1422848AbXBANCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 08:02:54 -0500
Subject: [PATCH -mm] gtod persistent clock resume fix
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Karsten Wiese <fzu@wemgehoertderstaat.de>
Cc: Andrew Morton <akpm@osdl.org>, Maciej Rutecki <maciej.rutecki@gmail.com>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
In-Reply-To: <200701310155.05474.fzu@wemgehoertderstaat.de>
References: <20070129204528.eb8d695e.akpm@osdl.org>
	 <45BFC442.5000903@gmail.com> <20070130142714.9f8dd5da.akpm@osdl.org>
	 <200701310155.05474.fzu@wemgehoertderstaat.de>
Content-Type: text/plain
Date: Thu, 01 Feb 2007 14:03:47 +0100
Message-Id: <1170335027.29240.272.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The reworked highres/dyntick code made a thinko in the resume code
visible, which was magically working in the old queue.

On resume we add the slept time to xtime. This delta must be adjusted in
wall_to_monotonic as well. The update of jiffies64 is bogus and a
leftover of the code which was taken from arch/i386/kernel/time.c.

On suspend the current state of xtime, wall_to_monotonic and jiffies is
frozen. After resume we need to add the slept time to xtime, but we need
to subtract it from wall_to_monotonic, so the monotonic time is resuming
from exactly the point where it was suspended. jiffies are restarting
from the same point as well.

This solves the resume waittime observed by Karsten Wiese.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Index: linux-2.6.20-rc6-mm/kernel/timer.c
===================================================================
--- linux-2.6.20-rc6-mm.orig/kernel/timer.c
+++ linux-2.6.20-rc6-mm/kernel/timer.c
@@ -985,8 +985,9 @@ static int timekeeping_resume(struct sys
 
 	if (now && (now > timekeeping_suspend_time)) {
 		unsigned long sleep_length = now - timekeeping_suspend_time;
+
 		xtime.tv_sec += sleep_length;
-		jiffies_64 += (u64)sleep_length * HZ;
+		wall_to_monotonic.tv_sec -= sleep_length;
 	}
 	/* re-base the last cycle value */
 	clock->cycle_last = clocksource_read(clock);
@@ -994,7 +995,7 @@ static int timekeeping_resume(struct sys
 	timekeeping_suspended = 0;
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 
-	clockevents_notify(CLOCK_EVT_NOTIFY_RESUME, NULL);
+	touch_softlockup_watchdog();
 	/* Resume hrtimers */
 	clock_was_set();
 


