Return-Path: <linux-kernel-owner+w=401wt.eu-S933805AbZFOTEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933805AbZFOTEg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 15:04:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764467AbZFOTE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 15:04:26 -0400
Received: from ms01.sssup.it ([193.205.80.99]:37752 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763240AbZFOTEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 15:04:25 -0400
Date: Mon, 15 Jun 2009 21:05:28 +0200
From: Fabio Checconi <fchecconi@gmail.com>
To: mingo@elte.hu, a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/8] Fix hrtick handling
Message-ID: <20090615190528.GL21741@gandalf.sssup.it>
References: <cover.1245092261.git.fabio@helm.retis>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1245092261.git.fabio@helm.retis>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current hrtick implementation can end up asking to the hrtimer code
to wake up ksoftirqd while holding rq->lock, causing a spinlock recursion.
This patch uses __hrtimer_start_range_ns() to disable the wakeup in the
reprogramming path.

Signed-off-by: Fabio Checconi <fabio@gandalf.sssup.it>
---
 kernel/sched.c |   20 +++++++++++++++++---
 1 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 873b252..b8d432b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1090,6 +1090,19 @@ static enum hrtimer_restart hrtick(struct hrtimer *timer)
 }
 
 #ifdef CONFIG_SMP
+static void hrtick_restart(struct hrtimer *timer)
+{
+	ktime_t hard, soft;
+	unsigned long delta;
+
+	soft = hrtimer_get_softexpires(timer);
+	hard = hrtimer_get_expires(timer);
+	delta = ktime_to_ns(ktime_sub(hard, soft));
+
+	__hrtimer_start_range_ns(timer, soft, delta,
+				 HRTIMER_MODE_ABS_PINNED, 0);
+}
+
 /*
  * called from hardirq (IPI) context
  */
@@ -1098,7 +1111,7 @@ static void __hrtick_start(void *arg)
 	struct rq *rq = arg;
 
 	spin_lock(&rq->lock);
-	hrtimer_restart(&rq->hrtick_timer);
+	hrtick_restart(&rq->hrtick_timer);
 	rq->hrtick_csd_pending = 0;
 	spin_unlock(&rq->lock);
 }
@@ -1116,7 +1129,7 @@ static void hrtick_start(struct rq *rq, u64 delay)
 	hrtimer_set_expires(timer, time);
 
 	if (rq == this_rq()) {
-		hrtimer_restart(timer);
+		hrtick_restart(timer);
 	} else if (!rq->hrtick_csd_pending) {
 		__smp_call_function_single(cpu_of(rq), &rq->hrtick_csd, 0);
 		rq->hrtick_csd_pending = 1;
@@ -1173,7 +1186,8 @@ static void init_rq_hrtick(struct rq *rq)
 	rq->hrtick_csd.info = rq;
 #endif
 
-	hrtimer_init(&rq->hrtick_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	hrtimer_init(&rq->hrtick_timer, CLOCK_MONOTONIC,
+				HRTIMER_MODE_REL_PINNED);
 	rq->hrtick_timer.function = hrtick;
 }
 #else	/* CONFIG_SCHED_HRTICK */
-- 
1.6.2.2

