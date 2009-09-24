Return-Path: <linux-kernel-owner+w=401wt.eu-S1754557AbZIXTho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557AbZIXTho (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 15:37:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754491AbZIXThn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 15:37:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:40200 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754527AbZIXThV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 15:37:21 -0400
Date: Thu, 24 Sep 2009 19:37:05 GMT
From: tip-bot for John Kacur <jkacur@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jkacur@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jkacur@redhat.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <alpine.LFD.2.00.0909241758390.11383@localhost.localdomain>
References: <alpine.LFD.2.00.0909241758390.11383@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Create util/sort.and use it
Message-ID: <tip-dd68ada2d417e57b848822a1407b5317a54136c5@git.kernel.org>
Git-Commit-ID: dd68ada2d417e57b848822a1407b5317a54136c5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 24 Sep 2009 19:37:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dd68ada2d417e57b848822a1407b5317a54136c5
Gitweb:     http://git.kernel.org/tip/dd68ada2d417e57b848822a1407b5317a54136c5
Author:     John Kacur <jkacur@redhat.com>
AuthorDate: Thu, 24 Sep 2009 18:02:49 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 24 Sep 2009 21:27:52 +0200

perf tools: Create util/sort.and use it

Create util/sort.[ch] and move common functionality for
builtin-report.c and builtin-annotate.c there, and make use of it.

Signed-off-by: John Kacur <jkacur@redhat.com>
LKML-Reference: <alpine.LFD.2.00.0909241758390.11383@localhost.localdomain>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/Makefile           |    2 +
 tools/perf/builtin-annotate.c |  211 +---------------------------
 tools/perf/builtin-report.c   |  307 +----------------------------------------
 tools/perf/util/sort.c        |  268 +++++++++++++++++++++++++++++++++++
 tools/perf/util/sort.h        |   93 +++++++++++++
 5 files changed, 373 insertions(+), 508 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index b5f1953..0a9e5ae 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -339,6 +339,7 @@ LIB_H += util/symbol.h
 LIB_H += util/module.h
 LIB_H += util/color.h
 LIB_H += util/values.h
+LIB_H += util/sort.h
 
 LIB_OBJS += util/abspath.o
 LIB_OBJS += util/alias.o
@@ -374,6 +375,7 @@ LIB_OBJS += util/trace-event-parse.o
 LIB_OBJS += util/trace-event-read.o
 LIB_OBJS += util/trace-event-info.o
 LIB_OBJS += util/svghelper.o
+LIB_OBJS += util/sort.o
 
 BUILTIN_OBJS += builtin-annotate.o
 BUILTIN_OBJS += builtin-help.o
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index a330873..059c565 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -22,12 +22,10 @@
 #include "util/parse-options.h"
 #include "util/parse-events.h"
 #include "util/thread.h"
+#include "util/sort.h"
 
 static char		const *input_name = "perf.data";
 
-static char		default_sort_order[] = "comm,symbol";
-static char		*sort_order = default_sort_order;
-
 static int		force;
 static int		input;
 static int		show_mask = SHOW_KERNEL | SHOW_USER | SHOW_HV;
@@ -55,207 +53,6 @@ struct sym_ext {
 
 static struct rb_root hist;
 
-struct hist_entry {
-	struct rb_node	 rb_node;
-
-	struct thread	 *thread;
-	struct map	 *map;
-	struct dso	 *dso;
-	struct symbol	 *sym;
-	u64	 ip;
-	char		 level;
-
-	uint32_t	 count;
-};
-
-/*
- * configurable sorting bits
- */
-
-struct sort_entry {
-	struct list_head list;
-
-	const char *header;
-
-	int64_t (*cmp)(struct hist_entry *, struct hist_entry *);
-	int64_t (*collapse)(struct hist_entry *, struct hist_entry *);
-	size_t	(*print)(FILE *fp, struct hist_entry *);
-};
-
-static int64_t cmp_null(void *l, void *r)
-{
-	if (!l && !r)
-		return 0;
-	else if (!l)
-		return -1;
-	else
-		return 1;
-}
-
-/* --sort pid */
-
-static int64_t
-sort__thread_cmp(struct hist_entry *left, struct hist_entry *right)
-{
-	return right->thread->pid - left->thread->pid;
-}
-
-static size_t
-sort__thread_print(FILE *fp, struct hist_entry *self)
-{
-	return fprintf(fp, "%16s:%5d", self->thread->comm ?: "", self->thread->pid);
-}
-
-static struct sort_entry sort_thread = {
-	.header = "         Command:  Pid",
-	.cmp	= sort__thread_cmp,
-	.print	= sort__thread_print,
-};
-
-/* --sort comm */
-
-static int64_t
-sort__comm_cmp(struct hist_entry *left, struct hist_entry *right)
-{
-	return right->thread->pid - left->thread->pid;
-}
-
-static int64_t
-sort__comm_collapse(struct hist_entry *left, struct hist_entry *right)
-{
-	char *comm_l = left->thread->comm;
-	char *comm_r = right->thread->comm;
-
-	if (!comm_l || !comm_r)
-		return cmp_null(comm_l, comm_r);
-
-	return strcmp(comm_l, comm_r);
-}
-
-static size_t
-sort__comm_print(FILE *fp, struct hist_entry *self)
-{
-	return fprintf(fp, "%16s", self->thread->comm);
-}
-
-static struct sort_entry sort_comm = {
-	.header		= "         Command",
-	.cmp		= sort__comm_cmp,
-	.collapse	= sort__comm_collapse,
-	.print		= sort__comm_print,
-};
-
-/* --sort dso */
-
-static int64_t
-sort__dso_cmp(struct hist_entry *left, struct hist_entry *right)
-{
-	struct dso *dso_l = left->dso;
-	struct dso *dso_r = right->dso;
-
-	if (!dso_l || !dso_r)
-		return cmp_null(dso_l, dso_r);
-
-	return strcmp(dso_l->name, dso_r->name);
-}
-
-static size_t
-sort__dso_print(FILE *fp, struct hist_entry *self)
-{
-	if (self->dso)
-		return fprintf(fp, "%-25s", self->dso->name);
-
-	return fprintf(fp, "%016llx         ", (u64)self->ip);
-}
-
-static struct sort_entry sort_dso = {
-	.header = "Shared Object            ",
-	.cmp	= sort__dso_cmp,
-	.print	= sort__dso_print,
-};
-
-/* --sort symbol */
-
-static int64_t
-sort__sym_cmp(struct hist_entry *left, struct hist_entry *right)
-{
-	u64 ip_l, ip_r;
-
-	if (left->sym == right->sym)
-		return 0;
-
-	ip_l = left->sym ? left->sym->start : left->ip;
-	ip_r = right->sym ? right->sym->start : right->ip;
-
-	return (int64_t)(ip_r - ip_l);
-}
-
-static size_t
-sort__sym_print(FILE *fp, struct hist_entry *self)
-{
-	size_t ret = 0;
-
-	if (verbose)
-		ret += fprintf(fp, "%#018llx  ", (u64)self->ip);
-
-	if (self->sym) {
-		ret += fprintf(fp, "[%c] %s",
-			self->dso == kernel_dso ? 'k' : '.', self->sym->name);
-	} else {
-		ret += fprintf(fp, "%#016llx", (u64)self->ip);
-	}
-
-	return ret;
-}
-
-static struct sort_entry sort_sym = {
-	.header = "Symbol",
-	.cmp	= sort__sym_cmp,
-	.print	= sort__sym_print,
-};
-
-static int sort__need_collapse = 0;
-
-struct sort_dimension {
-	const char		*name;
-	struct sort_entry	*entry;
-	int			taken;
-};
-
-static struct sort_dimension sort_dimensions[] = {
-	{ .name = "pid",	.entry = &sort_thread,	},
-	{ .name = "comm",	.entry = &sort_comm,	},
-	{ .name = "dso",	.entry = &sort_dso,	},
-	{ .name = "symbol",	.entry = &sort_sym,	},
-};
-
-static LIST_HEAD(hist_entry__sort_list);
-
-static int sort_dimension__add(char *tok)
-{
-	unsigned int i;
-
-	for (i = 0; i < ARRAY_SIZE(sort_dimensions); i++) {
-		struct sort_dimension *sd = &sort_dimensions[i];
-
-		if (sd->taken)
-			continue;
-
-		if (strncasecmp(tok, sd->name, strlen(tok)))
-			continue;
-
-		if (sd->entry->collapse)
-			sort__need_collapse = 1;
-
-		list_add_tail(&sd->entry->list, &hist_entry__sort_list);
-		sd->taken = 1;
-
-		return 0;
-	}
-
-	return -ESRCH;
-}
-
 static int64_t
 hist_entry__cmp(struct hist_entry *left, struct hist_entry *right)
 {
@@ -1137,5 +934,11 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __used)
 
 	setup_pager();
 
+	if (field_sep && *field_sep == '.') {
+		fputs("'.' is the only non valid --field-separator argument\n",
+				stderr);
+		exit(129);
+	}
+
 	return __cmd_annotate();
 }
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 19669c2..7b43504 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -27,15 +27,13 @@
 #include "util/parse-events.h"
 
 #include "util/thread.h"
+#include "util/sort.h"
 
 static char		const *input_name = "perf.data";
 
-static char		default_sort_order[] = "comm,dso,symbol";
-static char		*sort_order = default_sort_order;
 static char		*dso_list_str, *comm_list_str, *sym_list_str,
 			*col_width_list_str;
 static struct strlist	*dso_list, *comm_list, *sym_list;
-static char		*field_sep;
 
 static int		force;
 static int		input;
@@ -53,10 +51,6 @@ static char		*pretty_printing_style = default_pretty_printing_style;
 static unsigned long	page_size;
 static unsigned long	mmap_window = 32;
 
-static char		default_parent_pattern[] = "^sys_|^do_page_fault";
-static char		*parent_pattern = default_parent_pattern;
-static regex_t		parent_regex;
-
 static int		exclude_other = 1;
 
 static char		callchain_default_opt[] = "fractal,0.5";
@@ -80,304 +74,8 @@ struct callchain_param	callchain_param = {
 
 static u64		sample_type;
 
-static int repsep_fprintf(FILE *fp, const char *fmt, ...)
-{
-	int n;
-	va_list ap;
-
-	va_start(ap, fmt);
-	if (!field_sep)
-		n = vfprintf(fp, fmt, ap);
-	else {
-		char *bf = NULL;
-		n = vasprintf(&bf, fmt, ap);
-		if (n > 0) {
-			char *sep = bf;
-
-			while (1) {
-				sep = strchr(sep, *field_sep);
-				if (sep == NULL)
-					break;
-				*sep = '.';
-			}
-		}
-		fputs(bf, fp);
-		free(bf);
-	}
-	va_end(ap);
-	return n;
-}
-
-static unsigned int dsos__col_width,
-		    comms__col_width,
-		    threads__col_width;
-
-/*
- * histogram, sorted on item, collects counts
- */
-
 static struct rb_root hist;
 
-struct hist_entry {
-	struct rb_node		rb_node;
-
-	struct thread		*thread;
-	struct map		*map;
-	struct dso		*dso;
-	struct symbol		*sym;
-	struct symbol		*parent;
-	u64			ip;
-	char			level;
-	struct callchain_node	callchain;
-	struct rb_root		sorted_chain;
-
-	u64			count;
-};
-
-/*
- * configurable sorting bits
- */
-
-struct sort_entry {
-	struct list_head list;
-
-	const char *header;
-
-	int64_t (*cmp)(struct hist_entry *, struct hist_entry *);
-	int64_t (*collapse)(struct hist_entry *, struct hist_entry *);
-	size_t	(*print)(FILE *fp, struct hist_entry *, unsigned int width);
-	unsigned int *width;
-	bool	elide;
-};
-
-static int64_t cmp_null(void *l, void *r)
-{
-	if (!l && !r)
-		return 0;
-	else if (!l)
-		return -1;
-	else
-		return 1;
-}
-
-/* --sort pid */
-
-static int64_t
-sort__thread_cmp(struct hist_entry *left, struct hist_entry *right)
-{
-	return right->thread->pid - left->thread->pid;
-}
-
-static size_t
-sort__thread_print(FILE *fp, struct hist_entry *self, unsigned int width)
-{
-	return repsep_fprintf(fp, "%*s:%5d", width - 6,
-			      self->thread->comm ?: "", self->thread->pid);
-}
-
-static struct sort_entry sort_thread = {
-	.header = "Command:  Pid",
-	.cmp	= sort__thread_cmp,
-	.print	= sort__thread_print,
-	.width	= &threads__col_width,
-};
-
-/* --sort comm */
-
-static int64_t
-sort__comm_cmp(struct hist_entry *left, struct hist_entry *right)
-{
-	return right->thread->pid - left->thread->pid;
-}
-
-static int64_t
-sort__comm_collapse(struct hist_entry *left, struct hist_entry *right)
-{
-	char *comm_l = left->thread->comm;
-	char *comm_r = right->thread->comm;
-
-	if (!comm_l || !comm_r)
-		return cmp_null(comm_l, comm_r);
-
-	return strcmp(comm_l, comm_r);
-}
-
-static size_t
-sort__comm_print(FILE *fp, struct hist_entry *self, unsigned int width)
-{
-	return repsep_fprintf(fp, "%*s", width, self->thread->comm);
-}
-
-static struct sort_entry sort_comm = {
-	.header		= "Command",
-	.cmp		= sort__comm_cmp,
-	.collapse	= sort__comm_collapse,
-	.print		= sort__comm_print,
-	.width		= &comms__col_width,
-};
-
-/* --sort dso */
-
-static int64_t
-sort__dso_cmp(struct hist_entry *left, struct hist_entry *right)
-{
-	struct dso *dso_l = left->dso;
-	struct dso *dso_r = right->dso;
-
-	if (!dso_l || !dso_r)
-		return cmp_null(dso_l, dso_r);
-
-	return strcmp(dso_l->name, dso_r->name);
-}
-
-static size_t
-sort__dso_print(FILE *fp, struct hist_entry *self, unsigned int width)
-{
-	if (self->dso)
-		return repsep_fprintf(fp, "%-*s", width, self->dso->name);
-
-	return repsep_fprintf(fp, "%*llx", width, (u64)self->ip);
-}
-
-static struct sort_entry sort_dso = {
-	.header = "Shared Object",
-	.cmp	= sort__dso_cmp,
-	.print	= sort__dso_print,
-	.width	= &dsos__col_width,
-};
-
-/* --sort symbol */
-
-static int64_t
-sort__sym_cmp(struct hist_entry *left, struct hist_entry *right)
-{
-	u64 ip_l, ip_r;
-
-	if (left->sym == right->sym)
-		return 0;
-
-	ip_l = left->sym ? left->sym->start : left->ip;
-	ip_r = right->sym ? right->sym->start : right->ip;
-
-	return (int64_t)(ip_r - ip_l);
-}
-
-static size_t
-sort__sym_print(FILE *fp, struct hist_entry *self, unsigned int width __used)
-{
-	size_t ret = 0;
-
-	if (verbose)
-		ret += repsep_fprintf(fp, "%#018llx %c ", (u64)self->ip,
-				      dso__symtab_origin(self->dso));
-
-	ret += repsep_fprintf(fp, "[%c] ", self->level);
-	if (self->sym) {
-		ret += repsep_fprintf(fp, "%s", self->sym->name);
-
-		if (self->sym->module)
-			ret += repsep_fprintf(fp, "\t[%s]",
-					     self->sym->module->name);
-	} else {
-		ret += repsep_fprintf(fp, "%#016llx", (u64)self->ip);
-	}
-
-	return ret;
-}
-
-static struct sort_entry sort_sym = {
-	.header = "Symbol",
-	.cmp	= sort__sym_cmp,
-	.print	= sort__sym_print,
-};
-
-/* --sort parent */
-
-static int64_t
-sort__parent_cmp(struct hist_entry *left, struct hist_entry *right)
-{
-	struct symbol *sym_l = left->parent;
-	struct symbol *sym_r = right->parent;
-
-	if (!sym_l || !sym_r)
-		return cmp_null(sym_l, sym_r);
-
-	return strcmp(sym_l->name, sym_r->name);
-}
-
-static size_t
-sort__parent_print(FILE *fp, struct hist_entry *self, unsigned int width)
-{
-	return repsep_fprintf(fp, "%-*s", width,
-			      self->parent ? self->parent->name : "[other]");
-}
-
-static unsigned int parent_symbol__col_width;
-
-static struct sort_entry sort_parent = {
-	.header = "Parent symbol",
-	.cmp	= sort__parent_cmp,
-	.print	= sort__parent_print,
-	.width	= &parent_symbol__col_width,
-};
-
-static int sort__need_collapse = 0;
-static int sort__has_parent = 0;
-
-struct sort_dimension {
-	const char		*name;
-	struct sort_entry	*entry;
-	int			taken;
-};
-
-static struct sort_dimension sort_dimensions[] = {
-	{ .name = "pid",	.entry = &sort_thread,	},
-	{ .name = "comm",	.entry = &sort_comm,	},
-	{ .name = "dso",	.entry = &sort_dso,	},
-	{ .name = "symbol",	.entry = &sort_sym,	},
-	{ .name = "parent",	.entry = &sort_parent,	},
-};
-
-static LIST_HEAD(hist_entry__sort_list);
-
-static int sort_dimension__add(const char *tok)
-{
-	unsigned int i;
-
-	for (i = 0; i < ARRAY_SIZE(sort_dimensions); i++) {
-		struct sort_dimension *sd = &sort_dimensions[i];
-
-		if (sd->taken)
-			continue;
-
-		if (strncasecmp(tok, sd->name, strlen(tok)))
-			continue;
-
-		if (sd->entry->collapse)
-			sort__need_collapse = 1;
-
-		if (sd->entry == &sort_parent) {
-			int ret = regcomp(&parent_regex, parent_pattern, REG_EXTENDED);
-			if (ret) {
-				char err[BUFSIZ];
-
-				regerror(ret, &parent_regex, err, sizeof(err));
-				fprintf(stderr, "Invalid regex: %s\n%s",
-					parent_pattern, err);
-				exit(-1);
-			}
-			sort__has_parent = 1;
-		}
-
-		list_add_tail(&sd->entry->list, &hist_entry__sort_list);
-		sd->taken = 1;
-
-		return 0;
-	}
-
-	return -ESRCH;
-}
-
 static int64_t
 hist_entry__cmp(struct hist_entry *left, struct hist_entry *right)
 {
@@ -1606,7 +1304,8 @@ setup:
 	return 0;
 }
 
-static const char * const report_usage[] = {
+//static const char * const report_usage[] = {
+const char * const report_usage[] = {
 	"perf report [<options>] <command>",
 	NULL
 };
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
new file mode 100644
index 0000000..50e75ab
--- /dev/null
+++ b/tools/perf/util/sort.c
@@ -0,0 +1,268 @@
+#include "sort.h"
+
+regex_t		parent_regex;
+char		default_parent_pattern[] = "^sys_|^do_page_fault";
+char		*parent_pattern = default_parent_pattern;
+char		default_sort_order[] = "comm,dso,symbol";
+char		*sort_order = default_sort_order;
+int sort__need_collapse = 0;
+int sort__has_parent = 0;
+
+unsigned int dsos__col_width;
+unsigned int comms__col_width;
+unsigned int threads__col_width;
+static unsigned int parent_symbol__col_width;
+char * field_sep;
+
+LIST_HEAD(hist_entry__sort_list);
+
+struct sort_entry sort_thread = {
+	.header = "Command:  Pid",
+	.cmp	= sort__thread_cmp,
+	.print	= sort__thread_print,
+	.width	= &threads__col_width,
+};
+
+struct sort_entry sort_comm = {
+	.header		= "Command",
+	.cmp		= sort__comm_cmp,
+	.collapse	= sort__comm_collapse,
+	.print		= sort__comm_print,
+	.width		= &comms__col_width,
+};
+
+struct sort_entry sort_dso = {
+	.header = "Shared Object",
+	.cmp	= sort__dso_cmp,
+	.print	= sort__dso_print,
+	.width	= &dsos__col_width,
+};
+
+struct sort_entry sort_sym = {
+	.header = "Symbol",
+	.cmp	= sort__sym_cmp,
+	.print	= sort__sym_print,
+};
+
+struct sort_entry sort_parent = {
+	.header = "Parent symbol",
+	.cmp	= sort__parent_cmp,
+	.print	= sort__parent_print,
+	.width	= &parent_symbol__col_width,
+};
+
+struct sort_dimension {
+	const char		*name;
+	struct sort_entry	*entry;
+	int			taken;
+};
+
+static struct sort_dimension sort_dimensions[] = {
+	{ .name = "pid",	.entry = &sort_thread,	},
+	{ .name = "comm",	.entry = &sort_comm,	},
+	{ .name = "dso",	.entry = &sort_dso,	},
+	{ .name = "symbol",	.entry = &sort_sym,	},
+	{ .name = "parent",	.entry = &sort_parent,	},
+};
+
+int64_t cmp_null(void *l, void *r)
+{
+	if (!l && !r)
+		return 0;
+	else if (!l)
+		return -1;
+	else
+		return 1;
+}
+
+/* --sort pid */
+
+int64_t
+sort__thread_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	return right->thread->pid - left->thread->pid;
+}
+
+int repsep_fprintf(FILE *fp, const char *fmt, ...)
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
+
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
+size_t
+sort__thread_print(FILE *fp, struct hist_entry *self, unsigned int width)
+{
+	return repsep_fprintf(fp, "%*s:%5d", width - 6,
+			      self->thread->comm ?: "", self->thread->pid);
+}
+
+size_t
+sort__comm_print(FILE *fp, struct hist_entry *self, unsigned int width)
+{
+	return repsep_fprintf(fp, "%*s", width, self->thread->comm);
+}
+
+/* --sort dso */
+
+int64_t
+sort__dso_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	struct dso *dso_l = left->dso;
+	struct dso *dso_r = right->dso;
+
+	if (!dso_l || !dso_r)
+		return cmp_null(dso_l, dso_r);
+
+	return strcmp(dso_l->name, dso_r->name);
+}
+
+size_t
+sort__dso_print(FILE *fp, struct hist_entry *self, unsigned int width)
+{
+	if (self->dso)
+		return repsep_fprintf(fp, "%-*s", width, self->dso->name);
+
+	return repsep_fprintf(fp, "%*llx", width, (u64)self->ip);
+}
+
+/* --sort symbol */
+
+int64_t
+sort__sym_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	u64 ip_l, ip_r;
+
+	if (left->sym == right->sym)
+		return 0;
+
+	ip_l = left->sym ? left->sym->start : left->ip;
+	ip_r = right->sym ? right->sym->start : right->ip;
+
+	return (int64_t)(ip_r - ip_l);
+}
+
+
+size_t
+sort__sym_print(FILE *fp, struct hist_entry *self, unsigned int width __used)
+{
+	size_t ret = 0;
+
+	if (verbose)
+		ret += repsep_fprintf(fp, "%#018llx %c ", (u64)self->ip,
+				      dso__symtab_origin(self->dso));
+
+	ret += repsep_fprintf(fp, "[%c] ", self->level);
+	if (self->sym) {
+		ret += repsep_fprintf(fp, "%s", self->sym->name);
+
+		if (self->sym->module)
+			ret += repsep_fprintf(fp, "\t[%s]",
+					     self->sym->module->name);
+	} else {
+		ret += repsep_fprintf(fp, "%#016llx", (u64)self->ip);
+	}
+
+	return ret;
+}
+
+/* --sort comm */
+
+int64_t
+sort__comm_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	return right->thread->pid - left->thread->pid;
+}
+
+int64_t
+sort__comm_collapse(struct hist_entry *left, struct hist_entry *right)
+{
+	char *comm_l = left->thread->comm;
+	char *comm_r = right->thread->comm;
+
+	if (!comm_l || !comm_r)
+		return cmp_null(comm_l, comm_r);
+
+	return strcmp(comm_l, comm_r);
+}
+
+/* --sort parent */
+
+int64_t
+sort__parent_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	struct symbol *sym_l = left->parent;
+	struct symbol *sym_r = right->parent;
+
+	if (!sym_l || !sym_r)
+		return cmp_null(sym_l, sym_r);
+
+	return strcmp(sym_l->name, sym_r->name);
+}
+
+size_t
+sort__parent_print(FILE *fp, struct hist_entry *self, unsigned int width)
+{
+	return repsep_fprintf(fp, "%-*s", width,
+			      self->parent ? self->parent->name : "[other]");
+}
+
+int sort_dimension__add(const char *tok)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(sort_dimensions); i++) {
+		struct sort_dimension *sd = &sort_dimensions[i];
+
+		if (sd->taken)
+			continue;
+
+		if (strncasecmp(tok, sd->name, strlen(tok)))
+			continue;
+
+		if (sd->entry->collapse)
+			sort__need_collapse = 1;
+
+		if (sd->entry == &sort_parent) {
+			int ret = regcomp(&parent_regex, parent_pattern, REG_EXTENDED);
+			if (ret) {
+				char err[BUFSIZ];
+
+				regerror(ret, &parent_regex, err, sizeof(err));
+				fprintf(stderr, "Invalid regex: %s\n%s",
+					parent_pattern, err);
+				exit(-1);
+			}
+			sort__has_parent = 1;
+		}
+
+		list_add_tail(&sd->entry->list, &hist_entry__sort_list);
+		sd->taken = 1;
+
+		return 0;
+	}
+
+	return -ESRCH;
+}
+
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
new file mode 100644
index 0000000..4684fd6
--- /dev/null
+++ b/tools/perf/util/sort.h
@@ -0,0 +1,93 @@
+#ifndef __PERF_SORT_H
+#define __PERF_SORT_H
+#include "../builtin.h"
+
+#include "util.h"
+
+#include "color.h"
+#include <linux/list.h>
+#include "cache.h"
+#include <linux/rbtree.h>
+#include "symbol.h"
+#include "string.h"
+#include "callchain.h"
+#include "strlist.h"
+#include "values.h"
+
+#include "../perf.h"
+#include "debug.h"
+#include "header.h"
+
+#include "parse-options.h"
+#include "parse-events.h"
+
+#include "thread.h"
+#include "sort.h"
+
+extern regex_t parent_regex;
+extern char *sort_order;
+extern char default_parent_pattern[];
+extern char *parent_pattern;
+extern char default_sort_order[];
+extern int sort__need_collapse;
+extern int sort__has_parent;
+extern char *field_sep;
+extern struct sort_entry sort_comm;
+extern struct sort_entry sort_dso;
+extern struct sort_entry sort_sym;
+extern struct sort_entry sort_parent;
+extern unsigned int dsos__col_width;
+extern unsigned int comms__col_width;
+extern unsigned int threads__col_width;
+
+struct hist_entry {
+	struct rb_node		rb_node;
+
+	struct thread		*thread;
+	struct map		*map;
+	struct dso		*dso;
+	struct symbol		*sym;
+	struct symbol		*parent;
+	u64			ip;
+	char			level;
+	struct callchain_node	callchain;
+	struct rb_root		sorted_chain;
+
+	u64			count;
+};
+
+/*
+ * configurable sorting bits
+ */
+
+struct sort_entry {
+	struct list_head list;
+
+	const char *header;
+
+	int64_t (*cmp)(struct hist_entry *, struct hist_entry *);
+	int64_t (*collapse)(struct hist_entry *, struct hist_entry *);
+	size_t	(*print)(FILE *fp, struct hist_entry *, unsigned int width);
+	unsigned int *width;
+	bool	elide;
+};
+
+extern struct sort_entry sort_thread;
+extern struct list_head hist_entry__sort_list;
+
+extern int repsep_fprintf(FILE *fp, const char *fmt, ...);
+extern size_t sort__thread_print(FILE *, struct hist_entry *, unsigned int);
+extern size_t sort__comm_print(FILE *, struct hist_entry *, unsigned int);
+extern size_t sort__dso_print(FILE *, struct hist_entry *, unsigned int);
+extern size_t sort__sym_print(FILE *, struct hist_entry *, unsigned int __used);
+extern int64_t cmp_null(void *, void *);
+extern int64_t sort__thread_cmp(struct hist_entry *, struct hist_entry *);
+extern int64_t sort__comm_cmp(struct hist_entry *, struct hist_entry *);
+extern int64_t sort__comm_collapse(struct hist_entry *, struct hist_entry *);
+extern int64_t sort__dso_cmp(struct hist_entry *, struct hist_entry *);
+extern int64_t sort__sym_cmp(struct hist_entry *, struct hist_entry *);
+extern int64_t sort__parent_cmp(struct hist_entry *, struct hist_entry *);
+extern size_t sort__parent_print(FILE *, struct hist_entry *, unsigned int);
+extern int sort_dimension__add(const char *);
+
+#endif	/* __PERF_SORT_H */
