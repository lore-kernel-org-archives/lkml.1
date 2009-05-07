Return-Path: <linux-kernel-owner+w=401wt.eu-S1760502AbZEGDPD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760502AbZEGDPD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 23:15:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755116AbZEGDOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 23:14:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:59564 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121AbZEGDOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 23:14:34 -0400
Message-Id: <20090507031434.214633851@goodmis.org>
References: <20090507031335.815354104@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 06 May 2009 23:13:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/7] ring-buffer: change test to be more latency friendly
Content-Disposition: inline; filename=0004-ring-buffer-change-test-to-be-more-latency-friendly.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The ring buffer benchmark/test runs a producer for 10 seconds.
This is done with preemption and interrupts enabled. But if the kernel
is not compiled with CONFIG_PREEMPT, it basically stops everything
but interrupts for 10 seconds.

Although this is just a test and is not for production, this attribute
can be quite annoying. It can also spawn badness elsewhere.

This patch solves the issues by calling "cond_resched" when the system
is not compiled with CONFIG_PREEMPT. It also keeps track of the time
spent to call cond_resched such that it does not go against the
time calculations. That is, if the task schedules away, the time scheduled
out is removed from the test data. Note, this only works for non PREEMPT
because we do not know when the task is scheduled out if we have PREEMPT
enabled.

[ Impact: prevent test from stopping the world for 10 seconds ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer_benchmark.c |   31 +++++++++++++++++++++++++++++++
 1 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/ring_buffer_benchmark.c b/kernel/trace/ring_buffer_benchmark.c
index dcd75e9..a26fc67 100644
--- a/kernel/trace/ring_buffer_benchmark.c
+++ b/kernel/trace/ring_buffer_benchmark.c
@@ -185,6 +185,35 @@ static void ring_buffer_consumer(void)
 	complete(&read_done);
 }
 
+/*
+ * If we are a non preempt kernel, the 10 second run will
+ * stop everything while it runs. Instead, we will call cond_resched
+ * and also add any time that was lost by a rescedule.
+ */
+#ifdef CONFIG_PREEMPT
+static void sched_if_needed(struct timeval *start_tv, struct timeval *end_tv)
+{
+}
+#else
+static void sched_if_needed(struct timeval *start_tv, struct timeval *end_tv)
+{
+	struct timeval tv;
+
+	cond_resched();
+	do_gettimeofday(&tv);
+	if (tv.tv_usec < end_tv->tv_usec) {
+		tv.tv_usec += 1000000;
+		tv.tv_sec--;
+	}
+	start_tv->tv_sec += tv.tv_sec - end_tv->tv_sec;
+	start_tv->tv_usec += tv.tv_usec - end_tv->tv_usec;
+	if (start_tv->tv_usec > 1000000) {
+		start_tv->tv_usec -= 1000000;
+		start_tv->tv_sec++;
+	}
+}
+#endif
+
 static void ring_buffer_producer(void)
 {
 	struct timeval start_tv;
@@ -221,6 +250,8 @@ static void ring_buffer_producer(void)
 		if (consumer && !(++cnt % wakeup_interval))
 			wake_up_process(consumer);
 
+		sched_if_needed(&start_tv, &end_tv);
+
 	} while (end_tv.tv_sec < (start_tv.tv_sec + RUN_TIME) && !kill_test);
 	pr_info("End ring buffer hammer\n");
 
-- 
1.6.2.4

-- 
