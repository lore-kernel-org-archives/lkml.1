Return-Path: <linux-kernel-owner+w=401wt.eu-S1757198AbZFYDFD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198AbZFYDFD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 23:05:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751848AbZFYDEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 23:04:54 -0400
Received: from 130.120.124.202.static.snap.net.nz ([202.124.120.130]:46146
	"EHLO hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751548AbZFYDEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 23:04:53 -0400
Message-ID: <4A42E9E5.60802@bluewatersys.com>
Date: Thu, 25 Jun 2009 15:07:17 +1200
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linus Walleij <linus.ml.walleij@gmail.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       spi-devel-general@lists.sourceforge.net,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] SST25L (non JEDEC) SPI Flash driver
References: <4A42BDF3.10901@bluewatersys.com> <20090624194005.2f9574ce.akpm@linux-foundation.org>
In-Reply-To: <20090624194005.2f9574ce.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 25 Jun 2009 11:59:47 +1200 Ryan Mallon <ryan@bluewatersys.com> wrote:
>
>   
>> Add support for the non JEDEC SST25L SPI Flash devices.
>>
>> Signed-off-by: Andre Renaud <andre@bluewatersys.com>
>> Signed-off-by: Ryan Mallon <ryan@bluewatersys.com>
>> Acked-by: Linus Walleij <linus.walleij@stericsson.com>
>>     
>
> It looks OK to my inexperienced eye.
>
>   
Cool, thanks for picking this up. The patch below fixes the two issues
you pointed out. It will apply on top of
mtd-sst25l-non-jedec-spi-flash-driver-update.patch

----
Fix two issues in the SSTL25 driver:
- Replace min() plus u32 cast with min_t
- Fix memory leak on failed add_mtd_device

Signed-off-by: Ryan Mallon <ryan@bluewatersys.com>
----

diff --git a/drivers/mtd/devices/sst25l.c b/drivers/mtd/devices/sst25l.c
index 777fadf..d235067 100644
--- a/drivers/mtd/devices/sst25l.c
+++ b/drivers/mtd/devices/sst25l.c
@@ -298,7 +298,7 @@ static int sst25l_write(struct mtd_info *mtd, loff_t to, size_t len,
 		 * Write the remaining bytes using auto address
 		 * increment mode
 		 */
-		bytes = min(mtd->writesize, (u32)(len - i));
+		bytes = min_t(u32, mtd->writesize, len - i);
 		for (j = 1; j < bytes; j++, copied++) {
 			ret = sst25l_wait_till_ready(flash);
 			if (ret)
@@ -367,7 +367,7 @@ static int __init sst25l_probe(struct spi_device *spi)
 	struct flash_info *flash_info;
 	struct sst25l_flash *flash;
 	struct flash_platform_data *data;
-	int i;
+	int ret, i;
 
 	flash_info = sst25l_match_device(spi);
 	if (!flash_info)
@@ -457,7 +457,14 @@ static int __init sst25l_probe(struct spi_device *spi)
 			 data->nr_parts, data->name);
 	}
 
-	return add_mtd_device(&flash->mtd) == 1 ? -ENODEV : 0;
+	ret = add_mtd_device(&flash->mtd);
+	if (ret == 1) {
+		kfree(flash);
+		dev_set_drvdata(&spi->dev, NULL);
+		return -ENODEV;
+	}
+	
+	return 0;
 }
 
 static int __exit sst25l_remove(struct spi_device *spi)

