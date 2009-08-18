Return-Path: <linux-kernel-owner+w=401wt.eu-S1758535AbZHROLC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758535AbZHROLC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 10:11:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751697AbZHROLB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 10:11:01 -0400
Received: from hera.kernel.org ([140.211.167.34]:53116 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217AbZHROLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 10:11:00 -0400
Date: Tue, 18 Aug 2009 14:09:36 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, peterz@infradead.org,
       efault@gmx.de, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1250604226-6852-1-git-send-email-fweisbec@gmail.com>
References: <1250604226-6852-1-git-send-email-fweisbec@gmail.com>
Subject: [tip:perfcounters/core] perf tools: Fix comm column adjusting
Message-ID: <tip-4273b005875c34beda4a11c9d4a9132d80378036@git.kernel.org>
Git-Commit-ID: 4273b005875c34beda4a11c9d4a9132d80378036
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 18 Aug 2009 14:09:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4273b005875c34beda4a11c9d4a9132d80378036
Gitweb:     http://git.kernel.org/tip/4273b005875c34beda4a11c9d4a9132d80378036
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Tue, 18 Aug 2009 16:03:46 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 18 Aug 2009 16:06:18 +0200

perf tools: Fix comm column adjusting

The librarization of the thread helpers between annotate and
report lost some perf report specifics.

This patch fixes the thread comm column adjusting that has
been omitted during this export.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <1250604226-6852-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-report.c |   25 +++++++++++++++++++++++--
 1 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 1e3ad22..3fc0d47 100644
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
