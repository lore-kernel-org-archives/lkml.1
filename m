Return-Path: <linux-kernel-owner+w=401wt.eu-S1753500Ab0AHMtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab0AHMtw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 07:49:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753432Ab0AHMtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 07:49:47 -0500
Received: from landau.phys.spbu.ru ([195.19.235.38]:37363 "EHLO
	landau.phys.spbu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040Ab0AHMtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 07:49:45 -0500
X-Greylist: delayed 1867 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Jan 2010 07:49:45 EST
From: Kirill Smelkov <kirr@landau.phys.spbu.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Kirill Smelkov <kirr@landau.phys.spbu.ru>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>
Subject: [PATCH 1/6] perf top: teach it to autolocate vmlinux
Date: Fri,  8 Jan 2010 15:23:04 +0300
Message-Id: <de6bae3b8d61ea3db1a797f31ebea6e3ed8c00a8.1262952612.git.kirr@landau.phys.spbu.ru>
X-Mailer: git-send-email 1.6.6.79.gd514e.dirty
In-Reply-To: <cover.1262952612.git.kirr@landau.phys.spbu.ru>
References: <cover.1262952612.git.kirr@landau.phys.spbu.ru>
In-Reply-To: <cover.1262952612.git.kirr@landau.phys.spbu.ru>
References: <cover.1262952612.git.kirr@landau.phys.spbu.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By relying on logic in dso__load_kernel_sym(), we can automatically load
vmlinux.

The only thing which needs to be adjusted, is how --sym-annotate option
is handled - now we can't rely on vmlinux been loaded until full
successful pass of dso__load_vmlinux(), but that's not the case if we'll
do sym_filter_entry setup in symbol_filter().

So move this step right after event__process_sample() where we know the
whole dso__load_kernel_sym() pass is done.

By the way, though conceptually similar `perf top` still can't annotate
userspace - see next patches with fixes.

Signed-off-by: Kirill Smelkov <kirr@landau.phys.spbu.ru>
Cc: Mike Galbraith <efault@gmx.de>
---
 tools/perf/Documentation/perf-top.txt |    2 +-
 tools/perf/builtin-top.c              |   39 +++++++++++++++++++-------------
 2 files changed, 24 insertions(+), 17 deletions(-)

diff --git a/tools/perf/Documentation/perf-top.txt b/tools/perf/Documentation/perf-top.txt
index 4a7d558..785b9fc 100644
--- a/tools/perf/Documentation/perf-top.txt
+++ b/tools/perf/Documentation/perf-top.txt
@@ -74,7 +74,7 @@ OPTIONS
 
 -s <symbol>::
 --sym-annotate=<symbol>::
-        Annotate this symbol.  Requires -k option.
+        Annotate this symbol.
 
 -v::
 --verbose::
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index ddc584b..9c7de93 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -94,6 +94,7 @@ struct source_line {
 
 static char			*sym_filter			=   NULL;
 struct sym_entry		*sym_filter_entry		=   NULL;
+struct sym_entry		*sym_filter_entry_sched		=   NULL;
 static int			sym_pcnt_filter			=      5;
 static int			sym_counter			=      0;
 static int			display_weighted		=     -1;
@@ -695,11 +696,9 @@ static void print_mapped_keys(void)
 
 	fprintf(stdout, "\t[f]     profile display filter (count).    \t(%d)\n", count_filter);
 
-	if (symbol_conf.vmlinux_name) {
-		fprintf(stdout, "\t[F]     annotate display filter (percent). \t(%d%%)\n", sym_pcnt_filter);
-		fprintf(stdout, "\t[s]     annotate symbol.                   \t(%s)\n", name?: "NULL");
-		fprintf(stdout, "\t[S]     stop annotation.\n");
-	}
+	fprintf(stdout, "\t[F]     annotate display filter (percent). \t(%d%%)\n", sym_pcnt_filter);
+	fprintf(stdout, "\t[s]     annotate symbol.                   \t(%s)\n", name?: "NULL");
+	fprintf(stdout, "\t[S]     stop annotation.\n");
 
 	if (nr_counters > 1)
 		fprintf(stdout, "\t[w]     toggle display weighted/count[E]r. \t(%d)\n", display_weighted ? 1 : 0);
@@ -725,14 +724,13 @@ static int key_mapped(int c)
 		case 'Q':
 		case 'K':
 		case 'U':
+		case 'F':
+		case 's':
+		case 'S':
 			return 1;
 		case 'E':
 		case 'w':
 			return nr_counters > 1 ? 1 : 0;
-		case 'F':
-		case 's':
-		case 'S':
-			return symbol_conf.vmlinux_name ? 1 : 0;
 		default:
 			break;
 	}
@@ -910,8 +908,12 @@ static int symbol_filter(struct map *map, struct symbol *sym)
 	syme = symbol__priv(sym);
 	syme->map = map;
 	syme->src = NULL;
-	if (!sym_filter_entry && sym_filter && !strcmp(name, sym_filter))
-		sym_filter_entry = syme;
+
+	if (!sym_filter_entry && sym_filter && !strcmp(name, sym_filter)) {
+		/* schedule initial sym_filter_entry setup */
+		sym_filter_entry_sched = syme;
+		sym_filter = NULL;
+	}
 
 	for (i = 0; skip_symbols[i]; i++) {
 		if (!strcmp(skip_symbols[i], name)) {
@@ -951,6 +953,13 @@ static void event__process_sample(const event_t *self,
 	    al.sym == NULL || al.filtered)
 		return;
 
+	/* let's see, whether we need to install initial sym_filter_entry */
+	if (sym_filter_entry_sched) {
+		sym_filter_entry = sym_filter_entry_sched;
+		sym_filter_entry_sched = NULL;
+		parse_source(sym_filter_entry);
+	}
+
 	syme = symbol__priv(al.sym);
 	if (!syme->skip) {
 		syme->count[counter]++;
@@ -1244,7 +1253,7 @@ static const struct option options[] = {
 	OPT_BOOLEAN('i', "inherit", &inherit,
 		    "child tasks inherit counters"),
 	OPT_STRING('s', "sym-annotate", &sym_filter, "symbol name",
-		    "symbol to annotate - requires -k option"),
+		    "symbol to annotate"),
 	OPT_BOOLEAN('z', "zero", &zero,
 		    "zero history across updates"),
 	OPT_INTEGER('F', "freq", &freq,
@@ -1280,16 +1289,14 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 
 	symbol_conf.priv_size = (sizeof(struct sym_entry) +
 				 (nr_counters + 1) * sizeof(unsigned long));
-	if (symbol_conf.vmlinux_name == NULL)
-		symbol_conf.try_vmlinux_path = true;
+
+	symbol_conf.try_vmlinux_path = (symbol_conf.vmlinux_name == NULL);
 	if (symbol__init() < 0)
 		return -1;
 
 	if (delay_secs < 1)
 		delay_secs = 1;
 
-	parse_source(sym_filter_entry);
-
 	/*
 	 * User specified count overrides default frequency.
 	 */
-- 
1.6.6.79.gd514e.dirty
