Return-Path: <linux-kernel-owner+w=401wt.eu-S1760651AbYGKPTB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760651AbYGKPTB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 11:19:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759448AbYGKPPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 11:15:18 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:1276 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759382AbYGKPPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 11:15:16 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0K3UL0E-03-1OL-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, robert.richter@amd.com,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 06/16] AMD IOMMU: replace TBL_SIZE macro with a function
Date: Fri, 11 Jul 2008 17:14:25 +0200
Message-ID: <1215789275-20975-7-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1215789275-20975-1-git-send-email-joerg.roedel@amd.com>
References: <1215789275-20975-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 11 Jul 2008 15:14:36.0118 (UTC) FILETIME=[D47DD760:01C8E368]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the TBL_SIZE macro in the init code to a function.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 6e1c8ff..1f14839 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -33,7 +33,6 @@
 #define DEVID(bus, devfn) (((bus) << 8) | (devfn))
 #define PCI_BUS(x) (((x) >> 8) & 0xff)
 #define IVRS_HEADER_LENGTH 48
-#define TBL_SIZE(x) (1 << (PAGE_SHIFT + get_order(amd_iommu_last_bdf * (x))))
 
 #define ACPI_IVHD_TYPE                  0x10
 #define ACPI_IVMD_TYPE_ALL              0x20
@@ -170,6 +169,14 @@ static inline void update_last_devid(u16 devid)
 		amd_iommu_last_bdf = devid;
 }
 
+static inline unsigned long tbl_size(int entry_size)
+{
+	unsigned shift = PAGE_SHIFT +
+			 get_order(amd_iommu_last_bdf * entry_size);
+
+	return 1UL << shift;
+}
+
 /****************************************************************************
  *
  * AMD IOMMU MMIO register space handling functions
@@ -884,9 +891,9 @@ int __init amd_iommu_init(void)
 	if (acpi_table_parse("IVRS", find_last_devid_acpi) != 0)
 		return -ENODEV;
 
-	dev_table_size     = TBL_SIZE(DEV_TABLE_ENTRY_SIZE);
-	alias_table_size   = TBL_SIZE(ALIAS_TABLE_ENTRY_SIZE);
-	rlookup_table_size = TBL_SIZE(RLOOKUP_TABLE_ENTRY_SIZE);
+	dev_table_size     = tbl_size(DEV_TABLE_ENTRY_SIZE);
+	alias_table_size   = tbl_size(ALIAS_TABLE_ENTRY_SIZE);
+	rlookup_table_size = tbl_size(RLOOKUP_TABLE_ENTRY_SIZE);
 
 	ret = -ENOMEM;
 
-- 
1.5.3.7


