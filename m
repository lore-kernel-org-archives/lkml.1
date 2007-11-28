Return-Path: <linux-kernel-owner+w=401wt.eu-S1759519AbXK1M5E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759519AbXK1M5E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 07:57:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755121AbXK1M4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 07:56:55 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51573 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754167AbXK1M4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 07:56:54 -0500
Date: Wed, 28 Nov 2007 13:56:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch] softlockup: fix false positives on CONFIG_NOHZ
Message-ID: <20071128125637.GA21084@elte.hu>
References: <20071120084611.GA18721@elte.hu> <20071126152652.8db2793a.akpm@linux-foundation.org> <20071127103642.GE6286@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071127103642.GE6286@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> these can be fixed, but:
> 
> > This will introduce an up-to-one-second delay in responding to 
> > kthread_should_stop().  Is that bad?
> 
> grumble, it's bad. I guess David is right that this should be fixed 
> the right way ;-) So the above patch cannot go in.

Thomas found the right fix. David, could you try the fix below, does it 
fix those false positives on your nohz Niagara cores?

	Ingo

---------------->
Subject: softlockup: fix false positives on CONFIG_NOHZ
From: Thomas Gleixner <tglx@linutronix.de>

David Miller reported soft lockup false-positives that trigger
on NOHZ due to CPUs idling for more than 10 seconds.

The solution is touch the softlockup watchdog when we return from
idle. (by definition we are not 'locked up' when we were idle)

 http://bugzilla.kernel.org/show_bug.cgi?id=9409

Reported-by: David Miller <davem@davemloft.net>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/time/tick-sched.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux/kernel/time/tick-sched.c
===================================================================
--- linux.orig/kernel/time/tick-sched.c
+++ linux/kernel/time/tick-sched.c
@@ -133,6 +133,8 @@ void tick_nohz_update_jiffies(void)
 	if (!ts->tick_stopped)
 		return;
 
+	touch_softlockup_watchdog();
+
 	cpu_clear(cpu, nohz_cpu_mask);
 	now = ktime_get();
 
