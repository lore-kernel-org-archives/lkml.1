Return-Path: <linux-kernel-owner+w=401wt.eu-S933446AbZHDWLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933446AbZHDWLW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 18:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933438AbZHDWLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 18:11:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:39912 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933194AbZHDWLU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 18:11:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,324,1246863600"; 
   d="scan'208";a="538605630"
Date: Tue, 4 Aug 2009 15:11:20 -0700
From: Fenghua Yu <fenghua.yu@intel.com>
To: David Woodhouse <dwmw2@infradead.org>, Tony Luck <tony.luck@intel.com>
Cc: iommu@lists.linux-foundation.org, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org, Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH 4/4] Bug Fix drivers/pci/intel-iommu.c: convert pfn_lo to VTD page address when calling iommu_flush_dev_iotlb()
Message-ID: <20090804221119.GA21544@linux-os.sc.intel.com>
References: <bug-504363-150293@bugzilla.redhat.com> <200908042017.n74KHsNw018095@bz-web1.app.phx.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908042017.n74KHsNw018095@bz-web1.app.phx.redhat.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The iova->pfn_lo should be converted to VTD page address before it's passed to
iommu_flush_dev_iotlb().

This issue may cause DMA failure on PAGE_SIZE>VTD_PAGE_SIZE platforms e.g. ia64
platforms.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>

---

 drivers/pci/intel-iommu.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index bec29ed..54ee63d 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -2647,7 +2654,7 @@ static void flush_unmaps(void)
 			mask = (iova->pfn_hi - iova->pfn_lo + 1) << PAGE_SHIFT;
 			mask = ilog2(mask >> VTD_PAGE_SHIFT);
 			iommu_flush_dev_iotlb(deferred_flush[i].domain[j],
-					iova->pfn_lo << PAGE_SHIFT, mask);
+					iova->pfn_lo << VTD_PAGE_SHIFT, mask);
 			__free_iova(&deferred_flush[i].domain[j]->iovad, iova);
 		}
 		deferred_flush[i].next = 0;
