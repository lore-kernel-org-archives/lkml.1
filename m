Return-Path: <linux-kernel-owner+w=401wt.eu-S1763550AbZE1Rzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763550AbZE1Rzs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 13:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759180AbZE1Rzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 13:55:32 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35316 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757193AbZE1Rz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 13:55:29 -0400
Date: Thu, 28 May 2009 14:55:04 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH tip 1/5] perf: Move symbol resolution classes from report
	to libperf
Message-ID: <20090528175504.GC4747@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will be used by perf top as well.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 Documentation/perf_counter/Makefile         |    2 +
 Documentation/perf_counter/builtin-report.c |  458 +--------------------------
 Documentation/perf_counter/util/symbol.c    |  421 ++++++++++++++++++++++++
 Documentation/perf_counter/util/symbol.h    |   33 ++
 4 files changed, 471 insertions(+), 443 deletions(-)
 create mode 100644 Documentation/perf_counter/util/symbol.c
 create mode 100644 Documentation/perf_counter/util/symbol.h

diff --git a/Documentation/perf_counter/Makefile b/Documentation/perf_counter/Makefile
index 51b13f9..bd29a5c 100644
--- a/Documentation/perf_counter/Makefile
+++ b/Documentation/perf_counter/Makefile
@@ -298,6 +298,7 @@ LIB_H += util/help.h
 LIB_H += util/strbuf.h
 LIB_H += util/run-command.h
 LIB_H += util/sigchain.h
+LIB_H += util/symbol.h
 
 LIB_OBJS += util/abspath.o
 LIB_OBJS += util/alias.o
@@ -317,6 +318,7 @@ LIB_OBJS += util/strbuf.o
 LIB_OBJS += util/usage.o
 LIB_OBJS += util/wrapper.o
 LIB_OBJS += util/sigchain.o
+LIB_OBJS += util/symbol.o
 LIB_OBJS += util/pager.o
 
 BUILTIN_OBJS += builtin-help.o
diff --git a/Documentation/perf_counter/builtin-report.c b/Documentation/perf_counter/builtin-report.c
index 9fdf822..04fc7ec 100644
--- a/Documentation/perf_counter/builtin-report.c
+++ b/Documentation/perf_counter/builtin-report.c
@@ -1,13 +1,10 @@
 #include "util/util.h"
 #include "builtin.h"
 
-#include <libelf.h>
-#include <gelf.h>
-#include <elf.h>
-
 #include "util/list.h"
 #include "util/cache.h"
 #include "util/rbtree.h"
+#include "util/symbol.h"
 
 #include "perf.h"
 
@@ -62,305 +59,6 @@ typedef union event_union {
 	struct comm_event comm;
 } event_t;
 
-struct symbol {
-	struct rb_node		rb_node;
-	__u64			start;
-	__u64			end;
-	char			name[0];
-};
-
-static struct symbol *symbol__new(uint64_t start, uint64_t len, const char *name)
-{
-	struct symbol *self = malloc(sizeof(*self) + strlen(name) + 1);
-
-	if (self != NULL) {
-		self->start = start;
-		self->end   = start + len;
-		strcpy(self->name, name);
-	}
-
-	return self;
-}
-
-static void symbol__delete(struct symbol *self)
-{
-	free(self);
-}
-
-static size_t symbol__fprintf(struct symbol *self, FILE *fp)
-{
-	return fprintf(fp, " %llx-%llx %s\n",
-		       self->start, self->end, self->name);
-}
-
-struct dso {
-	struct list_head node;
-	struct rb_root	 syms;
-	char		 name[0];
-};
-
-static struct dso *dso__new(const char *name)
-{
-	struct dso *self = malloc(sizeof(*self) + strlen(name) + 1);
-
-	if (self != NULL) {
-		strcpy(self->name, name);
-		self->syms = RB_ROOT;
-	}
-
-	return self;
-}
-
-static void dso__delete_symbols(struct dso *self)
-{
-	struct symbol *pos;
-	struct rb_node *next = rb_first(&self->syms);
-
-	while (next) {
-		pos = rb_entry(next, struct symbol, rb_node);
-		next = rb_next(&pos->rb_node);
-		symbol__delete(pos);
-	}
-}
-
-static void dso__delete(struct dso *self)
-{
-	dso__delete_symbols(self);
-	free(self);
-}
-
-static void dso__insert_symbol(struct dso *self, struct symbol *sym)
-{
-	struct rb_node **p = &self->syms.rb_node;
-	struct rb_node *parent = NULL;
-	const uint64_t ip = sym->start;
-	struct symbol *s;
-
-	while (*p != NULL) {
-		parent = *p;
-		s = rb_entry(parent, struct symbol, rb_node);
-		if (ip < s->start)
-			p = &(*p)->rb_left;
-		else
-			p = &(*p)->rb_right;
-	}
-	rb_link_node(&sym->rb_node, parent, p);
-	rb_insert_color(&sym->rb_node, &self->syms);
-}
-
-static struct symbol *dso__find_symbol(struct dso *self, uint64_t ip)
-{
-	struct rb_node *n;
-
-	if (self == NULL)
-		return NULL;
-
-	n = self->syms.rb_node;
-
-	while (n) {
-		struct symbol *s = rb_entry(n, struct symbol, rb_node);
-
-		if (ip < s->start)
-			n = n->rb_left;
-		else if (ip > s->end)
-			n = n->rb_right;
-		else
-			return s;
-	}
-
-	return NULL;
-}
-
-/**
- * elf_symtab__for_each_symbol - iterate thru all the symbols
- *
- * @self: struct elf_symtab instance to iterate
- * @index: uint32_t index
- * @sym: GElf_Sym iterator
- */
-#define elf_symtab__for_each_symbol(syms, nr_syms, index, sym) \
-	for (index = 0, gelf_getsym(syms, index, &sym);\
-	     index < nr_syms; \
-	     index++, gelf_getsym(syms, index, &sym))
-
-static inline uint8_t elf_sym__type(const GElf_Sym *sym)
-{
-	return GELF_ST_TYPE(sym->st_info);
-}
-
-static inline int elf_sym__is_function(const GElf_Sym *sym)
-{
-	return elf_sym__type(sym) == STT_FUNC &&
-	       sym->st_name != 0 &&
-	       sym->st_shndx != SHN_UNDEF &&
-	       sym->st_size != 0;
-}
-
-static inline const char *elf_sym__name(const GElf_Sym *sym,
-					const Elf_Data *symstrs)
-{
-	return symstrs->d_buf + sym->st_name;
-}
-
-static Elf_Scn *elf_section_by_name(Elf *elf, GElf_Ehdr *ep,
-				    GElf_Shdr *shp, const char *name,
-				    size_t *index)
-{
-	Elf_Scn *sec = NULL;
-	size_t cnt = 1;
-
-	while ((sec = elf_nextscn(elf, sec)) != NULL) {
-		char *str;
-
-		gelf_getshdr(sec, shp);
-		str = elf_strptr(elf, ep->e_shstrndx, shp->sh_name);
-		if (!strcmp(name, str)) {
-			if (index)
-				*index = cnt;
-			break;
-		}
-		++cnt;
-	}
-
-	return sec;
-}
-
-static int dso__load_sym(struct dso *self, int fd, char *name)
-{
-	Elf_Data *symstrs;
-	uint32_t nr_syms;
-	int err = -1;
-	uint32_t index;
-	GElf_Ehdr ehdr;
-	GElf_Shdr shdr;
-	Elf_Data *syms;
-	GElf_Sym sym;
-	Elf_Scn *sec;
-	Elf *elf;
-	int nr = 0;
-
-	elf = elf_begin(fd, ELF_C_READ_MMAP, NULL);
-	if (elf == NULL) {
-		fprintf(stderr, "%s: cannot read %s ELF file.\n",
-			__func__, name);
-		goto out_close;
-	}
-
-	if (gelf_getehdr(elf, &ehdr) == NULL) {
-		fprintf(stderr, "%s: cannot get elf header.\n", __func__);
-		goto out_elf_end;
-	}
-
-	sec = elf_section_by_name(elf, &ehdr, &shdr, ".symtab", NULL);
-	if (sec == NULL)
-		sec = elf_section_by_name(elf, &ehdr, &shdr, ".dynsym", NULL);
-
-	if (sec == NULL)
-		goto out_elf_end;
-
-	syms = elf_getdata(sec, NULL);
-	if (syms == NULL)
-		goto out_elf_end;
-
-	sec = elf_getscn(elf, shdr.sh_link);
-	if (sec == NULL)
-		goto out_elf_end;
-
-	symstrs = elf_getdata(sec, NULL);
-	if (symstrs == NULL)
-		goto out_elf_end;
-
-	nr_syms = shdr.sh_size / shdr.sh_entsize;
-
-	elf_symtab__for_each_symbol(syms, nr_syms, index, sym) {
-		struct symbol *f;
-
-		if (!elf_sym__is_function(&sym))
-			continue;
-
-		sec = elf_getscn(elf, sym.st_shndx);
-		if (!sec)
-			goto out_elf_end;
-
-		gelf_getshdr(sec, &shdr);
-		sym.st_value -= shdr.sh_addr - shdr.sh_offset;
-
-		f = symbol__new(sym.st_value, sym.st_size,
-				elf_sym__name(&sym, symstrs));
-		if (!f)
-			goto out_elf_end;
-
-		dso__insert_symbol(self, f);
-
-		nr++;
-	}
-
-	err = nr;
-out_elf_end:
-	elf_end(elf);
-out_close:
-	return err;
-}
-
-static int dso__load(struct dso *self)
-{
-	int size = strlen(self->name) + sizeof("/usr/lib/debug%s.debug");
-	char *name = malloc(size);
-	int variant = 0;
-	int ret = -1;
-	int fd;
-
-	if (!name)
-		return -1;
-
-more:
-	do {
-		switch (variant) {
-		case 0: /* Fedora */
-			snprintf(name, size, "/usr/lib/debug%s.debug", self->name);
-			break;
-		case 1: /* Ubuntu */
-			snprintf(name, size, "/usr/lib/debug%s", self->name);
-			break;
-		case 2: /* Sane people */
-			snprintf(name, size, "%s", self->name);
-			break;
-
-		default:
-			goto out;
-		}
-		variant++;
-
-		fd = open(name, O_RDONLY);
-	} while (fd < 0);
-
-	ret = dso__load_sym(self, fd, name);
-	close(fd);
-
-	/*
-	 * Some people seem to have debuginfo files _WITHOUT_ debug info!?!?
-	 */
-	if (!ret)
-		goto more;
-
-out:
-	free(name);
-	return ret;
-}
-
-static size_t dso__fprintf(struct dso *self, FILE *fp)
-{
-	size_t ret = fprintf(fp, "dso: %s\n", self->name);
-
-	struct rb_node *nd;
-	for (nd = rb_first(&self->syms); nd; nd = rb_next(nd)) {
-		struct symbol *pos = rb_entry(nd, struct symbol, rb_node);
-		ret += symbol__fprintf(pos, fp);
-	}
-
-	return ret;
-}
-
 static LIST_HEAD(dsos);
 static struct dso *kernel_dso;
 
@@ -418,153 +116,27 @@ static void dsos__fprintf(FILE *fp)
 		dso__fprintf(pos, fp);
 }
 
-static int hex(char ch)
-{
-	if ((ch >= '0') && (ch <= '9'))
-		return ch - '0';
-	if ((ch >= 'a') && (ch <= 'f'))
-		return ch - 'a' + 10;
-	if ((ch >= 'A') && (ch <= 'F'))
-		return ch - 'A' + 10;
-	return -1;
-}
-
-/*
- * While we find nice hex chars, build a long_val.
- * Return number of chars processed.
- */
-static int hex2long(char *ptr, unsigned long *long_val)
-{
-	const char *p = ptr;
-	*long_val = 0;
-
-	while (*p) {
-		const int hex_val = hex(*p);
-
-		if (hex_val < 0)
-			break;
-
-		*long_val = (*long_val << 4) | hex_val;
-		p++;
-	}
-
-	return p - ptr;
-}
-
-static int load_kallsyms(void)
-{
-	struct rb_node *nd, *prevnd;
-	char *line = NULL;
-	FILE *file;
-	size_t n;
-
-	kernel_dso = dso__new("[kernel]");
-	if (kernel_dso == NULL)
-		return -1;
-
-	file = fopen("/proc/kallsyms", "r");
-	if (file == NULL)
-		goto out_delete_dso;
-
-	while (!feof(file)) {
-		unsigned long start;
-		struct symbol *sym;
-		int line_len, len;
-		char symbol_type;
-
-		line_len = getline(&line, &n, file);
-		if (line_len < 0)
-			break;
-
-		if (!line)
-			goto out_delete_dso;
-
-		line[--line_len] = '\0'; /* \n */
-
-		len = hex2long(line, &start);
-
-		len++;
-		if (len + 2 >= line_len)
-			continue;
-
-		symbol_type = toupper(line[len]);
-		/*
-		 * We're interested only in code ('T'ext)
-		 */
-		if (symbol_type != 'T' && symbol_type != 'W')
-			continue;
-		/*
-		 * Well fix up the end later, when we have all sorted.
-		 */
-		sym = symbol__new(start, 0xdead, line + len + 2);
-
-		if (sym == NULL)
-			goto out_delete_dso;
-
-		dso__insert_symbol(kernel_dso, sym);
-	}
-
-	/*
-	 * Now that we have all sorted out, just set the ->end of all
-	 * symbols
-	 */
-	prevnd = rb_first(&kernel_dso->syms);
-
-	if (prevnd == NULL)
-		goto out_delete_line;
-
-	for (nd = rb_next(prevnd); nd; nd = rb_next(nd)) {
-		struct symbol *prev = rb_entry(prevnd, struct symbol, rb_node),
-			      *curr = rb_entry(nd, struct symbol, rb_node);
-
-		prev->end = curr->start - 1;
-		prevnd = nd;
-	}
-
-	dsos__add(kernel_dso);
-	free(line);
-	fclose(file);
-
-	return 0;
-
-out_delete_line:
-	free(line);
-out_delete_dso:
-	dso__delete(kernel_dso);
-	return -1;
-}
-
 static int load_kernel(void)
 {
-	int fd, nr;
-
-	if (!vmlinux)
-		goto kallsyms;
-
-	fd = open(vmlinux, O_RDONLY);
-	if (fd < 0)
-		goto kallsyms;
+	int err = -1;
 
 	kernel_dso = dso__new("[kernel]");
 	if (!kernel_dso)
-		goto fail_open;
-
-	nr = dso__load_sym(kernel_dso, fd, vmlinux);
+		return -1;
 
-	if (nr <= 0)
-		goto fail_load;
+	if (vmlinux)
+		err = dso__load_vmlinux(kernel_dso, vmlinux);
 
-	dsos__add(kernel_dso);
-	close(fd);
+	if (err)
+		err = dso__load_kallsyms(kernel_dso);
 
-	return 0;
+	if (err) {
+		dso__delete(kernel_dso);
+		kernel_dso = NULL;
+	} else
+		dsos__add(kernel_dso);
 
-fail_load:
-	dso__delete(kernel_dso);
-fail_open:
-	close(fd);
-kallsyms:
-	return load_kallsyms();
+	return err;
 }
 
 struct map {
@@ -1050,7 +622,7 @@ static int __cmd_report(void)
 	}
 
 	if (load_kernel() < 0) {
-		perror("failed to open kallsyms");
+		perror("failed to load kernel symbols");
 		return EXIT_FAILURE;
 	}
 
@@ -1247,7 +819,7 @@ static const struct option options[] = {
 
 int cmd_report(int argc, const char **argv, const char *prefix)
 {
-	elf_version(EV_CURRENT);
+	symbol__init();
 
 	page_size = getpagesize();
 
diff --git a/Documentation/perf_counter/util/symbol.c b/Documentation/perf_counter/util/symbol.c
new file mode 100644
index 0000000..d06de2c
--- /dev/null
+++ b/Documentation/perf_counter/util/symbol.c
@@ -0,0 +1,421 @@
+#include "util.h"
+#include "../perf.h"
+#include "symbol.h"
+
+#include <libelf.h>
+#include <gelf.h>
+#include <elf.h>
+
+static struct symbol *symbol__new(uint64_t start, uint64_t len,
+				  const char *name)
+{
+	struct symbol *self = malloc(sizeof(*self) + strlen(name) + 1);
+
+	if (self != NULL) {
+		self->start = start;
+		self->end   = start + len;
+		strcpy(self->name, name);
+	}
+
+	return self;
+}
+
+static void symbol__delete(struct symbol *self)
+{
+	free(self);
+}
+
+static size_t symbol__fprintf(struct symbol *self, FILE *fp)
+{
+	return fprintf(fp, " %llx-%llx %s\n",
+		       self->start, self->end, self->name);
+}
+
+struct dso *dso__new(const char *name)
+{
+	struct dso *self = malloc(sizeof(*self) + strlen(name) + 1);
+
+	if (self != NULL) {
+		strcpy(self->name, name);
+		self->syms = RB_ROOT;
+	}
+
+	return self;
+}
+
+static void dso__delete_symbols(struct dso *self)
+{
+	struct symbol *pos;
+	struct rb_node *next = rb_first(&self->syms);
+
+	while (next) {
+		pos = rb_entry(next, struct symbol, rb_node);
+		next = rb_next(&pos->rb_node);
+		symbol__delete(pos);
+	}
+}
+
+void dso__delete(struct dso *self)
+{
+	dso__delete_symbols(self);
+	free(self);
+}
+
+static void dso__insert_symbol(struct dso *self, struct symbol *sym)
+{
+	struct rb_node **p = &self->syms.rb_node;
+	struct rb_node *parent = NULL;
+	const uint64_t ip = sym->start;
+	struct symbol *s;
+
+	while (*p != NULL) {
+		parent = *p;
+		s = rb_entry(parent, struct symbol, rb_node);
+		if (ip < s->start)
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
+	}
+	rb_link_node(&sym->rb_node, parent, p);
+	rb_insert_color(&sym->rb_node, &self->syms);
+}
+
+struct symbol *dso__find_symbol(struct dso *self, uint64_t ip)
+{
+	struct rb_node *n;
+
+	if (self == NULL)
+		return NULL;
+
+	n = self->syms.rb_node;
+
+	while (n) {
+		struct symbol *s = rb_entry(n, struct symbol, rb_node);
+
+		if (ip < s->start)
+			n = n->rb_left;
+		else if (ip > s->end)
+			n = n->rb_right;
+		else
+			return s;
+	}
+
+	return NULL;
+}
+
+size_t dso__fprintf(struct dso *self, FILE *fp)
+{
+	size_t ret = fprintf(fp, "dso: %s\n", self->name);
+
+	struct rb_node *nd;
+	for (nd = rb_first(&self->syms); nd; nd = rb_next(nd)) {
+		struct symbol *pos = rb_entry(nd, struct symbol, rb_node);
+		ret += symbol__fprintf(pos, fp);
+	}
+
+	return ret;
+}
+
+static int hex(char ch)
+{
+	if ((ch >= '0') && (ch <= '9'))
+		return ch - '0';
+	if ((ch >= 'a') && (ch <= 'f'))
+		return ch - 'a' + 10;
+	if ((ch >= 'A') && (ch <= 'F'))
+		return ch - 'A' + 10;
+	return -1;
+}
+
+/*
+ * While we find nice hex chars, build a long_val.
+ * Return number of chars processed.
+ */
+static int hex2long(char *ptr, unsigned long *long_val)
+{
+	const char *p = ptr;
+	*long_val = 0;
+
+	while (*p) {
+		const int hex_val = hex(*p);
+
+		if (hex_val < 0)
+			break;
+
+		*long_val = (*long_val << 4) | hex_val;
+		p++;
+	}
+
+	return p - ptr;
+}
+
+int dso__load_kallsyms(struct dso *self)
+{
+	struct rb_node *nd, *prevnd;
+	char *line = NULL;
+	size_t n;
+	FILE *file = fopen("/proc/kallsyms", "r");
+
+	if (file == NULL)
+		goto out_failure;
+
+	while (!feof(file)) {
+		unsigned long start;
+		struct symbol *sym;
+		int line_len, len;
+		char symbol_type;
+
+		line_len = getline(&line, &n, file);
+		if (line_len < 0)
+			break;
+
+		if (!line)
+			goto out_failure;
+
+		line[--line_len] = '\0'; /* \n */
+
+		len = hex2long(line, &start);
+
+		len++;
+		if (len + 2 >= line_len)
+			continue;
+
+		symbol_type = toupper(line[len]);
+		/*
+		 * We're interested only in code ('T'ext)
+		 */
+		if (symbol_type != 'T' && symbol_type != 'W')
+			continue;
+		/*
+		 * Well fix up the end later, when we have all sorted.
+		 */
+		sym = symbol__new(start, 0xdead, line + len + 2);
+
+		if (sym == NULL)
+			goto out_delete_line;
+
+		dso__insert_symbol(self, sym);
+	}
+
+	/*
+	 * Now that we have all sorted out, just set the ->end of all
+	 * symbols
+	 */
+	prevnd = rb_first(&self->syms);
+
+	if (prevnd == NULL)
+		goto out_delete_line;
+
+	for (nd = rb_next(prevnd); nd; nd = rb_next(nd)) {
+		struct symbol *prev = rb_entry(prevnd, struct symbol, rb_node),
+			      *curr = rb_entry(nd, struct symbol, rb_node);
+
+		prev->end = curr->start - 1;
+		prevnd = nd;
+	}
+
+	free(line);
+	fclose(file);
+
+	return 0;
+
+out_delete_line:
+	free(line);
+out_failure:
+	return -1;
+}
+
+/**
+ * elf_symtab__for_each_symbol - iterate thru all the symbols
+ *
+ * @self: struct elf_symtab instance to iterate
+ * @index: uint32_t index
+ * @sym: GElf_Sym iterator
+ */
+#define elf_symtab__for_each_symbol(syms, nr_syms, index, sym) \
+	for (index = 0, gelf_getsym(syms, index, &sym);\
+	     index < nr_syms; \
+	     index++, gelf_getsym(syms, index, &sym))
+
+static inline uint8_t elf_sym__type(const GElf_Sym *sym)
+{
+	return GELF_ST_TYPE(sym->st_info);
+}
+
+static inline int elf_sym__is_function(const GElf_Sym *sym)
+{
+	return elf_sym__type(sym) == STT_FUNC &&
+	       sym->st_name != 0 &&
+	       sym->st_shndx != SHN_UNDEF &&
+	       sym->st_size != 0;
+}
+
+static inline const char *elf_sym__name(const GElf_Sym *sym,
+					const Elf_Data *symstrs)
+{
+	return symstrs->d_buf + sym->st_name;
+}
+
+static Elf_Scn *elf_section_by_name(Elf *elf, GElf_Ehdr *ep,
+				    GElf_Shdr *shp, const char *name,
+				    size_t *index)
+{
+	Elf_Scn *sec = NULL;
+	size_t cnt = 1;
+
+	while ((sec = elf_nextscn(elf, sec)) != NULL) {
+		char *str;
+
+		gelf_getshdr(sec, shp);
+		str = elf_strptr(elf, ep->e_shstrndx, shp->sh_name);
+		if (!strcmp(name, str)) {
+			if (index)
+				*index = cnt;
+			break;
+		}
+		++cnt;
+	}
+
+	return sec;
+}
+
+static int dso__load_sym(struct dso *self, int fd, const char *name)
+{
+	Elf_Data *symstrs;
+	uint32_t nr_syms;
+	int err = -1;
+	uint32_t index;
+	GElf_Ehdr ehdr;
+	GElf_Shdr shdr;
+	Elf_Data *syms;
+	GElf_Sym sym;
+	Elf_Scn *sec;
+	Elf *elf;
+	int nr = 0;
+
+	elf = elf_begin(fd, ELF_C_READ_MMAP, NULL);
+	if (elf == NULL) {
+		fprintf(stderr, "%s: cannot read %s ELF file.\n",
+			__func__, name);
+		goto out_close;
+	}
+
+	if (gelf_getehdr(elf, &ehdr) == NULL) {
+		fprintf(stderr, "%s: cannot get elf header.\n", __func__);
+		goto out_elf_end;
+	}
+
+	sec = elf_section_by_name(elf, &ehdr, &shdr, ".symtab", NULL);
+	if (sec == NULL)
+		sec = elf_section_by_name(elf, &ehdr, &shdr, ".dynsym", NULL);
+
+	if (sec == NULL)
+		goto out_elf_end;
+
+	syms = elf_getdata(sec, NULL);
+	if (syms == NULL)
+		goto out_elf_end;
+
+	sec = elf_getscn(elf, shdr.sh_link);
+	if (sec == NULL)
+		goto out_elf_end;
+
+	symstrs = elf_getdata(sec, NULL);
+	if (symstrs == NULL)
+		goto out_elf_end;
+
+	nr_syms = shdr.sh_size / shdr.sh_entsize;
+
+	elf_symtab__for_each_symbol(syms, nr_syms, index, sym) {
+		struct symbol *f;
+
+		if (!elf_sym__is_function(&sym))
+			continue;
+
+		sec = elf_getscn(elf, sym.st_shndx);
+		if (!sec)
+			goto out_elf_end;
+
+		gelf_getshdr(sec, &shdr);
+		sym.st_value -= shdr.sh_addr - shdr.sh_offset;
+
+		f = symbol__new(sym.st_value, sym.st_size,
+				elf_sym__name(&sym, symstrs));
+		if (!f)
+			goto out_elf_end;
+
+		dso__insert_symbol(self, f);
+
+		nr++;
+	}
+
+	err = nr;
+out_elf_end:
+	elf_end(elf);
+out_close:
+	return err;
+}
+
+int dso__load(struct dso *self)
+{
+	int size = strlen(self->name) + sizeof("/usr/lib/debug%s.debug");
+	char *name = malloc(size);
+	int variant = 0;
+	int ret = -1;
+	int fd;
+
+	if (!name)
+		return -1;
+
+more:
+	do {
+		switch (variant) {
+		case 0: /* Fedora */
+			snprintf(name, size, "/usr/lib/debug%s.debug", self->name);
+			break;
+		case 1: /* Ubuntu */
+			snprintf(name, size, "/usr/lib/debug%s", self->name);
+			break;
+		case 2: /* Sane people */
+			snprintf(name, size, "%s", self->name);
+			break;
+
+		default:
+			goto out;
+		}
+		variant++;
+
+		fd = open(name, O_RDONLY);
+	} while (fd < 0);
+
+	ret = dso__load_sym(self, fd, name);
+	close(fd);
+
+	/*
+	 * Some people seem to have debuginfo files _WITHOUT_ debug info!?!?
+	 */
+	if (!ret)
+		goto more;
+
+out:
+	free(name);
+	return ret;
+}
+
+int dso__load_vmlinux(struct dso *self, const char *vmlinux)
+{
+	int err, fd = open(vmlinux, O_RDONLY);
+
+	if (fd < 0)
+		return -1;
+
+	err = dso__load_sym(self, fd, vmlinux);
+	close(fd);
+
+	return err;
+}
+
+void symbol__init(void)
+{
+	elf_version(EV_CURRENT);
+}
diff --git a/Documentation/perf_counter/util/symbol.h b/Documentation/perf_counter/util/symbol.h
new file mode 100644
index 0000000..6dffe76
--- /dev/null
+++ b/Documentation/perf_counter/util/symbol.h
@@ -0,0 +1,33 @@
+#ifndef _PERF_SYMBOL_
+#define _PERF_SYMBOL_ 1
+
+#include <linux/types.h>
+#include "list.h"
+#include "rbtree.h"
+
+struct symbol {
+	struct rb_node	rb_node;
+	__u64		start;
+	__u64		end;
+	char		name[0];
+};
+
+struct dso {
+	struct list_head node;
+	struct rb_root	 syms;
+	char		 name[0];
+};
+
+struct dso *dso__new(const char *name);
+void dso__delete(struct dso *self);
+
+struct symbol *dso__find_symbol(struct dso *self, uint64_t ip);
+
+int dso__load_kallsyms(struct dso *self);
+int dso__load_vmlinux(struct dso *self, const char *vmlinux);
+int dso__load(struct dso *self);
+
+size_t dso__fprintf(struct dso *self, FILE *fp);
+
+void symbol__init(void);
+#endif /* _PERF_SYMBOL_ */
-- 
1.6.0.6

