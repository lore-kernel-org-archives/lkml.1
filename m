Return-Path: <linux-kernel-owner+w=401wt.eu-S935330AbYD1RNM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935330AbYD1RNM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 13:13:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934076AbYD1RM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 13:12:57 -0400
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:36823
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933732AbYD1RM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 13:12:57 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [(RESEND) PATCH] sched: fix SCHED_FAIR wake-idle logic error
To: Ingo Molnar <mingo@elte.hu>
Cc: peterz@infradead.org, Gregory Haskins <ghaskins@novell.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 28 Apr 2008 12:40:01 -0400
Message-ID: <20080428163908.5900.74943.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, Peter,
  Please ACK/NACK this patch so I know where you stand.  Thanks!

-Greg

----------------------------------
sched: fix SCHED_FAIR wake-idle logic error

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
CC: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>
---

 kernel/sched_fair.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 89fa32b..80b7891 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1007,7 +1007,7 @@ static int wake_idle(int cpu, struct task_struct *p)
 	 * sibling runqueue info. This will avoid the checks and cache miss
 	 * penalities associated with that.
 	 */
-	if (idle_cpu(cpu) || cpu_rq(cpu)->nr_running > 1)
+	if (idle_cpu(cpu) || cpu_rq(cpu)->cfs.nr_running > 1)
 		return cpu;
 
 	for_each_domain(cpu, sd) {

