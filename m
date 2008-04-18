Return-Path: <linux-kernel-owner+w=401wt.eu-S1753158AbYDRV7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158AbYDRV7l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 17:59:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751256AbYDRV7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 17:59:33 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:59416 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbYDRV7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 17:59:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=qIv87Hq4+KTNDpeqSHGqCshmpHuztIZAM9qZ2y89vboC7ZTfi8/635sVNMMftGudtU5atDR9l54P0Hav08nCfyS/O7KhHgFW3g/XzhLvNuB+aefWWzgTFK0MeKDykLHhFyhpfGRVy9DVbaWf8kBEwlOd4XFwbHWQCU+mLdc/cnA=
Date: Fri, 18 Apr 2008 23:58:39 +0200
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Cristoph Lameter <clameter@sgi.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] kmemcheck: add the kmemcheck core
Message-ID: <20080418215839.GA16586@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is kmemcheck against 2.6.25 as of today. This should be more or less
what's in x86.git, the most notable exception being that x86.git contains the
development history of kmemcheck since v4 or so, while this is the condensed
three-patch set.

This version also contains the removal of the "tracked" page flag.

I post it now for a final review, as requested by Andrew.

Vegard


>From 485443a0273edd97b138c01d5fdc4f83ab725969 Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Fri, 4 Apr 2008 00:51:41 +0200
Subject: [PATCH] kmemcheck: add the kmemcheck core

General description: kmemcheck is a patch to the linux kernel that
detects use of uninitialized memory. It does this by trapping every
read and write to memory that was allocated dynamically (e.g. using
kmalloc()). If a memory address is read that has not previously been
written to, a message is printed to the kernel log.

Signed-off-by: Vegard Nossum <vegardno@ifi.uio.no>
---
 Documentation/kmemcheck.txt  |  101 +++++
 arch/x86/Kconfig.debug       |   75 ++++
 arch/x86/kernel/Makefile     |    2 +
 arch/x86/kernel/kmemcheck.c  |  930 ++++++++++++++++++++++++++++++++++++++++++
 include/asm-x86/kmemcheck.h  |   30 ++
 include/asm-x86/pgtable.h    |    4 +-
 include/asm-x86/pgtable_32.h |    6 +
 include/linux/kmemcheck.h    |   29 ++
 init/main.c                  |    2 +
 kernel/sysctl.c              |   12 +
 10 files changed, 1189 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/kmemcheck.txt
 create mode 100644 arch/x86/kernel/kmemcheck.c
 create mode 100644 include/asm-x86/kmemcheck.h
 create mode 100644 include/linux/kmemcheck.h

diff --git a/Documentation/kmemcheck.txt b/Documentation/kmemcheck.txt
new file mode 100644
index 0000000..a3c9a83
--- /dev/null
+++ b/Documentation/kmemcheck.txt
@@ -0,0 +1,101 @@
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
+2. Tell kmemcheck which parts of memory should be marked uninitialized. There
+   are actually a few more states, such as "not yet allocated" and "recently
+   freed".
+
+If a slab cache is set up using the SLAB_NOTRACK flag, it will never return
+memory that can take page faults because of kmemcheck.
+
+If a slab cache is NOT set up using the SLAB_NOTRACK flag, callers can still
+request memory with the __GFP_NOTRACK flag. This does not prevent the page
+faults from occurring, however, but marks the object in question as being
+initialized so that no warnings will ever be produced for this object.
+
+
+Problems
+========
+
+The most prominent problem seems to be that of bit-fields. kmemcheck can only
+track memory with byte granularity. Therefore, when gcc generates code to
+access only one bit in a bit-field, there is really no way for kmemcheck to
+know which of the other bits will be used or thrown away. Consequently, there
+may be bogus warnings for bit-field accesses. There is some experimental
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
+Parameters
+==========
+
+In addition to enabling CONFIG_KMEMCHECK before the kernel is compiled, the
+parameter kmemcheck=1 must be passed to the kernel when it is started in order
+to actually do the tracking. So by default, there is only a very small
+(probably negligible) overhead for enabling the config option.
+
+Similarly, kmemcheck may be turned on or off at run-time using, respectively:
+
+echo 1 > /proc/sys/kernel/kmemcheck
+	and
+echo 0 > /proc/sys/kernel/kmemcheck
+
+Note that this is a lazy setting; once turned off, the old allocations will
+still have to take a single page fault exception before tracking is turned off
+for that particular page. Enabling kmemcheck on will only enable tracking for
+allocations made from that point onwards.
+
+The default mode is the one-shot mode, where only the first error is reported
+before kmemcheck is disabled. This mode can be enabled by passing kmemcheck=2
+to the kernel at boot, or running
+
+echo 2 > /proc/sys/kernel/kmemcheck
+
+when the kernel is already running.
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
index 702eb39..6256b2e 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -134,6 +134,81 @@ config IOMMU_LEAK
 	  Add a simple leak tracer to the IOMMU code. This is useful when you
 	  are debugging a buggy device driver that leaks IOMMU mappings.
 
+config KMEMCHECK
+	bool "kmemcheck: trap use of uninitialized memory"
+	depends on X86_32
+	depends on !X86_USE_3DNOW
+	depends on !CC_OPTIMIZE_FOR_SIZE
+	depends on !DEBUG_PAGEALLOC && SLUB
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
+	  The kernel may be started with kmemcheck=0 or kmemcheck=1 to disable
+	  or enable kmemcheck at boot-time. If the kernel is started with
+	  kmemcheck=0, the large memory and CPU overhead is not incurred.
+
+choice
+	prompt "kmemcheck: default mode at boot"
+	depends on KMEMCHECK
+	default KMEMCHECK_ONESHOT_BY_DEFAULT
+	help
+	  This option controls the default behaviour of kmemcheck when the
+	  kernel boots and no kmemcheck= parameter is given.
+
+config KMEMCHECK_DISABLED_BY_DEFAULT
+	bool "disabled"
+	depends on KMEMCHECK
+
+config KMEMCHECK_ENABLED_BY_DEFAULT
+	bool "enabled"
+	depends on KMEMCHECK
+
+config KMEMCHECK_ONESHOT_BY_DEFAULT
+	bool "one-shot"
+	depends on KMEMCHECK
+	help
+	  In one-shot mode, only the first error detected is reported before
+	  kmemcheck is disabled.
+
+endchoice
+
+config KMEMCHECK_QUEUE_SIZE
+	int "kmemcheck: error queue size"
+	depends on KMEMCHECK
+	default 64
+	help
+	  Select the maximum number of errors to store in the queue. This
+	  queue will be emptied once every second, so this is effectively a
+	  limit on how many reports to print in one go. Note however, that
+	  if the number of errors occuring between two bursts is larger than
+	  this number, the extra error reports will get lost.
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
index 4eb5ce8..e1fcc1e 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -86,6 +86,8 @@ endif
 obj-$(CONFIG_SCx200)		+= scx200.o
 scx200-y			+= scx200_32.o
 
+obj-$(CONFIG_KMEMCHECK)		+= kmemcheck.o
+
 ###
 # 64 bit specific files
 ifeq ($(CONFIG_X86_64),y)
diff --git a/arch/x86/kernel/kmemcheck.c b/arch/x86/kernel/kmemcheck.c
new file mode 100644
index 0000000..4139199
--- /dev/null
+++ b/arch/x86/kernel/kmemcheck.c
@@ -0,0 +1,930 @@
+/**
+ * kmemcheck - a heavyweight memory checker for the linux kernel
+ * Copyright (C) 2007, 2008  Vegard Nossum <vegardno@ifi.uio.no>
+ * (With a lot of help from Ingo Molnar and Pekka Enberg.)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License (version 2) as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/init.h>
+#include <linux/kallsyms.h>
+#include <linux/kdebug.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/page-flags.h>
+#include <linux/stacktrace.h>
+#include <linux/timer.h>
+
+#include <asm/cacheflush.h>
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
+enum kmemcheck_error_type {
+	ERROR_INVALID_ACCESS,
+	ERROR_BUG,
+};
+
+struct kmemcheck_error {
+	enum kmemcheck_error_type type;
+
+	union {
+		/* ERROR_INVALID_ACCESS */
+		struct {
+			/* Kind of access that caused the error */
+			enum shadow	state;
+			/* Address and size of the erroneous read */
+			unsigned long	address;
+			unsigned int	size;
+		};
+	};
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
+static struct kmemcheck_error error_fifo[CONFIG_KMEMCHECK_QUEUE_SIZE];
+static unsigned int error_count;
+static unsigned int error_rd;
+static unsigned int error_wr;
+static unsigned int error_missed_count;
+
+static struct timer_list kmemcheck_timer;
+
+static struct kmemcheck_error *
+error_next_wr(void)
+{
+	struct kmemcheck_error *e;
+
+	if (error_count == ARRAY_SIZE(error_fifo)) {
+		++error_missed_count;
+		return NULL;
+	}
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
+ * Save the context of an error.
+ */
+static void
+error_save(enum shadow state, unsigned long address, unsigned int size,
+	struct pt_regs *regs)
+{
+	static unsigned long prev_ip;
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
+	e->type = ERROR_INVALID_ACCESS;
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
+	e->trace.skip = 1;
+	save_stack_trace(&e->trace);
+}
+
+/*
+ * Save the context of a kmemcheck bug.
+ */
+static void
+error_save_bug(struct pt_regs *regs)
+{
+	struct kmemcheck_error *e;
+
+	e = error_next_wr();
+	if (!e)
+		return;
+
+	e->type = ERROR_BUG;
+
+	memcpy(&e->regs, regs, sizeof(*regs));
+
+	e->trace.nr_entries = 0;
+	e->trace.entries = e->trace_entries;
+	e->trace.max_entries = ARRAY_SIZE(e->trace_entries);
+	e->trace.skip = 1;
+	save_stack_trace(&e->trace);
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
+	switch (e->type) {
+	case ERROR_INVALID_ACCESS:
+		printk(KERN_ERR  "kmemcheck: Caught %d-bit read "
+			"from %s memory (%08x)\n",
+			e->size, desc[e->state], e->address);
+		break;
+	case ERROR_BUG:
+		printk(KERN_EMERG "kmemcheck: Fatal error\n");
+		break;
+	}
+
+	__show_registers(&e->regs, 1);
+	print_stack_trace(&e->trace, 0);
+}
+
+static void
+do_wakeup(unsigned long data)
+{
+	while (error_count > 0)
+		error_recall();
+
+	if (error_missed_count > 0) {
+		printk(KERN_EMERG "kmemcheck: Lost %d error reports because "
+			"the queue was too small\n", error_missed_count);
+		error_missed_count = 0;
+	}
+
+	mod_timer(&kmemcheck_timer, kmemcheck_timer.expires + HZ);
+}
+
+void __init
+kmemcheck_init(void)
+{
+	printk(KERN_INFO "kmemcheck: \"Bugs, beware!\"\n");
+
+#ifdef CONFIG_SMP
+	/* Limit SMP to use a single CPU. We rely on the fact that this code
+	 * runs before SMP is set up. */
+	if (setup_max_cpus > 1) {
+		printk(KERN_INFO
+			"kmemcheck: Limiting number of CPUs to 1.\n");
+		setup_max_cpus = 1;
+	}
+#endif
+
+	setup_timer(&kmemcheck_timer, &do_wakeup, 0);
+	mod_timer(&kmemcheck_timer, jiffies + HZ);
+}
+
+#ifdef CONFIG_KMEMCHECK_DISABLED_BY_DEFAULT
+int kmemcheck_enabled = 0;
+#endif
+
+#ifdef CONFIG_KMEMCHECK_ENABLED_BY_DEFAULT
+int kmemcheck_enabled = 1;
+#endif
+
+#ifdef CONFIG_KMEMCHECK_ONESHOT_BY_DEFAULT
+int kmemcheck_enabled = 2;
+#endif
+
+/*
+ * We need to parse the kmemcheck= option before any memory is allocated.
+ */
+static int __init
+param_kmemcheck(char *str)
+{
+	if (!str)
+		return -EINVAL;
+
+	sscanf(str, "%d", &kmemcheck_enabled);
+	return 0;
+}
+
+early_param("kmemcheck", param_kmemcheck);
+
+static pte_t *
+address_get_pte(unsigned int address)
+{
+	pte_t *pte;
+	int level;
+
+	pte = lookup_address(address, &level);
+	if (!pte)
+		return NULL;
+	if (!pte_hidden(*pte))
+		return NULL;
+
+	return pte;
+}
+
+/*
+ * Return the shadow address for the given address. Returns NULL if the
+ * address is not tracked.
+ *
+ * We need to be extremely careful not to follow any invalid pointers,
+ * because this function can be called for *any* possible address.
+ */
+static void *
+address_get_shadow(unsigned long address)
+{
+	pte_t *pte;
+	struct page *page;
+	struct page *head;
+
+	if (!virt_addr_valid(address))
+		return NULL;
+
+	pte = address_get_pte(address);
+	if (!pte)
+		return NULL;
+
+	/* The accessed page */
+	page = virt_to_page(address);
+	BUG_ON(!PageCompound(page));
+
+	/* The head page */
+	head = compound_head(page);
+	BUG_ON(compound_order(head) == 0);
+
+	return (void *) address + (PAGE_SIZE << (compound_order(head) - 1));
+}
+
+static int
+show_addr(unsigned long address)
+{
+	pte_t *pte;
+
+	pte = address_get_pte(address);
+	if (!pte)
+		return 0;
+
+	set_pte(pte, __pte(pte_val(*pte) | _PAGE_PRESENT));
+	__flush_tlb_one(address);
+	return 1;
+}
+
+static int
+hide_addr(unsigned long address)
+{
+	pte_t *pte;
+
+	pte = address_get_pte(address);
+	if (!pte)
+		return 0;
+
+	set_pte(pte, __pte(pte_val(*pte) & ~_PAGE_PRESENT));
+	__flush_tlb_one(address);
+	return 1;
+}
+
+struct kmemcheck_context {
+	bool busy;
+	int balance;
+
+	unsigned long addr1;
+	unsigned long addr2;
+	unsigned long flags;
+};
+
+DEFINE_PER_CPU(struct kmemcheck_context, kmemcheck_context);
+
+bool
+kmemcheck_active(struct pt_regs *regs)
+{
+	struct kmemcheck_context *data = &__get_cpu_var(kmemcheck_context);
+
+	return data->balance > 0;
+}
+
+/*
+ * Called from the #PF handler.
+ */
+void
+kmemcheck_show(struct pt_regs *regs)
+{
+	struct kmemcheck_context *data = &__get_cpu_var(kmemcheck_context);
+	int n;
+
+	BUG_ON(!irqs_disabled());
+
+	if (unlikely(data->balance != 0)) {
+		show_addr(data->addr1);
+		show_addr(data->addr2);
+		error_save_bug(regs);
+		data->balance = 0;
+		return;
+	}
+
+	n = 0;
+	n += show_addr(data->addr1);
+	n += show_addr(data->addr2);
+
+	/* None of the addresses actually belonged to kmemcheck. Note that
+	 * this is not an error. */
+	if (n == 0)
+		return;
+
+	++data->balance;
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
+		data->flags = regs->flags;
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
+	struct kmemcheck_context *data = &__get_cpu_var(kmemcheck_context);
+	int n;
+
+	BUG_ON(!irqs_disabled());
+
+	if (data->balance == 0)
+		return;
+
+	if (unlikely(data->balance != 1)) {
+		show_addr(data->addr1);
+		show_addr(data->addr2);
+		error_save_bug(regs);
+		data->addr1 = 0;
+		data->addr2 = 0;
+		data->balance = 0;
+
+		if (!(data->flags & TF_MASK))
+			regs->flags &= ~TF_MASK;
+		if (data->flags & IF_MASK)
+			regs->flags |= IF_MASK;
+		return;
+	}
+
+	n = 0;
+	if (kmemcheck_enabled) {
+		n += hide_addr(data->addr1);
+		n += hide_addr(data->addr2);
+	} else {
+		n += show_addr(data->addr1);
+		n += show_addr(data->addr2);
+	}
+
+	if (n == 0)
+		return;
+
+	--data->balance;
+
+	data->addr1 = 0;
+	data->addr2 = 0;
+
+	if (!(data->flags & TF_MASK))
+		regs->flags &= ~TF_MASK;
+	if (data->flags & IF_MASK)
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
+		set_pte(pte, __pte(pte_val(*pte) | _PAGE_PRESENT));
+		set_pte(pte, __pte(pte_val(*pte) & ~_PAGE_HIDDEN));
+		__flush_tlb_one(address);
+	}
+}
+
+bool
+kmemcheck_page_is_tracked(struct page *p)
+{
+	/* This will also check the "hidden" flag of the PTE. */
+	return address_get_pte((unsigned long) page_address(p));
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
+		set_pte(pte, __pte(pte_val(*pte) & ~_PAGE_PRESENT));
+		set_pte(pte, __pte(pte_val(*pte) | _PAGE_HIDDEN));
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
+			return 8;
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
+/*
+ * Check that an access does not span across two different pages, because
+ * that will mess up our shadow lookup.
+ */
+static bool
+check_page_boundary(struct pt_regs *regs, unsigned long addr, unsigned int size)
+{
+	unsigned long page[4];
+
+	if (size == 8)
+		return false;
+
+	page[0] = (addr + 0) & PAGE_MASK;
+	page[1] = (addr + 1) & PAGE_MASK;
+
+	if (size == 16 && page[0] == page[1])
+		return false;
+
+	page[2] = (addr + 2) & PAGE_MASK;
+	page[3] = (addr + 3) & PAGE_MASK;
+
+	if (size == 32 && page[0] == page[2] && page[0] == page[3])
+		return false;
+
+	/*
+	 * XXX: The addr/size data is also really interesting if this
+	 * case ever triggers. We should make a separate class of errors
+	 * for this case. -Vegard
+	 */
+	error_save_bug(regs);
+	return true;
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
+kmemcheck_read(struct pt_regs *regs, unsigned long address, unsigned int size)
+{
+	void *shadow;
+	enum shadow status;
+
+	shadow = address_get_shadow(address);
+	if (!shadow)
+		return;
+
+	if (check_page_boundary(regs, address, size))
+		return;
+
+	status = test(shadow, size);
+	if (status == SHADOW_INITIALIZED)
+		return;
+
+	/* Don't warn about it again. */
+	set(shadow, size);
+
+	if (kmemcheck_enabled)
+		error_save(status, address, size, regs);
+
+	if (kmemcheck_enabled == 2)
+		kmemcheck_enabled = 0;
+}
+
+static void
+kmemcheck_write(struct pt_regs *regs, unsigned long address, unsigned int size)
+{
+	void *shadow;
+
+	shadow = address_get_shadow(address);
+	if (!shadow)
+		return;
+
+	if (check_page_boundary(regs, address, size))
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
+	const uint8_t *insn_primary;
+	unsigned int size;
+
+	struct kmemcheck_context *data = &__get_cpu_var(kmemcheck_context);
+
+	/* Recursive fault -- ouch. */
+	if (data->busy) {
+		show_addr(fallback_address);
+		error_save_bug(regs);
+		return;
+	}
+
+	data->busy = true;
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
+			data->addr1 = fallback_address;
+			data->addr2 = 0;
+			data->busy = false;
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
+		data->addr1 = regs->si;
+		data->addr2 = regs->di;
+		data->busy = false;
+		return;
+
+		/* CMPS, CMPSB, CMPSW, CMPSD */
+	case 0xa6:
+	case 0xa7:
+		kmemcheck_read(regs, regs->si, size);
+		kmemcheck_read(regs, regs->di, size);
+		data->addr1 = regs->si;
+		data->addr2 = regs->di;
+		data->busy = false;
+		return;
+	}
+
+	/* If the opcode isn't special in any way, we use the data from the
+	 * page fault handler to determine the address and type of memory
+	 * access. */
+	switch (fallback_method) {
+	case KMEMCHECK_READ:
+		kmemcheck_read(regs, fallback_address, size);
+		data->addr1 = fallback_address;
+		data->addr2 = 0;
+		data->busy = false;
+		return;
+	case KMEMCHECK_WRITE:
+		kmemcheck_write(regs, fallback_address, size);
+		data->addr1 = fallback_address;
+		data->addr2 = 0;
+		data->busy = false;
+		return;
+	}
+}
+
+/*
+ * A faster implementation of memset() when tracking is enabled where the
+ * whole memory area is within a single page.
+ */
+static void
+memset_one_page(void *s, int c, size_t n)
+{
+	unsigned long addr;
+	void *x;
+	unsigned long flags;
+
+	addr = (unsigned long) s;
+
+	x = address_get_shadow(addr);
+	if (!x) {
+		/* The page isn't being tracked. */
+		__memset(s, c, n);
+		return;
+	}
+
+	/* While we are not guarding the page in question, nobody else
+	 * should be able to change them. */
+	local_irq_save(flags);
+
+	show_addr(addr);
+	__memset(s, c, n);
+	__memset(x, SHADOW_INITIALIZED, n);
+	if (kmemcheck_enabled)
+		hide_addr(addr);
+
+	local_irq_restore(flags);
+}
+
+/*
+ * A faster implementation of memset() when tracking is enabled. We cannot
+ * assume that all pages within the range are tracked, so copying has to be
+ * split into page-sized (or smaller, for the ends) chunks.
+ */
+void *
+kmemcheck_memset(void *s, int c, size_t n)
+{
+	unsigned long addr;
+	unsigned long start_page, start_offset;
+	unsigned long end_page, end_offset;
+	unsigned long i;
+
+	if (!n)
+		return s;
+
+	if (!slab_is_available()) {
+		__memset(s, c, n);
+		return s;
+	}
+
+	addr = (unsigned long) s;
+
+	start_page = addr & PAGE_MASK;
+	end_page = (addr + n) & PAGE_MASK;
+
+	if (start_page == end_page) {
+		/* The entire area is within the same page. Good, we only
+		 * need one memset(). */
+		memset_one_page(s, c, n);
+		return s;
+	}
+
+	start_offset = addr & ~PAGE_MASK;
+	end_offset = (addr + n) & ~PAGE_MASK;
+
+	/* Clear the head, body, and tail of the memory area. */
+	if (start_offset < PAGE_SIZE)
+		memset_one_page(s, c, PAGE_SIZE - start_offset);
+	for (i = start_page + PAGE_SIZE; i < end_page; i += PAGE_SIZE)
+		memset_one_page((void *) i, c, PAGE_SIZE);
+	if (end_offset > 0)
+		memset_one_page((void *) end_page, c, end_offset);
+
+	return s;
+}
+
+EXPORT_SYMBOL(kmemcheck_memset);
diff --git a/include/asm-x86/kmemcheck.h b/include/asm-x86/kmemcheck.h
new file mode 100644
index 0000000..885b107
--- /dev/null
+++ b/include/asm-x86/kmemcheck.h
@@ -0,0 +1,30 @@
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
+bool kmemcheck_active(struct pt_regs *regs);
+
+void kmemcheck_show(struct pt_regs *regs);
+void kmemcheck_hide(struct pt_regs *regs);
+
+void kmemcheck_access(struct pt_regs *regs,
+	unsigned long address, enum kmemcheck_method method);
+#else
+static inline bool kmemcheck_active(struct pt_regs *regs) { return false; }
+
+static inline void kmemcheck_show(struct pt_regs *regs) { }
+static inline void kmemcheck_hide(struct pt_regs *regs) { }
+
+static inline void kmemcheck_access(struct pt_regs *regs,
+	unsigned long address, enum kmemcheck_method method) { }
+#endif /* CONFIG_KMEMCHECK */
+
+#endif
diff --git a/include/asm-x86/pgtable.h b/include/asm-x86/pgtable.h
index 9cf472a..a1cf46c 100644
--- a/include/asm-x86/pgtable.h
+++ b/include/asm-x86/pgtable.h
@@ -17,7 +17,7 @@
 #define _PAGE_BIT_GLOBAL	8	/* Global TLB entry PPro+ */
 #define _PAGE_BIT_UNUSED1	9	/* available for programmer */
 #define _PAGE_BIT_UNUSED2	10
-#define _PAGE_BIT_UNUSED3	11
+#define _PAGE_BIT_HIDDEN	11
 #define _PAGE_BIT_PAT_LARGE	12	/* On 2MB or 1GB pages */
 #define _PAGE_BIT_NX           63       /* No execute: only valid after cpuid check */
 
@@ -37,7 +37,7 @@
 #define _PAGE_GLOBAL	(_AC(1, L)<<_PAGE_BIT_GLOBAL)	/* Global TLB entry */
 #define _PAGE_UNUSED1	(_AC(1, L)<<_PAGE_BIT_UNUSED1)
 #define _PAGE_UNUSED2	(_AC(1, L)<<_PAGE_BIT_UNUSED2)
-#define _PAGE_UNUSED3	(_AC(1, L)<<_PAGE_BIT_UNUSED3)
+#define _PAGE_HIDDEN	(_AC(1, L)<<_PAGE_BIT_HIDDEN)
 #define _PAGE_PAT	(_AC(1, L)<<_PAGE_BIT_PAT)
 #define _PAGE_PAT_LARGE (_AC(1, L)<<_PAGE_BIT_PAT_LARGE)
 
diff --git a/include/asm-x86/pgtable_32.h b/include/asm-x86/pgtable_32.h
index 4e6a0fc..266a0f5 100644
--- a/include/asm-x86/pgtable_32.h
+++ b/include/asm-x86/pgtable_32.h
@@ -87,6 +87,12 @@ extern unsigned long pg0[];
 
 #define pte_present(x)	((x).pte_low & (_PAGE_PRESENT | _PAGE_PROTNONE))
 
+#ifdef CONFIG_KMEMCHECK
+#define pte_hidden(x)	((x).pte_low & (_PAGE_HIDDEN))
+#else
+#define pte_hidden(x)	0
+#endif
+
 /* To avoid harmful races, pmd_none(x) should check only the lower when PAE */
 #define pmd_none(x)	(!(unsigned long)pmd_val(x))
 #define pmd_present(x)	(pmd_val(x) & _PAGE_PRESENT)
diff --git a/include/linux/kmemcheck.h b/include/linux/kmemcheck.h
new file mode 100644
index 0000000..c795194
--- /dev/null
+++ b/include/linux/kmemcheck.h
@@ -0,0 +1,29 @@
+#ifndef LINUX_KMEMCHECK_H
+#define LINUX_KMEMCHECK_H
+
+#include <linux/types.h>
+
+#ifdef CONFIG_KMEMCHECK
+extern int kmemcheck_enabled;
+
+void kmemcheck_init(void);
+
+void kmemcheck_show_pages(struct page *p, unsigned int n);
+void kmemcheck_hide_pages(struct page *p, unsigned int n);
+
+bool kmemcheck_page_is_tracked(struct page *p);
+
+void kmemcheck_mark_unallocated(void *address, unsigned int n);
+void kmemcheck_mark_uninitialized(void *address, unsigned int n);
+void kmemcheck_mark_initialized(void *address, unsigned int n);
+void kmemcheck_mark_freed(void *address, unsigned int n);
+
+void kmemcheck_mark_unallocated_pages(struct page *p, unsigned int n);
+void kmemcheck_mark_uninitialized_pages(struct page *p, unsigned int n);
+#else
+#define kmemcheck_enabled 0
+static inline void kmemcheck_init(void) { }
+static inline bool kmemcheck_page_is_tracked(struct page *p) { return false; }
+#endif /* CONFIG_KMEMCHECK */
+
+#endif /* LINUX_KMEMCHECK_H */
diff --git a/init/main.c b/init/main.c
index 99ce949..7f85ea2 100644
--- a/init/main.c
+++ b/init/main.c
@@ -58,6 +58,7 @@
 #include <linux/kthread.h>
 #include <linux/sched.h>
 #include <linux/signal.h>
+#include <linux/kmemcheck.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -751,6 +752,7 @@ static void __init do_pre_smp_initcalls(void)
 {
 	extern int spawn_ksoftirqd(void);
 
+	kmemcheck_init();
 	migration_init();
 	spawn_ksoftirqd();
 	if (!nosoftlockup)
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index b2a2d68..5381eb7 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -45,6 +45,7 @@
 #include <linux/nfs_fs.h>
 #include <linux/acpi.h>
 #include <linux/reboot.h>
+#include <linux/kmemcheck.h>
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
@@ -820,6 +821,17 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= &proc_dostring,
 		.strategy	= &sysctl_string,
 	},
+#ifdef CONFIG_KMEMCHECK
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "kmemcheck",
+		.data		= &kmemcheck_enabled,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+#endif
+
 /*
  * NOTE: do not add new entries to this table unless you have read
  * Documentation/sysctl/ctl_unnumbered.txt
-- 
1.5.4.1

