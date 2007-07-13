Return-Path: <linux-kernel-owner+w=401wt.eu-S1761114AbXGMNP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761114AbXGMNP5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 09:15:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755253AbXGMNPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 09:15:50 -0400
Received: from mail.screens.ru ([213.234.233.54]:52593 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755077AbXGMNPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 09:15:49 -0400
Date: Fri, 13 Jul 2007 17:16:55 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Schmidt <mschmidt@redhat.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, stable@kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] destroy_workqueue() can livelock
Message-ID: <20070713131655.GA1033@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pointed out by Michal Schmidt <mschmidt@redhat.com>.

The bug was introduced in 2.6.22 by me.

cleanup_workqueue_thread() does flush_cpu_workqueue(cwq) in a loop until
->worklist becomes empty. This is live-lockable, a re-niced caller can
get CPU after wake_up() and insert a new barrier before the lower-priority
cwq->thread has a chance to clear ->current_work.

Change cleanup_workqueue_thread() to do flush_cpu_workqueue(cwq) only once.
We can rely on the fact that run_workqueue() won't return until it flushes
all works. So it is safe to call kthread_stop() after that, the "should stop"
request won't be noticed until run_workqueue() returns.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- t/kernel/workqueue.c~LIVELOCK	2007-06-13 18:26:56.000000000 +0400
+++ t/kernel/workqueue.c	2007-07-13 16:46:27.000000000 +0400
@@ -739,18 +739,17 @@ static void cleanup_workqueue_thread(str
 	if (cwq->thread == NULL)
 		return;
 
+	flush_cpu_workqueue(cwq);
 	/*
-	 * If the caller is CPU_DEAD the single flush_cpu_workqueue()
-	 * is not enough, a concurrent flush_workqueue() can insert a
-	 * barrier after us.
+	 * If the caller is CPU_DEAD and cwq->worklist was not empty,
+	 * a concurrent flush_workqueue() can insert a barrier after us.
+	 * However, in that case run_workqueue() won't return and check
+	 * kthread_should_stop() until it flushes all work_struct's.
 	 * When ->worklist becomes empty it is safe to exit because no
 	 * more work_structs can be queued on this cwq: flush_workqueue
 	 * checks list_empty(), and a "normal" queue_work() can't use
 	 * a dead CPU.
 	 */
-	while (flush_cpu_workqueue(cwq))
-		;
-
 	kthread_stop(cwq->thread);
 	cwq->thread = NULL;
 }

