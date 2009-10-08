Return-Path: <linux-kernel-owner+w=401wt.eu-S1754602AbZJHGFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602AbZJHGFk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 02:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753842AbZJHGFj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 02:05:39 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:34591 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754502AbZJHGFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 02:05:37 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 08/13] Blackfin: bf533-ezkit: convert to physmap/jedec_probe
Date: Thu,  8 Oct 2009 02:04:24 -0400
Message-Id: <1254981869-21586-9-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.rc2
In-Reply-To: <1254981869-21586-1-git-send-email-vapier@gentoo.org>
References: <1254981869-21586-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the common jedec_probe supports the ST PSD4256G6V, no need to
use the custom stm_flash driver.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mach-bf533/boards/ezkit.c |   66 +++++++++++++++++++------------
 1 files changed, 41 insertions(+), 25 deletions(-)

diff --git a/arch/blackfin/mach-bf533/boards/ezkit.c b/arch/blackfin/mach-bf533/boards/ezkit.c
index 9ffcd63..986fcdc 100644
--- a/arch/blackfin/mach-bf533/boards/ezkit.c
+++ b/arch/blackfin/mach-bf533/boards/ezkit.c
@@ -11,6 +11,7 @@
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/partitions.h>
 #include <linux/mtd/plat-ram.h>
+#include <linux/mtd/physmap.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/flash.h>
 #if defined(CONFIG_USB_ISP1362_HCD) || defined(CONFIG_USB_ISP1362_HCD_MODULE)
@@ -71,54 +72,69 @@ static struct platform_device smc91x_device = {
 };
 #endif
 
-#if defined(CONFIG_MTD_PSD4256G) || defined(CONFIG_MTD_PSD4256G_MODULE)
-static const char *map_probes[] = {
-	"stm_flash",
-	NULL,
+#if defined(CONFIG_MTD_PHYSMAP) || defined(CONFIG_MTD_PHYSMAP_MODULE)
+static struct mtd_partition ezkit_partitions_a[] = {
+	{
+		.name       = "bootloader(nor a)",
+		.size       = 0x40000,
+		.offset     = 0,
+	}, {
+		.name       = "linux kernel(nor a)",
+		.size       = MTDPART_SIZ_FULL,
+		.offset     = MTDPART_OFS_APPEND,
+	},
 };
 
-static struct platdata_mtd_ram stm_pri_data_a = {
-	.mapname    = "Flash A Primary",
-	.map_probes = map_probes,
-	.bankwidth  = 2,
+static struct physmap_flash_data ezkit_flash_data_a = {
+	.width      = 2,
+	.parts      = ezkit_partitions_a,
+	.nr_parts   = ARRAY_SIZE(ezkit_partitions_a),
 };
 
-static struct resource stm_pri_resource_a = {
+static struct resource ezkit_flash_resource_a = {
 	.start = 0x20000000,
 	.end   = 0x200fffff,
 	.flags = IORESOURCE_MEM,
 };
 
-static struct platform_device stm_pri_device_a = {
-	.name          = "mtd-ram",
+static struct platform_device ezkit_flash_device_a = {
+	.name          = "physmap-flash",
 	.id            = 0,
 	.dev = {
-		.platform_data = &stm_pri_data_a,
+		.platform_data = &ezkit_flash_data_a,
 	},
 	.num_resources = 1,
-	.resource      = &stm_pri_resource_a,
+	.resource      = &ezkit_flash_resource_a,
+};
+
+static struct mtd_partition ezkit_partitions_b[] = {
+	{
+		.name   = "file system(nor b)",
+		.size   = MTDPART_SIZ_FULL,
+		.offset = MTDPART_OFS_APPEND,
+	},
 };
 
-static struct platdata_mtd_ram stm_pri_data_b = {
-	.mapname    = "Flash B Primary",
-	.map_probes = map_probes,
-	.bankwidth  = 2,
+static struct physmap_flash_data ezkit_flash_data_b = {
+	.width      = 2,
+	.parts      = ezkit_partitions_b,
+	.nr_parts   = ARRAY_SIZE(ezkit_partitions_b),
 };
 
-static struct resource stm_pri_resource_b = {
+static struct resource ezkit_flash_resource_b = {
 	.start = 0x20100000,
 	.end   = 0x201fffff,
 	.flags = IORESOURCE_MEM,
 };
 
-static struct platform_device stm_pri_device_b = {
-	.name          = "mtd-ram",
+static struct platform_device ezkit_flash_device_b = {
+	.name          = "physmap-flash",
 	.id            = 4,
 	.dev = {
-		.platform_data = &stm_pri_data_b,
+		.platform_data = &ezkit_flash_data_b,
 	},
 	.num_resources = 1,
-	.resource      = &stm_pri_resource_b,
+	.resource      = &ezkit_flash_resource_b,
 };
 #endif
 
@@ -445,9 +461,9 @@ static struct platform_device *ezkit_devices[] __initdata = {
 
 	&bfin_dpmc,
 
-#if defined(CONFIG_MTD_PSD4256G) || defined(CONFIG_MTD_PSD4256G_MODULE)
-	&stm_pri_device_a,
-	&stm_pri_device_b,
+#if defined(CONFIG_MTD_PHYSMAP) || defined(CONFIG_MTD_PHYSMAP_MODULE)
+	&ezkit_flash_device_a,
+	&ezkit_flash_device_b,
 #endif
 
 #if defined(CONFIG_MTD_PLATRAM) || defined(CONFIG_MTD_PLATRAM_MODULE)
-- 
1.6.5.rc2

