Return-Path: <linux-kernel-owner+w=401wt.eu-S1756127AbZEGQXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127AbZEGQXT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 12:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754669AbZEGQXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 12:23:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:55753 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299AbZEGQXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 12:23:05 -0400
Message-Id: <20090507162302.053953109@goodmis.org>
References: <20090507162221.413243886@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 07 May 2009 12:22:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/2] ring-buffer: remove complex calculations in ring-buffer-test
Content-Disposition: inline; filename=0001-ring-buffer-remove-complex-calculations-in-ring-buf.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Ingo Molnar thought that the code to calculate the time in cond_resched
is a bit too ugly and is not needed. This patch removes it and replaces
it with a simple call to cond_resched. I kept the comment that explains
the reason for the cond_resched.

[ Impact: remove ugly code ]

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer_benchmark.c |   37 ++++++---------------------------
 1 files changed, 7 insertions(+), 30 deletions(-)

diff --git a/kernel/trace/ring_buffer_benchmark.c b/kernel/trace/ring_buffer_benchmark.c
index a26fc67..f4ceb45 100644
--- a/kernel/trace/ring_buffer_benchmark.c
+++ b/kernel/trace/ring_buffer_benchmark.c
@@ -185,35 +185,6 @@ static void ring_buffer_consumer(void)
 	complete(&read_done);
 }
 
-/*
- * If we are a non preempt kernel, the 10 second run will
- * stop everything while it runs. Instead, we will call cond_resched
- * and also add any time that was lost by a rescedule.
- */
-#ifdef CONFIG_PREEMPT
-static void sched_if_needed(struct timeval *start_tv, struct timeval *end_tv)
-{
-}
-#else
-static void sched_if_needed(struct timeval *start_tv, struct timeval *end_tv)
-{
-	struct timeval tv;
-
-	cond_resched();
-	do_gettimeofday(&tv);
-	if (tv.tv_usec < end_tv->tv_usec) {
-		tv.tv_usec += 1000000;
-		tv.tv_sec--;
-	}
-	start_tv->tv_sec += tv.tv_sec - end_tv->tv_sec;
-	start_tv->tv_usec += tv.tv_usec - end_tv->tv_usec;
-	if (start_tv->tv_usec > 1000000) {
-		start_tv->tv_usec -= 1000000;
-		start_tv->tv_sec++;
-	}
-}
-#endif
-
 static void ring_buffer_producer(void)
 {
 	struct timeval start_tv;
@@ -250,7 +221,13 @@ static void ring_buffer_producer(void)
 		if (consumer && !(++cnt % wakeup_interval))
 			wake_up_process(consumer);
 
-		sched_if_needed(&start_tv, &end_tv);
+		/*
+		 * If we are a non preempt kernel, the 10 second run will
+		 * stop everything while it runs. Instead, we will call
+		 * cond_resched and also add any time that was lost by a
+		 * rescedule.
+		 */
+		cond_resched();
 
 	} while (end_tv.tv_sec < (start_tv.tv_sec + RUN_TIME) && !kill_test);
 	pr_info("End ring buffer hammer\n");
-- 
1.6.2.4

-- 
