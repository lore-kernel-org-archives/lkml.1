Return-Path: <linux-kernel-owner+w=401wt.eu-S964905AbXA2XYE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964905AbXA2XYE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 18:24:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964919AbXA2XYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 18:24:04 -0500
Received: from www.osadl.org ([213.239.205.134]:52207 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964905AbXA2XYC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 18:24:02 -0500
Subject: [patch-mm] dynticks: Fix one off jiffy update
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Andrew Morton <akpm@osdl.org>
Cc: Karsten Wiese <fzu@wemgehoertderstaat.de>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 30 Jan 2007 00:24:43 +0100
Message-Id: <1170113083.29240.74.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sigh. /me wanted to be too clever and needs to order more brown
paperbags now.

The rework of the jiffy update code introduced a one off error, which
led to a one off accounting error for last_jiffy_update. This made
jiffies lag behind.

Noticed by Karsten Wiese (cpufreq_ondemand weirdness).

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Index: linux-2.6.20-rc6-mm/kernel/time/tick-sched.c
===================================================================
--- linux-2.6.20-rc6-mm.orig/kernel/time/tick-sched.c
+++ linux-2.6.20-rc6-mm/kernel/time/tick-sched.c
@@ -43,7 +43,7 @@ struct tick_sched *tick_get_tick_sched(i
  */
 static void tick_do_update_jiffies64(ktime_t now)
 {
-	unsigned long ticks = 1;
+	unsigned long ticks = 0;
 	ktime_t delta;
 
 	/* Reevalute with xtime_lock held */
@@ -60,12 +60,12 @@ static void tick_do_update_jiffies64(kti
 		if (unlikely(delta.tv64 >= tick_period.tv64)) {
 			s64 incr = ktime_to_ns(tick_period);
 
-			ticks += ktime_divns(delta, incr);
+			ticks = ktime_divns(delta, incr);
 
 			last_jiffies_update = ktime_add_ns(last_jiffies_update,
 							   incr * ticks);
 		}
-		do_timer(ticks);
+		do_timer(++ticks);
 	}
 	write_sequnlock(&xtime_lock);
 }


