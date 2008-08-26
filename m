Return-Path: <linux-kernel-owner+w=401wt.eu-S1759286AbYHZRh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759286AbYHZRh6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 13:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757562AbYHZRhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 13:37:15 -0400
Received: from 75-130-108-43.dhcp.oxfr.ma.charter.com ([75.130.108.43]:54161
	"EHLO dev.haskins.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757369AbYHZRhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 13:37:12 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH v2 2/6] sched: pull only one task during NEWIDLE balancing to
	limit critical section
To: mingo@elte.hu
Cc: srostedt@redhat.com, peterz@infradead.org, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, npiggin@suse.de,
       gregory.haskins@gmail.com
Date: Tue, 26 Aug 2008 13:34:54 -0400
Message-ID: <20080826173454.16413.10021.stgit@dev.haskins.net>
In-Reply-To: <20080826173131.16413.17862.stgit@dev.haskins.net>
References: <20080826173131.16413.17862.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

git-id c4acb2c0669c5c5c9b28e9d02a34b5c67edf7092 attempted to limit
newidle critical section length by stopping after at least one task
was moved.  Further investigation has shown that there are other
paths nested further inside the algorithm which still remain that allow
long latencies to occur with newidle balancing.  This patch applies
the same technique inside balance_tasks() to limit the duration of
this optional balancing operation.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
CC: Nick Piggin <npiggin@suse.de>
---

 kernel/sched.c |   18 +++++++++++++++++-
 1 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 6a43c89..df6b447 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2962,6 +2962,16 @@ next:
 	pulled++;
 	rem_load_move -= p->se.load.weight;
 
+#ifdef CONFIG_PREEMPT
+	/*
+	 * NEWIDLE balancing is a source of latency, so preemptible kernels
+	 * will stop after the first task is pulled to minimize the critical
+	 * section.
+	 */
+	if (idle == CPU_NEWLY_IDLE)
+		goto out;
+#endif
+
 	/*
 	 * We only want to steal up to the prescribed amount of weighted load.
 	 */
@@ -3008,9 +3018,15 @@ static int move_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
 				sd, idle, all_pinned, &this_best_prio);
 		class = class->next;
 
+#ifdef CONFIG_PREEMPT
+		/*
+		 * NEWIDLE balancing is a source of latency, so preemptible
+		 * kernels will stop after the first task is pulled to minimize
+		 * the critical section.
+		 */
 		if (idle == CPU_NEWLY_IDLE && this_rq->nr_running)
 			break;
-
+#endif
 	} while (class && max_load_move > total_load_moved);
 
 	return total_load_moved > 0;

