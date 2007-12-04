Return-Path: <linux-kernel-owner+w=401wt.eu-S1755411AbXLDVLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411AbXLDVLg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 16:11:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754395AbXLDVHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 16:07:25 -0500
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:53461
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754814AbXLDVHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 16:07:22 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 11/23] Subject: SCHED - Break out the search function
To: mingo@elte.hu
Cc: rostedt@goodmis.org, ghaskins@novell.com, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Tue, 04 Dec 2007 15:45:21 -0500
Message-ID: <20071204204521.3567.2646.stgit@novell1.haskins.net>
In-Reply-To: <20071204204236.3567.65491.stgit@novell1.haskins.net>
References: <20071204204236.3567.65491.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Isolate the search logic into a function so that it can be used later
in places other than find_locked_lowest_rq().

(Checkpatch error is inherited from moved code)

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---

 kernel/sched_rt.c |   66 +++++++++++++++++++++++++++++++----------------------
 1 files changed, 39 insertions(+), 27 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index da21c7a..7e26c2c 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -261,54 +261,66 @@ static struct task_struct *pick_next_highest_task_rt(struct rq *rq,
 
 static DEFINE_PER_CPU(cpumask_t, local_cpu_mask);
 
-/* Will lock the rq it finds */
-static struct rq *find_lock_lowest_rq(struct task_struct *task,
-				      struct rq *this_rq)
+static int find_lowest_rq(struct task_struct *task)
 {
-	struct rq *lowest_rq = NULL;
 	int cpu;
-	int tries;
 	cpumask_t *cpu_mask = &__get_cpu_var(local_cpu_mask);
+	struct rq *lowest_rq = NULL;
 
 	cpus_and(*cpu_mask, cpu_online_map, task->cpus_allowed);
 
-	for (tries = 0; tries < RT_MAX_TRIES; tries++) {
-		/*
-		 * Scan each rq for the lowest prio.
-		 */
-		for_each_cpu_mask(cpu, *cpu_mask) {
-			struct rq *rq = &per_cpu(runqueues, cpu);
+	/*
+	 * Scan each rq for the lowest prio.
+	 */
+	for_each_cpu_mask(cpu, *cpu_mask) {
+		struct rq *rq = cpu_rq(cpu);
 
-			if (cpu == this_rq->cpu)
-				continue;
+		if (cpu == rq->cpu)
+			continue;
 
-			/* We look for lowest RT prio or non-rt CPU */
-			if (rq->rt.highest_prio >= MAX_RT_PRIO) {
-				lowest_rq = rq;
-				break;
-			}
+		/* We look for lowest RT prio or non-rt CPU */
+		if (rq->rt.highest_prio >= MAX_RT_PRIO) {
+			lowest_rq = rq;
+			break;
+		}
 
-			/* no locking for now */
-			if (rq->rt.highest_prio > task->prio &&
-			    (!lowest_rq || rq->rt.highest_prio > lowest_rq->rt.highest_prio)) {
-				lowest_rq = rq;
-			}
+		/* no locking for now */
+		if (rq->rt.highest_prio > task->prio &&
+		    (!lowest_rq || rq->rt.highest_prio > lowest_rq->rt.highest_prio)) {
+			lowest_rq = rq;
 		}
+	}
+
+	return lowest_rq ? lowest_rq->cpu : -1;
+}
+
+/* Will lock the rq it finds */
+static struct rq *find_lock_lowest_rq(struct task_struct *task,
+				      struct rq *rq)
+{
+	struct rq *lowest_rq = NULL;
+	int cpu;
+	int tries;
 
-		if (!lowest_rq)
+	for (tries = 0; tries < RT_MAX_TRIES; tries++) {
+		cpu = find_lowest_rq(task);
+
+		if (cpu == -1)
 			break;
 
+		lowest_rq = cpu_rq(cpu);
+
 		/* if the prio of this runqueue changed, try again */
-		if (double_lock_balance(this_rq, lowest_rq)) {
+		if (double_lock_balance(rq, lowest_rq)) {
 			/*
 			 * We had to unlock the run queue. In
 			 * the mean time, task could have
 			 * migrated already or had its affinity changed.
 			 * Also make sure that it wasn't scheduled on its rq.
 			 */
-			if (unlikely(task_rq(task) != this_rq ||
+			if (unlikely(task_rq(task) != rq ||
 				     !cpu_isset(lowest_rq->cpu, task->cpus_allowed) ||
-				     task_running(this_rq, task) ||
+				     task_running(rq, task) ||
 				     !task->se.on_rq)) {
 				spin_unlock(&lowest_rq->lock);
 				lowest_rq = NULL;

