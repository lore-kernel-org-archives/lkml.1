Return-Path: <linux-kernel-owner+w=401wt.eu-S1752982AbZGCIab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982AbZGCIab (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 04:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753098AbZGCIaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 04:30:16 -0400
Received: from wa4ehsobe002.messaging.microsoft.com ([216.32.181.12]:35727
	"EHLO WA4EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751742AbZGCIaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 04:30:13 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KM76A9-02-2ZX-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/2] amd-iommu: handle alias entries correctly in init code
Date: Fri, 3 Jul 2009 10:29:12 +0200
Message-ID: <1246609753-30929-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1246609753-30929-1-git-send-email-joerg.roedel@amd.com>
References: <1246609753-30929-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 03 Jul 2009 08:29:18.0540 (UTC) FILETIME=[5B8EA8C0:01C9FBB8]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An alias entry in the ACPI table means that the device can send requests to the
IOMMU with both device ids, its own and the alias. This is not handled properly
in the ACPI init code. This patch fixes the issue.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 10b2acc..ec72c77 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -691,6 +691,7 @@ static void __init init_iommu_from_acpi(struct amd_iommu *iommu,
 
 			devid = e->devid;
 			devid_to = e->ext >> 8;
+			set_dev_entry_from_acpi(iommu, devid   , e->flags, 0);
 			set_dev_entry_from_acpi(iommu, devid_to, e->flags, 0);
 			amd_iommu_alias_table[devid] = devid_to;
 			break;
@@ -749,11 +750,13 @@ static void __init init_iommu_from_acpi(struct amd_iommu *iommu,
 
 			devid = e->devid;
 			for (dev_i = devid_start; dev_i <= devid; ++dev_i) {
-				if (alias)
+				if (alias) {
 					amd_iommu_alias_table[dev_i] = devid_to;
-				set_dev_entry_from_acpi(iommu,
-						amd_iommu_alias_table[dev_i],
-						flags, ext_flags);
+					set_dev_entry_from_acpi(iommu,
+						devid_to, flags, ext_flags);
+				}
+				set_dev_entry_from_acpi(iommu, dev_i,
+							flags, ext_flags);
 			}
 			break;
 		default:
-- 
1.6.3.3


