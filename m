Return-Path: <linux-kernel-owner+w=401wt.eu-S933289AbZE0TxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933289AbZE0TxA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 15:53:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932690AbZE0Tw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 15:52:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:51417 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762015AbZE0Tw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 15:52:27 -0400
Date: Wed, 27 May 2009 19:51:56 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <20090527182100.921953817@chello.nl>
References: <20090527182100.921953817@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: tools: report: Dynamic sort/print bits
Message-ID: <tip-1aa167382323eeeeb38368cab85cf17979793cbe@git.kernel.org>
Git-Commit-ID: 1aa167382323eeeeb38368cab85cf17979793cbe
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 27 May 2009 19:51:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1aa167382323eeeeb38368cab85cf17979793cbe
Gitweb:     http://git.kernel.org/tip/1aa167382323eeeeb38368cab85cf17979793cbe
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 27 May 2009 20:20:25 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 27 May 2009 21:44:13 +0200

perf_counter: tools: report: Dynamic sort/print bits

Make the sorting and printing dynamic.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <20090527182100.921953817@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-report.c |  141 ++++++++++++++++++++-------
 1 files changed, 107 insertions(+), 34 deletions(-)

diff --git a/Documentation/perf_counter/builtin-report.c b/Documentation/perf_counter/builtin-report.c
index 2762564..856186f 100644
--- a/Documentation/perf_counter/builtin-report.c
+++ b/Documentation/perf_counter/builtin-report.c
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
@@ -717,6 +744,79 @@ hist_entry__cmp(struct hist_entry *left, struct hist_entry *right)
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
@@ -762,35 +862,6 @@ hist_entry__add(struct thread *thread, struct map *map, struct dso *dso,
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
@@ -1077,6 +1148,8 @@ int cmd_report(int argc, const char **argv, const char *prefix)
 
 	parse_options(argc, argv, options, report_usage, 0);
 
+	setup_sorting();
+
 	setup_pager();
 
 	return __cmd_report();
