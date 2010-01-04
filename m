Return-Path: <linux-kernel-owner+w=401wt.eu-S1753589Ab0ADSTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589Ab0ADSTn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 13:19:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753457Ab0ADSTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 13:19:41 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:54435 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094Ab0ADSTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 13:19:40 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/4] perf symbols: Generalise the kallsyms parsing routine
Date: Mon,  4 Jan 2010 16:19:26 -0200
Message-Id: <1262629169-22797-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Will be used to find an specific symbol by name on 'perf record' to support
relocation reference symbols to support relocatable kernels.

Still have to conver the perf trace tools to use it instead of their current
reimplementation.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |   76 +++++++++++++++++++++++++++++----------------
 tools/perf/util/symbol.h |    2 +
 2 files changed, 51 insertions(+), 27 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 79ca6a0..b9e0da5 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -383,16 +383,12 @@ size_t dso__fprintf(struct dso *self, enum map_type type, FILE *fp)
 	return ret;
 }
 
-/*
- * Loads the function entries in /proc/kallsyms into kernel_map->dso,
- * so that we can in the next step set the symbol ->end address and then
- * call kernel_maps__split_kallsyms.
- */
-static int dso__load_all_kallsyms(struct dso *self, struct map *map)
+int kallsyms__parse(void *arg, int (*process_symbol)(void *arg, const char *name,
+						     char type, u64 start))
 {
 	char *line = NULL;
 	size_t n;
-	struct rb_root *root = &self->symbols[map->type];
+	int err = 0;
 	FILE *file = fopen("/proc/kallsyms", "r");
 
 	if (file == NULL)
@@ -400,7 +396,6 @@ static int dso__load_all_kallsyms(struct dso *self, struct map *map)
 
 	while (!feof(file)) {
 		u64 start;
-		struct symbol *sym;
 		int line_len, len;
 		char symbol_type;
 		char *symbol_name;
@@ -421,35 +416,62 @@ static int dso__load_all_kallsyms(struct dso *self, struct map *map)
 			continue;
 
 		symbol_type = toupper(line[len]);
-		if (!symbol_type__is_a(symbol_type, map->type))
-			continue;
-
 		symbol_name = line + len + 2;
-		/*
-		 * Will fix up the end later, when we have all symbols sorted.
-		 */
-		sym = symbol__new(start, 0, symbol_name);
 
-		if (sym == NULL)
-			goto out_delete_line;
-		/*
-		 * We will pass the symbols to the filter later, in
-		 * map__split_kallsyms, when we have split the maps per module
-		 */
-		symbols__insert(root, sym);
+		err = process_symbol(arg, symbol_name, symbol_type, start);
+		if (err)
+			break;
 	}
 
 	free(line);
 	fclose(file);
+	return err;
 
-	return 0;
-
-out_delete_line:
-	free(line);
 out_failure:
 	return -1;
 }
 
+struct process_kallsyms_args {
+	struct map *map;
+	struct dso *dso;
+};
+
+static int map__process_kallsym_symbol(void *arg, const char *name,
+				       char type, u64 start)
+{
+	struct symbol *sym;
+	struct process_kallsyms_args *a = arg;
+	struct rb_root *root = &a->dso->symbols[a->map->type];
+
+	if (!symbol_type__is_a(type, a->map->type))
+		return 0;
+
+	/*
+	 * Will fix up the end later, when we have all symbols sorted.
+	 */
+	sym = symbol__new(start, 0, name);
+
+	if (sym == NULL)
+		return -ENOMEM;
+	/*
+	 * We will pass the symbols to the filter later, in
+	 * map__split_kallsyms, when we have split the maps per module
+	 */
+	symbols__insert(root, sym);
+	return 0;
+}
+
+/*
+ * Loads the function entries in /proc/kallsyms into kernel_map->dso,
+ * so that we can in the next step set the symbol ->end address and then
+ * call kernel_maps__split_kallsyms.
+ */
+static int dso__load_all_kallsyms(struct dso *self, struct map *map)
+{
+	struct process_kallsyms_args args = { .map = map, .dso = self, };
+	return kallsyms__parse(&args, map__process_kallsym_symbol);
+}
+
 /*
  * Split the symbols into maps, making sure there are no overlaps, i.e. the
  * kernel range is broken in several maps, named [kernel].N, as we don't have
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index f27e158..21313e8 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -135,6 +135,8 @@ int filename__read_build_id(const char *filename, void *bf, size_t size);
 int sysfs__read_build_id(const char *filename, void *bf, size_t size);
 bool dsos__read_build_ids(void);
 int build_id__sprintf(u8 *self, int len, char *bf);
+int kallsyms__parse(void *arg, int (*process_symbol)(void *arg, const char *name,
+						     char type, u64 start));
 
 int symbol__init(void);
 int perf_session__create_kernel_maps(struct perf_session *self);
-- 
1.6.2.5

