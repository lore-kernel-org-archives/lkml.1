Return-Path: <linux-kernel-owner+w=401wt.eu-S1752836AbYCIOlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836AbYCIOlW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 10:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751777AbYCIOlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 10:41:06 -0400
Received: from pne-smtpout3-sn1.fre.skanova.net ([81.228.11.120]:49259 "EHLO
	pne-smtpout3-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751708AbYCIOlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 10:41:00 -0400
Date: Sun, 9 Mar 2008 16:40:50 +0200
From: Pekka Paalanen <pq@iki.fi>
To: linux-kernel@vger.kernel.org
Cc: Pekka Paalanen <pq@iki.fi>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>, Pavel Roskin <proski@gnu.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC] mmiotrace full patch, preview 2
Message-ID: <20080309164050.2194461e@daedalus.pq.iki.fi>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I've made some progress on mmiotrace and now it can actually work as a
built-in. Previously mmio-mod.c was full of locking bugs, which never
triggered, because a traced (binary) kernel module depended on the
mmiotrace module.

Changes between preview 1 and preview 2 include:

- Bug and style fixes in Kconfig.debug, Makefile, testmmiotrace.c, mutex
usage, and failure path in register probe function.
- RCU read-lock held over single stepping in kmmio.c
- mmio-mod.c is now a built-in with rewritten locking
- Added debugfs file to enable/disable mmiotracing, since this is not a
module anymore. (Temporary solution)
- Marker file moved from /proc into debugfs.
- mmiotrace entrypoints called directly from ioremap.c, which is why
this cannot be a module anymore.

It still uses relay for pushing data into user space, this would be
replaced by ftrace, along with the "enabled" debugfs file.

The kernel argument mmiotrace.enable_now=1 can be used to enable
mmiotracing at boot. I have tried this and it seems to work well,
I get about 80k events from boot until starting the user space
logger program by hand. Buffers are big enough that no event is
missed due to out-of-memory.

I have also tried tracing Nouveau, started X, and disabled
mmiotracing while in X. Works fine, the logger program just starts
to hog cpu. The logger program will become 'cat' when we get to ftrace.

Hooking or modifying kernel module files is not needed anymore, mmiotrace
will trace everything that is ioremapped after it has been enabled.
Well, everything that __ioremap() actually maps, not including e.g.
ISA area.

The only thing checkpatch.pl complains about is the use of "volatile",
but that is part of the original declaration of iounmap().

The next step would be going for ftrace framework.

This patch is against torvalds/linux-2.6.git master. I will reply to
this email with a patch for Ingo's x86/testing branch.


Signed-off-by: Pekka Paalanen <pq@iki.fi>

---
 arch/x86/Kconfig.debug      |   29 ++
 arch/x86/mm/Makefile        |    5 +
 arch/x86/mm/fault.c         |   13 +
 arch/x86/mm/ioremap.c       |    9 +-
 arch/x86/mm/kmmio.c         |  533 ++++++++++++++++++++++++++++++++++
 arch/x86/mm/mmio-mod.c      |  666 +++++++++++++++++++++++++++++++++++++++++++
 arch/x86/mm/pageattr.c      |    1 +
 arch/x86/mm/pf_in.c         |  489 +++++++++++++++++++++++++++++++
 arch/x86/mm/pf_in.h         |   39 +++
 arch/x86/mm/testmmiotrace.c |   71 +++++
 include/linux/mmiotrace.h   |  120 ++++++++
 11 files changed, 1974 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 702eb39..6ab0ca2 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -134,6 +134,35 @@ config IOMMU_LEAK
 	  Add a simple leak tracer to the IOMMU code. This is useful when you
 	  are debugging a buggy device driver that leaks IOMMU mappings.
 
+config MMIOTRACE_HOOKS
+	bool
+
+config MMIOTRACE
+	bool "Memory mapped IO tracing"
+	depends on DEBUG_KERNEL && RELAY && DEBUG_FS
+	select MMIOTRACE_HOOKS
+	default y
+	help
+	  Mmiotrace traces Memory Mapped I/O access and is meant for
+	  debugging and reverse engineering. It is called from the ioremap
+	  implementation and works via page faults. A user space program is
+	  required to collect the MMIO data from debugfs files.
+	  Tracing is disabled by default and can be enabled from a debugfs
+	  file.
+
+	  See http://nouveau.freedesktop.org/wiki/MmioTrace
+	  If you are not helping to develop drivers, say N.
+
+config MMIOTRACE_TEST
+	tristate "Test module for mmiotrace"
+	depends on MMIOTRACE && m
+	help
+	  This is a dumb module for testing mmiotrace. It is very dangerous
+	  as it will write garbage to IO memory starting at a given address.
+	  However, it should be safe to use on e.g. unused portion of VRAM.
+
+	  Say N, unless you absolutely know what you are doing.
+
 #
 # IO delay types:
 #
diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index 9832910..3423865 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -3,3 +3,8 @@ include ${srctree}/arch/x86/mm/Makefile_32
 else
 include ${srctree}/arch/x86/mm/Makefile_64
 endif
+
+obj-$(CONFIG_MMIOTRACE_HOOKS)	+= kmmio.o
+obj-$(CONFIG_MMIOTRACE) 	+= mmiotrace.o
+mmiotrace-y			:= pf_in.o mmio-mod.o
+obj-$(CONFIG_MMIOTRACE_TEST) 	+= testmmiotrace.o
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index fdc6674..ba6d4c5 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -25,6 +25,7 @@
 #include <linux/kprobes.h>
 #include <linux/uaccess.h>
 #include <linux/kdebug.h>
+#include <linux/mmiotrace.h>
 
 #include <asm/system.h>
 #include <asm/desc.h>
@@ -49,6 +50,16 @@
 #define PF_RSVD		(1<<3)
 #define PF_INSTR	(1<<4)
 
+static inline int kmmio_fault(struct pt_regs *regs, unsigned long addr)
+{
+#ifdef CONFIG_MMIOTRACE_HOOKS
+	if (unlikely(is_kmmio_active()))
+		if (kmmio_handler(regs, addr) == 1)
+			return -1;
+#endif
+	return 0;
+}
+
 static inline int notify_page_fault(struct pt_regs *regs)
 {
 #ifdef CONFIG_KPROBES
@@ -603,6 +614,8 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
 
 	if (notify_page_fault(regs))
 		return;
+	if (unlikely(kmmio_fault(regs, address)))
+		return;
 
 	/*
 	 * We fault-in kernel-space virtual memory on-demand. The
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index ac3c959..bfaa51f 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -12,6 +12,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
+#include <linux/mmiotrace.h>
 
 #include <asm/cacheflush.h>
 #include <asm/e820.h>
@@ -112,6 +113,7 @@ static void __iomem *__ioremap(unsigned long phys_addr, unsigned long size,
 	unsigned long pfn, offset, last_addr, vaddr;
 	struct vm_struct *area;
 	pgprot_t prot;
+	void __iomem *ret_addr;
 
 	/* Don't allow wraparound or zero size */
 	last_addr = phys_addr + size - 1;
@@ -171,7 +173,10 @@ static void __iomem *__ioremap(unsigned long phys_addr, unsigned long size,
 		return NULL;
 	}
 
-	return (void __iomem *) (vaddr + offset);
+	ret_addr = (void __iomem *) (vaddr + offset);
+	mmiotrace_ioremap(phys_addr, size, ret_addr);
+
+	return ret_addr;
 }
 
 /**
@@ -229,6 +234,8 @@ void iounmap(volatile void __iomem *addr)
 	    addr < phys_to_virt(ISA_END_ADDRESS))
 		return;
 
+	mmiotrace_iounmap(addr);
+
 	addr = (volatile void __iomem *)
 		(PAGE_MASK & (unsigned long __force)addr);
 
diff --git a/arch/x86/mm/kmmio.c b/arch/x86/mm/kmmio.c
new file mode 100644
index 0000000..efb4679
--- /dev/null
+++ b/arch/x86/mm/kmmio.c
@@ -0,0 +1,533 @@
+/* Support for MMIO probes.
+ * Benfit many code from kprobes
+ * (C) 2002 Louis Zhuang <louis.zhuang@intel.com>.
+ *     2007 Alexander Eichner
+ *     2008 Pekka Paalanen <pq@iki.fi>
+ */
+
+#include <linux/version.h>
+#include <linux/list.h>
+#include <linux/spinlock.h>
+#include <linux/hash.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/uaccess.h>
+#include <linux/ptrace.h>
+#include <linux/preempt.h>
+#include <linux/percpu.h>
+#include <linux/kdebug.h>
+#include <linux/mutex.h>
+#include <asm/io.h>
+#include <asm/cacheflush.h>
+#include <asm/errno.h>
+#include <asm/tlbflush.h>
+#include <asm/pgtable.h>
+
+#include <linux/mmiotrace.h>
+
+#define KMMIO_PAGE_HASH_BITS 4
+#define KMMIO_PAGE_TABLE_SIZE (1 << KMMIO_PAGE_HASH_BITS)
+
+struct kmmio_fault_page {
+	struct list_head list;
+	struct kmmio_fault_page *release_next;
+	unsigned long page; /* location of the fault page */
+
+	/*
+	 * Number of times this page has been registered as a part
+	 * of a probe. If zero, page is disarmed and this may be freed.
+	 * Used only by writers (RCU).
+	 */
+	int count;
+};
+
+struct kmmio_delayed_release {
+	struct rcu_head rcu;
+	struct kmmio_fault_page *release_list;
+};
+
+struct kmmio_context {
+	struct kmmio_fault_page *fpage;
+	struct kmmio_probe *probe;
+	unsigned long saved_flags;
+	unsigned long addr;
+	int active;
+};
+
+static int kmmio_die_notifier(struct notifier_block *nb, unsigned long val,
+								void *args);
+
+static DEFINE_MUTEX(kmmio_init_mutex);
+static DEFINE_SPINLOCK(kmmio_lock);
+
+/* These are protected by kmmio_lock */
+static int kmmio_initialized;
+unsigned int kmmio_count;
+
+/* Read-protected by RCU, write-protected by kmmio_lock. */
+static struct list_head kmmio_page_table[KMMIO_PAGE_TABLE_SIZE];
+static LIST_HEAD(kmmio_probes);
+
+static struct list_head *kmmio_page_list(unsigned long page)
+{
+	return &kmmio_page_table[hash_long(page, KMMIO_PAGE_HASH_BITS)];
+}
+
+/* Accessed per-cpu */
+static DEFINE_PER_CPU(struct kmmio_context, kmmio_ctx);
+
+/* protected by kmmio_init_mutex */
+static struct notifier_block nb_die = {
+	.notifier_call = kmmio_die_notifier
+};
+
+/**
+ * Makes sure kmmio is initialized and usable.
+ * This must be called before any other kmmio function defined here.
+ * May sleep.
+ */
+void reference_kmmio(void)
+{
+	mutex_lock(&kmmio_init_mutex);
+	spin_lock_irq(&kmmio_lock);
+	if (!kmmio_initialized) {
+		int i;
+		for (i = 0; i < KMMIO_PAGE_TABLE_SIZE; i++)
+			INIT_LIST_HEAD(&kmmio_page_table[i]);
+		if (register_die_notifier(&nb_die))
+			BUG();
+	}
+	kmmio_initialized++;
+	spin_unlock_irq(&kmmio_lock);
+	mutex_unlock(&kmmio_init_mutex);
+}
+EXPORT_SYMBOL_GPL(reference_kmmio);
+
+/**
+ * Clean up kmmio after use. This must be called for every call to
+ * reference_kmmio(). All probes registered after the corresponding
+ * reference_kmmio() must have been unregistered when calling this.
+ * May sleep.
+ */
+void unreference_kmmio(void)
+{
+	bool unreg = false;
+
+	mutex_lock(&kmmio_init_mutex);
+	spin_lock_irq(&kmmio_lock);
+
+	if (kmmio_initialized == 1) {
+		BUG_ON(is_kmmio_active());
+		unreg = true;
+	}
+	kmmio_initialized--;
+	BUG_ON(kmmio_initialized < 0);
+	spin_unlock_irq(&kmmio_lock);
+
+	if (unreg)
+		unregister_die_notifier(&nb_die); /* calls sync_rcu() */
+	mutex_unlock(&kmmio_init_mutex);
+}
+EXPORT_SYMBOL(unreference_kmmio);
+
+/*
+ * this is basically a dynamic stabbing problem:
+ * Could use the existing prio tree code or
+ * Possible better implementations:
+ * The Interval Skip List: A Data Structure for Finding All Intervals That
+ * Overlap a Point (might be simple)
+ * Space Efficient Dynamic Stabbing with Fast Queries - Mikkel Thorup
+ */
+/* Get the kmmio at this addr (if any). You must be holding RCU read lock. */
+static struct kmmio_probe *get_kmmio_probe(unsigned long addr)
+{
+	struct kmmio_probe *p;
+	list_for_each_entry_rcu(p, &kmmio_probes, list) {
+		if (addr >= p->addr && addr <= (p->addr + p->len))
+			return p;
+	}
+	return NULL;
+}
+
+/* You must be holding RCU read lock. */
+static struct kmmio_fault_page *get_kmmio_fault_page(unsigned long page)
+{
+	struct list_head *head;
+	struct kmmio_fault_page *p;
+
+	page &= PAGE_MASK;
+	head = kmmio_page_list(page);
+	list_for_each_entry_rcu(p, head, list) {
+		if (p->page == page)
+			return p;
+	}
+	return NULL;
+}
+
+/** Mark the given page as not present. Access to it will trigger a fault. */
+static void arm_kmmio_fault_page(unsigned long page, int *page_level)
+{
+	unsigned long address = page & PAGE_MASK;
+	int level;
+	pte_t *pte = lookup_address(address, &level);
+
+	if (!pte) {
+		pr_err("kmmio: Error in %s: no pte for page 0x%08lx\n",
+							__func__, page);
+		return;
+	}
+
+	if (level == PG_LEVEL_2M) {
+		pmd_t *pmd = (pmd_t *)pte;
+		set_pmd(pmd, __pmd(pmd_val(*pmd) & ~_PAGE_PRESENT));
+	} else {
+		/* PG_LEVEL_4K */
+		set_pte(pte, __pte(pte_val(*pte) & ~_PAGE_PRESENT));
+	}
+
+	if (page_level)
+		*page_level = level;
+
+	__flush_tlb_one(page);
+}
+
+/** Mark the given page as present. */
+static void disarm_kmmio_fault_page(unsigned long page, int *page_level)
+{
+	unsigned long address = page & PAGE_MASK;
+	int level;
+	pte_t *pte = lookup_address(address, &level);
+
+	if (!pte) {
+		pr_err("kmmio: Error in %s: no pte for page 0x%08lx\n",
+							__func__, page);
+		return;
+	}
+
+	if (level == PG_LEVEL_2M) {
+		pmd_t *pmd = (pmd_t *)pte;
+		set_pmd(pmd, __pmd(pmd_val(*pmd) | _PAGE_PRESENT));
+	} else {
+		/* PG_LEVEL_4K */
+		set_pte(pte, __pte(pte_val(*pte) | _PAGE_PRESENT));
+	}
+
+	if (page_level)
+		*page_level = level;
+
+	__flush_tlb_one(page);
+}
+
+/*
+ * This is being called from do_page_fault().
+ *
+ * We may be in an interrupt or a critical section. Also prefecthing may
+ * trigger a page fault. We may be in the middle of process switch.
+ * We cannot take any locks, because we could be executing especially
+ * within a kmmio critical section.
+ *
+ * Local interrupts are disabled, so preemption cannot happen.
+ * Do not enable interrupts, do not sleep, and watch out for other CPUs.
+ */
+/*
+ * Interrupts are disabled on entry as trap3 is an interrupt gate
+ * and they remain disabled thorough out this function.
+ */
+int kmmio_handler(struct pt_regs *regs, unsigned long addr)
+{
+	struct kmmio_context *ctx;
+	struct kmmio_fault_page *faultpage;
+
+	/*
+	 * Preemption is now disabled to prevent process switch during
+	 * single stepping. We can only handle one active kmmio trace
+	 * per cpu, so ensure that we finish it before something else
+	 * gets to run. We also hold the RCU read lock over single
+	 * stepping to avoid looking up the probe and kmmio_fault_page
+	 * again.
+	 */
+	preempt_disable();
+	rcu_read_lock();
+
+	faultpage = get_kmmio_fault_page(addr);
+	if (!faultpage) {
+		/*
+		 * Either this page fault is not caused by kmmio, or
+		 * another CPU just pulled the kmmio probe from under
+		 * our feet. In the latter case all hell breaks loose.
+		 */
+		goto no_kmmio;
+	}
+
+	ctx = &get_cpu_var(kmmio_ctx);
+	if (ctx->active) {
+		/*
+		 * Prevent overwriting already in-flight context.
+		 * If this page fault really was due to kmmio trap,
+		 * all hell breaks loose.
+		 */
+		pr_emerg("kmmio: recursive probe hit on CPU %d, "
+					"for address 0x%08lx. Ignoring.\n",
+					smp_processor_id(), addr);
+		goto no_kmmio_ctx;
+	}
+	ctx->active++;
+
+	ctx->fpage = faultpage;
+	ctx->probe = get_kmmio_probe(addr);
+	ctx->saved_flags = (regs->flags & (TF_MASK|IF_MASK));
+	ctx->addr = addr;
+
+	if (ctx->probe && ctx->probe->pre_handler)
+		ctx->probe->pre_handler(ctx->probe, regs, addr);
+
+	/*
+	 * Enable single-stepping and disable interrupts for the faulting
+	 * context. Local interrupts must not get enabled during stepping.
+	 */
+	regs->flags |= TF_MASK;
+	regs->flags &= ~IF_MASK;
+
+	/* Now we set present bit in PTE and single step. */
+	disarm_kmmio_fault_page(ctx->fpage->page, NULL);
+
+	/*
+	 * If another cpu accesses the same page while we are stepping,
+	 * the access will not be caught. It will simply succeed and the
+	 * only downside is we lose the event. If this becomes a problem,
+	 * the user should drop to single cpu before tracing.
+	 */
+
+	put_cpu_var(kmmio_ctx);
+	return 1;
+
+no_kmmio_ctx:
+	put_cpu_var(kmmio_ctx);
+no_kmmio:
+	rcu_read_unlock();
+	preempt_enable_no_resched();
+	return 0; /* page fault not handled by kmmio */
+}
+
+/*
+ * Interrupts are disabled on entry as trap1 is an interrupt gate
+ * and they remain disabled thorough out this function.
+ * This must always get called as the pair to kmmio_handler().
+ */
+static int post_kmmio_handler(unsigned long condition, struct pt_regs *regs)
+{
+	int ret = 0;
+	struct kmmio_context *ctx = &get_cpu_var(kmmio_ctx);
+
+	if (!ctx->active)
+		goto out;
+
+	if (ctx->probe && ctx->probe->post_handler)
+		ctx->probe->post_handler(ctx->probe, condition, regs);
+
+	arm_kmmio_fault_page(ctx->fpage->page, NULL);
+
+	regs->flags &= ~TF_MASK;
+	regs->flags |= ctx->saved_flags;
+
+	/* These were acquired in kmmio_handler(). */
+	ctx->active--;
+	BUG_ON(ctx->active);
+	rcu_read_unlock();
+	preempt_enable_no_resched();
+
+	/*
+	 * if somebody else is singlestepping across a probe point, flags
+	 * will have TF set, in which case, continue the remaining processing
+	 * of do_debug, as if this is not a probe hit.
+	 */
+	if (!(regs->flags & TF_MASK))
+		ret = 1;
+out:
+	put_cpu_var(kmmio_ctx);
+	return ret;
+}
+
+/* You must be holding kmmio_lock. */
+static int add_kmmio_fault_page(unsigned long page)
+{
+	struct kmmio_fault_page *f;
+
+	page &= PAGE_MASK;
+	f = get_kmmio_fault_page(page);
+	if (f) {
+		if (!f->count)
+			arm_kmmio_fault_page(f->page, NULL);
+		f->count++;
+		return 0;
+	}
+
+	f = kmalloc(sizeof(*f), GFP_ATOMIC);
+	if (!f)
+		return -1;
+
+	f->count = 1;
+	f->page = page;
+	list_add_rcu(&f->list, kmmio_page_list(f->page));
+
+	arm_kmmio_fault_page(f->page, NULL);
+
+	return 0;
+}
+
+/* You must be holding kmmio_lock. */
+static void release_kmmio_fault_page(unsigned long page,
+				struct kmmio_fault_page **release_list)
+{
+	struct kmmio_fault_page *f;
+
+	page &= PAGE_MASK;
+	f = get_kmmio_fault_page(page);
+	if (!f)
+		return;
+
+	f->count--;
+	BUG_ON(f->count < 0);
+	if (!f->count) {
+		disarm_kmmio_fault_page(f->page, NULL);
+		f->release_next = *release_list;
+		*release_list = f;
+	}
+}
+
+int register_kmmio_probe(struct kmmio_probe *p)
+{
+	unsigned long flags;
+	int ret = 0;
+	unsigned long size = 0;
+
+	spin_lock_irqsave(&kmmio_lock, flags);
+	if (get_kmmio_probe(p->addr)) {
+		ret = -EEXIST;
+		goto out;
+	}
+	kmmio_count++;
+	list_add_rcu(&p->list, &kmmio_probes);
+	while (size < p->len) {
+		if (add_kmmio_fault_page(p->addr + size))
+			pr_err("kmmio: Unable to set page fault.\n");
+		size += PAGE_SIZE;
+	}
+out:
+	spin_unlock_irqrestore(&kmmio_lock, flags);
+	/*
+	 * XXX: What should I do here?
+	 * Here was a call to global_flush_tlb(), but it does not exist
+	 * anymore. It seems it's not needed after all.
+	 */
+	return ret;
+}
+EXPORT_SYMBOL(register_kmmio_probe);
+
+static void rcu_free_kmmio_fault_pages(struct rcu_head *head)
+{
+	struct kmmio_delayed_release *dr = container_of(
+						head,
+						struct kmmio_delayed_release,
+						rcu);
+	struct kmmio_fault_page *p = dr->release_list;
+	while (p) {
+		struct kmmio_fault_page *next = p->release_next;
+		BUG_ON(p->count);
+		kfree(p);
+		p = next;
+	}
+	kfree(dr);
+}
+
+static void remove_kmmio_fault_pages(struct rcu_head *head)
+{
+	struct kmmio_delayed_release *dr = container_of(
+						head,
+						struct kmmio_delayed_release,
+						rcu);
+	struct kmmio_fault_page *p = dr->release_list;
+	struct kmmio_fault_page **prevp = &dr->release_list;
+	unsigned long flags;
+	spin_lock_irqsave(&kmmio_lock, flags);
+	while (p) {
+		if (!p->count)
+			list_del_rcu(&p->list);
+		else
+			*prevp = p->release_next;
+		prevp = &p->release_next;
+		p = p->release_next;
+	}
+	spin_unlock_irqrestore(&kmmio_lock, flags);
+	/* This is the real RCU destroy call. */
+	call_rcu(&dr->rcu, rcu_free_kmmio_fault_pages);
+}
+
+/*
+ * Remove a kmmio probe. You have to synchronize_rcu() before you can be
+ * sure that the callbacks will not be called anymore. Only after that
+ * you may actually release your struct kmmio_probe.
+ *
+ * Unregistering a kmmio fault page has three steps:
+ * 1. release_kmmio_fault_page()
+ *    Disarm the page, wait a grace period to let all faults finish.
+ * 2. remove_kmmio_fault_pages()
+ *    Remove the pages from kmmio_page_table.
+ * 3. rcu_free_kmmio_fault_pages()
+ *    Actally free the kmmio_fault_page structs as with RCU.
+ */
+void unregister_kmmio_probe(struct kmmio_probe *p)
+{
+	unsigned long flags;
+	unsigned long size = 0;
+	struct kmmio_fault_page *release_list = NULL;
+	struct kmmio_delayed_release *drelease;
+
+	spin_lock_irqsave(&kmmio_lock, flags);
+	while (size < p->len) {
+		release_kmmio_fault_page(p->addr + size, &release_list);
+		size += PAGE_SIZE;
+	}
+	list_del_rcu(&p->list);
+	kmmio_count--;
+	spin_unlock_irqrestore(&kmmio_lock, flags);
+
+	drelease = kmalloc(sizeof(*drelease), GFP_ATOMIC);
+	if (!drelease) {
+		pr_crit("kmmio: leaking kmmio_fault_page objects.\n");
+		return;
+	}
+	drelease->release_list = release_list;
+
+	/*
+	 * This is not really RCU here. We have just disarmed a set of
+	 * pages so that they cannot trigger page faults anymore. However,
+	 * we cannot remove the pages from kmmio_page_table,
+	 * because a probe hit might be in flight on another CPU. The
+	 * pages are collected into a list, and they will be removed from
+	 * kmmio_page_table when it is certain that no probe hit related to
+	 * these pages can be in flight. RCU grace period sounds like a
+	 * good choice.
+	 *
+	 * If we removed the pages too early, kmmio page fault handler might
+	 * not find the respective kmmio_fault_page and determine it's not
+	 * a kmmio fault, when it actually is. This would lead to madness.
+	 */
+	call_rcu(&drelease->rcu, remove_kmmio_fault_pages);
+}
+EXPORT_SYMBOL(unregister_kmmio_probe);
+
+static int kmmio_die_notifier(struct notifier_block *nb, unsigned long val,
+								void *args)
+{
+	struct die_args *arg = args;
+
+	if (val == DIE_DEBUG)
+		if (post_kmmio_handler(arg->err, arg->regs) == 1)
+			return NOTIFY_STOP;
+
+	return NOTIFY_DONE;
+}
diff --git a/arch/x86/mm/mmio-mod.c b/arch/x86/mm/mmio-mod.c
new file mode 100644
index 0000000..7386440
--- /dev/null
+++ b/arch/x86/mm/mmio-mod.c
@@ -0,0 +1,666 @@
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright (C) IBM Corporation, 2005
+ *               Jeff Muizelaar, 2006, 2007
+ *               Pekka Paalanen, 2008 <pq@iki.fi>
+ *
+ * Derived from the read-mod example from relay-examples by Tom Zanussi.
+ */
+#define DEBUG 1
+
+#include <linux/module.h>
+#include <linux/relay.h>
+#include <linux/debugfs.h>
+#include <linux/proc_fs.h>
+#include <asm/io.h>
+#include <linux/version.h>
+#include <linux/kallsyms.h>
+#include <asm/pgtable.h>
+#include <linux/mmiotrace.h>
+#include <asm/e820.h> /* for ISA_START_ADDRESS */
+#include <asm/atomic.h>
+#include <linux/percpu.h>
+
+#include "pf_in.h"
+
+#define NAME "mmiotrace: "
+
+/* This app's relay channel files will appear in /debug/mmio-trace */
+static const char APP_DIR[] = "mmio-trace";
+/* the marker injection file in /debug/APP_DIR */
+static const char MARKER_FILE[] = "mmio-marker";
+
+struct trap_reason {
+	unsigned long addr;
+	unsigned long ip;
+	enum reason_type type;
+	int active_traces;
+};
+
+struct remap_trace {
+	struct list_head list;
+	struct kmmio_probe probe;
+	unsigned long phys;
+	unsigned long id;
+};
+
+static const size_t subbuf_size = 256*1024;
+
+/* Accessed per-cpu. */
+static DEFINE_PER_CPU(struct trap_reason, pf_reason);
+static DEFINE_PER_CPU(struct mm_io_header_rw, cpu_trace);
+
+/* Access to this is not per-cpu. */
+static DEFINE_PER_CPU(atomic_t, dropped);
+
+static struct dentry *dir;
+static struct dentry *enabled_file;
+static struct dentry *marker_file;
+
+static DEFINE_MUTEX(mmiotrace_mutex);
+static DEFINE_SPINLOCK(trace_lock);
+static atomic_t mmiotrace_enabled;
+static LIST_HEAD(trace_list);		/* struct remap_trace */
+static struct rchan *chan;
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
+
+/* module parameters */
+static unsigned int	n_subbufs = 32*4;
+static unsigned long	filter_offset;
+static int		nommiotrace;
+static int		ISA_trace;
+static int		trace_pc;
+static int		enable_now;
+
+module_param(n_subbufs, uint, 0);
+module_param(filter_offset, ulong, 0);
+module_param(nommiotrace, bool, 0);
+module_param(ISA_trace, bool, 0);
+module_param(trace_pc, bool, 0);
+module_param(enable_now, bool, 0);
+
+MODULE_PARM_DESC(n_subbufs, "Number of 256kB buffers, default 128.");
+MODULE_PARM_DESC(filter_offset, "Start address of traced mappings.");
+MODULE_PARM_DESC(nommiotrace, "Disable actual MMIO tracing.");
+MODULE_PARM_DESC(ISA_trace, "Do not exclude the low ISA range.");
+MODULE_PARM_DESC(trace_pc, "Record address of faulting instructions.");
+MODULE_PARM_DESC(enable_now, "Start mmiotracing immediately on module load.");
+
+static bool is_enabled(void)
+{
+	return atomic_read(&mmiotrace_enabled);
+}
+
+static void record_timestamp(struct mm_io_header *header)
+{
+	struct timespec now;
+
+	getnstimeofday(&now);
+	header->sec = now.tv_sec;
+	header->nsec = now.tv_nsec;
+}
+
+/*
+ * Write callback for the debugfs entry:
+ * Read a marker and write it to the mmio trace log
+ */
+static ssize_t write_marker(struct file *file, const char __user *buffer,
+						size_t count, loff_t *ppos)
+{
+	char *event = NULL;
+	struct mm_io_header *headp;
+	ssize_t len = (count > 65535) ? 65535 : count;
+
+	event = kzalloc(sizeof(*headp) + len, GFP_KERNEL);
+	if (!event)
+		return -ENOMEM;
+
+	headp = (struct mm_io_header *)event;
+	headp->type = MMIO_MAGIC | (MMIO_MARKER << MMIO_OPCODE_SHIFT);
+	headp->data_len = len;
+	record_timestamp(headp);
+
+	if (copy_from_user(event + sizeof(*headp), buffer, len)) {
+		kfree(event);
+		return -EFAULT;
+	}
+
+	spin_lock_irq(&trace_lock);
+	if (is_enabled())
+		relay_write(chan, event, sizeof(*headp) + len);
+	else
+		len = -EINVAL;
+	spin_unlock_irq(&trace_lock);
+	kfree(event);
+	return len;
+}
+
+static void print_pte(unsigned long address)
+{
+	int level;
+	pte_t *pte = lookup_address(address, &level);
+
+	if (!pte) {
+		pr_err(NAME "Error in %s: no pte for page 0x%08lx\n",
+							__func__, address);
+		return;
+	}
+
+	if (level == PG_LEVEL_2M) {
+		pr_emerg(NAME "4MB pages are not currently supported: "
+							"0x%08lx\n", address);
+		BUG();
+	}
+	pr_info(NAME "pte for 0x%lx: 0x%lx 0x%lx\n", address, pte_val(*pte),
+						pte_val(*pte) & _PAGE_PRESENT);
+}
+
+/*
+ * For some reason the pre/post pairs have been called in an
+ * unmatched order. Report and die.
+ */
+static void die_kmmio_nesting_error(struct pt_regs *regs, unsigned long addr)
+{
+	const struct trap_reason *my_reason = &get_cpu_var(pf_reason);
+	pr_emerg(NAME "unexpected fault for address: 0x%08lx, "
+					"last fault for address: 0x%08lx\n",
+					addr, my_reason->addr);
+	print_pte(addr);
+	print_symbol(KERN_EMERG "faulting IP is at %s\n", regs->ip);
+	print_symbol(KERN_EMERG "last faulting IP was at %s\n", my_reason->ip);
+#ifdef __i386__
+	pr_emerg("eax: %08lx   ebx: %08lx   ecx: %08lx   edx: %08lx\n",
+			regs->ax, regs->bx, regs->cx, regs->dx);
+	pr_emerg("esi: %08lx   edi: %08lx   ebp: %08lx   esp: %08lx\n",
+			regs->si, regs->di, regs->bp, regs->sp);
+#else
+	pr_emerg("rax: %016lx   rcx: %016lx   rdx: %016lx\n",
+					regs->ax, regs->cx, regs->dx);
+	pr_emerg("rsi: %016lx   rdi: %016lx   rbp: %016lx   rsp: %016lx\n",
+				regs->si, regs->di, regs->bp, regs->sp);
+#endif
+	put_cpu_var(pf_reason);
+	BUG();
+}
+
+static void pre(struct kmmio_probe *p, struct pt_regs *regs,
+						unsigned long addr)
+{
+	struct trap_reason *my_reason = &get_cpu_var(pf_reason);
+	struct mm_io_header_rw *my_trace = &get_cpu_var(cpu_trace);
+	const unsigned long instptr = instruction_pointer(regs);
+	const enum reason_type type = get_ins_type(instptr);
+
+	/* it doesn't make sense to have more than one active trace per cpu */
+	if (my_reason->active_traces)
+		die_kmmio_nesting_error(regs, addr);
+	else
+		my_reason->active_traces++;
+
+	my_reason->type = type;
+	my_reason->addr = addr;
+	my_reason->ip = instptr;
+
+	my_trace->header.type = MMIO_MAGIC;
+	my_trace->header.pid = 0;
+	my_trace->header.data_len = sizeof(struct mm_io_rw);
+	my_trace->rw.address = addr;
+	/*
+	 * struct remap_trace *trace = p->user_data;
+	 * phys = addr - trace->probe.addr + trace->phys;
+	 */
+
+	/*
+	 * Only record the program counter when requested.
+	 * It may taint clean-room reverse engineering.
+	 */
+	if (trace_pc)
+		my_trace->rw.pc = instptr;
+	else
+		my_trace->rw.pc = 0;
+
+	record_timestamp(&my_trace->header);
+
+	switch (type) {
+	case REG_READ:
+		my_trace->header.type |=
+			(MMIO_READ << MMIO_OPCODE_SHIFT) |
+			(get_ins_mem_width(instptr) << MMIO_WIDTH_SHIFT);
+		break;
+	case REG_WRITE:
+		my_trace->header.type |=
+			(MMIO_WRITE << MMIO_OPCODE_SHIFT) |
+			(get_ins_mem_width(instptr) << MMIO_WIDTH_SHIFT);
+		my_trace->rw.value = get_ins_reg_val(instptr, regs);
+		break;
+	case IMM_WRITE:
+		my_trace->header.type |=
+			(MMIO_WRITE << MMIO_OPCODE_SHIFT) |
+			(get_ins_mem_width(instptr) << MMIO_WIDTH_SHIFT);
+		my_trace->rw.value = get_ins_imm_val(instptr);
+		break;
+	default:
+		{
+			unsigned char *ip = (unsigned char *)instptr;
+			my_trace->header.type |=
+					(MMIO_UNKNOWN_OP << MMIO_OPCODE_SHIFT);
+			my_trace->rw.value = (*ip) << 16 | *(ip + 1) << 8 |
+								*(ip + 2);
+		}
+	}
+	put_cpu_var(cpu_trace);
+	put_cpu_var(pf_reason);
+}
+
+static void post(struct kmmio_probe *p, unsigned long condition,
+							struct pt_regs *regs)
+{
+	struct trap_reason *my_reason = &get_cpu_var(pf_reason);
+	struct mm_io_header_rw *my_trace = &get_cpu_var(cpu_trace);
+
+	/* this should always return the active_trace count to 0 */
+	my_reason->active_traces--;
+	if (my_reason->active_traces) {
+		pr_emerg(NAME "unexpected post handler");
+		BUG();
+	}
+
+	switch (my_reason->type) {
+	case REG_READ:
+		my_trace->rw.value = get_ins_reg_val(my_reason->ip, regs);
+		break;
+	default:
+		break;
+	}
+	relay_write(chan, my_trace, sizeof(*my_trace));
+	put_cpu_var(cpu_trace);
+	put_cpu_var(pf_reason);
+}
+
+/*
+ * subbuf_start() relay callback.
+ *
+ * Defined so that we know when events are dropped due to the buffer-full
+ * condition.
+ */
+static int subbuf_start_handler(struct rchan_buf *buf, void *subbuf,
+					void *prev_subbuf, size_t prev_padding)
+{
+	unsigned int cpu = buf->cpu;
+	atomic_t *drop = &per_cpu(dropped, cpu);
+	int count;
+	if (relay_buf_full(buf)) {
+		if (atomic_inc_return(drop) == 1)
+			pr_err(NAME "cpu %d buffer full!\n", cpu);
+		return 0;
+	}
+	count = atomic_read(drop);
+	if (count) {
+		pr_err(NAME "cpu %d buffer no longer full, missed %d events.\n",
+								cpu, count);
+		atomic_sub(count, drop);
+	}
+
+	return 1;
+}
+
+static struct file_operations mmio_fops = {
+	.owner = THIS_MODULE,
+};
+
+/* file_create() callback.  Creates relay file in debugfs. */
+static struct dentry *create_buf_file_handler(const char *filename,
+						struct dentry *parent,
+						int mode,
+						struct rchan_buf *buf,
+						int *is_global)
+{
+	struct dentry *buf_file;
+
+	mmio_fops.read = relay_file_operations.read;
+	mmio_fops.open = relay_file_operations.open;
+	mmio_fops.poll = relay_file_operations.poll;
+	mmio_fops.mmap = relay_file_operations.mmap;
+	mmio_fops.release = relay_file_operations.release;
+	mmio_fops.splice_read = relay_file_operations.splice_read;
+
+	buf_file = debugfs_create_file(filename, mode, parent, buf,
+								&mmio_fops);
+
+	return buf_file;
+}
+
+/* file_remove() default callback.  Removes relay file in debugfs. */
+static int remove_buf_file_handler(struct dentry *dentry)
+{
+	debugfs_remove(dentry);
+	return 0;
+}
+
+static struct rchan_callbacks relay_callbacks = {
+	.subbuf_start = subbuf_start_handler,
+	.create_buf_file = create_buf_file_handler,
+	.remove_buf_file = remove_buf_file_handler,
+};
+
+static void ioremap_trace_core(unsigned long offset, unsigned long size,
+							void __iomem *addr)
+{
+	static atomic_t next_id;
+	struct remap_trace *trace = kmalloc(sizeof(*trace), GFP_KERNEL);
+	struct mm_io_header_map event = {
+		.header = {
+			.type = MMIO_MAGIC |
+					(MMIO_PROBE << MMIO_OPCODE_SHIFT),
+			.sec = 0,
+			.nsec = 0,
+			.pid = 0,
+			.data_len = sizeof(struct mm_io_map)
+		},
+		.map = {
+			.phys = offset,
+			.addr = (unsigned long)addr,
+			.len  = size,
+			.pc   = 0
+		}
+	};
+	record_timestamp(&event.header);
+
+	if (!trace) {
+		pr_err(NAME "kmalloc failed in ioremap\n");
+		return;
+	}
+
+	*trace = (struct remap_trace) {
+		.probe = {
+			.addr = (unsigned long)addr,
+			.len = size,
+			.pre_handler = pre,
+			.post_handler = post,
+			.user_data = trace
+		},
+		.phys = offset,
+		.id = atomic_inc_return(&next_id)
+	};
+
+	spin_lock_irq(&trace_lock);
+	if (!is_enabled())
+		goto not_enabled;
+
+	relay_write(chan, &event, sizeof(event));
+	list_add_tail(&trace->list, &trace_list);
+	if (!nommiotrace)
+		register_kmmio_probe(&trace->probe);
+
+not_enabled:
+	spin_unlock_irq(&trace_lock);
+}
+
+void
+mmiotrace_ioremap(unsigned long offset, unsigned long size, void __iomem *addr)
+{
+	if (!is_enabled()) /* recheck and proper locking in *_core() */
+		return;
+
+	pr_debug(NAME "ioremap_*(0x%lx, 0x%lx) = %p\n", offset, size, addr);
+	if ((filter_offset) && (offset != filter_offset))
+		return;
+	ioremap_trace_core(offset, size, addr);
+}
+
+static void iounmap_trace_core(volatile void __iomem *addr)
+{
+	struct mm_io_header_map event = {
+		.header = {
+			.type = MMIO_MAGIC |
+				(MMIO_UNPROBE << MMIO_OPCODE_SHIFT),
+			.sec = 0,
+			.nsec = 0,
+			.pid = 0,
+			.data_len = sizeof(struct mm_io_map)
+		},
+		.map = {
+			.phys = 0,
+			.addr = (unsigned long)addr,
+			.len  = 0,
+			.pc   = 0
+		}
+	};
+	struct remap_trace *trace;
+	struct remap_trace *tmp;
+	struct remap_trace *found_trace = NULL;
+
+	pr_debug(NAME "Unmapping %p.\n", addr);
+	record_timestamp(&event.header);
+
+	spin_lock_irq(&trace_lock);
+	if (!is_enabled())
+		goto not_enabled;
+
+	list_for_each_entry_safe(trace, tmp, &trace_list, list) {
+		if ((unsigned long)addr == trace->probe.addr) {
+			if (!nommiotrace)
+				unregister_kmmio_probe(&trace->probe);
+			list_del(&trace->list);
+			found_trace = trace;
+			break;
+		}
+	}
+	relay_write(chan, &event, sizeof(event));
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
+}
+
+static void clear_trace_list(void)
+{
+	struct remap_trace *trace;
+	struct remap_trace *tmp;
+
+	/*
+	 * No locking required, because the caller ensures we are in a
+	 * critical section via mutex, and is_enabled() is false,
+	 * i.e. nothing can traverse or modify this list.
+	 * Caller also ensures is_enabled() cannot change.
+	 */
+	list_for_each_entry(trace, &trace_list, list) {
+		pr_notice(NAME "purging non-iounmapped "
+					"trace @0x%08lx, size 0x%lx.\n",
+					trace->probe.addr, trace->probe.len);
+		if (!nommiotrace)
+			unregister_kmmio_probe(&trace->probe);
+	}
+	synchronize_rcu(); /* unregister_kmmio_probe() requirement */
+
+	list_for_each_entry_safe(trace, tmp, &trace_list, list) {
+		list_del(&trace->list);
+		kfree(trace);
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
+		break;
+	}
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
+}
+
+static int __init init(void)
+{
+	pr_debug(NAME "load...\n");
+	if (n_subbufs < 2)
+		return -EINVAL;
+
+	dir = debugfs_create_dir(APP_DIR, NULL);
+	if (!dir) {
+		pr_err(NAME "Couldn't create relay app directory.\n");
+		return -ENOMEM;
+	}
+
+	enabled_file = debugfs_create_file("enabled", 0600, dir, NULL,
+								&fops_enabled);
+	if (!enabled_file) {
+		pr_err(NAME "Couldn't create enabled file.\n");
+		debugfs_remove(dir);
+		return -ENOMEM;
+	}
+
+	if (enable_now)
+		enable_mmiotrace();
+
+	return 0;
+}
+
+static void __exit cleanup(void)
+{
+	pr_debug(NAME "unload...\n");
+	if (enabled_file)
+		debugfs_remove(enabled_file);
+	disable_mmiotrace();
+	if (dir)
+		debugfs_remove(dir);
+}
+
+module_init(init);
+module_exit(cleanup);
+MODULE_LICENSE("GPL");
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 14e48b5..7574bee 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -223,6 +223,7 @@ pte_t *lookup_address(unsigned long address, unsigned int *level)
 
 	return pte_offset_kernel(pmd, address);
 }
+EXPORT_SYMBOL_GPL(lookup_address);
 
 /*
  * Set the new pmd in all the pgds we know about:
diff --git a/arch/x86/mm/pf_in.c b/arch/x86/mm/pf_in.c
new file mode 100644
index 0000000..efa1911
--- /dev/null
+++ b/arch/x86/mm/pf_in.c
@@ -0,0 +1,489 @@
+/*
+ *  Fault Injection Test harness (FI)
+ *  Copyright (C) Intel Crop.
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  as published by the Free Software Foundation; either version 2
+ *  of the License, or (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307,
+ *  USA.
+ *
+ */
+
+/*  Id: pf_in.c,v 1.1.1.1 2002/11/12 05:56:32 brlock Exp
+ *  Copyright by Intel Crop., 2002
+ *  Louis Zhuang (louis.zhuang@intel.com)
+ *
+ *  Bjorn Steinbrink (B.Steinbrink@gmx.de), 2007
+ */
+
+#include <linux/module.h>
+#include <linux/ptrace.h> /* struct pt_regs */
+#include "pf_in.h"
+
+#ifdef __i386__
+/* IA32 Manual 3, 2-1 */
+static unsigned char prefix_codes[] = {
+	0xF0, 0xF2, 0xF3, 0x2E, 0x36, 0x3E, 0x26, 0x64,
+	0x65, 0x2E, 0x3E, 0x66, 0x67
+};
+/* IA32 Manual 3, 3-432*/
+static unsigned int reg_rop[] = {
+	0x8A, 0x8B, 0xB60F, 0xB70F, 0xBE0F, 0xBF0F
+};
+static unsigned int reg_wop[] = { 0x88, 0x89 };
+static unsigned int imm_wop[] = { 0xC6, 0xC7 };
+/* IA32 Manual 3, 3-432*/
+static unsigned int rw8[] = { 0x88, 0x8A, 0xC6 };
+static unsigned int rw32[] = {
+	0x89, 0x8B, 0xC7, 0xB60F, 0xB70F, 0xBE0F, 0xBF0F
+};
+static unsigned int mw8[] = { 0x88, 0x8A, 0xC6, 0xB60F, 0xBE0F };
+static unsigned int mw16[] = { 0xB70F, 0xBF0F };
+static unsigned int mw32[] = { 0x89, 0x8B, 0xC7 };
+static unsigned int mw64[] = {};
+#else /* not __i386__ */
+static unsigned char prefix_codes[] = {
+	0x66, 0x67, 0x2E, 0x3E, 0x26, 0x64, 0x65, 0x36,
+	0xF0, 0xF3, 0xF2,
+	/* REX Prefixes */
+	0x40, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46, 0x47,
+	0x48, 0x49, 0x4a, 0x4b, 0x4c, 0x4d, 0x4e, 0x4f
+};
+/* AMD64 Manual 3, Appendix A*/
+static unsigned int reg_rop[] = {
+	0x8A, 0x8B, 0xB60F, 0xB70F, 0xBE0F, 0xBF0F
+};
+static unsigned int reg_wop[] = { 0x88, 0x89 };
+static unsigned int imm_wop[] = { 0xC6, 0xC7 };
+static unsigned int rw8[] = { 0xC6, 0x88, 0x8A };
+static unsigned int rw32[] = {
+	0xC7, 0x89, 0x8B, 0xB60F, 0xB70F, 0xBE0F, 0xBF0F
+};
+/* 8 bit only */
+static unsigned int mw8[] = { 0xC6, 0x88, 0x8A, 0xB60F, 0xBE0F };
+/* 16 bit only */
+static unsigned int mw16[] = { 0xB70F, 0xBF0F };
+/* 16 or 32 bit */
+static unsigned int mw32[] = { 0xC7 };
+/* 16, 32 or 64 bit */
+static unsigned int mw64[] = { 0x89, 0x8B };
+#endif /* not __i386__ */
+
+static int skip_prefix(unsigned char *addr, int *shorted, int *enlarged,
+								int *rexr)
+{
+	int i;
+	unsigned char *p = addr;
+	*shorted = 0;
+	*enlarged = 0;
+	*rexr = 0;
+
+restart:
+	for (i = 0; i < ARRAY_SIZE(prefix_codes); i++) {
+		if (*p == prefix_codes[i]) {
+			if (*p == 0x66)
+				*shorted = 1;
+#ifdef __amd64__
+			if ((*p & 0xf8) == 0x48)
+				*enlarged = 1;
+			if ((*p & 0xf4) == 0x44)
+				*rexr = 1;
+#endif
+			p++;
+			goto restart;
+		}
+	}
+
+	return (p - addr);
+}
+
+static int get_opcode(unsigned char *addr, unsigned int *opcode)
+{
+	int len;
+
+	if (*addr == 0x0F) {
+		/* 0x0F is extension instruction */
+		*opcode = *(unsigned short *)addr;
+		len = 2;
+	} else {
+		*opcode = *addr;
+		len = 1;
+	}
+
+	return len;
+}
+
+#define CHECK_OP_TYPE(opcode, array, type) \
+	for (i = 0; i < ARRAY_SIZE(array); i++) { \
+		if (array[i] == opcode) { \
+			rv = type; \
+			goto exit; \
+		} \
+	}
+
+enum reason_type get_ins_type(unsigned long ins_addr)
+{
+	unsigned int opcode;
+	unsigned char *p;
+	int shorted, enlarged, rexr;
+	int i;
+	enum reason_type rv = OTHERS;
+
+	p = (unsigned char *)ins_addr;
+	p += skip_prefix(p, &shorted, &enlarged, &rexr);
+	p += get_opcode(p, &opcode);
+
+	CHECK_OP_TYPE(opcode, reg_rop, REG_READ);
+	CHECK_OP_TYPE(opcode, reg_wop, REG_WRITE);
+	CHECK_OP_TYPE(opcode, imm_wop, IMM_WRITE);
+
+exit:
+	return rv;
+}
+#undef CHECK_OP_TYPE
+
+static unsigned int get_ins_reg_width(unsigned long ins_addr)
+{
+	unsigned int opcode;
+	unsigned char *p;
+	int i, shorted, enlarged, rexr;
+
+	p = (unsigned char *)ins_addr;
+	p += skip_prefix(p, &shorted, &enlarged, &rexr);
+	p += get_opcode(p, &opcode);
+
+	for (i = 0; i < ARRAY_SIZE(rw8); i++)
+		if (rw8[i] == opcode)
+			return 1;
+
+	for (i = 0; i < ARRAY_SIZE(rw32); i++)
+		if (rw32[i] == opcode)
+			return (shorted ? 2 : (enlarged ? 8 : 4));
+
+	printk(KERN_ERR "mmiotrace: Unknown opcode 0x%02x\n", opcode);
+	return 0;
+}
+
+unsigned int get_ins_mem_width(unsigned long ins_addr)
+{
+	unsigned int opcode;
+	unsigned char *p;
+	int i, shorted, enlarged, rexr;
+
+	p = (unsigned char *)ins_addr;
+	p += skip_prefix(p, &shorted, &enlarged, &rexr);
+	p += get_opcode(p, &opcode);
+
+	for (i = 0; i < ARRAY_SIZE(mw8); i++)
+		if (mw8[i] == opcode)
+			return 1;
+
+	for (i = 0; i < ARRAY_SIZE(mw16); i++)
+		if (mw16[i] == opcode)
+			return 2;
+
+	for (i = 0; i < ARRAY_SIZE(mw32); i++)
+		if (mw32[i] == opcode)
+			return shorted ? 2 : 4;
+
+	for (i = 0; i < ARRAY_SIZE(mw64); i++)
+		if (mw64[i] == opcode)
+			return shorted ? 2 : (enlarged ? 8 : 4);
+
+	printk(KERN_ERR "mmiotrace: Unknown opcode 0x%02x\n", opcode);
+	return 0;
+}
+
+/*
+ * Define register ident in mod/rm byte.
+ * Note: these are NOT the same as in ptrace-abi.h.
+ */
+enum {
+	arg_AL = 0,
+	arg_CL = 1,
+	arg_DL = 2,
+	arg_BL = 3,
+	arg_AH = 4,
+	arg_CH = 5,
+	arg_DH = 6,
+	arg_BH = 7,
+
+	arg_AX = 0,
+	arg_CX = 1,
+	arg_DX = 2,
+	arg_BX = 3,
+	arg_SP = 4,
+	arg_BP = 5,
+	arg_SI = 6,
+	arg_DI = 7,
+#ifdef __amd64__
+	arg_R8  = 8,
+	arg_R9  = 9,
+	arg_R10 = 10,
+	arg_R11 = 11,
+	arg_R12 = 12,
+	arg_R13 = 13,
+	arg_R14 = 14,
+	arg_R15 = 15
+#endif
+};
+
+static unsigned char *get_reg_w8(int no, struct pt_regs *regs)
+{
+	unsigned char *rv = NULL;
+
+	switch (no) {
+	case arg_AL:
+		rv = (unsigned char *)&regs->ax;
+		break;
+	case arg_BL:
+		rv = (unsigned char *)&regs->bx;
+		break;
+	case arg_CL:
+		rv = (unsigned char *)&regs->cx;
+		break;
+	case arg_DL:
+		rv = (unsigned char *)&regs->dx;
+		break;
+	case arg_AH:
+		rv = 1 + (unsigned char *)&regs->ax;
+		break;
+	case arg_BH:
+		rv = 1 + (unsigned char *)&regs->bx;
+		break;
+	case arg_CH:
+		rv = 1 + (unsigned char *)&regs->cx;
+		break;
+	case arg_DH:
+		rv = 1 + (unsigned char *)&regs->dx;
+		break;
+#ifdef __amd64__
+	case arg_R8:
+		rv = (unsigned char *)&regs->r8;
+		break;
+	case arg_R9:
+		rv = (unsigned char *)&regs->r9;
+		break;
+	case arg_R10:
+		rv = (unsigned char *)&regs->r10;
+		break;
+	case arg_R11:
+		rv = (unsigned char *)&regs->r11;
+		break;
+	case arg_R12:
+		rv = (unsigned char *)&regs->r12;
+		break;
+	case arg_R13:
+		rv = (unsigned char *)&regs->r13;
+		break;
+	case arg_R14:
+		rv = (unsigned char *)&regs->r14;
+		break;
+	case arg_R15:
+		rv = (unsigned char *)&regs->r15;
+		break;
+#endif
+	default:
+		printk(KERN_ERR "mmiotrace: Error reg no# %d\n", no);
+		break;
+	}
+	return rv;
+}
+
+static unsigned long *get_reg_w32(int no, struct pt_regs *regs)
+{
+	unsigned long *rv = NULL;
+
+	switch (no) {
+	case arg_AX:
+		rv = &regs->ax;
+		break;
+	case arg_BX:
+		rv = &regs->bx;
+		break;
+	case arg_CX:
+		rv = &regs->cx;
+		break;
+	case arg_DX:
+		rv = &regs->dx;
+		break;
+	case arg_SP:
+		rv = &regs->sp;
+		break;
+	case arg_BP:
+		rv = &regs->bp;
+		break;
+	case arg_SI:
+		rv = &regs->si;
+		break;
+	case arg_DI:
+		rv = &regs->di;
+		break;
+#ifdef __amd64__
+	case arg_R8:
+		rv = &regs->r8;
+		break;
+	case arg_R9:
+		rv = &regs->r9;
+		break;
+	case arg_R10:
+		rv = &regs->r10;
+		break;
+	case arg_R11:
+		rv = &regs->r11;
+		break;
+	case arg_R12:
+		rv = &regs->r12;
+		break;
+	case arg_R13:
+		rv = &regs->r13;
+		break;
+	case arg_R14:
+		rv = &regs->r14;
+		break;
+	case arg_R15:
+		rv = &regs->r15;
+		break;
+#endif
+	default:
+		printk(KERN_ERR "mmiotrace: Error reg no# %d\n", no);
+	}
+
+	return rv;
+}
+
+unsigned long get_ins_reg_val(unsigned long ins_addr, struct pt_regs *regs)
+{
+	unsigned int opcode;
+	unsigned char mod_rm;
+	int reg;
+	unsigned char *p;
+	int i, shorted, enlarged, rexr;
+	unsigned long rv;
+
+	p = (unsigned char *)ins_addr;
+	p += skip_prefix(p, &shorted, &enlarged, &rexr);
+	p += get_opcode(p, &opcode);
+	for (i = 0; i < ARRAY_SIZE(reg_rop); i++)
+		if (reg_rop[i] == opcode) {
+			rv = REG_READ;
+			goto do_work;
+		}
+
+	for (i = 0; i < ARRAY_SIZE(reg_wop); i++)
+		if (reg_wop[i] == opcode) {
+			rv = REG_WRITE;
+			goto do_work;
+		}
+
+	printk(KERN_ERR "mmiotrace: Not a register instruction, opcode "
+							"0x%02x\n", opcode);
+	goto err;
+
+do_work:
+	mod_rm = *p;
+	reg = ((mod_rm >> 3) & 0x7) | (rexr << 3);
+	switch (get_ins_reg_width(ins_addr)) {
+	case 1:
+		return *get_reg_w8(reg, regs);
+
+	case 2:
+		return *(unsigned short *)get_reg_w32(reg, regs);
+
+	case 4:
+		return *(unsigned int *)get_reg_w32(reg, regs);
+
+#ifdef __amd64__
+	case 8:
+		return *(unsigned long *)get_reg_w32(reg, regs);
+#endif
+
+	default:
+		printk(KERN_ERR "mmiotrace: Error width# %d\n", reg);
+	}
+
+err:
+	return 0;
+}
+
+unsigned long get_ins_imm_val(unsigned long ins_addr)
+{
+	unsigned int opcode;
+	unsigned char mod_rm;
+	unsigned char mod;
+	unsigned char *p;
+	int i, shorted, enlarged, rexr;
+	unsigned long rv;
+
+	p = (unsigned char *)ins_addr;
+	p += skip_prefix(p, &shorted, &enlarged, &rexr);
+	p += get_opcode(p, &opcode);
+	for (i = 0; i < ARRAY_SIZE(imm_wop); i++)
+		if (imm_wop[i] == opcode) {
+			rv = IMM_WRITE;
+			goto do_work;
+		}
+
+	printk(KERN_ERR "mmiotrace: Not an immediate instruction, opcode "
+							"0x%02x\n", opcode);
+	goto err;
+
+do_work:
+	mod_rm = *p;
+	mod = mod_rm >> 6;
+	p++;
+	switch (mod) {
+	case 0:
+		/* if r/m is 5 we have a 32 disp (IA32 Manual 3, Table 2-2)  */
+		/* AMD64: XXX Check for address size prefix? */
+		if ((mod_rm & 0x7) == 0x5)
+			p += 4;
+		break;
+
+	case 1:
+		p += 1;
+		break;
+
+	case 2:
+		p += 4;
+		break;
+
+	case 3:
+	default:
+		printk(KERN_ERR "mmiotrace: not a memory access instruction "
+						"at 0x%lx, rm_mod=0x%02x\n",
+						ins_addr, mod_rm);
+	}
+
+	switch (get_ins_reg_width(ins_addr)) {
+	case 1:
+		return *(unsigned char *)p;
+
+	case 2:
+		return *(unsigned short *)p;
+
+	case 4:
+		return *(unsigned int *)p;
+
+#ifdef __amd64__
+	case 8:
+		return *(unsigned long *)p;
+#endif
+
+	default:
+		printk(KERN_ERR "mmiotrace: Error: width.\n");
+	}
+
+err:
+	return 0;
+}
diff --git a/arch/x86/mm/pf_in.h b/arch/x86/mm/pf_in.h
new file mode 100644
index 0000000..e05341a
--- /dev/null
+++ b/arch/x86/mm/pf_in.h
@@ -0,0 +1,39 @@
+/*
+ *  Fault Injection Test harness (FI)
+ *  Copyright (C) Intel Crop.
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  as published by the Free Software Foundation; either version 2
+ *  of the License, or (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307,
+ *  USA.
+ *
+ */
+
+#ifndef __PF_H_
+#define __PF_H_
+
+enum reason_type {
+	NOT_ME,	/* page fault is not in regions */
+	NOTHING,	/* access others point in regions */
+	REG_READ,	/* read from addr to reg */
+	REG_WRITE,	/* write from reg to addr */
+	IMM_WRITE,	/* write from imm to addr */
+	OTHERS	/* Other instructions can not intercept */
+};
+
+enum reason_type get_ins_type(unsigned long ins_addr);
+unsigned int get_ins_mem_width(unsigned long ins_addr);
+unsigned long get_ins_reg_val(unsigned long ins_addr, struct pt_regs *regs);
+unsigned long get_ins_imm_val(unsigned long ins_addr);
+
+#endif /* __PF_H_ */
diff --git a/arch/x86/mm/testmmiotrace.c b/arch/x86/mm/testmmiotrace.c
new file mode 100644
index 0000000..cfa60b2
--- /dev/null
+++ b/arch/x86/mm/testmmiotrace.c
@@ -0,0 +1,71 @@
+/*
+ * Written by Pekka Paalanen, 2008 <pq@iki.fi>
+ */
+#include <linux/module.h>
+#include <asm/io.h>
+
+#define MODULE_NAME "testmmiotrace"
+
+static unsigned long mmio_address;
+module_param(mmio_address, ulong, 0);
+MODULE_PARM_DESC(mmio_address, "Start address of the mapping of 16 kB.");
+
+static void do_write_test(void __iomem *p)
+{
+	unsigned int i;
+	for (i = 0; i < 256; i++)
+		iowrite8(i, p + i);
+	for (i = 1024; i < (5 * 1024); i += 2)
+		iowrite16(i * 12 + 7, p + i);
+	for (i = (5 * 1024); i < (16 * 1024); i += 4)
+		iowrite32(i * 212371 + 13, p + i);
+}
+
+static void do_read_test(void __iomem *p)
+{
+	unsigned int i;
+	for (i = 0; i < 256; i++)
+		ioread8(p + i);
+	for (i = 1024; i < (5 * 1024); i += 2)
+		ioread16(p + i);
+	for (i = (5 * 1024); i < (16 * 1024); i += 4)
+		ioread32(p + i);
+}
+
+static void do_test(void)
+{
+	void __iomem *p = ioremap_nocache(mmio_address, 0x4000);
+	if (!p) {
+		pr_err(MODULE_NAME ": could not ioremap, aborting.\n");
+		return;
+	}
+	do_write_test(p);
+	do_read_test(p);
+	iounmap(p);
+}
+
+static int __init init(void)
+{
+	if (mmio_address == 0) {
+		pr_err(MODULE_NAME ": you have to use the module argument "
+							"mmio_address.\n");
+		pr_err(MODULE_NAME ": DO NOT LOAD THIS MODULE UNLESS"
+				" YOU REALLY KNOW WHAT YOU ARE DOING!\n");
+		return -ENXIO;
+	}
+
+	pr_warning(MODULE_NAME ": WARNING: mapping 16 kB @ 0x%08lx "
+					"in PCI address space, and writing "
+					"rubbish in there.\n", mmio_address);
+	do_test();
+	return 0;
+}
+
+static void __exit cleanup(void)
+{
+	pr_debug(MODULE_NAME ": unloaded.\n");
+}
+
+module_init(init);
+module_exit(cleanup);
+MODULE_LICENSE("GPL");
diff --git a/include/linux/mmiotrace.h b/include/linux/mmiotrace.h
new file mode 100644
index 0000000..cb5efd0
--- /dev/null
+++ b/include/linux/mmiotrace.h
@@ -0,0 +1,120 @@
+#ifndef MMIOTRACE_H
+#define MMIOTRACE_H
+
+#include <asm/types.h>
+
+#ifdef __KERNEL__
+
+#include <linux/list.h>
+
+struct kmmio_probe;
+struct pt_regs;
+
+typedef void (*kmmio_pre_handler_t)(struct kmmio_probe *,
+				struct pt_regs *, unsigned long addr);
+typedef void (*kmmio_post_handler_t)(struct kmmio_probe *,
+				unsigned long condition, struct pt_regs *);
+
+struct kmmio_probe {
+	struct list_head list; /* kmmio internal list */
+	unsigned long addr; /* start location of the probe point */
+	unsigned long len; /* length of the probe region */
+	kmmio_pre_handler_t pre_handler; /* Called before addr is executed. */
+	kmmio_post_handler_t post_handler; /* Called after addr is executed */
+	void *user_data;
+};
+
+/* kmmio is active by some kmmio_probes? */
+static inline int is_kmmio_active(void)
+{
+	extern unsigned int kmmio_count;
+	return kmmio_count;
+}
+
+extern void reference_kmmio(void);
+extern void unreference_kmmio(void);
+extern int register_kmmio_probe(struct kmmio_probe *p);
+extern void unregister_kmmio_probe(struct kmmio_probe *p);
+
+/* Called from page fault handler. */
+extern int kmmio_handler(struct pt_regs *regs, unsigned long addr);
+
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
+#endif /* __KERNEL__ */
+
+
+/*
+ * If you change anything here, you must bump MMIO_VERSION.
+ * This is the relay data format for user space.
+ */
+#define MMIO_VERSION 0x04
+
+/* mm_io_header.type */
+#define MMIO_OPCODE_MASK 0xff
+#define MMIO_OPCODE_SHIFT 0
+#define MMIO_WIDTH_MASK 0xff00
+#define MMIO_WIDTH_SHIFT 8
+#define MMIO_MAGIC (0x6f000000 | (MMIO_VERSION<<16))
+#define MMIO_MAGIC_MASK 0xffff0000
+
+enum mm_io_opcode {          /* payload type: */
+	MMIO_READ = 0x1,     /* struct mm_io_rw */
+	MMIO_WRITE = 0x2,    /* struct mm_io_rw */
+	MMIO_PROBE = 0x3,    /* struct mm_io_map */
+	MMIO_UNPROBE = 0x4,  /* struct mm_io_map */
+	MMIO_MARKER = 0x5,   /* raw char data */
+	MMIO_UNKNOWN_OP = 0x6, /* struct mm_io_rw */
+};
+
+struct mm_io_header {
+	__u32 type;     /* see MMIO_* macros above */
+	__u32 sec;      /* timestamp */
+	__u32 nsec;
+	__u32 pid;      /* PID of the process, or 0 for kernel core */
+	__u16 data_len; /* length of the following payload */
+};
+
+struct mm_io_rw {
+	__u64 address; /* virtual address of register */
+	__u64 value;
+	__u64 pc;      /* optional program counter */
+};
+
+struct mm_io_map {
+	__u64 phys;  /* base address in PCI space */
+	__u64 addr;  /* base virtual address */
+	__u64 len;   /* mapping size */
+	__u64 pc;    /* optional program counter */
+};
+
+
+/*
+ * These structures are used to allow a single relay_write()
+ * call to write a full packet.
+ */
+
+struct mm_io_header_rw {
+	struct mm_io_header header;
+	struct mm_io_rw rw;
+} __attribute__((packed));
+
+struct mm_io_header_map {
+	struct mm_io_header header;
+	struct mm_io_map map;
+} __attribute__((packed));
+
+#endif /* MMIOTRACE_H */
