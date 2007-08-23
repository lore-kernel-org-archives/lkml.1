Return-Path: <linux-kernel-owner+w=401wt.eu-S1763262AbXHWTak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763262AbXHWTak (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 15:30:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756677AbXHWTaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 15:30:16 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:20992 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755909AbXHWTaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 15:30:14 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: [patch 2/2] Let process accouting trust sched_clock.
Date: Thu, 23 Aug 2007 21:29:54 +0200
User-Agent: KMail/1.9.7
Cc: Jan Glauber <jan.glauber@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org
References: <200708232126.36475.borntraeger@de.ibm.com>
In-Reply-To: <200708232126.36475.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708232129.54612.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the scheduler does sanity checking on sched_clock and corrects
the values. Remove some of these checks to make steal time influence the
process time.  
This patch is probably nothing for upstream but with this patch the
accouting for s390 seems to work regarding steal time, even without
CONFIG_VIRT_CPU_TIME (as long as CONFIG_VIRT_TIMER is y).

---
 kernel/sched.c |    6 ------
 1 file changed, 6 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -3310,19 +3310,13 @@ void account_steal_time(struct task_stru
 void scheduler_tick(void)
 {
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
 		curr->sched_class->task_tick(rq, curr);
 	spin_unlock(&rq->lock);

