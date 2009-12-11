Return-Path: <linux-kernel-owner+w=401wt.eu-S1757812AbZLKUuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757812AbZLKUuo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 15:50:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755107AbZLKUui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 15:50:38 -0500
Received: from casper.infradead.org ([85.118.1.10]:56291 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874AbZLKUui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 15:50:38 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/1] perf symbols: Allow lookups by symbol name too
Date: Fri, 11 Dec 2009 18:50:22 -0200
Message-Id: <1260564622-12392-1-git-send-email-acme@infradead.org>
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

Configurable via symbol_conf.sort_by_name, so that the cost of an extra
rb_node on all 'struct symbol' instances is not paid by tools that only
want to decode addresses.

How to use it:

	symbol_conf.sort_by_name = true;
	symbol_init(&symbol_conf);

	struct map *map = map_groups__find_by_name(kmaps, MAP__VARIABLE, "[kernel.kallsyms]");

	if (map == NULL) {
		pr_err("couldn't find map!\n");
		kernel_maps__fprintf(stdout);
	} else {
		struct symbol *sym = map__find_symbol_by_name(map, sym_filter, NULL);
		if (sym == NULL)
			pr_err("couldn't find symbol %s!\n", sym_filter);
		else
			pr_info("symbol %s: %#Lx-%#Lx \n", sym_filter, sym->start, sym->end);
	}

Looking over the vmlinux/kallsyms is common enough that I'll add a
variable to the upcoming struct perf_session to avoid the need to use
map_groups__find_by_name to get the main vmlinux/kallsyms map.

The above example looks on the 'variable' symtab, but it is just like
that for the functions one.

Also the sort operation is done when we first use
map__find_symbol_by_name, in a lazy way.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.h  |    2 +
 tools/perf/util/map.c    |   85 +++++++++++++++++++++++--------------
 tools/perf/util/symbol.c |  104 ++++++++++++++++++++++++++++++++++++++++++----
 tools/perf/util/symbol.h |   10 ++++-
 tools/perf/util/thread.h |    3 +
 5 files changed, 163 insertions(+), 41 deletions(-)

diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 5664094..51a96c2 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -151,6 +151,8 @@ int map__overlap(struct map *l, struct map *r);
 size_t map__fprintf(struct map *self, FILE *fp);
 struct symbol *map__find_symbol(struct map *self, u64 addr,
 				symbol_filter_t filter);
+struct symbol *map__find_symbol_by_name(struct map *self, const char *name,
+					symbol_filter_t filter);
 void map__fixup_start(struct map *self);
 void map__fixup_end(struct map *self);
 
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 69f94fe..175f1f6 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -104,45 +104,66 @@ void map__fixup_end(struct map *self)
 
 #define DSO__DELETED "(deleted)"
 
-struct symbol *map__find_symbol(struct map *self, u64 addr,
-				symbol_filter_t filter)
+static int map__load(struct map *self, symbol_filter_t filter)
 {
-	if (!dso__loaded(self->dso, self->type)) {
-		int nr = dso__load(self->dso, self, filter);
-
-		if (nr < 0) {
-			if (self->dso->has_build_id) {
-				char sbuild_id[BUILD_ID_SIZE * 2 + 1];
-
-				build_id__sprintf(self->dso->build_id,
-						  sizeof(self->dso->build_id),
-						  sbuild_id);
-				pr_warning("%s with build id %s not found",
-					   self->dso->long_name, sbuild_id);
-			} else
-				pr_warning("Failed to open %s",
-					   self->dso->long_name);
-			pr_warning(", continuing without symbols\n");
-			return NULL;
-		} else if (nr == 0) {
-			const char *name = self->dso->long_name;
-			const size_t len = strlen(name);
-			const size_t real_len = len - sizeof(DSO__DELETED);
-
-			if (len > sizeof(DSO__DELETED) &&
-			    strcmp(name + real_len + 1, DSO__DELETED) == 0) {
-				pr_warning("%.*s was updated, restart the long running apps that use it!\n",
-					   (int)real_len, name);
-			} else {
-				pr_warning("no symbols found in %s, maybe install a debug package?\n", name);
-			}
-			return NULL;
+	const char *name = self->dso->long_name;
+	int nr = dso__load(self->dso, self, filter);
+
+	if (nr < 0) {
+		if (self->dso->has_build_id) {
+			char sbuild_id[BUILD_ID_SIZE * 2 + 1];
+
+			build_id__sprintf(self->dso->build_id,
+					  sizeof(self->dso->build_id),
+					  sbuild_id);
+			pr_warning("%s with build id %s not found",
+				   name, sbuild_id);
+		} else
+			pr_warning("Failed to open %s", name);
+
+		pr_warning(", continuing without symbols\n");
+		return -1;
+	} else if (nr == 0) {
+		const size_t len = strlen(name);
+		const size_t real_len = len - sizeof(DSO__DELETED);
+
+		if (len > sizeof(DSO__DELETED) &&
+		    strcmp(name + real_len + 1, DSO__DELETED) == 0) {
+			pr_warning("%.*s was updated, restart the long "
+				   "running apps that use it!\n",
+				   (int)real_len, name);
+		} else {
+			pr_warning("no symbols found in %s, maybe install "
+				   "a debug package?\n", name);
 		}
+
+		return -1;
 	}
 
+	return 0;
+}
+
+struct symbol *map__find_symbol(struct map *self, u64 addr,
+				symbol_filter_t filter)
+{
+	if (!dso__loaded(self->dso, self->type) && map__load(self, filter) < 0)
+		return NULL;
+
 	return self->dso->find_symbol(self->dso, self->type, addr);
 }
 
+struct symbol *map__find_symbol_by_name(struct map *self, const char *name,
+					symbol_filter_t filter)
+{
+	if (!dso__loaded(self->dso, self->type) && map__load(self, filter) < 0)
+		return NULL;
+
+	if (!dso__sorted_by_name(self->dso, self->type))
+		dso__sort_by_name(self->dso, self->type);
+
+	return dso__find_symbol_by_name(self->dso, self->type, name);
+}
+
 struct map *map__clone(struct map *self)
 {
 	struct map *map = malloc(sizeof(*self));
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index e63ddb4..8134c49 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -29,7 +29,6 @@ enum dso_origin {
 };
 
 static void dsos__add(struct list_head *head, struct dso *dso);
-static struct map *map_groups__find_by_name(struct map_groups *self, char *name);
 static struct map *map__new2(u64 start, struct dso *dso, enum map_type type);
 struct symbol *dso__find_symbol(struct dso *self, enum map_type type, u64 addr);
 static int dso__load_kernel_sym(struct dso *self, struct map *map,
@@ -51,11 +50,21 @@ bool dso__loaded(const struct dso *self, enum map_type type)
 	return self->loaded & (1 << type);
 }
 
+bool dso__sorted_by_name(const struct dso *self, enum map_type type)
+{
+	return self->sorted_by_name & (1 << type);
+}
+
 static void dso__set_loaded(struct dso *self, enum map_type type)
 {
 	self->loaded |= (1 << type);
 }
 
+static void dso__set_sorted_by_name(struct dso *self, enum map_type type)
+{
+	self->sorted_by_name |= (1 << type);
+}
+
 static bool symbol_type__is_a(char symbol_type, enum map_type map_type)
 {
 	switch (map_type) {
@@ -176,11 +185,12 @@ struct dso *dso__new(const char *name)
 		dso__set_long_name(self, self->name);
 		self->short_name = self->name;
 		for (i = 0; i < MAP__NR_TYPES; ++i)
-			self->symbols[i] = RB_ROOT;
+			self->symbols[i] = self->symbol_names[i] = RB_ROOT;
 		self->find_symbol = dso__find_symbol;
 		self->slen_calculated = 0;
 		self->origin = DSO__ORIG_NOT_FOUND;
 		self->loaded = 0;
+		self->sorted_by_name = 0;
 		self->has_build_id = 0;
 	}
 
@@ -258,11 +268,85 @@ static struct symbol *symbols__find(struct rb_root *self, u64 ip)
 	return NULL;
 }
 
-struct symbol *dso__find_symbol(struct dso *self, enum map_type type, u64 addr)
+struct symbol_name_rb_node {
+	struct rb_node	rb_node;
+	struct symbol	sym;
+};
+
+static void symbols__insert_by_name(struct rb_root *self, struct symbol *sym)
+{
+	struct rb_node **p = &self->rb_node;
+	struct rb_node *parent = NULL;
+	struct symbol_name_rb_node *symn = ((void *)sym) - sizeof(*parent), *s;
+
+	while (*p != NULL) {
+		parent = *p;
+		s = rb_entry(parent, struct symbol_name_rb_node, rb_node);
+		if (strcmp(sym->name, s->sym.name) < 0)
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
+	}
+	rb_link_node(&symn->rb_node, parent, p);
+	rb_insert_color(&symn->rb_node, self);
+}
+
+static void symbols__sort_by_name(struct rb_root *self, struct rb_root *source)
+{
+	struct rb_node *nd;
+
+	for (nd = rb_first(source); nd; nd = rb_next(nd)) {
+		struct symbol *pos = rb_entry(nd, struct symbol, rb_node);
+		symbols__insert_by_name(self, pos);
+	}
+}
+
+static struct symbol *symbols__find_by_name(struct rb_root *self, const char *name)
+{
+	struct rb_node *n;
+
+	if (self == NULL)
+		return NULL;
+
+	n = self->rb_node;
+
+	while (n) {
+		struct symbol_name_rb_node *s;
+		int cmp;
+
+		s = rb_entry(n, struct symbol_name_rb_node, rb_node);
+		cmp = strcmp(name, s->sym.name);
+
+		if (cmp < 0)
+			n = n->rb_left;
+		else if (cmp > 0)
+			n = n->rb_right;
+		else
+			return &s->sym;
+	}
+
+	return NULL;
+}
+
+struct symbol *dso__find_symbol(struct dso *self,
+				enum map_type type, u64 addr)
 {
 	return symbols__find(&self->symbols[type], addr);
 }
 
+struct symbol *dso__find_symbol_by_name(struct dso *self, enum map_type type,
+					const char *name)
+{
+	return symbols__find_by_name(&self->symbol_names[type], name);
+}
+
+void dso__sort_by_name(struct dso *self, enum map_type type)
+{
+	dso__set_sorted_by_name(self, type);
+	return symbols__sort_by_name(&self->symbol_names[type],
+				     &self->symbols[type]);
+}
+
 int build_id__sprintf(u8 *self, int len, char *bf)
 {
 	char *bid = bf;
@@ -397,7 +481,7 @@ static int dso__split_kallsyms(struct dso *self, struct map *map,
 			*module++ = '\0';
 
 			if (strcmp(self->name, module)) {
-				curr_map = map_groups__find_by_name(mg, module);
+				curr_map = map_groups__find_by_name(mg, map->type, module);
 				if (curr_map == NULL) {
 					pr_debug("/proc/{kallsyms,modules} "
 					         "inconsistency!\n");
@@ -895,7 +979,7 @@ static int dso__load_sym(struct dso *self, struct map *map,
 			snprintf(dso_name, sizeof(dso_name),
 				 "%s%s", self->short_name, section_name);
 
-			curr_map = map_groups__find_by_name(mg, dso_name);
+			curr_map = map_groups__find_by_name(mg, map->type, dso_name);
 			if (curr_map == NULL) {
 				u64 start = sym.st_value;
 
@@ -1226,11 +1310,12 @@ out:
 	return ret;
 }
 
-static struct map *map_groups__find_by_name(struct map_groups *self, char *name)
+struct map *map_groups__find_by_name(struct map_groups *self,
+				     enum map_type type, const char *name)
 {
 	struct rb_node *nd;
 
-	for (nd = rb_first(&self->maps[MAP__FUNCTION]); nd; nd = rb_next(nd)) {
+	for (nd = rb_first(&self->maps[type]); nd; nd = rb_next(nd)) {
 		struct map *map = rb_entry(nd, struct map, rb_node);
 
 		if (map->dso && strcmp(map->dso->name, name) == 0)
@@ -1274,7 +1359,7 @@ static int dsos__set_modules_path_dir(char *dirname)
 				 (int)(dot - dent->d_name), dent->d_name);
 
 			strxfrchar(dso_name, '-', '_');
-			map = map_groups__find_by_name(kmaps, dso_name);
+			map = map_groups__find_by_name(kmaps, MAP__FUNCTION, dso_name);
 			if (map == NULL)
 				continue;
 
@@ -1671,6 +1756,9 @@ int symbol__init(struct symbol_conf *conf)
 
 	elf_version(EV_CURRENT);
 	symbol__priv_size = pconf->priv_size;
+	if (pconf->sort_by_name)
+		symbol__priv_size += (sizeof(struct symbol_name_rb_node) -
+				      sizeof(struct symbol));
 	map_groups__init(kmaps);
 
 	if (pconf->try_vmlinux_path && vmlinux_path__init() < 0)
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 6e1da1e..51c4013 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -52,7 +52,8 @@ struct symbol {
 struct symbol_conf {
 	unsigned short	priv_size;
 	bool		try_vmlinux_path,
-			use_modules;
+			use_modules,
+			sort_by_name;
 	const char	*vmlinux_name;
 };
 
@@ -74,6 +75,7 @@ struct addr_location {
 struct dso {
 	struct list_head node;
 	struct rb_root	 symbols[MAP__NR_TYPES];
+	struct rb_root	 symbol_names[MAP__NR_TYPES];
 	struct symbol    *(*find_symbol)(struct dso *self,
 					 enum map_type type, u64 addr);
 	u8		 adjust_symbols:1;
@@ -81,6 +83,7 @@ struct dso {
 	u8		 has_build_id:1;
 	u8		 kernel:1;
 	unsigned char	 origin;
+	u8		 sorted_by_name;
 	u8		 loaded;
 	u8		 build_id[BUILD_ID_SIZE];
 	u16		 long_name_len;
@@ -93,6 +96,9 @@ struct dso *dso__new(const char *name);
 void dso__delete(struct dso *self);
 
 bool dso__loaded(const struct dso *self, enum map_type type);
+bool dso__sorted_by_name(const struct dso *self, enum map_type type);
+
+void dso__sort_by_name(struct dso *self, enum map_type type);
 
 struct dso *dsos__findnew(const char *name);
 int dso__load(struct dso *self, struct map *map, symbol_filter_t filter);
@@ -103,6 +109,8 @@ size_t dso__fprintf_buildid(struct dso *self, FILE *fp);
 size_t dso__fprintf(struct dso *self, enum map_type type, FILE *fp);
 char dso__symtab_origin(const struct dso *self);
 void dso__set_build_id(struct dso *self, void *build_id);
+struct symbol *dso__find_symbol_by_name(struct dso *self, enum map_type type,
+					const char *name);
 
 int filename__read_build_id(const char *filename, void *bf, size_t size);
 int sysfs__read_build_id(const char *filename, void *bf, size_t size);
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index a6333f3..1751802 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -64,4 +64,7 @@ map_groups__find_function(struct map_groups *self, u64 addr,
 {
 	return map_groups__find_symbol(self, MAP__FUNCTION, addr, filter);
 }
+
+struct map *map_groups__find_by_name(struct map_groups *self,
+				     enum map_type type, const char *name);
 #endif	/* __PERF_THREAD_H */
-- 
1.6.2.5

