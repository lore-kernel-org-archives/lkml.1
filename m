Return-Path: <linux-kernel-owner+w=401wt.eu-S1757647AbYA3KC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757647AbYA3KC6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 05:02:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752166AbYA3KCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 05:02:50 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:59809 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbYA3KCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 05:02:48 -0500
X-IronPort-AV: E=Sophos;i="4.25,276,1199682000"; 
   d="scan'208";a="61206230"
From: Bryan Wu <bryan.wu@analog.com>
To: dwmw2@infradead.org, linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Bryan Wu <bryan.wu@analog.com>,
       Mike Frysinger <michael.frysinger@analog.com>
Subject: [PATCH 1/1] [MTD/MAPS] Blackfin BF5xx Maps: Handle the case where flash memory and ethernet mac/phy are mapped onto the same async bank
Date: Wed, 30 Jan 2008 18:02:44 +0800
Message-Id: <1201687364-32178-1-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BF533-STAMP does this for example.
All board-specific configuration goes in your board resources file.

Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/mtd/maps/Kconfig       |   45 ++++++++
 drivers/mtd/maps/Makefile      |    1 +
 drivers/mtd/maps/bf5xx-flash.c |  227 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 273 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mtd/maps/bf5xx-flash.c

diff --git a/drivers/mtd/maps/Kconfig b/drivers/mtd/maps/Kconfig
index a592fc0..5357f04 100644
--- a/drivers/mtd/maps/Kconfig
+++ b/drivers/mtd/maps/Kconfig
@@ -528,6 +528,51 @@ config MTD_PCMCIA_ANONYMOUS
 
 	  If unsure, say N.
 
+config MTD_BF5xx
+	tristate "Blackfin BF533-STAMP Flash Chip Support"
+	depends on BFIN533_STAMP && MTD_CFI
+	select MTD_PARTITIONS
+	help
+	  Map driver which allows for simultaneous utilization of
+	  ethernet and CFI parallel flash.
+
+config BFIN_FLASH_BANK_0
+	hex "EBIU_AMBCTL For Flash (Bank 0)"
+	depends on MTD_BF5xx
+	default 0x7BB0
+	help
+	  For boards that share the async memory bank with both Flash and
+	  the Ethernet, these settings allow you to have EBIU settings just
+	  when the Flash is active.  The other EBIU settings in the main
+	  Blackfin menu will be utilized when the Flash is not active.
+config BFIN_FLASH_BANK_1
+	hex "EBIU_AMBCTL For Flash (Bank 1)"
+	depends on MTD_BF5xx
+	default 0x7BB0
+	help
+	  For boards that share the async memory bank with both Flash and
+	  the Ethernet, these settings allow you to have EBIU settings just
+	  when the Flash is active.  The other EBIU settings in the main
+	  Blackfin menu will be utilized when the Flash is not active.
+config BFIN_FLASH_BANK_2
+	hex "EBIU_AMBCTL For Flash (Bank 2)"
+	depends on MTD_BF5xx
+	default 0x7BB0
+	help
+	  For boards that share the async memory bank with both Flash and
+	  the Ethernet, these settings allow you to have EBIU settings just
+	  when the Flash is active.  The other EBIU settings in the main
+	  Blackfin menu will be utilized when the Flash is not active.
+config BFIN_FLASH_BANK_3
+	hex "EBIU_AMBCTL For Flash (Bank 3)"
+	depends on MTD_BF5xx
+	default 0x7BB0
+	help
+	  For boards that share the async memory bank with both Flash and
+	  the Ethernet, these settings allow you to have EBIU settings just
+	  when the Flash is active.  The other EBIU settings in the main
+	  Blackfin menu will be utilized when the Flash is not active.
+
 config MTD_UCLINUX
 	tristate "Generic uClinux RAM/ROM filesystem support"
 	depends on MTD_PARTITIONS && !MMU
diff --git a/drivers/mtd/maps/Makefile b/drivers/mtd/maps/Makefile
index 316382a..62eea4f 100644
--- a/drivers/mtd/maps/Makefile
+++ b/drivers/mtd/maps/Makefile
@@ -69,3 +69,4 @@ obj-$(CONFIG_MTD_PLATRAM)	+= plat-ram.o
 obj-$(CONFIG_MTD_OMAP_NOR)	+= omap_nor.o
 obj-$(CONFIG_MTD_MTX1)		+= mtx-1_flash.o
 obj-$(CONFIG_MTD_INTEL_VR_NOR)	+= intel_vr_nor.o
+obj-$(CONFIG_MTD_BF5xx)		+= bf5xx-flash.o
diff --git a/drivers/mtd/maps/bf5xx-flash.c b/drivers/mtd/maps/bf5xx-flash.c
new file mode 100644
index 0000000..8c2f897
--- /dev/null
+++ b/drivers/mtd/maps/bf5xx-flash.c
@@ -0,0 +1,227 @@
+/*
+ * drivers/mtd/maps/bf5xx-flash.c
+ *
+ * Handle the case where flash memory and ethernet mac/phy are
+ * mapped onto the same async bank.  The BF533-STAMP does this
+ * for example.  All board-specific configuration goes in your
+ * board resources file.
+ *
+ * Copyright 2000 Nicolas Pitre <nico@cam.org>
+ * Copyright 2005-2008 Analog Devices Inc.
+ *
+ * Enter bugs at http://blackfin.uclinux.org/
+ *
+ * Licensed under the GPL-2 or later.
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/map.h>
+#include <linux/mtd/partitions.h>
+#include <linux/mtd/physmap.h>
+#include <linux/platform_device.h>
+#include <linux/types.h>
+
+#include <asm/blackfin.h>
+#include <asm/gpio.h>
+#include <asm/io.h>
+#include <asm/unaligned.h>
+
+#define pr_init(fmt, args...) ({ static const __initdata char __fmt[] = fmt; printk(__fmt, ## args); })
+
+#define DRIVER_NAME "BF5xx-Flash"
+
+#define BFIN_FLASH_AMBCTL0VAL	((CONFIG_BFIN_FLASH_BANK_1 << 16) | CONFIG_BFIN_FLASH_BANK_0)
+#define BFIN_FLASH_AMBCTL1VAL	((CONFIG_BFIN_FLASH_BANK_3 << 16) | CONFIG_BFIN_FLASH_BANK_2)
+
+/* Should add a per-device structure and track this there ... */
+static int enet_flash_pin;
+static struct mtd_info *bf5xx_mtd;
+
+struct flash_save {
+	u32 ambctl0;
+	u32 ambctl1;
+	unsigned long flags;
+};
+
+static void switch_to_flash(struct flash_save *save)
+{
+	local_irq_save(save->flags);
+
+	gpio_set_value(enet_flash_pin, 0);
+	SSYNC();
+
+	save->ambctl0 = bfin_read_EBIU_AMBCTL0();
+	save->ambctl1 = bfin_read_EBIU_AMBCTL1();
+	bfin_write_EBIU_AMBCTL0(BFIN_FLASH_AMBCTL0VAL);
+	bfin_write_EBIU_AMBCTL1(BFIN_FLASH_AMBCTL1VAL);
+	SSYNC();
+}
+
+static void switch_back(struct flash_save *save)
+{
+	bfin_write_EBIU_AMBCTL0(save->ambctl0);
+	bfin_write_EBIU_AMBCTL1(save->ambctl1);
+	SSYNC();
+
+	gpio_set_value(enet_flash_pin, 1);
+
+	local_irq_restore(save->flags);
+}
+
+static map_word bf5xx_read(struct map_info *map, unsigned long ofs)
+{
+	int nValue = 0x0;
+	map_word test;
+	struct flash_save save;
+
+	switch_to_flash(&save);
+	SSYNC();
+	nValue = readw(map->virt + ofs);
+	SSYNC();
+	switch_back(&save);
+
+	test.x[0] = (u16)nValue;
+	return test;
+}
+
+static void bf5xx_copy_from(struct map_info *map, void *to, unsigned long from, ssize_t len)
+{
+	unsigned long i;
+	map_word test;
+
+	if ((unsigned long)to & 0x1) {
+		for (i = 0; i < len / 2 * 2; i += 2) {
+			test = bf5xx_read(map, from + i);
+			put_unaligned(test.x[0], (__le16 *)(to + i));
+		}
+	} else {
+		for (i = 0; i < len / 2 * 2; i += 2) {
+			test = bf5xx_read(map, from + i);
+			*((u16*)(to + i)) = test.x[0];
+		}
+	}
+
+	if (len & 0x1) {
+		test = bf5xx_read(map, from + i);
+		*((u8*)(to + i)) = (u8)test.x[0];
+	}
+}
+
+static void bf5xx_write(struct map_info *map, map_word d1, unsigned long ofs)
+{
+	u16 d;
+	struct flash_save save;
+
+	d = (u16)d1.x[0];
+
+	switch_to_flash(&save);
+
+	SSYNC();
+	writew(d, map->virt + ofs);
+	SSYNC();
+
+	switch_back(&save);
+}
+
+static void bf5xx_copy_to(struct map_info *map, unsigned long to, const void *from, ssize_t len)
+{
+	struct flash_save save;
+
+	switch_to_flash(&save);
+
+	memcpy(map->virt + to, from, len);
+
+	switch_back(&save);
+}
+
+static struct map_info bf5xx_map = {
+	.name      = DRIVER_NAME,
+	.read      = bf5xx_read,
+	.copy_from = bf5xx_copy_from,
+	.write     = bf5xx_write,
+	.copy_to   = bf5xx_copy_to,
+};
+
+#ifdef CONFIG_MTD_PARTITIONS
+static const char *part_probe_types[] = { "cmdlinepart", "RedBoot", NULL };
+#endif
+
+static int __init bf5xx_flash_probe(struct platform_device *dev)
+{
+	int ret;
+	struct physmap_flash_data *pdata = dev->dev.platform_data;
+	struct resource *memory = platform_get_resource(dev, IORESOURCE_MEM, 0);
+
+	enet_flash_pin = platform_get_irq(dev, 0);
+
+	bf5xx_map.bankwidth = pdata->width;
+	bf5xx_map.size = memory->end - memory->start + 1;
+	bf5xx_map.virt = (void __iomem *)memory->start;
+	bf5xx_map.phys = memory->start;
+
+	if (gpio_request(enet_flash_pin, DRIVER_NAME)) {
+		pr_init(KERN_ERR DRIVER_NAME ": Failed to request gpio %d\n", enet_flash_pin);
+		return -EBUSY;
+	}
+	gpio_direction_output(enet_flash_pin, 1);
+
+	pr_init(KERN_NOTICE DRIVER_NAME ": probing %d-bit flash bus\n", bf5xx_map.bankwidth * 8);
+	bf5xx_mtd = do_map_probe(memory->name, &bf5xx_map);
+	if (!bf5xx_mtd)
+		return -ENXIO;
+
+#ifdef CONFIG_MTD_PARTITIONS
+	ret = parse_mtd_partitions(bf5xx_mtd, part_probe_types, &pdata->parts, 0);
+	if (ret > 0) {
+		pr_init(KERN_NOTICE DRIVER_NAME ": Using commandline partition definition\n");
+		add_mtd_partitions(bf5xx_mtd, pdata->parts, ret);
+
+	} else if (pdata->nr_parts) {
+		pr_init(KERN_NOTICE DRIVER_NAME ": Using board partition definition\n");
+		add_mtd_partitions(bf5xx_mtd, pdata->parts, pdata->nr_parts);
+
+	} else
+#endif
+	{
+		pr_init(KERN_NOTICE DRIVER_NAME ": no partition info available, registering whole flash at once\n");
+		add_mtd_device(bf5xx_mtd);
+	}
+
+	return 0;
+}
+
+static int __devexit bf5xx_flash_remove(struct platform_device *dev)
+{
+	gpio_free(enet_flash_pin);
+#ifdef CONFIG_MTD_PARTITIONS
+	del_mtd_partitions(bf5xx_mtd);
+#endif
+	map_destroy(bf5xx_mtd);
+	return 0;
+}
+
+static struct platform_driver bf5xx_flash_driver = {
+	.probe		= bf5xx_flash_probe,
+	.remove		= __devexit_p(bf5xx_flash_remove),
+	.driver		= {
+		.name	= DRIVER_NAME,
+	},
+};
+
+static int __init bf5xx_flash_init(void)
+{
+	return platform_driver_register(&bf5xx_flash_driver);
+}
+module_init(bf5xx_flash_init);
+
+static void __exit bf5xx_flash_exit(void)
+{
+	platform_driver_unregister(&bf5xx_flash_driver);
+}
+module_exit(bf5xx_flash_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("MTD map driver for Blackfins with flash/ethernet on same async bank");
-- 
1.5.3.4
