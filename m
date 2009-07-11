Return-Path: <linux-kernel-owner+w=401wt.eu-S1756769AbZGKIb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769AbZGKIb1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 04:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752099AbZGKIbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 04:31:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:34256 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752027AbZGKIbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 04:31:16 -0400
Date: Sat, 11 Jul 2009 08:30:37 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20090711014728.GH3452@ghostprotocols.net>
References: <20090711014728.GH3452@ghostprotocols.net>
Subject: [tip:perfcounters/core] perf report: Adjust column width to the values sampled
Message-ID: <tip-52d422de22b26d96bbdfbc605eb31c2994df6d0b@git.kernel.org>
Git-Commit-ID: 52d422de22b26d96bbdfbc605eb31c2994df6d0b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 11 Jul 2009 08:30:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  52d422de22b26d96bbdfbc605eb31c2994df6d0b
Gitweb:     http://git.kernel.org/tip/52d422de22b26d96bbdfbc605eb31c2994df6d0b
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 10 Jul 2009 22:47:28 -0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 11 Jul 2009 10:24:11 +0200

perf report: Adjust column width to the values sampled

Auto-adjust column width of perf report output to the
longest occuring string length.

Example:

[acme@doppio pahole]$  perf report --sort comm,dso,symbol | head -13

    12.79%   pahole  /usr/lib64/libdw-0.141.so    [.] __libdw_find_attr
     8.90%   pahole  /lib64/libc-2.10.1.so        [.] _int_malloc
     8.68%   pahole  /usr/lib64/libdw-0.141.so    [.] __libdw_form_val_len
     8.15%   pahole  /lib64/libc-2.10.1.so        [.] __GI_strcmp
     6.80%   pahole  /lib64/libc-2.10.1.so        [.] __tsearch
     5.54%   pahole  ./build/libdwarves.so.1.0.0  [.] tag__recode_dwarf_type
[acme@doppio pahole]$

[acme@doppio pahole]$  perf report --sort comm,dso,symbol -d /lib64/libc-2.10.1.so | head -10

    21.92%   pahole  /lib64/libc-2.10.1.so  [.] _int_malloc
    20.08%   pahole  /lib64/libc-2.10.1.so  [.] __GI_strcmp
    16.75%   pahole  /lib64/libc-2.10.1.so  [.] __tsearch
[acme@doppio pahole]$

Also add these extra options to control the new behaviour:

  -w, --field-width

Force each column width to the provided list, for large terminal
readability.

  -t, --field-separator:

Use a special separator character and don't pad with spaces, replacing
all occurances of this separator in symbol names (and other output) with
a '.' character, that thus it's the only non valid separator.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <20090711014728.GH3452@ghostprotocols.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/Documentation/perf-report.txt |   12 ++
 tools/perf/builtin-report.c              |  174 ++++++++++++++++++++++++------
 tools/perf/util/include/linux/kernel.h   |    8 ++
 tools/perf/util/symbol.c                 |    1 +
 tools/perf/util/symbol.h                 |    1 +
 5 files changed, 164 insertions(+), 32 deletions(-)

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 8aa3f8c..05774df 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -33,6 +33,18 @@ OPTIONS
 	Only consider these symbols. CSV that understands
 	file://filename entries.
 
+-w::
+--field-width=::
+	Force each column width to the provided list, for large terminal
+	readability.
+
+-t::
+--field-separator=::
+
+	Use a special separator character and don't pad with spaces, replacing
+	all occurances of this separator in symbol names (and other output)
+	with a '.' character, that thus it's the only non valid separator.
+
 SEE ALSO
 --------
 linkperf:perf-stat[1]
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 4e5cc26..740da43 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -33,8 +33,10 @@ static char		*vmlinux = NULL;
 
 static char		default_sort_order[] = "comm,dso";
 static char		*sort_order = default_sort_order;
-static char		*dso_list_str, *comm_list_str, *sym_list_str;
+static char		*dso_list_str, *comm_list_str, *sym_list_str,
+			*col_width_list_str;
 static struct strlist	*dso_list, *comm_list, *sym_list;
+static char		*field_sep;
 
 static int		input;
 static int		show_mask = SHOW_KERNEL | SHOW_USER | SHOW_HV;
@@ -129,6 +131,33 @@ typedef union event_union {
 	struct read_event		read;
 } event_t;
 
+static int repsep_fprintf(FILE *fp, const char *fmt, ...)
+{
+	int n;
+	va_list ap;
+
+	va_start(ap, fmt);
+	if (!field_sep)
+		n = vfprintf(fp, fmt, ap);
+	else {
+		char *bf = NULL;
+		n = vasprintf(&bf, fmt, ap);
+		if (n > 0) {
+			char *sep = bf;
+			while (1) {
+				sep = strchr(sep, *field_sep);
+				if (sep == NULL)
+					break;
+				*sep = '.';
+			}
+		}
+		fputs(bf, fp);
+		free(bf);
+	}
+	va_end(ap);
+	return n;
+}
+
 static LIST_HEAD(dsos);
 static struct dso *kernel_dso;
 static struct dso *vdso;
@@ -360,12 +389,28 @@ static struct thread *thread__new(pid_t pid)
 	return self;
 }
 
+static unsigned int dsos__col_width,
+		    comms__col_width,
+		    threads__col_width;
+
 static int thread__set_comm(struct thread *self, const char *comm)
 {
 	if (self->comm)
 		free(self->comm);
 	self->comm = strdup(comm);
-	return self->comm ? 0 : -ENOMEM;
+	if (!self->comm)
+		return -ENOMEM;
+
+	if (!col_width_list_str && !field_sep &&
+	    (!comm_list || strlist__has_entry(comm_list, comm))) {
+		unsigned int slen = strlen(comm);
+		if (slen > comms__col_width) {
+			comms__col_width = slen;
+			threads__col_width = slen + 6;
+		}
+	}
+
+	return 0;
 }
 
 static size_t thread__fprintf(struct thread *self, FILE *fp)
@@ -536,7 +581,8 @@ struct sort_entry {
 
 	int64_t (*cmp)(struct hist_entry *, struct hist_entry *);
 	int64_t (*collapse)(struct hist_entry *, struct hist_entry *);
-	size_t	(*print)(FILE *fp, struct hist_entry *);
+	size_t	(*print)(FILE *fp, struct hist_entry *, unsigned int width);
+	unsigned int *width;
 };
 
 static int64_t cmp_null(void *l, void *r)
@@ -558,15 +604,17 @@ sort__thread_cmp(struct hist_entry *left, struct hist_entry *right)
 }
 
 static size_t
-sort__thread_print(FILE *fp, struct hist_entry *self)
+sort__thread_print(FILE *fp, struct hist_entry *self, unsigned int width)
 {
-	return fprintf(fp, "%16s:%5d", self->thread->comm ?: "", self->thread->pid);
+	return repsep_fprintf(fp, "%*s:%5d", width - 6,
+			      self->thread->comm ?: "", self->thread->pid);
 }
 
 static struct sort_entry sort_thread = {
-	.header = "         Command:  Pid",
+	.header = "Command:  Pid",
 	.cmp	= sort__thread_cmp,
 	.print	= sort__thread_print,
+	.width	= &threads__col_width,
 };
 
 /* --sort comm */
@@ -590,16 +638,17 @@ sort__comm_collapse(struct hist_entry *left, struct hist_entry *right)
 }
 
 static size_t
-sort__comm_print(FILE *fp, struct hist_entry *self)
+sort__comm_print(FILE *fp, struct hist_entry *self, unsigned int width)
 {
-	return fprintf(fp, "%16s", self->thread->comm);
+	return repsep_fprintf(fp, "%*s", width, self->thread->comm);
 }
 
 static struct sort_entry sort_comm = {
-	.header		= "         Command",
+	.header		= "Command",
 	.cmp		= sort__comm_cmp,
 	.collapse	= sort__comm_collapse,
 	.print		= sort__comm_print,
+	.width		= &comms__col_width,
 };
 
 /* --sort dso */
@@ -617,18 +666,19 @@ sort__dso_cmp(struct hist_entry *left, struct hist_entry *right)
 }
 
 static size_t
-sort__dso_print(FILE *fp, struct hist_entry *self)
+sort__dso_print(FILE *fp, struct hist_entry *self, unsigned int width)
 {
 	if (self->dso)
-		return fprintf(fp, "%-25s", self->dso->name);
+		return repsep_fprintf(fp, "%-*s", width, self->dso->name);
 
-	return fprintf(fp, "%016llx         ", (u64)self->ip);
+	return repsep_fprintf(fp, "%*llx", width, (u64)self->ip);
 }
 
 static struct sort_entry sort_dso = {
-	.header = "Shared Object            ",
+	.header = "Shared Object",
 	.cmp	= sort__dso_cmp,
 	.print	= sort__dso_print,
+	.width	= &dsos__col_width,
 };
 
 /* --sort symbol */
@@ -648,22 +698,23 @@ sort__sym_cmp(struct hist_entry *left, struct hist_entry *right)
 }
 
 static size_t
-sort__sym_print(FILE *fp, struct hist_entry *self)
+sort__sym_print(FILE *fp, struct hist_entry *self, unsigned int width __used)
 {
 	size_t ret = 0;
 
 	if (verbose)
-		ret += fprintf(fp, "%#018llx  ", (u64)self->ip);
+		ret += repsep_fprintf(fp, "%#018llx  ", (u64)self->ip);
 
 	if (self->sym) {
-		ret += fprintf(fp, "[%c] %s",
+		ret += repsep_fprintf(fp, "[%c] %s",
 			self->dso == kernel_dso ? 'k' :
 			self->dso == hypervisor_dso ? 'h' : '.', self->sym->name);
 
 		if (self->sym->module)
-			ret += fprintf(fp, "\t[%s]", self->sym->module->name);
+			ret += repsep_fprintf(fp, "\t[%s]",
+					     self->sym->module->name);
 	} else {
-		ret += fprintf(fp, "%#016llx", (u64)self->ip);
+		ret += repsep_fprintf(fp, "%#016llx", (u64)self->ip);
 	}
 
 	return ret;
@@ -690,19 +741,19 @@ sort__parent_cmp(struct hist_entry *left, struct hist_entry *right)
 }
 
 static size_t
-sort__parent_print(FILE *fp, struct hist_entry *self)
+sort__parent_print(FILE *fp, struct hist_entry *self, unsigned int width)
 {
-	size_t ret = 0;
-
-	ret += fprintf(fp, "%-20s", self->parent ? self->parent->name : "[other]");
-
-	return ret;
+	return repsep_fprintf(fp, "%-*s", width,
+			      self->parent ? self->parent->name : "[other]");
 }
 
+static unsigned int parent_symbol__col_width;
+
 static struct sort_entry sort_parent = {
-	.header = "Parent symbol       ",
+	.header = "Parent symbol",
 	.cmp	= sort__parent_cmp,
 	.print	= sort__parent_print,
+	.width	= &parent_symbol__col_width,
 };
 
 static int sort__need_collapse = 0;
@@ -967,17 +1018,18 @@ hist_entry__fprintf(FILE *fp, struct hist_entry *self, u64 total_samples)
 		return 0;
 
 	if (total_samples)
-		ret = percent_color_fprintf(fp, "   %6.2f%%",
-				(self->count * 100.0) / total_samples);
+		ret = percent_color_fprintf(fp,
+					    field_sep ? "%.2f" : "   %6.2f%%",
+					(self->count * 100.0) / total_samples);
 	else
-		ret = fprintf(fp, "%12Ld ", self->count);
+		ret = fprintf(fp, field_sep ? "%lld" : "%12lld ", self->count);
 
 	list_for_each_entry(se, &hist_entry__sort_list, list) {
 		if (exclude_other && (se == &sort_parent))
 			continue;
 
-		fprintf(fp, "  ");
-		ret += se->print(fp, self);
+		fprintf(fp, "%s", field_sep ?: "  ");
+		ret += se->print(fp, self, se->width ? *se->width : 0);
 	}
 
 	ret += fprintf(fp, "\n");
@@ -992,6 +1044,18 @@ hist_entry__fprintf(FILE *fp, struct hist_entry *self, u64 total_samples)
  *
  */
 
+static void dso__calc_col_width(struct dso *self)
+{
+	if (!col_width_list_str && !field_sep &&
+	    (!dso_list || strlist__has_entry(dso_list, self->name))) {
+		unsigned int slen = strlen(self->name);
+		if (slen > dsos__col_width)
+			dsos__col_width = slen;
+	}
+
+	self->slen_calculated = 1;
+}
+
 static struct symbol *
 resolve_symbol(struct thread *thread, struct map **mapp,
 	       struct dso **dsop, u64 *ipp)
@@ -1011,6 +1075,14 @@ resolve_symbol(struct thread *thread, struct map **mapp,
 
 	map = thread__find_map(thread, ip);
 	if (map != NULL) {
+		/*
+		 * We have to do this here as we may have a dso
+		 * with no symbol hit that has a name longer than
+		 * the ones with symbols sampled.
+		 */
+		if (!map->dso->slen_calculated)
+			dso__calc_col_width(map->dso);
+
 		if (mapp)
 			*mapp = map;
 got_map:
@@ -1282,6 +1354,8 @@ static size_t output__fprintf(FILE *fp, u64 total_samples)
 	struct sort_entry *se;
 	struct rb_node *nd;
 	size_t ret = 0;
+	unsigned int width;
+	char *col_width = col_width_list_str;
 
 	fprintf(fp, "\n");
 	fprintf(fp, "#\n");
@@ -1292,10 +1366,29 @@ static size_t output__fprintf(FILE *fp, u64 total_samples)
 	list_for_each_entry(se, &hist_entry__sort_list, list) {
 		if (exclude_other && (se == &sort_parent))
 			continue;
-		fprintf(fp, "  %s", se->header);
+		if (field_sep) {
+			fprintf(fp, "%c%s", *field_sep, se->header);
+			continue;
+		}
+		width = strlen(se->header);
+		if (se->width) {
+			if (col_width_list_str) {
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
 	}
 	fprintf(fp, "\n");
 
+	if (field_sep)
+		goto print_entries;
+
 	fprintf(fp, "# ........");
 	list_for_each_entry(se, &hist_entry__sort_list, list) {
 		unsigned int i;
@@ -1304,13 +1397,18 @@ static size_t output__fprintf(FILE *fp, u64 total_samples)
 			continue;
 
 		fprintf(fp, "  ");
-		for (i = 0; i < strlen(se->header); i++)
+		if (se->width)
+			width = *se->width;
+		else
+			width = strlen(se->header);
+		for (i = 0; i < width; i++)
 			fprintf(fp, ".");
 	}
 	fprintf(fp, "\n");
 
 	fprintf(fp, "#\n");
 
+print_entries:
 	for (nd = rb_first(&output_hists); nd; nd = rb_next(nd)) {
 		pos = rb_entry(nd, struct hist_entry, rb_node);
 		ret += hist_entry__fprintf(fp, pos, total_samples);
@@ -1900,6 +1998,12 @@ static const struct option options[] = {
 		   "only consider symbols in these comms"),
 	OPT_STRING('S', "symbols", &sym_list_str, "symbol[,symbol...]",
 		   "only consider these symbols"),
+	OPT_STRING('w', "column-widths", &col_width_list_str,
+		   "width[,width...]",
+		   "don't try to adjust column width, use these fixed values"),
+	OPT_STRING('t', "field-separator", &field_sep, "separator",
+		   "separator for columns, no spaces will be added between "
+		   "columns '.' is reserved."),
 	OPT_END()
 };
 
@@ -1956,6 +2060,12 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 	setup_list(&comm_list, comm_list_str, "comm");
 	setup_list(&sym_list, sym_list_str, "symbol");
 
+	if (field_sep && *field_sep == '.') {
+		fputs("'.' is the only non valid --field-separator argument\n",
+		      stderr);
+		exit(129);
+	}
+
 	setup_pager();
 
 	return __cmd_report();
diff --git a/tools/perf/util/include/linux/kernel.h b/tools/perf/util/include/linux/kernel.h
index 99c1b3d..a6b8739 100644
--- a/tools/perf/util/include/linux/kernel.h
+++ b/tools/perf/util/include/linux/kernel.h
@@ -18,4 +18,12 @@
 	(type *)((char *)__mptr - offsetof(type, member)); })
 #endif
 
+#ifndef max
+#define max(x, y) ({				\
+	typeof(x) _max1 = (x);			\
+	typeof(y) _max2 = (y);			\
+	(void) (&_max1 == &_max2);		\
+	_max1 > _max2 ? _max1 : _max2; })
+#endif
+
 #endif
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 4683b67..8efe7e4 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -65,6 +65,7 @@ struct dso *dso__new(const char *name, unsigned int sym_priv_size)
 		self->syms = RB_ROOT;
 		self->sym_priv_size = sym_priv_size;
 		self->find_symbol = dso__find_symbol;
+		self->slen_calculated = 0;
 	}
 
 	return self;
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 7918cff..2f92b21 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -25,6 +25,7 @@ struct dso {
 	struct symbol    *(*find_symbol)(struct dso *, u64 ip);
 	unsigned int	 sym_priv_size;
 	unsigned char	 adjust_symbols;
+	unsigned char	 slen_calculated;
 	char		 name[0];
 };
 
