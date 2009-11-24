Return-Path: <linux-kernel-owner+w=401wt.eu-S933189AbZKXPCE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933189AbZKXPCE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 10:02:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757782AbZKXPCE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 10:02:04 -0500
Received: from casper.infradead.org ([85.118.1.10]:47106 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757567AbZKXPCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 10:02:01 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/1] perf symbols: Rename find_symbol routines to find_function
Date: Tue, 24 Nov 2009 13:01:52 -0200
Message-Id: <1259074912-5924-1-git-send-email-acme@infradead.org>
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

Paving the way for supporting variable in adition to function symbols.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c |    4 +-
 tools/perf/builtin-kmem.c     |    2 +-
 tools/perf/builtin-report.c   |    8 ++--
 tools/perf/builtin-top.c      |    4 +-
 tools/perf/util/event.h       |    7 ++--
 tools/perf/util/map.c         |   14 ++++----
 tools/perf/util/symbol.c      |   68 ++++++++++++++++++++++------------------
 tools/perf/util/symbol.h      |    6 ++--
 tools/perf/util/thread.h      |    4 +-
 9 files changed, 62 insertions(+), 55 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 45069a4..117e281 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -161,7 +161,7 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 
 	if (event->header.misc & PERF_RECORD_MISC_KERNEL) {
 		level = 'k';
-		sym = kernel_maps__find_symbol(ip, &map, symbol_filter);
+		sym = kernel_maps__find_function(ip, &map, symbol_filter);
 		dump_printf(" ...... dso: %s\n",
 			    map ? map->dso->long_name : "<not found>");
 	} else if (event->header.misc & PERF_RECORD_MISC_USER) {
@@ -170,7 +170,7 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 		if (map != NULL) {
 got_map:
 			ip = map->map_ip(map, ip);
-			sym = map__find_symbol(map, ip, symbol_filter);
+			sym = map__find_function(map, ip, symbol_filter);
 		} else {
 			/*
 			 * If this is outside of all known maps,
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 38b01a9..653eec5 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -323,7 +323,7 @@ static void __print_result(struct rb_root *root, int n_lines, int is_caller)
 
 		if (is_caller) {
 			addr = data->call_site;
-			sym = kernel_maps__find_symbol(addr, NULL, NULL);
+			sym = kernel_maps__find_function(addr, NULL, NULL);
 		} else
 			addr = data->ptr;
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index b16f86d..ccbf454 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -450,14 +450,14 @@ got_map:
 		 * trick of looking in the whole kernel symbol list.
 		 */
 		if ((long long)ip < 0)
-			return kernel_maps__find_symbol(ip, mapp, NULL);
+			return kernel_maps__find_function(ip, mapp, NULL);
 	}
 	dump_printf(" ...... dso: %s\n",
 		    map ? map->dso->long_name : "<not found>");
 	dump_printf(" ...... map: %Lx -> %Lx\n", *ipp, ip);
 	*ipp  = ip;
 
-	return map ? map__find_symbol(map, ip, NULL) : NULL;
+	return map ? map__find_function(map, ip, NULL) : NULL;
 }
 
 static int call__match(struct symbol *sym)
@@ -497,7 +497,7 @@ static struct symbol **resolve_callchain(struct thread *thread,
 		case PERF_CONTEXT_HV:
 			break;
 		case PERF_CONTEXT_KERNEL:
-			sym = kernel_maps__find_symbol(ip, NULL, NULL);
+			sym = kernel_maps__find_function(ip, NULL, NULL);
 			break;
 		default:
 			sym = resolve_symbol(thread, NULL, &ip);
@@ -717,7 +717,7 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 
 	if (cpumode == PERF_RECORD_MISC_KERNEL) {
 		level = 'k';
-		sym = kernel_maps__find_symbol(ip, &map, NULL);
+		sym = kernel_maps__find_function(ip, &map, NULL);
 		dump_printf(" ...... dso: %s\n",
 			    map ? map->dso->long_name : "<not found>");
 	} else if (cpumode == PERF_RECORD_MISC_USER) {
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 4c8653a..ded6cf6 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -948,7 +948,7 @@ static void event__process_sample(const event_t *self, int counter)
 		map = thread__find_map(thread, ip);
 		if (map != NULL) {
 			ip = map->map_ip(map, ip);
-			sym = map__find_symbol(map, ip, symbol_filter);
+			sym = map__find_function(map, ip, symbol_filter);
 			if (sym == NULL)
 				return;
 			userspace_samples++;
@@ -968,7 +968,7 @@ static void event__process_sample(const event_t *self, int counter)
 		if (hide_kernel_symbols)
 			return;
 
-		sym = kernel_maps__find_symbol(ip, &map, symbol_filter);
+		sym = kernel_maps__find_function(ip, &map, symbol_filter);
 		if (sym == NULL)
 			return;
 		break;
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index f1e3926..882a953 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -119,9 +119,10 @@ void map__delete(struct map *self);
 struct map *map__clone(struct map *self);
 int map__overlap(struct map *l, struct map *r);
 size_t map__fprintf(struct map *self, FILE *fp);
-struct symbol *map__find_symbol(struct map *self, u64 ip, symbol_filter_t filter);
-void map__fixup_start(struct map *self);
-void map__fixup_end(struct map *self);
+struct symbol *map__find_function(struct map *self, u64 ip,
+				  symbol_filter_t filter);
+void map__fixup_start(struct map *self, struct rb_root *symbols);
+void map__fixup_end(struct map *self, struct rb_root *symbols);
 
 int event__synthesize_thread(pid_t pid, int (*process)(event_t *event));
 void event__synthesize_threads(int (*process)(event_t *event));
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 0941232..41c5c4a 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -80,18 +80,18 @@ void map__delete(struct map *self)
 	free(self);
 }
 
-void map__fixup_start(struct map *self)
+void map__fixup_start(struct map *self, struct rb_root *symbols)
 {
-	struct rb_node *nd = rb_first(&self->dso->syms);
+	struct rb_node *nd = rb_first(symbols);
 	if (nd != NULL) {
 		struct symbol *sym = rb_entry(nd, struct symbol, rb_node);
 		self->start = sym->start;
 	}
 }
 
-void map__fixup_end(struct map *self)
+void map__fixup_end(struct map *self, struct rb_root *symbols)
 {
-	struct rb_node *nd = rb_last(&self->dso->syms);
+	struct rb_node *nd = rb_last(symbols);
 	if (nd != NULL) {
 		struct symbol *sym = rb_entry(nd, struct symbol, rb_node);
 		self->end = sym->end;
@@ -100,8 +100,8 @@ void map__fixup_end(struct map *self)
 
 #define DSO__DELETED "(deleted)"
 
-struct symbol *
-map__find_symbol(struct map *self, u64 ip, symbol_filter_t filter)
+struct symbol *map__find_function(struct map *self, u64 ip,
+				  symbol_filter_t filter)
 {
 	if (!self->dso->loaded) {
 		int nr = dso__load(self->dso, self, filter);
@@ -136,7 +136,7 @@ map__find_symbol(struct map *self, u64 ip, symbol_filter_t filter)
 		}
 	}
 
-	return self->dso->find_symbol(self->dso, ip);
+	return self->dso->find_function(self->dso, ip);
 }
 
 struct map *map__clone(struct map *self)
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 8db85b4..4ed379b 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -45,9 +45,9 @@ static struct symbol_conf symbol_conf__defaults = {
 
 static struct rb_root kernel_maps;
 
-static void dso__fixup_sym_end(struct dso *self)
+static void symbols__fixup_end(struct rb_root *self)
 {
-	struct rb_node *nd, *prevnd = rb_first(&self->syms);
+	struct rb_node *nd, *prevnd = rb_first(self);
 	struct symbol *curr, *prev;
 
 	if (prevnd == NULL)
@@ -144,8 +144,8 @@ struct dso *dso__new(const char *name)
 		strcpy(self->name, name);
 		dso__set_long_name(self, self->name);
 		self->short_name = self->name;
-		self->syms = RB_ROOT;
-		self->find_symbol = dso__find_symbol;
+		self->functions = RB_ROOT;
+		self->find_function = dso__find_function;
 		self->slen_calculated = 0;
 		self->origin = DSO__ORIG_NOT_FOUND;
 		self->loaded = 0;
@@ -155,22 +155,22 @@ struct dso *dso__new(const char *name)
 	return self;
 }
 
-static void dso__delete_symbols(struct dso *self)
+static void symbols__delete(struct rb_root *self)
 {
 	struct symbol *pos;
-	struct rb_node *next = rb_first(&self->syms);
+	struct rb_node *next = rb_first(self);
 
 	while (next) {
 		pos = rb_entry(next, struct symbol, rb_node);
 		next = rb_next(&pos->rb_node);
-		rb_erase(&pos->rb_node, &self->syms);
+		rb_erase(&pos->rb_node, self);
 		symbol__delete(pos);
 	}
 }
 
 void dso__delete(struct dso *self)
 {
-	dso__delete_symbols(self);
+	symbols__delete(&self->functions);
 	if (self->long_name != self->name)
 		free(self->long_name);
 	free(self);
@@ -182,9 +182,9 @@ void dso__set_build_id(struct dso *self, void *build_id)
 	self->has_build_id = 1;
 }
 
-static void dso__insert_symbol(struct dso *self, struct symbol *sym)
+static void symbols__insert(struct rb_root *self, struct symbol *sym)
 {
-	struct rb_node **p = &self->syms.rb_node;
+	struct rb_node **p = &self->rb_node;
 	struct rb_node *parent = NULL;
 	const u64 ip = sym->start;
 	struct symbol *s;
@@ -198,17 +198,17 @@ static void dso__insert_symbol(struct dso *self, struct symbol *sym)
 			p = &(*p)->rb_right;
 	}
 	rb_link_node(&sym->rb_node, parent, p);
-	rb_insert_color(&sym->rb_node, &self->syms);
+	rb_insert_color(&sym->rb_node, self);
 }
 
-struct symbol *dso__find_symbol(struct dso *self, u64 ip)
+static struct symbol *symbols__find(struct rb_root *self, u64 ip)
 {
 	struct rb_node *n;
 
 	if (self == NULL)
 		return NULL;
 
-	n = self->syms.rb_node;
+	n = self->rb_node;
 
 	while (n) {
 		struct symbol *s = rb_entry(n, struct symbol, rb_node);
@@ -224,6 +224,11 @@ struct symbol *dso__find_symbol(struct dso *self, u64 ip)
 	return NULL;
 }
 
+struct symbol *dso__find_function(struct dso *self, u64 ip)
+{
+	return symbols__find(&self->functions, ip);
+}
+
 int build_id__sprintf(u8 *self, int len, char *bf)
 {
 	char *bid = bf;
@@ -253,9 +258,9 @@ size_t dso__fprintf(struct dso *self, FILE *fp)
 	size_t ret = fprintf(fp, "dso: %s (", self->short_name);
 
 	ret += dso__fprintf_buildid(self, fp);
-	ret += fprintf(fp, ")\n");
+	ret += fprintf(fp, ")\nFunctions:\n");
 
-	for (nd = rb_first(&self->syms); nd; nd = rb_next(nd)) {
+	for (nd = rb_first(&self->functions); nd; nd = rb_next(nd)) {
 		struct symbol *pos = rb_entry(nd, struct symbol, rb_node);
 		ret += symbol__fprintf(pos, fp);
 	}
@@ -320,7 +325,7 @@ static int kernel_maps__load_all_kallsyms(void)
 		 * kernel_maps__split_kallsyms, when we have split the
 		 * maps per module
 		 */
-		dso__insert_symbol(kernel_map->dso, sym);
+		symbols__insert(&kernel_map->dso->functions, sym);
 	}
 
 	free(line);
@@ -344,7 +349,7 @@ static int kernel_maps__split_kallsyms(symbol_filter_t filter)
 	struct map *map = kernel_map;
 	struct symbol *pos;
 	int count = 0;
-	struct rb_node *next = rb_first(&kernel_map->dso->syms);
+	struct rb_node *next = rb_first(&kernel_map->dso->functions);
 	int kernel_range = 0;
 
 	while (next) {
@@ -394,12 +399,13 @@ static int kernel_maps__split_kallsyms(symbol_filter_t filter)
 		}
 
 		if (filter && filter(map, pos)) {
-			rb_erase(&pos->rb_node, &kernel_map->dso->syms);
+			rb_erase(&pos->rb_node, &kernel_map->dso->functions);
 			symbol__delete(pos);
 		} else {
 			if (map != kernel_map) {
-				rb_erase(&pos->rb_node, &kernel_map->dso->syms);
-				dso__insert_symbol(map->dso, pos);
+				rb_erase(&pos->rb_node,
+					 &kernel_map->dso->functions);
+				symbols__insert(&map->dso->functions, pos);
 			}
 			count++;
 		}
@@ -414,7 +420,7 @@ static int kernel_maps__load_kallsyms(symbol_filter_t filter)
 	if (kernel_maps__load_all_kallsyms())
 		return -1;
 
-	dso__fixup_sym_end(kernel_map->dso);
+	symbols__fixup_end(&kernel_map->dso->functions);
 	kernel_map->dso->origin = DSO__ORIG_KERNEL;
 
 	return kernel_maps__split_kallsyms(filter);
@@ -485,7 +491,7 @@ static int dso__load_perf_map(struct dso *self, struct map *map,
 		if (filter && filter(map, sym))
 			symbol__delete(sym);
 		else {
-			dso__insert_symbol(self, sym);
+			symbols__insert(&self->functions, sym);
 			nr_syms++;
 		}
 	}
@@ -683,7 +689,7 @@ static int dso__synthesize_plt_symbols(struct  dso *self, struct map *map,
 			if (filter && filter(map, f))
 				symbol__delete(f);
 			else {
-				dso__insert_symbol(self, f);
+				symbols__insert(&self->functions, f);
 				++nr;
 			}
 		}
@@ -705,7 +711,7 @@ static int dso__synthesize_plt_symbols(struct  dso *self, struct map *map,
 			if (filter && filter(map, f))
 				symbol__delete(f);
 			else {
-				dso__insert_symbol(self, f);
+				symbols__insert(&self->functions, f);
 				++nr;
 			}
 		}
@@ -879,7 +885,7 @@ new_symbol:
 		if (filter && filter(curr_map, f))
 			symbol__delete(f);
 		else {
-			dso__insert_symbol(curr_dso, f);
+			symbols__insert(&curr_dso->functions, f);
 			nr++;
 		}
 	}
@@ -888,7 +894,7 @@ new_symbol:
 	 * For misannotated, zeroed, ASM function sizes.
 	 */
 	if (nr > 0)
-		dso__fixup_sym_end(self);
+		symbols__fixup_end(&self->functions);
 	err = nr;
 out_elf_end:
 	elf_end(elf);
@@ -1160,8 +1166,8 @@ static void kernel_maps__insert(struct map *map)
 	maps__insert(&kernel_maps, map);
 }
 
-struct symbol *kernel_maps__find_symbol(u64 ip, struct map **mapp,
-					symbol_filter_t filter)
+struct symbol *kernel_maps__find_function(u64 ip, struct map **mapp,
+					  symbol_filter_t filter)
 {
 	struct map *map = maps__find(&kernel_maps, ip);
 
@@ -1170,7 +1176,7 @@ struct symbol *kernel_maps__find_symbol(u64 ip, struct map **mapp,
 
 	if (map) {
 		ip = map->map_ip(map, ip);
-		return map__find_symbol(map, ip, filter);
+		return map__find_function(map, ip, filter);
 	} else
 		WARN_ONCE(RB_EMPTY_ROOT(&kernel_maps),
 			  "Empty kernel_maps, was symbol__init() called?\n");
@@ -1432,8 +1438,8 @@ do_kallsyms:
 
 	if (err > 0) {
 out_fixup:
-		map__fixup_start(map);
-		map__fixup_end(map);
+		map__fixup_start(map, &map->dso->functions);
+		map__fixup_end(map, &map->dso->functions);
 	}
 
 	return err;
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 5538691..65846d0 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -65,8 +65,8 @@ static inline void *symbol__priv(struct symbol *self)
 
 struct dso {
 	struct list_head node;
-	struct rb_root	 syms;
-	struct symbol    *(*find_symbol)(struct dso *, u64 ip);
+	struct rb_root	 functions;
+	struct symbol    *(*find_function)(struct dso *, u64 ip);
 	u8		 adjust_symbols:1;
 	u8		 slen_calculated:1;
 	u8		 loaded:1;
@@ -83,7 +83,7 @@ struct dso {
 struct dso *dso__new(const char *name);
 void dso__delete(struct dso *self);
 
-struct symbol *dso__find_symbol(struct dso *self, u64 ip);
+struct symbol *dso__find_function(struct dso *self, u64 ip);
 
 struct dso *dsos__findnew(const char *name);
 int dso__load(struct dso *self, struct map *map, symbol_filter_t filter);
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index e4b8d43..74cba64 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -26,8 +26,8 @@ size_t threads__fprintf(FILE *fp);
 void maps__insert(struct rb_root *maps, struct map *map);
 struct map *maps__find(struct rb_root *maps, u64 ip);
 
-struct symbol *kernel_maps__find_symbol(const u64 ip, struct map **mapp,
-					symbol_filter_t filter);
+struct symbol *kernel_maps__find_function(const u64 ip, struct map **mapp,
+					  symbol_filter_t filter);
 struct map *kernel_maps__find_by_dso_name(const char *name);
 
 static inline struct map *thread__find_map(struct thread *self, u64 ip)
-- 
1.6.2.5

