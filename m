Return-Path: <linux-kernel-owner+w=401wt.eu-S932364AbZHMUHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932364AbZHMUHm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 16:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932296AbZHMUHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 16:07:40 -0400
Received: from kroah.org ([198.145.64.141]:41796 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932192AbZHMT7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:59:44 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:51:30 2009
Message-Id: <20090813195130.384492696@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:50:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Thomas Hellstrom <thellstrom@vmware.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       dri-devel@lists.sourceforge.net, venkatesh.pallipadi@intel.com,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 39/74] x86: Fix CPA memtype reserving in the set_pages_array*() cases
References: <20090813194935.985368088@mini.kroah.org>
Content-Disposition: inline; filename=x86-fix-cpa-memtype-reserving-in-the-set_pages_array-cases.patch
In-Reply-To: <20090813195705.GA22393@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Thomas Hellstrom <thellstrom@vmware.com>

commit 8523acfe40efc1a8d3da8f473ca67cb195b06f0c upstream.

The code was incorrectly reserving memtypes using the page
virtual address instead of the physical address. Furthermore,
the code was not ignoring highmem pages as it ought to.

( upstream does not pass in highmem pages yet - but upcoming
  graphics code will do it and there's no reason to not handle
  this properly in the CPA APIs.)

Fixes: http://bugzilla.kernel.org/show_bug.cgi?id=13884

Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: dri-devel@lists.sourceforge.net
Cc: venkatesh.pallipadi@intel.com
LKML-Reference: <1249284345-7654-1-git-send-email-thellstrom@vmware.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/mm/pageattr.c |   30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -590,9 +590,12 @@ static int __change_page_attr(struct cpa
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
@@ -695,9 +698,12 @@ static int cpa_process_alias(struct cpa_
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
@@ -1118,7 +1124,9 @@ int set_pages_array_uc(struct page **pag
 	int free_idx;
 
 	for (i = 0; i < addrinarray; i++) {
-		start = (unsigned long)page_address(pages[i]);
+		if (PageHighMem(pages[i]))
+			continue;
+		start = page_to_pfn(pages[i]) << PAGE_SHIFT;
 		end = start + PAGE_SIZE;
 		if (reserve_memtype(start, end, _PAGE_CACHE_UC_MINUS, NULL))
 			goto err_out;
@@ -1131,7 +1139,9 @@ int set_pages_array_uc(struct page **pag
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
@@ -1160,7 +1170,9 @@ int set_pages_array_wb(struct page **pag
 		return retval;
 
 	for (i = 0; i < addrinarray; i++) {
-		start = (unsigned long)page_address(pages[i]);
+		if (PageHighMem(pages[i]))
+			continue;
+		start = page_to_pfn(pages[i]) << PAGE_SHIFT;
 		end = start + PAGE_SIZE;
 		free_memtype(start, end);
 	}


