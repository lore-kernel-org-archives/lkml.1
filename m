Return-Path: <linux-kernel-owner+w=401wt.eu-S1755956AbZG2RFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956AbZG2RFH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 13:05:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755942AbZG2RFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 13:05:06 -0400
Received: from ru.mvista.com ([213.79.90.228]:28658 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755933AbZG2RFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 13:05:01 -0400
Date: Wed, 29 Jul 2009 21:05:00 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       David Woodhouse <dwmw2@infradead.org>,
       Grant Likely <grant.likely@secretlab.ca>,
       Jean Delvare <khali@linux-fr.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       linuxppc-dev@ozlabs.org
Subject: [PATCH 2/7] mtd: m25p80: Convert to device table matching
Message-ID: <20090729170500.GB4803@oksana.dev.rtsoft.ru>
References: <20090729170345.GA26787@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090729170345.GA26787@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the m25p80 driver so that now it uses .id_table
for device matching, making it properly detect devices on OpenFirmware
platforms (prior to this patch the driver misdetected non-JEDEC chips,
seeing all chips as "m25p80").

Also, now jedec_probe() only does jedec probing, nothing else. If it
is not able to detect a chip, NULL is returned and the driver fall
backs to the information specified by the platform (platform_data, or
exact ID).

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/mtd/devices/m25p80.c |  152 +++++++++++++++++++++++-------------------
 1 files changed, 84 insertions(+), 68 deletions(-)

diff --git a/drivers/mtd/devices/m25p80.c b/drivers/mtd/devices/m25p80.c
index 10ed195..7c3efff 100644
--- a/drivers/mtd/devices/m25p80.c
+++ b/drivers/mtd/devices/m25p80.c
@@ -21,6 +21,7 @@
 #include <linux/interrupt.h>
 #include <linux/mutex.h>
 #include <linux/math64.h>
+#include <linux/mod_devicetable.h>
 
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/partitions.h>
@@ -462,8 +463,6 @@ static int m25p80_write(struct mtd_info *mtd, loff_t to, size_t len,
  */
 
 struct flash_info {
-	char		*name;
-
 	/* JEDEC id zero means "no ID" (most older chips); otherwise it has
 	 * a high byte of zero plus three data bytes: the manufacturer id,
 	 * then a two byte device id.
@@ -481,74 +480,83 @@ struct flash_info {
 #define	SECT_4K		0x01		/* OPCODE_BE_4K works uniformly */
 };
 
+#define INFO(_jedec_id, _ext_id, _sector_size, _n_sectors, _flags)	\
+	(&(struct flash_info) {						\
+		.jedec_id = (_jedec_id),				\
+		.ext_id = (_ext_id),					\
+		.sector_size = (_sector_size),				\
+		.n_sectors = (_n_sectors),				\
+		.flags = (_flags),					\
+	})
 
 /* NOTE: double check command sets and memory organization when you add
  * more flash chips.  This current list focusses on newer chips, which
  * have been converging on command sets which including JEDEC ID.
  */
-static struct flash_info __devinitdata m25p_data [] = {
-
+static const struct spi_device_id m25p_ids[] = {
 	/* Atmel -- some are (confusingly) marketed as "DataFlash" */
-	{ "at25fs010",  0x1f6601, 0, 32 * 1024, 4, SECT_4K, },
-	{ "at25fs040",  0x1f6604, 0, 64 * 1024, 8, SECT_4K, },
+	{ "at25fs010",  INFO(0x1f6601, 0, 32 * 1024, 4, SECT_4K) },
+	{ "at25fs040",  INFO(0x1f6604, 0, 64 * 1024, 8, SECT_4K) },
 
-	{ "at25df041a", 0x1f4401, 0, 64 * 1024, 8, SECT_4K, },
-	{ "at25df641",  0x1f4800, 0, 64 * 1024, 128, SECT_4K, },
+	{ "at25df041a", INFO(0x1f4401, 0, 64 * 1024, 8, SECT_4K) },
+	{ "at25df641",  INFO(0x1f4800, 0, 64 * 1024, 128, SECT_4K) },
 
-	{ "at26f004",   0x1f0400, 0, 64 * 1024, 8, SECT_4K, },
-	{ "at26df081a", 0x1f4501, 0, 64 * 1024, 16, SECT_4K, },
-	{ "at26df161a", 0x1f4601, 0, 64 * 1024, 32, SECT_4K, },
-	{ "at26df321",  0x1f4701, 0, 64 * 1024, 64, SECT_4K, },
+	{ "at26f004",   INFO(0x1f0400, 0, 64 * 1024, 8, SECT_4K) },
+	{ "at26df081a", INFO(0x1f4501, 0, 64 * 1024, 16, SECT_4K) },
+	{ "at26df161a", INFO(0x1f4601, 0, 64 * 1024, 32, SECT_4K) },
+	{ "at26df321",  INFO(0x1f4701, 0, 64 * 1024, 64, SECT_4K) },
 
 	/* Macronix */
-	{ "mx25l12805d", 0xc22018, 0, 64 * 1024, 256, },
+	{ "mx25l12805d", INFO(0xc22018, 0, 64 * 1024, 256, 0) },
 
 	/* Spansion -- single (large) sector size only, at least
 	 * for the chips listed here (without boot sectors).
 	 */
-	{ "s25sl004a", 0x010212, 0, 64 * 1024, 8, },
-	{ "s25sl008a", 0x010213, 0, 64 * 1024, 16, },
-	{ "s25sl016a", 0x010214, 0, 64 * 1024, 32, },
-	{ "s25sl032a", 0x010215, 0, 64 * 1024, 64, },
-	{ "s25sl064a", 0x010216, 0, 64 * 1024, 128, },
-        { "s25sl12800", 0x012018, 0x0300, 256 * 1024, 64, },
-	{ "s25sl12801", 0x012018, 0x0301, 64 * 1024, 256, },
+	{ "s25sl004a",  INFO(0x010212, 0, 64 * 1024, 8, 0) },
+	{ "s25sl008a",  INFO(0x010213, 0, 64 * 1024, 16, 0) },
+	{ "s25sl016a",  INFO(0x010214, 0, 64 * 1024, 32, 0) },
+	{ "s25sl032a",  INFO(0x010215, 0, 64 * 1024, 64, 0) },
+	{ "s25sl064a",  INFO(0x010216, 0, 64 * 1024, 128, 0) },
+	{ "s25sl12800", INFO(0x012018, 0x0300, 256 * 1024, 64, 0) },
+	{ "s25sl12801", INFO(0x012018, 0x0301, 64 * 1024, 256, 0) },
 
 	/* SST -- large erase sizes are "overlays", "sectors" are 4K */
-	{ "sst25vf040b", 0xbf258d, 0, 64 * 1024, 8, SECT_4K, },
-	{ "sst25vf080b", 0xbf258e, 0, 64 * 1024, 16, SECT_4K, },
-	{ "sst25vf016b", 0xbf2541, 0, 64 * 1024, 32, SECT_4K, },
-	{ "sst25vf032b", 0xbf254a, 0, 64 * 1024, 64, SECT_4K, },
+	{ "sst25vf040b", INFO(0xbf258d, 0, 64 * 1024, 8, SECT_4K) },
+	{ "sst25vf080b", INFO(0xbf258e, 0, 64 * 1024, 16, SECT_4K) },
+	{ "sst25vf016b", INFO(0xbf2541, 0, 64 * 1024, 32, SECT_4K) },
+	{ "sst25vf032b", INFO(0xbf254a, 0, 64 * 1024, 64, SECT_4K) },
 
 	/* ST Microelectronics -- newer production may have feature updates */
-	{ "m25p05",  0x202010,  0, 32 * 1024, 2, },
-	{ "m25p10",  0x202011,  0, 32 * 1024, 4, },
-	{ "m25p20",  0x202012,  0, 64 * 1024, 4, },
-	{ "m25p40",  0x202013,  0, 64 * 1024, 8, },
-	{ "m25p80",         0,  0, 64 * 1024, 16, },
-	{ "m25p16",  0x202015,  0, 64 * 1024, 32, },
-	{ "m25p32",  0x202016,  0, 64 * 1024, 64, },
-	{ "m25p64",  0x202017,  0, 64 * 1024, 128, },
-	{ "m25p128", 0x202018, 0, 256 * 1024, 64, },
-
-	{ "m45pe10", 0x204011,  0, 64 * 1024, 2, },
-	{ "m45pe80", 0x204014,  0, 64 * 1024, 16, },
-	{ "m45pe16", 0x204015,  0, 64 * 1024, 32, },
-
-	{ "m25pe80", 0x208014,  0, 64 * 1024, 16, },
-	{ "m25pe16", 0x208015,  0, 64 * 1024, 32, SECT_4K, },
+	{ "m25p05",  INFO(0x202010,  0, 32 * 1024, 2, 0) },
+	{ "m25p10",  INFO(0x202011,  0, 32 * 1024, 4, 0) },
+	{ "m25p20",  INFO(0x202012,  0, 64 * 1024, 4, 0) },
+	{ "m25p40",  INFO(0x202013,  0, 64 * 1024, 8, 0) },
+	{ "m25p80",  INFO(0x202014,  0, 64 * 1024, 16, 0) },
+	{ "m25p16",  INFO(0x202015,  0, 64 * 1024, 32, 0) },
+	{ "m25p32",  INFO(0x202016,  0, 64 * 1024, 64, 0) },
+	{ "m25p64",  INFO(0x202017,  0, 64 * 1024, 128, 0) },
+	{ "m25p128", INFO(0x202018, 0, 256 * 1024, 64, 0) },
+
+	{ "m45pe10", INFO(0x204011,  0, 64 * 1024, 2, 0) },
+	{ "m45pe80", INFO(0x204014,  0, 64 * 1024, 16, 0) },
+	{ "m45pe16", INFO(0x204015,  0, 64 * 1024, 32, 0) },
+
+	{ "m25pe80", INFO(0x208014,  0, 64 * 1024, 16, 0) },
+	{ "m25pe16", INFO(0x208015,  0, 64 * 1024, 32, SECT_4K) },
 
 	/* Winbond -- w25x "blocks" are 64K, "sectors" are 4KiB */
-	{ "w25x10", 0xef3011, 0, 64 * 1024, 2, SECT_4K, },
-	{ "w25x20", 0xef3012, 0, 64 * 1024, 4, SECT_4K, },
-	{ "w25x40", 0xef3013, 0, 64 * 1024, 8, SECT_4K, },
-	{ "w25x80", 0xef3014, 0, 64 * 1024, 16, SECT_4K, },
-	{ "w25x16", 0xef3015, 0, 64 * 1024, 32, SECT_4K, },
-	{ "w25x32", 0xef3016, 0, 64 * 1024, 64, SECT_4K, },
-	{ "w25x64", 0xef3017, 0, 64 * 1024, 128, SECT_4K, },
+	{ "w25x10", INFO(0xef3011, 0, 64 * 1024, 2, SECT_4K) },
+	{ "w25x20", INFO(0xef3012, 0, 64 * 1024, 4, SECT_4K) },
+	{ "w25x40", INFO(0xef3013, 0, 64 * 1024, 8, SECT_4K) },
+	{ "w25x80", INFO(0xef3014, 0, 64 * 1024, 16, SECT_4K) },
+	{ "w25x16", INFO(0xef3015, 0, 64 * 1024, 32, SECT_4K) },
+	{ "w25x32", INFO(0xef3016, 0, 64 * 1024, 64, SECT_4K) },
+	{ "w25x64", INFO(0xef3017, 0, 64 * 1024, 128, SECT_4K) },
+	{ },
 };
+MODULE_DEVICE_TABLE(spi, m25p_ids);
 
-static struct flash_info *__devinit jedec_probe(struct spi_device *spi)
+static const struct spi_device_id *__devinit jedec_probe(struct spi_device *spi)
 {
 	int			tmp;
 	u8			code = OPCODE_RDID;
@@ -575,16 +583,14 @@ static struct flash_info *__devinit jedec_probe(struct spi_device *spi)
 
 	ext_jedec = id[3] << 8 | id[4];
 
-	for (tmp = 0, info = m25p_data;
-			tmp < ARRAY_SIZE(m25p_data);
-			tmp++, info++) {
+	for (tmp = 0; tmp < ARRAY_SIZE(m25p_ids) - 1; tmp++) {
+		info = m25p_ids[tmp].data;
 		if (info->jedec_id == jedec) {
 			if (info->ext_id != 0 && info->ext_id != ext_jedec)
 				continue;
-			return info;
+			return &m25p_ids[tmp];
 		}
 	}
-	dev_err(&spi->dev, "unrecognized JEDEC id %06x\n", jedec);
 	return NULL;
 }
 
@@ -594,7 +600,8 @@ static struct flash_info *__devinit jedec_probe(struct spi_device *spi)
  * matches what the READ command supports, at least until this driver
  * understands FAST_READ (for clocks over 25 MHz).
  */
-static int __devinit m25p_probe(struct spi_device *spi)
+static int __devinit m25p_probe(struct spi_device *spi,
+				const struct spi_device_id *id)
 {
 	struct flash_platform_data	*data;
 	struct m25p			*flash;
@@ -608,32 +615,40 @@ static int __devinit m25p_probe(struct spi_device *spi)
 	 */
 	data = spi->dev.platform_data;
 	if (data && data->type) {
-		for (i = 0, info = m25p_data;
-				i < ARRAY_SIZE(m25p_data);
-				i++, info++) {
-			if (strcmp(data->type, info->name) == 0)
-				break;
+		for (i = 0; i < ARRAY_SIZE(m25p_ids) - 1; i++) {
+			id = &m25p_ids[i];
+			info = m25p_ids[i].data;
+			if (strcmp(data->type, id->name))
+				continue;
+			break;
 		}
 
 		/* unrecognized chip? */
-		if (i == ARRAY_SIZE(m25p_data)) {
+		if (i == ARRAY_SIZE(m25p_ids) - 1) {
 			DEBUG(MTD_DEBUG_LEVEL0, "%s: unrecognized id %s\n",
 					dev_name(&spi->dev), data->type);
 			info = NULL;
 
 		/* recognized; is that chip really what's there? */
 		} else if (info->jedec_id) {
-			struct flash_info	*chip = jedec_probe(spi);
+			id = jedec_probe(spi);
 
-			if (!chip || chip != info) {
+			if (id != &m25p_ids[i]) {
 				dev_warn(&spi->dev, "found %s, expected %s\n",
-						chip ? chip->name : "UNKNOWN",
-						info->name);
+						id ? id->name : "UNKNOWN",
+						m25p_ids[i].name);
 				info = NULL;
 			}
 		}
-	} else
-		info = jedec_probe(spi);
+	} else {
+		const struct spi_device_id *jid;
+
+		jid = jedec_probe(spi);
+		if (jid)
+			id = jid;
+
+		info = id ? id->data : NULL;
+	}
 
 	if (!info)
 		return -ENODEV;
@@ -680,7 +695,7 @@ static int __devinit m25p_probe(struct spi_device *spi)
 
 	flash->mtd.dev.parent = &spi->dev;
 
-	dev_info(&spi->dev, "%s (%lld Kbytes)\n", info->name,
+	dev_info(&spi->dev, "%s (%lld Kbytes)\n", id->name,
 			(long long)flash->mtd.size >> 10);
 
 	DEBUG(MTD_DEBUG_LEVEL2,
@@ -766,7 +781,8 @@ static struct spi_driver m25p80_driver = {
 		.bus	= &spi_bus_type,
 		.owner	= THIS_MODULE,
 	},
-	.probe	= m25p_probe,
+	.id_table	= m25p_ids,
+	.probe_id	= m25p_probe,
 	.remove	= __devexit_p(m25p_remove),
 
 	/* REVISIT: many of these chips have deep power-down modes, which
-- 
1.6.3.3

