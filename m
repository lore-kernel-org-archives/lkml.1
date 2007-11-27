Return-Path: <linux-kernel-owner+w=401wt.eu-S1758648AbXK0PQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758648AbXK0PQn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 10:16:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756567AbXK0PQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 10:16:36 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:57132 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480AbXK0PQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 10:16:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=K3WXBE0j2nW4ggsouViEeNzHxMArlKj1434Gh10S4ba/yIdlzqwzcJvB5MAWrENYTLrKx7TuCykGtX4OpcClAxXSFE7F8G8uauz6CBP6AXIFonQktR8A+m8MyYascqrCIo5HiGMsN2TS/aZavX8US0X2I0AJJm3+pS7v5v2U8wY=
Message-ID: <474C34CC.6060509@gmail.com>
Date: Tue, 27 Nov 2007 16:16:28 +0100
From: Vegard Nossum <vegard.nossum@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [RFC] kmemcheck: trap uses of uninitialized memory (v2)
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

General description: kmemcheck will trap every read and write to memory that was
allocated dynamically (ie. with kmalloc()). If a memory address is read that has
not previously been written to, a message is printed to the kernel log.

Changes since v1:

- We properly flush TLB entries that change. This used to not be the case, and so we
   got both spurious and missing reports of invalid memory accesses.
- There was a problem with instructions that both read from and wrote to memory in a
   single instruction. In particular, memcpy would use a REP MOVSB instruction, which
   could cause a page fault for either the source or the destination address. In this
   case the information from the page fault handler is not enough (as we only get the
   first access, the read), and we would end up either looping indefinitely (between
   marking the source page and the destination page present if the pages were not the
   same, and missing the write if the source/destination page was the same). Now we
   examine the instruction that caused the fault to see if it makes one or two memory
   accesses.
- Compiling with -Os caused gcc to turn some MOVZWs into MOVs, which would result in
   reads from possibly uninitialized memory. This is not incorrect per se, (since the
   extra bits are thrown away afterwards) so we now depend on !CC_OPTIMIZE_FOR_SIZE.
- Adjacent reads from the same EIP will not display the full stack trace.

If anybody wants to take a look at a sample log from the patched kernel, I provide
this link: http://folk.uio.no/vegardno/linux/kmemcheck-20071127.txt
I do not know which (if any) of the messages are valid yet, but please have a look
around anyway. If you can confirm or deny the validity of a report, that's great.

To use this patch with qemu, use either qemu-cvs or qemu-0.9.0 with the following
patch: http://lists.gnu.org/archive/html/qemu-devel/2007-03/msg00126.html

In addition, you probably want to remove the -O2 entirely from the Makefile to
inhibit inlining, which makes the stack traces somewhat better.


Kind regards,
Vegard Nossum


  arch/x86/Kconfig.debug         |   10 ++
  arch/x86/kernel/Makefile_32    |    2 +
  arch/x86/kernel/kmemcheck_32.c |  290 ++++++++++++++++++++++++++++++++++++++++
  arch/x86/kernel/traps_32.c     |   16 ++-
  arch/x86/mm/fault_32.c         |   19 +++-
  include/asm-x86/kmemcheck.h    |    3 +
  include/asm-x86/kmemcheck_32.h |   33 +++++
  include/asm-x86/pgtable_32.h   |    9 +-
  include/linux/gfp.h            |    3 +-
  mm/slub.c                      |   37 +++++-
  10 files changed, 405 insertions(+), 17 deletions(-)

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 761ca7b..6a3e3ba 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -112,4 +112,14 @@ config IOMMU_LEAK
  	  Add a simple leak tracer to the IOMMU code. This is useful when you
  	  are debugging a buggy device driver that leaks IOMMU mappings.

+config KMEMCHECK
+	bool "Trap use of uninitialized memory"
+	depends on X86_32 && !CC_OPTIMIZE_FOR_SIZE
+	help
+	  This option enables tracing of dynamically allocated kernel memory
+	  to see if memory is used before it has been given an initial value.
+	  Be aware that this requires half of your memory for bookkeeping and
+	  will insert extra code at *every* read and write to tracked memory
+	  thus slow down the kernel code (but user code is unaffected).
+
  endmenu
diff --git a/arch/x86/kernel/Makefile_32 b/arch/x86/kernel/Makefile_32
index a7bc93c..91d3d9c 100644
--- a/arch/x86/kernel/Makefile_32
+++ b/arch/x86/kernel/Makefile_32
@@ -49,6 +49,8 @@ obj-y				+= pcspeaker.o

  obj-$(CONFIG_SCx200)		+= scx200_32.o

+obj-$(CONFIG_KMEMCHECK)		+= kmemcheck_32.o
+
  # vsyscall_32.o contains the vsyscall DSO images as __initdata.
  # We must build both images before we can assemble it.
  # Note: kbuild does not track this dependency due to usage of .incbin
diff --git a/arch/x86/kernel/kmemcheck_32.c b/arch/x86/kernel/kmemcheck_32.c
new file mode 100644
index 0000000..9d065b9
--- /dev/null
+++ b/arch/x86/kernel/kmemcheck_32.c
@@ -0,0 +1,290 @@
+#include <linux/kernel.h>
+#include <linux/kallsyms.h>
+#include <linux/mm.h>
+#include <asm/cacheflush.h>
+#include <asm/kmemcheck.h>
+#include <asm/tlbflush.h>
+
+static int
+page_is_tracked(struct page *page)
+{
+	struct page *head;
+
+	if (!page)
+		return 0;
+	head = compound_head(page);
+	if (!head)
+		return 0;
+	if (!(head->flags & (1 << PG_slab)))
+		return 0;
+	if (!head->slab)
+		return 0;
+	if (head->slab->flags & __GFP_NOTRACK)
+		return 0;
+	return 1;
+}
+
+static void
+show_addr(uint32_t addr)
+{
+	struct page *page;
+	pte_t *pte;
+
+	if (!addr)
+		return;
+	page = virt_to_page(addr);
+	if (!page_is_tracked(page))
+		return;
+
+	pte = lookup_address(addr);
+	change_page_attr(page, 1, __pgprot(pte->pte_low | _PAGE_VISIBLE));
+	__flush_tlb_one(addr);
+}
+
+static void
+hide_addr(uint32_t addr)
+{
+	struct page *page;
+	pte_t *pte;
+
+	if (!addr)
+		return;
+	page = virt_to_page(addr);
+	if (!page_is_tracked(page))
+		return;
+	pte = lookup_address(addr);
+	change_page_attr(page, 1, __pgprot(pte->pte_low & ~_PAGE_VISIBLE));
+	__flush_tlb_one(addr);
+}
+
+DEFINE_PER_CPU(uint32_t, kmemcheck_read_addr);
+DEFINE_PER_CPU(uint32_t, kmemcheck_write_addr);
+
+void
+kmemcheck_show(struct pt_regs *regs)
+{
+	show_addr(__get_cpu_var(kmemcheck_read_addr));
+	show_addr(__get_cpu_var(kmemcheck_write_addr));
+	regs->eflags |= TF_MASK;
+}
+
+void
+kmemcheck_hide(struct pt_regs *regs)
+{
+	hide_addr(__get_cpu_var(kmemcheck_read_addr));
+	hide_addr(__get_cpu_var(kmemcheck_write_addr));
+	regs->eflags &= ~TF_MASK;
+}
+
+void
+kmemcheck_hide_pages(struct page *p, unsigned int n)
+{
+	unsigned int i;
+
+	for(i = 0; i < n; ++i) {
+		unsigned long address = (unsigned long) page_address(&p[i]);
+		pte_t *pte = lookup_address(address);
+
+		change_page_attr(&p[i], 1,
+			__pgprot(pte->pte_low & ~_PAGE_VISIBLE));
+		__flush_tlb_one(address);
+	}
+}
+
+static int
+opcode_is_prefix(uint8_t b)
+{
+	return
+		/* Group 1 */
+		b == 0xf0 || b == 0xf2 || b == 0xf3
+		/* Group 2 */
+		|| b == 0x2e || b == 0x36 || b == 0x3e || b == 0x26
+		|| b == 0x64 || b == 0x65 || b == 0x2e || b == 0x3e
+		/* Group 3 */
+		|| b == 0x66
+		/* Group 4 */
+		|| b == 0x67;
+}
+
+/* This is a VERY crude opcode decoder. We only need to find the size of the
+ * load/store that caused our #PF and this should work for all the opcodes
+ * that we care about. Moreover, the ones who invented this instruction set
+ * should be shot. */
+static unsigned int
+opcode_get_size(const uint8_t *opcode)
+{
+	const uint8_t *i;
+
+	/* Default operand size */
+	int operand_size_override = 32;
+
+	/* prefixes */
+	for (i = opcode; opcode_is_prefix(*i); ++i) {
+		if (*i == 0x66)
+			operand_size_override = 16;
+	}
+
+	/* escape opcode */
+	if (*i == 0x0f) {
+		++i;
+
+		if(*i == 0xb6)
+			return operand_size_override >> 1;
+		if(*i == 0xb7)
+			return 16;
+	}
+
+	return (*i & 1) ? operand_size_override : 8;
+}
+
+static uint8_t
+opcode_get_primary(const uint8_t *opcode)
+{
+	const uint8_t *i;
+
+	/* skip prefixes */
+	for (i = opcode; opcode_is_prefix(*i); ++i);
+	return *i;
+}
+
+static void *address_get_shadow_slab(unsigned long address,
+	struct page *head)
+{
+	if (!head->slab)
+		return NULL;
+
+	if (head->slab->flags & __GFP_NOTRACK)
+		return NULL;
+
+	return (void *) address + (PAGE_SIZE << head->slab->order);
+}
+
+static void *address_get_shadow(unsigned long address)
+{
+	struct page *page = virt_to_page(address);
+	struct page *head = compound_head(page);
+
+	if (!head)
+		return NULL;
+
+	if (head->flags & (1 << PG_slab))
+		return address_get_shadow_slab(address, head);
+
+	return NULL;
+}
+
+static int
+test(void *shadow, unsigned int size)
+{
+	switch (size) {
+	case 8:
+		return *(uint8_t *) shadow == 0xff;
+	case 16:
+		return *(uint16_t *) shadow == 0xffff;
+	case 32:
+		return *(uint32_t *) shadow == 0xffffffff;
+	}
+
+	BUG();
+	return 0;
+}
+
+static void
+set(void *shadow, unsigned int size)
+{
+	switch (size) {
+	case 8:
+		*(uint8_t *) shadow = 0xff;
+		return;
+	case 16:
+		*(uint16_t *) shadow = 0xffff;
+		return;
+	case 32:
+		*(uint32_t *) shadow = 0xffffffff;
+		return;
+	}
+
+	BUG();
+}
+
+static void
+kmemcheck_read(uint32_t eip, uint32_t address, unsigned int size)
+{
+	static uint32_t prev_eip = 0;
+
+	void *shadow;
+
+	__get_cpu_var(kmemcheck_read_addr) = address;
+
+	shadow = address_get_shadow(address);
+	if (!shadow)
+		return;
+
+	if (!test(shadow, size)) {
+		set(shadow, size);
+
+		printk(KERN_ALERT "kmemcheck: Caught uninitialized "
+			"read from EIP = %08x ", eip);
+		print_symbol("(%s), ", eip);
+		printk("address %08x, size %d\n", address, size);
+
+		/* Some kind of rate-limiter; if we already printed a message
+		 * that originated from the same EIP, don't spam the logs
+		 * with new traces. */
+		if (eip != prev_eip) {
+			prev_eip = eip;
+			dump_stack();
+		}
+	}
+}
+
+static void
+kmemcheck_write(uint32_t eip, uint32_t address, unsigned int size)
+{
+	void *shadow;
+
+	__get_cpu_var(kmemcheck_write_addr) = address;
+
+	shadow = address_get_shadow(address);
+	if (!shadow)
+		return;
+
+	set(shadow, size);
+}
+
+void
+kmemcheck_access(struct pt_regs *regs,
+	unsigned long fallback_address, enum kmemcheck_method fallback_method)
+{
+	const uint8_t *insn;
+	unsigned int size;
+
+	insn = (const uint8_t *) regs->eip;
+	size = opcode_get_size(insn);
+
+	__get_cpu_var(kmemcheck_read_addr) = 0;
+	__get_cpu_var(kmemcheck_write_addr) = 0;
+
+	switch (opcode_get_primary(insn)) {
+		/* MOVS, MOVSB, MOVSW, MOVSD */
+	case 0xa4:
+	case 0xa5:
+		/* These instructions are special because they take two
+		 * addresses, but we only take one page fault. */
+		kmemcheck_read(regs->eip, regs->esi, size);
+		kmemcheck_write(regs->eip, regs->edi, size);
+		return;
+	}
+
+	/* If the opcode isn't special in any way, we use the data from the
+	 * page fault handler to determine the address and type of memory
+	 * access. */
+	switch (fallback_method) {
+	case KMEMCHECK_READ:
+		kmemcheck_read(regs->eip, fallback_address, size);
+		break;
+	case KMEMCHECK_WRITE:
+		kmemcheck_write(regs->eip, fallback_address, size);
+		break;
+	}
+}
diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index ef60102..5feed7e 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -56,6 +56,7 @@
  #include <asm/arch_hooks.h>
  #include <linux/kdebug.h>
  #include <asm/stacktrace.h>
+#include <asm/kmemcheck.h>

  #include <linux/module.h>

@@ -866,8 +867,14 @@ fastcall void __kprobes do_debug(struct pt_regs * regs, long error_code)
  		 * check for kernel mode by just checking the CPL
  		 * of CS.
  		 */
-		if (!user_mode(regs))
-			goto clear_TF_reenable;
+		if (!user_mode(regs)) {
+			kmemcheck_hide(regs);
+
+			/* XXX: How do we deal with this? */
+			if (0)
+				set_tsk_thread_flag(tsk, TIF_SINGLESTEP);
+			return;
+		}
  	}

  	/* Ok, finally something we can handle */
@@ -883,11 +890,6 @@ clear_dr7:
  debug_vm86:
  	handle_vm86_trap((struct kernel_vm86_regs *) regs, error_code, 1);
  	return;
-
-clear_TF_reenable:
-	set_tsk_thread_flag(tsk, TIF_SINGLESTEP);
-	regs->eflags &= ~TF_MASK;
-	return;
  }

  /*
diff --git a/arch/x86/mm/fault_32.c b/arch/x86/mm/fault_32.c
index a2273d4..dcf587f 100644
--- a/arch/x86/mm/fault_32.c
+++ b/arch/x86/mm/fault_32.c
@@ -30,6 +30,7 @@
  #include <asm/system.h>
  #include <asm/desc.h>
  #include <asm/segment.h>
+#include <asm/kmemcheck.h>

  extern void die(const char *,struct pt_regs *,long);

@@ -257,11 +258,13 @@ static inline pmd_t *vmalloc_sync_one(pgd_t *pgd, unsigned long address)
   *
   * This assumes no large pages in there.
   */
-static inline int vmalloc_fault(unsigned long address)
+static inline int vmalloc_fault(struct pt_regs *regs, unsigned long address,
+	unsigned long error_code)
  {
  	unsigned long pgd_paddr;
  	pmd_t *pmd_k;
  	pte_t *pte_k;
+
  	/*
  	 * Synchronize this task's top level page-table
  	 * with the 'reference' page table.
@@ -270,12 +273,23 @@ static inline int vmalloc_fault(unsigned long address)
  	 * an interrupt in the middle of a task switch..
  	 */
  	pgd_paddr = read_cr3();
+
  	pmd_k = vmalloc_sync_one(__va(pgd_paddr), address);
  	if (!pmd_k)
  		return -1;
  	pte_k = pte_offset_kernel(pmd_k, address);
  	if (!pte_present(*pte_k))
  		return -1;
+
+	if (!pte_visible(*pte_k)) {
+		if (error_code & 2)
+			kmemcheck_access(regs, address, KMEMCHECK_WRITE);
+		else
+			kmemcheck_access(regs, address, KMEMCHECK_READ);
+
+		kmemcheck_show(regs);
+	}
+
  	return 0;
  }

@@ -329,7 +343,8 @@ fastcall void __kprobes do_page_fault(struct pt_regs *regs,
  	 * protection error (error_code & 9) == 0.
  	 */
  	if (unlikely(address >= TASK_SIZE)) {
-		if (!(error_code & 0x0000000d) && vmalloc_fault(address) >= 0)
+		if (!(error_code & 0x0000000d)
+			&& vmalloc_fault(regs, address, error_code) >= 0)
  			return;
  		if (notify_page_fault(regs))
  			return;
diff --git a/include/asm-x86/kmemcheck.h b/include/asm-x86/kmemcheck.h
new file mode 100644
index 0000000..11de35a
--- /dev/null
+++ b/include/asm-x86/kmemcheck.h
@@ -0,0 +1,3 @@
+#ifdef CONFIG_X86_32
+# include "kmemcheck_32.h"
+#endif
diff --git a/include/asm-x86/kmemcheck_32.h b/include/asm-x86/kmemcheck_32.h
new file mode 100644
index 0000000..3663664
--- /dev/null
+++ b/include/asm-x86/kmemcheck_32.h
@@ -0,0 +1,33 @@
+#ifndef ASM_X86_KMEMCHECK_32_H
+#define ASM_X86_KMEMCHECK_32_H
+
+#include <linux/percpu.h>
+#include <asm/pgtable.h>
+
+enum kmemcheck_method {
+	KMEMCHECK_READ,
+	KMEMCHECK_WRITE,
+};
+
+#ifdef CONFIG_KMEMCHECK
+DECLARE_PER_CPU(uint32_t, kmemcheck_read_addr);
+DECLARE_PER_CPU(uint32_t, kmemcheck_write_addr);
+
+void kmemcheck_show(struct pt_regs *regs);
+void kmemcheck_hide(struct pt_regs *regs);
+
+void kmemcheck_hide_pages(struct page *p, unsigned int n);
+
+void kmemcheck_access(struct pt_regs *regs,
+	unsigned long address, enum kmemcheck_method method);
+#else
+static void kmemcheck_show(struct pt_regs *regs) { }
+static void kmemcheck_hide(struct pt_regs *regs) { }
+
+static void kmemcheck_hide_pages(struct page *p, unsigned int n) { }
+
+static void kmemcheck_access(struct pt_regs *regs,
+	unsigned long address, enum kmemcheck_method method) { }
+#endif
+
+#endif
diff --git a/include/asm-x86/pgtable_32.h b/include/asm-x86/pgtable_32.h
index ed3e70d..3a0c158 100644
--- a/include/asm-x86/pgtable_32.h
+++ b/include/asm-x86/pgtable_32.h
@@ -103,7 +103,7 @@ void paging_init(void);
  #define _PAGE_BIT_UNUSED3	11
  #define _PAGE_BIT_NX		63

-#define _PAGE_PRESENT	0x001
+#define _PAGE_VISIBLE	0x001
  #define _PAGE_RW	0x002
  #define _PAGE_USER	0x004
  #define _PAGE_PWT	0x008
@@ -114,7 +114,9 @@ void paging_init(void);
  #define _PAGE_GLOBAL	0x100	/* Global TLB entry PPro+ */
  #define _PAGE_UNUSED1	0x200	/* available for programmer */
  #define _PAGE_UNUSED2	0x400
-#define _PAGE_UNUSED3	0x800
+#define _PAGE_PRESENT2	0x800
+
+#define _PAGE_PRESENT	(_PAGE_VISIBLE | _PAGE_PRESENT2)

  /* If _PAGE_PRESENT is clear, we use these: */
  #define _PAGE_FILE	0x040	/* nonlinear file mapping, saved PTE; unset:swap */
@@ -201,7 +203,8 @@ extern unsigned long long __PAGE_KERNEL, __PAGE_KERNEL_EXEC;
  /* The boot page tables (all created as a single array) */
  extern unsigned long pg0[];

-#define pte_present(x)	((x).pte_low & (_PAGE_PRESENT | _PAGE_PROTNONE))
+#define pte_present(x)	((x).pte_low & (_PAGE_PRESENT2 | _PAGE_PROTNONE))
+#define pte_visible(x)	((x).pte_low & (_PAGE_VISIBLE))

  /* To avoid harmful races, pmd_none(x) should check only the lower when PAE */
  #define pmd_none(x)	(!(unsigned long)pmd_val(x))
diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 7e93a9a..a130067 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -50,8 +50,9 @@ struct vm_area_struct;
  #define __GFP_THISNODE	((__force gfp_t)0x40000u)/* No fallback, no policies */
  #define __GFP_RECLAIMABLE ((__force gfp_t)0x80000u) /* Page is reclaimable */
  #define __GFP_MOVABLE	((__force gfp_t)0x100000u)  /* Page is movable */
+#define __GFP_NOTRACK	((__force gfp_t)0x200000u)  /* Don't track with kmemcheck */

-#define __GFP_BITS_SHIFT 21	/* Room for 21 __GFP_FOO bits */
+#define __GFP_BITS_SHIFT 22	/* Room for 22 __GFP_FOO bits */
  #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))

  /* This equals 0, but use constants in case they ever change */
diff --git a/mm/slub.c b/mm/slub.c
index 9acb413..d70c22f 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -22,6 +22,9 @@
  #include <linux/kallsyms.h>
  #include <linux/memory.h>

+#include <asm/cacheflush.h>
+#include <asm/kmemcheck.h>
+
  /*
   * Lock order:
   *   1. slab_lock(page)
@@ -1039,8 +1042,9 @@ static inline unsigned long kmem_cache_flags(unsigned long objsize,
   */
  static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
  {
-	struct page * page;
+	struct page *page;
  	int pages = 1 << s->order;
+	int order = s->order;

  	if (s->order)
  		flags |= __GFP_COMP;
@@ -1051,14 +1055,33 @@ static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
  	if (s->flags & SLAB_RECLAIM_ACCOUNT)
  		flags |= __GFP_RECLAIMABLE;

+	/* Actually allocate twice as much, since we need to track the
+	 * status of each byte within the allocation. */
+	if (!(flags & __GFP_NOTRACK)) {
+		pages += pages;
+		order += 1;
+	}
+
  	if (node == -1)
-		page = alloc_pages(flags, s->order);
+		page = alloc_pages(flags, order);
  	else
-		page = alloc_pages_node(node, flags, s->order);
+		page = alloc_pages_node(node, flags, order);

  	if (!page)
  		return NULL;

+	if (!(flags & __GFP_NOTRACK)) {
+		unsigned int i;
+
+		/* Mark it as non-present for the MMU so that our accesses
+		 * to this memory will trigger a page fault and let us
+		 * analyze the memory accesses. */
+		kmemcheck_hide_pages(page, pages >> 1);
+
+		for (i = pages >> 1; i < pages; ++i)
+			clear_page(page_address(&page[i]));
+	}
+
  	mod_zone_page_state(page_zone(page),
  		(s->flags & SLAB_RECLAIM_ACCOUNT) ?
  		NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE,
@@ -1122,6 +1145,7 @@ out:
  static void __free_slab(struct kmem_cache *s, struct page *page)
  {
  	int pages = 1 << s->order;
+	int order = s->order;

  	if (unlikely(SlabDebug(page))) {
  		void *p;
@@ -1132,12 +1156,17 @@ static void __free_slab(struct kmem_cache *s, struct page *page)
  		ClearSlabDebug(page);
  	}

+	if (!(s->flags & __GFP_NOTRACK)) {
+		pages += pages;
+		order += 1;
+	}
+
  	mod_zone_page_state(page_zone(page),
  		(s->flags & SLAB_RECLAIM_ACCOUNT) ?
  		NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE,
  		- pages);

-	__free_pages(page, s->order);
+	__free_pages(page, order);
  }

  static void rcu_free_slab(struct rcu_head *h)
