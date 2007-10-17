Return-Path: <linux-kernel-owner+w=401wt.eu-S1761713AbXJQTFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761713AbXJQTFt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 15:05:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760360AbXJQTEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 15:04:38 -0400
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:53149
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760109AbXJQTEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 15:04:36 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 3/9] RT: Wrap the RQ notion of priority to make it conditional
To: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Gregory Haskins <ghaskins@novell.com>
Date: Wed, 17 Oct 2007 14:50:42 -0400
Message-ID: <20071017185042.11272.57681.stgit@novell1.haskins.net>
In-Reply-To: <20071017184745.11272.10024.stgit@novell1.haskins.net>
References: <20071017184745.11272.10024.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A little cleanup to avoid #ifdef proliferation later in the series

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/sched.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 0da8c30..131f618 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -365,6 +365,16 @@ struct rq {
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
 static DEFINE_MUTEX(sched_hotcpu_mutex);
 
+#if defined(CONFIG_PREEMPT_RT) && defined(CONFIG_SMP)
+static inline void set_rq_prio(struct rq *rq, int prio)
+{
+	rq->curr_prio = prio;
+}
+
+#else
+#define set_rq_prio(rq, prio) do { } while(0)
+#endif
+
 static inline void check_preempt_curr(struct rq *rq, struct task_struct *p)
 {
 	rq->curr->sched_class->check_preempt_curr(rq, p);
@@ -2328,9 +2338,9 @@ static inline void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	 */
 	prev_state = prev->state;
 	_finish_arch_switch(prev);
-#if defined(CONFIG_PREEMPT_RT) && defined(CONFIG_SMP)
-	rq->curr_prio = current->prio;
-#endif
+
+	set_rq_prio(rq, current->prio);
+
 	finish_lock_switch(rq, prev);
 #if defined(CONFIG_PREEMPT_RT) && defined(CONFIG_SMP)
 	/*

