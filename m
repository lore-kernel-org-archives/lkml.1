Return-Path: <linux-kernel-owner+w=401wt.eu-S1752555AbZIXONC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbZIXONC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 10:13:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751937AbZIXONB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 10:13:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38071 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751801AbZIXONA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 10:13:00 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] FRV: Flash mappings for the MB93090-MB00 motherboard
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Thu, 24 Sep 2009 15:12:00 +0100
Message-ID: <20090924141200.19699.81101.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Flash mappings for the MB93090-MB00 evaluation motherboard.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/frv/mb93090-mb00/Makefile |    2 +
 arch/frv/mb93090-mb00/flash.c  |   90 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 92 insertions(+), 0 deletions(-)
 create mode 100644 arch/frv/mb93090-mb00/flash.c


diff --git a/arch/frv/mb93090-mb00/Makefile b/arch/frv/mb93090-mb00/Makefile
index 76595e8..b73b542 100644
--- a/arch/frv/mb93090-mb00/Makefile
+++ b/arch/frv/mb93090-mb00/Makefile
@@ -11,3 +11,5 @@ else
 obj-y += pci-dma-nommu.o
 endif
 endif
+
+obj-$(CONFIG_MTD) += flash.o
diff --git a/arch/frv/mb93090-mb00/flash.c b/arch/frv/mb93090-mb00/flash.c
new file mode 100644
index 0000000..c0e3707
--- /dev/null
+++ b/arch/frv/mb93090-mb00/flash.c
@@ -0,0 +1,90 @@
+/* Flash mappings for the MB93090-MB00 motherboard
+ *
+ * Copyright (C) 2009 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/mtd/partitions.h>
+#include <linux/mtd/physmap.h>
+
+#define MB93090_BOOTROM_ADDR	0xFF000000	/* Boot ROM */
+#define MB93090_BOOTROM_SIZE	(2 * 1024 * 1024)
+#define MB93090_USERROM_ADDR	0xFF200000	/* User ROM */
+#define MB93090_USERROM_SIZE	(2 * 1024 * 1024)
+
+/*
+ * default MTD partition table for both main flash devices, expected to be
+ * overridden by RedBoot
+ */
+static struct mtd_partition mb93090_partitions[] = {
+	{
+		.name		= "Filesystem",
+		.size		= MTDPART_SIZ_FULL,
+		.offset		= 0,
+	}
+};
+
+/*
+ * Definition of the MB93090 Boot ROM (on the CPU card)
+ */
+static struct physmap_flash_data mb93090_bootrom_data = {
+	.width		= 2,
+	.nr_parts	= 2,
+	.parts		= mb93090_partitions,
+};
+
+static struct resource mb93090_bootrom_resource = {
+	.start		= MB93090_BOOTROM_ADDR,
+	.end		= MB93090_BOOTROM_ADDR + MB93090_BOOTROM_SIZE - 1,
+	.flags		= IORESOURCE_MEM,
+};
+
+static struct platform_device mb93090_bootrom = {
+	.name		= "physmap-flash",
+	.id		= 0,
+	.dev.platform_data = &mb93090_bootrom_data,
+	.num_resources	= 1,
+	.resource	= &mb93090_bootrom_resource,
+};
+
+/*
+ * Definition of the MB93090 User ROM definition (on the motherboard)
+ */
+static struct physmap_flash_data mb93090_userrom_data = {
+	.width		= 2,
+	.nr_parts	= 2,
+	.parts		= mb93090_partitions,
+};
+
+static struct resource mb93090_userrom_resource = {
+	.start		= MB93090_USERROM_ADDR,
+	.end		= MB93090_USERROM_ADDR + MB93090_USERROM_SIZE - 1,
+	.flags		= IORESOURCE_MEM,
+};
+
+static struct platform_device mb93090_userrom = {
+	.name		= "physmap-flash",
+	.id		= 1,
+	.dev.platform_data = &mb93090_userrom_data,
+	.num_resources	= 1,
+	.resource	= &mb93090_userrom_resource,
+};
+
+/*
+ * register the MB93090 flashes
+ */
+static int __init mb93090_mtd_init(void)
+{
+	platform_device_register(&mb93090_bootrom);
+	platform_device_register(&mb93090_userrom);
+	return 0;
+}
+
+module_init(mb93090_mtd_init);

