Return-Path: <linux-kernel-owner+w=401wt.eu-S1757775AbZLNQXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757775AbZLNQXN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 11:23:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757765AbZLNQXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 11:23:12 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:43700 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757744AbZLNQXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 11:23:11 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/2] perf session: Adopt resolve_callchain
Date: Mon, 14 Dec 2009 14:22:59 -0200
Message-Id: <1260807780-19377-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

This is really a generic library routine, so declutter builtin-report.c
a bit by moving it to the library.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c |   62 +-----------------------------------------
 tools/perf/util/session.c   |   59 ++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/session.h   |    7 +++++
 3 files changed, 68 insertions(+), 60 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 854427f..5141cdc 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -407,64 +407,6 @@ static int thread__set_comm_adjust(struct thread *self, const char *comm)
 	return 0;
 }
 
-static int call__match(struct symbol *sym)
-{
-	if (sym->name && !regexec(&parent_regex, sym->name, 0, NULL, 0))
-		return 1;
-
-	return 0;
-}
-
-static struct symbol **resolve_callchain(struct thread *thread,
-					 struct perf_session *session,
-					 struct ip_callchain *chain,
-					 struct symbol **parent)
-{
-	u8 cpumode = PERF_RECORD_MISC_USER;
-	struct symbol **syms = NULL;
-	unsigned int i;
-
-	if (session->use_callchain) {
-		syms = calloc(chain->nr, sizeof(*syms));
-		if (!syms) {
-			fprintf(stderr, "Can't allocate memory for symbols\n");
-			exit(-1);
-		}
-	}
-
-	for (i = 0; i < chain->nr; i++) {
-		u64 ip = chain->ips[i];
-		struct addr_location al;
-
-		if (ip >= PERF_CONTEXT_MAX) {
-			switch (ip) {
-			case PERF_CONTEXT_HV:
-				cpumode = PERF_RECORD_MISC_HYPERVISOR;	break;
-			case PERF_CONTEXT_KERNEL:
-				cpumode = PERF_RECORD_MISC_KERNEL;	break;
-			case PERF_CONTEXT_USER:
-				cpumode = PERF_RECORD_MISC_USER;	break;
-			default:
-				break;
-			}
-			continue;
-		}
-
-		thread__find_addr_location(thread, session, cpumode,
-					   MAP__FUNCTION, ip, &al, NULL);
-		if (al.sym != NULL) {
-			if (sort__has_parent && !*parent &&
-			    call__match(al.sym))
-				*parent = al.sym;
-			if (!session->use_callchain)
-				break;
-			syms[i] = al.sym;
-		}
-	}
-
-	return syms;
-}
-
 /*
  * collect histogram counts
  */
@@ -478,8 +420,8 @@ static int perf_session__add_hist_entry(struct perf_session *self,
 	struct hist_entry *he;
 
 	if ((sort__has_parent || self->use_callchain) && chain)
-		syms = resolve_callchain(al->thread, self, chain, &parent);
-
+		syms = perf_session__resolve_callchain(self, al->thread,
+						       chain, &parent);
 	he = __perf_session__add_hist_entry(self, al, parent, count, &hit);
 	if (he == NULL)
 		return -ENOMEM;
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index fe87a2f..ecd54be 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -4,6 +4,7 @@
 #include <sys/types.h>
 
 #include "session.h"
+#include "sort.h"
 #include "util.h"
 
 static int perf_session__open(struct perf_session *self, bool force)
@@ -90,3 +91,61 @@ void perf_session__delete(struct perf_session *self)
 	free(self->cwd);
 	free(self);
 }
+
+static bool symbol__match_parent_regex(struct symbol *sym)
+{
+	if (sym->name && !regexec(&parent_regex, sym->name, 0, NULL, 0))
+		return 1;
+
+	return 0;
+}
+
+struct symbol **perf_session__resolve_callchain(struct perf_session *self,
+						struct thread *thread,
+						struct ip_callchain *chain,
+						struct symbol **parent)
+{
+	u8 cpumode = PERF_RECORD_MISC_USER;
+	struct symbol **syms = NULL;
+	unsigned int i;
+
+	if (self->use_callchain) {
+		syms = calloc(chain->nr, sizeof(*syms));
+		if (!syms) {
+			fprintf(stderr, "Can't allocate memory for symbols\n");
+			exit(-1);
+		}
+	}
+
+	for (i = 0; i < chain->nr; i++) {
+		u64 ip = chain->ips[i];
+		struct addr_location al;
+
+		if (ip >= PERF_CONTEXT_MAX) {
+			switch (ip) {
+			case PERF_CONTEXT_HV:
+				cpumode = PERF_RECORD_MISC_HYPERVISOR;	break;
+			case PERF_CONTEXT_KERNEL:
+				cpumode = PERF_RECORD_MISC_KERNEL;	break;
+			case PERF_CONTEXT_USER:
+				cpumode = PERF_RECORD_MISC_USER;	break;
+			default:
+				break;
+			}
+			continue;
+		}
+
+		thread__find_addr_location(thread, self, cpumode,
+					   MAP__FUNCTION, ip, &al, NULL);
+		if (al.sym != NULL) {
+			if (sort__has_parent && !*parent &&
+			    symbol__match_parent_regex(al.sym))
+				*parent = al.sym;
+			if (!self->use_callchain)
+				break;
+			syms[i] = al.sym;
+		}
+	}
+
+	return syms;
+}
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 759d960..a8f3a49 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -6,7 +6,9 @@
 #include "thread.h"
 #include <linux/rbtree.h>
 
+struct ip_callchain;
 struct thread;
+struct symbol;
 struct symbol_conf;
 
 struct perf_session {
@@ -50,6 +52,11 @@ void perf_session__delete(struct perf_session *self);
 int perf_session__process_events(struct perf_session *self,
 				 struct perf_event_ops *event_ops);
 
+struct symbol **perf_session__resolve_callchain(struct perf_session *self,
+						struct thread *thread,
+						struct ip_callchain *chain,
+						struct symbol **parent);
+
 int perf_header__read_build_ids(int input, u64 offset, u64 file_size);
 
 #endif /* __PERF_SESSION_H */
-- 
1.6.2.5

