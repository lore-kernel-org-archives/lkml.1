Return-Path: <linux-kernel-owner+w=401wt.eu-S1757331AbZJSTSJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331AbZJSTSJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 15:18:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757290AbZJSTSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 15:18:08 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44675 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757309AbZJSTSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 15:18:07 -0400
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>
Subject: [PATCH v2] perf tools: Add ->unmap_ip operation to struct map
Date: Mon, 19 Oct 2009 17:17:57 -0200
Message-Id: <1255979877-12533-1-git-send-email-acme@redhat.com>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Sorry, first one had an extra hunk found on another patch I already sent ]

We need this because we get section relative addresses when reading the
symtabs, but when a tool like 'perf annotate' needs to match these address to
what 'objdump -dS' produces we need the address + section back again.

So in annotate now we look at the 'struct hist_entry' instances (that weren't
really being used) so that we iterate only over the symbols that had some hit
and get the map where that particular hit happened so that we can get the right
address to match with annotate.

Verified that at least:

perf annotate mmap_read_counter # Uses the ~/bin/perf binary
perf annotate --vmlinux /home/acme/git/build/perf/vmlinux intel_pmu_enable_all

on a 'perf record perf top' session seems to work.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c |   62 +++++++++++++++++++++++++++-------------
 tools/perf/util/event.h       |    8 ++++-
 tools/perf/util/map.c         |    6 ++-
 tools/perf/util/symbol.c      |    8 +++--
 4 files changed, 58 insertions(+), 26 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 56ba716..06f1027 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -58,9 +58,12 @@ static void hist_hit(struct hist_entry *he, u64 ip)
 		return;
 
 	sym_size = sym->end - sym->start;
-	ip = he->map->map_ip(he->map, ip);
 	offset = ip - sym->start;
 
+	if (verbose)
+		fprintf(stderr, "%s: ip=%Lx\n", __func__,
+			he->map->unmap_ip(he->map, ip));
+
 	if (offset >= sym_size)
 		return;
 
@@ -83,8 +86,7 @@ static int hist_entry__add(struct thread *thread, struct map *map,
 						  count, level, &hit);
 	if (he == NULL)
 		return -ENOMEM;
-	if (hit)
-		hist_hit(he, ip);
+	hist_hit(he, ip);
 	return 0;
 }
 
@@ -260,14 +262,15 @@ process_event(event_t *event, unsigned long offset, unsigned long head)
 	return 0;
 }
 
-static int
-parse_line(FILE *file, struct symbol *sym, u64 len)
+static int parse_line(FILE *file, struct hist_entry *he, u64 len)
 {
+	struct symbol *sym = he->sym;
 	char *line = NULL, *tmp, *tmp2;
 	static const char *prev_line;
 	static const char *prev_color;
 	unsigned int offset;
 	size_t line_len;
+	u64 start;
 	s64 line_ip;
 	int ret;
 	char *c;
@@ -304,6 +307,8 @@ parse_line(FILE *file, struct symbol *sym, u64 len)
 			line_ip = -1;
 	}
 
+	start = he->map->unmap_ip(he->map, sym->start);
+
 	if (line_ip != -1) {
 		const char *path = NULL;
 		unsigned int hits = 0;
@@ -311,7 +316,7 @@ parse_line(FILE *file, struct symbol *sym, u64 len)
 		const char *color;
 		struct sym_ext *sym_ext = sym->priv;
 
-		offset = line_ip - sym->start;
+		offset = line_ip - start;
 		if (offset < len)
 			hits = sym->hist[offset];
 
@@ -390,8 +395,10 @@ static void free_source_line(struct symbol *sym, int len)
 
 /* Get the filename:line for the colored entries */
 static void
-get_source_line(struct symbol *sym, int len, const char *filename)
+get_source_line(struct hist_entry *he, int len, const char *filename)
 {
+	struct symbol *sym = he->sym;
+	u64 start;
 	int i;
 	char cmd[PATH_MAX * 2];
 	struct sym_ext *sym_ext;
@@ -404,6 +411,7 @@ get_source_line(struct symbol *sym, int len, const char *filename)
 		return;
 
 	sym_ext = sym->priv;
+	start = he->map->unmap_ip(he->map, sym->start);
 
 	for (i = 0; i < len; i++) {
 		char *path = NULL;
@@ -415,7 +423,7 @@ get_source_line(struct symbol *sym, int len, const char *filename)
 		if (sym_ext[i].percent <= 0.5)
 			continue;
 
-		offset = sym->start + i;
+		offset = start + i;
 		sprintf(cmd, "addr2line -e %s %016llx", filename, offset);
 		fp = popen(cmd, "r");
 		if (!fp)
@@ -465,8 +473,11 @@ static void print_summary(const char *filename)
 	}
 }
 
-static void annotate_sym(struct dso *dso, struct symbol *sym)
+static void annotate_sym(struct hist_entry *he)
 {
+	struct map *map = he->map;
+	struct dso *dso = map->dso;
+	struct symbol *sym = he->sym;
 	const char *filename = dso->long_name, *d_filename;
 	u64 len;
 	char command[PATH_MAX*2];
@@ -475,6 +486,12 @@ static void annotate_sym(struct dso *dso, struct symbol *sym)
 	if (!filename)
 		return;
 
+	if (verbose)
+		fprintf(stderr, "%s: filename=%s, sym=%s, start=%Lx, end=%Lx\n",
+			__func__, filename, sym->name,
+			map->unmap_ip(map, sym->start),
+			map->unmap_ip(map, sym->end));
+
 	if (full_paths)
 		d_filename = filename;
 	else
@@ -483,7 +500,7 @@ static void annotate_sym(struct dso *dso, struct symbol *sym)
 	len = sym->end - sym->start;
 
 	if (print_line) {
-		get_source_line(sym, len, filename);
+		get_source_line(he, len, filename);
 		print_summary(filename);
 	}
 
@@ -496,7 +513,8 @@ static void annotate_sym(struct dso *dso, struct symbol *sym)
 		       dso, dso->long_name, sym, sym->name);
 
 	sprintf(command, "objdump --start-address=0x%016Lx --stop-address=0x%016Lx -dS %s|grep -v %s",
-		sym->start, sym->end, filename, filename);
+		map->unmap_ip(map, sym->start), map->unmap_ip(map, sym->end),
+		filename, filename);
 
 	if (verbose >= 3)
 		printf("doing: %s\n", command);
@@ -506,7 +524,7 @@ static void annotate_sym(struct dso *dso, struct symbol *sym)
 		return;
 
 	while (!feof(file)) {
-		if (parse_line(file, sym, len) < 0)
+		if (parse_line(file, he, len) < 0)
 			break;
 	}
 
@@ -518,18 +536,22 @@ static void annotate_sym(struct dso *dso, struct symbol *sym)
 static void find_annotations(void)
 {
 	struct rb_node *nd;
-	struct dso *dso;
 	int count = 0;
 
-	list_for_each_entry(dso, &dsos, node) {
+	for (nd = rb_first(&output_hists); nd; nd = rb_next(nd)) {
+		struct hist_entry *he = rb_entry(nd, struct hist_entry, rb_node);
 
-		for (nd = rb_first(&dso->syms); nd; nd = rb_next(nd)) {
-			struct symbol *sym = rb_entry(nd, struct symbol, rb_node);
+		if (he->sym && he->sym->hist) {
+			annotate_sym(he);
+			count++;
+			/*
+			 * Since we have a hist_entry per IP for the same
+			 * symbol, free he->sym->hist to signal we already
+			 * processed this symbol.
+			 */
+			free(he->sym->hist);
+			he->sym->hist = NULL;
 
-			if (sym->hist) {
-				annotate_sym(dso, sym);
-				count++;
-			}
 		}
 	}
 
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index c2e62be..6b5be56 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -82,6 +82,7 @@ struct map {
 	u64			end;
 	u64			pgoff;
 	u64			(*map_ip)(struct map *, u64);
+	u64			(*unmap_ip)(struct map *, u64);
 	struct dso		*dso;
 };
 
@@ -90,7 +91,12 @@ static inline u64 map__map_ip(struct map *map, u64 ip)
 	return ip - map->start + map->pgoff;
 }
 
-static inline u64 vdso__map_ip(struct map *map __used, u64 ip)
+static inline u64 map__unmap_ip(struct map *map, u64 ip)
+{
+	return ip + map->start - map->pgoff;
+}
+
+static inline u64 identity__map_ip(struct map *map __used, u64 ip)
 {
 	return ip;
 }
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 804e023..4e203d1 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -54,9 +54,11 @@ static int strcommon(const char *pathname, char *cwd, int cwdlen)
 			goto out_delete;
 
 		if (self->dso == vdso || anon)
-			self->map_ip = vdso__map_ip;
-		else
+			self->map_ip = self->unmap_ip = identity__map_ip;
+		else {
 			self->map_ip = map__map_ip;
+			self->unmap_ip = map__unmap_ip;
+		}
 	}
 	return self;
 out_delete:
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index faa84f5..3350119 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -337,7 +337,7 @@ static int kernel_maps__split_kallsyms(symbol_filter_t filter, int use_modules)
 				return -1;
 			}
 
-			map->map_ip = vdso__map_ip;
+			map->map_ip = map->unmap_ip = identity__map_ip;
 			kernel_maps__insert(map);
 			++kernel_range;
 		}
@@ -790,7 +790,8 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
 					dso__delete(curr_dso);
 					goto out_elf_end;
 				}
-				curr_map->map_ip = vdso__map_ip;
+				curr_map->map_ip = identity__map_ip;
+				curr_map->unmap_ip = identity__map_ip;
 				curr_dso->origin = DSO__ORIG_KERNEL;
 				kernel_maps__insert(curr_map);
 				dsos__add(curr_dso);
@@ -1158,6 +1159,7 @@ static struct map *map__new2(u64 start, struct dso *dso)
 		self->pgoff = 0;
 		self->dso = dso;
 		self->map_ip = map__map_ip;
+		self->unmap_ip = map__unmap_ip;
 		RB_CLEAR_NODE(&self->rb_node);
 	}
 	return self;
@@ -1259,7 +1261,7 @@ int dsos__load_kernel(const char *vmlinux, unsigned int sym_priv_size,
 	if (kernel_map == NULL)
 		goto out_delete_dso;
 
-	kernel_map->map_ip = vdso__map_ip;
+	kernel_map->map_ip = kernel_map->unmap_ip = identity__map_ip;
 
 	if (use_modules && dsos__load_modules(sym_priv_size) < 0) {
 		fprintf(stderr, "Failed to load list of modules in use! "
-- 
1.5.5.1

