Return-Path: <linux-kernel-owner+w=401wt.eu-S1753020AbZJXBEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020AbZJXBEX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 21:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752891AbZJXBEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 21:04:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:51631 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752218AbZJXBER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 21:04:17 -0400
Date: Sat, 24 Oct 2009 01:03:48 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, peterz@infradead.org,
       efault@gmx.de, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1256058509-19678-1-git-send-email-acme@redhat.com>
References: <1256058509-19678-1-git-send-email-acme@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:branch?] perf annotate: Remove requirement of passing a symbol name
Message-ID: <tip-8f0b037398a909ccf703ad5f5803066db6327f22@git.kernel.org>
Git-Commit-ID: 8f0b037398a909ccf703ad5f5803066db6327f22
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8f0b037398a909ccf703ad5f5803066db6327f22
Gitweb:     http://git.kernel.org/tip/8f0b037398a909ccf703ad5f5803066db6327f22
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 20 Oct 2009 15:08:29 -0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 20 Oct 2009 21:12:58 +0200

perf annotate: Remove requirement of passing a symbol name

If the user doesn't pass a symbol name to annotate, it will
annotate all the symbols that have hits, in order, just like
'perf report -s comm,dso,symbol'.

This is a natural followup patch to the one that uses
output_hists to find the symbols with hits.

The common case is to annotate the first few entries at the top
of a perf report, so lets type less characters.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <1256058509-19678-1-git-send-email-acme@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
