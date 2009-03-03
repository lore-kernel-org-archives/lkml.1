Return-Path: <linux-kernel-owner+w=401wt.eu-S1755607AbZCCVQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607AbZCCVQh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 16:16:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753786AbZCCVQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 16:16:28 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37111 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753262AbZCCVQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 16:16:27 -0500
Date: Tue, 3 Mar 2009 22:16:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC git pull] tracing, x86, mmiotrace fixes
Message-ID: <20090303211613.GA453@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
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


Linus,

Please consider pulling the latest tracing/mmiotrace git tree 
from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tracing/mmiotrace

The built-in mmiotrace code got some serious testing and usage 
from the Nouveau freedesktop.org people - resulting in a number 
of fixes to this debugging/tracing facility.

The fixes are technically late but they are strictly isolated to 
the mmiotrace files only, so i thought we could apply them. 

 Thanks,

	Ingo

------------------>
Pekka Paalanen (5):
      x86: count errors in testmmiotrace.ko
      x86: add far read test to testmmiotrace
      x86 mmiotrace: fix save/restore page table state
      x86 mmiotrace: split set_page_presence()
      x86 mmiotrace: fix race with release_kmmio_fault_page()

Stuart Bennett (2):
      x86 mmiotrace: WARN_ONCE if dis/arming a page fails
      x86 mmiotrace: improve handling of secondary faults


 arch/x86/mm/kmmio.c         |  149 +++++++++++++++++++++++++++---------------
 arch/x86/mm/testmmiotrace.c |   70 ++++++++++++++++----
 2 files changed, 153 insertions(+), 66 deletions(-)

diff --git a/arch/x86/mm/kmmio.c b/arch/x86/mm/kmmio.c
index 93d8203..9f20503 100644
--- a/arch/x86/mm/kmmio.c
+++ b/arch/x86/mm/kmmio.c
@@ -32,11 +32,14 @@ struct kmmio_fault_page {
 	struct list_head list;
 	struct kmmio_fault_page *release_next;
 	unsigned long page; /* location of the fault page */
+	bool old_presence; /* page presence prior to arming */
+	bool armed;
 
 	/*
 	 * Number of times this page has been registered as a part
 	 * of a probe. If zero, page is disarmed and this may be freed.
-	 * Used only by writers (RCU).
+	 * Used only by writers (RCU) and post_kmmio_handler().
+	 * Protected by kmmio_lock, when linked into kmmio_page_table.
 	 */
 	int count;
 };
@@ -105,57 +108,85 @@ static struct kmmio_fault_page *get_kmmio_fault_page(unsigned long page)
 	return NULL;
 }
 
-static void set_page_present(unsigned long addr, bool present,
-							unsigned int *pglevel)
+static void set_pmd_presence(pmd_t *pmd, bool present, bool *old)
+{
+	pmdval_t v = pmd_val(*pmd);
+	*old = !!(v & _PAGE_PRESENT);
+	v &= ~_PAGE_PRESENT;
+	if (present)
+		v |= _PAGE_PRESENT;
+	set_pmd(pmd, __pmd(v));
+}
+
+static void set_pte_presence(pte_t *pte, bool present, bool *old)
+{
+	pteval_t v = pte_val(*pte);
+	*old = !!(v & _PAGE_PRESENT);
+	v &= ~_PAGE_PRESENT;
+	if (present)
+		v |= _PAGE_PRESENT;
+	set_pte_atomic(pte, __pte(v));
+}
+
+static int set_page_presence(unsigned long addr, bool present, bool *old)
 {
-	pteval_t pteval;
-	pmdval_t pmdval;
 	unsigned int level;
-	pmd_t *pmd;
 	pte_t *pte = lookup_address(addr, &level);
 
 	if (!pte) {
 		pr_err("kmmio: no pte for page 0x%08lx\n", addr);
-		return;
+		return -1;
 	}
 
-	if (pglevel)
-		*pglevel = level;
-
 	switch (level) {
 	case PG_LEVEL_2M:
-		pmd = (pmd_t *)pte;
-		pmdval = pmd_val(*pmd) & ~_PAGE_PRESENT;
-		if (present)
-			pmdval |= _PAGE_PRESENT;
-		set_pmd(pmd, __pmd(pmdval));
+		set_pmd_presence((pmd_t *)pte, present, old);
 		break;
-
 	case PG_LEVEL_4K:
-		pteval = pte_val(*pte) & ~_PAGE_PRESENT;
-		if (present)
-			pteval |= _PAGE_PRESENT;
-		set_pte_atomic(pte, __pte(pteval));
+		set_pte_presence(pte, present, old);
 		break;
-
 	default:
 		pr_err("kmmio: unexpected page level 0x%x.\n", level);
-		return;
+		return -1;
 	}
 
 	__flush_tlb_one(addr);
+	return 0;
 }
 
-/** Mark the given page as not present. Access to it will trigger a fault. */
-static void arm_kmmio_fault_page(unsigned long page, unsigned int *pglevel)
+/*
+ * Mark the given page as not present. Access to it will trigger a fault.
+ *
+ * Struct kmmio_fault_page is protected by RCU and kmmio_lock, but the
+ * protection is ignored here. RCU read lock is assumed held, so the struct
+ * will not disappear unexpectedly. Furthermore, the caller must guarantee,
+ * that double arming the same virtual address (page) cannot occur.
+ *
+ * Double disarming on the other hand is allowed, and may occur when a fault
+ * and mmiotrace shutdown happen simultaneously.
+ */
+static int arm_kmmio_fault_page(struct kmmio_fault_page *f)
 {
-	set_page_present(page & PAGE_MASK, false, pglevel);
+	int ret;
+	WARN_ONCE(f->armed, KERN_ERR "kmmio page already armed.\n");
+	if (f->armed) {
+		pr_warning("kmmio double-arm: page 0x%08lx, ref %d, old %d\n",
+					f->page, f->count, f->old_presence);
+	}
+	ret = set_page_presence(f->page, false, &f->old_presence);
+	WARN_ONCE(ret < 0, KERN_ERR "kmmio arming 0x%08lx failed.\n", f->page);
+	f->armed = true;
+	return ret;
 }
 
-/** Mark the given page as present. */
-static void disarm_kmmio_fault_page(unsigned long page, unsigned int *pglevel)
+/** Restore the given page to saved presence state. */
+static void disarm_kmmio_fault_page(struct kmmio_fault_page *f)
 {
-	set_page_present(page & PAGE_MASK, true, pglevel);
+	bool tmp;
+	int ret = set_page_presence(f->page, f->old_presence, &tmp);
+	WARN_ONCE(ret < 0,
+			KERN_ERR "kmmio disarming 0x%08lx failed.\n", f->page);
+	f->armed = false;
 }
 
 /*
@@ -202,28 +233,32 @@ int kmmio_handler(struct pt_regs *regs, unsigned long addr)
 
 	ctx = &get_cpu_var(kmmio_ctx);
 	if (ctx->active) {
-		disarm_kmmio_fault_page(faultpage->page, NULL);
 		if (addr == ctx->addr) {
 			/*
-			 * On SMP we sometimes get recursive probe hits on the
-			 * same address. Context is already saved, fall out.
+			 * A second fault on the same page means some other
+			 * condition needs handling by do_page_fault(), the
+			 * page really not being present is the most common.
 			 */
-			pr_debug("kmmio: duplicate probe hit on CPU %d, for "
-						"address 0x%08lx.\n",
-						smp_processor_id(), addr);
-			ret = 1;
-			goto no_kmmio_ctx;
-		}
-		/*
-		 * Prevent overwriting already in-flight context.
-		 * This should not happen, let's hope disarming at least
-		 * prevents a panic.
-		 */
-		pr_emerg("kmmio: recursive probe hit on CPU %d, "
+			pr_debug("kmmio: secondary hit for 0x%08lx CPU %d.\n",
+					addr, smp_processor_id());
+
+			if (!faultpage->old_presence)
+				pr_info("kmmio: unexpected secondary hit for "
+					"address 0x%08lx on CPU %d.\n", addr,
+					smp_processor_id());
+		} else {
+			/*
+			 * Prevent overwriting already in-flight context.
+			 * This should not happen, let's hope disarming at
+			 * least prevents a panic.
+			 */
+			pr_emerg("kmmio: recursive probe hit on CPU %d, "
 					"for address 0x%08lx. Ignoring.\n",
 					smp_processor_id(), addr);
-		pr_emerg("kmmio: previous hit was at 0x%08lx.\n",
-					ctx->addr);
+			pr_emerg("kmmio: previous hit was at 0x%08lx.\n",
+						ctx->addr);
+			disarm_kmmio_fault_page(faultpage);
+		}
 		goto no_kmmio_ctx;
 	}
 	ctx->active++;
@@ -244,7 +279,7 @@ int kmmio_handler(struct pt_regs *regs, unsigned long addr)
 	regs->flags &= ~X86_EFLAGS_IF;
 
 	/* Now we set present bit in PTE and single step. */
-	disarm_kmmio_fault_page(ctx->fpage->page, NULL);
+	disarm_kmmio_fault_page(ctx->fpage);
 
 	/*
 	 * If another cpu accesses the same page while we are stepping,
@@ -275,7 +310,7 @@ static int post_kmmio_handler(unsigned long condition, struct pt_regs *regs)
 	struct kmmio_context *ctx = &get_cpu_var(kmmio_ctx);
 
 	if (!ctx->active) {
-		pr_debug("kmmio: spurious debug trap on CPU %d.\n",
+		pr_warning("kmmio: spurious debug trap on CPU %d.\n",
 							smp_processor_id());
 		goto out;
 	}
@@ -283,7 +318,11 @@ static int post_kmmio_handler(unsigned long condition, struct pt_regs *regs)
 	if (ctx->probe && ctx->probe->post_handler)
 		ctx->probe->post_handler(ctx->probe, condition, regs);
 
-	arm_kmmio_fault_page(ctx->fpage->page, NULL);
+	/* Prevent racing against release_kmmio_fault_page(). */
+	spin_lock(&kmmio_lock);
+	if (ctx->fpage->count)
+		arm_kmmio_fault_page(ctx->fpage);
+	spin_unlock(&kmmio_lock);
 
 	regs->flags &= ~X86_EFLAGS_TF;
 	regs->flags |= ctx->saved_flags;
@@ -315,20 +354,24 @@ static int add_kmmio_fault_page(unsigned long page)
 	f = get_kmmio_fault_page(page);
 	if (f) {
 		if (!f->count)
-			arm_kmmio_fault_page(f->page, NULL);
+			arm_kmmio_fault_page(f);
 		f->count++;
 		return 0;
 	}
 
-	f = kmalloc(sizeof(*f), GFP_ATOMIC);
+	f = kzalloc(sizeof(*f), GFP_ATOMIC);
 	if (!f)
 		return -1;
 
 	f->count = 1;
 	f->page = page;
-	list_add_rcu(&f->list, kmmio_page_list(f->page));
 
-	arm_kmmio_fault_page(f->page, NULL);
+	if (arm_kmmio_fault_page(f)) {
+		kfree(f);
+		return -1;
+	}
+
+	list_add_rcu(&f->list, kmmio_page_list(f->page));
 
 	return 0;
 }
@@ -347,7 +390,7 @@ static void release_kmmio_fault_page(unsigned long page,
 	f->count--;
 	BUG_ON(f->count < 0);
 	if (!f->count) {
-		disarm_kmmio_fault_page(f->page, NULL);
+		disarm_kmmio_fault_page(f);
 		f->release_next = *release_list;
 		*release_list = f;
 	}
diff --git a/arch/x86/mm/testmmiotrace.c b/arch/x86/mm/testmmiotrace.c
index ab50a8d..427fd1b 100644
--- a/arch/x86/mm/testmmiotrace.c
+++ b/arch/x86/mm/testmmiotrace.c
@@ -1,5 +1,5 @@
 /*
- * Written by Pekka Paalanen, 2008 <pq@iki.fi>
+ * Written by Pekka Paalanen, 2008-2009 <pq@iki.fi>
  */
 #include <linux/module.h>
 #include <linux/io.h>
@@ -9,35 +9,74 @@
 
 static unsigned long mmio_address;
 module_param(mmio_address, ulong, 0);
-MODULE_PARM_DESC(mmio_address, "Start address of the mapping of 16 kB.");
+MODULE_PARM_DESC(mmio_address, " Start address of the mapping of 16 kB "
+				"(or 8 MB if read_far is non-zero).");
+
+static unsigned long read_far = 0x400100;
+module_param(read_far, ulong, 0);
+MODULE_PARM_DESC(read_far, " Offset of a 32-bit read within 8 MB "
+				"(default: 0x400100).");
+
+static unsigned v16(unsigned i)
+{
+	return i * 12 + 7;
+}
+
+static unsigned v32(unsigned i)
+{
+	return i * 212371 + 13;
+}
 
 static void do_write_test(void __iomem *p)
 {
 	unsigned int i;
+	pr_info(MODULE_NAME ": write test.\n");
 	mmiotrace_printk("Write test.\n");
+
 	for (i = 0; i < 256; i++)
 		iowrite8(i, p + i);
+
 	for (i = 1024; i < (5 * 1024); i += 2)
-		iowrite16(i * 12 + 7, p + i);
+		iowrite16(v16(i), p + i);
+
 	for (i = (5 * 1024); i < (16 * 1024); i += 4)
-		iowrite32(i * 212371 + 13, p + i);
+		iowrite32(v32(i), p + i);
 }
 
 static void do_read_test(void __iomem *p)
 {
 	unsigned int i;
+	unsigned errs[3] = { 0 };
+	pr_info(MODULE_NAME ": read test.\n");
 	mmiotrace_printk("Read test.\n");
+
 	for (i = 0; i < 256; i++)
-		ioread8(p + i);
+		if (ioread8(p + i) != i)
+			++errs[0];
+
 	for (i = 1024; i < (5 * 1024); i += 2)
-		ioread16(p + i);
+		if (ioread16(p + i) != v16(i))
+			++errs[1];
+
 	for (i = (5 * 1024); i < (16 * 1024); i += 4)
-		ioread32(p + i);
+		if (ioread32(p + i) != v32(i))
+			++errs[2];
+
+	mmiotrace_printk("Read errors: 8-bit %d, 16-bit %d, 32-bit %d.\n",
+						errs[0], errs[1], errs[2]);
 }
 
-static void do_test(void)
+static void do_read_far_test(void __iomem *p)
 {
-	void __iomem *p = ioremap_nocache(mmio_address, 0x4000);
+	pr_info(MODULE_NAME ": read far test.\n");
+	mmiotrace_printk("Read far test.\n");
+
+	ioread32(p + read_far);
+}
+
+static void do_test(unsigned long size)
+{
+	void __iomem *p = ioremap_nocache(mmio_address, size);
 	if (!p) {
 		pr_err(MODULE_NAME ": could not ioremap, aborting.\n");
 		return;
@@ -45,11 +84,15 @@ static void do_test(void)
 	mmiotrace_printk("ioremap returned %p.\n", p);
 	do_write_test(p);
 	do_read_test(p);
+	if (read_far && read_far < size - 4)
+		do_read_far_test(p);
 	iounmap(p);
 }
 
 static int __init init(void)
 {
+	unsigned long size = (read_far) ? (8 << 20) : (16 << 10);
+
 	if (mmio_address == 0) {
 		pr_err(MODULE_NAME ": you have to use the module argument "
 							"mmio_address.\n");
@@ -58,10 +101,11 @@ static int __init init(void)
 		return -ENXIO;
 	}
 
-	pr_warning(MODULE_NAME ": WARNING: mapping 16 kB @ 0x%08lx "
-					"in PCI address space, and writing "
-					"rubbish in there.\n", mmio_address);
-	do_test();
+	pr_warning(MODULE_NAME ": WARNING: mapping %lu kB @ 0x%08lx in PCI "
+		"address space, and writing 16 kB of rubbish in there.\n",
+		 size >> 10, mmio_address);
+	do_test(size);
+	pr_info(MODULE_NAME ": All done.\n");
 	return 0;
 }
 
