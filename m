Return-Path: <linux-kernel-owner+w=401wt.eu-S1754157AbZLHLcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157AbZLHLcA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 06:32:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754034AbZLHLb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 06:31:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:36050 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753848AbZLHLb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 06:31:58 -0500
Date: Tue, 8 Dec 2009 11:31:16 GMT
From: tip-bot for Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, rusty@rustcorp.com.au,
       peterz@infradead.org, fweisbec@gmail.com, akpm@linux-foundation.org,
       tj@kernel.org, tglx@linutronix.de, sfr@canb.auug.org.au, mingo@elte.hu,
       cl@linux-foundation.org
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au, torvalds@linux-foundation.org,
       peterz@infradead.org, fweisbec@gmail.com, akpm@linux-foundation.org,
       tj@kernel.org, sfr@canb.auug.org.au, tglx@linutronix.de,
       cl@linux-foundation.org, mingo@elte.hu
In-Reply-To: <20091208182515.bb6dda4a.sfr@canb.auug.org.au>
References: <20091208182515.bb6dda4a.sfr@canb.auug.org.au>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: hw_breakpoints: Fix percpu namespace clash
Message-ID: <tip-6ab8886326a1b9a3a8d164d8174e3c20703a03a2@git.kernel.org>
Git-Commit-ID: 6ab8886326a1b9a3a8d164d8174e3c20703a03a2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6ab8886326a1b9a3a8d164d8174e3c20703a03a2
Gitweb:     http://git.kernel.org/tip/6ab8886326a1b9a3a8d164d8174e3c20703a03a2
Author:     Stephen Rothwell <sfr@canb.auug.org.au>
AuthorDate: Tue, 8 Dec 2009 18:25:15 +1100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 8 Dec 2009 09:34:43 +0100

perf: hw_breakpoints: Fix percpu namespace clash

Today's linux-next build failed with:

  kernel/hw_breakpoint.c:86: error: 'task_bp_pinned' redeclared as different kind of symbol
  ...

Caused by commit dd17c8f72993f9461e9c19250e3f155d6d99df22 ("percpu:
remove per_cpu__ prefix") from the percpu tree interacting with
commit 56053170ea2a2c0dc17420e9b94aa3ca51d80408 ("hw-breakpoints:
Fix task-bound breakpoint slot allocation") from the tip tree.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <20091208182515.bb6dda4a.sfr@canb.auug.org.au>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/hw_breakpoint.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
index 02b4925..03a0773 100644
--- a/kernel/hw_breakpoint.c
+++ b/kernel/hw_breakpoint.c
@@ -52,7 +52,7 @@
 static DEFINE_PER_CPU(unsigned int, nr_cpu_bp_pinned);
 
 /* Number of pinned task breakpoints in a cpu */
-static DEFINE_PER_CPU(unsigned int, task_bp_pinned[HBP_NUM]);
+static DEFINE_PER_CPU(unsigned int, nr_task_bp_pinned[HBP_NUM]);
 
 /* Number of non-pinned cpu/task breakpoints in a cpu */
 static DEFINE_PER_CPU(unsigned int, nr_bp_flexible);
@@ -73,7 +73,7 @@ static DEFINE_MUTEX(nr_bp_mutex);
 static unsigned int max_task_bp_pinned(int cpu)
 {
 	int i;
-	unsigned int *tsk_pinned = per_cpu(task_bp_pinned, cpu);
+	unsigned int *tsk_pinned = per_cpu(nr_task_bp_pinned, cpu);
 
 	for (i = HBP_NUM -1; i >= 0; i--) {
 		if (tsk_pinned[i] > 0)
@@ -162,7 +162,7 @@ static void toggle_bp_task_slot(struct task_struct *tsk, int cpu, bool enable)
 
 	count = task_bp_pinned(tsk);
 
-	tsk_pinned = per_cpu(task_bp_pinned, cpu);
+	tsk_pinned = per_cpu(nr_task_bp_pinned, cpu);
 	if (enable) {
 		tsk_pinned[count]++;
 		if (count > 0)
@@ -209,7 +209,7 @@ static void toggle_bp_slot(struct perf_event *bp, bool enable)
  *   - If attached to a single cpu, check:
  *
  *       (per_cpu(nr_bp_flexible, cpu) || (per_cpu(nr_cpu_bp_pinned, cpu)
- *           + max(per_cpu(task_bp_pinned, cpu)))) < HBP_NUM
+ *           + max(per_cpu(nr_task_bp_pinned, cpu)))) < HBP_NUM
  *
  *       -> If there are already non-pinned counters in this cpu, it means
  *          there is already a free slot for them.
@@ -220,7 +220,7 @@ static void toggle_bp_slot(struct perf_event *bp, bool enable)
  *   - If attached to every cpus, check:
  *
  *       (per_cpu(nr_bp_flexible, *) || (max(per_cpu(nr_cpu_bp_pinned, *))
- *           + max(per_cpu(task_bp_pinned, *)))) < HBP_NUM
+ *           + max(per_cpu(nr_task_bp_pinned, *)))) < HBP_NUM
  *
  *       -> This is roughly the same, except we check the number of per cpu
  *          bp for every cpu and we keep the max one. Same for the per tasks
@@ -232,7 +232,7 @@ static void toggle_bp_slot(struct perf_event *bp, bool enable)
  *   - If attached to a single cpu, check:
  *
  *       ((per_cpu(nr_bp_flexible, cpu) > 1) + per_cpu(nr_cpu_bp_pinned, cpu)
- *            + max(per_cpu(task_bp_pinned, cpu))) < HBP_NUM
+ *            + max(per_cpu(nr_task_bp_pinned, cpu))) < HBP_NUM
  *
  *       -> Same checks as before. But now the nr_bp_flexible, if any, must keep
  *          one register at least (or they will never be fed).
@@ -240,7 +240,7 @@ static void toggle_bp_slot(struct perf_event *bp, bool enable)
  *   - If attached to every cpus, check:
  *
  *       ((per_cpu(nr_bp_flexible, *) > 1) + max(per_cpu(nr_cpu_bp_pinned, *))
- *            + max(per_cpu(task_bp_pinned, *))) < HBP_NUM
+ *            + max(per_cpu(nr_task_bp_pinned, *))) < HBP_NUM
  */
 int reserve_bp_slot(struct perf_event *bp)
 {
