Return-Path: <linux-kernel-owner+w=401wt.eu-S933963AbZFOTIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933963AbZFOTIi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 15:08:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933932AbZFOTIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 15:08:07 -0400
Received: from ms01.sssup.it ([193.205.80.99]:58758 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933880AbZFOTIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 15:08:06 -0400
Date: Mon, 15 Jun 2009 21:09:09 +0200
From: Fabio Checconi <fchecconi@gmail.com>
To: mingo@elte.hu, a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 8/8] Use hrtick when available
Message-ID: <20090615190909.GR21741@gandalf.sssup.it>
References: <cover.1245092261.git.fabio@helm.retis>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1245092261.git.fabio@helm.retis>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To have a more precise budget enforcement, use the hrtick when available.
This comes at the cost of additional overhead; anyway it is disabled by
default.
---
 kernel/sched_rt.c |   32 +++++++++++++++++++++++++++++++-
 1 files changed, 31 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index a9db16b..38a7be0 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1150,14 +1150,41 @@ static struct task_struct *_pick_next_task_rt(struct rq *rq)
 	return p;
 }
 
+static void rt_start_hrtick(struct rq *rq, struct task_struct *p)
+{
+	struct sched_rt_entity *rt_se = &p->rt;
+	struct rt_rq *rt_rq;
+	s64 delta, expires = global_rt_period();
+
+	for_each_sched_rt_entity(rt_se) {
+		rt_rq = rt_rq_of_se(rt_se);
+		delta = rt_rq->rt_runtime - rt_rq->rt_time;
+		expires = min(expires, delta);
+	}
+
+	/*
+	 * Given the current handling of hrtick in sched_fair, this
+	 * may interfere with sched_fair tasks, generating a spurious
+	 * tick when switching from an RT to a SCHED_OTHER task.
+	 * This is due to the fact that sched_fair reprograms the
+	 * hrtick only in its enqueue/dequeue codepaths.
+	 */
+	if (expires > 10000)
+		hrtick_start(rq, expires);
+}
+
 static struct task_struct *pick_next_task_rt(struct rq *rq)
 {
 	struct task_struct *p = _pick_next_task_rt(rq);
 
 	/* The running task is never eligible for pushing */
-	if (p)
+	if (p) {
 		dequeue_pushable_task(rq, p);
 
+		if (hrtick_enabled(rq))
+			rt_start_hrtick(rq, p);
+	}
+
 	return p;
 }
 
@@ -1794,6 +1821,9 @@ static void task_tick_rt(struct rq *rq, struct task_struct *p, int queued)
 {
 	update_curr_rt(rq);
 
+	if (queued)
+		return;
+
 	watchdog(rq, p);
 
 	/*
-- 
1.6.2.2
