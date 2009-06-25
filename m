Return-Path: <linux-kernel-owner+w=401wt.eu-S1757406AbZFYCD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406AbZFYCD6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 22:03:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753621AbZFYCDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 22:03:51 -0400
Received: from 130.120.124.202.static.snap.net.nz ([202.124.120.130]:44298
	"EHLO hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753038AbZFYCDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 22:03:50 -0400
Message-ID: <4A42DB93.8020503@bluewatersys.com>
Date: Thu, 25 Jun 2009 14:06:11 +1200
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
       spi-devel-general@lists.sourceforge.net, mike@steroidmicros.com,
       linux kernel <linux-kernel@vger.kernel.org>,
       Linus Walleij <linus.ml.walleij@gmail.com>, akpm@linux-foundation.org
Subject: Re: [spi-devel-general] [PATCH] SST25L (non JEDEC) SPI Flash driver
References: <4A3F017B.2010409@bluewatersys.com> <BD79186B4FD85F4B8E60E381CAEE1909019BE1CE@mi8nycmail19.Mi8.com>
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE1909019BE1CE@mi8nycmail19.Mi8.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H Hartley Sweeten wrote:
> On Sunday, June 21, 2009 8:59 PM, Ryan Mallon wrote:
>   
>> Add support for the non JEDEC SST25L SPI Flash devices.
>>
>> Signed-off-by: Andre Renaud <andre@bluewatersys.com>
>> Signed-off-by: Ryan Mallon <ryan@bluewatersys.com>
>>     
>
>   
>> +struct flash_info {
>> +	const char		*name;
>> +	u16			device_id;
>> +	unsigned		page_size;
>> +	unsigned		nr_pages;
>> +	unsigned		erase_size;
>> +};
>> +
>> +#define to_sst25l_flash(x) container_of(x, struct sst25l_flash, mtd)
>> +
>> +static struct flash_info __devinitdata sst25l_flash_info[] = {
>> +	{"sst25lf020a", 0xbf43, 256, 1024, 32 * 1024},
>> +	{"sst25lf040a",	0xbf44,	256, 2048, 32 * 1024},
>> +};
>> +
>>     
>
> Ryan,
>
> I finally got a chance to test this on my hardware.  Previously
> I was using a hacked version on the m25p80 driver to access the
> SST23LF020A on my board.
>
> The driver works fine but you are only supporting the block erase,
> SST25L_CMD_BLOCK_ERASE (opcode 0x52).  The SST25L chips also can do a
> sector erase (opcode 0x20) and a full chip erase (opcode 0x60).
>   
The MTD sub-system doesn't support different types of erases (as far as
I am aware). We chose to use block erases since they are faster than
sector erases and the trade-off of having 32k aligned partitions didn't
seem to bad.
> The full chip erase is not that important but might give a slight
> performance increase on larger devices.  Max block erase time is
> listed as 25ms at 25MHz in the datasheet.  The SST25LF020A contains
> 8 blocks so it's "typical" full chip erase time should be around
> 200ms.  For comparison, the chip erase time is listed as 100ms.
>
> The sector erase is a bigger deal.  On the EDB93xx boards one of the
> SPI flash uses is used to store the MAC address at offset 0x2000 (4K
> offset).  The board can also be configured to boot from offset 0x0000
> in the SPI flash.  
>   
> Without the sector erase this partition setup results in all of the
> partitions being forced read-only.
>   
The updated patch below uses sector erases instead to allow for smaller
partition sizes.

Linus, is this still okay by you?

~Ryan

----
Add support for SST25L (non JEDEC) SPI Flash chips. Although the SSTL25
chips support a quick 32kb block erase, we use the slower 4k sector
erase to allow for smaller 4kb aligned MTD partitions.

Signed-off-by: Andre Renaud <andre@bluewatersys.com>
Signed-off-by: Ryan Mallon <ryan@bluewatersys.com>
----

diff --git a/drivers/mtd/devices/Kconfig b/drivers/mtd/devices/Kconfig
index 325fab9..c222514 100644
--- a/drivers/mtd/devices/Kconfig
+++ b/drivers/mtd/devices/Kconfig
@@ -104,6 +104,16 @@ config M25PXX_USE_FAST_READ
 	help
 	  This option enables FAST_READ access supported by ST M25Pxx.
 
+config MTD_SST25L
+	tristate "Support SST25L (non JEDEC) SPI Flash chips"
+	depends on SPI_MASTER
+	help
+	  This enables access to the non JEDEC SST25L SPI flash chips, used
+	  for program and data storage.
+
+	  Set up your spi devices with the right board-specific platform data,
+	  if you want to specify device partitioning.
+
 config MTD_SLRAM
 	tristate "Uncached system RAM"
 	help
diff --git a/drivers/mtd/devices/Makefile b/drivers/mtd/devices/Makefile
index 0993d5c..ab5c9b9 100644
--- a/drivers/mtd/devices/Makefile
+++ b/drivers/mtd/devices/Makefile
@@ -16,3 +16,4 @@ obj-$(CONFIG_MTD_LART)		+= lart.o
 obj-$(CONFIG_MTD_BLOCK2MTD)	+= block2mtd.o
 obj-$(CONFIG_MTD_DATAFLASH)	+= mtd_dataflash.o
 obj-$(CONFIG_MTD_M25P80)	+= m25p80.o
+obj-$(CONFIG_MTD_SST25L)	+= sst25l.o
diff --git a/drivers/mtd/devices/sst25l.c b/drivers/mtd/devices/sst25l.c
new file mode 100644
index 0000000..777fadf
--- /dev/null
+++ b/drivers/mtd/devices/sst25l.c
@@ -0,0 +1,503 @@
+/*
+ * drivers/mtd/sst25l.c
+ *
+ * Driver for SST25L SPI Flash chips
+ *
+ * Copyright (C) 2009 Bluewater Systems Ltd
+ * Author: Andre Renaud <andre@bluewatersys.com>
+ * Author: Ryan Mallon <ryan@bluewatersys.com>
+ *
+ * Based on m25p80.c
+ *
+ * This code is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/mutex.h>
+#include <linux/interrupt.h>
+
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/partitions.h>
+
+#include <linux/spi/spi.h>
+#include <linux/spi/flash.h>
+
+/* Erases can take up to 3 seconds! */
+#define MAX_READY_WAIT_JIFFIES	msecs_to_jiffies(3000)
+
+#define SST25L_CMD_WRSR		0x01	/* Write status register */
+#define SST25L_CMD_WRDI		0x04	/* Write disable */
+#define SST25L_CMD_RDSR		0x05	/* Read status register */
+#define SST25L_CMD_WREN		0x06	/* Write enable */
+#define SST25L_CMD_READ		0x03	/* High speed read */
+
+#define SST25L_CMD_EWSR		0x50	/* Enable write status register */
+#define SST25L_CMD_SECTOR_ERASE	0x20	/* Erase sector */
+#define SST25L_CMD_READ_ID	0x90	/* Read device ID */
+#define SST25L_CMD_AAI_PROGRAM	0xaf	/* Auto address increment */
+
+#define SST25L_STATUS_BUSY	(1 << 0)	/* Chip is busy */
+#define SST25L_STATUS_WREN	(1 << 1)	/* Write enabled */
+#define SST25L_STATUS_BP0	(1 << 2)	/* Block protection 0 */
+#define SST25L_STATUS_BP1	(1 << 3)	/* Block protection 1 */
+
+struct sst25l_flash {
+	struct spi_device	*spi;
+	struct mutex		lock;
+	struct mtd_info		mtd;
+
+	int 			partitioned;
+};
+
+struct flash_info {
+	const char		*name;
+	u16			device_id;
+	unsigned		page_size;
+	unsigned		nr_pages;
+	unsigned		erase_size;
+};
+
+#define to_sst25l_flash(x) container_of(x, struct sst25l_flash, mtd)
+
+static struct flash_info __initdata sst25l_flash_info[] = {
+	{"sst25lf020a", 0xbf43, 256, 1024, 4096},
+	{"sst25lf040a",	0xbf44,	256, 2048, 4096},
+};
+
+static int sst25l_status(struct sst25l_flash *flash, int *status)
+{
+	u8 command, response;
+	int err;
+
+	command = SST25L_CMD_RDSR;
+	err = spi_write_then_read(flash->spi, &command, 1, &response, 1);
+	if (err < 0)
+		return err;
+
+	*status = response;
+	return 0;
+}
+
+static int sst25l_write_enable(struct sst25l_flash *flash, int enable)
+{
+	u8 command[2];
+	int status, err;
+
+	command[0] = enable ? SST25L_CMD_WREN : SST25L_CMD_WRDI;
+	err = spi_write(flash->spi, command, 1);
+	if (err)
+		return err;
+
+	command[0] = SST25L_CMD_EWSR;
+	err = spi_write(flash->spi, command, 1);
+	if (err)
+		return err;
+
+	command[0] = SST25L_CMD_WRSR;
+	command[1] = enable ? 0 : SST25L_STATUS_BP0 | SST25L_STATUS_BP1;
+	err = spi_write(flash->spi, command, 2);
+	if (err)
+		return err;
+
+	if (enable) {
+		err = sst25l_status(flash, &status);
+		if (err)
+			return err;
+		if (!(status & SST25L_STATUS_WREN))
+			return -EROFS;
+	}
+
+	return 0;
+}
+
+static int sst25l_wait_till_ready(struct sst25l_flash *flash)
+{
+	unsigned long deadline;
+	int status, err;
+
+	deadline = jiffies + MAX_READY_WAIT_JIFFIES;
+	do {
+		err = sst25l_status(flash, &status);
+		if (err)
+			return err;
+		if (!(status & SST25L_STATUS_BUSY))
+			return 0;
+
+		cond_resched();
+	} while (!time_after_eq(jiffies, deadline));
+
+	return -ETIMEDOUT;
+}
+
+static int sst25l_erase_sector(struct sst25l_flash *flash, u32 offset)
+{
+	u8 command[4];
+	int err;
+
+	err = sst25l_write_enable(flash, 1);
+	if (err)
+		return err;
+
+	command[0] = SST25L_CMD_SECTOR_ERASE;
+	command[1] = offset >> 16;
+	command[2] = offset >> 8;
+	command[3] = offset;
+	err = spi_write(flash->spi, command, 4);
+	if (err)
+		return err;
+
+	err = sst25l_wait_till_ready(flash);
+	if (err)
+		return err;
+
+	return sst25l_write_enable(flash, 0);
+}
+
+static int sst25l_erase(struct mtd_info *mtd, struct erase_info *instr)
+{
+	struct sst25l_flash *flash = to_sst25l_flash(mtd);
+	u32 addr, end;
+	int err;
+
+	/* Sanity checks */
+	if (instr->addr + instr->len > flash->mtd.size)
+		return -EINVAL;
+
+	if ((u32)instr->len % mtd->erasesize)
+		return -EINVAL;
+
+	if ((u32)instr->addr % mtd->erasesize)
+		return -EINVAL;
+
+	addr = instr->addr;
+	end = addr + instr->len;
+
+	mutex_lock(&flash->lock);
+
+	err = sst25l_wait_till_ready(flash);
+	if (err)
+		return err;
+
+	while (addr < end) {
+		err = sst25l_erase_sector(flash, addr);
+		if (err) {
+			mutex_unlock(&flash->lock);
+			instr->state = MTD_ERASE_FAILED;
+			dev_err(&flash->spi->dev, "Erase failed\n");
+			return err;
+		}
+
+		addr += mtd->erasesize;
+	}
+
+	mutex_unlock(&flash->lock);
+
+	instr->state = MTD_ERASE_DONE;
+	mtd_erase_callback(instr);
+	return 0;
+}
+
+static int sst25l_read(struct mtd_info *mtd, loff_t from, size_t len,
+		       size_t *retlen, u_char *buf)
+{
+	struct sst25l_flash *flash = to_sst25l_flash(mtd);
+	struct spi_transfer transfer[2];
+	struct spi_message message;
+	u8 command[4];
+	int ret;
+
+	/* Sanity checking */
+	if (len == 0)
+		return 0;
+
+	if (from + len > flash->mtd.size)
+		return -EINVAL;
+
+	if (retlen)
+		*retlen = 0;
+
+	spi_message_init(&message);
+	memset(&transfer, 0, sizeof(transfer));
+
+	command[0] = SST25L_CMD_READ;
+	command[1] = from >> 16;
+	command[2] = from >> 8;
+	command[3] = from;
+
+	transfer[0].tx_buf = command;
+	transfer[0].len = sizeof(command);
+	spi_message_add_tail(&transfer[0], &message);
+
+	transfer[1].rx_buf = buf;
+	transfer[1].len = len;
+	spi_message_add_tail(&transfer[1], &message);
+
+	mutex_lock(&flash->lock);
+
+	/* Wait for previous write/erase to complete */
+	ret = sst25l_wait_till_ready(flash);
+	if (ret) {
+		mutex_unlock(&flash->lock);
+		return ret;
+	}
+
+	spi_sync(flash->spi, &message);
+
+	if (retlen && message.actual_length > sizeof(command))
+		*retlen += message.actual_length - sizeof(command);
+
+	mutex_unlock(&flash->lock);
+	return 0;
+}
+
+static int sst25l_write(struct mtd_info *mtd, loff_t to, size_t len,
+			size_t *retlen, const u_char *buf)
+{
+	struct sst25l_flash *flash = to_sst25l_flash(mtd);
+	int i, j, ret, bytes, copied = 0;
+	u8 command[5];
+
+	/* Sanity checks */
+	if (!len)
+		return 0;
+
+	if (to + len > flash->mtd.size)
+		return -EINVAL;
+
+	if ((u32)to % mtd->writesize)
+		return -EINVAL;
+
+	mutex_lock(&flash->lock);
+
+	ret = sst25l_write_enable(flash, 1);
+	if (ret)
+		goto out;
+
+	for (i = 0; i < len; i += mtd->writesize) {
+		ret = sst25l_wait_till_ready(flash);
+		if (ret)
+			goto out;
+
+		/* Write the first byte of the page */
+		command[0] = SST25L_CMD_AAI_PROGRAM;
+		command[1] = (to + i) >> 16;
+		command[2] = (to + i) >> 8;
+		command[3] = (to + i);
+		command[4] = buf[i];
+		ret = spi_write(flash->spi, command, 5);
+		if (ret < 0)
+			goto out;
+		copied++;
+
+		/*
+		 * Write the remaining bytes using auto address
+		 * increment mode
+		 */
+		bytes = min(mtd->writesize, (u32)(len - i));
+		for (j = 1; j < bytes; j++, copied++) {
+			ret = sst25l_wait_till_ready(flash);
+			if (ret)
+				goto out;
+
+			command[1] = buf[i + j];
+			ret = spi_write(flash->spi, command, 2);
+			if (ret)
+				goto out;
+		}
+	}
+
+out:
+	ret = sst25l_write_enable(flash, 0);
+
+	if (retlen)
+		*retlen = copied;
+
+	mutex_unlock(&flash->lock);
+	return ret;
+}
+
+static struct flash_info *__init sst25l_match_device(struct spi_device *spi)
+{
+	struct flash_info *flash_info = NULL;
+	u8 command[4], response;
+	int i, err;
+	u16 id;
+
+	command[0] = SST25L_CMD_READ_ID;
+	command[1] = 0;
+	command[2] = 0;
+	command[3] = 0;
+	err = spi_write_then_read(spi, command, sizeof(command), &response, 1);
+	if (err < 0) {
+		dev_err(&spi->dev, "error reading device id msb\n");
+		return NULL;
+	}
+
+	id = response << 8;
+
+	command[0] = SST25L_CMD_READ_ID;
+	command[1] = 0;
+	command[2] = 0;
+	command[3] = 1;
+	err = spi_write_then_read(spi, command, sizeof(command), &response, 1);
+	if (err < 0) {
+		dev_err(&spi->dev, "error reading device id lsb\n");
+		return NULL;
+	}
+
+	id |= response;
+
+	for (i = 0; i < ARRAY_SIZE(sst25l_flash_info); i++)
+		if (sst25l_flash_info[i].device_id == id)
+			flash_info = &sst25l_flash_info[i];
+
+	if (!flash_info)
+		dev_err(&spi->dev, "unknown id %.4x\n", id);
+
+	return flash_info;
+}
+
+static int __init sst25l_probe(struct spi_device *spi)
+{
+	struct flash_info *flash_info;
+	struct sst25l_flash *flash;
+	struct flash_platform_data *data;
+	int i;
+
+	flash_info = sst25l_match_device(spi);
+	if (!flash_info)
+		return -ENODEV;
+
+	flash = kzalloc(sizeof(struct sst25l_flash), GFP_KERNEL);
+	if (!flash)
+		return -ENOMEM;
+
+	flash->spi = spi;
+	mutex_init(&flash->lock);
+	dev_set_drvdata(&spi->dev, flash);
+
+	data = spi->dev.platform_data;
+	if (data && data->name)
+		flash->mtd.name = data->name;
+	else
+		flash->mtd.name = dev_name(&spi->dev);
+
+	flash->mtd.type		= MTD_NORFLASH;
+	flash->mtd.flags	= MTD_CAP_NORFLASH;
+	flash->mtd.erasesize	= flash_info->erase_size;
+	flash->mtd.writesize	= flash_info->page_size;
+	flash->mtd.size		= flash_info->page_size * flash_info->nr_pages;
+	flash->mtd.erase	= sst25l_erase;
+	flash->mtd.read		= sst25l_read;
+	flash->mtd.write 	= sst25l_write;
+
+	dev_info(&spi->dev, "%s (%lld Kbytes)\n", flash_info->name,
+		 (long long)flash->mtd.size >> 10);
+
+	DEBUG(MTD_DEBUG_LEVEL2,
+	      "mtd .name = %s, .size = 0x%llx (%lldMiB) "
+	      ".erasesize = 0x%.8x (%uKiB) .numeraseregions = %d\n",
+	      flash->mtd.name,
+	      (long long)flash->mtd.size, (long long)(flash->mtd.size >> 20),
+	      flash->mtd.erasesize, flash->mtd.erasesize / 1024,
+	      flash->mtd.numeraseregions);
+
+	if (flash->mtd.numeraseregions)
+		for (i = 0; i < flash->mtd.numeraseregions; i++)
+			DEBUG(MTD_DEBUG_LEVEL2,
+			      "mtd.eraseregions[%d] = { .offset = 0x%llx, "
+			      ".erasesize = 0x%.8x (%uKiB), "
+			      ".numblocks = %d }\n",
+			      i, (long long)flash->mtd.eraseregions[i].offset,
+			      flash->mtd.eraseregions[i].erasesize,
+			      flash->mtd.eraseregions[i].erasesize / 1024,
+			      flash->mtd.eraseregions[i].numblocks);
+
+	if (mtd_has_partitions()) {
+		struct mtd_partition *parts = NULL;
+		int nr_parts = 0;
+
+		if (mtd_has_cmdlinepart()) {
+			static const char *part_probes[] =
+				{"cmdlinepart", NULL};
+
+			nr_parts = parse_mtd_partitions(&flash->mtd,
+							part_probes,
+							&parts, 0);
+		}
+
+		if (nr_parts <= 0 && data && data->parts) {
+			parts = data->parts;
+			nr_parts = data->nr_parts;
+		}
+
+		if (nr_parts > 0) {
+			for (i = 0; i < nr_parts; i++) {
+				DEBUG(MTD_DEBUG_LEVEL2, "partitions[%d] = "
+				      "{.name = %s, .offset = 0x%llx, "
+				      ".size = 0x%llx (%lldKiB) }\n",
+				      i, parts[i].name,
+				      (long long)parts[i].offset,
+				      (long long)parts[i].size,
+				      (long long)(parts[i].size >> 10));
+			}
+
+			flash->partitioned = 1;
+			return add_mtd_partitions(&flash->mtd,
+						  parts, nr_parts);
+		}
+
+	} else if (data->nr_parts) {
+		dev_warn(&spi->dev, "ignoring %d default partitions on %s\n",
+			 data->nr_parts, data->name);
+	}
+
+	return add_mtd_device(&flash->mtd) == 1 ? -ENODEV : 0;
+}
+
+static int __exit sst25l_remove(struct spi_device *spi)
+{
+	struct sst25l_flash *flash = dev_get_drvdata(&spi->dev);
+	int ret;
+
+	if (mtd_has_partitions() && flash->partitioned)
+		ret = del_mtd_partitions(&flash->mtd);
+	else
+		ret = del_mtd_device(&flash->mtd);
+	if (ret == 0)
+		kfree(flash);
+	return ret;
+}
+
+static struct spi_driver sst25l_driver = {
+	.driver = {
+		.name	= "sst25l",
+		.bus	= &spi_bus_type,
+		.owner	= THIS_MODULE,
+	},
+	.probe		= sst25l_probe,
+	.remove		= __exit_p(sst25l_remove),
+};
+
+static int __init sst25l_init(void)
+{
+	return spi_register_driver(&sst25l_driver);
+}
+
+static void __exit sst25l_exit(void)
+{
+	spi_unregister_driver(&sst25l_driver);
+}
+
+module_init(sst25l_init);
+module_exit(sst25l_exit);
+
+MODULE_DESCRIPTION("MTD SPI driver for SST25L Flash chips");
+MODULE_AUTHOR("Andre Renaud <andre@bluewatersys.com>, "
+	      "Ryan Mallon <ryan@bluewatersys.com>");
+MODULE_LICENSE("GPL");


