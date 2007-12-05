Return-Path: <linux-kernel-owner+w=401wt.eu-S1756129AbXLEIAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129AbXLEIAu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 03:00:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754490AbXLEHzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 02:55:42 -0500
Received: from mx2.suse.de ([195.135.220.15]:42695 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752998AbXLEHzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 02:55:17 -0500
Message-Id: <20071205071627.685779000@nick.local0.net>
References: <20071205071547.701344000@nick.local0.net>
User-Agent: quilt/0.46-14
Date: Wed, 05 Dec 2007 18:15:56 +1100
From: npiggin@suse.de
To: akpm@linux-foundation.org
Cc: rth@twiddle.net, ink@jurassic.park.msu.ru, linux-kernel@vger.kernel.org
Subject: [patch 09/18] agp: alpha nopage
Content-Disposition: inline; filename=agp-alpha-nopage.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert AGP alpha driver from nopage to fault.
NULL is NOPAGE_SIGBUS, so we aren't changing behaviour there.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: rth@twiddle.net
Cc: ink@jurassic.park.msu.ru
Cc: linux-kernel@vger.kernel.org
---
 drivers/char/agp/alpha-agp.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

Index: linux-2.6/drivers/char/agp/alpha-agp.c
===================================================================
--- linux-2.6.orig/drivers/char/agp/alpha-agp.c
+++ linux-2.6/drivers/char/agp/alpha-agp.c
@@ -11,29 +11,28 @@
 
 #include "agp.h"
 
-static struct page *alpha_core_agp_vm_nopage(struct vm_area_struct *vma,
-					     unsigned long address,
-					     int *type)
+static int alpha_core_agp_vm_fault(struct vm_area_struct *vma,
+					struct vm_fault *vmf)
 {
 	alpha_agp_info *agp = agp_bridge->dev_private_data;
 	dma_addr_t dma_addr;
 	unsigned long pa;
 	struct page *page;
 
-	dma_addr = address - vma->vm_start + agp->aperture.bus_base;
+	dma_addr = (unsigned long)vmf->virtual_address - vma->vm_start
+						+ agp->aperture.bus_base;
 	pa = agp->ops->translate(agp, dma_addr);
 
 	if (pa == (unsigned long)-EINVAL)
-		return NULL;	/* no translation */
+		return VM_FAULT_SIGBUS;	/* no translation */
 
 	/*
 	 * Get the page, inc the use count, and return it
 	 */
 	page = virt_to_page(__va(pa));
 	get_page(page);
-	if (type)
-		*type = VM_FAULT_MINOR;
-	return page;
+	vmf->page = page;
+	return 0;
 }
 
 static struct aper_size_info_fixed alpha_core_agp_sizes[] =
@@ -42,7 +41,7 @@ static struct aper_size_info_fixed alpha
 };
 
 struct vm_operations_struct alpha_core_agp_vm_ops = {
-	.nopage = alpha_core_agp_vm_nopage,
+	.fault = alpha_core_agp_vm_fault,
 };
 
 

-- 

