Return-Path: <linux-kernel-owner+w=401wt.eu-S1758456AbZEVMSM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758456AbZEVMSM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 08:18:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758056AbZEVMQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 08:16:16 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:16954
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758091AbZEVMQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 08:16:14 -0400
X-BigFish: VPS-7(z6c9Rzzz1202hzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KK1OQI-03-94G-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 9/9] amd-iommu: implement suspend/resume
Date: Fri, 22 May 2009 14:15:40 +0200
Message-ID: <1242994540-28799-10-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1242994540-28799-1-git-send-email-joerg.roedel@amd.com>
References: <1242994540-28799-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 22 May 2009 12:15:42.0485 (UTC) FILETIME=[06DEAC50:01C9DAD7]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ impact: put everything together and enable suspend/resume ]

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c |   21 ++++++++++++++++++++-
 1 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 330896b..4ca8fbf 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -965,12 +965,31 @@ static void disable_iommus(void)
 
 static int amd_iommu_resume(struct sys_device *dev)
 {
+	/*
+	 * Disable IOMMUs before reprogramming the hardware registers.
+	 * IOMMU is still enabled from the resume kernel.
+	 */
+	disable_iommus();
+
+	/* re-load the hardware */
+	enable_iommus();
+
+	/*
+	 * we have to flush after the IOMMUs are enabled because a
+	 * disabled IOMMU will never execute the commands we send
+	 */
+	amd_iommu_flush_all_domains();
+	amd_iommu_flush_all_devices();
+
 	return 0;
 }
 
 static int amd_iommu_suspend(struct sys_device *dev, pm_message_t state)
 {
-	return -EINVAL;
+	/* disable IOMMUs to go out of the way for BIOS */
+	disable_iommus();
+
+	return 0;
 }
 
 static struct sysdev_class amd_iommu_sysdev_class = {
-- 
1.6.3.1


