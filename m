Return-Path: <linux-kernel-owner+w=401wt.eu-S1759741AbXKNAV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759741AbXKNAV6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 19:21:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762476AbXKNATj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 19:19:39 -0500
Received: from mx1.redhat.com ([66.187.233.31]:51348 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762405AbXKNATh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 19:19:37 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 9/9] MN10300: Add MTD flash support for the ASB2303 board [try
	#6]
To: torvalds@osdl.org, akpm@linux-foundation.org, dwmw2@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-am33-list@redhat.com,
       dhowells@redhat.com
Date: Wed, 14 Nov 2007 00:19:18 +0000
Message-ID: <20071114001918.27662.45678.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071114001832.27662.8437.stgit@warthog.procyon.org.uk>
References: <20071114001832.27662.8437.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add MTD flash support for the ASB2303 board.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/configs/asb2303_defconfig |    1 
 drivers/mtd/chips/jedec_probe.c        |    2 
 drivers/mtd/maps/Kconfig               |    8 +
 drivers/mtd/maps/Makefile              |    1 
 drivers/mtd/maps/asb2303-flash.c       |  177 ++++++++++++++++++++++++++++++++
 5 files changed, 189 insertions(+), 0 deletions(-)

diff --git a/arch/mn10300/configs/asb2303_defconfig b/arch/mn10300/configs/asb2303_defconfig
index 7855257..75e2cd7 100644
--- a/arch/mn10300/configs/asb2303_defconfig
+++ b/arch/mn10300/configs/asb2303_defconfig
@@ -282,6 +282,7 @@ CONFIG_MTD_CFI_UTIL=y
 # CONFIG_MTD_COMPLEX_MAPPINGS is not set
 # CONFIG_MTD_PHYSMAP is not set
 # CONFIG_MTD_PLATRAM is not set
+CONFIG_MTD_ASB2303=y
 
 #
 # Self-contained MTD device drivers
diff --git a/drivers/mtd/chips/jedec_probe.c b/drivers/mtd/chips/jedec_probe.c
index 75fbdcf..a5330b7 100644
--- a/drivers/mtd/chips/jedec_probe.c
+++ b/drivers/mtd/chips/jedec_probe.c
@@ -1882,11 +1882,13 @@ static inline __u8 finfo_uaddr(const struct amd_flash_info *finfo, int device_ty
 
 	uaddr = finfo->uaddr[uaddr_idx];
 
+#ifndef CONFIG_MN10300_UNIT_ASB2303
 	if (uaddr != MTD_UADDR_NOT_SUPPORTED ) {
 		/* ASSERT("The unlock addresses for non-8-bit mode
 		   are bollocks. We don't really need an array."); */
 		uaddr = finfo->uaddr[0];
 	}
+#endif
 
  uaddr_done:
 	return uaddr;
diff --git a/drivers/mtd/maps/Kconfig b/drivers/mtd/maps/Kconfig
index a592fc0..37157de 100644
--- a/drivers/mtd/maps/Kconfig
+++ b/drivers/mtd/maps/Kconfig
@@ -597,5 +597,13 @@ config MTD_PLATRAM
 
 	  This selection automatically selects the map_ram driver.
 
+config MTD_ASB2303
+	tristate "CFI Flash device mapped on MEI ASB2303"
+	depends on MTD_CFI && MN10300_UNIT_ASB2303 && MTD_PARTITIONS
+	help
+	  This enables access to the flash chips on the ASB2303 board with
+	  the MN10300 processor.
+	  Say 'Y' if you have this board.
+
 endmenu
 
diff --git a/drivers/mtd/maps/Makefile b/drivers/mtd/maps/Makefile
index 316382a..6f28f35 100644
--- a/drivers/mtd/maps/Makefile
+++ b/drivers/mtd/maps/Makefile
@@ -69,3 +69,4 @@ obj-$(CONFIG_MTD_PLATRAM)	+= plat-ram.o
 obj-$(CONFIG_MTD_OMAP_NOR)	+= omap_nor.o
 obj-$(CONFIG_MTD_MTX1)		+= mtx-1_flash.o
 obj-$(CONFIG_MTD_INTEL_VR_NOR)	+= intel_vr_nor.o
+obj-$(CONFIG_MTD_ASB2303)	+= asb2303-flash.o
diff --git a/drivers/mtd/maps/asb2303-flash.c b/drivers/mtd/maps/asb2303-flash.c
new file mode 100644
index 0000000..9962948
--- /dev/null
+++ b/drivers/mtd/maps/asb2303-flash.c
@@ -0,0 +1,177 @@
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
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/dma-mapping.h>
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/map.h>
+#include <linux/mtd/partitions.h>
+#include <asm/io.h>
+
+#define PROM_ADDR	0xA0000000
+#define FLASH_ADDR	0xA4000000
+#define CONFIG_ADDR	0xA6000000
+
+static struct map_info asb2303_maps[2] = {
+	{
+		.name		= "BootPROM",
+		.size		= 2 * 1024 * 1024,
+		.bankwidth	= 2,
+		.phys		= PROM_ADDR,
+	}, {
+		.name		= "SysFlash",
+		.size		= 32 * 1024 * 1024,
+		.bankwidth	= 4,
+		.phys		= FLASH_ADDR,
+	}
+};
+
+static struct mtd_partition asb2303_partitions[] = {
+	{
+		.name		= "Bootloader",
+		.size		= 0x00040000,
+		.offset		= 0,
+		.mask_flags	= MTD_WRITEABLE  /* force read-only */
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
+static struct mtd_info *mymtds[3];
+static struct mtd_partition *parsed_parts[3];
+static int nr_parsed_parts[3];
+
+static const char *probes[] = { "RedBoot", "cmdlinepart", NULL };
+
+static int __init init_asb2303(void)
+{
+	int ret = 0, nr, i;
+
+	for (i = 0; i < ARRAY_SIZE(asb2303_maps); i++) {
+		printk(KERN_NOTICE
+		       "Probing ASB2303 %s device: %08lx at %08lx\n",
+		       asb2303_maps[i].name,
+		       asb2303_maps[i].size,
+		       (unsigned long) asb2303_maps[i].phys);
+
+		asb2303_maps[i].map_priv_1 = 0;
+		asb2303_maps[i].virt = ioremap(asb2303_maps[i].phys,
+					       asb2303_maps[i].size);
+		if (!asb2303_maps[i].virt) {
+			printk(KERN_WARNING
+			       "Failed to ioremap %s\n",
+			       asb2303_maps[i].name);
+
+			if (!ret)
+				ret = -ENOMEM;
+			continue;
+		}
+
+		simple_map_init(&asb2303_maps[i]);
+
+		printk(KERN_NOTICE
+		       "Probing %s at physical address 0x%08lx"
+		       " (%d-bit bankwidth)\n",
+		       asb2303_maps[i].name,
+		       (unsigned long) asb2303_maps[i].phys,
+		       asb2303_maps[i].bankwidth * 8);
+
+		mymtds[i] = do_map_probe("cfi_probe", &asb2303_maps[i]);
+		if (!mymtds[i])
+			mymtds[i] = do_map_probe("jedec_probe",
+						 &asb2303_maps[i]);
+
+		if (!mymtds[i]) {
+			iounmap((void *) asb2303_maps[i].virt);
+			if (asb2303_maps[i].cached)
+				iounmap(asb2303_maps[i].cached);
+			if (!ret)
+				ret = -EIO;
+			continue;
+		}
+
+		mymtds[i]->owner = THIS_MODULE;
+
+		nr = parse_mtd_partitions(mymtds[i], probes,
+					  &parsed_parts[i], 0);
+
+		if (nr > 0)
+			nr_parsed_parts[i] = nr;
+		else if (nr < 0)
+			ret = nr;
+	}
+
+	if (!mymtds[0] && !mymtds[1] && !mymtds[2])
+		return ret;
+
+	for (i = 0; i < ARRAY_SIZE(asb2303_maps); i++) {
+		if (!mymtds[i]) {
+			printk(KERN_WARNING
+			       "%s is absent. Skipping\n",
+			       asb2303_maps[i].name);
+		} else if (nr_parsed_parts[i]) {
+			add_mtd_partitions(mymtds[i],
+					   parsed_parts[i],
+					   nr_parsed_parts[i]);
+		} else if (!i) {
+			printk(KERN_INFO
+			       "Using static partitions on %s\n",
+			       asb2303_maps[i].name);
+			add_mtd_partitions(mymtds[i], asb2303_partitions,
+					   ARRAY_SIZE(asb2303_partitions));
+		} else {
+			printk(KERN_INFO
+			       "Registering %s as whole device\n",
+			       asb2303_maps[i].name);
+			add_mtd_device(mymtds[i]);
+		}
+	}
+
+	return 0;
+}
+
+static void __exit cleanup_asb2303(void)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(mymtds); i++) {
+		if (!mymtds[i])
+			continue;
+
+		if (nr_parsed_parts[i] || !i)
+			del_mtd_partitions(mymtds[i]);
+		else
+			del_mtd_device(mymtds[i]);
+
+		map_destroy(mymtds[i]);
+
+		iounmap((void *) asb2303_maps[i].virt);
+		if (asb2303_maps[i].cached)
+			iounmap(asb2303_maps[i].cached);
+
+		kfree(parsed_parts[i]);
+	}
+}
+
+module_init(init_asb2303);
+module_exit(cleanup_asb2303);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("David Howells <dhowells@redhat.com>");
+MODULE_DESCRIPTION("MTD map driver for MEI ASB2303");

