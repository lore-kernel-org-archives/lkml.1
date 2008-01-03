Return-Path: <linux-kernel-owner+w=401wt.eu-S1759003AbYACPbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759003AbYACPbp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 10:31:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752258AbYACPYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 10:24:46 -0500
Received: from ns1.suse.de ([195.135.220.2]:46768 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752080AbYACPYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 10:24:41 -0500
From: Andi Kleen <ak@suse.de>
References: <20080103424.989432000@suse.de>
In-Reply-To: <20080103424.989432000@suse.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH CPA] [25/28] CPA: Always do full TLB flush when splitting large pages
Message-Id: <20080103152440.8839714E23@wotan.suse.de>
Date: Thu,  3 Jan 2008 16:24:40 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Various CPUs have errata when using INVLPG to flush large pages.
This includes Intel Penryn (AV2) and AMD K7 (#16 in Athlon 4) 
While these happen only in specific circumstances it is still
a little risky and it's not clear the kernel can avoid them all.

Avoid this can of worms by always flushing the full TLB (but 
not the full cache) when splitting a large page. This should
not be that expensive anyways and initial splitting should be
hopefully infrequent.

This also removes the previously hard coded workaround for K7 
Athlon on 32bit.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/mm/pageattr_32.c |   17 +++++++++++------
 arch/x86/mm/pageattr_64.c |   11 +++++++++--
 2 files changed, 20 insertions(+), 8 deletions(-)

Index: linux/arch/x86/mm/pageattr_32.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr_32.c
+++ linux/arch/x86/mm/pageattr_32.c
@@ -113,10 +113,7 @@ static void flush_kernel_map(void *arg)
 		}
 	}
 
-	/* Handle errata with flushing large pages in early Athlons */
-	if (a->full_flush ||
-	    (boot_cpu_data.x86_vendor == X86_VENDOR_AMD &&
-	     boot_cpu_data.x86 == 7))
+	if (a->full_flush)
 		__flush_tlb_all();
 
 	/*
@@ -198,7 +195,7 @@ static int cache_attr_changed(pte_t pte,
  * data structure to keep track of the flush. This has the added bonus that it will
  * work for MMIO holes without mem_map too.
  */
-static void set_tlb_flush(unsigned long address, int cache)
+static void set_tlb_flush(unsigned long address, int cache, int large)
 {
 	enum flush_mode mode = cache ? FLUSH_CACHE : FLUSH_TLB;
 	struct flush *f = kmalloc(sizeof(struct flush), GFP_KERNEL);
@@ -210,6 +207,13 @@ static void set_tlb_flush(unsigned long 
 	f->addr = address;
 	f->mode = mode;
 	list_add_tail(&f->l, &flush_pages);
+
+	/*
+	 * Work around large page INVLPG bugs in early K7 and in Penryn.
+ 	 * When we split a large page always do a full TLB flush.
+	 */
+	if (large && full_flush < FLUSH_TLB)
+		full_flush = FLUSH_TLB;
 }
 
 static int
@@ -230,7 +234,8 @@ __change_page_attr(struct page *page, pg
 	BUG_ON(PageLRU(kpte_page));
 	BUG_ON(PageCompound(kpte_page));
 
-	set_tlb_flush(address, cache_attr_changed(*kpte, prot, level));
+	set_tlb_flush(address, cache_attr_changed(*kpte, prot, level),
+			level < 3);
 
 	if (pgprot_val(prot) != pgprot_val(PAGE_KERNEL)) { 
 		if (level == 3) {
Index: linux/arch/x86/mm/pageattr_64.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr_64.c
+++ linux/arch/x86/mm/pageattr_64.c
@@ -164,7 +164,7 @@ static void revert_page(unsigned long ad
  * data structure to keep track of the flush. This has the added bonus that it will
  * work for MMIO holes without mem_map too.
  */
-static void set_tlb_flush(unsigned long address, int cache)
+static void set_tlb_flush(unsigned long address, int cache, int large)
 {
 	enum flush_mode mode = cache ? FLUSH_CACHE : FLUSH_TLB;
 	struct flush *f = kmalloc(sizeof(struct flush), GFP_KERNEL);
@@ -177,6 +177,13 @@ static void set_tlb_flush(unsigned long 
 	f->addr = address;
 	f->mode = mode;
 	list_add_tail(&f->l, &flush_pages);
+
+	/*
+	 * Work around large page INVLPG bugs in early K7 and in Penryn.
+ 	 * When we split a large page always do a full TLB flush.
+	 */
+	if (large && full_flush < FLUSH_TLB)
+		full_flush = FLUSH_TLB;
 }
 
 static unsigned short pat_bit[5] = {
@@ -208,7 +215,7 @@ __change_page_attr(unsigned long address
 	BUG_ON(PageCompound(kpte_page));
 	BUG_ON(PageLRU(kpte_page));
 
-	set_tlb_flush(address, cache_attr_changed(*kpte, prot, level));
+	set_tlb_flush(address, cache_attr_changed(*kpte, prot, level), level < 4);
 
 	if (pgprot_val(prot) != pgprot_val(ref_prot)) { 
 		if (level == 4) {
