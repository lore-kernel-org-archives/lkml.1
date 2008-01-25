Return-Path: <linux-kernel-owner+w=401wt.eu-S1758160AbYAYWuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758160AbYAYWuT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 17:50:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754317AbYAYWuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 17:50:04 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:44263 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938AbYAYWuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 17:50:01 -0500
Date: Fri, 25 Jan 2008 14:49:37 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, tglx@tglx.de, hpa@zytor.com
Subject: [patch 1/3] x86: a new API for drivers/etc to control cache and
 other page attributes
Message-ID: <20080125144937.2709f9ae@laptopd505.fenrus.org>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Subject: x86: a new API for drivers/etc to control cache and other page attributes
From: Arjan van de Ven <arjan@linux.intel.com>

Right now, if drivers or other code want to change, say, a cache attribute of a
page, the only API they have is change_page_attr(). c-p-a is a really bad API
for this, because it forces the caller to know *ALL* the attributes he wants
for the page, not just the 1 thing he wants to change. So code that wants to
set a page uncachable, needs to be aware of the NX status as well etc etc etc.

This patch introduces a set of new APIs for this, set_pages_<attr> and 
set_memory_<attr>, that offer a logical change to the user, and leave all
attributes not implied by the requested logical change alone.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

---
 arch/x86/mm/pageattr.c       |  197 +++++++++++++++++++++++++++++++++++++++++++
 include/asm-x86/cacheflush.h |   15 +++
 2 files changed, 212 insertions(+)

Index: linux.trees.git/arch/x86/mm/pageattr.c
===================================================================
--- linux.trees.git.orig/arch/x86/mm/pageattr.c
+++ linux.trees.git/arch/x86/mm/pageattr.c
@@ -215,6 +215,8 @@ repeat:
  * mem_map entry (pfn_valid() is false).
  *
  * See change_page_attr() documentation for more details.
+ *
+ * Modules and drivers should use the set_memory_* APIs instead.
  */
 
 int change_page_attr_addr(unsigned long address, int numpages, pgprot_t prot)
@@ -277,6 +279,8 @@ int change_page_attr_addr(unsigned long 
  * (e.g. in user space) * This function only deals with the kernel linear map.
  *
  * For MMIO areas without mem_map use change_page_attr_addr() instead.
+ *
+ * Modules and drivers should use the set_pages_* APIs instead.
  */
 int change_page_attr(struct page *page, int numpages, pgprot_t prot)
 {
@@ -286,6 +290,199 @@ int change_page_attr(struct page *page, 
 }
 EXPORT_SYMBOL(change_page_attr);
 
+/**
+ * change_page_attr_set - Change page table attributes in the linear mapping.
+ * @addr: Virtual address in linear mapping.
+ * @numpages: Number of pages to change
+ * @prot: Protection/caching type bits to set (PAGE_*)
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
+ * This function is different from change_page_attr() in that only selected bits
+ * are impacted, all other bits remain as is.
+ */
+int change_page_attr_set(unsigned long addr, int numpages, pgprot_t prot)
+{
+	pgprot_t current_prot;
+	int level;
+	pte_t *pte;
+
+	pte = lookup_address(addr, &level);
+	if (pte)
+		current_prot = pte_pgprot(*pte);
+	else
+		pgprot_val(current_prot) = 0;
+
+	pgprot_val(prot) = pgprot_val(current_prot) | pgprot_val(prot);
+
+	return change_page_attr_addr(addr, numpages, prot);
+}
+
+/**
+ * change_page_attr_clear - Change page table attributes in the linear mapping.
+ * @addr: Virtual address in linear mapping.
+ * @numpages: Number of pages to change
+ * @prot: Protection/caching type bits to clear (PAGE_*)
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
+ * This function is different from change_page_attr() in that only selected bits
+ * are impacted, all other bits remain as is.
+ */
+int change_page_attr_clear(unsigned long addr, int numpages, pgprot_t prot)
+{
+	pgprot_t current_prot;
+	int level;
+	pte_t *pte;
+
+	pte = lookup_address(addr, &level);
+	if (pte)
+		current_prot = pte_pgprot(*pte);
+	else
+		pgprot_val(current_prot) = 0;
+
+	pgprot_val(prot) = pgprot_val(current_prot) & ~pgprot_val(prot);
+
+	return change_page_attr_addr(addr, numpages, prot);
+}
+
+
+
+int set_memory_uc(unsigned long addr, int numpages)
+{
+	pgprot_t uncached;
+
+	pgprot_val(uncached) = _PAGE_PCD | _PAGE_PWT;
+	return change_page_attr_set(addr, numpages, uncached);
+}
+EXPORT_SYMBOL(set_memory_uc);
+
+int set_memory_cached(unsigned long addr, int numpages)
+{
+	pgprot_t uncached;
+
+	pgprot_val(uncached) = _PAGE_PCD | _PAGE_PWT;
+	return change_page_attr_clear(addr, numpages, uncached);
+}
+EXPORT_SYMBOL(set_memory_cached);
+
+int set_memory_x(unsigned long addr, int numpages)
+{
+	pgprot_t nx;
+
+	pgprot_val(nx) = _PAGE_NX;
+	return change_page_attr_clear(addr, numpages, nx);
+}
+EXPORT_SYMBOL(set_memory_x);
+
+int set_memory_nx(unsigned long addr, int numpages)
+{
+	pgprot_t nx;
+
+	pgprot_val(nx) = _PAGE_NX;
+	return change_page_attr_set(addr, numpages, nx);
+}
+EXPORT_SYMBOL(set_memory_nx);
+
+int set_memory_ro(unsigned long addr, int numpages)
+{
+	pgprot_t rw;
+
+	pgprot_val(rw) = _PAGE_RW;
+	return change_page_attr_clear(addr, numpages, rw);
+}
+EXPORT_SYMBOL(set_memory_ro);
+
+int set_memory_rw(unsigned long addr, int numpages)
+{
+	pgprot_t rw;
+
+	pgprot_val(rw) = _PAGE_RW;
+	return change_page_attr_set(addr, numpages, rw);
+}
+EXPORT_SYMBOL(set_memory_rw);
+
+int set_pages_uc(struct page *page, int numpages)
+{
+	unsigned long addr = (unsigned long)page_address(page);
+	pgprot_t uncached;
+
+	pgprot_val(uncached) = _PAGE_PCD | _PAGE_PWT;
+	return change_page_attr_set(addr, numpages, uncached);
+}
+EXPORT_SYMBOL(set_pages_uc);
+
+int set_pages_cached(struct page *page, int numpages)
+{
+	unsigned long addr = (unsigned long)page_address(page);
+	pgprot_t uncached;
+
+	pgprot_val(uncached) = _PAGE_PCD | _PAGE_PWT;
+	return change_page_attr_clear(addr, numpages, uncached);
+}
+EXPORT_SYMBOL(set_pages_cached);
+
+int set_pages_x(struct page *page, int numpages)
+{
+	unsigned long addr = (unsigned long)page_address(page);
+	pgprot_t nx;
+
+	pgprot_val(nx) = _PAGE_NX;
+	return change_page_attr_clear(addr, numpages, nx);
+}
+EXPORT_SYMBOL(set_pages_x);
+
+int set_pages_nx(struct page *page, int numpages)
+{
+	unsigned long addr = (unsigned long)page_address(page);
+	pgprot_t nx;
+
+	pgprot_val(nx) = _PAGE_NX;
+	return change_page_attr_set(addr, numpages, nx);
+}
+EXPORT_SYMBOL(set_pages_nx);
+
+int set_pages_ro(struct page *page, int numpages)
+{
+	unsigned long addr = (unsigned long)page_address(page);
+	pgprot_t rw;
+
+	pgprot_val(rw) = _PAGE_RW;
+	return change_page_attr_clear(addr, numpages, rw);
+}
+EXPORT_SYMBOL(set_pages_ro);
+
+int set_pages_rw(struct page *page, int numpages)
+{
+	unsigned long addr = (unsigned long)page_address(page);
+	pgprot_t rw;
+
+	pgprot_val(rw) = _PAGE_RW;
+	return change_page_attr_set(addr, numpages, rw);
+}
+EXPORT_SYMBOL(set_pages_rw);
+
+
 void clflush_cache_range(void *addr, int size)
 {
 	int i;
Index: linux.trees.git/include/asm-x86/cacheflush.h
===================================================================
--- linux.trees.git.orig/include/asm-x86/cacheflush.h
+++ linux.trees.git/include/asm-x86/cacheflush.h
@@ -27,6 +27,21 @@
 void global_flush_tlb(void);
 int change_page_attr(struct page *page, int numpages, pgprot_t prot);
 int change_page_attr_addr(unsigned long addr, int numpages, pgprot_t prot);
+
+int set_pages_uc(struct page *page, int numpages);
+int set_pages_cached(struct page *page, int numpages);
+int set_pages_x(struct page *page, int numpages);
+int set_pages_nx(struct page *page, int numpages);
+int set_pages_ro(struct page *page, int numpages);
+int set_pages_rw(struct page *page, int numpages);
+
+int set_memory_uc(unsigned long addr, int numpages);
+int set_memory_cached(unsigned long addr, int numpages);
+int set_memory_x(unsigned long addr, int numpages);
+int set_memory_nx(unsigned long addr, int numpages);
+int set_memory_ro(unsigned long addr, int numpages);
+int set_memory_rw(unsigned long addr, int numpages);
+
 void clflush_cache_range(void *addr, int size);
 
 #ifdef CONFIG_DEBUG_RODATA

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
