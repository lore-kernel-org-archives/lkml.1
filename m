Return-Path: <linux-kernel-owner+w=401wt.eu-S1752743AbZJTRId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743AbZJTRId (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 13:08:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751687AbZJTRIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 13:08:32 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39167 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbZJTRIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 13:08:31 -0400
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>
Subject: [PATCH] perf annotate: Remove requirement of passing a symbol name
Date: Tue, 20 Oct 2009 15:08:29 -0200
Message-Id: <1256058509-19678-1-git-send-email-acme@redhat.com>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the user doesn't pass a symbol name to annotate, it will annotate all the
symbols that have hits, in order, just like 'perf report -s comm,dso,symbol'.

This is a natural followup patch to the one that uses output_hists to find the
symbols with hits.

The common case is to annotate the first few entries at the top of a perf
report, so lets type less characters.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c |   11 ++---------
 1 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 2456925..99bac6a 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -57,7 +57,8 @@ static const char *sym_hist_filter;
 
 static int symbol_filter(struct map *map, struct symbol *sym)
 {
-	if (strcmp(sym->name, sym_hist_filter) == 0) {
+	if (sym_hist_filter == NULL ||
+	    strcmp(sym->name, sym_hist_filter) == 0) {
 		struct sym_priv *priv = dso__sym_priv(map->dso, sym);
 		const int size = (sizeof(*priv->hist) +
 				  (sym->end - sym->start) * sizeof(u64));
@@ -581,7 +582,6 @@ static void annotate_sym(struct hist_entry *he)
 static void find_annotations(void)
 {
 	struct rb_node *nd;
-	int count = 0;
 
 	for (nd = rb_first(&output_hists); nd; nd = rb_next(nd)) {
 		struct hist_entry *he = rb_entry(nd, struct hist_entry, rb_node);
@@ -595,7 +595,6 @@ static void find_annotations(void)
 			continue;
 
 		annotate_sym(he);
-		count++;
 		/*
 		 * Since we have a hist_entry per IP for the same symbol, free
 		 * he->sym->hist to signal we already processed this symbol.
@@ -603,9 +602,6 @@ static void find_annotations(void)
 		free(priv->hist);
 		priv->hist = NULL;
 	}
-
-	if (!count)
-		printf(" Error: symbol '%s' not present amongst the samples.\n", sym_hist_filter);
 }
 
 static int __cmd_annotate(void)
@@ -793,9 +789,6 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __used)
 		sym_hist_filter = argv[0];
 	}
 
-	if (!sym_hist_filter)
-		usage_with_options(annotate_usage, options);
-
 	setup_pager();
 
 	if (field_sep && *field_sep == '.') {
-- 
1.5.5.1

