Return-Path: <linux-kernel-owner+w=401wt.eu-S1756642AbZFCIrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642AbZFCIrX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 04:47:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756453AbZFCIq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 04:46:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:44945 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756536AbZFCIqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 04:46:55 -0400
Date: Wed, 3 Jun 2009 08:46:21 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, eranian@googlemail.com,
       jkacur@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, eranian@googlemail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, mtosatti@redhat.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter tools: Cover PLT symbols too
Message-ID: <tip-8ce998d6693bd02ab3b74ee1cc303ecb1fa9b514@git.kernel.org>
Git-Commit-ID: 8ce998d6693bd02ab3b74ee1cc303ecb1fa9b514
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 03 Jun 2009 08:46:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8ce998d6693bd02ab3b74ee1cc303ecb1fa9b514
Gitweb:     http://git.kernel.org/tip/8ce998d6693bd02ab3b74ee1cc303ecb1fa9b514
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 3 Jun 2009 00:54:33 -0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 3 Jun 2009 09:58:52 +0200

perf_counter tools: Cover PLT symbols too

PLT, the Program Linking Table, is used with the dynamic linker to
allow PIC code in executables and shared objects to figure out
where functions are in other shared objects.

It is one of the sources of unknown/unresolved symbols - this patch
does what binutils figures out when you ask it to disassembly.
(objdump -S)

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
Cc: Stephane Eranian <eranian@googlemail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/util/symbol.c |  143 ++++++++++++++++++++++++++++-
 1 files changed, 138 insertions(+), 5 deletions(-)

diff --git a/Documentation/perf_counter/util/symbol.c b/Documentation/perf_counter/util/symbol.c
index 039931f..d52a1ae 100644
--- a/Documentation/perf_counter/util/symbol.c
+++ b/Documentation/perf_counter/util/symbol.c
@@ -258,6 +258,117 @@ static Elf_Scn *elf_section_by_name(Elf *elf, GElf_Ehdr *ep,
 	return sec;
 }
 
+#define elf_section__for_each_rel(reldata, pos, pos_mem, idx, nr_entries) \
+	for (idx = 0, pos = gelf_getrel(reldata, 0, &pos_mem); \
+	     idx < nr_entries; \
+	     ++idx, pos = gelf_getrel(reldata, idx, &pos_mem))
+
+#define elf_section__for_each_rela(reldata, pos, pos_mem, idx, nr_entries) \
+	for (idx = 0, pos = gelf_getrela(reldata, 0, &pos_mem); \
+	     idx < nr_entries; \
+	     ++idx, pos = gelf_getrela(reldata, idx, &pos_mem))
+
+static int dso__synthesize_plt_symbols(struct  dso *self, Elf *elf,
+				       GElf_Ehdr *ehdr, Elf_Scn *scn_dynsym,
+				       GElf_Shdr *shdr_dynsym,
+				       size_t dynsym_idx)
+{
+	uint32_t nr_rel_entries, idx;
+	GElf_Sym sym;
+	__u64 plt_offset;
+	GElf_Shdr shdr_plt;
+	struct symbol *f;
+	GElf_Shdr shdr_rel_plt;
+	Elf_Data *reldata, *syms, *symstrs;
+	Elf_Scn *scn_plt_rel, *scn_symstrs;
+	char sympltname[1024];
+	int nr = 0, symidx;
+
+	scn_plt_rel = elf_section_by_name(elf, ehdr, &shdr_rel_plt,
+					  ".rela.plt", NULL);
+	if (scn_plt_rel == NULL) {
+		scn_plt_rel = elf_section_by_name(elf, ehdr, &shdr_rel_plt,
+						  ".rel.plt", NULL);
+		if (scn_plt_rel == NULL)
+			return 0;
+	}
+
+	if (shdr_rel_plt.sh_link != dynsym_idx)
+		return 0;
+
+	if (elf_section_by_name(elf, ehdr, &shdr_plt, ".plt", NULL) == NULL)
+		return 0;
+
+	/*
+	 * Fetch the relocation section to find the indexes to the GOT
+	 * and the symbols in the .dynsym they refer to.
+	 */
+	reldata = elf_getdata(scn_plt_rel, NULL);
+	if (reldata == NULL)
+		return -1;
+
+	syms = elf_getdata(scn_dynsym, NULL);
+	if (syms == NULL)
+		return -1;
+
+	scn_symstrs = elf_getscn(elf, shdr_dynsym->sh_link);
+	if (scn_symstrs == NULL)
+		return -1;
+
+	symstrs = elf_getdata(scn_symstrs, NULL);
+	if (symstrs == NULL)
+		return -1;
+
+	nr_rel_entries = shdr_rel_plt.sh_size / shdr_rel_plt.sh_entsize;
+	plt_offset = shdr_plt.sh_offset;
+
+	if (shdr_rel_plt.sh_type == SHT_RELA) {
+		GElf_Rela pos_mem, *pos;
+
+		elf_section__for_each_rela(reldata, pos, pos_mem, idx,
+					   nr_rel_entries) {
+			symidx = GELF_R_SYM(pos->r_info);
+			plt_offset += shdr_plt.sh_entsize;
+			gelf_getsym(syms, symidx, &sym);
+			snprintf(sympltname, sizeof(sympltname),
+				 "%s@plt", elf_sym__name(&sym, symstrs));
+
+			f = symbol__new(plt_offset, shdr_plt.sh_entsize,
+					sympltname, self->sym_priv_size);
+			if (!f)
+				return -1;
+
+			dso__insert_symbol(self, f);
+			++nr;
+		}
+	} else if (shdr_rel_plt.sh_type == SHT_REL) {
+		GElf_Rel pos_mem, *pos;
+		elf_section__for_each_rel(reldata, pos, pos_mem, idx,
+					  nr_rel_entries) {
+			symidx = GELF_R_SYM(pos->r_info);
+			plt_offset += shdr_plt.sh_entsize;
+			gelf_getsym(syms, symidx, &sym);
+			snprintf(sympltname, sizeof(sympltname),
+				 "%s@plt", elf_sym__name(&sym, symstrs));
+
+			f = symbol__new(plt_offset, shdr_plt.sh_entsize,
+					sympltname, self->sym_priv_size);
+			if (!f)
+				return -1;
+
+			dso__insert_symbol(self, f);
+			++nr;
+		}
+	} else {
+		/*
+		 * TODO: There are still one more shdr_rel_plt.sh_type
+		 * I have to investigate, but probably should be ignored.
+		 */
+	}
+
+	return nr;
+}
+
 static int dso__load_sym(struct dso *self, int fd, const char *name,
 			 symbol_filter_t filter)
 {
@@ -269,8 +380,9 @@ static int dso__load_sym(struct dso *self, int fd, const char *name,
 	GElf_Shdr shdr;
 	Elf_Data *syms;
 	GElf_Sym sym;
-	Elf_Scn *sec;
+	Elf_Scn *sec, *sec_dynsym;
 	Elf *elf;
+	size_t dynsym_idx;
 	int nr = 0;
 
 	elf = elf_begin(fd, ELF_C_READ_MMAP, NULL);
@@ -285,12 +397,33 @@ static int dso__load_sym(struct dso *self, int fd, const char *name,
 		goto out_elf_end;
 	}
 
+	/*
+	 * We need to check if we have a .dynsym, so that we can handle the
+	 * .plt, synthesizing its symbols, that aren't on the symtabs (be it
+	 * .dynsym or .symtab)
+	 */
+	sec_dynsym = elf_section_by_name(elf, &ehdr, &shdr,
+					 ".dynsym", &dynsym_idx);
+	if (sec_dynsym != NULL) {
+		nr = dso__synthesize_plt_symbols(self, elf, &ehdr,
+						 sec_dynsym, &shdr,
+						 dynsym_idx);
+		if (nr < 0)
+			goto out_elf_end;
+	}
+
+	/*
+	 * But if we have a full .symtab (that is a superset of .dynsym) we
+	 * should add the symbols not in the .dynsyn
+	 */
 	sec = elf_section_by_name(elf, &ehdr, &shdr, ".symtab", NULL);
-	if (sec == NULL)
-		sec = elf_section_by_name(elf, &ehdr, &shdr, ".dynsym", NULL);
+	if (sec == NULL) {
+		if (sec_dynsym == NULL)
+			goto out_elf_end;
 
-	if (sec == NULL)
-		goto out_elf_end;
+		sec = sec_dynsym;
+		gelf_getshdr(sec, &shdr);
+	}
 
 	syms = elf_getdata(sec, NULL);
 	if (syms == NULL)
