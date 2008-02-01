Return-Path: <linux-kernel-owner+w=401wt.eu-S1755069AbYBAJeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069AbYBAJeQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 04:34:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753270AbYBAJd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 04:33:59 -0500
Received: from mga02.intel.com ([134.134.136.20]:58521 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752937AbYBAJd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 04:33:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,289,1199692800"; 
   d="scan'208";a="256142917"
Subject: [PATCH 3/4] x86: update usage of set_memory_xx
From: "Huang, Ying" <ying.huang@intel.com>
To: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 01 Feb 2008 17:34:59 +0800
Message-Id: <1201858499.4051.19.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
X-OriginalArrivalTime: 01 Feb 2008 09:33:53.0807 (UTC) FILETIME=[8F6AF9F0:01C864B5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates the usage of set_memory_xx according to changes in
previous patch.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/kernel/pci-gart_64.c |    3 ++-
 arch/x86/mm/init_32.c         |    4 ++--
 arch/x86/mm/init_64.c         |    8 ++++----
 arch/x86/mm/ioremap.c         |    4 ++--
 4 files changed, 10 insertions(+), 9 deletions(-)

--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -91,10 +91,10 @@ static int ioremap_change_attr(unsigned 
 	switch (mode) {
 	case IOR_MODE_UNCACHED:
 	default:
-		err = set_memory_uc(vaddr, nrpages);
+		err = set_memory_uc(vaddr, paddr, nrpages);
 		break;
 	case IOR_MODE_CACHED:
-		err = set_memory_wb(vaddr, nrpages);
+		err = set_memory_wb(vaddr, paddr, nrpages);
 		break;
 	}
 
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -570,7 +570,8 @@ static __init int init_k8_gatt(struct ag
 	gatt = (void *)__get_free_pages(GFP_KERNEL, get_order(gatt_size));
 	if (!gatt)
 		panic("Cannot allocate GATT table");
-	if (set_memory_uc((unsigned long)gatt, gatt_size >> PAGE_SHIFT))
+	if (set_memory_uc((unsigned long)gatt, __pa(gatt),
+			  gatt_size >> PAGE_SHIFT))
 		panic("Could not set GART PTEs to uncacheable pages");
 
 	memset(gatt, 0, gatt_size);
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -610,7 +610,7 @@ void free_init_pages(char *what, unsigne
 #ifdef CONFIG_DEBUG_PAGEALLOC
 	printk(KERN_INFO "debug: unmapping init memory %08lx..%08lx\n",
 		begin, PAGE_ALIGN(end));
-	set_memory_np(begin, (end - begin) >> PAGE_SHIFT);
+	set_memory_np(begin, __pa(begin), (end - begin) >> PAGE_SHIFT);
 #else
 	printk(KERN_INFO "Freeing %s: %luk freed\n", what, (end - begin) >> 10);
 
@@ -656,7 +656,7 @@ void mark_rodata_ro(void)
 	if (end <= start)
 		return;
 
-	set_memory_ro(start, (end - start) >> PAGE_SHIFT);
+	set_memory_ro(start, __pa(start), (end - start) >> PAGE_SHIFT);
 
 	printk(KERN_INFO "Write protecting the kernel read-only data: %luk\n",
 	       (end - start) >> 10);
@@ -665,10 +665,10 @@ void mark_rodata_ro(void)
 
 #ifdef CONFIG_CPA_DEBUG
 	printk(KERN_INFO "Testing CPA: undo %lx-%lx\n", start, end);
-	set_memory_rw(start, (end-start) >> PAGE_SHIFT);
+	set_memory_rw(start, __pa(start), (end-start) >> PAGE_SHIFT);
 
 	printk(KERN_INFO "Testing CPA: again\n");
-	set_memory_ro(start, (end-start) >> PAGE_SHIFT);
+	set_memory_ro(start, __pa(start), (end-start) >> PAGE_SHIFT);
 #endif
 }
 #endif
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -788,7 +788,7 @@ void free_init_pages(char *what, unsigne
 	 */
 	printk(KERN_INFO "debug: unmapping init memory %08lx..%08lx\n",
 		begin, PAGE_ALIGN(end));
-	set_memory_np(begin, (end - begin) >> PAGE_SHIFT);
+	set_memory_np(begin, __pa(begin), (end - begin) >> PAGE_SHIFT);
 #else
 	unsigned long addr;
 
@@ -797,7 +797,7 @@ void free_init_pages(char *what, unsigne
 	 * we are going to free part of that, we need to make that
 	 * writeable first.
 	 */
-	set_memory_rw(begin, (end - begin) >> PAGE_SHIFT);
+	set_memory_rw(begin, __pa(begin), (end - begin) >> PAGE_SHIFT);
 
 	for (addr = begin; addr < end; addr += PAGE_SIZE) {
 		ClearPageReserved(virt_to_page(addr));

