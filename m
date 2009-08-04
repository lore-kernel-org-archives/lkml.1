Return-Path: <linux-kernel-owner+w=401wt.eu-S933423AbZHDWKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933423AbZHDWKj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 18:10:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933288AbZHDWKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 18:10:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:35338 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933111AbZHDWKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 18:10:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,324,1246863600"; 
   d="scan'208";a="538605525"
Date: Tue, 4 Aug 2009 15:10:24 -0700
From: Fenghua Yu <fenghua.yu@intel.com>
To: David Woodhouse <dwmw2@infradead.org>, Tony Luck <tony.luck@intel.com>
Cc: iommu@lists.linux-foundation.org, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org, Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH 2/4] Bug Fix drivers/pci/intel-iommu.c: secure sg_next() calling
Message-ID: <20090804221024.GA21406@linux-os.sc.intel.com>
References: <BAE9DCEF64577A439B3A37F36F9B691C0339372B@orsmsx418.amr.corp.intel.com> <617E1C2C70743745A92448908E030B2A02AD5AD7@scsmsx411.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <617E1C2C70743745A92448908E030B2A02AD5AD7@scsmsx411.amr.corp.intel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sg_next() is called only when sg is not NULL. This solves a kernel panic on
some platforms (e.g. ia64).

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>

---

 drivers/pci/intel-iommu.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index bec29ed..54ee63d 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -1705,8 +1715,12 @@ static int __domain_mapping(struct dmar_domain *domain, unsigned long iov_pfn,
 		iov_pfn++;
 		pteval += VTD_PAGE_SIZE;
 		sg_res--;
-		if (!sg_res)
-			sg = sg_next(sg);
+		if (!sg_res) {
+			if (sg)
+				sg = sg_next(sg);
+			else
+				return 0;
+		}
 	}
 	return 0;
 }
