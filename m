Return-Path: <linux-kernel-owner+w=401wt.eu-S1762607AbXKPNlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762607AbXKPNlU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 08:41:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757243AbXKPNlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 08:41:12 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43766 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757218AbXKPNlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 08:41:10 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/2] MN10300: Add platform MTD support for the ASB2303 board
To: torvalds@osdl.org, akpm@linux-foundation.org, dwmw2@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-am33-list@redhat.com,
       dhowells@redhat.com
Date: Fri, 16 Nov 2007 13:41:00 +0000
Message-ID: <20071116134100.3823.12894.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add platform MTD support for the ASB2303 board.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/configs/asb2303_defconfig |    5 +-
 arch/mn10300/unit-asb2303/Makefile     |    2 -
 arch/mn10300/unit-asb2303/flash.c      |  100 ++++++++++++++++++++++++++++++++
 3 files changed, 105 insertions(+), 2 deletions(-)

diff --git a/arch/mn10300/configs/asb2303_defconfig b/arch/mn10300/configs/asb2303_defconfig
index 0189a05..ca9876a 100644
--- a/arch/mn10300/configs/asb2303_defconfig
+++ b/arch/mn10300/configs/asb2303_defconfig
@@ -282,7 +282,10 @@ CONFIG_MTD_CFI_UTIL=y
 # Mapping drivers for chip access
 #
 # CONFIG_MTD_COMPLEX_MAPPINGS is not set
-# CONFIG_MTD_PHYSMAP is not set
+CONFIG_MTD_PHYSMAP=y
+CONFIG_MTD_PHYSMAP_START=0x8000000
+CONFIG_MTD_PHYSMAP_LEN=0x0
+CONFIG_MTD_PHYSMAP_BANKWIDTH=2
 # CONFIG_MTD_PLATRAM is not set
 
 #
diff --git a/arch/mn10300/unit-asb2303/Makefile b/arch/mn10300/unit-asb2303/Makefile
index 03e579f..38a5bb4 100644
--- a/arch/mn10300/unit-asb2303/Makefile
+++ b/arch/mn10300/unit-asb2303/Makefile
@@ -3,4 +3,4 @@
 # Makefile for the ASB2303 board
 #
 ###############################################################################
-obj-y   := unit-init.o smc91111.o leds.o
+obj-y   := unit-init.o smc91111.o flash.o leds.o
diff --git a/arch/mn10300/unit-asb2303/flash.c b/arch/mn10300/unit-asb2303/flash.c
new file mode 100644
index 0000000..17fe083
--- /dev/null
+++ b/arch/mn10300/unit-asb2303/flash.c
@@ -0,0 +1,100 @@
+/* Handle mapping of the flash on the ASB2303 board
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/mtd/partitions.h>
+#include <linux/mtd/physmap.h>
+
+#define ASB2303_PROM_ADDR	0xA0000000	/* Boot PROM */
+#define ASB2303_PROM_SIZE	(2 * 1024 * 1024)
+#define ASB2303_FLASH_ADDR	0xA4000000	/* System Flash */
+#define ASB2303_FLASH_SIZE	(32 * 1024 * 1024)
+#define ASB2303_CONFIG_ADDR	0xA6000000	/* System Config EEPROM */
+#define ASB2303_CONFIG_SIZE	(8 * 1024)
+
+/*
+ * default MTD partition table for both main flash devices, expected to be
+ * overridden by RedBoot
+ */
+static struct mtd_partition asb2303_partitions[] = {
+	{
+		.name		= "Bootloader",
+		.size		= 0x00040000,
+		.offset		= 0,
+		.mask_flags	= MTD_CAP_ROM /* force read-only */
+	}, {
+		.name		= "Kernel",
+		.size		= 0x00400000,
+		.offset		= 0x00040000,
+	}, {
+		.name		= "Filesystem",
+		.size		= MTDPART_SIZ_FULL,
+		.offset		= 0x00440000
+	}
+};
+
+/*
+ * the ASB2303 Boot PROM definition
+ */
+static struct physmap_flash_data asb2303_bootprom_data = {
+	.width		= 2,
+	.nr_parts	= 1,
+	.parts		= asb2303_partitions,
+};
+
+static struct resource asb2303_bootprom_resource = {
+	.start		= ASB2303_PROM_ADDR,
+	.end		= ASB2303_PROM_ADDR + ASB2303_PROM_SIZE,
+	.flags		= IORESOURCE_MEM,
+};
+
+static struct platform_device asb2303_bootprom = {
+	.name		= "physmap-flash",
+	.id		= 0,
+	.dev.platform_data = &asb2303_bootprom_data,
+	.num_resources	= 1,
+	.resource	= &asb2303_bootprom_resource,
+};
+
+/*
+ * the ASB2303 System Flash definition
+ */
+static struct physmap_flash_data asb2303_sysflash_data = {
+	.width		= 4,
+	.nr_parts	= 1,
+	.parts		= asb2303_partitions,
+};
+
+static struct resource asb2303_sysflash_resource = {
+	.start		= ASB2303_FLASH_ADDR,
+	.end		= ASB2303_FLASH_ADDR + ASB2303_FLASH_SIZE,
+	.flags		= IORESOURCE_MEM,
+};
+
+static struct platform_device asb2303_sysflash = {
+	.name		= "physmap-flash",
+	.id		= 1,
+	.dev.platform_data = &asb2303_sysflash_data,
+	.num_resources	= 1,
+	.resource	= &asb2303_sysflash_resource,
+};
+
+/*
+ * register the ASB2303 flashes
+ */
+static int __init asb2303_mtd_init(void)
+{
+	platform_device_register(&asb2303_bootprom);
+	platform_device_register(&asb2303_sysflash);
+	return 0;
+}
+
+module_init(asb2303_mtd_init);

