Return-Path: <linux-kernel-owner+w=401wt.eu-S1764377AbZAPIjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764377AbZAPIjN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 03:39:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761387AbZAPIhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 03:37:43 -0500
Received: from smtp.nokia.com ([192.100.122.230]:30893 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760367AbZAPIhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 03:37:41 -0500
From: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Subject: [PATCH 3/6] omap iommu: omap3 iommu device registration
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-omap@vger.kernel.org
Date: Fri, 16 Jan 2009 10:37:20 +0200
Message-ID: <20090116083719.18344.28959.stgit@oreo.research.nokia.com>
In-Reply-To: <20090116083003.18344.38307.stgit@oreo.research.nokia.com>
References: <20090116083003.18344.38307.stgit@oreo.research.nokia.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jan 2009 08:37:21.0183 (UTC) FILETIME=[A5D622F0:01C977B5]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
---

 arch/arm/mach-omap2/omap3-iommu.c |  111 +++++++++++++++++++++++++++++++++++++
 1 files changed, 111 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-omap2/omap3-iommu.c

diff --git a/arch/arm/mach-omap2/omap3-iommu.c b/arch/arm/mach-omap2/omap3-iommu.c
new file mode 100644
index 0000000..52d0e56
--- /dev/null
+++ b/arch/arm/mach-omap2/omap3-iommu.c
@@ -0,0 +1,111 @@
+/*
+ * omap iommu: omap3 device registration
+ *
+ * Copyright (C) 2008 Nokia Corporation
+ *
+ * Written by Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/io.h>
+#include <linux/platform_device.h>
+
+#include <mach/iommu.h>
+
+#define DEVNAME "omap-iommu"
+
+/* Camera ISP MMU */
+#define OMAP3_MMU1_BASE		0x480bd400
+#define OMAP3_MMU1_IRQ		24
+
+/* IVA2.2 MMU */
+#define OMAP3_MMU2_BASE		0x5d000000
+#define OMAP3_MMU2_IRQ		28
+
+static struct resource iommu1_res[] = { /* Camera ISP MMU */
+	{
+		.start		= OMAP3_MMU1_BASE,
+		.end		= OMAP3_MMU1_BASE + MMU_REG_SIZE - 1,
+		.flags		= IORESOURCE_MEM,
+	},
+	{
+		.start		= OMAP3_MMU1_IRQ,
+		.flags		= IORESOURCE_IRQ,
+	},
+};
+
+static struct resource iommu2_res[] = { /* IVA2.2 MMU */
+	{
+		.start		= OMAP3_MMU2_BASE,
+		.end		= OMAP3_MMU2_BASE + MMU_REG_SIZE - 1,
+		.flags		= IORESOURCE_MEM,
+	},
+	{
+		.start		= OMAP3_MMU2_IRQ,
+		.flags		= IORESOURCE_IRQ,
+	},
+};
+
+static struct iommu_platform_data omap3_iommu_pdata[] = {
+	{
+		.name = "isp",
+		.nr_tlb_entries = 8,
+		.clk_name = "cam_ick",
+	},
+	{
+		.name = "iva2",
+		.nr_tlb_entries = 32,
+		.clk_name = "iva2_ck",
+	},
+};
+
+static void omap3_iommu_release(struct device *dev)
+{
+}
+
+static struct platform_device omap3_iommu_pdev[] = {
+	{
+		.name		= DEVNAME,
+		.id		= 1,
+		.num_resources	= ARRAY_SIZE(iommu1_res),
+		.resource	= iommu1_res,
+		.dev		= {
+			.release = omap3_iommu_release,
+			.platform_data = &omap3_iommu_pdata[0],
+		},
+	},
+	{
+		.name		= DEVNAME,
+		.id		= 2,
+		.num_resources	= ARRAY_SIZE(iommu2_res),
+		.resource	= iommu2_res,
+		.dev		= {
+			.release = omap3_iommu_release,
+			.platform_data = &omap3_iommu_pdata[1],
+		},
+	},
+};
+
+static int __init omap3_iommu_init(void)
+{
+	int i;
+	for (i = 0; i < ARRAY_SIZE(omap3_iommu_pdev); i++)
+		platform_device_register(&omap3_iommu_pdev[i]);
+	return 0;
+}
+module_init(omap3_iommu_init);
+
+static void __exit omap3_iommu_exit(void)
+{
+	int i;
+	for (i = 0; i < ARRAY_SIZE(omap3_iommu_pdev); i++)
+		platform_device_unregister(&omap3_iommu_pdev[i]);
+}
+module_exit(omap3_iommu_exit);
+
+MODULE_AUTHOR("Hiroshi DOYU");
+MODULE_DESCRIPTION("omap iommu: omap3 device registration");
+MODULE_LICENSE("GPL v2");

