Return-Path: <linux-kernel-owner+w=401wt.eu-S1755292AbYBEG1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292AbYBEG1A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 01:27:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751386AbYBEG0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 01:26:52 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:42003 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbYBEG0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 01:26:51 -0500
Date: Mon, 4 Feb 2008 22:26:41 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, tglx@tglx.de, hpa@zytor.com
Subject: [patch] x86: add code to dump the (kernel) page tables for visual
 inspection
Message-ID: <20080204222641.4488e6a7@laptopd505.fenrus.org>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: x86: add code to dump the (kernel) page tables for visual inspection by kernel developers
From: Arjan van de Ven <arjan@linux.intel.com>

This patch adds code to the kernel to have an (optional)
/proc/kernel_page_tables debug file that basically dumps the kernel
pagetables; this allows us kernel developers to verify that nothing fishy is
going on and that the various mappings are set up correctly. This was quite
useful in finding various change_page_attr() bugs, and is very likely to be
useful in the future as well.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 arch/x86/Kconfig.debug        |   11 +
 arch/x86/mm/Makefile_64       |    1 
 arch/x86/mm/dump_pagetables.c |  301 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 313 insertions(+)

Index: linux.trees.git/arch/x86/Kconfig.debug
===================================================================
--- linux.trees.git.orig/arch/x86/Kconfig.debug
+++ linux.trees.git/arch/x86/Kconfig.debug
@@ -70,6 +70,17 @@ config DEBUG_PER_CPU_MAPS
 
 	  Say N if unsure.
 
+config X86_PTDUMP
+	bool "Export kernel pagetable layout to userspace in /proc"
+	depends on X86_64
+	help
+	  Say Y here if you want to show the kernel pagetable layout in
+	  a /proc file. This information is only useful for kernel developers
+	  who are working in architecture specific areas of the kernel.
+	  It is probably not a good idea to enable this feature in a production
+	  kernel.
+	  If in doubt, say "N"
+
 config DEBUG_RODATA
 	bool "Write protect kernel read-only data structures"
 	default y
Index: linux.trees.git/arch/x86/mm/Makefile_64
===================================================================
--- linux.trees.git.orig/arch/x86/mm/Makefile_64
+++ linux.trees.git/arch/x86/mm/Makefile_64
@@ -7,3 +7,4 @@ obj-$(CONFIG_HUGETLB_PAGE) += hugetlbpag
 obj-$(CONFIG_NUMA) += numa_64.o
 obj-$(CONFIG_K8_NUMA) += k8topology_64.o
 obj-$(CONFIG_ACPI_NUMA) += srat_64.o
+obj-$(CONFIG_X86_PTDUMP) += dump_pagetables.o
Index: linux.trees.git/arch/x86/mm/dump_pagetables.c
===================================================================
--- /dev/null
+++ linux.trees.git/arch/x86/mm/dump_pagetables.c
@@ -0,0 +1,301 @@
+/*
+ * Debug helper to dump the current kernel pagetables of the system
+ * so that we can see what the various memory ranges are set to.
+ *
+ * (C) Copyright 2008 Intel Corporation
+ *
+ * Author: Arjan van de Ven <arjan@linux.intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#include <linux/module.h>
+#include <linux/seq_file.h>
+#include <linux/proc_fs.h>
+
+#include <asm/pgtable.h>
+
+/*
+ * The dumper groups pagetable entries of the same type into one, and for
+ * that it needs to keep some state when walking, and flush this state
+ * when a "break" in the continuity is found.
+ */
+struct pg_state {
+	int level;
+	pgprot_t current_prot;
+	unsigned long start_address;
+	unsigned long current_address;
+	int printed_vmalloc;
+	int printed_modules;
+	int printed_vmemmap;
+	int printed_highmap;
+};
+
+/* Multipliers for offsets within the PTEs */
+#define LEVEL_4_MULT (PAGE_SIZE)
+#define LEVEL_3_MULT (512UL * LEVEL_4_MULT)
+#define LEVEL_2_MULT (512UL * LEVEL_3_MULT)
+#define LEVEL_1_MULT (512UL * LEVEL_2_MULT)
+
+
+/*
+ * Print a readable form of a pgprot_t to the seq_file
+ */
+static void printk_prot(struct seq_file *m, pgprot_t prot, int level)
+{
+	unsigned long pr = pgprot_val(prot);
+
+	if (pr & _PAGE_USER)
+		seq_printf(m, "USR ");
+	else
+		seq_printf(m, "    ");
+	if (pr & _PAGE_RW)
+		seq_printf(m, "RW ");
+	else
+		seq_printf(m, "ro ");
+	if (pr & _PAGE_PWT)
+		seq_printf(m, "PWT ");
+	else
+		seq_printf(m, "    ");
+	if (pr & _PAGE_PCD)
+		seq_printf(m, "PCD ");
+	else
+		seq_printf(m, "    ");
+
+	/* Bit 9 has a different meaning on level 3 vs 4 */
+	if (level <= 3) {
+		if (pr & _PAGE_PSE)
+			seq_printf(m, "PSE ");
+		else
+			seq_printf(m, "    ");
+	} else {
+		if (pr & _PAGE_PAT)
+			seq_printf(m, "pat ");
+		else
+			seq_printf(m, "    ");
+	}
+	if (pr & _PAGE_GLOBAL)
+		seq_printf(m, "GLB ");
+	else
+		seq_printf(m, "    ");
+	if (pr & _PAGE_NX)
+		seq_printf(m, "NX ");
+	else
+		seq_printf(m, "x  ");
+}
+
+/*
+ * Sign-extend the 48 bit address to 64 bit
+ */
+static unsigned long sign_extend(unsigned long u)
+{
+	if (u>>47)
+		u = u | (0xffffUL << 48);
+	return u;
+}
+
+/*
+ * This function gets called on a break in a continuous series
+ * of PTE entries; the next one is different so we need to
+ * print what we collected so far.
+ */
+static void note_page(struct seq_file *m, struct pg_state *st,
+					pgprot_t new_prot, int level)
+{
+	unsigned long prot, cur;
+
+	/*
+	 * If we have a "break" in the series, we need to flush the state that
+	 * we have now. "break" is either changing perms or a different level.
+	 */
+	prot = pgprot_val(new_prot) & ~(PTE_MASK);
+	cur = pgprot_val(st->current_prot) & ~(PTE_MASK);
+
+	if ((prot != cur || level != st->level) &&
+				st->current_address != st->start_address) {
+		char unit = 'K';
+		unsigned long delta;
+
+		/*
+		 * We print markers for special areas of address space,
+		 * such as the start of vmalloc space etc.
+		 * This helps in the interpretation.
+		 */
+		if (!st->printed_vmalloc &&
+				st->start_address >= VMALLOC_START) {
+			seq_printf(m, "---[ VMALLOC SPACE ]---\n");
+			st->printed_vmalloc = 1;
+		}
+		if (!st->printed_modules &&
+				st->start_address >= MODULES_VADDR) {
+			seq_printf(m, "---[ MODULES SPACE ]---\n");
+			st->printed_modules = 1;
+		}
+		if (st->printed_modules < 2 &&
+				st->start_address >= MODULES_END) {
+			seq_printf(m, "---[ END MODULES SPACE ]---\n");
+			st->printed_modules = 2;
+		}
+		if (!st->printed_vmemmap &&
+				st->start_address >= VMEMMAP_START) {
+			seq_printf(m, "---[ VMMEMMAP SPACE ]---\n");
+			st->printed_vmemmap = 1;
+		}
+		if (!st->printed_highmap &&
+				st->start_address >= __START_KERNEL_map) {
+			seq_printf(m, "---[ HIGH KERNEL MAPPING ]---\n");
+			st->printed_highmap = 1;
+		}
+
+		/*
+		 * Now print the actual finished series
+		 */
+		seq_printf(m, "[ %016lx -  %016lx   ",
+				st->start_address, st->current_address);
+
+		delta = (st->current_address - st->start_address) >> 10;
+		if ((delta & 1023) == 0) {
+			delta = delta >> 10;
+			unit = 'M';
+		}
+		if (pgprot_val(st->current_prot)) {
+			seq_printf(m, "Size %9lu%cb ", delta, unit);
+			printk_prot(m, st->current_prot, st->level);
+			seq_printf(m, "L%i]\n", st->level);
+		} else {
+			/* don't print protections on non-present memory */
+			seq_printf(m, "%14lu%cb", delta, unit);
+			seq_printf(m, "                           L%i]\n",
+					st->level);
+		}
+		st->start_address = st->current_address;
+		st->current_prot = new_prot;
+		st->level = level;
+	};
+}
+
+static void walk_level_4(struct seq_file *m, struct pg_state *st, pmd_t addr,
+							unsigned long P)
+{
+	int i;
+	pte_t *start;
+
+	start = (pte_t *) pmd_page_vaddr(addr);
+	for (i = 0; i < PTRS_PER_PTE; i++) {
+		pgprot_t prot = pte_pgprot(*start);
+
+		st->current_address = sign_extend(P + i * LEVEL_4_MULT);
+		note_page(m, st, prot, 4);
+		start++;
+	}
+}
+
+
+static void walk_level_3(struct seq_file *m, struct pg_state *st, pud_t addr,
+							unsigned long P)
+{
+	int i;
+	pmd_t *start;
+
+	start = (pmd_t *) pud_page_vaddr(addr);
+	for (i = 0; i < PTRS_PER_PMD; i++) {
+		st->current_address = sign_extend(P + i * LEVEL_3_MULT);
+		if (!pmd_none(*start)) {
+			unsigned long prot;
+
+			prot = pmd_val(*start) & ~(PTE_MASK);
+			/* Deal with 2Mb pages */
+			if (pmd_large(*start))
+				note_page(m, st, __pgprot(prot), 3);
+			else
+				walk_level_4(m, st, *start,
+							P + i * LEVEL_3_MULT);
+		} else
+			note_page(m, st, __pgprot(0), 3);
+		start++;
+	}
+}
+
+
+static void walk_level_2(struct seq_file *m, struct pg_state *st, pgd_t addr,
+							unsigned long P)
+{
+	int i;
+	pud_t *start;
+
+	start = (pud_t *) pgd_page_vaddr(addr);
+
+	for (i = 0; i < PTRS_PER_PUD; i++) {
+		if (!pud_none(*start)) {
+			unsigned long prot;
+
+			prot = pud_val(*start) & ~(PTE_MASK);
+			/* Deal with 1Gb pages */
+			if (pud_large(*start))
+				note_page(m, st, __pgprot(prot), 2);
+			else
+				walk_level_3(m, st, *start,
+					P + i * LEVEL_2_MULT);
+		} else
+			note_page(m, st, __pgprot(0), 2);
+
+		start++;
+	}
+}
+
+static void walk_level_1(struct seq_file *m)
+{
+	pgd_t *start = (pgd_t *) &init_level4_pgt;
+	int i;
+	struct pg_state st;
+
+	memset(&st, 0, sizeof(st));
+	st.level = 1;
+
+	for (i = 0; i < PTRS_PER_PGD; i++) {
+		if (!pgd_none(*start))
+			walk_level_2(m, &st, *start, i * LEVEL_1_MULT);
+		else
+			note_page(m, &st, __pgprot(0), 1);
+		start++;
+	}
+}
+
+static int ptdump_show(struct seq_file *m, void *v)
+{
+	seq_puts(m, "Kernel pagetable dump\n");
+	walk_level_1(m);
+	return 0;
+}
+
+static int ptdump_open(struct inode *inode, struct file *filp)
+{
+	return single_open(filp, ptdump_show, NULL);
+}
+
+static const struct file_operations ptdump_fops = {
+	.open		= ptdump_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+int pt_dump_init(void)
+{
+	struct proc_dir_entry *pe;
+
+	pe = create_proc_entry("kernel_page_tables", 0600, NULL);
+	if (!pe)
+		return -ENOMEM;
+
+	pe->proc_fops = &ptdump_fops;
+	return 0;
+}
+
+__initcall(pt_dump_init);
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Arjan van de Ven <arjan@linux.intel.com>");
+MODULE_DESCRIPTION("Kernel debugging helper that dumps pagetables");

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
