Return-Path: <linux-kernel-owner+w=401wt.eu-S933911AbZFOTIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933911AbZFOTIY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 15:08:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933809AbZFOTIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 15:08:00 -0400
Received: from ms01.sssup.it ([193.205.80.99]:58750 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932422AbZFOTH7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 15:07:59 -0400
Date: Mon, 15 Jun 2009 21:09:02 +0200
From: Fabio Checconi <fchecconi@gmail.com>
To: mingo@elte.hu, a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 7/8] Reprogram timers only when necessary
Message-ID: <20090615190901.GQ21741@gandalf.sssup.it>
References: <cover.1245092261.git.fabio@helm.retis>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1245092261.git.fabio@helm.retis>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid unnecessary timer reprogramming when a group is at its full
capacity and it is already enqueued.  Such a group will not need
further budget recharges until it astually consumes its budget, so
do not rearm its timer immediately.
---
 kernel/sched_rt.c |   19 ++++++++++++++++++-
 1 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index f43ce7b..a9db16b 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -386,6 +386,19 @@ static int do_sched_rt_period_timer(struct rt_rq *rt_rq, int overrun)
 	return idle;
 }
 
+static inline int rt_rq_needs_recharge(struct rt_rq *rt_rq)
+{
+	struct sched_rt_entity *rt_se = rt_rq->rt_se;
+
+	if (rt_rq->rt_time)
+		return 1;
+
+	if (!rt_se)
+		return 0;
+
+	return !on_rt_rq(rt_rq->rt_se);
+}
+
 static enum hrtimer_restart sched_rt_period_timer(struct hrtimer *timer)
 {
 	struct rt_rq *rt_rq = container_of(timer, struct rt_rq,
@@ -402,7 +415,8 @@ static enum hrtimer_restart sched_rt_period_timer(struct hrtimer *timer)
 		idle = do_sched_rt_period_timer(rt_rq, overrun);
 	}
 
-	return idle ? HRTIMER_NORESTART : HRTIMER_RESTART;
+	return idle || !rt_rq_needs_recharge(rt_rq) ?
+		HRTIMER_NORESTART : HRTIMER_RESTART;
 }
 
 static void start_rt_period_timer(struct rt_rq *rt_rq)
@@ -428,6 +442,9 @@ static void start_rt_period_timer(struct rt_rq *rt_rq)
 		if (overrun)
 			__do_sched_rt_period_timer(rt_rq, overrun);
 
+		if (!rt_rq_needs_recharge(rt_rq))
+			return;
+
 		soft = hrtimer_get_softexpires(&rt_rq->rt_period_timer);
 		hard = hrtimer_get_expires(&rt_rq->rt_period_timer);
 		range = ktime_to_ns(ktime_sub(hard, soft));
-- 
1.6.2.2

