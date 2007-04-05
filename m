Return-Path: <linux-kernel-owner+w=401wt.eu-S1946086AbXDEITH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946086AbXDEITH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 04:19:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946092AbXDEITG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 04:19:06 -0400
Received: from gw.goop.org ([64.81.55.164]:53812 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946086AbXDEITB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 04:19:01 -0400
Message-ID: <4614B0DB.7040003@goop.org>
Date: Thu, 05 Apr 2007 01:18:35 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Jan Beulich <jbeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, Andi Kleen <ak@suse.de>,
       lkml <linux-kernel@vger.kernel.org>, Zachary Amsden <zach@vmware.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patch 1/2] Relocate VDSO ELF headers to match mapped	location
 with COMPAT_VDSO
References: <20070405081415.E59E6180055@magilla.sf.frob.com>
In-Reply-To: <20070405081415.E59E6180055@magilla.sf.frob.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath wrote:
>> In addition to Roland's remarks about missing symbol table relocation, I
>> would also assume section headers, if present, should be relocated.
>>     
>
> Yes, and also the .symtab as well as .dynsym just in case one ever has one
> (though I think they are built stripped now, it's not hard to check sh_type
> for SHT_SYMTAB and call the same routine that works from DT_SYMTAB).
>   

OK, how does this look?  Does it need to worry about DT_REL/DT_RELA
tags? (Not that there are any.)

    J

Subject: Relocate VDSO ELF headers to match mapped location with COMPAT_VDSO

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
  rather than sections. ]

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Zachary Amsden <zach@vmware.com>
Cc: "Jan Beulich" <JBeulich@novell.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Roland McGrath <roland@redhat.com>

---
 arch/i386/kernel/entry.S    |    4 -
 arch/i386/kernel/sysenter.c |   95 ++++++++++++++++++++++++++++++++++++-------
 arch/i386/mm/pgtable.c      |    6 --
 include/asm-i386/elf.h      |   28 ++++--------
 include/asm-i386/fixmap.h   |    8 ---
 include/linux/elf.h         |    3 +
 6 files changed, 95 insertions(+), 49 deletions(-)

diff -r 97a792fb6127 arch/i386/kernel/entry.S
--- a/arch/i386/kernel/entry.S	Wed Apr 04 23:26:37 2007 -0700
+++ b/arch/i386/kernel/entry.S	Thu Apr 05 01:11:25 2007 -0700
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
 
diff -r 97a792fb6127 arch/i386/kernel/sysenter.c
--- a/arch/i386/kernel/sysenter.c	Wed Apr 04 23:26:37 2007 -0700
+++ b/arch/i386/kernel/sysenter.c	Thu Apr 05 01:11:25 2007 -0700
@@ -22,6 +22,7 @@
 #include <asm/msr.h>
 #include <asm/pgtable.h>
 #include <asm/unistd.h>
+#include <asm/elf.h>
 
 /*
  * Should the kernel map a VDSO page into processes and pass its
@@ -41,6 +42,102 @@ __setup("vdso=", vdso_setup);
 __setup("vdso=", vdso_setup);
 
 extern asmlinkage void sysenter_entry(void);
+
+#ifdef CONFIG_COMPAT_VDSO
+static __cpuinit void reloc_symtab(Elf32_Ehdr *ehdr,
+				   unsigned offset, unsigned size)
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
+struct elfhash {
+	Elf32_Word nbucket, nchain;
+};
+
+static __cpuinit void reloc_dyn(Elf32_Ehdr *ehdr, unsigned offset)
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
+		case DT_ENCODING ... DT_HIOS:
+			/* tags above DT_ENCODING are even if they're
+			   a pointer, so skip odd ones */
+			if (dyn->d_tag >= DT_ENCODING &&
+			    (dyn->d_tag & 1) == 1)
+				break;
+
+			dyn->d_un.d_ptr += VDSO_HIGH_BASE;
+		}
+}
+
+static __cpuinit void relocate_vdso(Elf32_Ehdr *ehdr)
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
@@ -71,6 +168,9 @@ int __cpuinit sysenter_setup(void)
 int __cpuinit sysenter_setup(void)
 {
 	void *syscall_page = (void *)get_zeroed_page(GFP_ATOMIC);
+	const void *vsyscall;
+	size_t vsyscall_len;
+
 	syscall_pages[0] = virt_to_page(syscall_page);
 
 #ifdef CONFIG_COMPAT_VDSO
@@ -79,23 +179,23 @@ int __cpuinit sysenter_setup(void)
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
@@ -155,4 +255,17 @@ int in_gate_area_no_task(unsigned long a
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
diff -r 97a792fb6127 arch/i386/mm/pgtable.c
--- a/arch/i386/mm/pgtable.c	Wed Apr 04 23:26:37 2007 -0700
+++ b/arch/i386/mm/pgtable.c	Thu Apr 05 01:11:25 2007 -0700
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
diff -r 97a792fb6127 include/asm-i386/elf.h
--- a/include/asm-i386/elf.h	Wed Apr 04 23:26:37 2007 -0700
+++ b/include/asm-i386/elf.h	Thu Apr 05 01:11:25 2007 -0700
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
diff -r 97a792fb6127 include/asm-i386/fixmap.h
--- a/include/asm-i386/fixmap.h	Wed Apr 04 23:26:37 2007 -0700
+++ b/include/asm-i386/fixmap.h	Thu Apr 05 01:11:25 2007 -0700
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
diff -r 97a792fb6127 include/linux/elf.h
--- a/include/linux/elf.h	Wed Apr 04 23:26:37 2007 -0700
+++ b/include/linux/elf.h	Thu Apr 05 01:11:25 2007 -0700
@@ -83,6 +83,12 @@ typedef __s64	Elf64_Sxword;
 #define DT_DEBUG	21
 #define DT_TEXTREL	22
 #define DT_JMPREL	23
+#define DT_ENCODING	32
+#define DT_LOOS		0x6000000D
+#define DT_HIOS		0x6ffff000
+#define DT_VERSYM	0x6ffffff0
+#define DT_VERDEF	0x6ffffffc
+#define DT_VERNEED	0x6ffffffe
 #define DT_LOPROC	0x70000000
 #define DT_HIPROC	0x7fffffff
 


