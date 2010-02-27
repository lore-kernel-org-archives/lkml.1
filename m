Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030577Ab0B0S0Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 13:26:16 -0500
Received: from mail-ew0-f220.google.com ([209.85.219.220]:42919 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030293Ab0B0SZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 13:25:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=EESxqzPRzgHDKX6cfaZBCUD7HRNLln7H36DQD8kjkyKO/08Kry2HcTKlaYodhQo5Yf
         BfPQnYa68z+8I3hHNJTlDe6AjDShNPZIICvGjAapbetRWvUV1Db+F0wg0Su+fuRGqfGY
         tVtKyPUxozDZNAqTuj1EZI/8K9MBJjNd8JvEM=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 3/5] perf lock: Drop the buffers multiplexing dependency
Date: Sat, 27 Feb 2010 19:25:31 +0100
Message-Id: <1267295133-6320-4-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1267295133-6320-1-git-send-regression-fweisbec@gmail.com>
References: <1267295133-6320-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We need to deal with time ordered events to build a correct
state machine of lock events. This is why we multiplex the lock
events buffers. But the ordering is done from the kernel, on
the tracing fast path, leading to high contention between cpus.

Without multiplexing, the events appears in a weak order.
If we have four events, each split per cpu, perf record will
read the events buffers in the following order:

[ CPU0 ev0, CPU0 ev1, CPU0 ev3, CPU0 ev4, CPU1 ev0, CPU1 ev0....]

To handle a post processing reordering, we could just read and sort
the whole in memory, but it just doesn't scale with high amounts
of events: lock events can fill huge amounts in few times.

Basically we need to sort in memory and find a "grace period"
point when we know that a given slice of previously sorted events
can be committed for post-processing, so that we can unload the
memory usage step by step and keep a scalable sorting list.

There is no strong rules about how to define such "grace period".
What does this patch is:

We define a FLUSH_PERIOD value that defines a grace period in
seconds.
We want to have a slice of events covering 2 * FLUSH_PERIOD in our
sorted list.
If FLUSH_PERIOD is big enough, it ensures every events that occured
in the first half of the timeslice have all been buffered and there
are none remaining and there won't be further to put inside this
first timeslice. Then once we reach the 2 * FLUSH_PERIOD
timeslice, we flush the first half to be gentle with the memory
(the second half can still get new events in the middle, so wait
another period to flush it)

FLUSH_PERIOD is defined to 5 seconds. Say the first event started on
time t0. We can safely assume that at the time we are processing
events of t0 + 10 seconds, ther won't be anymore events to read
from perf.data that occured between t0 and t0 + 5 seconds. Hence
we can safely flush the first half.

To point out funky bugs, we have a guardian that checks a new event
timestamp is not below the last event's timestamp flushed and that
displays a warning in this case.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 tools/perf/builtin-lock.c |  148 ++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 146 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index fb9ab2a..e12c844 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -460,6 +460,150 @@ process_raw_event(void *data, int cpu,
 		process_lock_release_event(data, event, cpu, timestamp, thread);
 }
 
+struct raw_event_queue {
+	u64			timestamp;
+	int			cpu;
+	void			*data;
+	struct thread		*thread;
+	struct list_head	list;
+};
+
+static LIST_HEAD(raw_event_head);
+
+#define FLUSH_PERIOD	(5 * NSEC_PER_SEC)
+
+static u64 flush_limit = ULLONG_MAX;
+static u64 last_flush = 0;
+struct raw_event_queue *last_inserted;
+
+static void flush_raw_event_queue(u64 limit)
+{
+	struct raw_event_queue *tmp, *iter;
+
+	list_for_each_entry_safe(iter, tmp, &raw_event_head, list) {
+		if (iter->timestamp > limit)
+			return;
+
+		if (iter == last_inserted)
+			last_inserted = NULL;
+
+		process_raw_event(iter->data, iter->cpu, iter->timestamp,
+				  iter->thread);
+
+		last_flush = iter->timestamp;
+		list_del(&iter->list);
+		free(iter->data);
+		free(iter);
+	}
+}
+
+static void __queue_raw_event_end(struct raw_event_queue *new)
+{
+	struct raw_event_queue *iter;
+
+	list_for_each_entry_reverse(iter, &raw_event_head, list) {
+		if (iter->timestamp < new->timestamp) {
+			list_add(&new->list, &iter->list);
+			return;
+		}
+	}
+
+	list_add(&new->list, &raw_event_head);
+}
+
+static void __queue_raw_event_before(struct raw_event_queue *new,
+				     struct raw_event_queue *iter)
+{
+	list_for_each_entry_continue_reverse(iter, &raw_event_head, list) {
+		if (iter->timestamp < new->timestamp) {
+			list_add(&new->list, &iter->list);
+			return;
+		}
+	}
+
+	list_add(&new->list, &raw_event_head);
+}
+
+static void __queue_raw_event_after(struct raw_event_queue *new,
+				     struct raw_event_queue *iter)
+{
+	list_for_each_entry_continue(iter, &raw_event_head, list) {
+		if (iter->timestamp > new->timestamp) {
+			list_add_tail(&new->list, &iter->list);
+			return;
+		}
+	}
+	list_add_tail(&new->list, &raw_event_head);
+}
+
+/* The queue is ordered by time */
+static void __queue_raw_event(struct raw_event_queue *new)
+{
+	if (!last_inserted) {
+		__queue_raw_event_end(new);
+		return;
+	}
+
+	/*
+	 * Most of the time the current event has a timestamp
+	 * very close to the last event inserted, unless we just switched
+	 * to another event buffer. Having a sorting based on a list and
+	 * on the last inserted event that is close to the current one is
+	 * probably more efficient than an rbtree based sorting.
+	 */
+	if (last_inserted->timestamp >= new->timestamp)
+		__queue_raw_event_before(new, last_inserted);
+	else
+		__queue_raw_event_after(new, last_inserted);
+}
+
+static void queue_raw_event(void *data, int raw_size, int cpu,
+			    u64 timestamp, struct thread *thread)
+{
+	struct raw_event_queue *new;
+
+	if (flush_limit == ULLONG_MAX)
+		flush_limit = timestamp + FLUSH_PERIOD;
+
+	if (timestamp < last_flush) {
+		printf("Warning: Timestamp below last timeslice flush\n");
+		return;
+	}
+
+	new = malloc(sizeof(*new));
+	if (!new)
+		die("Not enough memory\n");
+
+	new->timestamp = timestamp;
+	new->cpu = cpu;
+	new->thread = thread;
+
+	new->data = malloc(raw_size);
+	if (!new->data)
+		die("Not enough memory\n");
+
+	memcpy(new->data, data, raw_size);
+
+	__queue_raw_event(new);
+	last_inserted = new;
+
+	/*
+	 * We want to have a slice of events covering 2 * FLUSH_PERIOD
+	 * If FLUSH_PERIOD is big enough, it ensures every events that occured
+	 * in the first half of the timeslice have all been buffered and there
+	 * are none remaining (we need that because of the weakly ordered
+	 * event recording we have). Then once we reach the 2 * FLUSH_PERIOD
+	 * timeslice, we flush the first half to be gentle with the memory
+	 * (the second half can still get new events in the middle, so wait
+	 * another period to flush it)
+	 */
+	if (new->timestamp > flush_limit &&
+		new->timestamp - flush_limit > FLUSH_PERIOD) {
+		flush_limit += FLUSH_PERIOD;
+		flush_raw_event_queue(flush_limit);
+	}
+}
+
 static int process_sample_event(event_t *event, struct perf_session *session)
 {
 	struct thread *thread;
@@ -480,7 +624,7 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 	if (profile_cpu != -1 && profile_cpu != (int) data.cpu)
 		return 0;
 
-	process_raw_event(data.raw_data, data.cpu, data.time, thread);
+	queue_raw_event(data.raw_data, data.raw_size, data.cpu, data.time, thread);
 
 	return 0;
 }
@@ -576,6 +720,7 @@ static void __cmd_report(void)
 	setup_pager();
 	select_key();
 	read_events();
+	flush_raw_event_queue(ULLONG_MAX);
 	sort_result();
 	print_result();
 }
@@ -608,7 +753,6 @@ static const char *record_args[] = {
 	"record",
 	"-a",
 	"-R",
-	"-M",
 	"-f",
 	"-m", "1024",
 	"-c", "1",
-- 
1.6.2.3

