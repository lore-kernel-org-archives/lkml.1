Return-Path: <linux-kernel-owner+w=401wt.eu-S1753790Ab0ANOXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790Ab0ANOXi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 09:23:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752438Ab0ANOX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 09:23:26 -0500
Received: from casper.infradead.org ([85.118.1.10]:34772 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379Ab0ANOXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 09:23:24 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/2] perf tools: Don't cast RIP to pointers
Date: Thu, 14 Jan 2010 12:23:09 -0200
Message-Id: <1263478990-8200-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Since they can come from another arquitecture with bigger pointers, i.e.
processing a 64-bit perf.data on a 32-bit arch.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c |    4 ++--
 tools/perf/builtin-diff.c     |    4 ++--
 tools/perf/builtin-kmem.c     |    7 ++-----
 tools/perf/builtin-report.c   |    7 ++-----
 tools/perf/builtin-sched.c    |    7 ++-----
 tools/perf/builtin-trace.c    |    7 ++-----
 tools/perf/util/event.c       |    9 +++------
 tools/perf/util/session.c     |   16 ++++++----------
 8 files changed, 21 insertions(+), 40 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 117bbae..73c202e 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -132,8 +132,8 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 {
 	struct addr_location al;
 
-	dump_printf("(IP, %d): %d: %p\n", event->header.misc,
-		    event->ip.pid, (void *)(long)event->ip.ip);
+	dump_printf("(IP, %d): %d: %#Lx\n", event->header.misc,
+		    event->ip.pid, event->ip.ip);
 
 	if (event__preprocess_sample(event, session, &al, symbol_filter) < 0) {
 		fprintf(stderr, "problem processing %d event, skipping it.\n",
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 924bfb7..18b3f50 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -42,8 +42,8 @@ static int diff__process_sample_event(event_t *event, struct perf_session *sessi
 	struct addr_location al;
 	struct sample_data data = { .period = 1, };
 
-	dump_printf("(IP, %d): %d: %p\n", event->header.misc,
-		    event->ip.pid, (void *)(long)event->ip.ip);
+	dump_printf("(IP, %d): %d: %#Lx\n", event->header.misc,
+		    event->ip.pid, event->ip.ip);
 
 	if (event__preprocess_sample(event, session, &al, NULL) < 0) {
 		pr_warning("problem processing %d event, skipping it.\n",
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 4af7199..7323d9d 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -316,11 +316,8 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 
 	event__parse_sample(event, session->sample_type, &data);
 
-	dump_printf("(IP, %d): %d/%d: %p period: %Ld\n",
-		event->header.misc,
-		data.pid, data.tid,
-		(void *)(long)data.ip,
-		(long long)data.period);
+	dump_printf("(IP, %d): %d/%d: %#Lx period: %Ld\n", event->header.misc,
+		    data.pid, data.tid, data.ip, data.period);
 
 	thread = perf_session__findnew(session, event->ip.pid);
 	if (thread == NULL) {
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 80d691a..4c3d699 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -93,11 +93,8 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 
 	event__parse_sample(event, session->sample_type, &data);
 
-	dump_printf("(IP, %d): %d/%d: %p period: %Ld\n",
-		event->header.misc,
-		data.pid, data.tid,
-		(void *)(long)data.ip,
-		(long long)data.period);
+	dump_printf("(IP, %d): %d/%d: %#Lx period: %Ld\n", event->header.misc,
+		    data.pid, data.tid, data.ip, data.period);
 
 	if (session->sample_type & PERF_SAMPLE_CALLCHAIN) {
 		unsigned int i;
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 702322f..4f5a03e 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1621,11 +1621,8 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 
 	event__parse_sample(event, session->sample_type, &data);
 
-	dump_printf("(IP, %d): %d/%d: %p period: %Ld\n",
-		event->header.misc,
-		data.pid, data.tid,
-		(void *)(long)data.ip,
-		(long long)data.period);
+	dump_printf("(IP, %d): %d/%d: %#Lx period: %Ld\n", event->header.misc,
+		    data.pid, data.tid, data.ip, data.period);
 
 	thread = perf_session__findnew(session, data.pid);
 	if (thread == NULL) {
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 1831434..8e9cbfe 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -75,11 +75,8 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 
 	event__parse_sample(event, session->sample_type, &data);
 
-	dump_printf("(IP, %d): %d/%d: %p period: %Ld\n",
-		event->header.misc,
-		data.pid, data.tid,
-		(void *)(long)data.ip,
-		(long long)data.period);
+	dump_printf("(IP, %d): %d/%d: %#Lx period: %Ld\n", event->header.misc,
+		    data.pid, data.tid, data.ip, data.period);
 
 	thread = perf_session__findnew(session, event->ip.pid);
 	if (thread == NULL) {
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 4f3e7ef..24ec5be 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -313,12 +313,9 @@ int event__process_mmap(event_t *self, struct perf_session *session)
 	struct thread *thread;
 	struct map *map;
 
-	dump_printf(" %d/%d: [%p(%p) @ %p]: %s\n",
-		    self->mmap.pid, self->mmap.tid,
-		    (void *)(long)self->mmap.start,
-		    (void *)(long)self->mmap.len,
-		    (void *)(long)self->mmap.pgoff,
-		    self->mmap.filename);
+	dump_printf(" %d/%d: [%#Lx(%#Lx) @ %#Lx]: %s\n",
+		    self->mmap.pid, self->mmap.tid, self->mmap.start,
+		    self->mmap.len, self->mmap.pgoff, self->mmap.filename);
 
 	if (self->mmap.pid == 0) {
 		static const char kmmap_prefix[] = "[kernel.kallsyms.";
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index fd1c5a3..e3ccdb4 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -209,9 +209,8 @@ static int perf_session__process_event(struct perf_session *self,
 	trace_event(event);
 
 	if (event->header.type < PERF_RECORD_MAX) {
-		dump_printf("%p [%p]: PERF_RECORD_%s",
-			    (void *)(offset + head),
-			    (void *)(long)(event->header.size),
+		dump_printf("%#lx [%#x]: PERF_RECORD_%s",
+			    offset + head, event->header.size,
 			    event__name[event->header.type]);
 		++event__total[0];
 		++event__total[event->header.type];
@@ -362,16 +361,13 @@ more:
 
 	size = event->header.size;
 
-	dump_printf("\n%p [%p]: event: %d\n",
-			(void *)(offset + head),
-			(void *)(long)event->header.size,
-			event->header.type);
+	dump_printf("\n%#lx [%#x]: event: %d\n",
+		    offset + head, event->header.size, event->header.type);
 
 	if (size == 0 ||
 	    perf_session__process_event(self, event, ops, offset, head) < 0) {
-		dump_printf("%p [%p]: skipping unknown header type: %d\n",
-			    (void *)(offset + head),
-			    (void *)(long)(event->header.size),
+		dump_printf("%#lx [%#x]: skipping unknown header type: %d\n",
+			    offset + head, event->header.size,
 			    event->header.type);
 		/*
 		 * assume we lost track of the stream, check alignment, and
-- 
1.6.5

