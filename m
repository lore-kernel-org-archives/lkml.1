Return-Path: <linux-kernel-owner+w=401wt.eu-S933966AbZLFRTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933966AbZLFRTa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 12:19:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933928AbZLFRT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 12:19:29 -0500
Received: from hera.kernel.org ([140.211.167.34]:47487 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933925AbZLFRTW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 12:19:22 -0500
Date: Sun, 6 Dec 2009 17:18:55 GMT
From: tip-bot for OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       fweisbec@gmail.com, hirofumi@mail.parknet.co.jp, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, hirofumi@mail.parknet.co.jp, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <87hbs48imv.fsf@devron.myhome.or.jp>
References: <87hbs48imv.fsf@devron.myhome.or.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Make common SAMPLE_EVENT parser
Message-ID: <tip-180f95e29aa8782c019caa64ede2a28d8ab62564@git.kernel.org>
Git-Commit-ID: 180f95e29aa8782c019caa64ede2a28d8ab62564
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  180f95e29aa8782c019caa64ede2a28d8ab62564
Gitweb:     http://git.kernel.org/tip/180f95e29aa8782c019caa64ede2a28d8ab62564
Author:     OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
AuthorDate: Sun, 6 Dec 2009 20:08:24 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 6 Dec 2009 18:15:01 +0100

perf: Make common SAMPLE_EVENT parser

Currently, sample event data is parsed for each commands, and it
is assuming that the data is not including other data. (E.g.
timechart, trace, etc. can't parse the event if it has
PERF_SAMPLE_CALLCHAIN)

So, even if we record the superset data for multiple commands at
a time, commands can't parse. etc.

To fix it, this makes common sample event parser, and use it to
parse sample event correctly. (PERF_SAMPLE_READ is unsupported
for now though, it seems to be not using.)

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <87hbs48imv.fsf@devron.myhome.or.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-kmem.c      |   36 +++++++--------------
 tools/perf/builtin-report.c    |   39 +++++++++++------------
 tools/perf/builtin-sched.c     |   38 +++++++---------------
 tools/perf/builtin-timechart.c |   58 +++++++++-------------------------
 tools/perf/builtin-trace.c     |   48 +++++++++-------------------
 tools/perf/util/event.c        |   67 ++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/event.h        |   17 +++++++++-
 7 files changed, 156 insertions(+), 147 deletions(-)

diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 047fef7..f218990 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -320,35 +320,23 @@ process_raw_event(event_t *raw_event __used, void *more_data,
 
 static int process_sample_event(event_t *event)
 {
-	u64 ip = event->ip.ip;
-	u64 timestamp = -1;
-	u32 cpu = -1;
-	u64 period = 1;
-	void *more_data = event->ip.__more_data;
-	struct thread *thread = threads__findnew(event->ip.pid);
-
-	if (sample_type & PERF_SAMPLE_TIME) {
-		timestamp = *(u64 *)more_data;
-		more_data += sizeof(u64);
-	}
+	struct sample_data data;
+	struct thread *thread;
 
-	if (sample_type & PERF_SAMPLE_CPU) {
-		cpu = *(u32 *)more_data;
-		more_data += sizeof(u32);
-		more_data += sizeof(u32); /* reserved */
-	}
+	memset(&data, 0, sizeof(data));
+	data.time = -1;
+	data.cpu = -1;
+	data.period = 1;
 
-	if (sample_type & PERF_SAMPLE_PERIOD) {
-		period = *(u64 *)more_data;
-		more_data += sizeof(u64);
-	}
+	event__parse_sample(event, sample_type, &data);
 
 	dump_printf("(IP, %d): %d/%d: %p period: %Ld\n",
 		event->header.misc,
-		event->ip.pid, event->ip.tid,
-		(void *)(long)ip,
-		(long long)period);
+		data.pid, data.tid,
+		(void *)(long)data.ip,
+		(long long)data.period);
 
+	thread = threads__findnew(event->ip.pid);
 	if (thread == NULL) {
 		pr_debug("problem processing %d event, skipping it.\n",
 			 event->header.type);
@@ -357,7 +345,7 @@ static int process_sample_event(event_t *event)
 
 	dump_printf(" ... thread: %s:%d\n", thread->comm, thread->pid);
 
-	process_raw_event(event, more_data, cpu, timestamp, thread);
+	process_raw_event(event, data.raw_data, data.cpu, data.time, thread);
 
 	return 0;
 }
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 383c4ab..2b9eb3a 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -605,44 +605,41 @@ static int validate_chain(struct ip_callchain *chain, event_t *event)
 
 static int process_sample_event(event_t *event)
 {
-	u64 ip = event->ip.ip;
-	u64 period = 1;
-	void *more_data = event->ip.__more_data;
-	struct ip_callchain *chain = NULL;
+	struct sample_data data;
 	int cpumode;
 	struct addr_location al;
-	struct thread *thread = threads__findnew(event->ip.pid);
+	struct thread *thread;
 
-	if (sample_type & PERF_SAMPLE_PERIOD) {
-		period = *(u64 *)more_data;
-		more_data += sizeof(u64);
-	}
+	memset(&data, 0, sizeof(data));
+	data.period = 1;
+
+	event__parse_sample(event, sample_type, &data);
 
 	dump_printf("(IP, %d): %d/%d: %p period: %Ld\n",
 		event->header.misc,
-		event->ip.pid, event->ip.tid,
-		(void *)(long)ip,
-		(long long)period);
+		data.pid, data.tid,
+		(void *)(long)data.ip,
+		(long long)data.period);
 
 	if (sample_type & PERF_SAMPLE_CALLCHAIN) {
 		unsigned int i;
 
-		chain = (void *)more_data;
-
-		dump_printf("... chain: nr:%Lu\n", chain->nr);
+		dump_printf("... chain: nr:%Lu\n", data.callchain->nr);
 
-		if (validate_chain(chain, event) < 0) {
+		if (validate_chain(data.callchain, event) < 0) {
 			pr_debug("call-chain problem with event, "
 				 "skipping it.\n");
 			return 0;
 		}
 
 		if (dump_trace) {
-			for (i = 0; i < chain->nr; i++)
-				dump_printf("..... %2d: %016Lx\n", i, chain->ips[i]);
+			for (i = 0; i < data.callchain->nr; i++)
+				dump_printf("..... %2d: %016Lx\n",
+					    i, data.callchain->ips[i]);
 		}
 	}
 
+	thread = threads__findnew(data.pid);
 	if (thread == NULL) {
 		pr_debug("problem processing %d event, skipping it.\n",
 			event->header.type);
@@ -657,7 +654,7 @@ static int process_sample_event(event_t *event)
 	cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
 
 	thread__find_addr_location(thread, cpumode,
-				   MAP__FUNCTION, ip, &al, NULL);
+				   MAP__FUNCTION, data.ip, &al, NULL);
 	/*
 	 * We have to do this here as we may have a dso with no symbol hit that
 	 * has a name longer than the ones with symbols sampled.
@@ -675,12 +672,12 @@ static int process_sample_event(event_t *event)
 	if (sym_list && al.sym && !strlist__has_entry(sym_list, al.sym->name))
 		return 0;
 
-	if (hist_entry__add(&al, chain, period)) {
+	if (hist_entry__add(&al, data.callchain, data.period)) {
 		pr_debug("problem incrementing symbol count, skipping event\n");
 		return -1;
 	}
 
-	event__stats.total += period;
+	event__stats.total += data.period;
 
 	return 0;
 }
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 26b782f..45c46c7 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1598,40 +1598,26 @@ process_raw_event(event_t *raw_event __used, void *more_data,
 
 static int process_sample_event(event_t *event)
 {
+	struct sample_data data;
 	struct thread *thread;
-	u64 ip = event->ip.ip;
-	u64 timestamp = -1;
-	u32 cpu = -1;
-	u64 period = 1;
-	void *more_data = event->ip.__more_data;
 
 	if (!(sample_type & PERF_SAMPLE_RAW))
 		return 0;
 
-	thread = threads__findnew(event->ip.pid);
+	memset(&data, 0, sizeof(data));
+	data.time = -1;
+	data.cpu = -1;
+	data.period = -1;
 
-	if (sample_type & PERF_SAMPLE_TIME) {
-		timestamp = *(u64 *)more_data;
-		more_data += sizeof(u64);
-	}
-
-	if (sample_type & PERF_SAMPLE_CPU) {
-		cpu = *(u32 *)more_data;
-		more_data += sizeof(u32);
-		more_data += sizeof(u32); /* reserved */
-	}
-
-	if (sample_type & PERF_SAMPLE_PERIOD) {
-		period = *(u64 *)more_data;
-		more_data += sizeof(u64);
-	}
+	event__parse_sample(event, sample_type, &data);
 
 	dump_printf("(IP, %d): %d/%d: %p period: %Ld\n",
 		event->header.misc,
-		event->ip.pid, event->ip.tid,
-		(void *)(long)ip,
-		(long long)period);
+		data.pid, data.tid,
+		(void *)(long)data.ip,
+		(long long)data.period);
 
+	thread = threads__findnew(data.pid);
 	if (thread == NULL) {
 		pr_debug("problem processing %d event, skipping it.\n",
 			 event->header.type);
@@ -1640,10 +1626,10 @@ static int process_sample_event(event_t *event)
 
 	dump_printf(" ... thread: %s:%d\n", thread->comm, thread->pid);
 
-	if (profile_cpu != -1 && profile_cpu != (int) cpu)
+	if (profile_cpu != -1 && profile_cpu != (int)data.cpu)
 		return 0;
 
-	process_raw_event(event, more_data, cpu, timestamp, thread);
+	process_raw_event(event, data.raw_data, data.cpu, data.time, thread);
 
 	return 0;
 }
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index c0f29ed..f472df9 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -483,48 +483,22 @@ static void sched_switch(int cpu, u64 timestamp, struct trace_entry *te)
 static int
 process_sample_event(event_t *event)
 {
-	int cursor = 0;
-	u64 addr = 0;
-	u64 stamp = 0;
-	u32 cpu = 0;
-	u32 pid = 0;
-	u32 size, *size_ptr;
+	struct sample_data data;
 	struct trace_entry *te;
 
-	if (sample_type & PERF_SAMPLE_IP)
-		cursor++;
-
-	if (sample_type & PERF_SAMPLE_TID) {
-		pid = event->sample.array[cursor]>>32;
-		cursor++;
-	}
-	if (sample_type & PERF_SAMPLE_TIME) {
-		stamp = event->sample.array[cursor++];
+	memset(&data, 0, sizeof(data));
 
-		if (!first_time || first_time > stamp)
-			first_time = stamp;
-		if (last_time < stamp)
-			last_time = stamp;
+	event__parse_sample(event, sample_type, &data);
 
+	if (sample_type & PERF_SAMPLE_TIME) {
+		if (!first_time || first_time > data.time)
+			first_time = data.time;
+		if (last_time < data.time)
+			last_time = data.time;
 	}
-	if (sample_type & PERF_SAMPLE_ADDR)
-		addr = event->sample.array[cursor++];
-	if (sample_type & PERF_SAMPLE_ID)
-		cursor++;
-	if (sample_type & PERF_SAMPLE_STREAM_ID)
-		cursor++;
-	if (sample_type & PERF_SAMPLE_CPU)
-		cpu = event->sample.array[cursor++] & 0xFFFFFFFF;
-	if (sample_type & PERF_SAMPLE_PERIOD)
-		cursor++;
-
-	size_ptr = (void *)&event->sample.array[cursor];
-
-	size = *size_ptr;
-	size_ptr++;
 
-	te = (void *)size_ptr;
-	if (sample_type & PERF_SAMPLE_RAW && size > 0) {
+	te = (void *)data.raw_data;
+	if (sample_type & PERF_SAMPLE_RAW && data.raw_size > 0) {
 		char *event_str;
 		struct power_entry *pe;
 
@@ -536,19 +510,19 @@ process_sample_event(event_t *event)
 			return 0;
 
 		if (strcmp(event_str, "power:power_start") == 0)
-			c_state_start(cpu, stamp, pe->value);
+			c_state_start(data.cpu, data.time, pe->value);
 
 		if (strcmp(event_str, "power:power_end") == 0)
-			c_state_end(cpu, stamp);
+			c_state_end(data.cpu, data.time);
 
 		if (strcmp(event_str, "power:power_frequency") == 0)
-			p_state_change(cpu, stamp, pe->value);
+			p_state_change(data.cpu, data.time, pe->value);
 
 		if (strcmp(event_str, "sched:sched_wakeup") == 0)
-			sched_wakeup(cpu, stamp, pid, te);
+			sched_wakeup(data.cpu, data.time, data.pid, te);
 
 		if (strcmp(event_str, "sched:sched_switch") == 0)
-			sched_switch(cpu, stamp, te);
+			sched_switch(data.cpu, data.time, te);
 	}
 	return 0;
 }
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index abb914a..c2fcc34 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -66,58 +66,40 @@ static u64			sample_type;
 
 static int process_sample_event(event_t *event)
 {
-	u64 ip = event->ip.ip;
-	u64 timestamp = -1;
-	u32 cpu = -1;
-	u64 period = 1;
-	void *more_data = event->ip.__more_data;
-	struct thread *thread = threads__findnew(event->ip.pid);
-
-	if (sample_type & PERF_SAMPLE_TIME) {
-		timestamp = *(u64 *)more_data;
-		more_data += sizeof(u64);
-	}
+	struct sample_data data;
+	struct thread *thread;
 
-	if (sample_type & PERF_SAMPLE_CPU) {
-		cpu = *(u32 *)more_data;
-		more_data += sizeof(u32);
-		more_data += sizeof(u32); /* reserved */
-	}
+	memset(&data, 0, sizeof(data));
+	data.time = -1;
+	data.cpu = -1;
+	data.period = 1;
 
-	if (sample_type & PERF_SAMPLE_PERIOD) {
-		period = *(u64 *)more_data;
-		more_data += sizeof(u64);
-	}
+	event__parse_sample(event, sample_type, &data);
 
 	dump_printf("(IP, %d): %d/%d: %p period: %Ld\n",
 		event->header.misc,
-		event->ip.pid, event->ip.tid,
-		(void *)(long)ip,
-		(long long)period);
+		data.pid, data.tid,
+		(void *)(long)data.ip,
+		(long long)data.period);
 
+	thread = threads__findnew(event->ip.pid);
 	if (thread == NULL) {
 		pr_debug("problem processing %d event, skipping it.\n",
 			 event->header.type);
 		return -1;
 	}
 
-	dump_printf(" ... thread: %s:%d\n", thread->comm, thread->pid);
-
 	if (sample_type & PERF_SAMPLE_RAW) {
-		struct {
-			u32 size;
-			char data[0];
-		} *raw = more_data;
-
 		/*
 		 * FIXME: better resolve from pid from the struct trace_entry
 		 * field, although it should be the same than this perf
 		 * event pid
 		 */
-		scripting_ops->process_event(cpu, raw->data, raw->size,
-					     timestamp, thread->comm);
+		scripting_ops->process_event(data.cpu, data.raw_data,
+					     data.raw_size,
+					     data.time, thread->comm);
 	}
-	event__stats.total += period;
+	event__stats.total += data.period;
 
 	return 0;
 }
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 414b89d..4dcecaf 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -310,3 +310,70 @@ int event__preprocess_sample(const event_t *self, struct addr_location *al,
 			al->level == 'H' ? "[hypervisor]" : "<not found>");
 	return 0;
 }
+
+int event__parse_sample(event_t *event, u64 type, struct sample_data *data)
+{
+	u64 *array = event->sample.array;
+
+	if (type & PERF_SAMPLE_IP) {
+		data->ip = event->ip.ip;
+		array++;
+	}
+
+	if (type & PERF_SAMPLE_TID) {
+		u32 *p = (u32 *)array;
+		data->pid = p[0];
+		data->tid = p[1];
+		array++;
+	}
+
+	if (type & PERF_SAMPLE_TIME) {
+		data->time = *array;
+		array++;
+	}
+
+	if (type & PERF_SAMPLE_ADDR) {
+		data->addr = *array;
+		array++;
+	}
+
+	if (type & PERF_SAMPLE_ID) {
+		data->id = *array;
+		array++;
+	}
+
+	if (type & PERF_SAMPLE_STREAM_ID) {
+		data->stream_id = *array;
+		array++;
+	}
+
+	if (type & PERF_SAMPLE_CPU) {
+		u32 *p = (u32 *)array;
+		data->cpu = *p;
+		array++;
+	}
+
+	if (type & PERF_SAMPLE_PERIOD) {
+		data->period = *array;
+		array++;
+	}
+
+	if (type & PERF_SAMPLE_READ) {
+		pr_debug("PERF_SAMPLE_READ is unsuported for now\n");
+		return -1;
+	}
+
+	if (type & PERF_SAMPLE_CALLCHAIN) {
+		data->callchain = (struct ip_callchain *)array;
+		array += 1 + data->callchain->nr;
+	}
+
+	if (type & PERF_SAMPLE_RAW) {
+		u32 *p = (u32 *)array;
+		data->raw_size = *p;
+		p++;
+		data->raw_data = p;
+	}
+
+	return 0;
+}
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index a4cc810..c7a78ee 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -56,11 +56,25 @@ struct read_event {
 	u64 id;
 };
 
-struct sample_event{
+struct sample_event {
 	struct perf_event_header        header;
 	u64 array[];
 };
 
+struct sample_data {
+	u64 ip;
+	u32 pid, tid;
+	u64 time;
+	u64 addr;
+	u64 id;
+	u64 stream_id;
+	u32 cpu;
+	u64 period;
+	struct ip_callchain *callchain;
+	u32 raw_size;
+	void *raw_data;
+};
+
 #define BUILD_ID_SIZE 20
 
 struct build_id_event {
@@ -155,5 +169,6 @@ int event__process_task(event_t *self);
 struct addr_location;
 int event__preprocess_sample(const event_t *self, struct addr_location *al,
 			     symbol_filter_t filter);
+int event__parse_sample(event_t *event, u64 type, struct sample_data *data);
 
 #endif /* __PERF_RECORD_H */
