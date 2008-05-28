Return-Path: <linux-kernel-owner+w=401wt.eu-S1758372AbYE1B2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758372AbYE1B2i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 21:28:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757485AbYE1B1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 21:27:54 -0400
Received: from lsg.lsg.lab.novell.com ([151.155.230.1]:3890 "EHLO
	lsg.lsg.lab.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948AbYE1B1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 21:27:50 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 2/3] sched: fix SCHED_FAIR wake-idle logic error
To: Steven Rostedt <rostedt@goodmis.org>, linux-rt-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>
Date: Tue, 27 May 2008 18:59:39 -0600
Message-ID: <20080528005939.4146.67523.stgit@lsg.lsg.lab.novell.com>
In-Reply-To: <20080528005647.4146.13252.stgit@lsg.lsg.lab.novell.com>
References: <20080528005647.4146.13252.stgit@lsg.lsg.lab.novell.com>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We currently use an optimization to skip the overhead of wake-idle

processing if more than one task is assigned to a run-queue.  The
assumption is that the system must already be load-balanced or we
wouldnt be overloaded to begin with.

The problem is that we are looking at rq->nr_running, which may include
RT tasks in addition to CFS tasks.  Since the presence of RT tasks
really has no bearing on the balance status of CFS tasks, this throws
the calculation off.

This patch changes the logic to only consider the number of CFS tasks
when making the decision to optimze the wake-idle.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
CC: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---

 kernel/sched_fair.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 24c0830..0ade6f8 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -951,7 +951,7 @@ static int wake_idle(int cpu, struct task_struct *p)
 	 * sibling runqueue info. This will avoid the checks and cache miss
 	 * penalities associated with that.
 	 */
-	if (idle_cpu(cpu) || cpu_rq(cpu)->nr_running > 1)
+	if (idle_cpu(cpu) || cpu_rq(cpu)->cfs.nr_running > 1)
 		return cpu;
 
 	for_each_domain(cpu, sd) {

