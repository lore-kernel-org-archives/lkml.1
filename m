Return-Path: <linux-kernel-owner+w=401wt.eu-S1758017AbZLNRGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758017AbZLNRGP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 12:06:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758005AbZLNRGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 12:06:13 -0500
Received: from casper.infradead.org ([85.118.1.10]:55864 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757986AbZLNRGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 12:06:11 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/1] perf session: event statistics also are per session
Date: Mon, 14 Dec 2009 15:06:01 -0200
Message-Id: <1260810361-22828-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
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
 tools/perf/builtin-annotate.c |    2 +-
 tools/perf/builtin-report.c   |    7 +++----
 tools/perf/builtin-trace.c    |    2 +-
 tools/perf/util/event.c       |    6 ++----
 tools/perf/util/event.h       |    5 -----
 tools/perf/util/session.h     |    3 +++
 6 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 1f1341f..fa833f5 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -487,7 +487,7 @@ static int __cmd_annotate(void)
 		dsos__fprintf(stdout);
 
 	perf_session__collapse_resort(session);
-	perf_session__output_resort(session, event__total[0]);
+	perf_session__output_resort(session, session->event_total[0]);
 	perf_session__find_annotations(session);
 out_delete:
 	perf_session__delete(session);
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 142c475..d12ea4a 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -619,8 +619,7 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 		return -1;
 	}
 
-	event__stats.total += data.period;
-
+	session->events_stats.total += data.period;
 	return 0;
 }
 
@@ -731,8 +730,8 @@ static int __cmd_report(void)
 		dsos__fprintf(stdout);
 
 	perf_session__collapse_resort(session);
-	perf_session__output_resort(session, event__stats.total);
-	perf_session__fprintf_hist_entries(session, event__stats.total, stdout);
+	perf_session__output_resort(session, session->events_stats.total);
+	perf_session__fprintf_hist_entries(session, session->events_stats.total, stdout);
 
 	if (show_threads)
 		perf_read_values_destroy(&show_threads_values);
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 9ee976d..07da665 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -96,8 +96,8 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 					     data.raw_size,
 					     data.time, thread->comm);
 	}
-	event__stats.total += data.period;
 
+	session->events_stats.total += data.period;
 	return 0;
 }
 
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 222efb1..375fb6d 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -187,8 +187,6 @@ void event__synthesize_threads(int (*process)(event_t *event,
 	closedir(proc);
 }
 
-struct events_stats event__stats;
-
 int event__process_comm(event_t *self, struct perf_session *session)
 {
 	struct thread *thread = perf_session__findnew(session, self->comm.pid);
@@ -203,10 +201,10 @@ int event__process_comm(event_t *self, struct perf_session *session)
 	return 0;
 }
 
-int event__process_lost(event_t *self, struct perf_session *session __used)
+int event__process_lost(event_t *self, struct perf_session *session)
 {
 	dump_printf(": id:%Ld: lost:%Ld\n", self->lost.id, self->lost.lost);
-	event__stats.lost += self->lost.lost;
+	session->events_stats.lost += self->lost.lost;
 	return 0;
 }
 
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 035ecf3..a92e0b0 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -168,11 +168,6 @@ void event__synthesize_threads(int (*process)(event_t *event,
 					      struct perf_session *session),
 			       struct perf_session *session);
 
-extern char *event__cwd;
-extern int  event__cwdlen;
-extern struct events_stats event__stats;
-extern unsigned long event__total[PERF_RECORD_MAX];
-
 int event__process_comm(event_t *self, struct perf_session *session);
 int event__process_lost(event_t *self, struct perf_session *session);
 int event__process_mmap(event_t *self, struct perf_session *session);
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 4e8a21c..bdfc4b8 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -5,6 +5,7 @@
 #include "header.h"
 #include "thread.h"
 #include <linux/rbtree.h>
+#include "../../../include/linux/perf_event.h"
 
 struct ip_callchain;
 struct thread;
@@ -18,6 +19,8 @@ struct perf_session {
 	struct map_groups	kmaps;
 	struct rb_root		threads;
 	struct thread		*last_match;
+	struct events_stats	events_stats;
+	unsigned long		event_total[PERF_RECORD_MAX];
 	struct rb_root		hists;
 	u64			sample_type;
 	int			fd;
-- 
1.6.2.5

