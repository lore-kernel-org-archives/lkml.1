Return-Path: <linux-kernel-owner+w=401wt.eu-S1758246AbXFNCB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246AbXFNCB7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 22:01:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751436AbXFNCBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 22:01:52 -0400
Received: from mga01.intel.com ([192.55.52.88]:63664 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356AbXFNCBv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 22:01:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,418,1175497200"; 
   d="scan'208";a="256633487"
Date: Thu, 14 Jun 2007 10:01:04 +0800
From: Wang Zhenyu <zhenyu.z.wang@intel.com>
To: Dave Jones <davej@redhat.com>, Wang Zhenyu <zhen78@gmail.com>,
       Meelis Roos <mroos@linux.ee>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Eric Anholt <eric@anholt.net>
Subject: Re: I815 suddenly unkown to agpgart?
Message-ID: <20070614020104.GB31534@zhen-devel.sh.intel.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Wang Zhenyu <zhen78@gmail.com>, Meelis Roos <mroos@linux.ee>,
	Linux Kernel list <linux-kernel@vger.kernel.org>,
	Eric Anholt <eric@anholt.net>
References: <Pine.SOC.4.64.0706131804180.2614@math> <20070613160152.GC3875@redhat.com> <20070613161513.GE3875@redhat.com> <20070613180039.GA4508@localhost.localdomain> <20070613182240.GA3726@redhat.com> <20070614013412.GA31534@zhen-devel.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070614013412.GA31534@zhen-devel.sh.intel.com>
User-Agent: Mutt/1.4.2.1i
X-Mailer: mutt
X-Operating-System: Linux 2.6.15-1.2054_FC5smp i686
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.06.14 09:34:12 +0000, Wang Zhenyu wrote:
> 
> Dave, after rethinking about this, I think we mixed two cases 
> need to be fixed here. This is the patch for this, sorry for mess
> it up. Meelis, could you help to test by replace my last patch with this? 
> 

oop, for 945GME like case, we should stop scan if still no detection. 
Updated patch here. 

[AGPGART] intel_agp: fix device probe

This patch trys to fix device probe in two cases. First we should
correctly detect device if integrated graphics device is not enabled
or exists, like an add-in card is plugged. Second on some type of intel
GMCH, it might have multiple graphic chip models, like 945GME case, so
we should be sure the detect works through the whole table.

Signed-off-by: Wang Zhenyu <zhenyu.z.wang@intel.com>
---
 drivers/char/agp/intel-agp.c |   97 ++++++++++++++++++++++--------------------
 1 files changed, 51 insertions(+), 46 deletions(-)

diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
index d383168..1a83b02 100644
--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -1810,68 +1810,69 @@ static int find_gmch(u16 device)
 static const struct intel_driver_description {
 	unsigned int chip_id;
 	unsigned int gmch_chip_id;
+	unsigned int multi_gmch_chip; /* if we have more gfx chip type on this HB. */
 	char *name;
 	const struct agp_bridge_driver *driver;
 	const struct agp_bridge_driver *gmch_driver;
 } intel_agp_chipsets[] = {
-	{ PCI_DEVICE_ID_INTEL_82443LX_0, 0, "440LX", &intel_generic_driver, NULL },
-	{ PCI_DEVICE_ID_INTEL_82443BX_0, 0, "440BX", &intel_generic_driver, NULL },
-	{ PCI_DEVICE_ID_INTEL_82443GX_0, 0, "440GX", &intel_generic_driver, NULL },
-	{ PCI_DEVICE_ID_INTEL_82810_MC1, PCI_DEVICE_ID_INTEL_82810_IG1, "i810",
+	{ PCI_DEVICE_ID_INTEL_82443LX_0, 0, 0, "440LX", &intel_generic_driver, NULL },
+	{ PCI_DEVICE_ID_INTEL_82443BX_0, 0, 0, "440BX", &intel_generic_driver, NULL },
+	{ PCI_DEVICE_ID_INTEL_82443GX_0, 0, 0, "440GX", &intel_generic_driver, NULL },
+	{ PCI_DEVICE_ID_INTEL_82810_MC1, PCI_DEVICE_ID_INTEL_82810_IG1, 0, "i810",
 		NULL, &intel_810_driver },
-	{ PCI_DEVICE_ID_INTEL_82810_MC3, PCI_DEVICE_ID_INTEL_82810_IG3, "i810",
+	{ PCI_DEVICE_ID_INTEL_82810_MC3, PCI_DEVICE_ID_INTEL_82810_IG3, 0, "i810",
 		NULL, &intel_810_driver },
-	{ PCI_DEVICE_ID_INTEL_82810E_MC, PCI_DEVICE_ID_INTEL_82810E_IG, "i810",
+	{ PCI_DEVICE_ID_INTEL_82810E_MC, PCI_DEVICE_ID_INTEL_82810E_IG, 0, "i810",
 		NULL, &intel_810_driver },
-	{ PCI_DEVICE_ID_INTEL_82815_MC, PCI_DEVICE_ID_INTEL_82815_CGC, "i815",
-		&intel_810_driver, &intel_815_driver },
-	{ PCI_DEVICE_ID_INTEL_82820_HB, 0, "i820", &intel_820_driver, NULL },
-	{ PCI_DEVICE_ID_INTEL_82820_UP_HB, 0, "i820", &intel_820_driver, NULL },
-	{ PCI_DEVICE_ID_INTEL_82830_HB, PCI_DEVICE_ID_INTEL_82830_CGC, "830M",
+	{ PCI_DEVICE_ID_INTEL_82815_MC, PCI_DEVICE_ID_INTEL_82815_CGC, 0, "i815",
+		&intel_815_driver, &intel_810_driver },
+	{ PCI_DEVICE_ID_INTEL_82820_HB, 0, 0, "i820", &intel_820_driver, NULL },
+	{ PCI_DEVICE_ID_INTEL_82820_UP_HB, 0, 0, "i820", &intel_820_driver, NULL },
+	{ PCI_DEVICE_ID_INTEL_82830_HB, PCI_DEVICE_ID_INTEL_82830_CGC, 0, "830M",
 		&intel_830mp_driver, &intel_830_driver },
-	{ PCI_DEVICE_ID_INTEL_82840_HB, 0, "i840", &intel_840_driver, NULL },
-	{ PCI_DEVICE_ID_INTEL_82845_HB, 0, "845G", &intel_845_driver, NULL },
-	{ PCI_DEVICE_ID_INTEL_82845G_HB, PCI_DEVICE_ID_INTEL_82845G_IG, "830M",
+	{ PCI_DEVICE_ID_INTEL_82840_HB, 0, 0, "i840", &intel_840_driver, NULL },
+	{ PCI_DEVICE_ID_INTEL_82845_HB, 0, 0, "845G", &intel_845_driver, NULL },
+	{ PCI_DEVICE_ID_INTEL_82845G_HB, PCI_DEVICE_ID_INTEL_82845G_IG, 0, "830M",
 		&intel_845_driver, &intel_830_driver },
-	{ PCI_DEVICE_ID_INTEL_82850_HB, 0, "i850", &intel_850_driver, NULL },
-	{ PCI_DEVICE_ID_INTEL_82855PM_HB, 0, "855PM", &intel_845_driver, NULL },
-	{ PCI_DEVICE_ID_INTEL_82855GM_HB, PCI_DEVICE_ID_INTEL_82855GM_IG, "855GM",
+	{ PCI_DEVICE_ID_INTEL_82850_HB, 0, 0, "i850", &intel_850_driver, NULL },
+	{ PCI_DEVICE_ID_INTEL_82855PM_HB, 0, 0, "855PM", &intel_845_driver, NULL },
+	{ PCI_DEVICE_ID_INTEL_82855GM_HB, PCI_DEVICE_ID_INTEL_82855GM_IG, 0, "855GM",
 		&intel_845_driver, &intel_830_driver },
-	{ PCI_DEVICE_ID_INTEL_82860_HB, 0, "i860", &intel_860_driver, NULL },
-	{ PCI_DEVICE_ID_INTEL_82865_HB, PCI_DEVICE_ID_INTEL_82865_IG, "865",
+	{ PCI_DEVICE_ID_INTEL_82860_HB, 0, 0, "i860", &intel_860_driver, NULL },
+	{ PCI_DEVICE_ID_INTEL_82865_HB, PCI_DEVICE_ID_INTEL_82865_IG, 0, "865",
 		&intel_845_driver, &intel_830_driver },
-	{ PCI_DEVICE_ID_INTEL_82875_HB, 0, "i875", &intel_845_driver, NULL },
-	{ PCI_DEVICE_ID_INTEL_82915G_HB, PCI_DEVICE_ID_INTEL_82915G_IG, "915G",
+	{ PCI_DEVICE_ID_INTEL_82875_HB, 0, 0, "i875", &intel_845_driver, NULL },
+	{ PCI_DEVICE_ID_INTEL_82915G_HB, PCI_DEVICE_ID_INTEL_82915G_IG, 0, "915G",
 		&intel_845_driver, &intel_915_driver },
-	{ PCI_DEVICE_ID_INTEL_82915GM_HB, PCI_DEVICE_ID_INTEL_82915GM_IG, "915GM",
+	{ PCI_DEVICE_ID_INTEL_82915GM_HB, PCI_DEVICE_ID_INTEL_82915GM_IG, 0, "915GM",
 		&intel_845_driver, &intel_915_driver },
-	{ PCI_DEVICE_ID_INTEL_82945G_HB, PCI_DEVICE_ID_INTEL_82945G_IG, "945G",
+	{ PCI_DEVICE_ID_INTEL_82945G_HB, PCI_DEVICE_ID_INTEL_82945G_IG, 0, "945G",
 		&intel_845_driver, &intel_915_driver },
-	{ PCI_DEVICE_ID_INTEL_82945GM_HB, PCI_DEVICE_ID_INTEL_82945GM_IG, "945GM",
+	{ PCI_DEVICE_ID_INTEL_82945GM_HB, PCI_DEVICE_ID_INTEL_82945GM_IG, 1, "945GM",
 		&intel_845_driver, &intel_915_driver },
-	{ PCI_DEVICE_ID_INTEL_82945GM_HB, PCI_DEVICE_ID_INTEL_82945GME_IG, "945GME",
+	{ PCI_DEVICE_ID_INTEL_82945GM_HB, PCI_DEVICE_ID_INTEL_82945GME_IG, 0, "945GME",
 		&intel_845_driver, &intel_915_driver },
-	{ PCI_DEVICE_ID_INTEL_82946GZ_HB, PCI_DEVICE_ID_INTEL_82946GZ_IG, "946GZ",
+	{ PCI_DEVICE_ID_INTEL_82946GZ_HB, PCI_DEVICE_ID_INTEL_82946GZ_IG, 0, "946GZ",
 		&intel_845_driver, &intel_i965_driver },
-	{ PCI_DEVICE_ID_INTEL_82965G_1_HB, PCI_DEVICE_ID_INTEL_82965G_1_IG, "965G",
+	{ PCI_DEVICE_ID_INTEL_82965G_1_HB, PCI_DEVICE_ID_INTEL_82965G_1_IG, 0, "965G",
 		&intel_845_driver, &intel_i965_driver },
-	{ PCI_DEVICE_ID_INTEL_82965Q_HB, PCI_DEVICE_ID_INTEL_82965Q_IG, "965Q",
+	{ PCI_DEVICE_ID_INTEL_82965Q_HB, PCI_DEVICE_ID_INTEL_82965Q_IG, 0, "965Q",
 		&intel_845_driver, &intel_i965_driver },
-	{ PCI_DEVICE_ID_INTEL_82965G_HB, PCI_DEVICE_ID_INTEL_82965G_IG, "965G",
+	{ PCI_DEVICE_ID_INTEL_82965G_HB, PCI_DEVICE_ID_INTEL_82965G_IG, 0, "965G",
 		&intel_845_driver, &intel_i965_driver },
-	{ PCI_DEVICE_ID_INTEL_82965GM_HB, PCI_DEVICE_ID_INTEL_82965GM_IG, "965GM",
+	{ PCI_DEVICE_ID_INTEL_82965GM_HB, PCI_DEVICE_ID_INTEL_82965GM_IG, 1, "965GM",
 		&intel_845_driver, &intel_i965_driver },
-	{ PCI_DEVICE_ID_INTEL_82965GM_HB, PCI_DEVICE_ID_INTEL_82965GME_IG, "965GME/GLE",
+	{ PCI_DEVICE_ID_INTEL_82965GM_HB, PCI_DEVICE_ID_INTEL_82965GME_IG, 0, "965GME/GLE",
 		&intel_845_driver, &intel_i965_driver },
-	{ PCI_DEVICE_ID_INTEL_7505_0, 0, "E7505", &intel_7505_driver, NULL },
-	{ PCI_DEVICE_ID_INTEL_7205_0, 0, "E7205", &intel_7505_driver, NULL },
-	{ PCI_DEVICE_ID_INTEL_G33_HB, PCI_DEVICE_ID_INTEL_G33_IG, "G33",
+	{ PCI_DEVICE_ID_INTEL_7505_0, 0, 0, "E7505", &intel_7505_driver, NULL },
+	{ PCI_DEVICE_ID_INTEL_7205_0, 0, 0, "E7205", &intel_7505_driver, NULL },
+	{ PCI_DEVICE_ID_INTEL_G33_HB, PCI_DEVICE_ID_INTEL_G33_IG, 0, "G33",
 		&intel_845_driver, &intel_g33_driver },
-	{ PCI_DEVICE_ID_INTEL_Q35_HB, PCI_DEVICE_ID_INTEL_Q35_IG, "Q35",
+	{ PCI_DEVICE_ID_INTEL_Q35_HB, PCI_DEVICE_ID_INTEL_Q35_IG, 0, "Q35",
 		&intel_845_driver, &intel_g33_driver },
-	{ PCI_DEVICE_ID_INTEL_Q33_HB, PCI_DEVICE_ID_INTEL_Q33_IG, "Q33",
+	{ PCI_DEVICE_ID_INTEL_Q33_HB, PCI_DEVICE_ID_INTEL_Q33_IG, 0, "Q33",
 		&intel_845_driver, &intel_g33_driver },
-	{ 0, 0, NULL, NULL, NULL }
+	{ 0, 0, 0, NULL, NULL, NULL }
 };
 
 static int __devinit agp_intel_probe(struct pci_dev *pdev,
@@ -1892,10 +1893,19 @@ static int __devinit agp_intel_probe(struct pci_dev *pdev,
 		/* In case that multiple models of gfx chip may
 		   stand on same host bridge type, this can be
 		   sure we detect the right IGD. */
-		if ((pdev->device == intel_agp_chipsets[i].chip_id) &&
-			((intel_agp_chipsets[i].gmch_chip_id == 0) ||
-				find_gmch(intel_agp_chipsets[i].gmch_chip_id)))
-			break;
+		if (pdev->device == intel_agp_chipsets[i].chip_id) {
+			if ((intel_agp_chipsets[i].gmch_chip_id != 0) &&
+				find_gmch(intel_agp_chipsets[i].gmch_chip_id)) {
+				bridge->driver = 
+					intel_agp_chipsets[i].gmch_driver;
+				break;
+			} else if (intel_agp_chipsets[i].multi_gmch_chip) {
+				continue;
+			} else {
+	    			bridge->driver = intel_agp_chipsets[i].driver;
+				break;
+			}
+		}
 	}
 
 	if (intel_agp_chipsets[i].name == NULL) {
@@ -1906,11 +1916,6 @@ static int __devinit agp_intel_probe(struct pci_dev *pdev,
 		return -ENODEV;
 	}
 
-	if (intel_agp_chipsets[i].gmch_chip_id != 0)
-	    bridge->driver = intel_agp_chipsets[i].gmch_driver;
-	else
-	    bridge->driver = intel_agp_chipsets[i].driver;
-
 	if (bridge->driver == NULL) {
 		printk(KERN_WARNING PFX "Failed to find bridge device "
 			"(chip_id: %04x)\n", intel_agp_chipsets[i].gmch_chip_id);
-- 
1.4.4.4
