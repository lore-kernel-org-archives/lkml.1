Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320Ab0CCHGj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 02:06:39 -0500
Received: from mail-yw0-f197.google.com ([209.85.211.197]:42230 "EHLO
	mail-yw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755086Ab0CCHFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 02:05:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=PI75Ln731eObppjlIQGxw8Uxb9xSecE3jigUAD7EtLDi0BYUT7x+EGhdHhyQ123KIx
         W+Bhs05cgB4mAdTDabFAA0zfCQuPvfeC4HucnH4PrMKCJdtlFQ2D3M8Gb6ow5LFcQhkQ
         n5qd8ytKYVCFAL8x2aAlYBV8R0d+a/H92fbgI=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, rostedt@goodmis.org,
       k-keiichi@bx.jp.nec.com
Subject: [RFC PATCH 5/7] perf: convert perf tracing data into a tracing_data event
Date: Wed,  3 Mar 2010 01:05:27 -0600
Message-Id: <1267599929-8310-6-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
In-Reply-To: <1267599929-8310-1-git-send-email-tzanussi@gmail.com>
References: <1267599929-8310-1-git-send-email-tzanussi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bypasses the tracing_data perf header code and replaces it with a
synthesized event and processing function that accomplishes the same
thing, used when reading/writing perf data to/from a pipe.

The tracing data is pretty large, and this patch doesn't attempt to
break it down into component events.  The tracing_data event itself
doesn't actually contain the tracing data, rather it arranges for the
event processing code to skip over it after it's read, using the
'action' added in a previous patch; in this case the action is 'skip'.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
---
 tools/perf/builtin-record.c        |   16 ++++++
 tools/perf/util/event.h            |    7 +++
 tools/perf/util/header.c           |   53 +++++++++++++++++++++
 tools/perf/util/header.h           |    6 ++
 tools/perf/util/session.c          |   14 ++++++
 tools/perf/util/session.h          |    3 +-
 tools/perf/util/trace-event-info.c |   24 ++++++++++
 tools/perf/util/trace-event-read.c |   89 ++++++++++++++++++------------------
 tools/perf/util/trace-event.h      |    4 +-
 9 files changed, 170 insertions(+), 46 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 0e3d4cd..95bccdc 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -101,6 +101,11 @@ static void mmap_write_tail(struct mmap_data *md, unsigned long tail)
 	pc->data_tail = tail;
 }
 
+static void advance_output(size_t size)
+{
+	bytes_written += size;
+}
+
 static void write_output(void *buf, size_t size)
 {
 	while (size) {
@@ -581,6 +586,17 @@ static int __cmd_record(int argc, const char **argv)
 			pr_err("Couldn't synthesize event_types.\n");
 			return err;
 		}
+
+		err = event__synthesize_tracing_data(output, attrs,
+						     nr_counters,
+						     process_synthesized_event,
+						     session);
+		if (err <= 0) {
+			pr_err("Couldn't record tracing data.\n");
+			return err;
+		}
+
+		advance_output(err);
 	}
 
 	err = event__synthesize_kernel_mmap(process_synthesized_event,
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index dc6d27b..c111358 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -86,6 +86,7 @@ struct build_id_event {
 enum perf_header_event_type { /* above any possible kernel type */
 	PERF_RECORD_HEADER_ATTR			= 64,
 	PERF_RECORD_HEADER_EVENT_TYPE		= 65,
+	PERF_RECORD_HEADER_TRACING_DATA		= 66,
 	PERF_RECORD_HEADER_MAX
 };
 
@@ -107,6 +108,11 @@ struct event_type_event {
 	struct perf_trace_event_type event_type;
 };
 
+struct tracing_data_event {
+	struct perf_event_header header;
+	u32 size;
+};
+
 typedef union event_union {
 	struct perf_event_header	header;
 	struct ip_event			ip;
@@ -118,6 +124,7 @@ typedef union event_union {
 	struct sample_event		sample;
 	struct attr_event		attr;
 	struct event_type_event		event_type;
+	struct tracing_data_event	tracing_data;
 } event_t;
 
 struct events_stats {
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index cb75e66..5910aee 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -708,6 +708,7 @@ static int perf_header__read_pipe(struct perf_session *session, int fd)
 	perf_event_ops__fill_stop(&header_ops);
 	header_ops.attr = event__process_attr;
 	header_ops.event_type = event__process_event_type;
+	header_ops.tracing_data = event__process_tracing_data;
 	session->fd = fd;
 
 	return perf_session__process_events(session, &header_ops);
@@ -954,3 +955,55 @@ int event__process_event_type(event_t *self,
 
 	return 0;
 }
+
+int event__synthesize_tracing_data(int fd, struct perf_event_attr *pattrs,
+				   int nb_events,
+				   event__handler_t process,
+				   struct perf_session *session __unused)
+{
+	event_t ev;
+	ssize_t size = 0, aligned_size = 0, padding;
+	int err = 0;
+
+	memset(&ev, 0, sizeof(ev));
+
+	ev.tracing_data.header.type = PERF_RECORD_HEADER_TRACING_DATA;
+	size = read_tracing_data_size(fd, pattrs, nb_events);
+	if (size <= 0)
+		return size;
+	aligned_size = ALIGN(size, sizeof(u64));
+	padding = aligned_size - size;
+	ev.tracing_data.header.size = sizeof(ev.tracing_data);
+	ev.tracing_data.size = aligned_size;
+
+	process(&ev, session);
+
+	err = read_tracing_data(fd, pattrs, nb_events);
+	write_padded(fd, NULL, 0, padding);
+
+	return aligned_size;
+}
+
+int event__process_tracing_data(event_t *self,
+				struct perf_session *session)
+{
+	ssize_t size_read, padding, size = self->tracing_data.size;
+	off_t offset = lseek(session->fd, 0, SEEK_CUR);
+	char buf[BUFSIZ];
+
+	/* setup for reading amidst mmap */
+	lseek(session->fd, offset + sizeof(struct tracing_data_event),
+	      SEEK_SET);
+
+	size_read = trace_report(session->fd);
+
+	padding = ALIGN(size_read, sizeof(u64)) - size_read;
+
+	if (read(session->fd, buf, padding) < 0)
+		die("reading input file");
+
+	if (size_read + padding != size)
+		die("tracing data size mismatch");
+
+	return size_read + padding;
+}
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 9d18c9b..a83f375 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -111,5 +111,11 @@ int event__synthesize_event_types(event__handler_t process,
 int event__process_event_type(event_t *self,
 			      struct perf_session *session);
 
+int event__synthesize_tracing_data(int fd, struct perf_event_attr *pattrs,
+				   int nb_events,
+				   event__handler_t process,
+				   struct perf_session *session);
+int event__process_tracing_data(event_t *self,
+				struct perf_session *session);
 
 #endif /* __PERF_HEADER_H */
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index d704bdf..74e9646 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -213,6 +213,8 @@ static void perf_event_ops__fill_defaults(struct perf_event_ops *handler)
 		handler->attr = process_event_stub;
 	if (handler->event_type == NULL)
 		handler->event_type = process_event_stub;
+	if (handler->tracing_data == NULL)
+		handler->tracing_data = process_event_stub;
 }
 
 static int process_event_stop(event_t *event __used,
@@ -235,6 +237,7 @@ void perf_event_ops__fill_stop(struct perf_event_ops *handler)
 	handler->unthrottle = process_event_stop;
 	handler->attr = process_event_stop;
 	handler->event_type = process_event_stop;
+	handler->tracing_data = process_event_stop;
 }
 
 static const char *event__name[] = {
@@ -250,6 +253,7 @@ static const char *event__name[] = {
 	[PERF_RECORD_SAMPLE]	 = "SAMPLE",
 	[PERF_RECORD_HEADER_ATTR]	 = "ATTR",
 	[PERF_RECORD_HEADER_EVENT_TYPE]	 = "EVENT_TYPE",
+	[PERF_RECORD_HEADER_TRACING_DATA]	 = "TRACING_DATA",
 };
 
 unsigned long event__total[PERF_RECORD_HEADER_MAX];
@@ -342,6 +346,11 @@ static void event__event_type_swap(event_t *self)
 		bswap_64(self->event_type.event_type.event_id);
 }
 
+static void event__tracing_data_swap(event_t *self)
+{
+	self->tracing_data.size = bswap_32(self->tracing_data.size);
+}
+
 typedef void (*event__swap_op)(event_t *self);
 
 static event__swap_op event__swap_ops[] = {
@@ -354,6 +363,7 @@ static event__swap_op event__swap_ops[] = {
 	[PERF_RECORD_SAMPLE] = event__all64_swap,
 	[PERF_RECORD_HEADER_ATTR]   = event__attr_swap,
 	[PERF_RECORD_HEADER_EVENT_TYPE]   = event__event_type_swap,
+	[PERF_RECORD_HEADER_TRACING_DATA]   = event__tracing_data_swap,
 	[PERF_RECORD_HEADER_MAX]    = NULL,
 };
 
@@ -398,6 +408,10 @@ static int perf_session__process_event(struct perf_session *self,
 		return ops->attr(event, self);
 	case PERF_RECORD_HEADER_EVENT_TYPE:
 		return ops->event_type(event, self);
+	case PERF_RECORD_HEADER_TRACING_DATA:
+		/* setup for reading amidst mmap */
+		lseek(self->fd, offset + head, SEEK_SET);
+		return ops->tracing_data(event, self);
 	default:
 		self->unknown_events++;
 		return -1;
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index ea9eb4a..a648af0 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -45,7 +45,8 @@ struct perf_event_ops {
 		 throttle,
 		 unthrottle,
 		 attr,
-		 event_type;
+		 event_type,
+		 tracing_data;
 };
 
 /*
diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index 5ea8973..30cd9b5 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -154,10 +154,17 @@ static void put_tracing_file(char *file)
 	free(file);
 }
 
+static ssize_t calc_data_size;
+
 static ssize_t write_or_die(const void *buf, size_t len)
 {
 	int ret;
 
+	if (calc_data_size) {
+		calc_data_size += len;
+		return len;
+	}
+
 	ret = write(output_fd, buf, len);
 	if (ret < 0)
 		die("writing to '%s'", output_file);
@@ -526,3 +533,20 @@ int read_tracing_data(int fd, struct perf_event_attr *pattrs, int nb_events)
 
 	return 0;
 }
+
+ssize_t read_tracing_data_size(int fd, struct perf_event_attr *pattrs,
+			       int nb_events)
+{
+	ssize_t size;
+	int err = 0;
+
+	calc_data_size = 1;
+	err = read_tracing_data(fd, pattrs, nb_events);
+	size = calc_data_size - 1;
+	calc_data_size = 0;
+
+	if (err < 0)
+		return err;
+
+	return size;
+}
diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
index 7cd1193..44889c9 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -50,14 +50,37 @@ static int long_size;
 
 static unsigned long	page_size;
 
+static ssize_t calc_data_size;
+
+static int do_read(int fd, void *buf, int size)
+{
+	int rsize = size;
+
+	while (size) {
+		int ret = read(fd, buf, size);
+
+		if (ret <= 0)
+			return -1;
+
+		size -= ret;
+		buf += ret;
+	}
+
+	return rsize;
+}
+
 static int read_or_die(void *data, int size)
 {
 	int r;
 
-	r = read(input_fd, data, size);
-	if (r != size)
+	r = do_read(input_fd, data, size);
+	if (r <= 0)
 		die("reading input file (size expected=%d received=%d)",
 		    size, r);
+
+	if (calc_data_size)
+		calc_data_size += r;
+
 	return r;
 }
 
@@ -82,56 +105,28 @@ static char *read_string(void)
 	char buf[BUFSIZ];
 	char *str = NULL;
 	int size = 0;
-	int i;
 	off_t r;
+	char c;
 
 	for (;;) {
-		r = read(input_fd, buf, BUFSIZ);
+		r = read(input_fd, &c, 1);
 		if (r < 0)
 			die("reading input file");
 
 		if (!r)
 			die("no data");
 
-		for (i = 0; i < r; i++) {
-			if (!buf[i])
-				break;
-		}
-		if (i < r)
-			break;
+		buf[size++] = c;
 
-		if (str) {
-			size += BUFSIZ;
-			str = realloc(str, size);
-			if (!str)
-				die("malloc of size %d", size);
-			memcpy(str + (size - BUFSIZ), buf, BUFSIZ);
-		} else {
-			size = BUFSIZ;
-			str = malloc_or_die(size);
-			memcpy(str, buf, size);
-		}
+		if (!c)
+			break;
 	}
 
-	/* trailing \0: */
-	i++;
-
-	/* move the file descriptor to the end of the string */
-	r = lseek(input_fd, -(r - i), SEEK_CUR);
-	if (r == (off_t)-1)
-		die("lseek");
-
-	if (str) {
-		size += i;
-		str = realloc(str, size);
-		if (!str)
-			die("malloc of size %d", size);
-		memcpy(str + (size - i), buf, i);
-	} else {
-		size = i;
-		str = malloc_or_die(i);
-		memcpy(str, buf, i);
-	}
+	if (calc_data_size)
+		calc_data_size += size;
+
+	str = malloc_or_die(size);
+	memcpy(str, buf, size);
 
 	return str;
 }
@@ -459,7 +454,7 @@ struct record *trace_read_data(int cpu)
 	return data;
 }
 
-void trace_report(int fd)
+ssize_t trace_report(int fd)
 {
 	char buf[BUFSIZ];
 	char test[] = { 23, 8, 68 };
@@ -467,6 +462,9 @@ void trace_report(int fd)
 	int show_version = 0;
 	int show_funcs = 0;
 	int show_printk = 0;
+	ssize_t size;
+
+	calc_data_size = 1;
 
 	input_fd = fd;
 
@@ -499,14 +497,17 @@ void trace_report(int fd)
 	read_proc_kallsyms();
 	read_ftrace_printk();
 
+	size = calc_data_size - 1;
+	calc_data_size = 0;
+
 	if (show_funcs) {
 		print_funcs();
-		return;
+		return size;
 	}
 	if (show_printk) {
 		print_printk();
-		return;
+		return size;
 	}
 
-	return;
+	return size;
 }
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index c3269b9..0cb5866 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -162,7 +162,7 @@ struct record *trace_read_data(int cpu);
 
 void parse_set_info(int nr_cpus, int long_sz);
 
-void trace_report(int fd);
+ssize_t trace_report(int fd);
 
 void *malloc_or_die(unsigned int size);
 
@@ -258,6 +258,8 @@ void *raw_field_ptr(struct event *event, const char *name, void *data);
 unsigned long long eval_flag(const char *flag);
 
 int read_tracing_data(int fd, struct perf_event_attr *pattrs, int nb_events);
+ssize_t read_tracing_data_size(int fd, struct perf_event_attr *pattrs,
+			       int nb_events);
 
 /* taken from kernel/trace/trace.h */
 enum trace_flag_type {
-- 
1.6.4.GIT

