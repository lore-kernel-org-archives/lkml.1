Return-Path: <linux-kernel-owner+w=401wt.eu-S933490AbXDGABM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933490AbXDGABM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 20:01:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933539AbXDGAAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 20:00:35 -0400
Received: from 163.sub-75-209-152.myvzw.com ([75.209.152.163]:42392 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933537AbXDGAAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 20:00:30 -0400
Message-Id: <20070406224204.946993099@goop.org>
References: <20070406224152.556848893@goop.org>
User-Agent: quilt/0.46-1
Date: Fri, 06 Apr 2007 15:41:55 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>, Zachary Amsden <zach@vmware.com>,
       "Jan Beulich" <JBeulich@novell.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>
Subject: [patch 3/4] Relocate VDSO ELF headers to match mapped location with COMPAT_VDSO
Content-Disposition: inline; filename=relocate-COMPAT_VDSO.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Some versions of libc can't deal with a VDSO which doesn't have its
ELF headers matching its mapped address.  COMPAT_VDSO maps the VDSO at
a specific system-wide fixed address.  Previously this was all done at
build time, on the grounds that the fixed VDSO address is always at
the top of the address space.  However, a hypervisor may reserve some
of that address space, pushing the fixmap address down.

This patch does the adjustment dynamically at runtime, depending on
the runtime location of the VDSO fixmap.

[ Patch has been through several hands: Jan Beulich wrote the orignal
  version; Zach reworked it, and Jeremy converted it to relocate phdrs
  as well as sections. ]

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Zachary Amsden <zach@vmware.com>
Cc: "Jan Beulich" <JBeulich@novell.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Roland McGrath <roland@redhat.com>

---
 arch/i386/kernel/entry.S    |    4 -
 arch/i386/kernel/sysenter.c |  170 +++++++++++++++++++++++++++++++++++++++----
 arch/i386/mm/pgtable.c      |    6 -
 include/asm-i386/elf.h      |   28 ++-----
 include/asm-i386/fixmap.h   |    8 --
 include/linux/elf.h         |   17 ++++
 6 files changed, 184 insertions(+), 49 deletions(-)

===================================================================
--- a/arch/i386/kernel/entry.S
+++ b/arch/i386/kernel/entry.S
@@ -305,16 +305,12 @@ sysenter_past_esp:
 	pushl $(__USER_CS)
 	CFI_ADJUST_CFA_OFFSET 4
 	/*CFI_REL_OFFSET cs, 0*/
-#ifndef CONFIG_COMPAT_VDSO
 	/*
 	 * Push current_thread_info()->sysenter_return to the stack.
 	 * A tiny bit of offset fixup is necessary - 4*4 means the 4 words
 	 * pushed above; +8 corresponds to copy_thread's esp0 setting.
 	 */
 	pushl (TI_sysenter_return-THREAD_SIZE+8+4*4)(%esp)
-#else
-	pushl $SYSENTER_RETURN
-#endif
 	CFI_ADJUST_CFA_OFFSET 4
 	CFI_REL_OFFSET eip, 0
 
===================================================================
--- a/arch/i386/kernel/sysenter.c
+++ b/arch/i386/kernel/sysenter.c
@@ -22,6 +22,7 @@
 #include <asm/msr.h>
 #include <asm/pgtable.h>
 #include <asm/unistd.h>
+#include <asm/elf.h>
 
 /*
  * Should the kernel map a VDSO page into processes and pass its
@@ -41,6 +42,129 @@ __setup("vdso=", vdso_setup);
 __setup("vdso=", vdso_setup);
 
 extern asmlinkage void sysenter_entry(void);
+
+#ifdef CONFIG_COMPAT_VDSO
+static __init void reloc_symtab(Elf32_Ehdr *ehdr,
+				unsigned offset, unsigned size)
+{
+	Elf32_Sym *sym = (void *)ehdr + offset;
+	unsigned nsym = size / sizeof(*sym);
+	unsigned i;
+
+	for(i = 0; i < nsym; i++, sym++) {
+		if (sym->st_shndx == SHN_UNDEF ||
+		    sym->st_shndx == SHN_ABS)
+			continue;  /* skip */
+
+		if (sym->st_shndx > SHN_LORESERVE) {
+			printk(KERN_INFO "VDSO: unexpected st_shndx %x\n",
+			       sym->st_shndx);
+			continue;
+		}
+
+		switch(ELF_ST_TYPE(sym->st_info)) {
+		case STT_OBJECT:
+		case STT_FUNC:
+		case STT_SECTION:
+		case STT_FILE:
+			sym->st_value += VDSO_HIGH_BASE;
+		}
+	}
+}
+
+static __init void reloc_dyn(Elf32_Ehdr *ehdr, unsigned offset)
+{
+	Elf32_Dyn *dyn = (void *)ehdr + offset;
+
+	for(; dyn->d_tag != DT_NULL; dyn++)
+		switch(dyn->d_tag) {
+		case DT_PLTGOT:
+		case DT_HASH:
+		case DT_STRTAB:
+		case DT_SYMTAB:
+		case DT_RELA:
+		case DT_INIT:
+		case DT_FINI:
+		case DT_REL:
+		case DT_DEBUG:
+		case DT_JMPREL:
+		case DT_VERSYM:
+		case DT_VERDEF:
+		case DT_VERNEED:
+		case DT_ADDRRNGLO ... DT_ADDRRNGHI:
+			/* definitely pointers needing relocation */
+			dyn->d_un.d_ptr += VDSO_HIGH_BASE;
+			break;
+
+		case DT_ENCODING ... OLD_DT_LOOS-1:
+		case DT_LOOS ... DT_HIOS-1:
+			/* Tags above DT_ENCODING are pointers if
+			   they're even */
+			if (dyn->d_tag >= DT_ENCODING &&
+			    (dyn->d_tag & 1) == 0)
+				dyn->d_un.d_ptr += VDSO_HIGH_BASE;
+			break;
+
+		case DT_VERDEFNUM:
+		case DT_VERNEEDNUM:
+		case DT_FLAGS_1:
+		case DT_RELACOUNT:
+		case DT_RELCOUNT:
+		case DT_VALRNGLO ... DT_VALRNGHI:
+			/* definitely not pointers */
+			break;
+
+		case OLD_DT_LOOS ... DT_LOOS-1:
+		case DT_HIOS ... DT_VALRNGLO-1:
+		default:
+			if (dyn->d_tag > DT_ENCODING)
+				printk(KERN_INFO "VDSO: unexpected DT_tag %x\n",
+				       dyn->d_tag);
+			break;
+		}
+}
+
+static __init void relocate_vdso(Elf32_Ehdr *ehdr)
+{
+	Elf32_Phdr *phdr;
+	Elf32_Shdr *shdr;
+	int i;
+
+	BUG_ON(memcmp(ehdr->e_ident, ELFMAG, 4) != 0 ||
+	       !elf_check_arch(ehdr) ||
+	       ehdr->e_type != ET_DYN);
+
+	ehdr->e_entry += VDSO_HIGH_BASE;
+
+	/* rebase phdrs */
+	phdr = (void *)ehdr + ehdr->e_phoff;
+	for (i = 0; i < ehdr->e_phnum; i++) {
+		phdr[i].p_vaddr += VDSO_HIGH_BASE;
+
+		/* relocate dynamic stuff */
+		if (phdr[i].p_type == PT_DYNAMIC)
+			reloc_dyn(ehdr, phdr[i].p_offset);
+	}
+
+	/* rebase sections */
+	shdr = (void *)ehdr + ehdr->e_shoff;
+	for(i = 0; i < ehdr->e_shnum; i++) {
+		if (!(shdr[i].sh_flags & SHF_ALLOC))
+			continue;
+
+		shdr[i].sh_addr += VDSO_HIGH_BASE;
+
+		if (shdr[i].sh_type == SHT_SYMTAB ||
+		    shdr[i].sh_type == SHT_DYNSYM)
+			reloc_symtab(ehdr, shdr[i].sh_offset,
+				     shdr[i].sh_size);
+	}
+}
+#else
+static inline void relocate_vdso(Elf32_Ehdr *ehdr)
+{
+}
+#endif	/* COMPAT_VDSO */
 
 void enable_sep_cpu(void)
 {
@@ -71,6 +195,9 @@ int __init sysenter_setup(void)
 int __init sysenter_setup(void)
 {
 	void *syscall_page = (void *)get_zeroed_page(GFP_ATOMIC);
+	const void *vsyscall;
+	size_t vsyscall_len;
+
 	syscall_pages[0] = virt_to_page(syscall_page);
 
 #ifdef CONFIG_COMPAT_VDSO
@@ -79,23 +206,23 @@ int __init sysenter_setup(void)
 #endif
 
 	if (!boot_cpu_has(X86_FEATURE_SEP)) {
-		memcpy(syscall_page,
-		       &vsyscall_int80_start,
-		       &vsyscall_int80_end - &vsyscall_int80_start);
-		return 0;
-	}
-
-	memcpy(syscall_page,
-	       &vsyscall_sysenter_start,
-	       &vsyscall_sysenter_end - &vsyscall_sysenter_start);
-
-	return 0;
-}
-
-#ifndef CONFIG_COMPAT_VDSO
+		vsyscall = &vsyscall_int80_start;
+		vsyscall_len = &vsyscall_int80_end - &vsyscall_int80_start;
+	} else {
+		vsyscall = &vsyscall_sysenter_start;
+		vsyscall_len = &vsyscall_sysenter_end - &vsyscall_sysenter_start;
+	}
+
+	memcpy(syscall_page, vsyscall, vsyscall_len);
+	relocate_vdso(syscall_page);
+
+	return 0;
+}
+
 /* Defined in vsyscall-sysenter.S */
 extern void SYSENTER_RETURN;
 
+#ifdef __HAVE_ARCH_GATE_AREA
 /* Setup a VMA at program startup for the vsyscall page */
 int arch_setup_additional_pages(struct linux_binprm *bprm, int exstack)
 {
@@ -155,4 +282,17 @@ int in_gate_area_no_task(unsigned long a
 {
 	return 0;
 }
-#endif
+#else  /* !__HAVE_ARCH_GATE_AREA */
+int arch_setup_additional_pages(struct linux_binprm *bprm, int exstack)
+{
+	/*
+	 * If not creating userspace VMA, simply set vdso to point to
+	 * fixmap page.
+	 */
+	current->mm->context.vdso = (void *)VDSO_HIGH_BASE;
+	current_thread_info()->sysenter_return =
+		(void *)VDSO_SYM(&SYSENTER_RETURN);
+
+	return 0;
+}
+#endif	/* __HAVE_ARCH_GATE_AREA */
===================================================================
--- a/arch/i386/mm/pgtable.c
+++ b/arch/i386/mm/pgtable.c
@@ -144,10 +144,8 @@ void set_pmd_pfn(unsigned long vaddr, un
 }
 
 static int fixmaps;
-#ifndef CONFIG_COMPAT_VDSO
 unsigned long __FIXADDR_TOP = 0xfffff000;
 EXPORT_SYMBOL(__FIXADDR_TOP);
-#endif
 
 void __set_fixmap (enum fixed_addresses idx, unsigned long phys, pgprot_t flags)
 {
@@ -173,12 +171,8 @@ void reserve_top_address(unsigned long r
 	BUG_ON(fixmaps > 0);
 	printk(KERN_INFO "Reserving virtual address space above 0x%08x\n",
 	       (int)-reserve);
-#ifdef CONFIG_COMPAT_VDSO
-	BUG_ON(reserve != 0);
-#else
 	__FIXADDR_TOP = -reserve - PAGE_SIZE;
 	__VMALLOC_RESERVE += reserve;
-#endif
 }
 
 pte_t *pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address)
===================================================================
--- a/include/asm-i386/elf.h
+++ b/include/asm-i386/elf.h
@@ -133,39 +133,31 @@ extern int dump_task_extended_fpu (struc
 #define ELF_CORE_COPY_XFPREGS(tsk, elf_xfpregs) dump_task_extended_fpu(tsk, elf_xfpregs)
 
 #define VDSO_HIGH_BASE		(__fix_to_virt(FIX_VDSO))
-#define VDSO_BASE		((unsigned long)current->mm->context.vdso)
-
-#ifdef CONFIG_COMPAT_VDSO
-# define VDSO_COMPAT_BASE	VDSO_HIGH_BASE
-# define VDSO_PRELINK		VDSO_HIGH_BASE
-#else
-# define VDSO_COMPAT_BASE	VDSO_BASE
-# define VDSO_PRELINK		0
-#endif
+#define VDSO_CURRENT_BASE	((unsigned long)current->mm->context.vdso)
+#define VDSO_PRELINK		0
 
 #define VDSO_SYM(x) \
-		(VDSO_COMPAT_BASE + (unsigned long)(x) - VDSO_PRELINK)
+		(VDSO_CURRENT_BASE + (unsigned long)(x) - VDSO_PRELINK)
 
 #define VDSO_HIGH_EHDR		((const struct elfhdr *) VDSO_HIGH_BASE)
-#define VDSO_EHDR		((const struct elfhdr *) VDSO_COMPAT_BASE)
+#define VDSO_EHDR		((const struct elfhdr *) VDSO_CURRENT_BASE)
 
 extern void __kernel_vsyscall;
 
 #define VDSO_ENTRY		VDSO_SYM(&__kernel_vsyscall)
 
-#ifndef CONFIG_COMPAT_VDSO
+struct linux_binprm;
+
 #define ARCH_HAS_SETUP_ADDITIONAL_PAGES
-struct linux_binprm;
 extern int arch_setup_additional_pages(struct linux_binprm *bprm,
                                        int executable_stack);
-#endif
 
 extern unsigned int vdso_enabled;
 
-#define ARCH_DLINFO						\
-do if (vdso_enabled) {						\
-		NEW_AUX_ENT(AT_SYSINFO,	VDSO_ENTRY);		\
-		NEW_AUX_ENT(AT_SYSINFO_EHDR, VDSO_COMPAT_BASE);	\
+#define ARCH_DLINFO							\
+do if (vdso_enabled) {							\
+		NEW_AUX_ENT(AT_SYSINFO,	VDSO_ENTRY);			\
+		NEW_AUX_ENT(AT_SYSINFO_EHDR, VDSO_CURRENT_BASE);	\
 } while (0)
 
 #endif
===================================================================
--- a/include/asm-i386/fixmap.h
+++ b/include/asm-i386/fixmap.h
@@ -19,13 +19,9 @@
  * Leave one empty page between vmalloc'ed areas and
  * the start of the fixmap.
  */
-#ifndef CONFIG_COMPAT_VDSO
 extern unsigned long __FIXADDR_TOP;
-#else
-#define __FIXADDR_TOP  0xfffff000
-#define FIXADDR_USER_START	__fix_to_virt(FIX_VDSO)
-#define FIXADDR_USER_END	__fix_to_virt(FIX_VDSO - 1)
-#endif
+#define FIXADDR_USER_START     __fix_to_virt(FIX_VDSO)
+#define FIXADDR_USER_END       __fix_to_virt(FIX_VDSO - 1)
 
 #ifndef __ASSEMBLY__
 #include <linux/kernel.h>
===================================================================
--- a/include/linux/elf.h
+++ b/include/linux/elf.h
@@ -83,6 +83,23 @@ typedef __s64	Elf64_Sxword;
 #define DT_DEBUG	21
 #define DT_TEXTREL	22
 #define DT_JMPREL	23
+#define DT_ENCODING	32
+#define OLD_DT_LOOS	0x60000000
+#define DT_LOOS		0x6000000d
+#define DT_HIOS		0x6ffff000
+#define DT_VALRNGLO	0x6ffffd00
+#define DT_VALRNGHI	0x6ffffdff
+#define DT_ADDRRNGLO	0x6ffffe00
+#define DT_ADDRRNGHI	0x6ffffeff
+#define DT_VERSYM	0x6ffffff0
+#define DT_RELACOUNT	0x6ffffff9
+#define DT_RELCOUNT	0x6ffffffa
+#define DT_FLAGS_1	0x6ffffffb
+#define DT_VERDEF	0x6ffffffc
+#define	DT_VERDEFNUM	0x6ffffffd
+#define DT_VERNEED	0x6ffffffe
+#define	DT_VERNEEDNUM	0x6fffffff
+#define OLD_DT_HIOS     0x6fffffff
 #define DT_LOPROC	0x70000000
 #define DT_HIPROC	0x7fffffff
 

-- 

