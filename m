Return-Path: <linux-kernel-owner+w=401wt.eu-S1762210AbXEVGkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762210AbXEVGkX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 02:40:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756978AbXEVGkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 02:40:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51981 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756392AbXEVGkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 02:40:11 -0400
Date: Tue, 22 May 2007 08:38:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>,
       Stable Team <stable@kernel.org>, Anant Nitya <kernel@prachanda.info>
Subject: Re: [PATCH] Prevent going idle with softirq pending
Message-ID: <20070522063850.GA23854@elte.hu>
References: <1179783264.12708.70.camel@chaos> <20070521233214.42ba9f12.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070521233214.42ba9f12.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> [  550.280860] BUG: at kernel/softirq.c:138 local_bh_enable()

yep. The correct patch is the one below.

	Ingo

--------------------->
Subject: Prevent going idle with softirq pending
From: Thomas Gleixner <tglx@linutronix.de>
 
The NOHZ patch contains a check for softirqs pending when a CPU goes 
idle. The BUG is unrelated to NOHZ, it just was made visible by the NOHZ 
patch. The BUG showed up mainly on P4 / hyperthreading enabled machines 
which lead the investigations into the wrong direction in the first 
place.  The real cause is in cond_resched_softirq():
 
cond_resched_softirq() is enabling softirqs without invoking the softirq 
daemon when softirqs are pending.  This leads to the warning message in 
the NOHZ idle code:
 
t1 runs softirq disabled code on CPU#0
interrupt happens, softirq is raised, but deferred (softirqs disabled)
t1 calls cond_resched_softirq()
	enables softirqs via _local_bh_enable()
	calls schedule()
t2 runs
t1 is migrated to CPU#1
t2 is done and invokes idle()
NOHZ detects the pending softirq
 
Fix: change _local_bh_enable() to local_bh_enable() so the softirq
daemon is invoked.
 
Thanks to Anant Nitya for debugging this with great patience !
 
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -4212,9 +4212,7 @@ int __sched cond_resched_softirq(void)
 	BUG_ON(!in_softirq());
 
 	if (need_resched() && system_state == SYSTEM_RUNNING) {
-		raw_local_irq_disable();
-		_local_bh_enable();
-		raw_local_irq_enable();
+		local_bh_enable();
 		__cond_resched();
 		local_bh_disable();
 		return 1;
