Return-Path: <linux-kernel-owner+w=401wt.eu-S1755203AbZJZX3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203AbZJZX3o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 19:29:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755147AbZJZX3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 19:29:42 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:31075 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754963AbZJZX3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 19:29:18 -0400
From: Alex Williamson <alex.williamson@hp.com>
Subject: [PATCH 4/5] intel-iommu: Reinstate RMRRs if a device is removed from
	passthrough domain
To: dwmw2@infradead.org
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, alex.williamson@hp.com
Date: Mon, 26 Oct 2009 17:25:14 -0600
Message-ID: <20091026232514.9646.58322.stgit@nehalem.aw>
In-Reply-To: <20091026232401.9646.90540.stgit@nehalem.aw>
References: <20091026232401.9646.90540.stgit@nehalem.aw>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a device is setup for passthrough it has full access to memory
so processing the RMRRs is unnecessary.  However, if we remove the device
from the si_domain, we need to reinstate the associated RMRRs.

Signed-off-by: Alex Williamson <alex.williamson@hp.com>
---

 drivers/pci/intel-iommu.c |   33 +++++++++++++++++++++++++++++++++
 1 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 19f10ae..a7f4476 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -2538,6 +2538,10 @@ static int iommu_no_mapping(struct device *dev)
 		if (iommu_should_identity_map(pdev, 0))
 			return 1;
 		else {
+			struct dmar_rmrr_unit *rmrr;
+			struct dmar_domain *domain;
+			int i, ret;
+
 			/*
 			 * Devices that cannot support identity mapping
 			 * are removed from si_domain and fall back to
@@ -2546,6 +2550,35 @@ static int iommu_no_mapping(struct device *dev)
 			domain_remove_one_dev_info(si_domain, pdev);
 			printk(KERN_INFO "%s uses non-identity mapping\n",
 			       pci_name(pdev));
+
+			domain = get_valid_domain_for_dev(pdev);
+			if (!domain) {
+				printk(KERN_ERR
+				       "Allocating domain for %s failed",
+				       pci_name(pdev));
+				return 0;
+			}
+
+			ret = domain_add_dev_info(domain, pdev,
+						  CONTEXT_TT_MULTI_LEVEL);
+			if (ret) {
+				printk(KERN_ERR
+				       "Attaching %s to domain failed",
+				       pci_name(pdev));
+				return 0;
+			}
+
+			for_each_rmrr_units(rmrr) {
+				for (i = 0; i < rmrr->devices_cnt; i++) {
+					if (pdev != rmrr->devices[i])
+						continue;
+					ret = iommu_prepare_rmrr_dev(rmrr,
+								     pdev);
+					if (ret)
+						printk(KERN_ERR
+						       "IOMMU: mapping reserved region failed\n");
+				}
+			}
 			return 0;
 		}
 	} else {

