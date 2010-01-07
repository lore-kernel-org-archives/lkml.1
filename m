Return-Path: <linux-kernel-owner+w=401wt.eu-S1754360Ab0AGWBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360Ab0AGWBk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 17:01:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754312Ab0AGWA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 17:00:59 -0500
Received: from casper.infradead.org ([85.118.1.10]:50255 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474Ab0AGV7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 16:59:55 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 3/6] perf tools: Create typedef for common event synthesizing callback
Date: Thu,  7 Jan 2010 19:59:40 -0200
Message-Id: <1262901583-8074-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1262901583-8074-1-git-send-email-acme@infradead.org>
References: <1262901583-8074-1-git-send-email-acme@infradead.org>
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
 tools/perf/util/event.c |   16 +++++-----------
 tools/perf/util/event.h |   12 +++++-------
 2 files changed, 10 insertions(+), 18 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 1a31feb..bfb3d87 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -8,8 +8,7 @@
 #include "thread.h"
 
 static pid_t event__synthesize_comm(pid_t pid, int full,
-				    int (*process)(event_t *event,
-						   struct perf_session *session),
+				    event__handler_t process,
 				    struct perf_session *session)
 {
 	event_t ev;
@@ -91,8 +90,7 @@ out_failure:
 }
 
 static int event__synthesize_mmap_events(pid_t pid, pid_t tgid,
-					 int (*process)(event_t *event,
-							struct perf_session *session),
+					 event__handler_t process,
 					 struct perf_session *session)
 {
 	char filename[PATH_MAX];
@@ -156,9 +154,7 @@ static int event__synthesize_mmap_events(pid_t pid, pid_t tgid,
 	return 0;
 }
 
-int event__synthesize_thread(pid_t pid,
-			     int (*process)(event_t *event,
-					    struct perf_session *session),
+int event__synthesize_thread(pid_t pid, event__handler_t process,
 			     struct perf_session *session)
 {
 	pid_t tgid = event__synthesize_comm(pid, 1, process, session);
@@ -167,8 +163,7 @@ int event__synthesize_thread(pid_t pid,
 	return event__synthesize_mmap_events(pid, tgid, process, session);
 }
 
-void event__synthesize_threads(int (*process)(event_t *event,
-					      struct perf_session *session),
+void event__synthesize_threads(event__handler_t process,
 			       struct perf_session *session)
 {
 	DIR *proc;
@@ -205,8 +200,7 @@ static int find_symbol_cb(void *arg, const char *name, char type, u64 start)
 	return 1;
 }
 
-int event__synthesize_kernel_mmap(int (*process)(event_t *event,
-						 struct perf_session *session),
+int event__synthesize_kernel_mmap(event__handler_t process,
 				  struct perf_session *session,
 				  const char *symbol_name)
 {
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 61fc0dc..80356da 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -103,15 +103,13 @@ void event__print_totals(void);
 
 struct perf_session;
 
-int event__synthesize_thread(pid_t pid,
-			     int (*process)(event_t *event,
-					    struct perf_session *session),
+typedef int (*event__handler_t)(event_t *event, struct perf_session *session);
+
+int event__synthesize_thread(pid_t pid, event__handler_t process,
 			     struct perf_session *session);
-void event__synthesize_threads(int (*process)(event_t *event,
-					      struct perf_session *session),
+void event__synthesize_threads(event__handler_t process,
 			       struct perf_session *session);
-int event__synthesize_kernel_mmap(int (*process)(event_t *event,
-						 struct perf_session *session),
+int event__synthesize_kernel_mmap(event__handler_t process,
 				  struct perf_session *session,
 				  const char *symbol_name);
 
-- 
1.6.2.5

