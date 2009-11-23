Return-Path: <linux-kernel-owner+w=401wt.eu-S1755448AbZKWSjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448AbZKWSjU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 13:39:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753719AbZKWSjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 13:39:19 -0500
Received: from casper.infradead.org ([85.118.1.10]:37434 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235AbZKWSjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 13:39:18 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/1] perf symbols: Look for vmlinux in more places
Date: Mon, 23 Nov 2009 16:39:10 -0200
Message-Id: <1259001550-8194-1-git-send-email-acme@infradead.org>
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

Now that we can check the buildid to see if it really matches, this can
be done safely.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c |    3 +-
 tools/perf/builtin-kmem.c     |    2 +-
 tools/perf/builtin-report.c   |    6 ++-
 tools/perf/builtin-sched.c    |    3 +-
 tools/perf/builtin-top.c      |    3 +-
 tools/perf/builtin-trace.c    |    3 +-
 tools/perf/util/data_map.c    |    4 +-
 tools/perf/util/data_map.h    |    2 +
 tools/perf/util/header.c      |    2 +-
 tools/perf/util/symbol.c      |  113 ++++++++++++++++++++++++++++++++++++----
 tools/perf/util/symbol.h      |    4 +-
 11 files changed, 122 insertions(+), 23 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 2031527..6b13a1e 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -37,6 +37,7 @@ static bool		use_modules;
 
 static unsigned long	page_size;
 static unsigned long	mmap_window = 32;
+const char		*vmlinux_name;
 
 struct sym_hist {
 	u64		sum;
@@ -637,7 +638,7 @@ static int __cmd_annotate(void)
 		exit(0);
 	}
 
-	if (kernel_maps__init(use_modules) < 0) {
+	if (kernel_maps__init(vmlinux_name, true, use_modules) < 0) {
 		pr_err("failed to create kernel maps for symbol resolution\b");
 		return -1;
 	}
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 4145049..5d8aeae 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -291,7 +291,7 @@ static int read_events(void)
 	register_idle_thread();
 	register_perf_file_handler(&file_handler);
 
-	return mmap_dispatch_perf_file(&header, input_name, 0, 0,
+	return mmap_dispatch_perf_file(&header, input_name, NULL, false, 0, 0,
 				       &cwdlen, &cwd);
 }
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 7e690f7..fe474b7 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -52,6 +52,7 @@ static char		*pretty_printing_style = default_pretty_printing_style;
 static int		exclude_other = 1;
 
 static char		callchain_default_opt[] = "fractal,0.5";
+const char		*vmlinux_name;
 
 static char		*cwd;
 static int		cwdlen;
@@ -925,8 +926,9 @@ static int __cmd_report(void)
 
 	register_perf_file_handler(&file_handler);
 
-	ret = mmap_dispatch_perf_file(&header, input_name, force, full_paths,
-				      &cwdlen, &cwd);
+	ret = mmap_dispatch_perf_file(&header, input_name, vmlinux_name,
+				      !vmlinux_name, force,
+				      full_paths, &cwdlen, &cwd);
 	if (ret)
 		return ret;
 
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index df44b75..260f57a 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1718,7 +1718,8 @@ static int read_events(void)
 	register_idle_thread();
 	register_perf_file_handler(&file_handler);
 
-	return mmap_dispatch_perf_file(&header, input_name, 0, 0, &cwdlen, &cwd);
+	return mmap_dispatch_perf_file(&header, input_name, NULL, false, 0, 0,
+				       &cwdlen, &cwd);
 }
 
 static void print_bad_events(void)
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index ea49c2e..eef9caa 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -79,6 +79,7 @@ static int			dump_symtab                     =      0;
 static bool			hide_kernel_symbols		=  false;
 static bool			hide_user_symbols		=  false;
 static struct winsize		winsize;
+const char 			*vmlinux_name;
 static const char		*graph_line			=
 	"_____________________________________________________________________"
 	"_____________________________________________________________________";
@@ -1341,7 +1342,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 	if (delay_secs < 1)
 		delay_secs = 1;
 
-	err = kernel_maps__init(true);
+	err = kernel_maps__init(vmlinux_name, !vmlinux_name, true);
 	if (err < 0)
 		return err;
 	parse_source(sym_filter_entry);
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index d042d65..b71198e 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -131,7 +131,8 @@ static int __cmd_trace(void)
 	register_idle_thread();
 	register_perf_file_handler(&file_handler);
 
-	return mmap_dispatch_perf_file(&header, input_name, 0, 0, &cwdlen, &cwd);
+	return mmap_dispatch_perf_file(&header, input_name, NULL, false,
+				       0, 0, &cwdlen, &cwd);
 }
 
 static const char * const annotate_usage[] = {
diff --git a/tools/perf/util/data_map.c b/tools/perf/util/data_map.c
index e7b6c2b..f318d19 100644
--- a/tools/perf/util/data_map.c
+++ b/tools/perf/util/data_map.c
@@ -101,6 +101,8 @@ out:
 
 int mmap_dispatch_perf_file(struct perf_header **pheader,
 			    const char *input_name,
+			    const char *vmlinux_name,
+			    bool try_vmlinux_path,
 			    int force,
 			    int full_paths,
 			    int *cwdlen,
@@ -171,7 +173,7 @@ int mmap_dispatch_perf_file(struct perf_header **pheader,
 		goto out_delete;
 
 	err = -ENOMEM;
-	if (kernel_maps__init(true) < 0) {
+	if (kernel_maps__init(vmlinux_name, try_vmlinux_path, true) < 0) {
 		pr_err("failed to setup the kernel maps to resolve symbols\n");
 		goto out_delete;
 	}
diff --git a/tools/perf/util/data_map.h b/tools/perf/util/data_map.h
index ae036ec..3f0d21b 100644
--- a/tools/perf/util/data_map.h
+++ b/tools/perf/util/data_map.h
@@ -23,6 +23,8 @@ struct perf_file_handler {
 void register_perf_file_handler(struct perf_file_handler *handler);
 int mmap_dispatch_perf_file(struct perf_header **pheader,
 			    const char *input_name,
+			    const char *vmlinux_name,
+			    bool try_vmlinux_path,
 			    int force,
 			    int full_paths,
 			    int *cwdlen,
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index ac3410b..1332f8e 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -257,7 +257,7 @@ static int perf_header__adds_write(struct perf_header *self, int fd)
 		 * Read the kernel buildid nad the list of loaded modules with
 		 * its build_ids:
 		 */
-		kernel_maps__init(true);
+		kernel_maps__init(NULL, false, true);
 
 		/* Write build-ids */
 		buildid_sec->offset = lseek(fd, 0, SEEK_CUR);
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 74b5b8a..44d81d5 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -34,6 +34,8 @@ static void kernel_maps__insert(struct map *map);
 static int dso__load_kernel_sym(struct dso *self, struct map *map,
 				symbol_filter_t filter);
 unsigned int symbol__priv_size;
+static int vmlinux_path__nr_entries;
+static char **vmlinux_path;
 
 static struct rb_root kernel_maps;
 
@@ -1386,15 +1388,43 @@ static int dso__load_vmlinux(struct dso *self, struct map *map,
 static int dso__load_kernel_sym(struct dso *self, struct map *map,
 				symbol_filter_t filter)
 {
-	int err = dso__load_vmlinux(self, map, self->name, filter);
+	int err;
+	bool is_kallsyms;
+
+	if (vmlinux_path != NULL) {
+		int i;
+		pr_debug("Looking at the vmlinux_path (%d entries long)\n",
+			 vmlinux_path__nr_entries);
+		for (i = 0; i < vmlinux_path__nr_entries; ++i) {
+			err = dso__load_vmlinux(self, map, vmlinux_path[i],
+						filter);
+			if (err > 0) {
+				pr_debug("Using %s for symbols\n",
+					 vmlinux_path[i]);
+				dso__set_long_name(self,
+						   strdup(vmlinux_path[i]));
+				goto out_fixup;
+			}
+		}
+	}
+
+	is_kallsyms = self->long_name[0] == '[';
+	if (is_kallsyms)
+		goto do_kallsyms;
 
+	err = dso__load_vmlinux(self, map, self->long_name, filter);
 	if (err <= 0) {
+		pr_info("The file %s cannot be used, "
+			"trying to use /proc/kallsyms...", self->long_name);
+		sleep(2);
+do_kallsyms:
 		err = kernel_maps__load_kallsyms(filter);
-		if (err > 0)
+		if (err > 0 && !is_kallsyms)
                         dso__set_long_name(self, strdup("[kernel.kallsyms]"));
 	}
 
 	if (err > 0) {
+out_fixup:
 		map__fixup_start(map);
 		map__fixup_end(map);
 	}
@@ -1403,9 +1433,7 @@ static int dso__load_kernel_sym(struct dso *self, struct map *map,
 }
 
 LIST_HEAD(dsos);
-struct dso	*vdso;
-
-const char	*vmlinux_name = "vmlinux";
+struct dso *vdso;
 
 static void dsos__add(struct dso *dso)
 {
@@ -1457,9 +1485,9 @@ size_t dsos__fprintf_buildid(FILE *fp)
 	return ret;
 }
 
-static int kernel_maps__create_kernel_map(void)
+static int kernel_maps__create_kernel_map(const char *vmlinux_name)
 {
-	struct dso *kernel = dso__new(vmlinux_name);
+	struct dso *kernel = dso__new(vmlinux_name ?: "[kernel.kallsyms]");
 
 	if (kernel == NULL)
 		return -1;
@@ -1468,10 +1496,10 @@ static int kernel_maps__create_kernel_map(void)
 	if (kernel_map == NULL)
 		goto out_delete_kernel_dso;
 
-	kernel_map->map_ip = kernel_map->unmap_ip = identity__map_ip;
+	kernel_map->map_ip	 = kernel_map->unmap_ip = identity__map_ip;
+	kernel->short_name	 = "[kernel]";
+	kernel->kernel		 = 1;
 
-	kernel->short_name = "[kernel]";
-	kernel->kernel = 1;
 	vdso = dso__new("[vdso]");
 	if (vdso == NULL)
 		goto out_delete_kernel_map;
@@ -1494,11 +1522,72 @@ out_delete_kernel_dso:
 	return -1;
 }
 
-int kernel_maps__init(bool use_modules)
+static void vmlinux_path__exit(void)
+{
+	while (--vmlinux_path__nr_entries >= 0) {
+		free(vmlinux_path[vmlinux_path__nr_entries]);
+		vmlinux_path[vmlinux_path__nr_entries] = NULL;
+	}
+
+	free(vmlinux_path);
+	vmlinux_path = NULL;
+}
+
+static int vmlinux_path__init(void)
+{
+	struct utsname uts;
+	char bf[PATH_MAX];
+
+	if (uname(&uts) < 0)
+		return -1;
+
+	vmlinux_path = malloc(sizeof(char *) * 5);
+	if (vmlinux_path == NULL)
+		return -1;
+
+	vmlinux_path[vmlinux_path__nr_entries] = strdup("vmlinux");
+	if (vmlinux_path[vmlinux_path__nr_entries] == NULL)
+		goto out_fail;
+	++vmlinux_path__nr_entries;
+	vmlinux_path[vmlinux_path__nr_entries] = strdup("/boot/vmlinux");
+	if (vmlinux_path[vmlinux_path__nr_entries] == NULL)
+		goto out_fail;
+	++vmlinux_path__nr_entries;
+	snprintf(bf, sizeof(bf), "/boot/vmlinux-%s", uts.release);
+	vmlinux_path[vmlinux_path__nr_entries] = strdup(bf);
+	if (vmlinux_path[vmlinux_path__nr_entries] == NULL)
+		goto out_fail;
+	++vmlinux_path__nr_entries;
+	snprintf(bf, sizeof(bf), "/lib/modules/%s/build/vmlinux", uts.release);
+	vmlinux_path[vmlinux_path__nr_entries] = strdup(bf);
+	if (vmlinux_path[vmlinux_path__nr_entries] == NULL)
+		goto out_fail;
+	++vmlinux_path__nr_entries;
+	snprintf(bf, sizeof(bf), "/usr/lib/debug/lib/modules/%s/vmlinux",
+		 uts.release);
+	vmlinux_path[vmlinux_path__nr_entries] = strdup(bf);
+	if (vmlinux_path[vmlinux_path__nr_entries] == NULL)
+		goto out_fail;
+	++vmlinux_path__nr_entries;
+
+	return 0;
+
+out_fail:
+	vmlinux_path__exit();
+	return -1;
+}
+
+int kernel_maps__init(const char *vmlinux_name, bool try_vmlinux_path,
+		      bool use_modules)
 {
-	if (kernel_maps__create_kernel_map() < 0)
+	if (try_vmlinux_path && vmlinux_path__init() < 0)
 		return -1;
 
+	if (kernel_maps__create_kernel_map(vmlinux_name) < 0) {
+		vmlinux_path__exit();
+		return -1;
+	}
+
 	if (use_modules && kernel_maps__create_module_maps() < 0)
 		pr_debug("Failed to load list of modules in use, "
 			 "continuing...\n");
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 7a12904..8c4d026 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -93,7 +93,8 @@ int sysfs__read_build_id(const char *filename, void *bf, size_t size);
 bool dsos__read_build_ids(void);
 int build_id__sprintf(u8 *self, int len, char *bf);
 
-int kernel_maps__init(bool use_modules);
+int kernel_maps__init(const char *vmlinux_name, bool try_vmlinux_path,
+		      bool use_modules);
 size_t kernel_maps__fprintf(FILE *fp);
 
 void symbol__init(unsigned int priv_size);
@@ -101,5 +102,4 @@ void symbol__init(unsigned int priv_size);
 extern struct list_head dsos;
 extern struct map *kernel_map;
 extern struct dso *vdso;
-extern const char *vmlinux_name;
 #endif /* __PERF_SYMBOL */
-- 
1.6.2.5

