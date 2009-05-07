Return-Path: <linux-kernel-owner+w=401wt.eu-S1762239AbZEGMZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762239AbZEGMZk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 08:25:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755866AbZEGMZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 08:25:30 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:42520 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbZEGMZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 08:25:29 -0400
Date: Thu, 07 May 2009 14:24:11 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH] [drivers] [SPI] SPI_GPIO: add support for controllers with
 missing MISO pin
To: LKML <linux-kernel@vger.kernel.org>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>
Cc: "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <E4D3F24EA6C9E54F817833EAE0D912AC02243DBF8C@bssrvexch01.BS.local>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: en-US
Content-transfer-encoding: 7BIT
Accept-Language: en-US
Thread-topic: [PATCH] [drivers] [SPI] SPI_GPIO: add support for controllers
 with missing MISO pin
Thread-index: AcnPDro/dNLLs3ilSKSkVf9W2XCLRw==
acceptlanguage: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are some boards that do not strictly follow SPI standard and use only 3 wires (SCLK, MOSI, SS) for connecting some simple auxiliary chips and controls them with GPIO based 'spi controller'. In this configuration the MISO line is missing (it is not required if the chip does not transfer any data back to host). The example of such board is a NCP ARM S3C64XX based machine. This patch adds support for such non-standard configuration in GPIO-based SPI controller.

Reviewed-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>

--- 

diff --git a/drivers/spi/spi_gpio.c b/drivers/spi/spi_gpio.c
index 26bd03e..5b75601 100644
--- a/drivers/spi/spi_gpio.c
+++ b/drivers/spi/spi_gpio.c
@@ -114,7 +114,10 @@ static inline void setmosi(const struct spi_device *spi, int is_on)
 
 static inline int getmiso(const struct spi_device *spi)
 {
-	return !!gpio_get_value(SPI_MISO_GPIO);
+	if (SPI_MISO_GPIO)
+		return !!gpio_get_value(SPI_MISO_GPIO);
+	else
+		return 0;
 }
 
 #undef pdata
@@ -243,9 +246,11 @@ spi_gpio_request(struct spi_gpio_platform_data *pdata, const char *label)
 	if (value)
 		goto done;
 
-	value = spi_gpio_alloc(SPI_MISO_GPIO, label, true);
-	if (value)
-		goto free_mosi;
+	if (SPI_MISO_GPIO) {
+		value = spi_gpio_alloc(SPI_MISO_GPIO, label, true);
+		if (value)
+			goto free_mosi;
+	}
 
 	value = spi_gpio_alloc(SPI_SCK_GPIO, label, false);
 	if (value)
@@ -254,7 +259,8 @@ spi_gpio_request(struct spi_gpio_platform_data *pdata, const char *label)
 	goto done;
 
 free_miso:
-	gpio_free(SPI_MISO_GPIO);
+	if (SPI_MISO_GPIO)
+		gpio_free(SPI_MISO_GPIO);
 free_mosi:
 	gpio_free(SPI_MOSI_GPIO);
 done:
@@ -308,7 +314,8 @@ static int __init spi_gpio_probe(struct platform_device *pdev)
 	if (status < 0) {
 		spi_master_put(spi_gpio->bitbang.master);
 gpio_free:
-		gpio_free(SPI_MISO_GPIO);
+		if (SPI_MISO_GPIO)
+			gpio_free(SPI_MISO_GPIO);
 		gpio_free(SPI_MOSI_GPIO);
 		gpio_free(SPI_SCK_GPIO);
 		spi_master_put(master);
@@ -332,7 +339,8 @@ static int __exit spi_gpio_remove(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, NULL);
 
-	gpio_free(SPI_MISO_GPIO);
+	if (SPI_MISO_GPIO)
+		gpio_free(SPI_MISO_GPIO);
 	gpio_free(SPI_MOSI_GPIO);
 	gpio_free(SPI_SCK_GPIO);

