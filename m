Return-Path: <linux-kernel-owner+w=401wt.eu-S1761280AbYBMNDD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761280AbYBMNDD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 08:03:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757002AbYBMNCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 08:02:54 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47891 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572AbYBMNCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 08:02:53 -0500
Date: Wed, 13 Feb 2008 14:02:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: rdreier@cisco.com, linux-kernel@vger.kernel.org
Subject: Re: Strange hang on ia64 with CONFIG_PRINTK_TIME=y
Message-ID: <20080213130236.GA8345@elte.hu>
References: <adazlu5tlve.fsf@cisco.com> <20080212.230156.33759433.davem@davemloft.net> <20080213125725.GC6344@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080213125725.GC6344@elte.hu>
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
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> so .. how about the patch below? Note that we already had an "early 
> bootup" special (the rq->idle check), it's now just made explicit via 
> the scheduler_running flag.

the one below even builds. (untested otherwise)

	Ingo

----------->
Subject: sched: make sched_clock() early-bootup capable
From: Ingo Molnar <mingo@elte.hu>
Date: Wed Feb 13 13:49:36 CET 2008

do not call sched_clock() too early. Not only might rq->idle
not be set up - but pure per-cpu data might not be accessible
either.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

Index: linux-x86.q/kernel/sched.c
===================================================================
--- linux-x86.q.orig/kernel/sched.c
+++ linux-x86.q/kernel/sched.c
@@ -666,6 +666,8 @@ const_debug unsigned int sysctl_sched_rt
  */
 const_debug unsigned int sysctl_sched_rt_ratio = 62259;
 
+static __read_mostly int scheduler_running;
+
 /*
  * For kernel-internal use: high-speed (but slightly incorrect) per-cpu
  * clock constructed from sched_clock():
@@ -676,14 +678,16 @@ unsigned long long cpu_clock(int cpu)
 	unsigned long flags;
 	struct rq *rq;
 
-	local_irq_save(flags);
-	rq = cpu_rq(cpu);
 	/*
 	 * Only call sched_clock() if the scheduler has already been
 	 * initialized (some code might call cpu_clock() very early):
 	 */
-	if (rq->idle)
-		update_rq_clock(rq);
+	if (unlikely(!scheduler_running))
+		return 0;
+
+	local_irq_save(flags);
+	rq = cpu_rq(cpu);
+	update_rq_clock(rq);
 	now = rq->clock;
 	local_irq_restore(flags);
 
@@ -7255,6 +7259,8 @@ void __init sched_init(void)
 	 * During early bootup we pretend to be a normal task:
 	 */
 	current->sched_class = &fair_sched_class;
+
+	scheduler_running = 1;
 }
 
 #ifdef CONFIG_DEBUG_SPINLOCK_SLEEP
