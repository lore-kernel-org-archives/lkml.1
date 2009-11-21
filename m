Return-Path: <linux-kernel-owner+w=401wt.eu-S1755708AbZKUQbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708AbZKUQbc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 11:31:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755407AbZKUQbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 11:31:31 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:40418 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755459AbZKUQb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 11:31:29 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 3/3] perf trace: read_tracing_data should die() another day
Date: Sat, 21 Nov 2009 14:31:26 -0200
Message-Id: <1258821086-11521-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1258821086-11521-2-git-send-email-acme@infradead.org>
References: <1258821086-11521-1-git-send-email-acme@infradead.org>
 <1258821086-11521-2-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

It better propagate errors, also if we do a simple:

[root@doppio linux-2.6-tip]# perf record -R -a -f sleep 3s ; perf trace
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.182 MB perf.data (~7972 samples) ]
  Fatal: not an trace data file
[root@doppio linux-2.6-tip]#

That is what is expected, right? I.e. as we didn't specify any
tracepoint event via -e, it should gracefully bail out and not SEGFAULT.

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/trace-event-info.c |   22 +++++++++++++++-------
 tools/perf/util/trace-event.h      |    2 +-
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index 831052d..cace355 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -33,11 +33,11 @@
 #include <ctype.h>
 #include <errno.h>
 #include <stdbool.h>
+#include <linux/kernel.h>
 
 #include "../perf.h"
 #include "trace-event.h"
 
-
 #define VERSION "0.5"
 
 #define _STR(x) #x
@@ -483,23 +483,31 @@ static struct tracepoint_path *
 get_tracepoints_path(struct perf_event_attr *pattrs, int nb_events)
 {
 	struct tracepoint_path path, *ppath = &path;
-	int i;
+	int i, nr_tracepoints = 0;
 
 	for (i = 0; i < nb_events; i++) {
 		if (pattrs[i].type != PERF_TYPE_TRACEPOINT)
 			continue;
+		++nr_tracepoints;
 		ppath->next = tracepoint_id_to_path(pattrs[i].config);
 		if (!ppath->next)
 			die("%s\n", "No memory to alloc tracepoints list");
 		ppath = ppath->next;
 	}
 
-	return path.next;
+	return nr_tracepoints > 0 ? path.next : NULL;
 }
-void read_tracing_data(int fd, struct perf_event_attr *pattrs, int nb_events)
+
+int read_tracing_data(int fd, struct perf_event_attr *pattrs, int nb_events)
 {
 	char buf[BUFSIZ];
-	struct tracepoint_path *tps;
+	struct tracepoint_path *tps = get_tracepoints_path(pattrs, nb_events);
+
+	/*
+	 * What? No tracepoints? No sense writing anything here, bail out.
+	 */
+	if (tps == NULL)
+		return -1;
 
 	output_fd = fd;
 
@@ -528,11 +536,11 @@ void read_tracing_data(int fd, struct perf_event_attr *pattrs, int nb_events)
 	page_size = getpagesize();
 	write_or_die(&page_size, 4);
 
-	tps = get_tracepoints_path(pattrs, nb_events);
-
 	read_header_files();
 	read_ftrace_files(tps);
 	read_event_files(tps);
 	read_proc_kallsyms();
 	read_ftrace_printk();
+
+	return 0;
 }
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index f6637c2..dd51c68 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -248,7 +248,7 @@ unsigned long long
 raw_field_value(struct event *event, const char *name, void *data);
 void *raw_field_ptr(struct event *event, const char *name, void *data);
 
-void read_tracing_data(int fd, struct perf_event_attr *pattrs, int nb_events);
+int read_tracing_data(int fd, struct perf_event_attr *pattrs, int nb_events);
 
 /* taken from kernel/trace/trace.h */
 enum trace_flag_type {
-- 
1.6.2.5

