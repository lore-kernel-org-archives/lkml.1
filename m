Return-Path: <linux-kernel-owner+w=401wt.eu-S1753319AbZKQRlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319AbZKQRlI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 12:41:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753450AbZKQRlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 12:41:07 -0500
Received: from casper.infradead.org ([85.118.1.10]:42363 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305AbZKQRlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 12:41:05 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 2/3] perf top: Auto adjust symbol and dso widths
Date: Tue, 17 Nov 2009 15:40:54 -0200
Message-Id: <1258479655-28662-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1258479655-28662-1-git-send-email-acme@infradead.org>
References: <1258479655-28662-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

We pre-calculate the symbol name lenght, then after we sort the entries
to print, calculate the biggest one and use that for the symbol name
width justification, then use the dso->long_name->len to justificate the
DSO name, deciding wether using the short or long name depending on how
much space we have on the terminal.

IOW give as much info to the user as the terminal width allows.

Suggested-by: Ingo Molnar <mingo@elte.hu>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c |   92 +++++++++++++++++++++++++++++++++------------
 1 files changed, 67 insertions(+), 25 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 89b7f68..a368978 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -78,6 +78,14 @@ static int			dump_symtab                     =      0;
 
 static bool			hide_kernel_symbols		=  false;
 static bool			hide_user_symbols		=  false;
+static struct winsize		winsize;
+static const char		*graph_line			=
+	"_____________________________________________________________________"
+	"_____________________________________________________________________";
+static const char		*graph_dotted_line			=
+	"---------------------------------------------------------------------"
+	"---------------------------------------------------------------------"
+	"---------------------------------------------------------------------";
 
 /*
  * Source
@@ -107,6 +115,7 @@ struct sym_entry {
 	unsigned long		snap_count;
 	double			weight;
 	int			skip;
+	u16			name_len;
 	u8			origin;
 	struct map		*map;
 	struct source_line	*source;
@@ -119,34 +128,40 @@ struct sym_entry {
  * Source functions
  */
 
-/* most GUI terminals set LINES (although some don't export it) */
-static int term_rows(void)
+static void get_term_dimensions(struct winsize *ws)
 {
-	char *lines_string = getenv("LINES");
-	int n_lines;
-
-	if (lines_string && (n_lines = atoi(lines_string)) > 0)
-		return n_lines;
-#ifdef TIOCGWINSZ
-	else {
-		struct winsize ws;
-		if (!ioctl(1, TIOCGWINSZ, &ws) && ws.ws_row)
-			return ws.ws_row;
+	char *s = getenv("LINES");
+
+	if (s != NULL) {
+		ws->ws_row = atoi(s);
+		s = getenv("COLUMNS");
+		if (s != NULL) {
+			ws->ws_col = atoi(s);
+			if (ws->ws_row && ws->ws_col)
+				return;
+		}
 	}
+#ifdef TIOCGWINSZ
+	if (ioctl(1, TIOCGWINSZ, ws) == 0 &&
+	    ws->ws_row && ws->ws_col)
+		return;
 #endif
-	return 25;
+	ws->ws_row = 25;
+	ws->ws_col = 80;
 }
 
-static void update_print_entries(void)
+static void update_print_entries(struct winsize *ws)
 {
-	print_entries = term_rows();
+	print_entries = ws->ws_row;
+
 	if (print_entries > 9)
 		print_entries -= 9;
 }
 
 static void sig_winch_handler(int sig __used)
 {
-	update_print_entries();
+	get_term_dimensions(&winsize);
+	update_print_entries(&winsize);
 }
 
 static void parse_source(struct sym_entry *syme)
@@ -423,6 +438,8 @@ static void print_sym_table(void)
 	struct sym_entry *syme, *n;
 	struct rb_root tmp = RB_ROOT;
 	struct rb_node *nd;
+	int sym_width = 0, dso_width;
+	const int win_width = winsize.ws_col - 1;
 
 	samples = userspace_samples = 0;
 
@@ -434,6 +451,7 @@ static void print_sym_table(void)
 	list_for_each_entry_safe_from(syme, n, &active_symbols, node) {
 		syme->snap_count = syme->count[snap];
 		if (syme->snap_count != 0) {
+
 			if ((hide_user_symbols &&
 			     syme->origin == PERF_RECORD_MISC_USER) ||
 			    (hide_kernel_symbols &&
@@ -453,8 +471,7 @@ static void print_sym_table(void)
 
 	puts(CONSOLE_CLEAR);
 
-	printf(
-"------------------------------------------------------------------------------\n");
+	printf("%-*.*s\n", win_width, win_width, graph_dotted_line);
 	printf( "   PerfTop:%8.0f irqs/sec  kernel:%4.1f%% [",
 		samples_per_sec,
 		100.0 - (100.0*((samples_per_sec-ksamples_per_sec)/samples_per_sec)));
@@ -492,26 +509,44 @@ static void print_sym_table(void)
 			printf(", %d CPUs)\n", nr_cpus);
 	}
 
-	printf("------------------------------------------------------------------------------\n\n");
+	printf("%-*.*s\n\n", win_width, win_width, graph_dotted_line);
 
 	if (sym_filter_entry) {
 		show_details(sym_filter_entry);
 		return;
 	}
 
+	/*
+	 * Find the longest symbol name that will be displayed
+	 */
+	for (nd = rb_first(&tmp); nd; nd = rb_next(nd)) {
+		syme = rb_entry(nd, struct sym_entry, rb_node);
+		if (++printed > print_entries ||
+		    (int)syme->snap_count < count_filter)
+			continue;
+
+		if (syme->name_len > sym_width)
+			sym_width = syme->name_len;
+	}
+
+	printed = 0;
+
 	if (nr_counters == 1)
 		printf("             samples  pcnt");
 	else
 		printf("   weight    samples  pcnt");
 
+	dso_width = winsize.ws_col - sym_width - 29;
+
 	if (verbose)
 		printf("         RIP       ");
-	printf(" function                                 DSO\n");
+	printf(" %-*.*s DSO\n", sym_width, sym_width, "function");
 	printf("   %s    _______ _____",
 	       nr_counters == 1 ? "      " : "______");
 	if (verbose)
 		printf(" ________________");
-	printf(" ________________________________ ________________\n\n");
+	printf(" %-*.*s %-*.*s\n\n", sym_width, sym_width, graph_line,
+	       dso_width, dso_width, graph_line);
 
 	for (nd = rb_first(&tmp); nd; nd = rb_next(nd)) {
 		struct symbol *sym;
@@ -534,8 +569,11 @@ static void print_sym_table(void)
 		percent_color_fprintf(stdout, "%4.1f%%", pcnt);
 		if (verbose)
 			printf(" %016llx", sym->start);
-		printf(" %-32s", sym->name);
-		printf(" %s", syme->map->dso->short_name);
+		printf(" %-*.*s", sym_width, sym_width, sym->name);
+		printf(" %-*.*s", dso_width, dso_width,
+		       dso_width >= syme->map->dso->long_name_len ?
+					syme->map->dso->long_name :
+					syme->map->dso->short_name);
 		printf("\n");
 	}
 }
@@ -718,7 +756,7 @@ static void handle_keypress(int c)
 		case 'e':
 			prompt_integer(&print_entries, "Enter display entries (lines)");
 			if (print_entries == 0) {
-				update_print_entries();
+				sig_winch_handler(SIGWINCH);
 				signal(SIGWINCH, sig_winch_handler);
 			} else
 				signal(SIGWINCH, SIG_DFL);
@@ -862,6 +900,9 @@ static int symbol_filter(struct map *map, struct symbol *sym)
 		}
 	}
 
+	if (!syme->skip)
+		syme->name_len = strlen(sym->name);
+
 	return 0;
 }
 
@@ -1301,8 +1342,9 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 	if (target_pid != -1 || profile_cpu != -1)
 		nr_cpus = 1;
 
+	get_term_dimensions(&winsize);
 	if (print_entries == 0) {
-		update_print_entries();
+		update_print_entries(&winsize);
 		signal(SIGWINCH, sig_winch_handler);
 	}
 
-- 
1.6.2.5

