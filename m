Return-Path: <linux-kernel-owner+w=401wt.eu-S1753877AbZCMINo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877AbZCMINo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 04:13:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753590AbZCMIMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 04:12:14 -0400
Received: from gw.goop.org ([64.81.55.164]:34787 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751964AbZCMIMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 04:12:09 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 03/24] xen: dynamically allocate p2m tables
Date: Fri, 13 Mar 2009 01:11:39 -0700
Message-Id: <1236931920-6861-4-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1236931920-6861-1-git-send-email-jeremy@goop.org>
References: <1236931920-6861-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Saves about 128k static object size.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/mmu.c |   38 +++++++++++++++++++++++++++++---------
 1 files changed, 29 insertions(+), 9 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index d534986..05280b4 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -159,18 +159,14 @@ DEFINE_PER_CPU(unsigned long, xen_current_cr3);	 /* actual vcpu cr3 */
 #define TOP_ENTRIES		(MAX_DOMAIN_PAGES / P2M_ENTRIES_PER_PAGE)
 
 /* Placeholder for holes in the address space */
-static unsigned long p2m_missing[P2M_ENTRIES_PER_PAGE] __page_aligned_data =
-		{ [ 0 ... P2M_ENTRIES_PER_PAGE-1 ] = ~0UL };
+static unsigned long *p2m_missing;
 
  /* Array of pointers to pages containing p2m entries */
-static unsigned long *p2m_top[TOP_ENTRIES] __page_aligned_data =
-		{ [ 0 ... TOP_ENTRIES - 1] = &p2m_missing[0] };
+static unsigned long **p2m_top;
 
 /* Arrays of p2m arrays expressed in mfns used for save/restore */
-static unsigned long p2m_top_mfn[TOP_ENTRIES] __page_aligned_bss;
-
-static unsigned long p2m_top_mfn_list[TOP_ENTRIES / P2M_ENTRIES_PER_PAGE]
-	__page_aligned_bss;
+static unsigned long *p2m_top_mfn;
+static unsigned long *p2m_top_mfn_list;
 
 static inline unsigned p2m_top_index(unsigned long pfn)
 {
@@ -183,18 +179,28 @@ static inline unsigned p2m_index(unsigned long pfn)
 	return pfn % P2M_ENTRIES_PER_PAGE;
 }
 
+#define SIZE_TOP_MFN sizeof(*p2m_top_mfn) * TOP_ENTRIES
+#define SIZE_TOP_MFN_LIST sizeof(*p2m_top_mfn_list) *			\
+	(TOP_ENTRIES / P2M_ENTRIES_PER_PAGE)
+
+RESERVE_BRK(xen_top_mfn, SIZE_TOP_MFN);
+RESERVE_BRK(xen_top_mfn_list, SIZE_TOP_MFN_LIST);
+
 /* Build the parallel p2m_top_mfn structures */
 void xen_setup_mfn_list_list(void)
 {
 	unsigned pfn, idx;
 
+	p2m_top_mfn = extend_brk(SIZE_TOP_MFN, PAGE_SIZE);
+	p2m_top_mfn_list = extend_brk(SIZE_TOP_MFN_LIST, PAGE_SIZE);
+
 	for (pfn = 0; pfn < MAX_DOMAIN_PAGES; pfn += P2M_ENTRIES_PER_PAGE) {
 		unsigned topidx = p2m_top_index(pfn);
 
 		p2m_top_mfn[topidx] = virt_to_mfn(p2m_top[topidx]);
 	}
 
-	for (idx = 0; idx < ARRAY_SIZE(p2m_top_mfn_list); idx++) {
+	for (idx = 0; idx < (TOP_ENTRIES / P2M_ENTRIES_PER_PAGE); idx++) {
 		unsigned topidx = idx * P2M_ENTRIES_PER_PAGE;
 		p2m_top_mfn_list[idx] = virt_to_mfn(&p2m_top_mfn[topidx]);
 	}
@@ -206,12 +212,26 @@ void xen_setup_mfn_list_list(void)
 	HYPERVISOR_shared_info->arch.max_pfn = xen_start_info->nr_pages;
 }
 
+#define SIZE_P2M_MISSING	sizeof(*p2m_missing) * P2M_ENTRIES_PER_PAGE
+#define SIZE_P2M_TOP		sizeof(*p2m_top) * TOP_ENTRIES
+RESERVE_BRK(xen_p2m_missing, SIZE_P2M_MISSING);
+RESERVE_BRK(xen_p2m_top, SIZE_P2M_TOP);
+
 /* Set up p2m_top to point to the domain-builder provided p2m pages */
 void __init xen_build_dynamic_phys_to_machine(void)
 {
 	unsigned long *mfn_list = (unsigned long *)xen_start_info->mfn_list;
 	unsigned long max_pfn = min(MAX_DOMAIN_PAGES, xen_start_info->nr_pages);
 	unsigned pfn;
+	unsigned i;
+
+	p2m_missing = extend_brk(SIZE_P2M_MISSING, PAGE_SIZE);
+	for(i = 0; i < P2M_ENTRIES_PER_PAGE; i++)
+		p2m_missing[i] = ~0ul;
+
+	p2m_top = extend_brk(SIZE_P2M_TOP, PAGE_SIZE);
+	for(i = 0; i < TOP_ENTRIES; i++)
+		p2m_top[i] = p2m_missing;
 
 	for (pfn = 0; pfn < max_pfn; pfn += P2M_ENTRIES_PER_PAGE) {
 		unsigned topidx = p2m_top_index(pfn);
-- 
1.6.0.6

