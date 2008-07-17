Return-Path: <linux-kernel-owner+w=401wt.eu-S932825AbYGQUh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932825AbYGQUh7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 16:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753761AbYGQUhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 16:37:51 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:21371 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409AbYGQUht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 16:37:49 -0400
From: Daniel Walker <dwalker@mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] sched: sched_rt.c unused struct rq warning fix
Date: Thu, 17 Jul 2008 13:37:39 -0700
Message-Id: <1216327059-22706-1-git-send-email-dwalker@mvista.com>
X-Mailer: git-send-email 1.5.5.1.32.gba7d2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

following warning,

In file included from /localuser/dwalker/linus/kernel/sched.c:1675:
/localuser/dwalker/linus/kernel/sched_rt.c: In function ‘inc_rt_tasks’:
/localuser/dwalker/linus/kernel/sched_rt.c:508: warning: unused variable ‘rq’

looks to be caused by,

commit 1100ac91b6af02d8639d518fad5b434b1bf44ed6
Author: Ingo Molnar <mingo@elte.hu>
Date:   Thu Jun 5 12:25:37 2008 +0200

    sched: fix cpuprio build bug

    this patch was not built on !SMP:

     kernel/sched_rt.c: In function 'inc_rt_tasks':
     kernel/sched_rt.c:404: error: 'struct rq' has no member named 'online'

    Signed-off-by: Ingo Molnar <mingo@elte.hu>

Only in the case that group scheduling is on, but SMP is off..

Signed-off-by: Daniel Walker <dwalker@mvista.com>
---
 kernel/sched_rt.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 47ceac9..7280277 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -505,14 +505,14 @@ void inc_rt_tasks(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 	rt_rq->rt_nr_running++;
 #if defined CONFIG_SMP || defined CONFIG_RT_GROUP_SCHED
 	if (rt_se_prio(rt_se) < rt_rq->highest_prio) {
-		struct rq *rq = rq_of_rt_rq(rt_rq);
-
-		rt_rq->highest_prio = rt_se_prio(rt_se);
 #ifdef CONFIG_SMP
+		struct rq *rq = rq_of_rt_rq(rt_rq);
 		if (rq->online)
 			cpupri_set(&rq->rd->cpupri, rq->cpu,
 				   rt_se_prio(rt_se));
 #endif
+
+		rt_rq->highest_prio = rt_se_prio(rt_se);
 	}
 #endif
 #ifdef CONFIG_SMP
-- 
1.5.5.1.32.gba7d2

