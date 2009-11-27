Return-Path: <linux-kernel-owner+w=401wt.eu-S1753950AbZK0OAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950AbZK0OAg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 09:00:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753128AbZK0Nz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 08:55:58 -0500
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:17999 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647AbZK0Nzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 08:55:53 -0500
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KTRTD3-02-34Q-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 26/34] x86/amd-iommu: Remove support for domain sharing
Date: Fri, 27 Nov 2009 14:55:37 +0100
Message-ID: <1259330145-14865-27-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <1259330145-14865-1-git-send-email-joerg.roedel@amd.com>
References: <1259330145-14865-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Nov 2009 13:55:48.0373 (UTC) FILETIME=[52BB3450:01CA6F69]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes device isolation mandatory and removes
support for the amd_iommu=share option. This simplifies the
code in several places.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/amd_iommu_types.h |    3 ---
 arch/x86/kernel/amd_iommu.c            |   10 ++--------
 arch/x86/kernel/amd_iommu_init.c       |   17 -----------------
 3 files changed, 2 insertions(+), 28 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
index 4899f78..02b6a0f 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -451,9 +451,6 @@ extern struct protection_domain **amd_iommu_pd_table;
 /* allocation bitmap for domain ids */
 extern unsigned long *amd_iommu_pd_alloc_bitmap;
 
-/* will be 1 if device isolation is enabled */
-extern bool amd_iommu_isolate;
-
 /*
  * If true, the addresses will be flushed on unmap time, not when
  * they are reused
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 14b60c0..ed58a16 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -148,7 +148,6 @@ DECLARE_STATS_COUNTER(alloced_io_mem);
 DECLARE_STATS_COUNTER(total_map_requests);
 
 static struct dentry *stats_dir;
-static struct dentry *de_isolate;
 static struct dentry *de_fflush;
 
 static void amd_iommu_stats_add(struct __iommu_counter *cnt)
@@ -166,9 +165,6 @@ static void amd_iommu_stats_init(void)
 	if (stats_dir == NULL)
 		return;
 
-	de_isolate = debugfs_create_bool("isolation", 0444, stats_dir,
-					 (u32 *)&amd_iommu_isolate);
-
 	de_fflush  = debugfs_create_bool("fullflush", 0444, stats_dir,
 					 (u32 *)&amd_iommu_unmap_flush);
 
@@ -2135,11 +2131,9 @@ int __init amd_iommu_init_dma_ops(void)
 	}
 
 	/*
-	 * If device isolation is enabled, pre-allocate the protection
-	 * domains for each device.
+	 * Pre-allocate the protection domains for each device.
 	 */
-	if (amd_iommu_isolate)
-		prealloc_protection_domains();
+	prealloc_protection_domains();
 
 	iommu_detected = 1;
 	swiotlb = 0;
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index fbe4c3c..fe1686f 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -125,13 +125,6 @@ u16 amd_iommu_last_bdf;			/* largest PCI device id we have
 					   to handle */
 LIST_HEAD(amd_iommu_unity_map);		/* a list of required unity mappings
 					   we find in ACPI */
-#ifdef CONFIG_IOMMU_STRESS
-bool amd_iommu_isolate = false;
-#else
-bool amd_iommu_isolate = true;		/* if true, device isolation is
-					   enabled */
-#endif
-
 bool amd_iommu_unmap_flush;		/* if true, flush on every unmap */
 
 LIST_HEAD(amd_iommu_list);		/* list of all AMD IOMMUs in the
@@ -1308,12 +1301,6 @@ static int __init amd_iommu_init(void)
 	if (iommu_pass_through)
 		goto out;
 
-	printk(KERN_INFO "AMD-Vi: device isolation ");
-	if (amd_iommu_isolate)
-		printk("enabled\n");
-	else
-		printk("disabled\n");
-
 	if (amd_iommu_unmap_flush)
 		printk(KERN_INFO "AMD-Vi: IO/TLB flush on unmap enabled\n");
 	else
@@ -1387,10 +1374,6 @@ static int __init parse_amd_iommu_dump(char *str)
 static int __init parse_amd_iommu_options(char *str)
 {
 	for (; *str; ++str) {
-		if (strncmp(str, "isolate", 7) == 0)
-			amd_iommu_isolate = true;
-		if (strncmp(str, "share", 5) == 0)
-			amd_iommu_isolate = false;
 		if (strncmp(str, "fullflush", 9) == 0)
 			amd_iommu_unmap_flush = true;
 	}
-- 
1.6.5.3


