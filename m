Return-Path: <linux-kernel-owner+w=401wt.eu-S1753434AbZGKPTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434AbZGKPTg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 11:19:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755340AbZGKPSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 11:18:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:51102 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbZGKPSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 11:18:42 -0400
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH tip 4/5] perf_counter tools: PLT info is stripped in -debuginfo packages
Date: Sat, 11 Jul 2009 12:18:36 -0300
Message-Id: <1247325517-12272-4-git-send-email-acme@redhat.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1247325517-12272-3-git-send-email-acme@redhat.com>
References: <1247325517-12272-1-git-send-email-acme@redhat.com>
 <1247325517-12272-2-git-send-email-acme@redhat.com>
 <1247325517-12272-3-git-send-email-acme@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So we need to get the richer .symtab from the debuginfo packages but the
PLT info from the original DSO where we have just the leaner .dynsym
symtab.

Example:

[acme@doppio pahole]$ perf report --sort comm,dso,symbol > before
[acme@doppio pahole]$ perf report --sort comm,dso,symbol > after
[acme@doppio pahole]$ diff -U1 before after
--- before	2009-07-11 11:04:22.688595741 -0300
+++ after	2009-07-11 11:04:33.380595676 -0300
@@ -80,3 +80,2 @@
      0.07%  pahole ./build/pahole              [.] pahole_stealer
-     0.06%  pahole /usr/lib64/libdw-0.141.so   [.] 0x00000000007140
      0.06%  pahole /usr/lib64/libdw-0.141.so   [.] __libdw_getabbrev
@@ -91,2 +90,3 @@
      0.06%  pahole [kernel]                    [k] free_hot_cold_page
+     0.06%  pahole /usr/lib64/libdw-0.141.so   [.] tfind@plt
      0.05%  pahole ./build/libdwarves.so.1.0.0 [.] ftype__add_parameter
@@ -242,2 +242,3 @@
      0.01%  pahole [kernel]                    [k] account_group_user_time
+     0.01%  pahole /usr/lib64/libdw-0.141.so   [.] strlen@plt
      0.01%  pahole ./build/pahole              [.] strcmp@plt
[acme@doppio pahole]$

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |  116 ++++++++++++++++++++++++++--------------------
 1 files changed, 65 insertions(+), 51 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 8efe7e4..f40266b 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -374,36 +374,61 @@ static Elf_Scn *elf_section_by_name(Elf *elf, GElf_Ehdr *ep,
 	     idx < nr_entries; \
 	     ++idx, pos = gelf_getrela(reldata, idx, &pos_mem))
 
-static int dso__synthesize_plt_symbols(struct  dso *self, Elf *elf,
-				       GElf_Ehdr *ehdr, Elf_Scn *scn_dynsym,
-				       GElf_Shdr *shdr_dynsym,
-				       size_t dynsym_idx, int verbose)
+/*
+ * We need to check if we have a .dynsym, so that we can handle the
+ * .plt, synthesizing its symbols, that aren't on the symtabs (be it
+ * .dynsym or .symtab).
+ * And always look at the original dso, not at debuginfo packages, that
+ * have the PLT data stripped out (shdr_rel_plt.sh_type == SHT_NOBITS).
+ */
+static int dso__synthesize_plt_symbols(struct  dso *self, int verbose)
 {
 	uint32_t nr_rel_entries, idx;
 	GElf_Sym sym;
 	u64 plt_offset;
 	GElf_Shdr shdr_plt;
 	struct symbol *f;
-	GElf_Shdr shdr_rel_plt;
+	GElf_Shdr shdr_rel_plt, shdr_dynsym;
 	Elf_Data *reldata, *syms, *symstrs;
-	Elf_Scn *scn_plt_rel, *scn_symstrs;
+	Elf_Scn *scn_plt_rel, *scn_symstrs, *scn_dynsym;
+	size_t dynsym_idx;
+	GElf_Ehdr ehdr;
 	char sympltname[1024];
-	int nr = 0, symidx;
+	Elf *elf;
+	int nr = 0, symidx, fd, err = 0;
+
+	fd = open(self->name, O_RDONLY);
+	if (fd < 0)
+		goto out;
+
+	elf = elf_begin(fd, ELF_C_READ_MMAP, NULL);
+	if (elf == NULL)
+		goto out_close;
+
+	if (gelf_getehdr(elf, &ehdr) == NULL)
+		goto out_elf_end;
+
+	scn_dynsym = elf_section_by_name(elf, &ehdr, &shdr_dynsym,
+					 ".dynsym", &dynsym_idx);
+	if (scn_dynsym == NULL)
+		goto out_elf_end;
 
-	scn_plt_rel = elf_section_by_name(elf, ehdr, &shdr_rel_plt,
+	scn_plt_rel = elf_section_by_name(elf, &ehdr, &shdr_rel_plt,
 					  ".rela.plt", NULL);
 	if (scn_plt_rel == NULL) {
-		scn_plt_rel = elf_section_by_name(elf, ehdr, &shdr_rel_plt,
+		scn_plt_rel = elf_section_by_name(elf, &ehdr, &shdr_rel_plt,
 						  ".rel.plt", NULL);
 		if (scn_plt_rel == NULL)
-			return 0;
+			goto out_elf_end;
 	}
 
+	err = -1;
+
 	if (shdr_rel_plt.sh_link != dynsym_idx)
-		return 0;
+		goto out_elf_end;
 
-	if (elf_section_by_name(elf, ehdr, &shdr_plt, ".plt", NULL) == NULL)
-		return 0;
+	if (elf_section_by_name(elf, &ehdr, &shdr_plt, ".plt", NULL) == NULL)
+		goto out_elf_end;
 
 	/*
 	 * Fetch the relocation section to find the indexes to the GOT
@@ -411,19 +436,19 @@ static int dso__synthesize_plt_symbols(struct  dso *self, Elf *elf,
 	 */
 	reldata = elf_getdata(scn_plt_rel, NULL);
 	if (reldata == NULL)
-		return -1;
+		goto out_elf_end;
 
 	syms = elf_getdata(scn_dynsym, NULL);
 	if (syms == NULL)
-		return -1;
+		goto out_elf_end;
 
-	scn_symstrs = elf_getscn(elf, shdr_dynsym->sh_link);
+	scn_symstrs = elf_getscn(elf, shdr_dynsym.sh_link);
 	if (scn_symstrs == NULL)
-		return -1;
+		goto out_elf_end;
 
 	symstrs = elf_getdata(scn_symstrs, NULL);
 	if (symstrs == NULL)
-		return -1;
+		goto out_elf_end;
 
 	nr_rel_entries = shdr_rel_plt.sh_size / shdr_rel_plt.sh_entsize;
 	plt_offset = shdr_plt.sh_offset;
@@ -442,7 +467,7 @@ static int dso__synthesize_plt_symbols(struct  dso *self, Elf *elf,
 			f = symbol__new(plt_offset, shdr_plt.sh_entsize,
 					sympltname, self->sym_priv_size, 0, verbose);
 			if (!f)
-				return -1;
+				goto out_elf_end;
 
 			dso__insert_symbol(self, f);
 			++nr;
@@ -460,19 +485,25 @@ static int dso__synthesize_plt_symbols(struct  dso *self, Elf *elf,
 			f = symbol__new(plt_offset, shdr_plt.sh_entsize,
 					sympltname, self->sym_priv_size, 0, verbose);
 			if (!f)
-				return -1;
+				goto out_elf_end;
 
 			dso__insert_symbol(self, f);
 			++nr;
 		}
-	} else {
-		/*
-		 * TODO: There are still one more shdr_rel_plt.sh_type
-		 * I have to investigate, but probably should be ignored.
-		 */
 	}
 
-	return nr;
+	err = 0;
+out_elf_end:
+	elf_end(elf);
+out_close:
+	close(fd);
+
+	if (err == 0)
+		return nr;
+out:
+	fprintf(stderr, "%s: problems reading %s PLT info.\n",
+		__func__, self->name);
+	return 0;
 }
 
 static int dso__load_sym(struct dso *self, int fd, const char *name,
@@ -486,9 +517,8 @@ static int dso__load_sym(struct dso *self, int fd, const char *name,
 	GElf_Shdr shdr;
 	Elf_Data *syms;
 	GElf_Sym sym;
-	Elf_Scn *sec, *sec_dynsym, *sec_strndx;
+	Elf_Scn *sec, *sec_strndx;
 	Elf *elf;
-	size_t dynsym_idx;
 	int nr = 0;
 
 	elf = elf_begin(fd, ELF_C_READ_MMAP, NULL);
@@ -505,32 +535,11 @@ static int dso__load_sym(struct dso *self, int fd, const char *name,
 		goto out_elf_end;
 	}
 
-	/*
-	 * We need to check if we have a .dynsym, so that we can handle the
-	 * .plt, synthesizing its symbols, that aren't on the symtabs (be it
-	 * .dynsym or .symtab)
-	 */
-	sec_dynsym = elf_section_by_name(elf, &ehdr, &shdr,
-					 ".dynsym", &dynsym_idx);
-	if (sec_dynsym != NULL) {
-		nr = dso__synthesize_plt_symbols(self, elf, &ehdr,
-						 sec_dynsym, &shdr,
-						 dynsym_idx, verbose);
-		if (nr < 0)
-			goto out_elf_end;
-	}
-
-	/*
-	 * But if we have a full .symtab (that is a superset of .dynsym) we
-	 * should add the symbols not in the .dynsyn
-	 */
 	sec = elf_section_by_name(elf, &ehdr, &shdr, ".symtab", NULL);
 	if (sec == NULL) {
-		if (sec_dynsym == NULL)
+		sec = elf_section_by_name(elf, &ehdr, &shdr, ".dynsym", NULL);
+		if (sec == NULL)
 			goto out_elf_end;
-
-		sec = sec_dynsym;
-		gelf_getshdr(sec, &shdr);
 	}
 
 	syms = elf_getdata(sec, NULL);
@@ -669,6 +678,11 @@ more:
 	if (!ret)
 		goto more;
 
+	if (ret > 0) {
+		int nr_plt = dso__synthesize_plt_symbols(self, verbose);
+		if (nr_plt > 0)
+			ret += nr_plt;
+	}
 out:
 	free(name);
 	return ret;
-- 
1.6.2.5

