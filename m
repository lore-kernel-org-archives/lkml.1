Return-Path: <linux-kernel-owner+w=401wt.eu-S1753437AbZKQUiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437AbZKQUiO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 15:38:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753171AbZKQUiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 15:38:12 -0500
Received: from casper.infradead.org ([85.118.1.10]:43953 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180AbZKQUiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 15:38:10 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/3] perf top: Introduce helper function to access symbol from sym_entry
Date: Tue, 17 Nov 2009 18:38:00 -0200
Message-Id: <1258490282-1821-1-git-send-email-acme@infradead.org>
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

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 6db0e37..0d60c51 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -128,6 +128,11 @@ struct sym_entry {
  * Source functions
  */
 
+static inline struct symbol *sym_entry__symbol(struct sym_entry *self)
+{
+       return (struct symbol *)(self + 1);
+}
+
 static void get_term_dimensions(struct winsize *ws)
 {
 	char *s = getenv("LINES");
@@ -181,7 +186,7 @@ static void parse_source(struct sym_entry *syme)
 		goto out_assign;
 	}
 
-	sym = (struct symbol *)(syme + 1);
+	sym = sym_entry__symbol(syme);
 	map = syme->map;
 	path = map->dso->long_name;
 
@@ -276,7 +281,7 @@ out_unlock:
 
 static void lookup_sym_source(struct sym_entry *syme)
 {
-	struct symbol *symbol = (struct symbol *)(syme + 1);
+	struct symbol *symbol = sym_entry__symbol(syme);
 	struct source_line *line;
 	char pattern[PATH_MAX];
 
@@ -325,7 +330,7 @@ static void show_details(struct sym_entry *syme)
 	if (!syme->source)
 		return;
 
-	symbol = (struct symbol *)(syme + 1);
+	symbol = sym_entry__symbol(syme);
 	printf("Showing %s for %s\n", event_name(sym_counter), symbol->name);
 	printf("  Events  Pcnt (>=%d%%)\n", sym_pcnt_filter);
 
@@ -573,7 +578,7 @@ static void print_sym_table(void)
 		double pcnt;
 
 		syme = rb_entry(nd, struct sym_entry, rb_node);
-		sym = (struct symbol *)(syme + 1);
+		sym = sym_entry__symbol(syme);
 
 		if (++printed > print_entries || (int)syme->snap_count < count_filter)
 			continue;
@@ -661,7 +666,7 @@ static void prompt_symbol(struct sym_entry **target, const char *msg)
 	pthread_mutex_unlock(&active_symbols_lock);
 
 	list_for_each_entry_safe_from(syme, n, &active_symbols, node) {
-		struct symbol *sym = (struct symbol *)(syme + 1);
+		struct symbol *sym = sym_entry__symbol(syme);
 
 		if (!strcmp(buf, sym->name)) {
 			found = syme;
@@ -685,7 +690,7 @@ static void print_mapped_keys(void)
 	char *name = NULL;
 
 	if (sym_filter_entry) {
-		struct symbol *sym = (struct symbol *)(sym_filter_entry+1);
+		struct symbol *sym = sym_entry__symbol(sym_filter_entry);
 		name = sym->name;
 	}
 
-- 
1.6.2.5

