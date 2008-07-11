Return-Path: <linux-kernel-owner+w=401wt.eu-S1760797AbYGKPQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760797AbYGKPQv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 11:16:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756322AbYGKPPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 11:15:05 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:64953 "EHLO
	SG2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755862AbYGKPPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 11:15:03 -0400
X-BigFish: VPS30(z5edJz9321ivzz10d3izzz32i)
X-FB-OUTBOUND-SPAM: yes
X-SpamScore: 30
X-WSS-ID: 0K3UL0B-03-1O7-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, robert.richter@amd.com,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 05/16] AMD IOMMU: replace UPDATE_LAST_BDF macro with a function
Date: Fri, 11 Jul 2008 17:14:24 +0200
Message-ID: <1215789275-20975-6-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1215789275-20975-1-git-send-email-joerg.roedel@amd.com>
References: <1215789275-20975-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 11 Jul 2008 15:14:36.0071 (UTC) FILETIME=[D476AB70:01C8E368]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces the UPDATE_LAST_BDF macro in the init code with the
update_last_devid function.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 9ddb46d..6e1c8ff 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -30,11 +30,6 @@
 /*
  * definitions for the ACPI scanning code
  */
-#define UPDATE_LAST_BDF(x) do {\
-	if ((x) > amd_iommu_last_bdf) \
-		amd_iommu_last_bdf = (x); \
-	} while (0);
-
 #define DEVID(bus, devfn) (((bus) << 8) | (devfn))
 #define PCI_BUS(x) (((x) >> 8) & 0xff)
 #define IVRS_HEADER_LENGTH 48
@@ -169,6 +164,12 @@ static u32 dev_table_size;	/* size of the device table */
 static u32 alias_table_size;	/* size of the alias table */
 static u32 rlookup_table_size;	/* size if the rlookup table */
 
+static inline void update_last_devid(u16 devid)
+{
+	if (devid > amd_iommu_last_bdf)
+		amd_iommu_last_bdf = devid;
+}
+
 /****************************************************************************
  *
  * AMD IOMMU MMIO register space handling functions
@@ -287,7 +288,7 @@ static int __init find_last_devid_on_pci(int bus, int dev, int fn, int cap_ptr)
 	u32 cap;
 
 	cap = read_pci_config(bus, dev, fn, cap_ptr+MMIO_RANGE_OFFSET);
-	UPDATE_LAST_BDF(DEVID(MMIO_GET_BUS(cap), MMIO_GET_LD(cap)));
+	update_last_devid(DEVID(MMIO_GET_BUS(cap), MMIO_GET_LD(cap)));
 
 	return 0;
 }
@@ -317,7 +318,7 @@ static int __init find_last_devid_from_ivhd(struct ivhd_header *h)
 		case IVHD_DEV_ALIAS:
 		case IVHD_DEV_EXT_SELECT:
 			/* all the above subfield types refer to device ids */
-			UPDATE_LAST_BDF(dev->devid);
+			update_last_devid(dev->devid);
 			break;
 		default:
 			break;
-- 
1.5.3.7


