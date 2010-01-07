Return-Path: <linux-kernel-owner+w=401wt.eu-S1754250Ab0AGWAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250Ab0AGWAb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 17:00:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754253Ab0AGWAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 17:00:06 -0500
Received: from casper.infradead.org ([85.118.1.10]:50257 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183Ab0AGV7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 16:59:55 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 5/6] perf tools: Use rb_for_each_entry
Date: Thu,  7 Jan 2010 19:59:42 -0200
Message-Id: <1262901583-8074-5-git-send-email-acme@infradead.org>
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
 tools/perf/builtin-annotate.c |   19 ++++++-------------
 tools/perf/builtin-diff.c     |    5 ++---
 tools/perf/builtin-kmem.c     |   12 +++++-------
 tools/perf/builtin-sched.c    |   10 ++--------
 tools/perf/builtin-top.c      |   10 +++-------
 tools/perf/util/symbol.c      |   16 ++++++----------
 6 files changed, 24 insertions(+), 48 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 117bbae..61b644e 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -349,19 +349,12 @@ static void print_summary(const char *filename)
 		return;
 	}
 
-	node = rb_first(&root_sym_ext);
-	while (node) {
-		double percent;
-		const char *color;
-		char *path;
-
-		sym_ext = rb_entry(node, struct sym_ext, node);
-		percent = sym_ext->percent;
-		color = get_percent_color(percent);
-		path = sym_ext->path;
+	rb_for_each_entry(sym_ext, node, &root_sym_ext, node) {
+		double percent = sym_ext->percent;
+		const char *color = get_percent_color(percent);
+		char *path = sym_ext->path;
 
 		color_fprintf(stdout, color, " %7.2f %s", percent, path);
-		node = rb_next(node);
 	}
 }
 
@@ -428,9 +421,9 @@ static void annotate_sym(struct hist_entry *he)
 static void perf_session__find_annotations(struct perf_session *self)
 {
 	struct rb_node *nd;
+	struct hist_entry *he;
 
-	for (nd = rb_first(&self->hists); nd; nd = rb_next(nd)) {
-		struct hist_entry *he = rb_entry(nd, struct hist_entry, rb_node);
+	rb_for_each_entry(he, nd, &self->hists, rb_node) {
 		struct sym_priv *priv;
 
 		if (he->sym == NULL)
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 924bfb7..48a1e61 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -143,11 +143,10 @@ static void perf_session__match_hists(struct perf_session *old_session,
 				      struct perf_session *new_session)
 {
 	struct rb_node *nd;
+	struct hist_entry *pos;
 
-	for (nd = rb_first(&new_session->hists); nd; nd = rb_next(nd)) {
-		struct hist_entry *pos = rb_entry(nd, struct hist_entry, rb_node);
+	rb_for_each_entry(pos, nd, &new_session->hists, rb_node)
 		pos->pair = perf_session__find_hist_entry(old_session, pos);
-	}
 }
 
 static int __cmd_diff(void)
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 88c570c..2d2990d 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -354,21 +354,21 @@ static void __print_result(struct rb_root *root, struct perf_session *session,
 			   int n_lines, int is_caller)
 {
 	struct rb_node *next;
+	struct alloc_stat *data;
 
 	printf("%.102s\n", graph_dotted_line);
 	printf(" %-34s |",  is_caller ? "Callsite": "Alloc Ptr");
 	printf(" Total_alloc/Per | Total_req/Per   | Hit   | Ping-pong | Frag\n");
 	printf("%.102s\n", graph_dotted_line);
 
-	next = rb_first(root);
-
-	while (next && n_lines--) {
-		struct alloc_stat *data = rb_entry(next, struct alloc_stat,
-						   node);
+	rb_for_each_entry(data, next, root, node) {
 		struct symbol *sym = NULL;
 		char buf[BUFSIZ];
 		u64 addr;
 
+		if (n_lines--)
+			break;
+
 		if (is_caller) {
 			addr = data->call_site;
 			if (!raw_ip)
@@ -391,8 +391,6 @@ static void __print_result(struct rb_root *root, struct perf_session *session,
 		       (unsigned long)data->hit,
 		       (unsigned long)data->pingpong,
 		       fragmentation(data->bytes_req, data->bytes_alloc));
-
-		next = rb_next(next);
 	}
 
 	if (n_lines == -1)
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 702322f..88be245 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1706,6 +1706,7 @@ static void print_bad_events(void)
 static void __cmd_lat(void)
 {
 	struct rb_node *next;
+	struct work_atoms *work_list;
 
 	setup_pager();
 	read_events();
@@ -1715,15 +1716,8 @@ static void __cmd_lat(void)
 	printf("  Task                  |   Runtime ms  | Switches | Average delay ms | Maximum delay ms | Maximum delay at     |\n");
 	printf(" ---------------------------------------------------------------------------------------------------------------\n");
 
-	next = rb_first(&sorted_atom_root);
-
-	while (next) {
-		struct work_atoms *work_list;
-
-		work_list = rb_entry(next, struct work_atoms, node);
+	rb_for_each_entry(work_list, next, &sorted_atom_root, node)
 		output_lat_thread(work_list);
-		next = rb_next(next);
-	}
 
 	printf(" -----------------------------------------------------------------------------------------\n");
 	printf("  TOTAL:                |%11.3f ms |%9Ld |\n",
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index ddc584b..8f0c837 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -532,8 +532,7 @@ static void print_sym_table(void)
 	/*
 	 * Find the longest symbol name that will be displayed
 	 */
-	for (nd = rb_first(&tmp); nd; nd = rb_next(nd)) {
-		syme = rb_entry(nd, struct sym_entry, rb_node);
+	rb_for_each_entry(syme, nd, &tmp, rb_node) {
 		if (++printed > print_entries ||
 		    (int)syme->snap_count < count_filter)
 			continue;
@@ -567,13 +566,10 @@ static void print_sym_table(void)
 	printf(" %-*.*s", dso_width, dso_width, graph_line);
 	puts("\n");
 
-	for (nd = rb_first(&tmp); nd; nd = rb_next(nd)) {
-		struct symbol *sym;
+	rb_for_each_entry(syme, nd, &tmp, rb_node) {
+		struct symbol *sym = sym_entry__symbol(syme);
 		double pcnt;
 
-		syme = rb_entry(nd, struct sym_entry, rb_node);
-		sym = sym_entry__symbol(syme);
-
 		if (++printed > print_entries || (int)syme->snap_count < count_filter)
 			continue;
 
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 8e6627e..85b96ea 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -292,11 +292,10 @@ static void symbols__insert_by_name(struct rb_root *self, struct symbol *sym)
 static void symbols__sort_by_name(struct rb_root *self, struct rb_root *source)
 {
 	struct rb_node *nd;
+	struct symbol *pos;
 
-	for (nd = rb_first(source); nd; nd = rb_next(nd)) {
-		struct symbol *pos = rb_entry(nd, struct symbol, rb_node);
+	rb_for_each_entry(pos, nd, source, rb_node)
 		symbols__insert_by_name(self, pos);
-	}
 }
 
 static struct symbol *symbols__find_by_name(struct rb_root *self, const char *name)
@@ -371,14 +370,13 @@ size_t dso__fprintf_buildid(struct dso *self, FILE *fp)
 size_t dso__fprintf(struct dso *self, enum map_type type, FILE *fp)
 {
 	struct rb_node *nd;
+	struct symbol *pos;
 	size_t ret = fprintf(fp, "dso: %s (", self->short_name);
 
 	ret += dso__fprintf_buildid(self, fp);
 	ret += fprintf(fp, ")\n");
-	for (nd = rb_first(&self->symbols[type]); nd; nd = rb_next(nd)) {
-		struct symbol *pos = rb_entry(nd, struct symbol, rb_node);
+	rb_for_each_entry(pos, nd, &self->symbols[type], rb_node)
 		ret += symbol__fprintf(pos, fp);
-	}
 
 	return ret;
 }
@@ -1339,13 +1337,11 @@ struct map *map_groups__find_by_name(struct map_groups *self,
 				     enum map_type type, const char *name)
 {
 	struct rb_node *nd;
+	struct map *map;
 
-	for (nd = rb_first(&self->maps[type]); nd; nd = rb_next(nd)) {
-		struct map *map = rb_entry(nd, struct map, rb_node);
-
+	rb_for_each_entry(map, nd, &self->maps[type], rb_node)
 		if (map->dso && strcmp(map->dso->name, name) == 0)
 			return map;
-	}
 
 	return NULL;
 }
-- 
1.6.2.5

