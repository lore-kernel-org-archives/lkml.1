Return-Path: <linux-kernel-owner+w=401wt.eu-S1753283AbZJXBI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283AbZJXBI4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 21:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753182AbZJXBEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 21:04:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:51687 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753128AbZJXBEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 21:04:35 -0400
Date: Sat, 24 Oct 2009 01:03:46 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, peterz@infradead.org,
       efault@gmx.de, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1256055940-19511-1-git-send-email-acme@redhat.com>
References: <1256055940-19511-1-git-send-email-acme@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:branch?] perf annotate: Use the sym_priv_size area for the histogram
Message-ID: <tip-e42049926ebdcae24fdfdc8f0e3ff8f05f24a60b@git.kernel.org>
Git-Commit-ID: e42049926ebdcae24fdfdc8f0e3ff8f05f24a60b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e42049926ebdcae24fdfdc8f0e3ff8f05f24a60b
Gitweb:     http://git.kernel.org/tip/e42049926ebdcae24fdfdc8f0e3ff8f05f24a60b
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 20 Oct 2009 14:25:40 -0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 20 Oct 2009 21:12:58 +0200

perf annotate: Use the sym_priv_size area for the histogram

We have this sym_priv_size mechanism for attaching private areas
to struct symbol entries but annotate wasn't using it, adding
private areas to struct symbol in addition to a ->priv pointer.

Scrap all that and use the sym_priv_size mechanism.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <1256055940-19511-1-git-send-email-acme@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-annotate.c |  109 +++++++++++++++++++++++++++++-----------
 tools/perf/builtin-report.c   |    2 +-
 tools/perf/util/data_map.c    |    2 +-
 tools/perf/util/event.h       |    8 +++-
 tools/perf/util/map.c         |   21 +++++++-
 tools/perf/util/symbol.c      |   56 +++++++--------------
 tools/perf/util/symbol.h      |   17 ++----
 7 files changed, 132 insertions(+), 83 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 06f1027..2456925 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -37,12 +37,44 @@ static int		print_line;
 static unsigned long	page_size;
 static unsigned long	mmap_window = 32;
 
+struct sym_hist {
+	u64		sum;
+	u64		ip[0];
+};
+
 struct sym_ext {
 	struct rb_node	node;
 	double		percent;
 	char		*path;
 };
 
+struct sym_priv {
+	struct sym_hist	*hist;
+	struct sym_ext	*ext;
+};
+
+static const char *sym_hist_filter;
+
+static int symbol_filter(struct map *map, struct symbol *sym)
+{
+	if (strcmp(sym->name, sym_hist_filter) == 0) {
+		struct sym_priv *priv = dso__sym_priv(map->dso, sym);
+		const int size = (sizeof(*priv->hist) +
+				  (sym->end - sym->start) * sizeof(u64));
+
+		priv->hist = malloc(size);
+		if (priv->hist)
+			memset(priv->hist, 0, size);
+		return 0;
+	}
+	/*
+	 * FIXME: We should really filter it out, as we don't want to go thru symbols
+	 * we're not interested, and if a DSO ends up with no symbols, delete it too,
+	 * but right now the kernel loading routines in symbol.c bail out if no symbols
+	 * are found, fix it later.
+	 */
+	return 0;
+}
 
 /*
  * collect histogram counts
@@ -51,10 +83,16 @@ static void hist_hit(struct hist_entry *he, u64 ip)
 {
 	unsigned int sym_size, offset;
 	struct symbol *sym = he->sym;
+	struct sym_priv *priv;
+	struct sym_hist *h;
 
 	he->count++;
 
-	if (!sym || !sym->hist)
+	if (!sym || !he->map)
+		return;
+
+	priv = dso__sym_priv(he->map->dso, sym);
+	if (!priv->hist)
 		return;
 
 	sym_size = sym->end - sym->start;
@@ -67,15 +105,16 @@ static void hist_hit(struct hist_entry *he, u64 ip)
 	if (offset >= sym_size)
 		return;
 
-	sym->hist_sum++;
-	sym->hist[offset]++;
+	h = priv->hist;
+	h->sum++;
+	h->ip[offset]++;
 
 	if (verbose >= 3)
 		printf("%p %s: count++ [ip: %p, %08Lx] => %Ld\n",
 			(void *)(unsigned long)he->sym->start,
 			he->sym->name,
 			(void *)(unsigned long)ip, ip - he->sym->start,
-			sym->hist[offset]);
+			h->ip[offset]);
 }
 
 static int hist_entry__add(struct thread *thread, struct map *map,
@@ -162,7 +201,9 @@ got_map:
 static int
 process_mmap_event(event_t *event, unsigned long offset, unsigned long head)
 {
-	struct map *map = map__new(&event->mmap, NULL, 0);
+	struct map *map = map__new(&event->mmap, NULL, 0,
+				   sizeof(struct sym_priv), symbol_filter,
+				   verbose);
 	struct thread *thread = threads__findnew(event->mmap.pid);
 
 	dump_printf("%p [%p]: PERF_RECORD_MMAP %d: [%p(%p) @ %p]: %s\n",
@@ -314,17 +355,19 @@ static int parse_line(FILE *file, struct hist_entry *he, u64 len)
 		unsigned int hits = 0;
 		double percent = 0.0;
 		const char *color;
-		struct sym_ext *sym_ext = sym->priv;
+		struct sym_priv *priv = dso__sym_priv(he->map->dso, sym);
+		struct sym_ext *sym_ext = priv->ext;
+		struct sym_hist *h = priv->hist;
 
 		offset = line_ip - start;
 		if (offset < len)
-			hits = sym->hist[offset];
+			hits = h->ip[offset];
 
 		if (offset < len && sym_ext) {
 			path = sym_ext[offset].path;
 			percent = sym_ext[offset].percent;
-		} else if (sym->hist_sum)
-			percent = 100.0 * hits / sym->hist_sum;
+		} else if (h->sum)
+			percent = 100.0 * hits / h->sum;
 
 		color = get_percent_color(percent);
 
@@ -377,9 +420,10 @@ static void insert_source_line(struct sym_ext *sym_ext)
 	rb_insert_color(&sym_ext->node, &root_sym_ext);
 }
 
-static void free_source_line(struct symbol *sym, int len)
+static void free_source_line(struct hist_entry *he, int len)
 {
-	struct sym_ext *sym_ext = sym->priv;
+	struct sym_priv *priv = dso__sym_priv(he->map->dso, he->sym);
+	struct sym_ext *sym_ext = priv->ext;
 	int i;
 
 	if (!sym_ext)
@@ -389,7 +433,7 @@ static void free_source_line(struct symbol *sym, int len)
 		free(sym_ext[i].path);
 	free(sym_ext);
 
-	sym->priv = NULL;
+	priv->ext = NULL;
 	root_sym_ext = RB_ROOT;
 }
 
@@ -402,15 +446,16 @@ get_source_line(struct hist_entry *he, int len, const char *filename)
 	int i;
 	char cmd[PATH_MAX * 2];
 	struct sym_ext *sym_ext;
+	struct sym_priv *priv = dso__sym_priv(he->map->dso, sym);
+	struct sym_hist *h = priv->hist;
 
-	if (!sym->hist_sum)
+	if (!h->sum)
 		return;
 
-	sym->priv = calloc(len, sizeof(struct sym_ext));
-	if (!sym->priv)
+	sym_ext = priv->ext = calloc(len, sizeof(struct sym_ext));
+	if (!priv->ext)
 		return;
 
-	sym_ext = sym->priv;
 	start = he->map->unmap_ip(he->map, sym->start);
 
 	for (i = 0; i < len; i++) {
@@ -419,7 +464,7 @@ get_source_line(struct hist_entry *he, int len, const char *filename)
 		u64 offset;
 		FILE *fp;
 
-		sym_ext[i].percent = 100.0 * sym->hist[i] / sym->hist_sum;
+		sym_ext[i].percent = 100.0 * h->ip[i] / h->sum;
 		if (sym_ext[i].percent <= 0.5)
 			continue;
 
@@ -530,7 +575,7 @@ static void annotate_sym(struct hist_entry *he)
 
 	pclose(file);
 	if (print_line)
-		free_source_line(sym, len);
+		free_source_line(he, len);
 }
 
 static void find_annotations(void)
@@ -540,19 +585,23 @@ static void find_annotations(void)
 
 	for (nd = rb_first(&output_hists); nd; nd = rb_next(nd)) {
 		struct hist_entry *he = rb_entry(nd, struct hist_entry, rb_node);
+		struct sym_priv *priv;
 
-		if (he->sym && he->sym->hist) {
-			annotate_sym(he);
-			count++;
-			/*
-			 * Since we have a hist_entry per IP for the same
-			 * symbol, free he->sym->hist to signal we already
-			 * processed this symbol.
-			 */
-			free(he->sym->hist);
-			he->sym->hist = NULL;
+		if (he->sym == NULL)
+			continue;
 
-		}
+		priv = dso__sym_priv(he->map->dso, he->sym);
+		if (priv->hist == NULL)
+			continue;
+
+		annotate_sym(he);
+		count++;
+		/*
+		 * Since we have a hist_entry per IP for the same symbol, free
+		 * he->sym->hist to signal we already processed this symbol.
+		 */
+		free(priv->hist);
+		priv->hist = NULL;
 	}
 
 	if (!count)
@@ -593,7 +642,7 @@ static int __cmd_annotate(void)
 		exit(0);
 	}
 
-	if (load_kernel() < 0) {
+	if (load_kernel(sizeof(struct sym_priv), symbol_filter) < 0) {
 		perror("failed to load kernel symbols");
 		return EXIT_FAILURE;
 	}
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index a4f8cc2..bee207c 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -680,7 +680,7 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 static int
 process_mmap_event(event_t *event, unsigned long offset, unsigned long head)
 {
-	struct map *map = map__new(&event->mmap, cwd, cwdlen);
+	struct map *map = map__new(&event->mmap, cwd, cwdlen, 0, NULL, verbose);
 	struct thread *thread = threads__findnew(event->mmap.pid);
 
 	dump_printf("%p [%p]: PERF_RECORD_MMAP %d/%d: [%p(%p) @ %p]: %s\n",
diff --git a/tools/perf/util/data_map.c b/tools/perf/util/data_map.c
index 242b055..18accb8 100644
--- a/tools/perf/util/data_map.c
+++ b/tools/perf/util/data_map.c
@@ -130,7 +130,7 @@ int mmap_dispatch_perf_file(struct perf_header **pheader,
 		if (curr_handler->sample_type_check(sample_type) < 0)
 			exit(-1);
 
-	if (load_kernel() < 0) {
+	if (load_kernel(0, NULL) < 0) {
 		perror("failed to load kernel symbols");
 		return EXIT_FAILURE;
 	}
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 6b5be56..db59c8b 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -101,7 +101,13 @@ static inline u64 identity__map_ip(struct map *map __used, u64 ip)
 	return ip;
 }
 
-struct map *map__new(struct mmap_event *event, char *cwd, int cwdlen);
+struct symbol;
+
+typedef int (*symbol_filter_t)(struct map *map, struct symbol *sym);
+
+struct map *map__new(struct mmap_event *event, char *cwd, int cwdlen,
+		     unsigned int sym_priv_size, symbol_filter_t filter,
+		     int v);
 struct map *map__clone(struct map *self);
 int map__overlap(struct map *l, struct map *r);
 size_t map__fprintf(struct map *self, FILE *fp);
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 4e203d1..55079c0 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -3,6 +3,7 @@
 #include <stdlib.h>
 #include <string.h>
 #include <stdio.h>
+#include "debug.h"
 
 static inline int is_anon_memory(const char *filename)
 {
@@ -19,7 +20,9 @@ static int strcommon(const char *pathname, char *cwd, int cwdlen)
 	return n;
 }
 
- struct map *map__new(struct mmap_event *event, char *cwd, int cwdlen)
+struct map *map__new(struct mmap_event *event, char *cwd, int cwdlen,
+		     unsigned int sym_priv_size, symbol_filter_t filter,
+		     int v)
 {
 	struct map *self = malloc(sizeof(*self));
 
@@ -27,6 +30,7 @@ static int strcommon(const char *pathname, char *cwd, int cwdlen)
 		const char *filename = event->filename;
 		char newfilename[PATH_MAX];
 		int anon;
+		bool new_dso;
 
 		if (cwd) {
 			int n = strcommon(filename, cwd, cwdlen);
@@ -49,10 +53,23 @@ static int strcommon(const char *pathname, char *cwd, int cwdlen)
 		self->end   = event->start + event->len;
 		self->pgoff = event->pgoff;
 
-		self->dso = dsos__findnew(filename);
+		self->dso = dsos__findnew(filename, sym_priv_size, &new_dso);
 		if (self->dso == NULL)
 			goto out_delete;
 
+		if (new_dso) {
+			int nr = dso__load(self->dso, self, filter, v);
+
+			if (nr < 0)
+				eprintf("Failed to open %s, continuing "
+					"without symbols\n",
+					self->dso->long_name);
+			else if (nr == 0)
+				eprintf("No symbols found in %s, maybe "
+					"install a debug package?\n",
+					self->dso->long_name);
+		}
+
 		if (self->dso == vdso || anon)
 			self->map_ip = self->unmap_ip = identity__map_ip;
 		else {
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 3350119..0a48984 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -11,8 +11,6 @@
 #include <elf.h>
 #include <sys/utsname.h>
 
-const char *sym_hist_filter;
-
 enum dso_origin {
 	DSO__ORIG_KERNEL = 0,
 	DSO__ORIG_JAVA_JIT,
@@ -86,22 +84,16 @@ static struct symbol *symbol__new(u64 start, u64 len, const char *name,
 	if (!self)
 		return NULL;
 
-	if (v > 2)
-		printf("new symbol: %016Lx [%08lx]: %s, hist: %p\n",
-			start, (unsigned long)len, name, self->hist);
-
-	self->hist = NULL;
-	self->hist_sum = 0;
-
-	if (sym_hist_filter && !strcmp(name, sym_hist_filter))
-		self->hist = calloc(sizeof(u64), len);
-
 	if (priv_size) {
 		memset(self, 0, priv_size);
 		self = ((void *)self) + priv_size;
 	}
 	self->start = start;
 	self->end   = len ? start + len - 1 : start;
+
+	if (v > 2)
+		printf("%s: %s %#Lx-%#Lx\n", __func__, name, start, self->end);
+
 	memcpy(self->name, name, namelen);
 
 	return self;
@@ -919,7 +911,8 @@ char dso__symtab_origin(const struct dso *self)
 	return origin[self->origin];
 }
 
-int dso__load(struct dso *self, struct map *map, symbol_filter_t filter, int v)
+int dso__load(struct dso *self, struct map *map,
+	      symbol_filter_t filter, int v)
 {
 	int size = PATH_MAX;
 	char *name = malloc(size), *build_id = NULL;
@@ -1335,33 +1328,21 @@ static struct dso *dsos__find(const char *name)
 	return NULL;
 }
 
-struct dso *dsos__findnew(const char *name)
+struct dso *dsos__findnew(const char *name, unsigned int sym_priv_size,
+			  bool *is_new)
 {
 	struct dso *dso = dsos__find(name);
-	int nr;
-
-	if (dso)
-		return dso;
-
-	dso = dso__new(name, 0);
-	if (!dso)
-		goto out_delete_dso;
 
-	nr = dso__load(dso, NULL, NULL, verbose);
-	if (nr < 0) {
-		eprintf("Failed to open: %s\n", name);
-		goto out_delete_dso;
-	}
-	if (!nr)
-		eprintf("No symbols found in: %s, maybe install a debug package?\n", name);
-
-	dsos__add(dso);
+	if (!dso) {
+		dso = dso__new(name, sym_priv_size);
+		if (dso) {
+			dsos__add(dso);
+			*is_new = true;
+		}
+	} else
+		*is_new = false;
 
 	return dso;
-
-out_delete_dso:
-	dso__delete(dso);
-	return NULL;
 }
 
 void dsos__fprintf(FILE *fp)
@@ -1372,9 +1353,10 @@ void dsos__fprintf(FILE *fp)
 		dso__fprintf(pos, fp);
 }
 
-int load_kernel(void)
+int load_kernel(unsigned int sym_priv_size, symbol_filter_t filter)
 {
-	if (dsos__load_kernel(vmlinux_name, 0, NULL, verbose, modules) <= 0)
+	if (dsos__load_kernel(vmlinux_name, sym_priv_size,
+			      filter, verbose, modules) <= 0)
 		return -1;
 
 	vdso = dso__new("[vdso]", 0);
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 2e4522e..c2a777d 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -2,6 +2,7 @@
 #define __PERF_SYMBOL 1
 
 #include <linux/types.h>
+#include <stdbool.h>
 #include "types.h"
 #include <linux/list.h>
 #include <linux/rbtree.h>
@@ -35,9 +36,6 @@ struct symbol {
 	struct rb_node	rb_node;
 	u64		start;
 	u64		end;
-	u64		hist_sum;
-	u64		*hist;
-	void		*priv;
 	char		name[0];
 };
 
@@ -54,10 +52,6 @@ struct dso {
 	char		 name[0];
 };
 
-extern const char *sym_hist_filter;
-
-typedef int (*symbol_filter_t)(struct map *map, struct symbol *sym);
-
 struct dso *dso__new(const char *name, unsigned int sym_priv_size);
 void dso__delete(struct dso *self);
 
@@ -70,15 +64,16 @@ struct symbol *dso__find_symbol(struct dso *self, u64 ip);
 
 int dsos__load_kernel(const char *vmlinux, unsigned int sym_priv_size,
 		      symbol_filter_t filter, int verbose, int modules);
-int dso__load(struct dso *self, struct map *map, symbol_filter_t filter,
-	      int verbose);
-struct dso *dsos__findnew(const char *name);
+struct dso *dsos__findnew(const char *name, unsigned int sym_priv_size,
+			  bool *is_new);
+int dso__load(struct dso *self, struct map *map,
+	      symbol_filter_t filter, int v);
 void dsos__fprintf(FILE *fp);
 
 size_t dso__fprintf(struct dso *self, FILE *fp);
 char dso__symtab_origin(const struct dso *self);
 
-int load_kernel(void);
+int load_kernel(unsigned int sym_priv_size, symbol_filter_t filter);
 
 void symbol__init(void);
 
