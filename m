Return-Path: <linux-kernel-owner+w=401wt.eu-S1754482AbZLMVva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482AbZLMVva (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 16:51:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754422AbZLMVuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 16:50:50 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:47498 "HELO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754409AbZLMVup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 16:50:45 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 4/6] perf session: Reduce the number of parms to perf_session__process_events
Date: Sun, 13 Dec 2009 19:50:27 -0200
Message-Id: <1260741029-4430-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1260741029-4430-1-git-send-email-acme@infradead.org>
References: <1260741029-4430-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

By having the cwd/cwdlen in the perf_session struct and full_paths in
perf_event_ops.

Now its just a matter of passing the ops.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c  |    3 +--
 tools/perf/builtin-kmem.c      |    3 +--
 tools/perf/builtin-report.c    |    6 ++----
 tools/perf/builtin-sched.c     |    3 +--
 tools/perf/builtin-timechart.c |    3 +--
 tools/perf/builtin-trace.c     |    3 +--
 tools/perf/util/data_map.c     |   32 ++++++++++++++++----------------
 tools/perf/util/event.c        |    8 +++-----
 tools/perf/util/session.c      |    4 ++++
 tools/perf/util/session.h      |    7 +++++--
 10 files changed, 35 insertions(+), 37 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 93d765a..a931b13 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -469,8 +469,7 @@ static int __cmd_annotate(void)
 	if (session == NULL)
 		return -ENOMEM;
 
-	ret = perf_session__process_events(session, &event_ops, 0,
-					   &event__cwdlen, &event__cwd);
+	ret = perf_session__process_events(session, &event_ops);
 	if (ret)
 		goto out_delete;
 
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 37a8499..237155f 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -372,8 +372,7 @@ static int read_events(void)
 	if (session == NULL)
 		return -ENOMEM;
 
-	err = perf_session__process_events(session, &event_ops, 0,
-					   &event__cwdlen, &event__cwd);
+	err = perf_session__process_events(session, &event_ops);
 	perf_session__delete(session);
 	return err;
 }
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 4b37ac4..26b9478 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -39,7 +39,6 @@ static struct strlist	*dso_list, *comm_list, *sym_list;
 
 static int		force;
 
-static int		full_paths;
 static int		show_nr_samples;
 
 static int		show_threads;
@@ -771,8 +770,7 @@ static int __cmd_report(void)
 	if (show_threads)
 		perf_read_values_init(&show_threads_values);
 
-	ret = perf_session__process_events(session, &event_ops, full_paths,
-					   &event__cwdlen, &event__cwd);
+	ret = perf_session__process_events(session, &event_ops);
 	if (ret)
 		goto out_delete;
 
@@ -877,7 +875,7 @@ static const struct option options[] = {
 		   "pretty printing style key: normal raw"),
 	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
 		   "sort by key(s): pid, comm, dso, symbol, parent"),
-	OPT_BOOLEAN('P', "full-paths", &full_paths,
+	OPT_BOOLEAN('P', "full-paths", &event_ops.full_paths,
 		    "Don't shorten the pathnames taking into account the cwd"),
 	OPT_STRING('p', "parent", &parent_pattern, "regex",
 		   "regex filter to identify parent, see: '--sort parent'"),
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 847ed51..1e4e508 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1670,8 +1670,7 @@ static int read_events(void)
 	if (session == NULL)
 		return -ENOMEM;
 
-	err = perf_session__process_events(session, &event_ops, 0,
-					   &event__cwdlen, &event__cwd);
+	err = perf_session__process_events(session, &event_ops);
 	perf_session__delete(session);
 	return err;
 }
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 4b95cec..b5211fa 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -1062,8 +1062,7 @@ static int __cmd_timechart(void)
 	if (session == NULL)
 		return -ENOMEM;
 
-	ret = perf_session__process_events(session, &event_ops, 0,
-					   &event__cwdlen, &event__cwd);
+	ret = perf_session__process_events(session, &event_ops);
 	if (ret)
 		goto out_delete;
 
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 40cb896..b7eb3fc 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -125,8 +125,7 @@ static struct perf_event_ops event_ops = {
 
 static int __cmd_trace(struct perf_session *session)
 {
-	return perf_session__process_events(session, &event_ops, 0,
-					    &event__cwdlen, &event__cwd);
+	return perf_session__process_events(session, &event_ops);
 }
 
 struct script_spec {
diff --git a/tools/perf/util/data_map.c b/tools/perf/util/data_map.c
index 36e3bfe..ba2eb2c 100644
--- a/tools/perf/util/data_map.c
+++ b/tools/perf/util/data_map.c
@@ -4,9 +4,6 @@
 #include "thread.h"
 #include "session.h"
 
-static unsigned long	mmap_window = 32;
-static char		__cwd[PATH_MAX];
-
 static int process_event_stub(event_t *event __used,
 			      struct perf_session *session __used)
 {
@@ -141,8 +138,7 @@ static struct thread *perf_session__register_idle_thread(struct perf_session *se
 }
 
 int perf_session__process_events(struct perf_session *self,
-				 struct perf_event_ops *ops,
-				 int full_paths, int *cwdlen, char **cwd)
+				 struct perf_event_ops *ops)
 {
 	int err;
 	unsigned long head, shift;
@@ -168,17 +164,21 @@ int perf_session__process_events(struct perf_session *self,
 	    ops->sample_type_check(sample_type) < 0)
 		goto out_err;
 
-	if (!full_paths) {
-		if (getcwd(__cwd, sizeof(__cwd)) == NULL) {
-			pr_err("failed to get the current directory\n");
+	if (!ops->full_paths) {
+		char bf[PATH_MAX];
+
+		if (getcwd(bf, sizeof(bf)) == NULL) {
 			err = -errno;
+out_getcwd_err:
+			pr_err("failed to get the current directory\n");
 			goto out_err;
 		}
-		*cwd = __cwd;
-		*cwdlen = strlen(*cwd);
-	} else {
-		*cwd = NULL;
-		*cwdlen = 0;
+		self->cwd = strdup(bf);
+		if (self->cwd == NULL) {
+			err = -ENOMEM;
+			goto out_getcwd_err;
+		}
+		self->cwdlen = strlen(self->cwd);
 	}
 
 	shift = page_size * (head / page_size);
@@ -186,7 +186,7 @@ int perf_session__process_events(struct perf_session *self,
 	head -= shift;
 
 remap:
-	buf = mmap(NULL, page_size * mmap_window, PROT_READ,
+	buf = mmap(NULL, page_size * self->mmap_window, PROT_READ,
 		   MAP_SHARED, self->fd, offset);
 	if (buf == MAP_FAILED) {
 		pr_err("failed to mmap file\n");
@@ -201,12 +201,12 @@ more:
 	if (!size)
 		size = 8;
 
-	if (head + event->header.size >= page_size * mmap_window) {
+	if (head + event->header.size >= page_size * self->mmap_window) {
 		int munmap_ret;
 
 		shift = page_size * (head / page_size);
 
-		munmap_ret = munmap(buf, page_size * mmap_window);
+		munmap_ret = munmap(buf, page_size * self->mmap_window);
 		assert(munmap_ret == 0);
 
 		offset += shift;
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index e2c4895..40d8d84 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -1,6 +1,7 @@
 #include <linux/types.h>
 #include "event.h"
 #include "debug.h"
+#include "session.h"
 #include "string.h"
 #include "thread.h"
 
@@ -186,9 +187,6 @@ void event__synthesize_threads(int (*process)(event_t *event,
 	closedir(proc);
 }
 
-char *event__cwd;
-int  event__cwdlen;
-
 struct events_stats event__stats;
 
 int event__process_comm(event_t *self, struct perf_session *session __used)
@@ -212,11 +210,11 @@ int event__process_lost(event_t *self, struct perf_session *session __used)
 	return 0;
 }
 
-int event__process_mmap(event_t *self, struct perf_session *session __used)
+int event__process_mmap(event_t *self, struct perf_session *session)
 {
 	struct thread *thread = threads__findnew(self->mmap.pid);
 	struct map *map = map__new(&self->mmap, MAP__FUNCTION,
-				   event__cwd, event__cwdlen);
+				   session->cwd, session->cwdlen);
 
 	dump_printf(" %d/%d: [%p(%p) @ %p]: %s\n",
 		    self->mmap.pid, self->mmap.tid,
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 3976686..534a877 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -61,6 +61,9 @@ struct perf_session *perf_session__new(const char *filename, int mode,
 		goto out_delete;
 
 	memcpy(self->filename, filename, len);
+	self->mmap_window = 32;
+	self->cwd = NULL;
+	self->cwdlen = 0;
 
 	if (mode == O_RDONLY && perf_session__open(self, force) < 0) {
 		perf_session__delete(self);
@@ -77,5 +80,6 @@ void perf_session__delete(struct perf_session *self)
 {
 	perf_header__exit(&self->header);
 	close(self->fd);
+	free(self->cwd);
 	free(self);
 }
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 7a4c32c..1e0da9c 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -7,7 +7,10 @@
 struct perf_session {
 	struct perf_header	header;
 	unsigned long		size;
+	unsigned long		mmap_window;
 	int			fd;
+	int			cwdlen;
+	char			*cwd;
 	char filename[0];
 };
 
@@ -25,6 +28,7 @@ struct perf_event_ops {
 	event_op	process_unthrottle_event;
 	int		(*sample_type_check)(u64 sample_type);
 	unsigned long	total_unknown;
+	bool		full_paths;
 };
 
 struct perf_session *perf_session__new(const char *filename, int mode,
@@ -32,8 +36,7 @@ struct perf_session *perf_session__new(const char *filename, int mode,
 void perf_session__delete(struct perf_session *self);
 
 int perf_session__process_events(struct perf_session *self,
-				 struct perf_event_ops *event_ops,
-				 int full_paths, int *cwdlen, char **cwd);
+				 struct perf_event_ops *event_ops);
 
 int perf_header__read_build_ids(int input, u64 offset, u64 file_size);
 
-- 
1.6.2.5

