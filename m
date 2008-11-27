Return-Path: <linux-kernel-owner+w=401wt.eu-S1755464AbYK0CG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464AbYK0CG3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 21:06:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752295AbYK0CF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 21:05:57 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:52212 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141AbYK0CF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 21:05:56 -0500
Message-Id: <20081127020554.533035163@goodmis.org>
References: <20081127020423.460116740@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 26 Nov 2008 21:04:24 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/1] sched: prevent divide by zero error in cpu_avg_load_per_task
Content-Disposition: inline; filename=0001-sched-prevent-divide-by-zero-error-in-cpu_avg_load_.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

Impact: fix to divide by zero

While testing the branch profiler, I hit this crash:

divide error: 0000 [#1] PREEMPT SMP
[...]
RIP: 0010:[<ffffffff8024a008>]  [<ffffffff8024a008>] cpu_avg_load_per_task+0x50/0x7f
[...]
Call Trace:
 <IRQ> <0> [<ffffffff8024fd43>] find_busiest_group+0x3e5/0xcaa
 [<ffffffff8025da75>] rebalance_domains+0x2da/0xa21
 [<ffffffff80478769>] ? find_next_bit+0x1b2/0x1e6
 [<ffffffff8025e2ce>] run_rebalance_domains+0x112/0x19f
 [<ffffffff8026d7c2>] __do_softirq+0xa8/0x232
 [<ffffffff8020ea7c>] call_softirq+0x1c/0x3e
 [<ffffffff8021047a>] do_softirq+0x94/0x1cd
 [<ffffffff8026d5eb>] irq_exit+0x6b/0x10e
 [<ffffffff8022e6ec>] smp_apic_timer_interrupt+0xd3/0xff
 [<ffffffff8020e4b3>] apic_timer_interrupt+0x13/0x20

The code for cpu_avg_load_per_task has:

	if (rq->nr_running)
		rq->avg_load_per_task = rq->load.weight / rq->nr_running;

The runqueue lock is not held here, and there is nothing that prevents
the rq->nr_running from going to zero after it passes the if condition.

The branch profiler simply made the race window bigger.

This patch saves off the rq->nr_running to a local variable and uses that
for both the condition and the division.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/sched.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 9b1e793..700aa9a 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1453,9 +1453,10 @@ static int task_hot(struct task_struct *p, u64 now, struct sched_domain *sd);
 static unsigned long cpu_avg_load_per_task(int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
+	unsigned long nr_running = rq->nr_running;
 
-	if (rq->nr_running)
-		rq->avg_load_per_task = rq->load.weight / rq->nr_running;
+	if (nr_running)
+		rq->avg_load_per_task = rq->load.weight / nr_running;
 	else
 		rq->avg_load_per_task = 0;
 
-- 
1.5.6.5

-- 
