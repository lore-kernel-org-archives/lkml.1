Return-Path: <linux-kernel-owner+w=401wt.eu-S932881AbZJ3S3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932881AbZJ3S3W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 14:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932871AbZJ3S3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 14:29:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:45625 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932856AbZJ3S3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 14:29:02 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>
Subject: [PATCH] perf tools: Simplify the symbol priv area mechanism
Date: Fri, 30 Oct 2009 16:28:24 -0200
Message-Id: <1256927305-4628-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1256927305-4628-1-git-send-email-acme@infradead.org>
References: <1256927305-4628-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Before we were storing this in the DSO, but in fact this is a property
of the 'symbol' class, not something that will vary among DSOs, so move
it to a global variable and initialize it using the existing
symbol__init routine.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c  |   21 +++++------
 tools/perf/builtin-report.c    |    4 +-
 tools/perf/builtin-sched.c     |    2 +-
 tools/perf/builtin-timechart.c |    2 +-
 tools/perf/builtin-top.c       |   12 +++----
 tools/perf/builtin-trace.c     |    2 +-
 tools/perf/util/data_map.c     |    2 +-
 tools/perf/util/event.h        |    3 +-
 tools/perf/util/map.c          |    5 +--
 tools/perf/util/symbol.c       |   73 ++++++++++++++++++---------------------
 tools/perf/util/symbol.h       |   24 ++++++------
 11 files changed, 70 insertions(+), 80 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 8688bfe..77d50a6 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -55,11 +55,11 @@ struct sym_priv {
 
 static const char *sym_hist_filter;
 
-static int symbol_filter(struct map *map, struct symbol *sym)
+static int symbol_filter(struct map *map __used, struct symbol *sym)
 {
 	if (sym_hist_filter == NULL ||
 	    strcmp(sym->name, sym_hist_filter) == 0) {
-		struct sym_priv *priv = dso__sym_priv(map->dso, sym);
+		struct sym_priv *priv = symbol__priv(sym);
 		const int size = (sizeof(*priv->hist) +
 				  (sym->end - sym->start) * sizeof(u64));
 
@@ -92,7 +92,7 @@ static void hist_hit(struct hist_entry *he, u64 ip)
 	if (!sym || !he->map)
 		return;
 
-	priv = dso__sym_priv(he->map->dso, sym);
+	priv = symbol__priv(sym);
 	if (!priv->hist)
 		return;
 
@@ -202,8 +202,7 @@ got_map:
 static int
 process_mmap_event(event_t *event, unsigned long offset, unsigned long head)
 {
-	struct map *map = map__new(&event->mmap, NULL, 0,
-				   sizeof(struct sym_priv));
+	struct map *map = map__new(&event->mmap, NULL, 0);
 	struct thread *thread = threads__findnew(event->mmap.pid);
 
 	dump_printf("%p [%p]: PERF_RECORD_MMAP %d: [%p(%p) @ %p]: %s\n",
@@ -355,7 +354,7 @@ static int parse_line(FILE *file, struct hist_entry *he, u64 len)
 		unsigned int hits = 0;
 		double percent = 0.0;
 		const char *color;
-		struct sym_priv *priv = dso__sym_priv(he->map->dso, sym);
+		struct sym_priv *priv = symbol__priv(sym);
 		struct sym_ext *sym_ext = priv->ext;
 		struct sym_hist *h = priv->hist;
 
@@ -422,7 +421,7 @@ static void insert_source_line(struct sym_ext *sym_ext)
 
 static void free_source_line(struct hist_entry *he, int len)
 {
-	struct sym_priv *priv = dso__sym_priv(he->map->dso, he->sym);
+	struct sym_priv *priv = symbol__priv(he->sym);
 	struct sym_ext *sym_ext = priv->ext;
 	int i;
 
@@ -446,7 +445,7 @@ get_source_line(struct hist_entry *he, int len, const char *filename)
 	int i;
 	char cmd[PATH_MAX * 2];
 	struct sym_ext *sym_ext;
-	struct sym_priv *priv = dso__sym_priv(he->map->dso, sym);
+	struct sym_priv *priv = symbol__priv(sym);
 	struct sym_hist *h = priv->hist;
 
 	if (!h->sum)
@@ -589,7 +588,7 @@ static void find_annotations(void)
 		if (he->sym == NULL)
 			continue;
 
-		priv = dso__sym_priv(he->map->dso, he->sym);
+		priv = symbol__priv(he->sym);
 		if (priv->hist == NULL)
 			continue;
 
@@ -637,7 +636,7 @@ static int __cmd_annotate(void)
 		exit(0);
 	}
 
-	if (load_kernel(sizeof(struct sym_priv), symbol_filter) < 0) {
+	if (load_kernel(symbol_filter) < 0) {
 		perror("failed to load kernel symbols");
 		return EXIT_FAILURE;
 	}
@@ -769,7 +768,7 @@ static void setup_sorting(void)
 
 int cmd_annotate(int argc, const char **argv, const char *prefix __used)
 {
-	symbol__init();
+	symbol__init(sizeof(struct sym_priv));
 
 	page_size = getpagesize();
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index f1bcd35..1a806d5 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -751,7 +751,7 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 static int
 process_mmap_event(event_t *event, unsigned long offset, unsigned long head)
 {
-	struct map *map = map__new(&event->mmap, cwd, cwdlen, 0);
+	struct map *map = map__new(&event->mmap, cwd, cwdlen);
 	struct thread *thread = threads__findnew(event->mmap.pid);
 
 	dump_printf("%p [%p]: PERF_RECORD_MMAP %d/%d: [%p(%p) @ %p]: %s\n",
@@ -1093,7 +1093,7 @@ static void setup_list(struct strlist **list, const char *list_str,
 
 int cmd_report(int argc, const char **argv, const char *prefix __used)
 {
-	symbol__init();
+	symbol__init(0);
 
 	argc = parse_options(argc, argv, options, report_usage, 0);
 
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 9a48d96..df44b75 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1937,7 +1937,7 @@ static int __cmd_record(int argc, const char **argv)
 
 int cmd_sched(int argc, const char **argv, const char *prefix __used)
 {
-	symbol__init();
+	symbol__init(0);
 
 	argc = parse_options(argc, argv, sched_options, sched_usage,
 			     PARSE_OPT_STOP_AT_NON_OPTION);
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 0a2f222..665877e 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -1266,7 +1266,7 @@ static const struct option options[] = {
 
 int cmd_timechart(int argc, const char **argv, const char *prefix __used)
 {
-	symbol__init();
+	symbol__init(0);
 
 	page_size = getpagesize();
 
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index ee87640..2aea913 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -789,7 +789,7 @@ static int symbol_filter(struct map *map, struct symbol *sym)
 	    strstr(name, "_text_end"))
 		return 1;
 
-	syme = dso__sym_priv(map->dso, sym);
+	syme = symbol__priv(sym);
 	syme->map = map;
 	pthread_mutex_init(&syme->source_lock, NULL);
 	if (!sym_filter_entry && sym_filter && !strcmp(name, sym_filter))
@@ -807,8 +807,7 @@ static int symbol_filter(struct map *map, struct symbol *sym)
 
 static int parse_symbols(void)
 {
-	if (dsos__load_kernel(vmlinux_name, sizeof(struct sym_entry),
-			      symbol_filter, 1) <= 0)
+	if (dsos__load_kernel(vmlinux_name, symbol_filter, 1) <= 0)
 		return -1;
 
 	if (dump_symtab)
@@ -859,7 +858,7 @@ static void event__process_sample(const event_t *self, int counter)
 		return;
 	}
 
-	syme = dso__sym_priv(map->dso, sym);
+	syme = symbol__priv(sym);
 
 	if (!syme->skip) {
 		syme->count[counter]++;
@@ -878,8 +877,7 @@ static void event__process_mmap(event_t *self)
 	struct thread *thread = threads__findnew(self->mmap.pid);
 
 	if (thread != NULL) {
-		struct map *map = map__new(&self->mmap, NULL, 0,
-					   sizeof(struct sym_entry));
+		struct map *map = map__new(&self->mmap, NULL, 0);
 		if (map != NULL)
 			thread__insert_map(thread, map);
 	}
@@ -1176,7 +1174,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 {
 	int counter;
 
-	symbol__init();
+	symbol__init(sizeof(struct sym_entry));
 
 	page_size = sysconf(_SC_PAGE_SIZE);
 
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index e566bbe..d042d65 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -151,7 +151,7 @@ static const struct option options[] = {
 
 int cmd_trace(int argc, const char **argv, const char *prefix __used)
 {
-	symbol__init();
+	symbol__init(0);
 
 	argc = parse_options(argc, argv, options, annotate_usage, 0);
 	if (argc) {
diff --git a/tools/perf/util/data_map.c b/tools/perf/util/data_map.c
index 18accb8..c458db9 100644
--- a/tools/perf/util/data_map.c
+++ b/tools/perf/util/data_map.c
@@ -130,7 +130,7 @@ int mmap_dispatch_perf_file(struct perf_header **pheader,
 		if (curr_handler->sample_type_check(sample_type) < 0)
 			exit(-1);
 
-	if (load_kernel(0, NULL) < 0) {
+	if (load_kernel(NULL) < 0) {
 		perror("failed to load kernel symbols");
 		return EXIT_FAILURE;
 	}
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 4a158a0..0a443be 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -107,8 +107,7 @@ typedef int (*symbol_filter_t)(struct map *map, struct symbol *sym);
 
 void map__init(struct map *self, u64 start, u64 end, u64 pgoff,
 	       struct dso *dso);
-struct map *map__new(struct mmap_event *event, char *cwd, int cwdlen,
-		     unsigned int sym_priv_size);
+struct map *map__new(struct mmap_event *event, char *cwd, int cwdlen);
 struct map *map__clone(struct map *self);
 int map__overlap(struct map *l, struct map *r);
 size_t map__fprintf(struct map *self, FILE *fp);
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 3b7ce1b..679011c 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -32,8 +32,7 @@ void map__init(struct map *self, u64 start, u64 end, u64 pgoff,
 	RB_CLEAR_NODE(&self->rb_node);
 }
 
-struct map *map__new(struct mmap_event *event, char *cwd, int cwdlen,
-		     unsigned int sym_priv_size)
+struct map *map__new(struct mmap_event *event, char *cwd, int cwdlen)
 {
 	struct map *self = malloc(sizeof(*self));
 
@@ -60,7 +59,7 @@ struct map *map__new(struct mmap_event *event, char *cwd, int cwdlen,
 			filename = newfilename;
 		}
 
-		dso = dsos__findnew(filename, sym_priv_size);
+		dso = dsos__findnew(filename);
 		if (dso == NULL)
 			goto out_delete;
 
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 9dad496..ec99d79 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -26,6 +26,7 @@ static void dsos__add(struct dso *dso);
 static struct dso *dsos__find(const char *name);
 static struct map *map__new2(u64 start, struct dso *dso);
 static void kernel_maps__insert(struct map *map);
+unsigned int symbol__priv_size;
 
 static struct rb_root kernel_maps;
 
@@ -75,18 +76,17 @@ static void kernel_maps__fixup_end(void)
 	}
 }
 
-static struct symbol *symbol__new(u64 start, u64 len, const char *name,
-				  unsigned int priv_size)
+static struct symbol *symbol__new(u64 start, u64 len, const char *name)
 {
 	size_t namelen = strlen(name) + 1;
-	struct symbol *self = calloc(1, priv_size + sizeof(*self) + namelen);
-
+	struct symbol *self = calloc(1, (symbol__priv_size +
+					 sizeof(*self) + namelen));
 	if (!self)
 		return NULL;
 
-	if (priv_size) {
-		memset(self, 0, priv_size);
-		self = ((void *)self) + priv_size;
+	if (symbol__priv_size) {
+		memset(self, 0, symbol__priv_size);
+		self = ((void *)self) + symbol__priv_size;
 	}
 	self->start = start;
 	self->end   = len ? start + len - 1 : start;
@@ -98,9 +98,9 @@ static struct symbol *symbol__new(u64 start, u64 len, const char *name,
 	return self;
 }
 
-static void symbol__delete(struct symbol *self, unsigned int priv_size)
+static void symbol__delete(struct symbol *self)
 {
-	free(((void *)self) - priv_size);
+	free(((void *)self) - symbol__priv_size);
 }
 
 static size_t symbol__fprintf(struct symbol *self, FILE *fp)
@@ -109,7 +109,7 @@ static size_t symbol__fprintf(struct symbol *self, FILE *fp)
 		       self->start, self->end, self->name);
 }
 
-struct dso *dso__new(const char *name, unsigned int sym_priv_size)
+struct dso *dso__new(const char *name)
 {
 	struct dso *self = malloc(sizeof(*self) + strlen(name) + 1);
 
@@ -118,7 +118,6 @@ struct dso *dso__new(const char *name, unsigned int sym_priv_size)
 		self->long_name = self->name;
 		self->short_name = self->name;
 		self->syms = RB_ROOT;
-		self->sym_priv_size = sym_priv_size;
 		self->find_symbol = dso__find_symbol;
 		self->slen_calculated = 0;
 		self->origin = DSO__ORIG_NOT_FOUND;
@@ -136,7 +135,7 @@ static void dso__delete_symbols(struct dso *self)
 		pos = rb_entry(next, struct symbol, rb_node);
 		next = rb_next(&pos->rb_node);
 		rb_erase(&pos->rb_node, &self->syms);
-		symbol__delete(pos, self->sym_priv_size);
+		symbol__delete(pos);
 	}
 }
 
@@ -250,8 +249,7 @@ static int kernel_maps__load_all_kallsyms(void)
 		/*
 		 * Will fix up the end later, when we have all symbols sorted.
 		 */
-		sym = symbol__new(start, 0, symbol_name,
-				  kernel_map->dso->sym_priv_size);
+		sym = symbol__new(start, 0, symbol_name);
 
 		if (sym == NULL)
 			goto out_delete_line;
@@ -317,8 +315,7 @@ static int kernel_maps__split_kallsyms(symbol_filter_t filter, int use_modules)
 			snprintf(dso_name, sizeof(dso_name), "[kernel].%d",
 				 kernel_range++);
 
-			dso = dso__new(dso_name,
-				       kernel_map->dso->sym_priv_size);
+			dso = dso__new(dso_name);
 			if (dso == NULL)
 				return -1;
 
@@ -336,7 +333,7 @@ static int kernel_maps__split_kallsyms(symbol_filter_t filter, int use_modules)
 		if (filter && filter(map, pos)) {
 delete_symbol:
 			rb_erase(&pos->rb_node, &kernel_map->dso->syms);
-			symbol__delete(pos, kernel_map->dso->sym_priv_size);
+			symbol__delete(pos);
 		} else {
 			if (map != kernel_map) {
 				rb_erase(&pos->rb_node, &kernel_map->dso->syms);
@@ -417,14 +414,13 @@ static int dso__load_perf_map(struct dso *self, struct map *map,
 		if (len + 2 >= line_len)
 			continue;
 
-		sym = symbol__new(start, size, line + len,
-				  self->sym_priv_size);
+		sym = symbol__new(start, size, line + len);
 
 		if (sym == NULL)
 			goto out_delete_line;
 
 		if (filter && filter(map, sym))
-			symbol__delete(sym, self->sym_priv_size);
+			symbol__delete(sym);
 		else {
 			dso__insert_symbol(self, sym);
 			nr_syms++;
@@ -616,7 +612,7 @@ static int dso__synthesize_plt_symbols(struct  dso *self)
 				 "%s@plt", elf_sym__name(&sym, symstrs));
 
 			f = symbol__new(plt_offset, shdr_plt.sh_entsize,
-					sympltname, self->sym_priv_size);
+					sympltname);
 			if (!f)
 				goto out_elf_end;
 
@@ -634,7 +630,7 @@ static int dso__synthesize_plt_symbols(struct  dso *self)
 				 "%s@plt", elf_sym__name(&sym, symstrs));
 
 			f = symbol__new(plt_offset, shdr_plt.sh_entsize,
-					sympltname, self->sym_priv_size);
+					sympltname);
 			if (!f)
 				goto out_elf_end;
 
@@ -769,7 +765,7 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
 				if (kmodule)
 					start += map->start + shdr.sh_offset;
 
-				curr_dso = dso__new(dso_name, self->sym_priv_size);
+				curr_dso = dso__new(dso_name);
 				if (curr_dso == NULL)
 					goto out_elf_end;
 				curr_map = map__new2(start, curr_dso);
@@ -803,14 +799,13 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
 		if (demangled != NULL)
 			elf_name = demangled;
 new_symbol:
-		f = symbol__new(sym.st_value, sym.st_size, elf_name,
-				curr_dso->sym_priv_size);
+		f = symbol__new(sym.st_value, sym.st_size, elf_name);
 		free(demangled);
 		if (!f)
 			goto out_elf_end;
 
 		if (filter && filter(curr_map, f))
-			symbol__delete(f, curr_dso->sym_priv_size);
+			symbol__delete(f);
 		else {
 			dso__insert_symbol(curr_dso, f);
 			nr++;
@@ -1141,7 +1136,7 @@ static struct map *map__new2(u64 start, struct dso *dso)
 	return self;
 }
 
-static int dsos__load_modules(unsigned int sym_priv_size)
+static int dsos__load_modules(void)
 {
 	char *line = NULL;
 	size_t n;
@@ -1180,7 +1175,7 @@ static int dsos__load_modules(unsigned int sym_priv_size)
 		*sep = '\0';
 
 		snprintf(name, sizeof(name), "[%s]", line);
-		dso = dso__new(name, sym_priv_size);
+		dso = dso__new(name);
 
 		if (dso == NULL)
 			goto out_delete_line;
@@ -1224,11 +1219,11 @@ static int dso__load_vmlinux(struct dso *self, struct map *map,
 	return err;
 }
 
-int dsos__load_kernel(const char *vmlinux, unsigned int sym_priv_size,
-		      symbol_filter_t filter, int use_modules)
+int dsos__load_kernel(const char *vmlinux, symbol_filter_t filter,
+		      int use_modules)
 {
 	int err = -1;
-	struct dso *dso = dso__new(vmlinux, sym_priv_size);
+	struct dso *dso = dso__new(vmlinux);
 
 	if (dso == NULL)
 		return -1;
@@ -1240,7 +1235,7 @@ int dsos__load_kernel(const char *vmlinux, unsigned int sym_priv_size,
 
 	kernel_map->map_ip = kernel_map->unmap_ip = identity__map_ip;
 
-	if (use_modules && dsos__load_modules(sym_priv_size) < 0) {
+	if (use_modules && dsos__load_modules() < 0) {
 		pr_warning("Failed to load list of modules in use! "
 			   "Continuing...\n");
 		use_modules = 0;
@@ -1312,12 +1307,12 @@ static struct dso *dsos__find(const char *name)
 	return NULL;
 }
 
-struct dso *dsos__findnew(const char *name, unsigned int sym_priv_size)
+struct dso *dsos__findnew(const char *name)
 {
 	struct dso *dso = dsos__find(name);
 
 	if (!dso) {
-		dso = dso__new(name, sym_priv_size);
+		dso = dso__new(name);
 		if (dso != NULL)
 			dsos__add(dso);
 	}
@@ -1333,13 +1328,12 @@ void dsos__fprintf(FILE *fp)
 		dso__fprintf(pos, fp);
 }
 
-int load_kernel(unsigned int sym_priv_size, symbol_filter_t filter)
+int load_kernel(symbol_filter_t filter)
 {
-	if (dsos__load_kernel(vmlinux_name, sym_priv_size, filter,
-			      modules) <= 0)
+	if (dsos__load_kernel(vmlinux_name, filter, modules) <= 0)
 		return -1;
 
-	vdso = dso__new("[vdso]", 0);
+	vdso = dso__new("[vdso]");
 	if (!vdso)
 		return -1;
 
@@ -1348,7 +1342,8 @@ int load_kernel(unsigned int sym_priv_size, symbol_filter_t filter)
 	return 0;
 }
 
-void symbol__init(void)
+void symbol__init(unsigned int priv_size)
 {
 	elf_version(EV_CURRENT);
+	symbol__priv_size = priv_size;
 }
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index fb77e0b..0884330 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -49,11 +49,17 @@ struct symbol {
 	char		name[0];
 };
 
+extern unsigned int symbol__priv_size;
+
+static inline void *symbol__priv(struct symbol *self)
+{
+	return ((void *)self) - symbol__priv_size;
+}
+
 struct dso {
 	struct list_head node;
 	struct rb_root	 syms;
 	struct symbol    *(*find_symbol)(struct dso *, u64 ip);
-	unsigned int	 sym_priv_size;
 	unsigned char	 adjust_symbols;
 	unsigned char	 slen_calculated;
 	bool		 loaded;
@@ -63,28 +69,22 @@ struct dso {
 	char		 name[0];
 };
 
-struct dso *dso__new(const char *name, unsigned int sym_priv_size);
+struct dso *dso__new(const char *name);
 void dso__delete(struct dso *self);
 
-static inline void *dso__sym_priv(struct dso *self, struct symbol *sym)
-{
-	return ((void *)sym) - self->sym_priv_size;
-}
-
 struct symbol *dso__find_symbol(struct dso *self, u64 ip);
 
-int dsos__load_kernel(const char *vmlinux, unsigned int sym_priv_size,
-		      symbol_filter_t filter, int modules);
-struct dso *dsos__findnew(const char *name, unsigned int sym_priv_size);
+int dsos__load_kernel(const char *vmlinux, symbol_filter_t filter, int modules);
+struct dso *dsos__findnew(const char *name);
 int dso__load(struct dso *self, struct map *map, symbol_filter_t filter);
 void dsos__fprintf(FILE *fp);
 
 size_t dso__fprintf(struct dso *self, FILE *fp);
 char dso__symtab_origin(const struct dso *self);
 
-int load_kernel(unsigned int sym_priv_size, symbol_filter_t filter);
+int load_kernel(symbol_filter_t filter);
 
-void symbol__init(void);
+void symbol__init(unsigned int priv_size);
 
 extern struct list_head dsos;
 extern struct map *kernel_map;
-- 
1.6.2.5

