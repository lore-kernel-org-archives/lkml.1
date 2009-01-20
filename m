Return-Path: <linux-kernel-owner+w=401wt.eu-S1755445AbZATOMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445AbZATOMm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 09:12:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754650AbZATOMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 09:12:17 -0500
Received: from mba.ocn.ne.jp ([122.1.235.107]:57693 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106AbZATOMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 09:12:16 -0500
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
To: linux-mips@linux-mips.org
Cc: ralf@linux-mips.org, linux-mtd@lists.infradead.org, dwmw2@infradead.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] RBTX4939: Add MTD support
Date: Tue, 20 Jan 2009 23:12:16 +0900
Message-Id: <1232460738-4714-2-git-send-email-anemo@mba.ocn.ne.jp>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add platform support for NOR flash chips on RBTX4939 board.
This board has complex flash mappings, controlled by its DIPSW setting.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
 arch/mips/include/asm/txx9/rbtx4939.h |    9 ++
 arch/mips/txx9/rbtx4939/setup.c       |  157 +++++++++++++++++++++++++++++++++
 2 files changed, 166 insertions(+), 0 deletions(-)

diff --git a/arch/mips/include/asm/txx9/rbtx4939.h b/arch/mips/include/asm/txx9/rbtx4939.h
index 1acf428..e517899 100644
--- a/arch/mips/include/asm/txx9/rbtx4939.h
+++ b/arch/mips/include/asm/txx9/rbtx4939.h
@@ -130,4 +130,13 @@
 void rbtx4939_prom_init(void);
 void rbtx4939_irq_setup(void);
 
+struct mtd_partition;
+struct map_info;
+struct rbtx4939_flash_data {
+	unsigned int width;
+	unsigned int nr_parts;
+	struct mtd_partition *parts;
+	void (*map_init)(struct map_info *map);
+};
+
 #endif /* __ASM_TXX9_RBTX4939_H */
diff --git a/arch/mips/txx9/rbtx4939/setup.c b/arch/mips/txx9/rbtx4939/setup.c
index 74839f2..eee8763 100644
--- a/arch/mips/txx9/rbtx4939/setup.c
+++ b/arch/mips/txx9/rbtx4939/setup.c
@@ -16,6 +16,9 @@
 #include <linux/leds.h>
 #include <linux/interrupt.h>
 #include <linux/smc91x.h>
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/partitions.h>
+#include <linux/mtd/map.h>
 #include <asm/reboot.h>
 #include <asm/txx9/generic.h>
 #include <asm/txx9/pci.h>
@@ -282,6 +285,159 @@ static void rbtx4939_7segled_putc(unsigned int pos, unsigned char val)
 	__rbtx4939_7segled_putc(pos, val);
 }
 
+#if defined(CONFIG_MTD_RBTX4939) || defined(CONFIG_MTD_RBTX4939_MODULE)
+/* special mapping for boot rom */
+static unsigned long rbtx4939_flash_fixup_ofs(unsigned long ofs)
+{
+	u8 bdipsw = readb(rbtx4939_bdipsw_addr) & 0x0f;
+	unsigned char shift;
+
+	if (bdipsw & 8) {
+		/* BOOT Mode: USER ROM1 / USER ROM2 */
+		shift = bdipsw & 3;
+		/* rotate A[23:22] */
+		return (ofs & ~0xc00000) | ((((ofs >> 22) + shift) & 3) << 22);
+	}
+#ifdef __BIG_ENDIAN
+	if (bdipsw == 0)
+		/* BOOT Mode: Monitor ROM */
+		ofs ^= 0x400000;	/* swap A[22] */
+#endif
+	return ofs;
+}
+
+static map_word rbtx4939_flash_read16(struct map_info *map, unsigned long ofs)
+{
+	map_word r;
+
+	ofs = rbtx4939_flash_fixup_ofs(ofs);
+	r.x[0] = __raw_readw(map->virt + ofs);
+	return r;
+}
+
+static void rbtx4939_flash_write16(struct map_info *map, const map_word datum,
+				   unsigned long ofs)
+{
+	ofs = rbtx4939_flash_fixup_ofs(ofs);
+	__raw_writew(datum.x[0], map->virt + ofs);
+	mb();	/* see inline_map_write() in mtd/map.h */
+}
+
+static void rbtx4939_flash_copy_from(struct map_info *map, void *to,
+				     unsigned long from, ssize_t len)
+{
+	u8 bdipsw = readb(rbtx4939_bdipsw_addr) & 0x0f;
+	unsigned char shift;
+	ssize_t curlen;
+
+	from += (unsigned long)map->virt;
+	if (bdipsw & 8) {
+		/* BOOT Mode: USER ROM1 / USER ROM2 */
+		shift = bdipsw & 3;
+		while (len) {
+			curlen = min((unsigned long)len,
+				     0x400000 -	(from & (0x400000 - 1)));
+			memcpy(to,
+			       (void *)((from & ~0xc00000) |
+					((((from >> 22) + shift) & 3) << 22)),
+			       curlen);
+			len -= curlen;
+			from += curlen;
+			to += curlen;
+		}
+		return;
+	}
+#ifdef __BIG_ENDIAN
+	if (bdipsw == 0) {
+		/* BOOT Mode: Monitor ROM */
+		while (len) {
+			curlen = min((unsigned long)len,
+				     0x400000 - (from & (0x400000 - 1)));
+			memcpy(to, (void *)(from ^ 0x400000), curlen);
+			len -= curlen;
+			from += curlen;
+			to += curlen;
+		}
+		return;
+	}
+#endif
+	memcpy(to, (void *)from, len);
+}
+
+static void rbtx4939_flash_map_init(struct map_info *map)
+{
+	map->read = rbtx4939_flash_read16;
+	map->write = rbtx4939_flash_write16;
+	map->copy_from = rbtx4939_flash_copy_from;
+}
+
+static void __init rbtx4939_mtd_init(void)
+{
+	static struct {
+		struct platform_device dev;
+		struct resource res;
+		struct rbtx4939_flash_data data;
+	} pdevs[4];
+	int i;
+	static char names[4][8];
+	static struct mtd_partition parts[4];
+	struct rbtx4939_flash_data *boot_pdata = &pdevs[0].data;
+	u8 bdipsw = readb(rbtx4939_bdipsw_addr) & 0x0f;
+
+	if (bdipsw & 8) {
+		/* BOOT Mode: USER ROM1 / USER ROM2 */
+		boot_pdata->nr_parts = 4;
+		for (i = 0; i < boot_pdata->nr_parts; i++) {
+			sprintf(names[i], "img%d", 4 - i);
+			parts[i].name = names[i];
+			parts[i].size = 0x400000;
+			parts[i].offset = MTDPART_OFS_NXTBLK;
+		}
+	} else if (bdipsw == 0) {
+		/* BOOT Mode: Monitor ROM */
+		boot_pdata->nr_parts = 2;
+		strcpy(names[0], "big");
+		strcpy(names[1], "little");
+		for (i = 0; i < boot_pdata->nr_parts; i++) {
+			parts[i].name = names[i];
+			parts[i].size = 0x400000;
+			parts[i].offset = MTDPART_OFS_NXTBLK;
+		}
+	} else {
+		/* BOOT Mode: ROM Emulator */
+		boot_pdata->nr_parts = 2;
+		parts[0].name = "boot";
+		parts[0].offset = 0xc00000;
+		parts[0].size = 0x400000;
+		parts[1].name = "user";
+		parts[1].offset = 0;
+		parts[1].size = 0xc00000;
+	}
+	boot_pdata->parts = parts;
+	boot_pdata->map_init = rbtx4939_flash_map_init;
+
+	for (i = 0; i < ARRAY_SIZE(pdevs); i++) {
+		struct resource *r = &pdevs[i].res;
+		struct platform_device *dev = &pdevs[i].dev;
+
+		r->start = 0x1f000000 - i * 0x1000000;
+		r->end = r->start + 0x1000000 - 1;
+		r->flags = IORESOURCE_MEM;
+		pdevs[i].data.width = 2;
+		dev->num_resources = 1;
+		dev->resource = r;
+		dev->id = i;
+		dev->name = "rbtx4939-flash";
+		dev->dev.platform_data = &pdevs[i].data;
+		platform_device_register(dev);
+	}
+}
+#else
+static void __init rbtx4939_mtd_init(void)
+{
+}
+#endif
+
 static void __init rbtx4939_arch_init(void)
 {
 	rbtx4939_pci_setup();
@@ -333,6 +489,7 @@ static void __init rbtx4939_device_init(void)
 	    platform_device_add_data(pdev, &smc_pdata, sizeof(smc_pdata)) ||
 	    platform_device_add(pdev))
 		platform_device_put(pdev);
+	rbtx4939_mtd_init();
 	/* TC58DVM82A1FT: tDH=10ns, tWP=tRP=tREADID=35ns */
 	tx4939_ndfmc_init(10, 35,
 			  (1 << 1) | (1 << 2),
-- 
1.5.6.3

