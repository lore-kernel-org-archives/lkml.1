Return-Path: <linux-kernel-owner+w=401wt.eu-S1751395AbZL0Xha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751395AbZL0Xha (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 18:37:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751297AbZL0XhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 18:37:25 -0500
Received: from casper.infradead.org ([85.118.1.10]:40956 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbZL0XhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 18:37:20 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 05/10] perf session: Share the common trace sample_check routine as perf_session__has_traces
Date: Sun, 27 Dec 2009 21:37:01 -0200
Message-Id: <1261957026-15580-5-git-send-email-acme@infradead.org>
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

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kmem.c      |   14 +-------------
 tools/perf/builtin-sched.c     |   14 +-------------
 tools/perf/builtin-timechart.c |   13 +------------
 tools/perf/builtin-trace.c     |   14 +-------------
 tools/perf/util/session.c      |   11 +++++++++++
 tools/perf/util/session.h      |    2 ++
 6 files changed, 17 insertions(+), 51 deletions(-)

diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index fc21ad7..a85936f 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -342,22 +342,10 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 	return 0;
 }
 
-static int sample_type_check(struct perf_session *session)
-{
-	if (!(session->sample_type & PERF_SAMPLE_RAW)) {
-		fprintf(stderr,
-			"No trace sample to read. Did you call perf record "
-			"without -R?");
-		return -1;
-	}
-
-	return 0;
-}
-
 static struct perf_event_ops event_ops = {
 	.process_sample_event	= process_sample_event,
 	.process_comm_event	= event__process_comm,
-	.sample_type_check	= sample_type_check,
+	.sample_type_check	= perf_session__has_traces,
 };
 
 static double fragmentation(unsigned long n_req, unsigned long n_alloc)
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 80209df..d65098c 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1653,23 +1653,11 @@ static int process_lost_event(event_t *event __used,
 	return 0;
 }
 
-static int sample_type_check(struct perf_session *session __used)
-{
-	if (!(session->sample_type & PERF_SAMPLE_RAW)) {
-		fprintf(stderr,
-			"No trace sample to read. Did you call perf record "
-			"without -R?");
-		return -1;
-	}
-
-	return 0;
-}
-
 static struct perf_event_ops event_ops = {
 	.process_sample_event	= process_sample_event,
 	.process_comm_event	= event__process_comm,
 	.process_lost_event	= process_lost_event,
-	.sample_type_check	= sample_type_check,
+	.sample_type_check	= perf_session__has_traces,
 };
 
 static int read_events(void)
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index a589a43..b42f337 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -1029,23 +1029,12 @@ static void process_samples(struct perf_session *session)
 	}
 }
 
-static int sample_type_check(struct perf_session *session)
-{
-	if (!(session->sample_type & PERF_SAMPLE_RAW)) {
-		fprintf(stderr, "No trace samples found in the file.\n"
-				"Have you used 'perf timechart record' to record it?\n");
-		return -1;
-	}
-
-	return 0;
-}
-
 static struct perf_event_ops event_ops = {
 	.process_comm_event	= process_comm_event,
 	.process_fork_event	= process_fork_event,
 	.process_exit_event	= process_exit_event,
 	.process_sample_event	= queue_sample_event,
-	.sample_type_check	= sample_type_check,
+	.sample_type_check	= perf_session__has_traces,
 };
 
 static int __cmd_timechart(void)
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 574a215..b0ba2ac 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -103,22 +103,10 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 	return 0;
 }
 
-static int sample_type_check(struct perf_session *session)
-{
-	if (!(session->sample_type & PERF_SAMPLE_RAW)) {
-		fprintf(stderr,
-			"No trace sample to read. Did you call perf record "
-			"without -R?");
-		return -1;
-	}
-
-	return 0;
-}
-
 static struct perf_event_ops event_ops = {
 	.process_sample_event	= process_sample_event,
 	.process_comm_event	= event__process_comm,
-	.sample_type_check	= sample_type_check,
+	.sample_type_check	= perf_session__has_traces,
 };
 
 static int __cmd_trace(struct perf_session *session)
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 736d4fd..60eab8b 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -393,3 +393,14 @@ done:
 out_err:
 	return err;
 }
+
+int perf_session__has_traces(struct perf_session *self)
+{
+	if (!(self->sample_type & PERF_SAMPLE_RAW)) {
+		pr_err("No trace sample to read. Did you call perf record "
+		       "without -R?");
+		return -1;
+	}
+
+	return 0;
+}
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 32eaa1b..a6951d2 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -56,6 +56,8 @@ struct symbol **perf_session__resolve_callchain(struct perf_session *self,
 						struct ip_callchain *chain,
 						struct symbol **parent);
 
+int perf_session__has_traces(struct perf_session *self);
+
 int perf_header__read_build_ids(int input, u64 offset, u64 file_size);
 
 #endif /* __PERF_SESSION_H */
-- 
1.6.2.5

