Return-Path: <linux-kernel-owner+w=401wt.eu-S1757996AbYA3JOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757996AbYA3JOW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 04:14:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754873AbYA3JNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 04:13:48 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:40311 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143AbYA3JNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 04:13:44 -0500
X-IronPort-AV: E=Sophos;i="4.25,276,1199682000"; 
   d="scan'208";a="47623403"
From: Bryan Wu <bryan.wu@analog.com>
To: dbrownell@users.sourceforge.net, spi-devel-general@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Bryan Wu <bryan.wu@analog.com>,
       Jean-Christian de Rivaz <jc@eclis.ch>
Subject: [PATCH 4/6] [Blackfin] SPI driver: fix bug - SPI duplex operation can read a dummy byte at the first transfer
Date: Wed, 30 Jan 2008 17:13:39 +0800
Message-Id: <1201684421-26124-5-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1201684421-26124-1-git-send-email-bryan.wu@analog.com>
References: <1201684421-26124-1-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bug reported by Jean-Christian de Rivaz <jc@eclis.ch> and he also gave a patch.
http://blackfin.uclinux.org/gf/project/uclinux-dist/tracker/?action=TrackerItemEdit&tracker_item_id=3678

So revert spi_bfin5xx.c duplex operation.

Signed-off-by: Jean-Christian de Rivaz <jc@eclis.ch>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/spi/spi_bfin5xx.c |   18 +++---------------
 1 files changed, 3 insertions(+), 15 deletions(-)

diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index ceb5b53..c5d4d77 100644
--- a/drivers/spi/spi_bfin5xx.c
+++ b/drivers/spi/spi_bfin5xx.c
@@ -358,14 +358,10 @@ static void u8_cs_chg_reader(struct driver_data *drv_data)
 
 static void u8_duplex(struct driver_data *drv_data)
 {
-	/* poll for SPI completion before start */
-	while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
-		cpu_relax();
-
 	/* in duplex mode, clk is triggered by writing of TDBR */
 	while (drv_data->rx < drv_data->rx_end) {
 		write_TDBR(drv_data, (*(u8 *) (drv_data->tx)));
-		while (read_STAT(drv_data) & BIT_STAT_TXS)
+		while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
 			cpu_relax();
 		while (!(read_STAT(drv_data) & BIT_STAT_RXS))
 			cpu_relax();
@@ -495,14 +491,10 @@ static void u16_cs_chg_reader(struct driver_data *drv_data)
 
 static void u16_duplex(struct driver_data *drv_data)
 {
-	/* poll for SPI completion before start */
-	while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
-		cpu_relax();
-
 	/* in duplex mode, clk is triggered by writing of TDBR */
 	while (drv_data->tx < drv_data->tx_end) {
 		write_TDBR(drv_data, (*(u16 *) (drv_data->tx)));
-		while (read_STAT(drv_data) & BIT_STAT_TXS)
+		while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
 			cpu_relax();
 		while (!(read_STAT(drv_data) & BIT_STAT_RXS))
 			cpu_relax();
@@ -516,15 +508,11 @@ static void u16_cs_chg_duplex(struct driver_data *drv_data)
 {
 	struct chip_data *chip = drv_data->cur_chip;
 
-	/* poll for SPI completion before start */
-	while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
-		cpu_relax();
-
 	while (drv_data->tx < drv_data->tx_end) {
 		cs_active(drv_data, chip);
 
 		write_TDBR(drv_data, (*(u16 *) (drv_data->tx)));
-		while (read_STAT(drv_data) & BIT_STAT_TXS)
+		while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
 			cpu_relax();
 		while (!(read_STAT(drv_data) & BIT_STAT_RXS))
 			cpu_relax();
-- 
1.5.3.4
