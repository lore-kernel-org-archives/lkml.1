Return-Path: <linux-kernel-owner+w=401wt.eu-S1755279AbZI3ToV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279AbZI3ToV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 15:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755239AbZI3ToT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 15:44:19 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36996 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755248AbZI3ToP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 15:44:15 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: spi-devel-general@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH 7/7 RFC] spi-imx: strip down chipselect function to only drive the chipselect
Date: Wed, 30 Sep 2009 21:43:34 +0200
Message-Id: <1254339814-21506-7-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.4.3
In-Reply-To: <1254339814-21506-6-git-send-email-u.kleine-koenig@pengutronix.de>
References: <20090930194211.GB1881@pengutronix.de>
 <1254339814-21506-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <1254339814-21506-2-git-send-email-u.kleine-koenig@pengutronix.de>
 <1254339814-21506-3-git-send-email-u.kleine-koenig@pengutronix.de>
 <1254339814-21506-4-git-send-email-u.kleine-koenig@pengutronix.de>
 <1254339814-21506-5-git-send-email-u.kleine-koenig@pengutronix.de>
 <1254339814-21506-6-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

spi_imx_chipselect() made things that should be (and mostly are) done by
spi_imx_setupxfer.  Only setting the tx and rx functions was missing.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Acked-by: Sascha Hauer <s.hauer@pengutronix.de>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/spi/spi_imx.c |   50 ++++++++++++++++--------------------------------
 1 files changed, 17 insertions(+), 33 deletions(-)

diff --git a/drivers/spi/spi_imx.c b/drivers/spi/spi_imx.c
index 2fec117..89c22ef 100644
--- a/drivers/spi/spi_imx.c
+++ b/drivers/spi/spi_imx.c
@@ -354,43 +354,14 @@ static int mx1_rx_available(struct spi_imx_data *spi_imx)
 static void spi_imx_chipselect(struct spi_device *spi, int is_active)
 {
 	struct spi_imx_data *spi_imx = spi_master_get_devdata(spi->master);
-	unsigned int cs = 0;
 	int gpio = spi_imx->chipselect[spi->chip_select];
-	struct spi_imx_config config;
-
-	if (spi->mode & SPI_CS_HIGH)
-		cs = 1;
+	int active = is_active != BITBANG_CS_INACTIVE;
+	int dev_is_lowactive = !(spi->mode & SPI_CS_HIGH);
 
-	if (is_active == BITBANG_CS_INACTIVE) {
-		if (gpio >= 0)
-			gpio_set_value(gpio, !cs);
+	if (gpio < 0)
 		return;
-	}
-
-	config.bpw = spi->bits_per_word;
-	config.speed_hz = spi->max_speed_hz;
-	config.mode = spi->mode;
-	config.cs = spi_imx->chipselect[spi->chip_select];
-
-	spi_imx->config(spi_imx, &config);
-
-	/* Initialize the functions for transfer */
-	if (config.bpw <= 8) {
-		spi_imx->rx = spi_imx_buf_rx_u8;
-		spi_imx->tx = spi_imx_buf_tx_u8;
-	} else if (config.bpw <= 16) {
-		spi_imx->rx = spi_imx_buf_rx_u16;
-		spi_imx->tx = spi_imx_buf_tx_u16;
-	} else if (config.bpw <= 32) {
-		spi_imx->rx = spi_imx_buf_rx_u32;
-		spi_imx->tx = spi_imx_buf_tx_u32;
-	} else
-		BUG();
-
-	if (gpio >= 0)
-		gpio_set_value(gpio, cs);
 
-	return;
+	gpio_set_value(gpio, dev_is_lowactive ^ active);
 }
 
 static void spi_imx_push(struct spi_imx_data *spi_imx)
@@ -451,6 +422,19 @@ static int spi_imx_setupxfer(struct spi_device *spi,
 	if (!config.speed_hz)
 		config.speed_hz = spi->max_speed_hz;
 
+	/* Initialize the functions for transfer */
+	if (config.bpw <= 8) {
+		spi_imx->rx = spi_imx_buf_rx_u8;
+		spi_imx->tx = spi_imx_buf_tx_u8;
+	} else if (config.bpw <= 16) {
+		spi_imx->rx = spi_imx_buf_rx_u16;
+		spi_imx->tx = spi_imx_buf_tx_u16;
+	} else if (config.bpw <= 32) {
+		spi_imx->rx = spi_imx_buf_rx_u32;
+		spi_imx->tx = spi_imx_buf_tx_u32;
+	} else
+		BUG();
+
 	spi_imx->config(spi_imx, &config);
 
 	return 0;
-- 
1.6.4.3

