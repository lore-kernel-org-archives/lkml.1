Return-Path: <linux-kernel-owner+w=401wt.eu-S1757017AbZJPRZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757017AbZJPRZW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 13:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755224AbZJPRZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 13:25:19 -0400
Received: from kroah.org ([198.145.64.141]:48519 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754081AbZJPRS1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 13:18:27 -0400
X-Mailbox-Line: From linux@linux.site Fri Oct 16 10:11:57 2009
Message-Id: <20091016171156.879737124@linux.site>
User-Agent: quilt/0.47-14.9
Date: Fri, 16 Oct 2009 10:10:13 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       David Woodhouse <David.Woodhouse@intel.com>,
       Arto Jantunen <viiru@debian.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [20/46] intel-iommu: Cope with broken HP DC7900 BIOS
References: <20091016170953.128828149@linux.site>
Content-Disposition: inline; filename=intel-iommu-cope-with-broken-hp-dc7900-bios.patch
In-Reply-To: <20091016171422.GA13339@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: David Woodhouse <David.Woodhouse@intel.com>

commit 0815565adfe3f4c369110c57d8ffe83caefeed68 upstream.

Yet another reason why trusting this stuff to the BIOS was a bad idea.
The HP DC7900 BIOS reports an iommu at an address which just returns all
ones, when VT-d is disabled in the BIOS.

Fix up the missing iounmap in the error paths while we're at it.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Cc: Arto Jantunen <viiru@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/dmar.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -632,20 +632,31 @@ int alloc_iommu(struct dmar_drhd_unit *d
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
@@ -665,7 +676,7 @@ int alloc_iommu(struct dmar_drhd_unit *d
 	}
 
 	ver = readl(iommu->reg + DMAR_VER_REG);
-	pr_debug("IOMMU %llx: ver %d:%d cap %llx ecap %llx\n",
+	pr_info("IOMMU %llx: ver %d:%d cap %llx ecap %llx\n",
 		(unsigned long long)drhd->reg_base_addr,
 		DMAR_VER_MAJOR(ver), DMAR_VER_MINOR(ver),
 		(unsigned long long)iommu->cap,
@@ -675,7 +686,10 @@ int alloc_iommu(struct dmar_drhd_unit *d
 
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


