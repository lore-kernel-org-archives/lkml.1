Return-Path: <linux-kernel-owner+w=401wt.eu-S1754776AbYKGAfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbYKGAfj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 19:35:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753357AbYKGAfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 19:35:30 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:63656 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864AbYKGAf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 19:35:29 -0500
Subject: arm: struct device - replace bus_id with dev_name(), dev_set_name()
From: Kay Sievers <kay.sievers@vrfy.org>
To: Russell King <rmk@arm.linux.org.uk>
Cc: Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 07 Nov 2008 01:35:26 +0100
Message-Id: <1226018126.3189.6.camel@nga>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(I did not compile or test it, please let me know, or help fixing
 it, if something is wrong with the conversion)

This patch is part of a larger patch series which will remove
the "char bus_id[20]" name string from struct device. The device
name is managed in the kobject anyway, and without any size
limitation, and just needlessly copied into "struct device".

To set and read the device name dev_name(dev) and dev_set_name(dev)
must be used. If your code uses static kobjects, which it shouldn't
do, "const char *init_name" can be used to statically provide the
name the registered device should have. At registration time, the
init_name field is cleared, to enforce the use of dev_name(dev) to
access the device name at a later time.

We need to get rid of all occurrences of bus_id in the entire tree
to be able to enable the new interface. Please apply this patch,
and possibly convert any remaining remaining occurrences of bus_id.

We want to submit a patch to -next, which will remove bus_id from
"struct device", to find the remaining pieces to convert, and finally
switch over to the new api, which will remove the 20 bytes array
and does no longer have a size limitation.

Thanks,
Kay


From: Kay Sievers <kay.sievers@vrfy.org>
Subject: arm: struct device - replace bus_id with dev_name(), dev_set_name()

Cc: Russell King <rmk@arm.linux.org.uk>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 arch/arm/kernel/ecard.c                  |    2 +-
 arch/arm/mach-aaec2000/core.c            |    2 +-
 arch/arm/mach-ep93xx/core.c              |    6 +++---
 arch/arm/mach-integrator/core.c          |   10 +++++-----
 arch/arm/mach-integrator/integrator_cp.c |    6 +++---
 arch/arm/mach-lh7a40x/clcd.c             |    2 +-
 arch/arm/mach-netx/fb.c                  |    2 +-
 arch/arm/mach-realview/core.h            |    2 +-
 arch/arm/mach-versatile/core.h           |    2 +-
 arch/arm/plat-omap/include/mach/memory.h |    2 +-
 10 files changed, 16 insertions(+), 16 deletions(-)

--- a/arch/arm/kernel/ecard.c
+++ b/arch/arm/kernel/ecard.c
@@ -817,7 +817,7 @@ static struct expansion_card *__init eca
 	ec->dma = NO_DMA;
 	ec->ops = &ecard_default_ops;
 
-	snprintf(ec->dev.bus_id, sizeof(ec->dev.bus_id), "ecard%d", slot);
+	dev_set_name(&ec->dev, "ecard%d", slot);
 	ec->dev.parent = NULL;
 	ec->dev.bus = &ecard_bus_type;
 	ec->dev.dma_mask = &ec->dma_mask;
--- a/arch/arm/mach-aaec2000/core.c
+++ b/arch/arm/mach-aaec2000/core.c
@@ -212,7 +212,7 @@ static struct clcd_board clcd_plat_data
 
 static struct amba_device clcd_device = {
 	.dev		= {
-		.bus_id			= "mb:16",
+		.init_name		= "mb:16",
 		.coherent_dma_mask	= ~0,
 		.platform_data		= &clcd_plat_data,
 	},
--- a/arch/arm/mach-ep93xx/core.c
+++ b/arch/arm/mach-ep93xx/core.c
@@ -389,7 +389,7 @@ static struct amba_pl010_data ep93xx_uar
 
 static struct amba_device uart1_device = {
 	.dev		= {
-		.bus_id		= "apb:uart1",
+		.init_name	= "apb:uart1",
 		.platform_data	= &ep93xx_uart_data,
 	},
 	.res		= {
@@ -403,7 +403,7 @@ static struct amba_device uart1_device =
 
 static struct amba_device uart2_device = {
 	.dev		= {
-		.bus_id		= "apb:uart2",
+		.init_name	= "apb:uart2",
 		.platform_data	= &ep93xx_uart_data,
 	},
 	.res		= {
@@ -417,7 +417,7 @@ static struct amba_device uart2_device =
 
 static struct amba_device uart3_device = {
 	.dev		= {
-		.bus_id		= "apb:uart3",
+		.init_name	= "apb:uart3",
 		.platform_data	= &ep93xx_uart_data,
 	},
 	.res		= {
--- a/arch/arm/mach-integrator/core.c
+++ b/arch/arm/mach-integrator/core.c
@@ -35,7 +35,7 @@ static struct amba_pl010_data integrator
 
 static struct amba_device rtc_device = {
 	.dev		= {
-		.bus_id	= "mb:15",
+		.init_name = "mb:15",
 	},
 	.res		= {
 		.start	= INTEGRATOR_RTC_BASE,
@@ -48,7 +48,7 @@ static struct amba_device rtc_device = {
 
 static struct amba_device uart0_device = {
 	.dev		= {
-		.bus_id	= "mb:16",
+		.init_name = "mb:16",
 		.platform_data = &integrator_uart_data,
 	},
 	.res		= {
@@ -62,7 +62,7 @@ static struct amba_device uart0_device =
 
 static struct amba_device uart1_device = {
 	.dev		= {
-		.bus_id	= "mb:17",
+		.init_name = "mb:17",
 		.platform_data = &integrator_uart_data,
 	},
 	.res		= {
@@ -76,7 +76,7 @@ static struct amba_device uart1_device =
 
 static struct amba_device kmi0_device = {
 	.dev		= {
-		.bus_id	= "mb:18",
+		.init_name = "mb:18",
 	},
 	.res		= {
 		.start	= KMI0_BASE,
@@ -89,7 +89,7 @@ static struct amba_device kmi0_device =
 
 static struct amba_device kmi1_device = {
 	.dev		= {
-		.bus_id	= "mb:19",
+		.init_name = "mb:19",
 	},
 	.res		= {
 		.start	= KMI1_BASE,
--- a/arch/arm/mach-integrator/integrator_cp.c
+++ b/arch/arm/mach-integrator/integrator_cp.c
@@ -405,7 +405,7 @@ static struct mmc_platform_data mmc_data
 
 static struct amba_device mmc_device = {
 	.dev		= {
-		.bus_id	= "mb:1c",
+		.init_name = "mb:1c",
 		.platform_data = &mmc_data,
 	},
 	.res		= {
@@ -419,7 +419,7 @@ static struct amba_device mmc_device = {
 
 static struct amba_device aaci_device = {
 	.dev		= {
-		.bus_id	= "mb:1d",
+		.init_name = "mb:1d",
 	},
 	.res		= {
 		.start	= INTCP_PA_AACI_BASE,
@@ -530,7 +530,7 @@ static struct clcd_board clcd_data = {
 
 static struct amba_device clcd_device = {
 	.dev		= {
-		.bus_id	= "mb:c0",
+		.init_name = "mb:c0",
 		.coherent_dma_mask = ~0,
 		.platform_data = &clcd_data,
 	},
--- a/arch/arm/mach-lh7a40x/clcd.c
+++ b/arch/arm/mach-lh7a40x/clcd.c
@@ -207,7 +207,7 @@ static struct clcd_board clcd_platform_d
 static struct amba_device name##_device = {			\
 	.dev = {						\
 		.coherent_dma_mask = ~0,			\
-		.bus_id	= busid,				\
+		.init_name = busid,				\
 		.platform_data = plat,				\
 		},						\
 	.res = {						\
--- a/arch/arm/mach-netx/fb.c
+++ b/arch/arm/mach-netx/fb.c
@@ -94,7 +94,7 @@ void clk_put(struct clk *clk)
 
 static struct amba_device fb_device = {
 	.dev		= {
-		.bus_id	= "fb",
+		.init_name = "fb",
 		.coherent_dma_mask = ~0,
 	},
 	.res		= {

--- a/arch/arm/mach-realview/core.h
+++ b/arch/arm/mach-realview/core.h
@@ -31,7 +31,7 @@
 static struct amba_device name##_device = {			\
 	.dev		= {					\
 		.coherent_dma_mask = ~0,			\
-		.bus_id	= busid,				\
+		.init_name = busid,				\
 		.platform_data = plat,				\
 	},							\
 	.res		= {					\
--- a/arch/arm/mach-versatile/core.h
+++ b/arch/arm/mach-versatile/core.h
@@ -34,7 +34,7 @@ extern unsigned int mmc_status(struct de
 static struct amba_device name##_device = {			\
 	.dev		= {					\
 		.coherent_dma_mask = ~0,			\
-		.bus_id	= busid,				\
+		.init_name = busid,				\
 		.platform_data = plat,				\
 	},							\
 	.res		= {					\
--- a/arch/arm/plat-omap/include/mach/memory.h
+++ b/arch/arm/plat-omap/include/mach/memory.h
@@ -70,7 +70,7 @@
 
 #define virt_to_lbus(x)		((x) - PAGE_OFFSET + OMAP1510_LB_OFFSET)
 #define lbus_to_virt(x)		((x) - OMAP1510_LB_OFFSET + PAGE_OFFSET)
-#define is_lbus_device(dev)	(cpu_is_omap15xx() && dev && (strncmp(dev->bus_id, "ohci", 4) == 0))
+#define is_lbus_device(dev)	(cpu_is_omap15xx() && dev && (strncmp(dev_name(dev), "ohci", 4) == 0))
 
 #define __arch_page_to_dma(dev, page)	({is_lbus_device(dev) ? \
 					(dma_addr_t)virt_to_lbus(page_address(page)) : \


