Return-Path: <linux-kernel-owner+w=401wt.eu-S1755406AbZLKQvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406AbZLKQvH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 11:51:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752490AbZLKQus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 11:50:48 -0500
Received: from casper.infradead.org ([85.118.1.10]:60431 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbZLKQup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 11:50:45 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 4/4] perf symbols: Add support for 'variable' symtabs
Date: Fri, 11 Dec 2009 14:50:39 -0200
Message-Id: <1260550239-5372-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1260550239-5372-1-git-send-email-acme@infradead.org>
References: <1260550239-5372-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Example:

{
	u64 addr = strtoull(sym_filter, NULL, 16);
	struct map *map = map_groups__find(kmaps, MAP__VARIABLE, addr);

	if (map == NULL)
		pr_err("couldn't find map!\n");
	else {
		struct symbol *sym = map__find_symbol(map, addr, NULL);
		if (sym == NULL)
			pr_err("couldn't find addr!\n");
		else
			pr_info("addr %#Lx is in %s global var\n", addr, sym->name);
	}
	exit(0);
}

Added just after symbol__init() call in 'perf top', then:

{
        u64 addr = strtoull(sym_filter, NULL, 16);
        struct map *map = map_groups__find(kmaps, MAP__VARIABLE, addr);

        if (map == NULL)
                pr_err("couldn't find map!\n");
        else {
                struct symbol *sym = map__find_symbol(map, addr, NULL);
                if (sym == NULL)
                        pr_err("couldn't find addr!\n");
                else
                        pr_info("addr %#Lx is in %s global var\n", addr, sym->name);
        }
        exit(0);
}

[root@doppio linux-2.6-tip]# grep ' [dD] ' /proc/kallsyms | grep ' sched'
ffffffff817827d8 d sched_nr_latency
ffffffff81782ce0 d sched_domains_mutex
ffffffff8178c070 d schedstr.22423
ffffffff817909a0 d sched_register_mutex
ffffffff81823490 d sched_feat_names
ffffffff81823558 d scheduler_running
ffffffff818235b8 d sched_clock_running
ffffffff818235bc D sched_clock_stable
ffffffff81824f00 d sched_switch_trace
[root@doppio linux-2.6-tip]# perf top -s 0xffffffff817827d9
addr 0xffffffff817827d9 is in sched_nr_latency global var
[root@doppio linux-2.6-tip]# perf top -s ffffffff81782ce0
addr 0xffffffff81782ce0 is in sched_domains_mutex global var
[root@doppio linux-2.6-tip]#
[root@doppio linux-2.6-tip]# perf top -s ffffffff81782ce0 --vmlinux OFF
The file OFF cannot be used, trying to use /proc/kallsyms...addr 0xffffffff81782ce0 is in sched_domains_mutex global var
[root@doppio linux-2.6-tip]# perf top -s ffffffff818235bc --vmlinux OFF
The file OFF cannot be used, trying to use /proc/kallsyms...addr 0xffffffff818235bc is in sched_clock_stable global var
[root@doppio linux-2.6-tip]#

So it works with both /proc/kallsyms and with ELF symtabs, either the one on
the vmlinux explicitely passed via --vmlinux or in one in the vmlinux_path that
matches the buildid for the running kernel or the one found in the buildid
header section in a perf.data file.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.h  |    3 +-
 tools/perf/util/symbol.c |   66 +++++++++++++++++++++++++++++++++++----------
 2 files changed, 53 insertions(+), 16 deletions(-)

diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index d9a65d9..5664094 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -103,9 +103,10 @@ void event__print_totals(void);
 
 enum map_type {
 	MAP__FUNCTION = 0,
+	MAP__VARIABLE,
 };
 
-#define MAP__NR_TYPES (MAP__FUNCTION + 1)
+#define MAP__NR_TYPES (MAP__VARIABLE + 1)
 
 struct map {
 	union {
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index db8dc97..e63ddb4 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -61,6 +61,8 @@ static bool symbol_type__is_a(char symbol_type, enum map_type map_type)
 	switch (map_type) {
 	case MAP__FUNCTION:
 		return symbol_type == 'T' || symbol_type == 'W';
+	case MAP__VARIABLE:
+		return symbol_type == 'D' || symbol_type == 'd';
 	default:
 		return false;
 	}
@@ -551,6 +553,13 @@ static inline int elf_sym__is_function(const GElf_Sym *sym)
 	       sym->st_shndx != SHN_UNDEF;
 }
 
+static inline bool elf_sym__is_object(const GElf_Sym *sym)
+{
+	return elf_sym__type(sym) == STT_OBJECT &&
+		sym->st_name != 0 &&
+		sym->st_shndx != SHN_UNDEF;
+}
+
 static inline int elf_sym__is_label(const GElf_Sym *sym)
 {
 	return elf_sym__type(sym) == STT_NOTYPE &&
@@ -571,6 +580,12 @@ static inline int elf_sec__is_text(const GElf_Shdr *shdr,
 	return strstr(elf_sec__name(shdr, secstrs), "text") != NULL;
 }
 
+static inline bool elf_sec__is_data(const GElf_Shdr *shdr,
+				    const Elf_Data *secstrs)
+{
+	return strstr(elf_sec__name(shdr, secstrs), "data") != NULL;
+}
+
 static inline const char *elf_sym__name(const GElf_Sym *sym,
 					const Elf_Data *symstrs)
 {
@@ -756,6 +771,8 @@ static bool elf_sym__is_a(GElf_Sym *self, enum map_type type)
 	switch (type) {
 	case MAP__FUNCTION:
 		return elf_sym__is_function(self);
+	case MAP__VARIABLE:
+		return elf_sym__is_object(self);
 	default:
 		return false;
 	}
@@ -766,6 +783,8 @@ static bool elf_sec__is_a(GElf_Shdr *self, Elf_Data *secstrs, enum map_type type
 	switch (type) {
 	case MAP__FUNCTION:
 		return elf_sec__is_text(self, secstrs);
+	case MAP__VARIABLE:
+		return elf_sec__is_data(self, secstrs);
 	default:
 		return false;
 	}
@@ -1536,42 +1555,59 @@ size_t dsos__fprintf_buildid(FILE *fp)
 		__dsos__fprintf_buildid(&dsos__user, fp));
 }
 
-static int map_groups__create_kernel_map(struct map_groups *self, const char *vmlinux)
+static struct dso *dsos__create_kernel( const char *vmlinux)
 {
-	struct map *kmap;
 	struct dso *kernel = dso__new(vmlinux ?: "[kernel.kallsyms]");
 
 	if (kernel == NULL)
-		return -1;
-
-	kmap = map__new2(0, kernel, MAP__FUNCTION);
-	if (kmap == NULL)
-		goto out_delete_kernel_dso;
+		return NULL;
 
-	kmap->map_ip	   = kmap->unmap_ip = identity__map_ip;
 	kernel->short_name = "[kernel]";
 	kernel->kernel	   = 1;
 
 	vdso = dso__new("[vdso]");
 	if (vdso == NULL)
-		goto out_delete_kernel_map;
+		goto out_delete_kernel_dso;
 	dso__set_loaded(vdso, MAP__FUNCTION);
 
 	if (sysfs__read_build_id("/sys/kernel/notes", kernel->build_id,
 				 sizeof(kernel->build_id)) == 0)
 		kernel->has_build_id = true;
 
-	map_groups__insert(self, kmap);
 	dsos__add(&dsos__kernel, kernel);
 	dsos__add(&dsos__user, vdso);
 
-	return 0;
+	return kernel;
 
-out_delete_kernel_map:
-	map__delete(kmap);
 out_delete_kernel_dso:
 	dso__delete(kernel);
-	return -1;
+	return NULL;
+}
+
+static int map_groups__create_kernel_maps(struct map_groups *self, const char *vmlinux)
+{
+	struct map *functions, *variables;
+	struct dso *kernel = dsos__create_kernel(vmlinux);
+
+	if (kernel == NULL)
+		return -1;
+
+	functions = map__new2(0, kernel, MAP__FUNCTION);
+	if (functions == NULL)
+		return -1;
+
+	variables = map__new2(0, kernel, MAP__VARIABLE);
+	if (variables == NULL) {
+		map__delete(functions);
+		return -1;
+	}
+
+	functions->map_ip = functions->unmap_ip =
+		variables->map_ip = variables->unmap_ip = identity__map_ip;
+	map_groups__insert(self, functions);
+	map_groups__insert(self, variables);
+
+	return 0;
 }
 
 static void vmlinux_path__exit(void)
@@ -1640,7 +1676,7 @@ int symbol__init(struct symbol_conf *conf)
 	if (pconf->try_vmlinux_path && vmlinux_path__init() < 0)
 		return -1;
 
-	if (map_groups__create_kernel_map(kmaps, pconf->vmlinux_name) < 0) {
+	if (map_groups__create_kernel_maps(kmaps, pconf->vmlinux_name) < 0) {
 		vmlinux_path__exit();
 		return -1;
 	}
-- 
1.6.2.5

