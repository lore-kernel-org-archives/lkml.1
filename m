Return-Path: <linux-kernel-owner+w=401wt.eu-S1758147AbYDDNp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758147AbYDDNp5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 09:45:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753889AbYDDNpr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 09:45:47 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:14370 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389AbYDDNpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 09:45:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=NiTDq2FIO31d/wXint7oUs55k5fY5S+bhq/iAOJN96TSh2gMfUpnX7uSNGESDiLVCoso0B82tdUyfSYeRCaY6mPWwihBfAdz5U8WtUBohMevrCQ+4Jq+sJCLNtzFsv/eBqUp39klcgYx60S5TuzuviBy+DztPmqP8W8pDwf1wdc=
Message-ID: <47F630FB.8080704@gmail.com>
Date: Fri, 04 Apr 2008 15:45:31 +0200
From: Vegard Nossum <vegard.nossum@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Christoph Lameter <clameter@sgi.com>,
       Daniel Walker <dwalker@mvista.com>, Andi Kleen <andi@firstfloor.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Josh Aune <luken@omner.org>,
       Pekka Paalanen <pq@iki.fi>
Subject: [PATCH 1/3] kmemcheck: add the kmemcheck core
References: <47F630AE.7050801@gmail.com>
In-Reply-To: <47F630AE.7050801@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 From bb63a1de75a67ecd88c962c2616f0ab4217f27fe Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Fri, 4 Apr 2008 00:51:41 +0200
Subject: [PATCH] kmemcheck: add the kmemcheck core

General description: kmemcheck is a patch to the linux kernel that
detects use of uninitialized memory. It does this by trapping every
read and write to memory that was allocated dynamically (e.g. using
kmalloc()). If a memory address is read that has not previously been
written to, a message is printed to the kernel log.

Signed-off-by: Vegard Nossum <vegardno@ifi.uio.no>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
  Documentation/kmemcheck.txt  |   93 +++++
  arch/x86/Kconfig.debug       |   47 +++
  arch/x86/kernel/Makefile     |    2 +
  arch/x86/kernel/kmemcheck.c  |  893 ++++++++++++++++++++++++++++++++++++++++++
  include/asm-x86/kmemcheck.h  |   30 ++
  include/asm-x86/pgtable.h    |    4 +-
  include/asm-x86/pgtable_32.h |    6 +
  include/linux/kmemcheck.h    |   27 ++
  include/linux/page-flags.h   |    6 +
  init/main.c                  |    2 +
  kernel/sysctl.c              |   12 +
  11 files changed, 1120 insertions(+), 2 deletions(-)
  create mode 100644 Documentation/kmemcheck.txt
  create mode 100644 arch/x86/kernel/kmemcheck.c
  create mode 100644 include/asm-x86/kmemcheck.h
  create mode 100644 include/linux/kmemcheck.h

diff --git a/Documentation/kmemcheck.txt b/Documentation/kmemcheck.txt
new file mode 100644
index 0000000..9d359d2
--- /dev/null
+++ b/Documentation/kmemcheck.txt
@@ -0,0 +1,93 @@
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
index 702eb39..a33683f 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -134,6 +134,53 @@ config IOMMU_LEAK
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
+config KMEMCHECK_ENABLED_BY_DEFAULT
+	bool "kmemcheck: enable at boot by default"
+	depends on KMEMCHECK
+	default y
+	help
+	  This option controls the default behaviour of kmemcheck when the
+	  kernel boots and no kmemcheck= parameter is given.
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
index 0000000..1dd79f5
--- /dev/null
+++ b/arch/x86/kernel/kmemcheck.c
@@ -0,0 +1,893 @@
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
+			enum shadow		state;
+			/* Address and size of the erroneous read */
+			uint32_t		address;
+			unsigned int		size;
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
+static struct kmemcheck_error error_fifo[32];
+static unsigned int error_count;
+static unsigned int error_rd;
+static unsigned int error_wr;
+
+static struct timer_list kmemcheck_timer;
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
+ * Save the context of an error.
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
+#ifdef CONFIG_KMEMCHECK_ENABLED_BY_DEFAULT
+int kmemcheck_enabled = 1;
+#else
+int kmemcheck_enabled = 0;
+#endif
+
+static int __init
+param_kmemcheck(char *str)
+{
+	if (!str)
+		return -EINVAL;
+
+	switch (str[0]) {
+	case '0':
+		kmemcheck_enabled = 0;
+		return 0;
+	case '1':
+		kmemcheck_enabled = 1;
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+early_param("kmemcheck", param_kmemcheck);
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
+	if (!PageHead(head))
+		return NULL;
+	if (!PageSlab(head))
+		return NULL;
+	if (!PageTracked(head))
+		return NULL;
+
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
+	set_pte(pte, __pte(pte_val(*pte) | _PAGE_PRESENT));
+	__flush_tlb_one(addr);
+	return 1;
+}
+
+/*
+ * In case there's something seriously wrong with kmemcheck (like a recursive
+ * or looping page fault), we should disable tracking for the page as a last
+ * attempt to not hang the machine.
+ */
+static void
+emergency_show_addr(uint32_t address)
+{
+	pte_t *pte;
+	int level;
+
+	pte = lookup_address(address, &level);
+	if (!pte)
+		return;
+	if (level != PG_LEVEL_4K)
+		return;
+
+	/* Don't change pages that weren't hidden in the first place -- they
+	 * aren't ours to modify. */
+	if (!(pte_val(*pte) & _PAGE_HIDDEN))
+		return;
+
+	set_pte(pte, __pte(pte_val(*pte) | _PAGE_PRESENT));
+	__flush_tlb_one(address);
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
+	set_pte(pte, __pte(pte_val(*pte) & ~_PAGE_PRESENT));
+	__flush_tlb_one(addr);
+	return 1;
+}
+
+struct kmemcheck_context {
+	bool busy;
+	int balance;
+
+	uint32_t addr1;
+	uint32_t addr2;
+	uint32_t flags;
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
+		emergency_show_addr(data->addr1);
+		emergency_show_addr(data->addr2);
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
+		emergency_show_addr(data->addr1);
+		emergency_show_addr(data->addr2);
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
+	struct page *head;
+
+	head = compound_head(p);
+	BUG_ON(!PageHead(head));
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
+		set_pte(pte, __pte(pte_val(*pte) | _PAGE_PRESENT));
+		set_pte(pte, __pte(pte_val(*pte) & ~_PAGE_HIDDEN));
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
+	BUG_ON(!PageHead(head));
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
+	struct kmemcheck_context *data = &__get_cpu_var(kmemcheck_context);
+
+	/* Recursive fault -- ouch. */
+	if (data->busy) {
+		emergency_show_addr(fallback_address);
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
index 9cf472a..ebf285d 100644
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
index 0000000..801da50
--- /dev/null
+++ b/include/linux/kmemcheck.h
@@ -0,0 +1,27 @@
+#ifndef LINUX_KMEMCHECK_H
+#define LINUX_KMEMCHECK_H
+
+#ifdef CONFIG_KMEMCHECK
+extern int kmemcheck_enabled;
+
+void kmemcheck_init(void);
+
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
+#endif /* CONFIG_KMEMCHECK */
+
+
+#ifndef CONFIG_KMEMCHECK
+#define kmemcheck_enabled 0
+static inline void kmemcheck_init(void) { }
+#endif /* CONFIG_KMEMCHECK */
+
+#endif /* LINUX_KMEMCHECK_H */
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index b5b30f1..63f5fd8 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -89,6 +89,7 @@
  #define PG_mappedtodisk		16	/* Has blocks allocated on-disk */
  #define PG_reclaim		17	/* To be reclaimed asap */
  #define PG_buddy		19	/* Page is free, on buddy lists */
+#define PG_tracked		20	/* Tracked by kmemcheck */

  /* PG_readahead is only used for file reads; PG_reclaim is only for writes */
  #define PG_readahead		PG_reclaim /* Reminder to do async read-ahead */
@@ -296,6 +297,11 @@ static inline void __ClearPageTail(struct page *page)
  #define SetPageUncached(page)	set_bit(PG_uncached, &(page)->flags)
  #define ClearPageUncached(page)	clear_bit(PG_uncached, &(page)->flags)

+#define PageTracked(page)	test_bit(PG_tracked, &(page)->flags)
+#define SetPageTracked(page)	set_bit(PG_tracked, &(page)->flags)
+#define ClearPageTracked(page)	clear_bit(PG_tracked, &(page)->flags)
+
+
  struct page;	/* forward declaration */

  extern void cancel_dirty_page(struct page *page, unsigned int account_size);
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


