Return-Path: <linux-kernel-owner+w=401wt.eu-S1754308AbYC3SMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308AbYC3SMz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 14:12:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751856AbYC3SMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 14:12:46 -0400
Received: from pne-smtpout4-sn1.fre.skanova.net ([81.228.11.168]:60563 "EHLO
	pne-smtpout4-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753863AbYC3SMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 14:12:43 -0400
Date: Sun, 30 Mar 2008 21:12:37 +0300
From: Pekka Paalanen <pq@iki.fi>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: tracing and mmiotrace
Message-ID: <20080330211237.7682e027@daedalus.pq.iki.fi>
In-Reply-To: <20080323191653.388921ac@daedalus.pq.iki.fi>
References: <20080321233955.66e75a57@daedalus.pq.iki.fi>
	<20080322120746.GF13264@elte.hu>
	<20080322173245.01e69743@daedalus.pq.iki.fi>
	<Pine.LNX.4.58.0803221609550.12942@gandalf.stny.rr.com>
	<20080323191653.388921ac@daedalus.pq.iki.fi>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

another weekend, another patch. This should apply on top of my previous patch
from March 23rd.

Summary of changes:
- Print PCI device list in output header
- work around recursive probe hits on SMP
- refactor dis/arm_kmmio_fault_page() and add check for page levels
- remove un/reference_kmmio(), the die notifier hook is registered
permanently into the list
- explicitly check for single stepping in die notifier callback

I have tested this version on my UP Athlon64 desktop with Nouveau, and
SMP Core 2 Duo laptop with the proprietary nvidia driver. Both systems
are 64-bit. One previously unknown bug crept into daylight: the ftrace
framework's output routines print the first entry last after buffer has
wrapped around.

The most important regressions compared to non-ftrace mmiotrace at this
time are:
- failure of trace_pipe file
- illegal lines in output file
- unaware of losing data due to buffer full

Personally I'd like to see these three solved before submitting to
mainline. Other issues may come up once we know when we lose events.

Cheers.


Signed-off-by: Pekka Paalanen <pq@iki.fi>

---
 arch/x86/mm/kmmio.c            |  186 ++++++++++++++++-----------------------
 arch/x86/mm/mmio-mod.c         |    3 -
 include/linux/mmiotrace.h      |    2 -
 kernel/trace/trace_mmiotrace.c |   47 ++++++++++-
 4 files changed, 120 insertions(+), 118 deletions(-)

diff --git a/arch/x86/mm/kmmio.c b/arch/x86/mm/kmmio.c
index efb4679..cd0d95f 100644
--- a/arch/x86/mm/kmmio.c
+++ b/arch/x86/mm/kmmio.c
@@ -5,15 +5,12 @@
  *     2008 Pekka Paalanen <pq@iki.fi>
  */
 
-#include <linux/version.h>
 #include <linux/list.h>
 #include <linux/spinlock.h>
 #include <linux/hash.h>
 #include <linux/init.h>
 #include <linux/module.h>
-#include <linux/slab.h>
 #include <linux/kernel.h>
-#include <linux/mm.h>
 #include <linux/uaccess.h>
 #include <linux/ptrace.h>
 #include <linux/preempt.h>
@@ -22,10 +19,9 @@
 #include <linux/mutex.h>
 #include <asm/io.h>
 #include <asm/cacheflush.h>
-#include <asm/errno.h>
 #include <asm/tlbflush.h>
-#include <asm/pgtable.h>
-
+#include <asm/errno.h>
+#include <asm/debugreg.h>
 #include <linux/mmiotrace.h>
 
 #define KMMIO_PAGE_HASH_BITS 4
@@ -57,14 +53,9 @@ struct kmmio_context {
 	int active;
 };
 
-static int kmmio_die_notifier(struct notifier_block *nb, unsigned long val,
-								void *args);
-
-static DEFINE_MUTEX(kmmio_init_mutex);
 static DEFINE_SPINLOCK(kmmio_lock);
 
-/* These are protected by kmmio_lock */
-static int kmmio_initialized;
+/* Protected by kmmio_lock */
 unsigned int kmmio_count;
 
 /* Read-protected by RCU, write-protected by kmmio_lock. */
@@ -79,60 +70,6 @@ static struct list_head *kmmio_page_list(unsigned long page)
 /* Accessed per-cpu */
 static DEFINE_PER_CPU(struct kmmio_context, kmmio_ctx);
 
-/* protected by kmmio_init_mutex */
-static struct notifier_block nb_die = {
-	.notifier_call = kmmio_die_notifier
-};
-
-/**
- * Makes sure kmmio is initialized and usable.
- * This must be called before any other kmmio function defined here.
- * May sleep.
- */
-void reference_kmmio(void)
-{
-	mutex_lock(&kmmio_init_mutex);
-	spin_lock_irq(&kmmio_lock);
-	if (!kmmio_initialized) {
-		int i;
-		for (i = 0; i < KMMIO_PAGE_TABLE_SIZE; i++)
-			INIT_LIST_HEAD(&kmmio_page_table[i]);
-		if (register_die_notifier(&nb_die))
-			BUG();
-	}
-	kmmio_initialized++;
-	spin_unlock_irq(&kmmio_lock);
-	mutex_unlock(&kmmio_init_mutex);
-}
-EXPORT_SYMBOL_GPL(reference_kmmio);
-
-/**
- * Clean up kmmio after use. This must be called for every call to
- * reference_kmmio(). All probes registered after the corresponding
- * reference_kmmio() must have been unregistered when calling this.
- * May sleep.
- */
-void unreference_kmmio(void)
-{
-	bool unreg = false;
-
-	mutex_lock(&kmmio_init_mutex);
-	spin_lock_irq(&kmmio_lock);
-
-	if (kmmio_initialized == 1) {
-		BUG_ON(is_kmmio_active());
-		unreg = true;
-	}
-	kmmio_initialized--;
-	BUG_ON(kmmio_initialized < 0);
-	spin_unlock_irq(&kmmio_lock);
-
-	if (unreg)
-		unregister_die_notifier(&nb_die); /* calls sync_rcu() */
-	mutex_unlock(&kmmio_init_mutex);
-}
-EXPORT_SYMBOL(unreference_kmmio);
-
 /*
  * this is basically a dynamic stabbing problem:
  * Could use the existing prio tree code or
@@ -167,58 +104,56 @@ static struct kmmio_fault_page *get_kmmio_fault_page(unsigned long page)
 	return NULL;
 }
 
-/** Mark the given page as not present. Access to it will trigger a fault. */
-static void arm_kmmio_fault_page(unsigned long page, int *page_level)
+static void set_page_present(unsigned long addr, bool present, int *pglevel)
 {
-	unsigned long address = page & PAGE_MASK;
+	pteval_t pteval;
+	pmdval_t pmdval;
 	int level;
-	pte_t *pte = lookup_address(address, &level);
+	pmd_t *pmd;
+	pte_t *pte = lookup_address(addr, &level);
 
 	if (!pte) {
-		pr_err("kmmio: Error in %s: no pte for page 0x%08lx\n",
-							__func__, page);
+		pr_err("kmmio: no pte for page 0x%08lx\n", addr);
 		return;
 	}
 
-	if (level == PG_LEVEL_2M) {
-		pmd_t *pmd = (pmd_t *)pte;
-		set_pmd(pmd, __pmd(pmd_val(*pmd) & ~_PAGE_PRESENT));
-	} else {
-		/* PG_LEVEL_4K */
-		set_pte(pte, __pte(pte_val(*pte) & ~_PAGE_PRESENT));
+	if (pglevel)
+		*pglevel = level;
+
+	switch (level) {
+	case PG_LEVEL_2M:
+		pmd = (pmd_t *)pte;
+		pmdval = pmd_val(*pmd) & ~_PAGE_PRESENT;
+		if (present)
+			pmdval |= _PAGE_PRESENT;
+		set_pmd(pmd, __pmd(pmdval));
+		break;
+
+	case PG_LEVEL_4K:
+		pteval = pte_val(*pte) & ~_PAGE_PRESENT;
+		if (present)
+			pteval |= _PAGE_PRESENT;
+		set_pte_atomic(pte, __pte(pteval));
+		break;
+
+	default:
+		pr_err("kmmio: unexpected page level 0x%x.\n", level);
+		return;
 	}
 
-	if (page_level)
-		*page_level = level;
+	__flush_tlb_one(addr);
+}
 
-	__flush_tlb_one(page);
+/** Mark the given page as not present. Access to it will trigger a fault. */
+static void arm_kmmio_fault_page(unsigned long page, int *page_level)
+{
+	set_page_present(page & PAGE_MASK, false, page_level);
 }
 
 /** Mark the given page as present. */
 static void disarm_kmmio_fault_page(unsigned long page, int *page_level)
 {
-	unsigned long address = page & PAGE_MASK;
-	int level;
-	pte_t *pte = lookup_address(address, &level);
-
-	if (!pte) {
-		pr_err("kmmio: Error in %s: no pte for page 0x%08lx\n",
-							__func__, page);
-		return;
-	}
-
-	if (level == PG_LEVEL_2M) {
-		pmd_t *pmd = (pmd_t *)pte;
-		set_pmd(pmd, __pmd(pmd_val(*pmd) | _PAGE_PRESENT));
-	} else {
-		/* PG_LEVEL_4K */
-		set_pte(pte, __pte(pte_val(*pte) | _PAGE_PRESENT));
-	}
-
-	if (page_level)
-		*page_level = level;
-
-	__flush_tlb_one(page);
+	set_page_present(page & PAGE_MASK, true, page_level);
 }
 
 /*
@@ -240,6 +175,7 @@ int kmmio_handler(struct pt_regs *regs, unsigned long addr)
 {
 	struct kmmio_context *ctx;
 	struct kmmio_fault_page *faultpage;
+	int ret = 0; /* default to fault not handled */
 
 	/*
 	 * Preemption is now disabled to prevent process switch during
@@ -257,21 +193,35 @@ int kmmio_handler(struct pt_regs *regs, unsigned long addr)
 		/*
 		 * Either this page fault is not caused by kmmio, or
 		 * another CPU just pulled the kmmio probe from under
-		 * our feet. In the latter case all hell breaks loose.
+		 * our feet. The latter case should not be possible.
 		 */
 		goto no_kmmio;
 	}
 
 	ctx = &get_cpu_var(kmmio_ctx);
 	if (ctx->active) {
+		disarm_kmmio_fault_page(faultpage->page, NULL);
+		if (addr == ctx->addr) {
+			/*
+			 * On SMP we sometimes get recursive probe hits on the
+			 * same address. Context is already saved, fall out.
+			 */
+			pr_debug("kmmio: duplicate probe hit on CPU %d, for "
+						"address 0x%08lx.\n",
+						smp_processor_id(), addr);
+			ret = 1;
+			goto no_kmmio_ctx;
+		}
 		/*
 		 * Prevent overwriting already in-flight context.
-		 * If this page fault really was due to kmmio trap,
-		 * all hell breaks loose.
+		 * This should not happen, let's hope disarming at least
+		 * prevents a panic.
 		 */
 		pr_emerg("kmmio: recursive probe hit on CPU %d, "
 					"for address 0x%08lx. Ignoring.\n",
 					smp_processor_id(), addr);
+		pr_emerg("kmmio: previous hit was at 0x%08lx.\n",
+					ctx->addr);
 		goto no_kmmio_ctx;
 	}
 	ctx->active++;
@@ -302,14 +252,14 @@ int kmmio_handler(struct pt_regs *regs, unsigned long addr)
 	 */
 
 	put_cpu_var(kmmio_ctx);
-	return 1;
+	return 1; /* fault handled */
 
 no_kmmio_ctx:
 	put_cpu_var(kmmio_ctx);
 no_kmmio:
 	rcu_read_unlock();
 	preempt_enable_no_resched();
-	return 0; /* page fault not handled by kmmio */
+	return ret;
 }
 
 /*
@@ -322,8 +272,11 @@ static int post_kmmio_handler(unsigned long condition, struct pt_regs *regs)
 	int ret = 0;
 	struct kmmio_context *ctx = &get_cpu_var(kmmio_ctx);
 
-	if (!ctx->active)
+	if (!ctx->active) {
+		pr_debug("kmmio: spurious debug trap on CPU %d.\n",
+							smp_processor_id());
 		goto out;
+	}
 
 	if (ctx->probe && ctx->probe->post_handler)
 		ctx->probe->post_handler(ctx->probe, condition, regs);
@@ -525,9 +478,22 @@ static int kmmio_die_notifier(struct notifier_block *nb, unsigned long val,
 {
 	struct die_args *arg = args;
 
-	if (val == DIE_DEBUG)
+	if (val == DIE_DEBUG && (arg->err & DR_STEP))
 		if (post_kmmio_handler(arg->err, arg->regs) == 1)
 			return NOTIFY_STOP;
 
 	return NOTIFY_DONE;
 }
+
+static struct notifier_block nb_die = {
+	.notifier_call = kmmio_die_notifier
+};
+
+static int __init init_kmmio(void)
+{
+	int i;
+	for (i = 0; i < KMMIO_PAGE_TABLE_SIZE; i++)
+		INIT_LIST_HEAD(&kmmio_page_table[i]);
+	return register_die_notifier(&nb_die);
+}
+fs_initcall(init_kmmio); /* should be before device_initcall() */
diff --git a/arch/x86/mm/mmio-mod.c b/arch/x86/mm/mmio-mod.c
index 62abc28..8256546 100644
--- a/arch/x86/mm/mmio-mod.c
+++ b/arch/x86/mm/mmio-mod.c
@@ -415,8 +415,6 @@ void enable_mmiotrace(void)
 	if (is_enabled())
 		goto out;
 
-	reference_kmmio();
-
 #if 0 /* XXX: tracing does not support text entries */
 	marker_file = debugfs_create_file("marker", 0660, dir, NULL,
 								&fops_marker);
@@ -448,7 +446,6 @@ void disable_mmiotrace(void)
 	spin_unlock_irq(&trace_lock);
 
 	clear_trace_list(); /* guarantees: no more kmmio callbacks */
-	unreference_kmmio();
 	if (marker_file) {
 		debugfs_remove(marker_file);
 		marker_file = NULL;
diff --git a/include/linux/mmiotrace.h b/include/linux/mmiotrace.h
index c88a9c1..dd6b64b 100644
--- a/include/linux/mmiotrace.h
+++ b/include/linux/mmiotrace.h
@@ -31,8 +31,6 @@ static inline int is_kmmio_active(void)
 	return kmmio_count;
 }
 
-extern void reference_kmmio(void);
-extern void unreference_kmmio(void);
 extern int register_kmmio_probe(struct kmmio_probe *p);
 extern void unregister_kmmio_probe(struct kmmio_probe *p);
 
diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
index 3a12b1a..361472b 100644
--- a/kernel/trace/trace_mmiotrace.c
+++ b/kernel/trace/trace_mmiotrace.c
@@ -8,6 +8,7 @@
 
 #include <linux/kernel.h>
 #include <linux/mmiotrace.h>
+#include <linux/pci.h>
 
 #include "trace.h"
 
@@ -53,12 +54,52 @@ static void mmio_trace_ctrl_update(struct trace_array *tr)
 	}
 }
 
+static int mmio_print_pcidev(struct trace_seq *s, const struct pci_dev *dev)
+{
+	int ret = 0;
+	int i;
+	resource_size_t start, end;
+	const struct pci_driver *drv = pci_dev_driver(dev);
+
+	/* XXX: incomplete checks for trace_seq_printf() return value */
+	ret += trace_seq_printf(s, "PCIDEV %02x%02x %04x%04x %x",
+				dev->bus->number, dev->devfn,
+				dev->vendor, dev->device, dev->irq);
+	/*
+	 * XXX: is pci_resource_to_user() appropriate, since we are
+	 * supposed to interpret the __ioremap() phys_addr argument based on
+	 * these printed values?
+	 */
+	for (i = 0; i < 7; i++) {
+		pci_resource_to_user(dev, i, &dev->resource[i], &start, &end);
+		ret += trace_seq_printf(s, " %llx",
+			(unsigned long long)(start |
+			(dev->resource[i].flags & PCI_REGION_FLAG_MASK)));
+	}
+	for (i = 0; i < 7; i++) {
+		pci_resource_to_user(dev, i, &dev->resource[i], &start, &end);
+		ret += trace_seq_printf(s, " %llx",
+			dev->resource[i].start < dev->resource[i].end ?
+			(unsigned long long)(end - start) + 1 : 0);
+	}
+	if (drv)
+		ret += trace_seq_printf(s, " %s\n", drv->name);
+	else
+		ret += trace_seq_printf(s, " \n");
+	return ret;
+}
+
 /* XXX: This is not called for trace_pipe file! */
-void mmio_print_header(struct trace_iterator *iter)
+static void mmio_print_header(struct trace_iterator *iter)
 {
 	struct trace_seq *s = &iter->seq;
-	trace_seq_printf(s, "VERSION broken 20070824\n");
-	/* TODO: print /proc/bus/pci/devices contents as PCIDEV lines */
+	struct pci_dev *dev = NULL;
+
+	trace_seq_printf(s, "VERSION 20070824\n");
+
+	for_each_pci_dev(dev)
+		mmio_print_pcidev(s, dev);
+	/* XXX: return value? What if header is very long? */
 }
 
 static int mmio_print_rw(struct trace_iterator *iter)
