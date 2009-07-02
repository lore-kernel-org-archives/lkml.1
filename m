Return-Path: <linux-kernel-owner+w=401wt.eu-S1756219AbZGBHIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219AbZGBHIY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 03:08:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753835AbZGBHHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 03:07:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:54564 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755712AbZGBHHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 03:07:36 -0400
Date: Thu, 2 Jul 2009 07:06:57 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1246514916.13293.46.camel@marge.simson.net>
References: <1246514916.13293.46.camel@marge.simson.net>
Subject: [tip:perfcounters/urgent] perf_counter tools: Connect module support infrastructure to symbol loading infrastructure
Message-ID: <tip-6cfcc53ed4f3ecb9319e73a03f34f1eddcb644dd@git.kernel.org>
Git-Commit-ID: 6cfcc53ed4f3ecb9319e73a03f34f1eddcb644dd
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 02 Jul 2009 07:06:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6cfcc53ed4f3ecb9319e73a03f34f1eddcb644dd
Gitweb:     http://git.kernel.org/tip/6cfcc53ed4f3ecb9319e73a03f34f1eddcb644dd
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Thu, 2 Jul 2009 08:08:36 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 2 Jul 2009 08:42:21 +0200

perf_counter tools: Connect module support infrastructure to symbol loading infrastructure

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <1246514916.13293.46.camel@marge.simson.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-annotate.c |    2 +-
 tools/perf/builtin-report.c   |    2 +-
 tools/perf/builtin-top.c      |    2 +-
 tools/perf/util/symbol.c      |  159 ++++++++++++++++++++++++++++++++++++++---
 tools/perf/util/symbol.h      |    5 +-
 5 files changed, 156 insertions(+), 14 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 3becc8a..8820568 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -171,7 +171,7 @@ static int load_kernel(void)
 	if (!kernel_dso)
 		return -1;
 
-	err = dso__load_kernel(kernel_dso, vmlinux, NULL, verbose);
+	err = dso__load_kernel(kernel_dso, vmlinux, NULL, verbose, 0);
 	if (err <= 0) {
 		dso__delete(kernel_dso);
 		kernel_dso = NULL;
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 58d1612..38d136f 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -188,7 +188,7 @@ static int load_kernel(void)
 	if (!kernel_dso)
 		return -1;
 
-	err = dso__load_kernel(kernel_dso, vmlinux, NULL, verbose);
+	err = dso__load_kernel(kernel_dso, vmlinux, NULL, verbose, 0);
 	if (err <= 0) {
 		dso__delete(kernel_dso);
 		kernel_dso = NULL;
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 97fde1d..9bb25fc 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -364,7 +364,7 @@ static int parse_symbols(void)
 	if (kernel_dso == NULL)
 		return -1;
 
-	if (dso__load_kernel(kernel_dso, NULL, symbol_filter, 1) <= 0)
+	if (dso__load_kernel(kernel_dso, NULL, symbol_filter, 1, 0) <= 0)
 		goto out_delete_dso;
 
 	node = rb_first(&kernel_dso->syms);
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index c077b6a..98a1311 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -35,7 +35,7 @@ static struct symbol *symbol__new(u64 start, u64 len,
 		self = ((void *)self) + priv_size;
 	}
 	self->start = start;
-	self->end   = start + len - 1;
+	self->end   = len ? start + len - 1 : start;
 	memcpy(self->name, name, namelen);
 
 	return self;
@@ -48,8 +48,12 @@ static void symbol__delete(struct symbol *self, unsigned int priv_size)
 
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
@@ -310,6 +314,26 @@ static inline int elf_sym__is_function(const GElf_Sym *sym)
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
@@ -451,9 +475,9 @@ static int dso__synthesize_plt_symbols(struct  dso *self, Elf *elf,
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
@@ -461,7 +485,7 @@ static int dso__load_sym(struct dso *self, int fd, const char *name,
 	GElf_Shdr shdr;
 	Elf_Data *syms;
 	GElf_Sym sym;
-	Elf_Scn *sec, *sec_dynsym;
+	Elf_Scn *sec, *sec_dynsym, *sec_strndx;
 	Elf *elf;
 	size_t dynsym_idx;
 	int nr = 0;
@@ -520,6 +544,14 @@ static int dso__load_sym(struct dso *self, int fd, const char *name,
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
@@ -529,8 +561,11 @@ static int dso__load_sym(struct dso *self, int fd, const char *name,
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
@@ -538,6 +573,11 @@ static int dso__load_sym(struct dso *self, int fd, const char *name,
 			goto out_elf_end;
 
 		gelf_getshdr(sec, &shdr);
+
+		if (is_label && !elf_sec__is_text(&shdr, secstrs))
+			continue;
+
+		section_name = elf_sec__name(&shdr, secstrs);
 		obj_start = sym.st_value;
 
 		if (self->prelinked) {
@@ -548,6 +588,17 @@ static int dso__load_sym(struct dso *self, int fd, const char *name,
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
@@ -557,6 +608,7 @@ static int dso__load_sym(struct dso *self, int fd, const char *name,
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
@@ -628,19 +760,26 @@ static int dso__load_vmlinux(struct dso *self, const char *vmlinux,
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
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 65a8449..4e141a3 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
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
@@ -41,7 +43,8 @@ static inline void *dso__sym_priv(struct dso *self, struct symbol *sym)
 struct symbol *dso__find_symbol(struct dso *self, u64 ip);
 
 int dso__load_kernel(struct dso *self, const char *vmlinux,
-		     symbol_filter_t filter, int verbose);
+		     symbol_filter_t filter, int verbose, int modules);
+int dso__load_modules(struct dso *self, symbol_filter_t filter, int verbose);
 int dso__load(struct dso *self, symbol_filter_t filter, int verbose);
 
 size_t dso__fprintf(struct dso *self, FILE *fp);
