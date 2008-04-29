Return-Path: <linux-kernel-owner+w=401wt.eu-S1760653AbYD2UgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760653AbYD2UgX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 16:36:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755370AbYD2UgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 16:36:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41858 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517AbYD2UgC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 16:36:02 -0400
Date: Tue, 29 Apr 2008 22:34:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [git pull] kmemcheck
Message-ID: <20080429203446.GA18314@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull the latest kmemcheck git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-kmemcheck-v3.git for-linus

the SLUB impact has been ACK-ed (and co-authored :) by the SLUB folks. 
Andrew is happy too now that kmemcheck does not use up any page flags.

Thanks,

	Ingo

------------------>
Pekka Enberg (4):
      x86: __show_registers() and __show_regs() API unification
      kmemcheck: support for 64-bit
      kmemcheck: add missing pte_hidden() for x86-64
      kmemcheck: add Vegard and Pekka to MAINTAINERS

Vegard Nossum (4):
      kmemcheck: add the kmemcheck core
      x86: add hooks for kmemcheck
      slub: add kmemcheck support
      kmemcheck: enable in the x86 Kconfig

 Documentation/kmemcheck.txt    |  101 +++++
 MAINTAINERS                    |    8 +
 arch/x86/Kconfig.debug         |   64 +++
 arch/x86/kernel/Makefile       |    2 +
 arch/x86/kernel/cpu/common.c   |    7 +
 arch/x86/kernel/entry_32.S     |    8 +-
 arch/x86/kernel/entry_64.S     |    4 +-
 arch/x86/kernel/head_32.S      |    2 +-
 arch/x86/kernel/kmemcheck.c    |  918 ++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/process.c      |    2 +-
 arch/x86/kernel/process_32.c   |    4 +-
 arch/x86/kernel/process_64.c   |   12 +-
 arch/x86/kernel/traps_32.c     |   18 +-
 arch/x86/kernel/traps_64.c     |   21 +-
 arch/x86/mm/fault.c            |   25 +-
 arch/x86/mm/init_32.c          |    2 +-
 include/asm-x86/kdebug.h       |    3 +-
 include/asm-x86/kmemcheck.h    |   30 ++
 include/asm-x86/pgtable.h      |    4 +-
 include/asm-x86/pgtable_32.h   |    6 +
 include/asm-x86/pgtable_64.h   |    6 +
 include/asm-x86/string_32.h    |    8 +
 include/asm-x86/string_64.h    |    1 +
 include/linux/gfp.h            |    3 +-
 include/linux/kmemcheck.h      |   29 ++
 include/linux/mm_types.h       |    4 +
 include/linux/slab.h           |    7 +
 include/linux/slub_kmemcheck.h |   32 ++
 init/main.c                    |    2 +
 kernel/fork.c                  |   16 +-
 kernel/sysctl.c                |   12 +
 mm/Makefile                    |    3 +
 mm/slub.c                      |   19 +-
 mm/slub_kmemcheck.c            |  107 +++++
 34 files changed, 1452 insertions(+), 38 deletions(-)
 create mode 100644 Documentation/kmemcheck.txt
 create mode 100644 arch/x86/kernel/kmemcheck.c
 create mode 100644 include/asm-x86/kmemcheck.h
 create mode 100644 include/linux/kmemcheck.h
 create mode 100644 include/linux/slub_kmemcheck.h
 create mode 100644 mm/slub_kmemcheck.c

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
diff --git a/MAINTAINERS b/MAINTAINERS
index c4e5b5d..1d022a4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2369,6 +2369,14 @@ M:	jason.wessel@windriver.com
 L:	kgdb-bugreport@lists.sourceforge.net
 S:	Maintained
 
+KMEMCHECK
+P:	Vegard Nossum
+M:	vegardno@ifi.uio.no
+P	Pekka Enberg
+M:	penberg@cs.helsinki.fi
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+
 KPROBES
 P:	Ananth N Mavinakayanahalli
 M:	ananth@in.ibm.com
diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 5b1979a..136cc89 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -243,6 +243,70 @@ config DEFAULT_IO_DELAY_TYPE
 	default IO_DELAY_TYPE_NONE
 endif
 
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
 config DEBUG_BOOT_PARAMS
 	bool "Debug boot parameters"
 	depends on DEBUG_KERNEL
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 30d54ed..6c5a7f1 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -93,6 +93,8 @@ scx200-y			+= scx200_32.o
 
 obj-$(CONFIG_OLPC)		+= olpc.o
 
+obj-$(CONFIG_KMEMCHECK)		+= kmemcheck.o
+
 ###
 # 64 bit specific files
 ifeq ($(CONFIG_X86_64),y)
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 35b4f6a..39933f6 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -651,6 +651,13 @@ void __init early_cpu_init(void)
 		cpu_devs[cvdev->vendor] = cvdev->cpu_dev;
 
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
index 2a609dc..5f624fc 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -282,7 +282,7 @@ ENTRY(ia32_sysenter_target)
 	CFI_DEF_CFA esp, 0
 	CFI_REGISTER esp, ebp
 	movl TSS_sysenter_sp0(%esp),%esp
-sysenter_past_esp:
+ENTRY(sysenter_past_esp)
 	/*
 	 * Interrupts are disabled here, but we can't trace it until
 	 * enough kernel state to call TRACE_IRQS_OFF can be called - but
@@ -761,7 +761,7 @@ label:						\
 	CFI_ADJUST_CFA_OFFSET 4;		\
 	CFI_REL_OFFSET eip, 0
 
-KPROBE_ENTRY(debug)
+KPROBE_ENTRY(x86_debug)
 	RING0_INT_FRAME
 	cmpl $ia32_sysenter_target,(%esp)
 	jne debug_stack_correct
@@ -775,7 +775,7 @@ debug_stack_correct:
 	call do_debug
 	jmp ret_from_exception
 	CFI_ENDPROC
-KPROBE_END(debug)
+KPROBE_END(x86_debug)
 
 /*
  * NMI is doubly nasty. It can happen _while_ we're handling
@@ -829,7 +829,7 @@ nmi_debug_stack_check:
 	/* We have a RING0_INT_FRAME here */
 	cmpw $__KERNEL_CS,16(%esp)
 	jne nmi_stack_correct
-	cmpl $debug,(%esp)
+	cmpl $x86_debug,(%esp)
 	jb nmi_stack_correct
 	cmpl $debug_esp_fix_insn,(%esp)
 	ja nmi_stack_correct
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 556a8df..1edd9ac 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1073,13 +1073,13 @@ ENTRY(device_not_available)
 END(device_not_available)
 
 	/* runs on exception stack */
-KPROBE_ENTRY(debug)
+KPROBE_ENTRY(x86_debug)
  	INTR_FRAME
 	pushq $0
 	CFI_ADJUST_CFA_OFFSET 8		
 	paranoidentry do_debug, DEBUG_STACK
 	paranoidexit
-KPROBE_END(debug)
+KPROBE_END(x86_debug)
 
 	/* runs on exception stack */	
 KPROBE_ENTRY(nmi)
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 90f038a..debbc6a 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -60,7 +60,7 @@ LOW_PAGES = 1<<(32-PAGE_SHIFT_asm)
  * pagetables from above the 16MB DMA limit, so we'll have to set
  * up pagetables 16MB more (worst-case):
  */
-#ifdef CONFIG_DEBUG_PAGEALLOC
+#if defined(CONFIG_DEBUG_PAGEALLOC) || defined(CONFIG_KMEMCHECK)
 LOW_PAGES = LOW_PAGES + 0x1000000
 #endif
 
diff --git a/arch/x86/kernel/kmemcheck.c b/arch/x86/kernel/kmemcheck.c
new file mode 100644
index 0000000..408ba6d
--- /dev/null
+++ b/arch/x86/kernel/kmemcheck.c
@@ -0,0 +1,918 @@
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
+#include <linux/kmemcheck.h>
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
+			"from %s memory (%p)\n",
+			e->size, desc[e->state], (void *) e->address);
+		break;
+	case ERROR_BUG:
+		printk(KERN_EMERG "kmemcheck: Fatal error\n");
+		break;
+	}
+
+	__show_regs(&e->regs, 1);
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
+	unsigned int level;
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
+	page = virt_to_page(address);
+	head = compound_head(page);
+	return head->shadow + ((void *) address - page_address(head));
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
+static DEFINE_PER_CPU(struct kmemcheck_context, kmemcheck_context);
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
+		if (!(data->flags & X86_EFLAGS_TF))
+			regs->flags &= ~X86_EFLAGS_TF;
+		if (data->flags & X86_EFLAGS_IF)
+			regs->flags |= X86_EFLAGS_IF;
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
+	if (!(data->flags & X86_EFLAGS_TF))
+		regs->flags &= ~X86_EFLAGS_TF;
+	if (data->flags & X86_EFLAGS_IF)
+		regs->flags |= X86_EFLAGS_IF;
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
+		unsigned int level;
+
+		address = (unsigned long) page_address(&p[i]);
+		pte = lookup_address(address, &level);
+		BUG_ON(!pte);
+
+		if (level != PG_LEVEL_4K)
+			continue;
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
+		unsigned int level;
+
+		address = (unsigned long) page_address(&p[i]);
+		pte = lookup_address(address, &level);
+		BUG_ON(!pte);
+		if (level != PG_LEVEL_4K)
+			continue;
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
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 67e9b4a..cdf05ca 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -42,7 +42,7 @@ void arch_task_cache_init(void)
         task_xstate_cachep =
         	kmem_cache_create("task_xstate", xstate_size,
 				  __alignof__(union thread_xstate),
-				  SLAB_PANIC, NULL);
+				  SLAB_PANIC | SLAB_NOTRACK, NULL);
 }
 
 static void do_nothing(void *unused)
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index f8476df..ace6550 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -194,7 +194,7 @@ void cpu_idle(void)
 	}
 }
 
-void __show_registers(struct pt_regs *regs, int all)
+void __show_regs(struct pt_regs *regs, int all)
 {
 	unsigned long cr0 = 0L, cr2 = 0L, cr3 = 0L, cr4 = 0L;
 	unsigned long d0, d1, d2, d3, d6, d7;
@@ -255,7 +255,7 @@ void __show_registers(struct pt_regs *regs, int all)
 
 void show_regs(struct pt_regs *regs)
 {
-	__show_registers(regs, 1);
+	__show_regs(regs, 1);
 	show_trace(NULL, regs, &regs->sp, regs->bp);
 }
 
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index e2319f3..a18d00f 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -180,7 +180,7 @@ void cpu_idle(void)
 }
 
 /* Prints also some state that isn't saved in the pt_regs */
-void __show_regs(struct pt_regs * regs)
+void __show_regs(struct pt_regs * regs, int all)
 {
 	unsigned long cr0 = 0L, cr2 = 0L, cr3 = 0L, cr4 = 0L, fs, gs, shadowgs;
 	unsigned long d0, d1, d2, d3, d6, d7;
@@ -219,13 +219,17 @@ void __show_regs(struct pt_regs * regs)
 	rdmsrl(MSR_GS_BASE, gs); 
 	rdmsrl(MSR_KERNEL_GS_BASE, shadowgs); 
 
+	printk("FS:  %016lx(%04x) GS:%016lx(%04x) knlGS:%016lx\n",
+	       fs,fsindex,gs,gsindex,shadowgs);
+
+	if (!all)
+		return;
+
 	cr0 = read_cr0();
 	cr2 = read_cr2();
 	cr3 = read_cr3();
 	cr4 = read_cr4();
 
-	printk("FS:  %016lx(%04x) GS:%016lx(%04x) knlGS:%016lx\n", 
-	       fs,fsindex,gs,gsindex,shadowgs); 
 	printk("CS:  %04x DS: %04x ES: %04x CR0: %016lx\n", cs, ds, es, cr0); 
 	printk("CR2: %016lx CR3: %016lx CR4: %016lx\n", cr2, cr3, cr4);
 
@@ -242,7 +246,7 @@ void __show_regs(struct pt_regs * regs)
 void show_regs(struct pt_regs *regs)
 {
 	printk("CPU %d:", smp_processor_id());
-	__show_regs(regs);
+	__show_regs(regs, 1);
 	show_trace(NULL, regs, (void *)(regs + 1), regs->bp);
 }
 
diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index bde6f63..7fad084 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -57,6 +57,7 @@
 #include <asm/nmi.h>
 #include <asm/smp.h>
 #include <asm/io.h>
+#include <asm/kmemcheck.h>
 
 #include "mach_traps.h"
 
@@ -330,7 +331,7 @@ void show_registers(struct pt_regs *regs)
 	int i;
 
 	print_modules();
-	__show_registers(regs, 0);
+	__show_regs(regs, 0);
 
 	printk(KERN_EMERG "Process %.*s (pid: %d, ti=%p task=%p task.ti=%p)",
 		TASK_COMM_LEN, current->comm, task_pid_nr(current),
@@ -874,6 +875,10 @@ void __kprobes do_int3(struct pt_regs *regs, long error_code)
 }
 #endif
 
+extern void ia32_sysenter_target(void);
+extern void sysenter_past_esp(void);
+extern void x86_debug(void);
+
 /*
  * Our handling of the processor debug registers is non-trivial.
  * We do not clear them on entry and exit from the kernel. Therefore
@@ -905,6 +910,14 @@ void __kprobes do_debug(struct pt_regs *regs, long error_code)
 
 	get_debugreg(condition, 6);
 
+	/* Catch kmemcheck conditions first of all! */
+	if (condition & DR_STEP) {
+		if (kmemcheck_active(regs)) {
+			kmemcheck_hide(regs);
+			return;
+		}
+	}
+
 	/*
 	 * The processor cleared BTF, so don't mark that we need it set.
 	 */
@@ -914,6 +927,7 @@ void __kprobes do_debug(struct pt_regs *regs, long error_code)
 	if (notify_die(DIE_DEBUG, "debug", regs, condition, error_code,
 					SIGTRAP) == NOTIFY_STOP)
 		return;
+
 	/* It's safe to allow irq's after DR6 has been saved */
 	if (regs->flags & X86_EFLAGS_IF)
 		local_irq_enable();
@@ -1199,7 +1213,7 @@ void __init trap_init(void)
 	init_apic_mappings();
 #endif
 	set_trap_gate(0,  &divide_error);
-	set_intr_gate(1,  &debug);
+	set_intr_gate(1,  &x86_debug);
 	set_intr_gate(2,  &nmi);
 	set_system_intr_gate(3, &int3); /* int3/4 can be called from all */
 	set_system_gate(4, &overflow);
diff --git a/arch/x86/kernel/traps_64.c b/arch/x86/kernel/traps_64.c
index adff76e..8069073 100644
--- a/arch/x86/kernel/traps_64.c
+++ b/arch/x86/kernel/traps_64.c
@@ -53,6 +53,7 @@
 #include <asm/proto.h>
 #include <asm/nmi.h>
 #include <asm/stacktrace.h>
+#include <asm/kmemcheck.h>
 
 asmlinkage void divide_error(void);
 asmlinkage void debug(void);
@@ -470,7 +471,7 @@ void show_registers(struct pt_regs *regs)
 	sp = regs->sp;
 	ip = (u8 *) regs->ip - code_prologue;
 	printk("CPU %d ", cpu);
-	__show_regs(regs);
+	__show_regs(regs, 1);
 	printk("Process %s (pid: %d, threadinfo %p, task %p)\n",
 		cur->comm, cur->pid, task_thread_info(cur), cur);
 
@@ -899,6 +900,9 @@ asmlinkage __kprobes struct pt_regs *sync_regs(struct pt_regs *eregs)
 	return regs;
 }
 
+extern void ia32_sysenter_target(void);
+extern void x86_debug(void);
+
 /* runs on IST stack. */
 asmlinkage void __kprobes do_debug(struct pt_regs * regs,
 				   unsigned long error_code)
@@ -911,6 +915,19 @@ asmlinkage void __kprobes do_debug(struct pt_regs * regs,
 
 	get_debugreg(condition, 6);
 
+#ifdef CONFIG_KMEMCHECK
+	/* Catch kmemcheck conditions first of all! */
+	if (condition & DR_STEP) {
+		if (!(regs->flags & X86_VM_MASK) && !user_mode(regs) &&
+			((void *)regs->ip != system_call) &&
+			((void *)regs->ip != x86_debug) &&
+			((void *)regs->ip != ia32_sysenter_target)) {
+			kmemcheck_hide(regs);
+			return;
+		}
+	}
+#endif
+
 	/*
 	 * The processor cleared BTF, so don't mark that we need it set.
 	 */
@@ -1150,7 +1167,7 @@ EXPORT_SYMBOL_GPL(math_state_restore);
 void __init trap_init(void)
 {
 	set_intr_gate(0,&divide_error);
-	set_intr_gate_ist(1,&debug,DEBUG_STACK);
+	set_intr_gate_ist(1,&x86_debug,DEBUG_STACK);
 	set_intr_gate_ist(2,&nmi,NMI_STACK);
  	set_system_gate_ist(3,&int3,DEBUG_STACK); /* int3 can be called from all */
 	set_system_gate(4,&overflow);	/* int4 can be called from all */
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index fd7e179..694a0b0 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -33,6 +33,7 @@
 #include <asm/smp.h>
 #include <asm/tlbflush.h>
 #include <asm/proto.h>
+#include <asm/kmemcheck.h>
 #include <asm-generic/sections.h>
 
 /*
@@ -491,7 +492,8 @@ static int spurious_fault(unsigned long address,
  *
  * This assumes no large pages in there.
  */
-static int vmalloc_fault(unsigned long address)
+static int vmalloc_fault(struct pt_regs *regs, unsigned long address,
+	unsigned long error_code)
 {
 #ifdef CONFIG_X86_32
 	unsigned long pgd_paddr;
@@ -509,8 +511,16 @@ static int vmalloc_fault(unsigned long address)
 	if (!pmd_k)
 		return -1;
 	pte_k = pte_offset_kernel(pmd_k, address);
-	if (!pte_present(*pte_k))
-		return -1;
+	if (!pte_present(*pte_k)) {
+		if (!pte_hidden(*pte_k))
+			return -1;
+
+		if (error_code & 2)
+			kmemcheck_access(regs, address, KMEMCHECK_WRITE);
+		else
+			kmemcheck_access(regs, address, KMEMCHECK_READ);
+		kmemcheck_show(regs);
+	}
 	return 0;
 #else
 	pgd_t *pgd, *pgd_ref;
@@ -599,6 +609,13 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
 
 	si_code = SEGV_MAPERR;
 
+	/*
+	 * Detect and handle instructions that would cause a page fault for
+	 * both a tracked kernel page and a userspace page.
+	 */
+	if(kmemcheck_active(regs))
+		kmemcheck_hide(regs);
+
 	if (notify_page_fault(regs))
 		return;
 
@@ -621,7 +638,7 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
 	if (unlikely(address >= TASK_SIZE64)) {
 #endif
 		if (!(error_code & (PF_RSVD|PF_USER|PF_PROT)) &&
-		    vmalloc_fault(address) >= 0)
+		    vmalloc_fault(regs, address, error_code) >= 0)
 			return;
 
 		/* Can handle a stale RO->RW TLB */
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index de236e4..806c6aa 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -92,7 +92,7 @@ static pte_t * __init one_page_table_init(pmd_t *pmd)
 	if (!(pmd_val(*pmd) & _PAGE_PRESENT)) {
 		pte_t *page_table = NULL;
 
-#ifdef CONFIG_DEBUG_PAGEALLOC
+#if defined(CONFIG_DEBUG_PAGEALLOC) || defined(CONFIG_KMEMCHECK)
 		page_table = (pte_t *) alloc_bootmem_pages(PAGE_SIZE);
 #endif
 		if (!page_table) {
diff --git a/include/asm-x86/kdebug.h b/include/asm-x86/kdebug.h
index 96651bb..fe1fbde 100644
--- a/include/asm-x86/kdebug.h
+++ b/include/asm-x86/kdebug.h
@@ -27,10 +27,9 @@ extern void printk_address(unsigned long address, int reliable);
 extern void die(const char *, struct pt_regs *,long);
 extern int __must_check __die(const char *, struct pt_regs *, long);
 extern void show_registers(struct pt_regs *regs);
-extern void __show_registers(struct pt_regs *, int all);
 extern void show_trace(struct task_struct *t, struct pt_regs *regs,
 		       unsigned long *sp, unsigned long bp);
-extern void __show_regs(struct pt_regs *regs);
+extern void __show_regs(struct pt_regs *regs, int all);
 extern void show_regs(struct pt_regs *regs);
 extern unsigned long oops_begin(void);
 extern void oops_end(unsigned long, struct pt_regs *, int signr);
diff --git a/include/asm-x86/kmemcheck.h b/include/asm-x86/kmemcheck.h
new file mode 100644
index 0000000..7c6b7ec
--- /dev/null
+++ b/include/asm-x86/kmemcheck.h
@@ -0,0 +1,30 @@
+#ifndef ASM_X86_KMEMCHECK_H
+#define ASM_X86_KMEMCHECK_H
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
index 801b31f..b95791a 100644
--- a/include/asm-x86/pgtable.h
+++ b/include/asm-x86/pgtable.h
@@ -16,8 +16,8 @@
 #define _PAGE_BIT_GLOBAL	8	/* Global TLB entry PPro+ */
 #define _PAGE_BIT_UNUSED1	9	/* available for programmer */
 #define _PAGE_BIT_UNUSED2	10
-#define _PAGE_BIT_UNUSED3	11
 #define _PAGE_BIT_PAT_LARGE	12	/* On 2MB or 1GB pages */
+#define _PAGE_BIT_HIDDEN	11
 #define _PAGE_BIT_NX           63       /* No execute: only valid after cpuid check */
 
 /*
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
index 577ab79..248cfea 100644
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
diff --git a/include/asm-x86/pgtable_64.h b/include/asm-x86/pgtable_64.h
index a3bbf87..abb9b32 100644
--- a/include/asm-x86/pgtable_64.h
+++ b/include/asm-x86/pgtable_64.h
@@ -171,6 +171,12 @@ static inline unsigned long pmd_bad(pmd_t pmd)
 #define pte_none(x)	(!pte_val((x)))
 #define pte_present(x)	(pte_val((x)) & (_PAGE_PRESENT | _PAGE_PROTNONE))
 
+#ifdef CONFIG_KMEMCHECK
+#define pte_hidden(x)	(pte_val((x)) & (_PAGE_HIDDEN))
+#else
+#define pte_hidden(x)	0
+#endif
+
 #define pages_to_mb(x)	((x) >> (20 - PAGE_SHIFT))   /* FIXME: is this right? */
 #define pte_page(x)	pfn_to_page(pte_pfn((x)))
 #define pte_pfn(x)	((pte_val((x)) & __PHYSICAL_MASK) >> PAGE_SHIFT)
diff --git a/include/asm-x86/string_32.h b/include/asm-x86/string_32.h
index b49369a..fade185 100644
--- a/include/asm-x86/string_32.h
+++ b/include/asm-x86/string_32.h
@@ -262,6 +262,14 @@ __asm__  __volatile__( \
  __constant_c_x_memset((s),(0x01010101UL*(unsigned char)(c)),(count)) : \
  __memset((s),(c),(count)))
 
+/* If kmemcheck is enabled, our best bet is a custom memset() that disables
+ * checking in order to save a whole lot of (unnecessary) page faults. */
+#ifdef CONFIG_KMEMCHECK
+void *kmemcheck_memset(void *s, int c, size_t n);
+#undef memset
+#define memset(s, c, n) kmemcheck_memset((s), (c), (n))
+#endif
+
 /*
  * find the first occurrence of byte 'c', or 1 past the area if none
  */
diff --git a/include/asm-x86/string_64.h b/include/asm-x86/string_64.h
index 52b5ab3..49874fd 100644
--- a/include/asm-x86/string_64.h
+++ b/include/asm-x86/string_64.h
@@ -45,6 +45,7 @@ extern void *__memcpy(void *to, const void *from, size_t len);
 
 #define __HAVE_ARCH_MEMSET
 void *memset(void *s, int c, size_t n);
+void *__memset(void *s, int c, size_t n);
 
 #define __HAVE_ARCH_MEMMOVE
 void *memmove(void *dest, const void *src, size_t count);
diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index b414be3..7c1db87 100644
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
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index eb7c16c..cb77aaf 100644
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
diff --git a/include/linux/slab.h b/include/linux/slab.h
index f62caaa..d5505b1 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -29,6 +29,13 @@
 #define SLAB_MEM_SPREAD		0x00100000UL	/* Spread some memory over cpuset */
 #define SLAB_TRACE		0x00200000UL	/* Trace allocations and frees */
 
+#ifdef CONFIG_KMEMCHECK
+/* Don't track use of uninitialized memory */
+# define SLAB_NOTRACK		0x00400000UL
+#else
+# define SLAB_NOTRACK		0
+#endif
+
 /* The following flags affect the page allocator grouping pages by mobility */
 #define SLAB_RECLAIM_ACCOUNT	0x00020000UL		/* Objects are reclaimable */
 #define SLAB_TEMPORARY		SLAB_RECLAIM_ACCOUNT	/* Objects are short-lived */
diff --git a/include/linux/slub_kmemcheck.h b/include/linux/slub_kmemcheck.h
new file mode 100644
index 0000000..9fc4a94
--- /dev/null
+++ b/include/linux/slub_kmemcheck.h
@@ -0,0 +1,32 @@
+#ifndef LINUX__SLUB_KMEMCHECK__H
+#define LINUX__SLUB_KMEMCHECK__H
+
+#ifdef CONFIG_KMEMCHECK
+void kmemcheck_alloc_shadow(struct kmem_cache *s, gfp_t flags, int node,
+			   struct page *page);
+void kmemcheck_free_shadow(struct kmem_cache *s, struct page *page);
+void kmemcheck_slab_alloc(struct kmem_cache *s, gfp_t gfpflags, void *object);
+void kmemcheck_slab_free(struct kmem_cache *s, void *object);
+#else
+static inline void
+kmemcheck_alloc_shadow(struct kmem_cache *s, gfp_t flags, int node,
+		       struct page *page)
+{
+}
+
+static inline void
+kmemcheck_free_shadow(struct kmem_cache *s, struct page *page)
+{
+}
+
+static inline void
+kmemcheck_slab_alloc(struct kmem_cache *s, gfp_t gfpflags, void *object)
+{
+}
+
+static inline void kmemcheck_slab_free(struct kmem_cache *s, void *object)
+{
+}
+#endif /* CONFIG_KMEMCHECK */
+
+#endif /* LINUX__SLUB_KMEMCHECK__H */
diff --git a/init/main.c b/init/main.c
index 624266b..788b5d1 100644
--- a/init/main.c
+++ b/init/main.c
@@ -59,6 +59,7 @@
 #include <linux/sched.h>
 #include <linux/signal.h>
 #include <linux/idr.h>
+#include <linux/kmemcheck.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -773,6 +774,7 @@ static void __init do_pre_smp_initcalls(void)
 {
 	extern int spawn_ksoftirqd(void);
 
+	kmemcheck_init();
 	migration_init();
 	spawn_ksoftirqd();
 	if (!nosoftlockup)
diff --git a/kernel/fork.c b/kernel/fork.c
index 068ffe0..46b87b6 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -149,7 +149,7 @@ void __init fork_init(unsigned long mempages)
 	/* create a slab on which task_structs can be allocated */
 	task_struct_cachep =
 		kmem_cache_create("task_struct", sizeof(struct task_struct),
-			ARCH_MIN_TASKALIGN, SLAB_PANIC, NULL);
+			ARCH_MIN_TASKALIGN, SLAB_PANIC | SLAB_NOTRACK, NULL);
 #endif
 
 	/* do the arch specific task caches init */
@@ -1544,23 +1544,23 @@ void __init proc_caches_init(void)
 {
 	sighand_cachep = kmem_cache_create("sighand_cache",
 			sizeof(struct sighand_struct), 0,
-			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_DESTROY_BY_RCU,
-			sighand_ctor);
+			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_DESTROY_BY_RCU|
+			SLAB_NOTRACK, sighand_ctor);
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
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index d7ffdc5..042ee49 100644
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
@@ -812,6 +813,17 @@ static struct ctl_table kern_table[] = {
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
diff --git a/mm/Makefile b/mm/Makefile
index 18c143b..ac5f15d 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -34,3 +34,6 @@ obj-$(CONFIG_SMP) += allocpercpu.o
 obj-$(CONFIG_QUICKLIST) += quicklist.o
 obj-$(CONFIG_CGROUP_MEM_RES_CTLR) += memcontrol.o
 
+ifeq ($(CONFIG_KMEMCHECK),y)
+obj-$(CONFIG_SLUB) += slub_kmemcheck.o
+endif
diff --git a/mm/slub.c b/mm/slub.c
index b145e79..ae4b1da 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -21,6 +21,8 @@
 #include <linux/ctype.h>
 #include <linux/kallsyms.h>
 #include <linux/memory.h>
+#include <linux/kmemcheck.h>
+#include <linux/slub_kmemcheck.h>
 
 /*
  * Lock order:
@@ -172,7 +174,7 @@ static inline void ClearSlabDebug(struct page *page)
 		SLAB_TRACE | SLAB_DESTROY_BY_RCU)
 
 #define SLUB_MERGE_SAME (SLAB_DEBUG_FREE | SLAB_RECLAIM_ACCOUNT | \
-		SLAB_CACHE_DMA)
+		SLAB_CACHE_DMA | SLAB_NOTRACK)
 
 #ifndef ARCH_KMALLOC_MINALIGN
 #define ARCH_KMALLOC_MINALIGN __alignof__(unsigned long long)
@@ -1119,6 +1121,10 @@ static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
 
 		stat(get_cpu_slab(s, raw_smp_processor_id()), ORDER_FALLBACK);
 	}
+
+	if (kmemcheck_enabled && !(s->flags & SLAB_NOTRACK))
+		kmemcheck_alloc_shadow(s, flags, node, page);
+
 	page->objects = oo_objects(oo);
 	mod_zone_page_state(page_zone(page),
 		(s->flags & SLAB_RECLAIM_ACCOUNT) ?
@@ -1192,6 +1198,9 @@ static void __free_slab(struct kmem_cache *s, struct page *page)
 		ClearSlabDebug(page);
 	}
 
+	if (kmemcheck_page_is_tracked(page) && !(s->flags & SLAB_NOTRACK))
+		kmemcheck_free_shadow(s, page);
+
 	mod_zone_page_state(page_zone(page),
 		(s->flags & SLAB_RECLAIM_ACCOUNT) ?
 		NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE,
@@ -1642,6 +1651,7 @@ static __always_inline void *slab_alloc(struct kmem_cache *s,
 	if (unlikely((gfpflags & __GFP_ZERO) && object))
 		memset(object, 0, c->objsize);
 
+	kmemcheck_slab_alloc(s, gfpflags, object);
 	return object;
 }
 
@@ -1744,6 +1754,8 @@ static __always_inline void slab_free(struct kmem_cache *s,
 	struct kmem_cache_cpu *c;
 	unsigned long flags;
 
+	kmemcheck_slab_free(s, object);
+
 	local_irq_save(flags);
 	c = get_cpu_slab(s, smp_processor_id());
 	debug_check_no_locks_freed(object, c->objsize);
@@ -2595,7 +2607,8 @@ static noinline struct kmem_cache *dma_kmalloc_cache(int index, gfp_t flags)
 
 	if (!s || !text || !kmem_cache_open(s, flags, text,
 			realsize, ARCH_KMALLOC_MINALIGN,
-			SLAB_CACHE_DMA|__SYSFS_ADD_DEFERRED, NULL)) {
+			SLAB_CACHE_DMA|SLAB_NOTRACK|__SYSFS_ADD_DEFERRED,
+			NULL)) {
 		kfree(s);
 		kfree(text);
 		goto unlock_out;
@@ -4285,6 +4298,8 @@ static char *create_unique_id(struct kmem_cache *s)
 		*p++ = 'a';
 	if (s->flags & SLAB_DEBUG_FREE)
 		*p++ = 'F';
+	if (!(s->flags & SLAB_NOTRACK))
+		*p++ = 't';
 	if (p != name + 1)
 		*p++ = '-';
 	p += sprintf(p, "%07d", s->size);
diff --git a/mm/slub_kmemcheck.c b/mm/slub_kmemcheck.c
new file mode 100644
index 0000000..1fa8168
--- /dev/null
+++ b/mm/slub_kmemcheck.c
@@ -0,0 +1,107 @@
+#include <linux/mm_types.h>
+#include <linux/mm.h>
+#include <linux/slab.h>
+#include <linux/kmemcheck.h>
+#include <linux/slub_kmemcheck.h>
+
+void kmemcheck_alloc_shadow(struct kmem_cache *s, gfp_t flags, int node,
+			   struct page *page)
+{
+	struct page *shadow;
+	int order, pages;
+
+	order = compound_order(page);
+	pages = 1 << order;
+
+	/*
+	 * With kmemcheck enabled, we need to allocate a memory area for the
+	 * shadow bits as well.
+	 */
+
+	flags |= __GFP_COMP;
+
+	shadow = alloc_pages_node(node, flags, order);
+	if (!shadow) {
+		if (printk_ratelimit())
+			printk(KERN_ERR "SLUB: failed to allocate kmemcheck "
+				"shadow bitmap\n");
+		return;
+	}
+
+	page->shadow = page_address(shadow);
+
+	/*
+	 * Mark it as non-present for the MMU so that our accesses to
+	 * this memory will trigger a page fault and let us analyze
+	 * the memory accesses.
+	 */
+	kmemcheck_hide_pages(page, pages);
+
+	/*
+	 * Objects from caches that have a constructor don't get
+	 * cleared when they're allocated, so we need to do it here.
+	 */
+	if (s->ctor)
+		kmemcheck_mark_uninitialized_pages(page, pages);
+	else
+		kmemcheck_mark_unallocated_pages(page, pages);
+
+	mod_zone_page_state(page_zone(shadow),
+		(s->flags & SLAB_RECLAIM_ACCOUNT) ?
+		NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE,
+		pages);
+}
+
+void kmemcheck_free_shadow(struct kmem_cache *s, struct page *page)
+{
+	struct page *shadow = virt_to_page(page->shadow);
+	int order, pages;
+
+	order = compound_order(page);
+	pages = 1 << order;
+
+	kmemcheck_show_pages(page, pages);
+
+	__ClearPageSlab(shadow);
+	mod_zone_page_state(page_zone(shadow),
+		(s->flags & SLAB_RECLAIM_ACCOUNT) ?
+		NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE,
+		-pages);
+	reset_page_mapcount(shadow);
+	__free_pages(shadow, order);
+}
+
+void
+kmemcheck_slab_alloc(struct kmem_cache *s, gfp_t gfpflags, void *object)
+{
+	if (gfpflags & __GFP_ZERO)
+		return;
+	if (s->flags & SLAB_NOTRACK)
+		return;
+
+	if (!kmemcheck_enabled || gfpflags & __GFP_NOTRACK) {
+		/*
+		 * Allow notracked objects to be allocated from
+		 * tracked caches. Note however that these objects
+		 * will still get page faults on access, they just
+		 * won't ever be flagged as uninitialized. If page
+		 * faults are not acceptable, the slab cache itself
+		 * should be marked NOTRACK.
+		 */
+		kmemcheck_mark_initialized(object, s->objsize);
+	} else if (!s->ctor) {
+		/*
+		 * New objects should be marked uninitialized before
+		 * they're returned to the called.
+		 */
+		kmemcheck_mark_uninitialized(object, s->objsize);
+	}
+}
+
+void
+kmemcheck_slab_free(struct kmem_cache *s, void *object)
+{
+	/* TODO: RCU freeing is unsupported for now; hide false positives. */
+	if (!s->ctor && !(s->flags & SLAB_DESTROY_BY_RCU))
+		kmemcheck_mark_freed(object, s->objsize);
+}
