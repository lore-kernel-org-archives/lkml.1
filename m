Return-Path: <linux-kernel-owner+w=401wt.eu-S1756622AbZFVNiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622AbZFVNiv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 09:38:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753783AbZFVNiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 09:38:22 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:50758 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755791AbZFVNiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 09:38:21 -0400
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: Daniel Mack <daniel@caiaq.de>, Pavel Machek <pavel@ucw.cz>,
       Eric Piel <eric.piel@tremplin-utc.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/4] piis3: add power management functions
Date: Mon, 22 Jun 2009 15:38:07 +0200
Message-Id: <1245677888-16634-3-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1245677888-16634-2-git-send-email-daniel@caiaq.de>
References: <1245677888-16634-1-git-send-email-daniel@caiaq.de>
 <1245677888-16634-2-git-send-email-daniel@caiaq.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This enabled power management functions for the SPI transport layer of
the lis3 devices. The device's suspend mode is only entered in case no
wakeup threshold has been given. In this case, the device is supposed
to wake up the system and must thus not be put to deep sleep.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Eric Piel <eric.piel@tremplin-utc.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/hwmon/lis3lv02d_spi.c |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/drivers/hwmon/lis3lv02d_spi.c b/drivers/hwmon/lis3lv02d_spi.c
index 3827ff0..97d5f70 100644
--- a/drivers/hwmon/lis3lv02d_spi.c
+++ b/drivers/hwmon/lis3lv02d_spi.c
@@ -87,6 +87,32 @@ static int __devexit lis302dl_spi_remove(struct spi_device *spi)
 	return 0;
 }
 
+#ifdef CONFIG_PM
+static int lis3lv02d_spi_suspend(struct spi_device *spi, pm_message_t mesg)
+{
+	struct lis3lv02d *lis3 = spi_get_drvdata(spi);
+
+	if (!lis3->pdata->wakeup_flags)
+		lis3lv02d_poweroff(&lis3_dev);
+
+	return 0;
+}
+
+static int lis3lv02d_spi_resume(struct spi_device *spi)
+{
+	struct lis3lv02d *lis3 = spi_get_drvdata(spi);
+
+	if (!lis3->pdata->wakeup_flags)
+		lis3lv02d_poweron(lis3);
+
+	return 0;
+}
+
+#else
+#define lis3_spi_suspend	NULL
+#define lis3_spi_resume		NULL
+#endif
+
 static struct spi_driver lis302dl_spi_driver = {
 	.driver	 = {
 		.name   = DRV_NAME,
@@ -94,6 +120,8 @@ static struct spi_driver lis302dl_spi_driver = {
 	},
 	.probe	= lis302dl_spi_probe,
 	.remove	= __devexit_p(lis302dl_spi_remove),
+	.suspend = lis3lv02d_spi_suspend,
+	.resume  = lis3lv02d_spi_resume,
 };
 
 static int __init lis302dl_init(void)
-- 
1.6.3.1

