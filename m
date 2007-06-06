Return-Path: <linux-kernel-owner+w=401wt.eu-S933759AbXFFDRO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933759AbXFFDRO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 23:17:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751509AbXFFDRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 23:17:06 -0400
Received: from mga01.intel.com ([192.55.52.88]:60055 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227AbXFFDRF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 23:17:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,387,1175497200"; 
   d="scan'208";a="253696025"
Date: Wed, 6 Jun 2007 11:16:25 +0800
From: Wang Zhenyu <zhenyu.z.wang@intel.com>
To: Dave Jones <davej@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Keith Packard <keithp@keithp.com>,
       Eric Anholt <eric@anholt.net>
Subject: Re: [AGPGART] intel_agp: Add support for G33, Q33 and Q35 chipsets
Message-ID: <20070606031625.GA19986@zhen-devel.sh.intel.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Keith Packard <keithp@keithp.com>, Eric Anholt <eric@anholt.net>
References: <20070606010157.GA16199@zhen-devel.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070606010157.GA16199@zhen-devel.sh.intel.com>
User-Agent: Mutt/1.4.2.1i
X-Mailer: mutt
X-Operating-System: Linux 2.6.15-1.2054_FC5smp i686
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.06.06 09:01:57 +0000, Wang Zhenyu wrote:
> 
> This patch adds pci ids for G33, Q33 and Q35 chips
> 
> It bases on below intel-agp patches currently in -mm tree:
> intel_agp-cleanup-intel-private-data.patch
> intel_agp-cleanup-intel-private-data-update.patch
> intel_agp-use-table-for-device-probe.patch
> intel_agp-use-table-for-device-probe-update.patch
> intel_agp-add-support-for-965gme-gle.patch
> intel_agp-add-support-for-945gme.patch
> 

oops, found one break line was missed in detect GTT size switch. 
Here's the updated patch. Thanks Kent Liu for report. 

[AGPGART] intel_agp: Add support for G33, Q33 and Q35 chipsets

This patch adds pci ids for G33, Q33 and Q35 chips, and update with new
GTT size and stolen mem size detect method on these chips.

Signed-off-by: Wang Zhenyu <zhenyu.z.wang@intel.com>
---
 drivers/char/agp/agp.h       |    6 +++-
 drivers/char/agp/intel-agp.c |   79 ++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 82 insertions(+), 3 deletions(-)

diff --git a/drivers/char/agp/agp.h b/drivers/char/agp/agp.h
index fdbca25..35ab1a9 100644
--- a/drivers/char/agp/agp.h
+++ b/drivers/char/agp/agp.h
@@ -176,7 +176,7 @@ struct agp_bridge_data {
 #define I830_GMCH_MEM_MASK		0x1
 #define I830_GMCH_MEM_64M		0x1
 #define I830_GMCH_MEM_128M		0
-#define I830_GMCH_GMS_MASK		0x70
+#define I830_GMCH_GMS_MASK		0xF0
 #define I830_GMCH_GMS_DISABLED		0x00
 #define I830_GMCH_GMS_LOCAL		0x10
 #define I830_GMCH_GMS_STOLEN_512	0x20
@@ -231,6 +231,10 @@ struct agp_bridge_data {
 #define I965_PGETBL_SIZE_512KB	(0 << 1)
 #define I965_PGETBL_SIZE_256KB	(1 << 1)
 #define I965_PGETBL_SIZE_128KB	(2 << 1)
+#define G33_PGETBL_SIZE_MASK    (3 << 8)
+#define G33_PGETBL_SIZE_1M      (1 << 8)
+#define G33_PGETBL_SIZE_2M      (2 << 8)
+
 #define I810_DRAM_CTL		0x3000
 #define I810_DRAM_ROW_0		0x00000001
 #define I810_DRAM_ROW_0_SDRAM	0x00000001
diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
index 3c4a1c2..d383168 100644
--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -22,6 +22,12 @@
 #define PCI_DEVICE_ID_INTEL_82965GM_IG      0x2A02
 #define PCI_DEVICE_ID_INTEL_82965GME_IG     0x2A12
 #define PCI_DEVICE_ID_INTEL_82945GME_IG     0x27AE
+#define PCI_DEVICE_ID_INTEL_G33_HB          0x29C0
+#define PCI_DEVICE_ID_INTEL_G33_IG          0x29C2
+#define PCI_DEVICE_ID_INTEL_Q35_HB          0x29B0
+#define PCI_DEVICE_ID_INTEL_Q35_IG          0x29B2
+#define PCI_DEVICE_ID_INTEL_Q33_HB          0x29D0
+#define PCI_DEVICE_ID_INTEL_Q33_IG          0x29D2
 
 #define IS_I965 (agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82946GZ_HB || \
                  agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82965G_1_HB || \
@@ -29,6 +35,9 @@
                  agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82965G_HB || \
                  agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82965GM_HB)
 
+#define IS_G33 (agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_G33_HB || \
+		agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_Q35_HB || \
+		agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_Q33_HB)
 
 extern int agp_memory_reserved;
 
@@ -55,6 +64,8 @@ extern int agp_memory_reserved;
 #define I915_PTEADDR	0x1C
 #define I915_GMCH_GMS_STOLEN_48M	(0x6 << 4)
 #define I915_GMCH_GMS_STOLEN_64M	(0x7 << 4)
+#define G33_GMCH_GMS_STOLEN_128M       (0x8 << 4)
+#define G33_GMCH_GMS_STOLEN_256M       (0x9 << 4)
 
 /* Intel 965G registers */
 #define I965_MSAC 0x62
@@ -448,6 +459,22 @@ static void intel_i830_init_gtt_entries(void)
 			size = 512;
 		}
 		size += 4; /* add in BIOS popup space */
+	} else if (IS_G33) {
+	/* G33's GTT size defined in gmch_ctrl */
+		switch (gmch_ctrl & G33_PGETBL_SIZE_MASK) {
+		case G33_PGETBL_SIZE_1M:
+			size = 1024;
+			break;
+		case G33_PGETBL_SIZE_2M:
+			size = 2048;
+			break;
+		default:
+			printk(KERN_INFO PFX "Unknown page table size 0x%x, "
+				"assuming 512KB\n",
+				(gmch_ctrl & G33_PGETBL_SIZE_MASK));
+			size = 512;
+		}
+		size += 4;
 	} else {
 		/* On previous hardware, the GTT size was just what was
 		 * required to map the aperture.
@@ -499,7 +526,8 @@ static void intel_i830_init_gtt_entries(void)
 			if (agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82915G_HB ||
 			    agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82915GM_HB ||
 			    agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82945G_HB ||
-			    agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82945GM_HB || IS_I965 )
+			    agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82945GM_HB ||
+			    IS_I965 || IS_G33)
 				gtt_entries = MB(48) - KB(size);
 			else
 				gtt_entries = 0;
@@ -509,10 +537,24 @@ static void intel_i830_init_gtt_entries(void)
 			if (agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82915G_HB ||
 			    agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82915GM_HB ||
 			    agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82945G_HB ||
-			    agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82945GM_HB || IS_I965)
+			    agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82945GM_HB ||
+			    IS_I965 || IS_G33)
 				gtt_entries = MB(64) - KB(size);
 			else
 				gtt_entries = 0;
+			break;
+		case G33_GMCH_GMS_STOLEN_128M:
+			if (IS_G33)
+				gtt_entries = MB(128) - KB(size);
+			else
+				gtt_entries = 0;
+			break;
+		case G33_GMCH_GMS_STOLEN_256M:
+			if (IS_G33)
+				gtt_entries = MB(256) - KB(size);
+			else
+				gtt_entries = 0;
+			break;
 		default:
 			gtt_entries = 0;
 			break;
@@ -1719,6 +1761,30 @@ static const struct agp_bridge_driver intel_7505_driver = {
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 };
 
+static const struct agp_bridge_driver intel_g33_driver = {
+	.owner                  = THIS_MODULE,
+	.aperture_sizes         = intel_i830_sizes,
+	.size_type              = FIXED_APER_SIZE,
+	.num_aperture_sizes     = 4,
+	.needs_scratch_page     = TRUE,
+	.configure              = intel_i915_configure,
+	.fetch_size             = intel_i9xx_fetch_size,
+	.cleanup                = intel_i915_cleanup,
+	.tlb_flush              = intel_i810_tlbflush,
+	.mask_memory            = intel_i965_mask_memory,
+	.masks                  = intel_i810_masks,
+	.agp_enable             = intel_i810_agp_enable,
+	.cache_flush            = global_cache_flush,
+	.create_gatt_table      = intel_i915_create_gatt_table,
+	.free_gatt_table        = intel_i830_free_gatt_table,
+	.insert_memory          = intel_i915_insert_entries,
+	.remove_memory          = intel_i915_remove_entries,
+	.alloc_by_type          = intel_i830_alloc_by_type,
+	.free_by_type           = intel_i810_free_by_type,
+	.agp_alloc_page         = agp_generic_alloc_page,
+	.agp_destroy_page       = agp_generic_destroy_page,
+	.agp_type_to_mask_type  = intel_i830_type_to_mask_type,
+};
 
 static int find_gmch(u16 device)
 {
@@ -1799,6 +1865,12 @@ static const struct intel_driver_description {
 		&intel_845_driver, &intel_i965_driver },
 	{ PCI_DEVICE_ID_INTEL_7505_0, 0, "E7505", &intel_7505_driver, NULL },
 	{ PCI_DEVICE_ID_INTEL_7205_0, 0, "E7205", &intel_7505_driver, NULL },
+	{ PCI_DEVICE_ID_INTEL_G33_HB, PCI_DEVICE_ID_INTEL_G33_IG, "G33",
+		&intel_845_driver, &intel_g33_driver },
+	{ PCI_DEVICE_ID_INTEL_Q35_HB, PCI_DEVICE_ID_INTEL_Q35_IG, "Q35",
+		&intel_845_driver, &intel_g33_driver },
+	{ PCI_DEVICE_ID_INTEL_Q33_HB, PCI_DEVICE_ID_INTEL_Q33_IG, "Q33",
+		&intel_845_driver, &intel_g33_driver },
 	{ 0, 0, NULL, NULL, NULL }
 };
 
@@ -1976,6 +2048,9 @@ static struct pci_device_id agp_intel_pci_table[] = {
 	ID(PCI_DEVICE_ID_INTEL_82965Q_HB),
 	ID(PCI_DEVICE_ID_INTEL_82965G_HB),
 	ID(PCI_DEVICE_ID_INTEL_82965GM_HB),
+	ID(PCI_DEVICE_ID_INTEL_G33_HB),
+	ID(PCI_DEVICE_ID_INTEL_Q35_HB),
+	ID(PCI_DEVICE_ID_INTEL_Q33_HB),
 	{ }
 };
 
-- 
1.4.4.4
