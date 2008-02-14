Return-Path: <linux-kernel-owner+w=401wt.eu-S1760102AbYBNUAL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760102AbYBNUAL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 15:00:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755903AbYBNT75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 14:59:57 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:48925 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754986AbYBNT7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 14:59:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=n/ZMmLgtfcYDu836sdzVgCCxOUG6gXkjPr5CSENOkc4uW76MEwaG11cfNaNzdtGbgloVI2KFl7VPAX6YmjdTRtwODHEs41AVqO68jrm6DJD7x3u4DPzq8TNa456bh1NfZQKO+5Ps5Cj11Impuop0+q3mqhtG6N90SHgkQaNH0QM=
Message-ID: <47B49DB2.2090402@gmail.com>
Date: Thu, 14 Feb 2008 20:59:46 +0100
From: Vegard Nossum <vegard.nossum@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
CC: Daniel Walker <dwalker@mvista.com>, Ingo Molnar <mingo@elte.hu>,
       Richard Knutsson <ricknu-0@student.ltu.se>,
       Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>
Subject: [PATCH 1/4] kmemcheck v4
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

I post the fourth revision of kmemcheck. It seems that we are slowly
converging towards something usable :-)

General description: kmemcheck is a patch to the linux kernel that
detects use of uninitialized memory. It does this by trapping every
read and write to memory that was allocated dynamically (e.g. using
kmalloc()). If a memory address is read that has not previously been
written to, a message is printed to the kernel log.

Changes since v3:
- More clean-ups. Hopefully the SLUB bits are clearer now.
- Don't print directly from the page fault handler. Instead, we save all
   errors on a ring queue and print them from a helper kernel thread.
- Some experimental support for graceful bit-field handling.
- Preliminary support for use-after-free detection.
- I've also separated the patch into logical chunks.

On my machine, the kmemcheck-enabled kernel now boots into full
graphical desktop. As expected, it is much, much slower than the vanilla
kernel, but still surprisingly usable. Unfortunately, the kernel
usually freezes hard after a couple of hours for unknown reasons --
ideas and/or patches are welcome ;-)

The patches apply to v2.6.25-rc1.


Kind regards,
Vegard Nossum


 From 0fcca4341b6b1b277d936558aa3cab0f212bad9b Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Thu, 14 Feb 2008 19:10:40 +0100
Subject: [PATCH] kmemcheck: add the core kmemcheck changes

General description: kmemcheck is a patch to the linux kernel that
detects use of uninitialized memory. It does this by trapping every
read and write to memory that was allocated dynamically (e.g. using
kmalloc()). If a memory address is read that has not previously been
written to, a message is printed to the kernel log.

Signed-off-by: Vegard Nossum <vegardno@ifi.uio.no>
---
  Documentation/kmemcheck.txt    |   73 ++++
  arch/x86/Kconfig.debug         |   35 ++
  arch/x86/kernel/Makefile       |    2 +
  arch/x86/kernel/kmemcheck_32.c |  781 ++++++++++++++++++++++++++++++++++++++++
  include/asm-x86/kmemcheck.h    |    3 +
  include/asm-x86/kmemcheck_32.h |   22 ++
  include/asm-x86/pgtable.h      |    4 +-
  include/asm-x86/pgtable_32.h   |    1 +
  include/linux/gfp.h            |    3 +-
  include/linux/kmemcheck.h      |   17 +
  include/linux/page-flags.h     |    7 +
  11 files changed, 945 insertions(+), 3 deletions(-)
  create mode 100644 Documentation/kmemcheck.txt
  create mode 100644 arch/x86/kernel/kmemcheck_32.c
  create mode 100644 include/asm-x86/kmemcheck.h
  create mode 100644 include/asm-x86/kmemcheck_32.h
  create mode 100644 include/linux/kmemcheck.h

diff --git a/Documentation/kmemcheck.txt b/Documentation/kmemcheck.txt
new file mode 100644
index 0000000..d234571
--- /dev/null
+++ b/Documentation/kmemcheck.txt
@@ -0,0 +1,73 @@
+Technical description
+=====================
+
+kmemcheck works by marking memory pages non-present. This means that whenever
+somebody attempts to access the page, a page fault is generated. The page
+fault handler notices that the page was in fact only hidden, and so it calls
+on the kmemcheck code to make further investigations.
+
+When the investigations are completed, kmemcheck "shows" the page by marking
+it present (as it would be under normal circumstances). This way, the
+interrupted code can continue as usual.
+
+But after the instruction has been executed, we should hide the page again, so
+that we can catch the next access too! Now kmemcheck makes use of a debugging
+feature of the processor, namely single-stepping. When the processor has
+finished the one instruction that generated the memory access, a debug
+exception is raised. From here, we simply hide the page again and continue
+execution, this time with the single-stepping feature turned off.
+
+
+Changes to the memory allocator (SLUB)
+======================================
+
+kmemcheck requires some assistance from the memory allocator in order to work.
+The memory allocator needs to
+
+1. Request twice as much memory as would normally be needed. The bottom half
+   of the memory is what the user actually sees and uses; the upper half
+   contains the so-called shadow memory, which stores the status of each byte
+   in the bottom half, e.g. initialized or uninitialized.
+2. Tell kmemcheck which parts of memory that should be marked uninitialized.
+   There are actually a few more states, such as "not yet allocated" and
+   "recently freed".
+
+If a slab cache is set up using the SLAB_NOTRACK flag, it will never return
+memory that can take page faults because of kmemcheck.
+
+If a slab cache is NOT set up using the SLAB_NOTRACK flag, callers can still
+request memory with the __GFP_NOTRACK flag. This does not prevent the page
+faults from occuring, however, but marks the object in question as being
+initialized so that no warnings will ever be produced for this object.
+
+
+Problems
+========
+
+The most prominent problem seems to be that of bit-fields. kmemcheck can only
+track memory with byte granularity. Therefore, when gcc generates code to
+access only one bit in a bit-field, there is really no way for kmemcheck to
+know which of the other bits that will be used or thrown away. Consequently,
+there may be bogus warnings for bit-field accesses. There is some experimental
+support to detect this automatically, though it is probably better to work
+around this by explicitly initializing whole bit-fields at once.
+
+Some allocations are used for DMA. As DMA doesn't go through the paging
+mechanism, we have absolutely no way to detect DMA writes. This means that
+spurious warnings may be seen on access to DMA memory. DMA allocations should
+be annotated with the __GFP_NOTRACK flag or allocated from caches marked
+SLAB_NOTRACK to work around this problem.
+
+
+Future enhancements
+===================
+
+There is already some preliminary support for catching use-after-free errors.
+What still needs to be done is delaying kfree() so that memory is not
+reallocated immediately after freeing it. [Suggested by Pekka Enberg.]
+
+It should be possible to allow SMP systems by duplicating the page tables for
+each processor in the system. This is probably extremely difficult, however.
+[Suggested by Ingo Molnar.]
+
+Support for instruction set extensions like XMM, SSE2, etc.
diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 864affc..f373c0e 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -134,6 +134,41 @@ config IOMMU_LEAK
  	  Add a simple leak tracer to the IOMMU code. This is useful when you
  	  are debugging a buggy device driver that leaks IOMMU mappings.

+config KMEMCHECK
+	bool "kmemcheck: trap use of uninitialized memory"
+	depends on M386 && !X86_GENERIC && !SMP
+	depends on !CC_OPTIMIZE_FOR_SIZE
+	depends on !DEBUG_PAGEALLOC && SLUB
+	select DEBUG_INFO
+	select FRAME_POINTER
+	select STACKTRACE
+	default n
+	help
+	  This option enables tracing of dynamically allocated kernel memory
+	  to see if memory is used before it has been given an initial value.
+	  Be aware that this requires half of your memory for bookkeeping and
+	  will insert extra code at *every* read and write to tracked memory
+	  thus slow down the kernel code (but user code is unaffected).
+
+config KMEMCHECK_PARTIAL_OK
+	bool "kmemcheck: allow partially uninitialized memory"
+	depends on KMEMCHECK
+	default y
+	help
+	  This option works around certain GCC optimizations that produce
+	  32-bit reads from 16-bit variables where the upper 16 bits are
+	  thrown away afterwards. This may of course also hide some real
+	  bugs.
+
+config KMEMCHECK_BITOPS_OK
+	bool "kmemcheck: allow bit-field manipulation"
+	depends on KMEMCHECK
+	default n
+	help
+	  This option silences warnings that would be generated for bit-field
+	  accesses where not all the bits are initialized at the same time.
+	  This may also hide some real bugs.
+
  #
  # IO delay types:
  #
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 76ec0f8..f302a8a 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -78,6 +78,8 @@ endif
  obj-$(CONFIG_SCx200)		+= scx200.o
  scx200-y			+= scx200_32.o

+obj-$(CONFIG_KMEMCHECK)		+= kmemcheck_32.o
+
  ###
  # 64 bit specific files
  ifeq ($(CONFIG_X86_64),y)
diff --git a/arch/x86/kernel/kmemcheck_32.c b/arch/x86/kernel/kmemcheck_32.c
new file mode 100644
index 0000000..0863ce2
--- /dev/null
+++ b/arch/x86/kernel/kmemcheck_32.c
@@ -0,0 +1,781 @@
+/**
+ * kmemcheck - a heavyweight memory checker
+ * Copyright (C) 2007, 2008  Vegard Nossum <vegardno@ifi.uio.no>
+ * (With a lot of help from Ingo Molnar and Pekka Enberg.)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License (version 2) as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kallsyms.h>
+#include <linux/kernel.h>
+#include <linux/kthread.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/page-flags.h>
+#include <linux/stacktrace.h>
+
+#include <asm/cacheflush.h>
+#include <asm/kdebug.h>
+#include <asm/kmemcheck.h>
+#include <asm/pgtable.h>
+#include <asm/string.h>
+#include <asm/tlbflush.h>
+
+enum shadow {
+	SHADOW_UNALLOCATED,
+	SHADOW_UNINITIALIZED,
+	SHADOW_INITIALIZED,
+	SHADOW_FREED,
+};
+
+struct kmemcheck_error {
+	/* Kind of access that caused the error */
+	enum shadow		state;
+	/* Address and size of the erroneous read */
+	uint32_t		address;
+	unsigned int		size;
+
+	struct pt_regs		regs;
+	struct stack_trace	trace;
+	unsigned long		trace_entries[32];
+};
+
+/*
+ * Create a ring queue of errors to output. We can't call printk() directly
+ * from the kmemcheck traps, since this may call the console drivers and
+ * result in a recursive fault.
+ */
+static struct kmemcheck_error error_fifo[32];
+static unsigned int error_count;
+static unsigned int error_rd;
+static unsigned int error_wr;
+
+static struct task_struct *kmemcheck_thread;
+
+static struct kmemcheck_error *
+error_next_wr(void)
+{
+	struct kmemcheck_error *e;
+
+	if (error_count == ARRAY_SIZE(error_fifo))
+		return NULL;
+
+	e = &error_fifo[error_wr];
+	if (++error_wr == ARRAY_SIZE(error_fifo))
+		error_wr = 0;
+	++error_count;
+	return e;
+}
+
+static struct kmemcheck_error *
+error_next_rd(void)
+{
+	struct kmemcheck_error *e;
+
+	if (error_count == 0)
+		return NULL;
+
+	e = &error_fifo[error_rd];
+	if (++error_rd == ARRAY_SIZE(error_fifo))
+		error_rd = 0;
+	--error_count;
+	return e;
+}
+
+/*
+ * Save the context of the error.
+ */
+static void
+error_save(enum shadow state, uint32_t address, unsigned int size,
+	struct pt_regs *regs)
+{
+	static uint32_t prev_ip;
+
+	struct kmemcheck_error *e;
+
+	/* Don't report several adjacent errors from the same EIP. */
+	if (regs->ip == prev_ip)
+		return;
+	prev_ip = regs->ip;
+
+	e = error_next_wr();
+	if (!e)
+		return;
+
+	e->state = state;
+	e->address = address;
+	e->size = size;
+
+	/* Save regs */
+	memcpy(&e->regs, regs, sizeof(*regs));
+
+	/* Save stack trace */
+	e->trace.nr_entries = 0;
+	e->trace.entries = e->trace_entries;
+	e->trace.max_entries = ARRAY_SIZE(e->trace_entries);
+	e->trace.skip = 4;
+	save_stack_trace(&e->trace);
+
+	if (kmemcheck_thread)
+		wake_up_process(kmemcheck_thread);
+}
+
+static void
+error_recall(void)
+{
+	static const char *desc[] = {
+		[SHADOW_UNALLOCATED]	= "unallocated",
+		[SHADOW_UNINITIALIZED]	= "uninitialized",
+		[SHADOW_INITIALIZED]	= "initialized",
+		[SHADOW_FREED]		= "freed",
+	};
+
+	struct kmemcheck_error *e;
+
+	e = error_next_rd();
+	if (!e)
+		return;
+
+	printk(KERN_ALERT "kmemcheck: Caught %d-bit read from %s memory\n",
+		e->size, desc[e->state]);
+	printk(KERN_ALERT "=> address %08x\n", e->address);
+
+	__show_registers(&e->regs, 1);
+	print_stack_trace(&e->trace, 0);
+}
+
+/*
+ * The error reporter thread.
+ */
+static int
+kmemcheck_thread_run(void *data)
+{
+	while (true) {
+		while (error_count > 0)
+			error_recall();
+
+		/* Sleep */
+		set_current_state(TASK_INTERRUPTIBLE);
+		schedule();
+	}
+}
+
+static int
+init(void)
+{
+	struct task_struct *t;
+
+	printk(KERN_INFO "kmemcheck: \"Bugs, beware!\"\n");
+
+	t = kthread_create(&kmemcheck_thread_run, NULL,
+		"kmemcheck");
+	if (IS_ERR(t)) {
+		printk(KERN_ERR "kmemcheck: Couldn't start output thread\n");
+		return PTR_ERR(t);
+	}
+
+	kmemcheck_thread = t;
+	wake_up_process(kmemcheck_thread);
+	return 0;
+}
+
+core_initcall(init);
+
+/*
+ * Return the shadow address for the given address. Returns NULL if the
+ * address is not tracked.
+ */
+static void *
+address_get_shadow(unsigned long address)
+{
+	struct page *page;
+	struct page *head;
+
+	if (address < PAGE_OFFSET)
+		return NULL;
+	page = virt_to_page(address);
+	if (!page)
+		return NULL;
+	head = compound_head(page);
+	if (!head)
+		return NULL;
+	if (!PageSlab(head))
+		return NULL;
+	if (!PageTracked(head))
+		return NULL;
+	return (void *) address + (PAGE_SIZE << (compound_order(head) - 1));
+}
+
+static int
+show_addr(uint32_t addr)
+{
+	pte_t *pte;
+	int level;
+
+	if (!address_get_shadow(addr))
+		return 0;
+
+	pte = lookup_address(addr, &level);
+	BUG_ON(!pte);
+	BUG_ON(level != PG_LEVEL_4K);
+
+	pte->pte_low |= _PAGE_PRESENT;
+	__flush_tlb_one(addr);
+	return 1;
+}
+
+static int
+hide_addr(uint32_t addr)
+{
+	pte_t *pte;
+	int level;
+
+	if (!address_get_shadow(addr))
+		return 0;
+
+	pte = lookup_address(addr, &level);
+	BUG_ON(!pte);
+	BUG_ON(level != PG_LEVEL_4K);
+
+	pte->pte_low &= ~_PAGE_PRESENT;
+	__flush_tlb_one(addr);
+	return 1;
+}
+
+DEFINE_PER_CPU(bool, kmemcheck_busy) = false;
+DEFINE_PER_CPU(uint32_t, kmemcheck_addr1) = 0;
+DEFINE_PER_CPU(uint32_t, kmemcheck_addr2) = 0;
+DEFINE_PER_CPU(uint32_t, kmemcheck_reg_flags) = 0;
+
+DEFINE_PER_CPU(int, kmemcheck_num) = 0;
+DEFINE_PER_CPU(int, kmemcheck_balance) = 0;
+
+/*
+ * Called from the #PF handler.
+ */
+void
+kmemcheck_show(struct pt_regs *regs)
+{
+	int n;
+
+	BUG_ON(!irqs_disabled());
+
+	if (__get_cpu_var(kmemcheck_balance) != 0) {
+		oops_in_progress = 1;
+		panic("kmemcheck: extra #PF");
+	}
+
+	++__get_cpu_var(kmemcheck_num);
+
+	BUG_ON(!__get_cpu_var(kmemcheck_addr1)
+		&& !__get_cpu_var(kmemcheck_addr2));
+
+	n = 0;
+	n += show_addr(__get_cpu_var(kmemcheck_addr1));
+	n += show_addr(__get_cpu_var(kmemcheck_addr2));
+
+	/* None of the addresses actually belonged to kmemcheck. Note that
+	 * this is not an error. */
+	if (n == 0)
+		return;
+
+	++__get_cpu_var(kmemcheck_balance);
+	++__get_cpu_var(kmemcheck_num);
+
+	/*
+	 * The IF needs to be cleared as well, so that the faulting
+	 * instruction can run "uninterrupted". Otherwise, we might take
+	 * an interrupt and start executing that before we've had a chance
+	 * to hide the page again.
+	 *
+	 * NOTE: In the rare case of multiple faults, we must not override
+	 * the original flags:
+	 */
+	if (!(regs->flags & TF_MASK))
+		__get_cpu_var(kmemcheck_reg_flags) = regs->flags;
+
+	regs->flags |= TF_MASK;
+	regs->flags &= ~IF_MASK;
+}
+
+/*
+ * Called from the #DB handler.
+ */
+void
+kmemcheck_hide(struct pt_regs *regs)
+{
+	BUG_ON(!irqs_disabled());
+
+	--__get_cpu_var(kmemcheck_balance);
+	if (unlikely(__get_cpu_var(kmemcheck_balance) != 0)) {
+		oops_in_progress = 1;
+		panic("kmemcheck: extra #DB");
+	}
+
+	hide_addr(__get_cpu_var(kmemcheck_addr1));
+	hide_addr(__get_cpu_var(kmemcheck_addr2));
+	__get_cpu_var(kmemcheck_addr1) = 0;
+	__get_cpu_var(kmemcheck_addr2) = 0;
+
+	if (!(__get_cpu_var(kmemcheck_reg_flags) & TF_MASK))
+		regs->flags &= ~TF_MASK;
+	if (__get_cpu_var(kmemcheck_reg_flags) & IF_MASK)
+		regs->flags |= IF_MASK;
+}
+
+void
+kmemcheck_prepare(struct pt_regs *regs)
+{
+	/*
+	 * Detect and handle recursive pagefaults:
+	 */
+	if (__get_cpu_var(kmemcheck_balance) > 0) {
+		panic_timeout++;
+		/*
+		 * We can have multi-address faults from accesses like:
+		 *
+		 *          rep movsb %ds:(%esi),%es:(%edi)
+		 *
+		 * So in this case, we hide the current in-progress fault
+		 * and handle when we detect this recursion, we hide the
+		 * currently in-progress addresses again.
+		 */
+		kmemcheck_hide(regs);
+	}
+}
+
+void
+kmemcheck_show_pages(struct page *p, unsigned int n)
+{
+	unsigned int i;
+	struct page *head;
+
+	head = compound_head(p);
+	BUG_ON(!head);
+
+	ClearPageTracked(head);
+
+	for (i = 0; i < n; ++i) {
+		unsigned long address;
+		pte_t *pte;
+		int level;
+
+		address = (unsigned long) page_address(&p[i]);
+		pte = lookup_address(address, &level);
+		BUG_ON(!pte);
+		BUG_ON(level != PG_LEVEL_4K);
+
+		pte->pte_low |= _PAGE_PRESENT;
+		pte->pte_low &= ~_PAGE_HIDDEN;
+		__flush_tlb_one(address);
+	}
+}
+
+void
+kmemcheck_hide_pages(struct page *p, unsigned int n)
+{
+	unsigned int i;
+	struct page *head;
+
+	head = compound_head(p);
+	BUG_ON(!head);
+
+	SetPageTracked(head);
+
+	for (i = 0; i < n; ++i) {
+		unsigned long address;
+		pte_t *pte;
+		int level;
+
+		address = (unsigned long) page_address(&p[i]);
+		pte = lookup_address(address, &level);
+		BUG_ON(!pte);
+		BUG_ON(level != PG_LEVEL_4K);
+
+		pte->pte_low &= ~_PAGE_PRESENT;
+		pte->pte_low |= _PAGE_HIDDEN;
+		__flush_tlb_one(address);
+	}
+}
+
+static void
+mark_shadow(void *address, unsigned int n, enum shadow status)
+{
+	void *shadow;
+
+	shadow = address_get_shadow((unsigned long) address);
+	if (!shadow)
+		return;
+	__memset(shadow, status, n);
+}
+
+void
+kmemcheck_mark_unallocated(void *address, unsigned int n)
+{
+	mark_shadow(address, n, SHADOW_UNALLOCATED);
+}
+
+void
+kmemcheck_mark_uninitialized(void *address, unsigned int n)
+{
+	mark_shadow(address, n, SHADOW_UNINITIALIZED);
+}
+
+/*
+ * Fill the shadow memory of the given address such that the memory at that
+ * address is marked as being initialized.
+ */
+void
+kmemcheck_mark_initialized(void *address, unsigned int n)
+{
+	mark_shadow(address, n, SHADOW_INITIALIZED);
+}
+
+void
+kmemcheck_mark_freed(void *address, unsigned int n)
+{
+	mark_shadow(address, n, SHADOW_FREED);
+}
+
+void
+kmemcheck_mark_unallocated_pages(struct page *p, unsigned int n)
+{
+	unsigned int i;
+
+	for (i = 0; i < n; ++i)
+		kmemcheck_mark_unallocated(page_address(&p[i]), PAGE_SIZE);
+}
+
+void
+kmemcheck_mark_uninitialized_pages(struct page *p, unsigned int n)
+{
+	unsigned int i;
+
+	for (i = 0; i < n; ++i)
+		kmemcheck_mark_uninitialized(page_address(&p[i]), PAGE_SIZE);
+}
+
+static bool
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
+opcode_get_size(const uint8_t *op)
+{
+	/* Default operand size */
+	int operand_size_override = 32;
+
+	/* prefixes */
+	for (; opcode_is_prefix(*op); ++op) {
+		if (*op == 0x66)
+			operand_size_override = 16;
+	}
+
+	/* escape opcode */
+	if (*op == 0x0f) {
+		++op;
+
+		if (*op == 0xb6)
+			return operand_size_override >> 1;
+		if (*op == 0xb7)
+			return 16;
+	}
+
+	return (*op & 1) ? operand_size_override : 8;
+}
+
+static const uint8_t *
+opcode_get_primary(const uint8_t *op)
+{
+	/* skip prefixes */
+	for (; opcode_is_prefix(*op); ++op);
+	return op;
+}
+
+static inline enum shadow
+test(void *shadow, unsigned int size)
+{
+	uint8_t *x;
+
+	x = shadow;
+
+#ifdef CONFIG_KMEMCHECK_PARTIAL_OK
+	/*
+	 * Make sure _some_ bytes are initialized. Gcc frequently generates
+	 * code to access neighboring bytes.
+	 */
+	switch (size) {
+	case 32:
+		if (x[3] == SHADOW_INITIALIZED)
+			return x[3];
+		if (x[2] == SHADOW_INITIALIZED)
+			return x[2];
+	case 16:
+		if (x[1] == SHADOW_INITIALIZED)
+			return x[1];
+	case 8:
+		if (x[0] == SHADOW_INITIALIZED)
+			return x[0];
+	}
+#else
+	switch (size) {
+	case 32:
+		if (x[3] != SHADOW_INITIALIZED)
+			return x[3];
+		if (x[2] != SHADOW_INITIALIZED)
+			return x[2];
+	case 16:
+		if (x[1] != SHADOW_INITIALIZED)
+			return x[1];
+	case 8:
+		if (x[0] != SHADOW_INITIALIZED)
+			return x[0];
+	}
+#endif
+
+	return x[0];
+}
+
+static inline void
+set(void *shadow, unsigned int size)
+{
+	uint8_t *x;
+
+	x = shadow;
+
+	switch (size) {
+	case 32:
+		x[3] = SHADOW_INITIALIZED;
+		x[2] = SHADOW_INITIALIZED;
+	case 16:
+		x[1] = SHADOW_INITIALIZED;
+	case 8:
+		x[0] = SHADOW_INITIALIZED;
+	}
+
+	return;
+}
+
+static void
+kmemcheck_read(struct pt_regs *regs, uint32_t address, unsigned int size)
+{
+	void *shadow;
+	enum shadow status;
+
+	shadow = address_get_shadow(address);
+	if (!shadow)
+		return;
+
+	status = test(shadow, size);
+	if (status == SHADOW_INITIALIZED)
+		return;
+
+	/* Don't warn about it again. */
+	set(shadow, size);
+
+	oops_in_progress = 1;
+	error_save(status, address, size, regs);
+}
+
+static void
+kmemcheck_write(struct pt_regs *regs, uint32_t address, unsigned int size)
+{
+	void *shadow;
+
+	shadow = address_get_shadow(address);
+	if (!shadow)
+		return;
+	set(shadow, size);
+}
+
+void
+kmemcheck_access(struct pt_regs *regs,
+	unsigned long fallback_address, enum kmemcheck_method fallback_method)
+{
+	const uint8_t *insn;
+	const uint8_t *insn_primary;
+	unsigned int size;
+
+	if (__get_cpu_var(kmemcheck_busy)) {
+		oops_in_progress = 1;
+		panic("kmemcheck: recursive fault");
+	}
+
+	__get_cpu_var(kmemcheck_busy) = true;
+
+	insn = (const uint8_t *) regs->ip;
+	insn_primary = opcode_get_primary(insn);
+
+	size = opcode_get_size(insn);
+
+	switch (insn_primary[0]) {
+#ifdef CONFIG_KMEMCHECK_BITOPS_OK
+		/* AND, OR, XOR */
+		/*
+		 * Unfortunately, these instructions have to be excluded from
+		 * our regular checking since they access only some (and not
+		 * all) bits. This clears out "bogus" bitfield-access warnings.
+		 */
+	case 0x80:
+	case 0x81:
+	case 0x82:
+	case 0x83:
+		switch ((insn_primary[1] >> 3) & 7) {
+			/* OR */
+		case 1:
+			/* AND */
+		case 4:
+			/* XOR */
+		case 6:
+			kmemcheck_write(regs, fallback_address, size);
+			__get_cpu_var(kmemcheck_addr1) = fallback_address;
+			__get_cpu_var(kmemcheck_addr2) = 0;
+			__get_cpu_var(kmemcheck_busy) = false;
+			return;
+
+			/* ADD */
+		case 0:
+			/* ADC */
+		case 2:
+			/* SBB */
+		case 3:
+			/* SUB */
+		case 5:
+			/* CMP */
+		case 7:
+			break;
+		}
+		break;
+#endif
+
+		/* MOVS, MOVSB, MOVSW, MOVSD */
+	case 0xa4:
+	case 0xa5:
+		/* These instructions are special because they take two
+		 * addresses, but we only get one page fault. */
+		kmemcheck_read(regs, regs->si, size);
+		kmemcheck_write(regs, regs->di, size);
+		__get_cpu_var(kmemcheck_addr1) = regs->si;
+		__get_cpu_var(kmemcheck_addr2) = regs->di;
+		__get_cpu_var(kmemcheck_busy) = false;
+		return;
+
+		/* CMPS, CMPSB, CMPSW, CMPSD */
+	case 0xa6:
+	case 0xa7:
+		kmemcheck_read(regs, regs->si, size);
+		kmemcheck_read(regs, regs->di, size);
+		__get_cpu_var(kmemcheck_addr1) = regs->si;
+		__get_cpu_var(kmemcheck_addr2) = regs->di;
+		__get_cpu_var(kmemcheck_busy) = false;
+		return;
+	}
+
+	/* If the opcode isn't special in any way, we use the data from the
+	 * page fault handler to determine the address and type of memory
+	 * access. */
+	switch (fallback_method) {
+	case KMEMCHECK_READ:
+		kmemcheck_read(regs, fallback_address, size);
+		__get_cpu_var(kmemcheck_addr1) = fallback_address;
+		__get_cpu_var(kmemcheck_addr2) = 0;
+		__get_cpu_var(kmemcheck_busy) = false;
+		return;
+	case KMEMCHECK_WRITE:
+		kmemcheck_write(regs, fallback_address, size);
+		__get_cpu_var(kmemcheck_addr1) = fallback_address;
+		__get_cpu_var(kmemcheck_addr2) = 0;
+		__get_cpu_var(kmemcheck_busy) = false;
+		return;
+	}
+}
+
+/*
+ * A faster implementation of memset() when tracking is enabled where the
+ * whole memory area is within a single page.
+ */
+static void
+memset_one_page(unsigned long s, int c, size_t n)
+{
+	void *x;
+	unsigned long flags;
+
+	x = address_get_shadow(s);
+	if (!x) {
+		/* The page isn't being tracked. */
+		__memset((void *) s, c, n);
+		return;
+	}
+
+	/* While we are not guarding the page in question, nobody else
+	 * should be able to change them. */
+	local_irq_save(flags);
+
+	show_addr(s);
+	__memset((void *) s, c, n);
+	__memset((void *) x, SHADOW_INITIALIZED, n);
+	hide_addr(s);
+
+	local_irq_restore(flags);
+}
+
+/*
+ * A faster implementation of memset() when tracking is enabled. We cannot
+ * assume that all pages within the range are tracked, so copying has to be
+ * split into page-sized (or smaller, for the ends) chunks.
+ */
+void
+kmemcheck_memset(unsigned long s, int c, size_t n)
+{
+	unsigned long a_page, a_offset;
+	unsigned long b_page, b_offset;
+	unsigned long i;
+
+	if (!n)
+		return;
+
+	if (!slab_is_available()) {
+		__memset((void *) s, c, n);
+		return;
+	}
+
+	a_page = s & PAGE_MASK;
+	b_page = (s + n) & PAGE_MASK;
+
+	if (a_page == b_page) {
+		/* The entire area is within the same page. Good, we only
+		 * need one memset(). */
+		memset_one_page(s, c, n);
+		return;
+	}
+
+	a_offset = s & ~PAGE_MASK;
+	b_offset = (s + n) & ~PAGE_MASK;
+
+	/* Clear the head, body, and tail of the memory area. */
+	if (a_offset < PAGE_SIZE)
+		memset_one_page(s, c, PAGE_SIZE - a_offset);
+	for (i = a_page + PAGE_SIZE; i < b_page; i += PAGE_SIZE)
+		memset_one_page(i, c, PAGE_SIZE);
+	if (b_offset > 0)
+		memset_one_page(b_page, c, b_offset);
+}
+
+EXPORT_SYMBOL(kmemcheck_memset);
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
index 0000000..295e256
--- /dev/null
+++ b/include/asm-x86/kmemcheck_32.h
@@ -0,0 +1,22 @@
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
+void kmemcheck_prepare(struct pt_regs *regs);
+
+void kmemcheck_show(struct pt_regs *regs);
+void kmemcheck_hide(struct pt_regs *regs);
+
+void kmemcheck_access(struct pt_regs *regs,
+	unsigned long address, enum kmemcheck_method method);
+#endif
+
+#endif
diff --git a/include/asm-x86/pgtable.h b/include/asm-x86/pgtable.h
index 174b877..eb64bbb 100644
--- a/include/asm-x86/pgtable.h
+++ b/include/asm-x86/pgtable.h
@@ -17,8 +17,8 @@
  #define _PAGE_BIT_GLOBAL	8	/* Global TLB entry PPro+ */
  #define _PAGE_BIT_UNUSED1	9	/* available for programmer */
  #define _PAGE_BIT_UNUSED2	10
-#define _PAGE_BIT_UNUSED3	11
  #define _PAGE_BIT_PAT_LARGE	12	/* On 2MB or 1GB pages */
+#define _PAGE_BIT_HIDDEN	11
  #define _PAGE_BIT_NX           63       /* No execute: only valid after cpuid check */

  /*
@@ -37,9 +37,9 @@
  #define _PAGE_GLOBAL	(_AC(1, L)<<_PAGE_BIT_GLOBAL)	/* Global TLB entry */
  #define _PAGE_UNUSED1	(_AC(1, L)<<_PAGE_BIT_UNUSED1)
  #define _PAGE_UNUSED2	(_AC(1, L)<<_PAGE_BIT_UNUSED2)
-#define _PAGE_UNUSED3	(_AC(1, L)<<_PAGE_BIT_UNUSED3)
  #define _PAGE_PAT	(_AC(1, L)<<_PAGE_BIT_PAT)
  #define _PAGE_PAT_LARGE (_AC(1, L)<<_PAGE_BIT_PAT_LARGE)
+#define _PAGE_HIDDEN	(_AC(1, L)<<_PAGE_BIT_HIDDEN)

  #if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
  #define _PAGE_NX	(_AC(1, ULL) << _PAGE_BIT_NX)
diff --git a/include/asm-x86/pgtable_32.h b/include/asm-x86/pgtable_32.h
index a842c72..6830703 100644
--- a/include/asm-x86/pgtable_32.h
+++ b/include/asm-x86/pgtable_32.h
@@ -87,6 +87,7 @@ void paging_init(void);
  extern unsigned long pg0[];

  #define pte_present(x)	((x).pte_low & (_PAGE_PRESENT | _PAGE_PROTNONE))
+#define pte_hidden(x)	((x).pte_low & (_PAGE_HIDDEN))

  /* To avoid harmful races, pmd_none(x) should check only the lower when PAE */
  #define pmd_none(x)	(!(unsigned long)pmd_val(x))
diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 0c6ce51..2138d64 100644
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
diff --git a/include/linux/kmemcheck.h b/include/linux/kmemcheck.h
new file mode 100644
index 0000000..407bc5c
--- /dev/null
+++ b/include/linux/kmemcheck.h
@@ -0,0 +1,17 @@
+#ifndef LINUX_KMEMCHECK_H
+#define LINUX_KMEMCHECK_H
+
+#ifdef CONFIG_KMEMCHECK
+void kmemcheck_show_pages(struct page *p, unsigned int n);
+void kmemcheck_hide_pages(struct page *p, unsigned int n);
+
+void kmemcheck_mark_unallocated(void *address, unsigned int n);
+void kmemcheck_mark_uninitialized(void *address, unsigned int n);
+void kmemcheck_mark_initialized(void *address, unsigned int n);
+void kmemcheck_mark_freed(void *address, unsigned int n);
+
+void kmemcheck_mark_unallocated_pages(struct page *p, unsigned int n);
+void kmemcheck_mark_uninitialized_pages(struct page *p, unsigned int n);
+#endif
+
+#endif
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index bbad43f..1593859 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -90,6 +90,8 @@
  #define PG_reclaim		17	/* To be reclaimed asap */
  #define PG_buddy		19	/* Page is free, on buddy lists */

+#define PG_tracked		20	/* Page is tracked by kmemcheck */
+
  /* PG_readahead is only used for file reads; PG_reclaim is only for writes */
  #define PG_readahead		PG_reclaim /* Reminder to do async read-ahead */

@@ -296,6 +298,11 @@ static inline void __ClearPageTail(struct page *page)
  #define SetPageUncached(page)	set_bit(PG_uncached, &(page)->flags)
  #define ClearPageUncached(page)	clear_bit(PG_uncached, &(page)->flags)

+#define PageTracked(page)	test_bit(PG_tracked, &(page)->flags)
+#define SetPageTracked(page)	set_bit(PG_tracked, &(page)->flags)
+#define ClearPageTracked(page)	clear_bit(PG_tracked, &(page)->flags)
+
+
  struct page;	/* forward declaration */

  extern void cancel_dirty_page(struct page *page, unsigned int account_size);
-- 
1.5.3.8
