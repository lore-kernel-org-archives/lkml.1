Return-Path: <linux-kernel-owner+w=401wt.eu-S1753480AbZK0S3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480AbZK0S3w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 13:29:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753308AbZK0S3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 13:29:49 -0500
Received: from casper.infradead.org ([85.118.1.10]:43553 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305AbZK0S3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 13:29:43 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 08/12] perf symbols: kernel_maps should be an array of MAP__NR_TYPES entries
Date: Fri, 27 Nov 2009 16:29:19 -0200
Message-Id: <1259346563-12568-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1259346563-12568-7-git-send-email-acme@infradead.org>
References: <1259346563-12568-1-git-send-email-acme@infradead.org>
 <1259346563-12568-2-git-send-email-acme@infradead.org>
 <1259346563-12568-3-git-send-email-acme@infradead.org>
 <1259346563-12568-4-git-send-email-acme@infradead.org>
 <1259346563-12568-5-git-send-email-acme@infradead.org>
 <1259346563-12568-6-git-send-email-acme@infradead.org>
 <1259346563-12568-7-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

So that we can support multiple symbol table types.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |   51 ++++++++++++++++++++++++++++++++++-----------
 tools/perf/util/thread.h |    1 -
 2 files changed, 38 insertions(+), 14 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 956656f..581db4c 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -29,6 +29,7 @@ enum dso_origin {
 };
 
 static void dsos__add(struct list_head *head, struct dso *dso);
+static struct map *kernel_maps__find_by_dso_name(const char *name);
 static struct map *map__new2(u64 start, struct dso *dso, enum map_type type);
 static void kernel_maps__insert(struct map *map);
 struct symbol *dso__find_symbol(struct dso *self, enum map_type type, u64 addr);
@@ -43,7 +44,7 @@ static struct symbol_conf symbol_conf__defaults = {
 	.try_vmlinux_path = true,
 };
 
-static struct rb_root kernel_maps__functions;
+static struct rb_root kernel_maps[MAP__NR_TYPES];
 
 bool dso__loaded(const struct dso *self, enum map_type type)
 {
@@ -78,10 +79,10 @@ static void symbols__fixup_end(struct rb_root *self)
 		curr->end = roundup(curr->start, 4096);
 }
 
-static void kernel_maps__fixup_end(void)
+static void __kernel_maps__fixup_end(struct rb_root *root)
 {
 	struct map *prev, *curr;
-	struct rb_node *nd, *prevnd = rb_first(&kernel_maps__functions);
+	struct rb_node *nd, *prevnd = rb_first(root);
 
 	if (prevnd == NULL)
 		return;
@@ -101,6 +102,13 @@ static void kernel_maps__fixup_end(void)
 	curr->end = ~0UL;
 }
 
+static void kernel_maps__fixup_end(void)
+{
+	int i;
+	for (i = 0; i < MAP__NR_TYPES; ++i)
+		__kernel_maps__fixup_end(&kernel_maps[i]);
+}
+
 static struct symbol *symbol__new(u64 start, u64 len, const char *name)
 {
 	size_t namelen = strlen(name) + 1;
@@ -449,12 +457,12 @@ static int dso__load_kallsyms(struct dso *self, struct map *map,
 	return dso__split_kallsyms(self, map, filter);
 }
 
-size_t kernel_maps__fprintf(FILE *fp)
+static size_t __kernel_maps__fprintf(enum map_type type, FILE *fp)
 {
-	size_t printed = fprintf(fp, "Kernel maps:\n");
+	size_t printed = fprintf(fp, "%s:\n", map_type__name[type]);
 	struct rb_node *nd;
 
-	for (nd = rb_first(&kernel_maps__functions); nd; nd = rb_next(nd)) {
+	for (nd = rb_first(&kernel_maps[type]); nd; nd = rb_next(nd)) {
 		struct map *pos = rb_entry(nd, struct map, rb_node);
 
 		printed += fprintf(fp, "Map:");
@@ -465,6 +473,16 @@ size_t kernel_maps__fprintf(FILE *fp)
 		}
 	}
 
+	return printed;
+}
+
+size_t kernel_maps__fprintf(FILE *fp)
+{
+	size_t printed = fprintf(fp, "Kernel maps:\n");
+	int i;
+	for (i = 0; i < MAP__NR_TYPES; ++i)
+		printed += __kernel_maps__fprintf(i, fp);
+
 	return printed + fprintf(fp, "END kernel maps\n");
 }
 
@@ -1191,13 +1209,14 @@ out:
 
 static void kernel_maps__insert(struct map *map)
 {
-	maps__insert(&kernel_maps__functions, map);
+	maps__insert(&kernel_maps[map->type], map);
 }
 
-struct symbol *kernel_maps__find_function(u64 ip, struct map **mapp,
-					  symbol_filter_t filter)
+static struct symbol *kernel_maps__find_symbol(u64 ip, enum map_type type,
+					       struct map **mapp,
+					       symbol_filter_t filter)
 {
-	struct map *map = maps__find(&kernel_maps__functions, ip);
+	struct map *map = maps__find(&kernel_maps[type], ip);
 
 	if (mapp)
 		*mapp = map;
@@ -1206,17 +1225,23 @@ struct symbol *kernel_maps__find_function(u64 ip, struct map **mapp,
 		ip = map->map_ip(map, ip);
 		return map__find_symbol(map, ip, filter);
 	} else
-		WARN_ONCE(RB_EMPTY_ROOT(&kernel_maps__functions),
+		WARN_ONCE(RB_EMPTY_ROOT(&kernel_maps[type]),
 			  "Empty kernel_maps, was symbol__init() called?\n");
 
 	return NULL;
 }
 
-struct map *kernel_maps__find_by_dso_name(const char *name)
+struct symbol *kernel_maps__find_function(u64 ip, struct map **mapp,
+					  symbol_filter_t filter)
+{
+	return kernel_maps__find_symbol(ip, MAP__FUNCTION, mapp, filter);
+}
+
+static struct map *kernel_maps__find_by_dso_name(const char *name)
 {
 	struct rb_node *nd;
 
-	for (nd = rb_first(&kernel_maps__functions); nd; nd = rb_next(nd)) {
+	for (nd = rb_first(&kernel_maps[MAP__FUNCTION]); nd; nd = rb_next(nd)) {
 		struct map *map = rb_entry(nd, struct map, rb_node);
 
 		if (map->dso && strcmp(map->dso->name, name) == 0)
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index 74cba64..54580bb 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -28,7 +28,6 @@ struct map *maps__find(struct rb_root *maps, u64 ip);
 
 struct symbol *kernel_maps__find_function(const u64 ip, struct map **mapp,
 					  symbol_filter_t filter);
-struct map *kernel_maps__find_by_dso_name(const char *name);
 
 static inline struct map *thread__find_map(struct thread *self, u64 ip)
 {
-- 
1.6.2.5

