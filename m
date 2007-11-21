Return-Path: <linux-kernel-owner+w=401wt.eu-S1756702AbXKUFES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702AbXKUFES (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 00:04:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753610AbXKUFDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 00:03:50 -0500
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:48887
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753356AbXKUFDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 00:03:48 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 1/4] Fix optimized search
To: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <srostedt@redhat.com>
Cc: Christoph Lameter <clameter@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Gregory Haskins <ghaskins@novell.com>
Date: Tue, 20 Nov 2007 23:44:06 -0500
Message-ID: <20071121044406.6315.82159.stgit@novell1.haskins.net>
In-Reply-To: <20071121043648.6315.29246.stgit@novell1.haskins.net>
References: <20071121043648.6315.29246.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Include cpu 0 in the search, and eliminate the redundant cpu_set since
the bit should already be set in the mask.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/sched_rt.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 28feeff..fbf4fb1 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -297,7 +297,7 @@ static DEFINE_PER_CPU(cpumask_t, local_cpu_mask);
 static int find_lowest_cpus(struct task_struct *task, cpumask_t *lowest_mask)
 {
 	int       lowest_prio = -1;
-	int       lowest_cpu  = 0;
+	int       lowest_cpu  = -1;
 	int       count       = 0;
 	int       cpu;
 
@@ -319,7 +319,7 @@ static int find_lowest_cpus(struct task_struct *task, cpumask_t *lowest_mask)
 			 * and the count==1 will cause the algorithm
 			 * to use the first bit found.
 			 */
-			if (lowest_cpu) {
+			if (lowest_cpu != -1) {
 				cpus_clear(*lowest_mask);
 				cpu_set(rq->cpu, *lowest_mask);
 			}
@@ -335,7 +335,6 @@ static int find_lowest_cpus(struct task_struct *task, cpumask_t *lowest_mask)
 				lowest_cpu = cpu;
 				count = 0;
 			}
-			cpu_set(rq->cpu, *lowest_mask);
 			count++;
 		} else
 			cpu_clear(cpu, *lowest_mask);
@@ -346,7 +345,7 @@ static int find_lowest_cpus(struct task_struct *task, cpumask_t *lowest_mask)
 	 * runqueues that were of higher prio than
 	 * the lowest_prio.
 	 */
-	if (lowest_cpu) {
+	if (lowest_cpu != -1) {
 		/*
 		 * Perhaps we could add another cpumask op to
 		 * zero out bits. Like cpu_zero_bits(cpumask, nrbits);

