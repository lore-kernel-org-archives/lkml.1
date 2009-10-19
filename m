Return-Path: <linux-kernel-owner+w=401wt.eu-S1757588AbZJSUVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588AbZJSUVi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 16:21:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757557AbZJSUVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 16:21:36 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:46154 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757551AbZJSUVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 16:21:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=s5cjLk6UAYueUYET5tqqMdy4F9tQxDibj+7mBc9z58de2c3wKqJIrU0bolBJwa7qn0
         LV4Ca28Qtvg9Ifip/ZyYMU+KG+J66pu9wU6RhMD60r4STrXMKfqWbuPaI6JrMrfsM4n9
         /qQeGPU2itIXMSEx+WIZr9ZlRIzZwgXW5H3m8=
From: Corrado Zoccolo <czoccolo@gmail.com>
To: "Linux-Kernel" <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Jeff Moyer <jmoyer@redhat.com>
Subject: [RFC PATCH 4/5] cfq-iosched: enable idling for last queue on priority class
Date: Mon, 19 Oct 2009 22:21:31 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.32cz; KDE/4.2.4; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910192221.32158.czoccolo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cfq can disable idling for queues in various circumstances.
When workloads of different priorities are competing, if the higher
priority queue has idling disabled, lower priority queues may steal
its disk share. For example, in a scenario with an RT process
performing seeky reads vs a BE process performing sequential reads,
on an NCQ enabled hardware, with low_latency unset,
the RT process will dispatch only the few pending requests every full
slice of service for the BE process.

The patch solves this issue by always performing idle on the last
queue at a given priority class > idle. If the same process, or one
that can pre-empt it (so at the same priority or higher), submits a
new request within the idle window, the lower priority queue won't
dispatch, saving the disk bandwidth for higher priority ones.

Note: this doesn't touch the non_rotational + NCQ case (no hardware
to test if this is a benefit in that case).

Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>
---
 block/cfq-iosched.c |   21 ++++++++++++++++++---
 1 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index a5a1786..c6dbefc 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1121,6 +1121,21 @@ static struct cfq_queue *cfq_close_cooperator(struct cfq_data *cfqd,
 	return cfqq;
 }
 
+static bool cfq_should_idle(struct cfq_data *cfqd, struct cfq_queue *cfqq)
+{
+	if (cfq_class_idle(cfqq))
+		return false;
+	if (cfq_cfqq_idle_window(cfqq))
+		return true;
+	{
+		enum wl_prio_t prio = cfq_class_rt(cfqq) ? RT_WL : BE_WL;
+		struct cfq_rb_root *service_tree = service_tree_for(prio, cfqd);
+		return service_tree->count == 0 ||
+			(service_tree->count == 1
+			 && cfq_rb_first(service_tree) == cfqq);
+	}
+}
+
 static void cfq_arm_slice_timer(struct cfq_data *cfqd)
 {
 	struct cfq_queue *cfqq = cfqd->active_queue;
@@ -1141,7 +1156,7 @@ static void cfq_arm_slice_timer(struct cfq_data *cfqd)
 	/*
 	 * idle is disabled, either manually or by past process history
 	 */
-	if (!cfqd->cfq_slice_idle || !cfq_cfqq_idle_window(cfqq))
+	if (!cfqd->cfq_slice_idle || !cfq_should_idle(cfqd, cfqq))
 		return;
 
 	/*
@@ -1274,7 +1289,7 @@ static struct cfq_queue *cfq_select_queue(struct cfq_data *cfqd)
 	 * conditions to happen (or time out) before selecting a new queue.
 	 */
 	if (timer_pending(&cfqd->idle_slice_timer) ||
-	    (cfqq->dispatched && cfq_cfqq_idle_window(cfqq))) {
+	    (cfqq->dispatched && cfq_should_idle(cfqd, cfqq))) {
 		cfqq = NULL;
 		goto keep_queue;
 	}
@@ -1339,7 +1354,7 @@ static bool cfq_may_dispatch(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	/*
 	 * Drain async requests before we start sync IO
 	 */
-	if (cfq_cfqq_idle_window(cfqq) && cfqd->rq_in_driver[BLK_RW_ASYNC])
+	if (cfq_should_idle(cfqd, cfqq) && cfqd->rq_in_driver[BLK_RW_ASYNC])
 		return false;
 
 	/*
-- 
1.6.2.5


