Return-Path: <linux-kernel-owner+w=401wt.eu-S1756136AbZA0Vac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136AbZA0Vac (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 16:30:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755169AbZA0VaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 16:30:10 -0500
Received: from smtp.nokia.com ([192.100.105.134]:64531 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283AbZA0VaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 16:30:08 -0500
Date: Tue, 27 Jan 2009 23:29:35 +0200 (EET)
Message-Id: <20090127.232935.68131092.Hiroshi.DOYU@nokia.com>
To: linux@arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-omap@vger.kernel.org
Subject: Re: [PATCH 3/6] omap iommu: omap3 iommu device registration
From: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
In-Reply-To: <20090117162139.GB12341@n2100.arm.linux.org.uk>
References: <20090116083719.18344.28959.stgit@oreo.research.nokia.com>
	<20090117162139.GB12341@n2100.arm.linux.org.uk>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
 boundary="--Next_Part(Tue_Jan_27_23_29_35_2009_013)--"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Jan 2009 21:29:36.0931 (UTC) FILETIME=[5AA36F30:01C980C6]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----Next_Part(Tue_Jan_27_23_29_35_2009_013)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hi Russell,

I attached the update one.

From: ext Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH 3/6] omap iommu: omap3 iommu device registration
Date: Sat, 17 Jan 2009 17:21:39 +0100

> On Fri, Jan 16, 2009 at 10:37:20AM +0200, Hiroshi DOYU wrote:
> > +#include <linux/io.h>
> 
> Is linux/io.h needed, or will a more specific include be better?
> 
> > +#include <linux/platform_device.h>
> > +
> > +#include <mach/iommu.h>
> > +
> > +#define DEVNAME "omap-iommu"
> 
> I'm not sure this DEVNAME definition really helps anything.
> 
> > +static void omap3_iommu_release(struct device *dev)
> > +{
> > +}
> 
> Err, no.  Never ever ever provide a NULL release function.  Providing
> such a function is a screaming message that what you're doing is buggy.
> 
> And if you get a warning through not providing such a function, it's
> telling you that what your overall approach with the driver API is
> buggy (and you haven't understood the implications of refcounted
> object management.)
> 
> > +
> > +static struct platform_device omap3_iommu_pdev[] = {
> > +	{
> > +		.name		= DEVNAME,
> > +		.id		= 1,
> > +		.num_resources	= ARRAY_SIZE(iommu1_res),
> > +		.resource	= iommu1_res,
> > +		.dev		= {
> > +			.release = omap3_iommu_release,
> > +			.platform_data = &omap3_iommu_pdata[0],
> > +		},
> > +	},
> > +	{
> > +		.name		= DEVNAME,
> > +		.id		= 2,
> > +		.num_resources	= ARRAY_SIZE(iommu2_res),
> > +		.resource	= iommu2_res,
> > +		.dev		= {
> > +			.release = omap3_iommu_release,
> > +			.platform_data = &omap3_iommu_pdata[1],
> > +		},
> > +	},
> > +};
> > +
> > +static int __init omap3_iommu_init(void)
> > +{
> > +	int i;
> > +	for (i = 0; i < ARRAY_SIZE(omap3_iommu_pdev); i++)
> > +		platform_device_register(&omap3_iommu_pdev[i]);
> > +	return 0;
> > +}
> > +module_init(omap3_iommu_init);
> > +
> > +static void __exit omap3_iommu_exit(void)
> > +{
> > +	int i;
> > +	for (i = 0; i < ARRAY_SIZE(omap3_iommu_pdev); i++)
> > +		platform_device_unregister(&omap3_iommu_pdev[i]);
> 
> So... this can never be bug free - you can _never_ unregister statically
> allocated devices.  Not even if you provide an empty release function.
> 
> If you want to register and unregister device structures, it must be
> done using the correct APIs, and in the case of platform devices, that's
> the platform_device_alloc(), platform_device_add() and
> platform_device_unregister() APIs.

----Next_Part(Tue_Jan_27_23_29_35_2009_013)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0003-omap-iommu-omap3-iommu-device-registration.patch"

>From 5b61d40f516d7df3a597df5bd798cb06df01fb28 Mon Sep 17 00:00:00 2001
From: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Date: Tue, 27 Jan 2009 22:46:36 +0200
Subject: [PATCH 3/6] omap iommu: omap3 iommu device registration

Signed-off-by: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
---
 arch/arm/mach-omap2/omap3-iommu.c |  103 +++++++++++++++++++++++++++++++++++++
 1 files changed, 103 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-omap2/omap3-iommu.c

diff --git a/arch/arm/mach-omap2/omap3-iommu.c b/arch/arm/mach-omap2/omap3-iommu.c
new file mode 100644
index 0000000..4f51c18
--- /dev/null
+++ b/arch/arm/mach-omap2/omap3-iommu.c
@@ -0,0 +1,103 @@
+/*
+ * omap iommu: omap3 device registration
+ *
+ * Copyright (C) 2008-2009 Nokia Corporation
+ *
+ * Written by Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/platform_device.h>
+#include <asm/io.h>
+#include <mach/iommu.h>
+
+#define OMAP3_MMU1_BASE	0x480bd400
+#define OMAP3_MMU2_BASE	0x5d000000
+#define OMAP3_MMU1_IRQ	24
+#define OMAP3_MMU2_IRQ	28
+
+static struct resource omap3_iommu_res[] = {
+	{ /* Camera ISP MMU */
+		.start		= OMAP3_MMU1_BASE,
+		.end		= OMAP3_MMU1_BASE + MMU_REG_SIZE - 1,
+		.flags		= IORESOURCE_MEM,
+	},
+	{
+		.start		= OMAP3_MMU1_IRQ,
+		.flags		= IORESOURCE_IRQ,
+	},
+	{ /* IVA2.2 MMU */
+		.start		= OMAP3_MMU2_BASE,
+		.end		= OMAP3_MMU2_BASE + MMU_REG_SIZE - 1,
+		.flags		= IORESOURCE_MEM,
+	},
+	{
+		.start		= OMAP3_MMU2_IRQ,
+		.flags		= IORESOURCE_IRQ,
+	},
+};
+#define NR_IOMMU_RES (ARRAY_SIZE(omap3_iommu_res) / 2)
+
+static const struct iommu_platform_data omap3_iommu_pdata[] __initconst = {
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
+#define NR_IOMMU_DEVICES ARRAY_SIZE(omap3_iommu_pdata)
+
+static struct platform_device *omap3_iommu_pdev[NR_IOMMU_DEVICES];
+
+static int __init omap3_iommu_init(void)
+{
+	int i, err;
+
+	for (i = 0; i < NR_IOMMU_DEVICES; i++) {
+		struct platform_device *pdev;
+
+		pdev = platform_device_alloc("omap-iommu", i + 1);
+		if (!pdev)
+			goto err_out;
+		err = platform_device_add_resources(pdev,
+				    &omap3_iommu_res[2 * i], NR_IOMMU_RES);
+		if (err)
+			goto err_out;
+		err = platform_device_add_data(pdev, &omap3_iommu_pdata[i],
+					       sizeof(omap3_iommu_pdata[0]));
+		if (err)
+			goto err_out;
+		err = platform_device_add(pdev);
+		if (err)
+			goto err_out;
+		omap3_iommu_pdev[i] = pdev;
+	}
+	return 0;
+
+err_out:
+	while (i--)
+		platform_device_put(omap3_iommu_pdev[i]);
+	return err;
+}
+module_init(omap3_iommu_init);
+
+static void __exit omap3_iommu_exit(void)
+{
+	int i;
+
+	for (i = 0; i < NR_IOMMU_DEVICES; i++)
+		platform_device_unregister(omap3_iommu_pdev[i]);
+}
+module_exit(omap3_iommu_exit);
+
+MODULE_AUTHOR("Hiroshi DOYU");
+MODULE_DESCRIPTION("omap iommu: omap3 device registration");
+MODULE_LICENSE("GPL v2");
-- 
1.6.1.rc4


----Next_Part(Tue_Jan_27_23_29_35_2009_013)----
