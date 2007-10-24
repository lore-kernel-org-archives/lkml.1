Return-Path: <linux-kernel-owner+w=401wt.eu-S1759555AbXJXOJE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759555AbXJXOJE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 10:09:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758317AbXJXOHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 10:07:41 -0400
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:49099
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758883AbXJXOHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 10:07:39 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 5/9] RT: Wrap the RQ notion of priority to make it conditional
To: linux-rt-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Gregory Haskins <ghaskins@novell.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Darren Hart <dvhltc@us.ibm.com>
Date: Wed, 24 Oct 2007 09:52:59 -0400
Message-ID: <20071024135259.7960.18676.stgit@novell1.haskins.net>
In-Reply-To: <20071024134431.7960.41984.stgit@novell1.haskins.net>
References: <20071024134431.7960.41984.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A little cleanup to avoid #ifdef proliferation later in the series

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/sched.c |   18 +++++++++++++++---
 1 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 7b9b481..ce5292f 100644
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
@@ -2326,9 +2336,9 @@ static inline void finish_task_switch(struct rq *rq, struct task_struct *prev)
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
@@ -7383,6 +7393,8 @@ void __init sched_init(void)
 		highest_cpu = i;
 		/* delimiter for bitsearch: */
 		__set_bit(MAX_RT_PRIO, array->bitmap);
+
+		set_rq_prio(rq, MAX_PRIO);
 	}
 
 	set_load_weight(&init_task);

