Return-Path: <linux-kernel-owner+w=401wt.eu-S1754996AbZLUPWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996AbZLUPWt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 10:22:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754508AbZLUPWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 10:22:47 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:24872
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754284AbZLUPWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 10:22:43 -0500
X-SpamScore: 1
X-BigFish: VPS1(zzab9bhzz1202hzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KV0DD4-02-36K-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>, stable@kernel.org
Subject: [PATCH 2/2] x86/amd-iommu: Fix initialization failure panic
Date: Mon, 21 Dec 2009 16:22:09 +0100
Message-ID: <1261408929-6261-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.5.4
In-Reply-To: <1261408929-6261-1-git-send-email-joerg.roedel@amd.com>
References: <1261408929-6261-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 21 Dec 2009 15:22:13.0413 (UTC) FILETIME=[5F2B8550:01CA8251]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The assumption that acpi_table_parse passes the return value
of the hanlder function to the caller proved wrong
recently. The return value of the handler function is
totally ignored. This makes the initialization code for AMD
IOMMU buggy in a way that could cause a kernel panic on
initialization. This patch fixes the issue in the AMD IOMMU
driver.

Cc: stable@kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 1dca9c3..fb490ce 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -138,6 +138,11 @@ int amd_iommus_present;
 bool amd_iommu_np_cache __read_mostly;
 
 /*
+ * Set to true if ACPI table parsing and hardware intialization went properly
+ */
+static bool amd_iommu_initialized;
+
+/*
  * List of protection domains - used during resume
  */
 LIST_HEAD(amd_iommu_pd_list);
@@ -929,6 +934,8 @@ static int __init init_iommu_all(struct acpi_table_header *table)
 	}
 	WARN_ON(p != end);
 
+	amd_iommu_initialized = true;
+
 	return 0;
 }
 
@@ -1263,6 +1270,9 @@ static int __init amd_iommu_init(void)
 	if (acpi_table_parse("IVRS", init_iommu_all) != 0)
 		goto free;
 
+	if (!amd_iommu_initialized)
+		goto free;
+
 	if (acpi_table_parse("IVRS", init_memory_definitions) != 0)
 		goto free;
 
-- 
1.6.5.4


