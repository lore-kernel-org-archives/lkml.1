Return-Path: <linux-kernel-owner+w=401wt.eu-S1753816AbZHLPm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816AbZHLPm7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 11:42:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753784AbZHLPm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 11:42:59 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42921 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753777AbZHLPm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 11:42:56 -0400
Message-Id: <20090812154118.044301415@chello.nl>
References: <20090812153529.716542680@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 12 Aug 2009 17:35:30 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       stephane eranian <eranian@googlemail.com>
Cc: Corey J Ashford <cjashfor@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/2] perf: rework the whole read vs group stuff
Content-Disposition: inline; filename=perf-PERF_SAMPLE_READ.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace PERF_SAMPLE_GROUP with PERF_SAMPLE_READ and introduce
PERF_FORMAT_GROUP to deal with group reads in a more generic way.

This allows you to get group reads out of read() as well.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_counter.h |   36 +++++--
 kernel/perf_counter.c        |  213 +++++++++++++++++++++++++++++--------------
 2 files changed, 172 insertions(+), 77 deletions(-)

Index: linux-2.6/include/linux/perf_counter.h
===================================================================
--- linux-2.6.orig/include/linux/perf_counter.h
+++ linux-2.6/include/linux/perf_counter.h
@@ -115,7 +115,7 @@ enum perf_counter_sample_format {
 	PERF_SAMPLE_TID				= 1U << 1,
 	PERF_SAMPLE_TIME			= 1U << 2,
 	PERF_SAMPLE_ADDR			= 1U << 3,
-	PERF_SAMPLE_GROUP			= 1U << 4,
+	PERF_SAMPLE_READ			= 1U << 4,
 	PERF_SAMPLE_CALLCHAIN			= 1U << 5,
 	PERF_SAMPLE_ID				= 1U << 6,
 	PERF_SAMPLE_CPU				= 1U << 7,
@@ -130,13 +130,25 @@ enum perf_counter_sample_format {
  * Bits that can be set in attr.read_format to request that
  * reads on the counter should return the indicated quantities,
  * in increasing order of bit value, after the counter value.
+ *
+ * struct {
+ * 	{ u64		nr; 		} && PERF_FORMAT_GROUP
+ * 	{ u64		time_enabled;	} && PERF_FORMAT_ENABLED
+ * 	{ u64		time_running;	} && PERF_FORMAT_RUNNING
+ * 	{ u64		value;
+ * 	  { u64		id;		} && PERF_FORMAT_ID
+ * 	} 		cntr[nr];
+ * };
+ *
+ * Where 'nr' defaults to 1 when !PERF_FORMAT_GROUP
  */
 enum perf_counter_read_format {
 	PERF_FORMAT_TOTAL_TIME_ENABLED		= 1U << 0,
 	PERF_FORMAT_TOTAL_TIME_RUNNING		= 1U << 1,
 	PERF_FORMAT_ID				= 1U << 2,
+	PERF_FORMAT_GROUP			= 1U << 3,
 
-	PERF_FORMAT_MAX = 1U << 3, 		/* non-ABI */
+	PERF_FORMAT_MAX = 1U << 4, 		/* non-ABI */
 };
 
 #define PERF_ATTR_SIZE_VER0	64	/* sizeof first published struct */
@@ -343,10 +355,13 @@ enum perf_event_type {
 	 * struct {
 	 * 	struct perf_event_header	header;
 	 * 	u32				pid, tid;
-	 * 	u64				value;
-	 * 	{ u64		time_enabled; 	} && PERF_FORMAT_ENABLED
-	 * 	{ u64		time_running; 	} && PERF_FORMAT_RUNNING
-	 * 	{ u64		parent_id;	} && PERF_FORMAT_ID
+	 *
+	 * 	{ u64		nr;		} && PERF_FORMAT_GROUP
+	 * 	{ u64		value;
+	 * 	  { u64		time_enabled; 	} && PERF_FORMAT_ENABLED
+	 * 	  { u64		time_running; 	} && PERF_FORMAT_RUNNING
+	 * 	  { u64		parent_id;	} && PERF_FORMAT_ID
+	 * 	} 				cntr[nr];
 	 * };
 	 */
 	PERF_EVENT_READ			= 8,
@@ -364,11 +379,16 @@ enum perf_event_type {
 	 *	{ u32			cpu, res; } && PERF_SAMPLE_CPU
 	 * 	{ u64			period;   } && PERF_SAMPLE_PERIOD
 	 *
-	 *	{ u64			nr;
-	 *	  { u64 id, val; }	cnt[nr];  } && PERF_SAMPLE_GROUP
+	 *	{ { u64			nr;   } && PERF_FORMAT_GROUP
+	 *	  { u64		value;
+	 *	    { u64	time_enabled; } && PERF_FORMAT_ENABLED
+	 *	    { u64	time_running; } && PERF_FORMAT_RUNNING
+	 *	    { u64	id;           } && PERF_FORMAT_ID
+	 *	  }			cntr[nr]; } && PERF_SAMPLE_READ
 	 *
 	 *	{ u64			nr,
 	 *	  u64			ips[nr];  } && PERF_SAMPLE_CALLCHAIN
+	 *
 	 *	{ u32			size;
 	 *	  char                  data[size];}&& PERF_SAMPLE_RAW
 	 * };
Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -1692,7 +1692,32 @@ static int perf_release(struct inode *in
 	return 0;
 }
 
-static u64 perf_counter_read_tree(struct perf_counter *counter)
+static int perf_counter_read_size(struct perf_counter *counter)
+{
+	int entry = sizeof(u64); /* value */
+	int size = 0;
+	int nr = 1;
+
+	if (counter->attr.read_format & PERF_FORMAT_TOTAL_TIME_ENABLED)
+		size += sizeof(u64);
+
+	if (counter->attr.read_format & PERF_FORMAT_TOTAL_TIME_RUNNING)
+		size += sizeof(u64);
+
+	if (counter->attr.read_format & PERF_FORMAT_ID)
+		entry += sizeof(u64);
+
+	if (counter->attr.read_format & PERF_FORMAT_GROUP) {
+		nr += counter->group_leader->nr_siblings;
+		size += sizeof(u64);
+	}
+
+	size += entry * nr;
+
+	return size;
+}
+
+static u64 perf_counter_read_value(struct perf_counter *counter)
 {
 	struct perf_counter *child;
 	u64 total = 0;
@@ -1704,14 +1729,34 @@ static u64 perf_counter_read_tree(struct
 	return total;
 }
 
+static int perf_counter_read_entry(struct perf_counter *counter,
+				   u64 read_format, char __user *buf)
+{
+	u64 values[2];
+	int n = 0, count = 0;
+
+	values[n++] = perf_counter_read_value(counter);
+	if (read_format & PERF_FORMAT_ID)
+		values[n++] = primary_counter_id(counter);
+
+	count = n * sizeof(u64);
+
+	if (copy_to_user(buf, values, count))
+		return -EFAULT;
+
+	return count;
+}
+
 /*
  * Read the performance counter - simple non blocking version for now
  */
 static ssize_t
 perf_read_hw(struct perf_counter *counter, char __user *buf, size_t count)
 {
-	u64 values[4];
-	int n;
+	u64 read_format = counter->attr.read_format;
+	struct perf_counter *leader = counter, *sub;
+	int n = 0, size = 0, err = -EFAULT;
+	u64 values[3];
 
 	/*
 	 * Return end-of-file for a read on a counter that is in
@@ -1721,28 +1766,52 @@ perf_read_hw(struct perf_counter *counte
 	if (counter->state == PERF_COUNTER_STATE_ERROR)
 		return 0;
 
+	if (count < perf_counter_read_size(counter))
+		return -ENOSPC;
+
 	WARN_ON_ONCE(counter->ctx->parent_ctx);
 	mutex_lock(&counter->child_mutex);
-	values[0] = perf_counter_read_tree(counter);
-	n = 1;
-	if (counter->attr.read_format & PERF_FORMAT_TOTAL_TIME_ENABLED)
-		values[n++] = counter->total_time_enabled +
-			atomic64_read(&counter->child_total_time_enabled);
-	if (counter->attr.read_format & PERF_FORMAT_TOTAL_TIME_RUNNING)
-		values[n++] = counter->total_time_running +
-			atomic64_read(&counter->child_total_time_running);
-	if (counter->attr.read_format & PERF_FORMAT_ID)
-		values[n++] = primary_counter_id(counter);
-	mutex_unlock(&counter->child_mutex);
 
-	if (count < n * sizeof(u64))
-		return -EINVAL;
-	count = n * sizeof(u64);
+	if (read_format & PERF_FORMAT_GROUP) {
+		leader = counter->group_leader;
+		values[n++] = 1 + leader->nr_siblings;
+	}
+	if (leader->attr.read_format & PERF_FORMAT_TOTAL_TIME_ENABLED) {
+		values[n++] = leader->total_time_enabled +
+			atomic64_read(&leader->child_total_time_enabled);
+	}
+	if (leader->attr.read_format & PERF_FORMAT_TOTAL_TIME_RUNNING) {
+		values[n++] = leader->total_time_running +
+			atomic64_read(&leader->child_total_time_running);
+	}
 
-	if (copy_to_user(buf, values, count))
-		return -EFAULT;
+	size = n * sizeof(u64);
 
-	return count;
+	if (copy_to_user(buf, values, size))
+		goto unlock;
+
+	err = perf_counter_read_entry(leader, read_format, buf + size);
+	if (err < 0)
+		goto unlock;
+
+	size += err;
+
+	if (read_format & PERF_FORMAT_GROUP) {
+		list_for_each_entry(sub, &leader->sibling_list, list_entry) {
+			err = perf_counter_read_entry(counter, read_format,
+					buf + size);
+			if (err < 0)
+				goto unlock;
+
+			size += err;
+		}
+	}
+
+	err = size;
+unlock:
+	mutex_unlock(&counter->child_mutex);
+
+	return err;
 }
 
 static ssize_t
@@ -2631,6 +2700,49 @@ static u32 perf_counter_tid(struct perf_
 	return task_pid_nr_ns(p, counter->ns);
 }
 
+void perf_output_read(struct perf_output_handle *handle, struct perf_counter *counter)
+{
+	struct perf_counter *leader = counter, *sub;
+	u64 read_format = counter->attr.read_format;
+	u64 values[5];
+	int n = 0;
+
+	if (read_format & PERF_FORMAT_GROUP) {
+		leader = counter->group_leader;
+		values[n++] = 1 + leader->nr_siblings;
+	}
+
+	if (read_format & PERF_FORMAT_TOTAL_TIME_ENABLED)
+		values[n++] = leader->total_time_enabled;
+
+	if (read_format & PERF_FORMAT_TOTAL_TIME_RUNNING)
+		values[n++] = leader->total_time_running;
+
+	if (leader != counter)
+		leader->pmu->read(leader);
+	values[n++] = atomic64_read(&leader->count);
+
+	if (read_format & PERF_FORMAT_ID)
+		values[n++] = primary_counter_id(leader);
+
+	perf_output_copy(handle, values, n * sizeof(u64));
+
+	if (read_format & PERF_FORMAT_GROUP) {
+		list_for_each_entry(sub, &leader->sibling_list, list_entry) {
+			n = 0;
+
+			if (sub != counter)
+				sub->pmu->read(sub);
+
+			values[n++] = atomic64_read(&sub->count);
+			if (read_format & PERF_FORMAT_ID)
+				values[n++] = primary_counter_id(sub);
+
+			perf_output_copy(handle, values, n * sizeof(u64));
+		}
+	}
+}
+
 void perf_counter_output(struct perf_counter *counter, int nmi,
 				struct perf_sample_data *data)
 {
@@ -2642,10 +2754,6 @@ void perf_counter_output(struct perf_cou
 	struct {
 		u32 pid, tid;
 	} tid_entry;
-	struct {
-		u64 id;
-		u64 counter;
-	} group_entry;
 	struct perf_callchain_entry *callchain = NULL;
 	int callchain_size = 0;
 	u64 time;
@@ -2700,10 +2808,8 @@ void perf_counter_output(struct perf_cou
 	if (sample_type & PERF_SAMPLE_PERIOD)
 		header.size += sizeof(u64);
 
-	if (sample_type & PERF_SAMPLE_GROUP) {
-		header.size += sizeof(u64) +
-			counter->nr_siblings * sizeof(group_entry);
-	}
+	if (sample_type & PERF_SAMPLE_READ)
+		header.size += perf_counter_read_size(counter);
 
 	if (sample_type & PERF_SAMPLE_CALLCHAIN) {
 		callchain = perf_callchain(data->regs);
@@ -2761,25 +2867,10 @@ void perf_counter_output(struct perf_cou
 		perf_output_put(&handle, data->period);
 
 	/*
-	 * XXX PERF_SAMPLE_GROUP vs inherited counters seems difficult.
+	 * XXX PERF_SAMPLE_READ vs inherited counters seems difficult.
 	 */
-	if (sample_type & PERF_SAMPLE_GROUP) {
-		struct perf_counter *leader, *sub;
-		u64 nr = counter->nr_siblings;
-
-		perf_output_put(&handle, nr);
-
-		leader = counter->group_leader;
-		list_for_each_entry(sub, &leader->sibling_list, list_entry) {
-			if (sub != counter)
-				sub->pmu->read(sub);
-
-			group_entry.id = primary_counter_id(sub);
-			group_entry.counter = atomic64_read(&sub->count);
-
-			perf_output_put(&handle, group_entry);
-		}
-	}
+	if (sample_type & PERF_SAMPLE_READ)
+		perf_output_read(&handle, counter);
 
 	if (sample_type & PERF_SAMPLE_CALLCHAIN) {
 		if (callchain)
@@ -2818,8 +2909,6 @@ struct perf_read_event {
 
 	u32				pid;
 	u32				tid;
-	u64				value;
-	u64				format[3];
 };
 
 static void
@@ -2831,34 +2920,20 @@ perf_counter_read_event(struct perf_coun
 		.header = {
 			.type = PERF_EVENT_READ,
 			.misc = 0,
-			.size = sizeof(event) - sizeof(event.format),
+			.size = sizeof(event) + perf_counter_read_size(counter),
 		},
 		.pid = perf_counter_pid(counter, task),
 		.tid = perf_counter_tid(counter, task),
-		.value = atomic64_read(&counter->count),
 	};
-	int ret, i = 0;
-
-	if (counter->attr.read_format & PERF_FORMAT_TOTAL_TIME_ENABLED) {
-		event.header.size += sizeof(u64);
-		event.format[i++] = counter->total_time_enabled;
-	}
-
-	if (counter->attr.read_format & PERF_FORMAT_TOTAL_TIME_RUNNING) {
-		event.header.size += sizeof(u64);
-		event.format[i++] = counter->total_time_running;
-	}
-
-	if (counter->attr.read_format & PERF_FORMAT_ID) {
-		event.header.size += sizeof(u64);
-		event.format[i++] = primary_counter_id(counter);
-	}
+	int ret;
 
 	ret = perf_output_begin(&handle, counter, event.header.size, 0, 0);
 	if (ret)
 		return;
 
-	perf_output_copy(&handle, &event, event.header.size);
+	perf_output_put(&handle, event);
+	perf_output_read(&handle, counter);
+
 	perf_output_end(&handle);
 }
 
@@ -3929,9 +4004,9 @@ perf_counter_alloc(struct perf_counter_a
 	atomic64_set(&hwc->period_left, hwc->sample_period);
 
 	/*
-	 * we currently do not support PERF_SAMPLE_GROUP on inherited counters
+	 * we currently do not support PERF_FORMAT_GROUP on inherited counters
 	 */
-	if (attr->inherit && (attr->sample_type & PERF_SAMPLE_GROUP))
+	if (attr->inherit && (attr->read_format & PERF_FORMAT_GROUP))
 		goto done;
 
 	switch (attr->type) {

-- 

