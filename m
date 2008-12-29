Return-Path: <linux-kernel-owner+w=401wt.eu-S1755500AbYL2OKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500AbYL2OKh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 09:10:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753878AbYL2OK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 09:10:29 -0500
Received: from mail.gmx.net ([213.165.64.20]:38515 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753190AbYL2OK1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 09:10:27 -0500
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX1+2kPcPJP+23O8YpzEQrPPvREDXviJXUrQkyDFSaY
	jmmeSjGza82ZBK
Message-ID: <4958DA54.8060003@gmx.de>
Date: Mon, 29 Dec 2008 15:10:28 +0100
From: Helge Deller <deller@gmx.de>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: linux-parisc@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Kyle McMartin <kyle@mcmartin.ca>, Randolph Chung <randolph@tausq.org>,
       Moritz Muehlenhoff <jmm@inutil.org>,
       Linus <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
CC: Helge Deller <deller@gmx.de>
Subject: [PATCH 2/2] parisc: fix module loading failure of large modules
References: <4958D99E.4010201@gmx.de>
In-Reply-To: <4958D99E.4010201@gmx.de>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/mixed;
 boundary="------------060902090404070205040905"
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.64,0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060902090404070205040905
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

[PATCH 2/2] parisc: fix module loading failure of large modules

On 32bit (and sometimes 64bit) and with big kernel modules like xfs or
ipv6 the relocation types R_PARISC_PCREL17F and R_PARISC_PCREL22F may
fail to reach their PLT stub if we only create one big stub array for
all sections at the beginning of the core or init section.

With this patch we now instead append individual PLT stub entries
directly at the end of the code sections where the stubs are actually
called. This reduces the distance between the PCREL location and the
stub entry so that the relocations can be fulfilled.

The kernel module loader will call module_additional_section_size() and
request us to return the amount of additional memory we need for the
stubs of each section. The final section size of the code segment will
then be increased by that value when the kernel layouts the final
addresses of all sections.

Tested with 32- and 64bit kernels.

Signed-off-by: Helge Deller <deller@gmx.de>


--------------060902090404070205040905
Content-Type: text/plain;
 name="modules.patch2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="modules.patch2"

diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index 644a70b..cbb622f 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -34,6 +34,9 @@ config RWSEM_GENERIC_SPINLOCK
 config RWSEM_XCHGADD_ALGORITHM
 	bool
 
+config ARCH_WANTS_STUBS_BEHIND_SECTIONS
+	def_bool y
+
 config ARCH_HAS_ILOG2_U32
 	bool
 	default n
diff --git a/arch/parisc/include/asm/module.h b/arch/parisc/include/asm/module.h
index c2cb49e..1f41234 100644
--- a/arch/parisc/include/asm/module.h
+++ b/arch/parisc/include/asm/module.h
@@ -23,8 +23,10 @@ struct mod_arch_specific
 {
 	unsigned long got_offset, got_count, got_max;
 	unsigned long fdesc_offset, fdesc_count, fdesc_max;
-	unsigned long stub_offset, stub_count, stub_max;
-	unsigned long init_stub_offset, init_stub_count, init_stub_max;
+	struct {
+		unsigned long stub_offset;
+		unsigned int stub_entries;
+		} *section;
 	int unwind_section;
 	struct unwind_table *unwind;
 };
diff --git a/arch/parisc/kernel/module.c b/arch/parisc/kernel/module.c
index 44138c3..f57caf3 100644
--- a/arch/parisc/kernel/module.c
+++ b/arch/parisc/kernel/module.c
@@ -6,6 +6,7 @@
  *
  *    Linux/PA-RISC Project (http://www.parisc-linux.org/)
  *    Copyright (C) 2003 Randolph Chung <tausq at debian . org>
+ *    Copyright (C) 2008 Helge Deller <deller@gmx.de>
  *
  *
  *    This program is free software; you can redistribute it and/or modify
@@ -24,6 +25,21 @@
  *
  *
  *    Notes:
+ *    - PLT stub handling
+ *      On 32bit (and sometimes 64bit) and with big kernel modules like xfs or
+ *      ipv6 the relocation types R_PARISC_PCREL17F and R_PARISC_PCREL22F may
+ *      fail to reach its PLT stub if we only create one big stub array for
+ *      all sections at the beginning of the core or init section.
+ *      Instead we now append individual PLT stub entries directly at the end
+ *      of the code sections where the stubs are actually called.
+ *      This reduces the distance between the PCREL location and the stub entry
+ *      so that the relocations can be fulfilled.
+ *      The kernel module loader will call module_additional_section_size()
+ *      and request us to return the amount of additional memory we need for
+ *      the stubs of each section. The final section size of the code segment
+ *      will then be increased by that value when the kernel layouts the final
+ *      addresses of all sections.
+ *
  *    - SEGREL32 handling
  *      We are not doing SEGREL32 handling correctly. According to the ABI, we
  *      should do a value offset, like this:
@@ -58,9 +74,13 @@
 #define DEBUGP(fmt...)
 #endif
 
+#define RELOC_REACHABLE(val, bits) \
+	(( ( !((val) & (1<<((bits)-1))) && ((val)>>(bits)) != 0 )  ||	\
+	     ( ((val) & (1<<((bits)-1))) && ((val)>>(bits)) != (((__typeof__(val))(~0))>>((bits)+2)))) ? \
+	0 : 1)
+
 #define CHECK_RELOC(val, bits) \
-	if ( ( !((val) & (1<<((bits)-1))) && ((val)>>(bits)) != 0 )  ||	\
-	     ( ((val) & (1<<((bits)-1))) && ((val)>>(bits)) != (((__typeof__(val))(~0))>>((bits)+2)))) { \
+	if (!RELOC_REACHABLE(val, bits)) { \
 		printk(KERN_ERR "module %s relocation of symbol %s is out of range (0x%lx in %d bits)\n", \
 		me->name, strtab + sym->st_name, (unsigned long)val, bits); \
 		return -ENOEXEC;			\
@@ -92,13 +112,6 @@ static inline int in_local(struct module *me, void *loc)
 	return in_init(me, loc) || in_core(me, loc);
 }
 
-static inline int in_local_section(struct module *me, void *loc, void *dot)
-{
-	return (in_init(me, loc) && in_init(me, dot)) ||
-		(in_core(me, loc) && in_core(me, dot));
-}
-
-
 #ifndef CONFIG_64BIT
 struct got_entry {
 	Elf32_Addr addr;
@@ -258,23 +271,42 @@ static inline unsigned long count_stubs(const Elf_Rela *rela, unsigned long n)
 /* Free memory returned from module_alloc */
 void module_free(struct module *mod, void *module_region)
 {
+	kfree(mod->arch.section);
+	mod->arch.section = NULL;
+
 	vfree(module_region);
 	/* FIXME: If module_region == mod->init_region, trim exception
            table entries. */
 }
 
+/* return number of additional bytes to reserve for a section */
+unsigned long module_additional_section_size(struct module *mod,
+					     unsigned int section)
+{
+	/* size needed for all stubs of this section (including
+	 * one additional for correct alignment of the stubs) */
+	return (mod->arch.section[section].stub_entries + 1)
+		* sizeof(struct stub_entry);
+}
+
 #define CONST 
 int module_frob_arch_sections(CONST Elf_Ehdr *hdr,
 			      CONST Elf_Shdr *sechdrs,
 			      CONST char *secstrings,
 			      struct module *me)
 {
-	unsigned long gots = 0, fdescs = 0, stubs = 0, init_stubs = 0;
+	unsigned long gots = 0, fdescs = 0, len;
 	unsigned int i;
 
+	len = hdr->e_shnum * sizeof(me->arch.section[0]);
+	me->arch.section = kzalloc(len, GFP_KERNEL);
+	if (!me->arch.section)
+		return -ENOMEM;
+
 	for (i = 1; i < hdr->e_shnum; i++) {
-		const Elf_Rela *rels = (void *)hdr + sechdrs[i].sh_offset;
+		const Elf_Rela *rels = (void *)sechdrs[i].sh_addr;
 		unsigned long nrels = sechdrs[i].sh_size / sizeof(*rels);
+		unsigned int count, s;
 
 		if (strncmp(secstrings + sechdrs[i].sh_name,
 			    ".PARISC.unwind", 14) == 0)
@@ -290,11 +322,24 @@ int module_frob_arch_sections(CONST Elf_Ehdr *hdr,
 		 */
 		gots += count_gots(rels, nrels);
 		fdescs += count_fdescs(rels, nrels);
-		if(strncmp(secstrings + sechdrs[i].sh_name,
-			   ".rela.init", 10) == 0)
-			init_stubs += count_stubs(rels, nrels);
-		else
-			stubs += count_stubs(rels, nrels);
+
+		/* XXX: By sorting the relocs and finding duplicate entries
+		 *  we could reduce the number of necessary stubs and save
+		 *  some memory. */
+		count = count_stubs(rels, nrels);
+		if (!count)
+			continue;
+
+		/* so we need relocation stubs. reserve necessary memory. */
+		/* sh_info gives the section for which we need to add stubs. */
+		s = sechdrs[i].sh_info;
+
+		/* amunt of stubs we want to add to this section */
+		WARN_ON(me->arch.section[s].stub_entries);
+		me->arch.section[s].stub_entries += count;
+
+		/* stubs start at end of the section */
+		me->arch.section[s].stub_offset = sechdrs[s].sh_size;
 	}
 
 	/* align things a bit */
@@ -306,18 +351,8 @@ int module_frob_arch_sections(CONST Elf_Ehdr *hdr,
 	me->arch.fdesc_offset = me->core_size;
 	me->core_size += fdescs * sizeof(Elf_Fdesc);
 
-	me->core_size = ALIGN(me->core_size, 16);
-	me->arch.stub_offset = me->core_size;
-	me->core_size += stubs * sizeof(struct stub_entry);
-
-	me->init_size = ALIGN(me->init_size, 16);
-	me->arch.init_stub_offset = me->init_size;
-	me->init_size += init_stubs * sizeof(struct stub_entry);
-
 	me->arch.got_max = gots;
 	me->arch.fdesc_max = fdescs;
-	me->arch.stub_max = stubs;
-	me->arch.init_stub_max = init_stubs;
 
 	return 0;
 }
@@ -380,22 +415,18 @@ enum elf_stub_type {
 };
 
 static Elf_Addr get_stub(struct module *me, unsigned long value, long addend,
-	enum elf_stub_type stub_type, int init_section)
+	enum elf_stub_type stub_type, Elf_Addr loc0, unsigned int targetsec)
 {
-	unsigned long i;
 	struct stub_entry *stub;
 
-	if(init_section) {
-		i = me->arch.init_stub_count++;
-		BUG_ON(me->arch.init_stub_count > me->arch.init_stub_max);
-		stub = me->module_init + me->arch.init_stub_offset + 
-			i * sizeof(struct stub_entry);
-	} else {
-		i = me->arch.stub_count++;
-		BUG_ON(me->arch.stub_count > me->arch.stub_max);
-		stub = me->module_core + me->arch.stub_offset + 
-			i * sizeof(struct stub_entry);
-	}
+	/* do not write outside available stub area */
+	BUG_ON(0 == me->arch.section[targetsec].stub_entries--);
+
+	/* calculate address of next stub entry, take care of alignment */
+	loc0 += me->arch.section[targetsec].stub_offset;
+	loc0 = ALIGN(loc0, sizeof(struct stub_entry));
+	stub = (void *) loc0;
+	me->arch.section[targetsec].stub_offset += sizeof(struct stub_entry);
 
 #ifndef CONFIG_64BIT
 /* for 32-bit the stub looks like this:
@@ -489,15 +520,19 @@ int apply_relocate_add(Elf_Shdr *sechdrs,
 	Elf32_Addr val;
 	Elf32_Sword addend;
 	Elf32_Addr dot;
+	Elf_Addr loc0;
+	unsigned int targetsec = sechdrs[relsec].sh_info;
 	//unsigned long dp = (unsigned long)$global$;
 	register unsigned long dp asm ("r27");
 
 	DEBUGP("Applying relocate section %u to %u\n", relsec,
-	       sechdrs[relsec].sh_info);
+	       targetsec);
 	for (i = 0; i < sechdrs[relsec].sh_size / sizeof(*rel); i++) {
 		/* This is where to make the change */
-		loc = (void *)sechdrs[sechdrs[relsec].sh_info].sh_addr
+		loc = (void *)sechdrs[targetsec].sh_addr
 		      + rel[i].r_offset;
+		/* This is the start of the target section */
+		loc0 = sechdrs[targetsec].sh_addr;
 		/* This is the symbol it is referring to */
 		sym = (Elf32_Sym *)sechdrs[symindex].sh_addr
 			+ ELF32_R_SYM(rel[i].r_info);
@@ -569,19 +604,32 @@ int apply_relocate_add(Elf_Shdr *sechdrs,
 			break;
 		case R_PARISC_PCREL17F:
 			/* 17-bit PC relative address */
-			val = get_stub(me, val, addend, ELF_STUB_GOT, in_init(me, loc));
+			/* calculate direct call offset */
+			val += addend;
 			val = (val - dot - 8)/4;
-			CHECK_RELOC(val, 17)
+			if (!RELOC_REACHABLE(val, 17)) {
+				/* direct distance too far, create
+				 * stub entry instead */
+				val = get_stub(me, sym->st_value, addend,
+					ELF_STUB_DIRECT, loc0, targetsec);
+				val = (val - dot - 8)/4;
+				CHECK_RELOC(val, 17);
+			}
 			*loc = (*loc & ~0x1f1ffd) | reassemble_17(val);
 			break;
 		case R_PARISC_PCREL22F:
 			/* 22-bit PC relative address; only defined for pa20 */
-			val = get_stub(me, val, addend, ELF_STUB_GOT, in_init(me, loc));
-			DEBUGP("STUB FOR %s loc %lx+%lx at %lx\n", 
-			       strtab + sym->st_name, (unsigned long)loc, addend, 
-			       val)
+			/* calculate direct call offset */
+			val += addend;
 			val = (val - dot - 8)/4;
-			CHECK_RELOC(val, 22);
+			if (!RELOC_REACHABLE(val, 22)) {
+				/* direct distance too far, create
+				 * stub entry instead */
+				val = get_stub(me, sym->st_value, addend,
+					ELF_STUB_DIRECT, loc0, targetsec);
+				val = (val - dot - 8)/4;
+				CHECK_RELOC(val, 22);
+			}
 			*loc = (*loc & ~0x3ff1ffd) | reassemble_22(val);
 			break;
 
@@ -610,13 +658,17 @@ int apply_relocate_add(Elf_Shdr *sechdrs,
 	Elf64_Addr val;
 	Elf64_Sxword addend;
 	Elf64_Addr dot;
+	Elf_Addr loc0;
+	unsigned int targetsec = sechdrs[relsec].sh_info;
 
 	DEBUGP("Applying relocate section %u to %u\n", relsec,
-	       sechdrs[relsec].sh_info);
+	       targetsec);
 	for (i = 0; i < sechdrs[relsec].sh_size / sizeof(*rel); i++) {
 		/* This is where to make the change */
-		loc = (void *)sechdrs[sechdrs[relsec].sh_info].sh_addr
+		loc = (void *)sechdrs[targetsec].sh_addr
 		      + rel[i].r_offset;
+		/* This is the start of the target section */
+		loc0 = sechdrs[targetsec].sh_addr;
 		/* This is the symbol it is referring to */
 		sym = (Elf64_Sym *)sechdrs[symindex].sh_addr
 			+ ELF64_R_SYM(rel[i].r_info);
@@ -672,42 +724,40 @@ int apply_relocate_add(Elf_Shdr *sechdrs,
 			DEBUGP("PCREL22F Symbol %s loc %p val %lx\n",
 			       strtab + sym->st_name,
 			       loc, val);
+			val += addend;
 			/* can we reach it locally? */
-			if(!in_local_section(me, (void *)val, (void *)dot)) {
-
-				if (in_local(me, (void *)val))
-					/* this is the case where the
-					 * symbol is local to the
-					 * module, but in a different
-					 * section, so stub the jump
-					 * in case it's more than 22
-					 * bits away */
-					val = get_stub(me, val, addend, ELF_STUB_DIRECT,
-						       in_init(me, loc));
-				else if (strncmp(strtab + sym->st_name, "$$", 2)
+			if (in_local(me, (void *)val)) {
+				/* this is the case where the symbol is local
+				 * to the module, but in a different section,
+				 * so stub the jump in case it's more than 22
+				 * bits away */
+				val = (val - dot - 8)/4;
+				if (!RELOC_REACHABLE(val, 22)) {
+					/* direct distance too far, create
+					 * stub entry instead */
+					val = get_stub(me, sym->st_value,
+						addend, ELF_STUB_DIRECT,
+						loc0, targetsec);
+				} else {
+					/* Ok, we can reach it directly. */
+					val = sym->st_value;
+					val += addend;
+				}
+			} else {
+				val = sym->st_value;
+				if (strncmp(strtab + sym->st_name, "$$", 2)
 				    == 0)
 					val = get_stub(me, val, addend, ELF_STUB_MILLI,
-						       in_init(me, loc));
+						       loc0, targetsec);
 				else
 					val = get_stub(me, val, addend, ELF_STUB_GOT,
-						       in_init(me, loc));
+						       loc0, targetsec);
 			}
 			DEBUGP("STUB FOR %s loc %lx, val %lx+%lx at %lx\n", 
 			       strtab + sym->st_name, loc, sym->st_value,
 			       addend, val);
-			/* FIXME: local symbols work as long as the
-			 * core and init pieces aren't separated too
-			 * far.  If this is ever broken, you will trip
-			 * the check below.  The way to fix it would
-			 * be to generate local stubs to go between init
-			 * and core */
-			if((Elf64_Sxword)(val - dot - 8) > 0x800000 -1 ||
-			   (Elf64_Sxword)(val - dot - 8) < -0x800000) {
-				printk(KERN_ERR "Module %s, symbol %s is out of range for PCREL22F relocation\n",
-				       me->name, strtab + sym->st_name);
-				return -ENOEXEC;
-			}
 			val = (val - dot - 8)/4;
+			CHECK_RELOC(val, 22);
 			*loc = (*loc & ~0x3ff1ffd) | reassemble_22(val);
 			break;
 		case R_PARISC_DIR64:
@@ -794,12 +844,8 @@ int module_finalize(const Elf_Ehdr *hdr,
 	addr = (u32 *)entry->addr;
 	printk("INSNS: %x %x %x %x\n",
 	       addr[0], addr[1], addr[2], addr[3]);
-	printk("stubs used %ld, stubs max %ld\n"
-	       "init_stubs used %ld, init stubs max %ld\n"
-	       "got entries used %ld, gots max %ld\n"
+	printk("got entries used %ld, gots max %ld\n"
 	       "fdescs used %ld, fdescs max %ld\n",
-	       me->arch.stub_count, me->arch.stub_max,
-	       me->arch.init_stub_count, me->arch.init_stub_max,
 	       me->arch.got_count, me->arch.got_max,
 	       me->arch.fdesc_count, me->arch.fdesc_max);
 #endif
@@ -829,7 +875,10 @@ int module_finalize(const Elf_Ehdr *hdr,
 				me->name, me->arch.got_count, MAX_GOTS);
 		return -EINVAL;
 	}
-	
+
+	kfree(me->arch.section);
+	me->arch.section = NULL;
+
 	/* no symbol table */
 	if(symhdr == NULL)
 		return 0;

--------------060902090404070205040905--
