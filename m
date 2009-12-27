Return-Path: <linux-kernel-owner+w=401wt.eu-S1751416AbZL0XiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751416AbZL0XiX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 18:38:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751168AbZL0XhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 18:37:23 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56322 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbZL0XhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 18:37:20 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 06/10] perf session: Remove sample_type_check from event_ops
Date: Sun, 27 Dec 2009 21:37:02 -0200
Message-Id: <1261957026-15580-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1261957026-15580-1-git-send-email-acme@infradead.org>
References: <1261957026-15580-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

This is really something tools need to do before asking for the events
to be processed, leaving perf_session__process_events to do just that,
process events.

Also add a msg parameter to perf_session__has_traces() so that the right
message can be printed, fixing a regression added by me in the previous
cset (right timechart message) and also fixing 'perf kmem', that was not
asking if 'perf kmem record' was ran.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kmem.c      |    6 ++++--
 tools/perf/builtin-report.c    |   16 +++++++++-------
 tools/perf/builtin-sched.c     |    7 ++++---
 tools/perf/builtin-timechart.c |    6 ++++--
 tools/perf/builtin-trace.c     |    4 +++-
 tools/perf/util/session.c      |   16 ++++++----------
 tools/perf/util/session.h      |    3 +--
 7 files changed, 31 insertions(+), 27 deletions(-)

diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index a85936f..73b0650 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -345,7 +345,6 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 static struct perf_event_ops event_ops = {
 	.process_sample_event	= process_sample_event,
 	.process_comm_event	= event__process_comm,
-	.sample_type_check	= perf_session__has_traces,
 };
 
 static double fragmentation(unsigned long n_req, unsigned long n_alloc)
@@ -492,11 +491,14 @@ static void sort_result(void)
 
 static int __cmd_kmem(void)
 {
-	int err;
+	int err = -EINVAL;
 	struct perf_session *session = perf_session__new(input_name, O_RDONLY, 0);
 	if (session == NULL)
 		return -ENOMEM;
 
+	if (!perf_session__has_traces(session, "kmem record"))
+		goto out_delete;
+
 	setup_pager();
 	err = perf_session__process_events(session, &event_ops);
 	if (err != 0)
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index db10c0e..0825918 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -156,14 +156,14 @@ static int process_read_event(event_t *event, struct perf_session *session __use
 	return 0;
 }
 
-static int sample_type_check(struct perf_session *session)
+static int perf_session__setup_sample_type(struct perf_session *self)
 {
-	if (!(session->sample_type & PERF_SAMPLE_CALLCHAIN)) {
+	if (!(self->sample_type & PERF_SAMPLE_CALLCHAIN)) {
 		if (sort__has_parent) {
 			fprintf(stderr, "selected --sort parent, but no"
 					" callchain data. Did you call"
 					" perf record without -g?\n");
-			return -1;
+			return -EINVAL;
 		}
 		if (symbol_conf.use_callchain) {
 			fprintf(stderr, "selected -g but no callchain data."
@@ -176,7 +176,7 @@ static int sample_type_check(struct perf_session *session)
 			if (register_callchain_param(&callchain_param) < 0) {
 				fprintf(stderr, "Can't register callchain"
 						" params\n");
-				return -1;
+				return -EINVAL;
 			}
 	}
 
@@ -191,13 +191,11 @@ static struct perf_event_ops event_ops = {
 	.process_fork_event	= event__process_task,
 	.process_lost_event	= event__process_lost,
 	.process_read_event	= process_read_event,
-	.sample_type_check	= sample_type_check,
 };
 
-
 static int __cmd_report(void)
 {
-	int ret;
+	int ret = -EINVAL;
 	struct perf_session *session;
 
 	session = perf_session__new(input_name, O_RDONLY, force);
@@ -207,6 +205,10 @@ static int __cmd_report(void)
 	if (show_threads)
 		perf_read_values_init(&show_threads_values);
 
+	ret = perf_session__setup_sample_type(session);
+	if (ret)
+		goto out_delete;
+
 	ret = perf_session__process_events(session, &event_ops);
 	if (ret)
 		goto out_delete;
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index d65098c..e862e71 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1657,17 +1657,18 @@ static struct perf_event_ops event_ops = {
 	.process_sample_event	= process_sample_event,
 	.process_comm_event	= event__process_comm,
 	.process_lost_event	= process_lost_event,
-	.sample_type_check	= perf_session__has_traces,
 };
 
 static int read_events(void)
 {
-	int err;
+	int err = -EINVAL;
 	struct perf_session *session = perf_session__new(input_name, O_RDONLY, 0);
 	if (session == NULL)
 		return -ENOMEM;
 
-	err = perf_session__process_events(session, &event_ops);
+	if (perf_session__has_traces(session, "record -R"))
+		err = perf_session__process_events(session, &event_ops);
+
 	perf_session__delete(session);
 	return err;
 }
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index b42f337..8252837 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -1034,17 +1034,19 @@ static struct perf_event_ops event_ops = {
 	.process_fork_event	= process_fork_event,
 	.process_exit_event	= process_exit_event,
 	.process_sample_event	= queue_sample_event,
-	.sample_type_check	= perf_session__has_traces,
 };
 
 static int __cmd_timechart(void)
 {
 	struct perf_session *session = perf_session__new(input_name, O_RDONLY, 0);
-	int ret;
+	int ret = -EINVAL;
 
 	if (session == NULL)
 		return -ENOMEM;
 
+	if (!perf_session__has_traces(session, "timechart record"))
+		goto out_delete;
+
 	ret = perf_session__process_events(session, &event_ops);
 	if (ret)
 		goto out_delete;
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index b0ba2ac..e94f346 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -106,7 +106,6 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 static struct perf_event_ops event_ops = {
 	.process_sample_event	= process_sample_event,
 	.process_comm_event	= event__process_comm,
-	.sample_type_check	= perf_session__has_traces,
 };
 
 static int __cmd_trace(struct perf_session *session)
@@ -580,6 +579,9 @@ int cmd_trace(int argc, const char **argv, const char *prefix __used)
 	if (session == NULL)
 		return -ENOMEM;
 
+	if (!perf_session__has_traces(session, "record -R"))
+		return -EINVAL;
+
 	if (generate_script_lang) {
 		struct stat perf_stat;
 
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 60eab8b..bc84a52 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -73,6 +73,8 @@ struct perf_session *perf_session__new(const char *filename, int mode, bool forc
 
 	if (mode == O_RDONLY && perf_session__open(self, force) < 0)
 		goto out_delete;
+
+	self->sample_type = perf_header__sample_type(&self->header);
 out:
 	return self;
 out_free:
@@ -302,11 +304,6 @@ int perf_session__process_events(struct perf_session *self,
 	page_size = getpagesize();
 
 	head = self->header.data_offset;
-	self->sample_type = perf_header__sample_type(&self->header);
-
-	err = -EINVAL;
-	if (ops->sample_type_check && ops->sample_type_check(self) < 0)
-		goto out_err;
 
 	if (!ops->full_paths) {
 		char bf[PATH_MAX];
@@ -394,13 +391,12 @@ out_err:
 	return err;
 }
 
-int perf_session__has_traces(struct perf_session *self)
+bool perf_session__has_traces(struct perf_session *self, const char *msg)
 {
 	if (!(self->sample_type & PERF_SAMPLE_RAW)) {
-		pr_err("No trace sample to read. Did you call perf record "
-		       "without -R?");
-		return -1;
+		pr_err("No trace sample to read. Did you call 'perf %s'?\n", msg);
+		return false;
 	}
 
-	return 0;
+	return true;
 }
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index a6951d2..5771ccb 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -40,7 +40,6 @@ struct perf_event_ops {
 	event_op	process_read_event;
 	event_op	process_throttle_event;
 	event_op	process_unthrottle_event;
-	int		(*sample_type_check)(struct perf_session *session);
 	unsigned long	total_unknown;
 	bool		full_paths;
 };
@@ -56,7 +55,7 @@ struct symbol **perf_session__resolve_callchain(struct perf_session *self,
 						struct ip_callchain *chain,
 						struct symbol **parent);
 
-int perf_session__has_traces(struct perf_session *self);
+bool perf_session__has_traces(struct perf_session *self, const char *msg);
 
 int perf_header__read_build_ids(int input, u64 offset, u64 file_size);
 
-- 
1.6.2.5

