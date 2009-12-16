Return-Path: <linux-kernel-owner+w=401wt.eu-S1751700AbZLPPto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700AbZLPPto (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 10:49:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751030AbZLPPtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 10:49:42 -0500
Received: from casper.infradead.org ([85.118.1.10]:50939 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbZLPPtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 10:49:41 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/1] perf diff: Use perf_session__fprintf_hists just like 'perf record'
Date: Wed, 16 Dec 2009 13:49:27 -0200
Message-Id: <1260978567-550-1-git-send-email-acme@infradead.org>
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

That means that almost everything you can do with 'perf report' can be
done with 'perf diff', for instance:

$ perf record -f find / > /dev/null
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.062 MB perf.data (~2699 samples) ]
$ perf record -f find / > /dev/null
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.062 MB perf.data (~2687 samples) ]
perf diff | head -8
     9.02%     +1.00%     find  libc-2.10.1.so               [.] _IO_vfprintf_internal
     2.91%     -1.00%     find  [kernel]                     [k] __kmalloc
     2.85%     -1.00%     find  [kernel]                     [k] ext4_htree_store_dirent
     1.99%     -1.00%     find  [kernel]                     [k] _atomic_dec_and_lock
     2.44%                find  [kernel]                     [k] half_md4_transform
$

So if you want to zoom into libc:

$ perf diff --dsos libc-2.10.1.so | head -8
    37.34%                find  [.] _IO_vfprintf_internal
    10.34%                find  [.] __GI_memmove
     8.25%     +2.00%     find  [.] _int_malloc
     5.07%     -1.00%     find  [.] __GI_mempcpy
     7.62%     +2.00%     find  [.] _int_free
$

And if there were multiple commands using libc, it is also possible to aggregate them all
by using --sort symbol:

$ perf diff --dsos libc-2.10.1.so --sort symbol | head -8
    37.34%             [.] _IO_vfprintf_internal
    10.34%             [.] __GI_memmove
     8.25%     +2.00%  [.] _int_malloc
     5.07%     -1.00%  [.] __GI_mempcpy
     7.62%     +2.00%  [.] _int_free
$

The displacement column now is off by default, to use it:

perf diff -m --dsos libc-2.10.1.so --sort symbol | head -8
    37.34%                   [.] _IO_vfprintf_internal
    10.34%                   [.] __GI_memmove
     8.25%     +2.00%        [.] _int_malloc
     5.07%     -1.00%    +2  [.] __GI_mempcpy
     7.62%     +2.00%    -1  [.] _int_free
$

Using -t/--field-separator can be used for scripting:

$ perf diff -t, -m --dsos libc-2.10.1.so --sort symbol | head -8
37.34, , ,[.] _IO_vfprintf_internal
10.34, , ,[.] __GI_memmove
8.25,+2.00%, ,[.] _int_malloc
5.07,-1.00%,  +2,[.] __GI_mempcpy
7.62,+2.00%,  -1,[.] _int_free
6.99,+1.00%,  -1,[.] _IO_new_file_xsputn
1.89,-2.00%,  +4,[.] __readdir64
$

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-diff.txt   |   29 ++++++-
 tools/perf/Documentation/perf-report.txt |    4 +
 tools/perf/builtin-diff.c                |   90 +++++-----------------
 tools/perf/builtin-report.c              |   12 +---
 tools/perf/util/hist.c                   |  126 ++++++++++++++++++++++++------
 tools/perf/util/hist.h                   |    5 +-
 tools/perf/util/sort.c                   |   11 +++
 tools/perf/util/sort.h                   |    2 +
 8 files changed, 169 insertions(+), 110 deletions(-)

diff --git a/tools/perf/Documentation/perf-diff.txt b/tools/perf/Documentation/perf-diff.txt
index 6936fdb..8974e20 100644
--- a/tools/perf/Documentation/perf-diff.txt
+++ b/tools/perf/Documentation/perf-diff.txt
@@ -19,9 +19,32 @@ If no parameters are passed it will assume perf.data.old and perf.data.
 
 OPTIONS
 -------
--p::
---percentage::
-	Show percentages instead of raw counts
+-d::
+--dsos=::
+	Only consider symbols in these dsos. CSV that understands
+	file://filename entries.
+
+-C::
+--comms=::
+	Only consider symbols in these comms. CSV that understands
+	file://filename entries.
+
+-S::
+--symbols=::
+	Only consider these symbols. CSV that understands
+	file://filename entries.
+
+-s::
+--sort=::
+	Sort by key(s): pid, comm, dso, symbol.
+
+-t::
+--field-separator=::
+
+	Use a special separator character and don't pad with spaces, replacing
+	all occurances of this separator in symbol names (and other output)
+	with a '.' character, that thus it's the only non valid separator.
+
 -v::
 --verbose::
 	Be verbose, for instance, show the raw counts in addition to the
diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 9dccb18..abfabe9 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -39,6 +39,10 @@ OPTIONS
 	Only consider these symbols. CSV that understands
 	file://filename entries.
 
+-s::
+--sort=::
+	Sort by key(s): pid, comm, dso, symbol, parent.
+
 -w::
 --field-width=::
 	Force each column width to the provided list, for large terminal
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index ff91e9c..66f100d 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -16,10 +16,10 @@
 
 #include <stdlib.h>
 
-static char	   const *input_old = "perf.data.old",
-			 *input_new = "perf.data";
-static int	   force;
-static bool 	   show_percent;
+static char const *input_old = "perf.data.old",
+		  *input_new = "perf.data";
+static int  force;
+static bool show_displacement;
 
 static int perf_session__add_hist_entry(struct perf_session *self,
 					struct addr_location *al, u64 count)
@@ -162,70 +162,6 @@ static void perf_session__match_hists(struct perf_session *old_session,
 	}
 }
 
-static size_t hist_entry__fprintf_matched(struct hist_entry *self,
-					  unsigned long pos,
-					  struct perf_session *session,
-					  struct perf_session *pair_session,
-					  FILE *fp)
-{
-	u64 old_count = 0;
-	char displacement[16];
-	size_t printed;
-
-	if (self->pair != NULL) {
-		long pdiff = (long)self->pair->position - (long)pos;
-		old_count = self->pair->count;
-		if (pdiff == 0)
-			goto blank;
-		snprintf(displacement, sizeof(displacement), "%+4ld", pdiff);
-	} else {
-blank:		memset(displacement, ' ', sizeof(displacement));
-	}
-
-	printed = fprintf(fp, "%4lu %5.5s ", pos, displacement);
-
-	if (show_percent) {
-		double old_percent = 0, new_percent = 0, diff;
-
-		if (pair_session->events_stats.total > 0)
-			old_percent = (old_count * 100) / pair_session->events_stats.total;
-		if (session->events_stats.total > 0)
-			new_percent = (self->count * 100) / session->events_stats.total;
-
-		diff = old_percent - new_percent;
-		if (verbose)
-			printed += fprintf(fp, " %3.2f%% %3.2f%%", old_percent, new_percent);
-
-		if ((u64)diff != 0)
-			printed += fprintf(fp, " %+4.2F%%", diff);
-		else
-			printed += fprintf(fp, "       ");
-	} else {
-		if (verbose)
-			printed += fprintf(fp, " %9Lu %9Lu", old_count, self->count);
-		printed += fprintf(fp, " %+9Ld", (s64)self->count - (s64)old_count);
-	}
-
-	return printed + fprintf(fp, " %25.25s   %s\n",
-				 self->map->dso->name, self->sym->name);
-}
-
-static size_t perf_session__fprintf_matched_hists(struct perf_session *self,
-						  struct perf_session *pair,
-						  FILE *fp)
-{
-	struct rb_node *nd;
-	size_t printed = 0;
-	unsigned long pos = 1;
-
-	for (nd = rb_first(&self->hists); nd; nd = rb_next(nd)) {
-		struct hist_entry *he = rb_entry(nd, struct hist_entry, rb_node);
-		printed += hist_entry__fprintf_matched(he, pos++, self, pair, fp);
-	}
-
-	return printed;
-}
-
 static int __cmd_diff(void)
 {
 	int ret, i;
@@ -244,7 +180,8 @@ static int __cmd_diff(void)
 	}
 
 	perf_session__match_hists(session[0], session[1]);
-	perf_session__fprintf_matched_hists(session[1], session[0], stdout);
+	perf_session__fprintf_hists(session[1], session[0],
+				    show_displacement, stdout);
 out_delete:
 	for (i = 0; i < 2; ++i)
 		perf_session__delete(session[i]);
@@ -258,13 +195,13 @@ static const char *const diff_usage[] = {
 static const struct option options[] = {
 	OPT_BOOLEAN('v', "verbose", &verbose,
 		    "be more verbose (show symbol address, etc)"),
+	OPT_BOOLEAN('m', "displacement", &show_displacement,
+		    "Show position displacement relative to baseline"),
 	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
 		    "dump raw trace in ASCII"),
 	OPT_BOOLEAN('f', "force", &force, "don't complain, do it"),
 	OPT_BOOLEAN('m', "modules", &symbol_conf.use_modules,
 		    "load module symbols - WARNING: use only with -k and LIVE kernel"),
-	OPT_BOOLEAN('p', "percentages", &show_percent,
-		    "Don't shorten the pathnames taking into account the cwd"),
 	OPT_BOOLEAN('P', "full-paths", &event_ops.full_paths,
 		    "Don't shorten the pathnames taking into account the cwd"),
 	OPT_STRING('d', "dsos", &symbol_conf.dso_list_str, "dso[,dso...]",
@@ -273,6 +210,11 @@ static const struct option options[] = {
 		   "only consider symbols in these comms"),
 	OPT_STRING('S', "symbols", &symbol_conf.sym_list_str, "symbol[,symbol...]",
 		   "only consider these symbols"),
+	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
+		   "sort by key(s): pid, comm, dso, symbol, parent"),
+	OPT_STRING('t', "field-separator", &symbol_conf.field_sep, "separator",
+		   "separator for columns, no spaces will be added between "
+		   "columns '.' is reserved."),
 	OPT_END()
 };
 
@@ -289,10 +231,16 @@ int cmd_diff(int argc, const char **argv, const char *prefix __used)
 			input_new = argv[0];
 	}
 
+	symbol_conf.exclude_other = false;
 	if (symbol__init() < 0)
 		return -1;
 
 	setup_sorting(diff_usage, options);
 	setup_pager();
+
+	sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list, "dso", NULL);
+	sort_entry__setup_elide(&sort_comm, symbol_conf.comm_list, "comm", NULL);
+	sort_entry__setup_elide(&sort_sym, symbol_conf.sym_list, "symbol", NULL);
+
 	return __cmd_diff();
 }
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index cf1d370..e50a6b1 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -225,7 +225,7 @@ static int __cmd_report(void)
 	perf_session__collapse_resort(session);
 	perf_session__output_resort(session, session->events_stats.total);
 	fprintf(stdout, "# Samples: %ld\n#\n", session->events_stats.total);
-	perf_session__fprintf_hists(session, stdout);
+	perf_session__fprintf_hists(session, NULL, false, stdout);
 	if (sort_order == default_sort_order &&
 	    parent_pattern == default_parent_pattern)
 		fprintf(stdout, "#\n# (For a higher level overview, try: perf report --sort comm,dso)\n#\n");
@@ -344,16 +344,6 @@ static const struct option options[] = {
 	OPT_END()
 };
 
-static void sort_entry__setup_elide(struct sort_entry *self,
-				    struct strlist *list,
-				    const char *list_name, FILE *fp)
-{
-	if (list && strlist__nr_entries(list) == 1) {
-		fprintf(fp, "# %s: %s\n", list_name, strlist__entry(list, 0)->s);
-		self->elide = true;
-	}
-}
-
 int cmd_report(int argc, const char **argv, const char *prefix __used)
 {
 	argc = parse_options(argc, argv, options, report_usage, 0);
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 6e416a6..ecf853c 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -454,34 +454,80 @@ static size_t hist_entry_callchain__fprintf(FILE *fp, struct hist_entry *self,
 	return ret;
 }
 
-static size_t hist_entry__fprintf(FILE *fp, struct hist_entry *self,
-				  struct perf_session *session)
+static size_t hist_entry__fprintf(struct hist_entry *self,
+				  struct perf_session *session,
+				  struct perf_session *pair_session,
+				  bool show_displacement,
+				  long displacement, FILE *fp)
 {
 	struct sort_entry *se;
+	u64 count, total;
+	const char *sep = symbol_conf.field_sep;
 	size_t ret;
 
 	if (symbol_conf.exclude_other && !self->parent)
 		return 0;
 
-	if (session->events_stats.total)
-		ret = percent_color_fprintf(fp,
-					    symbol_conf.field_sep ? "%.2f" : "   %6.2f%%",
-					(self->count * 100.0) / session->events_stats.total);
+	if (pair_session) {
+		count = self->pair ? self->pair->count : 0;
+		total = pair_session->events_stats.total;
+	} else {
+		count = self->count;
+		total = session->events_stats.total;
+	}
+
+	if (total)
+		ret = percent_color_fprintf(fp, sep ? "%.2f" : "   %6.2f%%",
+					    (count * 100.0) / total);
 	else
-		ret = fprintf(fp, symbol_conf.field_sep ? "%lld" : "%12lld ", self->count);
+		ret = fprintf(fp, sep ? "%lld" : "%12lld ", count);
 
 	if (symbol_conf.show_nr_samples) {
-		if (symbol_conf.field_sep)
-			fprintf(fp, "%c%lld", *symbol_conf.field_sep, self->count);
+		if (sep)
+			fprintf(fp, "%c%lld", *sep, count);
 		else
-			fprintf(fp, "%11lld", self->count);
+			fprintf(fp, "%11lld", count);
+	}
+
+	if (pair_session) {
+		char bf[32];
+		double old_percent = 0, new_percent = 0, diff;
+
+		if (total > 0)
+			old_percent = (count * 100) / total;
+		if (session->events_stats.total > 0)
+			new_percent = (self->count * 100) / session->events_stats.total;
+
+		diff = old_percent - new_percent;
+
+		if ((u64)diff != 0)
+			snprintf(bf, sizeof(bf), "%+4.2F%%", diff);
+		else
+			snprintf(bf, sizeof(bf), " ");
+
+		if (sep)
+			ret += fprintf(fp, "%c%s", *sep, bf);
+		else
+			ret += fprintf(fp, "%11.11s", bf);
+
+		if (show_displacement) {
+			if (displacement)
+				snprintf(bf, sizeof(bf), "%+4ld", displacement);
+			else
+				snprintf(bf, sizeof(bf), " ");
+
+			if (sep)
+				fprintf(fp, "%c%s", *sep, bf);
+			else
+				fprintf(fp, "%6.6s", bf);
+		}
 	}
 
 	list_for_each_entry(se, &hist_entry__sort_list, list) {
 		if (se->elide)
 			continue;
 
-		fprintf(fp, "%s", symbol_conf.field_sep ?: "  ");
+		fprintf(fp, "%s", sep ?: "  ");
 		ret += se->print(fp, self, se->width ? *se->width : 0);
 	}
 
@@ -504,29 +550,49 @@ static size_t hist_entry__fprintf(FILE *fp, struct hist_entry *self,
 	return ret;
 }
 
-size_t perf_session__fprintf_hists(struct perf_session *self, FILE *fp)
+size_t perf_session__fprintf_hists(struct perf_session *self,
+				   struct perf_session *pair,
+				   bool show_displacement, FILE *fp)
 {
-	struct hist_entry *pos;
 	struct sort_entry *se;
 	struct rb_node *nd;
 	size_t ret = 0;
+	unsigned long position = 1;
+	long displacement = 0;
 	unsigned int width;
+	const char *sep = symbol_conf.field_sep;
 	char *col_width = symbol_conf.col_width_list_str;
 
 	init_rem_hits();
 
-	fprintf(fp, "# Overhead");
+	fprintf(fp, "# %s", pair ? "Baseline" : "Overhead");
+
 	if (symbol_conf.show_nr_samples) {
-		if (symbol_conf.field_sep)
-			fprintf(fp, "%cSamples", *symbol_conf.field_sep);
+		if (sep)
+			fprintf(fp, "%cSamples", *sep);
 		else
 			fputs("  Samples  ", fp);
 	}
+
+	if (pair) {
+		if (sep)
+			ret += fprintf(fp, "%cDelta", *sep);
+		else
+			ret += fprintf(fp, "  Delta    ");
+
+		if (show_displacement) {
+			if (sep)
+				ret += fprintf(fp, "%cDisplacement", *sep);
+			else
+				ret += fprintf(fp, " Displ");
+		}
+	}
+
 	list_for_each_entry(se, &hist_entry__sort_list, list) {
 		if (se->elide)
 			continue;
-		if (symbol_conf.field_sep) {
-			fprintf(fp, "%c%s", *symbol_conf.field_sep, se->header);
+		if (sep) {
+			fprintf(fp, "%c%s", *sep, se->header);
 			continue;
 		}
 		width = strlen(se->header);
@@ -545,12 +611,17 @@ size_t perf_session__fprintf_hists(struct perf_session *self, FILE *fp)
 	}
 	fprintf(fp, "\n");
 
-	if (symbol_conf.field_sep)
+	if (sep)
 		goto print_entries;
 
 	fprintf(fp, "# ........");
 	if (symbol_conf.show_nr_samples)
 		fprintf(fp, " ..........");
+	if (pair) {
+		fprintf(fp, " ..........");
+		if (show_displacement)
+			fprintf(fp, " .....");
+	}
 	list_for_each_entry(se, &hist_entry__sort_list, list) {
 		unsigned int i;
 
@@ -565,14 +636,23 @@ size_t perf_session__fprintf_hists(struct perf_session *self, FILE *fp)
 		for (i = 0; i < width; i++)
 			fprintf(fp, ".");
 	}
-	fprintf(fp, "\n");
 
-	fprintf(fp, "#\n");
+	fprintf(fp, "\n#\n");
 
 print_entries:
 	for (nd = rb_first(&self->hists); nd; nd = rb_next(nd)) {
-		pos = rb_entry(nd, struct hist_entry, rb_node);
-		ret += hist_entry__fprintf(fp, pos, self);
+		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
+
+		if (show_displacement) {
+			if (h->pair != NULL)
+				displacement = ((long)h->pair->position -
+					        (long)position);
+			else
+				displacement = 0;
+			++position;
+		}
+		ret += hist_entry__fprintf(h, self, pair, show_displacement,
+					   displacement, fp);
 	}
 
 	free(rem_sq_bracket);
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index c7ac78d..e5f99b2 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -21,6 +21,7 @@ void hist_entry__free(struct hist_entry *);
 
 void perf_session__output_resort(struct perf_session *self, u64 total_samples);
 void perf_session__collapse_resort(struct perf_session *self);
-size_t perf_session__fprintf_hists(struct perf_session *self, FILE *fp);
-
+size_t perf_session__fprintf_hists(struct perf_session *self,
+				   struct perf_session *pair,
+				   bool show_displacement, FILE *fp);
 #endif	/* __PERF_HIST_H */
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index cff1c31..cb0f327 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -303,3 +303,14 @@ void setup_sorting(const char * const usagestr[], const struct option *opts)
 
 	free(str);
 }
+
+void sort_entry__setup_elide(struct sort_entry *self, struct strlist *list,
+			     const char *list_name, FILE *fp)
+{
+	if (list && strlist__nr_entries(list) == 1) {
+		if (fp != NULL)
+			fprintf(fp, "# %s: %s\n", list_name,
+				strlist__entry(list, 0)->s);
+		self->elide = true;
+	}
+}
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 925f083..753f9ea 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -101,5 +101,7 @@ extern int64_t sort__sym_cmp(struct hist_entry *, struct hist_entry *);
 extern int64_t sort__parent_cmp(struct hist_entry *, struct hist_entry *);
 extern size_t sort__parent_print(FILE *, struct hist_entry *, unsigned int);
 extern int sort_dimension__add(const char *);
+void sort_entry__setup_elide(struct sort_entry *self, struct strlist *list,
+			     const char *list_name, FILE *fp);
 
 #endif	/* __PERF_SORT_H */
-- 
1.6.2.5

