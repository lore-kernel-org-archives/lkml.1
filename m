Return-Path: <linux-kernel-owner+w=401wt.eu-S1763802AbXGZJA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763802AbXGZJA1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 05:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756966AbXGZJAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 05:00:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60480 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756417AbXGZJAS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 05:00:18 -0400
Date: Thu, 26 Jul 2007 11:00:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [patch] sched: make cpu_clock() not use the rq clock
Message-ID: <20070726090012.GA5287@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: sched: make cpu_clock() not use the rq clock
From: Ingo Molnar <mingo@elte.hu>

it is enough to disable interrupts to get the precise rq-clock
of the local CPU.

this also solves an NMI watchdog regression: the NMI watchdog
calls touch_softlockup_watchdog(), which might deadlock on
rq->lock if the NMI hits an rq-locked critical section.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

Index: linux-rt-rebase.q/kernel/sched.c
===================================================================
--- linux-rt-rebase.q.orig/kernel/sched.c
+++ linux-rt-rebase.q/kernel/sched.c
@@ -446,13 +446,12 @@ static inline unsigned long long rq_cloc
  */
 unsigned long long cpu_clock(int cpu)
 {
-	struct rq *rq = cpu_rq(cpu);
 	unsigned long long now;
 	unsigned long flags;
 
-	spin_lock_irqsave(&rq->lock, flags);
-	now = rq_clock(rq);
-	spin_unlock_irqrestore(&rq->lock, flags);
+	local_irq_save(flags);
+	now = rq_clock(cpu_rq(cpu));
+	local_irq_restore(flags);
 
 	return now;
 }
