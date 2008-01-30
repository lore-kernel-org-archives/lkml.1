Return-Path: <linux-kernel-owner+w=401wt.eu-S1758646AbYA3JPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758646AbYA3JPT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 04:15:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755115AbYA3JNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 04:13:50 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:32402 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753943AbYA3JNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 04:13:45 -0500
X-IronPort-AV: E=Sophos;i="4.25,276,1199682000"; 
   d="scan'208";a="47623404"
From: Bryan Wu <bryan.wu@analog.com>
To: dbrownell@users.sourceforge.net, spi-devel-general@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 3/6] [Blackfin] SPI driver: fix bug - PBX cannot work with this SPI framework driver
Date: Wed, 30 Jan 2008 17:13:38 +0800
Message-Id: <1201684421-26124-4-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1201684421-26124-1-git-send-email-bryan.wu@analog.com>
References: <1201684421-26124-1-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PBX 2 SPI device need cs change per word and this regression is due to commit

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/spi/spi_bfin5xx.c |   40 ++++++++++++----------------------------
 1 files changed, 12 insertions(+), 28 deletions(-)

diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index c3f9ed4..ceb5b53 100644
--- a/drivers/spi/spi_bfin5xx.c
+++ b/drivers/spi/spi_bfin5xx.c
@@ -294,16 +294,14 @@ static void u8_cs_chg_writer(struct driver_data *drv_data)
 {
 	struct chip_data *chip = drv_data->cur_chip;
 
-	/* poll for SPI completion before start */
-	while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
-		cpu_relax();
-
 	while (drv_data->tx < drv_data->tx_end) {
 		cs_active(drv_data, chip);
 
 		write_TDBR(drv_data, (*(u8 *) (drv_data->tx)));
 		while (read_STAT(drv_data) & BIT_STAT_TXS)
 			cpu_relax();
+		while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
+			cpu_relax();
 
 		cs_deactive(drv_data, chip);
 
@@ -342,31 +340,20 @@ static void u8_cs_chg_reader(struct driver_data *drv_data)
 {
 	struct chip_data *chip = drv_data->cur_chip;
 
-	/* poll for SPI completion before start */
-	while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
-		cpu_relax();
-
-	/* clear TDBR buffer before read(else it will be shifted out) */
-	write_TDBR(drv_data, 0xFFFF);
+	while (drv_data->rx < drv_data->rx_end) {
+		cs_active(drv_data, chip);
+		read_RDBR(drv_data);	/* kick off */
 
-	cs_active(drv_data, chip);
-	dummy_read(drv_data);
+		while (!(read_STAT(drv_data) & BIT_STAT_RXS))
+			cpu_relax();
+		while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
+			cpu_relax();
 
-	while (drv_data->rx < drv_data->rx_end - 1) {
+		*(u8 *) (drv_data->rx) = read_SHAW(drv_data);
 		cs_deactive(drv_data, chip);
 
-		while (!(read_STAT(drv_data) & BIT_STAT_RXS))
-			cpu_relax();
-		cs_active(drv_data, chip);
-		*(u8 *) (drv_data->rx) = read_RDBR(drv_data);
 		++drv_data->rx;
 	}
-	cs_deactive(drv_data, chip);
-
-	while (!(read_STAT(drv_data) & BIT_STAT_RXS))
-		cpu_relax();
-	*(u8 *) (drv_data->rx) = read_SHAW(drv_data);
-	++drv_data->rx;
 }
 
 static void u8_duplex(struct driver_data *drv_data)
@@ -392,15 +379,12 @@ static void u8_cs_chg_duplex(struct driver_data *drv_data)
 {
 	struct chip_data *chip = drv_data->cur_chip;
 
-	/* poll for SPI completion before start */
-	while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
-		cpu_relax();
-
 	while (drv_data->rx < drv_data->rx_end) {
 		cs_active(drv_data, chip);
 
 		write_TDBR(drv_data, (*(u8 *) (drv_data->tx)));
-		while (read_STAT(drv_data) & BIT_STAT_TXS)
+
+		while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
 			cpu_relax();
 		while (!(read_STAT(drv_data) & BIT_STAT_RXS))
 			cpu_relax();
-- 
1.5.3.4
