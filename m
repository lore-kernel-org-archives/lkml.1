Return-Path: <linux-kernel-owner+w=401wt.eu-S1753278AbZDFSWF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278AbZDFSWF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 14:22:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751385AbZDFSVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 14:21:52 -0400
Received: from mga03.intel.com ([143.182.124.21]:42168 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbZDFSVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 14:21:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,331,1235980800"; 
   d="scan'208";a="128430360"
Date: Mon, 6 Apr 2009 11:21:49 -0700
From: Fenghua Yu <fenghua.yu@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       "Zhao, Yu" <yu.zhao@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       iommu <iommu@lists.linux-foundation.org>
Subject: [PATCH] Intel-IOMMU Alignment Issue in dma_pte_clear_range()
Message-ID: <20090406182149.GA28529@linux-os.sc.intel.com>
References: <1238507922.3294.35.camel@macbook.infradead.org> <alpine.LFD.2.00.0904031140520.19690@localhost.localdomain> <20090403191923.GA7772@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090403191923.GA7772@linux-os.sc.intel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This issue was pointed out by Linus.

In dma_pte_clear_range() in intel-iommu.c

start = PAGE_ALIGN(start);
end &= PAGE_MASK;
npages = (end - start) / VTD_PAGE_SIZE;

In partial page case, start could be bigger than end and npages will be
negative.

Currently the issue doesn't show up as a real bug in testing because start and
end have been aligned to page boundary already by all callers. So the issue has
been hiden. But it is dangerous programming practice.

The following patch fixes the issue. It's applied on iommu-2.6.git tree.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>

---

 intel-iommu.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index fd7472f..bce4f6e 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -732,8 +732,8 @@ static void dma_pte_clear_range(struct dmar_domain *domain, u64 start, u64 end)
 	start &= (((u64)1) << addr_width) - 1;
 	end &= (((u64)1) << addr_width) - 1;
 	/* in case it's partial page */
-	start = PAGE_ALIGN(start);
-	end &= PAGE_MASK;
+	start &= PAGE_MASK;
+	end = PAGE_ALIGN(end);
 	npages = (end - start) / VTD_PAGE_SIZE;
 
 	/* we don't need lock here, nobody else touches the iova range */
