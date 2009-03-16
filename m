Return-Path: <linux-kernel-owner+w=401wt.eu-S1762103AbZCPVha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762103AbZCPVha (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 17:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760556AbZCPVge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 17:36:34 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:43383 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760871AbZCPVgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 17:36:33 -0400
From: Kevin Hilman <khilman@deeprootsystems.com>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Kevin Hilman <khilman@deeprootsystems.com>
Subject: [PATCH v3 3/3] Implement the new memory_accessor interfaces for SPI EEPROMs:
Date: Mon, 16 Mar 2009 14:36:19 -0700
Message-Id: <1237239379-24186-4-git-send-email-khilman@deeprootsystems.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1237239379-24186-3-git-send-email-khilman@deeprootsystems.com>
References: <1237239379-24186-1-git-send-email-khilman@deeprootsystems.com>
 <1237239379-24186-2-git-send-email-khilman@deeprootsystems.com>
 <1237239379-24186-3-git-send-email-khilman@deeprootsystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

From: David Brownell <dbrownell@users.sourceforge.net>

 - Define new setup() hook to export the accessor
 - Implement accessor methods

Moves some error checking out of the sysfs interface code
into the layer below it, which is now shared by both sysfs
and memory access code.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
---
 drivers/misc/eeprom/at25.c |   58 +++++++++++++++++++++++++++++++++----------
 include/linux/spi/eeprom.h |    6 ++++
 2 files changed, 50 insertions(+), 14 deletions(-)

diff --git a/drivers/misc/eeprom/at25.c b/drivers/misc/eeprom/at25.c
index 290dbe9..6bc0dac 100644
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
 
@@ -127,13 +135,6 @@ at25_bin_read(struct kobject *kobj, struct bin_attribute *bin_attr,
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
 
@@ -146,6 +147,13 @@ at25_ee_write(struct at25_data *at25, char *buf, loff_t off, size_t count)
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
@@ -253,18 +261,31 @@ at25_bin_write(struct kobject *kobj, struct bin_attribute *bin_attr,
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
@@ -317,6 +338,10 @@ static int at25_probe(struct spi_device *spi)
 	at25->addrlen = addrlen;
 
 	/* Export the EEPROM bytes through sysfs, since that's convenient.
+	 * And maybe to other kernel code; it might hold a board's Ethernet
+	 * address, or board-specific calibration data generated on the
+	 * manufacturing floor.
+	 *
 	 * Default to root-only access to the data; EEPROMs often hold data
 	 * that's sensitive for read and/or write, like ethernet addresses,
 	 * security codes, board-specific manufacturing calibrations, etc.
@@ -324,17 +349,22 @@ static int at25_probe(struct spi_device *spi)
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
diff --git a/include/linux/spi/eeprom.h b/include/linux/spi/eeprom.h
index 1085212..306e7b1 100644
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
-- 
1.6.1.3

