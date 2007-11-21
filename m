Return-Path: <linux-kernel-owner+w=401wt.eu-S1756663AbXKUE1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663AbXKUE1L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 23:27:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752637AbXKUE05
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 23:26:57 -0500
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:55220 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472AbXKUE04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 23:26:56 -0500
Date: Tue, 20 Nov 2007 23:26:35 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Gregory Haskins <ghaskins@novell.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <clameter@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Fix optimized search
Message-ID: <20071121042635.GB24815@goodmis.org>
References: <20071121021057.GA24815@goodmis.org> <20071121030838.16020.59975.stgit@novell1.haskins.net> <4743B0F4.8000302@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4743B0F4.8000302@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2007 at 11:15:48PM -0500, Steven Rostedt wrote:
> Gregory Haskins wrote:
>> I spied a few more issues from http://lkml.org/lkml/2007/11/20/590.
>> Patch is below..
>
> Thanks, but I have one update...
>

Here's the updated patch.

Oh, and Gregory, please email me at my rostedt@goodmis.org account. It
has better filters ;-)

This series is at:

  http://rostedt.homelinux.com/rt/rt-balance-patches-v6.tar.bz2

===

This patch removes several cpumask operations by keeping track
of the first of the CPUS that is of the lowest priority. When
the search for the lowest priority runqueue is completed, all
the bits up to the first CPU with the lowest priority runqueue
is cleared.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>

---
 kernel/sched_rt.c |   49 ++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 36 insertions(+), 13 deletions(-)

Index: linux-compile.git/kernel/sched_rt.c
===================================================================
--- linux-compile.git.orig/kernel/sched_rt.c	2007-11-20 23:17:43.000000000 -0500
+++ linux-compile.git/kernel/sched_rt.c	2007-11-20 23:18:21.000000000 -0500
@@ -293,29 +293,36 @@ static struct task_struct *pick_next_hig
 }
 
 static DEFINE_PER_CPU(cpumask_t, local_cpu_mask);
-static DEFINE_PER_CPU(cpumask_t, valid_cpu_mask);
 
 static int find_lowest_cpus(struct task_struct *task, cpumask_t *lowest_mask)
 {
-	int       cpu;
-	cpumask_t *valid_mask = &__get_cpu_var(valid_cpu_mask);
 	int       lowest_prio = -1;
+	int       lowest_cpu  = -1;
 	int       count       = 0;
+	int       cpu;
 
-	cpus_clear(*lowest_mask);
-	cpus_and(*valid_mask, cpu_online_map, task->cpus_allowed);
+	cpus_and(*lowest_mask, cpu_online_map, task->cpus_allowed);
 
 	/*
 	 * Scan each rq for the lowest prio.
 	 */
-	for_each_cpu_mask(cpu, *valid_mask) {
+	for_each_cpu_mask(cpu, *lowest_mask) {
 		struct rq *rq = cpu_rq(cpu);
 
 		/* We look for lowest RT prio or non-rt CPU */
 		if (rq->rt.highest_prio >= MAX_RT_PRIO) {
-			if (count)
+			/*
+			 * if we already found a low RT queue
+			 * and now we found this non-rt queue
+			 * clear the mask and set our bit.
+			 * Otherwise just return the queue as is
+			 * and the count==1 will cause the algorithm
+			 * to use the first bit found.
+			 */
+			if (lowest_cpu != -1) {
 				cpus_clear(*lowest_mask);
-			cpu_set(rq->cpu, *lowest_mask);
+				cpu_set(rq->cpu, *lowest_mask);
+			}
 			return 1;
 		}
 
@@ -325,13 +332,29 @@ static int find_lowest_cpus(struct task_
 			if (rq->rt.highest_prio > lowest_prio) {
 				/* new low - clear old data */
 				lowest_prio = rq->rt.highest_prio;
-				if (count) {
-					cpus_clear(*lowest_mask);
-					count = 0;
-				}
+				lowest_cpu = cpu;
+				count = 0;
 			}
-			cpu_set(rq->cpu, *lowest_mask);
 			count++;
+		} else
+			cpu_clear(cpu, *lowest_mask);
+	}
+
+	/*
+	 * Clear out all the set bits that represent
+	 * runqueues that were of higher prio than
+	 * the lowest_prio.
+	 */
+	if (lowest_cpu > 0) {
+		/*
+		 * Perhaps we could add another cpumask op to
+		 * zero out bits. Like cpu_zero_bits(cpumask, nrbits);
+		 * Then that could be optimized to use memset and such.
+		 */
+		for_each_cpu_mask(cpu, *lowest_mask) {
+			if (cpu >= lowest_cpu)
+				break;
+			cpu_clear(cpu, *lowest_mask);
 		}
 	}
 
