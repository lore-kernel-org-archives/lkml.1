Return-Path: <linux-kernel-owner+w=401wt.eu-S1760762AbXJMAaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760762AbXJMAaH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 20:30:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759963AbXJMA3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 20:29:06 -0400
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:33475
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759145AbXJMA3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 20:29:04 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 2/7] RT: Wrap the RQ notion of priority to make it conditional
To: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Gregory Haskins <ghaskins@novell.com>
Date: Fri, 12 Oct 2007 20:15:44 -0400
Message-ID: <20071013001543.7444.6025.stgit@novell1.haskins.net>
In-Reply-To: <20071013001052.7444.8363.stgit@novell1.haskins.net>
References: <20071013001052.7444.8363.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A little cleanup to avoid #ifdef proliferation later in the series

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/sched.c |   23 ++++++++++++++++++++---
 1 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 0a1ad0e..c9afc8a 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -255,6 +255,10 @@ struct cfs_rq {
 #endif
 };
 
+#if defined(CONFIG_PREEMPT_RT) && defined(CONFIG_SMP)
+#define  ENABLE_RQ_PRIORITY   /* Steve wants this conditional on PREEMPT_RT */
+#endif /* CONFIG_PREEMPT_RT */
+
 /* Real-Time classes' related field in a runqueue: */
 struct rt_rq {
 	struct rt_prio_array active;
@@ -304,6 +308,9 @@ struct rq {
 #ifdef CONFIG_PREEMPT_RT
 	unsigned long rt_nr_running;
 	unsigned long rt_nr_uninterruptible;
+#endif
+
+#ifdef ENABLE_RQ_PRIORITY
 	int curr_prio;
 #endif
 
@@ -365,6 +372,16 @@ struct rq {
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
 static DEFINE_MUTEX(sched_hotcpu_mutex);
 
+#ifdef ENABLE_RQ_PRIORITY
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
@@ -2331,9 +2348,9 @@ static inline void finish_task_switch(struct rq *rq, struct task_struct *prev)
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

