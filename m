Return-Path: <linux-kernel-owner+w=401wt.eu-S933145AbYF3V4E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933145AbYF3V4E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 17:56:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934226AbYF3Vym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 17:54:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33121 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933521AbYF3Vyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 17:54:39 -0400
Message-ID: <48695449.5010602@zytor.com>
Date: Mon, 30 Jun 2008 14:46:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Ingo Molnar <mingo@elte.hu>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       Andy Whitcroft <apw@shadowen.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, Vivek Goyal <vgoyal@in.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [BUILD-FAILURE] linux-next: Tree for June 30
References: <20080701001656.e156585c.sfr@canb.auug.org.au> <48690385.7030500@linux.vnet.ibm.com> <48690D3C.1060803@linux.vnet.ibm.com> <20080630185943.GA24692@uranus.ravnborg.org> <20080630192610.GA6584@elte.hu> <20080630194727.GA26682@uranus.ravnborg.org> <20080630200623.GE6584@elte.hu> <20080630202506.GA28050@uranus.ravnborg.org> <486943F1.80606@zytor.com>
In-Reply-To: <486943F1.80606@zytor.com>
Content-Type: multipart/mixed;
 boundary="------------010809090001050403080104"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010809090001050403080104
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Here is a patch to replace the hard-coded limit with dynamic allocation. 
  I have only build-tested it, but it seems to work.

Please try it out; barring any screams to the contrary I'll add it to -tip.

	-hpa


--------------010809090001050403080104
Content-Type: text/x-patch;
 name="0001-x86-remove-arbitrary-ELF-section-limit-in-32-bit-re.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-x86-remove-arbitrary-ELF-section-limit-in-32-bit-re.pat";
 filename*1="ch"

>From 3ba7b5c55e7f62b56c4d355c0619c92c739f0d81 Mon Sep 17 00:00:00 2001
From: H. Peter Anvin <hpa@zytor.com>
Date: Mon, 30 Jun 2008 14:42:18 -0700
Subject: [PATCH] x86: remove arbitrary ELF section limit in 32-bit relocatable kernel

Impact: build failure in maximal configurations

The 32-bit x86 relocatable kernel requires an auxilliary host program
to process the relocations.  This program had a hard-coded arbitrary
limit of a 100 ELF sections.  Instead of a hard-coded limit, allocate
the structures dynamically.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/boot/compressed/relocs.c |  198 ++++++++++++++++++++----------------
 1 files changed, 110 insertions(+), 88 deletions(-)

diff --git a/arch/x86/boot/compressed/relocs.c b/arch/x86/boot/compressed/relocs.c
index edaadea..a1310c5 100644
--- a/arch/x86/boot/compressed/relocs.c
+++ b/arch/x86/boot/compressed/relocs.c
@@ -10,16 +10,20 @@
 #define USE_BSD
 #include <endian.h>
 
-#define MAX_SHDRS 100
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
 static Elf32_Ehdr ehdr;
-static Elf32_Shdr shdr[MAX_SHDRS];
-static Elf32_Sym  *symtab[MAX_SHDRS];
-static Elf32_Rel  *reltab[MAX_SHDRS];
-static char *strtab[MAX_SHDRS];
 static unsigned long reloc_count, reloc_idx;
 static unsigned long *relocs;
 
+struct section {
+	Elf32_Shdr     shdr;
+	struct section *link;
+	Elf32_Sym      *symtab;
+	Elf32_Rel      *reltab;
+	char           *strtab;
+};
+static struct section *secs;
+
 /*
  * Following symbols have been audited. There values are constant and do
  * not change if bzImage is loaded at a different physical address than
@@ -35,7 +39,7 @@ static int is_safe_abs_reloc(const char* sym_name)
 {
 	int i;
 
-	for(i = 0; i < ARRAY_SIZE(safe_abs_relocs); i++) {
+	for (i = 0; i < ARRAY_SIZE(safe_abs_relocs); i++) {
 		if (!strcmp(sym_name, safe_abs_relocs[i]))
 			/* Match found */
 			return 1;
@@ -137,10 +141,10 @@ static const char *sec_name(unsigned shndx)
 {
 	const char *sec_strtab;
 	const char *name;
-	sec_strtab = strtab[ehdr.e_shstrndx];
+	sec_strtab = secs[ehdr.e_shstrndx].strtab;
 	name = "<noname>";
 	if (shndx < ehdr.e_shnum) {
-		name = sec_strtab + shdr[shndx].sh_name;
+		name = sec_strtab + secs[shndx].shdr.sh_name;
 	}
 	else if (shndx == SHN_ABS) {
 		name = "ABSOLUTE";
@@ -159,7 +163,7 @@ static const char *sym_name(const char *sym_strtab, Elf32_Sym *sym)
 		name = sym_strtab + sym->st_name;
 	}
 	else {
-		name = sec_name(shdr[sym->st_shndx].sh_name);
+		name = sec_name(secs[sym->st_shndx].shdr.sh_name);
 	}
 	return name;
 }
@@ -244,29 +248,34 @@ static void read_ehdr(FILE *fp)
 static void read_shdrs(FILE *fp)
 {
 	int i;
-	if (ehdr.e_shnum > MAX_SHDRS) {
-		die("%d section headers supported: %d\n",
-			ehdr.e_shnum, MAX_SHDRS);
+	Elf32_Shdr shdr;
+
+	secs = calloc(ehdr.e_shnum, sizeof(struct section));
+	if (!secs) {
+		die("Unable to allocate %d section headers\n",
+		    ehdr.e_shnum);
 	}
 	if (fseek(fp, ehdr.e_shoff, SEEK_SET) < 0) {
 		die("Seek to %d failed: %s\n",
 			ehdr.e_shoff, strerror(errno));
 	}
-	if (fread(&shdr, sizeof(shdr[0]), ehdr.e_shnum, fp) != ehdr.e_shnum) {
-		die("Cannot read ELF section headers: %s\n",
-			strerror(errno));
-	}
-	for(i = 0; i < ehdr.e_shnum; i++) {
-		shdr[i].sh_name      = elf32_to_cpu(shdr[i].sh_name);
-		shdr[i].sh_type      = elf32_to_cpu(shdr[i].sh_type);
-		shdr[i].sh_flags     = elf32_to_cpu(shdr[i].sh_flags);
-		shdr[i].sh_addr      = elf32_to_cpu(shdr[i].sh_addr);
-		shdr[i].sh_offset    = elf32_to_cpu(shdr[i].sh_offset);
-		shdr[i].sh_size      = elf32_to_cpu(shdr[i].sh_size);
-		shdr[i].sh_link      = elf32_to_cpu(shdr[i].sh_link);
-		shdr[i].sh_info      = elf32_to_cpu(shdr[i].sh_info);
-		shdr[i].sh_addralign = elf32_to_cpu(shdr[i].sh_addralign);
-		shdr[i].sh_entsize   = elf32_to_cpu(shdr[i].sh_entsize);
+	for (i = 0; i < ehdr.e_shnum; i++) {
+		struct section *sec = &secs[i];
+		if (fread(&shdr, sizeof shdr, 1, fp) != 1)
+			die("Cannot read ELF section headers %d/%d: %s\n",
+			    i, ehdr.e_shnum, strerror(errno));
+		sec->shdr.sh_name      = elf32_to_cpu(shdr.sh_name);
+		sec->shdr.sh_type      = elf32_to_cpu(shdr.sh_type);
+		sec->shdr.sh_flags     = elf32_to_cpu(shdr.sh_flags);
+		sec->shdr.sh_addr      = elf32_to_cpu(shdr.sh_addr);
+		sec->shdr.sh_offset    = elf32_to_cpu(shdr.sh_offset);
+		sec->shdr.sh_size      = elf32_to_cpu(shdr.sh_size);
+		sec->shdr.sh_link      = elf32_to_cpu(shdr.sh_link);
+		sec->shdr.sh_info      = elf32_to_cpu(shdr.sh_info);
+		sec->shdr.sh_addralign = elf32_to_cpu(shdr.sh_addralign);
+		sec->shdr.sh_entsize   = elf32_to_cpu(shdr.sh_entsize);
+		if (sec->shdr.sh_link < ehdr.e_shnum)
+			sec->link = &secs[sec->shdr.sh_link];
 	}
 
 }
@@ -274,20 +283,22 @@ static void read_shdrs(FILE *fp)
 static void read_strtabs(FILE *fp)
 {
 	int i;
-	for(i = 0; i < ehdr.e_shnum; i++) {
-		if (shdr[i].sh_type != SHT_STRTAB) {
+	for (i = 0; i < ehdr.e_shnum; i++) {
+		struct section *sec = &secs[i];
+		if (sec->shdr.sh_type != SHT_STRTAB) {
 			continue;
 		}
-		strtab[i] = malloc(shdr[i].sh_size);
-		if (!strtab[i]) {
+		sec->strtab = malloc(sec->shdr.sh_size);
+		if (!sec->strtab) {
 			die("malloc of %d bytes for strtab failed\n",
-				shdr[i].sh_size);
+				sec->shdr.sh_size);
 		}
-		if (fseek(fp, shdr[i].sh_offset, SEEK_SET) < 0) {
+		if (fseek(fp, sec->shdr.sh_offset, SEEK_SET) < 0) {
 			die("Seek to %d failed: %s\n",
-				shdr[i].sh_offset, strerror(errno));
+				sec->shdr.sh_offset, strerror(errno));
 		}
-		if (fread(strtab[i], 1, shdr[i].sh_size, fp) != shdr[i].sh_size) {
+		if (fread(sec->strtab, 1, sec->shdr.sh_size, fp)
+		    != sec->shdr.sh_size) {
 			die("Cannot read symbol table: %s\n",
 				strerror(errno));
 		}
@@ -297,28 +308,31 @@ static void read_strtabs(FILE *fp)
 static void read_symtabs(FILE *fp)
 {
 	int i,j;
-	for(i = 0; i < ehdr.e_shnum; i++) {
-		if (shdr[i].sh_type != SHT_SYMTAB) {
+	for (i = 0; i < ehdr.e_shnum; i++) {
+		struct section *sec = &secs[i];
+		if (sec->shdr.sh_type != SHT_SYMTAB) {
 			continue;
 		}
-		symtab[i] = malloc(shdr[i].sh_size);
-		if (!symtab[i]) {
+		sec->symtab = malloc(sec->shdr.sh_size);
+		if (!sec->symtab) {
 			die("malloc of %d bytes for symtab failed\n",
-				shdr[i].sh_size);
+				sec->shdr.sh_size);
 		}
-		if (fseek(fp, shdr[i].sh_offset, SEEK_SET) < 0) {
+		if (fseek(fp, sec->shdr.sh_offset, SEEK_SET) < 0) {
 			die("Seek to %d failed: %s\n",
-				shdr[i].sh_offset, strerror(errno));
+				sec->shdr.sh_offset, strerror(errno));
 		}
-		if (fread(symtab[i], 1, shdr[i].sh_size, fp) != shdr[i].sh_size) {
+		if (fread(sec->symtab, 1, sec->shdr.sh_size, fp)
+		    != sec->shdr.sh_size) {
 			die("Cannot read symbol table: %s\n",
 				strerror(errno));
 		}
-		for(j = 0; j < shdr[i].sh_size/sizeof(symtab[i][0]); j++) {
-			symtab[i][j].st_name  = elf32_to_cpu(symtab[i][j].st_name);
-			symtab[i][j].st_value = elf32_to_cpu(symtab[i][j].st_value);
-			symtab[i][j].st_size  = elf32_to_cpu(symtab[i][j].st_size);
-			symtab[i][j].st_shndx = elf16_to_cpu(symtab[i][j].st_shndx);
+		for (j = 0; j < sec->shdr.sh_size/sizeof(Elf32_Sym); j++) {
+			Elf32_Sym *sym = &sec->symtab[j];
+			sym->st_name  = elf32_to_cpu(sym->st_name);
+			sym->st_value = elf32_to_cpu(sym->st_value);
+			sym->st_size  = elf32_to_cpu(sym->st_size);
+			sym->st_shndx = elf16_to_cpu(sym->st_shndx);
 		}
 	}
 }
@@ -327,26 +341,29 @@ static void read_symtabs(FILE *fp)
 static void read_relocs(FILE *fp)
 {
 	int i,j;
-	for(i = 0; i < ehdr.e_shnum; i++) {
-		if (shdr[i].sh_type != SHT_REL) {
+	for (i = 0; i < ehdr.e_shnum; i++) {
+		struct section *sec = &secs[i];
+		if (sec->shdr.sh_type != SHT_REL) {
 			continue;
 		}
-		reltab[i] = malloc(shdr[i].sh_size);
-		if (!reltab[i]) {
+		sec->reltab = malloc(sec->shdr.sh_size);
+		if (!sec->reltab) {
 			die("malloc of %d bytes for relocs failed\n",
-				shdr[i].sh_size);
+				sec->shdr.sh_size);
 		}
-		if (fseek(fp, shdr[i].sh_offset, SEEK_SET) < 0) {
+		if (fseek(fp, sec->shdr.sh_offset, SEEK_SET) < 0) {
 			die("Seek to %d failed: %s\n",
-				shdr[i].sh_offset, strerror(errno));
+				sec->shdr.sh_offset, strerror(errno));
 		}
-		if (fread(reltab[i], 1, shdr[i].sh_size, fp) != shdr[i].sh_size) {
+		if (fread(sec->reltab, 1, sec->shdr.sh_size, fp)
+		    != sec->shdr.sh_size) {
 			die("Cannot read symbol table: %s\n",
 				strerror(errno));
 		}
-		for(j = 0; j < shdr[i].sh_size/sizeof(reltab[0][0]); j++) {
-			reltab[i][j].r_offset = elf32_to_cpu(reltab[i][j].r_offset);
-			reltab[i][j].r_info   = elf32_to_cpu(reltab[i][j].r_info);
+		for (j = 0; j < sec->shdr.sh_size/sizeof(Elf32_Rel); j++) {
+			Elf32_Rel *rel = &sec->reltab[j];
+			rel->r_offset = elf32_to_cpu(rel->r_offset);
+			rel->r_info   = elf32_to_cpu(rel->r_info);
 		}
 	}
 }
@@ -357,19 +374,21 @@ static void print_absolute_symbols(void)
 	int i;
 	printf("Absolute symbols\n");
 	printf(" Num:    Value Size  Type       Bind        Visibility  Name\n");
-	for(i = 0; i < ehdr.e_shnum; i++) {
+	for (i = 0; i < ehdr.e_shnum; i++) {
+		struct section *sec = &secs[i];
 		char *sym_strtab;
 		Elf32_Sym *sh_symtab;
 		int j;
-		if (shdr[i].sh_type != SHT_SYMTAB) {
+
+		if (sec->shdr.sh_type != SHT_SYMTAB) {
 			continue;
 		}
-		sh_symtab = symtab[i];
-		sym_strtab = strtab[shdr[i].sh_link];
-		for(j = 0; j < shdr[i].sh_size/sizeof(symtab[0][0]); j++) {
+		sh_symtab = sec->symtab;
+		sym_strtab = sec->link->strtab;
+		for (j = 0; j < sec->shdr.sh_size/sizeof(Elf32_Sym); j++) {
 			Elf32_Sym *sym;
 			const char *name;
-			sym = &symtab[i][j];
+			sym = &sec->symtab[j];
 			name = sym_name(sym_strtab, sym);
 			if (sym->st_shndx != SHN_ABS) {
 				continue;
@@ -389,26 +408,27 @@ static void print_absolute_relocs(void)
 {
 	int i, printed = 0;
 
-	for(i = 0; i < ehdr.e_shnum; i++) {
+	for (i = 0; i < ehdr.e_shnum; i++) {
+		struct section *sec = &secs[i];
+		struct section *sec_applies, *sec_symtab;
 		char *sym_strtab;
 		Elf32_Sym *sh_symtab;
-		unsigned sec_applies, sec_symtab;
 		int j;
-		if (shdr[i].sh_type != SHT_REL) {
+		if (sec->shdr.sh_type != SHT_REL) {
 			continue;
 		}
-		sec_symtab  = shdr[i].sh_link;
-		sec_applies = shdr[i].sh_info;
-		if (!(shdr[sec_applies].sh_flags & SHF_ALLOC)) {
+		sec_symtab  = sec->link;
+		sec_applies = &secs[sec->shdr.sh_info];
+		if (!(sec_applies->shdr.sh_flags & SHF_ALLOC)) {
 			continue;
 		}
-		sh_symtab = symtab[sec_symtab];
-		sym_strtab = strtab[shdr[sec_symtab].sh_link];
-		for(j = 0; j < shdr[i].sh_size/sizeof(reltab[0][0]); j++) {
+		sh_symtab  = sec_symtab->symtab;
+		sym_strtab = sec_symtab->link->strtab;
+		for (j = 0; j < sec->shdr.sh_size/sizeof(Elf32_Rel); j++) {
 			Elf32_Rel *rel;
 			Elf32_Sym *sym;
 			const char *name;
-			rel = &reltab[i][j];
+			rel = &sec->reltab[j];
 			sym = &sh_symtab[ELF32_R_SYM(rel->r_info)];
 			name = sym_name(sym_strtab, sym);
 			if (sym->st_shndx != SHN_ABS) {
@@ -456,26 +476,28 @@ static void walk_relocs(void (*visit)(Elf32_Rel *rel, Elf32_Sym *sym))
 {
 	int i;
 	/* Walk through the relocations */
-	for(i = 0; i < ehdr.e_shnum; i++) {
+	for (i = 0; i < ehdr.e_shnum; i++) {
 		char *sym_strtab;
 		Elf32_Sym *sh_symtab;
-		unsigned sec_applies, sec_symtab;
+		struct section *sec_applies, *sec_symtab;
 		int j;
-		if (shdr[i].sh_type != SHT_REL) {
+		struct section *sec = &secs[i];
+
+		if (sec->shdr.sh_type != SHT_REL) {
 			continue;
 		}
-		sec_symtab  = shdr[i].sh_link;
-		sec_applies = shdr[i].sh_info;
-		if (!(shdr[sec_applies].sh_flags & SHF_ALLOC)) {
+		sec_symtab  = sec->link;
+		sec_applies = &secs[sec->shdr.sh_info];
+		if (!(sec_applies->shdr.sh_flags & SHF_ALLOC)) {
 			continue;
 		}
-		sh_symtab = symtab[sec_symtab];
-		sym_strtab = strtab[shdr[sec_symtab].sh_link];
-		for(j = 0; j < shdr[i].sh_size/sizeof(reltab[0][0]); j++) {
+		sh_symtab = sec_symtab->symtab;
+		sym_strtab = sec->link->strtab;
+		for (j = 0; j < sec->shdr.sh_size/sizeof(Elf32_Rel); j++) {
 			Elf32_Rel *rel;
 			Elf32_Sym *sym;
 			unsigned r_type;
-			rel = &reltab[i][j];
+			rel = &sec->reltab[j];
 			sym = &sh_symtab[ELF32_R_SYM(rel->r_info)];
 			r_type = ELF32_R_TYPE(rel->r_info);
 			/* Don't visit relocations to absolute symbols */
@@ -539,7 +561,7 @@ static void emit_relocs(int as_text)
 		 */
 		printf(".section \".data.reloc\",\"a\"\n");
 		printf(".balign 4\n");
-		for(i = 0; i < reloc_count; i++) {
+		for (i = 0; i < reloc_count; i++) {
 			printf("\t .long 0x%08lx\n", relocs[i]);
 		}
 		printf("\n");
@@ -550,7 +572,7 @@ static void emit_relocs(int as_text)
 		/* Print a stop */
 		printf("%c%c%c%c", buf[0], buf[1], buf[2], buf[3]);
 		/* Now print each relocation */
-		for(i = 0; i < reloc_count; i++) {
+		for (i = 0; i < reloc_count; i++) {
 			buf[0] = (relocs[i] >>  0) & 0xff;
 			buf[1] = (relocs[i] >>  8) & 0xff;
 			buf[2] = (relocs[i] >> 16) & 0xff;
@@ -577,7 +599,7 @@ int main(int argc, char **argv)
 	show_absolute_relocs = 0;
 	as_text = 0;
 	fname = NULL;
-	for(i = 1; i < argc; i++) {
+	for (i = 1; i < argc; i++) {
 		char *arg = argv[i];
 		if (*arg == '-') {
 			if (strcmp(argv[1], "--abs-syms") == 0) {
-- 
1.5.4.1


--------------010809090001050403080104--
