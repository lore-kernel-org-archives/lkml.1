Return-Path: <linux-kernel-owner+w=401wt.eu-S1757996AbYG0PpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757996AbYG0PpU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 11:45:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752046AbYG0PpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 11:45:06 -0400
Received: from gw.goop.org ([64.81.55.164]:44164 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751224AbYG0PpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 11:45:04 -0400
Message-ID: <488C97FE.2010606@goop.org>
Date: Sun, 27 Jul 2008 08:45:02 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] xen: fix allocation and use of large ldts
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the ldt gets to more than 1 page in size, the kernel uses vmalloc
to allocate it.  This means that:
 - when making the ldt RO, we must update the pages in both the vmalloc
   mapping and the linear mapping to make sure there are no RW aliases.
 - we need to use arbitrary_virt_to_machine to compute the machine addr
   for each update

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/enlighten.c |   49 ++++++++++++++++++++++++++++++++++++----------
 1 file changed, 39 insertions(+), 10 deletions(-)

===================================================================
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -305,24 +305,53 @@
 	return 0;
 }
 
+/* If 'v' is a vmalloc mapping, then find the linear mapping of the
+   page (if any) and also set its protections to match. */
+static void set_aliased_prot(void *v, pgprot_t prot)
+{
+	int level;
+	pte_t *ptep;
+	pte_t pte;
+	unsigned long pfn;
+	struct page *page;
+
+	ptep = lookup_address((unsigned long)v, &level);
+	BUG_ON(ptep == NULL);
+
+	pfn = pte_pfn(*ptep);
+	page = pfn_to_page(pfn);
+
+	pte = pfn_pte(pfn, prot);
+
+	if (HYPERVISOR_update_va_mapping((unsigned long)v, pte, 0))
+		BUG();
+
+	if (!PageHighMem(page)) {
+		void *av = __va(PFN_PHYS(pfn));
+
+		if (av != v)
+			if (HYPERVISOR_update_va_mapping((unsigned long)av, pte, 0))
+				BUG();
+	} else
+		kmap_flush_unused();
+}
+
 static void xen_alloc_ldt(struct desc_struct *ldt, unsigned entries)
 {
-	unsigned pages = roundup(entries * LDT_ENTRY_SIZE, PAGE_SIZE);
-	void *v = ldt;
+	const unsigned entries_per_page = PAGE_SIZE / LDT_ENTRY_SIZE;
 	int i;
 
-	for(i = 0; i < pages; i += PAGE_SIZE)
-		make_lowmem_page_readonly(v + i);
+	for(i = 0; i < entries; i += entries_per_page)
+		set_aliased_prot(ldt + i, PAGE_KERNEL_RO);
 }
 
 static void xen_free_ldt(struct desc_struct *ldt, unsigned entries)
 {
-	unsigned pages = roundup(entries * LDT_ENTRY_SIZE, PAGE_SIZE);
-	void *v = ldt;
+	const unsigned entries_per_page = PAGE_SIZE / LDT_ENTRY_SIZE;
 	int i;
 
-	for(i = 0; i < pages; i += PAGE_SIZE)
-		make_lowmem_page_readwrite(v + i);
+	for(i = 0; i < entries; i += entries_per_page)
+		set_aliased_prot(ldt + i, PAGE_KERNEL);
 }
 
 static void xen_set_ldt(const void *addr, unsigned entries)
@@ -426,7 +455,7 @@
 				const void *ptr)
 {
 	unsigned long lp = (unsigned long)&dt[entrynum];
-	xmaddr_t mach_lp = virt_to_machine(lp);
+	xmaddr_t mach_lp = arbitrary_virt_to_machine(lp);
 	u64 entry = *(u64 *)ptr;
 
 	preempt_disable();
@@ -559,7 +588,7 @@
 }
 
 static void xen_load_sp0(struct tss_struct *tss,
-			  struct thread_struct *thread)
+			 struct thread_struct *thread)
 {
 	struct multicall_space mcs = xen_mc_entry(0);
 	MULTI_stack_switch(mcs.mc, __KERNEL_DS, thread->sp0);


