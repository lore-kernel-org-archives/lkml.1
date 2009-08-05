Return-Path: <linux-kernel-owner+w=401wt.eu-S933772AbZHEIKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933772AbZHEIKI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 04:10:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933743AbZHEIKD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 04:10:03 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38795 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933736AbZHEIKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 04:10:01 -0400
Subject: Re: [PATCH 2/4] Bug Fix drivers/pci/intel-iommu.c: secure
 sg_next() calling
From: David Woodhouse <dwmw2@infradead.org>
To: Fenghua Yu <fenghua.yu@intel.com>
Cc: Tony Luck <tony.luck@intel.com>, iommu@lists.linux-foundation.org,
       linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090804221024.GA21406@linux-os.sc.intel.com>
References: <BAE9DCEF64577A439B3A37F36F9B691C0339372B@orsmsx418.amr.corp.intel.com>
	 <617E1C2C70743745A92448908E030B2A02AD5AD7@scsmsx411.amr.corp.intel.com>
	 <20090804221024.GA21406@linux-os.sc.intel.com>
Content-Type: text/plain
Date: Wed, 05 Aug 2009 09:09:59 +0100
Message-Id: <1249459799.9324.348.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-04 at 15:10 -0700, Fenghua Yu wrote:
> sg_next() is called only when sg is not NULL. This solves a kernel panic on
> some platforms (e.g. ia64).

Is this still necessary after we fix the other bugs? When does it
happen? And is this fix sufficient (ignore the first hunk; it's just a
cleanup that the fix allows me to make, which is why I'd prefer to do it
this way):

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 11b317a..c9bdb0b 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -1675,7 +1675,7 @@ static int __domain_mapping(struct dmar_domain *domain, unsigned long iov_pfn,
 	if (sg)
 		sg_res = 0;
 	else {
-		sg_res = nr_pages + 1;
+		sg_res = nr_pages;
 		pteval = ((phys_addr_t)phys_pfn << VTD_PAGE_SHIFT) | prot;
 	}
 
@@ -1716,7 +1716,7 @@ static int __domain_mapping(struct dmar_domain *domain, unsigned long iov_pfn,
 		iov_pfn++;
 		pteval += VTD_PAGE_SIZE;
 		sg_res--;
-		if (!sg_res)
+		if (nr_pages && !sg_res)
 			sg = sg_next(sg);
 	}
 	return 0;


-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

