Return-Path: <linux-kernel-owner+w=401wt.eu-S1757451AbZCFWOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757451AbZCFWOg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 17:14:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756222AbZCFWOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 17:14:08 -0500
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:34227 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755868AbZCFWOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 17:14:05 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=47V0ORj5NEzj76Uu+RaOjEuPqddpcD0FbjOyWBM/yKDMhOfLz7ZW/Wjx3loNEIbr2+PAf1XySBWGJoa4k61Jr7sCzq+1i+IT0cX2hPbW1hymCiUPfzT/Qz9tPJG0cYlvu/5lZHLwA3Qxe/TYzSMmqe9bl7pDRqa77iL4sz0huOM=  ;
X-YMail-OSG: 1TxXLEUVM1mCvv5L1TLp4IPVN52GzYUcTpSF5x5ESAZM.wN9J1eGk9jRpe.LmRYcIECHt_Jj.q0bIosonwoDqeSHnFgullEDuiRoVWu4AqLSovdGpC1Ozc9VycJJGIQTBlT04hXEkZn9JpDfslcIvdFjgRuzBvB5_BZRnIuTHSQiYQPen1X2WBiGXx1a8l60G2ufx9bLXgJgM9cGUgjAJOy2FTsZFg--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Kevin Hilman <khilman@deeprootsystems.com>
Subject: Re: [PATCH] eeprom: add kernel interface for reading/writing persistent memory
Date: Fri, 6 Mar 2009 14:14:01 -0800
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
References: <1236281608-18063-1-git-send-email-khilman@deeprootsystems.com>
In-Reply-To: <1236281608-18063-1-git-send-email-khilman@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903061414.01500.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Implement the new memory_accessor interfaces for SPI EEPROMs:

 - Define new setup() hook to export the accessor
 - Implement accessor methods

Moves some error checking out of the sysfs interface code
into the layer below it, which is now shared by both sysfs
and memory access code.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
Can't have this only for I2C ... SPI may need it too.  :)

 drivers/misc/eeprom/at25.c |   58 ++++++++++++++++++++++++++++++++-----------
 include/linux/spi/eeprom.h |    6 ++++
 2 files changed, 50 insertions(+), 14 deletions(-)

--- a/drivers/misc/eeprom/at25.c
+++ b/drivers/misc/eeprom/at25.c
@@ -30,6 +30,7 @@
 
 struct at25_data {
 	struct spi_device	*spi;
+	struct memory_accessor	mem;
 	struct mutex		lock;
 	struct spi_eeprom	chip;
 	struct bin_attribute	bin;
@@ -75,6 +76,13 @@ at25_ee_read(
 	struct spi_transfer	t[2];
 	struct spi_message	m;
 
+	if (unlikely(offset >= at25->bin.size))
+		return 0;
+	if ((offset + count) > at25->bin.size)
+		count = at25->bin.size - offset;
+	if (unlikely(!count))
+		return count;
+
 	cp = command;
 	*cp++ = AT25_READ;
 
@@ -127,13 +135,6 @@ at25_bin_read(struct kobject *kobj, stru
 	dev = container_of(kobj, struct device, kobj);
 	at25 = dev_get_drvdata(dev);
 
-	if (unlikely(off >= at25->bin.size))
-		return 0;
-	if ((off + count) > at25->bin.size)
-		count = at25->bin.size - off;
-	if (unlikely(!count))
-		return count;
-
 	return at25_ee_read(at25, buf, off, count);
 }
 
@@ -146,6 +147,13 @@ at25_ee_write(struct at25_data *at25, ch
 	unsigned		buf_size;
 	u8			*bounce;
 
+	if (unlikely(off >= at25->bin.size))
+		return -EFBIG;
+	if ((off + count) > at25->bin.size)
+		count = at25->bin.size - off;
+	if (unlikely(!count))
+		return count;
+
 	/* Temp buffer starts with command and address */
 	buf_size = at25->chip.page_size;
 	if (buf_size > io_limit)
@@ -253,18 +261,31 @@ at25_bin_write(struct kobject *kobj, str
 	dev = container_of(kobj, struct device, kobj);
 	at25 = dev_get_drvdata(dev);
 
-	if (unlikely(off >= at25->bin.size))
-		return -EFBIG;
-	if ((off + count) > at25->bin.size)
-		count = at25->bin.size - off;
-	if (unlikely(!count))
-		return count;
-
 	return at25_ee_write(at25, buf, off, count);
 }
 
 /*-------------------------------------------------------------------------*/
 
+/* Let in-kernel code access the eeprom data. */
+
+static ssize_t at25_mem_read(struct memory_accessor *mem, char *buf,
+			 off_t offset, size_t count)
+{
+	struct at25_data *at25 = container_of(mem, struct at25_data, mem);
+
+	return at25_ee_read(at25, buf, offset, count);
+}
+
+static ssize_t at25_mem_write(struct memory_accessor *mem, char *buf,
+			  off_t offset, size_t count)
+{
+	struct at25_data *at25 = container_of(mem, struct at25_data, mem);
+
+	return at25_ee_write(at25, buf, offset, count);
+}
+
+/*-------------------------------------------------------------------------*/
+
 static int at25_probe(struct spi_device *spi)
 {
 	struct at25_data	*at25 = NULL;
@@ -317,6 +338,10 @@ static int at25_probe(struct spi_device 
 	at25->addrlen = addrlen;
 
 	/* Export the EEPROM bytes through sysfs, since that's convenient.
+	 * And maybe to other kernel code; it might hold a board's Ethernet
+	 * address, or board-specific calibration data generated on the
+	 * manufacturing floor.
+	 *
 	 * Default to root-only access to the data; EEPROMs often hold data
 	 * that's sensitive for read and/or write, like ethernet addresses,
 	 * security codes, board-specific manufacturing calibrations, etc.
@@ -324,17 +349,22 @@ static int at25_probe(struct spi_device 
 	at25->bin.attr.name = "eeprom";
 	at25->bin.attr.mode = S_IRUSR;
 	at25->bin.read = at25_bin_read;
+	at25->mem.read = at25_mem_read;
 
 	at25->bin.size = at25->chip.byte_len;
 	if (!(chip->flags & EE_READONLY)) {
 		at25->bin.write = at25_bin_write;
 		at25->bin.attr.mode |= S_IWUSR;
+		at25->mem.write = at25_mem_write;
 	}
 
 	err = sysfs_create_bin_file(&spi->dev.kobj, &at25->bin);
 	if (err)
 		goto fail;
 
+	if (chip->setup)
+		chip->setup(&at25->mem, chip->context);
+
 	dev_info(&spi->dev, "%Zd %s %s eeprom%s, pagesize %u\n",
 		(at25->bin.size < 1024)
 			? at25->bin.size
--- a/include/linux/spi/eeprom.h
+++ b/include/linux/spi/eeprom.h
@@ -1,6 +1,8 @@
 #ifndef __LINUX_SPI_EEPROM_H
 #define __LINUX_SPI_EEPROM_H
 
+#include <linux/memory.h>
+
 /*
  * Put one of these structures in platform_data for SPI EEPROMS handled
  * by the "at25" driver.  On SPI, most EEPROMS understand the same core
@@ -17,6 +19,10 @@ struct spi_eeprom {
 #define	EE_ADDR2	0x0002			/* 16 bit addrs */
 #define	EE_ADDR3	0x0004			/* 24 bit addrs */
 #define	EE_READONLY	0x0008			/* disallow writes */
+
+	/* for exporting this chip's data to other kernel code */
+	void (*setup)(struct memory_accessor *mem, void *context);
+	void *context;
 };
 
 #endif /* __LINUX_SPI_EEPROM_H */
