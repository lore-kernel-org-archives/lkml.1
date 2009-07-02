Return-Path: <linux-kernel-owner+w=401wt.eu-S1754524AbZGBGIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524AbZGBGIn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 02:08:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751612AbZGBGIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 02:08:36 -0400
Received: from mail.gmx.net ([213.165.64.20]:35066 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751425AbZGBGIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 02:08:36 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+5Il5KyBu5Phb0LqlWL175c7Cvvr0PgXTaW8v/Io
	7//RRhrv6ZAwYx
Subject: [patch 3/4] perf_counter tools: connect module support
 infrastructure to symbol loading infrastructure
From: Mike Galbraith <efault@gmx.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <1246514639.13293.40.camel@marge.simson.net>
References: <1246514639.13293.40.camel@marge.simson.net>
Content-Type: text/plain
Date: Thu, 02 Jul 2009 08:08:36 +0200
Message-Id: <1246514916.13293.46.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


perf_counter tools: connect module support infrastructure to symbol loading infrastructure.


Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>

---
 tools/perf/builtin-annotate.c |    2 
 tools/perf/builtin-report.c   |    2 
 tools/perf/builtin-top.c      |    2 
 tools/perf/util/symbol.c      |  159 +++++++++++++++++++++++++++++++++++++++---
 tools/perf/util/symbol.h      |    5 +
 5 files changed, 156 insertions(+), 14 deletions(-)

Index: linux-2.6/tools/perf/util/symbol.h
===================================================================
--- linux-2.6.orig/tools/perf/util/symbol.h
+++ linux-2.6/tools/perf/util/symbol.h
@@ -5,6 +5,7 @@
 #include "types.h"
 #include <linux/list.h>
 #include <linux/rbtree.h>
+#include "module.h"
 
 struct symbol {
 	struct rb_node	rb_node;
@@ -13,6 +14,7 @@ struct symbol {
 	u64		obj_start;
 	u64		hist_sum;
 	u64		*hist;
+	struct module	*module;
 	void		*priv;
 	char		name[0];
 };
@@ -41,7 +43,8 @@ static inline void *dso__sym_priv(struct
 struct symbol *dso__find_symbol(struct dso *self, u64 ip);
 
 int dso__load_kernel(struct dso *self, const char *vmlinux,
-		     symbol_filter_t filter, int verbose);
+		     symbol_filter_t filter, int verbose, int modules);
+int dso__load_modules(struct dso *self, symbol_filter_t filter, int verbose);
 int dso__load(struct dso *self, symbol_filter_t filter, int verbose);
 
 size_t dso__fprintf(struct dso *self, FILE *fp);
Index: linux-2.6/tools/perf/util/symbol.c
===================================================================
--- linux-2.6.orig/tools/perf/util/symbol.c
+++ linux-2.6/tools/perf/util/symbol.c
@@ -35,7 +35,7 @@ static struct symbol *symbol__new(u64 st
 		self = ((void *)self) + priv_size;
 	}
 	self->start = start;
-	self->end   = start + len - 1;
+	self->end   = len ? start + len - 1 : start;
 	memcpy(self->name, name, namelen);
 
 	return self;
@@ -48,8 +48,12 @@ static void symbol__delete(struct symbol
 
 static size_t symbol__fprintf(struct symbol *self, FILE *fp)
 {
-	return fprintf(fp, " %llx-%llx %s\n",
+	if (!self->module)
+		return fprintf(fp, " %llx-%llx %s\n",
 		       self->start, self->end, self->name);
+	else
+		return fprintf(fp, " %llx-%llx %s \t[%s]\n",
+		       self->start, self->end, self->name, self->module->name);
 }
 
 struct dso *dso__new(const char *name, unsigned int sym_priv_size)
@@ -310,6 +314,26 @@ static inline int elf_sym__is_function(c
 	       sym->st_size != 0;
 }
 
+static inline int elf_sym__is_label(const GElf_Sym *sym)
+{
+	return elf_sym__type(sym) == STT_NOTYPE &&
+		sym->st_name != 0 &&
+		sym->st_shndx != SHN_UNDEF &&
+		sym->st_shndx != SHN_ABS;
+}
+
+static inline const char *elf_sec__name(const GElf_Shdr *shdr,
+					const Elf_Data *secstrs)
+{
+	return secstrs->d_buf + shdr->sh_name;
+}
+
+static inline int elf_sec__is_text(const GElf_Shdr *shdr,
+					const Elf_Data *secstrs)
+{
+	return strstr(elf_sec__name(shdr, secstrs), "text") != NULL;
+}
+
 static inline const char *elf_sym__name(const GElf_Sym *sym,
 					const Elf_Data *symstrs)
 {
@@ -451,9 +475,9 @@ static int dso__synthesize_plt_symbols(s
 }
 
 static int dso__load_sym(struct dso *self, int fd, const char *name,
-			 symbol_filter_t filter, int verbose)
+			 symbol_filter_t filter, int verbose, struct module *mod)
 {
-	Elf_Data *symstrs;
+	Elf_Data *symstrs, *secstrs;
 	uint32_t nr_syms;
 	int err = -1;
 	uint32_t index;
@@ -461,7 +485,7 @@ static int dso__load_sym(struct dso *sel
 	GElf_Shdr shdr;
 	Elf_Data *syms;
 	GElf_Sym sym;
-	Elf_Scn *sec, *sec_dynsym;
+	Elf_Scn *sec, *sec_dynsym, *sec_strndx;
 	Elf *elf;
 	size_t dynsym_idx;
 	int nr = 0;
@@ -520,6 +544,14 @@ static int dso__load_sym(struct dso *sel
 	if (symstrs == NULL)
 		goto out_elf_end;
 
+	sec_strndx = elf_getscn(elf, ehdr.e_shstrndx);
+	if (sec_strndx == NULL)
+		goto out_elf_end;
+
+	secstrs = elf_getdata(sec_strndx, NULL);
+	if (symstrs == NULL)
+		goto out_elf_end;
+
 	nr_syms = shdr.sh_size / shdr.sh_entsize;
 
 	memset(&sym, 0, sizeof(sym));
@@ -529,8 +561,11 @@ static int dso__load_sym(struct dso *sel
 	elf_symtab__for_each_symbol(syms, nr_syms, index, sym) {
 		struct symbol *f;
 		u64 obj_start;
+		struct section *section = NULL;
+		int is_label = elf_sym__is_label(&sym);
+		const char *section_name;
 
-		if (!elf_sym__is_function(&sym))
+		if (!is_label && !elf_sym__is_function(&sym))
 			continue;
 
 		sec = elf_getscn(elf, sym.st_shndx);
@@ -538,6 +573,11 @@ static int dso__load_sym(struct dso *sel
 			goto out_elf_end;
 
 		gelf_getshdr(sec, &shdr);
+
+		if (is_label && !elf_sec__is_text(&shdr, secstrs))
+			continue;
+
+		section_name = elf_sec__name(&shdr, secstrs);
 		obj_start = sym.st_value;
 
 		if (self->prelinked) {
@@ -548,6 +588,17 @@ static int dso__load_sym(struct dso *sel
 			sym.st_value -= shdr.sh_addr - shdr.sh_offset;
 		}
 
+		if (mod) {
+			section = mod->sections->find_section(mod->sections, section_name);
+			if (section)
+				sym.st_value += section->vma;
+			else {
+				fprintf(stderr, "dso__load_sym() module %s lookup of %s failed\n",
+					mod->name, section_name);
+				goto out_elf_end;
+			}
+		}
+
 		f = symbol__new(sym.st_value, sym.st_size,
 				elf_sym__name(&sym, symstrs),
 				self->sym_priv_size, obj_start, verbose);
@@ -557,6 +608,7 @@ static int dso__load_sym(struct dso *sel
 		if (filter && filter(self, f))
 			symbol__delete(f, self->sym_priv_size);
 		else {
+			f->module = mod;
 			dso__insert_symbol(self, f);
 			nr++;
 		}
@@ -606,7 +658,7 @@ more:
 		fd = open(name, O_RDONLY);
 	} while (fd < 0);
 
-	ret = dso__load_sym(self, fd, name, filter, verbose);
+	ret = dso__load_sym(self, fd, name, filter, verbose, NULL);
 	close(fd);
 
 	/*
@@ -620,6 +672,86 @@ out:
 	return ret;
 }
 
+static int dso__load_module(struct dso *self, struct mod_dso *mods, const char *name,
+			     symbol_filter_t filter, int verbose)
+{
+	struct module *mod = mod_dso__find_module(mods, name);
+	int err = 0, fd;
+
+	if (mod == NULL || !mod->active)
+		return err;
+
+	fd = open(mod->path, O_RDONLY);
+
+	if (fd < 0)
+		return err;
+
+	err = dso__load_sym(self, fd, name, filter, verbose, mod);
+	close(fd);
+
+	return err;
+}
+
+int dso__load_modules(struct dso *self, symbol_filter_t filter, int verbose)
+{
+	struct mod_dso *mods = mod_dso__new_dso("modules");
+	struct module *pos;
+	struct rb_node *next;
+	int err;
+
+	err = mod_dso__load_modules(mods);
+
+	if (err <= 0)
+		return err;
+
+	/*
+	 * Iterate over modules, and load active symbols.
+	 */
+	next = rb_first(&mods->mods);
+	while (next) {
+		pos = rb_entry(next, struct module, rb_node);
+		err = dso__load_module(self, mods, pos->name, filter, verbose);
+
+		if (err < 0)
+			break;
+
+		next = rb_next(&pos->rb_node);
+	}
+
+	if (err < 0) {
+		mod_dso__delete_modules(mods);
+		mod_dso__delete_self(mods);
+	}
+
+	return err;
+}
+
+static inline void dso__fill_symbol_holes(struct dso *self)
+{
+	struct symbol *prev = NULL;
+	struct rb_node *nd;
+
+	for (nd = rb_last(&self->syms); nd; nd = rb_prev(nd)) {
+		struct symbol *pos = rb_entry(nd, struct symbol, rb_node);
+
+		if (prev) {
+			u64 hole = 0;
+			int alias = pos->start == prev->start;
+
+			if (!alias)
+				hole = prev->start - pos->end - 1;
+
+			if (hole || alias) {
+				if (alias)
+					pos->end = prev->end;
+				else if (hole)
+					pos->end = prev->start - 1;
+			}
+		}
+		prev = pos;
+	}
+}
+
 static int dso__load_vmlinux(struct dso *self, const char *vmlinux,
 			     symbol_filter_t filter, int verbose)
 {
@@ -628,19 +760,26 @@ static int dso__load_vmlinux(struct dso
 	if (fd < 0)
 		return -1;
 
-	err = dso__load_sym(self, fd, vmlinux, filter, verbose);
+	err = dso__load_sym(self, fd, vmlinux, filter, verbose, NULL);
+
+	if (err > 0)
+		dso__fill_symbol_holes(self);
+
 	close(fd);
 
 	return err;
 }
 
 int dso__load_kernel(struct dso *self, const char *vmlinux,
-		     symbol_filter_t filter, int verbose)
+		     symbol_filter_t filter, int verbose, int modules)
 {
 	int err = -1;
 
-	if (vmlinux)
+	if (vmlinux) {
 		err = dso__load_vmlinux(self, vmlinux, filter, verbose);
+		if (err > 0 && modules)
+			err = dso__load_modules(self, filter, verbose);
+	}
 
 	if (err <= 0)
 		err = dso__load_kallsyms(self, filter, verbose);
Index: linux-2.6/tools/perf/builtin-annotate.c
===================================================================
--- linux-2.6.orig/tools/perf/builtin-annotate.c
+++ linux-2.6/tools/perf/builtin-annotate.c
@@ -171,7 +171,7 @@ static int load_kernel(void)
 	if (!kernel_dso)
 		return -1;
 
-	err = dso__load_kernel(kernel_dso, vmlinux, NULL, verbose);
+	err = dso__load_kernel(kernel_dso, vmlinux, NULL, verbose, 0);
 	if (err <= 0) {
 		dso__delete(kernel_dso);
 		kernel_dso = NULL;
Index: linux-2.6/tools/perf/builtin-report.c
===================================================================
--- linux-2.6.orig/tools/perf/builtin-report.c
+++ linux-2.6/tools/perf/builtin-report.c
@@ -188,7 +188,7 @@ static int load_kernel(void)
 	if (!kernel_dso)
 		return -1;
 
-	err = dso__load_kernel(kernel_dso, vmlinux, NULL, verbose);
+	err = dso__load_kernel(kernel_dso, vmlinux, NULL, verbose, 0);
 	if (err <= 0) {
 		dso__delete(kernel_dso);
 		kernel_dso = NULL;
Index: linux-2.6/tools/perf/builtin-top.c
===================================================================
--- linux-2.6.orig/tools/perf/builtin-top.c
+++ linux-2.6/tools/perf/builtin-top.c
@@ -364,7 +364,7 @@ static int parse_symbols(void)
 	if (kernel_dso == NULL)
 		return -1;
 
-	if (dso__load_kernel(kernel_dso, NULL, symbol_filter, 1) <= 0)
+	if (dso__load_kernel(kernel_dso, NULL, symbol_filter, 1, 0) <= 0)
 		goto out_delete_dso;
 
 	node = rb_first(&kernel_dso->syms);


