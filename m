Return-Path: <linux-kernel-owner+w=401wt.eu-S1758077AbZCEXaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758077AbZCEXaK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 18:30:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757766AbZCEX3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 18:29:05 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:47970 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757971AbZCEX3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 18:29:03 -0500
Message-Id: <20090305225516.392170785@polymtl.ca>
References: <20090305224728.947235917@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 05 Mar 2009 17:47:49 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>, ltt-dev@lists.casi.polymtl.ca,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Martin Bligh <mbligh@google.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       Jiaying Zhang <jiayingz@google.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       mrubin@google.com, md@google.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [RFC patch 21/41] LTTng probes specialized tracepoints
Content-Disposition: inline; filename=lttng-type-serializer.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Thu,  5 Mar 2009 23:14:12 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tracing tbench runs gives those top event counts :

(~7 sec run)

kernel_arch_syscall_exit :   4570630
kernel_arch_syscall_entry :  4570589
kernel_timer_set :           2276276
kernel_softirq_entry :       1446470
kernel_softirq_exit :        1446469
kernel_sched_schedule :      1362552
kernel_sched_try_wakeup :    1140044
mm_page_alloc :              1033063
mm_page_free :                927878

All other events are much lower :
fs_write :                     20575

This patch creates specialized probes to accelerate tbench high-rate
events.

TODO : do lockdep specialized probes.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 include/linux/ltt-type-serializer.h |  107 ++++++++++++++++++++++++++++++++++++
 ltt/ltt-type-serializer.c           |   96 ++++++++++++++++++++++++++++++++
 2 files changed, 203 insertions(+)

Index: linux-2.6-lttng/ltt/ltt-type-serializer.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/ltt/ltt-type-serializer.c	2009-03-04 14:08:15.000000000 -0500
@@ -0,0 +1,96 @@
+/**
+ * ltt-type-serializer.c
+ *
+ * LTTng specialized type serializer.
+ *
+ * Copyright Mathieu Desnoyers, 2008.
+ */
+#include <linux/module.h>
+#include <linux/ltt-type-serializer.h>
+
+notrace void _ltt_specialized_trace(const struct marker *mdata,
+		void *probe_data,
+		void *serialize_private, unsigned int data_size,
+		unsigned int largest_align)
+{
+	int ret;
+	uint16_t eID;
+	size_t slot_size;
+	unsigned int chan_index;
+	struct ltt_channel_struct *channel;
+	struct ltt_trace_struct *trace;
+	struct rchan_buf *buf;
+	void *transport_data;
+	uint64_t tsc;
+	long buf_offset;
+	int cpu;
+	unsigned int rflags;
+
+	/*
+	 * If we get here, it's probably because we have useful work to do.
+	 */
+	if (unlikely(ltt_traces.num_active_traces == 0))
+		return;
+
+	rcu_read_lock_sched_notrace();
+	cpu = smp_processor_id();
+	__get_cpu_var(ltt_nesting)++;
+
+	eID = mdata->event_id;
+	chan_index = mdata->channel_id;
+
+	/* Iterate on each trace */
+	list_for_each_entry_rcu(trace, &ltt_traces.head, list) {
+		if (unlikely(!trace->active))
+			continue;
+		if (unlikely(!ltt_run_filter(trace, eID)))
+			continue;
+#ifdef CONFIG_LTT_DEBUG_EVENT_SIZE
+		rflags = LTT_RFLAG_ID_SIZE;
+#else
+		if (unlikely(eID >= LTT_FREE_EVENTS))
+			rflags = LTT_RFLAG_ID;
+		else
+			rflags = 0;
+#endif
+		/*
+		 * Skip channels added after trace creation.
+		 */
+		if (unlikely(chan_index >= trace->nr_channels))
+			continue;
+		channel = &trace->channels[chan_index];
+		if (!channel->active)
+			continue;
+
+		/* reserve space : header and data */
+		ret = ltt_reserve_slot(trace, channel, &transport_data,
+					data_size, &slot_size, &buf_offset,
+					&tsc, &rflags,
+					largest_align, cpu);
+		if (unlikely(ret < 0))
+			continue; /* buffer full */
+
+		/* FIXME : could probably encapsulate transport better. */
+		buf = ((struct rchan *)channel->trans_channel_data)->buf[cpu];
+		/* Out-of-order write : header and data */
+		buf_offset = ltt_write_event_header(trace,
+					channel, buf, buf_offset,
+					eID, data_size, tsc, rflags);
+		if (data_size) {
+			buf_offset += ltt_align(buf_offset, largest_align);
+			ltt_relay_write(buf, buf_offset, serialize_private,
+				data_size);
+			buf_offset += data_size;
+		}
+		/* Out-of-order commit */
+		ltt_commit_slot(channel, &transport_data, buf_offset,
+				slot_size);
+	}
+	__get_cpu_var(ltt_nesting)--;
+	rcu_read_unlock_sched_notrace();
+}
+EXPORT_SYMBOL_GPL(_ltt_specialized_trace);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Mathieu Desnoyers");
+MODULE_DESCRIPTION("LTT type serializer");
Index: linux-2.6-lttng/include/linux/ltt-type-serializer.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/linux/ltt-type-serializer.h	2009-03-04 14:08:15.000000000 -0500
@@ -0,0 +1,107 @@
+#ifndef _LTT_TYPE_SERIALIZER_H
+#define _LTT_TYPE_SERIALIZER_H
+
+#include <linux/ltt-tracer.h>
+
+/*
+ * largest_align must be non-zero, equal to the minimum between the largest type
+ * and sizeof(void *).
+ */
+extern void _ltt_specialized_trace(const struct marker *mdata, void *probe_data,
+		void *serialize_private, unsigned int data_size,
+		unsigned int largest_align);
+
+/*
+ * Statically check that 0 < largest_align < sizeof(void *) to make sure it is
+ * dumb-proof. It will make sure 0 is changed into 1 and unsigned long long is
+ * changed into sizeof(void *) on 32-bit architectures.
+ */
+static inline void ltt_specialized_trace(const struct marker *mdata,
+		void *probe_data,
+		void *serialize_private, unsigned int data_size,
+		unsigned int largest_align)
+{
+	largest_align = min_t(unsigned int, largest_align, sizeof(void *));
+	largest_align = max_t(unsigned int, largest_align, 1);
+	_ltt_specialized_trace(mdata, probe_data, serialize_private, data_size,
+		largest_align);
+}
+
+/*
+ * Type serializer definitions.
+ */
+
+/*
+ * Return size of structure without end-of-structure padding.
+ */
+#define serialize_sizeof(type)	offsetof(typeof(type), end_field)
+
+struct serialize_long_int {
+	unsigned long f1;
+	unsigned int f2;
+	unsigned char end_field[0];
+} LTT_ALIGN;
+
+struct serialize_int_int_long {
+	unsigned int f1;
+	unsigned int f2;
+	unsigned long f3;
+	unsigned char end_field[0];
+} LTT_ALIGN;
+
+struct serialize_int_int_short {
+	unsigned int f1;
+	unsigned int f2;
+	unsigned short f3;
+	unsigned char end_field[0];
+} LTT_ALIGN;
+
+struct serialize_long_long_long {
+	unsigned long f1;
+	unsigned long f2;
+	unsigned long f3;
+	unsigned char end_field[0];
+} LTT_ALIGN;
+
+struct serialize_long_long_int {
+	unsigned long f1;
+	unsigned long f2;
+	unsigned int f3;
+	unsigned char end_field[0];
+} LTT_ALIGN;
+
+struct serialize_long_long_short_char {
+	unsigned long f1;
+	unsigned long f2;
+	unsigned short f3;
+	unsigned char f4;
+	unsigned char end_field[0];
+} LTT_ALIGN;
+
+struct serialize_long_long_short {
+	unsigned long f1;
+	unsigned long f2;
+	unsigned short f3;
+	unsigned char end_field[0];
+} LTT_ALIGN;
+
+struct serialize_long_short_char {
+	unsigned long f1;
+	unsigned short f2;
+	unsigned char f3;
+	unsigned char end_field[0];
+} LTT_ALIGN;
+
+struct serialize_long_short {
+	unsigned long f1;
+	unsigned short f2;
+	unsigned char end_field[0];
+} LTT_ALIGN;
+
+struct serialize_long_char {
+	unsigned long f1;
+	unsigned char f2;
+	unsigned char end_field[0];
+} LTT_ALIGN;
+
+#endif /* _LTT_TYPE_SERIALIZER_H */

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
