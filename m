Return-Path: <linux-kernel-owner+w=401wt.eu-S1754401AbYAIDnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401AbYAIDnS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 22:43:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbYAIDnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 22:43:07 -0500
Received: from mga11.intel.com ([192.55.52.93]:50102 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812AbYAIDnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 22:43:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,260,1196668800"; 
   d="scan'208";a="490272835"
Date: Wed, 9 Jan 2008 11:27:33 +0800
From: Zhenyu Wang <zhenyu.z.wang@intel.com>
To: Dave Airlie <airlied@linux.ie>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH][AGP] intel_agp: add new chipset ids
Message-ID: <20080109032733.GA14231@zhen-devel.sh.intel.com>
Mail-Followup-To: Dave Airlie <airlied@linux.ie>,
	LKML <linux-kernel@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
X-Mailer: mutt
X-Operating-System: Linux 2.6.23 i686
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dave,

This one adds new pci ids for Intel intergrated graphics
chipset, with gtt table access change on it and new gtt table
size definition.

Thanks.

Signed-off-by: Zhenyu Wang <zhenyu.z.wang@intel.com>
---
 drivers/char/agp/agp.h       |    3 +++
 drivers/char/agp/intel-agp.c |   31 ++++++++++++++++++++++++++-----
 2 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/drivers/char/agp/agp.h b/drivers/char/agp/agp.h
index b83824c..d132914 100644
--- a/drivers/char/agp/agp.h
+++ b/drivers/char/agp/agp.h
@@ -235,6 +235,9 @@ struct agp_bridge_data {
 #define I965_PGETBL_SIZE_512KB	(0 << 1)
 #define I965_PGETBL_SIZE_256KB	(1 << 1)
 #define I965_PGETBL_SIZE_128KB	(2 << 1)
+#define I965_PGETBL_SIZE_1MB	(3 << 1)
+#define I965_PGETBL_SIZE_2MB	(4 << 1)
+#define I965_PGETBL_SIZE_1_5MB	(5 << 1)
 #define G33_PGETBL_SIZE_MASK    (3 << 8)
 #define G33_PGETBL_SIZE_1M      (1 << 8)
 #define G33_PGETBL_SIZE_2M      (2 << 8)
diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
index d879619..091e765 100644
--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -30,13 +30,16 @@
 #define PCI_DEVICE_ID_INTEL_Q35_IG          0x29B2
 #define PCI_DEVICE_ID_INTEL_Q33_HB          0x29D0
 #define PCI_DEVICE_ID_INTEL_Q33_IG          0x29D2
+#define PCI_DEVICE_ID_INTEL_IGD_HB          0x2A40
+#define PCI_DEVICE_ID_INTEL_IGD_IG          0x2A42
 
 #define IS_I965 (agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82946GZ_HB || \
                  agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82965G_1_HB || \
                  agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82965Q_HB || \
                  agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82965G_HB || \
                  agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82965GM_HB || \
-                 agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82965GME_HB)
+                 agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82965GME_HB || \
+                 agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_IGD_HB)
 
 #define IS_G33 (agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_G33_HB || \
 		agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_Q35_HB || \
@@ -456,6 +459,15 @@ static void intel_i830_init_gtt_entries(void)
 		case I965_PGETBL_SIZE_512KB:
 			size = 512;
 			break;
+		case I965_PGETBL_SIZE_1MB:
+			size = 1024;
+			break;
+		case I965_PGETBL_SIZE_2MB:
+			size = 2048;
+			break;
+		case I965_PGETBL_SIZE_1_5MB:
+			size = 1024 + 512;
+			break;
 		default:
 			printk(KERN_INFO PFX "Unknown page table size, "
 			       "assuming 512KB\n");
@@ -981,6 +993,7 @@ static int intel_i965_create_gatt_table(struct agp_bridge_data *bridge)
        struct aper_size_info_fixed *size;
        int num_entries;
        u32 temp;
+       int gtt_offset, gtt_size;
 
        size = agp_bridge->current_size;
        page_order = size->page_order;
@@ -990,13 +1003,18 @@ static int intel_i965_create_gatt_table(struct agp_bridge_data *bridge)
        pci_read_config_dword(intel_private.pcidev, I915_MMADDR, &temp);
 
        temp &= 0xfff00000;
-       intel_private.gtt = ioremap((temp + (512 * 1024)) , 512 * 1024);
 
-	if (!intel_private.gtt)
-		return -ENOMEM;
+       if (agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_IGD_HB)
+	       gtt_offset = gtt_size = MB(2);
+       else
+	       gtt_offset = gtt_size = KB(512);
+
+       intel_private.gtt = ioremap((temp + gtt_offset) , gtt_size);
 
+       if (!intel_private.gtt)
+	       return -ENOMEM;
 
-       intel_private.registers = ioremap(temp,128 * 4096);
+       intel_private.registers = ioremap(temp, 128 * 4096);
        if (!intel_private.registers) {
 		iounmap(intel_private.gtt);
 		return -ENOMEM;
@@ -1884,6 +1902,8 @@ static const struct intel_driver_description {
 		NULL, &intel_g33_driver },
 	{ PCI_DEVICE_ID_INTEL_Q33_HB, PCI_DEVICE_ID_INTEL_Q33_IG, 0, "Q33",
 		NULL, &intel_g33_driver },
+	{ PCI_DEVICE_ID_INTEL_IGD_HB, PCI_DEVICE_ID_INTEL_IGD_IG, 0,
+	    "Intel Integrated Graphics Device", NULL, &intel_i965_driver },
 	{ 0, 0, 0, NULL, NULL, NULL }
 };
 
@@ -2073,6 +2093,7 @@ static struct pci_device_id agp_intel_pci_table[] = {
 	ID(PCI_DEVICE_ID_INTEL_G33_HB),
 	ID(PCI_DEVICE_ID_INTEL_Q35_HB),
 	ID(PCI_DEVICE_ID_INTEL_Q33_HB),
+	ID(PCI_DEVICE_ID_INTEL_IGD_HB),
 	{ }
 };
 
-- 
1.5.3.7

