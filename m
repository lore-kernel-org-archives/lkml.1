Return-Path: <linux-kernel-owner+w=401wt.eu-S1757196AbXKTIqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196AbXKTIqb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 03:46:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752076AbXKTIqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 03:46:24 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41452 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911AbXKTIqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 03:46:23 -0500
Date: Tue, 20 Nov 2007 09:46:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [patch] softlockup: do the wakeup from a hrtimer
Message-ID: <20071120084611.GA18721@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: softlockup: do the wakeup from a hrtimer
From: Ingo Molnar <mingo@elte.hu>

David Miller reported soft lockup false-positives that trigger on NOHZ 
due to CPUs idling for more than 10 seconds.

The solution is to drive the wakeup of the watchdog threads not from the 
timer tick (which has no guaranteed frequency), but from the watchdog 
tasks themselves.

http://bugzilla.kernel.org/show_bug.cgi?id=9409

Reported-by: David Miller <davem@davemloft.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/softlockup.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

Index: linux/kernel/softlockup.c
===================================================================
--- linux.orig/kernel/softlockup.c
+++ linux/kernel/softlockup.c
@@ -100,10 +100,6 @@ void softlockup_tick(void)
 
 	now = get_timestamp(this_cpu);
 
-	/* Wake up the high-prio watchdog task every second: */
-	if (now > (touch_timestamp + 1))
-		wake_up_process(per_cpu(watchdog_task, this_cpu));
-
 	/* Warn about unreasonable 10+ seconds delays: */
 	if (now <= (touch_timestamp + softlockup_thresh))
 		return;
@@ -141,7 +137,7 @@ static int watchdog(void *__bind_cpu)
 	while (!kthread_should_stop()) {
 		set_current_state(TASK_INTERRUPTIBLE);
 		touch_softlockup_watchdog();
-		schedule();
+		msleep(1000);
 	}
 
 	return 0;
