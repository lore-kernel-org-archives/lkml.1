Return-Path: <linux-kernel-owner+w=401wt.eu-S1757812AbZKRWVJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757812AbZKRWVJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 17:21:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757726AbZKRWVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 17:21:06 -0500
Received: from casper.infradead.org ([85.118.1.10]:41080 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757522AbZKRWVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 17:21:04 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Roland McGrath <roland@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 4/4] perf symbols: Capture the running kernel buildid too
Date: Wed, 18 Nov 2009 20:20:53 -0200
Message-Id: <1258582853-8579-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1258582853-8579-3-git-send-email-acme@infradead.org>
References: <1258582853-8579-1-git-send-email-acme@infradead.org>
 <1258582853-8579-2-git-send-email-acme@infradead.org>
 <1258582853-8579-3-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[root@doppio linux-2.6-tip]# perf record -a -f sleep 3s ; perf
buildid-list | grep vmlinux
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.171 MB perf.data (~7489 samples) ]
18e7cc53db62a7d35e9d6f6c9ddc23017d38ee9a vmlinux
[root@doppio linux-2.6-tip]#

Several refactorings were needed so that we can have simmetry between
dsos__load_modules and dsos__load_kernel, i.e. those functions will
respectively create and add to the dsos list the loaded modules and
kernel, with its buildids, but not load its symbols. That is something
the subcomands that need will have to call dso__load_kernel_sym(), just
like we do with modules with dsos__load_module_sym()/dso__load_module_sym().

Nexts csets will actually use this info to stop producing bogus results
using mismatched vmlinux and .ko files.

Yeah, we need to close some races here and there, but aside from evil
corner cases (that you should know and avoid, of course), this is good
enough till we do the right thing :-)

Cc: Roland McGrath <roland@redhat.com>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c |    7 ++++-
 tools/perf/util/header.c |    1 +
 tools/perf/util/symbol.c |   65 ++++++++++++++++++++++++++-------------------
 tools/perf/util/symbol.h |    3 +-
 4 files changed, 46 insertions(+), 30 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 07b92c3..6d770ac 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -948,7 +948,12 @@ static int symbol_filter(struct map *map, struct symbol *sym)
 
 static int parse_symbols(void)
 {
-	if (dsos__load_kernel(vmlinux_name, symbol_filter, 1) <= 0)
+	struct dso *kernel = dsos__load_kernel();
+
+	if (kernel == NULL)
+		return -1;
+
+	if (dso__load_kernel_sym(kernel, symbol_filter, 1) <= 0)
 		return -1;
 
 	if (dump_symtab)
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index d3d656f..425a29b 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -241,6 +241,7 @@ perf_header__adds_write(struct perf_header *self, int fd)
 
 		buildid_sec = &feat_sec[idx++];
 
+		dsos__load_kernel();
 		/*
 		 * Read the list of loaded modules with its build_ids
 		 */
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 7b4cede..4d75e74 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1352,17 +1352,11 @@ static int dso__load_vmlinux(struct dso *self, struct map *map,
 	return err;
 }
 
-int dsos__load_kernel(const char *vmlinux, symbol_filter_t filter,
-		      int use_modules)
+int dso__load_kernel_sym(struct dso *self, symbol_filter_t filter, int use_modules)
 {
 	int err = -1;
-	struct dso *dso = dso__new(vmlinux);
 
-	if (dso == NULL)
-		return -1;
-
-	dso->short_name = "[kernel]";
-	kernel_map = map__new2(0, dso);
+	kernel_map = map__new2(0, self);
 	if (kernel_map == NULL)
 		goto out_delete_dso;
 
@@ -1374,39 +1368,36 @@ int dsos__load_kernel(const char *vmlinux, symbol_filter_t filter,
 		use_modules = 0;
 	}
 
-	if (vmlinux) {
-		err = dso__load_vmlinux(dso, kernel_map, vmlinux, filter);
-		if (err > 0 && use_modules) {
-			int syms = dsos__load_modules_sym(filter);
+	err = dso__load_vmlinux(self, kernel_map, self->name, filter);
+	if (err > 0 && use_modules) {
+		int syms = dsos__load_modules_sym(filter);
 
-			if (syms < 0)
-				pr_warning("Failed to read module symbols!"
-					   " Continuing...\n");
-			else
-				err += syms;
-		}
+		if (syms < 0)
+			pr_warning("Failed to read module symbols!"
+				   " Continuing...\n");
+		else
+			err += syms;
 	}
 
 	if (err <= 0)
 		err = kernel_maps__load_kallsyms(filter, use_modules);
 
 	if (err > 0) {
-		struct rb_node *node = rb_first(&dso->syms);
+		struct rb_node *node = rb_first(&self->syms);
 		struct symbol *sym = rb_entry(node, struct symbol, rb_node);
 
 		kernel_map->start = sym->start;
-		node = rb_last(&dso->syms);
+		node = rb_last(&self->syms);
 		sym = rb_entry(node, struct symbol, rb_node);
 		kernel_map->end = sym->end;
 
-		dso->origin = DSO__ORIG_KERNEL;
+		self->origin = DSO__ORIG_KERNEL;
 		kernel_maps__insert(kernel_map);
 		/*
 		 * Now that we have all sorted out, just set the ->end of all
 		 * maps:
 		 */
 		kernel_maps__fixup_end();
-		dsos__add(dso);
 
 		if (verbose)
 			kernel_maps__fprintf(stderr);
@@ -1415,7 +1406,7 @@ int dsos__load_kernel(const char *vmlinux, symbol_filter_t filter,
 	return err;
 
 out_delete_dso:
-	dso__delete(dso);
+	dso__delete(self);
 	return -1;
 }
 
@@ -1475,18 +1466,36 @@ size_t dsos__fprintf_buildid(FILE *fp)
 	return ret;
 }
 
-int load_kernel(symbol_filter_t filter)
+struct dso *dsos__load_kernel(void)
 {
-	if (dsos__load_kernel(vmlinux_name, filter, modules) <= 0)
-		return -1;
+	struct dso *kernel = dso__new(vmlinux_name);
 
+	if (kernel == NULL)
+		return NULL;
+
+	kernel->short_name = "[kernel]";
 	vdso = dso__new("[vdso]");
 	if (!vdso)
-		return -1;
+		return NULL;
+
+	if (sysfs__read_build_id("/sys/kernel/notes", kernel->build_id,
+				 sizeof(kernel->build_id)) == 0)
+		kernel->has_build_id = true;
 
+	dsos__add(kernel);
 	dsos__add(vdso);
 
-	return 0;
+	return kernel;
+}
+
+int load_kernel(symbol_filter_t filter)
+{
+	struct dso *kernel = dsos__load_kernel();
+
+	if (kernel == NULL)
+		return -1;
+
+	return dso__load_kernel_sym(kernel, filter, modules);
 }
 
 void symbol__init(unsigned int priv_size)
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index da7ec1a..f0593a6 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -77,10 +77,10 @@ void dso__delete(struct dso *self);
 
 struct symbol *dso__find_symbol(struct dso *self, u64 ip);
 
-int dsos__load_kernel(const char *vmlinux, symbol_filter_t filter, int modules);
 int dsos__load_modules(void);
 struct dso *dsos__findnew(const char *name);
 int dso__load(struct dso *self, struct map *map, symbol_filter_t filter);
+int dso__load_kernel_sym(struct dso *self, symbol_filter_t filter, int modules);
 void dsos__fprintf(FILE *fp);
 size_t dsos__fprintf_buildid(FILE *fp);
 
@@ -94,6 +94,7 @@ int sysfs__read_build_id(const char *filename, void *bf, size_t size);
 bool dsos__read_build_ids(void);
 int build_id__sprintf(u8 *self, int len, char *bf);
 
+struct dso *dsos__load_kernel(void);
 int load_kernel(symbol_filter_t filter);
 
 void symbol__init(unsigned int priv_size);
-- 
1.6.2.5

