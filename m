Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461Ab0BCSw2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 13:52:28 -0500
Received: from casper.infradead.org ([85.118.1.10]:53438 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383Ab0BCSwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 13:52:21 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 5/9] perf build-id: Move the routine to find DSOs with hits to the lib
Date: Wed,  3 Feb 2010 16:52:04 -0200
Message-Id: <1265223128-11786-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1265223128-11786-1-git-send-email-acme@infradead.org>
References: <1265223128-11786-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Because 'perf record' will have to find the build-ids in after we stop
recording, so as to reduce even more the impact in the workload while we do the
measurement.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile               |    2 +
 tools/perf/builtin-buildid-list.c |   31 +---------------------------
 tools/perf/util/build-id.c        |   39 +++++++++++++++++++++++++++++++++++++
 tools/perf/util/build-id.h        |    8 +++++++
 4 files changed, 51 insertions(+), 29 deletions(-)
 create mode 100644 tools/perf/util/build-id.c
 create mode 100644 tools/perf/util/build-id.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 4296930..3a5fb36 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -357,6 +357,7 @@ LIB_H += util/include/asm/uaccess.h
 LIB_H += perf.h
 LIB_H += util/cache.h
 LIB_H += util/callchain.h
+LIB_H += util/build-id.h
 LIB_H += util/debug.h
 LIB_H += util/debugfs.h
 LIB_H += util/event.h
@@ -390,6 +391,7 @@ LIB_H += util/probe-event.h
 
 LIB_OBJS += util/abspath.o
 LIB_OBJS += util/alias.o
+LIB_OBJS += util/build-id.o
 LIB_OBJS += util/config.o
 LIB_OBJS += util/ctype.o
 LIB_OBJS += util/debugfs.o
diff --git a/tools/perf/builtin-buildid-list.c b/tools/perf/builtin-buildid-list.c
index 431f204..d0675c0 100644
--- a/tools/perf/builtin-buildid-list.c
+++ b/tools/perf/builtin-buildid-list.c
@@ -8,6 +8,7 @@
  */
 #include "builtin.h"
 #include "perf.h"
+#include "util/build-id.h"
 #include "util/cache.h"
 #include "util/debug.h"
 #include "util/parse-options.h"
@@ -33,34 +34,6 @@ static const struct option options[] = {
 	OPT_END()
 };
 
-static int build_id_list__process_event(event_t *event,
-					struct perf_session *session)
-{
-	struct addr_location al;
-	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
-	struct thread *thread = perf_session__findnew(session, event->ip.pid);
-
-	if (thread == NULL) {
-		pr_err("problem processing %d event, skipping it.\n",
-			event->header.type);
-		return -1;
-	}
-
-	thread__find_addr_map(thread, session, cpumode, MAP__FUNCTION,
-			      event->ip.ip, &al);
-
-	if (al.map != NULL)
-		al.map->dso->hit = 1;
-
-	return 0;
-}
-
-static struct perf_event_ops build_id_list__event_ops = {
-	.sample	= build_id_list__process_event,
-	.mmap	= event__process_mmap,
-	.fork	= event__process_task,
-};
-
 static int __cmd_buildid_list(void)
 {
 	int err = -1;
@@ -71,7 +44,7 @@ static int __cmd_buildid_list(void)
 		return -1;
 
 	if (with_hits)
-		perf_session__process_events(session, &build_id_list__event_ops);
+		perf_session__process_events(session, &build_id__mark_dso_hit_ops);
 
 	dsos__fprintf_buildid(stdout, with_hits);
 
diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
new file mode 100644
index 0000000..04904b3
--- /dev/null
+++ b/tools/perf/util/build-id.c
@@ -0,0 +1,39 @@
+/*
+ * build-id.c
+ *
+ * build-id support
+ *
+ * Copyright (C) 2009, 2010 Red Hat Inc.
+ * Copyright (C) 2009, 2010 Arnaldo Carvalho de Melo <acme@redhat.com>
+ */
+#include "build-id.h"
+#include "event.h"
+#include "symbol.h"
+#include <linux/kernel.h>
+
+static int build_id__mark_dso_hit(event_t *event, struct perf_session *session)
+{
+	struct addr_location al;
+	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
+	struct thread *thread = perf_session__findnew(session, event->ip.pid);
+
+	if (thread == NULL) {
+		pr_err("problem processing %d event, skipping it.\n",
+			event->header.type);
+		return -1;
+	}
+
+	thread__find_addr_map(thread, session, cpumode, MAP__FUNCTION,
+			      event->ip.ip, &al);
+
+	if (al.map != NULL)
+		al.map->dso->hit = 1;
+
+	return 0;
+}
+
+struct perf_event_ops build_id__mark_dso_hit_ops = {
+	.sample	= build_id__mark_dso_hit,
+	.mmap	= event__process_mmap,
+	.fork	= event__process_task,
+};
diff --git a/tools/perf/util/build-id.h b/tools/perf/util/build-id.h
new file mode 100644
index 0000000..1d981d6
--- /dev/null
+++ b/tools/perf/util/build-id.h
@@ -0,0 +1,8 @@
+#ifndef PERF_BUILD_ID_H_
+#define PERF_BUILD_ID_H_ 1
+
+#include "session.h"
+
+extern struct perf_event_ops build_id__mark_dso_hit_ops;
+
+#endif
-- 
1.6.2.5

