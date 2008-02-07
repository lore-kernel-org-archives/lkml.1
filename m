Return-Path: <linux-kernel-owner+w=401wt.eu-S964889AbYBGVi7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964889AbYBGVi7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 16:38:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935378AbYBGVgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 16:36:32 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:23290 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762880AbYBGVg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 16:36:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=iwoL2Khgq4XjChwICn7nQuUmS3S7g/oT2tSrnKggMHPFw977sFuIXk6JxvESLlDfszKDJPgst2wOfIk3vZg9ZRkqXTmYHrHe/zfFCNoN1KrqLDit0ydt9uAWeZLUJlOHspnB4DvhJXrMiJrHRYlnINCmPQKr8Y/grC2FeOTJZEc=
Message-ID: <47AB79D4.2070605@gmail.com>
Date: Thu, 07 Feb 2008 22:36:20 +0100
From: Vegard Nossum <vegard.nossum@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Andi Kleen <andi@firstfloor.org>,
       Richard Knutsson <ricknu-0@student.ltu.se>,
       Christoph Lameter <clameter@sgi.com>
Subject: [PATCH 1/2] kmemcheck v3
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

With a lot of help from Ingo Molnar and Pekka Enberg over the last couple of
weeks, we've been able to produce a new version of kmemcheck!

General description: kmemcheck is a patch to the linux kernel that detects
use of uninitialized memory. It does this by trapping every read and write to
memory that was allocated dynamically (e.g. using kmalloc()). If a memory
address is read that has not previously been written to, a message is printed
to the kernel log.

Changes since v2:
- Don't use change_page_attr()
- Clean up the use of PTE flags. In particular, we don't mess with the
   existing flags, we simply add a new flag called HIDDEN
- Clean up the use of gfp flags. We now have a separate SLAB_NOTRACK flag
   for slab caches in addition to  __GFP_NOTRACK
- Mask interrupts while we are executing the faulting instruction
- Handle CMPS instructions correctly
- Provide a (faster) memset() that doesn't go through the #PF/#DB dance
- More debugging facilities
- Allow (optionally) partially uninitialized reads
- It actually boots!

In addition, we have a second patch (thanks to Ingo) to be applied on top of
the core kmemcheck -- this silences a few of the bogus reports.

The current version of the patch boots on real hardware, but we've seen
freezes on some machines, so it's not perfect yet. (In other words, this
patch is HIGHLY experimental, and run at your own risk, etc.)

Other errors that still need to be resolved:
- SLUB uses the first few bytes of an object as a pointer to the next free
   object (the so-called freepointer). Because of this, those bytes will
   almost always be marked "initialized" although they aren't really.
- DMA can be a problem since there's generally no way for kmemcheck to
   determine when/if a chunk of memory is used for DMA. Ideally, DMA should be
   allocated with untracked caches, but this requires annotation of the
   drivers in question.

The patch applies to linux-2.6.git.

Kind regards,
Vegard Nossum



  arch/x86/Kconfig.debug         |   35 +++
  arch/x86/kernel/Makefile       |    2 +
  arch/x86/kernel/cpu/common.c   |    7 +
  arch/x86/kernel/entry_32.S     |    8 +-
  arch/x86/kernel/kmemcheck_32.c |  612 ++++++++++++++++++++++++++++++++++++++++
  arch/x86/kernel/traps_32.c     |   22 ++-
  arch/x86/mm/fault.c            |   21 ++-
  arch/x86/mm/pgtable_32.c       |    4 +-
  include/asm-x86/kmemcheck.h    |    3 +
  include/asm-x86/kmemcheck_32.h |   22 ++
  include/asm-x86/pgtable.h      |    4 +-
  include/asm-x86/pgtable_32.h   |    1 +
  include/asm-x86/string_32.h    |    8 +
  include/linux/gfp.h            |    3 +-
  include/linux/kmemcheck.h      |   12 +
  include/linux/slab.h           |    1 +
  kernel/fork.c                  |   15 +-
  mm/slub.c                      |   97 ++++++-
  18 files changed, 840 insertions(+), 37 deletions(-)


Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index fa55514..16b2b01 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -138,6 +138,41 @@ config IOMMU_LEAK
  	  Add a simple leak tracer to the IOMMU code. This is useful when you
  	  are debugging a buggy device driver that leaks IOMMU mappings.

+config KMEMCHECK
+	bool "kmemcheck: trap use of uninitialized memory"
+	depends on M386 && !X86_GENERIC && !SMP
+	depends on !CC_OPTIMIZE_FOR_SIZE
+	depends on !DEBUG_PAGEALLOC && SLUB
+	select DEBUG_INFO
+	select FRAME_POINTER
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
+config KMEMCHECK_DEBUG
+	bool "kmemcheck: extra debug information"
+	depends on KMEMCHECK
+	select STACKTRACE
+	default n
+	help
+	  This option will cause kmemcheck to record some more information
+	  that will be printed out in the case of a fatal error within
+	  kmemcheck itself.
+
  #
  # IO delay types:
  #
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 21dc1a0..98bd6cc 100644
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
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index f86a3c4..83cd359 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -634,6 +634,13 @@ void __init early_cpu_init(void)
  	nexgen_init_cpu();
  	umc_init_cpu();
  	early_cpu_detect();
+
+#ifdef CONFIG_KMEMCHECK
+	/*
+	 * We need 4K granular PTEs for kmemcheck:
+	 */
+	setup_clear_cpu_cap(X86_FEATURE_PSE);
+#endif
  }

  /* Make sure %fs is initialized properly in idle threads */
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index be5c31d..6247eae 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -289,7 +289,7 @@ ENTRY(ia32_sysenter_target)
  	CFI_DEF_CFA esp, 0
  	CFI_REGISTER esp, ebp
  	movl TSS_sysenter_sp0(%esp),%esp
-sysenter_past_esp:
+ENTRY(sysenter_past_esp)
  	/*
  	 * No need to follow this irqs on/off section: the syscall
  	 * disabled irqs and here we enable it straight after entry:
@@ -766,7 +766,7 @@ label:						\
  	CFI_ADJUST_CFA_OFFSET 4;		\
  	CFI_REL_OFFSET eip, 0

-KPROBE_ENTRY(debug)
+KPROBE_ENTRY(x86_debug)
  	RING0_INT_FRAME
  	cmpl $ia32_sysenter_target,(%esp)
  	jne debug_stack_correct
@@ -780,7 +780,7 @@ debug_stack_correct:
  	call do_debug
  	jmp ret_from_exception
  	CFI_ENDPROC
-KPROBE_END(debug)
+KPROBE_END(x86_debug)

  /*
   * NMI is doubly nasty. It can happen _while_ we're handling
@@ -834,7 +834,7 @@ nmi_debug_stack_check:
  	/* We have a RING0_INT_FRAME here */
  	cmpw $__KERNEL_CS,16(%esp)
  	jne nmi_stack_correct
-	cmpl $debug,(%esp)
+	cmpl $x86_debug,(%esp)
  	jb nmi_stack_correct
  	cmpl $debug_esp_fix_insn,(%esp)
  	ja nmi_stack_correct
diff --git a/arch/x86/kernel/kmemcheck_32.c b/arch/x86/kernel/kmemcheck_32.c
new file mode 100644
index 0000000..01c9243
--- /dev/null
+++ b/arch/x86/kernel/kmemcheck_32.c
@@ -0,0 +1,612 @@
+/**
+ * kmemcheck - a heavyweight memory checker
+ * Copyright (C) 2007, 2008  Vegard Nossum
+ * (With a lot of help from Ingo Molnar and Pekka Enberg.)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License (version 2) as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kallsyms.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/page-flags.h>
+#include <linux/stacktrace.h>
+
+#include <asm/cacheflush.h>
+#include <asm/kmemcheck.h>
+#include <asm/pgtable.h>
+#include <asm/string.h>
+#include <asm/tlbflush.h>
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
+	if (!head->slab)
+		return NULL;
+	if (head->slab->flags & SLAB_NOTRACK)
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
+#ifdef CONFIG_KMEMCHECK_DEBUG
+static struct stack_trace trace;
+static unsigned long trace_entries[256];
+
+static struct pt_regs regs_prev;
+
+static void
+dump_regs(const char *name, struct pt_regs *regs)
+{
+	printk(KERN_EMERG "%s regs:\n", name);
+	printk(KERN_EMERG "eip: %08lx\n", regs->ip);
+	printk(KERN_EMERG "eax: %08lx ebx: %08lx\n", regs->ax, regs->bx);
+	printk(KERN_EMERG "ecx: %08lx edx: %08lx\n", regs->cx, regs->dx);
+	printk(KERN_EMERG "esi: %08lx edi: %08lx\n", regs->si, regs->di);
+	printk(KERN_EMERG "\n");
+}
+#endif
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
+	if (regs->flags & TF_MASK) {
+		/* Why did we enter the #PF from a context that was already
+		 * single-stepping? */
+
+		oops_in_progress = 1;
+		printk(KERN_EMERG "kmemcheck: entered #PF from single-"
+			"stepping cotext.\n");
+
+#ifdef CONFIG_KMEMCHECK_DEBUG
+		dump_regs("current", regs);
+		dump_regs("prev", &regs_prev);
+
+		dump_stack();
+		print_stack_trace(&trace, 0);
+#endif
+
+		panic("kmemcheck");
+	}
+
+	if (__get_cpu_var(kmemcheck_balance) != 0) {
+		oops_in_progress = 1;
+		printk(KERN_EMERG "kmemcheck: missed a #DB.\n");
+
+#ifdef CONFIG_KMEMCHECK_DEBUG
+		dump_regs("current", regs);
+		dump_regs("prev", &regs_prev);
+
+		dump_stack();
+		print_stack_trace(&trace, 0);
+#endif
+		panic("kmemcheck");
+	} else {
+#ifdef CONFIG_KMEMCHECK_DEBUG
+		memcpy(&regs_prev, regs, sizeof(regs_prev));
+
+		trace.nr_entries = 0;
+		trace.entries = trace_entries;
+		trace.max_entries = ARRAY_SIZE(trace_entries);
+		trace.skip = 0;
+		save_stack_trace(&trace);
+#endif
+
+		++__get_cpu_var(kmemcheck_num);
+	}
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
+#ifdef CONFIG_KMEMCHECK_DEBUG
+		memcpy(&regs_prev, regs, sizeof(regs_prev));
+
+		trace.nr_entries = 0;
+		trace.entries = trace_entries;
+		trace.max_entries = ARRAY_SIZE(trace_entries);
+		trace.skip = 0;
+		save_stack_trace(&trace);
+#endif
+		return;
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
+kmemcheck_show_pages(struct page *p, unsigned int n)
+{
+	unsigned int i;
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
+/*
+ * Fill the shadow memory of the given address such that the memory at that
+ * address is marked as being initialized.
+ */
+void
+kmemcheck_fill_shadow(void *address, unsigned int n)
+{
+	void *shadow;
+
+	shadow = address_get_shadow((unsigned long) address);
+	if (!shadow)
+		return;
+	__memset(shadow, 0xff, n);
+}
+
+/*
+ * Clear the shadow memory of the given pages such that the memory at those
+ * addresses is marked as being uninitialized.
+ */
+void
+kmemcheck_clear_shadow_pages(struct page *p, unsigned int n)
+{
+	unsigned int i;
+
+	for (i = 0; i < n; ++i)
+		clear_page(page_address(&p[i]));
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
+static uint8_t
+opcode_get_primary(const uint8_t *op)
+{
+	/* skip prefixes */
+	for (; opcode_is_prefix(*op); ++op);
+	return *op;
+}
+
+static bool
+test(void *shadow, unsigned int size)
+{
+#ifdef CONFIG_KMEMCHECK_PARTIAL_OK
+	/*
+	 * Make sure _some_ bytes are initialized. Gcc frequently generates
+	 * code to access neighboring bytes.
+	 */
+	switch (size) {
+	case 8:
+		return *(uint8_t *) shadow != 0;
+	case 16:
+		return *(uint16_t *) shadow != 0;
+	case 32:
+		return *(uint32_t *) shadow != 0;
+	}
+#else
+	switch (size) {
+	case 8:
+		return *(uint8_t *) shadow == 0xff;
+	case 16:
+		return *(uint16_t *) shadow == 0xffff;
+	case 32:
+		return *(uint32_t *) shadow == 0xffffffff;
+	}
+#endif
+
+	BUG();
+	return false;
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
+kmemcheck_read(uint32_t eip, uint32_t address, unsigned int size,
+	       struct pt_regs *regs)
+{
+	void *shadow;
+
+	shadow = address_get_shadow(address);
+	if (!shadow)
+		return;
+	if (!test(shadow, size)) {
+		static uint32_t prev_eip;
+
+		/* Don't warn about it again. */
+		set(shadow, size);
+
+		oops_in_progress = 1;
+		printk(KERN_ALERT
+			"kmemcheck: Caught uninitialized %d-bit read:\n",
+				size);
+		printk(KERN_ALERT
+			"=> from EIP = %08x ", eip);
+		print_symbol("(%s), ", eip);
+		printk("address %08x\n", address);
+
+		/*
+		 * Some kind of rate-limiter; if we already printed a message
+		 * that originated from the same EIP, don't spam the logs
+		 * with new traces.
+		 */
+		if (eip != prev_eip) {
+			prev_eip = eip;
+			show_regs(regs);
+		}
+	}
+}
+
+static void
+kmemcheck_write(uint32_t eip, uint32_t address, unsigned int size)
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
+kmemcheck_access(struct pt_regs *regs,
+	unsigned long fallback_address, enum kmemcheck_method fallback_method)
+{
+	const uint8_t *insn;
+	unsigned int size;
+
+	if (__get_cpu_var(kmemcheck_busy)) {
+		static int warn_once = 1;
+		if (!warn_once)
+			return;
+		warn_once = 0;
+
+		oops_in_progress = 1;
+		printk(KERN_EMERG "kmemcheck: It seems that kmemcheck itself "
+			"triggered a page fault :-( This generally "
+			"means that some book-keeping memory was not "
+			"allocated with the __GFP_NOTRACK flag, which it "
+			"should be (where was %08lx allocated at?)\n",
+			fallback_address);
+		show_regs(regs);
+		BUG();
+		return;
+	}
+
+	__get_cpu_var(kmemcheck_busy) = true;
+
+	insn = (const uint8_t *) regs->ip;
+	size = opcode_get_size(insn);
+
+	switch (opcode_get_primary(insn)) {
+		/* MOVS, MOVSB, MOVSW, MOVSD */
+	case 0xa4:
+	case 0xa5:
+		/* These instructions are special because they take two
+		 * addresses, but we only get one page fault. */
+		kmemcheck_read(regs->ip, regs->si, size, regs);
+		kmemcheck_write(regs->ip, regs->di, size);
+		__get_cpu_var(kmemcheck_addr1) = regs->si;
+		__get_cpu_var(kmemcheck_addr2) = regs->di;
+		__get_cpu_var(kmemcheck_busy) = false;
+		return;
+
+		/* CMPS, CMPSB, CMPSW, CMPSD */
+	case 0xa6:
+	case 0xa7:
+		kmemcheck_read(regs->ip, regs->si, size, regs);
+		kmemcheck_read(regs->ip, regs->di, size, regs);
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
+		kmemcheck_read(regs->ip, fallback_address, size, regs);
+		__get_cpu_var(kmemcheck_addr1) = fallback_address;
+		__get_cpu_var(kmemcheck_addr2) = 0;
+		__get_cpu_var(kmemcheck_busy) = false;
+		return;
+	case KMEMCHECK_WRITE:
+		kmemcheck_write(regs->ip, fallback_address, size);
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
+	__memset((void *) x, 0xff, n);
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
diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index b22c01e..1299d38 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -56,6 +56,7 @@
  #include <asm/arch_hooks.h>
  #include <linux/kdebug.h>
  #include <asm/stacktrace.h>
+#include <asm/kmemcheck.h>

  #include <linux/module.h>

@@ -841,6 +842,10 @@ void __kprobes do_int3(struct pt_regs *regs, long error_code)
  }
  #endif

+extern void ia32_sysenter_target(void);
+extern void sysenter_past_esp(void);
+extern void x86_debug(void);
+
  /*
   * Our handling of the processor debug registers is non-trivial.
   * We do not clear them on entry and exit from the kernel. Therefore
@@ -872,6 +877,20 @@ void __kprobes do_debug(struct pt_regs * regs, long error_code)

  	get_debugreg(condition, 6);

+#ifdef CONFIG_KMEMCHECK
+	/* Catch kmemcheck conditions first of all! */
+	if (condition & DR_STEP) {
+		if (!(regs->flags & VM_MASK) && !user_mode(regs) &&
+			((void *)regs->ip != system_call) &&
+			((void *)regs->ip != x86_debug) &&
+			((void *)regs->ip != ia32_sysenter_target) &&
+			((void *)regs->ip != sysenter_past_esp)) {
+			kmemcheck_hide(regs);
+			return;
+		}
+	}
+#endif
+
  	/*
  	 * The processor cleared BTF, so don't mark that we need it set.
  	 */
@@ -881,6 +900,7 @@ void __kprobes do_debug(struct pt_regs * regs, long error_code)
  	if (notify_die(DIE_DEBUG, "debug", regs, condition, error_code,
  					SIGTRAP) == NOTIFY_STOP)
  		return;
+
  	/* It's safe to allow irq's after DR6 has been saved */
  	if (regs->flags & X86_EFLAGS_IF)
  		local_irq_enable();
@@ -1154,7 +1174,7 @@ void __init trap_init(void)
  #endif

  	set_trap_gate(0,&divide_error);
-	set_intr_gate(1,&debug);
+	set_intr_gate(1,&x86_debug);
  	set_intr_gate(2,&nmi);
  	set_system_intr_gate(3, &int3); /* int3/4 can be called from all */
  	set_system_gate(4,&overflow);
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 621afb6..2886cf9 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -33,6 +33,7 @@
  #include <asm/smp.h>
  #include <asm/tlbflush.h>
  #include <asm/proto.h>
+#include <asm/kmemcheck.h>
  #include <asm-generic/sections.h>

  /*
@@ -493,7 +494,8 @@ static int spurious_fault(unsigned long address,
   *
   * This assumes no large pages in there.
   */
-static int vmalloc_fault(unsigned long address)
+static int vmalloc_fault(struct pt_regs *regs, unsigned long address,
+	unsigned long error_code)
  {
  #ifdef CONFIG_X86_32
  	unsigned long pgd_paddr;
@@ -511,8 +513,19 @@ static int vmalloc_fault(unsigned long address)
  	if (!pmd_k)
  		return -1;
  	pte_k = pte_offset_kernel(pmd_k, address);
-	if (!pte_present(*pte_k))
-		return -1;
+	if (!pte_present(*pte_k)) {
+		if (!pte_hidden(*pte_k))
+			return -1;
+
+#ifdef CONFIG_KMEMCHECK
+		kmemcheck_prepare(regs);
+		if (error_code & 2)
+			kmemcheck_access(regs, address, KMEMCHECK_WRITE);
+		else
+			kmemcheck_access(regs, address, KMEMCHECK_READ);
+		kmemcheck_show(regs);
+#endif
+	}
  	return 0;
  #else
  	pgd_t *pgd, *pgd_ref;
@@ -623,7 +636,7 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
  	if (unlikely(address >= TASK_SIZE64)) {
  #endif
  		if (!(error_code & (PF_RSVD|PF_USER|PF_PROT)) &&
-		    vmalloc_fault(address) >= 0)
+		    vmalloc_fault(regs, address, error_code) >= 0)
  			return;

  		/* Can handle a stale RO->RW TLB */
diff --git a/arch/x86/mm/pgtable_32.c b/arch/x86/mm/pgtable_32.c
index 6c19146..fe0dff0 100644
--- a/arch/x86/mm/pgtable_32.c
+++ b/arch/x86/mm/pgtable_32.c
@@ -190,7 +190,7 @@ struct page *pte_alloc_one(struct mm_struct *mm, unsigned long address)
  #ifdef CONFIG_HIGHPTE
  	pte = alloc_pages(GFP_KERNEL|__GFP_HIGHMEM|__GFP_REPEAT|__GFP_ZERO, 0);
  #else
-	pte = alloc_pages(GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO, 0);
+	pte = alloc_pages(GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO|__GFP_NOTRACK, 0);
  #endif
  	return pte;
  }
@@ -340,7 +340,7 @@ static void pgd_mop_up_pmds(struct mm_struct *mm, pgd_t *pgdp)

  pgd_t *pgd_alloc(struct mm_struct *mm)
  {
-	pgd_t *pgd = quicklist_alloc(0, GFP_KERNEL, pgd_ctor);
+	pgd_t *pgd = quicklist_alloc(0, GFP_KERNEL|__GFP_NOTRACK, pgd_ctor);

  	mm->pgd = pgd;		/* so that alloc_pd can use it */

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
index 44c0a4f..b3790d7 100644
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
index 80dd438..aec71ad 100644
--- a/include/asm-x86/pgtable_32.h
+++ b/include/asm-x86/pgtable_32.h
@@ -91,6 +91,7 @@ void paging_init(void);
  extern unsigned long pg0[];

  #define pte_present(x)	((x).pte_low & (_PAGE_PRESENT | _PAGE_PROTNONE))
+#define pte_hidden(x)	((x).pte_low & (_PAGE_HIDDEN))

  /* To avoid harmful races, pmd_none(x) should check only the lower when PAE */
  #define pmd_none(x)	(!(unsigned long)pmd_val(x))
diff --git a/include/asm-x86/string_32.h b/include/asm-x86/string_32.h
index c5d13a8..546cea0 100644
--- a/include/asm-x86/string_32.h
+++ b/include/asm-x86/string_32.h
@@ -262,6 +262,14 @@ __asm__  __volatile__( \
   __constant_c_x_memset((s),(0x01010101UL*(unsigned char)(c)),(count)) : \
   __memset((s),(c),(count)))

+/* If kmemcheck is enabled, our best bet is a custom memset() that disables
+ * checking in order to save a whole lot of (unnecessary) page faults. */
+#ifdef CONFIG_KMEMCHECK
+void kmemcheck_memset(unsigned long s, int c, size_t n);
+#undef memset
+#define memset(s, c, n) kmemcheck_memset((unsigned long) (s), (c), (n))
+#endif
+
  /*
   * find the first occurrence of byte 'c', or 1 past the area if none
   */
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
index 0000000..766b525
--- /dev/null
+++ b/include/linux/kmemcheck.h
@@ -0,0 +1,12 @@
+#ifndef LINUX_KMEMCHECK_H
+#define LINUX_KMEMCHECK_H
+
+#ifdef CONFIG_KMEMCHECK
+void kmemcheck_show_pages(struct page *p, unsigned int n);
+void kmemcheck_hide_pages(struct page *p, unsigned int n);
+
+void kmemcheck_fill_shadow(void *address, unsigned int n);
+void kmemcheck_clear_shadow_pages(struct page *p, unsigned int n);
+#endif
+
+#endif
diff --git a/include/linux/slab.h b/include/linux/slab.h
index f62caaa..35cc185 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -28,6 +28,7 @@
  #define SLAB_DESTROY_BY_RCU	0x00080000UL	/* Defer freeing slabs to RCU */
  #define SLAB_MEM_SPREAD		0x00100000UL	/* Spread some memory over cpuset */
  #define SLAB_TRACE		0x00200000UL	/* Trace allocations and frees */
+#define SLAB_NOTRACK		0x00400000UL	/* Don't track use of uninitialized memory */

  /* The following flags affect the page allocator grouping pages by mobility */
  #define SLAB_RECLAIM_ACCOUNT	0x00020000UL		/* Objects are reclaimable */
diff --git a/kernel/fork.c b/kernel/fork.c
index 3995297..d2b90ef 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -140,7 +140,7 @@ void __init fork_init(unsigned long mempages)
  	/* create a slab on which task_structs can be allocated */
  	task_struct_cachep =
  		kmem_cache_create("task_struct", sizeof(struct task_struct),
-			ARCH_MIN_TASKALIGN, SLAB_PANIC, NULL);
+			ARCH_MIN_TASKALIGN, SLAB_PANIC | SLAB_NOTRACK, NULL);
  #endif

  	/*
@@ -1548,23 +1548,24 @@ void __init proc_caches_init(void)
  {
  	sighand_cachep = kmem_cache_create("sighand_cache",
  			sizeof(struct sighand_struct), 0,
-			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_DESTROY_BY_RCU,
+			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_DESTROY_BY_RCU
+			|SLAB_NOTRACK,
  			sighand_ctor);
  	signal_cachep = kmem_cache_create("signal_cache",
  			sizeof(struct signal_struct), 0,
-			SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
+			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_NOTRACK, NULL);
  	files_cachep = kmem_cache_create("files_cache",
  			sizeof(struct files_struct), 0,
-			SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
+			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_NOTRACK, NULL);
  	fs_cachep = kmem_cache_create("fs_cache",
  			sizeof(struct fs_struct), 0,
-			SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
+			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_NOTRACK, NULL);
  	vm_area_cachep = kmem_cache_create("vm_area_struct",
  			sizeof(struct vm_area_struct), 0,
-			SLAB_PANIC, NULL);
+			SLAB_PANIC|SLAB_NOTRACK, NULL);
  	mm_cachep = kmem_cache_create("mm_struct",
  			sizeof(struct mm_struct), ARCH_MIN_MMSTRUCT_ALIGN,
-			SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
+			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_NOTRACK, NULL);
  }

  /*
diff --git a/mm/slub.c b/mm/slub.c
index 3f05667..3b3dfb8 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -21,6 +21,7 @@
  #include <linux/ctype.h>
  #include <linux/kallsyms.h>
  #include <linux/memory.h>
+#include <linux/kmemcheck.h>

  /*
   * Lock order:
@@ -191,7 +192,7 @@ static inline void ClearSlabDebug(struct page *page)
  		SLAB_TRACE | SLAB_DESTROY_BY_RCU)

  #define SLUB_MERGE_SAME (SLAB_DEBUG_FREE | SLAB_RECLAIM_ACCOUNT | \
-		SLAB_CACHE_DMA)
+		SLAB_CACHE_DMA | SLAB_NOTRACK)

  #ifndef ARCH_KMALLOC_MINALIGN
  #define ARCH_KMALLOC_MINALIGN __alignof__(unsigned long long)
@@ -1043,9 +1044,7 @@ static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
  {
  	struct page *page;
  	int pages = 1 << s->order;
-
-	if (s->order)
-		flags |= __GFP_COMP;
+	int order = s->order;

  	if (s->flags & SLAB_CACHE_DMA)
  		flags |= SLUB_DMA;
@@ -1053,14 +1052,39 @@ static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
  	if (s->flags & SLAB_RECLAIM_ACCOUNT)
  		flags |= __GFP_RECLAIMABLE;

+#ifdef CONFIG_KMEMCHECK
+	if (s->flags & SLAB_NOTRACK)
+		flags |= __GFP_NOTRACK;
+
+	/* Actually allocate twice as much, since we need to track the
+	 * status of each byte within the allocation. */
+	if (!(flags & __GFP_NOTRACK)) {
+		pages += pages;
+		order += 1;
+	}
+#endif
+
+	if (order)
+		flags |= __GFP_COMP;
+
  	if (node == -1)
-		page = alloc_pages(flags, s->order);
+		page = alloc_pages(flags, order);
  	else
-		page = alloc_pages_node(node, flags, s->order);
+		page = alloc_pages_node(node, flags, order);

  	if (!page)
  		return NULL;

+#ifdef CONFIG_KMEMCHECK
+	if (!(flags & __GFP_NOTRACK)) {
+		/* Mark it as non-present for the MMU so that our accesses
+		 * to this memory will trigger a page fault and let us
+		 * analyze the memory accesses. */
+		kmemcheck_hide_pages(page, pages >> 1);
+		kmemcheck_clear_shadow_pages(page + (pages >> 1), pages >> 1);
+	}
+#endif
+
  	mod_zone_page_state(page_zone(page),
  		(s->flags & SLAB_RECLAIM_ACCOUNT) ?
  		NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE,
@@ -1088,7 +1112,8 @@ static struct page *new_slab(struct kmem_cache *s, gfp_t flags, int node)
  	BUG_ON(flags & GFP_SLAB_BUG_MASK);

  	page = allocate_slab(s,
-		flags & (GFP_RECLAIM_MASK | GFP_CONSTRAINT_MASK), node);
+		flags & (GFP_RECLAIM_MASK | GFP_CONSTRAINT_MASK
+			| __GFP_NOTRACK), node);
  	if (!page)
  		goto out;

@@ -1124,6 +1149,7 @@ out:
  static void __free_slab(struct kmem_cache *s, struct page *page)
  {
  	int pages = 1 << s->order;
+	int order = s->order;

  	if (unlikely(SlabDebug(page))) {
  		void *p;
@@ -1134,12 +1160,21 @@ static void __free_slab(struct kmem_cache *s, struct page *page)
  		ClearSlabDebug(page);
  	}

+#ifdef CONFIG_KMEMCHECK
+	if (!(s->flags & SLAB_NOTRACK)) {
+		kmemcheck_show_pages(page, pages);
+
+		pages += pages;
+		order += 1;
+	}
+#endif
+
  	mod_zone_page_state(page_zone(page),
  		(s->flags & SLAB_RECLAIM_ACCOUNT) ?
  		NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE,
  		-pages);

-	__free_pages(page, s->order);
+	__free_pages(page, order);
  }

  static void rcu_free_slab(struct rcu_head *h)
@@ -1551,9 +1586,7 @@ static __always_inline void *slab_alloc(struct kmem_cache *s,
  	local_irq_save(flags);
  	c = get_cpu_slab(s, smp_processor_id());
  	if (unlikely(!c->freelist || !node_match(c, node)))
-
  		object = __slab_alloc(s, gfpflags, node, addr, c);
-
  	else {
  		object = c->freelist;
  		c->freelist = object[c->offset];
@@ -1562,6 +1595,22 @@ static __always_inline void *slab_alloc(struct kmem_cache *s,

  	if (unlikely((gfpflags & __GFP_ZERO) && object))
  		memset(object, 0, c->objsize);
+	else {
+#ifdef CONFIG_KMEMCHECK
+		/*
+		 * Allow notracked objects to be allocated from tracked
+		 * caches. Note however that these objects will still get
+		 * page faults on access, they just won't ever be flagged
+		 * as uninitialized. If page faults are not acceptable,
+		 * the slab cache itself should be marked NOTRACK.
+		 */
+		if (unlikely((gfpflags & __GFP_NOTRACK)
+			&& !(s->flags & SLAB_NOTRACK)))
+		{
+			kmemcheck_fill_shadow(object, c->objsize);
+		}
+#endif
+	}

  	return object;
  }
@@ -2344,6 +2393,8 @@ EXPORT_SYMBOL(kmem_cache_destroy);
  struct kmem_cache kmalloc_caches[PAGE_SHIFT] __cacheline_aligned;
  EXPORT_SYMBOL(kmalloc_caches);

+struct kmem_cache cache_cache;
+
  #ifdef CONFIG_ZONE_DMA
  static struct kmem_cache *kmalloc_caches_dma[PAGE_SHIFT];
  #endif
@@ -2391,6 +2442,9 @@ static struct kmem_cache *create_kmalloc_cache(struct kmem_cache *s,
  	if (gfp_flags & SLUB_DMA)
  		flags = SLAB_CACHE_DMA;

+	if (gfp_flags & __GFP_NOTRACK)
+		flags |= SLAB_NOTRACK;
+
  	down_write(&slub_lock);
  	if (!kmem_cache_open(s, gfp_flags, name, size, ARCH_KMALLOC_MINALIGN,
  			flags, NULL))
@@ -2445,14 +2499,18 @@ static noinline struct kmem_cache *dma_kmalloc_cache(int index, gfp_t flags)
  	if (kmalloc_caches_dma[index])
  		goto unlock_out;

+#ifdef CONFIG_KMEMCHECK
+	flags |= __GFP_NOTRACK;
+#endif
+
  	realsize = kmalloc_caches[index].objsize;
  	text = kasprintf(flags & ~SLUB_DMA, "kmalloc_dma-%d", (unsigned int)realsize),
-	s = kmalloc(kmem_size, flags & ~SLUB_DMA);
+	s = kmem_cache_alloc(&cache_cache, flags & ~SLUB_DMA);

  	if (!s || !text || !kmem_cache_open(s, flags, text,
  			realsize, ARCH_KMALLOC_MINALIGN,
  			SLAB_CACHE_DMA|__SYSFS_ADD_DEFERRED, NULL)) {
-		kfree(s);
+		kmem_cache_free(&cache_cache, s);
  		kfree(text);
  		goto unlock_out;
  	}
@@ -2894,7 +2952,8 @@ void __init kmem_cache_init(void)
  #else
  	kmem_size = sizeof(struct kmem_cache);
  #endif
-
+	create_kmalloc_cache(&cache_cache, "kmem_cache", kmem_size, GFP_KERNEL
+		| __GFP_NOTRACK);

  	printk(KERN_INFO "SLUB: Genslabs=%d, HWalign=%d, Order=%d-%d, MinObjects=%d,"
  		" CPUs=%d, Nodes=%d\n",
@@ -2994,9 +3053,13 @@ struct kmem_cache *kmem_cache_create(const char *name, size_t size,
  			goto err;
  		return s;
  	}
-	s = kmalloc(kmem_size, GFP_KERNEL);
+	s = kmem_cache_alloc(&cache_cache, GFP_KERNEL);
  	if (s) {
-		if (kmem_cache_open(s, GFP_KERNEL, name,
+		gfp_t gfpflags = GFP_KERNEL;
+		if (flags & SLAB_NOTRACK)
+			gfpflags |= __GFP_NOTRACK;
+
+		if (kmem_cache_open(s, gfpflags, name,
  				size, align, flags, ctor)) {
  			list_add(&s->list, &slab_caches);
  			up_write(&slub_lock);
@@ -3004,7 +3067,7 @@ struct kmem_cache *kmem_cache_create(const char *name, size_t size,
  				goto err;
  			return s;
  		}
-		kfree(s);
+		kmem_cache_free(&cache_cache, s);
  	}
  	up_write(&slub_lock);

@@ -4006,6 +4069,8 @@ static char *create_unique_id(struct kmem_cache *s)
  		*p++ = 'a';
  	if (s->flags & SLAB_DEBUG_FREE)
  		*p++ = 'F';
+	if (!(s->flags & SLAB_NOTRACK))
+		*p++ = 't';
  	if (p != name + 1)
  		*p++ = '-';
  	p += sprintf(p, "%07d", s->size);

