Return-Path: <linux-kernel-owner+w=401wt.eu-S1755274AbZI3Tqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274AbZI3Tqy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 15:46:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755185AbZI3Tqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 15:46:53 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37142 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755072AbZI3Tqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 15:46:53 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: spi-devel-general@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH 3/7] spi-imx: Fix initial chipselect settings
Date: Wed, 30 Sep 2009 21:43:30 +0200
Message-Id: <1254339814-21506-3-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.4.3
In-Reply-To: <1254339814-21506-2-git-send-email-u.kleine-koenig@pengutronix.de>
References: <20090930194211.GB1881@pengutronix.de>
 <1254339814-21506-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <1254339814-21506-2-git-send-email-u.kleine-koenig@pengutronix.de>
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

From: Sascha Hauer <s.hauer@pengutronix.de>

We can only setup the gpio pins in spi_setup time when we
know the SPI_CS_HIGH setting.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/spi/spi_imx.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/spi/spi_imx.c b/drivers/spi/spi_imx.c
index a8f9bff..b91a5a8 100644
--- a/drivers/spi/spi_imx.c
+++ b/drivers/spi/spi_imx.c
@@ -478,12 +478,18 @@ static int spi_imx_transfer(struct spi_device *spi,
 
 static int spi_imx_setup(struct spi_device *spi)
 {
+	struct spi_imx_data *spi_imx = spi_master_get_devdata(spi->master);
+	int gpio = spi_imx->chipselect[spi->chip_select];
+
 	if (!spi->bits_per_word)
 		spi->bits_per_word = 8;
 
 	pr_debug("%s: mode %d, %u bpw, %d hz\n", __func__,
 		 spi->mode, spi->bits_per_word, spi->max_speed_hz);
 
+	if (gpio >= 0)
+		gpio_direction_output(gpio, spi->mode & SPI_CS_HIGH ? 0 : 1);
+
 	spi_imx_chipselect(spi, BITBANG_CS_INACTIVE);
 
 	return 0;
@@ -532,7 +538,6 @@ static int __init spi_imx_probe(struct platform_device *pdev)
 			dev_err(&pdev->dev, "can't get cs gpios");
 			goto out_master_put;
 		}
-		gpio_direction_output(spi_imx->chipselect[i], 1);
 	}
 
 	spi_imx->bitbang.chipselect = spi_imx_chipselect;
-- 
1.6.4.3

