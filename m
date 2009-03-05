Return-Path: <linux-kernel-owner+w=401wt.eu-S1755542AbZCEBAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542AbZCEBAl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 20:00:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750972AbZCEBAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 20:00:33 -0500
Received: from mail-ew0-f177.google.com ([209.85.219.177]:52762 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbZCEBAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 20:00:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:from:date:subject:to:cc;
        b=oRF6PwsQL3PP+GVWdmg1Xx220hx/b4KPSf6fac6TNMzOaTDUKIR+JatNwEoOBcvi1r
         HSLxjqlIiX5XP6knFrYo6b+1HWWnG4F18QG7fBgoxmKHsu0Np6UkkBsJYMAMWQyNrjSk
         IagTHCgf7UYlhK0CY7sAfnvDLGPII76305qOY=
Message-ID: <49af242d.1c07d00a.32d5.ffffc019@mx.google.com>
From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Thu, 5 Mar 2009 01:27:02 +0100
Subject: [PATCH 1/2] sched: don't rebalance if attached on NULL domain
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix function graph trace hang / drop pointless softirq on UP

While debugging a function graph trace hang on an old PII, I saw that it
consumed most of its time on the timer interrupt.
And the domain rebalancing softirq was the most concerned.

The timer interrupt calls trigger_load_balance() which will decide if it is
worth to schedule a rebalancing softirq.

In case of builtin UP kernel, no problem arises because there is no
domain question.

In case of builtin SMP kernel running on an SMP box, still no problem,
the softirq will be raised each time we reach the next_balance time.

In case of builtin SMP kernel running on a UP box (most distros provide default SMP
kernels, whatever the box you have), then the CPU is attached to the NULL sched domain.
So a kind of unexpected behaviour happen:

trigger_load_balance() -> raises the rebalancing softirq
later on softirq: run_rebalance_domains() -> rebalance_domains() where
the for_each_domain(cpu, sd) is not taken because of the NULL domain we are attached at.
Which means rq->next_balance is never updated.
So on the next timer tick, we will enter trigger_load_balance() which will always reschedule()
the rebalacing softirq:

if (time_after_eq(jiffies, rq->next_balance))
	raise_softirq(SCHED_SOFTIRQ);

So for each tick, we process this pointless softirq.

This patch fixes it by checking if we are attached to the null domain before raising the softirq,
another possible fix would be to set the maximal possible JIFFIES value to rq->next_balance if we are
attached to the NULL domain.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/sched.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 7335a65..89e2ca0 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -680,6 +680,11 @@ inline void update_rq_clock(struct rq *rq)
 	rq->clock = sched_clock_cpu(cpu_of(rq));
 }
 
+static inline int on_null_domain(int cpu)
+{
+	return !rcu_dereference(cpu_rq(cpu)->sd);
+}
+
 /*
  * Tunables that become constants when CONFIG_SCHED_DEBUG is off:
  */
@@ -4267,7 +4272,9 @@ static inline void trigger_load_balance(struct rq *rq, int cpu)
 	    cpumask_test_cpu(cpu, nohz.cpu_mask))
 		return;
 #endif
-	if (time_after_eq(jiffies, rq->next_balance))
+	/* Don't need to rebalance while attached to NULL domain */
+	if (time_after_eq(jiffies, rq->next_balance) &&
+	    likely(!on_null_domain(cpu)))
 		raise_softirq(SCHED_SOFTIRQ);
 }
 
-- 
1.6.1


