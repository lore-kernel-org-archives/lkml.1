Return-Path: <linux-kernel-owner+w=401wt.eu-S1751502AbZL0Xix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502AbZL0Xix (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 18:38:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468AbZL0Xir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 18:38:47 -0500
Received: from casper.infradead.org ([85.118.1.10]:40957 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbZL0XhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 18:37:20 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 03/10] perf session: Move the event processing routines to session.c
Date: Sun, 27 Dec 2009 21:36:59 -0200
Message-Id: <1261957026-15580-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1261957026-15580-1-git-send-email-acme@infradead.org>
References: <1261957026-15580-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

No need for an extra "data_map" file since the routines there operate
mainly on a perf_session instance.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile        |    1 -
 tools/perf/util/data_map.c |  252 --------------------------------------------
 tools/perf/util/session.c  |  245 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 245 insertions(+), 253 deletions(-)
 delete mode 100644 tools/perf/util/data_map.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 652a470..4172c3b 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -423,7 +423,6 @@ LIB_OBJS += util/trace-event-perl.o
 LIB_OBJS += util/svghelper.o
 LIB_OBJS += util/sort.o
 LIB_OBJS += util/hist.o
-LIB_OBJS += util/data_map.o
 LIB_OBJS += util/probe-event.o
 
 BUILTIN_OBJS += builtin-annotate.o
diff --git a/tools/perf/util/data_map.c b/tools/perf/util/data_map.c
deleted file mode 100644
index b557b83..0000000
--- a/tools/perf/util/data_map.c
+++ /dev/null
@@ -1,252 +0,0 @@
-#include "symbol.h"
-#include "util.h"
-#include "debug.h"
-#include "thread.h"
-#include "session.h"
-
-static int process_event_stub(event_t *event __used,
-			      struct perf_session *session __used)
-{
-	dump_printf(": unhandled!\n");
-	return 0;
-}
-
-static void perf_event_ops__fill_defaults(struct perf_event_ops *handler)
-{
-	if (!handler->process_sample_event)
-		handler->process_sample_event = process_event_stub;
-	if (!handler->process_mmap_event)
-		handler->process_mmap_event = process_event_stub;
-	if (!handler->process_comm_event)
-		handler->process_comm_event = process_event_stub;
-	if (!handler->process_fork_event)
-		handler->process_fork_event = process_event_stub;
-	if (!handler->process_exit_event)
-		handler->process_exit_event = process_event_stub;
-	if (!handler->process_lost_event)
-		handler->process_lost_event = process_event_stub;
-	if (!handler->process_read_event)
-		handler->process_read_event = process_event_stub;
-	if (!handler->process_throttle_event)
-		handler->process_throttle_event = process_event_stub;
-	if (!handler->process_unthrottle_event)
-		handler->process_unthrottle_event = process_event_stub;
-}
-
-static const char *event__name[] = {
-	[0]			 = "TOTAL",
-	[PERF_RECORD_MMAP]	 = "MMAP",
-	[PERF_RECORD_LOST]	 = "LOST",
-	[PERF_RECORD_COMM]	 = "COMM",
-	[PERF_RECORD_EXIT]	 = "EXIT",
-	[PERF_RECORD_THROTTLE]	 = "THROTTLE",
-	[PERF_RECORD_UNTHROTTLE] = "UNTHROTTLE",
-	[PERF_RECORD_FORK]	 = "FORK",
-	[PERF_RECORD_READ]	 = "READ",
-	[PERF_RECORD_SAMPLE]	 = "SAMPLE",
-};
-
-unsigned long event__total[PERF_RECORD_MAX];
-
-void event__print_totals(void)
-{
-	int i;
-	for (i = 0; i < PERF_RECORD_MAX; ++i)
-		pr_info("%10s events: %10ld\n",
-			event__name[i], event__total[i]);
-}
-
-static int process_event(event_t *event, struct perf_session *session,
-			 struct perf_event_ops *ops,
-			 unsigned long offset, unsigned long head)
-{
-	trace_event(event);
-
-	if (event->header.type < PERF_RECORD_MAX) {
-		dump_printf("%p [%p]: PERF_RECORD_%s",
-			    (void *)(offset + head),
-			    (void *)(long)(event->header.size),
-			    event__name[event->header.type]);
-		++event__total[0];
-		++event__total[event->header.type];
-	}
-
-	switch (event->header.type) {
-	case PERF_RECORD_SAMPLE:
-		return ops->process_sample_event(event, session);
-	case PERF_RECORD_MMAP:
-		return ops->process_mmap_event(event, session);
-	case PERF_RECORD_COMM:
-		return ops->process_comm_event(event, session);
-	case PERF_RECORD_FORK:
-		return ops->process_fork_event(event, session);
-	case PERF_RECORD_EXIT:
-		return ops->process_exit_event(event, session);
-	case PERF_RECORD_LOST:
-		return ops->process_lost_event(event, session);
-	case PERF_RECORD_READ:
-		return ops->process_read_event(event, session);
-	case PERF_RECORD_THROTTLE:
-		return ops->process_throttle_event(event, session);
-	case PERF_RECORD_UNTHROTTLE:
-		return ops->process_unthrottle_event(event, session);
-	default:
-		ops->total_unknown++;
-		return -1;
-	}
-}
-
-int perf_header__read_build_ids(int input, u64 offset, u64 size)
-{
-	struct build_id_event bev;
-	char filename[PATH_MAX];
-	u64 limit = offset + size;
-	int err = -1;
-
-	while (offset < limit) {
-		struct dso *dso;
-		ssize_t len;
-
-		if (read(input, &bev, sizeof(bev)) != sizeof(bev))
-			goto out;
-
-		len = bev.header.size - sizeof(bev);
-		if (read(input, filename, len) != len)
-			goto out;
-
-		dso = dsos__findnew(filename);
-		if (dso != NULL)
-			dso__set_build_id(dso, &bev.build_id);
-
-		offset += bev.header.size;
-	}
-	err = 0;
-out:
-	return err;
-}
-
-static struct thread *perf_session__register_idle_thread(struct perf_session *self)
-{
-	struct thread *thread = perf_session__findnew(self, 0);
-
-	if (!thread || thread__set_comm(thread, "swapper")) {
-		pr_err("problem inserting idle task.\n");
-		thread = NULL;
-	}
-
-	return thread;
-}
-
-int perf_session__process_events(struct perf_session *self,
-				 struct perf_event_ops *ops)
-{
-	int err;
-	unsigned long head, shift;
-	unsigned long offset = 0;
-	size_t	page_size;
-	event_t *event;
-	uint32_t size;
-	char *buf;
-
-	if (perf_session__register_idle_thread(self) == NULL)
-		return -ENOMEM;
-
-	perf_event_ops__fill_defaults(ops);
-
-	page_size = getpagesize();
-
-	head = self->header.data_offset;
-	self->sample_type = perf_header__sample_type(&self->header);
-
-	err = -EINVAL;
-	if (ops->sample_type_check && ops->sample_type_check(self) < 0)
-		goto out_err;
-
-	if (!ops->full_paths) {
-		char bf[PATH_MAX];
-
-		if (getcwd(bf, sizeof(bf)) == NULL) {
-			err = -errno;
-out_getcwd_err:
-			pr_err("failed to get the current directory\n");
-			goto out_err;
-		}
-		self->cwd = strdup(bf);
-		if (self->cwd == NULL) {
-			err = -ENOMEM;
-			goto out_getcwd_err;
-		}
-		self->cwdlen = strlen(self->cwd);
-	}
-
-	shift = page_size * (head / page_size);
-	offset += shift;
-	head -= shift;
-
-remap:
-	buf = mmap(NULL, page_size * self->mmap_window, PROT_READ,
-		   MAP_SHARED, self->fd, offset);
-	if (buf == MAP_FAILED) {
-		pr_err("failed to mmap file\n");
-		err = -errno;
-		goto out_err;
-	}
-
-more:
-	event = (event_t *)(buf + head);
-
-	size = event->header.size;
-	if (!size)
-		size = 8;
-
-	if (head + event->header.size >= page_size * self->mmap_window) {
-		int munmap_ret;
-
-		shift = page_size * (head / page_size);
-
-		munmap_ret = munmap(buf, page_size * self->mmap_window);
-		assert(munmap_ret == 0);
-
-		offset += shift;
-		head -= shift;
-		goto remap;
-	}
-
-	size = event->header.size;
-
-	dump_printf("\n%p [%p]: event: %d\n",
-			(void *)(offset + head),
-			(void *)(long)event->header.size,
-			event->header.type);
-
-	if (!size || process_event(event, self, ops, offset, head) < 0) {
-
-		dump_printf("%p [%p]: skipping unknown header type: %d\n",
-			(void *)(offset + head),
-			(void *)(long)(event->header.size),
-			event->header.type);
-
-		/*
-		 * assume we lost track of the stream, check alignment, and
-		 * increment a single u64 in the hope to catch on again 'soon'.
-		 */
-
-		if (unlikely(head & 7))
-			head &= ~7ULL;
-
-		size = 8;
-	}
-
-	head += size;
-
-	if (offset + head >= self->header.data_offset + self->header.data_size)
-		goto done;
-
-	if (offset + head < self->size)
-		goto more;
-
-done:
-	err = 0;
-out_err:
-	return err;
-}
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index ce3a6c8..736d4fd 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -148,3 +148,248 @@ struct symbol **perf_session__resolve_callchain(struct perf_session *self,
 
 	return syms;
 }
+
+static int process_event_stub(event_t *event __used,
+			      struct perf_session *session __used)
+{
+	dump_printf(": unhandled!\n");
+	return 0;
+}
+
+static void perf_event_ops__fill_defaults(struct perf_event_ops *handler)
+{
+	if (handler->process_sample_event == NULL)
+		handler->process_sample_event = process_event_stub;
+	if (handler->process_mmap_event == NULL)
+		handler->process_mmap_event = process_event_stub;
+	if (handler->process_comm_event == NULL)
+		handler->process_comm_event = process_event_stub;
+	if (handler->process_fork_event == NULL)
+		handler->process_fork_event = process_event_stub;
+	if (handler->process_exit_event == NULL)
+		handler->process_exit_event = process_event_stub;
+	if (handler->process_lost_event == NULL)
+		handler->process_lost_event = process_event_stub;
+	if (handler->process_read_event == NULL)
+		handler->process_read_event = process_event_stub;
+	if (handler->process_throttle_event == NULL)
+		handler->process_throttle_event = process_event_stub;
+	if (handler->process_unthrottle_event == NULL)
+		handler->process_unthrottle_event = process_event_stub;
+}
+
+static const char *event__name[] = {
+	[0]			 = "TOTAL",
+	[PERF_RECORD_MMAP]	 = "MMAP",
+	[PERF_RECORD_LOST]	 = "LOST",
+	[PERF_RECORD_COMM]	 = "COMM",
+	[PERF_RECORD_EXIT]	 = "EXIT",
+	[PERF_RECORD_THROTTLE]	 = "THROTTLE",
+	[PERF_RECORD_UNTHROTTLE] = "UNTHROTTLE",
+	[PERF_RECORD_FORK]	 = "FORK",
+	[PERF_RECORD_READ]	 = "READ",
+	[PERF_RECORD_SAMPLE]	 = "SAMPLE",
+};
+
+unsigned long event__total[PERF_RECORD_MAX];
+
+void event__print_totals(void)
+{
+	int i;
+	for (i = 0; i < PERF_RECORD_MAX; ++i)
+		pr_info("%10s events: %10ld\n",
+			event__name[i], event__total[i]);
+}
+
+static int perf_session__process_event(struct perf_session *self,
+				       event_t *event,
+				       struct perf_event_ops *ops,
+				       unsigned long offset, unsigned long head)
+{
+	trace_event(event);
+
+	if (event->header.type < PERF_RECORD_MAX) {
+		dump_printf("%p [%p]: PERF_RECORD_%s",
+			    (void *)(offset + head),
+			    (void *)(long)(event->header.size),
+			    event__name[event->header.type]);
+		++event__total[0];
+		++event__total[event->header.type];
+	}
+
+	switch (event->header.type) {
+	case PERF_RECORD_SAMPLE:
+		return ops->process_sample_event(event, self);
+	case PERF_RECORD_MMAP:
+		return ops->process_mmap_event(event, self);
+	case PERF_RECORD_COMM:
+		return ops->process_comm_event(event, self);
+	case PERF_RECORD_FORK:
+		return ops->process_fork_event(event, self);
+	case PERF_RECORD_EXIT:
+		return ops->process_exit_event(event, self);
+	case PERF_RECORD_LOST:
+		return ops->process_lost_event(event, self);
+	case PERF_RECORD_READ:
+		return ops->process_read_event(event, self);
+	case PERF_RECORD_THROTTLE:
+		return ops->process_throttle_event(event, self);
+	case PERF_RECORD_UNTHROTTLE:
+		return ops->process_unthrottle_event(event, self);
+	default:
+		ops->total_unknown++;
+		return -1;
+	}
+}
+
+int perf_header__read_build_ids(int input, u64 offset, u64 size)
+{
+	struct build_id_event bev;
+	char filename[PATH_MAX];
+	u64 limit = offset + size;
+	int err = -1;
+
+	while (offset < limit) {
+		struct dso *dso;
+		ssize_t len;
+
+		if (read(input, &bev, sizeof(bev)) != sizeof(bev))
+			goto out;
+
+		len = bev.header.size - sizeof(bev);
+		if (read(input, filename, len) != len)
+			goto out;
+
+		dso = dsos__findnew(filename);
+		if (dso != NULL)
+			dso__set_build_id(dso, &bev.build_id);
+
+		offset += bev.header.size;
+	}
+	err = 0;
+out:
+	return err;
+}
+
+static struct thread *perf_session__register_idle_thread(struct perf_session *self)
+{
+	struct thread *thread = perf_session__findnew(self, 0);
+
+	if (thread == NULL || thread__set_comm(thread, "swapper")) {
+		pr_err("problem inserting idle task.\n");
+		thread = NULL;
+	}
+
+	return thread;
+}
+
+int perf_session__process_events(struct perf_session *self,
+				 struct perf_event_ops *ops)
+{
+	int err;
+	unsigned long head, shift;
+	unsigned long offset = 0;
+	size_t	page_size;
+	event_t *event;
+	uint32_t size;
+	char *buf;
+
+	if (perf_session__register_idle_thread(self) == NULL)
+		return -ENOMEM;
+
+	perf_event_ops__fill_defaults(ops);
+
+	page_size = getpagesize();
+
+	head = self->header.data_offset;
+	self->sample_type = perf_header__sample_type(&self->header);
+
+	err = -EINVAL;
+	if (ops->sample_type_check && ops->sample_type_check(self) < 0)
+		goto out_err;
+
+	if (!ops->full_paths) {
+		char bf[PATH_MAX];
+
+		if (getcwd(bf, sizeof(bf)) == NULL) {
+			err = -errno;
+out_getcwd_err:
+			pr_err("failed to get the current directory\n");
+			goto out_err;
+		}
+		self->cwd = strdup(bf);
+		if (self->cwd == NULL) {
+			err = -ENOMEM;
+			goto out_getcwd_err;
+		}
+		self->cwdlen = strlen(self->cwd);
+	}
+
+	shift = page_size * (head / page_size);
+	offset += shift;
+	head -= shift;
+
+remap:
+	buf = mmap(NULL, page_size * self->mmap_window, PROT_READ,
+		   MAP_SHARED, self->fd, offset);
+	if (buf == MAP_FAILED) {
+		pr_err("failed to mmap file\n");
+		err = -errno;
+		goto out_err;
+	}
+
+more:
+	event = (event_t *)(buf + head);
+
+	size = event->header.size;
+	if (size == 0)
+		size = 8;
+
+	if (head + event->header.size >= page_size * self->mmap_window) {
+		int munmap_ret;
+
+		shift = page_size * (head / page_size);
+
+		munmap_ret = munmap(buf, page_size * self->mmap_window);
+		assert(munmap_ret == 0);
+
+		offset += shift;
+		head -= shift;
+		goto remap;
+	}
+
+	size = event->header.size;
+
+	dump_printf("\n%p [%p]: event: %d\n",
+			(void *)(offset + head),
+			(void *)(long)event->header.size,
+			event->header.type);
+
+	if (size == 0 ||
+	    perf_session__process_event(self, event, ops, offset, head) < 0) {
+		dump_printf("%p [%p]: skipping unknown header type: %d\n",
+			    (void *)(offset + head),
+			    (void *)(long)(event->header.size),
+			    event->header.type);
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
+	if (offset + head >= self->header.data_offset + self->header.data_size)
+		goto done;
+
+	if (offset + head < self->size)
+		goto more;
+done:
+	err = 0;
+out_err:
+	return err;
+}
-- 
1.6.2.5

