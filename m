Return-Path: <linux-kernel-owner+w=401wt.eu-S1753779AbZLHHZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779AbZLHHZR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 02:25:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752686AbZLHHZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 02:25:16 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:58319 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020AbZLHHZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 02:25:15 -0500
Date: Tue, 8 Dec 2009 18:25:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: percpu/tip tree build failure
Message-Id: <20091208182515.bb6dda4a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta3 (GTK+ 2.18.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next build (x86_64 allmodconfig) failed like this:

kernel/hw_breakpoint.c:86: error: 'task_bp_pinned' redeclared as different kind of symbol
kernel/hw_breakpoint.c:55: note: previous declaration of 'task_bp_pinned' was here
kernel/hw_breakpoint.c: In function 'toggle_bp_task_slot':
kernel/hw_breakpoint.c:165: warning: assignment from incompatible pointer type

Caused by commit dd17c8f72993f9461e9c19250e3f155d6d99df22 ("percpu:
remove per_cpu__ prefix") from the percpu tree interacting with commit
56053170ea2a2c0dc17420e9b94aa3ca51d80408 ("hw-breakpoints: Fix task-bound
breakpoint slot allocation") from the tip tree.

I have applied the following patch for today (and can carry it as
necessary:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 8 Dec 2009 18:19:48 +1100
Subject: [PATCH] percpu: make per_cpu variable name unique in hw_breakpoint.c

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
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
-- 
1.6.5.3

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
