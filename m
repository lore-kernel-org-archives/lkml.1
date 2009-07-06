Return-Path: <linux-kernel-owner+w=401wt.eu-S1754243AbZGFTWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243AbZGFTWY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 15:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752964AbZGFTWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 15:22:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43275 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753480AbZGFTWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 15:22:17 -0400
Date: Mon, 6 Jul 2009 16:21:57 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1 tip] perf report: Adjust column width to the values
	sampled
Message-ID: <20090706192157.GA3320@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Suggested-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c            |   93 ++++++++++++++++++++++++--------
 tools/perf/util/include/linux/kernel.h |    8 +++
 tools/perf/util/symbol.c               |    1 +
 tools/perf/util/symbol.h               |    1 +
 4 files changed, 80 insertions(+), 23 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 4e5cc26..db566ea 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -360,12 +360,27 @@ static struct thread *thread__new(pid_t pid)
 	return self;
 }
 
+static unsigned int dsos__longest_name,
+		    comms__longest_name,
+		    threads__longest_name;
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
+	if (!comm_list || strlist__has_entry(comm_list, comm)) {
+		unsigned int slen = strlen(comm);
+		if (slen > comms__longest_name) {
+			comms__longest_name = slen;
+			threads__longest_name = slen + 6;
+		}
+	}
+
+	return 0;
 }
 
 static size_t thread__fprintf(struct thread *self, FILE *fp)
@@ -536,7 +551,8 @@ struct sort_entry {
 
 	int64_t (*cmp)(struct hist_entry *, struct hist_entry *);
 	int64_t (*collapse)(struct hist_entry *, struct hist_entry *);
-	size_t	(*print)(FILE *fp, struct hist_entry *);
+	size_t	(*print)(FILE *fp, struct hist_entry *, unsigned int width);
+	unsigned int *width;
 };
 
 static int64_t cmp_null(void *l, void *r)
@@ -558,15 +574,17 @@ sort__thread_cmp(struct hist_entry *left, struct hist_entry *right)
 }
 
 static size_t
-sort__thread_print(FILE *fp, struct hist_entry *self)
+sort__thread_print(FILE *fp, struct hist_entry *self, unsigned int width)
 {
-	return fprintf(fp, "%16s:%5d", self->thread->comm ?: "", self->thread->pid);
+	return fprintf(fp, "%*s:%5d", width - 6, self->thread->comm ?: "",
+		       self->thread->pid);
 }
 
 static struct sort_entry sort_thread = {
-	.header = "         Command:  Pid",
+	.header = "Command:  Pid",
 	.cmp	= sort__thread_cmp,
 	.print	= sort__thread_print,
+	.width	= &threads__longest_name,
 };
 
 /* --sort comm */
@@ -590,16 +608,17 @@ sort__comm_collapse(struct hist_entry *left, struct hist_entry *right)
 }
 
 static size_t
-sort__comm_print(FILE *fp, struct hist_entry *self)
+sort__comm_print(FILE *fp, struct hist_entry *self, unsigned int width)
 {
-	return fprintf(fp, "%16s", self->thread->comm);
+	return fprintf(fp, "%*s", width, self->thread->comm);
 }
 
 static struct sort_entry sort_comm = {
-	.header		= "         Command",
+	.header		= "Command",
 	.cmp		= sort__comm_cmp,
 	.collapse	= sort__comm_collapse,
 	.print		= sort__comm_print,
+	.width		= &comms__longest_name,
 };
 
 /* --sort dso */
@@ -617,18 +636,19 @@ sort__dso_cmp(struct hist_entry *left, struct hist_entry *right)
 }
 
 static size_t
-sort__dso_print(FILE *fp, struct hist_entry *self)
+sort__dso_print(FILE *fp, struct hist_entry *self, unsigned int width)
 {
 	if (self->dso)
-		return fprintf(fp, "%-25s", self->dso->name);
+		return fprintf(fp, "%-*s", width, self->dso->name);
 
-	return fprintf(fp, "%016llx         ", (u64)self->ip);
+	return fprintf(fp, "%*llx", width, (u64)self->ip);
 }
 
 static struct sort_entry sort_dso = {
-	.header = "Shared Object            ",
+	.header = "Shared Object",
 	.cmp	= sort__dso_cmp,
 	.print	= sort__dso_print,
+	.width	= &dsos__longest_name,
 };
 
 /* --sort symbol */
@@ -648,7 +668,7 @@ sort__sym_cmp(struct hist_entry *left, struct hist_entry *right)
 }
 
 static size_t
-sort__sym_print(FILE *fp, struct hist_entry *self)
+sort__sym_print(FILE *fp, struct hist_entry *self, unsigned int width __used)
 {
 	size_t ret = 0;
 
@@ -690,19 +710,19 @@ sort__parent_cmp(struct hist_entry *left, struct hist_entry *right)
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
+	return fprintf(fp, "%-*s", width,
+		       self->parent ? self->parent->name : "[other]");
 }
 
+static unsigned int parent_symbol__longest_name;
+
 static struct sort_entry sort_parent = {
-	.header = "Parent symbol       ",
+	.header = "Parent symbol",
 	.cmp	= sort__parent_cmp,
 	.print	= sort__parent_print,
+	.width	= &parent_symbol__longest_name,
 };
 
 static int sort__need_collapse = 0;
@@ -977,7 +997,7 @@ hist_entry__fprintf(FILE *fp, struct hist_entry *self, u64 total_samples)
 			continue;
 
 		fprintf(fp, "  ");
-		ret += se->print(fp, self);
+		ret += se->print(fp, self, se->width ? *se->width : 0);
 	}
 
 	ret += fprintf(fp, "\n");
@@ -992,6 +1012,17 @@ hist_entry__fprintf(FILE *fp, struct hist_entry *self, u64 total_samples)
  *
  */
 
+static void dso__calc_longest_name(struct dso *self)
+{
+	if (!dso_list || strlist__has_entry(dso_list, self->name)) {
+		unsigned int slen = strlen(self->name);
+		if (slen > dsos__longest_name)
+			dsos__longest_name = slen;
+	}
+
+	self->slen_calculated = 1;
+}
+
 static struct symbol *
 resolve_symbol(struct thread *thread, struct map **mapp,
 	       struct dso **dsop, u64 *ipp)
@@ -1011,6 +1042,14 @@ resolve_symbol(struct thread *thread, struct map **mapp,
 
 	map = thread__find_map(thread, ip);
 	if (map != NULL) {
+		/*
+		 * We have to do this here as we may have a dso
+		 * with no symbol hit that has a name longer than
+		 * the ones with symbols sampled.
+		 */
+		if (!map->dso->slen_calculated)
+			dso__calc_longest_name(map->dso);
+
 		if (mapp)
 			*mapp = map;
 got_map:
@@ -1282,6 +1321,7 @@ static size_t output__fprintf(FILE *fp, u64 total_samples)
 	struct sort_entry *se;
 	struct rb_node *nd;
 	size_t ret = 0;
+	unsigned int width;
 
 	fprintf(fp, "\n");
 	fprintf(fp, "#\n");
@@ -1292,7 +1332,10 @@ static size_t output__fprintf(FILE *fp, u64 total_samples)
 	list_for_each_entry(se, &hist_entry__sort_list, list) {
 		if (exclude_other && (se == &sort_parent))
 			continue;
-		fprintf(fp, "  %s", se->header);
+		width = strlen(se->header);
+		if (se->width)
+			width = *se->width = max(*se->width, width);
+		fprintf(fp, "  %*s", width, se->header);
 	}
 	fprintf(fp, "\n");
 
@@ -1304,7 +1347,11 @@ static size_t output__fprintf(FILE *fp, u64 total_samples)
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
 
-- 
1.6.2.5

