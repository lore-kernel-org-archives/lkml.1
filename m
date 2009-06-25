Return-Path: <linux-kernel-owner+w=401wt.eu-S1756779AbZFYXov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779AbZFYXov (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 19:44:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753350AbZFYXon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 19:44:43 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52483 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752571AbZFYXom (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 19:44:42 -0400
Date: Thu, 25 Jun 2009 16:43:42 -0700
From: Chris Wright <chrisw@redhat.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, fenghua.yu@intel.com,
       chrisw@redhat.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, tony.luck@intel.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       linux-ia64@vger.kernel.org
Subject: Re: [PATCH v2] IA64 Compilation Error Fix for Intel IOMMU Identity
	Mapping Support
Message-ID: <20090625234342.GD28176@x200.localdomain>
References: <20090625003841.GA12226@linux-os.sc.intel.com> <20090625095643F.fujita.tomonori@lab.ntt.co.jp> <20090625041605.GA9330@linux-os.sc.intel.com> <20090625134827W.fujita.tomonori@lab.ntt.co.jp> <1245913886.17089.91.camel@macbook.infradead.org> <1245966743.30355.42.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245966743.30355.42.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Woodhouse (dwmw2@infradead.org) wrote:
> On Thu, 2009-06-25 at 08:11 +0100, David Woodhouse wrote:
> > It raises the question: Why are we using firmware-specific interfaces to
> > list the available memory -- can't we get that from somewhere _generic_?
> > 
> > The less we tie our code to these crappy BIOS, EFI and ACPI interfaces,
> > the better off we'll be.
> 
> Does this work everywhere... ?

Why don't we just use what's already there?  That should already be
working w/ IA-64.

Then it's clearer for later consolidation (there's no reason to have all
these different copies of same page tables).

thanks,
-chris
---
From: Chris Wright <chrisw@redhat.com>
Subject: [PATCH] intel-iommu: fix Identity Mapping to be arch independent

Drop the e820 scanning and use existing function for finding valid RAM
regions to add to 1:1 mapping.

Signed-off-by: Chris Wright <chrisw@redhat.com>
---
 drivers/pci/intel-iommu.c |   17 ++++-------------
 1 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index e53eacd..151e7d9 100644
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
 
@@ -2091,17 +2089,10 @@ static int iommu_prepare_static_identity_mapping(void)
 
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
-			}
+		ret = iommu_prepare_with_active_regions(pdev);
+		if (ret) {
+			printk(KERN_INFO "1:1 mapping to one domain failed.\n");
+			return -EFAULT;
 		}
 		ret = domain_add_dev_info(si_domain, pdev);
 		if (ret)
