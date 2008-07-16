Return-Path: <linux-kernel-owner+w=401wt.eu-S1759395AbYGPAZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759395AbYGPAZN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 20:25:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755057AbYGPAXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 20:23:51 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:8513 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755028AbYGPAXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 20:23:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=rzRD6U5nHQFfbwymG5AWsi81A9eR7gcJfS6u2bOJHUxZxp8riELBZHUbNDf7fYRN7P
         U6TjbZP755DpBXFZT5zTTL0TkeVD0JSXD24rK1EF/2vEtMs+ByQgZmUUfjUY9prYdZ5o
         LBH2WBE0d78FU4lf0Ed1EYvMUq/M5FuzNdjk0=
Date: Wed, 16 Jul 2008 02:23:29 +0200
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: [PATCH 07/13] kmemcheck: add the kmemcheck core
Message-ID: <20080716002329.GH12564@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From fcd8f514a8962ea22aafb831b9f22a2ea1a13870 Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Fri, 4 Apr 2008 00:51:41 +0200
Subject: [PATCH 07/13] kmemcheck: add the kmemcheck core

General description: kmemcheck is a patch to the linux kernel that
detects use of uninitialized memory. It does this by trapping every
read and write to memory that was allocated dynamically (e.g. using
kmalloc()). If a memory address is read that has not previously been
written to, a message is printed to the kernel log.

(Thanks to Andi Kleen for the set_memory_4k() solution.)

Signed-off-by: Vegard Nossum <vegardno@ifi.uio.no>
---
 Documentation/kmemcheck.txt       |  135 +++++++++++
 arch/x86/mm/Makefile              |    2 +
 arch/x86/mm/kmemcheck/Makefile    |    3 +
 arch/x86/mm/kmemcheck/error.c     |  216 +++++++++++++++++
 arch/x86/mm/kmemcheck/error.h     |   15 ++
 arch/x86/mm/kmemcheck/kmemcheck.c |  477 +++++++++++++++++++++++++++++++++++++
 arch/x86/mm/kmemcheck/opcode.c    |   70 ++++++
 arch/x86/mm/kmemcheck/opcode.h    |    9 +
 arch/x86/mm/kmemcheck/pte.c       |   22 ++
 arch/x86/mm/kmemcheck/pte.h       |   10 +
 arch/x86/mm/kmemcheck/shadow.c    |  175 ++++++++++++++
 arch/x86/mm/kmemcheck/shadow.h    |   16 ++
 arch/x86/mm/kmemcheck/smp.c       |   79 ++++++
 arch/x86/mm/kmemcheck/smp.h       |   23 ++
 arch/x86/mm/kmemcheck/string.c    |   91 +++++++
 include/asm-x86/kmemcheck.h       |   36 +++
 include/asm-x86/pgtable.h         |    4 +-
 include/asm-x86/pgtable_32.h      |    6 +
 include/linux/kmemcheck.h         |   22 ++
 include/linux/mm_types.h          |    4 +
 init/main.c                       |    2 +
 kernel/sysctl.c                   |   12 +
 22 files changed, 1427 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/kmemcheck.txt
 create mode 100644 arch/x86/mm/kmemcheck/Makefile
 create mode 100644 arch/x86/mm/kmemcheck/error.c
 create mode 100644 arch/x86/mm/kmemcheck/error.h
 create mode 100644 arch/x86/mm/kmemcheck/kmemcheck.c
 create mode 100644 arch/x86/mm/kmemcheck/opcode.c
 create mode 100644 arch/x86/mm/kmemcheck/opcode.h
 create mode 100644 arch/x86/mm/kmemcheck/pte.c
 create mode 100644 arch/x86/mm/kmemcheck/pte.h
 create mode 100644 arch/x86/mm/kmemcheck/shadow.c
 create mode 100644 arch/x86/mm/kmemcheck/shadow.h
 create mode 100644 arch/x86/mm/kmemcheck/smp.c
 create mode 100644 arch/x86/mm/kmemcheck/smp.h
 create mode 100644 arch/x86/mm/kmemcheck/string.c
 create mode 100644 include/asm-x86/kmemcheck.h
 create mode 100644 include/linux/kmemcheck.h

diff --git a/Documentation/kmemcheck.txt b/Documentation/kmemcheck.txt
new file mode 100644
index 0000000..843a63c
--- /dev/null
+++ b/Documentation/kmemcheck.txt
@@ -0,0 +1,135 @@
+Contents
+========
+
+  1. How to use
+  2. Technical description
+  3. Changes to the slab allocators
+  4. Problems
+  5. Parameters
+  6. Future enhancements
+
+
+How to use (IMPORTANT)
+======================
+
+Always remember this: kmemcheck _will_ give false positives. So don't enable
+it and spam the mailing list with its reports; you are not going to be heard,
+and it will make people's skins thicker for when the real errors are found.
+
+Instead, I encourage maintainers and developers to find errors in _their_
+_own_ code. And if you find false positives, you can try to work around them,
+try to figure out if it's a real bug or not, or simply ignore them. Most
+developers know their own code and will quickly and efficiently determine the
+root cause of a kmemcheck report. This is therefore also the most efficient
+way to work with kmemcheck.
+
+If you still want to run kmemcheck to inspect others' code, the rule of thumb
+should be: If it's not obvious (to you), don't tell us about it either. Most
+likely the code is correct and you'll only waste our time. If you can work
+out the error, please do send the maintainer a heads up and/or a patch, but
+don't expect him/her to fix something that wasn't wrong in the first place.
+
+
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
+Changes to the slab allocators
+==============================
+
+kmemcheck requires some assistance from the memory allocator in order to work.
+The memory allocator needs to
+
+1. Tell kmemcheck about newly allocated pages and pages that are about to
+   be freed. This allows kmemcheck to set up and tear down the shadow memory
+   for the pages in question. The shadow memory stores the status of each byte
+   in the allocation proper, e.g. whether it is initialized or uninitialized.
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
+Currently, the SLAB and SLUB allocators are supported by kmemcheck.
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
diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index b7b3e4c..1f19d3e 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -8,6 +8,8 @@ obj-$(CONFIG_X86_PTDUMP)	+= dump_pagetables.o
 
 obj-$(CONFIG_HIGHMEM)		+= highmem_32.o
 
+obj-$(CONFIG_KMEMCHECK)		+= kmemcheck/
+
 ifeq ($(CONFIG_X86_32),y)
 obj-$(CONFIG_NUMA)		+= discontig_32.o
 else
diff --git a/arch/x86/mm/kmemcheck/Makefile b/arch/x86/mm/kmemcheck/Makefile
new file mode 100644
index 0000000..f888b5c
--- /dev/null
+++ b/arch/x86/mm/kmemcheck/Makefile
@@ -0,0 +1,3 @@
+obj-y := error.o kmemcheck.o opcode.o pte.o shadow.o string.o
+
+obj-$(CONFIG_KMEMCHECK_USE_SMP) += smp.o
diff --git a/arch/x86/mm/kmemcheck/error.c b/arch/x86/mm/kmemcheck/error.c
new file mode 100644
index 0000000..56410c6
--- /dev/null
+++ b/arch/x86/mm/kmemcheck/error.c
@@ -0,0 +1,216 @@
+#include <linux/interrupt.h>
+#include <linux/kdebug.h>
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/ptrace.h>
+#include <linux/stacktrace.h>
+#include <linux/string.h>
+
+#include "error.h"
+#include "shadow.h"
+
+enum kmemcheck_error_type {
+	KMEMCHECK_ERROR_INVALID_ACCESS,
+	KMEMCHECK_ERROR_BUG,
+};
+
+#define SHADOW_COPY_SIZE (1 << CONFIG_KMEMCHECK_SHADOW_COPY_SHIFT)
+
+struct kmemcheck_error {
+	enum kmemcheck_error_type type;
+
+	union {
+		/* KMEMCHECK_ERROR_INVALID_ACCESS */
+		struct {
+			/* Kind of access that caused the error */
+			enum kmemcheck_shadow state;
+			/* Address and size of the erroneous read */
+			unsigned long	address;
+			unsigned int	size;
+		};
+	};
+
+	struct pt_regs		regs;
+	struct stack_trace	trace;
+	unsigned long		trace_entries[32];
+
+	/* We compress it to a char. */
+	unsigned char		shadow_copy[SHADOW_COPY_SIZE];
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
+static struct kmemcheck_error *error_next_wr(void)
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
+static struct kmemcheck_error *error_next_rd(void)
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
+static void do_wakeup(unsigned long);
+static DECLARE_TASKLET(kmemcheck_tasklet, &do_wakeup, 0);
+
+/*
+ * Save the context of an error report.
+ */
+void kmemcheck_error_save(enum kmemcheck_shadow state,
+	unsigned long address, unsigned int size, struct pt_regs *regs)
+{
+	static unsigned long prev_ip;
+
+	struct kmemcheck_error *e;
+	enum shadow *shadow_copy;
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
+	e->type = KMEMCHECK_ERROR_INVALID_ACCESS;
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
+	e->trace.skip = 0;
+	save_stack_trace_bp(&e->trace, regs->bp);
+
+	/* Round address down to nearest 16 bytes */
+	shadow_copy = kmemcheck_shadow_lookup(address
+		& ~(SHADOW_COPY_SIZE - 1));
+	BUG_ON(!shadow_copy);
+
+	memcpy(e->shadow_copy, shadow_copy, SHADOW_COPY_SIZE);
+
+	tasklet_hi_schedule_first(&kmemcheck_tasklet);
+}
+
+/*
+ * Save the context of a kmemcheck bug.
+ */
+void kmemcheck_error_save_bug(struct pt_regs *regs)
+{
+	struct kmemcheck_error *e;
+
+	e = error_next_wr();
+	if (!e)
+		return;
+
+	e->type = KMEMCHECK_ERROR_BUG;
+
+	memcpy(&e->regs, regs, sizeof(*regs));
+
+	e->trace.nr_entries = 0;
+	e->trace.entries = e->trace_entries;
+	e->trace.max_entries = ARRAY_SIZE(e->trace_entries);
+	e->trace.skip = 1;
+	save_stack_trace(&e->trace);
+
+	tasklet_hi_schedule_first(&kmemcheck_tasklet);
+}
+
+void kmemcheck_error_recall(void)
+{
+	static const char *desc[] = {
+		[KMEMCHECK_SHADOW_UNALLOCATED]		= "unallocated",
+		[KMEMCHECK_SHADOW_UNINITIALIZED]	= "uninitialized",
+		[KMEMCHECK_SHADOW_INITIALIZED]		= "initialized",
+		[KMEMCHECK_SHADOW_FREED]		= "freed",
+	};
+
+	static const char short_desc[] = {
+		[KMEMCHECK_SHADOW_UNALLOCATED]		= 'a',
+		[KMEMCHECK_SHADOW_UNINITIALIZED]	= 'u',
+		[KMEMCHECK_SHADOW_INITIALIZED]		= 'i',
+		[KMEMCHECK_SHADOW_FREED]		= 'f',
+	};
+
+	struct kmemcheck_error *e;
+	unsigned int i;
+
+	e = error_next_rd();
+	if (!e)
+		return;
+
+	switch (e->type) {
+	case KMEMCHECK_ERROR_INVALID_ACCESS:
+		printk(KERN_ERR  "kmemcheck: Caught %d-bit read "
+			"from %s memory (%p)\n",
+			e->size, e->state < ARRAY_SIZE(desc) ?
+				desc[e->state] : "(invalid shadow state)",
+			(void *) e->address);
+
+		printk(KERN_INFO);
+		for (i = 0; i < SHADOW_COPY_SIZE; ++i) {
+			if (e->shadow_copy[i] < ARRAY_SIZE(short_desc))
+				printk("%c", short_desc[e->shadow_copy[i]]);
+			else
+				printk("?");
+		}
+		printk("\n");
+		printk(KERN_INFO "%*c\n",
+			1 + (int) (e->address & (SHADOW_COPY_SIZE - 1)), '^');
+		break;
+	case KMEMCHECK_ERROR_BUG:
+		printk(KERN_EMERG "kmemcheck: Fatal error\n");
+		break;
+	}
+
+	__show_regs(&e->regs, 1);
+	print_stack_trace(&e->trace, 0);
+}
+
+static void do_wakeup(unsigned long data)
+{
+	while (error_count > 0)
+		kmemcheck_error_recall();
+
+	if (error_missed_count > 0) {
+		printk(KERN_WARNING "kmemcheck: Lost %d error reports because "
+			"the queue was too small\n", error_missed_count);
+		error_missed_count = 0;
+	}
+}
diff --git a/arch/x86/mm/kmemcheck/error.h b/arch/x86/mm/kmemcheck/error.h
new file mode 100644
index 0000000..0efc2e8
--- /dev/null
+++ b/arch/x86/mm/kmemcheck/error.h
@@ -0,0 +1,15 @@
+#ifndef ARCH__X86__MM__KMEMCHECK__ERROR_H
+#define ARCH__X86__MM__KMEMCHECK__ERROR_H
+
+#include <linux/ptrace.h>
+
+#include "shadow.h"
+
+void kmemcheck_error_save(enum kmemcheck_shadow state,
+	unsigned long address, unsigned int size, struct pt_regs *regs);
+
+void kmemcheck_error_save_bug(struct pt_regs *regs);
+
+void kmemcheck_error_recall(void);
+
+#endif
diff --git a/arch/x86/mm/kmemcheck/kmemcheck.c b/arch/x86/mm/kmemcheck/kmemcheck.c
new file mode 100644
index 0000000..342151f
--- /dev/null
+++ b/arch/x86/mm/kmemcheck/kmemcheck.c
@@ -0,0 +1,477 @@
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
+#include <linux/interrupt.h>
+#include <linux/kallsyms.h>
+#include <linux/kernel.h>
+#include <linux/kmemcheck.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/page-flags.h>
+#include <linux/percpu.h>
+#include <linux/ptrace.h>
+#include <linux/string.h>
+#include <linux/types.h>
+
+#include <asm/cacheflush.h>
+#include <asm/kmemcheck.h>
+#include <asm/pgtable.h>
+#include <asm/tlbflush.h>
+
+#include "error.h"
+#include "opcode.h"
+#include "pte.h"
+#include "shadow.h"
+#include "smp.h"
+
+void __init kmemcheck_init(void)
+{
+	printk(KERN_INFO "kmemcheck: \"Bugs, beware!\"\n");
+
+	kmemcheck_smp_init();
+
+#if defined(CONFIG_SMP) && !defined(CONFIG_KMEMCHECK_USE_SMP)
+	/* Limit SMP to use a single CPU. We rely on the fact that this code
+	* runs before SMP is set up. */
+	if (setup_max_cpus > 1) {
+		printk(KERN_INFO
+			"kmemcheck: Limiting number of CPUs to 1.\n");
+		setup_max_cpus = 1;
+	}
+#endif
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
+static int __init param_kmemcheck(char *str)
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
+int kmemcheck_show_addr(unsigned long address)
+{
+	pte_t *pte;
+
+	pte = kmemcheck_pte_lookup(address);
+	if (!pte)
+		return 0;
+
+	set_pte(pte, __pte(pte_val(*pte) | _PAGE_PRESENT));
+	__flush_tlb_one(address);
+	return 1;
+}
+
+int kmemcheck_hide_addr(unsigned long address)
+{
+	pte_t *pte;
+
+	pte = kmemcheck_pte_lookup(address);
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
+static DEFINE_PER_CPU(struct kmemcheck_context, kmemcheck_context);
+
+bool kmemcheck_active(struct pt_regs *regs)
+{
+	struct kmemcheck_context *data = &__get_cpu_var(kmemcheck_context);
+
+	return data->balance > 0;
+}
+
+/*
+ * Called from the #PF handler.
+ */
+void kmemcheck_show(struct pt_regs *regs)
+{
+	struct kmemcheck_context *data = &__get_cpu_var(kmemcheck_context);
+	int n;
+
+	BUG_ON(!irqs_disabled());
+
+	kmemcheck_pause_allbutself();
+
+	if (unlikely(data->balance != 0)) {
+		kmemcheck_show_addr(data->addr1);
+		kmemcheck_show_addr(data->addr2);
+		kmemcheck_error_save_bug(regs);
+		data->balance = 0;
+		kmemcheck_resume();
+		return;
+	}
+
+	n = 0;
+	n += kmemcheck_show_addr(data->addr1);
+	n += kmemcheck_show_addr(data->addr2);
+
+	/* None of the addresses actually belonged to kmemcheck. Note that
+	 * this is not an error. */
+	if (n == 0) {
+		kmemcheck_resume();
+		return;
+	}
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
+	if (!(regs->flags & X86_EFLAGS_TF))
+		data->flags = regs->flags;
+
+	regs->flags |= X86_EFLAGS_TF;
+	regs->flags &= ~X86_EFLAGS_IF;
+}
+
+/*
+ * Called from the #DB handler.
+ */
+void kmemcheck_hide(struct pt_regs *regs)
+{
+	struct kmemcheck_context *data = &__get_cpu_var(kmemcheck_context);
+	int n;
+
+	BUG_ON(!irqs_disabled());
+
+	if (data->balance == 0) {
+		kmemcheck_resume();
+		return;
+	}
+
+	if (unlikely(data->balance != 1)) {
+		kmemcheck_show_addr(data->addr1);
+		kmemcheck_show_addr(data->addr2);
+		kmemcheck_error_save_bug(regs);
+		data->addr1 = 0;
+		data->addr2 = 0;
+		data->balance = 0;
+
+		if (!(data->flags & X86_EFLAGS_TF))
+			regs->flags &= ~X86_EFLAGS_TF;
+		if (data->flags & X86_EFLAGS_IF)
+			regs->flags |= X86_EFLAGS_IF;
+		kmemcheck_resume();
+		return;
+	}
+
+	n = 0;
+	if (kmemcheck_enabled) {
+		n += kmemcheck_hide_addr(data->addr1);
+		n += kmemcheck_hide_addr(data->addr2);
+	} else {
+		n += kmemcheck_show_addr(data->addr1);
+		n += kmemcheck_show_addr(data->addr2);
+	}
+
+	if (n == 0) {
+		kmemcheck_resume();
+		return;
+	}
+
+	--data->balance;
+
+	data->addr1 = 0;
+	data->addr2 = 0;
+
+	if (!(data->flags & X86_EFLAGS_TF))
+		regs->flags &= ~X86_EFLAGS_TF;
+	if (data->flags & X86_EFLAGS_IF)
+		regs->flags |= X86_EFLAGS_IF;
+	kmemcheck_resume();
+}
+
+void kmemcheck_show_pages(struct page *p, unsigned int n)
+{
+	unsigned int i;
+
+	for (i = 0; i < n; ++i) {
+		unsigned long address;
+		pte_t *pte;
+		unsigned int level;
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
+bool kmemcheck_page_is_tracked(struct page *p)
+{
+	/* This will also check the "hidden" flag of the PTE. */
+	return kmemcheck_pte_lookup((unsigned long) page_address(p));
+}
+
+void kmemcheck_hide_pages(struct page *p, unsigned int n)
+{
+	unsigned int i;
+
+	set_memory_4k((unsigned long) page_address(p), n);
+
+	for (i = 0; i < n; ++i) {
+		unsigned long address;
+		pte_t *pte;
+		unsigned int level;
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
+/*
+ * Check that an access does not span across two different pages, because
+ * that will mess up our shadow lookup.
+ */
+static bool check_page_boundary(struct pt_regs *regs,
+	unsigned long addr, unsigned int size)
+{
+	if (size == 8)
+		return false;
+	if (size == 16 && (addr & PAGE_MASK) == ((addr + 1) & PAGE_MASK))
+		return false;
+	if (size == 32 && (addr & PAGE_MASK) == ((addr + 3) & PAGE_MASK))
+		return false;
+#ifdef CONFIG_X86_64
+	if (size == 64 && (addr & PAGE_MASK) == ((addr + 7) & PAGE_MASK))
+		return false;
+#endif
+
+	/*
+	 * XXX: The addr/size data is also really interesting if this
+	 * case ever triggers. We should make a separate class of errors
+	 * for this case. -Vegard
+	 */
+	kmemcheck_error_save_bug(regs);
+	return true;
+}
+
+static void kmemcheck_read(struct pt_regs *regs,
+	unsigned long address, unsigned int size)
+{
+	void *shadow;
+	enum kmemcheck_shadow status;
+
+	shadow = kmemcheck_shadow_lookup(address);
+	if (!shadow)
+		return;
+
+	if (check_page_boundary(regs, address, size))
+		return;
+
+	status = kmemcheck_shadow_test(shadow, size);
+	if (status == KMEMCHECK_SHADOW_INITIALIZED)
+		return;
+
+	if (kmemcheck_enabled)
+		kmemcheck_error_save(status, address, size, regs);
+
+	if (kmemcheck_enabled == 2)
+		kmemcheck_enabled = 0;
+
+	/* Don't warn about it again. */
+	kmemcheck_shadow_set(shadow, size);
+}
+
+static void kmemcheck_write(struct pt_regs *regs,
+	unsigned long address, unsigned int size)
+{
+	void *shadow;
+
+	shadow = kmemcheck_shadow_lookup(address);
+	if (!shadow)
+		return;
+
+	if (check_page_boundary(regs, address, size))
+		return;
+
+	kmemcheck_shadow_set(shadow, size);
+}
+
+enum kmemcheck_method {
+	KMEMCHECK_READ,
+	KMEMCHECK_WRITE,
+};
+
+static void kmemcheck_access(struct pt_regs *regs,
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
+		kmemcheck_show_addr(fallback_address);
+		kmemcheck_error_save_bug(regs);
+		return;
+	}
+
+	data->busy = true;
+
+	insn = (const uint8_t *) regs->ip;
+	insn_primary = kmemcheck_opcode_get_primary(insn);
+
+	size = kmemcheck_opcode_get_size(insn);
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
+bool kmemcheck_fault(struct pt_regs *regs, unsigned long address,
+	unsigned long error_code)
+{
+	pte_t *pte;
+	unsigned int level;
+
+	pte = lookup_address(address, &level);
+	if (!pte)
+		return false;
+	if (level != PG_LEVEL_4K)
+		return false;
+	if (!pte_hidden(*pte))
+		return false;
+
+	if (error_code & 2)
+		kmemcheck_access(regs, address, KMEMCHECK_WRITE);
+	else
+		kmemcheck_access(regs, address, KMEMCHECK_READ);
+
+	kmemcheck_show(regs);
+	return true;
+}
diff --git a/arch/x86/mm/kmemcheck/opcode.c b/arch/x86/mm/kmemcheck/opcode.c
new file mode 100644
index 0000000..be0c8b7
--- /dev/null
+++ b/arch/x86/mm/kmemcheck/opcode.c
@@ -0,0 +1,70 @@
+#include <linux/types.h>
+
+#include "opcode.h"
+
+static bool opcode_is_prefix(uint8_t b)
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
+static bool opcode_is_rex_prefix(uint8_t b)
+{
+	return (b & 0xf0) == 0x40;
+}
+
+/* This is a VERY crude opcode decoder. We only need to find the size of the
+ * load/store that caused our #PF and this should work for all the opcodes
+ * that we care about. Moreover, the ones who invented this instruction set
+ * should be shot. */
+unsigned int kmemcheck_opcode_get_size(const uint8_t *op)
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
+#ifdef CONFIG_X86_64
+	/* REX prefix */
+	if (opcode_is_rex_prefix(*op)) {
+		if (*op & 0x08)
+			return 64;
+		++op;
+	}
+#endif
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
+const uint8_t *kmemcheck_opcode_get_primary(const uint8_t *op)
+{
+	/* skip prefixes */
+	while (opcode_is_prefix(*op))
+		++op;
+	if (opcode_is_rex_prefix(*op))
+		++op;
+	return op;
+}
+
diff --git a/arch/x86/mm/kmemcheck/opcode.h b/arch/x86/mm/kmemcheck/opcode.h
new file mode 100644
index 0000000..a19b8fa
--- /dev/null
+++ b/arch/x86/mm/kmemcheck/opcode.h
@@ -0,0 +1,9 @@
+#ifndef ARCH__X86__MM__KMEMCHECK__OPCODE_H
+#define ARCH__X86__MM__KMEMCHECK__OPCODE_H
+
+#include <linux/types.h>
+
+unsigned int kmemcheck_opcode_get_size(const uint8_t *op);
+const uint8_t *kmemcheck_opcode_get_primary(const uint8_t *op);
+
+#endif
diff --git a/arch/x86/mm/kmemcheck/pte.c b/arch/x86/mm/kmemcheck/pte.c
new file mode 100644
index 0000000..4ead26e
--- /dev/null
+++ b/arch/x86/mm/kmemcheck/pte.c
@@ -0,0 +1,22 @@
+#include <linux/mm.h>
+
+#include <asm/pgtable.h>
+
+#include "pte.h"
+
+pte_t *kmemcheck_pte_lookup(unsigned long address)
+{
+	pte_t *pte;
+	unsigned int level;
+
+	pte = lookup_address(address, &level);
+	if (!pte)
+		return NULL;
+	if (level != PG_LEVEL_4K)
+		return NULL;
+	if (!pte_hidden(*pte))
+		return NULL;
+
+	return pte;
+}
+
diff --git a/arch/x86/mm/kmemcheck/pte.h b/arch/x86/mm/kmemcheck/pte.h
new file mode 100644
index 0000000..9f59664
--- /dev/null
+++ b/arch/x86/mm/kmemcheck/pte.h
@@ -0,0 +1,10 @@
+#ifndef ARCH__X86__MM__KMEMCHECK__PTE_H
+#define ARCH__X86__MM__KMEMCHECK__PTE_H
+
+#include <linux/mm.h>
+
+#include <asm/pgtable.h>
+
+pte_t *kmemcheck_pte_lookup(unsigned long address);
+
+#endif
diff --git a/arch/x86/mm/kmemcheck/shadow.c b/arch/x86/mm/kmemcheck/shadow.c
new file mode 100644
index 0000000..0cb144f
--- /dev/null
+++ b/arch/x86/mm/kmemcheck/shadow.c
@@ -0,0 +1,175 @@
+#include <linux/kmemcheck.h>
+#include <linux/mm.h>
+
+#include <asm/page.h>
+#include <asm/pgtable.h>
+
+#include "pte.h"
+#include "shadow.h"
+
+/*
+ * Return the shadow address for the given address. Returns NULL if the
+ * address is not tracked.
+ *
+ * We need to be extremely careful not to follow any invalid pointers,
+ * because this function can be called for *any* possible address.
+ */
+void *kmemcheck_shadow_lookup(unsigned long address)
+{
+	pte_t *pte;
+	struct page *page;
+
+	if (!virt_addr_valid(address))
+		return NULL;
+
+	pte = kmemcheck_pte_lookup(address);
+	if (!pte)
+		return NULL;
+
+	page = virt_to_page(address);
+	if (!page->shadow)
+		return NULL;
+	return page->shadow + (address & (PAGE_SIZE - 1));
+}
+
+static void mark_shadow(void *address, unsigned int n,
+	enum kmemcheck_shadow status)
+{
+	void *shadow;
+
+	shadow = kmemcheck_shadow_lookup((unsigned long) address);
+	if (!shadow)
+		return;
+	__memset(shadow, status, n);
+}
+
+void kmemcheck_mark_unallocated(void *address, unsigned int n)
+{
+	mark_shadow(address, n, KMEMCHECK_SHADOW_UNALLOCATED);
+}
+
+void kmemcheck_mark_uninitialized(void *address, unsigned int n)
+{
+	mark_shadow(address, n, KMEMCHECK_SHADOW_UNINITIALIZED);
+}
+
+/*
+ * Fill the shadow memory of the given address such that the memory at that
+ * address is marked as being initialized.
+ */
+void kmemcheck_mark_initialized(void *address, unsigned int n)
+{
+	mark_shadow(address, n, KMEMCHECK_SHADOW_INITIALIZED);
+}
+
+void kmemcheck_mark_freed(void *address, unsigned int n)
+{
+	mark_shadow(address, n, KMEMCHECK_SHADOW_FREED);
+}
+
+void kmemcheck_mark_unallocated_pages(struct page *p, unsigned int n)
+{
+	unsigned int i;
+
+	for (i = 0; i < n; ++i)
+		kmemcheck_mark_unallocated(page_address(&p[i]), PAGE_SIZE);
+}
+
+void kmemcheck_mark_uninitialized_pages(struct page *p, unsigned int n)
+{
+	unsigned int i;
+
+	for (i = 0; i < n; ++i)
+		kmemcheck_mark_uninitialized(page_address(&p[i]), PAGE_SIZE);
+}
+
+enum kmemcheck_shadow kmemcheck_shadow_test(void *shadow, unsigned int size)
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
+#ifdef CONFIG_X86_64
+	case 64:
+		if (x[7] == KMEMCHECK_SHADOW_INITIALIZED)
+			return x[7];
+		if (x[6] == KMEMCHECK_SHADOW_INITIALIZED)
+			return x[6];
+		if (x[5] == KMEMCHECK_SHADOW_INITIALIZED)
+			return x[5];
+		if (x[4] == KMEMCHECK_SHADOW_INITIALIZED)
+			return x[4];
+#endif
+	case 32:
+		if (x[3] == KMEMCHECK_SHADOW_INITIALIZED)
+			return x[3];
+		if (x[2] == KMEMCHECK_SHADOW_INITIALIZED)
+			return x[2];
+	case 16:
+		if (x[1] == KMEMCHECK_SHADOW_INITIALIZED)
+			return x[1];
+	case 8:
+		if (x[0] == KMEMCHECK_SHADOW_INITIALIZED)
+			return x[0];
+	}
+#else
+	switch (size) {
+#ifdef CONFIG_X86_64
+	case 64:
+		if (x[7] != KMEMCHECK_SHADOW_INITIALIZED)
+			return x[7];
+		if (x[6] != KMEMCHECK_SHADOW_INITIALIZED)
+			return x[6];
+		if (x[5] != KMEMCHECK_SHADOW_INITIALIZED)
+			return x[5];
+		if (x[4] != KMEMCHECK_SHADOW_INITIALIZED)
+			return x[4];
+#endif
+	case 32:
+		if (x[3] != KMEMCHECK_SHADOW_INITIALIZED)
+			return x[3];
+		if (x[2] != KMEMCHECK_SHADOW_INITIALIZED)
+			return x[2];
+	case 16:
+		if (x[1] != KMEMCHECK_SHADOW_INITIALIZED)
+			return x[1];
+	case 8:
+		if (x[0] != KMEMCHECK_SHADOW_INITIALIZED)
+			return x[0];
+	}
+#endif
+
+	return x[0];
+}
+
+void kmemcheck_shadow_set(void *shadow, unsigned int size)
+{
+	uint8_t *x;
+
+	x = shadow;
+
+	switch (size) {
+#ifdef CONFIG_X86_64
+	case 64:
+		x[7] = KMEMCHECK_SHADOW_INITIALIZED;
+		x[6] = KMEMCHECK_SHADOW_INITIALIZED;
+		x[5] = KMEMCHECK_SHADOW_INITIALIZED;
+		x[4] = KMEMCHECK_SHADOW_INITIALIZED;
+#endif
+	case 32:
+		x[3] = KMEMCHECK_SHADOW_INITIALIZED;
+		x[2] = KMEMCHECK_SHADOW_INITIALIZED;
+	case 16:
+		x[1] = KMEMCHECK_SHADOW_INITIALIZED;
+	case 8:
+		x[0] = KMEMCHECK_SHADOW_INITIALIZED;
+	}
+
+	return;
+}
diff --git a/arch/x86/mm/kmemcheck/shadow.h b/arch/x86/mm/kmemcheck/shadow.h
new file mode 100644
index 0000000..af46d9a
--- /dev/null
+++ b/arch/x86/mm/kmemcheck/shadow.h
@@ -0,0 +1,16 @@
+#ifndef ARCH__X86__MM__KMEMCHECK__SHADOW_H
+#define ARCH__X86__MM__KMEMCHECK__SHADOW_H
+
+enum kmemcheck_shadow {
+	KMEMCHECK_SHADOW_UNALLOCATED,
+	KMEMCHECK_SHADOW_UNINITIALIZED,
+	KMEMCHECK_SHADOW_INITIALIZED,
+	KMEMCHECK_SHADOW_FREED,
+};
+
+void *kmemcheck_shadow_lookup(unsigned long address);
+
+enum kmemcheck_shadow kmemcheck_shadow_test(void *shadow, unsigned int size);
+void kmemcheck_shadow_set(void *shadow, unsigned int size);
+
+#endif
diff --git a/arch/x86/mm/kmemcheck/smp.c b/arch/x86/mm/kmemcheck/smp.c
new file mode 100644
index 0000000..0098b1a
--- /dev/null
+++ b/arch/x86/mm/kmemcheck/smp.c
@@ -0,0 +1,79 @@
+#include <linux/kdebug.h>
+#include <linux/notifier.h>
+#include <linux/smp.h>
+
+#include <mach_ipi.h>
+
+#include "smp.h"
+
+static DEFINE_SPINLOCK(nmi_spinlock);
+
+static atomic_t nmi_wait;
+static atomic_t nmi_resume;
+static atomic_t paused;
+
+static int nmi_notifier(struct notifier_block *self,
+	unsigned long val, void *data)
+{
+	if (val != DIE_NMI_IPI || !atomic_read(&nmi_wait))
+		return NOTIFY_DONE;
+
+	atomic_inc(&paused);
+
+	/* Pause until the fault has been handled */
+	while (!atomic_read(&nmi_resume))
+		cpu_relax();
+
+	atomic_dec(&paused);
+
+	return NOTIFY_STOP;
+}
+
+static struct notifier_block nmi_nb = {
+	.notifier_call = &nmi_notifier,
+};
+
+void kmemcheck_smp_init(void)
+{
+	int err;
+
+	err = register_die_notifier(&nmi_nb);
+	BUG_ON(err);
+}
+
+void kmemcheck_pause_allbutself(void)
+{
+	int cpus;
+	cpumask_t mask = cpu_online_map;
+
+	spin_lock(&nmi_spinlock);
+
+	cpus = num_online_cpus() - 1;
+
+	atomic_set(&paused, 0);
+	atomic_set(&nmi_wait, 1);
+	atomic_set(&nmi_resume, 0);
+
+	cpu_clear(safe_smp_processor_id(), mask);
+	if (!cpus_empty(mask))
+		send_IPI_mask(mask, NMI_VECTOR);
+
+	while (atomic_read(&paused) != cpus)
+		cpu_relax();
+
+	atomic_set(&nmi_wait, 0);
+}
+
+void kmemcheck_resume(void)
+{
+	int cpus;
+
+	cpus = num_online_cpus() - 1;
+
+	atomic_set(&nmi_resume, 1);
+
+	while (atomic_read(&paused) != 0)
+		cpu_relax();
+
+	spin_unlock(&nmi_spinlock);
+}
diff --git a/arch/x86/mm/kmemcheck/smp.h b/arch/x86/mm/kmemcheck/smp.h
new file mode 100644
index 0000000..dc65f16
--- /dev/null
+++ b/arch/x86/mm/kmemcheck/smp.h
@@ -0,0 +1,23 @@
+#ifndef ARCH__X86__MM__KMEMCHECK__SMP_H
+#define ARCH__X86__MM__KMEMCHECK__SMP_H
+
+#ifdef CONFIG_KMEMCHECK_USE_SMP
+void kmemcheck_smp_init(void);
+
+void kmemcheck_pause_allbutself(void);
+void kmemcheck_resume(void);
+#else
+static inline void kmemcheck_smp_init(void)
+{
+}
+
+static inline void kmemcheck_pause_allbutself(void)
+{
+}
+
+static inline void kmemcheck_resume(void)
+{
+}
+#endif
+
+#endif
diff --git a/arch/x86/mm/kmemcheck/string.c b/arch/x86/mm/kmemcheck/string.c
new file mode 100644
index 0000000..0d21d22
--- /dev/null
+++ b/arch/x86/mm/kmemcheck/string.c
@@ -0,0 +1,91 @@
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/kmemcheck.h>
+#include <linux/module.h>
+#include <linux/string.h>
+#include <linux/types.h>
+
+#include "shadow.h"
+#include "smp.h"
+
+/*
+ * A faster implementation of memset() when tracking is enabled where the
+ * whole memory area is within a single page.
+ */
+static void memset_one_page(void *s, int c, size_t n)
+{
+	unsigned long addr;
+	void *x;
+	unsigned long flags;
+
+	addr = (unsigned long) s;
+
+	x = kmemcheck_shadow_lookup(addr);
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
+	kmemcheck_pause_allbutself();
+	kmemcheck_show_addr(addr);
+	__memset(s, c, n);
+	__memset(x, KMEMCHECK_SHADOW_INITIALIZED, n);
+	if (kmemcheck_enabled)
+		kmemcheck_hide_addr(addr);
+	kmemcheck_resume();
+
+	local_irq_restore(flags);
+}
+
+/*
+ * A faster implementation of memset() when tracking is enabled. We cannot
+ * assume that all pages within the range are tracked, so copying has to be
+ * split into page-sized (or smaller, for the ends) chunks.
+ */
+void *kmemcheck_memset(void *s, int c, size_t n)
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
index 0000000..f625398
--- /dev/null
+++ b/include/asm-x86/kmemcheck.h
@@ -0,0 +1,36 @@
+#ifndef ASM_X86_KMEMCHECK_H
+#define ASM_X86_KMEMCHECK_H
+
+#include <linux/types.h>
+#include <asm/ptrace.h>
+
+#ifdef CONFIG_KMEMCHECK
+bool kmemcheck_active(struct pt_regs *regs);
+
+void kmemcheck_show(struct pt_regs *regs);
+void kmemcheck_hide(struct pt_regs *regs);
+
+bool kmemcheck_fault(struct pt_regs *regs,
+	unsigned long address, unsigned long error_code);
+#else
+static inline bool kmemcheck_active(struct pt_regs *regs)
+{
+	return false;
+}
+
+static inline void kmemcheck_show(struct pt_regs *regs)
+{
+}
+
+static inline void kmemcheck_hide(struct pt_regs *regs)
+{
+}
+
+static inline bool kmemcheck_fault(struct pt_regs *regs,
+	unsigned long address, unsigned long error_code)
+{
+	return false;
+}
+#endif /* CONFIG_KMEMCHECK */
+
+#endif
diff --git a/include/asm-x86/pgtable.h b/include/asm-x86/pgtable.h
index 97c271b..0333c35 100644
--- a/include/asm-x86/pgtable.h
+++ b/include/asm-x86/pgtable.h
@@ -16,7 +16,7 @@
 #define _PAGE_BIT_GLOBAL	8	/* Global TLB entry PPro+ */
 #define _PAGE_BIT_UNUSED1	9	/* available for programmer */
 #define _PAGE_BIT_UNUSED2	10
-#define _PAGE_BIT_UNUSED3	11
+#define _PAGE_BIT_HIDDEN	11	/* hidden by kmemcheck */
 #define _PAGE_BIT_PAT_LARGE	12	/* On 2MB or 1GB pages */
 #define _PAGE_BIT_NX           63       /* No execute: only valid after cpuid check */
 
@@ -36,9 +36,9 @@
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
index 32ca031..d724813 100644
--- a/include/asm-x86/pgtable_32.h
+++ b/include/asm-x86/pgtable_32.h
@@ -85,6 +85,12 @@ extern unsigned long pg0[];
 
 #define pte_present(x)	((x).pte_low & (_PAGE_PRESENT | _PAGE_PROTNONE))
 
+#ifdef CONFIG_KMEMCHECK
+#define pte_hidden(x)	((x).pte_low & (_PAGE_HIDDEN))
+#else
+#define pte_hidden(x)	0
+#endif
+
 /* To avoid harmful races, pmd_none(x) should check only the lower when PAE */
 #define pmd_none(x)	(!(unsigned long)pmd_val((x)))
 #define pmd_present(x)	(pmd_val((x)) & _PAGE_PRESENT)
diff --git a/include/linux/kmemcheck.h b/include/linux/kmemcheck.h
new file mode 100644
index 0000000..266edbf
--- /dev/null
+++ b/include/linux/kmemcheck.h
@@ -0,0 +1,22 @@
+#ifndef LINUX_KMEMCHECK_H
+#define LINUX_KMEMCHECK_H
+
+#include <linux/mm_types.h>
+#include <linux/types.h>
+
+#ifdef CONFIG_KMEMCHECK
+extern int kmemcheck_enabled;
+
+void kmemcheck_init(void);
+
+int kmemcheck_show_addr(unsigned long address);
+int kmemcheck_hide_addr(unsigned long address);
+#else
+#define kmemcheck_enabled 0
+
+static inline void kmemcheck_init(void)
+{
+}
+#endif /* CONFIG_KMEMCHECK */
+
+#endif /* LINUX_KMEMCHECK_H */
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 02a27ae..f54e52a 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -94,6 +94,10 @@ struct page {
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR
 	unsigned long page_cgroup;
 #endif
+
+#ifdef CONFIG_KMEMCHECK
+	void *shadow;
+#endif
 };
 
 /*
diff --git a/init/main.c b/init/main.c
index f7fb200..39a9ec4 100644
--- a/init/main.c
+++ b/init/main.c
@@ -60,6 +60,7 @@
 #include <linux/sched.h>
 #include <linux/signal.h>
 #include <linux/idr.h>
+#include <linux/kmemcheck.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -779,6 +780,7 @@ static void __init do_pre_smp_initcalls(void)
 {
 	extern int spawn_ksoftirqd(void);
 
+	kmemcheck_init();
 	migration_init();
 	spawn_ksoftirqd();
 	if (!nosoftlockup)
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 2911665..69a32c1 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -27,6 +27,7 @@
 #include <linux/security.h>
 #include <linux/ctype.h>
 #include <linux/utsname.h>
+#include <linux/kmemcheck.h>
 #include <linux/smp_lock.h>
 #include <linux/fs.h>
 #include <linux/init.h>
@@ -813,6 +814,17 @@ static struct ctl_table kern_table[] = {
 		.child		= key_sysctls,
 	},
 #endif
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
1.5.5.1

