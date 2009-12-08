Return-Path: <linux-kernel-owner+w=401wt.eu-S966207AbZLHVOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966207AbZLHVOV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 16:14:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965987AbZLHVOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 16:14:20 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52219 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965969AbZLHVOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 16:14:19 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: spi-devel-general@lists.sourceforge.net
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       Daniel Mack <daniel@caiaq.de>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 1/5] spi-imx: use platform_driver_probe as probe lives in .init.text
Date: Tue,  8 Dec 2009 22:14:06 +0100
Message-Id: <1260306850-14945-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <20091208211258.GA13706@pengutronix.de>
References: <20091208211258.GA13706@pengutronix.de>
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

Using platform_driver_register with a probe function defined using
__init is wrong.

This fixes an oops after:

	cd /sys/bus/platform/drivers/spi_imx
	echo -n spi_imx.0 > unbind
	echo -n spi_imx.0 > bind

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/spi/spi_imx.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi_imx.c b/drivers/spi/spi_imx.c
index 1b17f44..c83ca05 100644
--- a/drivers/spi/spi_imx.c
+++ b/drivers/spi/spi_imx.c
@@ -666,13 +666,12 @@ static struct platform_driver spi_imx_driver = {
 		   .name = DRIVER_NAME,
 		   .owner = THIS_MODULE,
 		   },
-	.probe = spi_imx_probe,
 	.remove = __exit_p(spi_imx_remove),
 };
 
 static int __init spi_imx_init(void)
 {
-	return platform_driver_register(&spi_imx_driver);
+	return platform_driver_probe(&spi_imx_driver, spi_imx_probe);
 }
 
 static void __exit spi_imx_exit(void)
-- 
1.6.5.2

