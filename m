Return-Path: <linux-kernel-owner+w=401wt.eu-S938747AbXGSOC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938747AbXGSOC2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 10:02:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764872AbXGSNtD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 09:49:03 -0400
Received: from ns2.suse.de ([195.135.220.15]:48650 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936432AbXGSNs7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 09:48:59 -0400
From: Andi Kleen <ak@suse.de>
References: <20070719348.540885000@suse.de>
In-Reply-To: <20070719348.540885000@suse.de>
To: jeremy@goop.org, hidave.darkstar@gmail.com, cebbert@redhat.com, ak@suse.de,
       linux-kernel@vger.kernel.org
Subject: [PATCH for review] [28/48] i386: fix iounmap's use of vm_struct's size field
Message-Id: <20070719134858.5752D14E6E@wotan.suse.de>
Date: Thu, 19 Jul 2007 15:48:58 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Jeremy Fitzhardinge <jeremy@goop.org>

get_vm_area always returns an area with an adjacent guard page.  That guard
page is included in vm_struct.size.  iounmap uses vm_struct.size to
determine how much address space needs to have change_page_attr applied to
it, which will BUG if applied to the guard page.

This patch adds a helper function - get_vm_area_size() in linux/vmalloc.h -
to return the actual size of a vm area, and uses it to make iounmap do the
right thing.  There are probably other places which should be using
get_vm_area_size().

Thanks to Dave Young <hidave.darkstar@gmail.com> for debugging the
problem.

[ Andi, it wasn't clear to me whether x86_64 needs the same fix. ]

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Dave Young <hidave.darkstar@gmail.com>
Cc: Chuck Ebbert <cebbert@redhat.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/mm/ioremap.c  |    2 +-
 include/linux/vmalloc.h |    7 +++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

Index: linux/arch/i386/mm/ioremap.c
===================================================================
--- linux.orig/arch/i386/mm/ioremap.c
+++ linux/arch/i386/mm/ioremap.c
@@ -196,7 +196,7 @@ void iounmap(volatile void __iomem *addr
 	/* Reset the direct mapping. Can block */
 	if ((p->flags >> 20) && p->phys_addr < virt_to_phys(high_memory) - 1) {
 		change_page_attr(virt_to_page(__va(p->phys_addr)),
-				 p->size >> PAGE_SHIFT,
+				 get_vm_area_size(p) >> PAGE_SHIFT,
 				 PAGE_KERNEL);
 		global_flush_tlb();
 	} 
Index: linux/include/linux/vmalloc.h
===================================================================
--- linux.orig/include/linux/vmalloc.h
+++ linux/include/linux/vmalloc.h
@@ -58,6 +58,13 @@ void vmalloc_sync_all(void);
 /*
  *	Lowlevel-APIs (not for driver use!)
  */
+
+static inline size_t get_vm_area_size(const struct vm_struct *area)
+{
+	/* return actual size without guard page */
+	return area->size - PAGE_SIZE;
+}
+
 extern struct vm_struct *get_vm_area(unsigned long size, unsigned long flags);
 extern struct vm_struct *__get_vm_area(unsigned long size, unsigned long flags,
 					unsigned long start, unsigned long end);
