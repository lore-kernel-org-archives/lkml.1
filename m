Return-Path: <linux-kernel-owner+w=401wt.eu-S1753753AbZFZByB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753AbZFZByB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 21:54:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752342AbZFZBxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 21:53:52 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42149 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752242AbZFZBxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 21:53:51 -0400
Date: Thu, 25 Jun 2009 18:52:05 -0700
From: Chris Wright <chrisw@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chris Wright <chrisw@redhat.com>, David Woodhouse <dwmw2@infradead.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, fenghua.yu@intel.com,
       akpm@linux-foundation.org, tony.luck@intel.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       linux-ia64@vger.kernel.org
Subject: Re: [PATCH v2] IA64 Compilation Error Fix for Intel IOMMU Identity
	Mapping Support
Message-ID: <20090626015205.GE28176@x200.localdomain>
References: <20090625003841.GA12226@linux-os.sc.intel.com> <20090625095643F.fujita.tomonori@lab.ntt.co.jp> <20090625041605.GA9330@linux-os.sc.intel.com> <20090625134827W.fujita.tomonori@lab.ntt.co.jp> <1245913886.17089.91.camel@macbook.infradead.org> <1245966743.30355.42.camel@macbook.infradead.org> <20090625234342.GD28176@x200.localdomain> <alpine.LFD.2.01.0906251835060.3605@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906251835060.3605@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> On Thu, 25 Jun 2009, Chris Wright wrote:
> >
> > From: Chris Wright <chrisw@redhat.com>
> > Subject: [PATCH] intel-iommu: fix Identity Mapping to be arch independent
> > 
> > Drop the e820 scanning and use existing function for finding valid RAM
> > regions to add to 1:1 mapping.
> > 
> > Signed-off-by: Chris Wright <chrisw@redhat.com>
> 
> Is this tested on something that actually uses IOMMU?
> 
> If so, of the patches I've seen so far, this is obviously my favorite.

I tested it on x86; works fine and creates a slightly tighter set of page
tables (matching to e820).  But I don't have an IA-64 box w/ an IOMMU.

It does have one problem, however, the graphics work around code isn't
compiled in on IA-64, so it needs:

(a) a small ifdef move
(b) to be tested on IA-64, since my hypothesis was based on the fact that
it was already being used on IA-64

Here's v2, fixing (a) above (compile tested on IA-64), still needing (b).

thanks,
-chris
---
From: Chris Wright <chrisw@redhat.com>
Subject: [PATCH v2] intel-iommu: fix Identity Mapping to be arch independent

Drop the e820 scanning and use existing function for finding valid RAM
regions to add to 1:1 mapping.

Signed-off-by: Chris Wright <chrisw@redhat.com>
---
 drivers/pci/intel-iommu.c |   19 +++++--------------
 1 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index e53eacd..420afa8 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -39,7 +39,6 @@
 #include <linux/sysdev.h>
 #include <asm/cacheflush.h>
 #include <asm/iommu.h>
-#include <asm/e820.h>
 #include "pci.h"
 
 #define ROOT_SIZE		VTD_PAGE_SIZE
@@ -1908,7 +1907,6 @@ static inline int iommu_prepare_rmrr_dev(struct dmar_rmrr_unit *rmrr,
 		rmrr->end_address + 1);
 }
 
-#ifdef CONFIG_DMAR_GFX_WA
 struct iommu_prepare_data {
 	struct pci_dev *pdev;
 	int ret;
@@ -1943,6 +1941,7 @@ static int __init iommu_prepare_with_active_regions(struct pci_dev *pdev)
 	return data.ret;
 }
 
+#ifdef CONFIG_DMAR_GFX_WA
 static void __init iommu_prepare_gfx_mapping(void)
 {
 	struct pci_dev *pdev = NULL;
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
