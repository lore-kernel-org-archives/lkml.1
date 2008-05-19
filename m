Return-Path: <linux-kernel-owner+w=401wt.eu-S1754966AbYESKce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966AbYESKce (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 06:32:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755101AbYESKcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 06:32:25 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:28426 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755082AbYESKcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 06:32:23 -0400
X-IronPort-AV: E=Sophos;i="4.27,503,1204520400"; 
   d="scan'208";a="53751374"
From: Bryan Wu <cooloney@kernel.org>
To: joern@logfs.org, dwmw2@infradead.org
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 1/1] mtd maps - Blackfin Async Flash Maps (try #4): Handle the case where flash memory and ethernet mac/phy are mapped onto the same async bank
Date: Mon, 19 May 2008 18:32:24 +0800
Message-Id: <1211193144-7731-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

[try #4]
 - drop superfluous casts
 - drop SSYNC() when reading from the flash and rewrite
   bfin_copy_from() to be like bfin_copy_to() so that
   we dont have to handle all the aligned/unaligned cases

[try #3] rename bf5xx-flash to bfin-async-flash
 - move all kconfig board settings into board resources
 - fixup casting style according to lkml feedback
 - rewrite driver so that it can handle arbitrary of
   instances according to the declared platform resources

[try #2]
Remove useless SSYNC() as Will said

[try #1]
The BF533-STAMP does this for example.
All board-specific configuration goes in your board resources file.

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Cc: Joern Engel <joern@logfs.org>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/mtd/maps/Kconfig            |   11 ++
 drivers/mtd/maps/Makefile           |    1 +
 drivers/mtd/maps/bfin-async-flash.c |  219 +++++++++++++++++++++++++++++++++++
 3 files changed, 231 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mtd/maps/bfin-async-flash.c

diff --git a/drivers/mtd/maps/Kconfig b/drivers/mtd/maps/Kconfig
index 17bc87a..d4878eb 100644
--- a/drivers/mtd/maps/Kconfig
+++ b/drivers/mtd/maps/Kconfig
@@ -517,6 +517,17 @@ config MTD_PCMCIA_ANONYMOUS
 
 	  If unsure, say N.
 
+config MTD_BFIN_ASYNC
+	tristate "Blackfin BF533-STAMP Flash Chip Support"
+	depends on BFIN533_STAMP && MTD_CFI
+	select MTD_PARTITIONS
+	default y
+	help
+	  Map driver which allows for simultaneous utilization of
+	  ethernet and CFI parallel flash.
+
+	  If compiled as a module, it will be called bfin-async-flash.
+
 config MTD_UCLINUX
 	tristate "Generic uClinux RAM/ROM filesystem support"
 	depends on MTD_PARTITIONS && !MMU
diff --git a/drivers/mtd/maps/Makefile b/drivers/mtd/maps/Makefile
index 957fb5f..4ed1672 100644
--- a/drivers/mtd/maps/Makefile
+++ b/drivers/mtd/maps/Makefile
@@ -67,3 +67,4 @@ obj-$(CONFIG_MTD_PLATRAM)	+= plat-ram.o
 obj-$(CONFIG_MTD_OMAP_NOR)	+= omap_nor.o
 obj-$(CONFIG_MTD_MTX1)		+= mtx-1_flash.o
 obj-$(CONFIG_MTD_INTEL_VR_NOR)	+= intel_vr_nor.o
+obj-$(CONFIG_MTD_BFIN_ASYNC)	+= bfin-async-flash.o
diff --git a/drivers/mtd/maps/bfin-async-flash.c b/drivers/mtd/maps/bfin-async-flash.c
new file mode 100644
index 0000000..0d3f6e8
--- /dev/null
+++ b/drivers/mtd/maps/bfin-async-flash.c
@@ -0,0 +1,219 @@
+/*
+ * drivers/mtd/maps/bfin-async-flash.c
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
+#define pr_devinit(fmt, args...) ({ static const __devinitconst char __fmt[] = fmt; printk(__fmt, ## args); })
+
+#define DRIVER_NAME "bfin-async-flash"
+
+struct async_state {
+	struct mtd_info *mtd;
+	struct map_info map;
+	int enet_flash_pin;
+	u32 flash_ambctl0, flash_ambctl1;
+	u32 save_ambctl0, save_ambctl1;
+	unsigned long irq_flags;
+};
+
+static void switch_to_flash(struct async_state *state)
+{
+	local_irq_save(state->irq_flags);
+
+	gpio_set_value(state->enet_flash_pin, 0);
+
+	state->save_ambctl0 = bfin_read_EBIU_AMBCTL0();
+	state->save_ambctl1 = bfin_read_EBIU_AMBCTL1();
+	bfin_write_EBIU_AMBCTL0(state->flash_ambctl0);
+	bfin_write_EBIU_AMBCTL1(state->flash_ambctl1);
+	SSYNC();
+}
+
+static void switch_back(struct async_state *state)
+{
+	bfin_write_EBIU_AMBCTL0(state->save_ambctl0);
+	bfin_write_EBIU_AMBCTL1(state->save_ambctl1);
+	SSYNC();
+
+	gpio_set_value(state->enet_flash_pin, 1);
+
+	local_irq_restore(state->irq_flags);
+}
+
+static map_word bfin_read(struct map_info *map, unsigned long ofs)
+{
+	struct async_state *state = (struct async_state *)map->map_priv_1;
+	u16 word;
+	map_word test;
+
+	switch_to_flash(state);
+
+	word = readw(map->virt + ofs);
+
+	switch_back(state);
+
+	test.x[0] = word;
+	return test;
+}
+
+static void bfin_copy_from(struct map_info *map, void *to, unsigned long from, ssize_t len)
+{
+	struct async_state *state = (struct async_state *)map->map_priv_1;
+
+	switch_to_flash(state);
+
+	memcpy(to, map->virt + from, len);
+
+	switch_back(state);
+}
+
+static void bfin_write(struct map_info *map, map_word d1, unsigned long ofs)
+{
+	struct async_state *state = (struct async_state *)map->map_priv_1;
+	u16 d;
+
+	d = d1.x[0];
+
+	switch_to_flash(state);
+
+	writew(d, map->virt + ofs);
+	SSYNC();
+
+	switch_back(state);
+}
+
+static void bfin_copy_to(struct map_info *map, unsigned long to, const void *from, ssize_t len)
+{
+	struct async_state *state = (struct async_state *)map->map_priv_1;
+
+	switch_to_flash(state);
+
+	memcpy(map->virt + to, from, len);
+	SSYNC();
+
+	switch_back(state);
+}
+
+#ifdef CONFIG_MTD_PARTITIONS
+static const char *part_probe_types[] = { "cmdlinepart", "RedBoot", NULL };
+#endif
+
+static int __devinit bfin_flash_probe(struct platform_device *pdev)
+{
+	int ret;
+	struct physmap_flash_data *pdata = pdev->dev.platform_data;
+	struct resource *memory = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	struct resource *flash_ambctl = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	struct async_state *state;
+
+	state = kzalloc(sizeof(*state), GFP_KERNEL);
+	if (!state)
+		return -ENOMEM;
+
+	state->map.name       = DRIVER_NAME;
+	state->map.read       = bfin_read;
+	state->map.copy_from  = bfin_copy_from;
+	state->map.write      = bfin_write;
+	state->map.copy_to    = bfin_copy_to;
+	state->map.bankwidth  = pdata->width;
+	state->map.size       = memory->end - memory->start + 1;
+	state->map.virt       = (void __iomem *)memory->start;
+	state->map.phys       = memory->start;
+	state->map.map_priv_1 = (unsigned long)state;
+	state->enet_flash_pin = platform_get_irq(pdev, 0);
+	state->flash_ambctl0  = flash_ambctl->start;
+	state->flash_ambctl1  = flash_ambctl->end;
+
+	if (gpio_request(state->enet_flash_pin, DRIVER_NAME)) {
+		pr_devinit(KERN_ERR DRIVER_NAME ": Failed to request gpio %d\n", state->enet_flash_pin);
+		return -EBUSY;
+	}
+	gpio_direction_output(state->enet_flash_pin, 1);
+
+	pr_devinit(KERN_NOTICE DRIVER_NAME ": probing %d-bit flash bus\n", state->map.bankwidth * 8);
+	state->mtd = do_map_probe(memory->name, &state->map);
+	if (!state->mtd)
+		return -ENXIO;
+
+#ifdef CONFIG_MTD_PARTITIONS
+	ret = parse_mtd_partitions(state->mtd, part_probe_types, &pdata->parts, 0);
+	if (ret > 0) {
+		pr_devinit(KERN_NOTICE DRIVER_NAME ": Using commandline partition definition\n");
+		add_mtd_partitions(state->mtd, pdata->parts, ret);
+
+	} else if (pdata->nr_parts) {
+		pr_devinit(KERN_NOTICE DRIVER_NAME ": Using board partition definition\n");
+		add_mtd_partitions(state->mtd, pdata->parts, pdata->nr_parts);
+
+	} else
+#endif
+	{
+		pr_devinit(KERN_NOTICE DRIVER_NAME ": no partition info available, registering whole flash at once\n");
+		add_mtd_device(state->mtd);
+	}
+
+	platform_set_drvdata(pdev, state);
+
+	return 0;
+}
+
+static int __devexit bfin_flash_remove(struct platform_device *pdev)
+{
+	struct async_state *state = platform_get_drvdata(pdev);
+	gpio_free(state->enet_flash_pin);
+#ifdef CONFIG_MTD_PARTITIONS
+	del_mtd_partitions(state->mtd);
+#endif
+	map_destroy(state->mtd);
+	kfree(state);
+	return 0;
+}
+
+static struct platform_driver bfin_flash_driver = {
+	.probe		= bfin_flash_probe,
+	.remove		= __devexit_p(bfin_flash_remove),
+	.driver		= {
+		.name	= DRIVER_NAME,
+	},
+};
+
+static int __init bfin_flash_init(void)
+{
+	return platform_driver_register(&bfin_flash_driver);
+}
+module_init(bfin_flash_init);
+
+static void __exit bfin_flash_exit(void)
+{
+	platform_driver_unregister(&bfin_flash_driver);
+}
+module_exit(bfin_flash_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("MTD map driver for Blackfins with flash/ethernet on same async bank");
-- 
1.5.5
