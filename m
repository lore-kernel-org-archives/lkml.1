Return-Path: <linux-kernel-owner+w=401wt.eu-S934218AbZJGQtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934218AbZJGQtu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 12:49:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759567AbZJGQtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 12:49:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:41947 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759530AbZJGQts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 12:49:48 -0400
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>
Subject: [PATCH 1/1] perf tools: Improve kernel/modules symbol lookup
Date: Wed,  7 Oct 2009 13:48:56 -0300
Message-Id: <1254934136-8503-1-git-send-email-acme@redhat.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <y>
References: <y>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes the ovelapping of vmlinux addresses with modules, using the
ELF section name when using --vmlinux and creating a unique DSO name
when using /proc/kallsyms ([kernel].N).

This is done by creating multiple 'struct map' instances for address
ranges backed by DSOs that have just the symbols for that range and a
name that is derived from the ELF section name.o

Now it is possible to ask for just the symbols in some particular kernel
section:

$ perf report -m --vmlinux ../build/tip-recvmmsg/vmlinux \
	--dsos [kernel].vsyscall_fn | head -15
    52.73%             Xorg  [.] vread_hpet
    18.61%          firefox  [.] vread_hpet
    14.50%     npviewer.bin  [.] vread_hpet
     6.83%           compiz  [.] vread_hpet
     5.73%         glxgears  [.] vread_hpet
     0.63%             java  [.] vread_hpet
     0.30%   gnome-terminal  [.] vread_hpet
     0.23%             perf  [.] vread_hpet
     0.18%            xchat  [.] vread_hpet
$

Now we don't have to first lookup the list of modules and then, if it
fails, vmlinux symbols, its just a simple lookup for the map then the
symbols, just like for threads.

Reports generated using /proc/kallsyms and --vmlinux should provide the
same results, modulo the DSO name for sections other than ".text".

But they don't right now because things like:

 ffffffff81011c20-ffffffff81012068 system_call
 ffffffff81011c30-ffffffff81011c9b system_call_after_swapgs
 ffffffff81011c9c-ffffffff81011cb6 system_call_fastpath
 ffffffff81011cb7-ffffffff81011cbb ret_from_sys_call

I.e. overlapping symbols, again some ASM special case that we have to
fixup.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |  288 ++++++++++++++++++++++++++++++++--------------
 1 files changed, 201 insertions(+), 87 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index a6887f9..faa84f5 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -26,27 +26,35 @@ enum dso_origin {
 
 static void dsos__add(struct dso *dso);
 static struct dso *dsos__find(const char *name);
+static struct map *map__new2(u64 start, struct dso *dso);
+static void kernel_maps__insert(struct map *map);
 
 static struct rb_root kernel_maps;
 
-static void dso__set_symbols_end(struct dso *self)
+static void dso__fixup_sym_end(struct dso *self)
 {
 	struct rb_node *nd, *prevnd = rb_first(&self->syms);
+	struct symbol *curr, *prev;
 
 	if (prevnd == NULL)
 		return;
 
+	curr = rb_entry(prevnd, struct symbol, rb_node);
+
 	for (nd = rb_next(prevnd); nd; nd = rb_next(nd)) {
-		struct symbol *prev = rb_entry(prevnd, struct symbol, rb_node),
-			      *curr = rb_entry(nd, struct symbol, rb_node);
+		prev = curr;
+		curr = rb_entry(nd, struct symbol, rb_node);
 
 		if (prev->end == prev->start)
 			prev->end = curr->start - 1;
-		prevnd = nd;
 	}
+
+	/* Last entry */
+	if (curr->end == curr->start)
+		curr->end = roundup(curr->start, 4096);
 }
 
-static void kernel_maps__fixup_sym_end(void)
+static void kernel_maps__fixup_end(void)
 {
 	struct map *prev, *curr;
 	struct rb_node *nd, *prevnd = rb_first(&kernel_maps);
@@ -55,13 +63,17 @@ static void kernel_maps__fixup_sym_end(void)
 		return;
 
 	curr = rb_entry(prevnd, struct map, rb_node);
-	dso__set_symbols_end(curr->dso);
 
 	for (nd = rb_next(prevnd); nd; nd = rb_next(nd)) {
 		prev = curr;
 		curr = rb_entry(nd, struct map, rb_node);
 		prev->end = curr->start - 1;
-		dso__set_symbols_end(curr->dso);
+	}
+
+	nd = rb_last(&curr->dso->syms);
+	if (nd) {
+		struct symbol *sym = rb_entry(nd, struct symbol, rb_node);
+		curr->end = sym->end;
 	}
 }
 
@@ -200,13 +212,16 @@ size_t dso__fprintf(struct dso *self, FILE *fp)
 	return ret;
 }
 
-static int maps__load_kallsyms(symbol_filter_t filter, int use_modules, int v)
+/*
+ * Loads the function entries in /proc/kallsyms into kernel_map->dso,
+ * so that we can in the next step set the symbol ->end address and then
+ * call kernel_maps__split_kallsyms.
+ */
+static int kernel_maps__load_all_kallsyms(int v)
 {
-	struct map *map = kernel_map;
 	char *line = NULL;
 	size_t n;
 	FILE *file = fopen("/proc/kallsyms", "r");
-	int count = 0;
 
 	if (file == NULL)
 		goto out_failure;
@@ -216,7 +231,7 @@ static int maps__load_kallsyms(symbol_filter_t filter, int use_modules, int v)
 		struct symbol *sym;
 		int line_len, len;
 		char symbol_type;
-		char *module, *symbol_name;
+		char *symbol_name;
 
 		line_len = getline(&line, &n, file);
 		if (line_len < 0)
@@ -241,20 +256,55 @@ static int maps__load_kallsyms(symbol_filter_t filter, int use_modules, int v)
 			continue;
 
 		symbol_name = line + len + 2;
-		module = strchr(symbol_name, '\t');
-		if (module) {
-			char *module_name_end;
+		/*
+		 * Will fix up the end later, when we have all symbols sorted.
+		 */
+		sym = symbol__new(start, 0, symbol_name,
+				  kernel_map->dso->sym_priv_size, v);
 
+		if (sym == NULL)
+			goto out_delete_line;
+
+		dso__insert_symbol(kernel_map->dso, sym);
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
+/*
+ * Split the symbols into maps, making sure there are no overlaps, i.e. the
+ * kernel range is broken in several maps, named [kernel].N, as we don't have
+ * the original ELF section names vmlinux have.
+ */
+static int kernel_maps__split_kallsyms(symbol_filter_t filter, int use_modules)
+{
+	struct map *map = kernel_map;
+	struct symbol *pos;
+	int count = 0;
+	struct rb_node *next = rb_first(&kernel_map->dso->syms);
+	int kernel_range = 0;
+
+	while (next) {
+		char *module;
+
+		pos = rb_entry(next, struct symbol, rb_node);
+		next = rb_next(&pos->rb_node);
+
+		module = strchr(pos->name, '\t');
+		if (module) {
 			if (!use_modules)
-				continue;
-			*module = '\0';
-			module = strchr(module + 1, '[');
-			if (!module)
-				continue;
-			module_name_end = strchr(module + 1, ']');
-			if (!module_name_end)
-				continue;
-			*(module_name_end + 1) = '\0';
+				goto delete_symbol;
+
+			*module++ = '\0';
+
 			if (strcmp(map->dso->name, module)) {
 				map = kernel_maps__find_by_dso_name(module);
 				if (!map) {
@@ -263,50 +313,77 @@ static int maps__load_kallsyms(symbol_filter_t filter, int use_modules, int v)
 					return -1;
 				}
 			}
-			start = map->map_ip(map, start);
-		} else
-			map = kernel_map;
-		/*
-		 * Well fix up the end later, when we have all sorted.
-		 */
-		sym = symbol__new(start, 0, symbol_name,
-				  map->dso->sym_priv_size, v);
+			/*
+			 * So that we look just like we get from .ko files,
+			 * i.e. not prelinked, relative to map->start.
+			 */
+			pos->start = map->map_ip(map, pos->start);
+			pos->end   = map->map_ip(map, pos->end);
+		} else if (map != kernel_map) {
+			char dso_name[PATH_MAX];
+			struct dso *dso;
+
+			snprintf(dso_name, sizeof(dso_name), "[kernel].%d",
+				 kernel_range++);
+
+			dso = dso__new(dso_name,
+				       kernel_map->dso->sym_priv_size);
+			if (dso == NULL)
+				return -1;
+
+			map = map__new2(pos->start, dso);
+			if (map == NULL) {
+				dso__delete(dso);
+				return -1;
+			}
 
-		if (sym == NULL)
-			goto out_delete_line;
+			map->map_ip = vdso__map_ip;
+			kernel_maps__insert(map);
+			++kernel_range;
+		}
 
-		if (filter && filter(map, sym))
-			symbol__delete(sym, map->dso->sym_priv_size);
-		else {
-			dso__insert_symbol(map->dso, sym);
+		if (filter && filter(map, pos)) {
+delete_symbol:
+			rb_erase(&pos->rb_node, &kernel_map->dso->syms);
+			symbol__delete(pos, kernel_map->dso->sym_priv_size);
+		} else {
+			if (map != kernel_map) {
+				rb_erase(&pos->rb_node, &kernel_map->dso->syms);
+				dso__insert_symbol(map->dso, pos);
+			}
 			count++;
 		}
 	}
 
-	free(line);
-	fclose(file);
-
 	return count;
+}
 
-out_delete_line:
-	free(line);
-out_failure:
-	return -1;
+
+static int kernel_maps__load_kallsyms(symbol_filter_t filter,
+				      int use_modules, int v)
+{
+	if (kernel_maps__load_all_kallsyms(v))
+		return -1;
+
+	dso__fixup_sym_end(kernel_map->dso);
+
+	return kernel_maps__split_kallsyms(filter, use_modules);
 }
 
-static size_t kernel_maps__fprintf(FILE *fp)
+static size_t kernel_maps__fprintf(FILE *fp, int v)
 {
 	size_t printed = fprintf(stderr, "Kernel maps:\n");
 	struct rb_node *nd;
 
-	printed += map__fprintf(kernel_map, fp);
-	printed += dso__fprintf(kernel_map->dso, fp);
-
 	for (nd = rb_first(&kernel_maps); nd; nd = rb_next(nd)) {
 		struct map *pos = rb_entry(nd, struct map, rb_node);
 
+		printed += fprintf(fp, "Map:");
 		printed += map__fprintf(pos, fp);
-		printed += dso__fprintf(pos->dso, fp);
+		if (v > 1) {
+			printed += dso__fprintf(pos->dso, fp);
+			printed += fprintf(fp, "--\n");
+		}
 	}
 
 	return printed + fprintf(stderr, "END kernel maps\n");
@@ -594,6 +671,9 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
 			 int fd, symbol_filter_t filter, int kernel,
 			 int kmodule, int v)
 {
+	struct map *curr_map = map;
+	struct dso *curr_dso = self;
+	size_t dso_name_len = strlen(self->short_name);
 	Elf_Data *symstrs, *secstrs;
 	uint32_t nr_syms;
 	int err = -1;
@@ -660,10 +740,9 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
 	elf_symtab__for_each_symbol(syms, nr_syms, idx, sym) {
 		struct symbol *f;
 		const char *elf_name;
-		char *demangled;
+		char *demangled = NULL;
 		int is_label = elf_sym__is_label(&sym);
 		const char *section_name;
-		u64 sh_offset = 0;
 
 		if (!is_label && !elf_sym__is_function(&sym))
 			continue;
@@ -677,14 +756,51 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
 		if (is_label && !elf_sec__is_text(&shdr, secstrs))
 			continue;
 
+		elf_name = elf_sym__name(&sym, symstrs);
 		section_name = elf_sec__name(&shdr, secstrs);
 
-		if ((kernel || kmodule)) {
-			if (strstr(section_name, ".init"))
-				sh_offset = shdr.sh_offset;
+		if (kernel || kmodule) {
+			char dso_name[PATH_MAX];
+
+			if (strcmp(section_name,
+				   curr_dso->short_name + dso_name_len) == 0)
+				goto new_symbol;
+
+			if (strcmp(section_name, ".text") == 0) {
+				curr_map = map;
+				curr_dso = self;
+				goto new_symbol;
+			}
+
+			snprintf(dso_name, sizeof(dso_name),
+				 "%s%s", self->short_name, section_name);
+
+			curr_map = kernel_maps__find_by_dso_name(dso_name);
+			if (curr_map == NULL) {
+				u64 start = sym.st_value;
+
+				if (kmodule)
+					start += map->start + shdr.sh_offset;
+
+				curr_dso = dso__new(dso_name, self->sym_priv_size);
+				if (curr_dso == NULL)
+					goto out_elf_end;
+				curr_map = map__new2(start, curr_dso);
+				if (curr_map == NULL) {
+					dso__delete(curr_dso);
+					goto out_elf_end;
+				}
+				curr_map->map_ip = vdso__map_ip;
+				curr_dso->origin = DSO__ORIG_KERNEL;
+				kernel_maps__insert(curr_map);
+				dsos__add(curr_dso);
+			} else
+				curr_dso = curr_map->dso;
+
+			goto new_symbol;
 		}
 
-		if (self->adjust_symbols) {
+		if (curr_dso->adjust_symbols) {
 			if (v > 2)
 				printf("adjusting symbol: st_value: %Lx sh_addr: %Lx sh_offset: %Lx\n",
 					(u64)sym.st_value, (u64)shdr.sh_addr, (u64)shdr.sh_offset);
@@ -696,25 +812,29 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
 		 * DWARF DW_compile_unit has this, but we don't always have access
 		 * to it...
 		 */
-		elf_name = elf_sym__name(&sym, symstrs);
 		demangled = bfd_demangle(NULL, elf_name, DMGL_PARAMS | DMGL_ANSI);
 		if (demangled != NULL)
 			elf_name = demangled;
-
-		f = symbol__new(sym.st_value + sh_offset, sym.st_size, elf_name,
-				self->sym_priv_size, v);
+new_symbol:
+		f = symbol__new(sym.st_value, sym.st_size, elf_name,
+				curr_dso->sym_priv_size, v);
 		free(demangled);
 		if (!f)
 			goto out_elf_end;
 
-		if (filter && filter(map, f))
-			symbol__delete(f, self->sym_priv_size);
+		if (filter && filter(curr_map, f))
+			symbol__delete(f, curr_dso->sym_priv_size);
 		else {
-			dso__insert_symbol(self, f);
+			dso__insert_symbol(curr_dso, f);
 			nr++;
 		}
 	}
 
+	/*
+	 * For misannotated, zeroed, ASM function sizes.
+	 */
+	if (nr > 0)
+		dso__fixup_sym_end(self);
 	err = nr;
 out_elf_end:
 	elf_end(elf);
@@ -883,27 +1003,17 @@ static void kernel_maps__insert(struct map *map)
 
 struct symbol *kernel_maps__find_symbol(u64 ip, struct map **mapp)
 {
-	/*
-	 * We can't have kernel_map in kernel_maps because it spans an address
-	 * space that includes the modules. The right way to fix this is to
-	 * create several maps, so that we don't have overlapping ranges with
-	 * modules. For now lets look first on the kernel dso.
-	 */
 	struct map *map = maps__find(&kernel_maps, ip);
-	struct symbol *sym;
+
+	if (mapp)
+		*mapp = map;
 
 	if (map) {
 		ip = map->map_ip(map, ip);
-		sym = map->dso->find_symbol(map->dso, ip);
-	} else {
-		map = kernel_map;
-		sym = map->dso->find_symbol(map->dso, ip);
+		return map->dso->find_symbol(map->dso, ip);
 	}
 
-	if (mapp)
-		*mapp = map;
-
-	return sym;
+	return NULL;
 }
 
 struct map *kernel_maps__find_by_dso_name(const char *name)
@@ -994,6 +1104,14 @@ static int dsos__load_modules_sym_dir(char *dirname,
 			last = rb_last(&map->dso->syms);
 			if (last) {
 				struct symbol *sym;
+				/*
+				 * We do this here as well, even having the
+				 * symbol size found in the symtab because
+				 * misannotated ASM symbols may have the size
+				 * set to zero.
+				 */
+				dso__fixup_sym_end(map->dso);
+
 				sym = rb_entry(last, struct symbol, rb_node);
 				map->end = map->start + sym->end;
 			}
@@ -1163,17 +1281,11 @@ int dsos__load_kernel(const char *vmlinux, unsigned int sym_priv_size,
 	}
 
 	if (err <= 0)
-		err = maps__load_kallsyms(filter, use_modules, v);
+		err = kernel_maps__load_kallsyms(filter, use_modules, v);
 
 	if (err > 0) {
 		struct rb_node *node = rb_first(&dso->syms);
 		struct symbol *sym = rb_entry(node, struct symbol, rb_node);
-		/*
-		 * Now that we have all sorted out, just set the ->end of all
-		 * symbols that still don't have it.
-		 */
-		dso__set_symbols_end(dso);
-		kernel_maps__fixup_sym_end();
 
 		kernel_map->start = sym->start;
 		node = rb_last(&dso->syms);
@@ -1181,14 +1293,16 @@ int dsos__load_kernel(const char *vmlinux, unsigned int sym_priv_size,
 		kernel_map->end = sym->end;
 
 		dso->origin = DSO__ORIG_KERNEL;
+		kernel_maps__insert(kernel_map);
 		/*
-		 * XXX See kernel_maps__find_symbol comment
-		 * kernel_maps__insert(kernel_map)
+		 * Now that we have all sorted out, just set the ->end of all
+		 * maps:
 		 */
+		kernel_maps__fixup_end();
 		dsos__add(dso);
 
 		if (v > 0)
-			kernel_maps__fprintf(stderr);
+			kernel_maps__fprintf(stderr, v);
 	}
 
 	return err;
-- 
1.6.2.5

