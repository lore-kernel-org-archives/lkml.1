Return-Path: <linux-kernel-owner+w=401wt.eu-S1755189AbZFYVwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189AbZFYVwr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 17:52:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752433AbZFYVwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 17:52:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:43572 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbZFYVwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 17:52:37 -0400
Subject: Re: [PATCH v2] IA64 Compilation Error Fix for Intel IOMMU Identity
 Mapping Support
From: David Woodhouse <dwmw2@infradead.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: fenghua.yu@intel.com, chrisw@redhat.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, tony.luck@intel.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       linux-ia64@vger.kernel.org
In-Reply-To: <1245913886.17089.91.camel@macbook.infradead.org>
References: <20090625003841.GA12226@linux-os.sc.intel.com>
	 <20090625095643F.fujita.tomonori@lab.ntt.co.jp>
	 <20090625041605.GA9330@linux-os.sc.intel.com>
	 <20090625134827W.fujita.tomonori@lab.ntt.co.jp>
	 <1245913886.17089.91.camel@macbook.infradead.org>
Content-Type: text/plain
Date: Thu, 25 Jun 2009 22:52:23 +0100
Message-Id: <1245966743.30355.42.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-25 at 08:11 +0100, David Woodhouse wrote:
> It raises the question: Why are we using firmware-specific interfaces to
> list the available memory -- can't we get that from somewhere _generic_?
> 
> The less we tie our code to these crappy BIOS, EFI and ACPI interfaces,
> the better off we'll be.

Does this work everywhere... ?

(Fenghua, why are we doing the whole setup per pci dev anyway -- why not
set up the page tables once and point all devices at the same page
tables?)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index e53eacd..1f0830a 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -39,7 +39,6 @@
 #include <linux/sysdev.h>
 #include <asm/cacheflush.h>
 #include <asm/iommu.h>
-#include <asm/e820.h>
 #include "pci.h"
 
 #define ROOT_SIZE		VTD_PAGE_SIZE
@@ -2081,7 +2080,6 @@ static int domain_add_dev_info(struct dmar_domain *domain,
 
 static int iommu_prepare_static_identity_mapping(void)
 {
-	int i;
 	struct pci_dev *pdev = NULL;
 	int ret;
 
@@ -2091,16 +2089,18 @@ static int iommu_prepare_static_identity_mapping(void)
 
 	printk(KERN_INFO "IOMMU: Setting identity map:\n");
 	for_each_pci_dev(pdev) {
-		for (i = 0; i < e820.nr_map; i++) {
-			struct e820entry *ei = &e820.map[i];
-
-			if (ei->type == E820_RAM) {
-				ret = iommu_prepare_identity_map(pdev,
-					ei->addr, ei->addr + ei->size);
-				if (ret)  {
-					printk(KERN_INFO "1:1 mapping to one domain failed.\n");
-					return -EFAULT;
-				}
+		struct zone *zone;
+
+		for_each_populated_zone(zone) {
+			unsigned long zone_end_pfn = zone->zone_start_pfn +
+						     zone->spanned_pages;
+
+			ret = iommu_prepare_identity_map(pdev,
+				 (uint64_t)zone->zone_start_pfn << PAGE_SHIFT,
+				 (uint64_t)zone_end_pfn << PAGE_SHIFT);
+			if (ret) {
+				printk(KERN_INFO "1:1 mapping to one domain failed.\n");
+				return -EFAULT;
 			}
 		}
 		ret = domain_add_dev_info(si_domain, pdev);



-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

