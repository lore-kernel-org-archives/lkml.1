Return-Path: <linux-kernel-owner+w=401wt.eu-S1753297AbZHCKwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297AbZHCKwj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 06:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752517AbZHCKwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 06:52:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:56111 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752281AbZHCKwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 06:52:37 -0400
Date: Mon, 3 Aug 2009 10:51:57 GMT
From: tip-bot for Thomas Hellstrom <thellstrom@vmware.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, mingo@elte.hu, thellstrom@vmware.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, thellstrom@vmware.com, mingo@elte.hu
In-Reply-To: <1249284345-7654-1-git-send-email-thellstrom@vmware.com>
References: <1249284345-7654-1-git-send-email-thellstrom@vmware.com>
Subject: [tip:x86/urgent] x86: Fix CPA memtype reserving in the set_pages_array*() cases
Message-ID: <tip-9e5b74fef5a7e8e408ba514db8dee5320e633d40@git.kernel.org>
Git-Commit-ID: 9e5b74fef5a7e8e408ba514db8dee5320e633d40
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 03 Aug 2009 10:52:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9e5b74fef5a7e8e408ba514db8dee5320e633d40
Gitweb:     http://git.kernel.org/tip/9e5b74fef5a7e8e408ba514db8dee5320e633d40
Author:     Thomas Hellstrom <thellstrom@vmware.com>
AuthorDate: Mon, 3 Aug 2009 09:25:45 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 3 Aug 2009 12:47:56 +0200

x86: Fix CPA memtype reserving in the set_pages_array*() cases

The code was incorrectly reserving memtypes using the page
virtual address instead of the physical address. Furthermore,
the code was not ignoring highmem pages as it ought to.

( upstream does not pass in highmem pages yet - but upcoming
  graphics code will do it and there's no reason to not handle
  this properly in the CPA APIs.)

Fixes: http://bugzilla.kernel.org/show_bug.cgi?id=13884

Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
Cc: dri-devel@lists.sourceforge.net
Cc: venkatesh.pallipadi@intel.com
Cc: suresh.b.siddha@intel.com
LKML-Reference: <1249284345-7654-1-git-send-email-thellstrom@vmware.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/pageattr.c |   30 +++++++++++++++++++++---------
 1 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 895d90e..7e600c1 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -591,9 +591,12 @@ static int __change_page_attr(struct cpa_data *cpa, int primary)
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
@@ -697,9 +700,12 @@ static int cpa_process_alias(struct cpa_data *cpa)
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
@@ -1122,7 +1128,9 @@ int set_pages_array_uc(struct page **pages, int addrinarray)
 	int free_idx;
 
 	for (i = 0; i < addrinarray; i++) {
-		start = (unsigned long)page_address(pages[i]);
+		if (PageHighMem(pages[i]))
+			continue;
+		start = page_to_pfn(pages[i]) << PAGE_SHIFT;
 		end = start + PAGE_SIZE;
 		if (reserve_memtype(start, end, _PAGE_CACHE_UC_MINUS, NULL))
 			goto err_out;
@@ -1135,7 +1143,9 @@ int set_pages_array_uc(struct page **pages, int addrinarray)
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
@@ -1164,7 +1174,9 @@ int set_pages_array_wb(struct page **pages, int addrinarray)
 		return retval;
 
 	for (i = 0; i < addrinarray; i++) {
-		start = (unsigned long)page_address(pages[i]);
+		if (PageHighMem(pages[i]))
+			continue;
+		start = page_to_pfn(pages[i]) << PAGE_SHIFT;
 		end = start + PAGE_SIZE;
 		free_memtype(start, end);
 	}
