Return-Path: <linux-kernel-owner+w=401wt.eu-S1752826AbZHTICn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826AbZHTICn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 04:02:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752349AbZHTICm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 04:02:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:38995 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbZHTICj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 04:02:39 -0400
Subject: [PATCH] intel-iommu: Work around yet another BIOS bug
From: David Woodhouse <dwmw2@infradead.org>
To: torvalds@linux-foundation.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Faidon Liambotis <paravoid@debian.org>,
       Matt Domsch <Matt_Domsch@dell.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org,
       bero@arklinux.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1250754748.8974.17.camel@macbook.infradead.org>
References: <bug-14003-10286@http.bugzilla.kernel.org/>
	 <20090819142634.0fc550d1.akpm@linux-foundation.org>
	 <1250754748.8974.17.camel@macbook.infradead.org>
Content-Type: text/plain
Date: Thu, 20 Aug 2009 09:01:58 +0100
Message-Id: <1250755318.8974.26.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yet another reason why trusting this stuff to the BIOS was a bad idea.

There now seem to be a bunch of BIOSes which report an IOMMU at a
physical address which just returns all ones. (Perhaps only when VT-d is
actually _disabled_ in the BIOS?)

Well done, Dell and HP -- although I didn't think it was possible, you
have _further_ lowered my already-unprintable opinion of closed source
BIOSes and BIOS engineers.

This patch makes the kernel detect this particularly brokenness and
abort early -- and fixes up the missing iounmap in the error paths which
I noticed while I was poking at it.

This should fix kernel.org bug #14003, which was being called a
'regression' -- I think because the IOMMU code used to trip over
_another_ BIOS bug earlier than this one, and that one _did_ cause it to
abort.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
---
 drivers/pci/dmar.c |   22 ++++++++++++++++++----
 1 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
index 7b287cb..380b60e 100644
--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -632,20 +632,31 @@ int alloc_iommu(struct dmar_drhd_unit *drhd)
 	iommu->cap = dmar_readq(iommu->reg + DMAR_CAP_REG);
 	iommu->ecap = dmar_readq(iommu->reg + DMAR_ECAP_REG);
 
+	if (iommu->cap == (uint64_t)-1 && iommu->ecap == (uint64_t)-1) {
+		/* Promote an attitude of violence to a BIOS engineer today */
+		WARN(1, "Your BIOS is broken; DMAR reported at address %llx returns all ones!\n"
+		     "BIOS vendor: %s; Ver: %s; Product Version: %s\n",
+		     drhd->reg_base_addr,
+		     dmi_get_system_info(DMI_BIOS_VENDOR),
+		     dmi_get_system_info(DMI_BIOS_VERSION),
+		     dmi_get_system_info(DMI_PRODUCT_VERSION));
+		goto err_unmap;
+	}
+
 #ifdef CONFIG_DMAR
 	agaw = iommu_calculate_agaw(iommu);
 	if (agaw < 0) {
 		printk(KERN_ERR
 		       "Cannot get a valid agaw for iommu (seq_id = %d)\n",
 		       iommu->seq_id);
-		goto error;
+		goto err_unmap;
 	}
 	msagaw = iommu_calculate_max_sagaw(iommu);
 	if (msagaw < 0) {
 		printk(KERN_ERR
 			"Cannot get a valid max agaw for iommu (seq_id = %d)\n",
 			iommu->seq_id);
-		goto error;
+		goto err_unmap;
 	}
 #endif
 	iommu->agaw = agaw;
@@ -665,7 +676,7 @@ int alloc_iommu(struct dmar_drhd_unit *drhd)
 	}
 
 	ver = readl(iommu->reg + DMAR_VER_REG);
-	pr_debug("IOMMU %llx: ver %d:%d cap %llx ecap %llx\n",
+	pr_info("IOMMU %llx: ver %d:%d cap %llx ecap %llx\n",
 		(unsigned long long)drhd->reg_base_addr,
 		DMAR_VER_MAJOR(ver), DMAR_VER_MINOR(ver),
 		(unsigned long long)iommu->cap,
@@ -675,7 +686,10 @@ int alloc_iommu(struct dmar_drhd_unit *drhd)
 
 	drhd->iommu = iommu;
 	return 0;
-error:
+
+ err_unmap:
+	iounmap(iommu->reg);
+ error:
 	kfree(iommu);
 	return -1;
 }
-- 
1.6.2.5


-- 
dwmw2

