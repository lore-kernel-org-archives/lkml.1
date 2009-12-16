Return-Path: <linux-kernel-owner+w=401wt.eu-S1759243AbZLPO1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759243AbZLPO1d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 09:27:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758257AbZLPO11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 09:27:27 -0500
Received: from casper.infradead.org ([85.118.1.10]:59266 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756755AbZLPO1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 09:27:25 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/3] perf tools: Move hist entries printing routines from perf report
Date: Wed, 16 Dec 2009 12:27:09 -0200
Message-Id: <1260973631-28035-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Will be used in other tools such as 'perf diff'.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c |  397 -------------------------------------------
 tools/perf/util/hist.c      |  384 +++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/hist.h      |    1 +
 3 files changed, 385 insertions(+), 397 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 26f4de6..24d20e7 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -43,316 +43,6 @@ static char		*pretty_printing_style = default_pretty_printing_style;
 
 static char		callchain_default_opt[] = "fractal,0.5";
 
-static size_t
-callchain__fprintf_left_margin(FILE *fp, int left_margin)
-{
-	int i;
-	int ret;
-
-	ret = fprintf(fp, "            ");
-
-	for (i = 0; i < left_margin; i++)
-		ret += fprintf(fp, " ");
-
-	return ret;
-}
-
-static size_t ipchain__fprintf_graph_line(FILE *fp, int depth, int depth_mask,
-					  int left_margin)
-{
-	int i;
-	size_t ret = 0;
-
-	ret += callchain__fprintf_left_margin(fp, left_margin);
-
-	for (i = 0; i < depth; i++)
-		if (depth_mask & (1 << i))
-			ret += fprintf(fp, "|          ");
-		else
-			ret += fprintf(fp, "           ");
-
-	ret += fprintf(fp, "\n");
-
-	return ret;
-}
-static size_t
-ipchain__fprintf_graph(FILE *fp, struct callchain_list *chain, int depth,
-		       int depth_mask, int count, u64 total_samples,
-		       int hits, int left_margin)
-{
-	int i;
-	size_t ret = 0;
-
-	ret += callchain__fprintf_left_margin(fp, left_margin);
-	for (i = 0; i < depth; i++) {
-		if (depth_mask & (1 << i))
-			ret += fprintf(fp, "|");
-		else
-			ret += fprintf(fp, " ");
-		if (!count && i == depth - 1) {
-			double percent;
-
-			percent = hits * 100.0 / total_samples;
-			ret += percent_color_fprintf(fp, "--%2.2f%%-- ", percent);
-		} else
-			ret += fprintf(fp, "%s", "          ");
-	}
-	if (chain->sym)
-		ret += fprintf(fp, "%s\n", chain->sym->name);
-	else
-		ret += fprintf(fp, "%p\n", (void *)(long)chain->ip);
-
-	return ret;
-}
-
-static struct symbol *rem_sq_bracket;
-static struct callchain_list rem_hits;
-
-static void init_rem_hits(void)
-{
-	rem_sq_bracket = malloc(sizeof(*rem_sq_bracket) + 6);
-	if (!rem_sq_bracket) {
-		fprintf(stderr, "Not enough memory to display remaining hits\n");
-		return;
-	}
-
-	strcpy(rem_sq_bracket->name, "[...]");
-	rem_hits.sym = rem_sq_bracket;
-}
-
-static size_t
-__callchain__fprintf_graph(FILE *fp, struct callchain_node *self,
-			   u64 total_samples, int depth, int depth_mask,
-			   int left_margin)
-{
-	struct rb_node *node, *next;
-	struct callchain_node *child;
-	struct callchain_list *chain;
-	int new_depth_mask = depth_mask;
-	u64 new_total;
-	u64 remaining;
-	size_t ret = 0;
-	int i;
-
-	if (callchain_param.mode == CHAIN_GRAPH_REL)
-		new_total = self->children_hit;
-	else
-		new_total = total_samples;
-
-	remaining = new_total;
-
-	node = rb_first(&self->rb_root);
-	while (node) {
-		u64 cumul;
-
-		child = rb_entry(node, struct callchain_node, rb_node);
-		cumul = cumul_hits(child);
-		remaining -= cumul;
-
-		/*
-		 * The depth mask manages the output of pipes that show
-		 * the depth. We don't want to keep the pipes of the current
-		 * level for the last child of this depth.
-		 * Except if we have remaining filtered hits. They will
-		 * supersede the last child
-		 */
-		next = rb_next(node);
-		if (!next && (callchain_param.mode != CHAIN_GRAPH_REL || !remaining))
-			new_depth_mask &= ~(1 << (depth - 1));
-
-		/*
-		 * But we keep the older depth mask for the line seperator
-		 * to keep the level link until we reach the last child
-		 */
-		ret += ipchain__fprintf_graph_line(fp, depth, depth_mask,
-						   left_margin);
-		i = 0;
-		list_for_each_entry(chain, &child->val, list) {
-			if (chain->ip >= PERF_CONTEXT_MAX)
-				continue;
-			ret += ipchain__fprintf_graph(fp, chain, depth,
-						      new_depth_mask, i++,
-						      new_total,
-						      cumul,
-						      left_margin);
-		}
-		ret += __callchain__fprintf_graph(fp, child, new_total,
-						  depth + 1,
-						  new_depth_mask | (1 << depth),
-						  left_margin);
-		node = next;
-	}
-
-	if (callchain_param.mode == CHAIN_GRAPH_REL &&
-		remaining && remaining != new_total) {
-
-		if (!rem_sq_bracket)
-			return ret;
-
-		new_depth_mask &= ~(1 << (depth - 1));
-
-		ret += ipchain__fprintf_graph(fp, &rem_hits, depth,
-					      new_depth_mask, 0, new_total,
-					      remaining, left_margin);
-	}
-
-	return ret;
-}
-
-
-static size_t
-callchain__fprintf_graph(FILE *fp, struct callchain_node *self,
-			 u64 total_samples, int left_margin)
-{
-	struct callchain_list *chain;
-	bool printed = false;
-	int i = 0;
-	int ret = 0;
-
-	list_for_each_entry(chain, &self->val, list) {
-		if (chain->ip >= PERF_CONTEXT_MAX)
-			continue;
-
-		if (!i++ && sort__first_dimension == SORT_SYM)
-			continue;
-
-		if (!printed) {
-			ret += callchain__fprintf_left_margin(fp, left_margin);
-			ret += fprintf(fp, "|\n");
-			ret += callchain__fprintf_left_margin(fp, left_margin);
-			ret += fprintf(fp, "---");
-
-			left_margin += 3;
-			printed = true;
-		} else
-			ret += callchain__fprintf_left_margin(fp, left_margin);
-
-		if (chain->sym)
-			ret += fprintf(fp, " %s\n", chain->sym->name);
-		else
-			ret += fprintf(fp, " %p\n", (void *)(long)chain->ip);
-	}
-
-	ret += __callchain__fprintf_graph(fp, self, total_samples, 1, 1, left_margin);
-
-	return ret;
-}
-
-static size_t
-callchain__fprintf_flat(FILE *fp, struct callchain_node *self,
-			u64 total_samples)
-{
-	struct callchain_list *chain;
-	size_t ret = 0;
-
-	if (!self)
-		return 0;
-
-	ret += callchain__fprintf_flat(fp, self->parent, total_samples);
-
-
-	list_for_each_entry(chain, &self->val, list) {
-		if (chain->ip >= PERF_CONTEXT_MAX)
-			continue;
-		if (chain->sym)
-			ret += fprintf(fp, "                %s\n", chain->sym->name);
-		else
-			ret += fprintf(fp, "                %p\n",
-					(void *)(long)chain->ip);
-	}
-
-	return ret;
-}
-
-static size_t
-hist_entry_callchain__fprintf(FILE *fp, struct hist_entry *self,
-			      u64 total_samples, int left_margin)
-{
-	struct rb_node *rb_node;
-	struct callchain_node *chain;
-	size_t ret = 0;
-
-	rb_node = rb_first(&self->sorted_chain);
-	while (rb_node) {
-		double percent;
-
-		chain = rb_entry(rb_node, struct callchain_node, rb_node);
-		percent = chain->hit * 100.0 / total_samples;
-		switch (callchain_param.mode) {
-		case CHAIN_FLAT:
-			ret += percent_color_fprintf(fp, "           %6.2f%%\n",
-						     percent);
-			ret += callchain__fprintf_flat(fp, chain, total_samples);
-			break;
-		case CHAIN_GRAPH_ABS: /* Falldown */
-		case CHAIN_GRAPH_REL:
-			ret += callchain__fprintf_graph(fp, chain, total_samples,
-							left_margin);
-		case CHAIN_NONE:
-		default:
-			break;
-		}
-		ret += fprintf(fp, "\n");
-		rb_node = rb_next(rb_node);
-	}
-
-	return ret;
-}
-
-static size_t hist_entry__fprintf(FILE *fp, struct hist_entry *self,
-				  struct perf_session *session)
-{
-	struct sort_entry *se;
-	size_t ret;
-
-	if (symbol_conf.exclude_other && !self->parent)
-		return 0;
-
-	if (session->events_stats.total)
-		ret = percent_color_fprintf(fp,
-					    symbol_conf.field_sep ? "%.2f" : "   %6.2f%%",
-					(self->count * 100.0) / session->events_stats.total);
-	else
-		ret = fprintf(fp, symbol_conf.field_sep ? "%lld" : "%12lld ", self->count);
-
-	if (symbol_conf.show_nr_samples) {
-		if (symbol_conf.field_sep)
-			fprintf(fp, "%c%lld", *symbol_conf.field_sep, self->count);
-		else
-			fprintf(fp, "%11lld", self->count);
-	}
-
-	list_for_each_entry(se, &hist_entry__sort_list, list) {
-		if (se->elide)
-			continue;
-
-		fprintf(fp, "%s", symbol_conf.field_sep ?: "  ");
-		ret += se->print(fp, self, se->width ? *se->width : 0);
-	}
-
-	ret += fprintf(fp, "\n");
-
-	if (symbol_conf.use_callchain) {
-		int left_margin = 0;
-
-		if (sort__first_dimension == SORT_COMM) {
-			se = list_first_entry(&hist_entry__sort_list, typeof(*se),
-						list);
-			left_margin = se->width ? *se->width : 0;
-			left_margin -= thread__comm_len(self->thread);
-		}
-
-		hist_entry_callchain__fprintf(fp, self, session->events_stats.total,
-					      left_margin);
-	}
-
-	return ret;
-}
-
-/*
- * collect histogram counts
- */
-
 static int perf_session__add_hist_entry(struct perf_session *self,
 					struct addr_location *al,
 					struct ip_callchain *chain, u64 count)
@@ -381,93 +71,6 @@ static int perf_session__add_hist_entry(struct perf_session *self,
 	return 0;
 }
 
-static size_t perf_session__fprintf_hists(struct perf_session *self, FILE *fp)
-{
-	struct hist_entry *pos;
-	struct sort_entry *se;
-	struct rb_node *nd;
-	size_t ret = 0;
-	unsigned int width;
-	char *col_width = symbol_conf.col_width_list_str;
-
-	init_rem_hits();
-
-	fprintf(fp, "# Samples: %ld\n", self->events_stats.total);
-	fprintf(fp, "#\n");
-
-	fprintf(fp, "# Overhead");
-	if (symbol_conf.show_nr_samples) {
-		if (symbol_conf.field_sep)
-			fprintf(fp, "%cSamples", *symbol_conf.field_sep);
-		else
-			fputs("  Samples  ", fp);
-	}
-	list_for_each_entry(se, &hist_entry__sort_list, list) {
-		if (se->elide)
-			continue;
-		if (symbol_conf.field_sep) {
-			fprintf(fp, "%c%s", *symbol_conf.field_sep, se->header);
-			continue;
-		}
-		width = strlen(se->header);
-		if (se->width) {
-			if (symbol_conf.col_width_list_str) {
-				if (col_width) {
-					*se->width = atoi(col_width);
-					col_width = strchr(col_width, ',');
-					if (col_width)
-						++col_width;
-				}
-			}
-			width = *se->width = max(*se->width, width);
-		}
-		fprintf(fp, "  %*s", width, se->header);
-	}
-	fprintf(fp, "\n");
-
-	if (symbol_conf.field_sep)
-		goto print_entries;
-
-	fprintf(fp, "# ........");
-	if (symbol_conf.show_nr_samples)
-		fprintf(fp, " ..........");
-	list_for_each_entry(se, &hist_entry__sort_list, list) {
-		unsigned int i;
-
-		if (se->elide)
-			continue;
-
-		fprintf(fp, "  ");
-		if (se->width)
-			width = *se->width;
-		else
-			width = strlen(se->header);
-		for (i = 0; i < width; i++)
-			fprintf(fp, ".");
-	}
-	fprintf(fp, "\n");
-
-	fprintf(fp, "#\n");
-
-print_entries:
-	for (nd = rb_first(&self->hists); nd; nd = rb_next(nd)) {
-		pos = rb_entry(nd, struct hist_entry, rb_node);
-		ret += hist_entry__fprintf(fp, pos, self);
-	}
-
-	if (sort_order == default_sort_order &&
-			parent_pattern == default_parent_pattern) {
-		fprintf(fp, "#\n");
-		fprintf(fp, "# (For a higher level overview, try: perf report --sort comm,dso)\n");
-		fprintf(fp, "#\n");
-	}
-	fprintf(fp, "\n");
-
-	free(rem_sq_bracket);
-
-	return ret;
-}
-
 static int validate_chain(struct ip_callchain *chain, event_t *event)
 {
 	unsigned int chain_size;
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index d9a5a19..270eb8f 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -206,3 +206,387 @@ void perf_session__output_resort(struct perf_session *self, u64 total_samples)
 
 	self->hists = tmp;
 }
+
+static size_t callchain__fprintf_left_margin(FILE *fp, int left_margin)
+{
+	int i;
+	int ret = fprintf(fp, "            ");
+
+	for (i = 0; i < left_margin; i++)
+		ret += fprintf(fp, " ");
+
+	return ret;
+}
+
+static size_t ipchain__fprintf_graph_line(FILE *fp, int depth, int depth_mask,
+					  int left_margin)
+{
+	int i;
+	size_t ret = callchain__fprintf_left_margin(fp, left_margin);
+
+	for (i = 0; i < depth; i++)
+		if (depth_mask & (1 << i))
+			ret += fprintf(fp, "|          ");
+		else
+			ret += fprintf(fp, "           ");
+
+	ret += fprintf(fp, "\n");
+
+	return ret;
+}
+
+static size_t ipchain__fprintf_graph(FILE *fp, struct callchain_list *chain,
+				     int depth, int depth_mask, int count,
+				     u64 total_samples, int hits,
+				     int left_margin)
+{
+	int i;
+	size_t ret = 0;
+
+	ret += callchain__fprintf_left_margin(fp, left_margin);
+	for (i = 0; i < depth; i++) {
+		if (depth_mask & (1 << i))
+			ret += fprintf(fp, "|");
+		else
+			ret += fprintf(fp, " ");
+		if (!count && i == depth - 1) {
+			double percent;
+
+			percent = hits * 100.0 / total_samples;
+			ret += percent_color_fprintf(fp, "--%2.2f%%-- ", percent);
+		} else
+			ret += fprintf(fp, "%s", "          ");
+	}
+	if (chain->sym)
+		ret += fprintf(fp, "%s\n", chain->sym->name);
+	else
+		ret += fprintf(fp, "%p\n", (void *)(long)chain->ip);
+
+	return ret;
+}
+
+static struct symbol *rem_sq_bracket;
+static struct callchain_list rem_hits;
+
+static void init_rem_hits(void)
+{
+	rem_sq_bracket = malloc(sizeof(*rem_sq_bracket) + 6);
+	if (!rem_sq_bracket) {
+		fprintf(stderr, "Not enough memory to display remaining hits\n");
+		return;
+	}
+
+	strcpy(rem_sq_bracket->name, "[...]");
+	rem_hits.sym = rem_sq_bracket;
+}
+
+static size_t __callchain__fprintf_graph(FILE *fp, struct callchain_node *self,
+					 u64 total_samples, int depth,
+					 int depth_mask, int left_margin)
+{
+	struct rb_node *node, *next;
+	struct callchain_node *child;
+	struct callchain_list *chain;
+	int new_depth_mask = depth_mask;
+	u64 new_total;
+	u64 remaining;
+	size_t ret = 0;
+	int i;
+
+	if (callchain_param.mode == CHAIN_GRAPH_REL)
+		new_total = self->children_hit;
+	else
+		new_total = total_samples;
+
+	remaining = new_total;
+
+	node = rb_first(&self->rb_root);
+	while (node) {
+		u64 cumul;
+
+		child = rb_entry(node, struct callchain_node, rb_node);
+		cumul = cumul_hits(child);
+		remaining -= cumul;
+
+		/*
+		 * The depth mask manages the output of pipes that show
+		 * the depth. We don't want to keep the pipes of the current
+		 * level for the last child of this depth.
+		 * Except if we have remaining filtered hits. They will
+		 * supersede the last child
+		 */
+		next = rb_next(node);
+		if (!next && (callchain_param.mode != CHAIN_GRAPH_REL || !remaining))
+			new_depth_mask &= ~(1 << (depth - 1));
+
+		/*
+		 * But we keep the older depth mask for the line seperator
+		 * to keep the level link until we reach the last child
+		 */
+		ret += ipchain__fprintf_graph_line(fp, depth, depth_mask,
+						   left_margin);
+		i = 0;
+		list_for_each_entry(chain, &child->val, list) {
+			if (chain->ip >= PERF_CONTEXT_MAX)
+				continue;
+			ret += ipchain__fprintf_graph(fp, chain, depth,
+						      new_depth_mask, i++,
+						      new_total,
+						      cumul,
+						      left_margin);
+		}
+		ret += __callchain__fprintf_graph(fp, child, new_total,
+						  depth + 1,
+						  new_depth_mask | (1 << depth),
+						  left_margin);
+		node = next;
+	}
+
+	if (callchain_param.mode == CHAIN_GRAPH_REL &&
+		remaining && remaining != new_total) {
+
+		if (!rem_sq_bracket)
+			return ret;
+
+		new_depth_mask &= ~(1 << (depth - 1));
+
+		ret += ipchain__fprintf_graph(fp, &rem_hits, depth,
+					      new_depth_mask, 0, new_total,
+					      remaining, left_margin);
+	}
+
+	return ret;
+}
+
+static size_t callchain__fprintf_graph(FILE *fp, struct callchain_node *self,
+				       u64 total_samples, int left_margin)
+{
+	struct callchain_list *chain;
+	bool printed = false;
+	int i = 0;
+	int ret = 0;
+
+	list_for_each_entry(chain, &self->val, list) {
+		if (chain->ip >= PERF_CONTEXT_MAX)
+			continue;
+
+		if (!i++ && sort__first_dimension == SORT_SYM)
+			continue;
+
+		if (!printed) {
+			ret += callchain__fprintf_left_margin(fp, left_margin);
+			ret += fprintf(fp, "|\n");
+			ret += callchain__fprintf_left_margin(fp, left_margin);
+			ret += fprintf(fp, "---");
+
+			left_margin += 3;
+			printed = true;
+		} else
+			ret += callchain__fprintf_left_margin(fp, left_margin);
+
+		if (chain->sym)
+			ret += fprintf(fp, " %s\n", chain->sym->name);
+		else
+			ret += fprintf(fp, " %p\n", (void *)(long)chain->ip);
+	}
+
+	ret += __callchain__fprintf_graph(fp, self, total_samples, 1, 1, left_margin);
+
+	return ret;
+}
+
+static size_t callchain__fprintf_flat(FILE *fp, struct callchain_node *self,
+				      u64 total_samples)
+{
+	struct callchain_list *chain;
+	size_t ret = 0;
+
+	if (!self)
+		return 0;
+
+	ret += callchain__fprintf_flat(fp, self->parent, total_samples);
+
+
+	list_for_each_entry(chain, &self->val, list) {
+		if (chain->ip >= PERF_CONTEXT_MAX)
+			continue;
+		if (chain->sym)
+			ret += fprintf(fp, "                %s\n", chain->sym->name);
+		else
+			ret += fprintf(fp, "                %p\n",
+					(void *)(long)chain->ip);
+	}
+
+	return ret;
+}
+
+static size_t hist_entry_callchain__fprintf(FILE *fp, struct hist_entry *self,
+					    u64 total_samples, int left_margin)
+{
+	struct rb_node *rb_node;
+	struct callchain_node *chain;
+	size_t ret = 0;
+
+	rb_node = rb_first(&self->sorted_chain);
+	while (rb_node) {
+		double percent;
+
+		chain = rb_entry(rb_node, struct callchain_node, rb_node);
+		percent = chain->hit * 100.0 / total_samples;
+		switch (callchain_param.mode) {
+		case CHAIN_FLAT:
+			ret += percent_color_fprintf(fp, "           %6.2f%%\n",
+						     percent);
+			ret += callchain__fprintf_flat(fp, chain, total_samples);
+			break;
+		case CHAIN_GRAPH_ABS: /* Falldown */
+		case CHAIN_GRAPH_REL:
+			ret += callchain__fprintf_graph(fp, chain, total_samples,
+							left_margin);
+		case CHAIN_NONE:
+		default:
+			break;
+		}
+		ret += fprintf(fp, "\n");
+		rb_node = rb_next(rb_node);
+	}
+
+	return ret;
+}
+
+static size_t hist_entry__fprintf(FILE *fp, struct hist_entry *self,
+				  struct perf_session *session)
+{
+	struct sort_entry *se;
+	size_t ret;
+
+	if (symbol_conf.exclude_other && !self->parent)
+		return 0;
+
+	if (session->events_stats.total)
+		ret = percent_color_fprintf(fp,
+					    symbol_conf.field_sep ? "%.2f" : "   %6.2f%%",
+					(self->count * 100.0) / session->events_stats.total);
+	else
+		ret = fprintf(fp, symbol_conf.field_sep ? "%lld" : "%12lld ", self->count);
+
+	if (symbol_conf.show_nr_samples) {
+		if (symbol_conf.field_sep)
+			fprintf(fp, "%c%lld", *symbol_conf.field_sep, self->count);
+		else
+			fprintf(fp, "%11lld", self->count);
+	}
+
+	list_for_each_entry(se, &hist_entry__sort_list, list) {
+		if (se->elide)
+			continue;
+
+		fprintf(fp, "%s", symbol_conf.field_sep ?: "  ");
+		ret += se->print(fp, self, se->width ? *se->width : 0);
+	}
+
+	ret += fprintf(fp, "\n");
+
+	if (symbol_conf.use_callchain) {
+		int left_margin = 0;
+
+		if (sort__first_dimension == SORT_COMM) {
+			se = list_first_entry(&hist_entry__sort_list, typeof(*se),
+						list);
+			left_margin = se->width ? *se->width : 0;
+			left_margin -= thread__comm_len(self->thread);
+		}
+
+		hist_entry_callchain__fprintf(fp, self, session->events_stats.total,
+					      left_margin);
+	}
+
+	return ret;
+}
+
+size_t perf_session__fprintf_hists(struct perf_session *self, FILE *fp)
+{
+	struct hist_entry *pos;
+	struct sort_entry *se;
+	struct rb_node *nd;
+	size_t ret = 0;
+	unsigned int width;
+	char *col_width = symbol_conf.col_width_list_str;
+
+	init_rem_hits();
+
+	fprintf(fp, "# Samples: %ld\n", self->events_stats.total);
+	fprintf(fp, "#\n");
+
+	fprintf(fp, "# Overhead");
+	if (symbol_conf.show_nr_samples) {
+		if (symbol_conf.field_sep)
+			fprintf(fp, "%cSamples", *symbol_conf.field_sep);
+		else
+			fputs("  Samples  ", fp);
+	}
+	list_for_each_entry(se, &hist_entry__sort_list, list) {
+		if (se->elide)
+			continue;
+		if (symbol_conf.field_sep) {
+			fprintf(fp, "%c%s", *symbol_conf.field_sep, se->header);
+			continue;
+		}
+		width = strlen(se->header);
+		if (se->width) {
+			if (symbol_conf.col_width_list_str) {
+				if (col_width) {
+					*se->width = atoi(col_width);
+					col_width = strchr(col_width, ',');
+					if (col_width)
+						++col_width;
+				}
+			}
+			width = *se->width = max(*se->width, width);
+		}
+		fprintf(fp, "  %*s", width, se->header);
+	}
+	fprintf(fp, "\n");
+
+	if (symbol_conf.field_sep)
+		goto print_entries;
+
+	fprintf(fp, "# ........");
+	if (symbol_conf.show_nr_samples)
+		fprintf(fp, " ..........");
+	list_for_each_entry(se, &hist_entry__sort_list, list) {
+		unsigned int i;
+
+		if (se->elide)
+			continue;
+
+		fprintf(fp, "  ");
+		if (se->width)
+			width = *se->width;
+		else
+			width = strlen(se->header);
+		for (i = 0; i < width; i++)
+			fprintf(fp, ".");
+	}
+	fprintf(fp, "\n");
+
+	fprintf(fp, "#\n");
+
+print_entries:
+	for (nd = rb_first(&self->hists); nd; nd = rb_next(nd)) {
+		pos = rb_entry(nd, struct hist_entry, rb_node);
+		ret += hist_entry__fprintf(fp, pos, self);
+	}
+
+	if (sort_order == default_sort_order &&
+			parent_pattern == default_parent_pattern) {
+		fprintf(fp, "#\n");
+		fprintf(fp, "# (For a higher level overview, try: perf report --sort comm,dso)\n");
+		fprintf(fp, "#\n");
+	}
+	fprintf(fp, "\n");
+
+	free(rem_sq_bracket);
+
+	return ret;
+}
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 7efdb1b..c7ac78d 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -21,5 +21,6 @@ void hist_entry__free(struct hist_entry *);
 
 void perf_session__output_resort(struct perf_session *self, u64 total_samples);
 void perf_session__collapse_resort(struct perf_session *self);
+size_t perf_session__fprintf_hists(struct perf_session *self, FILE *fp);
 
 #endif	/* __PERF_HIST_H */
-- 
1.6.2.5

