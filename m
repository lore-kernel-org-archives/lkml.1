Return-Path: <linux-kernel-owner+w=401wt.eu-S1757082AbYACPc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757082AbYACPc2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 10:32:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754699AbYACPYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 10:24:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43036 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260AbYACPYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 10:24:44 -0500
From: Andi Kleen <ak@suse.de>
References: <20080103424.989432000@suse.de>
In-Reply-To: <20080103424.989432000@suse.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH CPA] [27/28] CPA: Change comments of external interfaces to kerneldoc format
Message-Id: <20080103152442.BA56414E23@wotan.suse.de>
Date: Thu,  3 Jan 2008 16:24:42 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


And clarify description a bit.

Only for 64bit, but the interfaces are identical for 32bit and kerneldoc should
merge them (?) 

Signed-off-by: Andi Kleen <ak@suse.de>

---
 Documentation/DocBook/kernel-api.tmpl |    8 +++++
 arch/x86/mm/pageattr_64.c             |   46 +++++++++++++++++++++++++---------
 2 files changed, 42 insertions(+), 12 deletions(-)

Index: linux/arch/x86/mm/pageattr_64.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr_64.c
+++ linux/arch/x86/mm/pageattr_64.c
@@ -265,19 +265,19 @@ __change_page_attr(unsigned long address
 	return 0;
 } 
 
-/*
- * Change the page attributes of an page in the linear mapping.
- *
- * This should be used when a page is mapped with a different caching policy
- * than write-back somewhere - some CPUs do not like it when mappings with
- * different caching policies exist. This changes the page attributes of the
- * in kernel linear mapping too.
+/**
+ * change_page_attr_addr - Change page table attributes in linear mapping
+ * @address: Virtual address in linear mapping.
+ * @numpages: Number of pages to change
+ * @prot:    New page table attribute (PAGE_*)
  * 
- * The caller needs to ensure that there are no conflicting mappings elsewhere.
- * This function only deals with the kernel linear map.
- * 
- * Caller must call global_flush_tlb() after this.
+ * Change page attributes of a page in the direct mapping. This is a variant
+ * of change_page_attr() that also works on memory holes that do not have
+ * mem_map entry (pfn_valid() is false).
+ *
+ * See change_page_attr() documentation for more details.
  */
+
 int change_page_attr_addr(unsigned long address, int numpages, pgprot_t prot)
 {
 	int err = 0, kernel_map = 0;
@@ -314,13 +314,35 @@ int change_page_attr_addr(unsigned long 
 	return err;
 }
 
-/* Don't call this for MMIO areas that may not have a mem_map entry */
+/**
+ * change_page_attr - Change page table attributes in the linear mapping.
+ * @page: First page to change
+ * @numpages: Number of pages to change
+ * @prot: New protection/caching type (PAGE_*)
+ *
+ * Returns 0 on success, otherwise a negated errno.
+ *
+ * This should be used when a page is mapped with a different caching policy
+ * than write-back somewhere - some CPUs do not like it when mappings with
+ * different caching policies exist. This changes the page attributes of the
+ * in kernel linear mapping too.
+ *
+ * Caller must call global_flush_tlb() later to make the changes active.
+ *
+ * The caller needs to ensure that there are no conflicting mappings elsewhere
+ * (e.g. in user space) * This function only deals with the kernel linear map.
+ *
+ * For MMIO areas without mem_map use change_page_attr_addr() instead.
+ */
 int change_page_attr(struct page *page, int numpages, pgprot_t prot)
 {
 	unsigned long addr = (unsigned long)page_address(page);
 	return change_page_attr_addr(addr, numpages, prot);
 }
 
+/**
+ * global_flush_tlb - Flush linear mappings changed by change_page_attr()
+ */
 void global_flush_tlb(void)
 { 
 	struct page *pg, *next;
Index: linux/Documentation/DocBook/kernel-api.tmpl
===================================================================
--- linux.orig/Documentation/DocBook/kernel-api.tmpl
+++ linux/Documentation/DocBook/kernel-api.tmpl
@@ -726,4 +726,12 @@ X!Idrivers/video/console/fonts.c
 !Ffs/pipe.c
   </chapter>
 
+  <chapter id="pageattr">
+	<title>Kernel direct mapping paging attributes</title>
+  <para>
+	Changing the paging attributes of kernel direct mapping pages
+	on x86.
+  </para>
+!Farch/x86/mm/pageattr_64.c
+  </chapter>
 </book>
