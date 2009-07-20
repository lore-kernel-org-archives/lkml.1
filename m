Return-Path: <linux-kernel-owner+w=401wt.eu-S1753604AbZGTNQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604AbZGTNQt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 09:16:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753430AbZGTNQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 09:16:47 -0400
Received: from viefep18-int.chello.at ([62.179.121.38]:46926 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405AbZGTNQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 09:16:46 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH] perf_counter: Always return the parent counter id to
 userspace
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Anton Blanchard <anton@samba.org>
Cc: mingo@elte.hu, paulus@samba.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090720114720.GB9029@kryten>
References: <20090720103825.GA9029@kryten>
	 <1248087346.15751.8437.camel@twins>  <20090720114720.GB9029@kryten>
Content-Type: text/plain
Date: Mon, 20 Jul 2009 15:17:26 +0200
Message-Id: <1248095846.15751.8781.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-20 at 21:47 +1000, Anton Blanchard wrote:

> > > @@ -2704,8 +2718,10 @@
> > >  	if (sample_type & PERF_SAMPLE_ADDR)
> > >  		perf_output_put(&handle, data->addr);
> > >  
> > > -	if (sample_type & PERF_SAMPLE_ID)
> > > -		perf_output_put(&handle, counter->id);
> > > +	if (sample_type & PERF_SAMPLE_ID) {
> > > +		u64 id = primary_counter_id(counter);
> > > +		perf_output_put(&handle, id);
> > > +	}
> > >  
> > >  	if (sample_type & PERF_SAMPLE_CPU)
> > >  		perf_output_put(&handle, cpu_entry);
> > 
> > This will actually wreck things.
> > 
> > It would be impossible to relate PERF_EVENT_PERIOD/THROTTLE (and maybe
> > others) to their respective counters.
> > 
> > If you have inherited counters and each task will have separate ones,
> > you need separate IDs in their sample stream to be able to related
> > PERIOD and THROTTLE events.
> 
> I think I'm missing something. I'm logging two events at once with perf record
> (-e page-faults -e dTLB-load-misses) and I added PERF_SAMPLE_ID to be able to
> identify each event in the output file.
> 
> I'm not seeing a way to inherit and share counters (so we always get a
> consistent id which matches the perf.data header), or a way for the new
> counters to be written out to the log as they are created (so I can work
> back to the original id).

Hmm, indeed I see the problem -- bugger, I should have spotted that some
time ago :/

I seem to have misplaced the thinking-cap because no elegant solution
comes to mind. Let me ponder this a bit.


One possibility is to remove PERF_EVENT_PERIOD, initially I though it
would be a somewhat rare event since we'd only be adjusting the period
sporadically (RR events), but we're now doing it for every overflow too.
Rendering it useless in favour of PERF_SAMPLE_PERIOD.

But that would still leave us PERF_EVENT_THROTTLE, where you really want
to tie the throttle to a particular event stream, but there too you'd
want it to be able to tie it back to a created counter.

So we could then extend PERF_EVENT_THROTTLE with a second ID. But that
would still leave us with the initial problem that there is only one ID
in the SAMPLE bits.

Hmm, ok, so how about something like this:

---
Subject: perf_counter: PERF_SAMPLE_ID and inherited counters

Anton noted that for inherited counters the counter-id as provided by
PERF_SAMPLE_ID isn't mappable to the id found through PERF_RECORD_ID
because each inherited counter gets its own id.

His suggestion was to always return the parent counter id, since that is
the primary counter id as exposed. However, these inherited counters
have a unique identifier so that events like PERF_EVENT_PERIOD and
PERF_EVENT_THROTTLE can be specific about which counter gets modified,
which is important when trying to normalize the sample streams.

This patch removes PERF_EVENT_PERIOD in favour of PERF_SAMPLE_PERIOD,
which is more useful anyway, since changing periods became a lot more
common than initially thought -- rendering PERF_EVENT_PERIOD the less
useful solution (also, PERF_SAMPLE_PERIOD reports the more accurate
value, since it reports the value used to trigger the overflow, whereas
PERF_EVENT_PERIOD simply reports the requested period changed, which
might only take effect on the next cycle).

This still leaves us PERF_EVENT_THROTTLE to consider, but since that
_should_ be a rare occurrence, and linking it to a primary id is the
most useful bit to diagnose the problem, we introduce a
PERF_SAMPLE_STREAM_ID, for those few cases where the full reconstruction
is important.

[Does change the ABI a little, but I see no other way out]

Suggested-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_counter.h  |   15 ++-----
 kernel/perf_counter.c         |   96 ++++++++++++++---------------------------
 tools/perf/builtin-annotate.c |   24 ----------
 tools/perf/builtin-report.c   |   24 ----------
 4 files changed, 36 insertions(+), 123 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 5e970c7..bd15d7a 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -120,8 +120,9 @@ enum perf_counter_sample_format {
 	PERF_SAMPLE_ID				= 1U << 6,
 	PERF_SAMPLE_CPU				= 1U << 7,
 	PERF_SAMPLE_PERIOD			= 1U << 8,
+	PERF_SAMPLE_STREAM_ID			= 1U << 9,
 
-	PERF_SAMPLE_MAX = 1U << 9,		/* non-ABI */
+	PERF_SAMPLE_MAX = 1U << 10,		/* non-ABI */
 };
 
 /*
@@ -312,16 +313,7 @@ enum perf_event_type {
 	 *	struct perf_event_header	header;
 	 *	u64				time;
 	 *	u64				id;
-	 *	u64				sample_period;
-	 * };
-	 */
-	PERF_EVENT_PERIOD		= 4,
-
-	/*
-	 * struct {
-	 *	struct perf_event_header	header;
-	 *	u64				time;
-	 *	u64				id;
+	 *	u64				stream_id;
 	 * };
 	 */
 	PERF_EVENT_THROTTLE		= 5,
@@ -356,6 +348,7 @@ enum perf_event_type {
 	 *	{ u64			time;     } && PERF_SAMPLE_TIME
 	 *	{ u64			addr;     } && PERF_SAMPLE_ADDR
 	 *	{ u64			id;	  } && PERF_SAMPLE_ID
+	 *	{ u64			stream_id;} && PERF_SAMPLE_STREAM_ID
 	 *	{ u32			cpu, res; } && PERF_SAMPLE_CPU
 	 * 	{ u64			period;   } && PERF_SAMPLE_PERIOD
 	 *
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 5498890..c185eba 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -154,6 +154,20 @@ static void unclone_ctx(struct perf_counter_context *ctx)
 	}
 }
 
+/* 
+ * If we inherit counters we want to return the parent counter id 
+ * to userspace.
+ */
+static u64 primary_counter_id(struct perf_counter *counter)
+{
+	u64 id = counter->id;
+
+	if (counter->parent)
+		id = counter->parent->id;
+
+	return id;
+}
+
 /*
  * Get the perf_counter_context for a task and lock it.
  * This has to cope with with the fact that until it is locked,
@@ -1296,7 +1310,6 @@ static void perf_counter_cpu_sched_in(struct perf_cpu_context *cpuctx, int cpu)
 #define MAX_INTERRUPTS (~0ULL)
 
 static void perf_log_throttle(struct perf_counter *counter, int enable);
-static void perf_log_period(struct perf_counter *counter, u64 period);
 
 static void perf_adjust_period(struct perf_counter *counter, u64 events)
 {
@@ -1315,8 +1328,6 @@ static void perf_adjust_period(struct perf_counter *counter, u64 events)
 	if (!sample_period)
 		sample_period = 1;
 
-	perf_log_period(counter, sample_period);
-
 	hwc->sample_period = sample_period;
 }
 
@@ -1705,7 +1716,7 @@ perf_read_hw(struct perf_counter *counter, char __user *buf, size_t count)
 		values[n++] = counter->total_time_running +
 			atomic64_read(&counter->child_total_time_running);
 	if (counter->attr.read_format & PERF_FORMAT_ID)
-		values[n++] = counter->id;
+		values[n++] = primary_counter_id(counter);
 	mutex_unlock(&counter->child_mutex);
 
 	if (count < n * sizeof(u64))
@@ -1812,8 +1823,6 @@ static int perf_counter_period(struct perf_counter *counter, u64 __user *arg)
 
 		counter->attr.sample_freq = value;
 	} else {
-		perf_log_period(counter, value);
-
 		counter->attr.sample_period = value;
 		counter->hw.sample_period = value;
 	}
@@ -2662,6 +2671,9 @@ static void perf_counter_output(struct perf_counter *counter, int nmi,
 	if (sample_type & PERF_SAMPLE_ID)
 		header.size += sizeof(u64);
 
+	if (sample_type & PERF_SAMPLE_STREAM_ID)
+		header.size += sizeof(u64);
+
 	if (sample_type & PERF_SAMPLE_CPU) {
 		header.size += sizeof(cpu_entry);
 
@@ -2704,7 +2716,13 @@ static void perf_counter_output(struct perf_counter *counter, int nmi,
 	if (sample_type & PERF_SAMPLE_ADDR)
 		perf_output_put(&handle, data->addr);
 
-	if (sample_type & PERF_SAMPLE_ID)
+	if (sample_type & PERF_SAMPLE_ID) {
+		u64 id = primary_counter_id(counter);
+
+		perf_output_put(&handle, id);
+	}
+
+	if (sample_type & PERF_SAMPLE_STREAM_ID)
 		perf_output_put(&handle, counter->id);
 
 	if (sample_type & PERF_SAMPLE_CPU)
@@ -2727,7 +2745,7 @@ static void perf_counter_output(struct perf_counter *counter, int nmi,
 			if (sub != counter)
 				sub->pmu->read(sub);
 
-			group_entry.id = sub->id;
+			group_entry.id = primary_counter_id(sub);
 			group_entry.counter = atomic64_read(&sub->count);
 
 			perf_output_put(&handle, group_entry);
@@ -2786,17 +2804,8 @@ perf_counter_read_event(struct perf_counter *counter,
 		event.format[i++] = counter->total_time_running;
 	}
 
-	if (counter->attr.read_format & PERF_FORMAT_ID) {
-		u64 id;
-
-		event.header.size += sizeof(u64);
-		if (counter->parent)
-			id = counter->parent->id;
-		else
-			id = counter->id;
-
-		event.format[i++] = id;
-	}
+	if (counter->attr.read_format & PERF_FORMAT_ID)
+		event.format[i++] = primary_counter_id(counter);
 
 	ret = perf_output_begin(&handle, counter, event.header.size, 0, 0);
 	if (ret)
@@ -3171,49 +3180,6 @@ void __perf_counter_mmap(struct vm_area_struct *vma)
 }
 
 /*
- * Log sample_period changes so that analyzing tools can re-normalize the
- * event flow.
- */
-
-struct freq_event {
-	struct perf_event_header	header;
-	u64				time;
-	u64				id;
-	u64				period;
-};
-
-static void perf_log_period(struct perf_counter *counter, u64 period)
-{
-	struct perf_output_handle handle;
-	struct freq_event event;
-	int ret;
-
-	if (counter->hw.sample_period == period)
-		return;
-
-	if (counter->attr.sample_type & PERF_SAMPLE_PERIOD)
-		return;
-
-	event = (struct freq_event) {
-		.header = {
-			.type = PERF_EVENT_PERIOD,
-			.misc = 0,
-			.size = sizeof(event),
-		},
-		.time = sched_clock(),
-		.id = counter->id,
-		.period = period,
-	};
-
-	ret = perf_output_begin(&handle, counter, sizeof(event), 1, 0);
-	if (ret)
-		return;
-
-	perf_output_put(&handle, event);
-	perf_output_end(&handle);
-}
-
-/*
  * IRQ throttle logging
  */
 
@@ -3226,14 +3192,16 @@ static void perf_log_throttle(struct perf_counter *counter, int enable)
 		struct perf_event_header	header;
 		u64				time;
 		u64				id;
+		u64				stream_id;
 	} throttle_event = {
 		.header = {
 			.type = PERF_EVENT_THROTTLE + 1,
 			.misc = 0,
 			.size = sizeof(throttle_event),
 		},
-		.time	= sched_clock(),
-		.id	= counter->id,
+		.time		= sched_clock(),
+		.id		= primary_counter_id(counter),
+		.stream_id	= counter->id,
 	};
 
 	ret = perf_output_begin(&handle, counter, sizeof(throttle_event), 1, 0);
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 5f9eefe..1dba568 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -74,20 +74,12 @@ struct fork_event {
 	u32 pid, ppid;
 };
 
-struct period_event {
-	struct perf_event_header header;
-	u64 time;
-	u64 id;
-	u64 sample_period;
-};
-
 typedef union event_union {
 	struct perf_event_header	header;
 	struct ip_event			ip;
 	struct mmap_event		mmap;
 	struct comm_event		comm;
 	struct fork_event		fork;
-	struct period_event		period;
 } event_t;
 
 
@@ -998,19 +990,6 @@ process_fork_event(event_t *event, unsigned long offset, unsigned long head)
 }
 
 static int
-process_period_event(event_t *event, unsigned long offset, unsigned long head)
-{
-	dprintf("%p [%p]: PERF_EVENT_PERIOD: time:%Ld, id:%Ld: period:%Ld\n",
-		(void *)(offset + head),
-		(void *)(long)(event->header.size),
-		event->period.time,
-		event->period.id,
-		event->period.sample_period);
-
-	return 0;
-}
-
-static int
 process_event(event_t *event, unsigned long offset, unsigned long head)
 {
 	switch (event->header.type) {
@@ -1025,9 +1004,6 @@ process_event(event_t *event, unsigned long offset, unsigned long head)
 
 	case PERF_EVENT_FORK:
 		return process_fork_event(event, offset, head);
-
-	case PERF_EVENT_PERIOD:
-		return process_period_event(event, offset, head);
 	/*
 	 * We dont process them right now but they are fine:
 	 */
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index a118bc7..b20a4b6 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -101,13 +101,6 @@ struct fork_event {
 	u32 pid, ppid;
 };
 
-struct period_event {
-	struct perf_event_header header;
-	u64 time;
-	u64 id;
-	u64 sample_period;
-};
-
 struct lost_event {
 	struct perf_event_header header;
 	u64 id;
@@ -127,7 +120,6 @@ typedef union event_union {
 	struct mmap_event		mmap;
 	struct comm_event		comm;
 	struct fork_event		fork;
-	struct period_event		period;
 	struct lost_event		lost;
 	struct read_event		read;
 } event_t;
@@ -1636,19 +1628,6 @@ process_fork_event(event_t *event, unsigned long offset, unsigned long head)
 }
 
 static int
-process_period_event(event_t *event, unsigned long offset, unsigned long head)
-{
-	dprintf("%p [%p]: PERF_EVENT_PERIOD: time:%Ld, id:%Ld: period:%Ld\n",
-		(void *)(offset + head),
-		(void *)(long)(event->header.size),
-		event->period.time,
-		event->period.id,
-		event->period.sample_period);
-
-	return 0;
-}
-
-static int
 process_lost_event(event_t *event, unsigned long offset, unsigned long head)
 {
 	dprintf("%p [%p]: PERF_EVENT_LOST: id:%Ld: lost:%Ld\n",
@@ -1729,9 +1708,6 @@ process_event(event_t *event, unsigned long offset, unsigned long head)
 	case PERF_EVENT_FORK:
 		return process_fork_event(event, offset, head);
 
-	case PERF_EVENT_PERIOD:
-		return process_period_event(event, offset, head);
-
 	case PERF_EVENT_LOST:
 		return process_lost_event(event, offset, head);
 


