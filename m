Return-Path: <linux-kernel-owner+w=401wt.eu-S1757808AbZLNQXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757808AbZLNQXY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 11:23:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757764AbZLNQXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 11:23:13 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:43701 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757749AbZLNQXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 11:23:11 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 2/2] perf session: Adopt the sample_type variable
Date: Mon, 14 Dec 2009 14:23:00 -0200
Message-Id: <1260807780-19377-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1260807780-19377-1-git-send-email-acme@infradead.org>
References: <1260807780-19377-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

All tools had copies, and perf diff would have to specify a
sample_type_check method just for copying it.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kmem.c      |   10 +++-------
 tools/perf/builtin-report.c    |   12 ++++--------
 tools/perf/builtin-sched.c     |   12 ++++--------
 tools/perf/builtin-timechart.c |   36 +++++++++++++++---------------------
 tools/perf/builtin-trace.c     |   12 ++++--------
 tools/perf/util/data_map.c     |    6 ++----
 tools/perf/util/session.h      |    4 ++--
 7 files changed, 34 insertions(+), 58 deletions(-)

diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 3b329c6..dda6086 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -20,8 +20,6 @@ typedef int (*sort_fn_t)(struct alloc_stat *, struct alloc_stat *);
 
 static char const		*input_name = "perf.data";
 
-static u64			sample_type;
-
 static int			alloc_flag;
 static int			caller_flag;
 
@@ -321,7 +319,7 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 	data.cpu = -1;
 	data.period = 1;
 
-	event__parse_sample(event, sample_type, &data);
+	event__parse_sample(event, session->sample_type, &data);
 
 	dump_printf("(IP, %d): %d/%d: %p period: %Ld\n",
 		event->header.misc,
@@ -344,11 +342,9 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 	return 0;
 }
 
-static int sample_type_check(u64 type, struct perf_session *session __used)
+static int sample_type_check(struct perf_session *session)
 {
-	sample_type = type;
-
-	if (!(sample_type & PERF_SAMPLE_RAW)) {
+	if (!(session->sample_type & PERF_SAMPLE_RAW)) {
 		fprintf(stderr,
 			"No trace sample to read. Did you call perf record "
 			"without -R?");
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 5141cdc..142c475 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -52,8 +52,6 @@ static int		exclude_other = 1;
 
 static char		callchain_default_opt[] = "fractal,0.5";
 
-static u64		sample_type;
-
 struct symbol_conf	symbol_conf;
 
 
@@ -557,7 +555,7 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 	memset(&data, 0, sizeof(data));
 	data.period = 1;
 
-	event__parse_sample(event, sample_type, &data);
+	event__parse_sample(event, session->sample_type, &data);
 
 	dump_printf("(IP, %d): %d/%d: %p period: %Ld\n",
 		event->header.misc,
@@ -565,7 +563,7 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 		(void *)(long)data.ip,
 		(long long)data.period);
 
-	if (sample_type & PERF_SAMPLE_CALLCHAIN) {
+	if (session->sample_type & PERF_SAMPLE_CALLCHAIN) {
 		unsigned int i;
 
 		dump_printf("... chain: nr:%Lu\n", data.callchain->nr);
@@ -664,11 +662,9 @@ static int process_read_event(event_t *event, struct perf_session *session __use
 	return 0;
 }
 
-static int sample_type_check(u64 type, struct perf_session *session)
+static int sample_type_check(struct perf_session *session)
 {
-	sample_type = type;
-
-	if (!(sample_type & PERF_SAMPLE_CALLCHAIN)) {
+	if (!(session->sample_type & PERF_SAMPLE_CALLCHAIN)) {
 		if (sort__has_parent) {
 			fprintf(stderr, "selected --sort parent, but no"
 					" callchain data. Did you call"
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 412ae92..d67f274 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -21,8 +21,6 @@
 
 static char			const *input_name = "perf.data";
 
-static u64			sample_type;
-
 static char			default_sort_order[] = "avg, max, switch, runtime";
 static char			*sort_order = default_sort_order;
 
@@ -1613,7 +1611,7 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 	struct sample_data data;
 	struct thread *thread;
 
-	if (!(sample_type & PERF_SAMPLE_RAW))
+	if (!(session->sample_type & PERF_SAMPLE_RAW))
 		return 0;
 
 	memset(&data, 0, sizeof(data));
@@ -1621,7 +1619,7 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 	data.cpu = -1;
 	data.period = -1;
 
-	event__parse_sample(event, sample_type, &data);
+	event__parse_sample(event, session->sample_type, &data);
 
 	dump_printf("(IP, %d): %d/%d: %p period: %Ld\n",
 		event->header.misc,
@@ -1655,11 +1653,9 @@ static int process_lost_event(event_t *event __used,
 	return 0;
 }
 
-static int sample_type_check(u64 type, struct perf_session *session __used)
+static int sample_type_check(struct perf_session *session __used)
 {
-	sample_type = type;
-
-	if (!(sample_type & PERF_SAMPLE_RAW)) {
+	if (!(session->sample_type & PERF_SAMPLE_RAW)) {
 		fprintf(stderr,
 			"No trace sample to read. Did you call perf record "
 			"without -R?");
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 3a0a89e..ffd81e8 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -36,9 +36,6 @@
 static char		const *input_name = "perf.data";
 static char		const *output_name = "output.svg";
 
-
-static u64		sample_type;
-
 static unsigned int	numcpus;
 static u64		min_freq;	/* Lowest CPU frequency seen */
 static u64		max_freq;	/* Highest CPU frequency seen */
@@ -478,17 +475,16 @@ static void sched_switch(int cpu, u64 timestamp, struct trace_entry *te)
 }
 
 
-static int
-process_sample_event(event_t *event)
+static int process_sample_event(event_t *event, struct perf_session *session)
 {
 	struct sample_data data;
 	struct trace_entry *te;
 
 	memset(&data, 0, sizeof(data));
 
-	event__parse_sample(event, sample_type, &data);
+	event__parse_sample(event, session->sample_type, &data);
 
-	if (sample_type & PERF_SAMPLE_TIME) {
+	if (session->sample_type & PERF_SAMPLE_TIME) {
 		if (!first_time || first_time > data.time)
 			first_time = data.time;
 		if (last_time < data.time)
@@ -496,7 +492,7 @@ process_sample_event(event_t *event)
 	}
 
 	te = (void *)data.raw_data;
-	if (sample_type & PERF_SAMPLE_RAW && data.raw_size > 0) {
+	if (session->sample_type & PERF_SAMPLE_RAW && data.raw_size > 0) {
 		char *event_str;
 		struct power_entry *pe;
 
@@ -573,16 +569,16 @@ static void end_sample_processing(void)
 	}
 }
 
-static u64 sample_time(event_t *event)
+static u64 sample_time(event_t *event, const struct perf_session *session)
 {
 	int cursor;
 
 	cursor = 0;
-	if (sample_type & PERF_SAMPLE_IP)
+	if (session->sample_type & PERF_SAMPLE_IP)
 		cursor++;
-	if (sample_type & PERF_SAMPLE_TID)
+	if (session->sample_type & PERF_SAMPLE_TID)
 		cursor++;
-	if (sample_type & PERF_SAMPLE_TIME)
+	if (session->sample_type & PERF_SAMPLE_TIME)
 		return event->sample.array[cursor];
 	return 0;
 }
@@ -592,7 +588,7 @@ static u64 sample_time(event_t *event)
  * We first queue all events, sorted backwards by insertion.
  * The order will get flipped later.
  */
-static int queue_sample_event(event_t *event, struct perf_session *session __used)
+static int queue_sample_event(event_t *event, struct perf_session *session)
 {
 	struct sample_wrapper *copy, *prev;
 	int size;
@@ -606,7 +602,7 @@ static int queue_sample_event(event_t *event, struct perf_session *session __use
 	memset(copy, 0, size);
 
 	copy->next = NULL;
-	copy->timestamp = sample_time(event);
+	copy->timestamp = sample_time(event, session);
 
 	memcpy(&copy->data, event, event->sample.header.size);
 
@@ -1018,7 +1014,7 @@ static void write_svg_file(const char *filename)
 	svg_close();
 }
 
-static void process_samples(void)
+static void process_samples(struct perf_session *session)
 {
 	struct sample_wrapper *cursor;
 	event_t *event;
@@ -1029,15 +1025,13 @@ static void process_samples(void)
 	while (cursor) {
 		event = (void *)&cursor->data;
 		cursor = cursor->next;
-		process_sample_event(event);
+		process_sample_event(event, session);
 	}
 }
 
-static int sample_type_check(u64 type, struct perf_session *session __used)
+static int sample_type_check(struct perf_session *session)
 {
-	sample_type = type;
-
-	if (!(sample_type & PERF_SAMPLE_RAW)) {
+	if (!(session->sample_type & PERF_SAMPLE_RAW)) {
 		fprintf(stderr, "No trace samples found in the file.\n"
 				"Have you used 'perf timechart record' to record it?\n");
 		return -1;
@@ -1067,7 +1061,7 @@ static int __cmd_timechart(void)
 	if (ret)
 		goto out_delete;
 
-	process_samples();
+	process_samples(session);
 
 	end_sample_processing();
 
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index adce442..9ee976d 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -61,8 +61,6 @@ static int cleanup_scripting(void)
 
 static char const		*input_name = "perf.data";
 
-static u64			sample_type;
-
 static int process_sample_event(event_t *event, struct perf_session *session)
 {
 	struct sample_data data;
@@ -73,7 +71,7 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 	data.cpu = -1;
 	data.period = 1;
 
-	event__parse_sample(event, sample_type, &data);
+	event__parse_sample(event, session->sample_type, &data);
 
 	dump_printf("(IP, %d): %d/%d: %p period: %Ld\n",
 		event->header.misc,
@@ -88,7 +86,7 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 		return -1;
 	}
 
-	if (sample_type & PERF_SAMPLE_RAW) {
+	if (session->sample_type & PERF_SAMPLE_RAW) {
 		/*
 		 * FIXME: better resolve from pid from the struct trace_entry
 		 * field, although it should be the same than this perf
@@ -103,11 +101,9 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 	return 0;
 }
 
-static int sample_type_check(u64 type, struct perf_session *session __used)
+static int sample_type_check(struct perf_session *session)
 {
-	sample_type = type;
-
-	if (!(sample_type & PERF_SAMPLE_RAW)) {
+	if (!(session->sample_type & PERF_SAMPLE_RAW)) {
 		fprintf(stderr,
 			"No trace sample to read. Did you call perf record "
 			"without -R?");
diff --git a/tools/perf/util/data_map.c b/tools/perf/util/data_map.c
index 08c4cf5..b557b83 100644
--- a/tools/perf/util/data_map.c
+++ b/tools/perf/util/data_map.c
@@ -144,7 +144,6 @@ int perf_session__process_events(struct perf_session *self,
 	unsigned long head, shift;
 	unsigned long offset = 0;
 	size_t	page_size;
-	u64 sample_type;
 	event_t *event;
 	uint32_t size;
 	char *buf;
@@ -157,11 +156,10 @@ int perf_session__process_events(struct perf_session *self,
 	page_size = getpagesize();
 
 	head = self->header.data_offset;
-	sample_type = perf_header__sample_type(&self->header);
+	self->sample_type = perf_header__sample_type(&self->header);
 
 	err = -EINVAL;
-	if (ops->sample_type_check &&
-	    ops->sample_type_check(sample_type, self) < 0)
+	if (ops->sample_type_check && ops->sample_type_check(self) < 0)
 		goto out_err;
 
 	if (!ops->full_paths) {
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index a8f3a49..4e8a21c 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -19,6 +19,7 @@ struct perf_session {
 	struct rb_root		threads;
 	struct thread		*last_match;
 	struct rb_root		hists;
+	u64			sample_type;
 	int			fd;
 	int			cwdlen;
 	char			*cwd;
@@ -39,8 +40,7 @@ struct perf_event_ops {
 	event_op	process_read_event;
 	event_op	process_throttle_event;
 	event_op	process_unthrottle_event;
-	int		(*sample_type_check)(u64 sample_type,
-					     struct perf_session *session);
+	int		(*sample_type_check)(struct perf_session *session);
 	unsigned long	total_unknown;
 	bool		full_paths;
 };
-- 
1.6.2.5

