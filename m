Return-Path: <linux-kernel-owner+w=401wt.eu-S1752369AbXCPCrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369AbXCPCrp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 22:47:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752393AbXCPCrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 22:47:45 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:44746 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752360AbXCPCro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 22:47:44 -0400
Message-ID: <45FA054F.6020107@vmware.com>
Date: Thu, 15 Mar 2007 18:47:43 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Jan Beulich <jbeulich@novell.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Chris Wright <chrisw@sous-sol.org>, Andrew Morton <akpm@osdl.org>,
       Linus Torvalds <torvalds@osdl.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>
Subject: [RFC, PATCH] Fixup COMPAT_VDSO to work with CONFIG_PARAVIRT
Content-Type: multipart/mixed;
 boundary="------------000201050106080000030407"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000201050106080000030407
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Paravirt-ops guests which move the fixmap also end up moving the syscall 
VDSO.  This fails if it is prelinked at a fixed address, which is why 
COMPAT_VDSO is broken under CONFIG_VMI (and also under CONFIG_XEN).  
Several options are available to try to address this.  Jan had cooked up 
a patch for Xen that used build magic to find the parts of the VDSO that 
need relocation.  I don't like the idea of having auto-generated 
relocations, as someday something could change between two linked 
objects (timestamp, elf notes perhaps) that is not a relocation.  So I 
prefer human supervision over the relocation and explicitly fixing 
everything by hand.  I'm not necessarily advocating one solution over 
the other; my way is more code to maintain if the VDSO linkage changes.  
I'm looking for feedback about which way is best.

Also, it appears that COMPAT_VDSO could disappear entirely.  Since this 
approach should work with older broken ld.so (2.3.2 is the version, I 
believe), we should be able to switch over completely to using the gate 
vma style of linking the vdso.  One can even get the address 
randomization benefits by simply running fixup on the vdso if you are 
prepared to take the cost of allocating an extra page per process.  Or 
you could randomize just once at boot, which makes the randomization 
per-machine, still sufficient to slow network based worm attacks which 
might rely on a fixed VDSO address.

Clearly this patch needs more testing and feedback, which I'm sure it 
will get...

<zach ducks>

Zach

P.S. - Eric, I've copied you as you appear to be an ELF expert, or at 
least have a greater grasp of Elven Magic than me, and I'm hoping I got 
all the dynamic tags which need relocation right.

--------------000201050106080000030407
Content-Type: text/plain;
 name="vdso-relocation-for-paravirt.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="vdso-relocation-for-paravirt.patch"

Invoke black magic to relocate the VDSO even when COMPAT_VDSO is enabled
by fixing up the ELF object.

Signed-off-by: Zachary Amsden <zach@vmware.com>

Index: linux-2.6.21/arch/i386/kernel/entry.S
===================================================================
--- linux-2.6.21.orig/arch/i386/kernel/entry.S	2007-03-06 18:51:33.000000000 -0800
+++ linux-2.6.21/arch/i386/kernel/entry.S	2007-03-15 18:14:11.000000000 -0800
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
 
Index: linux-2.6.21/arch/i386/kernel/sysenter.c
===================================================================
--- linux-2.6.21.orig/arch/i386/kernel/sysenter.c	2007-03-06 18:51:34.000000000 -0800
+++ linux-2.6.21/arch/i386/kernel/sysenter.c	2007-03-15 18:27:43.000000000 -0800
@@ -72,6 +72,99 @@ extern const char vsyscall_int80_start, 
 extern const char vsyscall_sysenter_start, vsyscall_sysenter_end;
 static struct page *syscall_pages[1];
 
+#ifdef CONFIG_COMPAT_VDSO
+static void fixup_vsyscall_elf(char *page)
+{
+	Elf32_Ehdr *hdr;
+	Elf32_Shdr *sechdrs;
+	Elf32_Phdr *phdr;
+	char *secstrings;
+	int i, j, n;
+
+	hdr = (Elf32_Ehdr *)page;
+	
+	printk("Remapping vsyscall page to %08x\n", (unsigned int)VDSO_HIGH_BASE);
+
+	/* Sanity checks against insmoding binaries or wrong arch,
+           weird elf version */
+	if (memcmp(hdr->e_ident, ELFMAG, 4) != 0 ||
+		!elf_check_arch(hdr) ||
+		hdr->e_type != ET_DYN)
+		panic("Bogus ELF in vsyscall DSO\n");
+
+	hdr->e_entry += VDSO_HIGH_BASE;
+	sechdrs = (void *)hdr + hdr->e_shoff;
+	secstrings = (void *)hdr + sechdrs[hdr->e_shstrndx].sh_offset;
+
+	for (i = 1; i < hdr->e_shnum; i++) {
+		if (!(sechdrs[i].sh_flags & SHF_ALLOC))
+			continue;
+
+		sechdrs[i].sh_addr += VDSO_HIGH_BASE;
+		if (strcmp(secstrings+sechdrs[i].sh_name, ".dynsym") == 0) {
+			Elf32_Sym  *sym =  (void *)hdr + sechdrs[i].sh_offset;
+			n = sechdrs[i].sh_size / sizeof(*sym);
+			for (j = 1; j < n;  j++) {
+				int ndx = sym[j].st_shndx;
+				if (ndx == SHN_UNDEF || ndx == SHN_ABS)
+					continue;
+				sym[j].st_value += VDSO_HIGH_BASE;
+			}
+		} else if (strcmp(secstrings+sechdrs[i].sh_name, ".dynamic") == 0) {
+			Elf32_Dyn *dyn = (void *)hdr + sechdrs[i].sh_offset;
+			int tag;
+			while ((tag = (++dyn)->d_tag) != DT_NULL)
+			switch(tag) {
+				case DT_PLTGOT:
+				case DT_HASH:
+			    	case DT_STRTAB:
+				case DT_SYMTAB:
+				case DT_RELA:
+				case DT_INIT:
+				case DT_FINI:
+				case DT_REL:
+				case DT_JMPREL:
+				case DT_VERSYM:
+				case DT_VERDEF:
+				case DT_VERNEED:
+					dyn->d_un.d_val += VDSO_HIGH_BASE;
+			}
+		} else if (strcmp(secstrings+sechdrs[i].sh_name, ".useless") == 0) {
+			/* This is demonic; see vsyscall.lds.S; it puts the
+			 * .got in a section named .useless */
+			uint32_t *got = (void *)hdr + sechdrs[i].sh_offset;
+			*got += VDSO_HIGH_BASE;
+		}
+	}
+	phdr = (void *)hdr + hdr->e_phoff;
+	for (i = 0; i < hdr->e_phnum; i++) {
+		phdr[i].p_vaddr += VDSO_HIGH_BASE;
+		phdr[i].p_paddr += VDSO_HIGH_BASE;
+	}
+
+#if 0
+/* 
+ * To verify the binary image in memory is identical, linked in the VDSO page
+ * from a COMPAT_VDSO compile without this patch; then diff the two.  For a
+ * non-relocated fixmap, the VDSO image is identical.
+ */
+{
+	extern const char vsyscall_orig_start, vsyscall_orig_end;
+	int *l1 = (int *)page, *l2 = (int *)&vsyscall_orig_start;
+	int foo = vsyscall_orig_end - vsyscall_orig_start / 4;
+	for (i = 0; i < foo; i++) {
+		if (l1[i] != l2[i]) {
+			printk("vsyscall - delta [%03x] orig %08x new %08x\n",
+				i, l2[i], l1[i]);
+		}
+	}
+}
+#endif
+}
+#else /* !CONFIG_COMPAT_VDSO */
+static inline void fixup_vsyscall_elf(char *page) {}
+#endif /* CONFIG_COMPAT_VDSO */
+
 int __init sysenter_setup(void)
 {
 	void *syscall_page = (void *)get_zeroed_page(GFP_ATOMIC);
@@ -86,20 +179,22 @@ int __init sysenter_setup(void)
 		memcpy(syscall_page,
 		       &vsyscall_int80_start,
 		       &vsyscall_int80_end - &vsyscall_int80_start);
+		fixup_vsyscall_elf((char *)syscall_page);
 		return 0;
 	}
 
 	memcpy(syscall_page,
 	       &vsyscall_sysenter_start,
 	       &vsyscall_sysenter_end - &vsyscall_sysenter_start);
+	fixup_vsyscall_elf((char *)syscall_page);
 
 	return 0;
 }
 
-#ifndef CONFIG_COMPAT_VDSO
 /* Defined in vsyscall-sysenter.S */
 extern void SYSENTER_RETURN;
 
+#ifdef __HAVE_ARCH_GATE_AREA
 /* Setup a VMA at program startup for the vsyscall page */
 int arch_setup_additional_pages(struct linux_binprm *bprm, int exstack)
 {
@@ -159,4 +254,17 @@ int in_gate_area_no_task(unsigned long a
 {
 	return 0;
 }
-#endif
+#else /* !__HAVE_ARCH_GATE_AREA */
+
+int arch_setup_additional_pages(struct linux_binprm *bprm, int exstack)
+	/*
+	 * If not creating userspace VMA, simply set vdso to point to
+	 * fixmap page.
+	 */
+	current->mm->context.vdso = (void *)VDSO_HIGH_BASE;
+	current_thread_info()->sysenter_return =
+				    (void *)VDSO_SYM(&SYSENTER_RETURN);
+
+	return 0;
+}
+#endif /* __HAVE_ARCH_GATE_AREA */
Index: linux-2.6.21/arch/i386/mm/pgtable.c
===================================================================
--- linux-2.6.21.orig/arch/i386/mm/pgtable.c	2007-03-06 18:51:34.000000000 -0800
+++ linux-2.6.21/arch/i386/mm/pgtable.c	2007-03-15 18:14:11.000000000 -0800
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
Index: linux-2.6.21/include/asm-i386/elf.h
===================================================================
--- linux-2.6.21.orig/include/asm-i386/elf.h	2007-03-06 18:52:03.000000000 -0800
+++ linux-2.6.21/include/asm-i386/elf.h	2007-03-15 18:14:11.000000000 -0800
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
-#define ARCH_HAS_SETUP_ADDITIONAL_PAGES
 struct linux_binprm;
+
+#define ARCH_HAS_SETUP_ADDITIONAL_PAGES
 extern int arch_setup_additional_pages(struct linux_binprm *bprm,
                                        int executable_stack);
-#endif
 
 extern unsigned int vdso_enabled;
 
 #define ARCH_DLINFO						\
 do if (vdso_enabled) {						\
 		NEW_AUX_ENT(AT_SYSINFO,	VDSO_ENTRY);		\
-		NEW_AUX_ENT(AT_SYSINFO_EHDR, VDSO_COMPAT_BASE);	\
+		NEW_AUX_ENT(AT_SYSINFO_EHDR, VDSO_CURRENT_BASE);\
 } while (0)
 
 #endif
Index: linux-2.6.21/include/asm-i386/fixmap.h
===================================================================
--- linux-2.6.21.orig/include/asm-i386/fixmap.h	2007-03-06 18:52:03.000000000 -0800
+++ linux-2.6.21/include/asm-i386/fixmap.h	2007-03-15 18:14:11.000000000 -0800
@@ -19,13 +19,9 @@
  * Leave one empty page between vmalloc'ed areas and
  * the start of the fixmap.
  */
-#ifndef CONFIG_COMPAT_VDSO
 extern unsigned long __FIXADDR_TOP;
-#else
-#define __FIXADDR_TOP  0xfffff000
 #define FIXADDR_USER_START	__fix_to_virt(FIX_VDSO)
 #define FIXADDR_USER_END	__fix_to_virt(FIX_VDSO - 1)
-#endif
 
 #ifndef __ASSEMBLY__
 #include <linux/kernel.h>
Index: linux-2.6.21/include/linux/elf.h
===================================================================
--- linux-2.6.21.orig/include/linux/elf.h	2007-03-06 18:52:08.000000000 -0800
+++ linux-2.6.21/include/linux/elf.h	2007-03-15 18:14:11.000000000 -0800
@@ -83,6 +83,9 @@ typedef __s64	Elf64_Sxword;
 #define DT_DEBUG	21
 #define DT_TEXTREL	22
 #define DT_JMPREL	23
+#define DT_VERSYM	0x6ffffff0
+#define DT_VERDEF	0x6ffffffc
+#define DT_VERNEED	0x6ffffffe
 #define DT_LOPROC	0x70000000
 #define DT_HIPROC	0x7fffffff
 

--------------000201050106080000030407--
