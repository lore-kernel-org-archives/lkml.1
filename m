Return-Path: <linux-kernel-owner+w=401wt.eu-S1758088AbZABLQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758088AbZABLQ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 06:16:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756885AbZABLQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 06:16:47 -0500
Received: from mail.gmx.net ([213.165.64.20]:40940 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756714AbZABLQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 06:16:47 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/5vlE1dgz57sgm2mnH5FsNtIXd6RJUMeItXXZgAM
	SUWvWCYwu2TqPL
Subject: Re: [patch] Re: problem with "sched: revert back to per-rq
	vruntime"?
From: Mike Galbraith <efault@gmx.de>
To: Jayson King <dev@jaysonking.com>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, mingo@elte.hu
In-Reply-To: <495D5C70.4090804@jaysonking.com>
References: <495948E0.8040502@jaysonking.com>
	 <495A788B.3010001@jaysonking.com>
	 <1230740773.6412.21.camel@marge.simson.net>
	 <495BD346.9040408@jaysonking.com>
	 <1230795963.5892.14.camel@marge.simson.net>
	 <495D5C70.4090804@jaysonking.com>
Content-Type: text/plain
Date: Fri, 02 Jan 2009 12:16:42 +0100
Message-Id: <1230895002.5747.46.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-01 at 18:14 -0600, Jayson King wrote:

> Still works OK for me. You may add, if you like:
> 
> Tested-By: Jayson King <dev@jaysonking.com>

Actually, I prefer the below.  Everything in one spot and obvious.

Impact: bug fixlet.

Fix sched_slice() to emit a sane result whether a task is currently enqueued or not.

Signed-off-by: Mike Galbraith <efault@gmx.de>

 kernel/sched_fair.c |   30 ++++++++++++------------------
 1 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 5ad4440..1a35bad 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -386,20 +386,6 @@ int sched_nr_latency_handler(struct ctl_table *table, int write,
 #endif
 
 /*
- * delta *= P[w / rw]
- */
-static inline unsigned long
-calc_delta_weight(unsigned long delta, struct sched_entity *se)
-{
-	for_each_sched_entity(se) {
-		delta = calc_delta_mine(delta,
-				se->load.weight, &cfs_rq_of(se)->load);
-	}
-
-	return delta;
-}
-
-/*
  * delta /= w
  */
 static inline unsigned long
@@ -440,12 +426,20 @@ static u64 __sched_period(unsigned long nr_running)
  */
 static u64 sched_slice(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
-	unsigned long nr_running = cfs_rq->nr_running;
+	u64 slice = __sched_period(cfs_rq->nr_running + !se->on_rq);
+	
+	for_each_sched_entity(se) {
+		struct load_weight *load = &cfs_rq->load;
 
-	if (unlikely(!se->on_rq))
-		nr_running++;
+		if (unlikely(!se->on_rq)) {
+			struct load_weight lw = cfs_rq->load;
 
-	return calc_delta_weight(__sched_period(nr_running), se);
+			update_load_add(&lw, se->load.weight);
+			load = &lw;
+		}
+		slice = calc_delta_mine(slice, se->load.weight, load);
+	}
+	return slice;
 }
 
 /*


