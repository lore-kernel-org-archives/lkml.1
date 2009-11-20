Return-Path: <linux-kernel-owner+w=401wt.eu-S1755471AbZKTWwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471AbZKTWwY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 17:52:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754129AbZKTWwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 17:52:24 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:58658 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818AbZKTWvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 17:51:33 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 4/6] perf symbols: Do lazy symtab loading for the kernel & modules too
Date: Fri, 20 Nov 2009 20:51:27 -0200
Message-Id: <1258757489-5978-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1258757489-5978-3-git-send-email-acme@infradead.org>
References: <1258757489-5978-1-git-send-email-acme@infradead.org>
 <1258757489-5978-2-git-send-email-acme@infradead.org>
 <1258757489-5978-3-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Just like we do with the other DSOs. This also simplifies the
kernel_maps setup process, now all that the tools need to do is to call
kernel_maps__init and the maps for the modules and kernel will be
created, then, later, when kernel_maps__find_symbol() is used, it will
also call maps__find_symbol that already checks if the symtab was
loaded, loading it if needed.

Now if one does 'perf top --hide_kernel_symbols' we won't pay the price
of loading the (many) symbols in /proc/kallsyms or vmlinux.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c |    8 +-
 tools/perf/builtin-report.c   |    6 +-
 tools/perf/builtin-top.c      |   35 ++-------
 tools/perf/util/data_map.c    |    4 +-
 tools/perf/util/event.h       |    3 +
 tools/perf/util/header.c      |    6 +-
 tools/perf/util/map.c         |   23 ++++++
 tools/perf/util/symbol.c      |  173 ++++++++++++++---------------------------
 tools/perf/util/symbol.h      |    9 +--
 tools/perf/util/thread.h      |    3 +-
 10 files changed, 109 insertions(+), 161 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index b6da147..2031527 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -157,7 +157,7 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 
 	if (event->header.misc & PERF_RECORD_MISC_KERNEL) {
 		level = 'k';
-		sym = kernel_maps__find_symbol(ip, &map);
+		sym = kernel_maps__find_symbol(ip, &map, symbol_filter);
 		dump_printf(" ...... dso: %s\n",
 			    map ? map->dso->long_name : "<not found>");
 	} else if (event->header.misc & PERF_RECORD_MISC_USER) {
@@ -637,9 +637,9 @@ static int __cmd_annotate(void)
 		exit(0);
 	}
 
-	if (load_kernel(symbol_filter, use_modules) < 0) {
-		perror("failed to load kernel symbols");
-		return EXIT_FAILURE;
+	if (kernel_maps__init(use_modules) < 0) {
+		pr_err("failed to create kernel maps for symbol resolution\b");
+		return -1;
 	}
 
 remap:
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 0af4840..0d39e80 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -449,7 +449,7 @@ got_map:
 		 * trick of looking in the whole kernel symbol list.
 		 */
 		if ((long long)ip < 0)
-			return kernel_maps__find_symbol(ip, mapp);
+			return kernel_maps__find_symbol(ip, mapp, NULL);
 	}
 	dump_printf(" ...... dso: %s\n",
 		    map ? map->dso->long_name : "<not found>");
@@ -496,7 +496,7 @@ static struct symbol **resolve_callchain(struct thread *thread, struct map *map,
 		case PERF_CONTEXT_HV:
 			break;
 		case PERF_CONTEXT_KERNEL:
-			sym = kernel_maps__find_symbol(ip, &map);
+			sym = kernel_maps__find_symbol(ip, &map, NULL);
 			break;
 		default:
 			sym = resolve_symbol(thread, &map, &ip);
@@ -716,7 +716,7 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 
 	if (cpumode == PERF_RECORD_MISC_KERNEL) {
 		level = 'k';
-		sym = kernel_maps__find_symbol(ip, &map);
+		sym = kernel_maps__find_symbol(ip, &map, NULL);
 		dump_printf(" ...... dso: %s\n",
 			    map ? map->dso->long_name : "<not found>");
 	} else if (cpumode == PERF_RECORD_MISC_USER) {
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 48cc108..ea49c2e 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -830,6 +830,8 @@ static void handle_keypress(int c)
 		case 'q':
 		case 'Q':
 			printf("exiting.\n");
+			if (dump_symtab)
+				dsos__fprintf(stderr);
 			exit(0);
 		case 's':
 			prompt_symbol(&sym_filter_entry, "Enter details symbol");
@@ -946,30 +948,6 @@ static int symbol_filter(struct map *map, struct symbol *sym)
 	return 0;
 }
 
-static int parse_symbols(void)
-{
-	struct dso *kernel = dsos__load_kernel();
-
-	if (kernel == NULL)
-		return -1;
-
-	if (dsos__load_modules() < 0)
-		pr_debug("Couldn't read the complete list of modules, "
-			 "continuing...\n");
-
-	if (dsos__load_modules_sym(symbol_filter) < 0)
-		pr_warning("Failed to read module symbols, continuing...\n");
-
-	if (dso__load_kernel_sym(kernel, symbol_filter, 1) <= 0)
-		pr_debug("Couldn't read the complete list of kernel symbols, "
-			 "continuing...\n");
-
-	if (dump_symtab)
-		dsos__fprintf(stderr);
-
-	return 0;
-}
-
 static void event__process_sample(const event_t *self, int counter)
 {
 	u64 ip = self->ip.ip;
@@ -1012,7 +990,7 @@ static void event__process_sample(const event_t *self, int counter)
 		if (hide_kernel_symbols)
 			return;
 
-		sym = kernel_maps__find_symbol(ip, &map);
+		sym = kernel_maps__find_symbol(ip, &map, symbol_filter);
 		if (sym == NULL)
 			return;
 		break;
@@ -1339,7 +1317,7 @@ static const struct option options[] = {
 
 int cmd_top(int argc, const char **argv, const char *prefix __used)
 {
-	int counter;
+	int counter, err;
 
 	page_size = sysconf(_SC_PAGE_SIZE);
 
@@ -1363,10 +1341,11 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 	if (delay_secs < 1)
 		delay_secs = 1;
 
-	parse_symbols();
+	err = kernel_maps__init(true);
+	if (err < 0)
+		return err;
 	parse_source(sym_filter_entry);
 
-
 	/*
 	 * User specified count overrides default frequency.
 	 */
diff --git a/tools/perf/util/data_map.c b/tools/perf/util/data_map.c
index a444a26..e7b6c2b 100644
--- a/tools/perf/util/data_map.c
+++ b/tools/perf/util/data_map.c
@@ -171,8 +171,8 @@ int mmap_dispatch_perf_file(struct perf_header **pheader,
 		goto out_delete;
 
 	err = -ENOMEM;
-	if (load_kernel(NULL, 1) < 0) {
-		pr_err("failed to load kernel symbols\n");
+	if (kernel_maps__init(true) < 0) {
+		pr_err("failed to setup the kernel maps to resolve symbols\n");
 		goto out_delete;
 	}
 
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 34c6fcb..f1e3926 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -115,10 +115,13 @@ typedef int (*symbol_filter_t)(struct map *map, struct symbol *sym);
 void map__init(struct map *self, u64 start, u64 end, u64 pgoff,
 	       struct dso *dso);
 struct map *map__new(struct mmap_event *event, char *cwd, int cwdlen);
+void map__delete(struct map *self);
 struct map *map__clone(struct map *self);
 int map__overlap(struct map *l, struct map *r);
 size_t map__fprintf(struct map *self, FILE *fp);
 struct symbol *map__find_symbol(struct map *self, u64 ip, symbol_filter_t filter);
+void map__fixup_start(struct map *self);
+void map__fixup_end(struct map *self);
 
 int event__synthesize_thread(pid_t pid, int (*process)(event_t *event));
 void event__synthesize_threads(int (*process)(event_t *event));
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index d5c81eb..ac3410b 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -253,11 +253,11 @@ static int perf_header__adds_write(struct perf_header *self, int fd)
 
 		buildid_sec = &feat_sec[idx++];
 
-		dsos__load_kernel();
 		/*
-		 * Read the list of loaded modules with its build_ids
+		 * Read the kernel buildid nad the list of loaded modules with
+		 * its build_ids:
 		 */
-		dsos__load_modules();
+		kernel_maps__init(true);
 
 		/* Write build-ids */
 		buildid_sec->offset = lseek(fd, 0, SEEK_CUR);
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 94ca950..0941232 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -75,6 +75,29 @@ out_delete:
 	return NULL;
 }
 
+void map__delete(struct map *self)
+{
+	free(self);
+}
+
+void map__fixup_start(struct map *self)
+{
+	struct rb_node *nd = rb_first(&self->dso->syms);
+	if (nd != NULL) {
+		struct symbol *sym = rb_entry(nd, struct symbol, rb_node);
+		self->start = sym->start;
+	}
+}
+
+void map__fixup_end(struct map *self)
+{
+	struct rb_node *nd = rb_last(&self->dso->syms);
+	if (nd != NULL) {
+		struct symbol *sym = rb_entry(nd, struct symbol, rb_node);
+		self->end = sym->end;
+	}
+}
+
 #define DSO__DELETED "(deleted)"
 
 struct symbol *
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index c324bdf..cb086cb 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -27,6 +27,8 @@ static void dsos__add(struct dso *dso);
 static struct dso *dsos__find(const char *name);
 static struct map *map__new2(u64 start, struct dso *dso);
 static void kernel_maps__insert(struct map *map);
+static int dso__load_kernel_sym(struct dso *self, struct map *map,
+				symbol_filter_t filter);
 unsigned int symbol__priv_size;
 
 static struct rb_root kernel_maps;
@@ -69,12 +71,6 @@ static void kernel_maps__fixup_end(void)
 		curr = rb_entry(nd, struct map, rb_node);
 		prev->end = curr->start - 1;
 	}
-
-	nd = rb_last(&curr->dso->syms);
-	if (nd) {
-		struct symbol *sym = rb_entry(nd, struct symbol, rb_node);
-		curr->end = sym->end;
-	}
 }
 
 static struct symbol *symbol__new(u64 start, u64 len, const char *name)
@@ -324,7 +320,7 @@ out_failure:
  * kernel range is broken in several maps, named [kernel].N, as we don't have
  * the original ELF section names vmlinux have.
  */
-static int kernel_maps__split_kallsyms(symbol_filter_t filter, int use_modules)
+static int kernel_maps__split_kallsyms(symbol_filter_t filter)
 {
 	struct map *map = kernel_map;
 	struct symbol *pos;
@@ -340,9 +336,6 @@ static int kernel_maps__split_kallsyms(symbol_filter_t filter, int use_modules)
 
 		module = strchr(pos->name, '\t');
 		if (module) {
-			if (!use_modules)
-				goto delete_symbol;
-
 			*module++ = '\0';
 
 			if (strcmp(map->dso->name, module)) {
@@ -382,7 +375,6 @@ static int kernel_maps__split_kallsyms(symbol_filter_t filter, int use_modules)
 		}
 
 		if (filter && filter(map, pos)) {
-delete_symbol:
 			rb_erase(&pos->rb_node, &kernel_map->dso->syms);
 			symbol__delete(pos);
 		} else {
@@ -398,17 +390,18 @@ delete_symbol:
 }
 
 
-static int kernel_maps__load_kallsyms(symbol_filter_t filter, int use_modules)
+static int kernel_maps__load_kallsyms(symbol_filter_t filter)
 {
 	if (kernel_maps__load_all_kallsyms())
 		return -1;
 
 	dso__fixup_sym_end(kernel_map->dso);
+	kernel_map->dso->origin = DSO__ORIG_KERNEL;
 
-	return kernel_maps__split_kallsyms(filter, use_modules);
+	return kernel_maps__split_kallsyms(filter);
 }
 
-static size_t kernel_maps__fprintf(FILE *fp)
+size_t kernel_maps__fprintf(FILE *fp)
 {
 	size_t printed = fprintf(fp, "Kernel maps:\n");
 	struct rb_node *nd;
@@ -1042,13 +1035,17 @@ char dso__symtab_origin(const struct dso *self)
 int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
 {
 	int size = PATH_MAX;
-	char *name = malloc(size);
+	char *name;
 	u8 build_id[BUILD_ID_SIZE];
 	int ret = -1;
 	int fd;
 
 	self->loaded = 1;
 
+	if (self->kernel)
+		return dso__load_kernel_sym(self, map, filter);
+
+	name = malloc(size);
 	if (!name)
 		return -1;
 
@@ -1139,7 +1136,8 @@ static void kernel_maps__insert(struct map *map)
 	maps__insert(&kernel_maps, map);
 }
 
-struct symbol *kernel_maps__find_symbol(u64 ip, struct map **mapp)
+struct symbol *kernel_maps__find_symbol(u64 ip, struct map **mapp,
+					symbol_filter_t filter)
 {
 	struct map *map = maps__find(&kernel_maps, ip);
 
@@ -1148,7 +1146,7 @@ struct symbol *kernel_maps__find_symbol(u64 ip, struct map **mapp)
 
 	if (map) {
 		ip = map->map_ip(map, ip);
-		return map->dso->find_symbol(map->dso, ip);
+		return map__find_symbol(map, ip, filter);
 	}
 
 	return NULL;
@@ -1168,28 +1166,9 @@ struct map *kernel_maps__find_by_dso_name(const char *name)
 	return NULL;
 }
 
-static int dso__load_module_sym(struct dso *self, struct map *map,
-				symbol_filter_t filter)
-{
-	int err = 0, fd = open(self->long_name, O_RDONLY);
-
-	self->loaded = 1;
-
-	if (fd < 0) {
-		pr_err("%s: cannot open %s\n", __func__, self->long_name);
-		return err;
-	}
-
-	err = dso__load_sym(self, map, self->long_name, fd, filter, 0, 1);
-	close(fd);
-
-	return err;
-}
-
-static int dsos__load_modules_sym_dir(char *dirname, symbol_filter_t filter)
+static int dsos__set_modules_path_dir(char *dirname)
 {
 	struct dirent *dent;
-	int nr_symbols = 0, err;
 	DIR *dir = opendir(dirname);
 
 	if (!dir) {
@@ -1207,14 +1186,12 @@ static int dsos__load_modules_sym_dir(char *dirname, symbol_filter_t filter)
 
 			snprintf(path, sizeof(path), "%s/%s",
 				 dirname, dent->d_name);
-			err = dsos__load_modules_sym_dir(path, filter);
-			if (err < 0)
+			if (dsos__set_modules_path_dir(path) < 0)
 				goto failure;
 		} else {
 			char *dot = strrchr(dent->d_name, '.'),
 			     dso_name[PATH_MAX];
 			struct map *map;
-			struct rb_node *last;
 			char *long_name;
 
 			if (dot == NULL || strcmp(dot, ".ko"))
@@ -1234,36 +1211,16 @@ static int dsos__load_modules_sym_dir(char *dirname, symbol_filter_t filter)
 			if (long_name == NULL)
 				goto failure;
 			dso__set_long_name(map->dso, long_name);
-			dso__set_basename(map->dso);
-
-			err = dso__load_module_sym(map->dso, map, filter);
-			if (err < 0)
-				goto failure;
-			last = rb_last(&map->dso->syms);
-			if (last) {
-				struct symbol *sym;
-				/*
-				 * We do this here as well, even having the
-				 * symbol size found in the symtab because
-				 * misannotated ASM symbols may have the size
-				 * set to zero.
-				 */
-				dso__fixup_sym_end(map->dso);
-
-				sym = rb_entry(last, struct symbol, rb_node);
-				map->end = map->start + sym->end;
-			}
 		}
-		nr_symbols += err;
 	}
 
-	return nr_symbols;
+	return 0;
 failure:
 	closedir(dir);
 	return -1;
 }
 
-int dsos__load_modules_sym(symbol_filter_t filter)
+static int dsos__set_modules_path(void)
 {
 	struct utsname uts;
 	char modules_path[PATH_MAX];
@@ -1274,7 +1231,7 @@ int dsos__load_modules_sym(symbol_filter_t filter)
 	snprintf(modules_path, sizeof(modules_path), "/lib/modules/%s/kernel",
 		 uts.release);
 
-	return dsos__load_modules_sym_dir(modules_path, filter);
+	return dsos__set_modules_path_dir(modules_path);
 }
 
 /*
@@ -1296,7 +1253,7 @@ static struct map *map__new2(u64 start, struct dso *dso)
 	return self;
 }
 
-int dsos__load_modules(void)
+static int kernel_maps__create_module_maps(void)
 {
 	char *line = NULL;
 	size_t n;
@@ -1360,7 +1317,13 @@ int dsos__load_modules(void)
 	free(line);
 	fclose(file);
 
-	return 0;
+	/*
+	 * Now that we have all sorted out, just set the ->end of all
+	 * maps:
+	 */
+	kernel_maps__fixup_end();
+
+	return dsos__set_modules_path();
 
 out_delete_line:
 	free(line);
@@ -1385,40 +1348,17 @@ static int dso__load_vmlinux(struct dso *self, struct map *map,
 	return err;
 }
 
-int dso__load_kernel_sym(struct dso *self, symbol_filter_t filter,
-			 int use_modules)
+static int dso__load_kernel_sym(struct dso *self, struct map *map,
+				symbol_filter_t filter)
 {
-	int err;
+	int err = dso__load_vmlinux(self, map, self->name, filter);
 
-	kernel_map = map__new2(0, self);
-	if (kernel_map == NULL)
-		return -1;
-
-	kernel_map->map_ip = kernel_map->unmap_ip = identity__map_ip;
-
-	err = dso__load_vmlinux(self, kernel_map, self->name, filter);
 	if (err <= 0)
-		err = kernel_maps__load_kallsyms(filter, use_modules);
+		err = kernel_maps__load_kallsyms(filter);
 
 	if (err > 0) {
-		struct rb_node *node = rb_first(&self->syms);
-		struct symbol *sym = rb_entry(node, struct symbol, rb_node);
-
-		kernel_map->start = sym->start;
-		node = rb_last(&self->syms);
-		sym = rb_entry(node, struct symbol, rb_node);
-		kernel_map->end = sym->end;
-
-		self->origin = DSO__ORIG_KERNEL;
-		kernel_maps__insert(kernel_map);
-		/*
-		 * Now that we have all sorted out, just set the ->end of all
-		 * maps:
-		 */
-		kernel_maps__fixup_end();
-
-		if (verbose)
-			kernel_maps__fprintf(stderr);
+		map__fixup_start(map);
+		map__fixup_end(map);
 	}
 
 	return err;
@@ -1479,46 +1419,51 @@ size_t dsos__fprintf_buildid(FILE *fp)
 	return ret;
 }
 
-struct dso *dsos__load_kernel(void)
+static int kernel_maps__create_kernel_map(void)
 {
 	struct dso *kernel = dso__new(vmlinux_name);
 
 	if (kernel == NULL)
-		return NULL;
+		return -1;
+
+	kernel_map = map__new2(0, kernel);
+	if (kernel_map == NULL)
+		goto out_delete_kernel_dso;
+
+	kernel_map->map_ip = kernel_map->unmap_ip = identity__map_ip;
 
 	kernel->short_name = "[kernel]";
+	kernel->kernel = 1;
 	vdso = dso__new("[vdso]");
-	if (!vdso)
-		return NULL;
+	if (vdso == NULL)
+		goto out_delete_kernel_map;
 
 	if (sysfs__read_build_id("/sys/kernel/notes", kernel->build_id,
 				 sizeof(kernel->build_id)) == 0)
 		kernel->has_build_id = true;
 
+	kernel_maps__insert(kernel_map);
 	dsos__add(kernel);
 	dsos__add(vdso);
 
-	return kernel;
+	return 0;
+
+out_delete_kernel_map:
+	map__delete(kernel_map);
+	kernel_map = NULL;
+out_delete_kernel_dso:
+	dso__delete(kernel);
+	return -1;
 }
 
-int load_kernel(symbol_filter_t filter, bool use_modules)
+int kernel_maps__init(bool use_modules)
 {
-	struct dso *kernel = dsos__load_kernel();
-
-	if (kernel == NULL)
+	if (kernel_maps__create_kernel_map() < 0)
 		return -1;
 
-	if (use_modules) {
-		if (dsos__load_modules() < 0)
-			pr_warning("Failed to load list of modules in use, "
-				   "continuing...\n");
-		else if (dsos__load_modules_sym(filter) < 0)
-			pr_warning("Failed to read module symbols, "
-				   "continuing...\n");
-	}
-
-	if (dso__load_kernel_sym(kernel, filter, use_modules) < 0)
-		pr_warning("Failed to read kernel symbols, continuing...\n");
+	if (use_modules && kernel_maps__create_module_maps() < 0)
+		pr_warning("Failed to load list of modules in use, "
+			   "continuing...\n");
 
 	return 0;
 }
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 3d9d346..7a12904 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -64,6 +64,7 @@ struct dso {
 	u8		 slen_calculated:1;
 	u8		 loaded:1;
 	u8		 has_build_id:1;
+	u8		 kernel:1;
 	unsigned char	 origin;
 	u8		 build_id[BUILD_ID_SIZE];
 	u16		 long_name_len;
@@ -77,12 +78,8 @@ void dso__delete(struct dso *self);
 
 struct symbol *dso__find_symbol(struct dso *self, u64 ip);
 
-int dsos__load_modules(void);
-int dsos__load_modules_sym(symbol_filter_t filter);
 struct dso *dsos__findnew(const char *name);
 int dso__load(struct dso *self, struct map *map, symbol_filter_t filter);
-int dso__load_kernel_sym(struct dso *self, symbol_filter_t filter,
-			 int use_modules);
 void dsos__fprintf(FILE *fp);
 size_t dsos__fprintf_buildid(FILE *fp);
 
@@ -96,8 +93,8 @@ int sysfs__read_build_id(const char *filename, void *bf, size_t size);
 bool dsos__read_build_ids(void);
 int build_id__sprintf(u8 *self, int len, char *bf);
 
-struct dso *dsos__load_kernel(void);
-int load_kernel(symbol_filter_t filter, bool use_modules);
+int kernel_maps__init(bool use_modules);
+size_t kernel_maps__fprintf(FILE *fp);
 
 void symbol__init(unsigned int priv_size);
 
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index 53addd7..e4b8d43 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -26,7 +26,8 @@ size_t threads__fprintf(FILE *fp);
 void maps__insert(struct rb_root *maps, struct map *map);
 struct map *maps__find(struct rb_root *maps, u64 ip);
 
-struct symbol *kernel_maps__find_symbol(const u64 ip, struct map **mapp);
+struct symbol *kernel_maps__find_symbol(const u64 ip, struct map **mapp,
+					symbol_filter_t filter);
 struct map *kernel_maps__find_by_dso_name(const char *name);
 
 static inline struct map *thread__find_map(struct thread *self, u64 ip)
-- 
1.6.2.5

