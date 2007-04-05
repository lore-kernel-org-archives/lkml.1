Return-Path: <linux-kernel-owner+w=401wt.eu-S1161196AbXDEFDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161196AbXDEFDe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 01:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161180AbXDEFDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 01:03:23 -0400
Received: from gw.goop.org ([64.81.55.164]:43269 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161182AbXDEFC4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 01:02:56 -0400
Message-Id: <20070405045843.441322903@goop.org>
References: <20070405045825.511024444@goop.org>
User-Agent: quilt/0.46-1
Date: Wed, 04 Apr 2007 21:58:27 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>, Zachary Amsden <zach@vmware.com>,
       "Jan Beulich" <JBeulich@novell.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>
Subject: [patch 2/2] Make COMPAT_VDSO runtime selectable.
Content-Disposition: inline; filename=runtime-COMPAT_VDSO-selection.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Now that relocation of the VDSO for COMPAT_VDSO users is done at
runtime rather than compile time, it is possible to enable/disable
compat mode at runtime.

This patch allows you to enable COMPAT_VDSO mode with "vdso=2" on the
kernel command line, or via sysctl.

The COMPAT_VDSO config option still exists, but if enabled it just
makes vdso_enabled default to VDSO_COMPAT.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Zachary Amsden <zach@vmware.com>
Cc: "Jan Beulich" <JBeulich@novell.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Roland McGrath <roland@redhat.com>

---
 Documentation/kernel-parameters.txt |    1 
 arch/i386/kernel/sysenter.c         |  131 ++++++++++++++++++++++-------------
 include/asm-i386/page.h             |    2 
 3 files changed, 84 insertions(+), 50 deletions(-)

===================================================================
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1807,6 +1807,7 @@ and is between 256 and 4096 characters. 
 			[USBHID] The interval which mice are to be polled at.
 
 	vdso=		[IA-32,SH]
+			vdso=2: enable compat VDSO (default with COMPAT_VDSO)
 			vdso=1: enable VDSO (default)
 			vdso=0: disable VDSO mapping
 
===================================================================
--- a/arch/i386/kernel/sysenter.c
+++ b/arch/i386/kernel/sysenter.c
@@ -24,11 +24,23 @@
 #include <asm/unistd.h>
 #include <asm/elf.h>
 
+enum {
+	VDSO_DISABLED = 0,
+	VDSO_ENABLED = 1,
+	VDSO_COMPAT = 2,
+};
+
+#ifdef CONFIG_COMPAT_VDSO
+#define VDSO_DEFAULT	VDSO_COMPAT
+#else
+#define VDSO_DEFAULT	VDSO_ENABLED
+#endif
+
 /*
  * Should the kernel map a VDSO page into processes and pass its
  * address down to glibc upon exec()?
  */
-unsigned int __read_mostly vdso_enabled = 1;
+unsigned int __read_mostly vdso_enabled = VDSO_DEFAULT;
 
 EXPORT_SYMBOL_GPL(vdso_enabled);
 
@@ -43,7 +55,6 @@ __setup("vdso=", vdso_setup);
 
 extern asmlinkage void sysenter_entry(void);
 
-#ifdef CONFIG_COMPAT_VDSO
 static __cpuinit void reloc_dyn(Elf32_Ehdr *ehdr, unsigned offset)
 {
 	Elf32_Dyn *dyn = (void *)ehdr + offset;
@@ -85,11 +96,6 @@ static __cpuinit void relocate_vdso(Elf3
 			reloc_dyn(ehdr, phdr[i].p_offset);
 	}
 }
-#else
-static inline void relocate_vdso(Elf32_Ehdr *ehdr)
-{
-}
-#endif	/* COMPAT_VDSO */
 
 void enable_sep_cpu(void)
 {
@@ -109,6 +115,25 @@ void enable_sep_cpu(void)
 	put_cpu();	
 }
 
+static struct vm_area_struct gate_vma;
+
+static int __cpuinit gate_vma_init(void)
+{
+	gate_vma.vm_mm = NULL;
+	gate_vma.vm_start = FIXADDR_USER_START;
+	gate_vma.vm_end = FIXADDR_USER_END;
+	gate_vma.vm_flags = VM_READ | VM_MAYREAD | VM_EXEC | VM_MAYEXEC;
+	gate_vma.vm_page_prot = __P101;
+	/*
+	 * Make sure the vDSO gets into every core dump.
+	 * Dumping its contents makes post-mortem fully interpretable later
+	 * without matching up the same kernel and hardware config to see
+	 * what PC values meant.
+	 */
+	gate_vma.vm_flags |= VM_ALWAYSDUMP;
+	return 0;
+}
+
 /*
  * These symbols are defined by vsyscall.o to mark the bounds
  * of the ELF DSO images included therein.
@@ -117,6 +142,19 @@ extern const char vsyscall_sysenter_star
 extern const char vsyscall_sysenter_start, vsyscall_sysenter_end;
 static struct page *syscall_pages[1];
 
+static void map_compat_vdso(int map)
+{
+	static int vdso_mapped;
+
+	if (map == vdso_mapped)
+		return;
+
+	vdso_mapped = map;
+
+	__set_fixmap(FIX_VDSO, page_to_pfn(syscall_pages[0]) << PAGE_SHIFT,
+		     map ? PAGE_READONLY_EXEC : PAGE_NONE);
+}
+
 int __cpuinit sysenter_setup(void)
 {
 	void *syscall_page = (void *)get_zeroed_page(GFP_ATOMIC);
@@ -125,10 +163,9 @@ int __cpuinit sysenter_setup(void)
 
 	syscall_pages[0] = virt_to_page(syscall_page);
 
-#ifdef CONFIG_COMPAT_VDSO
-	__set_fixmap(FIX_VDSO, __pa(syscall_page), PAGE_READONLY_EXEC);
+	gate_vma_init();
+
 	printk("Compat vDSO mapped to %08lx.\n", __fix_to_virt(FIX_VDSO));
-#endif
 
 	if (!boot_cpu_has(X86_FEATURE_SEP)) {
 		vsyscall = &vsyscall_int80_start;
@@ -147,7 +184,6 @@ int __cpuinit sysenter_setup(void)
 /* Defined in vsyscall-sysenter.S */
 extern void SYSENTER_RETURN;
 
-#ifdef __HAVE_ARCH_GATE_AREA
 /* Setup a VMA at program startup for the vsyscall page */
 int arch_setup_additional_pages(struct linux_binprm *bprm, int exstack)
 {
@@ -156,33 +192,44 @@ int arch_setup_additional_pages(struct l
 	int ret;
 
 	down_write(&mm->mmap_sem);
-	addr = get_unmapped_area(NULL, 0, PAGE_SIZE, 0, 0);
-	if (IS_ERR_VALUE(addr)) {
-		ret = addr;
-		goto up_fail;
-	}
-
-	/*
-	 * MAYWRITE to allow gdb to COW and set breakpoints
-	 *
-	 * Make sure the vDSO gets into every core dump.
-	 * Dumping its contents makes post-mortem fully interpretable later
-	 * without matching up the same kernel and hardware config to see
-	 * what PC values meant.
-	 */
-	ret = install_special_mapping(mm, addr, PAGE_SIZE,
-				      VM_READ|VM_EXEC|
-				      VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC|
-				      VM_ALWAYSDUMP,
-				      syscall_pages);
-	if (ret)
-		goto up_fail;
+
+	map_compat_vdso(vdso_enabled == VDSO_COMPAT);
+
+	if (vdso_enabled == VDSO_COMPAT)
+		addr = VDSO_HIGH_BASE;
+	else {
+		addr = get_unmapped_area(NULL, 0, PAGE_SIZE, 0, 0);
+		if (IS_ERR_VALUE(addr)) {
+			ret = addr;
+			goto up_fail;
+		}
+
+		/*
+		 * MAYWRITE to allow gdb to COW and set breakpoints
+		 *
+		 * Make sure the vDSO gets into every core dump.
+		 * Dumping its contents makes post-mortem fully
+		 * interpretable later without matching up the same
+		 * kernel and hardware config to see what PC values
+		 * meant.
+		 */
+		ret = install_special_mapping(mm, addr, PAGE_SIZE,
+					      VM_READ|VM_EXEC|
+					      VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC|
+					      VM_ALWAYSDUMP,
+					      syscall_pages);
+
+		if (ret)
+			goto up_fail;
+	}
 
 	current->mm->context.vdso = (void *)addr;
 	current_thread_info()->sysenter_return =
-				    (void *)VDSO_SYM(&SYSENTER_RETURN);
-up_fail:
+		(void *)VDSO_SYM(&SYSENTER_RETURN);
+
+  up_fail:
 	up_write(&mm->mmap_sem);
+
 	return ret;
 }
 
@@ -195,6 +242,8 @@ const char *arch_vma_name(struct vm_area
 
 struct vm_area_struct *get_gate_vma(struct task_struct *tsk)
 {
+	if (vdso_enabled == VDSO_COMPAT)
+		return &gate_vma;
 	return NULL;
 }
 
@@ -207,17 +256,3 @@ int in_gate_area_no_task(unsigned long a
 {
 	return 0;
 }
-#else  /* !__HAVE_ARCH_GATE_AREA */
-int arch_setup_additional_pages(struct linux_binprm *bprm, int exstack)
-{
-	/*
-	 * If not creating userspace VMA, simply set vdso to point to
-	 * fixmap page.
-	 */
-	current->mm->context.vdso = (void *)VDSO_HIGH_BASE;
-	current_thread_info()->sysenter_return =
-		(void *)VDSO_SYM(&SYSENTER_RETURN);
-
-	return 0;
-}
-#endif	/* __HAVE_ARCH_GATE_AREA */
===================================================================
--- a/include/asm-i386/page.h
+++ b/include/asm-i386/page.h
@@ -143,9 +143,7 @@ extern int page_is_ram(unsigned long pag
 #include <asm-generic/memory_model.h>
 #include <asm-generic/page.h>
 
-#ifndef CONFIG_COMPAT_VDSO
 #define __HAVE_ARCH_GATE_AREA 1
-#endif
 #endif /* __KERNEL__ */
 
 #endif /* _I386_PAGE_H */

-- 

