Return-Path: <linux-kernel-owner+w=401wt.eu-S1752614AbZGaL0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614AbZGaL0h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 07:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752039AbZGaL0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 07:26:36 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:63552 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbZGaL0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 07:26:35 -0400
Subject: [PATCH v2] sdio: add CD disable support
From: Ohad Ben-Cohen <ohad@bencohen.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Vrabel <david.vrabel@csr.com>, Philip Langdale <philipl@overt.org>,
       Matt Fleming <matt@console-pimps.org>, ian@mnementh.co.uk,
       pierre@ossman.eu, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org, nico@cam.org,
       nicolas.ferre@rfo.atmel.com, hskinnemoen@atmel.com, tony@atomide.com,
       david-b@pacbell.net, manuel.lauss@gmail.com, mirq-l@jasper.es,
       Adrian Hunter <adrian.hunter@nokia.com>, Madhusudhan <madhu.cr@ti.com>
Content-Type: text/plain
Date: Fri, 31 Jul 2009 14:31:02 +0300
Message-Id: <1249039862.24150.5.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ohad Ben-Cohen <ohad@wizery.com>

Add support to disconnect the pull-up resistor on CD/DAT[3] (pin 1)
of the card. This may be desired on certain setups of boards,
controllers and embedded sdio devices which do not need the card's
pull-up. As a result, card detection is disabled and power is saved.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
Acked-by: Matt Fleming <matt@console-pimps.org>
---
 drivers/mmc/core/sdio.c  |   34 ++++++++++++++++++++++++++++++++++
 include/linux/mmc/card.h |    3 ++-
 2 files changed, 36 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
index fb99ccf..a962946 100644
--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -165,6 +165,33 @@ static int sdio_enable_wide(struct mmc_card *card)
 }
 
 /*
+ * If desired, disconnect the pull-up resistor on CD/DAT[3] (pin 1)
+ * of the card. This may be required on certain setups of boards,
+ * controllers and embedded sdio device which do not need the card's
+ * pull-up. As a result, card detection is disabled and power is saved.
+ */
+static int sdio_disable_cd(struct mmc_card *card)
+{
+	int ret;
+	u8 ctrl;
+
+	if (!card->cccr.disable_cd)
+		return 0;
+
+	ret = mmc_io_rw_direct(card, 0, 0, SDIO_CCCR_IF, 0, &ctrl);
+	if (ret)
+		return ret;
+
+	ctrl |= SDIO_BUS_CD_DISABLE;
+
+	ret = mmc_io_rw_direct(card, 1, 0, SDIO_CCCR_IF, ctrl, NULL);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+/*
  * Test if the card supports high-speed mode and, if so, switch to it.
  */
 static int sdio_enable_hs(struct mmc_card *card)
@@ -392,6 +419,13 @@ int mmc_attach_sdio(struct mmc_host *host, u32 ocr)
 		goto remove;
 
 	/*
+	 * If needed, disconnect card detection pull-up resistor.
+	 */
+	err = sdio_disable_cd(card);
+	if (err)
+		goto remove;
+
+	/*
 	 * Initialize (but don't add) all present functions.
 	 */
 	for (i = 0;i < funcs;i++) {
diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
index 403aa50..82a8488 100644
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -62,7 +62,8 @@ struct sdio_cccr {
 				low_speed:1,
 				wide_bus:1,
 				high_power:1,
-				high_speed:1;
+				high_speed:1,
+				disable_cd:1;
 };
 
 struct sdio_cis {
-- 
1.5.4.3



