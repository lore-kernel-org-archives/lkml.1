Return-Path: <linux-kernel-owner+w=401wt.eu-S1757177AbYHUAEH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757177AbYHUAEH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 20:04:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754663AbYHUACp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 20:02:45 -0400
Received: from gw.goop.org ([64.81.55.164]:49158 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751974AbYHUACn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 20:02:43 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 2 of 4] xen: add debugfs support
X-Mercurial-Node: 63971867f079720f10e73ef83bcccc3af9c277c6
Message-Id: <63971867f079720f10e7.1219276939@localhost>
In-Reply-To: <patchbomb.1219276937@localhost>
Date: Wed, 20 Aug 2008 17:02:19 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       Jan Beulich <jbeulich@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for exporting statistics on mmu updates, multicall
batching and pv spinlocks into debugfs. The base path is xen/ and
each subsystem adds its own directory: mmu, multicalls, spinlocks.

In each directory, writing 1 to "zero_stats" will cause the
corresponding stats to be zeroed the next time they're updated.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/Kconfig      |   10 ++
 arch/x86/xen/Makefile     |    3
 arch/x86/xen/debugfs.c    |  123 +++++++++++++++++++++++++++++++++
 arch/x86/xen/debugfs.h    |   10 ++
 arch/x86/xen/mmu.c        |  163 +++++++++++++++++++++++++++++++++++++++++++-
 arch/x86/xen/multicalls.c |  115 ++++++++++++++++++++++++++++++-
 arch/x86/xen/spinlock.c   |  165 ++++++++++++++++++++++++++++++++++++++++++++-
 7 files changed, 580 insertions(+), 9 deletions(-)

diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
--- a/arch/x86/xen/Kconfig
+++ b/arch/x86/xen/Kconfig
@@ -27,4 +27,12 @@
 config XEN_SAVE_RESTORE
        bool
        depends on PM
-       default y
\ No newline at end of file
+       default y
+
+config XEN_DEBUG_FS
+	bool "Enable Xen debug and tuning parameters in debugfs"
+	depends on XEN && DEBUG_FS
+	default n
+	help
+	  Enable statistics output and various tuning options in debugfs.
+	  Enabling this option may incur a significant performance overhead.
\ No newline at end of file
diff --git a/arch/x86/xen/Makefile b/arch/x86/xen/Makefile
--- a/arch/x86/xen/Makefile
+++ b/arch/x86/xen/Makefile
@@ -8,4 +8,5 @@
 obj-y		:= enlighten.o setup.o multicalls.o mmu.o irq.o \
 			time.o xen-asm_$(BITS).o grant-table.o suspend.o
 
-obj-$(CONFIG_SMP)	+= smp.o spinlock.o
+obj-$(CONFIG_SMP)		+= smp.o spinlock.o
+obj-$(CONFIG_XEN_DEBUG_FS)	+= debugfs.o
\ No newline at end of file
diff --git a/arch/x86/xen/debugfs.c b/arch/x86/xen/debugfs.c
new file mode 100644
--- /dev/null
+++ b/arch/x86/xen/debugfs.c
@@ -0,0 +1,123 @@
+#include <linux/init.h>
+#include <linux/debugfs.h>
+#include <linux/module.h>
+
+#include "debugfs.h"
+
+static struct dentry *d_xen_debug;
+
+struct dentry * __init xen_init_debugfs(void)
+{
+	if (!d_xen_debug) {
+		d_xen_debug = debugfs_create_dir("xen", NULL);
+
+		if (!d_xen_debug)
+			pr_warning("Could not create 'xen' debugfs directory\n");
+	}
+
+	return d_xen_debug;
+}
+
+struct array_data
+{
+	void *array;
+	unsigned elements;
+};
+
+static int u32_array_open(struct inode *inode, struct file *file)
+{
+	file->private_data = NULL;
+	return nonseekable_open(inode, file);
+}
+
+static size_t format_array(char *buf, size_t bufsize, const char *fmt,
+			   u32 *array, unsigned array_size)
+{
+	size_t ret = 0;
+	unsigned i;
+
+	for(i = 0; i < array_size; i++) {
+		size_t len;
+
+		len = snprintf(buf, bufsize, fmt, array[i]);
+		len++;	/* ' ' or '\n' */
+		ret += len;
+
+		if (buf) {
+			buf += len;
+			bufsize -= len;
+			buf[-1] = (i == array_size-1) ? '\n' : ' ';
+		}
+	}
+
+	ret++;		/* \0 */
+	if (buf)
+		*buf = '\0';
+
+	return ret;
+}
+
+static char *format_array_alloc(const char *fmt, u32 *array, unsigned array_size)
+{
+	size_t len = format_array(NULL, 0, fmt, array, array_size);
+	char *ret;
+
+	ret = kmalloc(len, GFP_KERNEL);
+	if (ret == NULL)
+		return NULL;
+
+	format_array(ret, len, fmt, array, array_size);
+	return ret;
+}
+
+static ssize_t u32_array_read(struct file *file, char __user *buf, size_t len,
+			      loff_t *ppos)
+{
+	struct inode *inode = file->f_path.dentry->d_inode;
+	struct array_data *data = inode->i_private;
+	size_t size;
+
+	if (*ppos == 0) {
+		if (file->private_data) {
+			kfree(file->private_data);
+			file->private_data = NULL;
+		}
+
+		file->private_data = format_array_alloc("%u", data->array, data->elements);
+	}
+
+	size = 0;
+	if (file->private_data)
+		size = strlen(file->private_data);
+
+	return simple_read_from_buffer(buf, len, ppos, file->private_data, size);
+}
+
+static int xen_array_release(struct inode *inode, struct file *file)
+{
+	kfree(file->private_data);
+
+	return 0;
+}
+
+static struct file_operations u32_array_fops = {
+	.owner	= THIS_MODULE,
+	.open	= u32_array_open,
+	.release= xen_array_release,
+	.read	= u32_array_read,
+};
+
+struct dentry *xen_debugfs_create_u32_array(const char *name, mode_t mode,
+					    struct dentry *parent,
+					    u32 *array, unsigned elements)
+{
+	struct array_data *data = kmalloc(sizeof(*data), GFP_KERNEL);
+
+	if (data == NULL)
+		return NULL;
+
+	data->array = array;
+	data->elements = elements;
+
+	return debugfs_create_file(name, mode, parent, data, &u32_array_fops);
+}
diff --git a/arch/x86/xen/debugfs.h b/arch/x86/xen/debugfs.h
new file mode 100644
--- /dev/null
+++ b/arch/x86/xen/debugfs.h
@@ -0,0 +1,10 @@
+#ifndef _XEN_DEBUGFS_H
+#define _XEN_DEBUGFS_H
+
+struct dentry * __init xen_init_debugfs(void);
+
+struct dentry *xen_debugfs_create_u32_array(const char *name, mode_t mode,
+					    struct dentry *parent,
+					    u32 *array, unsigned elements);
+
+#endif /* _XEN_DEBUGFS_H */
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -40,6 +40,7 @@
  */
 #include <linux/sched.h>
 #include <linux/highmem.h>
+#include <linux/debugfs.h>
 #include <linux/bug.h>
 
 #include <asm/pgtable.h>
@@ -57,6 +58,61 @@
 
 #include "multicalls.h"
 #include "mmu.h"
+#include "debugfs.h"
+
+#define MMU_UPDATE_HISTO	30
+
+#ifdef CONFIG_XEN_DEBUG_FS
+
+static struct {
+	u32 pgd_update;
+	u32 pgd_update_pinned;
+	u32 pgd_update_batched;
+
+	u32 pud_update;
+	u32 pud_update_pinned;
+	u32 pud_update_batched;
+
+	u32 pmd_update;
+	u32 pmd_update_pinned;
+	u32 pmd_update_batched;
+
+	u32 pte_update;
+	u32 pte_update_pinned;
+	u32 pte_update_batched;
+
+	u32 mmu_update;
+	u32 mmu_update_extended;
+	u32 mmu_update_histo[MMU_UPDATE_HISTO];
+
+	u32 prot_commit;
+	u32 prot_commit_batched;
+
+	u32 set_pte_at;
+	u32 set_pte_at_batched;
+	u32 set_pte_at_pinned;
+	u32 set_pte_at_current;
+	u32 set_pte_at_kernel;
+} mmu_stats;
+
+static u8 zero_stats;
+
+static inline void check_zero(void)
+{
+	if (unlikely(zero_stats)) {
+		memset(&mmu_stats, 0, sizeof(mmu_stats));
+		zero_stats = 0;
+	}
+}
+
+#define ADD_STATS(elem, val)			\
+	do { check_zero(); mmu_stats.elem += (val); } while(0)
+
+#else  /* !CONFIG_XEN_DEBUG_FS */
+
+#define ADD_STATS(elem, val)	do { (void)(val); } while(0)
+
+#endif /* CONFIG_XEN_DEBUG_FS */
 
 /*
  * Just beyond the highest usermode address.  STACK_TOP_MAX has a
@@ -243,11 +299,21 @@
 
 	mcs = xen_mc_extend_args(__HYPERVISOR_mmu_update, sizeof(*u));
 
-	if (mcs.mc != NULL)
+	if (mcs.mc != NULL) {
+		ADD_STATS(mmu_update_extended, 1);
+		ADD_STATS(mmu_update_histo[mcs.mc->args[1]], -1);
+
 		mcs.mc->args[1]++;
-	else {
+
+		if (mcs.mc->args[1] < MMU_UPDATE_HISTO)
+			ADD_STATS(mmu_update_histo[mcs.mc->args[1]], 1);
+		else
+			ADD_STATS(mmu_update_histo[0], 1);
+	} else {
+		ADD_STATS(mmu_update, 1);
 		mcs = __xen_mc_entry(sizeof(*u));
 		MULTI_mmu_update(mcs.mc, mcs.args, 1, NULL, DOMID_SELF);
+		ADD_STATS(mmu_update_histo[1], 1);
 	}
 
 	u = mcs.args;
@@ -267,6 +333,8 @@
 	u.val = pmd_val_ma(val);
 	xen_extend_mmu_update(&u);
 
+	ADD_STATS(pmd_update_batched, paravirt_get_lazy_mode() == PARAVIRT_LAZY_MMU);
+
 	xen_mc_issue(PARAVIRT_LAZY_MMU);
 
 	preempt_enable();
@@ -274,12 +342,16 @@
 
 void xen_set_pmd(pmd_t *ptr, pmd_t val)
 {
+	ADD_STATS(pmd_update, 1);
+
 	/* If page is not pinned, we can just update the entry
 	   directly */
 	if (!xen_page_pinned(ptr)) {
 		*ptr = val;
 		return;
 	}
+
+	ADD_STATS(pmd_update_pinned, 1);
 
 	xen_set_pmd_hyper(ptr, val);
 }
@@ -300,12 +372,18 @@
 	if (mm == &init_mm)
 		preempt_disable();
 
+	ADD_STATS(set_pte_at, 1);
+//	ADD_STATS(set_pte_at_pinned, xen_page_pinned(ptep));
+	ADD_STATS(set_pte_at_current, mm == current->mm);
+	ADD_STATS(set_pte_at_kernel, mm == &init_mm);
+
 	if (mm == current->mm || mm == &init_mm) {
 		if (paravirt_get_lazy_mode() == PARAVIRT_LAZY_MMU) {
 			struct multicall_space mcs;
 			mcs = xen_mc_entry(0);
 
 			MULTI_update_va_mapping(mcs.mc, addr, pteval, 0);
+			ADD_STATS(set_pte_at_batched, 1);
 			xen_mc_issue(PARAVIRT_LAZY_MMU);
 			goto out;
 		} else
@@ -335,6 +413,9 @@
 	u.ptr = virt_to_machine(ptep).maddr | MMU_PT_UPDATE_PRESERVE_AD;
 	u.val = pte_val_ma(pte);
 	xen_extend_mmu_update(&u);
+
+	ADD_STATS(prot_commit, 1);
+	ADD_STATS(prot_commit_batched, paravirt_get_lazy_mode() == PARAVIRT_LAZY_MMU);
 
 	xen_mc_issue(PARAVIRT_LAZY_MMU);
 }
@@ -402,6 +483,8 @@
 	u.val = pud_val_ma(val);
 	xen_extend_mmu_update(&u);
 
+	ADD_STATS(pud_update_batched, paravirt_get_lazy_mode() == PARAVIRT_LAZY_MMU);
+
 	xen_mc_issue(PARAVIRT_LAZY_MMU);
 
 	preempt_enable();
@@ -409,6 +492,8 @@
 
 void xen_set_pud(pud_t *ptr, pud_t val)
 {
+	ADD_STATS(pud_update, 1);
+
 	/* If page is not pinned, we can just update the entry
 	   directly */
 	if (!xen_page_pinned(ptr)) {
@@ -416,11 +501,17 @@
 		return;
 	}
 
+	ADD_STATS(pud_update_pinned, 1);
+
 	xen_set_pud_hyper(ptr, val);
 }
 
 void xen_set_pte(pte_t *ptep, pte_t pte)
 {
+	ADD_STATS(pte_update, 1);
+//	ADD_STATS(pte_update_pinned, xen_page_pinned(ptep));
+	ADD_STATS(pte_update_batched, paravirt_get_lazy_mode() == PARAVIRT_LAZY_MMU);
+
 #ifdef CONFIG_X86_PAE
 	ptep->pte_high = pte.pte_high;
 	smp_wmb();
@@ -517,6 +608,8 @@
 {
 	pgd_t *user_ptr = xen_get_user_pgd(ptr);
 
+	ADD_STATS(pgd_update, 1);
+
 	/* If page is not pinned, we can just update the entry
 	   directly */
 	if (!xen_page_pinned(ptr)) {
@@ -527,6 +620,9 @@
 		}
 		return;
 	}
+
+	ADD_STATS(pgd_update_pinned, 1);
+	ADD_STATS(pgd_update_batched, paravirt_get_lazy_mode() == PARAVIRT_LAZY_MMU);
 
 	/* If it's pinned, then we can at least batch the kernel and
 	   user updates together. */
@@ -1003,3 +1099,66 @@
 
 	spin_unlock(&mm->page_table_lock);
 }
+
+#ifdef CONFIG_XEN_DEBUG_FS
+
+static struct dentry *d_mmu_debug;
+
+static int __init xen_mmu_debugfs(void)
+{
+	struct dentry *d_xen = xen_init_debugfs();
+
+	if (d_xen == NULL)
+		return -ENOMEM;
+
+	d_mmu_debug = debugfs_create_dir("mmu", d_xen);
+
+	debugfs_create_u8("zero_stats", 0644, d_mmu_debug, &zero_stats);
+
+	debugfs_create_u32("pgd_update", 0444, d_mmu_debug, &mmu_stats.pgd_update);
+	debugfs_create_u32("pgd_update_pinned", 0444, d_mmu_debug,
+			   &mmu_stats.pgd_update_pinned);
+	debugfs_create_u32("pgd_update_batched", 0444, d_mmu_debug,
+			   &mmu_stats.pgd_update_pinned);
+
+	debugfs_create_u32("pud_update", 0444, d_mmu_debug, &mmu_stats.pud_update);
+	debugfs_create_u32("pud_update_pinned", 0444, d_mmu_debug,
+			   &mmu_stats.pud_update_pinned);
+	debugfs_create_u32("pud_update_batched", 0444, d_mmu_debug,
+			   &mmu_stats.pud_update_pinned);
+
+	debugfs_create_u32("pmd_update", 0444, d_mmu_debug, &mmu_stats.pmd_update);
+	debugfs_create_u32("pmd_update_pinned", 0444, d_mmu_debug,
+			   &mmu_stats.pmd_update_pinned);
+	debugfs_create_u32("pmd_update_batched", 0444, d_mmu_debug,
+			   &mmu_stats.pmd_update_pinned);
+
+	debugfs_create_u32("pte_update", 0444, d_mmu_debug, &mmu_stats.pte_update);
+//	debugfs_create_u32("pte_update_pinned", 0444, d_mmu_debug,
+//			   &mmu_stats.pte_update_pinned);
+	debugfs_create_u32("pte_update_batched", 0444, d_mmu_debug,
+			   &mmu_stats.pte_update_pinned);
+
+	debugfs_create_u32("mmu_update", 0444, d_mmu_debug, &mmu_stats.mmu_update);
+	debugfs_create_u32("mmu_update_extended", 0444, d_mmu_debug,
+			   &mmu_stats.mmu_update_extended);
+	xen_debugfs_create_u32_array("mmu_update_histo", 0444, d_mmu_debug,
+				     mmu_stats.mmu_update_histo, 20);
+
+	debugfs_create_u32("set_pte_at", 0444, d_mmu_debug, &mmu_stats.set_pte_at);
+	debugfs_create_u32("set_pte_at_batched", 0444, d_mmu_debug,
+			   &mmu_stats.set_pte_at_batched);
+	debugfs_create_u32("set_pte_at_current", 0444, d_mmu_debug,
+			   &mmu_stats.set_pte_at_current);
+	debugfs_create_u32("set_pte_at_kernel", 0444, d_mmu_debug,
+			   &mmu_stats.set_pte_at_kernel);
+
+	debugfs_create_u32("prot_commit", 0444, d_mmu_debug, &mmu_stats.prot_commit);
+	debugfs_create_u32("prot_commit_batched", 0444, d_mmu_debug,
+			   &mmu_stats.prot_commit_batched);
+
+	return 0;
+}
+fs_initcall(xen_mmu_debugfs);
+
+#endif	/* CONFIG_XEN_DEBUG_FS */
diff --git a/arch/x86/xen/multicalls.c b/arch/x86/xen/multicalls.c
--- a/arch/x86/xen/multicalls.c
+++ b/arch/x86/xen/multicalls.c
@@ -21,15 +21,19 @@
  */
 #include <linux/percpu.h>
 #include <linux/hardirq.h>
+#include <linux/debugfs.h>
 
 #include <asm/xen/hypercall.h>
 
 #include "multicalls.h"
+#include "debugfs.h"
+
+#define MC_BATCH	32
 
 #define MC_DEBUG	1
 
-#define MC_BATCH	32
 #define MC_ARGS		(MC_BATCH * 16)
+
 
 struct mc_buffer {
 	struct multicall_entry entries[MC_BATCH];
@@ -47,6 +51,76 @@
 static DEFINE_PER_CPU(struct mc_buffer, mc_buffer);
 DEFINE_PER_CPU(unsigned long, xen_mc_irq_flags);
 
+/* flush reasons 0- slots, 1- args, 2- callbacks */
+enum flush_reasons
+{
+	FL_SLOTS,
+	FL_ARGS,
+	FL_CALLBACKS,
+
+	FL_N_REASONS
+};
+
+#ifdef CONFIG_XEN_DEBUG_FS
+#define NHYPERCALLS	40		/* not really */
+
+static struct {
+	unsigned histo[MC_BATCH+1];
+
+	unsigned issued;
+	unsigned arg_total;
+	unsigned hypercalls;
+	unsigned histo_hypercalls[NHYPERCALLS];
+
+	unsigned flush[FL_N_REASONS];
+} mc_stats;
+
+static u8 zero_stats;
+
+static inline void check_zero(void)
+{
+	if (unlikely(zero_stats)) {
+		memset(&mc_stats, 0, sizeof(mc_stats));
+		zero_stats = 0;
+	}
+}
+
+static void mc_add_stats(const struct mc_buffer *mc)
+{
+	int i;
+
+	check_zero();
+
+	mc_stats.issued++;
+	mc_stats.hypercalls += mc->mcidx;
+	mc_stats.arg_total += mc->argidx;
+
+	mc_stats.histo[mc->mcidx]++;
+	for(i = 0; i < mc->mcidx; i++) {
+		unsigned op = mc->entries[i].op;
+		if (op < NHYPERCALLS)
+			mc_stats.histo_hypercalls[op]++;
+	}
+}
+
+static void mc_stats_flush(enum flush_reasons idx)
+{
+	check_zero();
+
+	mc_stats.flush[idx]++;
+}
+
+#else  /* !CONFIG_XEN_DEBUG_FS */
+
+static inline void mc_add_stats(const struct mc_buffer *mc)
+{
+}
+
+static inline void mc_stats_flush(enum flush_reasons idx)
+{
+}
+#endif	/* CONFIG_XEN_DEBUG_FS */
+
 void xen_mc_flush(void)
 {
 	struct mc_buffer *b = &__get_cpu_var(mc_buffer);
@@ -59,6 +133,8 @@
 	/* Disable interrupts in case someone comes in and queues
 	   something in the middle */
 	local_irq_save(flags);
+
+	mc_add_stats(b);
 
 	if (b->mcidx) {
 #if MC_DEBUG
@@ -115,6 +191,7 @@
 
 	if (b->mcidx == MC_BATCH ||
 	    (argidx + args) > MC_ARGS) {
+		mc_stats_flush(b->mcidx == MC_BATCH ? FL_SLOTS : FL_ARGS);
 		xen_mc_flush();
 		argidx = roundup(b->argidx, sizeof(u64));
 	}
@@ -158,10 +235,44 @@
 	struct mc_buffer *b = &__get_cpu_var(mc_buffer);
 	struct callback *cb;
 
-	if (b->cbidx == MC_BATCH)
+	if (b->cbidx == MC_BATCH) {
+		mc_stats_flush(FL_CALLBACKS);
 		xen_mc_flush();
+	}
 
 	cb = &b->callbacks[b->cbidx++];
 	cb->fn = fn;
 	cb->data = data;
 }
+
+#ifdef CONFIG_XEN_DEBUG_FS
+
+static struct dentry *d_mc_debug;
+
+static int __init xen_mc_debugfs(void)
+{
+	struct dentry *d_xen = xen_init_debugfs();
+
+	if (d_xen == NULL)
+		return -ENOMEM;
+
+	d_mc_debug = debugfs_create_dir("multicalls", d_xen);
+
+	debugfs_create_u8("zero_stats", 0644, d_mc_debug, &zero_stats);
+
+	debugfs_create_u32("batches", 0444, d_mc_debug, &mc_stats.issued);
+	debugfs_create_u32("hypercalls", 0444, d_mc_debug, &mc_stats.hypercalls);
+	debugfs_create_u32("arg_total", 0444, d_mc_debug, &mc_stats.arg_total);
+
+	xen_debugfs_create_u32_array("batch_histo", 0444, d_mc_debug,
+				     mc_stats.histo, MC_BATCH);
+	xen_debugfs_create_u32_array("hypercall_histo", 0444, d_mc_debug,
+				     mc_stats.histo_hypercalls, NHYPERCALLS);
+	xen_debugfs_create_u32_array("flush_reasons", 0444, d_mc_debug,
+				     mc_stats.flush, FL_N_REASONS);
+
+	return 0;
+}
+fs_initcall(xen_mc_debugfs);
+
+#endif	/* CONFIG_XEN_DEBUG_FS */
diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -4,6 +4,8 @@
  */
 #include <linux/kernel_stat.h>
 #include <linux/spinlock.h>
+#include <linux/debugfs.h>
+#include <linux/log2.h>
 
 #include <asm/paravirt.h>
 
@@ -11,6 +13,93 @@
 #include <xen/events.h>
 
 #include "xen-ops.h"
+#include "debugfs.h"
+
+#ifdef CONFIG_XEN_DEBUG_FS
+static struct xen_spinlock_stats
+{
+	u64 taken;
+	u32 taken_slow;
+	u32 taken_slow_nested;
+	u32 taken_slow_pickup;
+	u32 taken_slow_spurious;
+
+	u64 released;
+	u32 released_slow;
+	u32 released_slow_kicked;
+
+#define HISTO_BUCKETS	20
+	u32 histo_spin_fast[HISTO_BUCKETS+1];
+	u32 histo_spin[HISTO_BUCKETS+1];
+
+	u64 spinning_time;
+	u64 total_time;
+} spinlock_stats;
+
+static u8 zero_stats;
+
+static unsigned lock_timeout = 1 << 10;
+#define TIMEOUT lock_timeout
+
+static inline void check_zero(void)
+{
+	if (unlikely(zero_stats)) {
+		memset(&spinlock_stats, 0, sizeof(spinlock_stats));
+		zero_stats = 0;
+	}
+}
+
+#define ADD_STATS(elem, val)			\
+	do { check_zero(); spinlock_stats.elem += (val); } while(0)
+
+static inline u64 spin_time_start(void)
+{
+	return xen_clocksource_read();
+}
+
+static void __spin_time_accum(u64 delta, u32 *array)
+{
+	unsigned index = ilog2(delta);
+
+	check_zero();
+
+	if (index < HISTO_BUCKETS)
+		array[index]++;
+	else
+		array[HISTO_BUCKETS]++;
+}
+
+static inline void spin_time_accum_fast(u64 start)
+{
+	u32 delta = xen_clocksource_read() - start;
+
+	__spin_time_accum(delta, spinlock_stats.histo_spin_fast);
+	spinlock_stats.spinning_time += delta;
+}
+
+static inline void spin_time_accum(u64 start)
+{
+	u32 delta = xen_clocksource_read() - start;
+
+	__spin_time_accum(delta, spinlock_stats.histo_spin);
+	spinlock_stats.total_time += delta;
+}
+#else  /* !CONFIG_XEN_DEBUG_FS */
+#define TIMEOUT			(1 << 10)
+#define ADD_STATS(elem, val)	do { (void)(val); } while(0)
+
+static inline u64 spin_time_start(void)
+{
+	return 0;
+}
+
+static inline void spin_time_accum_fast(u64 start)
+{
+}
+static inline void spin_time_accum(u64 start)
+{
+}
+#endif  /* CONFIG_XEN_DEBUG_FS */
 
 struct xen_spinlock {
 	unsigned char lock;		/* 0 -> free; 1 -> locked */
@@ -92,6 +181,9 @@
 	/* announce we're spinning */
 	prev = spinning_lock(xl);
 
+	ADD_STATS(taken_slow, 1);
+	ADD_STATS(taken_slow_nested, prev != NULL);
+
 	do {
 		/* clear pending */
 		xen_clear_irq_pending(irq);
@@ -100,6 +192,8 @@
 		   we weren't looking  */
 		ret = xen_spin_trylock(lock);
 		if (ret) {
+			ADD_STATS(taken_slow_pickup, 1);
+
 			/*
 			 * If we interrupted another spinlock while it
 			 * was blocking, make sure it doesn't block
@@ -120,6 +214,7 @@
 		 * pending.
 		 */
 		xen_poll_irq(irq);
+		ADD_STATS(taken_slow_spurious, !xen_test_irq_pending(irq));
 	} while (!xen_test_irq_pending(irq)); /* check for spurious wakeups */
 
 	kstat_irqs_this_cpu(irq_to_desc(irq))++;
@@ -132,11 +227,18 @@
 static void xen_spin_lock(struct raw_spinlock *lock)
 {
 	struct xen_spinlock *xl = (struct xen_spinlock *)lock;
-	int timeout;
+	unsigned timeout;
 	u8 oldval;
+	u64 start_spin;
+
+	ADD_STATS(taken, 1);
+
+	start_spin = spin_time_start();
 
 	do {
-		timeout = 1 << 10;
+		u64 start_spin_fast = spin_time_start();
+
+		timeout = TIMEOUT;
 
 		asm("1: xchgb %1,%0\n"
 		    "   testb %1,%1\n"
@@ -151,16 +253,22 @@
 		    : "1" (1)
 		    : "memory");
 
-	} while (unlikely(oldval != 0 && !xen_spin_lock_slow(lock)));
+		spin_time_accum_fast(start_spin_fast);
+	} while (unlikely(oldval != 0 && (TIMEOUT == ~0 || !xen_spin_lock_slow(lock))));
+
+	spin_time_accum(start_spin);
 }
 
 static noinline void xen_spin_unlock_slow(struct xen_spinlock *xl)
 {
 	int cpu;
 
+	ADD_STATS(released_slow, 1);
+
 	for_each_online_cpu(cpu) {
 		/* XXX should mix up next cpu selection */
 		if (per_cpu(lock_spinners, cpu) == xl) {
+			ADD_STATS(released_slow_kicked, 1);
 			xen_send_IPI_one(cpu, XEN_SPIN_UNLOCK_VECTOR);
 			break;
 		}
@@ -170,6 +278,8 @@
 static void xen_spin_unlock(struct raw_spinlock *lock)
 {
 	struct xen_spinlock *xl = (struct xen_spinlock *)lock;
+
+	ADD_STATS(released, 1);
 
 	smp_wmb();		/* make sure no writes get moved after unlock */
 	xl->lock = 0;		/* release lock */
@@ -216,3 +326,52 @@
 	pv_lock_ops.spin_trylock = xen_spin_trylock;
 	pv_lock_ops.spin_unlock = xen_spin_unlock;
 }
+
+#ifdef CONFIG_XEN_DEBUG_FS
+
+static struct dentry *d_spin_debug;
+
+static int __init xen_spinlock_debugfs(void)
+{
+	struct dentry *d_xen = xen_init_debugfs();
+
+	if (d_xen == NULL)
+		return -ENOMEM;
+
+	d_spin_debug = debugfs_create_dir("spinlocks", d_xen);
+
+	debugfs_create_u8("zero_stats", 0644, d_spin_debug, &zero_stats);
+
+	debugfs_create_u32("timeout", 0644, d_spin_debug, &lock_timeout);
+
+	debugfs_create_u64("taken", 0444, d_spin_debug, &spinlock_stats.taken);
+	debugfs_create_u32("taken_slow", 0444, d_spin_debug,
+			   &spinlock_stats.taken_slow);
+	debugfs_create_u32("taken_slow_nested", 0444, d_spin_debug,
+			   &spinlock_stats.taken_slow_nested);
+	debugfs_create_u32("taken_slow_pickup", 0444, d_spin_debug,
+			   &spinlock_stats.taken_slow_pickup);
+	debugfs_create_u32("taken_slow_spurious", 0444, d_spin_debug,
+			   &spinlock_stats.taken_slow_spurious);
+
+	debugfs_create_u64("released", 0444, d_spin_debug, &spinlock_stats.released);
+	debugfs_create_u32("released_slow", 0444, d_spin_debug,
+			   &spinlock_stats.released_slow);
+	debugfs_create_u32("released_slow_kicked", 0444, d_spin_debug,
+			   &spinlock_stats.released_slow_kicked);
+
+	debugfs_create_u64("time_spinning", 0444, d_spin_debug,
+			   &spinlock_stats.spinning_time);
+	debugfs_create_u64("time_total", 0444, d_spin_debug,
+			   &spinlock_stats.total_time);
+
+	xen_debugfs_create_u32_array("histo_total", 0444, d_spin_debug,
+				     spinlock_stats.histo_spin, HISTO_BUCKETS + 1);
+	xen_debugfs_create_u32_array("histo_spinning", 0444, d_spin_debug,
+				     spinlock_stats.histo_spin_fast, HISTO_BUCKETS + 1);
+
+	return 0;
+}
+fs_initcall(xen_spinlock_debugfs);
+
+#endif	/* CONFIG_XEN_DEBUG_FS */


