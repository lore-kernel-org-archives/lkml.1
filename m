Return-Path: <linux-kernel-owner+w=401wt.eu-S932704AbZLNWJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932704AbZLNWJz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 17:09:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932531AbZLNWJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 17:09:47 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:60837 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932600AbZLNWJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 17:09:44 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/3] perf util: Remove setup_sorting dups
Date: Mon, 14 Dec 2009 20:09:29 -0200
Message-Id: <1260828571-3613-1-git-send-email-acme@infradead.org>
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

And it is also needed by 'perf diff'.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c |   17 +----------------
 tools/perf/builtin-report.c   |   17 +----------------
 tools/perf/util/sort.c        |   15 +++++++++++++++
 tools/perf/util/sort.h        |    2 ++
 4 files changed, 19 insertions(+), 32 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index fa833f5..2e2855a 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -521,21 +521,6 @@ static const struct option options[] = {
 	OPT_END()
 };
 
-static void setup_sorting(void)
-{
-	char *tmp, *tok, *str = strdup(sort_order);
-
-	for (tok = strtok_r(str, ", ", &tmp);
-			tok; tok = strtok_r(NULL, ", ", &tmp)) {
-		if (sort_dimension__add(tok) < 0) {
-			error("Unknown --sort key: `%s'", tok);
-			usage_with_options(annotate_usage, options);
-		}
-	}
-
-	free(str);
-}
-
 int cmd_annotate(int argc, const char **argv, const char *prefix __used)
 {
 	if (symbol__init(&symbol_conf) < 0)
@@ -543,7 +528,7 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __used)
 
 	argc = parse_options(argc, argv, options, annotate_usage, 0);
 
-	setup_sorting();
+	setup_sorting(annotate_usage, options);
 
 	if (argc) {
 		/*
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index d12ea4a..beff7c0 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -843,21 +843,6 @@ static const struct option options[] = {
 	OPT_END()
 };
 
-static void setup_sorting(void)
-{
-	char *tmp, *tok, *str = strdup(sort_order);
-
-	for (tok = strtok_r(str, ", ", &tmp);
-			tok; tok = strtok_r(NULL, ", ", &tmp)) {
-		if (sort_dimension__add(tok) < 0) {
-			error("Unknown --sort key: `%s'", tok);
-			usage_with_options(report_usage, options);
-		}
-	}
-
-	free(str);
-}
-
 static void setup_list(struct strlist **list, const char *list_str,
 		       struct sort_entry *se, const char *list_name,
 		       FILE *fp)
@@ -884,7 +869,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 
 	argc = parse_options(argc, argv, options, report_usage, 0);
 
-	setup_sorting();
+	setup_sorting(report_usage, options);
 
 	if (parent_pattern != default_parent_pattern) {
 		sort_dimension__add("parent");
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index b490354..cff1c31 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -288,3 +288,18 @@ int sort_dimension__add(const char *tok)
 
 	return -ESRCH;
 }
+
+void setup_sorting(const char * const usagestr[], const struct option *opts)
+{
+	char *tmp, *tok, *str = strdup(sort_order);
+
+	for (tok = strtok_r(str, ", ", &tmp);
+			tok; tok = strtok_r(NULL, ", ", &tmp)) {
+		if (sort_dimension__add(tok) < 0) {
+			error("Unknown --sort key: `%s'", tok);
+			usage_with_options(usagestr, opts);
+		}
+	}
+
+	free(str);
+}
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 333e664..cb6151c 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -81,6 +81,8 @@ struct sort_entry {
 extern struct sort_entry sort_thread;
 extern struct list_head hist_entry__sort_list;
 
+void setup_sorting(const char * const usagestr[], const struct option *opts);
+
 extern int repsep_fprintf(FILE *fp, const char *fmt, ...);
 extern size_t sort__thread_print(FILE *, struct hist_entry *, unsigned int);
 extern size_t sort__comm_print(FILE *, struct hist_entry *, unsigned int);
-- 
1.6.2.5

