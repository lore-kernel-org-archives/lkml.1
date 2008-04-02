Return-Path: <linux-kernel-owner+w=401wt.eu-S1761499AbYDBSlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761499AbYDBSlX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 14:41:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758227AbYDBSfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 14:35:50 -0400
Received: from 21.sub-75-208-3.myvzw.com ([75.208.3.21]:38419 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757391AbYDBSfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 14:35:43 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 09 of 24] xen: make include/xen/page.h portable moving those
	definitions under asm dir
X-Mercurial-Node: afb214adb2f38a49e5e9e441a69294a60e5e2149
Message-Id: <afb214adb2f38a49e5e9.1207158838@localhost>
In-Reply-To: <patchbomb.1207158829@localhost>
Date: Wed, 02 Apr 2008 10:53:58 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Isaku Yamahata <yamahata@valinux.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Isaku Yamahata <yamahata@valinux.co.jp>

The definitions in include/asm/xen/page.h are arch specific.
ia64/xen wants to define its own version. So move them to arch specific
directory and keep include/xen/page.h in order not to break compilation.

Signed-off-by: Isaku Yamahata <yamahata@valinux.co.jp>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 include/asm-x86/xen/page.h |  168 +++++++++++++++++++++++++++++++++++++++++++
 include/xen/page.h         |  169 --------------------------------------------
 2 files changed, 169 insertions(+), 168 deletions(-)

diff --git a/include/asm-x86/xen/page.h b/include/asm-x86/xen/page.h
new file mode 100644
--- /dev/null
+++ b/include/asm-x86/xen/page.h
@@ -0,0 +1,168 @@
+#ifndef __XEN_PAGE_H
+#define __XEN_PAGE_H
+
+#include <linux/pfn.h>
+
+#include <asm/uaccess.h>
+#include <asm/pgtable.h>
+
+#include <xen/features.h>
+
+/* Xen machine address */
+typedef struct xmaddr {
+	phys_addr_t maddr;
+} xmaddr_t;
+
+/* Xen pseudo-physical address */
+typedef struct xpaddr {
+	phys_addr_t paddr;
+} xpaddr_t;
+
+#define XMADDR(x)	((xmaddr_t) { .maddr = (x) })
+#define XPADDR(x)	((xpaddr_t) { .paddr = (x) })
+
+/**** MACHINE <-> PHYSICAL CONVERSION MACROS ****/
+#define INVALID_P2M_ENTRY	(~0UL)
+#define FOREIGN_FRAME_BIT	(1UL<<31)
+#define FOREIGN_FRAME(m)	((m) | FOREIGN_FRAME_BIT)
+
+extern unsigned long *phys_to_machine_mapping;
+
+static inline unsigned long pfn_to_mfn(unsigned long pfn)
+{
+	if (xen_feature(XENFEAT_auto_translated_physmap))
+		return pfn;
+
+	return phys_to_machine_mapping[(unsigned int)(pfn)] &
+		~FOREIGN_FRAME_BIT;
+}
+
+static inline int phys_to_machine_mapping_valid(unsigned long pfn)
+{
+	if (xen_feature(XENFEAT_auto_translated_physmap))
+		return 1;
+
+	return (phys_to_machine_mapping[pfn] != INVALID_P2M_ENTRY);
+}
+
+static inline unsigned long mfn_to_pfn(unsigned long mfn)
+{
+	unsigned long pfn;
+
+	if (xen_feature(XENFEAT_auto_translated_physmap))
+		return mfn;
+
+#if 0
+	if (unlikely((mfn >> machine_to_phys_order) != 0))
+		return max_mapnr;
+#endif
+
+	pfn = 0;
+	/*
+	 * The array access can fail (e.g., device space beyond end of RAM).
+	 * In such cases it doesn't matter what we return (we return garbage),
+	 * but we must handle the fault without crashing!
+	 */
+	__get_user(pfn, &machine_to_phys_mapping[mfn]);
+
+	return pfn;
+}
+
+static inline xmaddr_t phys_to_machine(xpaddr_t phys)
+{
+	unsigned offset = phys.paddr & ~PAGE_MASK;
+	return XMADDR(PFN_PHYS((u64)pfn_to_mfn(PFN_DOWN(phys.paddr))) | offset);
+}
+
+static inline xpaddr_t machine_to_phys(xmaddr_t machine)
+{
+	unsigned offset = machine.maddr & ~PAGE_MASK;
+	return XPADDR(PFN_PHYS((u64)mfn_to_pfn(PFN_DOWN(machine.maddr))) | offset);
+}
+
+/*
+ * We detect special mappings in one of two ways:
+ *  1. If the MFN is an I/O page then Xen will set the m2p entry
+ *     to be outside our maximum possible pseudophys range.
+ *  2. If the MFN belongs to a different domain then we will certainly
+ *     not have MFN in our p2m table. Conversely, if the page is ours,
+ *     then we'll have p2m(m2p(MFN))==MFN.
+ * If we detect a special mapping then it doesn't have a 'struct page'.
+ * We force !pfn_valid() by returning an out-of-range pointer.
+ *
+ * NB. These checks require that, for any MFN that is not in our reservation,
+ * there is no PFN such that p2m(PFN) == MFN. Otherwise we can get confused if
+ * we are foreign-mapping the MFN, and the other domain as m2p(MFN) == PFN.
+ * Yikes! Various places must poke in INVALID_P2M_ENTRY for safety.
+ *
+ * NB2. When deliberately mapping foreign pages into the p2m table, you *must*
+ *      use FOREIGN_FRAME(). This will cause pte_pfn() to choke on it, as we
+ *      require. In all the cases we care about, the FOREIGN_FRAME bit is
+ *      masked (e.g., pfn_to_mfn()) so behaviour there is correct.
+ */
+static inline unsigned long mfn_to_local_pfn(unsigned long mfn)
+{
+	extern unsigned long max_mapnr;
+	unsigned long pfn = mfn_to_pfn(mfn);
+	if ((pfn < max_mapnr)
+	    && !xen_feature(XENFEAT_auto_translated_physmap)
+	    && (phys_to_machine_mapping[pfn] != mfn))
+		return max_mapnr; /* force !pfn_valid() */
+	return pfn;
+}
+
+static inline void set_phys_to_machine(unsigned long pfn, unsigned long mfn)
+{
+	if (xen_feature(XENFEAT_auto_translated_physmap)) {
+		BUG_ON(pfn != mfn && mfn != INVALID_P2M_ENTRY);
+		return;
+	}
+	phys_to_machine_mapping[pfn] = mfn;
+}
+
+/* VIRT <-> MACHINE conversion */
+#define virt_to_machine(v)	(phys_to_machine(XPADDR(__pa(v))))
+#define virt_to_mfn(v)		(pfn_to_mfn(PFN_DOWN(__pa(v))))
+#define mfn_to_virt(m)		(__va(mfn_to_pfn(m) << PAGE_SHIFT))
+
+static inline unsigned long pte_mfn(pte_t pte)
+{
+	return (pte.pte & ~_PAGE_NX) >> PAGE_SHIFT;
+}
+
+static inline pte_t mfn_pte(unsigned long page_nr, pgprot_t pgprot)
+{
+	pte_t pte;
+
+	pte.pte = ((phys_addr_t)page_nr << PAGE_SHIFT) |
+		(pgprot_val(pgprot) & __supported_pte_mask);
+
+	return pte;
+}
+
+static inline pteval_t pte_val_ma(pte_t pte)
+{
+	return pte.pte;
+}
+
+static inline pte_t __pte_ma(pteval_t x)
+{
+	return (pte_t) { .pte = x };
+}
+
+#ifdef CONFIG_X86_PAE
+#define pmd_val_ma(v) ((v).pmd)
+#define pud_val_ma(v) ((v).pgd.pgd)
+#define __pmd_ma(x)	((pmd_t) { (x) } )
+#else  /* !X86_PAE */
+#define pmd_val_ma(v)	((v).pud.pgd.pgd)
+#endif	/* CONFIG_X86_PAE */
+
+#define pgd_val_ma(x)	((x).pgd)
+
+
+xmaddr_t arbitrary_virt_to_machine(unsigned long address);
+void make_lowmem_page_readonly(void *vaddr);
+void make_lowmem_page_readwrite(void *vaddr);
+
+#endif /* __XEN_PAGE_H */
diff --git a/include/xen/page.h b/include/xen/page.h
--- a/include/xen/page.h
+++ b/include/xen/page.h
@@ -1,168 +1,1 @@
-#ifndef __XEN_PAGE_H
-#define __XEN_PAGE_H
-
-#include <linux/pfn.h>
-
-#include <asm/uaccess.h>
-#include <asm/pgtable.h>
-
-#include <xen/features.h>
-
-/* Xen machine address */
-typedef struct xmaddr {
-	phys_addr_t maddr;
-} xmaddr_t;
-
-/* Xen pseudo-physical address */
-typedef struct xpaddr {
-	phys_addr_t paddr;
-} xpaddr_t;
-
-#define XMADDR(x)	((xmaddr_t) { .maddr = (x) })
-#define XPADDR(x)	((xpaddr_t) { .paddr = (x) })
-
-/**** MACHINE <-> PHYSICAL CONVERSION MACROS ****/
-#define INVALID_P2M_ENTRY	(~0UL)
-#define FOREIGN_FRAME_BIT	(1UL<<31)
-#define FOREIGN_FRAME(m)	((m) | FOREIGN_FRAME_BIT)
-
-extern unsigned long *phys_to_machine_mapping;
-
-static inline unsigned long pfn_to_mfn(unsigned long pfn)
-{
-	if (xen_feature(XENFEAT_auto_translated_physmap))
-		return pfn;
-
-	return phys_to_machine_mapping[(unsigned int)(pfn)] &
-		~FOREIGN_FRAME_BIT;
-}
-
-static inline int phys_to_machine_mapping_valid(unsigned long pfn)
-{
-	if (xen_feature(XENFEAT_auto_translated_physmap))
-		return 1;
-
-	return (phys_to_machine_mapping[pfn] != INVALID_P2M_ENTRY);
-}
-
-static inline unsigned long mfn_to_pfn(unsigned long mfn)
-{
-	unsigned long pfn;
-
-	if (xen_feature(XENFEAT_auto_translated_physmap))
-		return mfn;
-
-#if 0
-	if (unlikely((mfn >> machine_to_phys_order) != 0))
-		return max_mapnr;
-#endif
-
-	pfn = 0;
-	/*
-	 * The array access can fail (e.g., device space beyond end of RAM).
-	 * In such cases it doesn't matter what we return (we return garbage),
-	 * but we must handle the fault without crashing!
-	 */
-	__get_user(pfn, &machine_to_phys_mapping[mfn]);
-
-	return pfn;
-}
-
-static inline xmaddr_t phys_to_machine(xpaddr_t phys)
-{
-	unsigned offset = phys.paddr & ~PAGE_MASK;
-	return XMADDR(PFN_PHYS((u64)pfn_to_mfn(PFN_DOWN(phys.paddr))) | offset);
-}
-
-static inline xpaddr_t machine_to_phys(xmaddr_t machine)
-{
-	unsigned offset = machine.maddr & ~PAGE_MASK;
-	return XPADDR(PFN_PHYS((u64)mfn_to_pfn(PFN_DOWN(machine.maddr))) | offset);
-}
-
-/*
- * We detect special mappings in one of two ways:
- *  1. If the MFN is an I/O page then Xen will set the m2p entry
- *     to be outside our maximum possible pseudophys range.
- *  2. If the MFN belongs to a different domain then we will certainly
- *     not have MFN in our p2m table. Conversely, if the page is ours,
- *     then we'll have p2m(m2p(MFN))==MFN.
- * If we detect a special mapping then it doesn't have a 'struct page'.
- * We force !pfn_valid() by returning an out-of-range pointer.
- *
- * NB. These checks require that, for any MFN that is not in our reservation,
- * there is no PFN such that p2m(PFN) == MFN. Otherwise we can get confused if
- * we are foreign-mapping the MFN, and the other domain as m2p(MFN) == PFN.
- * Yikes! Various places must poke in INVALID_P2M_ENTRY for safety.
- *
- * NB2. When deliberately mapping foreign pages into the p2m table, you *must*
- *      use FOREIGN_FRAME(). This will cause pte_pfn() to choke on it, as we
- *      require. In all the cases we care about, the FOREIGN_FRAME bit is
- *      masked (e.g., pfn_to_mfn()) so behaviour there is correct.
- */
-static inline unsigned long mfn_to_local_pfn(unsigned long mfn)
-{
-	extern unsigned long max_mapnr;
-	unsigned long pfn = mfn_to_pfn(mfn);
-	if ((pfn < max_mapnr)
-	    && !xen_feature(XENFEAT_auto_translated_physmap)
-	    && (phys_to_machine_mapping[pfn] != mfn))
-		return max_mapnr; /* force !pfn_valid() */
-	return pfn;
-}
-
-static inline void set_phys_to_machine(unsigned long pfn, unsigned long mfn)
-{
-	if (xen_feature(XENFEAT_auto_translated_physmap)) {
-		BUG_ON(pfn != mfn && mfn != INVALID_P2M_ENTRY);
-		return;
-	}
-	phys_to_machine_mapping[pfn] = mfn;
-}
-
-/* VIRT <-> MACHINE conversion */
-#define virt_to_machine(v)	(phys_to_machine(XPADDR(__pa(v))))
-#define virt_to_mfn(v)		(pfn_to_mfn(PFN_DOWN(__pa(v))))
-#define mfn_to_virt(m)		(__va(mfn_to_pfn(m) << PAGE_SHIFT))
-
-static inline unsigned long pte_mfn(pte_t pte)
-{
-	return (pte.pte & ~_PAGE_NX) >> PAGE_SHIFT;
-}
-
-static inline pte_t mfn_pte(unsigned long page_nr, pgprot_t pgprot)
-{
-	pte_t pte;
-
-	pte.pte = ((phys_addr_t)page_nr << PAGE_SHIFT) |
-		(pgprot_val(pgprot) & __supported_pte_mask);
-
-	return pte;
-}
-
-static inline pteval_t pte_val_ma(pte_t pte)
-{
-	return pte.pte;
-}
-
-static inline pte_t __pte_ma(pteval_t x)
-{
-	return (pte_t) { .pte = x };
-}
-
-#ifdef CONFIG_X86_PAE
-#define pmd_val_ma(v) ((v).pmd)
-#define pud_val_ma(v) ((v).pgd.pgd)
-#define __pmd_ma(x)	((pmd_t) { (x) } )
-#else  /* !X86_PAE */
-#define pmd_val_ma(v)	((v).pud.pgd.pgd)
-#endif	/* CONFIG_X86_PAE */
-
-#define pgd_val_ma(x)	((x).pgd)
-
-
-xmaddr_t arbitrary_virt_to_machine(unsigned long address);
-void make_lowmem_page_readonly(void *vaddr);
-void make_lowmem_page_readwrite(void *vaddr);
-
-#endif /* __XEN_PAGE_H */
+#include <asm/xen/page.h>


