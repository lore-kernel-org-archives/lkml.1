Return-Path: <linux-kernel-owner+w=401wt.eu-S1752664AbZHCHZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664AbZHCHZs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 03:25:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752439AbZHCHZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 03:25:48 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:42144 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752368AbZHCHZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 03:25:47 -0400
From: Thomas Hellstrom <thellstrom@vmware.com>
To: linux-kernel@vger.kernel.org
Cc: dri-devel@lists.sourceforge.net, hpa@zytor.com, mingo@elte.hu,
       tglx@linutronix.de, venkatesh.pallipadi@intel.com,
       suresh.b.siddha@intel.com, Thomas Hellstrom <thellstrom@vmware.com>
Subject: [PATCH] x86: Fix CPA memtype reserving in the set_pages_array cases
Date: Mon,  3 Aug 2009 09:25:45 +0200
Message-Id: <1249284345-7654-1-git-send-email-thellstrom@vmware.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bug #13884
The code was incorrectly reserving memtypes using the page
virtual address instead of the physical address. Furthermore,
the code was not ignoring highmem pages as it ought to.

Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
---
 arch/x86/mm/pageattr.c |   30 +++++++++++++++++++++---------
 1 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index d4327db..96dd4f6 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -590,9 +590,12 @@ static int __change_page_attr(struct cpa_data *cpa, int primary)
 	unsigned int level;
 	pte_t *kpte, old_pte;
 
-	if (cpa->flags & CPA_PAGES_ARRAY)
-		address = (unsigned long)page_address(cpa->pages[cpa->curpage]);
-	else if (cpa->flags & CPA_ARRAY)
+	if (cpa->flags & CPA_PAGES_ARRAY) {
+		struct page *page = cpa->pages[cpa->curpage];
+		if (unlikely(PageHighMem(page)))
+			return 0;
+		address = (unsigned long)page_address(page);
+	} else if (cpa->flags & CPA_ARRAY)
 		address = cpa->vaddr[cpa->curpage];
 	else
 		address = *cpa->vaddr;
@@ -696,9 +699,12 @@ static int cpa_process_alias(struct cpa_data *cpa)
 	 * No need to redo, when the primary call touched the direct
 	 * mapping already:
 	 */
-	if (cpa->flags & CPA_PAGES_ARRAY)
-		vaddr = (unsigned long)page_address(cpa->pages[cpa->curpage]);
-	else if (cpa->flags & CPA_ARRAY)
+	if (cpa->flags & CPA_PAGES_ARRAY) {
+		struct page *page = cpa->pages[cpa->curpage];
+		if (unlikely(PageHighMem(page)))
+			return 0;
+		vaddr = (unsigned long)page_address(page);
+	} else if (cpa->flags & CPA_ARRAY)
 		vaddr = cpa->vaddr[cpa->curpage];
 	else
 		vaddr = *cpa->vaddr;
@@ -1118,7 +1124,9 @@ int set_pages_array_uc(struct page **pages, int addrinarray)
 	int free_idx;
 
 	for (i = 0; i < addrinarray; i++) {
-		start = (unsigned long)page_address(pages[i]);
+		if (PageHighMem(pages[i]))
+			continue;
+		start = page_to_pfn(pages[i]) << PAGE_SHIFT;
 		end = start + PAGE_SIZE;
 		if (reserve_memtype(start, end, _PAGE_CACHE_UC_MINUS, NULL))
 			goto err_out;
@@ -1131,7 +1139,9 @@ int set_pages_array_uc(struct page **pages, int addrinarray)
 err_out:
 	free_idx = i;
 	for (i = 0; i < free_idx; i++) {
-		start = (unsigned long)page_address(pages[i]);
+		if (PageHighMem(pages[i]))
+			continue;
+		start = page_to_pfn(pages[i]) << PAGE_SHIFT;
 		end = start + PAGE_SIZE;
 		free_memtype(start, end);
 	}
@@ -1160,7 +1170,9 @@ int set_pages_array_wb(struct page **pages, int addrinarray)
 		return retval;
 
 	for (i = 0; i < addrinarray; i++) {
-		start = (unsigned long)page_address(pages[i]);
+		if (PageHighMem(pages[i]))
+			continue;
+		start = page_to_pfn(pages[i]) << PAGE_SHIFT;
 		end = start + PAGE_SIZE;
 		free_memtype(start, end);
 	}
-- 
1.5.4.3

