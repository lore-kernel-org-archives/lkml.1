Return-Path: <linux-kernel-owner+w=401wt.eu-S932812AbXKQGZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932812AbXKQGZ5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 01:25:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757592AbXKQGYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 01:24:36 -0500
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:51400 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756282AbXKQGYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 01:24:34 -0500
Message-Id: <20071117062403.702445167@goodmis.org>
References: <20071117062104.177779113@goodmis.org>
User-Agent: quilt/0.46-1
Date: Sat, 17 Nov 2007 01:21:08 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Gregory Haskins <ghaskins@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@sgi.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH v3 04/17] RT overloaded runqueues accounting
Content-Disposition: inline; filename=rt-overload.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an RT overload accounting system. When a runqueue has
more than one RT task queued, it is marked as overloaded. That is that it
is a candidate to have RT tasks pulled from it.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/sched_rt.c |   36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

Index: linux-compile.git/kernel/sched_rt.c
===================================================================
--- linux-compile.git.orig/kernel/sched_rt.c	2007-11-16 21:56:29.000000000 -0500
+++ linux-compile.git/kernel/sched_rt.c	2007-11-16 22:12:07.000000000 -0500
@@ -3,6 +3,38 @@
  * policies)
  */
 
+#ifdef CONFIG_SMP
+static cpumask_t rt_overload_mask;
+static atomic_t rto_count;
+static inline int rt_overloaded(void)
+{
+	return atomic_read(&rto_count);
+}
+static inline cpumask_t *rt_overload(void)
+{
+	return &rt_overload_mask;
+}
+static inline void rt_set_overload(struct rq *rq)
+{
+	cpu_set(rq->cpu, rt_overload_mask);
+	/*
+	 * Make sure the mask is visible before we set
+	 * the overload count. That is checked to determine
+	 * if we should look at the mask. It would be a shame
+	 * if we looked at the mask, but the mask was not
+	 * updated yet.
+	 */
+	wmb();
+	atomic_inc(&rto_count);
+}
+static inline void rt_clear_overload(struct rq *rq)
+{
+	/* the order here really doesn't matter */
+	atomic_dec(&rto_count);
+	cpu_clear(rq->cpu, rt_overload_mask);
+}
+#endif /* CONFIG_SMP */
+
 /*
  * Update the current task's runtime statistics. Skip current tasks that
  * are not in our scheduling class.
@@ -32,6 +64,8 @@ static inline void inc_rt_tasks(struct t
 #ifdef CONFIG_SMP
 	if (p->prio < rq->rt.highest_prio)
 		rq->rt.highest_prio = p->prio;
+	if (rq->rt.rt_nr_running > 1)
+		rt_set_overload(rq);
 #endif /* CONFIG_SMP */
 }
 
@@ -53,6 +87,8 @@ static inline void dec_rt_tasks(struct t
 		} /* otherwise leave rq->highest prio alone */
 	} else
 		rq->rt.highest_prio = MAX_RT_PRIO;
+	if (rq->rt.rt_nr_running < 2)
+		rt_clear_overload(rq);
 #endif /* CONFIG_SMP */
 }
 

-- 
