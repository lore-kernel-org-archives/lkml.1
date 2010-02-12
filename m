Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756320Ab0BLOtO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 09:49:14 -0500
Received: from lmv.inov.pt ([146.193.64.2]:38333 "EHLO lmv.inov.pt"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755324Ab0BLOtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 09:49:13 -0500
X-Greylist: delayed 857 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Feb 2010 09:49:13 EST
Message-ID: <4B7566E7.8070507@inov.pt>
Date: Fri, 12 Feb 2010 14:34:15 +0000
From: =?ISO-8859-1?Q?Jos=E9_Miguel_Gon=E7alves?= <jose.goncalves@inov.pt>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Marc Pignat <marc.pignat@hevs.ch>, linux-kernel@vger.kernel.org
Subject: [PATCH] adcxx: Fix for single-channel ADCs
Content-Type: multipart/mixed;
 boundary="------------060805040404010709050003"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0.1 (lmv.inov.pt [146.193.64.2]); Fri, 12 Feb 2010 14:34:19 +0000 (WET)
X-INOV-EmailServer-Information: Please contact the Email service provider for more information
X-INOV-EmailServer: Found to be clean
X-INOV-EmailServer-From: jose.goncalves@inov.pt
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060805040404010709050003
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

While testing a ADC121S021 in an embedded board with a S3C2142 SoC (ARM 
core), I have found that the 'adcxx' driver does not handle correctly 
single channel ADCs from this chip family.
For single channel chips you must only issue one read transfer for 
correct measurement.

Regards,
José Gonçalves

--------------060805040404010709050003
Content-Type: text/x-patch;
 name="linux-2.6.git-adcxx1sxxx.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="linux-2.6.git-adcxx1sxxx.patch"

Signed-off-by: Jose Miguel Goncalves <jose.goncalves@inov.pt>

diff --git a/drivers/hwmon/adcxx.c b/drivers/hwmon/adcxx.c
index 5e9e095..e645ce5 100644
--- a/drivers/hwmon/adcxx.c
+++ b/drivers/hwmon/adcxx.c
@@ -62,18 +62,23 @@ static ssize_t adcxx_read(struct device *dev,
 	struct spi_device *spi = to_spi_device(dev);
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct adcxx *adc = dev_get_drvdata(&spi->dev);
-	u8 tx_buf[2] = { attr->index << 3 }; /* other bits are don't care */
+	u8 tx_buf[2];
 	u8 rx_buf[2];
 	int status;
-	int value;
+	u32 value;
 
 	if (mutex_lock_interruptible(&adc->lock))
 		return -ERESTARTSYS;
 
-	status = spi_write_then_read(spi, tx_buf, sizeof(tx_buf),
-					rx_buf, sizeof(rx_buf));
+	if (adc->channels == 1) {
+		status = spi_read(spi, rx_buf, sizeof(rx_buf));
+	} else {
+		tx_buf[0] = attr->index << 3; /* other bits are don't care */
+		status = spi_write_then_read(spi, tx_buf, sizeof(tx_buf),
+						rx_buf, sizeof(rx_buf));
+	}
 	if (status < 0) {
-		dev_warn(dev, "spi_write_then_read failed with status %d\n",
+		dev_warn(dev, "SPI synch. transfer failed with status %d\n",
 				status);
 		goto out;
 	}

--------------060805040404010709050003--
