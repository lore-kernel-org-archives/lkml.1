Return-Path: <linux-kernel-owner+w=401wt.eu-S1759847AbYAJXXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759847AbYAJXXp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 18:23:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755065AbYAJXXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 18:23:11 -0500
Received: from gw.goop.org ([64.81.55.164]:35215 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753382AbYAJXXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 18:23:09 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 2 of 2] x86: use common _PAGE_NOCACHE
X-Mercurial-Node: 232ab35d54b0240c2f5385bc41fe609c1f30e8cd
Message-Id: <232ab35d54b0240c2f53.1200004571@localhost>
In-Reply-To: <patchbomb.1200004569@localhost>
Date: Thu, 10 Jan 2008 14:36:11 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since it seems that every use of _PAGE_PCD also sets _PAGE_PWT, define
_PAGE_NOCACHE with this combination.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

---
 arch/x86/mm/ioremap_32.c     |    2 +-
 arch/x86/mm/ioremap_64.c     |    2 +-
 arch/x86/pci/i386.c          |    2 +-
 arch/x86/xen/mmu.c           |    4 ++--
 include/asm-x86/pgtable.h    |    6 ++++--
 include/asm-x86/pgtable_32.h |    2 +-
 include/asm-x86/pgtable_64.h |    2 +-
 7 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/arch/x86/mm/ioremap_32.c b/arch/x86/mm/ioremap_32.c
--- a/arch/x86/mm/ioremap_32.c
+++ b/arch/x86/mm/ioremap_32.c
@@ -119,7 +119,7 @@ void __iomem *ioremap_nocache (unsigned 
 void __iomem *ioremap_nocache (unsigned long phys_addr, unsigned long size)
 {
 	unsigned long last_addr;
-	void __iomem *p = __ioremap(phys_addr, size, _PAGE_PCD | _PAGE_PWT);
+	void __iomem *p = __ioremap(phys_addr, size, _PAGE_NOCACHE);
 	if (!p) 
 		return p; 
 
diff --git a/arch/x86/mm/ioremap_64.c b/arch/x86/mm/ioremap_64.c
--- a/arch/x86/mm/ioremap_64.c
+++ b/arch/x86/mm/ioremap_64.c
@@ -142,7 +142,7 @@ EXPORT_SYMBOL(__ioremap);
 
 void __iomem *ioremap_nocache (unsigned long phys_addr, unsigned long size)
 {
-	return __ioremap(phys_addr, size, _PAGE_PCD | _PAGE_PWT);
+	return __ioremap(phys_addr, size, _PAGE_NOCACHE);
 }
 EXPORT_SYMBOL(ioremap_nocache);
 
diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -313,7 +313,7 @@ int pci_mmap_page_range(struct pci_dev *
 	 */
 	prot = pgprot_val(vma->vm_page_prot);
 	if (boot_cpu_data.x86 > 3)
-		prot |= _PAGE_PCD | _PAGE_PWT;
+		prot |= _PAGE_NOCACHE;
 	vma->vm_page_prot = __pgprot(prot);
 
 	/* Write-combine setting is ignored, it is changed via the mtrr
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -244,7 +244,7 @@ pte_t xen_make_pte(unsigned long long pt
 	if (pte & 1)
 		pte = phys_to_machine(XPADDR(pte)).maddr;
 
-	pte &= ~(_PAGE_PCD | _PAGE_PWT);
+	pte &= ~_PAGE_NOCACHE;
 
 	return (pte_t){ .pte = pte };
 }
@@ -293,7 +293,7 @@ pte_t xen_make_pte(unsigned long pte)
 	if (pte & _PAGE_PRESENT)
 		pte = phys_to_machine(XPADDR(pte)).maddr;
 
-	pte &= ~(_PAGE_PCD | _PAGE_PWT);
+	pte &= ~_PAGE_NOCACHE;
 
 	return (pte_t){ pte };
 }
diff --git a/include/asm-x86/pgtable.h b/include/asm-x86/pgtable.h
--- a/include/asm-x86/pgtable.h
+++ b/include/asm-x86/pgtable.h
@@ -31,6 +31,8 @@
 #define _PAGE_UNUSED1	(_AC(1, UL)<<_PAGE_BIT_UNUSED1)
 #define _PAGE_UNUSED2	(_AC(1, UL)<<_PAGE_BIT_UNUSED2)
 #define _PAGE_UNUSED3	(_AC(1, UL)<<_PAGE_BIT_UNUSED3)
+
+#define _PAGE_NOCACHE	(_PAGE_PCD | _PAGE_PWT)
 
 #if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
 #define _PAGE_NX	(_AC(1, ULL) << _PAGE_BIT_NX)
@@ -74,9 +76,9 @@ extern unsigned long long __PAGE_KERNEL,
 
 #define __PAGE_KERNEL_RO		(__PAGE_KERNEL & ~_PAGE_RW)
 #define __PAGE_KERNEL_RX		(__PAGE_KERNEL_EXEC & ~_PAGE_RW)
-#define __PAGE_KERNEL_NOCACHE		(__PAGE_KERNEL | _PAGE_PCD | _PAGE_PWT)
+#define __PAGE_KERNEL_NOCACHE		(__PAGE_KERNEL | _PAGE_NOCACHE)
 #define __PAGE_KERNEL_VSYSCALL		(__PAGE_KERNEL_RX | _PAGE_USER)
-#define __PAGE_KERNEL_VSYSCALL_NOCACHE	(__PAGE_KERNEL_VSYSCALL | _PAGE_PCD | _PAGE_PWT)
+#define __PAGE_KERNEL_VSYSCALL_NOCACHE	(__PAGE_KERNEL_VSYSCALL | _PAGE_NOCACHE)
 #define __PAGE_KERNEL_LARGE		(__PAGE_KERNEL | _PAGE_PSE)
 #define __PAGE_KERNEL_LARGE_EXEC	(__PAGE_KERNEL_EXEC | _PAGE_PSE)
 
diff --git a/include/asm-x86/pgtable_32.h b/include/asm-x86/pgtable_32.h
--- a/include/asm-x86/pgtable_32.h
+++ b/include/asm-x86/pgtable_32.h
@@ -121,7 +121,7 @@ static inline void clone_pgd_range(pgd_t
  * it, this is a no-op.
  */
 #define pgprot_noncached(prot)	((boot_cpu_data.x86 > 3)					  \
-				 ? (__pgprot(pgprot_val(prot) | _PAGE_PCD | _PAGE_PWT)) : (prot))
+				 ? (__pgprot(pgprot_val(prot) | _PAGE_NOCACHE)) : (prot))
 
 /*
  * Conversion functions: convert a page and protection to a page entry,
diff --git a/include/asm-x86/pgtable_64.h b/include/asm-x86/pgtable_64.h
--- a/include/asm-x86/pgtable_64.h
+++ b/include/asm-x86/pgtable_64.h
@@ -167,7 +167,7 @@ static inline unsigned long pmd_bad(pmd_
 /*
  * Macro to mark a page protection value as "uncacheable".
  */
-#define pgprot_noncached(prot)	(__pgprot(pgprot_val(prot) | _PAGE_PCD | _PAGE_PWT))
+#define pgprot_noncached(prot)	(__pgprot(pgprot_val(prot) | _PAGE_NOCACHE))
 
 
 /*


