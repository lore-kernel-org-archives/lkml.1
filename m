Return-Path: <linux-kernel-owner+w=401wt.eu-S1754547AbZCENIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbZCENIQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 08:08:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755507AbZCENHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 08:07:06 -0500
Received: from hera.kernel.org ([140.211.167.34]:59722 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753953AbZCENHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 08:07:03 -0500
Date: Thu, 5 Mar 2009 13:06:26 GMT
From: Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, peterz@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, peterz@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49af242d.1c07d00a.32d5.ffffc019@mx.google.com>
References: <49af242d.1c07d00a.32d5.ffffc019@mx.google.com>
Subject: [tip:sched/core] sched: don't rebalance if attached on NULL domain
Message-ID: <tip-8a0be9ef8225638d26b455788f988c8f84ce9e75@git.kernel.org>
Git-Commit-ID: 8a0be9ef8225638d26b455788f988c8f84ce9e75
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 05 Mar 2009 13:06:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8a0be9ef8225638d26b455788f988c8f84ce9e75
Gitweb:     http://git.kernel.org/tip/8a0be9ef8225638d26b455788f988c8f84ce9e75
Author:     "Frederic Weisbecker" <fweisbec@gmail.com>
AuthorDate: Thu, 5 Mar 2009 01:27:02 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 5 Mar 2009 14:04:44 +0100

sched: don't rebalance if attached on NULL domain

Impact: fix function graph trace hang / drop pointless softirq on UP

While debugging a function graph trace hang on an old PII, I saw
that it consumed most of its time on the timer interrupt. And
the domain rebalancing softirq was the most concerned.

The timer interrupt calls trigger_load_balance() which will
decide if it is worth to schedule a rebalancing softirq.

In case of builtin UP kernel, no problem arises because there is
no domain question.

In case of builtin SMP kernel running on an SMP box, still no
problem, the softirq will be raised each time we reach the
next_balance time.

In case of builtin SMP kernel running on a UP box (most distros
provide default SMP kernels, whatever the box you have), then
the CPU is attached to the NULL sched domain. So a kind of
unexpected behaviour happen:

trigger_load_balance() -> raises the rebalancing softirq later
on softirq: run_rebalance_domains() -> rebalance_domains() where
the for_each_domain(cpu, sd) is not taken because of the NULL
domain we are attached at. Which means rq->next_balance is never
updated. So on the next timer tick, we will enter
trigger_load_balance() which will always reschedule() the
rebalacing softirq:

if (time_after_eq(jiffies, rq->next_balance))
	raise_softirq(SCHED_SOFTIRQ);

So for each tick, we process this pointless softirq.

This patch fixes it by checking if we are attached to the null
domain before raising the softirq, another possible fix would be
to set the maximal possible JIFFIES value to rq->next_balance if
we are attached to the NULL domain.

v2: build fix on UP

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <49af242d.1c07d00a.32d5.ffffc019@mx.google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index dfae1bf..e509dbd 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4148,6 +4148,11 @@ static void run_rebalance_domains(struct softirq_action *h)
 #endif
 }
 
+static inline int on_null_domain(int cpu)
+{
+	return !rcu_dereference(cpu_rq(cpu)->sd);
+}
+
 /*
  * Trigger the SCHED_SOFTIRQ if it is time to do periodic load balancing.
  *
@@ -4205,7 +4210,9 @@ static inline void trigger_load_balance(struct rq *rq, int cpu)
 	    cpumask_test_cpu(cpu, nohz.cpu_mask))
 		return;
 #endif
-	if (time_after_eq(jiffies, rq->next_balance))
+	/* Don't need to rebalance while attached to NULL domain */
+	if (time_after_eq(jiffies, rq->next_balance) &&
+	    likely(!on_null_domain(cpu)))
 		raise_softirq(SCHED_SOFTIRQ);
 }
 
