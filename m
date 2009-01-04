Return-Path: <linux-kernel-owner+w=401wt.eu-S1756185AbZADWOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185AbZADWOS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 17:14:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750944AbZADWOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 17:14:00 -0500
Received: from ozlabs.org ([203.10.76.45]:44232 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775AbZADWN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 17:13:58 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL] modules and stop_machine
Date: Mon, 5 Jan 2009 08:43:51 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: linux-kernel@vger.kernel.org, Tim Abbott <tabbott@mit.edu>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Helge Deller <deller@gmx.de>, Jianjun Kong <jianjun@zeuux.org>,
       Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901050843.52479.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 7d3b56ba37a95f1f370f50258ed3954c304c524b:    
  Linus Torvalds (1):                                                           
        Merge branch 'cpus4096-for-linus-3' of git://git.kernel.org/.../tip/linux-2.6-tip                                                                       

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus.git master

Heiko Carstens (2):
      stop_machine: introduce stop_machine_create/destroy.
      module: convert to stop_machine_create/destroy.

Helge Deller (2):
      module: fix module loading failure of large kernel modules for parisc
      parisc: fix module loading failure of large kernel modules

Jianjun Kong (1):
      module: fix warning of unused function when !CONFIG_PROC_FS

Johannes Berg (1):
      remove CONFIG_KMOD

Tim Abbott (1):
      kernel/module.c: compare symbol values when marking symbols as exported in /proc/kallsyms.

 arch/parisc/include/asm/module.h |    6 +-
 arch/parisc/kernel/module.c      |  216 ++++++++++++++++++++++++--------------
 include/linux/moduleloader.h     |    3 +
 include/linux/stop_machine.h     |   22 ++++
 init/Kconfig                     |    6 -
 kernel/cpu.c                     |    6 +-
 kernel/module.c                  |   59 ++++++++---
 kernel/stop_machine.c            |   55 ++++++++--
 8 files changed, 258 insertions(+), 115 deletions(-)

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
index 44138c3..9013243 100644
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
@@ -24,6 +25,19 @@
  *
  *
  *    Notes:
+ *    - PLT stub handling
+ *      On 32bit (and sometimes 64bit) and with big kernel modules like xfs or
+ *      ipv6 the relocation types R_PARISC_PCREL17F and R_PARISC_PCREL22F may
+ *      fail to reach their PLT stub if we only create one big stub array for
+ *      all sections at the beginning of the core or init section.
+ *      Instead we now insert individual PLT stub entries directly in front of
+ *      of the code sections where the stubs are actually called.
+ *      This reduces the distance between the PCREL location and the stub entry
+ *      so that the relocations can be fulfilled.
+ *      While calculating the final layout of the kernel module in memory, the
+ *      kernel module loader calls arch_mod_section_prepend() to request the
+ *      to be reserved amount of memory in front of each individual section.
+ *
  *    - SEGREL32 handling
  *      We are not doing SEGREL32 handling correctly. According to the ABI, we
  *      should do a value offset, like this:
@@ -58,9 +72,13 @@
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
@@ -92,13 +110,6 @@ static inline int in_local(struct module *me, void *loc)
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
@@ -258,23 +269,42 @@ static inline unsigned long count_stubs(const Elf_Rela *rela, unsigned long n)
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
 
+/* Additional bytes needed in front of individual sections */
+unsigned int arch_mod_section_prepend(struct module *mod,
+				      unsigned int section)
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
@@ -290,11 +320,23 @@ int module_frob_arch_sections(CONST Elf_Ehdr *hdr,
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
+		/* each code section should only have one relocation section */
+		WARN_ON(me->arch.section[s].stub_entries);
+
+		/* store number of stubs we need for this section */
+		me->arch.section[s].stub_entries += count;
 	}
 
 	/* align things a bit */
@@ -306,18 +348,8 @@ int module_frob_arch_sections(CONST Elf_Ehdr *hdr,
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
@@ -380,23 +412,27 @@ enum elf_stub_type {
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
+	/* initialize stub_offset to point in front of the section */
+	if (!me->arch.section[targetsec].stub_offset) {
+		loc0 -= (me->arch.section[targetsec].stub_entries + 1) *
+				sizeof(struct stub_entry);
+		/* get correct alignment for the stubs */
+		loc0 = ALIGN(loc0, sizeof(struct stub_entry));
+		me->arch.section[targetsec].stub_offset = loc0;
 	}
 
+	/* get address of stub entry */
+	stub = (void *) me->arch.section[targetsec].stub_offset;
+	me->arch.section[targetsec].stub_offset += sizeof(struct stub_entry);
+
+	/* do not write outside available stub area */
+	BUG_ON(0 == me->arch.section[targetsec].stub_entries--);
+
+
 #ifndef CONFIG_64BIT
 /* for 32-bit the stub looks like this:
  * 	ldil L'XXX,%r1
@@ -489,15 +525,19 @@ int apply_relocate_add(Elf_Shdr *sechdrs,
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
@@ -569,19 +609,32 @@ int apply_relocate_add(Elf_Shdr *sechdrs,
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
 
@@ -610,13 +663,17 @@ int apply_relocate_add(Elf_Shdr *sechdrs,
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
@@ -672,42 +729,40 @@ int apply_relocate_add(Elf_Shdr *sechdrs,
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
@@ -794,12 +849,8 @@ int module_finalize(const Elf_Ehdr *hdr,
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
@@ -829,7 +880,10 @@ int module_finalize(const Elf_Ehdr *hdr,
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
diff --git a/include/linux/moduleloader.h b/include/linux/moduleloader.h
index eb10339..c1f40c2 100644
--- a/include/linux/moduleloader.h
+++ b/include/linux/moduleloader.h
@@ -13,6 +13,9 @@ int module_frob_arch_sections(Elf_Ehdr *hdr,
 			      char *secstrings,
 			      struct module *mod);
 
+/* Additional bytes needed by arch in front of individual sections */
+unsigned int arch_mod_section_prepend(struct module *mod, unsigned int section);
+
 /* Allocator used for allocating struct module, core sections and init
    sections.  Returns NULL on failure. */
 void *module_alloc(unsigned long size);
diff --git a/include/linux/stop_machine.h b/include/linux/stop_machine.h
index 74d59a6..baba3a2 100644
--- a/include/linux/stop_machine.h
+++ b/include/linux/stop_machine.h
@@ -35,6 +35,24 @@ int stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus);
  * won't come or go while it's being called.  Used by hotplug cpu.
  */
 int __stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus);
+
+/**
+ * stop_machine_create: create all stop_machine threads
+ *
+ * Description: This causes all stop_machine threads to be created before
+ * stop_machine actually gets called. This can be used by subsystems that
+ * need a non failing stop_machine infrastructure.
+ */
+int stop_machine_create(void);
+
+/**
+ * stop_machine_destroy: destroy all stop_machine threads
+ *
+ * Description: This causes all stop_machine threads which were created with
+ * stop_machine_create to be destroyed again.
+ */
+void stop_machine_destroy(void);
+
 #else
 
 static inline int stop_machine(int (*fn)(void *), void *data,
@@ -46,5 +64,9 @@ static inline int stop_machine(int (*fn)(void *), void *data,
 	local_irq_enable();
 	return ret;
 }
+
+static inline int stop_machine_create(void) { return 0; }
+static inline void stop_machine_destroy(void) { }
+
 #endif /* CONFIG_SMP */
 #endif /* _LINUX_STOP_MACHINE */
diff --git a/init/Kconfig b/init/Kconfig
index f628171..52847ee 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -916,12 +916,6 @@ config MODULE_SRCVERSION_ALL
 	  the version).  With this option, such a "srcversion" field
 	  will be created for all modules.  If unsure, say N.
 
-config KMOD
-	def_bool y
-	help
-	  This is being removed soon.  These days, CONFIG_MODULES
-	  implies CONFIG_KMOD, so use that instead.
-
 endif # MODULES
 
 config INIT_ALL_POSSIBLE
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 47fff3b..30e74dd 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -269,8 +269,11 @@ out_release:
 
 int __ref cpu_down(unsigned int cpu)
 {
-	int err = 0;
+	int err;
 
+	err = stop_machine_create();
+	if (err)
+		return err;
 	cpu_maps_update_begin();
 
 	if (cpu_hotplug_disabled) {
@@ -297,6 +300,7 @@ int __ref cpu_down(unsigned int cpu)
 
 out:
 	cpu_maps_update_done();
+	stop_machine_destroy();
 	return err;
 }
 EXPORT_SYMBOL(cpu_down);
diff --git a/kernel/module.c b/kernel/module.c
index dd2a541..f47cce9 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -757,8 +757,16 @@ sys_delete_module(const char __user *name_user, unsigned int flags)
 		return -EFAULT;
 	name[MODULE_NAME_LEN-1] = '\0';
 
-	if (mutex_lock_interruptible(&module_mutex) != 0)
-		return -EINTR;
+	/* Create stop_machine threads since free_module relies on
+	 * a non-failing stop_machine call. */
+	ret = stop_machine_create();
+	if (ret)
+		return ret;
+
+	if (mutex_lock_interruptible(&module_mutex) != 0) {
+		ret = -EINTR;
+		goto out_stop;
+	}
 
 	mod = find_module(name);
 	if (!mod) {
@@ -817,10 +825,12 @@ sys_delete_module(const char __user *name_user, unsigned int flags)
 
  out:
 	mutex_unlock(&module_mutex);
+out_stop:
+	stop_machine_destroy();
 	return ret;
 }
 
-static void print_unload_info(struct seq_file *m, struct module *mod)
+static inline void print_unload_info(struct seq_file *m, struct module *mod)
 {
 	struct module_use *use;
 	int printed_something = 0;
@@ -893,7 +903,7 @@ void module_put(struct module *module)
 EXPORT_SYMBOL(module_put);
 
 #else /* !CONFIG_MODULE_UNLOAD */
-static void print_unload_info(struct seq_file *m, struct module *mod)
+static inline void print_unload_info(struct seq_file *m, struct module *mod)
 {
 	/* We don't know the usage count, or what modules are using. */
 	seq_printf(m, " - -");
@@ -1578,11 +1588,21 @@ static int simplify_symbols(Elf_Shdr *sechdrs,
 	return ret;
 }
 
+/* Additional bytes needed by arch in front of individual sections */
+unsigned int __weak arch_mod_section_prepend(struct module *mod,
+					     unsigned int section)
+{
+	/* default implementation just returns zero */
+	return 0;
+}
+
 /* Update size with this section: return offset. */
-static long get_offset(unsigned int *size, Elf_Shdr *sechdr)
+static long get_offset(struct module *mod, unsigned int *size,
+		       Elf_Shdr *sechdr, unsigned int section)
 {
 	long ret;
 
+	*size += arch_mod_section_prepend(mod, section);
 	ret = ALIGN(*size, sechdr->sh_addralign ?: 1);
 	*size = ret + sechdr->sh_size;
 	return ret;
@@ -1622,7 +1642,7 @@ static void layout_sections(struct module *mod,
 			    || strncmp(secstrings + s->sh_name,
 				       ".init", 5) == 0)
 				continue;
-			s->sh_entsize = get_offset(&mod->core_size, s);
+			s->sh_entsize = get_offset(mod, &mod->core_size, s, i);
 			DEBUGP("\t%s\n", secstrings + s->sh_name);
 		}
 		if (m == 0)
@@ -1640,7 +1660,7 @@ static void layout_sections(struct module *mod,
 			    || strncmp(secstrings + s->sh_name,
 				       ".init", 5) != 0)
 				continue;
-			s->sh_entsize = (get_offset(&mod->init_size, s)
+			s->sh_entsize = (get_offset(mod, &mod->init_size, s, i)
 					 | INIT_OFFSET_MASK);
 			DEBUGP("\t%s\n", secstrings + s->sh_name);
 		}
@@ -1725,15 +1745,15 @@ static const struct kernel_symbol *lookup_symbol(const char *name,
 	return NULL;
 }
 
-static int is_exported(const char *name, const struct module *mod)
+static int is_exported(const char *name, unsigned long value,
+		       const struct module *mod)
 {
-	if (!mod && lookup_symbol(name, __start___ksymtab, __stop___ksymtab))
-		return 1;
+	const struct kernel_symbol *ks;
+	if (!mod)
+		ks = lookup_symbol(name, __start___ksymtab, __stop___ksymtab);
 	else
-		if (mod && lookup_symbol(name, mod->syms, mod->syms + mod->num_syms))
-			return 1;
-		else
-			return 0;
+		ks = lookup_symbol(name, mod->syms, mod->syms + mod->num_syms);
+	return ks != NULL && ks->value == value;
 }
 
 /* As per nm */
@@ -1865,6 +1885,13 @@ static noinline struct module *load_module(void __user *umod,
 	/* vmalloc barfs on "unusual" numbers.  Check here */
 	if (len > 64 * 1024 * 1024 || (hdr = vmalloc(len)) == NULL)
 		return ERR_PTR(-ENOMEM);
+
+	/* Create stop_machine threads since the error path relies on
+	 * a non-failing stop_machine call. */
+	err = stop_machine_create();
+	if (err)
+		goto free_hdr;
+
 	if (copy_from_user(hdr, umod, len) != 0) {
 		err = -EFAULT;
 		goto free_hdr;
@@ -2248,6 +2275,7 @@ static noinline struct module *load_module(void __user *umod,
 	/* Get rid of temporary copy */
 	vfree(hdr);
 
+	stop_machine_destroy();
 	/* Done! */
 	return mod;
 
@@ -2270,6 +2298,7 @@ static noinline struct module *load_module(void __user *umod,
 	kfree(args);
  free_hdr:
 	vfree(hdr);
+	stop_machine_destroy();
 	return ERR_PTR(err);
 
  truncated:
@@ -2504,7 +2533,7 @@ int module_get_kallsym(unsigned int symnum, unsigned long *value, char *type,
 			strlcpy(name, mod->strtab + mod->symtab[symnum].st_name,
 				KSYM_NAME_LEN);
 			strlcpy(module_name, mod->name, MODULE_NAME_LEN);
-			*exported = is_exported(name, mod);
+			*exported = is_exported(name, *value, mod);
 			preempt_enable();
 			return 0;
 		}
diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index 286c417..0cd415e 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -38,7 +38,10 @@ struct stop_machine_data {
 static unsigned int num_threads;
 static atomic_t thread_ack;
 static DEFINE_MUTEX(lock);
-
+/* setup_lock protects refcount, stop_machine_wq and stop_machine_work. */
+static DEFINE_MUTEX(setup_lock);
+/* Users of stop_machine. */
+static int refcount;
 static struct workqueue_struct *stop_machine_wq;
 static struct stop_machine_data active, idle;
 static const cpumask_t *active_cpus;
@@ -109,6 +112,43 @@ static int chill(void *unused)
 	return 0;
 }
 
+int stop_machine_create(void)
+{
+	mutex_lock(&setup_lock);
+	if (refcount)
+		goto done;
+	stop_machine_wq = create_rt_workqueue("kstop");
+	if (!stop_machine_wq)
+		goto err_out;
+	stop_machine_work = alloc_percpu(struct work_struct);
+	if (!stop_machine_work)
+		goto err_out;
+done:
+	refcount++;
+	mutex_unlock(&setup_lock);
+	return 0;
+
+err_out:
+	if (stop_machine_wq)
+		destroy_workqueue(stop_machine_wq);
+	mutex_unlock(&setup_lock);
+	return -ENOMEM;
+}
+EXPORT_SYMBOL_GPL(stop_machine_create);
+
+void stop_machine_destroy(void)
+{
+	mutex_lock(&setup_lock);
+	refcount--;
+	if (refcount)
+		goto done;
+	destroy_workqueue(stop_machine_wq);
+	free_percpu(stop_machine_work);
+done:
+	mutex_unlock(&setup_lock);
+}
+EXPORT_SYMBOL_GPL(stop_machine_destroy);
+
 int __stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus)
 {
 	struct work_struct *sm_work;
@@ -146,19 +186,14 @@ int stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus)
 {
 	int ret;
 
+	ret = stop_machine_create();
+	if (ret)
+		return ret;
 	/* No CPUs can come up or down during this. */
 	get_online_cpus();
 	ret = __stop_machine(fn, data, cpus);
 	put_online_cpus();
-
+	stop_machine_destroy();
 	return ret;
 }
 EXPORT_SYMBOL_GPL(stop_machine);
-
-static int __init stop_machine_init(void)
-{
-	stop_machine_wq = create_rt_workqueue("kstop");
-	stop_machine_work = alloc_percpu(struct work_struct);
-	return 0;
-}
-core_initcall(stop_machine_init);
