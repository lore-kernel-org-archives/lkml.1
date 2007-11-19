Return-Path: <linux-kernel-owner+w=401wt.eu-S1754052AbXKSW6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbXKSW6R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 17:58:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751874AbXKSW6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 17:58:07 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:16408 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbXKSW6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 17:58:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=Bdp7f4nfiA0C4k88tNR/5Ewj+4ip3HoZ/fBE8CvKA/rNoBhjXATgdBW1fyOQnD7ZFmlK4aI41duEPjRS+0ndvkw7+rTHkDn3+3rt6vL76FF9+wjUwVsxqvv2paVus6qsO7wkm968ypbvXu7QUGFVe0TzsreJyz1pHduVwXxB5Wc=
Message-ID: <474214EC.6070605@gmail.com>
Date: Mon, 19 Nov 2007 23:57:48 +0100
From: Vegard Nossum <vegard.nossum@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [RFC][PATCH] Implement a memory checker for kernel allocations (kmemcheck)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here follows a highly experimental patch for the kernel that catches uses of
uninitialized memory. (Also see the commit message below for more technical
information.)

This is a very early stage implementation. In fact, don't even expect it to
work for you. The only supported arch is x86_32 and even qemu-0.9.0 gets it
wrong (use qemu-cvs if you want to test it).

I am mainly interested in comments and feedback. I'm sure there are a lot of
things that could be done differently (and better). For one thing, I know that
it wastes A LOT of memory (about 8 times as much as it needs to), but that's a
detail. The important thing (for now) is to get it working without any false
reports.

I will try to test it more myself and see if it can actually come up with
something that is a real error.

Kind regards,
Vegard Nossum


Sample output:

TCP cubic registered
Initializing XFRM netlink socket
kmemcheck: Caught uninitialized read from EIP = c05aeacc (sock_init_data+0x9c/0x170), address c141a024, size 32
  [<c061a0e6>] do_page_fault+0x0/0x5ca
  [<c0618e8a>] error_code+0x72/0x78
  [<c05aeacc>] sock_init_data+0x9c/0x170
  [<c05c9cdd>] __netlink_create+0x3b/0x85
  [<c05cbbff>] netlink_kernel_create+0x59/0x148
  [<c075815a>] xfrm_user_init+0x3a/0x5a
  [<c060c349>] xfrm_netlink_rcv+0x0/0x24
  [<c0736491>] kernel_init+0x148/0x2aa
  [<c0404de6>] ret_from_fork+0x6/0x1c
  [<c0736349>] kernel_init+0x0/0x2aa
  [<c0736349>] kernel_init+0x0/0x2aa
  [<c0405aeb>] kernel_thread_helper+0x7/0x10
  =======================
NET: Registered protocol family 1
NET: Registered protocol family 17



 From 463936d1db883bad7c4d09750bd22dd8bd9e3c53 Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Mon, 19 Nov 2007 22:08:41 +0100
Subject: [PATCH] Implement a memory checker for kernel allocations

  Implement a memory checker for kernel allocations. The memory checker will
  trap every read and write to memory that was allocated dynamically. This is
  done using the following algorithm:

   1. Newly allocated pages are marked as non-present for the MMU.
   2. The MMU will give us a page fault when these non-present pages are
      accessed.
   3. The page fault handler updates the presence flag of the page in
      question, starts instruction tracing using the trap flag, and restarts
      the faulting instruction.
   4. The CPU executes the next instruction and calls the debug exception.
   5. The debug exception marks the page non-present again to catch the next
       access.

Currently, only SLUB allocations are tracked. When SLUB requests a new page
from the page allocator, actually two are allocated. The second page is used
by the memory checker to keep track of which bytes in the first page has
been written to.

If a read is performed on memory that has not previously been written to, a
message is printed to the kernel log.

Naturally, this slows down almost all the kernel code and takes about half of
the system memory for bookkeeping purposes.

---
  arch/x86/Kconfig.debug         |   11 +++
  arch/x86/kernel/Makefile_32    |    2 +
  arch/x86/kernel/kmemcheck_32.c |  153 ++++++++++++++++++++++++++++++++++++++++
  arch/x86/kernel/traps_32.c     |   16 +++--
  arch/x86/mm/fault_32.c         |   19 +++++-
  include/asm-x86/kmemcheck.h    |    3 +
  include/asm-x86/kmemcheck_32.h |   25 +++++++
  include/asm-x86/pgtable_32.h   |    9 ++-
  include/linux/gfp.h            |    3 +-
  mm/slub.c                      |   37 +++++++++-
  10 files changed, 261 insertions(+), 17 deletions(-)
  create mode 100644 arch/x86/kernel/kmemcheck_32.c
  create mode 100644 include/asm-x86/kmemcheck.h
  create mode 100644 include/asm-x86/kmemcheck_32.h

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 761ca7b..f3c0791 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -112,4 +112,15 @@ config IOMMU_LEAK
  	  Add a simple leak tracer to the IOMMU code. This is useful when you
  	  are debugging a buggy device driver that leaks IOMMU mappings.

+config KMEMCHECK
+	default n
+	bool "Trap use of uninitialized memory"
+	depends on X86_32
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
index 0000000..883e04c
--- /dev/null
+++ b/arch/x86/kernel/kmemcheck_32.c
@@ -0,0 +1,153 @@
+#include <linux/kernel.h>
+#include <linux/kallsyms.h>
+#include <linux/mm.h>
+#include <asm/kmemcheck.h>
+#include <asm/tlbflush.h>
+
+DEFINE_PER_CPU(pte_t *, kmemcheck_pte);
+DEFINE_PER_CPU(unsigned long, kmemcheck_address);
+
+void
+kmemcheck_show_page(struct pt_regs *regs, unsigned long address, pte_t *pte)
+{
+	__get_cpu_var(kmemcheck_pte) = pte;
+	__get_cpu_var(kmemcheck_address) = address;
+
+	pte->pte_low |= _PAGE_VISIBLE;
+	regs->eflags |= TF_MASK;
+
+	/* Only flush on this CPU. */
+	__flush_tlb_one(address);
+}
+
+void
+kmemcheck_hide_page(struct pt_regs *regs)
+{
+	pte_t *pte = __get_cpu_var(kmemcheck_pte);
+	unsigned long address = __get_cpu_var(kmemcheck_address);
+
+	pte->pte_low &= ~_PAGE_VISIBLE;
+	regs->eflags &= ~TF_MASK;
+
+	__flush_tlb_one(address);
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
+	int operand_size_override = 32;
+
+	/* prefixes */
+	for (i = opcode; opcode_is_prefix(*i); ++i) {
+		if (*i == 0x66)
+			operand_size_override = 16;
+	}
+
+	/* escape opcode */
+	if (*i == 0x0f)
+		++i;
+
+	return (*i & 1) ? operand_size_override : 8;
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
+void
+kmemcheck_read(struct pt_regs *regs, unsigned long address)
+{
+	unsigned int size = opcode_get_size((const uint8_t *) regs->eip);
+	uint8_t *shadow = address_get_shadow(address);
+	int error = 0;
+
+	if (!shadow)
+		return;
+
+	switch (size) {
+	case 8:
+		error = *(uint8_t *) shadow != 0xff;
+		*(uint8_t *) shadow = 0xff;
+		break;
+	case 16:
+		error = *(uint16_t *) shadow != 0xffff;
+		*(uint16_t *) shadow = 0xffff;
+		break;
+	case 32:
+		error = *(uint32_t *) shadow != 0xffffffff;
+		*(uint32_t *) shadow = 0xffffffff;
+		break;
+	}
+
+	if (error) {
+		printk(KERN_ALERT "kmemcheck: Caught uninitialized read from "
+			"EIP = %08lx ", regs->eip);
+		print_symbol("(%s), ", regs->eip);
+		printk("address %08lx, size %d\n", address, size);
+		dump_stack();
+	}
+}
+
+void
+kmemcheck_write(struct pt_regs *regs, unsigned long address)
+{
+	unsigned int size = opcode_get_size((const uint8_t *) regs->eip);
+	void *shadow = address_get_shadow(address);
+
+	if (!shadow)
+		return;
+
+	switch (size) {
+	case 8:
+		*(uint8_t *) shadow = 0xff;
+		break;
+	case 16:
+		*(uint16_t *) shadow = 0xffff;
+		break;
+	case 32:
+		*(uint32_t *) shadow = 0xffffffff;
+		break;
+	}
+}
diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index 298d13e..5a9178b 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -56,6 +56,7 @@
  #include <asm/arch_hooks.h>
  #include <linux/kdebug.h>
  #include <asm/stacktrace.h>
+#include <asm/kmemcheck.h>

  #include <linux/module.h>

@@ -859,8 +860,14 @@ fastcall void __kprobes do_debug(struct pt_regs * regs, long error_code)
  		 * check for kernel mode by just checking the CPL
  		 * of CS.
  		 */
-		if (!user_mode(regs))
-			goto clear_TF_reenable;
+		if (!user_mode(regs)) {
+			kmemcheck_hide_page(regs);
+
+			/* XXX: How do we deal with this? */
+			if (0)
+				set_tsk_thread_flag(tsk, TIF_SINGLESTEP);
+			return;
+		}
  	}

  	/* Ok, finally something we can handle */
@@ -876,11 +883,6 @@ clear_dr7:
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
index a2273d4..a9075ca 100644
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
+		kmemcheck_show_page(regs, address, pte_k);
+
+		if (error_code & 2)
+			kmemcheck_write(regs, address);
+		else
+			kmemcheck_read(regs, address);
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
index 0000000..e4bb559
--- /dev/null
+++ b/include/asm-x86/kmemcheck_32.h
@@ -0,0 +1,25 @@
+#ifndef ASM_X86_KMEMCHECK_32_H
+#define ASM_X86_KMEMCHECK_32_H
+
+#include <linux/percpu.h>
+#include <asm/pgtable.h>
+
+#ifdef CONFIG_KMEMCHECK
+DECLARE_PER_CPU(pte_t *, kmemcheck_pte);
+DECLARE_PER_CPU(unsigned long, kmemcheck_address);
+
+void kmemcheck_show_page(struct pt_regs *regs,
+	unsigned long address, pte_t *pte);
+void kmemcheck_hide_page(struct pt_regs *regs);
+void kmemcheck_read(struct pt_regs *regs, unsigned long address);
+void kmemcheck_write(struct pt_regs *regs, unsigned long address);
+#else
+static inline void kmemcheck_show_page(struct pt_regs *regs) { }
+static inline void kmemcheck_hide_page(struct pt_regs *regs) { }
+static inline void kmemcheck_read(struct pt_regs *regs,
+	unsigned int address) { }
+static inline void kmemcheck_write(struct pt_regs *regs,
+	unsigned int address) { }
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
index 9acb413..4d44f5f 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -22,6 +22,8 @@
  #include <linux/kallsyms.h>
  #include <linux/memory.h>

+#include <asm/cacheflush.h>
+
  /*
   * Lock order:
   *   1. slab_lock(page)
@@ -1039,8 +1041,9 @@ static inline unsigned long kmem_cache_flags(unsigned long objsize,
   */
  static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
  {
-	struct page * page;
+	struct page *page;
  	int pages = 1 << s->order;
+	int order = s->order;

  	if (s->order)
  		flags |= __GFP_COMP;
@@ -1051,14 +1054,34 @@ static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
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
+		change_page_attr(page, pages >> 1,
+			__pgprot(__PAGE_KERNEL & ~_PAGE_VISIBLE));
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
-- 
1.5.3.4

