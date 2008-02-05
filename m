Return-Path: <linux-kernel-owner+w=401wt.eu-S1759304AbYBEU2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759304AbYBEU2o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 15:28:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759026AbYBEU2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 15:28:30 -0500
Received: from smtp1.cc.lut.fi ([157.24.2.30]:47091 "EHLO smtp1.cc.lut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760643AbYBEU21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 15:28:27 -0500
Date: Tue, 5 Feb 2008 22:28:07 +0200
From: Pekka Paalanen <pq@iki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: pq@iki.fi, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] x86 mmiotrace: use lookup_address()
Message-ID: <20080205222807.7b35ef2b@daedalus.pq.iki.fi>
In-Reply-To: <20080203070321.GA8293@elte.hu>
References: <20080127185238.4bcac54b@daedalus.pq.iki.fi>
	<1201660102.8837.9.camel@brick>
	<1201660453.8837.13.camel@brick>
	<20080130200827.322c4f7d@daedalus.pq.iki.fi>
	<20080131150746.GB11996@elte.hu>
	<20080131180253.6c007852@daedalus.pq.iki.fi>
	<20080131081507.5edcde10@laptopd505.fenrus.org>
	<20080203085522.2b63e15b@daedalus.pq.iki.fi>
	<20080203070321.GA8293@elte.hu>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use lookup_address() from pageattr.c instead of doing the same
manually. Also had to EXPORT_SYMBOL(lookup_address) to make this
work for modules. This also fixes "undefined symbol 'init_mm'"
compile error for x86_32.

Signed-off-by: Pekka Paalanen <pq@iki.fi>
---
 arch/x86/kernel/mmiotrace/kmmio.c    |   46 +++++++++++++++++++++++-----------
 arch/x86/kernel/mmiotrace/mmio-mod.c |   19 +++++++++-----
 arch/x86/mm/pageattr.c               |    1 +
 3 files changed, 44 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kernel/mmiotrace/kmmio.c b/arch/x86/kernel/mmiotrace/kmmio.c
index 8ba48f9..28411da 100644
--- a/arch/x86/kernel/mmiotrace/kmmio.c
+++ b/arch/x86/kernel/mmiotrace/kmmio.c
@@ -20,6 +20,7 @@
 #include <asm/cacheflush.h>
 #include <asm/errno.h>
 #include <asm/tlbflush.h>
+#include <asm/pgtable.h>
 
 #include "kmmio.h"
 
@@ -117,40 +118,55 @@ static struct kmmio_fault_page *get_kmmio_fault_page(unsigned long page)
 	return NULL;
 }
 
-static void arm_kmmio_fault_page(unsigned long page, int *large)
+static void arm_kmmio_fault_page(unsigned long page, int *page_level)
 {
 	unsigned long address = page & PAGE_MASK;
-	pgd_t *pgd = pgd_offset_k(address);
-	pud_t *pud = pud_offset(pgd, address);
-	pmd_t *pmd = pmd_offset(pud, address);
-	pte_t *pte = pte_offset_kernel(pmd, address);
+	int level;
+	pte_t *pte = lookup_address(address, &level);
 
-	if (pmd_large(*pmd)) {
+	if (!pte) {
+		printk(KERN_ERR "Error in %s: no pte for page 0x%08lx\n",
+						__FUNCTION__, page);
+		return;
+	}
+
+	if (level == PG_LEVEL_2M) {
+		pmd_t *pmd = (pmd_t *)pte;
 		set_pmd(pmd, __pmd(pmd_val(*pmd) & ~_PAGE_PRESENT));
-		if (large)
-			*large = 1;
 	} else {
+		/* PG_LEVEL_4K */
 		set_pte(pte, __pte(pte_val(*pte) & ~_PAGE_PRESENT));
 	}
 
+	if (page_level)
+		*page_level = level;
+
 	__flush_tlb_one(page);
 }
 
-static void disarm_kmmio_fault_page(unsigned long page, int *large)
+static void disarm_kmmio_fault_page(unsigned long page, int *page_level)
 {
 	unsigned long address = page & PAGE_MASK;
-	pgd_t *pgd = pgd_offset_k(address);
-	pud_t *pud = pud_offset(pgd, address);
-	pmd_t *pmd = pmd_offset(pud, address);
-	pte_t *pte = pte_offset_kernel(pmd, address);
+	int level;
+	pte_t *pte = lookup_address(address, &level);
 
-	if (large && *large) {
+	if (!pte) {
+		printk(KERN_ERR "Error in %s: no pte for page 0x%08lx\n",
+						__FUNCTION__, page);
+		return;
+	}
+
+	if (level == PG_LEVEL_2M) {
+		pmd_t *pmd = (pmd_t *)pte;
 		set_pmd(pmd, __pmd(pmd_val(*pmd) | _PAGE_PRESENT));
-		*large = 0;
 	} else {
+		/* PG_LEVEL_4K */
 		set_pte(pte, __pte(pte_val(*pte) | _PAGE_PRESENT));
 	}
 
+	if (page_level)
+		*page_level = level;
+
 	__flush_tlb_one(page);
 }
 
diff --git a/arch/x86/kernel/mmiotrace/mmio-mod.c b/arch/x86/kernel/mmiotrace/mmio-mod.c
index 4a8c859..82ae920 100644
--- a/arch/x86/kernel/mmiotrace/mmio-mod.c
+++ b/arch/x86/kernel/mmiotrace/mmio-mod.c
@@ -120,19 +120,24 @@ static int write_marker(struct file *file, const char __user *buffer,
 
 static void print_pte(unsigned long address)
 {
-	pgd_t *pgd = pgd_offset_k(address);
-	pud_t *pud = pud_offset(pgd, address);
-	pmd_t *pmd = pmd_offset(pud, address);
-	if (pmd_large(*pmd)) {
+	int level;
+	pte_t *pte = lookup_address(address, &level);
+
+	if (!pte) {
+		printk(KERN_ERR "Error in %s: no pte for page 0x%08lx\n",
+						__FUNCTION__, address);
+		return;
+	}
+
+	if (level == PG_LEVEL_2M) {
 		printk(KERN_EMERG MODULE_NAME ": 4MB pages are not "
 						"currently supported: %lx\n",
 						address);
 		BUG();
 	}
 	printk(KERN_DEBUG MODULE_NAME ": pte for 0x%lx: 0x%lx 0x%lx\n",
-		address,
-		pte_val(*pte_offset_kernel(pmd, address)),
-		pte_val(*pte_offset_kernel(pmd, address)) & _PAGE_PRESENT);
+					address, pte_val(*pte),
+					pte_val(*pte) & _PAGE_PRESENT);
 }
 
 /*
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index bb55a78..fc7e9ea 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -225,6 +225,7 @@ pte_t *lookup_address(unsigned long address, int *level)
 
 	return pte_offset_kernel(pmd, address);
 }
+EXPORT_SYMBOL(lookup_address);
 
 /*
  * Set the new pmd in all the pgds we know about:
-- 
1.5.3.7

