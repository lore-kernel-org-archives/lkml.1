Return-Path: <linux-kernel-owner+w=401wt.eu-S1763407AbYF3SSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763407AbYF3SSd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 14:18:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754476AbYF3SS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 14:18:26 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:35813 "EHLO
	VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789AbYF3SSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 14:18:25 -0400
X-BigFish: VPS-6(z6c9Rzzz10d3izzz32i43j63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0K3AG5Y-03-U59-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH] AMD IOMMU: disable suspend/resume with IOMMU enabled (for now)
Date: Mon, 30 Jun 2008 20:18:02 +0200
Message-ID: <1214849882-18550-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
X-OriginalArrivalTime: 30 Jun 2008 18:18:03.0051 (UTC) FILETIME=[A29747B0:01C8DADD]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch disables suspend/resume on machines with AMD IOMMU enabled. Real
suspend/resume support for AMD IOMMU is currently being worked on. Until this
is ready it will be disabled to avoid data corruption when the IOMMU is not
properly re-enabled at resume. The patch is based on a similar patch for the
GART driver written by Pavel Machek.
The overall driver merged into tip/master is tested with parallel disk and
network loads and showed no problems in a test running for 3 days.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c |   35 +++++++++++++++++++++++++++++++++++
 1 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 6ab8128..5d9e45c 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -21,6 +21,7 @@
 #include <linux/acpi.h>
 #include <linux/gfp.h>
 #include <linux/list.h>
+#include <linux/sysdev.h>
 #include <asm/pci-direct.h>
 #include <asm/amd_iommu_types.h>
 #include <asm/amd_iommu.h>
@@ -654,6 +655,32 @@ static void __init enable_iommus(void)
 	}
 }
 
+/*
+ * Suspend/Resume support
+ * disable suspend until real resume implemented
+ */
+
+static int amd_iommu_resume(struct sys_device *dev)
+{
+	return 0;
+}
+
+static int amd_iommu_suspend(struct sys_device *dev, pm_message_t state)
+{
+	return -EINVAL;
+}
+
+static struct sysdev_class amd_iommu_sysdev_class = {
+	.name = "amd_iommu",
+	.suspend = amd_iommu_suspend,
+	.resume = amd_iommu_resume,
+};
+
+static struct sys_device device_amd_iommu = {
+	.id = 0,
+	.cls = &amd_iommu_sysdev_class,
+};
+
 int __init amd_iommu_init(void)
 {
 	int i, ret = 0;
@@ -745,6 +772,14 @@ int __init amd_iommu_init(void)
 	if (ret)
 		goto free;
 
+	ret = sysdev_class_register(&amd_iommu_sysdev_class);
+	if (ret)
+		goto free;
+
+	ret = sysdev_register(&device_amd_iommu);
+	if (ret)
+		goto free;
+
 	enable_iommus();
 
 	printk(KERN_INFO "AMD IOMMU: aperture size is %d MB\n",
-- 
1.5.3.7


