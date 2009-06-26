Return-Path: <linux-kernel-owner+w=401wt.eu-S1753837AbZFZFiJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837AbZFZFiJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 01:38:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752724AbZFZFh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 01:37:56 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:27887 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbZFZFh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 01:37:56 -0400
Date: Fri, 26 Jun 2009 07:35:57 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH] [drivers] [SPI] SPI_GPIO: add support for controllers without
 MISO or MOSI pin
To: "'LKML'" <linux-kernel@vger.kernel.org>,
       spi-devel-general@lists.sourceforge.net
Cc: "'David Brownell'" <dbrownell@users.sourceforge.net>,
       kyungmin.park@samsung.com, Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <000a01c9f61f$fd7ff3d0$f87fdb70$%szyprowski@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
Thread-index: AcnPDro/dNLLs3ilSKSkVf9W2XCLRw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are some boards that do not strictly follow SPI standard and use
only 3 wires (SCLK, MOSI or MISO, SS) for connecting some simple auxiliary
chips and controls them with GPIO based 'spi controller'. In this
configuration the MISO or MOSI line is missing (it is not required if the
chip does not transfer any data back to host or host only reads data from
chip). The example of such board is a NCP ARM S3C6410 based machine.

This patch adds support for such non-standard configuration in GPIO-based
SPI controller. It also adds 2 flags to indicate that the RX or TX
transactions are not supported. It has been tested in configuration
without MISO pin.

Reviewed-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>



diff --git a/drivers/spi/spi_bitbang.c b/drivers/spi/spi_bitbang.c
index 2a5abc0..fca6646 100644
--- a/drivers/spi/spi_bitbang.c
+++ b/drivers/spi/spi_bitbang.c
@@ -392,6 +392,22 @@ int spi_bitbang_transfer(struct spi_device *spi, struct spi_message *m)
 	unsigned long		flags;
 	int			status = 0;
 
+	if (spi->master->flags & SPI_MASTER_NO_RX) {
+		struct spi_transfer *xfer;
+		list_for_each_entry(xfer, &m->transfers, transfer_list) {
+			if (xfer->rx_buf)
+				return -EINVAL;
+		}
+	}
+
+	if (spi->master->flags & SPI_MASTER_NO_TX) {
+		struct spi_transfer *xfer;
+		list_for_each_entry(xfer, &m->transfers, transfer_list) {
+			if (xfer->tx_buf)
+				return -EINVAL;
+		}
+	}
+
 	m->actual_length = 0;
 	m->status = -EINPROGRESS;
 
diff --git a/drivers/spi/spi_gpio.c b/drivers/spi/spi_gpio.c
index 26bd03e..8b004a0 100644
--- a/drivers/spi/spi_gpio.c
+++ b/drivers/spi/spi_gpio.c
@@ -109,12 +109,16 @@ static inline void setsck(const struct spi_device *spi, int is_on)
 
 static inline void setmosi(const struct spi_device *spi, int is_on)
 {
-	gpio_set_value(SPI_MOSI_GPIO, is_on);
+	if (SPI_MOSI_GPIO != SPI_GPIO_NO_MOSI)
+		gpio_set_value(SPI_MOSI_GPIO, is_on);
 }
 
 static inline int getmiso(const struct spi_device *spi)
 {
-	return !!gpio_get_value(SPI_MISO_GPIO);
+	if (SPI_MISO_GPIO != SPI_GPIO_NO_MISO)
+		return !!gpio_get_value(SPI_MISO_GPIO);
+	else
+		return 0;
 }
 
 #undef pdata
@@ -233,19 +237,30 @@ static int __init spi_gpio_alloc(unsigned pin, const char *label, bool is_in)
 }
 
 static int __init
-spi_gpio_request(struct spi_gpio_platform_data *pdata, const char *label)
+spi_gpio_request(struct spi_gpio_platform_data *pdata, const char *label,
+	u16 *res_flags)
 {
 	int value;
 
 	/* NOTE:  SPI_*_GPIO symbols may reference "pdata" */
 
-	value = spi_gpio_alloc(SPI_MOSI_GPIO, label, false);
-	if (value)
-		goto done;
+	if (SPI_MOSI_GPIO != SPI_GPIO_NO_MOSI) {
+		value = spi_gpio_alloc(SPI_MOSI_GPIO, label, false);
+		if (value)
+			goto done;
+	} else {
+		/* HW configuration without MOSI pin */
+		*res_flags |= SPI_MASTER_NO_TX;
+	}
 
-	value = spi_gpio_alloc(SPI_MISO_GPIO, label, true);
-	if (value)
-		goto free_mosi;
+	if (SPI_MISO_GPIO != SPI_GPIO_NO_MISO) {
+		value = spi_gpio_alloc(SPI_MISO_GPIO, label, true);
+		if (value)
+			goto free_mosi;
+	} else {
+		/* HW configuration without MISO pin */
+		*res_flags |= SPI_MASTER_NO_RX;
+	}
 
 	value = spi_gpio_alloc(SPI_SCK_GPIO, label, false);
 	if (value)
@@ -254,9 +269,11 @@ spi_gpio_request(struct spi_gpio_platform_data *pdata, const char *label)
 	goto done;
 
 free_miso:
-	gpio_free(SPI_MISO_GPIO);
+	if (SPI_MISO_GPIO != SPI_GPIO_NO_MISO)
+		gpio_free(SPI_MISO_GPIO);
 free_mosi:
-	gpio_free(SPI_MOSI_GPIO);
+	if (SPI_MOSI_GPIO != SPI_GPIO_NO_MOSI)
+		gpio_free(SPI_MOSI_GPIO);
 done:
 	return value;
 }
@@ -267,6 +284,7 @@ static int __init spi_gpio_probe(struct platform_device *pdev)
 	struct spi_master		*master;
 	struct spi_gpio			*spi_gpio;
 	struct spi_gpio_platform_data	*pdata;
+	u16 master_flags = 0;
 
 	pdata = pdev->dev.platform_data;
 #ifdef GENERIC_BITBANG
@@ -274,7 +292,7 @@ static int __init spi_gpio_probe(struct platform_device *pdev)
 		return -ENODEV;
 #endif
 
-	status = spi_gpio_request(pdata, dev_name(&pdev->dev));
+	status = spi_gpio_request(pdata, dev_name(&pdev->dev), &master_flags);
 	if (status < 0)
 		return status;
 
@@ -290,6 +308,7 @@ static int __init spi_gpio_probe(struct platform_device *pdev)
 	if (pdata)
 		spi_gpio->pdata = *pdata;
 
+	master->flags = spi_master_flags;
 	master->bus_num = pdev->id;
 	master->num_chipselect = SPI_N_CHIPSEL;
 	master->setup = spi_gpio_setup;
@@ -308,8 +327,10 @@ static int __init spi_gpio_probe(struct platform_device *pdev)
 	if (status < 0) {
 		spi_master_put(spi_gpio->bitbang.master);
 gpio_free:
-		gpio_free(SPI_MISO_GPIO);
-		gpio_free(SPI_MOSI_GPIO);
+		if (SPI_MISO_GPIO != SPI_GPIO_NO_MISO)
+			gpio_free(SPI_MISO_GPIO);
+		if (SPI_MOSI_GPIO != SPI_GPIO_NO_MOSI)
+			gpio_free(SPI_MOSI_GPIO);
 		gpio_free(SPI_SCK_GPIO);
 		spi_master_put(master);
 	}
@@ -332,8 +353,10 @@ static int __exit spi_gpio_remove(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, NULL);
 
-	gpio_free(SPI_MISO_GPIO);
-	gpio_free(SPI_MOSI_GPIO);
+	if (SPI_MISO_GPIO != SPI_GPIO_NO_MISO)
+		gpio_free(SPI_MISO_GPIO);
+	if (SPI_MOSI_GPIO != SPI_GPIO_NO_MOSI)
+		gpio_free(SPI_MOSI_GPIO);
 	gpio_free(SPI_SCK_GPIO);
 
 	return status;
diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
index 934612f..77b06ff 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -251,6 +251,8 @@ struct spi_master {
 	/* other constraints relevant to this driver */
 	u16			flags;
 #define SPI_MASTER_HALF_DUPLEX	BIT(0)		/* can't do full duplex */
+#define SPI_MASTER_NO_RX	BIT(1)		/* can't do buffer read */
+#define SPI_MASTER_NO_TX	BIT(2)		/* can't do buffer write */
 
 	/* Setup mode and clock, etc (spi driver may call many times).
 	 *
diff --git a/include/linux/spi/spi_gpio.h b/include/linux/spi/spi_gpio.h
index ca6782e..369b3d7 100644
--- a/include/linux/spi/spi_gpio.h
+++ b/include/linux/spi/spi_gpio.h
@@ -29,11 +29,16 @@
  * SPI_GPIO_NO_CHIPSELECT to the controller_data:
  *		.controller_data = (void *) SPI_GPIO_NO_CHIPSELECT;
  *
+ * If the MISO or MOSI pin is not available then it should be set to
+ * SPI_GPIO_NO_MISO or SPI_GPIO_NO_MOSI.
+ *
  * If the bitbanged bus is later switched to a "native" controller,
  * that platform_device and controller_data should be removed.
  */
 
 #define SPI_GPIO_NO_CHIPSELECT		((unsigned long)-1l)
+#define SPI_GPIO_NO_MISO		((unsigned long)-1l)
+#define SPI_GPIO_NO_MOSI		((unsigned long)-1l)
 
 /**
  * struct spi_gpio_platform_data - parameter for bitbanged SPI master


