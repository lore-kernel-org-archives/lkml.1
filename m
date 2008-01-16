Return-Path: <linux-kernel-owner+w=401wt.eu-S1754118AbYAPWUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118AbYAPWUY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 17:20:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754080AbYAPWPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 17:15:22 -0500
Received: from ns1.suse.de ([195.135.220.2]:55203 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753922AbYAPWPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 17:15:14 -0500
From: Andi Kleen <ak@suse.de>
References: <200801161114.239449000@suse.de>
In-Reply-To: <200801161114.239449000@suse.de>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       jbeulich@novell.com, venkatesh.pallipadi@intel.com
Subject: [PATCH] [14/36] CPA: Add simple self test at boot
Message-Id: <20080116221513.458C7150C8@wotan.suse.de>
Date: Wed, 16 Jan 2008 23:15:13 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Since change_page_attr() is tricky code it is good to have some regression
test code. This patch maps and unmaps some random pages in the direct mapping
at boot and then dumps the state and does some simple sanity checks.

Add it with a CONFIG option.

Optional patch, but I find it useful.

Signed-off-by: Andi Kleen <ak@suse.de>
Acked-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/mm/Makefile_32     |    1 
 arch/x86/mm/Makefile_64     |    1 
 arch/x86/mm/pageattr-test.c |  233 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 235 insertions(+)

Index: linux/arch/x86/mm/Makefile_64
===================================================================
--- linux.orig/arch/x86/mm/Makefile_64
+++ linux/arch/x86/mm/Makefile_64
@@ -7,3 +7,4 @@ obj-$(CONFIG_HUGETLB_PAGE) += hugetlbpag
 obj-$(CONFIG_NUMA) += numa_64.o
 obj-$(CONFIG_K8_NUMA) += k8topology_64.o
 obj-$(CONFIG_ACPI_NUMA) += srat_64.o
+obj-$(CONFIG_CPA_DEBUG) += pageattr-test.o
Index: linux/arch/x86/mm/pageattr-test.c
===================================================================
--- /dev/null
+++ linux/arch/x86/mm/pageattr-test.c
@@ -0,0 +1,233 @@
+/*
+ * self test for change_page_attr.
+ *
+ * Clears the global bit on random pages in the direct mapping, then reverts
+ * and compares page tables forwards and afterwards.
+ */
+
+#include <linux/mm.h>
+#include <linux/random.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/bootmem.h>
+#include <asm/cacheflush.h>
+#include <asm/pgtable.h>
+#include <asm/kdebug.h>
+
+enum {
+	NTEST = 400,
+#ifdef CONFIG_X86_64
+	LOWEST_LEVEL = 4,
+	LPS = (1 << PMD_SHIFT),
+#elif defined(CONFIG_X86_PAE)
+	LOWEST_LEVEL = 3,
+	LPS = (1 << PMD_SHIFT),
+#else
+	LOWEST_LEVEL = 3, /* lookup_address lies here */
+	LPS = (1 << 22),
+#endif
+	GPS = (1<<30)
+};
+
+#ifdef CONFIG_X86_64
+#include <asm/proto.h>
+#define max_mapped end_pfn_map
+#else
+#define max_mapped max_low_pfn
+#endif
+
+struct split_state {
+	long lpg, gpg, spg, exec;
+	long min_exec, max_exec;
+};
+
+static __init int print_split(struct split_state *s)
+{
+	int printed = 0;
+	long i, expected, missed = 0;
+	int err = 0;
+
+	s->lpg = s->gpg = s->spg = s->exec = 0;
+	s->min_exec = ~0UL;
+	s->max_exec = 0;
+	for (i = 0; i < max_mapped; ) {
+		int level;
+		pte_t *pte;
+		unsigned long adr = (unsigned long)__va(i << PAGE_SHIFT);
+
+		pte = lookup_address(adr, &level);
+		if (!pte) {
+			if (!printed) {
+				dump_pagetable(adr);
+				printk("CPA %lx no pte level %d\n", adr, level);
+				printed = 1;
+			}
+			missed++;
+			i++;
+			continue;
+		}
+
+		if (level == 2 && sizeof(long) == 8) {
+			s->gpg++;
+			i += GPS/PAGE_SIZE;
+		} else if (level != LOWEST_LEVEL) {
+			if (!(pte_val(*pte) & _PAGE_PSE)) {
+				printk("%lx level %d but not PSE %Lx\n",
+					adr, level, (u64)pte_val(*pte));
+				err = 1;
+			}
+			s->lpg++;
+			i += LPS/PAGE_SIZE;
+		} else {
+			s->spg++;
+			i++;
+		}
+		if (!(pte_val(*pte) & _PAGE_NX)) {
+			s->exec++;
+			if (adr < s->min_exec)
+				s->min_exec = adr;
+			if (adr > s->max_exec)
+				s->max_exec = adr;
+		}
+	}
+	printk("CPA mapping 4k %lu large %lu gb %lu x %lu[%lx-%lx] miss %lu\n",
+		s->spg, s->lpg, s->gpg, s->exec,
+		s->min_exec != ~0UL ? s->min_exec : 0, s->max_exec, missed);
+	expected = (s->gpg*GPS + s->lpg*LPS)/PAGE_SIZE + s->spg + missed;
+	if (expected != i) {
+		printk("CPA max_mapped %lu but expected %lu\n",
+			max_mapped, expected);
+		return 1;
+	}
+	return err;
+}
+
+static __init int state_same(struct split_state *a, struct split_state *b)
+{
+	return a->lpg == b->lpg && a->gpg == b->gpg && a->spg == b->spg &&
+			a->exec == b->exec;
+}
+
+static unsigned long addr[NTEST] __initdata;
+static unsigned len[NTEST] __initdata;
+
+/* Change the global bit on random pages in the direct mapping */
+static __init int exercise_pageattr(void)
+{
+	int i, k;
+	pte_t *pte, pte0;
+	int level;
+	int err;
+	struct split_state sa, sb, sc;
+	int failed = 0;
+	unsigned long *bm;
+
+	printk("CPA exercising pageattr\n");
+
+	bm = vmalloc((max_mapped + 7) / 8);
+	if (!bm) {
+		printk("CPA Cannot vmalloc bitmap\n");
+		return -ENOMEM;
+	}
+	memset(bm, 0, (max_mapped + 7) / 8);
+
+	failed += print_split(&sa);
+	srandom32(100);
+	for (i = 0; i < NTEST; i++) {
+		unsigned long pfn = random32() % max_mapped;
+		addr[i] = (unsigned long)__va(pfn << PAGE_SHIFT);
+		len[i] = random32() % 100;
+		len[i] = min_t(unsigned long, len[i], max_mapped - pfn - 1);
+		if (len[i] == 0)
+			len[i] = 1;
+
+		pte = NULL;
+		pte0 = pfn_pte(0, __pgprot(0)); /* shut gcc up */
+		for (k = 0; k < len[i]; k++) {
+			pte = lookup_address(addr[i] + k*PAGE_SIZE, &level);
+			if (!pte || pgprot_val(pte_pgprot(*pte)) == 0) {
+				addr[i] = 0;
+				break;
+			}
+			if (k == 0)
+				pte0 = *pte;
+			else if (pgprot_val(pte_pgprot(*pte)) !=
+					pgprot_val(pte_pgprot(pte0))) {
+				len[i] = k;
+				break;
+			}
+			if (test_bit(pfn + k, bm)) {
+				len[i] = k;
+				break;
+			}
+			__set_bit(pfn + k, bm);
+		}
+		if (!addr[i] || !pte || !k) {
+			addr[i] = 0;
+			continue;
+		}
+
+		err = change_page_attr(virt_to_page(addr[i]), len[i],
+			    pte_pgprot(pte_clrhuge(pte_clrglobal(pte0))));
+		if (err < 0) {
+			printk("CPA %d failed %d\n", i, err);
+			failed++;
+		}
+
+		pte = lookup_address(addr[i], &level);
+		if (!pte || pte_global(*pte) || pte_huge(*pte)) {
+			printk("CPA %lx: bad pte %Lx\n", addr[i],
+				pte ? (u64)pte_val(*pte) : 0ULL);
+			failed++;
+		}
+		if (level != LOWEST_LEVEL) {
+			printk("CPA %lx: unexpected level %d\n", addr[i],
+					level);
+			failed++;
+		}
+
+	}
+	vfree(bm);
+	global_flush_tlb();
+
+	failed += print_split(&sb);
+
+	printk("CPA reverting everything\n");
+	for (i = 0; i < NTEST; i++) {
+		if (!addr[i])
+			continue;
+		pte = lookup_address(addr[i], &level);
+		if (!pte) {
+			printk("CPA lookup of %lx failed\n", addr[i]);
+			failed++;
+			continue;
+		}
+		err = change_page_attr(virt_to_page(addr[i]), len[i],
+					  pte_pgprot(pte_mkglobal(*pte)));
+		if (err < 0) {
+			printk("CPA reverting failed: %d\n", err);
+			failed++;
+		}
+		pte = lookup_address(addr[i], &level);
+		if (!pte || !pte_global(*pte)) {
+			printk("CPA %lx: bad pte after revert %Lx\n", addr[i],
+			       pte ? (u64)pte_val(*pte) : 0ULL);
+			failed++;
+		}
+
+	}
+	global_flush_tlb();
+
+	failed += print_split(&sc);
+	if (!state_same(&sa, &sc))
+		failed++;
+
+	if (failed)
+		printk("CPA selftests NOT PASSED. Please report.\n");
+	else
+		printk("CPA selftests PASSED\n");
+
+	return 0;
+}
+
+module_init(exercise_pageattr);
Index: linux/arch/x86/mm/Makefile_32
===================================================================
--- linux.orig/arch/x86/mm/Makefile_32
+++ linux/arch/x86/mm/Makefile_32
@@ -8,3 +8,4 @@ obj-$(CONFIG_NUMA) += discontig_32.o
 obj-$(CONFIG_HUGETLB_PAGE) += hugetlbpage.o
 obj-$(CONFIG_HIGHMEM) += highmem_32.o
 obj-$(CONFIG_BOOT_IOREMAP) += boot_ioremap_32.o
+obj-$(CONFIG_CPA_DEBUG) += pageattr-test.o
