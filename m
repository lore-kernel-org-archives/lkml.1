Return-Path: <linux-kernel-owner+w=401wt.eu-S1753107AbZK0S3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107AbZK0S3h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 13:29:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752812AbZK0S3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 13:29:36 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:42043 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024AbZK0S3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 13:29:31 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 06/12] perf symbols: Better support for multiple symbol tables per dso
Date: Fri, 27 Nov 2009 16:29:17 -0200
Message-Id: <1259346563-12568-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1259346563-12568-5-git-send-email-acme@infradead.org>
References: <1259346563-12568-1-git-send-email-acme@infradead.org>
 <1259346563-12568-2-git-send-email-acme@infradead.org>
 <1259346563-12568-3-git-send-email-acme@infradead.org>
 <1259346563-12568-4-git-send-email-acme@infradead.org>
 <1259346563-12568-5-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

By using an array of rb_roots in struct dso we can, from a struct map
instance to get the right symbol rb_tree more easily. This way we can
have just one symbol lookup method for struct map instances,
map__find_symbol, instead of one per symtab type (functions, variables).

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c |    2 +-
 tools/perf/builtin-report.c   |    2 +-
 tools/perf/builtin-top.c      |    2 +-
 tools/perf/util/event.h       |   12 +++++---
 tools/perf/util/map.c         |   12 +++++---
 tools/perf/util/symbol.c      |   59 +++++++++++++++++++++++++----------------
 tools/perf/util/symbol.h      |    7 ++---
 7 files changed, 56 insertions(+), 40 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 0846c8a..c32e760 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -170,7 +170,7 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 		map = thread__find_map(thread, ip);
 		if (map != NULL) {
 			ip = map->map_ip(map, ip);
-			sym = map__find_function(map, ip, symbol_filter);
+			sym = map__find_symbol(map, ip, symbol_filter);
 		} else {
 			/*
 			 * If this is outside of all known maps,
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index e4b1004..400bef9 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -455,7 +455,7 @@ got_map:
 	dump_printf(" ...... map: %Lx -> %Lx\n", *ipp, ip);
 	*ipp  = ip;
 
-	return map ? map__find_function(map, ip, NULL) : NULL;
+	return map ? map__find_symbol(map, ip, NULL) : NULL;
 }
 
 static int call__match(struct symbol *sym)
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index a0168f2..abe78bb 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -948,7 +948,7 @@ static void event__process_sample(const event_t *self, int counter)
 		map = thread__find_map(thread, ip);
 		if (map != NULL) {
 			ip = map->map_ip(map, ip);
-			sym = map__find_function(map, ip, symbol_filter);
+			sym = map__find_symbol(map, ip, symbol_filter);
 			if (sym == NULL)
 				return;
 			userspace_samples++;
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 29543bd..3ae3c96 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -81,7 +81,9 @@ typedef union event_union {
 } event_t;
 
 enum map_type {
-	MAP__FUNCTION,
+	MAP__FUNCTION = 0,
+
+	MAP__NR_TYPES,
 };
 
 struct map {
@@ -125,10 +127,10 @@ void map__delete(struct map *self);
 struct map *map__clone(struct map *self);
 int map__overlap(struct map *l, struct map *r);
 size_t map__fprintf(struct map *self, FILE *fp);
-struct symbol *map__find_function(struct map *self, u64 ip,
-				  symbol_filter_t filter);
-void map__fixup_start(struct map *self, struct rb_root *symbols);
-void map__fixup_end(struct map *self, struct rb_root *symbols);
+struct symbol *map__find_symbol(struct map *self, u64 addr,
+				symbol_filter_t filter);
+void map__fixup_start(struct map *self);
+void map__fixup_end(struct map *self);
 
 int event__synthesize_thread(pid_t pid, int (*process)(event_t *event));
 void event__synthesize_threads(int (*process)(event_t *event));
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 52bb4c6..69f94fe 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -82,8 +82,9 @@ void map__delete(struct map *self)
 	free(self);
 }
 
-void map__fixup_start(struct map *self, struct rb_root *symbols)
+void map__fixup_start(struct map *self)
 {
+	struct rb_root *symbols = &self->dso->symbols[self->type];
 	struct rb_node *nd = rb_first(symbols);
 	if (nd != NULL) {
 		struct symbol *sym = rb_entry(nd, struct symbol, rb_node);
@@ -91,8 +92,9 @@ void map__fixup_start(struct map *self, struct rb_root *symbols)
 	}
 }
 
-void map__fixup_end(struct map *self, struct rb_root *symbols)
+void map__fixup_end(struct map *self)
 {
+	struct rb_root *symbols = &self->dso->symbols[self->type];
 	struct rb_node *nd = rb_last(symbols);
 	if (nd != NULL) {
 		struct symbol *sym = rb_entry(nd, struct symbol, rb_node);
@@ -102,8 +104,8 @@ void map__fixup_end(struct map *self, struct rb_root *symbols)
 
 #define DSO__DELETED "(deleted)"
 
-struct symbol *map__find_function(struct map *self, u64 ip,
-				  symbol_filter_t filter)
+struct symbol *map__find_symbol(struct map *self, u64 addr,
+				symbol_filter_t filter)
 {
 	if (!dso__loaded(self->dso, self->type)) {
 		int nr = dso__load(self->dso, self, filter);
@@ -138,7 +140,7 @@ struct symbol *map__find_function(struct map *self, u64 ip,
 		}
 	}
 
-	return self->dso->find_function(self->dso, ip);
+	return self->dso->find_symbol(self->dso, self->type, addr);
 }
 
 struct map *map__clone(struct map *self)
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 45a4a9a..9a2dd81 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -31,6 +31,7 @@ enum dso_origin {
 static void dsos__add(struct list_head *head, struct dso *dso);
 static struct map *map__new2(u64 start, struct dso *dso, enum map_type type);
 static void kernel_maps__insert(struct map *map);
+struct symbol *dso__find_symbol(struct dso *self, enum map_type type, u64 addr);
 static int dso__load_kernel_sym(struct dso *self, struct map *map,
 				symbol_filter_t filter);
 unsigned int symbol__priv_size;
@@ -151,11 +152,13 @@ struct dso *dso__new(const char *name)
 	struct dso *self = malloc(sizeof(*self) + strlen(name) + 1);
 
 	if (self != NULL) {
+		int i;
 		strcpy(self->name, name);
 		dso__set_long_name(self, self->name);
 		self->short_name = self->name;
-		self->functions = RB_ROOT;
-		self->find_function = dso__find_function;
+		for (i = 0; i < MAP__NR_TYPES; ++i)
+			self->symbols[i] = RB_ROOT;
+		self->find_symbol = dso__find_symbol;
 		self->slen_calculated = 0;
 		self->origin = DSO__ORIG_NOT_FOUND;
 		self->loaded = 0;
@@ -180,7 +183,9 @@ static void symbols__delete(struct rb_root *self)
 
 void dso__delete(struct dso *self)
 {
-	symbols__delete(&self->functions);
+	int i;
+	for (i = 0; i < MAP__NR_TYPES; ++i)
+		symbols__delete(&self->symbols[i]);
 	if (self->long_name != self->name)
 		free(self->long_name);
 	free(self);
@@ -234,9 +239,9 @@ static struct symbol *symbols__find(struct rb_root *self, u64 ip)
 	return NULL;
 }
 
-struct symbol *dso__find_function(struct dso *self, u64 ip)
+struct symbol *dso__find_symbol(struct dso *self, enum map_type type, u64 addr)
 {
-	return symbols__find(&self->functions, ip);
+	return symbols__find(&self->symbols[type], addr);
 }
 
 int build_id__sprintf(u8 *self, int len, char *bf)
@@ -262,17 +267,25 @@ size_t dso__fprintf_buildid(struct dso *self, FILE *fp)
 	return fprintf(fp, "%s", sbuild_id);
 }
 
+static const char * map_type__name[MAP__NR_TYPES] = {
+	[MAP__FUNCTION] = "Functions",
+};
+
 size_t dso__fprintf(struct dso *self, FILE *fp)
 {
+	int i;
 	struct rb_node *nd;
 	size_t ret = fprintf(fp, "dso: %s (", self->short_name);
 
 	ret += dso__fprintf_buildid(self, fp);
-	ret += fprintf(fp, ")\nFunctions:\n");
+	ret += fprintf(fp, ")\n");
+	for (i = 0; i < MAP__NR_TYPES; ++i) {
+		ret += fprintf(fp, "%s:\n", map_type__name[i]);
 
-	for (nd = rb_first(&self->functions); nd; nd = rb_next(nd)) {
-		struct symbol *pos = rb_entry(nd, struct symbol, rb_node);
-		ret += symbol__fprintf(pos, fp);
+		for (nd = rb_first(&self->symbols[i]); nd; nd = rb_next(nd)) {
+			struct symbol *pos = rb_entry(nd, struct symbol, rb_node);
+			ret += symbol__fprintf(pos, fp);
+		}
 	}
 
 	return ret;
@@ -335,7 +348,7 @@ static int kernel_maps__load_all_kallsyms(void)
 		 * kernel_maps__split_kallsyms, when we have split the
 		 * maps per module
 		 */
-		symbols__insert(&kernel_map__functions->dso->functions, sym);
+		symbols__insert(&kernel_map__functions->dso->symbols[MAP__FUNCTION], sym);
 	}
 
 	free(line);
@@ -359,7 +372,7 @@ static int kernel_maps__split_kallsyms(symbol_filter_t filter)
 	struct map *map = kernel_map__functions;
 	struct symbol *pos;
 	int count = 0;
-	struct rb_node *next = rb_first(&kernel_map__functions->dso->functions);
+	struct rb_node *next = rb_first(&kernel_map__functions->dso->symbols[map->type]);
 	int kernel_range = 0;
 
 	while (next) {
@@ -409,13 +422,13 @@ static int kernel_maps__split_kallsyms(symbol_filter_t filter)
 		}
 
 		if (filter && filter(map, pos)) {
-			rb_erase(&pos->rb_node, &kernel_map__functions->dso->functions);
+			rb_erase(&pos->rb_node, &kernel_map__functions->dso->symbols[map->type]);
 			symbol__delete(pos);
 		} else {
 			if (map != kernel_map__functions) {
 				rb_erase(&pos->rb_node,
-					 &kernel_map__functions->dso->functions);
-				symbols__insert(&map->dso->functions, pos);
+					 &kernel_map__functions->dso->symbols[map->type]);
+				symbols__insert(&map->dso->symbols[map->type], pos);
 			}
 			count++;
 		}
@@ -430,7 +443,7 @@ static int kernel_maps__load_kallsyms(symbol_filter_t filter)
 	if (kernel_maps__load_all_kallsyms())
 		return -1;
 
-	symbols__fixup_end(&kernel_map__functions->dso->functions);
+	symbols__fixup_end(&kernel_map__functions->dso->symbols[MAP__FUNCTION]);
 	kernel_map__functions->dso->origin = DSO__ORIG_KERNEL;
 
 	return kernel_maps__split_kallsyms(filter);
@@ -501,7 +514,7 @@ static int dso__load_perf_map(struct dso *self, struct map *map,
 		if (filter && filter(map, sym))
 			symbol__delete(sym);
 		else {
-			symbols__insert(&self->functions, sym);
+			symbols__insert(&self->symbols[map->type], sym);
 			nr_syms++;
 		}
 	}
@@ -699,7 +712,7 @@ static int dso__synthesize_plt_symbols(struct  dso *self, struct map *map,
 			if (filter && filter(map, f))
 				symbol__delete(f);
 			else {
-				symbols__insert(&self->functions, f);
+				symbols__insert(&self->symbols[map->type], f);
 				++nr;
 			}
 		}
@@ -721,7 +734,7 @@ static int dso__synthesize_plt_symbols(struct  dso *self, struct map *map,
 			if (filter && filter(map, f))
 				symbol__delete(f);
 			else {
-				symbols__insert(&self->functions, f);
+				symbols__insert(&self->symbols[map->type], f);
 				++nr;
 			}
 		}
@@ -896,7 +909,7 @@ new_symbol:
 		if (filter && filter(curr_map, f))
 			symbol__delete(f);
 		else {
-			symbols__insert(&curr_dso->functions, f);
+			symbols__insert(&curr_dso->symbols[curr_map->type], f);
 			nr++;
 		}
 	}
@@ -905,7 +918,7 @@ new_symbol:
 	 * For misannotated, zeroed, ASM function sizes.
 	 */
 	if (nr > 0)
-		symbols__fixup_end(&self->functions);
+		symbols__fixup_end(&self->symbols[map->type]);
 	err = nr;
 out_elf_end:
 	elf_end(elf);
@@ -1191,7 +1204,7 @@ struct symbol *kernel_maps__find_function(u64 ip, struct map **mapp,
 
 	if (map) {
 		ip = map->map_ip(map, ip);
-		return map__find_function(map, ip, filter);
+		return map__find_symbol(map, ip, filter);
 	} else
 		WARN_ONCE(RB_EMPTY_ROOT(&kernel_maps__functions),
 			  "Empty kernel_maps, was symbol__init() called?\n");
@@ -1453,8 +1466,8 @@ do_kallsyms:
 
 	if (err > 0) {
 out_fixup:
-		map__fixup_start(map, &map->dso->functions);
-		map__fixup_end(map, &map->dso->functions);
+		map__fixup_start(map);
+		map__fixup_end(map);
 	}
 
 	return err;
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 11d4195..8934814 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -65,8 +65,9 @@ static inline void *symbol__priv(struct symbol *self)
 
 struct dso {
 	struct list_head node;
-	struct rb_root	 functions;
-	struct symbol    *(*find_function)(struct dso *, u64 ip);
+	struct rb_root	 symbols[MAP__NR_TYPES];
+	struct symbol    *(*find_symbol)(struct dso *self,
+					 enum map_type type, u64 addr);
 	u8		 adjust_symbols:1;
 	u8		 slen_calculated:1;
 	u8		 has_build_id:1;
@@ -83,8 +84,6 @@ struct dso {
 struct dso *dso__new(const char *name);
 void dso__delete(struct dso *self);
 
-struct symbol *dso__find_function(struct dso *self, u64 ip);
-
 bool dso__loaded(const struct dso *self, enum map_type type);
 
 struct dso *dsos__findnew(const char *name);
-- 
1.6.2.5

