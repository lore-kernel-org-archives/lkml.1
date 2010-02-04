Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062Ab0BDJ4t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 04:56:49 -0500
Received: from hera.kernel.org ([140.211.167.34]:60076 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758003Ab0BDJ4m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 04:56:42 -0500
Date: Thu, 4 Feb 2010 09:56:10 GMT
From: tip-bot for Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, rusty@rustcorp.com.au, yong.zhang0@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       yong.zhang0@gmail.com, mingo@elte.hu
In-Reply-To: <2674af741001282257r28c97a92o9f90cf16fe8d3d84@mail.gmail.com>
References: <2674af741001282257r28c97a92o9f90cf16fe8d3d84@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Change usage of rt_rq->rt_se to rt_rq->tg->rt_se[cpu]
Message-ID: <tip-74b7eb5885415ed41d012f432398d1b697115b5f@git.kernel.org>
Git-Commit-ID: 74b7eb5885415ed41d012f432398d1b697115b5f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 04 Feb 2010 09:56:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  74b7eb5885415ed41d012f432398d1b697115b5f
Gitweb:     http://git.kernel.org/tip/74b7eb5885415ed41d012f432398d1b697115b5f
Author:     Yong Zhang <yong.zhang0@gmail.com>
AuthorDate: Fri, 29 Jan 2010 14:57:52 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 4 Feb 2010 09:57:32 +0100

sched: Change usage of rt_rq->rt_se to rt_rq->tg->rt_se[cpu]

This is the first step to remove rt_rq member rt_se because it have the
same meaning with tg->rt_se[cpu]. And the latter style is also used by
the fair scheduling class.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <2674af741001282257r28c97a92o9f90cf16fe8d3d84@mail.gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_rt.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index ca49ceb..bf3e38f 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -199,8 +199,11 @@ static void dequeue_rt_entity(struct sched_rt_entity *rt_se);
 
 static void sched_rt_rq_enqueue(struct rt_rq *rt_rq)
 {
+	int this_cpu = smp_processor_id();
 	struct task_struct *curr = rq_of_rt_rq(rt_rq)->curr;
-	struct sched_rt_entity *rt_se = rt_rq->rt_se;
+	struct sched_rt_entity *rt_se;
+
+	rt_se = rt_rq->tg->rt_se[this_cpu];
 
 	if (rt_rq->rt_nr_running) {
 		if (rt_se && !on_rt_rq(rt_se))
@@ -212,7 +215,10 @@ static void sched_rt_rq_enqueue(struct rt_rq *rt_rq)
 
 static void sched_rt_rq_dequeue(struct rt_rq *rt_rq)
 {
-	struct sched_rt_entity *rt_se = rt_rq->rt_se;
+	int this_cpu = smp_processor_id();
+	struct sched_rt_entity *rt_se;
+
+	rt_se = rt_rq->tg->rt_se[this_cpu];
 
 	if (rt_se && on_rt_rq(rt_se))
 		dequeue_rt_entity(rt_se);
