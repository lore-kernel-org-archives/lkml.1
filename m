Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615Ab0CANZt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 08:25:49 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:56384
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751507Ab0CANZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 08:25:46 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i6bh2a8h87h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYLULH-01-6WZ-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org
CC: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 4/4] x86/amd-iommu: Report errors in acpi parsing functions upstream
Date: Mon, 1 Mar 2010 14:24:42 +0100
Message-ID: <1267449882-1415-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1267449882-1415-1-git-send-email-joerg.roedel@amd.com>
References: <1267449882-1415-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 01 Mar 2010 13:24:48.0849 (UTC) FILETIME=[9132DC10:01CAB942]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since acpi_table_parse ignores the return values of the
parsing function this patch introduces a workaround and
reports these errors upstream via a global variable.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c |   38 +++++++++++++++++++++++++++-----------
 1 files changed, 27 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 9dc91b4..feaf471 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -138,9 +138,9 @@ int amd_iommus_present;
 bool amd_iommu_np_cache __read_mostly;
 
 /*
- * Set to true if ACPI table parsing and hardware intialization went properly
+ * The ACPI table parsing functions set this variable on an error
  */
-static bool amd_iommu_initialized;
+static int __initdata amd_iommu_init_err;
 
 /*
  * List of protection domains - used during resume
@@ -391,9 +391,11 @@ static int __init find_last_devid_acpi(struct acpi_table_header *table)
 	 */
 	for (i = 0; i < table->length; ++i)
 		checksum += p[i];
-	if (checksum != 0)
+	if (checksum != 0) {
 		/* ACPI table corrupt */
-		return -ENODEV;
+		amd_iommu_init_err = -ENODEV;
+		return 0;
+	}
 
 	p += IVRS_HEADER_LENGTH;
 
@@ -920,11 +922,16 @@ static int __init init_iommu_all(struct acpi_table_header *table)
 				    h->mmio_phys);
 
 			iommu = kzalloc(sizeof(struct amd_iommu), GFP_KERNEL);
-			if (iommu == NULL)
-				return -ENOMEM;
+			if (iommu == NULL) {
+				amd_iommu_init_err = -ENOMEM;
+				return 0;
+			}
+
 			ret = init_iommu_one(iommu, h);
-			if (ret)
-				return ret;
+			if (ret) {
+				amd_iommu_init_err = ret;
+				return 0;
+			}
 			break;
 		default:
 			break;
@@ -934,8 +941,6 @@ static int __init init_iommu_all(struct acpi_table_header *table)
 	}
 	WARN_ON(p != end);
 
-	amd_iommu_initialized = true;
-
 	return 0;
 }
 
@@ -1211,6 +1216,10 @@ static int __init amd_iommu_init(void)
 	if (acpi_table_parse("IVRS", find_last_devid_acpi) != 0)
 		return -ENODEV;
 
+	ret = amd_iommu_init_err;
+	if (ret)
+		goto out;
+
 	dev_table_size     = tbl_size(DEV_TABLE_ENTRY_SIZE);
 	alias_table_size   = tbl_size(ALIAS_TABLE_ENTRY_SIZE);
 	rlookup_table_size = tbl_size(RLOOKUP_TABLE_ENTRY_SIZE);
@@ -1270,12 +1279,19 @@ static int __init amd_iommu_init(void)
 	if (acpi_table_parse("IVRS", init_iommu_all) != 0)
 		goto free;
 
-	if (!amd_iommu_initialized)
+	if (amd_iommu_init_err) {
+		ret = amd_iommu_init_err;
 		goto free;
+	}
 
 	if (acpi_table_parse("IVRS", init_memory_definitions) != 0)
 		goto free;
 
+	if (amd_iommu_init_err) {
+		ret = amd_iommu_init_err;
+		goto free;
+	}
+
 	ret = sysdev_class_register(&amd_iommu_sysdev_class);
 	if (ret)
 		goto free;
-- 
1.7.0


