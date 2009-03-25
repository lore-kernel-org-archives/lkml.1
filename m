Return-Path: <linux-kernel-owner+w=401wt.eu-S1757580AbZCYFVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580AbZCYFVP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 01:21:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753446AbZCYFU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 01:20:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:44403 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777AbZCYFU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 01:20:26 -0400
Message-Id: <20090325052023.387662292@goodmis.org>
References: <20090325051920.406564281@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 25 Mar 2009 01:19:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 3/5] sched: remove unlikely in pre_schedule_rt
Content-Disposition: inline; filename=0003-sched-remove-unlikely-in-pre_schedule_rt.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

Impact: clean up

The annotated branch profiler shows that the unlikely used by
pre_schedule_rt is always incorrect. This makes sense because in
sched.c we have:

	if (prev->sched_class->pre_schedule)
		prev->sched_class->pre_schedule(rq, prev);

And we are saying that prev is unlikely to be an rt task. This looks
more like a likely candidate to me.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/sched_rt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index bac1061..537af77 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1260,7 +1260,7 @@ static int pull_rt_task(struct rq *this_rq)
 static void pre_schedule_rt(struct rq *rq, struct task_struct *prev)
 {
 	/* Try to pull RT tasks here if we lower this rq's prio */
-	if (unlikely(rt_task(prev)) && rq->rt.highest_prio > prev->prio)
+	if (rt_task(prev) && rq->rt.highest_prio > prev->prio)
 		pull_rt_task(rq);
 }
 
-- 
1.6.2

-- 
