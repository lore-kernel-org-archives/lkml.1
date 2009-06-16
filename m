Return-Path: <linux-kernel-owner+w=401wt.eu-S1755925AbZFPLTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925AbZFPLTT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 07:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752561AbZFPLTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 07:19:10 -0400
Received: from mga14.intel.com ([143.182.124.37]:55803 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998AbZFPLTJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 07:19:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,228,1243839600"; 
   d="scan'208";a="155040479"
From: "Li, Jiebing" <jiebing.li@intel.com>
To: Pierre Ossman <pierre@ossman.eu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Johnson, Charles F" <charles.f.johnson@intel.com>,
       "Zhu, Daniel" <daniel.zhu@intel.com>,
       "Yuan, Hang" <hang.yuan@intel.com>
Date: Tue, 16 Jun 2009 19:18:53 +0800
Subject: [PATCH 1/1] MMC: SDIO card reset support for Intel Moorestown
  platform
Thread-Topic: [PATCH 1/1] MMC: SDIO card reset support for Intel Moorestown
  platform
Thread-Index: AcnudDs+4+t0UqUvQu67BIohCGpIDA==
Message-ID: <95608CFE3D0C064B8468DB61F8403BE036C19F9ECF@PDSMSX501.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



This patch supplies a card reset rountine for device driver to recover
the SDIO card when some error occurs in hardware.

Signed-off-by: JiebingLi <jiebing.li@intel.com>
---
 drivers/mmc/core/sdio.c       |  182 +++++++++++++++++++++++++++++++++++++++++
 include/linux/mmc/sdio_func.h |    4 +
 2 files changed, 186 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
index fb99ccf..ce74bda 100644
--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -24,6 +24,8 @@
 #include "sdio_ops.h"
 #include "sdio_cis.h"
 
+#define to_sdio_driver(d) container_of(d, struct sdio_driver, drv)
+
 static int sdio_read_fbr(struct sdio_func *func)
 {
 	int ret;
@@ -439,3 +441,183 @@ err:
 	return err;
 }
 
+/*
+ * Handle the re-initialization of a SDIO card.
+ */
+static int mmc_sdio_reinit_card(struct mmc_host *host,
+	struct mmc_card *oldcard)
+{
+	int err = 0;
+	u32 ocr;
+	struct mmc_card *card;
+
+	BUG_ON(!host);
+	WARN_ON(!host->claimed);
+
+	if (!oldcard)
+		goto err;
+
+	card = oldcard;
+
+	err = mmc_send_io_op_cond(host, 0, &ocr);
+	if (err)
+		goto remove;
+
+	/*
+	 * Inform the card of the voltage
+	 */
+	err = mmc_send_io_op_cond(host, host->ocr, &ocr);
+	if (err)
+		goto remove;
+
+	/*
+	 * For SPI, enable CRC as appropriate.
+	 */
+	if (mmc_host_is_spi(host)) {
+		err = mmc_spi_set_crc(host, use_spi_crc);
+		if (err)
+			goto remove;
+	}
+
+	if (!mmc_host_is_spi(host)) {
+		err = mmc_send_relative_addr(host, &card->rca);
+		if (err)
+			goto remove;
+
+		mmc_set_bus_mode(host, MMC_BUSMODE_PUSHPULL);
+	}
+
+	/*
+	 * Select card, as all following commands rely on that.
+	 */
+	if (!mmc_host_is_spi(host)) {
+		err = mmc_select_card(card);
+		if (err)
+			goto remove;
+	}
+
+	/*
+	 * Read the common CIS tuples.
+	 */
+	err = sdio_read_cccr(card);
+	if (err)
+		goto remove;
+
+	/*
+	 * Switch to high-speed (if supported).
+	 */
+	err = sdio_enable_hs(card);
+	if (err)
+		goto remove;
+
+	/*
+	 * Change to the card's maximum speed.
+	 */
+	if (mmc_card_highspeed(card))
+		mmc_set_clock(host, 50000000);
+	else
+		mmc_set_clock(host, card->cis.max_dtr);
+
+	/*
+	 * Switch to wider bus (if supported).
+	 */
+	err = sdio_enable_wide(card);
+	if (err)
+		goto remove;
+
+	host->card = card;
+
+	return 0;
+
+remove:
+err:
+	return err;
+}
+
+/*
+ * Sometimes there is a hang in the host interface hardware,
+ * eg: the device driver can not access the device due to some error.
+ * This API is used by device driver to perform a SDIO device
+ * reset in order to solve such issues.
+ *
+ * Warn all device drivers using their pre_reset method,
+ * performs the whole SDIO card and then lets the drivers
+ * know that the reset is over using the post_reset method.
+ */
+int sdio_reset_device(struct mmc_card *card)
+{
+	int ret = 0;
+	int i = 0;
+	u8 reg = 0;
+
+	BUG_ON(!card);
+	BUG_ON(!card->host);
+	BUG_ON(!card->sdio_func);
+
+	if (!mmc_card_present(card)) {
+		dev_dbg(&card->dev, "device reset not allowed\n");
+		return -EINVAL;
+	}
+
+	for (; i < card->sdio_funcs; i++) {
+		struct sdio_func *func = card->sdio_func[i];
+		struct sdio_driver *drv;
+
+		if (func && func->dev.driver) {
+			drv = to_sdio_driver(func->dev.driver);
+			if (drv->pre_reset) {
+				ret = (drv->pre_reset)(func);
+				if (ret)
+					break;
+			}
+		}
+	}
+
+	if (ret)
+		goto err;
+
+	/* reset SDIO card via CMD52 */
+	mmc_claim_host(card->host);
+
+	ret = mmc_io_rw_direct(card, 0, 0, SDIO_CCCR_ABORT, 0, &reg);
+
+	if (ret)
+		reg = 0x08;
+	else
+		reg |= 0x08;
+
+	mmc_io_rw_direct(card, 1, 0, SDIO_CCCR_ABORT, reg, NULL);
+
+	/* re-enumerate the device */
+	ret = mmc_sdio_reinit_card(card->host, card);
+
+	mmc_release_host(card->host);
+
+	if (ret)
+		goto err;
+
+	for (i = card->sdio_funcs - 1; i >= 0; i--) {
+		struct sdio_func *func = card->sdio_func[i];
+		struct sdio_driver *drv;
+
+		if (func && func->dev.driver) {
+			drv = to_sdio_driver(func->dev.driver);
+			if (drv->post_reset) {
+				ret = (drv->post_reset)(func);
+				if (ret)
+					break;
+			}
+		}
+	}
+
+	if (ret)
+		goto err;
+
+	return 0;
+
+err:
+	return -EINVAL;
+
+}
+EXPORT_SYMBOL_GPL(sdio_reset_device);
+
diff --git a/include/linux/mmc/sdio_func.h b/include/linux/mmc/sdio_func.h
index 451bdfc..90ec007 100644
--- a/include/linux/mmc/sdio_func.h
+++ b/include/linux/mmc/sdio_func.h
@@ -78,6 +78,9 @@ struct sdio_driver {
 	int (*probe)(struct sdio_func *, const struct sdio_device_id *);
 	void (*remove)(struct sdio_func *);
 
+	int (*pre_reset)(struct sdio_func *);
+	int (*post_reset)(struct sdio_func *);
+
 	struct device_driver drv;
 };
 
@@ -150,5 +153,6 @@ extern unsigned char sdio_f0_readb(struct sdio_func *func,
 extern void sdio_f0_writeb(struct sdio_func *func, unsigned char b,
 	unsigned int addr, int *err_ret);
 
+extern int sdio_reset_device(struct mmc_card *card);
 #endif
 
-- 
1.6.0
