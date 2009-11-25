Return-Path: <linux-kernel-owner+w=401wt.eu-S935114AbZKYV4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935114AbZKYV4A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 16:56:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758842AbZKYVz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 16:55:59 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:33322 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759008AbZKYVz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 16:55:57 -0500
Message-Id: <20091125215602.587628179@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 25 Nov 2009 16:55:30 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/2] [PATCH 1/2] ring-buffer-benchmark: Add parameters to set produce/consumer priorities
References: <20091125215529.492517040@goodmis.org>
Content-Disposition: inline; filename=0001-ring-buffer-benchmark-Add-parameters-to-set-produce-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Running the ring-buffer-benchmark's threads at the lowest priority may
work well for keeping it in the background, but it is not appropriate
for the benchmarks.

This patch adds 4 parameters to the module:

  consumer_fifo
  consumer_nice
  producer_fifo
  producer_nice

By default the consumer and producer still run at nice +19.

If the *_fifo options are set, they will override the *_nice values.

 modprobe ring_buffer_benchmark consumer_nice=0 producer_fifo=10

The above will set the consumer thread to a nice value of 0, and
the producer thread to a RT SCHED_FIFO priority of 10.

Note, this patch also fixes a bug where calling set_user_nice on the
consumer thread would oops the kernel when the parameter "disable_reader"
is set.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer_benchmark.c |   58 ++++++++++++++++++++++++++++++++-
 1 files changed, 56 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ring_buffer_benchmark.c b/kernel/trace/ring_buffer_benchmark.c
index 3875d49..b2477ca 100644
--- a/kernel/trace/ring_buffer_benchmark.c
+++ b/kernel/trace/ring_buffer_benchmark.c
@@ -39,6 +39,24 @@ static int write_iteration = 50;
 module_param(write_iteration, uint, 0644);
 MODULE_PARM_DESC(write_iteration, "# of writes between timestamp readings");
 
+static int producer_nice = 19;
+static int consumer_nice = 19;
+
+static int producer_fifo = -1;
+static int consumer_fifo = -1;
+
+module_param(producer_nice, uint, 0644);
+MODULE_PARM_DESC(producer_nice, "nice prio for producer");
+
+module_param(consumer_nice, uint, 0644);
+MODULE_PARM_DESC(consumer_nice, "nice prio for consumer");
+
+module_param(producer_fifo, uint, 0644);
+MODULE_PARM_DESC(producer_fifo, "fifo prio for producer");
+
+module_param(consumer_fifo, uint, 0644);
+MODULE_PARM_DESC(consumer_fifo, "fifo prio for consumer");
+
 static int read_events;
 
 static int kill_test;
@@ -270,6 +288,27 @@ static void ring_buffer_producer(void)
 
 	if (kill_test)
 		trace_printk("ERROR!\n");
+
+	if (!disable_reader) {
+		if (consumer_fifo < 0)
+			trace_printk("Running Consumer at nice: %d\n",
+				     consumer_nice);
+		else
+			trace_printk("Running Consumer at SCHED_FIFO %d\n",
+				     consumer_fifo);
+	}
+	if (producer_fifo < 0)
+		trace_printk("Running Producer at nice: %d\n",
+			     producer_nice);
+	else
+		trace_printk("Running Producer at SCHED_FIFO %d\n",
+			     producer_fifo);
+
+	/* Let the user know that the test is running at low priority */
+	if (producer_fifo < 0 && consumer_fifo < 0 &&
+	    producer_nice == 19 && consumer_nice == 19)
+		trace_printk("WARNING!!! This test is running at lowest priority.\n");
+
 	trace_printk("Time:     %lld (usecs)\n", time);
 	trace_printk("Overruns: %lld\n", overruns);
 	if (disable_reader)
@@ -402,8 +441,23 @@ static int __init ring_buffer_benchmark_init(void)
 	/*
 	 * Run them as low-prio background tasks by default:
 	 */
-	set_user_nice(consumer, 19);
-	set_user_nice(producer, 19);
+	if (!disable_reader) {
+		if (consumer_fifo >= 0) {
+			struct sched_param param = {
+				.sched_priority = consumer_fifo
+			};
+			sched_setscheduler(consumer, SCHED_FIFO, &param);
+		} else
+			set_user_nice(consumer, consumer_nice);
+	}
+
+	if (producer_fifo >= 0) {
+		struct sched_param param = {
+			.sched_priority = consumer_fifo
+		};
+		sched_setscheduler(producer, SCHED_FIFO, &param);
+	} else
+		set_user_nice(producer, producer_nice);
 
 	return 0;
 
-- 
1.6.5


