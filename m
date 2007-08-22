Return-Path: <linux-kernel-owner+w=401wt.eu-S1757510AbXHVHwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510AbXHVHwa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 03:52:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752704AbXHVHwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 03:52:22 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:41581 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbXHVHwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 03:52:21 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [accounting regression since rc1]  scheduler updates
Date: Wed, 22 Aug 2007 09:50:34 +0200
User-Agent: KMail/1.9.7
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Jan Glauber <jang@linux.vnet.ibm.com>, heiko.carstens@de.ibm.com,
       Paul Mackerras <paulus@samba.org>
References: <20070812163225.GA11996@elte.hu> <200708211017.02998.borntraeger@de.ibm.com> <20070821112529.GB648@elte.hu>
In-Reply-To: <20070821112529.GB648@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708220950.35044.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 21. August 2007 schrieben Sie:
> could you try the patch below, does it work any better?

I looked again at the scheduler code and things are getting better when I run 
the patch below on top of your patch and with our sched_clock prototype. I 
guess there is a reason why you want rq->clock advanced by at least one tick?

We discussed calling scheduler_tick with virtual time as well.
Would it have the same result?
What would be the impact on latency?

After looking at the current s390 timer code, it seems that this kind of 
change is not trivial enough to be rc3+ ready. 
I personally think, that for 2.6.23 we should use the patch against 
fs/proc/array.c and everything else for 2.6.24?

Christian

---
 kernel/sched.c |    6 ------
 1 file changed, 6 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -3321,15 +3321,9 @@ void scheduler_tick(void)
 	int cpu = smp_processor_id();
 	struct rq *rq = cpu_rq(cpu);
 	struct task_struct *curr = rq->curr;
-	u64 next_tick = rq->tick_timestamp + TICK_NSEC;
 
 	spin_lock(&rq->lock);
 	__update_rq_clock(rq);
-	/*
-	 * Let rq->clock advance by at least TICK_NSEC:
-	 */
-	if (unlikely(rq->clock < next_tick))
-		rq->clock = next_tick;
 	rq->tick_timestamp = rq->clock;
 	update_cpu_load(rq);
 	if (curr != rq->idle) /* FIXME: needed? */


