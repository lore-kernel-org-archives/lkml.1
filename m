Return-Path: <linux-kernel-owner+w=401wt.eu-S1761285AbYGBBEK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761285AbYGBBEK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 21:04:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759696AbYGBBCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 21:02:36 -0400
Received: from gw.goop.org ([64.81.55.164]:58691 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757936AbYGBBBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 21:01:52 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 5 of 8] x86_64/setup: create 4k mappings if the cpu doens't
	support PSE
X-Mercurial-Node: 274006562ec139981c3dde79dbfb501f9b661575
Message-Id: <274006562ec139981c3d.1214955994@localhost>
In-Reply-To: <patchbomb.1214955989@localhost>
Date: Tue, 01 Jul 2008 16:46:34 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the CPU (or environment) doesn't support PSE, then create 4k mappings.
This:
 1. allocates enough memory for the ptes
 2. reuses existing ptes, or
 3. allocates and initializes new pte pages

In other words, its identical to the code which deals with puds and pmds.

If the processor does support PSE, the behaviour is unchanged.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/mm/init_64.c |   63 +++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 59 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -253,6 +253,40 @@
 	early_iounmap(adr, PAGE_SIZE);
 }
 
+static void __meminit
+phys_pte_init(pte_t *pte_page, unsigned long addr, unsigned long end)
+{
+	unsigned pages = 0;
+	int i;
+	pte_t *pte = pte_page + pte_index(addr);
+
+	for(i = pte_index(addr); i < PTRS_PER_PTE; i++, addr += PAGE_SIZE, pte++) {
+
+		if (addr >= end) {
+			if (!after_bootmem) {
+				for(; i < PTRS_PER_PTE; i++, pte++)
+					set_pte(pte, __pte(0));
+			}
+			break;
+		}
+
+		if (pte_val(*pte))
+			continue;
+
+		set_pte(pte, pfn_pte(addr >> PAGE_SHIFT, PAGE_KERNEL));
+		pages++;
+	}
+	update_page_count(PG_LEVEL_4K, pages);
+}
+
+static void __meminit
+phys_pte_update(pmd_t *pmd, unsigned long address, unsigned long end)
+{
+	pte_t *pte = (pte_t *)pmd_page_vaddr(*pmd);
+
+	phys_pte_init(pte, address, end);
+}
+
 static unsigned long __meminit
 phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end)
 {
@@ -261,7 +295,9 @@
 	int i = pmd_index(address);
 
 	for (; i < PTRS_PER_PMD; i++, address += PMD_SIZE) {
+		unsigned long pte_phys;
 		pmd_t *pmd = pmd_page + pmd_index(address);
+		pte_t *pte;
 
 		if (address >= end) {
 			if (!after_bootmem) {
@@ -271,12 +307,27 @@
 			break;
 		}
 
-		if (pmd_val(*pmd))
+		if (pmd_val(*pmd)) {
+			WARN_ON(!pmd_present(*pmd));
+			if (!pmd_large(*pmd)) {
+				WARN_ON(cpu_has_pse);
+				phys_pte_update(pmd, address, end);
+			}
 			continue;
+		}
 
-		pages++;
-		set_pte((pte_t *)pmd,
-			pfn_pte(address >> PAGE_SHIFT, PAGE_KERNEL_LARGE));
+		if (cpu_has_pse) {
+			pages++;
+			set_pte((pte_t *)pmd,
+				pfn_pte(address >> PAGE_SHIFT, PAGE_KERNEL_LARGE));
+			continue;
+		}
+
+		pte = alloc_low_page(&pte_phys);
+		phys_pte_init(pte, address, end);
+		unmap_low_page(pte);
+
+		pmd_populate_kernel(&init_mm, pmd, __va(pte_phys));
 	}
 	update_page_count(PG_LEVEL_2M, pages);
 	return address;
@@ -354,6 +405,10 @@
 	if (!direct_gbpages) {
 		pmds = (end + PMD_SIZE - 1) >> PMD_SHIFT;
 		tables += round_up(pmds * sizeof(pmd_t), PAGE_SIZE);
+	}
+	if (!cpu_has_pse) {
+		unsigned long ptes = (end + PAGE_SIZE - 1) >> PAGE_SHIFT;
+		tables += round_up(ptes * sizeof(pte_t), PAGE_SIZE);
 	}
 
 	/*


