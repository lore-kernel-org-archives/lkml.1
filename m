Return-Path: <linux-kernel-owner+w=401wt.eu-S932574AbYAaQQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932574AbYAaQQv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 11:16:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757202AbYAaQQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 11:16:41 -0500
Received: from smtp1.cc.lut.fi ([157.24.2.30]:39652 "EHLO smtp1.cc.lut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755510AbYAaQQh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 11:16:37 -0500
Date: Thu, 31 Jan 2008 18:16:30 +0200
From: Pekka Paalanen <pq@iki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Paalanen <pq@iki.fi>, Harvey Harrison <harvey.harrison@gmail.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arjan van de Ven <arjan@infradead.org>
Subject: [RFC PATCH v2] x86: mmiotrace - trace memory mapped IO
Message-ID: <20080131181630.10cb1eac@daedalus.pq.iki.fi>
In-Reply-To: <20080131180253.6c007852@daedalus.pq.iki.fi>
References: <20080127185238.4bcac54b@daedalus.pq.iki.fi>
	<1201660102.8837.9.camel@brick>
	<1201660453.8837.13.camel@brick>
	<20080130200827.322c4f7d@daedalus.pq.iki.fi>
	<20080131150746.GB11996@elte.hu>
	<20080131180253.6c007852@daedalus.pq.iki.fi>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > could you please send us a patch for the whole mmiotrace kernel-side 
> > feature, so that we can have a look at the general structure of this? 
> > (and the interaction with change_page_attr(), etc.) Even if it's not 
> > functional (and wont even build/boot) at the moment. Thanks,

And here's mmiotrace. This works for me (amd64), but not for a test user
who has 32-bit x86. We have not had the chance to debug it yet.
The symptom is "everything locked up" after insmodding testmmiotrace.ko,
targeting the mid-point of his VRAM. And there's the "undefined symbol
init_mm" problem on 32-bit, but we just put the export back in (not
included in these patches).

No-one has tried this on SMP. I have a Core 2 Duo laptop where I will
test this when I get the chance.


>From 10000bf67af4900b75a56cb47726d7b63d11d7e8 Mon Sep 17 00:00:00 2001
From: Pekka Paalanen <pq@iki.fi>
Date: Wed, 30 Jan 2008 21:51:51 +0200
Subject: [PATCH] x86: mmiotrace - trace memory mapped IO

Mmiotrace is a tool for trapping memory mapped IO (MMIO) accesses within
the kernel. It is used for debugging and especially for reverse
engineering evil binary drivers.

Mmiotrace works by wrapping the ioremap family of kernel functions and
marking the returned pages as not present. Access to the IO memory
triggers a page fault, which will be handled by mmiotrace's custom page
fault handler. This will single-step the faulted instruction with the
MMIO page marked as present. Access logs are directed to user space via
relay and debug_fs.

This page fault approach is necessary, because binary drivers have
readl/writel etc. calls inlined and therefore extremely difficult to
trap with with e.g. kprobes.

This patch depends on the custom page fault handlers patch.

Signed-off-by: Pekka Paalanen <pq@iki.fi>
---
 arch/x86/Kconfig.debug                    |   28 ++
 arch/x86/kernel/Makefile                  |    2 +
 arch/x86/kernel/mmiotrace/Makefile        |    4 +
 arch/x86/kernel/mmiotrace/kmmio.c         |  391 +++++++++++++++++++++
 arch/x86/kernel/mmiotrace/kmmio.h         |   58 ++++
 arch/x86/kernel/mmiotrace/mmio-mod.c      |  527 +++++++++++++++++++++++++++++
 arch/x86/kernel/mmiotrace/pf_in.c         |  489 ++++++++++++++++++++++++++
 arch/x86/kernel/mmiotrace/pf_in.h         |   39 +++
 arch/x86/kernel/mmiotrace/testmmiotrace.c |   77 +++++
 include/linux/mmiotrace.h                 |   62 ++++
 10 files changed, 1677 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/kernel/mmiotrace/Makefile
 create mode 100644 arch/x86/kernel/mmiotrace/kmmio.c
 create mode 100644 arch/x86/kernel/mmiotrace/kmmio.h
 create mode 100644 arch/x86/kernel/mmiotrace/mmio-mod.c
 create mode 100644 arch/x86/kernel/mmiotrace/pf_in.c
 create mode 100644 arch/x86/kernel/mmiotrace/pf_in.h
 create mode 100644 arch/x86/kernel/mmiotrace/testmmiotrace.c
 create mode 100644 include/linux/mmiotrace.h

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 1185dcc..486dca5 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -146,6 +146,34 @@ config PAGE_FAULT_HANDLERS
 	  register a function that is called on every page fault. Custom
 	  handlers are used by some debugging and reverse engineering tools.
 
+config MMIOTRACE
+	tristate "Memory mapped IO tracing"
+	depends on DEBUG_KERNEL && m
+	depends on PAGE_FAULT_HANDLERS && RELAY && DEBUG_FS
+	default n
+	help
+	  This will build a kernel module called mmiotrace.
+
+	  Mmiotrace traces Memory Mapped I/O access and is meant for debugging
+	  and reverse engineering. The kernel module offers wrapped
+	  versions of the ioremap family of functions. The driver to be traced
+	  must be modified to call these wrappers. A user space program is
+	  required to collect the MMIO data.
+
+	  See http://nouveau.freedesktop.org/wiki/MmioTrace
+	  If you are not helping to develop drivers, say N.
+
+config MMIOTRACE_TEST
+	tristate "Test module for mmiotrace"
+	depends on MMIOTRACE && m
+	default n
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
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 7954e9d..469673f 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -61,6 +61,8 @@ obj-$(CONFIG_KGDB)		+= kgdb.o kgdb-jmp_$(BITS).o
 obj-$(CONFIG_VM86)		+= vm86_32.o
 obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
 
+obj-$(CONFIG_MMIOTRACE)		+= mmiotrace/
+
 obj-$(CONFIG_HPET_TIMER) 	+= hpet.o
 
 obj-$(CONFIG_K8_NB)		+= k8.o
diff --git a/arch/x86/kernel/mmiotrace/Makefile b/arch/x86/kernel/mmiotrace/Makefile
new file mode 100644
index 0000000..d6905f7
--- /dev/null
+++ b/arch/x86/kernel/mmiotrace/Makefile
@@ -0,0 +1,4 @@
+obj-$(CONFIG_MMIOTRACE) += mmiotrace.o
+mmiotrace-objs := pf_in.o kmmio.o mmio-mod.o
+
+obj-$(CONFIG_MMIOTRACE_TEST) += testmmiotrace.o
diff --git a/arch/x86/kernel/mmiotrace/kmmio.c b/arch/x86/kernel/mmiotrace/kmmio.c
new file mode 100644
index 0000000..8ba48f9
--- /dev/null
+++ b/arch/x86/kernel/mmiotrace/kmmio.c
@@ -0,0 +1,391 @@
+/* Support for MMIO probes.
+ * Benfit many code from kprobes
+ * (C) 2002 Louis Zhuang <louis.zhuang@intel.com>.
+ *     2007 Alexander Eichner
+ *     2008 Pekka Paalanen <pq@iki.fi>
+ */
+
+#include <linux/version.h>
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
+#include <asm/io.h>
+#include <asm/cacheflush.h>
+#include <asm/errno.h>
+#include <asm/tlbflush.h>
+
+#include "kmmio.h"
+
+#define KMMIO_HASH_BITS 6
+#define KMMIO_TABLE_SIZE (1 << KMMIO_HASH_BITS)
+#define KMMIO_PAGE_HASH_BITS 4
+#define KMMIO_PAGE_TABLE_SIZE (1 << KMMIO_PAGE_HASH_BITS)
+
+struct kmmio_context {
+	struct kmmio_fault_page *fpage;
+	struct kmmio_probe *probe;
+	unsigned long saved_flags;
+	int active;
+};
+
+static int kmmio_page_fault(struct pt_regs *regs, unsigned long error_code,
+						unsigned long address);
+static int kmmio_die_notifier(struct notifier_block *nb, unsigned long val,
+								void *args);
+
+static DEFINE_SPINLOCK(kmmio_lock);
+
+/* These are protected by kmmio_lock */
+unsigned int kmmio_count;
+static unsigned int handler_registered;
+static struct list_head kmmio_page_table[KMMIO_PAGE_TABLE_SIZE];
+static LIST_HEAD(kmmio_probes);
+
+static struct kmmio_context kmmio_ctx[NR_CPUS];
+
+static struct pf_handler kmmio_pf_hook = {
+	.handler = kmmio_page_fault
+};
+
+static struct notifier_block nb_die = {
+	.notifier_call = kmmio_die_notifier
+};
+
+int init_kmmio(void)
+{
+	int i;
+	for (i = 0; i < KMMIO_PAGE_TABLE_SIZE; i++)
+		INIT_LIST_HEAD(&kmmio_page_table[i]);
+
+	register_die_notifier(&nb_die);
+	return 0;
+}
+
+void cleanup_kmmio(void)
+{
+	/*
+	 * Assume the following have been already cleaned by calling
+	 * unregister_kmmio_probe() appropriately:
+	 * kmmio_page_table, kmmio_probes
+	 */
+	if (handler_registered) {
+		unregister_page_fault_handler(&kmmio_pf_hook);
+		synchronize_rcu();
+	}
+	unregister_die_notifier(&nb_die);
+}
+
+/*
+ * this is basically a dynamic stabbing problem:
+ * Could use the existing prio tree code or
+ * Possible better implementations:
+ * The Interval Skip List: A Data Structure for Finding All Intervals That
+ * Overlap a Point (might be simple)
+ * Space Efficient Dynamic Stabbing with Fast Queries - Mikkel Thorup
+ */
+/* Get the kmmio at this addr (if any). You must be holding kmmio_lock. */
+static struct kmmio_probe *get_kmmio_probe(unsigned long addr)
+{
+	struct kmmio_probe *p;
+	list_for_each_entry(p, &kmmio_probes, list) {
+		if (addr >= p->addr && addr <= (p->addr + p->len))
+			return p;
+	}
+	return NULL;
+}
+
+static struct kmmio_fault_page *get_kmmio_fault_page(unsigned long page)
+{
+	struct list_head *head, *tmp;
+
+	page &= PAGE_MASK;
+	head = &kmmio_page_table[hash_long(page, KMMIO_PAGE_HASH_BITS)];
+	list_for_each(tmp, head) {
+		struct kmmio_fault_page *p
+			= list_entry(tmp, struct kmmio_fault_page, list);
+		if (p->page == page)
+			return p;
+	}
+
+	return NULL;
+}
+
+static void arm_kmmio_fault_page(unsigned long page, int *large)
+{
+	unsigned long address = page & PAGE_MASK;
+	pgd_t *pgd = pgd_offset_k(address);
+	pud_t *pud = pud_offset(pgd, address);
+	pmd_t *pmd = pmd_offset(pud, address);
+	pte_t *pte = pte_offset_kernel(pmd, address);
+
+	if (pmd_large(*pmd)) {
+		set_pmd(pmd, __pmd(pmd_val(*pmd) & ~_PAGE_PRESENT));
+		if (large)
+			*large = 1;
+	} else {
+		set_pte(pte, __pte(pte_val(*pte) & ~_PAGE_PRESENT));
+	}
+
+	__flush_tlb_one(page);
+}
+
+static void disarm_kmmio_fault_page(unsigned long page, int *large)
+{
+	unsigned long address = page & PAGE_MASK;
+	pgd_t *pgd = pgd_offset_k(address);
+	pud_t *pud = pud_offset(pgd, address);
+	pmd_t *pmd = pmd_offset(pud, address);
+	pte_t *pte = pte_offset_kernel(pmd, address);
+
+	if (large && *large) {
+		set_pmd(pmd, __pmd(pmd_val(*pmd) | _PAGE_PRESENT));
+		*large = 0;
+	} else {
+		set_pte(pte, __pte(pte_val(*pte) | _PAGE_PRESENT));
+	}
+
+	__flush_tlb_one(page);
+}
+
+/*
+ * Interrupts are disabled on entry as trap3 is an interrupt gate
+ * and they remain disabled thorough out this function.
+ */
+static int kmmio_handler(struct pt_regs *regs, unsigned long addr)
+{
+	struct kmmio_context *ctx;
+	int cpu;
+
+	/*
+	 * Preemption is now disabled to prevent process switch during
+	 * single stepping. We can only handle one active kmmio trace
+	 * per cpu, so ensure that we finish it before something else
+	 * gets to run.
+	 *
+	 * XXX what if an interrupt occurs between returning from
+	 * do_page_fault() and entering the single-step exception handler?
+	 * And that interrupt triggers a kmmio trap?
+	 */
+	preempt_disable();
+	cpu = smp_processor_id();
+	ctx = &kmmio_ctx[cpu];
+
+	/* interrupts disabled and CPU-local data => atomicity guaranteed. */
+	if (ctx->active) {
+		/*
+		 * This avoids a deadlock with kmmio_lock.
+		 * If this page fault really was due to kmmio trap,
+		 * all hell breaks loose.
+		 */
+		printk(KERN_EMERG "mmiotrace: recursive probe hit on CPU %d, "
+					"for address %lu. Ignoring.\n",
+					cpu, addr);
+		goto no_kmmio;
+	}
+	ctx->active++;
+
+	/*
+	 * Acquire the kmmio lock to prevent changes affecting
+	 * get_kmmio_fault_page() and get_kmmio_probe(), since we save their
+	 * returned pointers.
+	 * The lock is released in post_kmmio_handler().
+	 * XXX: could/should get_kmmio_*() be using RCU instead of spinlock?
+	 */
+	spin_lock(&kmmio_lock);
+
+	ctx->fpage = get_kmmio_fault_page(addr);
+	if (!ctx->fpage) {
+		/* this page fault is not caused by kmmio */
+		goto no_kmmio_locked;
+	}
+
+	ctx->probe = get_kmmio_probe(addr);
+	ctx->saved_flags = (regs->flags & (TF_MASK|IF_MASK));
+
+	if (ctx->probe && ctx->probe->pre_handler)
+		ctx->probe->pre_handler(ctx->probe, regs, addr);
+
+	regs->flags |= TF_MASK;
+	regs->flags &= ~IF_MASK;
+
+	/* We hold lock, now we set present bit in PTE and single step. */
+	disarm_kmmio_fault_page(ctx->fpage->page, NULL);
+
+	return 1;
+
+no_kmmio_locked:
+	spin_unlock(&kmmio_lock);
+	ctx->active--;
+no_kmmio:
+	preempt_enable_no_resched();
+	/* page fault not handled by kmmio */
+	return 0;
+}
+
+/*
+ * Interrupts are disabled on entry as trap1 is an interrupt gate
+ * and they remain disabled thorough out this function.
+ * And we hold kmmio lock.
+ */
+static int post_kmmio_handler(unsigned long condition, struct pt_regs *regs)
+{
+	int cpu = smp_processor_id();
+	struct kmmio_context *ctx = &kmmio_ctx[cpu];
+
+	if (!ctx->active)
+		return 0;
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
+	spin_unlock(&kmmio_lock);
+	preempt_enable_no_resched();
+
+	/*
+	 * if somebody else is singlestepping across a probe point, flags
+	 * will have TF set, in which case, continue the remaining processing
+	 * of do_debug, as if this is not a probe hit.
+	 */
+	if (regs->flags & TF_MASK)
+		return 0;
+
+	return 1;
+}
+
+static int add_kmmio_fault_page(unsigned long page)
+{
+	struct kmmio_fault_page *f;
+
+	page &= PAGE_MASK;
+	f = get_kmmio_fault_page(page);
+	if (f) {
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
+	list_add(&f->list,
+		 &kmmio_page_table[hash_long(f->page, KMMIO_PAGE_HASH_BITS)]);
+
+	arm_kmmio_fault_page(f->page, NULL);
+
+	return 0;
+}
+
+static void release_kmmio_fault_page(unsigned long page)
+{
+	struct kmmio_fault_page *f;
+
+	page &= PAGE_MASK;
+	f = get_kmmio_fault_page(page);
+	if (!f)
+		return;
+
+	f->count--;
+	if (!f->count) {
+		disarm_kmmio_fault_page(f->page, NULL);
+		list_del(&f->list);
+	}
+}
+
+int register_kmmio_probe(struct kmmio_probe *p)
+{
+	int ret = 0;
+	unsigned long size = 0;
+
+	spin_lock_irq(&kmmio_lock);
+	kmmio_count++;
+	if (get_kmmio_probe(p->addr)) {
+		ret = -EEXIST;
+		goto out;
+	}
+	list_add(&p->list, &kmmio_probes);
+	/*printk("adding fault pages...\n");*/
+	while (size < p->len) {
+		if (add_kmmio_fault_page(p->addr + size))
+			printk(KERN_ERR "mmio: Unable to set page fault.\n");
+		size += PAGE_SIZE;
+	}
+
+	if (!handler_registered) {
+		register_page_fault_handler(&kmmio_pf_hook);
+		handler_registered++;
+	}
+
+out:
+	spin_unlock_irq(&kmmio_lock);
+	/*
+	 * XXX: What should I do here?
+	 * Here was a call to global_flush_tlb(), but it does not exist
+	 * anymore.
+	 */
+	return ret;
+}
+
+void unregister_kmmio_probe(struct kmmio_probe *p)
+{
+	unsigned long size = 0;
+
+	spin_lock_irq(&kmmio_lock);
+	while (size < p->len) {
+		release_kmmio_fault_page(p->addr + size);
+		size += PAGE_SIZE;
+	}
+	list_del(&p->list);
+	kmmio_count--;
+	spin_unlock_irq(&kmmio_lock);
+}
+
+/*
+ * According to 2.6.20, mainly x86_64 arch:
+ * This is being called from do_page_fault(), via the page fault notifier
+ * chain. The chain is called for both user space faults and kernel space
+ * faults (address >= TASK_SIZE64), except not on faults serviced by
+ * vmalloc_fault().
+ *
+ * We may be in an interrupt or a critical section. Also prefecthing may
+ * trigger a page fault. We may be in the middle of process switch.
+ * The page fault hook functionality has put us inside RCU read lock.
+ *
+ * Local interrupts are disabled, so preemption cannot happen.
+ * Do not enable interrupts, do not sleep, and watch out for other CPUs.
+ */
+static int kmmio_page_fault(struct pt_regs *regs, unsigned long error_code,
+						unsigned long address)
+{
+	if (is_kmmio_active())
+		if (kmmio_handler(regs, address) == 1)
+			return -1;
+	return 0;
+}
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
diff --git a/arch/x86/kernel/mmiotrace/kmmio.h b/arch/x86/kernel/mmiotrace/kmmio.h
new file mode 100644
index 0000000..85b7f68
--- /dev/null
+++ b/arch/x86/kernel/mmiotrace/kmmio.h
@@ -0,0 +1,58 @@
+#ifndef _LINUX_KMMIO_H
+#define _LINUX_KMMIO_H
+
+#include <linux/list.h>
+#include <linux/notifier.h>
+#include <linux/smp.h>
+#include <linux/types.h>
+#include <linux/ptrace.h>
+#include <linux/version.h>
+#include <linux/kdebug.h>
+
+struct kmmio_probe;
+struct kmmio_fault_page;
+struct pt_regs;
+
+typedef void (*kmmio_pre_handler_t)(struct kmmio_probe *,
+				struct pt_regs *, unsigned long addr);
+typedef void (*kmmio_post_handler_t)(struct kmmio_probe *,
+				unsigned long condition, struct pt_regs *);
+
+struct kmmio_probe {
+	struct list_head list;
+
+	/* start location of the probe point */
+	unsigned long addr;
+
+	/* length of the probe region */
+	unsigned long len;
+
+	 /* Called before addr is executed. */
+	kmmio_pre_handler_t pre_handler;
+
+	/* Called after addr is executed, unless... */
+	kmmio_post_handler_t post_handler;
+};
+
+struct kmmio_fault_page {
+	struct list_head list;
+
+	/* location of the fault page */
+	unsigned long page;
+
+	int count;
+};
+
+/* kmmio is active by some kmmio_probes? */
+static inline int is_kmmio_active(void)
+{
+	extern unsigned int kmmio_count;
+	return kmmio_count;
+}
+
+int init_kmmio(void);
+void cleanup_kmmio(void);
+int register_kmmio_probe(struct kmmio_probe *p);
+void unregister_kmmio_probe(struct kmmio_probe *p);
+
+#endif /* _LINUX_KMMIO_H */
diff --git a/arch/x86/kernel/mmiotrace/mmio-mod.c b/arch/x86/kernel/mmiotrace/mmio-mod.c
new file mode 100644
index 0000000..4a8c859
--- /dev/null
+++ b/arch/x86/kernel/mmiotrace/mmio-mod.c
@@ -0,0 +1,527 @@
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
+
+#include "kmmio.h"
+#include "pf_in.h"
+
+/* This app's relay channel files will appear in /debug/mmio-trace */
+#define APP_DIR		"mmio-trace"
+/* the marker injection file in /proc */
+#define MARKER_FILE     "mmio-marker"
+
+#define MODULE_NAME     "mmiotrace"
+
+struct trap_reason {
+	unsigned long addr;
+	unsigned long ip;
+	enum reason_type type;
+	int active_traces;
+};
+
+static struct trap_reason pf_reason[NR_CPUS];
+static struct mm_io_header_rw cpu_trace[NR_CPUS];
+
+static struct file_operations mmio_fops = {
+	.owner = THIS_MODULE,
+};
+
+static const size_t subbuf_size = 256*1024;
+static struct rchan *chan;
+static struct dentry *dir;
+static int suspended;      /* XXX should this be per cpu? */
+static struct proc_dir_entry *proc_marker_file;
+
+/* module parameters */
+static unsigned int      n_subbufs = 32*4;
+static unsigned long filter_offset;
+static int                 notrace;
+static int               ISA_trace;
+static int                trace_pc;
+
+module_param(n_subbufs, uint, 0);
+module_param(filter_offset, ulong, 0);
+module_param(notrace, bool, 0);
+module_param(ISA_trace, bool, 0);
+module_param(trace_pc, bool, 0);
+
+MODULE_PARM_DESC(n_subbufs, "Number of 256kB buffers, default 128.");
+MODULE_PARM_DESC(filter_offset, "Start address of traced mappings.");
+MODULE_PARM_DESC(notrace, "Disable actual MMIO tracing.");
+MODULE_PARM_DESC(ISA_trace, "Do not exclude the low ISA range.");
+MODULE_PARM_DESC(trace_pc, "Record address of faulting instructions.");
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
+ * Write callback for the /proc entry:
+ * Read a marker and write it to the mmio trace log
+ */
+static int write_marker(struct file *file, const char __user *buffer,
+					unsigned long count, void *data)
+{
+	char *event = NULL;
+	struct mm_io_header *headp;
+	int len = (count > 65535) ? 65535 : count;
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
+	relay_write(chan, event, sizeof(*headp) + len);
+	kfree(event);
+	return len;
+}
+
+static void print_pte(unsigned long address)
+{
+	pgd_t *pgd = pgd_offset_k(address);
+	pud_t *pud = pud_offset(pgd, address);
+	pmd_t *pmd = pmd_offset(pud, address);
+	if (pmd_large(*pmd)) {
+		printk(KERN_EMERG MODULE_NAME ": 4MB pages are not "
+						"currently supported: %lx\n",
+						address);
+		BUG();
+	}
+	printk(KERN_DEBUG MODULE_NAME ": pte for 0x%lx: 0x%lx 0x%lx\n",
+		address,
+		pte_val(*pte_offset_kernel(pmd, address)),
+		pte_val(*pte_offset_kernel(pmd, address)) & _PAGE_PRESENT);
+}
+
+/*
+ * For some reason the pre/post pairs have been called in an
+ * unmatched order. Report and die.
+ */
+static void die_kmmio_nesting_error(struct pt_regs *regs, unsigned long addr)
+{
+	const unsigned long cpu = smp_processor_id();
+	printk(KERN_EMERG MODULE_NAME ": unexpected fault for address: %lx, "
+					"last fault for address: %lx\n",
+					addr, pf_reason[cpu].addr);
+	print_pte(addr);
+#ifdef __i386__
+	print_symbol(KERN_EMERG "faulting EIP is at %s\n", regs->ip);
+	print_symbol(KERN_EMERG "last faulting EIP was at %s\n",
+							pf_reason[cpu].ip);
+	printk(KERN_EMERG
+			"eax: %08lx   ebx: %08lx   ecx: %08lx   edx: %08lx\n",
+			regs->ax, regs->bx, regs->cx, regs->dx);
+	printk(KERN_EMERG
+			"esi: %08lx   edi: %08lx   ebp: %08lx   esp: %08lx\n",
+			regs->si, regs->di, regs->bp, regs->sp);
+#else
+	print_symbol(KERN_EMERG "faulting RIP is at %s\n", regs->ip);
+	print_symbol(KERN_EMERG "last faulting RIP was at %s\n",
+							pf_reason[cpu].ip);
+	printk(KERN_EMERG "rax: %016lx   rcx: %016lx   rdx: %016lx\n",
+					regs->ax, regs->cx, regs->dx);
+	printk(KERN_EMERG "rsi: %016lx   rdi: %016lx   "
+				"rbp: %016lx   rsp: %016lx\n",
+				regs->si, regs->di, regs->bp, regs->sp);
+#endif
+	BUG();
+}
+
+static void pre(struct kmmio_probe *p, struct pt_regs *regs,
+						unsigned long addr)
+{
+	const unsigned long cpu = smp_processor_id();
+	const unsigned long instptr = instruction_pointer(regs);
+	const enum reason_type type = get_ins_type(instptr);
+
+	/* it doesn't make sense to have more than one active trace per cpu */
+	if (pf_reason[cpu].active_traces)
+		die_kmmio_nesting_error(regs, addr);
+	else
+		pf_reason[cpu].active_traces++;
+
+	pf_reason[cpu].type = type;
+	pf_reason[cpu].addr = addr;
+	pf_reason[cpu].ip = instptr;
+
+	cpu_trace[cpu].header.type = MMIO_MAGIC;
+	cpu_trace[cpu].header.pid = 0;
+	cpu_trace[cpu].header.data_len = sizeof(struct mm_io_rw);
+	cpu_trace[cpu].rw.address = addr;
+
+	/*
+	 * Only record the program counter when requested.
+	 * It may taint clean-room reverse engineering.
+	 */
+	if (trace_pc)
+		cpu_trace[cpu].rw.pc = instptr;
+	else
+		cpu_trace[cpu].rw.pc = 0;
+
+	record_timestamp(&cpu_trace[cpu].header);
+
+	switch (type) {
+	case REG_READ:
+		cpu_trace[cpu].header.type |=
+			(MMIO_READ << MMIO_OPCODE_SHIFT) |
+			(get_ins_mem_width(instptr) << MMIO_WIDTH_SHIFT);
+		break;
+	case REG_WRITE:
+		cpu_trace[cpu].header.type |=
+			(MMIO_WRITE << MMIO_OPCODE_SHIFT) |
+			(get_ins_mem_width(instptr) << MMIO_WIDTH_SHIFT);
+		cpu_trace[cpu].rw.value = get_ins_reg_val(instptr, regs);
+		break;
+	case IMM_WRITE:
+		cpu_trace[cpu].header.type |=
+			(MMIO_WRITE << MMIO_OPCODE_SHIFT) |
+			(get_ins_mem_width(instptr) << MMIO_WIDTH_SHIFT);
+		cpu_trace[cpu].rw.value = get_ins_imm_val(instptr);
+		break;
+	default:
+		{
+			unsigned char *ip = (unsigned char *)instptr;
+			cpu_trace[cpu].header.type |=
+					(MMIO_UNKNOWN_OP << MMIO_OPCODE_SHIFT);
+			cpu_trace[cpu].rw.value = (*ip) << 16 |
+							*(ip + 1) << 8 |
+							*(ip + 2);
+		}
+	}
+}
+
+static void post(struct kmmio_probe *p, unsigned long condition,
+							struct pt_regs *regs)
+{
+	const unsigned long cpu = smp_processor_id();
+
+	/* this should always return the active_trace count to 0 */
+	pf_reason[cpu].active_traces--;
+	if (pf_reason[cpu].active_traces) {
+		printk(KERN_EMERG MODULE_NAME ": unexpected post handler");
+		BUG();
+	}
+
+	switch (pf_reason[cpu].type) {
+	case REG_READ:
+		cpu_trace[cpu].rw.value = get_ins_reg_val(pf_reason[cpu].ip,
+									regs);
+		break;
+	default:
+		break;
+	}
+	relay_write(chan, &cpu_trace[cpu], sizeof(struct mm_io_header_rw));
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
+	if (relay_buf_full(buf)) {
+		if (!suspended) {
+			suspended = 1;
+			printk(KERN_ERR MODULE_NAME
+						": cpu %d buffer full!!!\n",
+						smp_processor_id());
+		}
+		return 0;
+	} else if (suspended) {
+		suspended = 0;
+		printk(KERN_ERR MODULE_NAME
+					": cpu %d buffer no longer full.\n",
+					smp_processor_id());
+	}
+
+	return 1;
+}
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
+/*
+ * create_channel - creates channel /debug/APP_DIR/cpuXXX
+ * Returns channel on success, NULL otherwise
+ */
+static struct rchan *create_channel(unsigned size, unsigned n)
+{
+	return relay_open("cpu", dir, size, n, &relay_callbacks, NULL);
+}
+
+/* destroy_channel - destroys channel /debug/APP_DIR/cpuXXX */
+static void destroy_channel(void)
+{
+	if (chan) {
+		relay_close(chan);
+		chan = NULL;
+	}
+}
+
+struct remap_trace {
+	struct list_head list;
+	struct kmmio_probe probe;
+};
+static LIST_HEAD(trace_list);
+static DEFINE_SPINLOCK(trace_list_lock);
+
+static void do_ioremap_trace_core(unsigned long offset, unsigned long size,
+							void __iomem *addr)
+{
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
+	*trace = (struct remap_trace) {
+		.probe = {
+			.addr = (unsigned long)addr,
+			.len = size,
+			.pre_handler = pre,
+			.post_handler = post,
+		}
+	};
+
+	relay_write(chan, &event, sizeof(event));
+	spin_lock(&trace_list_lock);
+	list_add_tail(&trace->list, &trace_list);
+	spin_unlock(&trace_list_lock);
+	if (!notrace)
+		register_kmmio_probe(&trace->probe);
+}
+
+static void ioremap_trace_core(unsigned long offset, unsigned long size,
+							void __iomem *addr)
+{
+	if ((filter_offset) && (offset != filter_offset))
+		return;
+
+	/* Don't trace the low PCI/ISA area, it's always mapped.. */
+	if (!ISA_trace && (offset < ISA_END_ADDRESS) &&
+					(offset + size > ISA_START_ADDRESS)) {
+		printk(KERN_NOTICE MODULE_NAME ": Ignoring map of low "
+						"PCI/ISA area (0x%lx-0x%lx)\n",
+						offset, offset + size);
+		return;
+	}
+	do_ioremap_trace_core(offset, size, addr);
+}
+
+void __iomem *ioremap_cache_trace(unsigned long offset, unsigned long size)
+{
+	void __iomem *p = ioremap_cache(offset, size);
+	printk(KERN_DEBUG MODULE_NAME ": ioremap_cache(0x%lx, 0x%lx) = %p\n",
+							offset, size, p);
+	ioremap_trace_core(offset, size, p);
+	return p;
+}
+EXPORT_SYMBOL(ioremap_cache_trace);
+
+void __iomem *ioremap_nocache_trace(unsigned long offset, unsigned long size)
+{
+	void __iomem *p = ioremap_nocache(offset, size);
+	printk(KERN_DEBUG MODULE_NAME ": ioremap_nocache(0x%lx, 0x%lx) = %p\n",
+							offset, size, p);
+	ioremap_trace_core(offset, size, p);
+	return p;
+}
+EXPORT_SYMBOL(ioremap_nocache_trace);
+
+void iounmap_trace(volatile void __iomem *addr)
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
+	printk(KERN_DEBUG MODULE_NAME ": Unmapping %p.\n", addr);
+	record_timestamp(&event.header);
+
+	spin_lock(&trace_list_lock);
+	list_for_each_entry_safe(trace, tmp, &trace_list, list) {
+		if ((unsigned long)addr == trace->probe.addr) {
+			if (!notrace)
+				unregister_kmmio_probe(&trace->probe);
+			list_del(&trace->list);
+			kfree(trace);
+			break;
+		}
+	}
+	spin_unlock(&trace_list_lock);
+	relay_write(chan, &event, sizeof(event));
+	iounmap(addr);
+}
+EXPORT_SYMBOL(iounmap_trace);
+
+static void clear_trace_list(void)
+{
+	struct remap_trace *trace;
+	struct remap_trace *tmp;
+
+	spin_lock(&trace_list_lock);
+	list_for_each_entry_safe(trace, tmp, &trace_list, list) {
+		printk(KERN_WARNING MODULE_NAME ": purging non-iounmapped "
+					"trace @0x%08lx, size 0x%lx.\n",
+					trace->probe.addr, trace->probe.len);
+		if (!notrace)
+			unregister_kmmio_probe(&trace->probe);
+		list_del(&trace->list);
+		kfree(trace);
+		break;
+	}
+	spin_unlock(&trace_list_lock);
+}
+
+static int __init init(void)
+{
+	if (n_subbufs < 2)
+		return -EINVAL;
+
+	dir = debugfs_create_dir(APP_DIR, NULL);
+	if (!dir) {
+		printk(KERN_ERR MODULE_NAME
+				": Couldn't create relay app directory.\n");
+		return -ENOMEM;
+	}
+
+	chan = create_channel(subbuf_size, n_subbufs);
+	if (!chan) {
+		debugfs_remove(dir);
+		printk(KERN_ERR MODULE_NAME
+				": relay app channel creation failed\n");
+		return -ENOMEM;
+	}
+
+	init_kmmio();
+
+	proc_marker_file = create_proc_entry(MARKER_FILE, 0, NULL);
+	if (proc_marker_file)
+		proc_marker_file->write_proc = write_marker;
+
+	printk(KERN_DEBUG MODULE_NAME ": loaded.\n");
+	if (notrace)
+		printk(KERN_DEBUG MODULE_NAME ": MMIO tracing disabled.\n");
+	if (ISA_trace)
+		printk(KERN_WARNING MODULE_NAME
+				": Warning! low ISA range will be traced.\n");
+	return 0;
+}
+
+static void __exit cleanup(void)
+{
+	printk(KERN_DEBUG MODULE_NAME ": unload...\n");
+	clear_trace_list();
+	cleanup_kmmio();
+	remove_proc_entry(MARKER_FILE, NULL);
+	destroy_channel();
+	if (dir)
+		debugfs_remove(dir);
+}
+
+module_init(init);
+module_exit(cleanup);
+MODULE_LICENSE("GPL");
diff --git a/arch/x86/kernel/mmiotrace/pf_in.c b/arch/x86/kernel/mmiotrace/pf_in.c
new file mode 100644
index 0000000..67ea520
--- /dev/null
+++ b/arch/x86/kernel/mmiotrace/pf_in.c
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
+/*  $Id: pf_in.c,v 1.1.1.1 2002/11/12 05:56:32 brlock Exp $
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
diff --git a/arch/x86/kernel/mmiotrace/pf_in.h b/arch/x86/kernel/mmiotrace/pf_in.h
new file mode 100644
index 0000000..e05341a
--- /dev/null
+++ b/arch/x86/kernel/mmiotrace/pf_in.h
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
diff --git a/arch/x86/kernel/mmiotrace/testmmiotrace.c b/arch/x86/kernel/mmiotrace/testmmiotrace.c
new file mode 100644
index 0000000..40e66b0
--- /dev/null
+++ b/arch/x86/kernel/mmiotrace/testmmiotrace.c
@@ -0,0 +1,77 @@
+/*
+ * Written by Pekka Paalanen, 2008 <pq@iki.fi>
+ */
+#include <linux/module.h>
+#include <asm/io.h>
+
+extern void __iomem *ioremap_nocache_trace(unsigned long offset,
+						unsigned long size);
+extern void iounmap_trace(volatile void __iomem *addr);
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
+	volatile unsigned int v;
+	for (i = 0; i < 256; i++)
+		v = ioread8(p + i);
+	for (i = 1024; i < (5 * 1024); i += 2)
+		v = ioread16(p + i);
+	for (i = (5 * 1024); i < (16 * 1024); i += 4)
+		v = ioread32(p + i);
+}
+
+static void do_test(void)
+{
+	void __iomem *p = ioremap_nocache_trace(mmio_address, 0x4000);
+	if (!p) {
+		printk(KERN_ERR MODULE_NAME ": could not ioremap IO memory, "
+							"aborting.\n");
+		return;
+	}
+	do_write_test(p);
+	do_read_test(p);
+	iounmap_trace(p);
+}
+
+static int __init init(void)
+{
+	if (mmio_address == 0) {
+		printk(KERN_ERR MODULE_NAME ": you have to use the module "
+						"argument mmio_address.\n");
+		printk(KERN_ERR MODULE_NAME ": DO NOT LOAD THIS MODULE UNLESS"
+				" YOU REALLY KNOW WHAT YOU ARE DOING!\n");
+		return -ENXIO;
+	}
+
+	printk(KERN_WARNING MODULE_NAME ": WARNING: mapping 16 kB @ 0x%08lx "
+					"in PCI address space, and writing "
+					"rubbish in there.\n", mmio_address);
+	do_test();
+	return 0;
+}
+
+static void __exit cleanup(void)
+{
+	printk(KERN_DEBUG MODULE_NAME ": unloaded.\n");
+}
+
+module_init(init);
+module_exit(cleanup);
+MODULE_LICENSE("GPL");
diff --git a/include/linux/mmiotrace.h b/include/linux/mmiotrace.h
new file mode 100644
index 0000000..cb24782
--- /dev/null
+++ b/include/linux/mmiotrace.h
@@ -0,0 +1,62 @@
+#ifndef MMIOTRACE_H
+#define MMIOTRACE_H
+
+#include <asm/types.h>
+
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
+	__u32 type;
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
-- 
1.5.3.7

