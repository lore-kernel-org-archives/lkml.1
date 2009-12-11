Return-Path: <linux-kernel-owner+w=401wt.eu-S1754439AbZLKQvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439AbZLKQvV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 11:51:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753726AbZLKQuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 11:50:50 -0500
Received: from casper.infradead.org ([85.118.1.10]:60432 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbZLKQup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 11:50:45 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Eduardo Habkost <ehabkost@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/4] perf symbols: Rename kthreads to kmaps, using another abstraction for it
Date: Fri, 11 Dec 2009 14:50:36 -0200
Message-Id: <1260550239-5372-1-git-send-email-acme@infradead.org>
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

Using a struct thread instance just to hold the kernel space maps
(vmlinux + modules) is overkill and confuses people trying to understand
the perf symbols abstractions.

The kernel maps are really present in all threads, i.e. the kernel is a
library, not a separate thread.

So introduce the 'map_groups' abstraction and use it for the kernel
maps, now in the kmaps global variable.

It, in turn, will move, together with the threads list to the perf_file
abstraction, so that we can support multiple perf_file instances, needed
by perf diff.

Brainstormed-with: Eduardo Habkost <ehabkost@redhat.com>
Cc: Eduardo Habkost <ehabkost@redhat.com>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kmem.c |    2 +-
 tools/perf/util/event.c   |   11 ++++---
 tools/perf/util/symbol.c  |   73 +++++++++++++++++++++++----------------------
 tools/perf/util/symbol.h  |    4 +-
 tools/perf/util/thread.c  |   62 +++++++++++++++++++++----------------
 tools/perf/util/thread.h  |   39 +++++++++++++++--------
 6 files changed, 106 insertions(+), 85 deletions(-)

diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 5f20951..fe73435 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -403,7 +403,7 @@ static void __print_result(struct rb_root *root, int n_lines, int is_caller)
 		if (is_caller) {
 			addr = data->call_site;
 			if (!raw_ip)
-				sym = thread__find_function(kthread, addr, NULL);
+				sym = map_groups__find_function(kmaps, addr, NULL);
 		} else
 			addr = data->ptr;
 
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 4dcecaf..ba0de90 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -254,13 +254,14 @@ void thread__find_addr_location(struct thread *self, u8 cpumode,
 				struct addr_location *al,
 				symbol_filter_t filter)
 {
-	struct thread *thread = al->thread = self;
+	struct map_groups *mg = &self->mg;
 
+	al->thread = self;
 	al->addr = addr;
 
 	if (cpumode & PERF_RECORD_MISC_KERNEL) {
 		al->level = 'k';
-		thread = kthread;
+		mg = kmaps;
 	} else if (cpumode & PERF_RECORD_MISC_USER)
 		al->level = '.';
 	else {
@@ -270,7 +271,7 @@ void thread__find_addr_location(struct thread *self, u8 cpumode,
 		return;
 	}
 try_again:
-	al->map = thread__find_map(thread, type, al->addr);
+	al->map = map_groups__find(mg, type, al->addr);
 	if (al->map == NULL) {
 		/*
 		 * If this is outside of all known maps, and is a negative
@@ -281,8 +282,8 @@ try_again:
 		 * "[vdso]" dso, but for now lets use the old trick of looking
 		 * in the whole kernel symbol list.
 		 */
-		if ((long long)al->addr < 0 && thread != kthread) {
-			thread = kthread;
+		if ((long long)al->addr < 0 && mg != kmaps) {
+			mg = kmaps;
 			goto try_again;
 		}
 		al->sym = NULL;
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index e7508ad..9362023 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -29,11 +29,11 @@ enum dso_origin {
 };
 
 static void dsos__add(struct list_head *head, struct dso *dso);
-static struct map *thread__find_map_by_name(struct thread *self, char *name);
+static struct map *map_groups__find_by_name(struct map_groups *self, char *name);
 static struct map *map__new2(u64 start, struct dso *dso, enum map_type type);
 struct symbol *dso__find_symbol(struct dso *self, enum map_type type, u64 addr);
 static int dso__load_kernel_sym(struct dso *self, struct map *map,
-				struct thread *thread, symbol_filter_t filter);
+				struct map_groups *mg, symbol_filter_t filter);
 unsigned int symbol__priv_size;
 static int vmlinux_path__nr_entries;
 static char **vmlinux_path;
@@ -43,8 +43,8 @@ static struct symbol_conf symbol_conf__defaults = {
 	.try_vmlinux_path = true,
 };
 
-static struct thread kthread_mem;
-struct thread *kthread = &kthread_mem;
+static struct map_groups kmaps_mem;
+struct map_groups *kmaps = &kmaps_mem;
 
 bool dso__loaded(const struct dso *self, enum map_type type)
 {
@@ -79,7 +79,7 @@ static void symbols__fixup_end(struct rb_root *self)
 		curr->end = roundup(curr->start, 4096);
 }
 
-static void __thread__fixup_maps_end(struct thread *self, enum map_type type)
+static void __map_groups__fixup_end(struct map_groups *self, enum map_type type)
 {
 	struct map *prev, *curr;
 	struct rb_node *nd, *prevnd = rb_first(&self->maps[type]);
@@ -102,11 +102,11 @@ static void __thread__fixup_maps_end(struct thread *self, enum map_type type)
 	curr->end = ~0UL;
 }
 
-static void thread__fixup_maps_end(struct thread *self)
+static void map_groups__fixup_end(struct map_groups *self)
 {
 	int i;
 	for (i = 0; i < MAP__NR_TYPES; ++i)
-		__thread__fixup_maps_end(self, i);
+		__map_groups__fixup_end(self, i);
 }
 
 static struct symbol *symbol__new(u64 start, u64 len, const char *name)
@@ -364,8 +364,8 @@ out_failure:
  * kernel range is broken in several maps, named [kernel].N, as we don't have
  * the original ELF section names vmlinux have.
  */
-static int dso__split_kallsyms(struct dso *self, struct map *map, struct thread *thread,
-			       symbol_filter_t filter)
+static int dso__split_kallsyms(struct dso *self, struct map *map,
+			       struct map_groups *mg, symbol_filter_t filter)
 {
 	struct map *curr_map = map;
 	struct symbol *pos;
@@ -382,13 +382,13 @@ static int dso__split_kallsyms(struct dso *self, struct map *map, struct thread
 
 		module = strchr(pos->name, '\t');
 		if (module) {
-			if (!thread->use_modules)
+			if (!mg->use_modules)
 				goto discard_symbol;
 
 			*module++ = '\0';
 
 			if (strcmp(self->name, module)) {
-				curr_map = thread__find_map_by_name(thread, module);
+				curr_map = map_groups__find_by_name(mg, module);
 				if (curr_map == NULL) {
 					pr_debug("/proc/{kallsyms,modules} "
 					         "inconsistency!\n");
@@ -419,7 +419,7 @@ static int dso__split_kallsyms(struct dso *self, struct map *map, struct thread
 			}
 
 			curr_map->map_ip = curr_map->unmap_ip = identity__map_ip;
-			__thread__insert_map(thread, curr_map);
+			map_groups__insert(mg, curr_map);
 			++kernel_range;
 		}
 
@@ -440,7 +440,7 @@ discard_symbol:		rb_erase(&pos->rb_node, root);
 
 
 static int dso__load_kallsyms(struct dso *self, struct map *map,
-			      struct thread *thread, symbol_filter_t filter)
+			      struct map_groups *mg, symbol_filter_t filter)
 {
 	if (dso__load_all_kallsyms(self, map) < 0)
 		return -1;
@@ -448,13 +448,13 @@ static int dso__load_kallsyms(struct dso *self, struct map *map,
 	symbols__fixup_end(&self->symbols[map->type]);
 	self->origin = DSO__ORIG_KERNEL;
 
-	return dso__split_kallsyms(self, map, thread, filter);
+	return dso__split_kallsyms(self, map, mg, filter);
 }
 
 size_t kernel_maps__fprintf(FILE *fp)
 {
 	size_t printed = fprintf(fp, "Kernel maps:\n");
-	printed += thread__fprintf_maps(kthread, fp);
+	printed += map_groups__fprintf_maps(kmaps, fp);
 	return printed + fprintf(fp, "END kernel maps\n");
 }
 
@@ -745,7 +745,7 @@ out:
 }
 
 static int dso__load_sym(struct dso *self, struct map *map,
-			 struct thread *thread, const char *name, int fd,
+			 struct map_groups *mg, const char *name, int fd,
 			 symbol_filter_t filter, int kernel, int kmodule)
 {
 	struct map *curr_map = map;
@@ -849,7 +849,7 @@ static int dso__load_sym(struct dso *self, struct map *map,
 			snprintf(dso_name, sizeof(dso_name),
 				 "%s%s", self->short_name, section_name);
 
-			curr_map = thread__find_map_by_name(thread, dso_name);
+			curr_map = map_groups__find_by_name(mg, dso_name);
 			if (curr_map == NULL) {
 				u64 start = sym.st_value;
 
@@ -868,7 +868,7 @@ static int dso__load_sym(struct dso *self, struct map *map,
 				curr_map->map_ip = identity__map_ip;
 				curr_map->unmap_ip = identity__map_ip;
 				curr_dso->origin = DSO__ORIG_KERNEL;
-				__thread__insert_map(kthread, curr_map);
+				map_groups__insert(kmaps, curr_map);
 				dsos__add(&dsos__kernel, curr_dso);
 			} else
 				curr_dso = curr_map->dso;
@@ -1094,7 +1094,7 @@ int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
 	dso__set_loaded(self, map->type);
 
 	if (self->kernel)
-		return dso__load_kernel_sym(self, map, kthread, filter);
+		return dso__load_kernel_sym(self, map, kmaps, filter);
 
 	name = malloc(size);
 	if (!name)
@@ -1180,7 +1180,7 @@ out:
 	return ret;
 }
 
-static struct map *thread__find_map_by_name(struct thread *self, char *name)
+static struct map *map_groups__find_by_name(struct map_groups *self, char *name)
 {
 	struct rb_node *nd;
 
@@ -1228,7 +1228,7 @@ static int dsos__set_modules_path_dir(char *dirname)
 				 (int)(dot - dent->d_name), dent->d_name);
 
 			strxfrchar(dso_name, '-', '_');
-			map = thread__find_map_by_name(kthread, dso_name);
+			map = map_groups__find_by_name(kmaps, dso_name);
 			if (map == NULL)
 				continue;
 
@@ -1281,7 +1281,7 @@ static struct map *map__new2(u64 start, struct dso *dso, enum map_type type)
 	return self;
 }
 
-static int thread__create_module_maps(struct thread *self)
+static int map_groups__create_module_maps(struct map_groups *self)
 {
 	char *line = NULL;
 	size_t n;
@@ -1338,7 +1338,7 @@ static int thread__create_module_maps(struct thread *self)
 			dso->has_build_id = true;
 
 		dso->origin = DSO__ORIG_KMODULE;
-		__thread__insert_map(self, map);
+		map_groups__insert(self, map);
 		dsos__add(&dsos__kernel, dso);
 	}
 
@@ -1353,7 +1353,8 @@ out_failure:
 	return -1;
 }
 
-static int dso__load_vmlinux(struct dso *self, struct map *map, struct thread *thread,
+static int dso__load_vmlinux(struct dso *self, struct map *map,
+			     struct map_groups *mg,
 			     const char *vmlinux, symbol_filter_t filter)
 {
 	int err = -1, fd;
@@ -1387,14 +1388,14 @@ static int dso__load_vmlinux(struct dso *self, struct map *map, struct thread *t
 		return -1;
 
 	dso__set_loaded(self, map->type);
-	err = dso__load_sym(self, map, thread, self->long_name, fd, filter, 1, 0);
+	err = dso__load_sym(self, map, mg, self->long_name, fd, filter, 1, 0);
 	close(fd);
 
 	return err;
 }
 
 static int dso__load_kernel_sym(struct dso *self, struct map *map,
-				struct thread *thread, symbol_filter_t filter)
+				struct map_groups *mg, symbol_filter_t filter)
 {
 	int err;
 	bool is_kallsyms;
@@ -1404,7 +1405,7 @@ static int dso__load_kernel_sym(struct dso *self, struct map *map,
 		pr_debug("Looking at the vmlinux_path (%d entries long)\n",
 			 vmlinux_path__nr_entries);
 		for (i = 0; i < vmlinux_path__nr_entries; ++i) {
-			err = dso__load_vmlinux(self, map, thread,
+			err = dso__load_vmlinux(self, map, mg,
 						vmlinux_path[i], filter);
 			if (err > 0) {
 				pr_debug("Using %s for symbols\n",
@@ -1420,12 +1421,12 @@ static int dso__load_kernel_sym(struct dso *self, struct map *map,
 	if (is_kallsyms)
 		goto do_kallsyms;
 
-	err = dso__load_vmlinux(self, map, thread, self->long_name, filter);
+	err = dso__load_vmlinux(self, map, mg, self->long_name, filter);
 	if (err <= 0) {
 		pr_info("The file %s cannot be used, "
 			"trying to use /proc/kallsyms...", self->long_name);
 do_kallsyms:
-		err = dso__load_kallsyms(self, map, thread, filter);
+		err = dso__load_kallsyms(self, map, mg, filter);
 		if (err > 0 && !is_kallsyms)
                         dso__set_long_name(self, strdup("[kernel.kallsyms]"));
 	}
@@ -1508,7 +1509,7 @@ size_t dsos__fprintf_buildid(FILE *fp)
 		__dsos__fprintf_buildid(&dsos__user, fp));
 }
 
-static int thread__create_kernel_map(struct thread *self, const char *vmlinux)
+static int map_groups__create_kernel_map(struct map_groups *self, const char *vmlinux)
 {
 	struct map *kmap;
 	struct dso *kernel = dso__new(vmlinux ?: "[kernel.kallsyms]");
@@ -1533,7 +1534,7 @@ static int thread__create_kernel_map(struct thread *self, const char *vmlinux)
 				 sizeof(kernel->build_id)) == 0)
 		kernel->has_build_id = true;
 
-	__thread__insert_map(self, kmap);
+	map_groups__insert(self, kmap);
 	dsos__add(&dsos__kernel, kernel);
 	dsos__add(&dsos__user, vdso);
 
@@ -1607,23 +1608,23 @@ int symbol__init(struct symbol_conf *conf)
 
 	elf_version(EV_CURRENT);
 	symbol__priv_size = pconf->priv_size;
-	thread__init(kthread, 0);
+	map_groups__init(kmaps);
 
 	if (pconf->try_vmlinux_path && vmlinux_path__init() < 0)
 		return -1;
 
-	if (thread__create_kernel_map(kthread, pconf->vmlinux_name) < 0) {
+	if (map_groups__create_kernel_map(kmaps, pconf->vmlinux_name) < 0) {
 		vmlinux_path__exit();
 		return -1;
 	}
 
-	kthread->use_modules = pconf->use_modules;
-	if (pconf->use_modules && thread__create_module_maps(kthread) < 0)
+	kmaps->use_modules = pconf->use_modules;
+	if (pconf->use_modules && map_groups__create_module_maps(kmaps) < 0)
 		pr_debug("Failed to load list of modules in use, "
 			 "continuing...\n");
 	/*
 	 * Now that we have all the maps created, just set the ->end of them:
 	 */
-	thread__fixup_maps_end(kthread);
+	map_groups__fixup_end(kmaps);
 	return 0;
 }
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 17003ef..6e1da1e 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -113,8 +113,8 @@ size_t kernel_maps__fprintf(FILE *fp);
 
 int symbol__init(struct symbol_conf *conf);
 
-struct thread;
-struct thread *kthread;
+struct map_groups;
+struct map_groups *kmaps;
 extern struct list_head dsos__user, dsos__kernel;
 extern struct dso *vdso;
 #endif /* __PERF_SYMBOL */
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 603f561..a128512 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -9,11 +9,9 @@
 static struct rb_root threads;
 static struct thread *last_match;
 
-void thread__init(struct thread *self, pid_t pid)
+void map_groups__init(struct map_groups *self)
 {
 	int i;
-	self->pid = pid;
-	self->comm = NULL;
 	for (i = 0; i < MAP__NR_TYPES; ++i) {
 		self->maps[i] = RB_ROOT;
 		INIT_LIST_HEAD(&self->removed_maps[i]);
@@ -25,7 +23,8 @@ static struct thread *thread__new(pid_t pid)
 	struct thread *self = zalloc(sizeof(*self));
 
 	if (self != NULL) {
-		thread__init(self, pid);
+		map_groups__init(&self->mg);
+		self->pid = pid;
 		self->comm = malloc(32);
 		if (self->comm)
 			snprintf(self->comm, 32, ":%d", self->pid);
@@ -57,8 +56,8 @@ static const char *map_type__name[MAP__NR_TYPES] = {
 	[MAP__FUNCTION] = "Functions",
 };
 
-static size_t __thread__fprintf_maps(struct thread *self,
-				     enum map_type type, FILE *fp)
+static size_t __map_groups__fprintf_maps(struct map_groups *self,
+					 enum map_type type, FILE *fp)
 {
 	size_t printed = fprintf(fp, "%s:\n", map_type__name[type]);
 	struct rb_node *nd;
@@ -76,16 +75,16 @@ static size_t __thread__fprintf_maps(struct thread *self,
 	return printed;
 }
 
-size_t thread__fprintf_maps(struct thread *self, FILE *fp)
+size_t map_groups__fprintf_maps(struct map_groups *self, FILE *fp)
 {
 	size_t printed = 0, i;
 	for (i = 0; i < MAP__NR_TYPES; ++i)
-		printed += __thread__fprintf_maps(self, i, fp);
+		printed += __map_groups__fprintf_maps(self, i, fp);
 	return printed;
 }
 
-static size_t __thread__fprintf_removed_maps(struct thread *self,
-					     enum map_type type, FILE *fp)
+static size_t __map_groups__fprintf_removed_maps(struct map_groups *self,
+						 enum map_type type, FILE *fp)
 {
 	struct map *pos;
 	size_t printed = 0;
@@ -101,20 +100,25 @@ static size_t __thread__fprintf_removed_maps(struct thread *self,
 	return printed;
 }
 
-static size_t thread__fprintf_removed_maps(struct thread *self, FILE *fp)
+static size_t map_groups__fprintf_removed_maps(struct map_groups *self, FILE *fp)
 {
 	size_t printed = 0, i;
 	for (i = 0; i < MAP__NR_TYPES; ++i)
-		printed += __thread__fprintf_removed_maps(self, i, fp);
+		printed += __map_groups__fprintf_removed_maps(self, i, fp);
 	return printed;
 }
 
-static size_t thread__fprintf(struct thread *self, FILE *fp)
+static size_t map_groups__fprintf(struct map_groups *self, FILE *fp)
 {
-	size_t printed = fprintf(fp, "Thread %d %s\n", self->pid, self->comm);
-	printed += thread__fprintf_removed_maps(self, fp);
+	size_t printed = map_groups__fprintf_maps(self, fp);
 	printed += fprintf(fp, "Removed maps:\n");
-	return printed + thread__fprintf_removed_maps(self, fp);
+	return printed + map_groups__fprintf_removed_maps(self, fp);
+}
+
+static size_t thread__fprintf(struct thread *self, FILE *fp)
+{
+	return fprintf(fp, "Thread %d %s\n", self->pid, self->comm) +
+	       map_groups__fprintf(&self->mg, fp);
 }
 
 struct thread *threads__findnew(pid_t pid)
@@ -168,7 +172,8 @@ struct thread *register_idle_thread(void)
 	return thread;
 }
 
-static void thread__remove_overlappings(struct thread *self, struct map *map)
+static void map_groups__remove_overlappings(struct map_groups *self,
+					    struct map *map)
 {
 	struct rb_root *root = &self->maps[map->type];
 	struct rb_node *next = rb_first(root);
@@ -238,12 +243,15 @@ struct map *maps__find(struct rb_root *maps, u64 ip)
 
 void thread__insert_map(struct thread *self, struct map *map)
 {
-	thread__remove_overlappings(self, map);
-	maps__insert(&self->maps[map->type], map);
+	map_groups__remove_overlappings(&self->mg, map);
+	map_groups__insert(&self->mg, map);
 }
 
-static int thread__clone_maps(struct thread *self, struct thread *parent,
-			      enum map_type type)
+/*
+ * XXX This should not really _copy_ te maps, but refcount them.
+ */
+static int map_groups__clone(struct map_groups *self,
+			     struct map_groups *parent, enum map_type type)
 {
 	struct rb_node *nd;
 	for (nd = rb_first(&parent->maps[type]); nd; nd = rb_next(nd)) {
@@ -251,7 +259,7 @@ static int thread__clone_maps(struct thread *self, struct thread *parent,
 		struct map *new = map__clone(map);
 		if (new == NULL)
 			return -ENOMEM;
-		thread__insert_map(self, new);
+		map_groups__insert(self, new);
 	}
 	return 0;
 }
@@ -267,7 +275,7 @@ int thread__fork(struct thread *self, struct thread *parent)
 		return -ENOMEM;
 
 	for (i = 0; i < MAP__NR_TYPES; ++i)
-		if (thread__clone_maps(self, parent, i) < 0)
+		if (map_groups__clone(&self->mg, &parent->mg, i) < 0)
 			return -ENOMEM;
 	return 0;
 }
@@ -286,11 +294,11 @@ size_t threads__fprintf(FILE *fp)
 	return ret;
 }
 
-struct symbol *thread__find_symbol(struct thread *self,
-				   enum map_type type, u64 addr,
-				   symbol_filter_t filter)
+struct symbol *map_groups__find_symbol(struct map_groups *self,
+				       enum map_type type, u64 addr,
+				       symbol_filter_t filter)
 {
-	struct map *map = thread__find_map(self, type, addr);
+	struct map *map = map_groups__find(self, type, addr);
 
 	if (map != NULL)
 		return map__find_symbol(map, map->map_ip(map, addr), filter);
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index 686d6e9..a6333f3 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -5,52 +5,63 @@
 #include <unistd.h>
 #include "symbol.h"
 
-struct thread {
-	struct rb_node		rb_node;
+struct map_groups {
 	struct rb_root		maps[MAP__NR_TYPES];
 	struct list_head	removed_maps[MAP__NR_TYPES];
-	pid_t			pid;
 	bool			use_modules;
+};
+
+struct thread {
+	struct rb_node		rb_node;
+	struct map_groups	mg;
+	pid_t			pid;
 	char			shortname[3];
 	char			*comm;
 	int			comm_len;
 };
 
-void thread__init(struct thread *self, pid_t pid);
+void map_groups__init(struct map_groups *self);
 int thread__set_comm(struct thread *self, const char *comm);
 int thread__comm_len(struct thread *self);
 struct thread *threads__findnew(pid_t pid);
 struct thread *register_idle_thread(void);
 void thread__insert_map(struct thread *self, struct map *map);
 int thread__fork(struct thread *self, struct thread *parent);
-size_t thread__fprintf_maps(struct thread *self, FILE *fp);
+size_t map_groups__fprintf_maps(struct map_groups *self, FILE *fp);
 size_t threads__fprintf(FILE *fp);
 
 void maps__insert(struct rb_root *maps, struct map *map);
 struct map *maps__find(struct rb_root *maps, u64 addr);
 
-static inline struct map *thread__find_map(struct thread *self,
+static inline void map_groups__insert(struct map_groups *self, struct map *map)
+{
+	 maps__insert(&self->maps[map->type], map);
+}
+
+static inline struct map *map_groups__find(struct map_groups *self,
 					   enum map_type type, u64 addr)
 {
-	return self ? maps__find(&self->maps[type], addr) : NULL;
+	return maps__find(&self->maps[type], addr);
 }
 
-static inline void __thread__insert_map(struct thread *self, struct map *map)
+static inline struct map *thread__find_map(struct thread *self,
+					   enum map_type type, u64 addr)
 {
-	 maps__insert(&self->maps[map->type], map);
+	return self ? map_groups__find(&self->mg, type, addr) : NULL;
 }
 
 void thread__find_addr_location(struct thread *self, u8 cpumode,
 				enum map_type type, u64 addr,
 				struct addr_location *al,
 				symbol_filter_t filter);
-struct symbol *thread__find_symbol(struct thread *self,
-				   enum map_type type, u64 addr,
-				   symbol_filter_t filter);
+struct symbol *map_groups__find_symbol(struct map_groups *self,
+				       enum map_type type, u64 addr,
+				       symbol_filter_t filter);
 
 static inline struct symbol *
-thread__find_function(struct thread *self, u64 addr, symbol_filter_t filter)
+map_groups__find_function(struct map_groups *self, u64 addr,
+			  symbol_filter_t filter)
 {
-	return thread__find_symbol(self, MAP__FUNCTION, addr, filter);
+	return map_groups__find_symbol(self, MAP__FUNCTION, addr, filter);
 }
 #endif	/* __PERF_THREAD_H */
-- 
1.6.2.5

