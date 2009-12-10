Return-Path: <linux-kernel-owner+w=401wt.eu-S934355AbZLJL4J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934355AbZLJL4J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 06:56:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934257AbZLJL4C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 06:56:02 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:35755
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934207AbZLJLzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 06:55:55 -0500
X-SpamScore: 7
X-BigFish: VPS7(zba6lzab9bhzz1202hzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KUFQGZ-01-4VZ-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/2] x86/amd-iommu: Fix passthrough mode
Date: Thu, 10 Dec 2009 12:55:34 +0100
Message-ID: <1260446135-16460-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.5.4
In-Reply-To: <1260446135-16460-1-git-send-email-joerg.roedel@amd.com>
References: <1260446135-16460-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 10 Dec 2009 11:55:46.0966 (UTC) FILETIME=[B5BA7360:01CA798F]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The data structure changes to use dev->archdata.iommu field
broke the iommu=pt mode because in this case the
dev->archdata.iommu was left uninitialized. This moves the
inititalization of the devices into the main init function
and fixes the problem.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/amd_iommu_proto.h |    3 +-
 arch/x86/kernel/amd_iommu.c            |   39 ++++++++++++++++++++++++++++++-
 arch/x86/kernel/amd_iommu_init.c       |    7 +++++
 3 files changed, 46 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu_proto.h b/arch/x86/include/asm/amd_iommu_proto.h
index 84786fb..2566e26 100644
--- a/arch/x86/include/asm/amd_iommu_proto.h
+++ b/arch/x86/include/asm/amd_iommu_proto.h
@@ -28,7 +28,8 @@ extern void amd_iommu_flush_all_domains(void);
 extern void amd_iommu_flush_all_devices(void);
 extern void amd_iommu_apply_erratum_63(u16 devid);
 extern void amd_iommu_reset_cmd_buffer(struct amd_iommu *iommu);
-
+extern int amd_iommu_init_devices(void);
+extern void amd_iommu_uninit_devices(void);
 #ifndef CONFIG_AMD_IOMMU_STATS
 
 static inline void amd_iommu_stats_init(void) { }
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 32fb091..450dd6a 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -166,6 +166,43 @@ static void iommu_uninit_device(struct device *dev)
 {
 	kfree(dev->archdata.iommu);
 }
+
+void __init amd_iommu_uninit_devices(void)
+{
+	struct pci_dev *pdev = NULL;
+
+	for_each_pci_dev(pdev) {
+
+		if (!check_device(&pdev->dev))
+			continue;
+
+		iommu_uninit_device(&pdev->dev);
+	}
+}
+
+int __init amd_iommu_init_devices(void)
+{
+	struct pci_dev *pdev = NULL;
+	int ret = 0;
+
+	for_each_pci_dev(pdev) {
+
+		if (!check_device(&pdev->dev))
+			continue;
+
+		ret = iommu_init_device(&pdev->dev);
+		if (ret)
+			goto out_free;
+	}
+
+	return 0;
+
+out_free:
+
+	amd_iommu_uninit_devices();
+
+	return ret;
+}
 #ifdef CONFIG_AMD_IOMMU_STATS
 
 /*
@@ -2145,8 +2182,6 @@ static void prealloc_protection_domains(void)
 		if (!check_device(&dev->dev))
 			continue;
 
-		iommu_init_device(&dev->dev);
-
 		/* Is there already any domain for it? */
 		if (domain_for_device(&dev->dev))
 			continue;
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 7ffc399..df01c69 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -1274,6 +1274,10 @@ static int __init amd_iommu_init(void)
 	if (ret)
 		goto free;
 
+	ret = amd_iommu_init_devices();
+	if (ret)
+		goto free;
+
 	if (iommu_pass_through)
 		ret = amd_iommu_init_passthrough();
 	else
@@ -1296,6 +1300,9 @@ out:
 	return ret;
 
 free:
+
+	amd_iommu_uninit_devices();
+
 	free_pages((unsigned long)amd_iommu_pd_alloc_bitmap,
 		   get_order(MAX_DOMAIN_ID/8));
 
-- 
1.6.5.4


