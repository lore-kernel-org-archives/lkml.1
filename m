Return-Path: <linux-kernel-owner+w=401wt.eu-S1757161AbYAPWY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757161AbYAPWY0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 17:24:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754312AbYAPWPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 17:15:41 -0500
Received: from mx2.suse.de ([195.135.220.15]:38282 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753969AbYAPWP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 17:15:27 -0500
From: Andi Kleen <ak@suse.de>
References: <200801161114.239449000@suse.de>
In-Reply-To: <200801161114.239449000@suse.de>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       jbeulich@novell.com, venkatesh.pallipadi@intel.com
Subject: [PATCH] [26/36] CPA: Dump pagetable when inconsistency is detected
Message-Id: <20080116221526.08B80150C8@wotan.suse.de>
Date: Wed, 16 Jan 2008 23:15:25 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When c_p_a() detects a inconsistency in the kernel page tables 
it BUGs. When this happens dump the page table first to avoid one 
bug reporting round trip.

Signed-off-by: Andi Kleen <ak@suse.de>
Acked-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/mm/pageattr_32.c |   11 ++++++++++-
 arch/x86/mm/pageattr_64.c |   11 ++++++++++-
 2 files changed, 20 insertions(+), 2 deletions(-)

Index: linux/arch/x86/mm/pageattr_64.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr_64.c
+++ linux/arch/x86/mm/pageattr_64.c
@@ -12,6 +12,7 @@
 #include <asm/processor.h>
 #include <asm/tlbflush.h>
 #include <asm/io.h>
+#include <asm/kdebug.h>
 
 enum flush_mode { FLUSH_NONE, FLUSH_CACHE, FLUSH_TLB };
 
@@ -231,8 +232,16 @@ __change_page_attr(unsigned long address
 		set_pte(kpte, pfn_pte(pfn, ref_prot));
 		BUG_ON(page_private(kpte_page) == 0);
 		page_private(kpte_page)--;
-	} else
+	} else {
+		/*
+		 * When you're here you either set the same page to PAGE_KERNEL
+		 * two times in a row or the page table reference counting is
+		 * broken again. To catch the later bug for now (sorry)
+		 */
+		printk(KERN_ERR "address %lx\n", address);
+		dump_pagetable(address);
 		BUG();
+	}
 
 	save_page(kpte_page);
 	if (!PageReserved(kpte_page) && page_private(kpte_page) == 0)
Index: linux/arch/x86/mm/pageattr_32.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr_32.c
+++ linux/arch/x86/mm/pageattr_32.c
@@ -13,6 +13,7 @@
 #include <asm/tlbflush.h>
 #include <asm/pgalloc.h>
 #include <asm/sections.h>
+#include <asm/kdebug.h>
 
 #define PG_deferred PG_arch_1
 
@@ -252,8 +253,16 @@ __change_page_attr(struct page *page, pg
 		set_pte_atomic(kpte, mk_pte(page, PAGE_KERNEL));
 		BUG_ON(page_private(kpte_page) == 0);
 		page_private(kpte_page)--;
-	} else
+	} else {
+		/*
+		 * When you're here you either set the same page to PAGE_KERNEL
+		 * two times in a row or the page table reference counting is
+		 * broken again. To catch the later bug for now (sorry)
+		 */
+		printk(KERN_ERR "address %lx\n", address);
+		dump_pagetable(address);
 		BUG();
+	}
 
 	/*
 	 * If the pte was reserved, it means it was created at boot
