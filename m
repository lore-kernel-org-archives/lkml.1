Return-Path: <linux-kernel-owner+w=401wt.eu-S1764282AbZFQX2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764282AbZFQX2S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 19:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762471AbZFQX0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 19:26:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:55023 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873AbZFQX03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 19:26:29 -0400
Message-Id: <20090617232630.908465956@goodmis.org>
References: <20090617232555.164629684@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 17 Jun 2009 19:26:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 7/7] ring-buffer: have benchmark test print to trace buffer
Content-Disposition: inline; filename=0007-ring-buffer-have-benchmark-test-print-to-trace-buffe.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Currently the output of the ring buffer benchmark/test prints to
the console. This test runs for ten seconds every ten seconds and
ouputs the result after every iteration. This needlessly fills up
the logs.

This patch makes the ring buffer benchmark/test print to the ftrace
buffer using trace_printk. To view the test results, you must examine
the debug/tracing/trace file.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer_benchmark.c |   37 +++++++++++++++++----------------
 1 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/kernel/trace/ring_buffer_benchmark.c b/kernel/trace/ring_buffer_benchmark.c
index cf6b0f5..573d3cc 100644
--- a/kernel/trace/ring_buffer_benchmark.c
+++ b/kernel/trace/ring_buffer_benchmark.c
@@ -203,7 +203,7 @@ static void ring_buffer_producer(void)
 	 * Hammer the buffer for 10 secs (this may
 	 * make the system stall)
 	 */
-	pr_info("Starting ring buffer hammer\n");
+	trace_printk("Starting ring buffer hammer\n");
 	do_gettimeofday(&start_tv);
 	do {
 		struct ring_buffer_event *event;
@@ -239,7 +239,7 @@ static void ring_buffer_producer(void)
 #endif
 
 	} while (end_tv.tv_sec < (start_tv.tv_sec + RUN_TIME) && !kill_test);
-	pr_info("End ring buffer hammer\n");
+	trace_printk("End ring buffer hammer\n");
 
 	if (consumer) {
 		/* Init both completions here to avoid races */
@@ -262,49 +262,50 @@ static void ring_buffer_producer(void)
 	overruns = ring_buffer_overruns(buffer);
 
 	if (kill_test)
-		pr_info("ERROR!\n");
-	pr_info("Time:     %lld (usecs)\n", time);
-	pr_info("Overruns: %lld\n", overruns);
+		trace_printk("ERROR!\n");
+	trace_printk("Time:     %lld (usecs)\n", time);
+	trace_printk("Overruns: %lld\n", overruns);
 	if (disable_reader)
-		pr_info("Read:     (reader disabled)\n");
+		trace_printk("Read:     (reader disabled)\n");
 	else
-		pr_info("Read:     %ld  (by %s)\n", read,
+		trace_printk("Read:     %ld  (by %s)\n", read,
 			read_events ? "events" : "pages");
-	pr_info("Entries:  %lld\n", entries);
-	pr_info("Total:    %lld\n", entries + overruns + read);
-	pr_info("Missed:   %ld\n", missed);
-	pr_info("Hit:      %ld\n", hit);
+	trace_printk("Entries:  %lld\n", entries);
+	trace_printk("Total:    %lld\n", entries + overruns + read);
+	trace_printk("Missed:   %ld\n", missed);
+	trace_printk("Hit:      %ld\n", hit);
 
 	/* Convert time from usecs to millisecs */
 	do_div(time, USEC_PER_MSEC);
 	if (time)
 		hit /= (long)time;
 	else
-		pr_info("TIME IS ZERO??\n");
+		trace_printk("TIME IS ZERO??\n");
 
-	pr_info("Entries per millisec: %ld\n", hit);
+	trace_printk("Entries per millisec: %ld\n", hit);
 
 	if (hit) {
 		/* Calculate the average time in nanosecs */
 		avg = NSEC_PER_MSEC / hit;
-		pr_info("%ld ns per entry\n", avg);
+		trace_printk("%ld ns per entry\n", avg);
 	}
 
 	if (missed) {
 		if (time)
 			missed /= (long)time;
 
-		pr_info("Total iterations per millisec: %ld\n", hit + missed);
+		trace_printk("Total iterations per millisec: %ld\n",
+			     hit + missed);
 
 		/* it is possible that hit + missed will overflow and be zero */
 		if (!(hit + missed)) {
-			pr_info("hit + missed overflowed and totalled zero!\n");
+			trace_printk("hit + missed overflowed and totalled zero!\n");
 			hit--; /* make it non zero */
 		}
 
 		/* Caculate the average time in nanosecs */
 		avg = NSEC_PER_MSEC / (hit + missed);
-		pr_info("%ld ns per entry\n", avg);
+		trace_printk("%ld ns per entry\n", avg);
 	}
 }
 
@@ -355,7 +356,7 @@ static int ring_buffer_producer_thread(void *arg)
 
 		ring_buffer_producer();
 
-		pr_info("Sleeping for 10 secs\n");
+		trace_printk("Sleeping for 10 secs\n");
 		set_current_state(TASK_INTERRUPTIBLE);
 		schedule_timeout(HZ * SLEEP_TIME);
 		__set_current_state(TASK_RUNNING);
-- 
1.6.3.1

-- 
