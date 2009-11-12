Return-Path: <linux-kernel-owner+w=401wt.eu-S1754342AbZKLUxN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342AbZKLUxN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 15:53:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754362AbZKLUxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 15:53:12 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:63585 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754337AbZKLUxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 15:53:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=AQusP99CotYsL28kqE/tlXs6Qja6NIlrfiozXG9TW29eFbpirdZvAqlCd0H5HmD54W
         g0G2BQzfkpdQ4dBSL+CdMr8X4V5OEzYM0yQbD/2yOt7DmLX82gB4rGdAAOG00t/B2NOB
         6D7u/TbSXa3vus5ZlfMkoFmqewmrjmziALv3A=
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Tony Lindgren <tony@atomide.com>, Hiroshi Doyu <hiroshi.doyu@nokia.com>,
       Hari Kanigeri <h-kanigeri2@ti.com>,
       Felipe Contreras <felipe.contreras@gmail.com>,
       Russell King <linux@arm.linux.org.uk>,
       Hiroshi DOYU <Hiroshi.DOYU@nokia.com>, linux-omap@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3] omap3-iommu: reorganize
Date: Thu, 12 Nov 2009 22:53:00 +0200
Message-Id: <1258059180-4353-2-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1258059180-4353-1-git-send-email-felipe.contreras@gmail.com>
References: <1258059180-4353-1-git-send-email-felipe.contreras@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This way it's more object oriented and easier to see what is happening.
No functional changes.

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---
 arch/arm/mach-omap2/omap3-iommu.c |   62 ++++++++++++++++++------------------
 1 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/arch/arm/mach-omap2/omap3-iommu.c b/arch/arm/mach-omap2/omap3-iommu.c
index 6a9bf4f..fbbcb5c 100644
--- a/arch/arm/mach-omap2/omap3-iommu.c
+++ b/arch/arm/mach-omap2/omap3-iommu.c
@@ -14,47 +14,50 @@
 
 #include <plat/iommu.h>
 
-#define OMAP3_MMU1_BASE	0x480bd400
-#define OMAP3_MMU2_BASE	0x5d000000
-#define OMAP3_MMU1_IRQ	24
-#define OMAP3_MMU2_IRQ	28
-
-
-static unsigned long iommu_base[] __initdata = {
-	OMAP3_MMU1_BASE,
-	OMAP3_MMU2_BASE,
-};
-
-static int iommu_irq[] __initdata = {
-	OMAP3_MMU1_IRQ,
-	OMAP3_MMU2_IRQ,
+struct iommu_device {
+	resource_size_t base;
+	int irq;
+	struct iommu_platform_data pdata;
+	struct resource res[2];
 };
 
-static const struct iommu_platform_data omap3_iommu_pdata[] __initconst = {
+static struct iommu_device devices[] = {
 	{
-		.name = "isp",
-		.nr_tlb_entries = 8,
-		.clk_name = "cam_ick",
+		.base = 0x480bd400,
+		.irq = 24,
+		.pdata = {
+			.name = "isp",
+			.nr_tlb_entries = 8,
+			.clk_name = "cam_ick",
+		},
 	},
 #if defined(CONFIG_MPU_BRIDGE_IOMMU)
 	{
-		.name = "iva2",
-		.nr_tlb_entries = 32,
-		.clk_name = "iva2_ck",
+		.base = 0x5d000000,
+		.irq = 28,
+		.pdata = {
+			.name = "iva2",
+			.nr_tlb_entries = 32,
+			.clk_name = "iva2_ck",
+		},
 	},
 #endif
 };
-#define NR_IOMMU_DEVICES ARRAY_SIZE(omap3_iommu_pdata)
+#define NR_IOMMU_DEVICES ARRAY_SIZE(devices)
 
 static struct platform_device *omap3_iommu_pdev[NR_IOMMU_DEVICES];
 
 static int __init omap3_iommu_init(void)
 {
 	int i, err;
+	struct resource res[] = {
+		{ .flags = IORESOURCE_MEM },
+		{ .flags = IORESOURCE_IRQ },
+	};
 
 	for (i = 0; i < NR_IOMMU_DEVICES; i++) {
 		struct platform_device *pdev;
-		struct resource res[2];
+		const struct iommu_device *d = &devices[i];
 
 		pdev = platform_device_alloc("omap-iommu", i);
 		if (!pdev) {
@@ -62,19 +65,16 @@ static int __init omap3_iommu_init(void)
 			goto err_out;
 		}
 
-		memset(res, 0,  sizeof(res));
-		res[0].start = iommu_base[i];
-		res[0].end = iommu_base[i] + MMU_REG_SIZE - 1;
-		res[0].flags = IORESOURCE_MEM;
-		res[1].start = res[1].end = iommu_irq[i];
-		res[1].flags = IORESOURCE_IRQ;
+		res[0].start = d->base;
+		res[0].end = d->base + MMU_REG_SIZE - 1;
+		res[1].start = res[1].end = d->irq;
 
 		err = platform_device_add_resources(pdev, res,
 						    ARRAY_SIZE(res));
 		if (err)
 			goto err_out;
-		err = platform_device_add_data(pdev, &omap3_iommu_pdata[i],
-					       sizeof(omap3_iommu_pdata[0]));
+		err = platform_device_add_data(pdev, &d->pdata,
+					       sizeof(d->pdata));
 		if (err)
 			goto err_out;
 		err = platform_device_add(pdev);
-- 
1.6.5.2

