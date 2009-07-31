Return-Path: <linux-kernel-owner+w=401wt.eu-S1752032AbZGaAlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbZGaAlJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 20:41:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751858AbZGaAlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 20:41:07 -0400
Received: from ru.mvista.com ([213.79.90.228]:33298 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751469AbZGaAlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 20:41:03 -0400
Date: Fri, 31 Jul 2009 04:41:03 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ben Dooks <ben@fluff.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       David Woodhouse <dwmw2@infradead.org>,
       Grant Likely <grant.likely@secretlab.ca>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jean Delvare <khali@linux-fr.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       linuxppc-dev@ozlabs.org
Subject: [PATCH 4/6] hwmon: adxx: Convert to device table matching
Message-ID: <20090731004103.GD8371@oksana.dev.rtsoft.ru>
References: <20090731003957.GA23982@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090731003957.GA23982@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the code a little bit nicer, and shorter.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/hwmon/adcxx.c |  101 ++++++++-----------------------------------------
 1 files changed, 16 insertions(+), 85 deletions(-)

diff --git a/drivers/hwmon/adcxx.c b/drivers/hwmon/adcxx.c
index 242294d..5e9e095 100644
--- a/drivers/hwmon/adcxx.c
+++ b/drivers/hwmon/adcxx.c
@@ -43,6 +43,7 @@
 #include <linux/hwmon.h>
 #include <linux/hwmon-sysfs.h>
 #include <linux/mutex.h>
+#include <linux/mod_devicetable.h>
 #include <linux/spi/spi.h>
 
 #define DRVNAME		"adcxx"
@@ -157,8 +158,9 @@ static struct sensor_device_attribute ad_input[] = {
 
 /*----------------------------------------------------------------------*/
 
-static int __devinit adcxx_probe(struct spi_device *spi, int channels)
+static int __devinit adcxx_probe(struct spi_device *spi)
 {
+	int channels = spi_get_device_id(spi)->driver_data;
 	struct adcxx *adc;
 	int status;
 	int i;
@@ -204,26 +206,6 @@ out_err:
 	return status;
 }
 
-static int __devinit adcxx1s_probe(struct spi_device *spi)
-{
-	return adcxx_probe(spi, 1);
-}
-
-static int __devinit adcxx2s_probe(struct spi_device *spi)
-{
-	return adcxx_probe(spi, 2);
-}
-
-static int __devinit adcxx4s_probe(struct spi_device *spi)
-{
-	return adcxx_probe(spi, 4);
-}
-
-static int __devinit adcxx8s_probe(struct spi_device *spi)
-{
-	return adcxx_probe(spi, 8);
-}
-
 static int __devexit adcxx_remove(struct spi_device *spi)
 {
 	struct adcxx *adc = dev_get_drvdata(&spi->dev);
@@ -241,79 +223,33 @@ static int __devexit adcxx_remove(struct spi_device *spi)
 	return 0;
 }
 
-static struct spi_driver adcxx1s_driver = {
-	.driver = {
-		.name	= "adcxx1s",
-		.owner	= THIS_MODULE,
-	},
-	.probe	= adcxx1s_probe,
-	.remove	= __devexit_p(adcxx_remove),
+static const struct spi_device_id adcxx_ids[] = {
+	{ "adcxx1s", 1 },
+	{ "adcxx2s", 2 },
+	{ "adcxx4s", 4 },
+	{ "adcxx8s", 8 },
+	{ },
 };
+MODULE_DEVICE_TABLE(spi, adcxx_ids);
 
-static struct spi_driver adcxx2s_driver = {
+static struct spi_driver adcxx_driver = {
 	.driver = {
-		.name	= "adcxx2s",
+		.name	= "adcxx",
 		.owner	= THIS_MODULE,
 	},
-	.probe	= adcxx2s_probe,
-	.remove	= __devexit_p(adcxx_remove),
-};
-
-static struct spi_driver adcxx4s_driver = {
-	.driver = {
-		.name	= "adcxx4s",
-		.owner	= THIS_MODULE,
-	},
-	.probe	= adcxx4s_probe,
-	.remove	= __devexit_p(adcxx_remove),
-};
-
-static struct spi_driver adcxx8s_driver = {
-	.driver = {
-		.name	= "adcxx8s",
-		.owner	= THIS_MODULE,
-	},
-	.probe	= adcxx8s_probe,
+	.id_table = adcxx_ids,
+	.probe	= adcxx_probe,
 	.remove	= __devexit_p(adcxx_remove),
 };
 
 static int __init init_adcxx(void)
 {
-	int status;
-	status = spi_register_driver(&adcxx1s_driver);
-	if (status)
-		goto reg_1_failed;
-
-	status = spi_register_driver(&adcxx2s_driver);
-	if (status)
-		goto reg_2_failed;
-
-	status = spi_register_driver(&adcxx4s_driver);
-	if (status)
-		goto reg_4_failed;
-
-	status = spi_register_driver(&adcxx8s_driver);
-	if (status)
-		goto reg_8_failed;
-
-	return status;
-
-reg_8_failed:
-	spi_unregister_driver(&adcxx4s_driver);
-reg_4_failed:
-	spi_unregister_driver(&adcxx2s_driver);
-reg_2_failed:
-	spi_unregister_driver(&adcxx1s_driver);
-reg_1_failed:
-	return status;
+	return spi_register_driver(&adcxx_driver);
 }
 
 static void __exit exit_adcxx(void)
 {
-	spi_unregister_driver(&adcxx1s_driver);
-	spi_unregister_driver(&adcxx2s_driver);
-	spi_unregister_driver(&adcxx4s_driver);
-	spi_unregister_driver(&adcxx8s_driver);
+	spi_unregister_driver(&adcxx_driver);
 }
 
 module_init(init_adcxx);
@@ -322,8 +258,3 @@ module_exit(exit_adcxx);
 MODULE_AUTHOR("Marc Pignat");
 MODULE_DESCRIPTION("National Semiconductor adcxx8sxxx Linux driver");
 MODULE_LICENSE("GPL");
-
-MODULE_ALIAS("adcxx1s");
-MODULE_ALIAS("adcxx2s");
-MODULE_ALIAS("adcxx4s");
-MODULE_ALIAS("adcxx8s");
-- 
1.6.3.3

