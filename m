Return-Path: <linux-kernel-owner+w=401wt.eu-S1753164AbZK0S3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164AbZK0S3k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 13:29:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753113AbZK0S3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 13:29:38 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:42042 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015AbZK0S3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 13:29:31 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 07/12] perf symbols: Make the kallsyms loading routines part of the dso class
Date: Fri, 27 Nov 2009 16:29:18 -0200
Message-Id: <1259346563-12568-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1259346563-12568-6-git-send-email-acme@infradead.org>
References: <1259346563-12568-1-git-send-email-acme@infradead.org>
 <1259346563-12568-2-git-send-email-acme@infradead.org>
 <1259346563-12568-3-git-send-email-acme@infradead.org>
 <1259346563-12568-4-git-send-email-acme@infradead.org>
 <1259346563-12568-5-git-send-email-acme@infradead.org>
 <1259346563-12568-6-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

So that the kallsyms loading routines are the direct counterpart of the
vmlinux loading ones, i.e. dso__load_kallsyms is the counterpart of
dso__load_vmlinux.

In the process make them also use the symbols rb tree indexed by
map->type, paving the way for supporting other types of symtabs, such as
the next one to be supported: variables.

This also allowed removal of yet another global variable:
kernel_map__functions.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |   77 ++++++++++++++++++++++-----------------------
 1 files changed, 38 insertions(+), 39 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 9a2dd81..956656f 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -37,7 +37,6 @@ static int dso__load_kernel_sym(struct dso *self, struct map *map,
 unsigned int symbol__priv_size;
 static int vmlinux_path__nr_entries;
 static char **vmlinux_path;
-static struct map *kernel_map__functions;
 
 static struct symbol_conf symbol_conf__defaults = {
 	.use_modules	  = true,
@@ -296,10 +295,11 @@ size_t dso__fprintf(struct dso *self, FILE *fp)
  * so that we can in the next step set the symbol ->end address and then
  * call kernel_maps__split_kallsyms.
  */
-static int kernel_maps__load_all_kallsyms(void)
+static int dso__load_all_kallsyms(struct dso *self, struct map *map)
 {
 	char *line = NULL;
 	size_t n;
+	struct rb_root *root = &self->symbols[map->type];
 	FILE *file = fopen("/proc/kallsyms", "r");
 
 	if (file == NULL)
@@ -342,13 +342,11 @@ static int kernel_maps__load_all_kallsyms(void)
 
 		if (sym == NULL)
 			goto out_delete_line;
-
 		/*
 		 * We will pass the symbols to the filter later, in
-		 * kernel_maps__split_kallsyms, when we have split the
-		 * maps per module
+		 * map__split_kallsyms, when we have split the maps per module
 		 */
-		symbols__insert(&kernel_map__functions->dso->symbols[MAP__FUNCTION], sym);
+		symbols__insert(root, sym);
 	}
 
 	free(line);
@@ -367,12 +365,14 @@ out_failure:
  * kernel range is broken in several maps, named [kernel].N, as we don't have
  * the original ELF section names vmlinux have.
  */
-static int kernel_maps__split_kallsyms(symbol_filter_t filter)
+static int dso__split_kallsyms(struct dso *self, struct map *map,
+			       symbol_filter_t filter)
 {
-	struct map *map = kernel_map__functions;
+	struct map *curr_map = map;
 	struct symbol *pos;
 	int count = 0;
-	struct rb_node *next = rb_first(&kernel_map__functions->dso->symbols[map->type]);
+	struct rb_root *root = &self->symbols[map->type];
+	struct rb_node *next = rb_first(root);
 	int kernel_range = 0;
 
 	while (next) {
@@ -385,9 +385,9 @@ static int kernel_maps__split_kallsyms(symbol_filter_t filter)
 		if (module) {
 			*module++ = '\0';
 
-			if (strcmp(map->dso->name, module)) {
-				map = kernel_maps__find_by_dso_name(module);
-				if (!map) {
+			if (strcmp(self->name, module)) {
+				curr_map = kernel_maps__find_by_dso_name(module);
+				if (curr_map == NULL) {
 					pr_err("/proc/{kallsyms,modules} "
 					       "inconsistency!\n");
 					return -1;
@@ -397,9 +397,9 @@ static int kernel_maps__split_kallsyms(symbol_filter_t filter)
 			 * So that we look just like we get from .ko files,
 			 * i.e. not prelinked, relative to map->start.
 			 */
-			pos->start = map->map_ip(map, pos->start);
-			pos->end   = map->map_ip(map, pos->end);
-		} else if (map != kernel_map__functions) {
+			pos->start = curr_map->map_ip(curr_map, pos->start);
+			pos->end   = curr_map->map_ip(curr_map, pos->end);
+		} else if (curr_map != map) {
 			char dso_name[PATH_MAX];
 			struct dso *dso;
 
@@ -410,25 +410,24 @@ static int kernel_maps__split_kallsyms(symbol_filter_t filter)
 			if (dso == NULL)
 				return -1;
 
-			map = map__new2(pos->start, dso, MAP__FUNCTION);
+			curr_map = map__new2(pos->start, dso, map->type);
 			if (map == NULL) {
 				dso__delete(dso);
 				return -1;
 			}
 
-			map->map_ip = map->unmap_ip = identity__map_ip;
-			kernel_maps__insert(map);
+			curr_map->map_ip = curr_map->unmap_ip = identity__map_ip;
+			kernel_maps__insert(curr_map);
 			++kernel_range;
 		}
 
-		if (filter && filter(map, pos)) {
-			rb_erase(&pos->rb_node, &kernel_map__functions->dso->symbols[map->type]);
+		if (filter && filter(curr_map, pos)) {
+			rb_erase(&pos->rb_node, root);
 			symbol__delete(pos);
 		} else {
-			if (map != kernel_map__functions) {
-				rb_erase(&pos->rb_node,
-					 &kernel_map__functions->dso->symbols[map->type]);
-				symbols__insert(&map->dso->symbols[map->type], pos);
+			if (curr_map != map) {
+				rb_erase(&pos->rb_node, root);
+				symbols__insert(&curr_map->dso->symbols[curr_map->type], pos);
 			}
 			count++;
 		}
@@ -438,15 +437,16 @@ static int kernel_maps__split_kallsyms(symbol_filter_t filter)
 }
 
 
-static int kernel_maps__load_kallsyms(symbol_filter_t filter)
+static int dso__load_kallsyms(struct dso *self, struct map *map,
+			      symbol_filter_t filter)
 {
-	if (kernel_maps__load_all_kallsyms())
+	if (dso__load_all_kallsyms(self, map) < 0)
 		return -1;
 
-	symbols__fixup_end(&kernel_map__functions->dso->symbols[MAP__FUNCTION]);
-	kernel_map__functions->dso->origin = DSO__ORIG_KERNEL;
+	symbols__fixup_end(&self->symbols[map->type]);
+	self->origin = DSO__ORIG_KERNEL;
 
-	return kernel_maps__split_kallsyms(filter);
+	return dso__split_kallsyms(self, map, filter);
 }
 
 size_t kernel_maps__fprintf(FILE *fp)
@@ -1457,9 +1457,8 @@ static int dso__load_kernel_sym(struct dso *self, struct map *map,
 	if (err <= 0) {
 		pr_info("The file %s cannot be used, "
 			"trying to use /proc/kallsyms...", self->long_name);
-		sleep(2);
 do_kallsyms:
-		err = kernel_maps__load_kallsyms(filter);
+		err = dso__load_kallsyms(self, map, filter);
 		if (err > 0 && !is_kallsyms)
                         dso__set_long_name(self, strdup("[kernel.kallsyms]"));
 	}
@@ -1541,18 +1540,19 @@ size_t dsos__fprintf_buildid(FILE *fp)
 
 static int kernel_maps__create_kernel_map(const struct symbol_conf *conf)
 {
+	struct map *kmap;
 	struct dso *kernel = dso__new(conf->vmlinux_name ?: "[kernel.kallsyms]");
 
 	if (kernel == NULL)
 		return -1;
 
-	kernel_map__functions = map__new2(0, kernel, MAP__FUNCTION);
-	if (kernel_map__functions == NULL)
+	kmap = map__new2(0, kernel, MAP__FUNCTION);
+	if (kmap == NULL)
 		goto out_delete_kernel_dso;
 
-	kernel_map__functions->map_ip	 = kernel_map__functions->unmap_ip = identity__map_ip;
-	kernel->short_name	 = "[kernel]";
-	kernel->kernel		 = 1;
+	kmap->map_ip	   = kmap->unmap_ip = identity__map_ip;
+	kernel->short_name = "[kernel]";
+	kernel->kernel	   = 1;
 
 	vdso = dso__new("[vdso]");
 	if (vdso == NULL)
@@ -1563,15 +1563,14 @@ static int kernel_maps__create_kernel_map(const struct symbol_conf *conf)
 				 sizeof(kernel->build_id)) == 0)
 		kernel->has_build_id = true;
 
-	kernel_maps__insert(kernel_map__functions);
+	kernel_maps__insert(kmap);
 	dsos__add(&dsos__kernel, kernel);
 	dsos__add(&dsos__user, vdso);
 
 	return 0;
 
 out_delete_kernel_map:
-	map__delete(kernel_map__functions);
-	kernel_map__functions = NULL;
+	map__delete(kmap);
 out_delete_kernel_dso:
 	dso__delete(kernel);
 	return -1;
-- 
1.6.2.5

