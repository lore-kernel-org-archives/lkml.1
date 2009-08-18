Return-Path: <linux-kernel-owner+w=401wt.eu-S1759143AbZHRODu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759143AbZHRODu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 10:03:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759134AbZHRODt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 10:03:49 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:44517 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759129AbZHRODs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 10:03:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=xlkuWSoBMzdYIBr0v3FTUmtlk+Ru7T3lh7hYVpE/tW5aVsImL+jhl+dp3IfQ3k9uCf
         1sxjJSLt90fEtU1QOKYXWIWkK12vmPIxnYg9vw7n/PgeJTiMRdiCJ+jje0UggCL56S90
         470Gcq73btp4AgbLHXXmsHYPUXmdUIbIp3ja8=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>
Subject: [PATCH] perf tools: Fix comm column adjusting
Date: Tue, 18 Aug 2009 16:03:46 +0200
Message-Id: <1250604226-6852-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The librarization of the thread helpers between annotate and report
lost some perf report specifics.

This patch fixes the thread comm column adjusting that has been omitted
during this export.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
---
 tools/perf/builtin-report.c |   25 +++++++++++++++++++++++--
 1 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index ed1fdab..29239e9 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -665,6 +665,27 @@ static void dso__calc_col_width(struct dso *self)
 	self->slen_calculated = 1;
 }
 
+static int thread__set_comm_adjust(struct thread *self, const char *comm)
+{
+	int ret = thread__set_comm(self, comm);
+
+	if (ret)
+		return ret;
+
+	if (!col_width_list_str && !field_sep &&
+	    (!comm_list || strlist__has_entry(comm_list, comm))) {
+		unsigned int slen = strlen(comm);
+
+		if (slen > comms__col_width) {
+			comms__col_width = slen;
+			threads__col_width = slen + 6;
+		}
+	}
+
+	return 0;
+}
+
+
 static struct symbol *
 resolve_symbol(struct thread *thread, struct map **mapp,
 	       struct dso **dsop, u64 *ipp)
@@ -1056,7 +1077,7 @@ static void register_idle_thread(void)
 	struct thread *thread = threads__findnew(0, &threads, &last_match);
 
 	if (thread == NULL ||
-			thread__set_comm(thread, "[idle]")) {
+			thread__set_comm_adjust(thread, "[idle]")) {
 		fprintf(stderr, "problem inserting idle task.\n");
 		exit(-1);
 	}
@@ -1226,7 +1247,7 @@ process_comm_event(event_t *event, unsigned long offset, unsigned long head)
 		event->comm.comm, event->comm.pid);
 
 	if (thread == NULL ||
-	    thread__set_comm(thread, event->comm.comm)) {
+	    thread__set_comm_adjust(thread, event->comm.comm)) {
 		dump_printf("problem processing PERF_EVENT_COMM, skipping event.\n");
 		return -1;
 	}
-- 
1.6.2.3

