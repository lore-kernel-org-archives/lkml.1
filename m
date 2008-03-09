Return-Path: <linux-kernel-owner+w=401wt.eu-S1752899AbYCIOrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899AbYCIOrq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 10:47:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751823AbYCIOri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 10:47:38 -0400
Received: from pne-smtpout4-sn1.fre.skanova.net ([81.228.11.168]:60135 "EHLO
	pne-smtpout4-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751777AbYCIOrg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 10:47:36 -0400
Date: Sun, 9 Mar 2008 16:46:07 +0200
From: Pekka Paalanen <pq@iki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Paalanen <pq@iki.fi>, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>, Pavel Roskin <proski@gnu.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC] mmiotrace full patch, preview 2
Message-ID: <20080309164607.443da6d1@daedalus.pq.iki.fi>
In-Reply-To: <20080309164050.2194461e@daedalus.pq.iki.fi>
References: <20080309164050.2194461e@daedalus.pq.iki.fi>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From bc32dcfb4048bb74c774fd3de724bd38e8b98c2f Mon Sep 17 00:00:00 2001
From: Pekka Paalanen <pq@iki.fi>
Date: Sun, 9 Mar 2008 13:52:25 +0200
Subject: [PATCH] x86 mmiotrace: update preview 1 to preview 2

Kconfig.debug, Makefile and testmmiotrace.c style fixes.
Use real mutex instead of mutex.
Fix failure path in register probe func.
kmmio: RCU read-locked over single stepping.
Generate mapping id's.
Make mmio-mod.c built-in and rewrite its locking.
Add debugfs file to enable/disable mmiotracing.
kmmio: use irqsave spinlocks.
Lots of cleanups in mmio-mod.c
Marker file moved from /proc into debugfs.
Call mmiotrace entrypoints directly from ioremap.c.

Signed-off-by: Pekka Paalanen <pq@iki.fi>
---
 arch/x86/Kconfig.debug      |   20 +--
 arch/x86/mm/Makefile        |    2 +-
 arch/x86/mm/ioremap.c       |    9 +-
 arch/x86/mm/kmmio.c         |   72 ++++-----
 arch/x86/mm/mmio-mod.c      |  397 ++++++++++++++++++++++++++++---------------
 arch/x86/mm/testmmiotrace.c |   15 +-
 include/linux/mmiotrace.h   |   18 ++-
 7 files changed, 332 insertions(+), 201 deletions(-)

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 177fd06..4c4fea0 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -183,22 +183,19 @@ config SYSPROF
 
 config MMIOTRACE_HOOKS
 	bool
-	default n
 
 config MMIOTRACE
-	tristate "Memory mapped IO tracing"
+	bool "Memory mapped IO tracing"
 	depends on DEBUG_KERNEL && RELAY && DEBUG_FS
 	select MMIOTRACE_HOOKS
-	default n
+	default y
 	help
-	  This will build a kernel module called mmiotrace.
-	  Making this a built-in is heavily discouraged.
-
-	  Mmiotrace traces Memory Mapped I/O access and is meant for debugging
-	  and reverse engineering. The kernel module offers wrapped
-	  versions of the ioremap family of functions. The driver to be traced
-	  must be modified to call these wrappers. A user space program is
-	  required to collect the MMIO data.
+	  Mmiotrace traces Memory Mapped I/O access and is meant for
+	  debugging and reverse engineering. It is called from the ioremap
+	  implementation and works via page faults. A user space program is
+	  required to collect the MMIO data from debugfs files.
+	  Tracing is disabled by default and can be enabled from a debugfs
+	  file.
 
 	  See http://nouveau.freedesktop.org/wiki/MmioTrace
 	  If you are not helping to develop drivers, say N.
@@ -206,7 +203,6 @@ config MMIOTRACE
 config MMIOTRACE_TEST
 	tristate "Test module for mmiotrace"
 	depends on MMIOTRACE && m
-	default n
 	help
 	  This is a dumb module for testing mmiotrace. It is very dangerous
 	  as it will write garbage to IO memory starting at a given address.
diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index e8f6e34..e6821ed 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -5,7 +5,7 @@ obj-$(CONFIG_X86_32)		+= pgtable_32.o
 
 obj-$(CONFIG_MMIOTRACE_HOOKS)	+= kmmio.o
 obj-$(CONFIG_MMIOTRACE)		+= mmiotrace.o
-mmiotrace-objs			:= pf_in.o mmio-mod.o
+mmiotrace-y			:= pf_in.o mmio-mod.o
 obj-$(CONFIG_MMIOTRACE_TEST)	+= testmmiotrace.o
 
 obj-$(CONFIG_HUGETLB_PAGE)	+= hugetlbpage.o
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 26b75e4..1253c35 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -12,6 +12,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
+#include <linux/mmiotrace.h>
 
 #include <asm/cacheflush.h>
 #include <asm/e820.h>
@@ -124,6 +125,7 @@ static void __iomem *__ioremap(unsigned long phys_addr, unsigned long size,
 	unsigned long pfn, offset, last_addr, vaddr;
 	struct vm_struct *area;
 	pgprot_t prot;
+	void __iomem *ret_addr;
 
 	/* Don't allow wraparound or zero size */
 	last_addr = phys_addr + size - 1;
@@ -191,7 +193,10 @@ static void __iomem *__ioremap(unsigned long phys_addr, unsigned long size,
 		return NULL;
 	}
 
-	return (void __iomem *) (vaddr + offset);
+	ret_addr = (void __iomem *) (vaddr + offset);
+	mmiotrace_ioremap(phys_addr, size, ret_addr);
+
+	return ret_addr;
 }
 
 /**
@@ -249,6 +254,8 @@ void iounmap(volatile void __iomem *addr)
 	    addr < phys_to_virt(ISA_END_ADDRESS))
 		return;
 
+	mmiotrace_iounmap(addr);
+
 	addr = (volatile void __iomem *)
 		(PAGE_MASK & (unsigned long __force)addr);
 
diff --git a/arch/x86/mm/kmmio.c b/arch/x86/mm/kmmio.c
index 539a9b1..efb4679 100644
--- a/arch/x86/mm/kmmio.c
+++ b/arch/x86/mm/kmmio.c
@@ -19,6 +19,7 @@
 #include <linux/preempt.h>
 #include <linux/percpu.h>
 #include <linux/kdebug.h>
+#include <linux/mutex.h>
 #include <asm/io.h>
 #include <asm/cacheflush.h>
 #include <asm/errno.h>
@@ -59,7 +60,7 @@ struct kmmio_context {
 static int kmmio_die_notifier(struct notifier_block *nb, unsigned long val,
 								void *args);
 
-static DECLARE_MUTEX(kmmio_init_mutex);
+static DEFINE_MUTEX(kmmio_init_mutex);
 static DEFINE_SPINLOCK(kmmio_lock);
 
 /* These are protected by kmmio_lock */
@@ -90,7 +91,7 @@ static struct notifier_block nb_die = {
  */
 void reference_kmmio(void)
 {
-	down(&kmmio_init_mutex);
+	mutex_lock(&kmmio_init_mutex);
 	spin_lock_irq(&kmmio_lock);
 	if (!kmmio_initialized) {
 		int i;
@@ -101,7 +102,7 @@ void reference_kmmio(void)
 	}
 	kmmio_initialized++;
 	spin_unlock_irq(&kmmio_lock);
-	up(&kmmio_init_mutex);
+	mutex_unlock(&kmmio_init_mutex);
 }
 EXPORT_SYMBOL_GPL(reference_kmmio);
 
@@ -115,7 +116,7 @@ void unreference_kmmio(void)
 {
 	bool unreg = false;
 
-	down(&kmmio_init_mutex);
+	mutex_lock(&kmmio_init_mutex);
 	spin_lock_irq(&kmmio_lock);
 
 	if (kmmio_initialized == 1) {
@@ -128,7 +129,7 @@ void unreference_kmmio(void)
 
 	if (unreg)
 		unregister_die_notifier(&nb_die); /* calls sync_rcu() */
-	up(&kmmio_init_mutex);
+	mutex_unlock(&kmmio_init_mutex);
 }
 EXPORT_SYMBOL(unreference_kmmio);
 
@@ -244,17 +245,13 @@ int kmmio_handler(struct pt_regs *regs, unsigned long addr)
 	 * Preemption is now disabled to prevent process switch during
 	 * single stepping. We can only handle one active kmmio trace
 	 * per cpu, so ensure that we finish it before something else
-	 * gets to run.
-	 *
-	 * XXX what if an interrupt occurs between returning from
-	 * do_page_fault() and entering the single-step exception handler?
-	 * And that interrupt triggers a kmmio trap?
-	 * XXX If we tracing an interrupt service routine or whatever, is
-	 * this enough to keep it on the current cpu?
+	 * gets to run. We also hold the RCU read lock over single
+	 * stepping to avoid looking up the probe and kmmio_fault_page
+	 * again.
 	 */
 	preempt_disable();
-
 	rcu_read_lock();
+
 	faultpage = get_kmmio_fault_page(addr);
 	if (!faultpage) {
 		/*
@@ -287,14 +284,24 @@ int kmmio_handler(struct pt_regs *regs, unsigned long addr)
 	if (ctx->probe && ctx->probe->pre_handler)
 		ctx->probe->pre_handler(ctx->probe, regs, addr);
 
+	/*
+	 * Enable single-stepping and disable interrupts for the faulting
+	 * context. Local interrupts must not get enabled during stepping.
+	 */
 	regs->flags |= TF_MASK;
 	regs->flags &= ~IF_MASK;
 
 	/* Now we set present bit in PTE and single step. */
 	disarm_kmmio_fault_page(ctx->fpage->page, NULL);
 
+	/*
+	 * If another cpu accesses the same page while we are stepping,
+	 * the access will not be caught. It will simply succeed and the
+	 * only downside is we lose the event. If this becomes a problem,
+	 * the user should drop to single cpu before tracing.
+	 */
+
 	put_cpu_var(kmmio_ctx);
-	rcu_read_unlock();
 	return 1;
 
 no_kmmio_ctx:
@@ -313,32 +320,15 @@ no_kmmio:
 static int post_kmmio_handler(unsigned long condition, struct pt_regs *regs)
 {
 	int ret = 0;
-	struct kmmio_probe *probe;
-	struct kmmio_fault_page *faultpage;
 	struct kmmio_context *ctx = &get_cpu_var(kmmio_ctx);
 
 	if (!ctx->active)
 		goto out;
 
-	rcu_read_lock();
-
-	faultpage = get_kmmio_fault_page(ctx->addr);
-	probe = get_kmmio_probe(ctx->addr);
-	if (faultpage != ctx->fpage || probe != ctx->probe) {
-		/*
-		 * The trace setup changed after kmmio_handler() and before
-		 * running this respective post handler. User does not want
-		 * the result anymore.
-		 */
-		ctx->probe = NULL;
-		ctx->fpage = NULL;
-	}
-
 	if (ctx->probe && ctx->probe->post_handler)
 		ctx->probe->post_handler(ctx->probe, condition, regs);
 
-	if (ctx->fpage)
-		arm_kmmio_fault_page(ctx->fpage->page, NULL);
+	arm_kmmio_fault_page(ctx->fpage->page, NULL);
 
 	regs->flags &= ~TF_MASK;
 	regs->flags |= ctx->saved_flags;
@@ -346,6 +336,7 @@ static int post_kmmio_handler(unsigned long condition, struct pt_regs *regs)
 	/* These were acquired in kmmio_handler(). */
 	ctx->active--;
 	BUG_ON(ctx->active);
+	rcu_read_unlock();
 	preempt_enable_no_resched();
 
 	/*
@@ -355,8 +346,6 @@ static int post_kmmio_handler(unsigned long condition, struct pt_regs *regs)
 	 */
 	if (!(regs->flags & TF_MASK))
 		ret = 1;
-
-	rcu_read_unlock();
 out:
 	put_cpu_var(kmmio_ctx);
 	return ret;
@@ -411,15 +400,16 @@ static void release_kmmio_fault_page(unsigned long page,
 
 int register_kmmio_probe(struct kmmio_probe *p)
 {
+	unsigned long flags;
 	int ret = 0;
 	unsigned long size = 0;
 
-	spin_lock_irq(&kmmio_lock);
-	kmmio_count++;
+	spin_lock_irqsave(&kmmio_lock, flags);
 	if (get_kmmio_probe(p->addr)) {
 		ret = -EEXIST;
 		goto out;
 	}
+	kmmio_count++;
 	list_add_rcu(&p->list, &kmmio_probes);
 	while (size < p->len) {
 		if (add_kmmio_fault_page(p->addr + size))
@@ -427,7 +417,7 @@ int register_kmmio_probe(struct kmmio_probe *p)
 		size += PAGE_SIZE;
 	}
 out:
-	spin_unlock_irq(&kmmio_lock);
+	spin_unlock_irqrestore(&kmmio_lock, flags);
 	/*
 	 * XXX: What should I do here?
 	 * Here was a call to global_flush_tlb(), but it does not exist
@@ -478,7 +468,8 @@ static void remove_kmmio_fault_pages(struct rcu_head *head)
 
 /*
  * Remove a kmmio probe. You have to synchronize_rcu() before you can be
- * sure that the callbacks will not be called anymore.
+ * sure that the callbacks will not be called anymore. Only after that
+ * you may actually release your struct kmmio_probe.
  *
  * Unregistering a kmmio fault page has three steps:
  * 1. release_kmmio_fault_page()
@@ -490,18 +481,19 @@ static void remove_kmmio_fault_pages(struct rcu_head *head)
  */
 void unregister_kmmio_probe(struct kmmio_probe *p)
 {
+	unsigned long flags;
 	unsigned long size = 0;
 	struct kmmio_fault_page *release_list = NULL;
 	struct kmmio_delayed_release *drelease;
 
-	spin_lock_irq(&kmmio_lock);
+	spin_lock_irqsave(&kmmio_lock, flags);
 	while (size < p->len) {
 		release_kmmio_fault_page(p->addr + size, &release_list);
 		size += PAGE_SIZE;
 	}
 	list_del_rcu(&p->list);
 	kmmio_count--;
-	spin_unlock_irq(&kmmio_lock);
+	spin_unlock_irqrestore(&kmmio_lock, flags);
 
 	drelease = kmalloc(sizeof(*drelease), GFP_ATOMIC);
 	if (!drelease) {
diff --git a/arch/x86/mm/mmio-mod.c b/arch/x86/mm/mmio-mod.c
index e1a5085..7386440 100644
--- a/arch/x86/mm/mmio-mod.c
+++ b/arch/x86/mm/mmio-mod.c
@@ -19,6 +19,8 @@
  *
  * Derived from the read-mod example from relay-examples by Tom Zanussi.
  */
+#define DEBUG 1
+
 #include <linux/module.h>
 #include <linux/relay.h>
 #include <linux/debugfs.h>
@@ -34,12 +36,12 @@
 
 #include "pf_in.h"
 
-/* This app's relay channel files will appear in /debug/mmio-trace */
-#define APP_DIR		"mmio-trace"
-/* the marker injection file in /proc */
-#define MARKER_FILE     "mmio-marker"
+#define NAME "mmiotrace: "
 
-#define MODULE_NAME     "mmiotrace"
+/* This app's relay channel files will appear in /debug/mmio-trace */
+static const char APP_DIR[] = "mmio-trace";
+/* the marker injection file in /debug/APP_DIR */
+static const char MARKER_FILE[] = "mmio-marker";
 
 struct trap_reason {
 	unsigned long addr;
@@ -48,6 +50,15 @@ struct trap_reason {
 	int active_traces;
 };
 
+struct remap_trace {
+	struct list_head list;
+	struct kmmio_probe probe;
+	unsigned long phys;
+	unsigned long id;
+};
+
+static const size_t subbuf_size = 256*1024;
+
 /* Accessed per-cpu. */
 static DEFINE_PER_CPU(struct trap_reason, pf_reason);
 static DEFINE_PER_CPU(struct mm_io_header_rw, cpu_trace);
@@ -55,33 +66,53 @@ static DEFINE_PER_CPU(struct mm_io_header_rw, cpu_trace);
 /* Access to this is not per-cpu. */
 static DEFINE_PER_CPU(atomic_t, dropped);
 
-static struct file_operations mmio_fops = {
-	.owner = THIS_MODULE,
-};
+static struct dentry *dir;
+static struct dentry *enabled_file;
+static struct dentry *marker_file;
 
-static const size_t subbuf_size = 256*1024;
+static DEFINE_MUTEX(mmiotrace_mutex);
+static DEFINE_SPINLOCK(trace_lock);
+static atomic_t mmiotrace_enabled;
+static LIST_HEAD(trace_list);		/* struct remap_trace */
 static struct rchan *chan;
-static struct dentry *dir;
-static struct proc_dir_entry *proc_marker_file;
+
+/*
+ * Locking in this file:
+ * - mmiotrace_mutex enforces enable/disable_mmiotrace() critical sections.
+ * - mmiotrace_enabled may be modified only when holding mmiotrace_mutex
+ *   and trace_lock.
+ * - Routines depending on is_enabled() must take trace_lock.
+ * - trace_list users must hold trace_lock.
+ * - is_enabled() guarantees that chan is valid.
+ * - pre/post callbacks assume the effect of is_enabled() being true.
+ */
 
 /* module parameters */
-static unsigned int      n_subbufs = 32*4;
-static unsigned long filter_offset;
-static int                 nommiotrace;
-static int               ISA_trace;
-static int                trace_pc;
+static unsigned int	n_subbufs = 32*4;
+static unsigned long	filter_offset;
+static int		nommiotrace;
+static int		ISA_trace;
+static int		trace_pc;
+static int		enable_now;
 
 module_param(n_subbufs, uint, 0);
 module_param(filter_offset, ulong, 0);
 module_param(nommiotrace, bool, 0);
 module_param(ISA_trace, bool, 0);
 module_param(trace_pc, bool, 0);
+module_param(enable_now, bool, 0);
 
 MODULE_PARM_DESC(n_subbufs, "Number of 256kB buffers, default 128.");
 MODULE_PARM_DESC(filter_offset, "Start address of traced mappings.");
 MODULE_PARM_DESC(nommiotrace, "Disable actual MMIO tracing.");
 MODULE_PARM_DESC(ISA_trace, "Do not exclude the low ISA range.");
 MODULE_PARM_DESC(trace_pc, "Record address of faulting instructions.");
+MODULE_PARM_DESC(enable_now, "Start mmiotracing immediately on module load.");
+
+static bool is_enabled(void)
+{
+	return atomic_read(&mmiotrace_enabled);
+}
 
 static void record_timestamp(struct mm_io_header *header)
 {
@@ -93,15 +124,15 @@ static void record_timestamp(struct mm_io_header *header)
 }
 
 /*
- * Write callback for the /proc entry:
+ * Write callback for the debugfs entry:
  * Read a marker and write it to the mmio trace log
  */
-static int write_marker(struct file *file, const char __user *buffer,
-					unsigned long count, void *data)
+static ssize_t write_marker(struct file *file, const char __user *buffer,
+						size_t count, loff_t *ppos)
 {
 	char *event = NULL;
 	struct mm_io_header *headp;
-	int len = (count > 65535) ? 65535 : count;
+	ssize_t len = (count > 65535) ? 65535 : count;
 
 	event = kzalloc(sizeof(*headp) + len, GFP_KERNEL);
 	if (!event)
@@ -117,7 +148,12 @@ static int write_marker(struct file *file, const char __user *buffer,
 		return -EFAULT;
 	}
 
-	relay_write(chan, event, sizeof(*headp) + len);
+	spin_lock_irq(&trace_lock);
+	if (is_enabled())
+		relay_write(chan, event, sizeof(*headp) + len);
+	else
+		len = -EINVAL;
+	spin_unlock_irq(&trace_lock);
 	kfree(event);
 	return len;
 }
@@ -128,19 +164,18 @@ static void print_pte(unsigned long address)
 	pte_t *pte = lookup_address(address, &level);
 
 	if (!pte) {
-		pr_err(MODULE_NAME ": Error in %s: no pte for page 0x%08lx\n",
+		pr_err(NAME "Error in %s: no pte for page 0x%08lx\n",
 							__func__, address);
 		return;
 	}
 
 	if (level == PG_LEVEL_2M) {
-		pr_emerg(MODULE_NAME ": 4MB pages are not currently "
-						"supported: %lx\n", address);
+		pr_emerg(NAME "4MB pages are not currently supported: "
+							"0x%08lx\n", address);
 		BUG();
 	}
-	pr_info(MODULE_NAME ": pte for 0x%lx: 0x%lx 0x%lx\n",
-					address, pte_val(*pte),
-					pte_val(*pte) & _PAGE_PRESENT);
+	pr_info(NAME "pte for 0x%lx: 0x%lx 0x%lx\n", address, pte_val(*pte),
+						pte_val(*pte) & _PAGE_PRESENT);
 }
 
 /*
@@ -150,22 +185,18 @@ static void print_pte(unsigned long address)
 static void die_kmmio_nesting_error(struct pt_regs *regs, unsigned long addr)
 {
 	const struct trap_reason *my_reason = &get_cpu_var(pf_reason);
-	pr_emerg(MODULE_NAME ": unexpected fault for address: %lx, "
-					"last fault for address: %lx\n",
+	pr_emerg(NAME "unexpected fault for address: 0x%08lx, "
+					"last fault for address: 0x%08lx\n",
 					addr, my_reason->addr);
 	print_pte(addr);
+	print_symbol(KERN_EMERG "faulting IP is at %s\n", regs->ip);
+	print_symbol(KERN_EMERG "last faulting IP was at %s\n", my_reason->ip);
 #ifdef __i386__
-	print_symbol(KERN_EMERG "faulting EIP is at %s\n", regs->ip);
-	print_symbol(KERN_EMERG "last faulting EIP was at %s\n",
-							my_reason->ip);
 	pr_emerg("eax: %08lx   ebx: %08lx   ecx: %08lx   edx: %08lx\n",
 			regs->ax, regs->bx, regs->cx, regs->dx);
 	pr_emerg("esi: %08lx   edi: %08lx   ebp: %08lx   esp: %08lx\n",
 			regs->si, regs->di, regs->bp, regs->sp);
 #else
-	print_symbol(KERN_EMERG "faulting RIP is at %s\n", regs->ip);
-	print_symbol(KERN_EMERG "last faulting RIP was at %s\n",
-							my_reason->ip);
 	pr_emerg("rax: %016lx   rcx: %016lx   rdx: %016lx\n",
 					regs->ax, regs->cx, regs->dx);
 	pr_emerg("rsi: %016lx   rdi: %016lx   rbp: %016lx   rsp: %016lx\n",
@@ -197,6 +228,10 @@ static void pre(struct kmmio_probe *p, struct pt_regs *regs,
 	my_trace->header.pid = 0;
 	my_trace->header.data_len = sizeof(struct mm_io_rw);
 	my_trace->rw.address = addr;
+	/*
+	 * struct remap_trace *trace = p->user_data;
+	 * phys = addr - trace->probe.addr + trace->phys;
+	 */
 
 	/*
 	 * Only record the program counter when requested.
@@ -246,15 +281,10 @@ static void post(struct kmmio_probe *p, unsigned long condition,
 	struct trap_reason *my_reason = &get_cpu_var(pf_reason);
 	struct mm_io_header_rw *my_trace = &get_cpu_var(cpu_trace);
 
-	/*
-	 * XXX: This might not get called, if the probe is removed while
-	 * trace hit is on flight.
-	 */
-
 	/* this should always return the active_trace count to 0 */
 	my_reason->active_traces--;
 	if (my_reason->active_traces) {
-		pr_emerg(MODULE_NAME ": unexpected post handler");
+		pr_emerg(NAME "unexpected post handler");
 		BUG();
 	}
 
@@ -284,20 +314,23 @@ static int subbuf_start_handler(struct rchan_buf *buf, void *subbuf,
 	int count;
 	if (relay_buf_full(buf)) {
 		if (atomic_inc_return(drop) == 1)
-			pr_err(MODULE_NAME ": cpu %d buffer full!\n", cpu);
+			pr_err(NAME "cpu %d buffer full!\n", cpu);
 		return 0;
 	}
 	count = atomic_read(drop);
 	if (count) {
-		pr_err(MODULE_NAME ": cpu %d buffer no longer full, "
-						"missed %d events.\n",
-						cpu, count);
+		pr_err(NAME "cpu %d buffer no longer full, missed %d events.\n",
+								cpu, count);
 		atomic_sub(count, drop);
 	}
 
 	return 1;
 }
 
+static struct file_operations mmio_fops = {
+	.owner = THIS_MODULE,
+};
+
 /* file_create() callback.  Creates relay file in debugfs. */
 static struct dentry *create_buf_file_handler(const char *filename,
 						struct dentry *parent,
@@ -333,34 +366,10 @@ static struct rchan_callbacks relay_callbacks = {
 	.remove_buf_file = remove_buf_file_handler,
 };
 
-/*
- * create_channel - creates channel /debug/APP_DIR/cpuXXX
- * Returns channel on success, NULL otherwise
- */
-static struct rchan *create_channel(unsigned size, unsigned n)
-{
-	return relay_open("cpu", dir, size, n, &relay_callbacks, NULL);
-}
-
-/* destroy_channel - destroys channel /debug/APP_DIR/cpuXXX */
-static void destroy_channel(void)
-{
-	if (chan) {
-		relay_close(chan);
-		chan = NULL;
-	}
-}
-
-struct remap_trace {
-	struct list_head list;
-	struct kmmio_probe probe;
-};
-static LIST_HEAD(trace_list);
-static DEFINE_SPINLOCK(trace_list_lock);
-
-static void do_ioremap_trace_core(unsigned long offset, unsigned long size,
+static void ioremap_trace_core(unsigned long offset, unsigned long size,
 							void __iomem *addr)
 {
+	static atomic_t next_id;
 	struct remap_trace *trace = kmalloc(sizeof(*trace), GFP_KERNEL);
 	struct mm_io_header_map event = {
 		.header = {
@@ -380,61 +389,49 @@ static void do_ioremap_trace_core(unsigned long offset, unsigned long size,
 	};
 	record_timestamp(&event.header);
 
+	if (!trace) {
+		pr_err(NAME "kmalloc failed in ioremap\n");
+		return;
+	}
+
 	*trace = (struct remap_trace) {
 		.probe = {
 			.addr = (unsigned long)addr,
 			.len = size,
 			.pre_handler = pre,
 			.post_handler = post,
-		}
+			.user_data = trace
+		},
+		.phys = offset,
+		.id = atomic_inc_return(&next_id)
 	};
 
+	spin_lock_irq(&trace_lock);
+	if (!is_enabled())
+		goto not_enabled;
+
 	relay_write(chan, &event, sizeof(event));
-	spin_lock(&trace_list_lock);
 	list_add_tail(&trace->list, &trace_list);
-	spin_unlock(&trace_list_lock);
 	if (!nommiotrace)
 		register_kmmio_probe(&trace->probe);
+
+not_enabled:
+	spin_unlock_irq(&trace_lock);
 }
 
-static void ioremap_trace_core(unsigned long offset, unsigned long size,
-							void __iomem *addr)
+void
+mmiotrace_ioremap(unsigned long offset, unsigned long size, void __iomem *addr)
 {
-	if ((filter_offset) && (offset != filter_offset))
+	if (!is_enabled()) /* recheck and proper locking in *_core() */
 		return;
 
-	/* Don't trace the low PCI/ISA area, it's always mapped.. */
-	if (!ISA_trace && (offset < ISA_END_ADDRESS) &&
-					(offset + size > ISA_START_ADDRESS)) {
-		pr_notice(MODULE_NAME ": Ignoring map of low PCI/ISA area "
-						"(0x%lx-0x%lx)\n",
-						offset, offset + size);
+	pr_debug(NAME "ioremap_*(0x%lx, 0x%lx) = %p\n", offset, size, addr);
+	if ((filter_offset) && (offset != filter_offset))
 		return;
-	}
-	do_ioremap_trace_core(offset, size, addr);
-}
-
-void __iomem *ioremap_cache_trace(unsigned long offset, unsigned long size)
-{
-	void __iomem *p = ioremap_cache(offset, size);
-	pr_debug(MODULE_NAME ": ioremap_cache(0x%lx, 0x%lx) = %p\n",
-							offset, size, p);
-	ioremap_trace_core(offset, size, p);
-	return p;
+	ioremap_trace_core(offset, size, addr);
 }
-EXPORT_SYMBOL(ioremap_cache_trace);
 
-void __iomem *ioremap_nocache_trace(unsigned long offset, unsigned long size)
-{
-	void __iomem *p = ioremap_nocache(offset, size);
-	pr_debug(MODULE_NAME ": ioremap_nocache(0x%lx, 0x%lx) = %p\n",
-							offset, size, p);
-	ioremap_trace_core(offset, size, p);
-	return p;
-}
-EXPORT_SYMBOL(ioremap_nocache_trace);
-
-void iounmap_trace(volatile void __iomem *addr)
+static void iounmap_trace_core(volatile void __iomem *addr)
 {
 	struct mm_io_header_map event = {
 		.header = {
@@ -454,84 +451,212 @@ void iounmap_trace(volatile void __iomem *addr)
 	};
 	struct remap_trace *trace;
 	struct remap_trace *tmp;
-	pr_debug(MODULE_NAME ": Unmapping %p.\n", addr);
+	struct remap_trace *found_trace = NULL;
+
+	pr_debug(NAME "Unmapping %p.\n", addr);
 	record_timestamp(&event.header);
 
-	spin_lock(&trace_list_lock);
+	spin_lock_irq(&trace_lock);
+	if (!is_enabled())
+		goto not_enabled;
+
 	list_for_each_entry_safe(trace, tmp, &trace_list, list) {
 		if ((unsigned long)addr == trace->probe.addr) {
 			if (!nommiotrace)
 				unregister_kmmio_probe(&trace->probe);
 			list_del(&trace->list);
-			kfree(trace);
+			found_trace = trace;
 			break;
 		}
 	}
-	spin_unlock(&trace_list_lock);
 	relay_write(chan, &event, sizeof(event));
-	iounmap(addr);
+
+not_enabled:
+	spin_unlock_irq(&trace_lock);
+	if (found_trace) {
+		synchronize_rcu(); /* unregister_kmmio_probe() requirement */
+		kfree(found_trace);
+	}
+}
+
+void mmiotrace_iounmap(volatile void __iomem *addr)
+{
+	might_sleep();
+	if (is_enabled()) /* recheck and proper locking in *_core() */
+		iounmap_trace_core(addr);
 }
-EXPORT_SYMBOL(iounmap_trace);
 
 static void clear_trace_list(void)
 {
 	struct remap_trace *trace;
 	struct remap_trace *tmp;
 
-	spin_lock(&trace_list_lock);
-	list_for_each_entry_safe(trace, tmp, &trace_list, list) {
-		pr_warning(MODULE_NAME ": purging non-iounmapped "
+	/*
+	 * No locking required, because the caller ensures we are in a
+	 * critical section via mutex, and is_enabled() is false,
+	 * i.e. nothing can traverse or modify this list.
+	 * Caller also ensures is_enabled() cannot change.
+	 */
+	list_for_each_entry(trace, &trace_list, list) {
+		pr_notice(NAME "purging non-iounmapped "
 					"trace @0x%08lx, size 0x%lx.\n",
 					trace->probe.addr, trace->probe.len);
 		if (!nommiotrace)
 			unregister_kmmio_probe(&trace->probe);
+	}
+	synchronize_rcu(); /* unregister_kmmio_probe() requirement */
+
+	list_for_each_entry_safe(trace, tmp, &trace_list, list) {
 		list_del(&trace->list);
 		kfree(trace);
+	}
+}
+
+static ssize_t read_enabled_file_bool(struct file *file,
+		char __user *user_buf, size_t count, loff_t *ppos)
+{
+	char buf[3];
+
+	if (is_enabled())
+		buf[0] = '1';
+	else
+		buf[0] = '0';
+	buf[1] = '\n';
+	buf[2] = '\0';
+	return simple_read_from_buffer(user_buf, count, ppos, buf, 2);
+}
+
+static void enable_mmiotrace(void);
+static void disable_mmiotrace(void);
+
+static ssize_t write_enabled_file_bool(struct file *file,
+		const char __user *user_buf, size_t count, loff_t *ppos)
+{
+	char buf[32];
+	int buf_size = min(count, (sizeof(buf)-1));
+
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+
+	switch (buf[0]) {
+	case 'y':
+	case 'Y':
+	case '1':
+		enable_mmiotrace();
+		break;
+	case 'n':
+	case 'N':
+	case '0':
+		disable_mmiotrace();
 		break;
 	}
-	spin_unlock(&trace_list_lock);
+
+	return count;
+}
+
+/* this ripped from kernel/kprobes.c */
+static struct file_operations fops_enabled = {
+	.owner =	THIS_MODULE,
+	.read =		read_enabled_file_bool,
+	.write =	write_enabled_file_bool
+};
+
+static struct file_operations fops_marker = {
+	.owner =	THIS_MODULE,
+	.write =	write_marker
+};
+
+static void enable_mmiotrace(void)
+{
+	mutex_lock(&mmiotrace_mutex);
+	if (is_enabled())
+		goto out;
+
+	chan = relay_open("cpu", dir, subbuf_size, n_subbufs,
+						&relay_callbacks, NULL);
+	if (!chan) {
+		pr_err(NAME "relay app channel creation failed.\n");
+		goto out;
+	}
+
+	reference_kmmio();
+
+	marker_file = debugfs_create_file("marker", 0660, dir, NULL,
+								&fops_marker);
+	if (!marker_file)
+		pr_err(NAME "marker file creation failed.\n");
+
+	if (nommiotrace)
+		pr_info(NAME "MMIO tracing disabled.\n");
+	if (ISA_trace)
+		pr_warning(NAME "Warning! low ISA range will be traced.\n");
+	spin_lock_irq(&trace_lock);
+	atomic_inc(&mmiotrace_enabled);
+	spin_unlock_irq(&trace_lock);
+	pr_info(NAME "enabled.\n");
+out:
+	mutex_unlock(&mmiotrace_mutex);
+}
+
+static void disable_mmiotrace(void)
+{
+	mutex_lock(&mmiotrace_mutex);
+	if (!is_enabled())
+		goto out;
+
+	spin_lock_irq(&trace_lock);
+	atomic_dec(&mmiotrace_enabled);
+	BUG_ON(is_enabled());
+	spin_unlock_irq(&trace_lock);
+
+	clear_trace_list(); /* guarantees: no more kmmio callbacks */
+	unreference_kmmio();
+	if (marker_file) {
+		debugfs_remove(marker_file);
+		marker_file = NULL;
+	}
+	if (chan) {
+		relay_close(chan);
+		chan = NULL;
+	}
+
+	pr_info(NAME "disabled.\n");
+out:
+	mutex_unlock(&mmiotrace_mutex);
 }
 
 static int __init init(void)
 {
+	pr_debug(NAME "load...\n");
 	if (n_subbufs < 2)
 		return -EINVAL;
 
 	dir = debugfs_create_dir(APP_DIR, NULL);
 	if (!dir) {
-		pr_err(MODULE_NAME ": Couldn't create relay app directory.\n");
+		pr_err(NAME "Couldn't create relay app directory.\n");
 		return -ENOMEM;
 	}
 
-	chan = create_channel(subbuf_size, n_subbufs);
-	if (!chan) {
+	enabled_file = debugfs_create_file("enabled", 0600, dir, NULL,
+								&fops_enabled);
+	if (!enabled_file) {
+		pr_err(NAME "Couldn't create enabled file.\n");
 		debugfs_remove(dir);
-		pr_err(MODULE_NAME ": relay app channel creation failed\n");
 		return -ENOMEM;
 	}
 
-	reference_kmmio();
-
-	proc_marker_file = create_proc_entry(MARKER_FILE, 0, NULL);
-	if (proc_marker_file)
-		proc_marker_file->write_proc = write_marker;
+	if (enable_now)
+		enable_mmiotrace();
 
-	pr_debug(MODULE_NAME ": loaded.\n");
-	if (nommiotrace)
-		pr_info(MODULE_NAME ": MMIO tracing disabled.\n");
-	if (ISA_trace)
-		pr_warning(MODULE_NAME ": Warning! low ISA range will be "
-								"traced.\n");
 	return 0;
 }
 
 static void __exit cleanup(void)
 {
-	pr_debug(MODULE_NAME ": unload...\n");
-	clear_trace_list();
-	unreference_kmmio();
-	remove_proc_entry(MARKER_FILE, NULL);
-	destroy_channel();
+	pr_debug(NAME "unload...\n");
+	if (enabled_file)
+		debugfs_remove(enabled_file);
+	disable_mmiotrace();
 	if (dir)
 		debugfs_remove(dir);
 }
diff --git a/arch/x86/mm/testmmiotrace.c b/arch/x86/mm/testmmiotrace.c
index 5ecff57..cfa60b2 100644
--- a/arch/x86/mm/testmmiotrace.c
+++ b/arch/x86/mm/testmmiotrace.c
@@ -4,10 +4,6 @@
 #include <linux/module.h>
 #include <asm/io.h>
 
-extern void __iomem *ioremap_nocache_trace(unsigned long offset,
-						unsigned long size);
-extern void iounmap_trace(volatile void __iomem *addr);
-
 #define MODULE_NAME "testmmiotrace"
 
 static unsigned long mmio_address;
@@ -28,25 +24,24 @@ static void do_write_test(void __iomem *p)
 static void do_read_test(void __iomem *p)
 {
 	unsigned int i;
-	volatile unsigned int v;
 	for (i = 0; i < 256; i++)
-		v = ioread8(p + i);
+		ioread8(p + i);
 	for (i = 1024; i < (5 * 1024); i += 2)
-		v = ioread16(p + i);
+		ioread16(p + i);
 	for (i = (5 * 1024); i < (16 * 1024); i += 4)
-		v = ioread32(p + i);
+		ioread32(p + i);
 }
 
 static void do_test(void)
 {
-	void __iomem *p = ioremap_nocache_trace(mmio_address, 0x4000);
+	void __iomem *p = ioremap_nocache(mmio_address, 0x4000);
 	if (!p) {
 		pr_err(MODULE_NAME ": could not ioremap, aborting.\n");
 		return;
 	}
 	do_write_test(p);
 	do_read_test(p);
-	iounmap_trace(p);
+	iounmap(p);
 }
 
 static int __init init(void)
diff --git a/include/linux/mmiotrace.h b/include/linux/mmiotrace.h
index d87a6cd..cb5efd0 100644
--- a/include/linux/mmiotrace.h
+++ b/include/linux/mmiotrace.h
@@ -16,11 +16,12 @@ typedef void (*kmmio_post_handler_t)(struct kmmio_probe *,
 				unsigned long condition, struct pt_regs *);
 
 struct kmmio_probe {
-	struct list_head list;
+	struct list_head list; /* kmmio internal list */
 	unsigned long addr; /* start location of the probe point */
 	unsigned long len; /* length of the probe region */
 	kmmio_pre_handler_t pre_handler; /* Called before addr is executed. */
 	kmmio_post_handler_t post_handler; /* Called after addr is executed */
+	void *user_data;
 };
 
 /* kmmio is active by some kmmio_probes? */
@@ -38,6 +39,21 @@ extern void unregister_kmmio_probe(struct kmmio_probe *p);
 /* Called from page fault handler. */
 extern int kmmio_handler(struct pt_regs *regs, unsigned long addr);
 
+/* Called from ioremap.c */
+#ifdef CONFIG_MMIOTRACE
+extern void
+mmiotrace_ioremap(unsigned long offset, unsigned long size, void __iomem *addr);
+extern void mmiotrace_iounmap(volatile void __iomem *addr);
+#else
+static inline void
+mmiotrace_ioremap(unsigned long offset, unsigned long size, void __iomem *addr)
+{
+}
+static inline void mmiotrace_iounmap(volatile void __iomem *addr)
+{
+}
+#endif /* CONFIG_MMIOTRACE_HOOKS */
+
 #endif /* __KERNEL__ */
 
 
-- 
1.5.3.7

