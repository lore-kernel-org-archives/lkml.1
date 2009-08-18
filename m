Return-Path: <linux-kernel-owner+w=401wt.eu-S1751433AbZHRVqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751433AbZHRVqW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 17:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751357AbZHRVqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 17:46:21 -0400
Received: from ru.mvista.com ([213.79.90.228]:43969 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751396AbZHRVqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 17:46:21 -0400
Date: Wed, 19 Aug 2009 01:46:22 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       David Woodhouse <dwmw2@infradead.org>,
       Artem Bityutskiy <dedekind1@gmail.com>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: [PATCH 1/2] mtd: m25p80: Rework probing/JEDEC code
Message-ID: <20090818214622.GA22651@oksana.dev.rtsoft.ru>
References: <20090818214449.GA12848@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090818214449.GA12848@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previosly the driver always tried JEDEC probing, assuming that non-JEDEC
chips will return '0'. But truly non-JEDEC chips (like CAT25) won't do
that, their behaviour on RDID command is undefined, so the driver should
not call jedec_probe() for these chips.

Also, be less strict on error conditions, don't fail to probe if JEDEC
found a chip that is different from what platform code told, instead
just print some warnings and use an information obtained via JEDEC. In
that case we should not trust partitions any longer, but they might be
still useful (i.e. they could protect some parts of the chip).

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/mtd/devices/m25p80.c |   69 ++++++++++++++++++++++++-----------------
 1 files changed, 40 insertions(+), 29 deletions(-)

diff --git a/drivers/mtd/devices/m25p80.c b/drivers/mtd/devices/m25p80.c
index 0d74b38..b75e319 100644
--- a/drivers/mtd/devices/m25p80.c
+++ b/drivers/mtd/devices/m25p80.c
@@ -581,6 +581,14 @@ static const struct spi_device_id *__devinit jedec_probe(struct spi_device *spi)
 	jedec = jedec << 8;
 	jedec |= id[2];
 
+	/*
+	 * Some chips (like Numonyx M25P80) have JEDEC and non-JEDEC variants,
+	 * which depend on technology process. Officially RDID command doesn't
+	 * exist for non-JEDEC chips, but for compatibility they return ID 0.
+	 */
+	if (jedec == 0)
+		return NULL;
+
 	ext_jedec = id[3] << 8 | id[4];
 
 	for (tmp = 0; tmp < ARRAY_SIZE(m25p_ids) - 1; tmp++) {
@@ -602,7 +610,7 @@ static const struct spi_device_id *__devinit jedec_probe(struct spi_device *spi)
  */
 static int __devinit m25p_probe(struct spi_device *spi)
 {
-	const struct spi_device_id	*id;
+	const struct spi_device_id	*id = spi_get_device_id(spi);
 	struct flash_platform_data	*data;
 	struct m25p			*flash;
 	struct flash_info		*info;
@@ -615,41 +623,44 @@ static int __devinit m25p_probe(struct spi_device *spi)
 	 */
 	data = spi->dev.platform_data;
 	if (data && data->type) {
+		const struct spi_device_id *plat_id;
+
 		for (i = 0; i < ARRAY_SIZE(m25p_ids) - 1; i++) {
-			id = &m25p_ids[i];
-			info = (void *)m25p_ids[i].driver_data;
-			if (strcmp(data->type, id->name))
+			plat_id = &m25p_ids[i];
+			if (strcmp(data->type, plat_id->name))
 				continue;
 			break;
 		}
 
-		/* unrecognized chip? */
-		if (i == ARRAY_SIZE(m25p_ids) - 1) {
-			DEBUG(MTD_DEBUG_LEVEL0, "%s: unrecognized id %s\n",
-					dev_name(&spi->dev), data->type);
-			info = NULL;
-
-		/* recognized; is that chip really what's there? */
-		} else if (info->jedec_id) {
-			id = jedec_probe(spi);
-
-			if (id != &m25p_ids[i]) {
-				dev_warn(&spi->dev, "found %s, expected %s\n",
-						id ? id->name : "UNKNOWN",
-						m25p_ids[i].name);
-				info = NULL;
-			}
-		}
-	} else {
-		id = jedec_probe(spi);
-		if (!id)
-			id = spi_get_device_id(spi);
-
-		info = (void *)id->driver_data;
+		if (plat_id)
+			id = plat_id;
+		else
+			dev_warn(&spi->dev, "unrecognized id %s\n", data->type);
 	}
 
-	if (!info)
-		return -ENODEV;
+	info = (void *)id->driver_data;
+
+	if (info->jedec_id) {
+		const struct spi_device_id *jid;
+
+		jid = jedec_probe(spi);
+		if (!jid) {
+			dev_info(&spi->dev, "non-JEDEC variant of %s\n",
+				 id->name);
+		} else if (jid != id) {
+			/*
+			 * JEDEC knows better, so overwrite platform ID. We
+			 * can't trust partitions any longer, but we'll let
+			 * mtd apply them anyway, since some partitions may be
+			 * marked read-only, and we don't want to lose that
+			 * information, even if it's not 100% accurate.
+			 */
+			dev_warn(&spi->dev, "found %s, expected %s\n",
+				 jid->name, id->name);
+			id = jid;
+			info = (void *)jid->driver_data;
+		}
+	}
 
 	flash = kzalloc(sizeof *flash, GFP_KERNEL);
 	if (!flash)
-- 
1.6.3.3

