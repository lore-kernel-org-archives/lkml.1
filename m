Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545Ab0BCSxf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 13:53:35 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:50012 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383Ab0BCSwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 13:52:30 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/9] perf symbols: Remove perf_session usage in symbols layer
Date: Wed,  3 Feb 2010 16:52:00 -0200
Message-Id: <1265223128-11786-1-git-send-email-acme@infradead.org>
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

I noticed while writing the first test in 'perf regtest' that to just test the
symbol handling routines one needs to create a perf session, that is a layer
centered on a perf.data file, events, etc, so I untied these layers.

This reduces the complexity for the users as the number of parameters to most
of the symbols and session APIs now was reduced while not adding more state to
all the map instances by only having data that is needed to split the kernel
(kallsyms and ELF symtab sections) maps and do vmlinux relocation on the main
kernel map.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kmem.c  |    2 +-
 tools/perf/builtin-probe.c |    5 +-
 tools/perf/util/event.c    |    6 +--
 tools/perf/util/map.c      |   20 ++++---
 tools/perf/util/map.h      |   22 ++++++--
 tools/perf/util/session.c  |   35 +++++++++----
 tools/perf/util/session.h  |   22 +++++---
 tools/perf/util/symbol.c   |  122 ++++++++++++++++++++-----------------------
 tools/perf/util/symbol.h   |   19 ++++---
 tools/perf/util/thread.c   |    3 +-
 tools/perf/util/thread.h   |   14 +++--
 11 files changed, 149 insertions(+), 121 deletions(-)

diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 5d5dc6b..924a951 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -369,7 +369,7 @@ static void __print_result(struct rb_root *root, struct perf_session *session,
 		if (is_caller) {
 			addr = data->call_site;
 			if (!raw_ip)
-				sym = map_groups__find_function(&session->kmaps, session, addr, NULL);
+				sym = map_groups__find_function(&session->kmaps, addr, NULL);
 		} else
 			addr = data->ptr;
 
diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 34f2acb..4fa73ec 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -122,8 +122,7 @@ static int opt_del_probe_event(const struct option *opt __used,
 static void evaluate_probe_point(struct probe_point *pp)
 {
 	struct symbol *sym;
-	sym = map__find_symbol_by_name(session.kmap, pp->function,
-				       session.psession, NULL);
+	sym = map__find_symbol_by_name(session.kmap, pp->function, NULL);
 	if (!sym)
 		die("Kernel symbol \'%s\' not found - probe not added.",
 		    pp->function);
@@ -132,7 +131,7 @@ static void evaluate_probe_point(struct probe_point *pp)
 #ifndef NO_LIBDWARF
 static int open_vmlinux(void)
 {
-	if (map__load(session.kmap, session.psession, NULL) < 0) {
+	if (map__load(session.kmap, NULL) < 0) {
 		pr_debug("Failed to load kernel map.\n");
 		return -EINVAL;
 	}
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index bbaee61..c3831f6 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -374,9 +374,7 @@ int event__process_mmap(event_t *self, struct perf_session *session)
 				goto out_problem;
 
 			kernel->kernel = 1;
-			if (__map_groups__create_kernel_maps(&session->kmaps,
-							     session->vmlinux_maps,
-							     kernel) < 0)
+			if (__perf_session__create_kernel_maps(session, kernel) < 0)
 				goto out_problem;
 
 			session->vmlinux_maps[MAP__FUNCTION]->start = self->mmap.start;
@@ -476,7 +474,7 @@ void thread__find_addr_location(struct thread *self,
 {
 	thread__find_addr_map(self, session, cpumode, type, addr, al);
 	if (al->map != NULL)
-		al->sym = map__find_symbol(al->map, session, al->addr, filter);
+		al->sym = map__find_symbol(al->map, al->addr, filter);
 	else
 		al->sym = NULL;
 }
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index c4d55a0..36ff0bf 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -104,8 +104,7 @@ void map__fixup_end(struct map *self)
 
 #define DSO__DELETED "(deleted)"
 
-int map__load(struct map *self, struct perf_session *session,
-	      symbol_filter_t filter)
+int map__load(struct map *self, symbol_filter_t filter)
 {
 	const char *name = self->dso->long_name;
 	int nr;
@@ -113,7 +112,7 @@ int map__load(struct map *self, struct perf_session *session,
 	if (dso__loaded(self->dso, self->type))
 		return 0;
 
-	nr = dso__load(self->dso, self, session, filter);
+	nr = dso__load(self->dso, self, filter);
 	if (nr < 0) {
 		if (self->dso->has_build_id) {
 			char sbuild_id[BUILD_ID_SIZE * 2 + 1];
@@ -144,24 +143,29 @@ int map__load(struct map *self, struct perf_session *session,
 
 		return -1;
 	}
+	/*
+	 * Only applies to the kernel, as its symtabs aren't relative like the
+	 * module ones.
+	 */
+	if (self->dso->kernel)
+		map__reloc_vmlinux(self);
 
 	return 0;
 }
 
-struct symbol *map__find_symbol(struct map *self, struct perf_session *session,
-				u64 addr, symbol_filter_t filter)
+struct symbol *map__find_symbol(struct map *self, u64 addr,
+				symbol_filter_t filter)
 {
-	if (map__load(self, session, filter) < 0)
+	if (map__load(self, filter) < 0)
 		return NULL;
 
 	return dso__find_symbol(self->dso, self->type, addr);
 }
 
 struct symbol *map__find_symbol_by_name(struct map *self, const char *name,
-					struct perf_session *session,
 					symbol_filter_t filter)
 {
-	if (map__load(self, session, filter) < 0)
+	if (map__load(self, filter) < 0)
 		return NULL;
 
 	if (!dso__sorted_by_name(self->dso, self->type))
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index 72f0b6a..de04839 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -14,6 +14,8 @@ enum map_type {
 #define MAP__NR_TYPES (MAP__VARIABLE + 1)
 
 struct dso;
+struct ref_reloc_sym;
+struct map_groups;
 
 struct map {
 	union {
@@ -29,6 +31,16 @@ struct map {
 	struct dso		*dso;
 };
 
+struct kmap {
+	struct ref_reloc_sym	*ref_reloc_sym;
+	struct map_groups	*kmaps;
+};
+
+static inline struct kmap *map__kmap(struct map *self)
+{
+	return (struct kmap *)(self + 1);
+}
+
 static inline u64 map__map_ip(struct map *map, u64 ip)
 {
 	return ip - map->start + map->pgoff;
@@ -58,16 +70,14 @@ struct map *map__clone(struct map *self);
 int map__overlap(struct map *l, struct map *r);
 size_t map__fprintf(struct map *self, FILE *fp);
 
-struct perf_session;
-
-int map__load(struct map *self, struct perf_session *session,
-	      symbol_filter_t filter);
-struct symbol *map__find_symbol(struct map *self, struct perf_session *session,
+int map__load(struct map *self, symbol_filter_t filter);
+struct symbol *map__find_symbol(struct map *self,
 				u64 addr, symbol_filter_t filter);
 struct symbol *map__find_symbol_by_name(struct map *self, const char *name,
-					struct perf_session *session,
 					symbol_filter_t filter);
 void map__fixup_start(struct map *self);
 void map__fixup_end(struct map *self);
 
+void map__reloc_vmlinux(struct map *self);
+
 #endif /* __PERF_MAP_H */
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index cf91d09..aa8a031 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -53,6 +53,11 @@ out_close:
 	return -1;
 }
 
+static inline int perf_session__create_kernel_maps(struct perf_session *self)
+{
+	return map_groups__create_kernel_maps(&self->kmaps, self->vmlinux_maps);
+}
+
 struct perf_session *perf_session__new(const char *filename, int mode, bool force)
 {
 	size_t len = filename ? strlen(filename) + 1 : 0;
@@ -507,6 +512,7 @@ int perf_session__set_kallsyms_ref_reloc_sym(struct perf_session *self,
 					     u64 addr)
 {
 	char *bracket;
+	enum map_type i;
 
 	self->ref_reloc_sym.name = strdup(symbol_name);
 	if (self->ref_reloc_sym.name == NULL)
@@ -517,6 +523,12 @@ int perf_session__set_kallsyms_ref_reloc_sym(struct perf_session *self,
 		*bracket = '\0';
 
 	self->ref_reloc_sym.addr = addr;
+
+	for (i = 0; i < MAP__NR_TYPES; ++i) {
+		struct kmap *kmap = map__kmap(self->vmlinux_maps[i]);
+		kmap->ref_reloc_sym = &self->ref_reloc_sym;
+	}
+
 	return 0;
 }
 
@@ -530,20 +542,21 @@ static u64 map__reloc_unmap_ip(struct map *map, u64 ip)
 	return ip - (s64)map->pgoff;
 }
 
-void perf_session__reloc_vmlinux_maps(struct perf_session *self,
-				      u64 unrelocated_addr)
+void map__reloc_vmlinux(struct map *self)
 {
-	enum map_type type;
-	s64 reloc = unrelocated_addr - self->ref_reloc_sym.addr;
+	struct kmap *kmap = map__kmap(self);
+	s64 reloc;
 
-	if (!reloc)
+	if (!kmap->ref_reloc_sym || !kmap->ref_reloc_sym->unrelocated_addr)
 		return;
 
-	for (type = 0; type < MAP__NR_TYPES; ++type) {
-		struct map *map = self->vmlinux_maps[type];
+	reloc = (kmap->ref_reloc_sym->unrelocated_addr -
+		 kmap->ref_reloc_sym->addr);
 
-		map->map_ip = map__reloc_map_ip;
-		map->unmap_ip = map__reloc_unmap_ip;
-		map->pgoff = reloc;
-	}
+	if (!reloc)
+		return;
+
+	self->map_ip   = map__reloc_map_ip;
+	self->unmap_ip = map__reloc_unmap_ip;
+	self->pgoff    = reloc;
 }
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 36d1a80..752d75a 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -3,13 +3,13 @@
 
 #include "event.h"
 #include "header.h"
+#include "symbol.h"
 #include "thread.h"
 #include <linux/rbtree.h>
 #include "../../../include/linux/perf_event.h"
 
 struct ip_callchain;
 struct thread;
-struct symbol;
 
 struct perf_session {
 	struct perf_header	header;
@@ -24,10 +24,7 @@ struct perf_session {
 	unsigned long		unknown_events;
 	struct rb_root		hists;
 	u64			sample_type;
-	struct {
-		const char	*name;
-		u64		addr;
-	}			ref_reloc_sym;
+	struct ref_reloc_sym	ref_reloc_sym;
 	int			fd;
 	int			cwdlen;
 	char			*cwd;
@@ -69,9 +66,20 @@ int perf_header__read_build_ids(struct perf_header *self, int input,
 int perf_session__set_kallsyms_ref_reloc_sym(struct perf_session *self,
 					     const char *symbol_name,
 					     u64 addr);
-void perf_session__reloc_vmlinux_maps(struct perf_session *self,
-				      u64 unrelocated_addr);
 
 void mem_bswap_64(void *src, int byte_size);
 
+static inline int __perf_session__create_kernel_maps(struct perf_session *self,
+						struct dso *kernel)
+{
+	return __map_groups__create_kernel_maps(&self->kmaps,
+						self->vmlinux_maps, kernel);
+}
+
+static inline struct map *
+	perf_session__new_module_map(struct perf_session *self,
+				     u64 start, const char *filename)
+{
+	return map_groups__new_module(&self->kmaps, start, filename);
+}
 #endif /* __PERF_SESSION_H */
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index f9049d1..6138742 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1,6 +1,5 @@
 #include "util.h"
 #include "../perf.h"
-#include "session.h"
 #include "sort.h"
 #include "string.h"
 #include "symbol.h"
@@ -34,7 +33,7 @@ enum dso_origin {
 static void dsos__add(struct list_head *head, struct dso *dso);
 static struct map *map__new2(u64 start, struct dso *dso, enum map_type type);
 static int dso__load_kernel_sym(struct dso *self, struct map *map,
-				struct perf_session *session, symbol_filter_t filter);
+				symbol_filter_t filter);
 static int vmlinux_path__nr_entries;
 static char **vmlinux_path;
 
@@ -480,8 +479,9 @@ static int dso__load_all_kallsyms(struct dso *self, const char *filename,
  * the original ELF section names vmlinux have.
  */
 static int dso__split_kallsyms(struct dso *self, struct map *map,
-			       struct perf_session *session, symbol_filter_t filter)
+			       symbol_filter_t filter)
 {
+	struct map_groups *kmaps = map__kmap(map)->kmaps;
 	struct map *curr_map = map;
 	struct symbol *pos;
 	int count = 0;
@@ -503,7 +503,7 @@ static int dso__split_kallsyms(struct dso *self, struct map *map,
 			*module++ = '\0';
 
 			if (strcmp(curr_map->dso->short_name, module)) {
-				curr_map = map_groups__find_by_name(&session->kmaps, map->type, module);
+				curr_map = map_groups__find_by_name(kmaps, map->type, module);
 				if (curr_map == NULL) {
 					pr_debug("/proc/{kallsyms,modules} "
 					         "inconsistency while looking "
@@ -538,7 +538,7 @@ static int dso__split_kallsyms(struct dso *self, struct map *map,
 			}
 
 			curr_map->map_ip = curr_map->unmap_ip = identity__map_ip;
-			map_groups__insert(&session->kmaps, curr_map);
+			map_groups__insert(kmaps, curr_map);
 			++kernel_range;
 		}
 
@@ -557,9 +557,8 @@ discard_symbol:		rb_erase(&pos->rb_node, root);
 	return count;
 }
 
-
-static int dso__load_kallsyms(struct dso *self, const char *filename, struct map *map,
-			      struct perf_session *session, symbol_filter_t filter)
+int dso__load_kallsyms(struct dso *self, const char *filename,
+		       struct map *map, symbol_filter_t filter)
 {
 	if (dso__load_all_kallsyms(self, filename, map) < 0)
 		return -1;
@@ -567,7 +566,7 @@ static int dso__load_kallsyms(struct dso *self, const char *filename, struct map
 	symbols__fixup_end(&self->symbols[map->type]);
 	self->origin = DSO__ORIG_KERNEL;
 
-	return dso__split_kallsyms(self, map, session, filter);
+	return dso__split_kallsyms(self, map, filter);
 }
 
 static int dso__load_perf_map(struct dso *self, struct map *map,
@@ -893,10 +892,10 @@ static bool elf_sec__is_a(GElf_Shdr *self, Elf_Data *secstrs, enum map_type type
 	}
 }
 
-static int dso__load_sym(struct dso *self, struct map *map,
-			 struct perf_session *session, const char *name, int fd,
-			 symbol_filter_t filter, int kernel, int kmodule)
+static int dso__load_sym(struct dso *self, struct map *map, const char *name,
+			 int fd, symbol_filter_t filter, int kmodule)
 {
+	struct kmap *kmap = self->kernel ? map__kmap(map) : NULL;
 	struct map *curr_map = map;
 	struct dso *curr_dso = self;
 	size_t dso_name_len = strlen(self->short_name);
@@ -953,7 +952,7 @@ static int dso__load_sym(struct dso *self, struct map *map,
 	nr_syms = shdr.sh_size / shdr.sh_entsize;
 
 	memset(&sym, 0, sizeof(sym));
-	if (!kernel) {
+	if (!self->kernel) {
 		self->adjust_symbols = (ehdr.e_type == ET_EXEC ||
 				elf_section_by_name(elf, &ehdr, &shdr,
 						     ".gnu.prelink_undo",
@@ -967,9 +966,9 @@ static int dso__load_sym(struct dso *self, struct map *map,
 		int is_label = elf_sym__is_label(&sym);
 		const char *section_name;
 
-		if (kernel && session->ref_reloc_sym.name != NULL &&
-		    strcmp(elf_name, session->ref_reloc_sym.name) == 0)
-			perf_session__reloc_vmlinux_maps(session, sym.st_value);
+		if (kmap && kmap->ref_reloc_sym && kmap->ref_reloc_sym->name &&
+		    strcmp(elf_name, kmap->ref_reloc_sym->name) == 0)
+			kmap->ref_reloc_sym->unrelocated_addr = sym.st_value;
 
 		if (!is_label && !elf_sym__is_a(&sym, map->type))
 			continue;
@@ -985,7 +984,7 @@ static int dso__load_sym(struct dso *self, struct map *map,
 
 		section_name = elf_sec__name(&shdr, secstrs);
 
-		if (kernel || kmodule) {
+		if (self->kernel || kmodule) {
 			char dso_name[PATH_MAX];
 
 			if (strcmp(section_name,
@@ -1001,7 +1000,7 @@ static int dso__load_sym(struct dso *self, struct map *map,
 			snprintf(dso_name, sizeof(dso_name),
 				 "%s%s", self->short_name, section_name);
 
-			curr_map = map_groups__find_by_name(&session->kmaps, map->type, dso_name);
+			curr_map = map_groups__find_by_name(kmap->kmaps, map->type, dso_name);
 			if (curr_map == NULL) {
 				u64 start = sym.st_value;
 
@@ -1020,7 +1019,7 @@ static int dso__load_sym(struct dso *self, struct map *map,
 				curr_map->map_ip = identity__map_ip;
 				curr_map->unmap_ip = identity__map_ip;
 				curr_dso->origin = DSO__ORIG_KERNEL;
-				map_groups__insert(&session->kmaps, curr_map);
+				map_groups__insert(kmap->kmaps, curr_map);
 				dsos__add(&dsos__kernel, curr_dso);
 			} else
 				curr_dso = curr_map->dso;
@@ -1236,8 +1235,7 @@ char dso__symtab_origin(const struct dso *self)
 	return origin[self->origin];
 }
 
-int dso__load(struct dso *self, struct map *map, struct perf_session *session,
-	      symbol_filter_t filter)
+int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
 {
 	int size = PATH_MAX;
 	char *name;
@@ -1249,7 +1247,7 @@ int dso__load(struct dso *self, struct map *map, struct perf_session *session,
 	dso__set_loaded(self, map->type);
 
 	if (self->kernel)
-		return dso__load_kernel_sym(self, map, session, filter);
+		return dso__load_kernel_sym(self, map, filter);
 
 	name = malloc(size);
 	if (!name)
@@ -1320,7 +1318,7 @@ open_file:
 		fd = open(name, O_RDONLY);
 	} while (fd < 0);
 
-	ret = dso__load_sym(self, map, NULL, name, fd, filter, 0, 0);
+	ret = dso__load_sym(self, map, name, fd, filter, 0);
 	close(fd);
 
 	/*
@@ -1376,7 +1374,7 @@ static int dso__kernel_module_get_build_id(struct dso *self)
 	return 0;
 }
 
-static int perf_session__set_modules_path_dir(struct perf_session *self, char *dirname)
+static int map_groups__set_modules_path_dir(struct map_groups *self, char *dirname)
 {
 	struct dirent *dent;
 	DIR *dir = opendir(dirname);
@@ -1396,7 +1394,7 @@ static int perf_session__set_modules_path_dir(struct perf_session *self, char *d
 
 			snprintf(path, sizeof(path), "%s/%s",
 				 dirname, dent->d_name);
-			if (perf_session__set_modules_path_dir(self, path) < 0)
+			if (map_groups__set_modules_path_dir(self, path) < 0)
 				goto failure;
 		} else {
 			char *dot = strrchr(dent->d_name, '.'),
@@ -1410,7 +1408,7 @@ static int perf_session__set_modules_path_dir(struct perf_session *self, char *d
 				 (int)(dot - dent->d_name), dent->d_name);
 
 			strxfrchar(dso_name, '-', '_');
-			map = map_groups__find_by_name(&self->kmaps, MAP__FUNCTION, dso_name);
+			map = map_groups__find_by_name(self, MAP__FUNCTION, dso_name);
 			if (map == NULL)
 				continue;
 
@@ -1431,7 +1429,7 @@ failure:
 	return -1;
 }
 
-static int perf_session__set_modules_path(struct perf_session *self)
+static int map_groups__set_modules_path(struct map_groups *self)
 {
 	struct utsname uts;
 	char modules_path[PATH_MAX];
@@ -1442,7 +1440,7 @@ static int perf_session__set_modules_path(struct perf_session *self)
 	snprintf(modules_path, sizeof(modules_path), "/lib/modules/%s/kernel",
 		 uts.release);
 
-	return perf_session__set_modules_path_dir(self, modules_path);
+	return map_groups__set_modules_path_dir(self, modules_path);
 }
 
 /*
@@ -1452,8 +1450,8 @@ static int perf_session__set_modules_path(struct perf_session *self)
  */
 static struct map *map__new2(u64 start, struct dso *dso, enum map_type type)
 {
-	struct map *self = malloc(sizeof(*self));
-
+	struct map *self = zalloc(sizeof(*self) +
+				  (dso->kernel ? sizeof(struct kmap) : 0));
 	if (self != NULL) {
 		/*
 		 * ->end will be filled after we load all the symbols
@@ -1464,8 +1462,8 @@ static struct map *map__new2(u64 start, struct dso *dso, enum map_type type)
 	return self;
 }
 
-struct map *perf_session__new_module_map(struct perf_session *self, u64 start,
-					 const char *filename)
+struct map *map_groups__new_module(struct map_groups *self, u64 start,
+				   const char *filename)
 {
 	struct map *map;
 	struct dso *dso = __dsos__findnew(&dsos__kernel, filename);
@@ -1478,11 +1476,11 @@ struct map *perf_session__new_module_map(struct perf_session *self, u64 start,
 		return NULL;
 
 	dso->origin = DSO__ORIG_KMODULE;
-	map_groups__insert(&self->kmaps, map);
+	map_groups__insert(self, map);
 	return map;
 }
 
-static int perf_session__create_module_maps(struct perf_session *self)
+static int map_groups__create_modules(struct map_groups *self)
 {
 	char *line = NULL;
 	size_t n;
@@ -1520,7 +1518,7 @@ static int perf_session__create_module_maps(struct perf_session *self)
 		*sep = '\0';
 
 		snprintf(name, sizeof(name), "[%s]", line);
-		map = perf_session__new_module_map(self, start, name);
+		map = map_groups__new_module(self, start, name);
 		if (map == NULL)
 			goto out_delete_line;
 		dso__kernel_module_get_build_id(map->dso);
@@ -1529,7 +1527,7 @@ static int perf_session__create_module_maps(struct perf_session *self)
 	free(line);
 	fclose(file);
 
-	return perf_session__set_modules_path(self);
+	return map_groups__set_modules_path(self);
 
 out_delete_line:
 	free(line);
@@ -1538,7 +1536,6 @@ out_failure:
 }
 
 static int dso__load_vmlinux(struct dso *self, struct map *map,
-			     struct perf_session *session,
 			     const char *vmlinux, symbol_filter_t filter)
 {
 	int err = -1, fd;
@@ -1572,14 +1569,14 @@ static int dso__load_vmlinux(struct dso *self, struct map *map,
 		return -1;
 
 	dso__set_loaded(self, map->type);
-	err = dso__load_sym(self, map, session, vmlinux, fd, filter, 1, 0);
+	err = dso__load_sym(self, map, vmlinux, fd, filter, 0);
 	close(fd);
 
 	return err;
 }
 
 int dso__load_vmlinux_path(struct dso *self, struct map *map,
-			   struct perf_session *session, symbol_filter_t filter)
+			   symbol_filter_t filter)
 {
 	int i, err = 0;
 
@@ -1587,8 +1584,7 @@ int dso__load_vmlinux_path(struct dso *self, struct map *map,
 		 vmlinux_path__nr_entries);
 
 	for (i = 0; i < vmlinux_path__nr_entries; ++i) {
-		err = dso__load_vmlinux(self, map, session, vmlinux_path[i],
-					filter);
+		err = dso__load_vmlinux(self, map, vmlinux_path[i], filter);
 		if (err > 0) {
 			pr_debug("Using %s for symbols\n", vmlinux_path[i]);
 			dso__set_long_name(self, strdup(vmlinux_path[i]));
@@ -1600,7 +1596,7 @@ int dso__load_vmlinux_path(struct dso *self, struct map *map,
 }
 
 static int dso__load_kernel_sym(struct dso *self, struct map *map,
-				struct perf_session *session, symbol_filter_t filter)
+				symbol_filter_t filter)
 {
 	int err;
 	const char *kallsyms_filename = NULL;
@@ -1621,13 +1617,13 @@ static int dso__load_kernel_sym(struct dso *self, struct map *map,
 	 * match.
 	 */
 	if (symbol_conf.vmlinux_name != NULL) {
-		err = dso__load_vmlinux(self, map, session,
+		err = dso__load_vmlinux(self, map,
 					symbol_conf.vmlinux_name, filter);
 		goto out_try_fixup;
 	}
 
 	if (vmlinux_path != NULL) {
-		err = dso__load_vmlinux_path(self, map, session, filter);
+		err = dso__load_vmlinux_path(self, map, filter);
 		if (err > 0)
 			goto out_fixup;
 	}
@@ -1675,7 +1671,7 @@ static int dso__load_kernel_sym(struct dso *self, struct map *map,
 	}
 
 do_kallsyms:
-	err = dso__load_kallsyms(self, kallsyms_filename, map, session, filter);
+	err = dso__load_kallsyms(self, kallsyms_filename, map, filter);
 	free(kallsyms_allocated_filename);
 
 out_try_fixup:
@@ -1812,30 +1808,23 @@ int __map_groups__create_kernel_maps(struct map_groups *self,
 	enum map_type type;
 
 	for (type = 0; type < MAP__NR_TYPES; ++type) {
+		struct kmap *kmap;
+
 		vmlinux_maps[type] = map__new2(0, kernel, type);
 		if (vmlinux_maps[type] == NULL)
 			return -1;
 
 		vmlinux_maps[type]->map_ip =
 			vmlinux_maps[type]->unmap_ip = identity__map_ip;
+
+		kmap = map__kmap(vmlinux_maps[type]);
+		kmap->kmaps = self;
 		map_groups__insert(self, vmlinux_maps[type]);
 	}
 
 	return 0;
 }
 
-static int map_groups__create_kernel_maps(struct map_groups *self,
-					  struct map *vmlinux_maps[MAP__NR_TYPES],
-					  const char *vmlinux)
-{
-	struct dso *kernel = dsos__create_kernel(vmlinux);
-
-	if (kernel == NULL)
-		return -1;
-
-	return __map_groups__create_kernel_maps(self, vmlinux_maps, kernel);
-}
-
 static void vmlinux_path__exit(void)
 {
 	while (--vmlinux_path__nr_entries >= 0) {
@@ -1941,19 +1930,22 @@ out_free_comm_list:
 	return -1;
 }
 
-int perf_session__create_kernel_maps(struct perf_session *self)
+int map_groups__create_kernel_maps(struct map_groups *self,
+				   struct map *vmlinux_maps[MAP__NR_TYPES])
 {
-	if (map_groups__create_kernel_maps(&self->kmaps, self->vmlinux_maps,
-					   symbol_conf.vmlinux_name) < 0)
+	struct dso *kernel = dsos__create_kernel(symbol_conf.vmlinux_name);
+
+	if (kernel == NULL)
+		return -1;
+
+	if (__map_groups__create_kernel_maps(self, vmlinux_maps, kernel) < 0)
 		return -1;
 
-	if (symbol_conf.use_modules &&
-	    perf_session__create_module_maps(self) < 0)
-		pr_debug("Failed to load list of modules for session %s, "
-			 "continuing...\n", self->filename);
+	if (symbol_conf.use_modules && map_groups__create_modules(self) < 0)
+		return -1;
 	/*
 	 * Now that we have all the maps created, just set the ->end of them:
 	 */
-	map_groups__fixup_end(&self->kmaps);
+	map_groups__fixup_end(self);
 	return 0;
 }
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 1243027..e6a59e5 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -80,6 +80,12 @@ static inline void *symbol__priv(struct symbol *self)
 	return ((void *)self) - symbol_conf.priv_size;
 }
 
+struct ref_reloc_sym {
+	const char	*name;
+	u64		addr;
+	u64		unrelocated_addr;
+};
+
 struct addr_location {
 	struct thread *thread;
 	struct map    *map;
@@ -126,12 +132,11 @@ static inline struct dso *dsos__findnew(const char *name)
 	return __dsos__findnew(&dsos__user, name);
 }
 
-struct perf_session;
-
-int dso__load(struct dso *self, struct map *map, struct perf_session *session,
-	      symbol_filter_t filter);
+int dso__load(struct dso *self, struct map *map, symbol_filter_t filter);
 int dso__load_vmlinux_path(struct dso *self, struct map *map,
-			   struct perf_session *session, symbol_filter_t filter);
+			   symbol_filter_t filter);
+int dso__load_kallsyms(struct dso *self, const char *filename, struct map *map,
+		       symbol_filter_t filter);
 void dsos__fprintf(FILE *fp);
 size_t dsos__fprintf_buildid(FILE *fp, bool with_hits);
 
@@ -156,9 +161,5 @@ int kallsyms__parse(const char *filename, void *arg,
 int symbol__init(void);
 bool symbol_type__is_a(char symbol_type, enum map_type map_type);
 
-int perf_session__create_kernel_maps(struct perf_session *self);
-
-struct map *perf_session__new_module_map(struct perf_session *self, u64 start,
-					 const char *filename);
 extern struct dso *vdso;
 #endif /* __PERF_SYMBOL */
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 4a08dcf..634b7f7 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -282,14 +282,13 @@ size_t perf_session__fprintf(struct perf_session *self, FILE *fp)
 }
 
 struct symbol *map_groups__find_symbol(struct map_groups *self,
-				       struct perf_session *session,
 				       enum map_type type, u64 addr,
 				       symbol_filter_t filter)
 {
 	struct map *map = map_groups__find(self, type, addr);
 
 	if (map != NULL)
-		return map__find_symbol(map, session, map->map_ip(map, addr), filter);
+		return map__find_symbol(map, map->map_ip(map, addr), filter);
 
 	return NULL;
 }
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index e35653c..56f317b 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -59,15 +59,14 @@ void thread__find_addr_location(struct thread *self,
 				struct addr_location *al,
 				symbol_filter_t filter);
 struct symbol *map_groups__find_symbol(struct map_groups *self,
-				       struct perf_session *session,
 				       enum map_type type, u64 addr,
 				       symbol_filter_t filter);
 
-static inline struct symbol *
-map_groups__find_function(struct map_groups *self, struct perf_session *session,
-			  u64 addr, symbol_filter_t filter)
+static inline struct symbol *map_groups__find_function(struct map_groups *self,
+						       u64 addr,
+						       symbol_filter_t filter)
 {
-	return map_groups__find_symbol(self, session, MAP__FUNCTION, addr, filter);
+	return map_groups__find_symbol(self, MAP__FUNCTION, addr, filter);
 }
 
 struct map *map_groups__find_by_name(struct map_groups *self,
@@ -76,4 +75,9 @@ struct map *map_groups__find_by_name(struct map_groups *self,
 int __map_groups__create_kernel_maps(struct map_groups *self,
 				     struct map *vmlinux_maps[MAP__NR_TYPES],
 				     struct dso *kernel);
+int map_groups__create_kernel_maps(struct map_groups *self,
+				   struct map *vmlinux_maps[MAP__NR_TYPES]);
+
+struct map *map_groups__new_module(struct map_groups *self, u64 start,
+				   const char *filename);
 #endif	/* __PERF_THREAD_H */
-- 
1.6.2.5

