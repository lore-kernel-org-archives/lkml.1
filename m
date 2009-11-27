Return-Path: <linux-kernel-owner+w=401wt.eu-S1753429AbZK0S3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429AbZK0S3v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 13:29:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753310AbZK0S3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 13:29:48 -0500
Received: from casper.infradead.org ([85.118.1.10]:43555 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308AbZK0S3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 13:29:44 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 02/12] perf symbols: Rename kernel_map[s] to kernel_map[s]__functions
Date: Fri, 27 Nov 2009 16:29:13 -0200
Message-Id: <1259346563-12568-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1259346563-12568-1-git-send-email-acme@infradead.org>
References: <1259346563-12568-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

As we'll have kernel_map[s]__variables too.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c |    2 +-
 tools/perf/util/symbol.c      |   46 ++++++++++++++++++++--------------------
 tools/perf/util/symbol.h      |    2 +-
 3 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 18ac5ea..377cb7c 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -184,7 +184,7 @@ got_map:
 			 * trick of looking in the whole kernel symbol list.
 			 */
 			if ((long long)ip < 0) {
-				map = kernel_map;
+				map = kernel_map__functions;
 				goto got_map;
 			}
 		}
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 8aab89b..687fb7f 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -43,7 +43,7 @@ static struct symbol_conf symbol_conf__defaults = {
 	.try_vmlinux_path = true,
 };
 
-static struct rb_root kernel_maps;
+static struct rb_root kernel_maps__functions;
 
 static void symbols__fixup_end(struct rb_root *self)
 {
@@ -71,7 +71,7 @@ static void symbols__fixup_end(struct rb_root *self)
 static void kernel_maps__fixup_end(void)
 {
 	struct map *prev, *curr;
-	struct rb_node *nd, *prevnd = rb_first(&kernel_maps);
+	struct rb_node *nd, *prevnd = rb_first(&kernel_maps__functions);
 
 	if (prevnd == NULL)
 		return;
@@ -325,7 +325,7 @@ static int kernel_maps__load_all_kallsyms(void)
 		 * kernel_maps__split_kallsyms, when we have split the
 		 * maps per module
 		 */
-		symbols__insert(&kernel_map->dso->functions, sym);
+		symbols__insert(&kernel_map__functions->dso->functions, sym);
 	}
 
 	free(line);
@@ -346,10 +346,10 @@ out_failure:
  */
 static int kernel_maps__split_kallsyms(symbol_filter_t filter)
 {
-	struct map *map = kernel_map;
+	struct map *map = kernel_map__functions;
 	struct symbol *pos;
 	int count = 0;
-	struct rb_node *next = rb_first(&kernel_map->dso->functions);
+	struct rb_node *next = rb_first(&kernel_map__functions->dso->functions);
 	int kernel_range = 0;
 
 	while (next) {
@@ -376,7 +376,7 @@ static int kernel_maps__split_kallsyms(symbol_filter_t filter)
 			 */
 			pos->start = map->map_ip(map, pos->start);
 			pos->end   = map->map_ip(map, pos->end);
-		} else if (map != kernel_map) {
+		} else if (map != kernel_map__functions) {
 			char dso_name[PATH_MAX];
 			struct dso *dso;
 
@@ -399,12 +399,12 @@ static int kernel_maps__split_kallsyms(symbol_filter_t filter)
 		}
 
 		if (filter && filter(map, pos)) {
-			rb_erase(&pos->rb_node, &kernel_map->dso->functions);
+			rb_erase(&pos->rb_node, &kernel_map__functions->dso->functions);
 			symbol__delete(pos);
 		} else {
-			if (map != kernel_map) {
+			if (map != kernel_map__functions) {
 				rb_erase(&pos->rb_node,
-					 &kernel_map->dso->functions);
+					 &kernel_map__functions->dso->functions);
 				symbols__insert(&map->dso->functions, pos);
 			}
 			count++;
@@ -420,8 +420,8 @@ static int kernel_maps__load_kallsyms(symbol_filter_t filter)
 	if (kernel_maps__load_all_kallsyms())
 		return -1;
 
-	symbols__fixup_end(&kernel_map->dso->functions);
-	kernel_map->dso->origin = DSO__ORIG_KERNEL;
+	symbols__fixup_end(&kernel_map__functions->dso->functions);
+	kernel_map__functions->dso->origin = DSO__ORIG_KERNEL;
 
 	return kernel_maps__split_kallsyms(filter);
 }
@@ -431,7 +431,7 @@ size_t kernel_maps__fprintf(FILE *fp)
 	size_t printed = fprintf(fp, "Kernel maps:\n");
 	struct rb_node *nd;
 
-	for (nd = rb_first(&kernel_maps); nd; nd = rb_next(nd)) {
+	for (nd = rb_first(&kernel_maps__functions); nd; nd = rb_next(nd)) {
 		struct map *pos = rb_entry(nd, struct map, rb_node);
 
 		printed += fprintf(fp, "Map:");
@@ -1159,17 +1159,17 @@ out:
 	return ret;
 }
 
-struct map *kernel_map;
+struct map *kernel_map__functions;
 
 static void kernel_maps__insert(struct map *map)
 {
-	maps__insert(&kernel_maps, map);
+	maps__insert(&kernel_maps__functions, map);
 }
 
 struct symbol *kernel_maps__find_function(u64 ip, struct map **mapp,
 					  symbol_filter_t filter)
 {
-	struct map *map = maps__find(&kernel_maps, ip);
+	struct map *map = maps__find(&kernel_maps__functions, ip);
 
 	if (mapp)
 		*mapp = map;
@@ -1178,7 +1178,7 @@ struct symbol *kernel_maps__find_function(u64 ip, struct map **mapp,
 		ip = map->map_ip(map, ip);
 		return map__find_function(map, ip, filter);
 	} else
-		WARN_ONCE(RB_EMPTY_ROOT(&kernel_maps),
+		WARN_ONCE(RB_EMPTY_ROOT(&kernel_maps__functions),
 			  "Empty kernel_maps, was symbol__init() called?\n");
 
 	return NULL;
@@ -1188,7 +1188,7 @@ struct map *kernel_maps__find_by_dso_name(const char *name)
 {
 	struct rb_node *nd;
 
-	for (nd = rb_first(&kernel_maps); nd; nd = rb_next(nd)) {
+	for (nd = rb_first(&kernel_maps__functions); nd; nd = rb_next(nd)) {
 		struct map *map = rb_entry(nd, struct map, rb_node);
 
 		if (map->dso && strcmp(map->dso->name, name) == 0)
@@ -1505,11 +1505,11 @@ static int kernel_maps__create_kernel_map(const struct symbol_conf *conf)
 	if (kernel == NULL)
 		return -1;
 
-	kernel_map = map__new2(0, kernel);
-	if (kernel_map == NULL)
+	kernel_map__functions = map__new2(0, kernel);
+	if (kernel_map__functions == NULL)
 		goto out_delete_kernel_dso;
 
-	kernel_map->map_ip	 = kernel_map->unmap_ip = identity__map_ip;
+	kernel_map__functions->map_ip	 = kernel_map__functions->unmap_ip = identity__map_ip;
 	kernel->short_name	 = "[kernel]";
 	kernel->kernel		 = 1;
 
@@ -1522,15 +1522,15 @@ static int kernel_maps__create_kernel_map(const struct symbol_conf *conf)
 				 sizeof(kernel->build_id)) == 0)
 		kernel->has_build_id = true;
 
-	kernel_maps__insert(kernel_map);
+	kernel_maps__insert(kernel_map__functions);
 	dsos__add(kernel);
 	dsos__add(vdso);
 
 	return 0;
 
 out_delete_kernel_map:
-	map__delete(kernel_map);
-	kernel_map = NULL;
+	map__delete(kernel_map__functions);
+	kernel_map__functions = NULL;
 out_delete_kernel_dso:
 	dso__delete(kernel);
 	return -1;
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 65846d0..b42d196 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -105,6 +105,6 @@ size_t kernel_maps__fprintf(FILE *fp);
 int symbol__init(struct symbol_conf *conf);
 
 extern struct list_head dsos;
-extern struct map *kernel_map;
+extern struct map *kernel_map__functions;
 extern struct dso *vdso;
 #endif /* __PERF_SYMBOL */
-- 
1.6.2.5

