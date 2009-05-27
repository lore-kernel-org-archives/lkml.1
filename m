Return-Path: <linux-kernel-owner+w=401wt.eu-S933525AbZE0SW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933525AbZE0SW7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 14:22:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932573AbZE0SVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 14:21:45 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58133 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932913AbZE0SVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 14:21:43 -0400
Message-Id: <20090527182100.921953817@chello.nl>
References: <20090527182021.231666503@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 27 May 2009 20:20:25 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       John Kacur <jkacur@redhat.com>, Mike Galbraith <efault@gmx.de>
Subject: [PATCH 4/7] perf_counter: tools: report: dynamic sort/print bits
Content-Disposition: inline; filename=perf_counter-tools-report-sort3.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the sorting and printing dynamic.

LKML-Reference: <new-submission>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 Documentation/perf_counter/builtin-report.c |  141 +++++++++++++++++++++-------
 1 file changed, 107 insertions(+), 34 deletions(-)

Index: linux-2.6/Documentation/perf_counter/builtin-report.c
===================================================================
--- linux-2.6.orig/Documentation/perf_counter/builtin-report.c
+++ linux-2.6/Documentation/perf_counter/builtin-report.c
@@ -699,14 +699,41 @@ struct hist_entry {
 	uint32_t	 count;
 };
 
+/*
+ * configurable sorting bits
+ */
+
+struct sort_entry {
+	struct list_head list;
+
+	int64_t (*cmp)(struct hist_entry *, struct hist_entry *);
+	size_t	(*print)(FILE *fp, struct hist_entry *);
+};
+
 static int64_t
-hist_entry__cmp(struct hist_entry *left, struct hist_entry *right)
+sort__thread_cmp(struct hist_entry *left, struct hist_entry *right)
 {
-	uint64_t ip_l, ip_r;
-	int cmp = right->thread->pid - left->thread->pid;
+	return right->thread->pid - left->thread->pid;
+}
+
+static size_t
+sort__thread_print(FILE *fp, struct hist_entry *self)
+{
+	char bf[32];
+
+	return fprintf(fp, "%14s ",
+			thread__name(self->thread, bf, sizeof(bf)));
+}
 
-	if (cmp)
-		return cmp;
+static struct sort_entry sort_thread = {
+	.cmp	= sort__thread_cmp,
+	.print	= sort__thread_print,
+};
+
+static int64_t
+sort__sym_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	uint64_t ip_l, ip_r;
 
 	if (left->sym == right->sym)
 		return 0;
@@ -717,6 +744,79 @@ hist_entry__cmp(struct hist_entry *left,
 	return (int64_t)(ip_r - ip_l);
 }
 
+static size_t
+sort__sym_print(FILE *fp, struct hist_entry *self)
+{
+	size_t ret = 0;
+
+	ret += fprintf(fp, "[%c] ", self->level);
+
+	if (verbose)
+		ret += fprintf(fp, "%#018llx ", (unsigned long long)self->ip);
+
+	if (self->level != '.')
+		ret += fprintf(fp, "%s ",
+			       self->sym ? self->sym->name : "<unknown>");
+	else
+		ret += fprintf(fp, "%s: %s ",
+			       self->dso ? self->dso->name : "<unknown>",
+			       self->sym ? self->sym->name : "<unknown>");
+
+	return ret;
+}
+
+static struct sort_entry sort_sym = {
+	.cmp	= sort__sym_cmp,
+	.print	= sort__sym_print,
+};
+
+static LIST_HEAD(hist_entry__sort_list);
+
+static void setup_sorting(void)
+{
+	list_add_tail(&sort_thread.list, &hist_entry__sort_list);
+	list_add_tail(&sort_sym.list, &hist_entry__sort_list);
+}
+
+static int64_t
+hist_entry__cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	struct sort_entry *se;
+	int64_t cmp = 0;
+
+	list_for_each_entry(se, &hist_entry__sort_list, list) {
+		cmp = se->cmp(left, right);
+		if (cmp)
+			break;
+	}
+
+	return cmp;
+}
+
+static size_t
+hist_entry__fprintf(FILE *fp, struct hist_entry *self, uint64_t total_samples)
+{
+	struct sort_entry *se;
+	size_t ret;
+
+	if (total_samples) {
+		ret = fprintf(fp, "%5.2f%% ",
+				(self->count * 100.0) / total_samples);
+	} else
+		ret = fprintf(fp, "%12d ", self->count);
+
+	list_for_each_entry(se, &hist_entry__sort_list, list)
+		ret += se->print(fp, self);
+
+	ret += fprintf(fp, "\n");
+
+	return ret;
+}
+
+/*
+ * collect histogram counts
+ */
+
 static int
 hist_entry__add(struct thread *thread, struct map *map, struct dso *dso,
 		struct symbol *sym, uint64_t ip, char level)
@@ -762,35 +862,6 @@ hist_entry__add(struct thread *thread, s
 	return 0;
 }
 
-static size_t
-hist_entry__fprintf(FILE *fp, struct hist_entry *self, uint64_t total_samples)
-{
-	char bf[32];
-	size_t ret;
-
-	if (total_samples) {
-		ret = fprintf(fp, "%5.2f%% ",
-				(self->count * 100.0) / total_samples);
-	} else
-		ret = fprintf(fp, "%12d ", self->count);
-
-	ret += fprintf(fp, "%14s [%c] ",
-		       thread__name(self->thread, bf, sizeof(bf)),
-		       self->level);
-
-	if (verbose)
-		ret += fprintf(fp, "%#018llx ", (unsigned long long)self->ip);
-
-	if (self->level != '.')
-		ret += fprintf(fp, "%s\n",
-			       self->sym ? self->sym->name : "<unknown>");
-	else
-		ret += fprintf(fp, "%s: %s\n",
-			       self->dso ? self->dso->name : "<unknown>",
-			       self->sym ? self->sym->name : "<unknown>");
-	return ret;
-}
-
 /*
  * reverse the map, sort on count.
  */
@@ -1077,6 +1148,8 @@ int cmd_report(int argc, const char **ar
 
 	parse_options(argc, argv, options, report_usage, 0);
 
+	setup_sorting();
+
 	setup_pager();
 
 	return __cmd_report();

-- 

