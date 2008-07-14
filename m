Return-Path: <linux-kernel-owner+w=401wt.eu-S1756437AbYGNSLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756437AbYGNSLs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 14:11:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753803AbYGNSLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 14:11:40 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:25959 "EHLO
	VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbYGNSLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 14:11:39 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K40D6P-03-71U-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, robert.richter@amd.com,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH] AMD IOMMU: set iommu for device from ACPI code too
Date: Mon, 14 Jul 2008 20:11:18 +0200
Message-ID: <1216059078-4054-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
X-OriginalArrivalTime: 14 Jul 2008 18:11:18.0762 (UTC) FILETIME=[03662CA0:01C8E5DD]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device<->iommu relationship has to be set from the information in the ACPI
table too. This patch adds this logic to the driver.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c |   27 ++++++++++++++++-----------
 1 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 8749520..c9d8ff2 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -426,11 +426,18 @@ static void set_dev_entry_bit(u16 devid, u8 bit)
 	amd_iommu_dev_table[devid].data[i] |= (1 << _bit);
 }
 
+/* Writes the specific IOMMU for a device into the rlookup table */
+static void __init set_iommu_for_device(struct amd_iommu *iommu, u16 devid)
+{
+	amd_iommu_rlookup_table[devid] = iommu;
+}
+
 /*
  * This function takes the device specific flags read from the ACPI
  * table and sets up the device table entry with that information
  */
-static void __init set_dev_entry_from_acpi(u16 devid, u32 flags, u32 ext_flags)
+static void __init set_dev_entry_from_acpi(struct amd_iommu *iommu,
+					   u16 devid, u32 flags, u32 ext_flags)
 {
 	if (flags & ACPI_DEVFLAG_INITPASS)
 		set_dev_entry_bit(devid, DEV_ENTRY_INIT_PASS);
@@ -446,12 +453,8 @@ static void __init set_dev_entry_from_acpi(u16 devid, u32 flags, u32 ext_flags)
 		set_dev_entry_bit(devid, DEV_ENTRY_LINT0_PASS);
 	if (flags & ACPI_DEVFLAG_LINT1)
 		set_dev_entry_bit(devid, DEV_ENTRY_LINT1_PASS);
-}
 
-/* Writes the specific IOMMU for a device into the rlookup table */
-static void __init set_iommu_for_device(struct amd_iommu *iommu, u16 devid)
-{
-	amd_iommu_rlookup_table[devid] = iommu;
+	set_iommu_for_device(iommu, devid);
 }
 
 /*
@@ -550,11 +553,12 @@ static void __init init_iommu_from_acpi(struct amd_iommu *iommu,
 		case IVHD_DEV_ALL:
 			for (dev_i = iommu->first_device;
 					dev_i <= iommu->last_device; ++dev_i)
-				set_dev_entry_from_acpi(dev_i, e->flags, 0);
+				set_dev_entry_from_acpi(iommu, dev_i,
+							e->flags, 0);
 			break;
 		case IVHD_DEV_SELECT:
 			devid = e->devid;
-			set_dev_entry_from_acpi(devid, e->flags, 0);
+			set_dev_entry_from_acpi(iommu, devid, e->flags, 0);
 			break;
 		case IVHD_DEV_SELECT_RANGE_START:
 			devid_start = e->devid;
@@ -565,7 +569,7 @@ static void __init init_iommu_from_acpi(struct amd_iommu *iommu,
 		case IVHD_DEV_ALIAS:
 			devid = e->devid;
 			devid_to = e->ext >> 8;
-			set_dev_entry_from_acpi(devid, e->flags, 0);
+			set_dev_entry_from_acpi(iommu, devid, e->flags, 0);
 			amd_iommu_alias_table[devid] = devid_to;
 			break;
 		case IVHD_DEV_ALIAS_RANGE:
@@ -577,7 +581,8 @@ static void __init init_iommu_from_acpi(struct amd_iommu *iommu,
 			break;
 		case IVHD_DEV_EXT_SELECT:
 			devid = e->devid;
-			set_dev_entry_from_acpi(devid, e->flags, e->ext);
+			set_dev_entry_from_acpi(iommu, devid, e->flags,
+						e->ext);
 			break;
 		case IVHD_DEV_EXT_SELECT_RANGE:
 			devid_start = e->devid;
@@ -590,7 +595,7 @@ static void __init init_iommu_from_acpi(struct amd_iommu *iommu,
 			for (dev_i = devid_start; dev_i <= devid; ++dev_i) {
 				if (alias)
 					amd_iommu_alias_table[dev_i] = devid_to;
-				set_dev_entry_from_acpi(
+				set_dev_entry_from_acpi(iommu,
 						amd_iommu_alias_table[dev_i],
 						flags, ext_flags);
 			}
-- 
1.5.3.7


