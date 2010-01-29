Return-Path: <linux-kernel-owner+w=401wt.eu-S1753304Ab0A2G5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304Ab0A2G5z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 01:57:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752054Ab0A2G5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 01:57:54 -0500
Received: from mail-pz0-f189.google.com ([209.85.222.189]:45274 "EHLO
	mail-pz0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab0A2G5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 01:57:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=nMhJurSn3WZ81OWkjvcLPmLZkI96vq42o4F0yQhek7fXMVBMokr40ac1VmsJl+z8H2
         nwvjeomUoGvfuRDHUvK3+IZAmjn287OA1KSuFjvePFR2v326qCZva+8+amcy+beWlffJ
         aPcdzTM9pPcdj2P/Y4cGoO7RXuiJO+iczUSJk=
MIME-Version: 1.0
Date: Fri, 29 Jan 2010 14:57:52 +0800
Message-ID: <2674af741001282257r28c97a92o9f90cf16fe8d3d84@mail.gmail.com>
Subject: [RFC PATCH 1/2] sched: change usage of rt_rq->rt_se to 
	rt_rq->tg->rt_se[cpu]
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, rusty <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the first step to remove rt_rq member rt_se because
it have the same meaning with tg->rt_se[cpu]. And the latter
style is also used by CFS.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>
---
 kernel/sched_rt.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index f48328a..b175a98 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -199,8 +199,11 @@ static void dequeue_rt_entity(struct
sched_rt_entity *rt_se);

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
-- 
1.6.3.3
