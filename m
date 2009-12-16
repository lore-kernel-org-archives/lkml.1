Return-Path: <linux-kernel-owner+w=401wt.eu-S1758304AbZLPO11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758304AbZLPO11 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 09:27:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757736AbZLPO1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 09:27:25 -0500
Received: from casper.infradead.org ([85.118.1.10]:59264 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755680AbZLPO1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 09:27:24 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 2/3] perf session: Move perf report specific hits out of perf_session__fprintf_hists
Date: Wed, 16 Dec 2009 12:27:10 -0200
Message-Id: <1260973631-28035-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1260973631-28035-1-git-send-email-acme@infradead.org>
References: <1260973631-28035-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Those don't make sense for tools such as 'perf diff'.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c |    5 +++++
 tools/perf/util/hist.c      |   11 -----------
 2 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 24d20e7..c4f3a08 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -224,7 +224,12 @@ static int __cmd_report(void)
 
 	perf_session__collapse_resort(session);
 	perf_session__output_resort(session, session->events_stats.total);
+	fprintf(stdout, "# Samples: %ld\n#\n", session->events_stats.total);
 	perf_session__fprintf_hists(session, stdout);
+	if (sort_order == default_sort_order &&
+	    parent_pattern == default_parent_pattern)
+		fprintf(stdout, "#\n# (For a higher level overview, try: perf report --sort comm,dso)\n#\n");
+
 	if (show_threads) {
 		bool raw_printing_style = !strcmp(pretty_printing_style, "raw");
 		perf_read_values_display(stdout, &show_threads_values,
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 270eb8f..6e416a6 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -515,9 +515,6 @@ size_t perf_session__fprintf_hists(struct perf_session *self, FILE *fp)
 
 	init_rem_hits();
 
-	fprintf(fp, "# Samples: %ld\n", self->events_stats.total);
-	fprintf(fp, "#\n");
-
 	fprintf(fp, "# Overhead");
 	if (symbol_conf.show_nr_samples) {
 		if (symbol_conf.field_sep)
@@ -578,14 +575,6 @@ print_entries:
 		ret += hist_entry__fprintf(fp, pos, self);
 	}
 
-	if (sort_order == default_sort_order &&
-			parent_pattern == default_parent_pattern) {
-		fprintf(fp, "#\n");
-		fprintf(fp, "# (For a higher level overview, try: perf report --sort comm,dso)\n");
-		fprintf(fp, "#\n");
-	}
-	fprintf(fp, "\n");
-
 	free(rem_sq_bracket);
 
 	return ret;
-- 
1.6.2.5

