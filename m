Return-Path: <linux-kernel-owner+w=401wt.eu-S1758577AbXFUAct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758577AbXFUAct (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 20:32:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758176AbXFUAcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 20:32:20 -0400
Received: from bay-wan-b-65.sfo.dsl.cerfnet.com ([216.148.65.65]:46216 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753886AbXFUAcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 20:32:18 -0400
Message-Id: <20070620231853.404008559@goop.org>
References: <20070620231726.834538992@goop.org>
User-Agent: quilt/0.46-1
Date: Wed, 20 Jun 2007 16:17:35 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: Vivek Goyal <vgoyal@in.ibm.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Andi Kleen <ak@suse.de>,
       v12n <virtualization@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 9/9] xen: use boot protocol to boot xen kernel
Content-Disposition: inline; filename=xen-paravirt-boot.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Boot a Xen kernel using the boot protocol.  There are two parts to this:

1. Add Xen-specific notes to the bzImage's internal ELF file, so that
   the Xen domain builder knows what to do with it.  This is simply a
   matter of adding a new notes-xen.S to the image.  The notes depend
   on the config options, but they contain no addresses, so there's no
   concern about relocation, or references into the kernel image itself.

2. Do the early setup after booting, mainly to remap the kernel to
   the proper virtual address.  The kernel initially comes up with
   a P=V 1:1 mapping.  We need to copy the appropriate internal pagetable
   pointers to get the kernel also mapped at __PAGE_OFFSET.  In order
   to simplify this process, we just keep the same pte pages, and only
   update the pgd/pmd entries (depending on whether its PAE or not, and
   whether the kernel and Xen want to share the same pgd slot).

   A pre-requisite for updating the pagetables is setting up the
   hypercall page in order to do hypercalls.  Rather than using the
   Xen Notes to set this up (which would require a relocatable
   reference from the bzImage notes into the kernel), we use the Xen
   reserved MSR to set the page address.

   Once the kernel has been relocated, we update some of the pointers
   in the start_info to kernel virtual addresses, and then jump to
   xen_start_kernel() to do the rest of the setup before calling
   start_kernel() proper.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

---
 arch/i386/boot/compressed/Makefile    |    4 
 arch/i386/boot/compressed/notes-xen.c |   17 ++
 arch/i386/kernel/head.S               |    2 
 arch/i386/xen/Makefile                |    2 
 arch/i386/xen/early.c                 |  216 +++++++++++++++++++++++++++++++++
 arch/i386/xen/enlighten.c             |   29 +---
 arch/i386/xen/xen-head.S              |   38 -----
 arch/i386/xen/xen-ops.h               |    1 
 include/asm-i386/xen/hypercall.h      |    4 
 9 files changed, 252 insertions(+), 61 deletions(-)

===================================================================
--- a/arch/i386/boot/compressed/Makefile
+++ b/arch/i386/boot/compressed/Makefile
@@ -5,7 +5,7 @@
 #
 
 targets		:= blob vmlinux.bin vmlinux.bin.gz \
-			elfhdr.o head.o misc.o notes.o piggy.o \
+			elfhdr.o head.o misc.o notes.o notes-xen.o piggy.o \
 			vmlinux.bin.all vmlinux.relocs
 
 hostprogs-y	:= relocs
@@ -16,7 +16,7 @@ CFLAGS  := -m32 -D__KERNEL__ $(LINUX_INC
 	   $(call cc-option,-fno-stack-protector)
 LDFLAGS := -R $(obj)/vmlinux-syms --defsym IMAGE_OFFSET=$(IMAGE_OFFSET) -T
 
-OBJS=$(addprefix $(obj)/,elfhdr.o head.o misc.o notes.o piggy.o)
+OBJS=$(addprefix $(obj)/,elfhdr.o head.o misc.o notes.o notes-xen.o piggy.o)
 
 $(obj)/blob: $(src)/vmlinux.lds $(obj)/vmlinux-syms $(OBJS) FORCE
 	$(call if_changed,ld)
===================================================================
--- /dev/null
+++ b/arch/i386/boot/compressed/notes-xen.c
@@ -0,0 +1,17 @@
+#ifdef CONFIG_XEN
+#include <linux/elfnote.h>
+#include <xen/interface/elfnote.h>
+
+ELFNOTE("Xen", XEN_ELFNOTE_GUEST_OS,       "linux");
+ELFNOTE("Xen", XEN_ELFNOTE_GUEST_VERSION,  "2.6");
+ELFNOTE("Xen", XEN_ELFNOTE_XEN_VERSION,    "xen-3.0");
+ELFNOTE("Xen", XEN_ELFNOTE_FEATURES,
+	"!writable_page_tables|pae_pgdir_above_4gb");
+ELFNOTE("Xen", XEN_ELFNOTE_LOADER,         "generic");
+
+#ifdef CONFIG_X86_PAE
+	ELFNOTE("Xen", XEN_ELFNOTE_PAE_MODE,       "yes");
+#else
+	ELFNOTE("Xen", XEN_ELFNOTE_PAE_MODE,       "no");
+#endif
+#endif
===================================================================
--- a/arch/i386/kernel/head.S
+++ b/arch/i386/kernel/head.S
@@ -594,8 +594,6 @@ fault_msg:
 	.ascii "Int %d: CR2 %p  err %p  EIP %p  CS %p  flags %p\n"
 	.asciz "Stack: %p %p %p %p %p %p %p %p\n"
 
-#include "../xen/xen-head.S"
-
 /*
  * The IDT and GDT 'descriptors' are a strange 48-bit object
  * only used by the lidt and lgdt instructions. They are not
===================================================================
--- a/arch/i386/xen/Makefile
+++ b/arch/i386/xen/Makefile
@@ -1,4 +1,4 @@ obj-y		:= enlighten.o setup.o features.o
-obj-y		:= enlighten.o setup.o features.o multicalls.o mmu.o \
+obj-y		:= early.o enlighten.o setup.o features.o multicalls.o mmu.o \
 			events.o time.o manage.o xen-asm.o
 
 obj-$(CONFIG_SMP)	+= smp.o
===================================================================
--- /dev/null
+++ b/arch/i386/xen/early.c
@@ -0,0 +1,216 @@
+/*
+ * Very earliest code, run before we're in the kernel virtual address
+ * space.  As a result, we need to be careful about touching static
+ * symbols or any absolute address.
+ */
+
+#include <linux/types.h>
+#include <linux/bug.h>
+#include <linux/sched.h>
+
+#include <asm/bootparam.h>
+#include <asm/setup.h>
+#include <asm/paravirt.h>
+#include <asm/pgtable.h>
+
+#include <xen/interface/xen.h>
+#include <xen/page.h>
+#include <asm/xen/interface.h>
+#include <asm/xen/hypercall.h>
+
+#include "xen-ops.h"
+
+#define PA(ptr)	((typeof(ptr)) __pa_symbol((ptr)))
+
+extern char _end[];
+
+static inline void early_cpuid(unsigned int *eax, unsigned int *ebx,
+			       unsigned int *ecx, unsigned int *edx)
+{
+	asm(XEN_EMULATE_PREFIX "cpuid"
+		: "=a" (*eax),
+		  "=b" (*ebx),
+		  "=c" (*ecx),
+		  "=d" (*edx)
+		: "0" (*eax), "2" (*ecx));
+}
+
+static __init u64 early_p2m(unsigned long *mfn_list,
+			    unsigned long phys)
+{
+	unsigned offset = phys & ~PAGE_MASK;
+	return PFN_PHYS((u64)mfn_list[PFN_DOWN(phys)]) + offset;
+}
+
+static __init unsigned long early_m2p(unsigned long mfn)
+{
+	unsigned long ret = machine_to_phys_mapping[mfn];
+	if (ret == ~0)
+		ret = 0;
+	return ret;
+}
+
+static __init void setup_hypercall_page(struct start_info *info)
+{
+	unsigned long *mfn_list = (unsigned long *)info->mfn_list;
+	unsigned eax, ebx, ecx, edx;
+	unsigned long hypercall_mfn;
+
+	/* leaf 0x40000000 is a virtual machine leaf */
+	eax = 0x40000000;
+	ecx = 0;
+	early_cpuid(&eax, &ebx, &ecx, &edx);
+
+	/* No way we should be able to get here without being under Xen */
+	if (ebx != 0x566e6558 || /* Signature 1: "XenV" */
+	    ecx != 0x65584d4d || /* Signature 2: "MMXe" */
+	    edx != 0x4d4d566e || /* Signature 3: "nVMM" */
+	    eax < 0x40000002)
+		BUG();
+
+	/* Get the number of hypercall pages (we only need 1) and the
+	   Xen MSR base */
+	eax = 0x40000002;
+	early_cpuid(&eax, &ebx, &ecx, &edx);
+
+	/* Use magic msr to set the address of the hypercall page */
+	hypercall_mfn = PFN_DOWN(__pa_symbol(hypercall_page));
+	if (mfn_list)
+		hypercall_mfn = mfn_list[hypercall_mfn];
+
+	native_write_msr(ebx + 0, ((u64)hypercall_mfn) << PAGE_SHIFT);
+}
+
+static __init pmd_t *get_pmd(pgd_t *pgd, unsigned long addr)
+{
+	unsigned idx = pgd_index(addr);
+	pmd_t *ret;
+
+#ifdef CONFIG_X86_PAE
+	{
+		unsigned long pfn;
+		pfn = PFN_DOWN(pgd_val_ma(pgd[idx]));
+		pfn = machine_to_phys_mapping[pfn];
+
+		ret = ((pmd_t *)PFN_PHYS(pfn)) + pmd_index(addr);
+	}
+#else
+	ret = (pmd_t *)&pgd[idx];
+#endif
+
+	return ret;
+}
+
+static __init void copy_mapping(struct start_info *info, void *src, void *dst)
+{
+	unsigned long *mfn_list = (unsigned long *)info->mfn_list;
+	struct mmu_update u;
+
+	u.ptr = early_p2m(mfn_list, (unsigned long)dst);
+	u.val = pte_val_ma(*(pte_t *)src);
+
+	if (HYPERVISOR_mmu_update(&u, 1, NULL, DOMID_SELF) != 0)
+		BUG();
+}
+
+static __init void remap_addr_pmd(struct start_info *info, unsigned long addr)
+{
+	pgd_t *pgd = (pgd_t *)info->pt_base;
+	pmd_t *src = get_pmd(pgd, addr);
+	pmd_t *dst = get_pmd(pgd, addr + __PAGE_OFFSET);
+
+	copy_mapping(info, src, dst);
+}
+
+static __init void remap_kernel_pmd(struct start_info *info,
+				    unsigned long addr, unsigned long max)
+{
+	while (addr < max) {
+		remap_addr_pmd(info, addr);
+		addr += PMD_SIZE;
+	}
+}
+
+static __init void remap_addr_pgd(struct start_info *info, unsigned long addr)
+{
+	pgd_t *pgd = (pgd_t *)info->pt_base;
+	pgd_t *src = &pgd[pgd_index(addr)];
+	pgd_t *dst = &pgd[pgd_index(addr + __PAGE_OFFSET)];
+
+	copy_mapping(info, src, dst);
+}
+
+static __init void remap_kernel_pgd(struct start_info *info,
+				    unsigned long addr, unsigned long max)
+{
+	while (addr < max) {
+		remap_addr_pgd(info, addr);
+		addr += PGDIR_SIZE;
+	}
+}
+
+static __init void remap_kernel(struct start_info *info,
+				unsigned long start, unsigned long max)
+{
+	pgd_t *pgd = (pgd_t *)info->pt_base;
+
+#ifdef CONFIG_X86_PAE
+	/*
+	 * If we're running PAE, the kernel will probably want to be
+	 * mapped into the same pgd slot as Xen.  If so, we need to
+	 * copy the pmd entries rather than the pgd entries.  If not,
+	 * either the kernel doesn't want to be at the top of the
+	 * address space, or Xen has decided not to reserve any space;
+	 * in that case, we can just clone the pgd entries.
+	 */
+	if (pgd_val_ma(pgd[pgd_index(__PAGE_OFFSET)]) != 0) {
+		remap_kernel_pmd(info, start, max);
+		return;
+	}
+#endif
+
+	remap_kernel_pgd(info, start, max);
+}
+
+void __init xen_entry(void)
+{
+	struct start_info *info;
+	unsigned long limit;
+
+	info = (struct start_info *)(unsigned long)
+		(PA(&boot_params)->hdr.hardware_subarch_data);
+
+	BUG_ON(memcmp(info->magic, PA(&"xen-3.0"), 7) != 0);
+
+	/* establish a hypercall page */
+	setup_hypercall_page(info);
+
+	/* work out how far we need to remap */
+	limit = __pa(_end);
+	limit = max(limit, info->pt_base + (info->nr_pt_frames * PAGE_SIZE));
+	limit = max(limit, info->mfn_list +
+		    (info->nr_pages * sizeof(unsigned long)));
+	if (info->mod_start)
+		limit = max(limit, info->mod_start + info->mod_len);
+	limit = max(limit, early_m2p(info->console.domU.mfn) << PAGE_SHIFT);
+	limit = max(limit, early_m2p(info->store_mfn) << PAGE_SHIFT);
+
+	limit += PAGE_SIZE;
+
+	/* remap the kernel to its virtual address */
+	remap_kernel(info, 0, limit);
+
+	/* repoint things to their new virtual addresses */
+	info->pt_base = (unsigned long)__va(info->pt_base);
+	info->mfn_list = (unsigned long)__va(info->mfn_list);
+
+	init_pg_tables_end = limit;
+
+	asm volatile("mov %0,%%esp;"
+		     "push $0;"
+		     "jmp *%1"
+		     :
+		     : "i" (&init_thread_union.stack[THREAD_SIZE/sizeof(long)]),
+		       "r" (xen_start_kernel)
+		     : "memory");
+}
===================================================================
--- a/arch/i386/xen/enlighten.c
+++ b/arch/i386/xen/enlighten.c
@@ -50,6 +50,8 @@
 #include "mmu.h"
 #include "multicalls.h"
 
+struct hypercall_entry hypercall_page[PAGE_SIZE/sizeof(struct hypercall_entry)]
+	__attribute__((aligned(PAGE_SIZE), section(".bss.page_aligned")));
 EXPORT_SYMBOL_GPL(hypercall_page);
 
 DEFINE_PER_CPU(enum paravirt_lazy_mode, xen_lazy_mode);
@@ -1096,15 +1098,19 @@ static void __init xen_reserve_top(void)
 	reserve_top_address(-top + 2 * PAGE_SIZE);
 }
 
-/* First C function to be called on Xen boot */
-asmlinkage void __init xen_start_kernel(void)
+/*
+ * This is jumped to by early.c, once we're running in the proper
+ * kernel virtual address space.
+ */
+void __init xen_start_kernel(void)
 {
 	pgd_t *pgd;
 
-	if (!xen_start_info)
-		return;
-
-	BUG_ON(memcmp(xen_start_info->magic, "xen-3.0", 7) != 0);
+	xen_start_info = (struct start_info *)
+		__va(boot_params.hdr.hardware_subarch_data);
+
+	/* Get mfn list */
+	phys_to_machine_mapping = (unsigned long *)xen_start_info->mfn_list;
 
 	/* Install Xen paravirt ops */
 	paravirt_ops = xen_paravirt_ops;
@@ -1116,13 +1122,7 @@ asmlinkage void __init xen_start_kernel(
 
 	xen_setup_features();
 
-	/* Get mfn list */
-	if (!xen_feature(XENFEAT_auto_translated_physmap))
-		phys_to_machine_mapping = (unsigned long *)xen_start_info->mfn_list;
-
 	pgd = (pgd_t *)xen_start_info->pt_base;
-
-	init_pg_tables_end = __pa(pgd) + xen_start_info->nr_pt_frames*PAGE_SIZE;
 
 	init_mm.pgd = pgd; /* use the Xen pagetables to start */
 
@@ -1152,11 +1152,6 @@ asmlinkage void __init xen_start_kernel(
 	new_cpu_data.hard_math = 1;
 	new_cpu_data.x86_capability[0] = cpuid_edx(1);
 
-	/* Poke various useful things into boot_params */
-	LOADER_TYPE = (9 << 4) | 0;
-	INITRD_START = xen_start_info->mod_start ? __pa(xen_start_info->mod_start) : 0;
-	INITRD_SIZE = xen_start_info->mod_len;
-
 	/* Start the world */
 	start_kernel();
 }
===================================================================
--- a/arch/i386/xen/xen-head.S
+++ /dev/null
@@ -1,38 +0,0 @@
-/* Xen-specific pieces of head.S, intended to be included in the right
-	place in head.S */
-
-#ifdef CONFIG_XEN
-
-#include <linux/elfnote.h>
-#include <asm/boot.h>
-#include <xen/interface/elfnote.h>
-
-.pushsection .init.text,"ax",@progbits
-ENTRY(startup_xen)
-	movl %esi,xen_start_info
-	cld
- 	movl $(init_thread_union+THREAD_SIZE),%esp
-	jmp xen_start_kernel
-.popsection
-
-.pushsection ".bss.page_aligned"
-	.align PAGE_SIZE_asm
-ENTRY(hypercall_page)
-	.skip 0x1000
-.popsection
-
-	ELFNOTE(Xen, XEN_ELFNOTE_GUEST_OS,       .asciz "linux")
-	ELFNOTE(Xen, XEN_ELFNOTE_GUEST_VERSION,  .asciz "2.6")
-	ELFNOTE(Xen, XEN_ELFNOTE_XEN_VERSION,    .asciz "xen-3.0")
-	ELFNOTE(Xen, XEN_ELFNOTE_VIRT_BASE,      .long  __PAGE_OFFSET)
-	ELFNOTE(Xen, XEN_ELFNOTE_ENTRY,          .long  startup_xen)
-	ELFNOTE(Xen, XEN_ELFNOTE_HYPERCALL_PAGE, .long  hypercall_page)
-	ELFNOTE(Xen, XEN_ELFNOTE_FEATURES,       .asciz "!writable_page_tables|pae_pgdir_above_4gb")
-#ifdef CONFIG_X86_PAE
-	ELFNOTE(Xen, XEN_ELFNOTE_PAE_MODE,       .asciz "yes")
-#else
-	ELFNOTE(Xen, XEN_ELFNOTE_PAE_MODE,       .asciz "no")
-#endif
-	ELFNOTE(Xen, XEN_ELFNOTE_LOADER,         .asciz "generic")
-
-#endif /*CONFIG_XEN */
===================================================================
--- a/arch/i386/xen/xen-ops.h
+++ b/arch/i386/xen/xen-ops.h
@@ -19,6 +19,7 @@ void __init xen_arch_setup(void);
 void __init xen_arch_setup(void);
 void __init xen_init_IRQ(void);
 
+void xen_start_kernel(void);
 void xen_setup_timer(int cpu);
 void xen_setup_cpu_clockevents(void);
 unsigned long xen_cpu_khz(void);
===================================================================
--- a/include/asm-i386/xen/hypercall.h
+++ b/include/asm-i386/xen/hypercall.h
@@ -40,7 +40,9 @@
 #include <xen/interface/sched.h>
 #include <xen/interface/physdev.h>
 
-extern struct { char _entry[32]; } hypercall_page[];
+extern struct hypercall_entry {
+	char _entry[32];
+} hypercall_page[];
 
 #define _hypercall0(type, name)						\
 ({									\

-- 

