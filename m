Return-Path: <linux-kernel-owner+w=401wt.eu-S1756063AbYCJVXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063AbYCJVXW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 17:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752904AbYCJVXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 17:23:09 -0400
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:50153
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751316AbYCJVXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 17:23:08 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 1/2] Revert "cpu hotplug: adjust root-domain->online span in
	response to hotplug
Cc: linux-kernel@vger.kernel.org, ghaskins@novell.com,
       Gregory Haskins <ghaskins@novell.com>
Date: Mon, 10 Mar 2008 16:52:41 -0400
Message-ID: <20080310205241.9571.38832.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

event"

This reverts commit 393d94d98b19089ec172566e23557997931b137e.

I submitted 393d94d98b1 to -mm and sched-devel, and then quickly realized
it was flawed.  However, the patch was already "in flight" and made it
to Linus' tree and is in .25-rc5.  So this patch reverts the
original/flawed fix, and the patch that follows has the updated version.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |   18 +++++++++++-------
 1 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index b02e4fc..52b9867 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5813,13 +5813,6 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		/* Must be high prio: stop_machine expects to yield to it. */
 		rq = task_rq_lock(p, &flags);
 		__setscheduler(rq, p, SCHED_FIFO, MAX_RT_PRIO-1);
-
-		/* Update our root-domain */
-		if (rq->rd) {
-			BUG_ON(!cpu_isset(cpu, rq->rd->span));
-			cpu_set(cpu, rq->rd->online);
-		}
-
 		task_rq_unlock(rq, &flags);
 		cpu_rq(cpu)->migration_thread = p;
 		break;
@@ -5828,6 +5821,15 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 	case CPU_ONLINE_FROZEN:
 		/* Strictly unnecessary, as first user will wake it. */
 		wake_up_process(cpu_rq(cpu)->migration_thread);
+
+		/* Update our root-domain */
+		rq = cpu_rq(cpu);
+		spin_lock_irqsave(&rq->lock, flags);
+		if (rq->rd) {
+			BUG_ON(!cpu_isset(cpu, rq->rd->span));
+			cpu_set(cpu, rq->rd->online);
+		}
+		spin_unlock_irqrestore(&rq->lock, flags);
 		break;
 
 #ifdef CONFIG_HOTPLUG_CPU
@@ -6103,6 +6105,8 @@ static void rq_attach_root(struct rq *rq, struct root_domain *rd)
 	rq->rd = rd;
 
 	cpu_set(rq->cpu, rd->span);
+	if (cpu_isset(rq->cpu, cpu_online_map))
+		cpu_set(rq->cpu, rd->online);
 
 	for (class = sched_class_highest; class; class = class->next) {
 		if (class->join_domain)

