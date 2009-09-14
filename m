Return-Path: <linux-kernel-owner+w=401wt.eu-S933786AbZINUNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933786AbZINUNu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:13:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933530AbZINUI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:08:59 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54117 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933573AbZINUIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:08:50 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Barry Song <barry.song@analog.com>
Subject: [PATCH 44/72] Blackfin: bf538-ezkit: add resources for parallel flash
Date: Mon, 14 Sep 2009 16:07:48 -0400
Message-Id: <1252958896-25150-45-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Barry Song <barry.song@analog.com>

The board has some parallel flash hooked up to the async banks, so add
appropriate physmap resources for it.

Signed-off-by: Barry Song <barry.song@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mach-bf538/boards/ezkit.c |   49 +++++++++++++++++++++++++++++++
 1 files changed, 49 insertions(+), 0 deletions(-)

diff --git a/arch/blackfin/mach-bf538/boards/ezkit.c b/arch/blackfin/mach-bf538/boards/ezkit.c
index 42297fa..9113f60 100644
--- a/arch/blackfin/mach-bf538/boards/ezkit.c
+++ b/arch/blackfin/mach-bf538/boards/ezkit.c
@@ -31,6 +31,7 @@
 #include <linux/device.h>
 #include <linux/platform_device.h>
 #include <linux/mtd/mtd.h>
+#include <linux/mtd/physmap.h>
 #include <linux/mtd/partitions.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/flash.h>
@@ -561,6 +562,50 @@ static struct platform_device bfin_dpmc = {
 	},
 };
 
+#if defined(CONFIG_MTD_PHYSMAP) || defined(CONFIG_MTD_PHYSMAP_MODULE)
+static struct mtd_partition ezkit_partitions[] = {
+	{
+		.name       = "bootloader(nor)",
+		.size       = 0x40000,
+		.offset     = 0,
+	}, {
+		.name       = "linux kernel(nor)",
+		.size       = 0x180000,
+		.offset     = MTDPART_OFS_APPEND,
+	}, {
+		.name       = "file system(nor)",
+		.size       = MTDPART_SIZ_FULL,
+		.offset     = MTDPART_OFS_APPEND,
+	}
+};
+
+static struct physmap_flash_data ezkit_flash_data = {
+	.width      = 2,
+	.parts      = ezkit_partitions,
+	.nr_parts   = ARRAY_SIZE(ezkit_partitions),
+};
+
+static struct resource ezkit_flash_resource = {
+	.start = 0x20000000,
+#if defined(CONFIG_SMC91X) || defined(CONFIG_SMC91X_MODULE)
+	.end   = 0x202fffff,
+#else
+	.end   = 0x203fffff,
+#endif
+	.flags = IORESOURCE_MEM,
+};
+
+static struct platform_device ezkit_flash_device = {
+	.name          = "physmap-flash",
+	.id            = 0,
+	.dev = {
+		.platform_data = &ezkit_flash_data,
+	},
+	.num_resources = 1,
+	.resource      = &ezkit_flash_resource,
+};
+#endif
+
 static struct platform_device *cm_bf538_devices[] __initdata = {
 
 	&bfin_dpmc,
@@ -609,6 +654,10 @@ static struct platform_device *cm_bf538_devices[] __initdata = {
 #endif
 
 	&bfin_gpios_device,
+
+#if defined(CONFIG_MTD_PHYSMAP) || defined(CONFIG_MTD_PHYSMAP_MODULE)
+	&ezkit_flash_device,
+#endif
 };
 
 static int __init ezkit_init(void)
-- 
1.6.4.2

