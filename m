Return-Path: <linux-kernel-owner+w=401wt.eu-S932377AbZAPXyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932377AbZAPXyZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 18:54:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761982AbZAPXyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 18:54:16 -0500
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:48856 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755486AbZAPXyP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 18:54:15 -0500
From: Bhavesh Davda <bhavesh@vmware.com>
To: "David.Woodhouse@intel.com" <David.Woodhouse@intel.com>,
       "mingo@elte.hu" <mingo@elte.hu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 16 Jan 2009 15:54:12 -0800
Subject: [PATCH] intel-iommu: intel_iommu_domain_alloc should check
 'dmar_disabled'
Thread-Topic: [PATCH] intel-iommu: intel_iommu_domain_alloc should check
 'dmar_disabled'
Thread-Index: Acl4NbskZ9wme9WgTGqUC7EELSjheg==
Message-ID: <AF9CD7A487028E428749836D21102612201D323DBB@PA-EXMBX02.vmware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


intel_iommu_domain_alloc() will try and iommu_alloc_domain(iommu),
which calls alloc_domain_mem() to allocate out of 'iommu_domain_cache'.
Unfortunately iommu_domain_cache will not be created if booted with
"intel_iommu=off", i.e. dmar_disabled = 1.

This fixes that.

Signed-off-by: Bhavesh P. Davda <bhavesh@vmware.com>
---
 drivers/pci/intel-iommu.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 5c8baa4..06237a8 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -2356,6 +2356,11 @@ struct dmar_domain *intel_iommu_domain_alloc(struct pci_dev *pdev)
        struct dmar_domain *domain;
        struct intel_iommu *iommu;

+       if (dmar_disabled) {
+               printk(KERN_ERR "intel_iommu_domain_alloc: Intel-IOMMU disabled\n");
+               return NULL;
+       }
+
        drhd = dmar_find_matched_drhd_unit(pdev);
        if (!drhd) {
                printk(KERN_ERR "intel_iommu_domain_alloc: drhd == NULL\n");
--
1.5.6.3

