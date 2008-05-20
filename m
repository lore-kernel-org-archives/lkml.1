Return-Path: <linux-kernel-owner+w=401wt.eu-S1760795AbYETKw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760795AbYETKw6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 06:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764698AbYETKvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 06:51:47 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:14091 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764497AbYETKvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 06:51:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=eV69OlWjTUo/9b2/sC/xIkz1ooS0jRKSGxq3nt6GZzjh9YYJPkbMVQf22OE2rW0MTIBs1A31XD7AtUHC+o6Z+gBtEBQaBVkB45j97aoFi/rujNIj2aqUpJ20EU5F4ncZuh/6rm8eNcTqDY4AtG8s/qBSiggykTWN0y+bauZHH6M=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Magnus Damm <magnus.damm@gmail.com>, lethal@linux-sh.org,
       hjk@linutronix.de, gregkh@suse.de, linux-sh@vger.kernel.org
Date: Tue, 20 May 2008 19:51:57 +0900
Message-Id: <20080520105157.1474.29557.sendpatchset@rx1.opensource.se>
In-Reply-To: <20080520105132.1474.73941.sendpatchset@rx1.opensource.se>
References: <20080520105132.1474.73941.sendpatchset@rx1.opensource.se>
Subject: [PATCH 03/03] sh: Export sh7343/sh7722/sh7723 VPU/VEU blocks
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch exports the following SuperH hardware to user space:

sh7343: VPU
sh7722: VPU, VEU
sh7723: VPU, VEU, VEU

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 arch/sh/kernel/cpu/sh4a/setup-sh7343.c |   32 ++++++++++
 arch/sh/kernel/cpu/sh4a/setup-sh7722.c |   63 +++++++++++++++++++++
 arch/sh/kernel/cpu/sh4a/setup-sh7723.c |   94 ++++++++++++++++++++++++++++++++
 3 files changed, 189 insertions(+)

--- 0001/arch/sh/kernel/cpu/sh4a/setup-sh7343.c
+++ work/arch/sh/kernel/cpu/sh4a/setup-sh7343.c	2008-05-20 17:19:05.000000000 +0900
@@ -11,6 +11,37 @@
 #include <linux/init.h>
 #include <linux/serial.h>
 #include <linux/serial_sci.h>
+#include <linux/uio_platform.h>
+
+static struct uio_platform_info vpu_platform_data = {
+	.name = "VPU",
+	.version = "0.0.1",
+	.memsize = 1 << 20,
+};
+
+static struct resource vpu_resources[] = {
+	[0] = {
+		.name	= "VPU",
+		.start	= 0xfe900000,
+		.end	= 0xfe9022ec,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= 60,
+		.end	= 60,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device vpu_device = {
+	.name		= "uio-platform",
+	.id		= 0,
+	.dev = {
+		.platform_data	= &vpu_platform_data,
+	},
+	.resource	= vpu_resources,
+	.num_resources	= ARRAY_SIZE(vpu_resources),
+};
 
 static struct plat_sci_port sci_platform_data[] = {
 	{
@@ -33,6 +64,7 @@ static struct platform_device sci_device
 
 static struct platform_device *sh7343_devices[] __initdata = {
 	&sci_device,
+	&vpu_device,
 };
 
 static int __init sh7343_devices_setup(void)
--- 0001/arch/sh/kernel/cpu/sh4a/setup-sh7722.c
+++ work/arch/sh/kernel/cpu/sh4a/setup-sh7722.c	2008-05-20 17:19:05.000000000 +0900
@@ -12,6 +12,7 @@
 #include <linux/serial.h>
 #include <linux/serial_sci.h>
 #include <linux/mm.h>
+#include <linux/uio_platform.h>
 #include <asm/mmzone.h>
 
 static struct resource usbf_resources[] = {
@@ -59,6 +60,66 @@ static struct platform_device iic_device
 	.resource       = iic_resources,
 };
 
+static struct uio_platform_info veu_platform_data = {
+	.name = "VEU",
+	.version = "0.0.1",
+	.memsize = 2 << 20,
+};
+
+static struct resource veu_resources[] = {
+	[0] = {
+		.name	= "VEU",
+		.start	= 0xfe920000,
+		.end	= 0xfe9200b7,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= 54,
+		.end	= 54,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device veu_device = {
+	.name		= "uio-platform",
+	.id		= 0,
+	.dev = {
+		.platform_data	= &veu_platform_data,
+	},
+	.resource	= veu_resources,
+	.num_resources	= ARRAY_SIZE(veu_resources),
+};
+
+static struct uio_platform_info vpu_platform_data = {
+	.name = "VPU",
+	.version = "0.0.1",
+	.memsize = 1 << 20,
+};
+
+static struct resource vpu_resources[] = {
+	[0] = {
+		.name	= "VPU",
+		.start	= 0xfe900000,
+		.end	= 0xfe9022ec,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= 60,
+		.end	= 60,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device vpu_device = {
+	.name		= "uio-platform",
+	.id		= 1,
+	.dev = {
+		.platform_data	= &vpu_platform_data,
+	},
+	.resource	= vpu_resources,
+	.num_resources	= ARRAY_SIZE(vpu_resources),
+};
+
 static struct plat_sci_port sci_platform_data[] = {
 	{
 		.mapbase	= 0xffe00000,
@@ -94,6 +155,8 @@ static struct platform_device sci_device
 static struct platform_device *sh7722_devices[] __initdata = {
 	&usbf_device,
 	&iic_device,
+	&veu_device,
+	&vpu_device,
 	&sci_device,
 };
 
--- 0001/arch/sh/kernel/cpu/sh4a/setup-sh7723.c
+++ work/arch/sh/kernel/cpu/sh4a/setup-sh7723.c	2008-05-20 17:19:05.000000000 +0900
@@ -12,6 +12,7 @@
 #include <linux/serial.h>
 #include <linux/mm.h>
 #include <linux/serial_sci.h>
+#include <linux/uio_platform.h>
 #include <asm/mmzone.h>
 
 static struct plat_sci_port sci_platform_data[] = {
@@ -73,9 +74,102 @@ static struct platform_device rtc_device
 	.resource	= rtc_resources,
 };
 
+static struct uio_platform_info veu0_platform_data = {
+	.name = "VEU",
+	.version = "0.0.1",
+	.memsize = 2 << 20,
+};
+
+static struct resource veu0_resources[] = {
+	[0] = {
+		.name	= "VEU0",
+		.start	= 0xfe920000,
+		.end	= 0xfe92027c,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= 54,
+		.end	= 54,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device veu0_device = {
+	.name		= "uio-platform",
+	.id		= 0,
+	.dev = {
+		.platform_data	= &veu0_platform_data,
+	},
+	.resource	= veu0_resources,
+	.num_resources	= ARRAY_SIZE(veu0_resources),
+};
+
+static struct uio_platform_info veu1_platform_data = {
+	.name = "VEU",
+	.version = "0.0.1",
+	.memsize = 2 << 20,
+};
+
+static struct resource veu1_resources[] = {
+	[0] = {
+		.name	= "VEU1",
+		.start	= 0xfe924000,
+		.end	= 0xfe92427c,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= 27,
+		.end	= 27,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device veu1_device = {
+	.name		= "uio-platform",
+	.id		= 1,
+	.dev = {
+		.platform_data	= &veu1_platform_data,
+	},
+	.resource	= veu1_resources,
+	.num_resources	= ARRAY_SIZE(veu1_resources),
+};
+
+static struct uio_platform_info vpu_platform_data = {
+	.name = "VPU",
+	.version = "0.0.1",
+	.memsize = 1 << 20,
+};
+
+static struct resource vpu_resources[] = {
+	[0] = {
+		.name	= "VPU",
+		.start	= 0xfe900000,
+		.end	= 0xfe902808,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= 60,
+		.end	= 60,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device vpu_device = {
+	.name		= "uio-platform",
+	.id		= 2,
+	.dev = {
+		.platform_data	= &vpu_platform_data,
+	},
+	.resource	= vpu_resources,
+	.num_resources	= ARRAY_SIZE(vpu_resources),
+};
+
 static struct platform_device *sh7723_devices[] __initdata = {
 	&sci_device,
 	&rtc_device,
+	&vpu_device,
+	&veu0_device,
+	&veu1_device,
 };
 
 static int __init sh7723_devices_setup(void)
