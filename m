Return-Path: <linux-kernel-owner+w=401wt.eu-S1758940AbZEFE0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758940AbZEFE0n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 00:26:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750917AbZEFEXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 00:23:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:39824 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbZEFEXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 00:23:35 -0400
Message-Id: <20090506042335.131774566@goodmis.org>
References: <20090506042101.231470089@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 06 May 2009 00:21:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 11/11] ring-buffer: add benchmark and tester
Content-Disposition: inline; filename=0011-ring-buffer-add-benchmark-and-tester.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

This patch adds code that can benchmark the ring buffer as well as
test it. This code can be compiled into the kernel (not recommended)
or as a module.

A separate ring buffer is used to not interfer with other users, like
ftrace. It creates a producer and a consumer (option to disable creation
of the consumer) and will run for 10 seconds, then sleep for 10 seconds
and then repeat.

While running, the producer will write 10 byte loads into the ring
buffer with just putting in the current CPU number. The reader will
continually try to read the buffer. The reader will alternate from reading
the buffer via event by event, or by full pages.

The output is a pr_info, thus it will fill up the syslogs.

  Starting ring buffer hammer
  End ring buffer hammer
  Time:     9000349 (usecs)
  Overruns: 12578640
  Read:     5358440  (by events)
  Entries:  0
  Total:    17937080
  Missed:   0
  Hit:      17937080
  Entries per millisec: 1993
  501 ns per entry
  Sleeping for 10 secs
  Starting ring buffer hammer
  End ring buffer hammer
  Time:     9936350 (usecs)
  Overruns: 0
  Read:     28146644  (by pages)
  Entries:  74
  Total:    28146718
  Missed:   0
  Hit:      28146718
  Entries per millisec: 2832
  353 ns per entry
  Sleeping for 10 secs

Time:      is the time the test ran
Overruns:  the number of events that were overwritten and not read
Read:      the number of events read (either by pages or events)
Entries:   the number of entries left in the buffer
                 (the by pages will only read full pages)
Total:     Entries + Read + Overruns
Missed:    the number of entries that failed to write
Hit:       the number of entries that were written

The above example shows that it takes ~353 nanosecs per entry when
there is a reader, reading by pages (and no overruns)

The event by event reader slowed the producer down to 501 nanosecs.

[ Impact: see how changes to the ring buffer affect stability and performance ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/Kconfig                 |   16 ++
 kernel/trace/Makefile                |    1 +
 kernel/trace/ring_buffer_benchmark.c |  379 ++++++++++++++++++++++++++++++++++
 3 files changed, 396 insertions(+), 0 deletions(-)
 create mode 100644 kernel/trace/ring_buffer_benchmark.c

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 450d3c2..50f62a2 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -471,6 +471,22 @@ config MMIOTRACE_TEST
 
 	  Say N, unless you absolutely know what you are doing.
 
+config RING_BUFFER_BENCHMARK
+	tristate "Ring buffer benchmark stress tester"
+	depends on RING_BUFFER
+	help
+	  This option creates a test to stress the ring buffer and bench mark it.
+	  It creates its own ring buffer such that it will not interfer with
+	  any other users of the ring buffer (such as ftrace). It then creates
+	  a producer and consumer that will run for 10 seconds and sleep for
+	  10 seconds. Each interval it will print out the number of events
+	  it recorded and give a rough estimate of how long each iteration took.
+
+	  It does not disable interrupts or raise its priority, so it may be
+	  affected by processes that are running.
+
+	  If unsure, say N
+
 endif # FTRACE
 
 endif # TRACING_SUPPORT
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index fb9d7f9..7c34cbf 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -17,6 +17,7 @@ endif
 
 obj-$(CONFIG_FUNCTION_TRACER) += libftrace.o
 obj-$(CONFIG_RING_BUFFER) += ring_buffer.o
+obj-$(CONFIG_RING_BUFFER_BENCHMARK) += ring_buffer_benchmark.o
 
 obj-$(CONFIG_TRACING) += trace.o
 obj-$(CONFIG_TRACING) += trace_clock.o
diff --git a/kernel/trace/ring_buffer_benchmark.c b/kernel/trace/ring_buffer_benchmark.c
new file mode 100644
index 0000000..747244a
--- /dev/null
+++ b/kernel/trace/ring_buffer_benchmark.c
@@ -0,0 +1,379 @@
+/*
+ * ring buffer tester and benchmark
+ *
+ * Copyright (C) 2009 Steven Rostedt <srostedt@redhat.com>
+ */
+#include <linux/ring_buffer.h>
+#include <linux/completion.h>
+#include <linux/kthread.h>
+#include <linux/module.h>
+#include <linux/time.h>
+
+struct rb_page {
+	u64		ts;
+	local_t		commit;
+	char		data[4080];
+};
+
+/* run time and sleep time in seconds */
+#define RUN_TIME	10
+#define SLEEP_TIME	10
+
+/* number of events for writer to wake up the reader */
+static int wakeup_interval = 100;
+
+static int reader_finish;
+static struct completion read_start;
+static struct completion read_done;
+
+static struct ring_buffer *buffer;
+static struct task_struct *producer;
+static struct task_struct *consumer;
+static unsigned long read;
+
+static int disable_reader;
+module_param(disable_reader, uint, 0644);
+MODULE_PARM_DESC(disable_reader, "only run producer");
+
+static int read_events;
+
+static int kill_test;
+
+#define KILL_TEST()				\
+	do {					\
+		if (!kill_test) {		\
+			kill_test = 1;		\
+			WARN_ON(1);		\
+		}				\
+	} while (0)
+
+enum event_status {
+	EVENT_FOUND,
+	EVENT_DROPPED,
+};
+
+static enum event_status read_event(int cpu)
+{
+	struct ring_buffer_event *event;
+	int *entry;
+	u64 ts;
+
+	event = ring_buffer_consume(buffer, cpu, &ts);
+	if (!event)
+		return EVENT_DROPPED;
+
+	entry = ring_buffer_event_data(event);
+	if (*entry != cpu) {
+		KILL_TEST();
+		return EVENT_DROPPED;
+	}
+
+	read++;
+	return EVENT_FOUND;
+}
+
+static enum event_status read_page(int cpu)
+{
+	struct ring_buffer_event *event;
+	struct rb_page *rpage;
+	unsigned long commit;
+	void *bpage;
+	int *entry;
+	int ret;
+	int inc;
+	int i;
+
+	bpage = ring_buffer_alloc_read_page(buffer);
+	ret = ring_buffer_read_page(buffer, &bpage, PAGE_SIZE, cpu, 1);
+	if (ret >= 0) {
+		rpage = bpage;
+		commit = local_read(&rpage->commit);
+		for (i = 0; i < commit && !kill_test; i += inc) {
+
+			if (i >= (PAGE_SIZE - offsetof(struct rb_page, data))) {
+				KILL_TEST();
+				break;
+			}
+
+			inc = -1;
+			event = (void *)&rpage->data[i];
+			switch (event->type_len) {
+			case RINGBUF_TYPE_PADDING:
+				/* We don't expect any padding */
+				KILL_TEST();
+				break;
+			case RINGBUF_TYPE_TIME_EXTEND:
+				inc = 8;
+				break;
+			case 0:
+				entry = ring_buffer_event_data(event);
+				if (*entry != cpu) {
+					KILL_TEST();
+					break;
+				}
+				read++;
+				if (!event->array[0]) {
+					KILL_TEST();
+					break;
+				}
+				inc = event->array[0];
+				break;
+			default:
+				entry = ring_buffer_event_data(event);
+				if (*entry != cpu) {
+					KILL_TEST();
+					break;
+				}
+				read++;
+				inc = ((event->type_len + 1) * 4);
+			}
+			if (kill_test)
+				break;
+
+			if (inc <= 0) {
+				KILL_TEST();
+				break;
+			}
+		}
+	}
+	ring_buffer_free_read_page(buffer, bpage);
+
+	if (ret < 0)
+		return EVENT_DROPPED;
+	return EVENT_FOUND;
+}
+
+static void ring_buffer_consumer(void)
+{
+	/* toggle between reading pages and events */
+	read_events ^= 1;
+
+	read = 0;
+	while (!reader_finish && !kill_test) {
+		int found;
+
+		do {
+			int cpu;
+
+			found = 0;
+			for_each_online_cpu(cpu) {
+				enum event_status stat;
+
+				if (read_events)
+					stat = read_event(cpu);
+				else
+					stat = read_page(cpu);
+
+				if (kill_test)
+					break;
+				if (stat == EVENT_FOUND)
+					found = 1;
+			}
+		} while (found && !kill_test);
+
+		set_current_state(TASK_INTERRUPTIBLE);
+		if (reader_finish)
+			break;
+
+		schedule();
+		__set_current_state(TASK_RUNNING);
+	}
+	reader_finish = 0;
+	complete(&read_done);
+}
+
+static void ring_buffer_producer(void)
+{
+	struct timeval start_tv;
+	struct timeval end_tv;
+	unsigned long long time;
+	unsigned long long entries;
+	unsigned long long overruns;
+	unsigned long missed = 0;
+	unsigned long hit = 0;
+	unsigned long avg;
+	int cnt = 0;
+
+	/*
+	 * Hammer the buffer for 10 secs (this may
+	 * make the system stall)
+	 */
+	pr_info("Starting ring buffer hammer\n");
+	do_gettimeofday(&start_tv);
+	do {
+		struct ring_buffer_event *event;
+		int *entry;
+
+		event = ring_buffer_lock_reserve(buffer, 10);
+		if (!event) {
+			missed++;
+		} else {
+			hit++;
+			entry = ring_buffer_event_data(event);
+			*entry = smp_processor_id();
+			ring_buffer_unlock_commit(buffer, event);
+		}
+		do_gettimeofday(&end_tv);
+
+		if (consumer && !(++cnt % wakeup_interval))
+			wake_up_process(consumer);
+
+	} while (end_tv.tv_sec < (start_tv.tv_sec + RUN_TIME) && !kill_test);
+	pr_info("End ring buffer hammer\n");
+
+	if (consumer) {
+		/* Init both completions here to avoid races */
+		init_completion(&read_start);
+		init_completion(&read_done);
+		/* the completions must be visible before the finish var */
+		smp_wmb();
+		reader_finish = 1;
+		/* finish var visible before waking up the consumer */
+		smp_wmb();
+		wake_up_process(consumer);
+		wait_for_completion(&read_done);
+	}
+
+	time = end_tv.tv_sec - start_tv.tv_sec;
+	time *= 1000000;
+	time += (long long)((long)end_tv.tv_usec - (long)start_tv.tv_usec);
+
+	entries = ring_buffer_entries(buffer);
+	overruns = ring_buffer_overruns(buffer);
+
+	if (kill_test)
+		pr_info("ERROR!\n");
+	pr_info("Time:     %lld (usecs)\n", time);
+	pr_info("Overruns: %lld\n", overruns);
+	if (disable_reader)
+		pr_info("Read:     (reader disabled)\n");
+	else
+		pr_info("Read:     %ld  (by %s)\n", read,
+			read_events ? "events" : "pages");
+	pr_info("Entries:  %lld\n", entries);
+	pr_info("Total:    %lld\n", entries + overruns + read);
+	pr_info("Missed:   %ld\n", missed);
+	pr_info("Hit:      %ld\n", hit);
+
+	do_div(time, 1000);
+	if (time)
+		hit /= (long)time;
+	else
+		pr_info("TIME IS ZERO??\n");
+
+	pr_info("Entries per millisec: %ld\n", hit);
+
+	if (hit) {
+		avg = 1000000 / hit;
+		pr_info("%ld ns per entry\n", avg);
+	}
+}
+
+static void wait_to_die(void)
+{
+	set_current_state(TASK_INTERRUPTIBLE);
+	while (!kthread_should_stop()) {
+		schedule();
+		set_current_state(TASK_INTERRUPTIBLE);
+	}
+	__set_current_state(TASK_RUNNING);
+}
+
+static int ring_buffer_consumer_thread(void *arg)
+{
+	while (!kthread_should_stop() && !kill_test) {
+		complete(&read_start);
+
+		ring_buffer_consumer();
+
+		set_current_state(TASK_INTERRUPTIBLE);
+		if (kthread_should_stop() || kill_test)
+			break;
+
+		schedule();
+		__set_current_state(TASK_RUNNING);
+	}
+	__set_current_state(TASK_RUNNING);
+
+	if (kill_test)
+		wait_to_die();
+
+	return 0;
+}
+
+static int ring_buffer_producer_thread(void *arg)
+{
+	init_completion(&read_start);
+
+	while (!kthread_should_stop() && !kill_test) {
+		ring_buffer_reset(buffer);
+
+		if (consumer) {
+			smp_wmb();
+			wake_up_process(consumer);
+			wait_for_completion(&read_start);
+		}
+
+		ring_buffer_producer();
+
+		pr_info("Sleeping for 10 secs\n");
+		set_current_state(TASK_INTERRUPTIBLE);
+		schedule_timeout(HZ * SLEEP_TIME);
+		__set_current_state(TASK_RUNNING);
+	}
+
+	if (kill_test)
+		wait_to_die();
+
+	return 0;
+}
+
+static int __init ring_buffer_benchmark_init(void)
+{
+	int ret;
+
+	/* make a one meg buffer in overwite mode */
+	buffer = ring_buffer_alloc(1000000, RB_FL_OVERWRITE);
+	if (!buffer)
+		return -ENOMEM;
+
+	if (!disable_reader) {
+		consumer = kthread_create(ring_buffer_consumer_thread,
+					  NULL, "rb_consumer");
+		ret = PTR_ERR(consumer);
+		if (IS_ERR(consumer))
+			goto out_fail;
+	}
+
+	producer = kthread_run(ring_buffer_producer_thread,
+			       NULL, "rb_producer");
+	ret = PTR_ERR(producer);
+
+	if (IS_ERR(producer))
+		goto out_kill;
+
+	return 0;
+
+ out_kill:
+	if (consumer)
+		kthread_stop(consumer);
+
+ out_fail:
+	ring_buffer_free(buffer);
+	return ret;
+}
+
+static void __exit ring_buffer_benchmark_exit(void)
+{
+	kthread_stop(producer);
+	if (consumer)
+		kthread_stop(consumer);
+	ring_buffer_free(buffer);
+}
+
+module_init(ring_buffer_benchmark_init);
+module_exit(ring_buffer_benchmark_exit);
+
+MODULE_AUTHOR("Steven Rostedt");
+MODULE_DESCRIPTION("ring_buffer_benchmark");
+MODULE_LICENSE("GPL");
-- 
1.6.2.4

-- 
