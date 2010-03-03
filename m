Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231Ab0CCHHA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 02:07:00 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:58581 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754977Ab0CCHFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 02:05:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=dj7xWEUPCyW3XDaICbtQvsDFTms5ZZ0I2u9VuVaGrdSwM5gl3usla6exdERwTWJLt8
         Joy84PdwvfNDKsnHV4H6sOK4XYlB2k4/8Rw7wqab2+YQqSY5eA4VxRYrrJycQ11Nfxhh
         y3do8EVMCZ4gZHv4ISq8F+Yffnwg1zT4lxlyc=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, rostedt@goodmis.org,
       k-keiichi@bx.jp.nec.com
Subject: [RFC PATCH 2/7] perf: add pipe-specific header read/write and event processing code
Date: Wed,  3 Mar 2010 01:05:24 -0600
Message-Id: <1267599929-8310-3-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
In-Reply-To: <1267599929-8310-1-git-send-email-tzanussi@gmail.com>
References: <1267599929-8310-1-git-send-email-tzanussi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes several changes to allow the perf event stream to be
sent and received over a pipe:

- adds pipe-specific versions of the header read/write code

- adds pipe-specific version of the event processing code

- adds a range of event types to be used for header or other pseudo
  events, above the range used by the kernel

- adds code to interpret return values >0 from event processing
  functions as 'actions'.  The first action defined is for stopping
  the event-processing loop at the first non-header event.  So
  initially there's still a restriction that header events come first
  in the event stream.

Note that none of this affects the existing perf data file format or
processing - this code only comes into play if perf output is sent to
stdout (or is read from stdin).

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
---
 tools/perf/builtin-record.c |    8 ++-
 tools/perf/builtin-report.c |   10 +++
 tools/perf/builtin-trace.c  |   11 +++
 tools/perf/util/event.h     |    4 +
 tools/perf/util/header.c    |   62 ++++++++++++++++++-
 tools/perf/util/header.h    |    8 ++-
 tools/perf/util/session.c   |  145 +++++++++++++++++++++++++++++++++++++++---
 tools/perf/util/session.h   |   16 +++++
 8 files changed, 249 insertions(+), 15 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 4fe87e3..b676689 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -475,7 +475,7 @@ static int __cmd_record(int argc, const char **argv)
 	}
 
 	if (!file_new) {
-		err = perf_header__read(&session->header, output);
+		err = perf_header__read(session, output);
 		if (err < 0)
 			return err;
 	}
@@ -554,7 +554,11 @@ static int __cmd_record(int argc, const char **argv)
 			open_counters(i, target_pid);
 	}
 
-	if (file_new) {
+	if (pipe_output) {
+		err = perf_header__write_pipe(&session->header, output);
+		if (err < 0)
+			return err;
+	} else if (file_new) {
 		err = perf_header__write(&session->header, output, false);
 		if (err < 0)
 			return err;
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index ca12efa..603f705 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -193,11 +193,21 @@ static struct perf_event_ops event_ops = {
 	.read	= process_read_event,
 };
 
+extern volatile int done;
+
+static void sig_handler(int sig __attribute__((__unused__)))
+{
+	done = 1;
+}
+
 static int __cmd_report(void)
 {
 	int ret = -EINVAL;
 	struct perf_session *session;
 
+	signal(SIGCHLD, sig_handler);
+	signal(SIGINT, sig_handler);
+
 	session = perf_session__new(input_name, O_RDONLY, force);
 	if (session == NULL)
 		return -ENOMEM;
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 407041d..2a56dda 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -106,8 +106,18 @@ static struct perf_event_ops event_ops = {
 	.comm	= event__process_comm,
 };
 
+extern volatile int done;
+
+static void sig_handler(int sig __unused)
+{
+	done = 1;
+}
+
 static int __cmd_trace(struct perf_session *session)
 {
+	signal(SIGCHLD, sig_handler);
+	signal(SIGINT, sig_handler);
+
 	return perf_session__process_events(session, &event_ops);
 }
 
@@ -609,6 +619,7 @@ int cmd_trace(int argc, const char **argv, const char *prefix __used)
 			return -1;
 		}
 
+		perf_header__read(session, input);
 		err = scripting_ops->generate_script("perf-trace");
 		goto out;
 	}
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 50a7132..cec3067 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -83,6 +83,10 @@ struct build_id_event {
 	char			 filename[];
 };
 
+enum perf_header_event_type { /* above any possible kernel type */
+	PERF_RECORD_HEADER_MAX			= 64,
+};
+
 typedef union event_union {
 	struct perf_event_header	header;
 	struct ip_event			ip;
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 6c9aa16..75b8a4c 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -427,6 +427,26 @@ out_free:
 	return err;
 }
 
+int perf_header__write_pipe(struct perf_header *self, int fd)
+{
+	struct perf_file_header_pipe f_header;
+	int err;
+
+	f_header = (struct perf_file_header_pipe){
+		.magic	   = PERF_MAGIC,
+		.size	   = sizeof(f_header),
+	};
+
+	err = do_write(fd, &f_header, sizeof(f_header));
+	if (err < 0) {
+		pr_debug("failed to write perf pipe header\n");
+		return err;
+	}
+
+	self->frozen = 1;
+	return 0;
+}
+
 int perf_header__write(struct perf_header *self, int fd, bool at_exit)
 {
 	struct perf_file_header f_header;
@@ -662,13 +682,53 @@ static int perf_file_section__process(struct perf_file_section *self,
 	return 0;
 }
 
-int perf_header__read(struct perf_header *self, int fd)
+static int perf_file_header__read_pipe(struct perf_file_header_pipe *self,
+				       struct perf_header *ph, int fd)
+{
+	if (do_read(fd, self, sizeof(*self)) ||
+	    memcmp(&self->magic, __perf_magic, sizeof(self->magic)))
+		return -1;
+
+	if (self->size != sizeof(*self)) {
+		u64 size = bswap_64(self->size);
+
+		if (size != sizeof(*self))
+			return -1;
+
+		ph->needs_swap = true;
+	}
+
+	return 0;
+}
+
+static int perf_header__read_pipe(struct perf_session *session, int fd)
 {
+	struct perf_header *self = &session->header;
+	struct perf_file_header_pipe f_header;
+	struct perf_event_ops header_ops;
+
+	if (perf_file_header__read_pipe(&f_header, self, fd) < 0) {
+		pr_debug("incompatible file format\n");
+		return -EINVAL;
+	}
+
+	perf_event_ops__fill_stop(&header_ops);
+	session->fd = fd;
+
+	return perf_session__process_events(session, &header_ops);
+}
+
+int perf_header__read(struct perf_session *session, int fd)
+{
+	struct perf_header *self = &session->header;
 	struct perf_file_header	f_header;
 	struct perf_file_attr	f_attr;
 	u64			f_id;
 	int nr_attrs, nr_ids, i, j;
 
+	if (session->fd_pipe)
+		return perf_header__read_pipe(session, fd);
+
 	if (perf_file_header__read(&f_header, self, fd) < 0) {
 		pr_debug("incompatible file format\n");
 		return -EINVAL;
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 82a6af7..714b1d5 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -39,6 +39,11 @@ struct perf_file_header {
 	DECLARE_BITMAP(adds_features, HEADER_FEAT_BITS);
 };
 
+struct perf_file_header_pipe {
+	u64				magic;
+	u64				size;
+};
+
 struct perf_header;
 
 int perf_file_header__read(struct perf_file_header *self,
@@ -60,8 +65,9 @@ struct perf_header {
 int perf_header__init(struct perf_header *self);
 void perf_header__exit(struct perf_header *self);
 
-int perf_header__read(struct perf_header *self, int fd);
+int perf_header__read(struct perf_session *session, int fd);
 int perf_header__write(struct perf_header *self, int fd, bool at_exit);
+int perf_header__write_pipe(struct perf_header *self, int fd);
 
 int perf_header__add_attr(struct perf_header *self,
 			  struct perf_header_attr *attr);
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index dd1e923..3a3db33 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -18,7 +18,7 @@ static int perf_session__open(struct perf_session *self, bool force)
 		self->fd_pipe = true;
 		self->fd = STDIN_FILENO;
 
-		if (perf_header__read(&self->header, self->fd) < 0)
+		if (perf_header__read(self, self->fd) < 0)
 			pr_err("incompatible file format");
 
 		return 0;
@@ -48,12 +48,13 @@ static int perf_session__open(struct perf_session *self, bool force)
 		goto out_close;
 	}
 
-	if (perf_header__read(&self->header, self->fd) < 0) {
+	self->size = input_stat.st_size;
+
+	if (perf_header__read(self, self->fd) < 0) {
 		pr_err("incompatible file format");
 		goto out_close;
 	}
 
-	self->size = input_stat.st_size;
 	return 0;
 
 out_close:
@@ -67,6 +68,11 @@ static inline int perf_session__create_kernel_maps(struct perf_session *self)
 	return map_groups__create_kernel_maps(&self->kmaps, self->vmlinux_maps);
 }
 
+void perf_session__update_sample_type(struct perf_session *self)
+{
+	self->sample_type = perf_header__sample_type(&self->header);
+}
+
 struct perf_session *perf_session__new(const char *filename, int mode, bool force)
 {
 	size_t len = filename ? strlen(filename) + 1 : 0;
@@ -99,7 +105,7 @@ struct perf_session *perf_session__new(const char *filename, int mode, bool forc
 			goto out_delete;
 	}
 
-	self->sample_type = perf_header__sample_type(&self->header);
+	perf_session__update_sample_type(self);
 out:
 	return self;
 out_free:
@@ -205,6 +211,26 @@ static void perf_event_ops__fill_defaults(struct perf_event_ops *handler)
 		handler->unthrottle = process_event_stub;
 }
 
+static int process_event_stop(event_t *event __used,
+			      struct perf_session *session __used)
+{
+	dump_printf(": stop!\n");
+	return PERF_PROCESS_EVENT_STOP;
+}
+
+void perf_event_ops__fill_stop(struct perf_event_ops *handler)
+{
+	handler->sample = process_event_stop;
+	handler->mmap = process_event_stop;
+	handler->comm = process_event_stop;
+	handler->fork = process_event_stop;
+	handler->exit = process_event_stop;
+	handler->lost = process_event_stop;
+	handler->read = process_event_stop;
+	handler->throttle = process_event_stop;
+	handler->unthrottle = process_event_stop;
+}
+
 static const char *event__name[] = {
 	[0]			 = "TOTAL",
 	[PERF_RECORD_MMAP]	 = "MMAP",
@@ -218,14 +244,17 @@ static const char *event__name[] = {
 	[PERF_RECORD_SAMPLE]	 = "SAMPLE",
 };
 
-unsigned long event__total[PERF_RECORD_MAX];
+unsigned long event__total[PERF_RECORD_HEADER_MAX];
 
 void event__print_totals(void)
 {
 	int i;
-	for (i = 0; i < PERF_RECORD_MAX; ++i)
+	for (i = 0; i < PERF_RECORD_HEADER_MAX; ++i) {
+		if (!event__name[i])
+			continue;
 		pr_info("%10s events: %10ld\n",
 			event__name[i], event__total[i]);
+	}
 }
 
 void mem_bswap_64(void *src, int byte_size)
@@ -289,7 +318,7 @@ static event__swap_op event__swap_ops[] = {
 	[PERF_RECORD_LOST]   = event__all64_swap,
 	[PERF_RECORD_READ]   = event__read_swap,
 	[PERF_RECORD_SAMPLE] = event__all64_swap,
-	[PERF_RECORD_MAX]    = NULL,
+	[PERF_RECORD_HEADER_MAX]    = NULL,
 };
 
 static int perf_session__process_event(struct perf_session *self,
@@ -299,7 +328,7 @@ static int perf_session__process_event(struct perf_session *self,
 {
 	trace_event(event);
 
-	if (event->header.type < PERF_RECORD_MAX) {
+	if (event->header.type < PERF_RECORD_HEADER_MAX) {
 		dump_printf("%#Lx [%#x]: PERF_RECORD_%s",
 			    offset + head, event->header.size,
 			    event__name[event->header.type]);
@@ -394,6 +423,96 @@ static struct thread *perf_session__register_idle_thread(struct perf_session *se
 	return thread;
 }
 
+static int do_read(int fd, void *buf, size_t size)
+{
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
+	return 0;
+}
+
+#define is_done()	(*(volatile int *)(&done))
+volatile int done;
+
+static int __perf_session__process_events_pipe(struct perf_session *self,
+					       struct perf_event_ops *ops)
+{
+	int action = 0;
+	event_t event;
+	uint32_t size;
+	u64 head;
+	int err;
+	void *p;
+
+	perf_event_ops__fill_defaults(ops);
+
+	head = 0;
+more:
+	err = do_read(self->fd, &event, sizeof(struct perf_event_header));
+	if (err) {
+		pr_err("failed to read event header\n");
+		goto out_err;
+	}
+
+	if (self->header.needs_swap)
+		perf_event_header__bswap(&event.header);
+
+	size = event.header.size;
+	if (size == 0)
+		size = 8;
+
+	p = &event;
+	p += sizeof(struct perf_event_header);
+
+	err = do_read(self->fd, p, size - sizeof(struct perf_event_header));
+	if (err) {
+		pr_err("failed to read event payload\n");
+		goto out_err;
+	}
+
+	if (size == 0 ||
+	    (action = perf_session__process_event(self, &event, ops,
+						  0, head)) < 0) {
+		dump_printf("%#Lx [%#x]: skipping unknown header type: %d\n",
+			    head, event.header.size, event.header.type);
+		/*
+		 * assume we lost track of the stream, check alignment, and
+		 * increment a single u64 in the hope to catch on again 'soon'.
+		 */
+		if (unlikely(head & 7))
+			head &= ~7ULL;
+
+		size = 8;
+	}
+
+	head += size;
+
+	dump_printf("\n%#Lx [%#x]: event: %d\n",
+		    head, event.header.size, event.header.type);
+
+	if (action == PERF_PROCESS_EVENT_STOP) {
+		self->header.data_offset = head;
+		goto done;
+	}
+
+	if (action >= PERF_PROCESS_EVENT_MAX)
+		head += action;
+
+	if (!is_done())
+		goto more;
+done:
+	err = 0;
+out_err:
+	return err;
+}
+
 int __perf_session__process_events(struct perf_session *self,
 				   u64 data_offset, u64 data_size,
 				   u64 file_size, struct perf_event_ops *ops)
@@ -511,9 +630,13 @@ out_getcwd_err:
 		self->cwdlen = strlen(self->cwd);
 	}
 
-	err = __perf_session__process_events(self, self->header.data_offset,
-					     self->header.data_size,
-					     self->size, ops);
+	if (!self->fd_pipe)
+		err = __perf_session__process_events(self,
+						     self->header.data_offset,
+						     self->header.data_size,
+						     self->size, ops);
+	else
+		err = __perf_session__process_events_pipe(self, ops);
 out_err:
 	return err;
 }
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index dbfb74a..ab1fcbf 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -46,6 +46,18 @@ struct perf_event_ops {
 		 unthrottle;
 };
 
+/*
+ * interpret process_event return values as actions.
+ * PERF_PROCESS_EVENT_MAX or greater is interpreted as 'skip ahead
+ * that many bytes'.  Since that can never be less than
+ * sizeof(perf_event_header), 1 through sizeof(perf_event_header) can
+ * be interpreted as 'actions'.
+*/
+enum perf_process_event_action {
+	PERF_PROCESS_EVENT_STOP			= 1,
+	PERF_PROCESS_EVENT_MAX
+};
+
 struct perf_session *perf_session__new(const char *filename, int mode, bool force);
 void perf_session__delete(struct perf_session *self);
 
@@ -86,4 +98,8 @@ static inline struct map *
 {
 	return map_groups__new_module(&self->kmaps, start, filename);
 }
+
+void perf_session__update_sample_type(struct perf_session *self);
+void perf_event_ops__fill_stop(struct perf_event_ops *handler);
+
 #endif /* __PERF_SESSION_H */
-- 
1.6.4.GIT

