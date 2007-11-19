Return-Path: <linux-kernel-owner+w=401wt.eu-S1755402AbXKSJoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402AbXKSJoP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 04:44:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752512AbXKSJn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 04:43:59 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42649 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752247AbXKSJn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 04:43:58 -0500
Date: Mon, 19 Nov 2007 10:43:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, jeremy@goop.org, gregkh@suse.de,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: regression from softlockup fix
Message-ID: <20071119094338.GA19271@elte.hu>
References: <20071119.012119.118043374.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071119.012119.118043374.davem@davemloft.net>
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


* David Miller <davem@davemloft.net> wrote:

> I suspect that what is happening is that the NOHZ period is longer 
> than the softlockup timeout (10 seconds) and we get an interrupt 
> before the watchdog thread gets onto the cpu.

indeed! Does the patch below do the trick?

	Ingo

--------------->
Subject: softlockup: do the wakeup from a hrtimer
From: Ingo Molnar <mingo@elte.hu>

David Miller reported soft lockup false-positives that trigger
on NOHZ due to CPUs idling for more than 10 seconds.

The solution is to drive the wakeup of the watchdog threads
not from the timer tick (which has no guaranteed frequency),
but from the watchdog tasks themselves.

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
