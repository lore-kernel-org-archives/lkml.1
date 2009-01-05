Return-Path: <linux-kernel-owner+w=401wt.eu-S1753670AbZAEJbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670AbZAEJbS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 04:31:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752076AbZAEJbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 04:31:06 -0500
Received: from yw-out-2324.google.com ([74.125.46.28]:53160 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbZAEJbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 04:31:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=WPsu5wman/1Krovl4ZaezacpksQPcH1wo/+L/h3cfaZ6hai7W27kWHFkNi+Oyh9ci4
         YaIgaYHjQIjhsQx+D6ERV/zh/3xNYVxJO90czIbAO37TFeFkkeGpVIflAVdQC1tqYluI
         qkVaTHCwepbdeUKoNmQ4JNr3I4y/p/pkUE4pI=
Message-ID: <57afda040901050130n1f102dd4u40e0b642294f42bc@mail.gmail.com>
Date: Mon, 5 Jan 2009 18:30:57 +0900
From: "unsik Kim" <donari75@gmail.com>
To: "Heikki Orsila" <shdl@zakalwe.fi>
Subject: Re: [PATCH] mflash linux support
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <20090105023346.GE6115@zakalwe.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <57afda040901041718g1415e210hfd0991270dfdd72d@mail.gmail.com>
	 <20090105023346.GE6115@zakalwe.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You are right. I fixed style issues.

Thanks a lot.

following is new patches.

Signed-off-by: unsik Kim <donari75@gmail.com>
---
6	0	drivers/block/Kconfig
2	0	drivers/block/Makefile
923	0	drivers/block/mg_disk.c
174	0	include/linux/mg_disk.h
 drivers/block/Kconfig   |    6 +
 drivers/block/Makefile  |    2 +
 drivers/block/mg_disk.c |  923 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mg_disk.h |  174 +++++++++
 4 files changed, 1105 insertions(+), 0 deletions(-)

diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index 0344a8a..cad48c8 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -403,6 +403,12 @@ config ATA_OVER_ETH
 	This driver provides Support for ATA over Ethernet block
 	devices like the Coraid EtherDrive (R) Storage Blade.

+config MG_DISK
+	tristate "mGine mflash, gflash support"
+	depends on ARM
+	help
+	  mGine mFlash(gFlash) block device driver
+
 config SUNVDC
 	tristate "Sun Virtual Disk Client support"
 	depends on SUN_LDOMS
diff --git a/drivers/block/Makefile b/drivers/block/Makefile
index 204332b..1694d45 100644
--- a/drivers/block/Makefile
+++ b/drivers/block/Makefile
@@ -32,3 +32,5 @@ obj-$(CONFIG_BLK_DEV_UB)	+= ub.o
 obj-$(CONFIG_BLK_DEV_HD)	+= hd.o

 obj-$(CONFIG_XEN_BLKDEV_FRONTEND)	+= xen-blkfront.o
+
+obj-$(CONFIG_MG_DISK)	+= mg_disk.o
diff --git a/drivers/block/mg_disk.c b/drivers/block/mg_disk.c
new file mode 100644
index 0000000..24edc9a
--- /dev/null
+++ b/drivers/block/mg_disk.c
@@ -0,0 +1,923 @@
+/*
+ *  drivers/block/mg_disk.c
+ *
+ *  Support for the mGine m[g]flash IO mode.
+ *  Based on legacy hd.c
+ *
+ * (c) 2008 mGine Co.,LTD
+ * (c) 2008 unsik Kim <donari75@gmail.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/blkdev.h>
+#include <linux/hdreg.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/mg_disk.h>
+
+static void mg_request(struct request_queue *);
+
+static void mg_dump_status(const char *msg, unsigned int stat, struct
mg_host *host)
+{
+	char *name = MG_DISK_NAME"?";
+	struct request *req;
+
+	if (host->breq) {
+		req = elv_next_request(host->breq);
+		if (req)
+			name = req->rq_disk->disk_name;
+	}
+
+	printk("%s: %s: status=0x%02x { ", name, msg, stat & 0xff);
+	if (stat & MG_REG_STATUS_BIT_BUSY)
+		printk("Busy ");
+	if (stat & MG_REG_STATUS_BIT_READY)
+		printk("DriveReady ");
+	if (stat & MG_REG_STATUS_BIT_WRITE_FAULT)
+		printk("WriteFault ");
+	if (stat & MG_REG_STATUS_BIT_SEEK_DONE)
+		printk("SeekComplete ");
+	if (stat & MG_REG_STATUS_BIT_DATA_REQ)
+		printk("DataRequest ");
+	if (stat & MG_REG_STATUS_BIT_CORRECTED_ERROR)
+		printk("CorrectedError ");
+	if (stat & MG_REG_STATUS_BIT_ERROR)
+		printk("Error ");
+	printk("}\n");
+	if ((stat & MG_REG_STATUS_BIT_ERROR) == 0) {
+		host->error = 0;
+	} else {
+		host->error = inb(host->dev_base + MG_REG_ERROR);
+		printk("%s: %s: error=0x%02x { ", name, msg, host->error & 0xff);
+		if (host->error & MG_REG_ERR_BBK)
+			printk("BadSector ");
+		if (host->error & MG_REG_ERR_UNC)
+			printk("UncorrectableError ");
+		if (host->error & MG_REG_ERR_IDNF)
+			printk("SectorIdNotFound ");
+		if (host->error & MG_REG_ERR_ABRT)
+			printk("DriveStatusError ");
+		if (host->error & MG_REG_ERR_AMNF)
+			printk("AddrMarkNotFound ");
+		printk("}");
+		if (host->error &
+		    (MG_REG_ERR_BBK | MG_REG_ERR_UNC | MG_REG_ERR_IDNF | MG_REG_ERR_AMNF)) {
+			if (host->breq) {
+				req = elv_next_request(host->breq);
+				if (req)
+					printk(", sector=%ld", req->sector);
+			}
+
+		}
+		printk("\n");
+	}
+}
+
+static unsigned int mg_wait(struct mg_host *host, u32 expect, u32 msec)
+{
+	u8 status;
+	u64 expire, cur_jiffies;
+
+	host->error = MG_ERR_NONE;
+	expire = get_jiffies_64() + msecs_to_jiffies(msec);
+
+	status = inb(host->dev_base + MG_REG_STATUS);
+	do {
+		cur_jiffies = get_jiffies_64();
+		if (status & MG_REG_STATUS_BIT_BUSY) {
+			if (expect == MG_REG_STATUS_BIT_BUSY)
+				break;
+		} else {
+			/* Check the error condition! */
+			if (status & MG_REG_STATUS_BIT_ERROR) {
+				mg_dump_status("mg_wait", status, host);
+				break;
+			}
+
+			if (expect == MG_STAT_READY) {
+				if (MG_READY_OK(status))
+					break;
+			}
+
+			if (expect == MG_REG_STATUS_BIT_DATA_REQ) {
+				if (status & MG_REG_STATUS_BIT_DATA_REQ) {
+					break;
+				}
+			}
+		}
+		status = inb(host->dev_base + MG_REG_STATUS);
+	} while (cur_jiffies < expire);
+
+	if (cur_jiffies >= expire) {
+		host->error = MG_ERR_TIMEOUT;
+	}
+
+	return host->error;
+}
+
+static void mg_unexpected_intr(struct mg_host *host)
+{
+	u32 status = inb(host->dev_base + MG_REG_STATUS);
+
+	mg_dump_status("mg_unexpected_intr", status, host);
+}
+
+static irqreturn_t mg_irq(int irq, void *dev_id)
+{
+	struct mg_host *host = dev_id;
+	void (*handler)(struct mg_host *) = host->mg_do_intr;
+
+	host->mg_do_intr = 0;
+	del_timer(&host->timer);
+	if (!handler)
+		handler = mg_unexpected_intr;
+	handler(host);
+	return IRQ_HANDLED;
+}
+
+static void mg_fix_disk_id(u16 *id)
+{
+#ifndef __LITTLE_ENDIAN
+# ifdef __BIG_ENDIAN
+	int i;
+
+	for (i = 0; i < 256; i++)
+		id[i] = __le16_to_cpu(id[i]);
+# else
+#  error "Please fix <asm/byteorder.h>"
+# endif
+#endif
+}
+
+static void mg_ide_fixstring(u8 *s, const int bytecount, const int byteswap)
+{
+	u8 *p, *end = &s[bytecount & ~1]; /* bytecount must be even */
+
+	if (byteswap) {
+		/* convert from big-endian to host byte order */
+		for (p = s ; p != end ; p += 2)
+			be16_to_cpus((u16 *) p);
+	}
+
+	/* strip leading blanks */
+	p = s;
+	while (s != end && *s == ' ')
+		++s;
+	/* compress internal blanks and strip trailing blanks */
+	while (s != end && *s) {
+		if (*s++ != ' ' || (s != end && *s && *s != ' '))
+			*p++ = *(s-1);
+	}
+	/* wipe out trailing garbage */
+	while (p != end)
+		*p++ = '\0';
+}
+
+static int mg_get_disk_id(struct mg_host *host)
+{
+	u32 i;
+	s32 err;
+	u16 *id = (u16 *)&host->id_data;
+	struct mg_drv_data *prv_data = host->dev->platform_data;
+
+	if (!prv_data->use_polling) {
+		outb(MG_REG_CTRL_INTR_DISABLE, host->dev_base + MG_REG_DRV_CTRL);
+	}
+
+	outb(MG_CMD_ID, host->dev_base + MG_REG_COMMAND);
+	err = mg_wait(host, MG_REG_STATUS_BIT_DATA_REQ, 3000);
+	if (!err) {
+		for (i = 0; i < (MG_SECTOR_SIZE >> 1); i++)
+			id[i] = inw(host->dev_base + MG_BUFF_OFFSET + i * 2);
+
+		outb(MG_CMD_RD_CONF, host->dev_base + MG_REG_COMMAND);
+		err = mg_wait(host, MG_STAT_READY, 3000);
+		if (!err) {
+			mg_fix_disk_id(id);
+			if ((host->id_data.field_valid & 1) == 0) {
+				err = MG_ERR_TRANSLATION;
+			} else {
+#ifdef __BIG_ENDIAN
+				host->id_data.lba_capacity = (host->id_data.lba_capacity << 16) |
(host->id_data.lba_capacity >> 16);
+#endif /* __BIG_ENDIAN */
+				host->tot_sectors = host->id_data.lba_capacity;
+				mg_ide_fixstring(host->id_data.model, sizeof(host->id_data.model), 1);
+				mg_ide_fixstring(host->id_data.serial_no,
sizeof(host->id_data.serial_no), 1);
+				mg_ide_fixstring(host->id_data.fw_rev, sizeof(host->id_data.fw_rev), 1);
+				printk(KERN_INFO "mg_disk: model: %s\n", host->id_data.model);
+				printk(KERN_INFO "mg_disk: firm: %.8s\n", host->id_data.fw_rev);
+				printk(KERN_INFO "mg_disk: serial: %s\n", host->id_data.serial_no);
+				printk(KERN_INFO "mg_disk: %d sectors\n", host->tot_sectors);
+			}
+		}
+	}
+
+	if (!prv_data->use_polling) {
+		outb(MG_REG_CTRL_INTR_ENABLE, host->dev_base + MG_REG_DRV_CTRL);
+	}
+
+	return err;
+}
+
+
+static int mg_disk_init(struct mg_host *host)
+{
+	struct mg_drv_data *prv_data = host->dev->platform_data;
+	s32 err;
+	u8 init_status;
+
+	/* init ctrl pin */
+	if (prv_data->mg_ctrl_pin_init)
+		prv_data->mg_ctrl_pin_init();
+
+	if (!prv_data->mg_hdrst_pin)
+		return MG_ERR_CTRL_RST;
+
+	/* hdd rst low */
+	prv_data->mg_hdrst_pin(0);
+	err = mg_wait(host, MG_REG_STATUS_BIT_BUSY, 300);
+	if (err)
+		return err;
+
+	/* hdd rst high */
+	prv_data->mg_hdrst_pin(1);
+	err = mg_wait(host, MG_STAT_READY, 3000);
+	if (err)
+		return err;
+
+	/* soft reset on */
+	outb(MG_REG_CTRL_RESET |
+		(prv_data->use_polling ? MG_REG_CTRL_INTR_DISABLE : MG_REG_CTRL_INTR_ENABLE),
+		host->dev_base + MG_REG_DRV_CTRL);
+	err = mg_wait(host, MG_REG_STATUS_BIT_BUSY, 3000);
+	if (err)
+		return err;
+
+	/* soft reset off */
+	outb(prv_data->use_polling ? MG_REG_CTRL_INTR_DISABLE :
MG_REG_CTRL_INTR_ENABLE,
+		host->dev_base + MG_REG_DRV_CTRL);
+	err = mg_wait(host, MG_STAT_READY, 3000);
+	if (err)
+		return err;
+
+	init_status = inb(host->dev_base + MG_REG_STATUS) & 0xf;
+
+	if (init_status == 0xf)
+		return MG_ERR_INIT_STAT;
+
+	if (prv_data->op_mode & (MG_OP_CASCADE_SYNC_RD | MG_OP_CASCADE_SYNC_WR)) {
+		outb(prv_data->burst_latcy | prv_data->burst_len, host->dev_base +
MG_REG_BURST_CTRL);
+	}
+
+	return err;
+}
+
+static void mg_bad_rw_intr(struct mg_host *host)
+{
+	struct request *req = elv_next_request(host->breq);
+	if (req != NULL) {
+		if (++req->errors >= MG_MAX_ERRORS) {
+			end_request(req, 0);
+		} else if (req->errors % MG_RESET_FREQ == 0 || host->error ==
MG_ERR_TIMEOUT) {
+			host->reset = 1;
+		}
+		/* Otherwise just retry */
+	}
+}
+
+static unsigned int mg_out(struct mg_host *host,
+			unsigned int sect_num,
+			unsigned int sect_cnt,
+			unsigned int cmd,
+			void (*intr_addr)(struct mg_host *))
+{
+	struct mg_drv_data *prv_data = host->dev->platform_data;
+
+	if (mg_wait(host, MG_STAT_READY, 3000)) {
+		return host->error;
+	}
+
+	if (!prv_data->use_polling) {
+		host->mg_do_intr = intr_addr;
+		mod_timer(&host->timer, jiffies + 3 * HZ);
+	}
+	outb((u8)sect_cnt, host->dev_base + MG_REG_SECT_CNT);
+	outb((u8)sect_num, host->dev_base + MG_REG_SECT_NUM);
+	outb((u8)(sect_num >> 8), host->dev_base + MG_REG_CYL_LOW);
+	outb((u8)(sect_num >> 16), host->dev_base + MG_REG_CYL_HIGH);
+	outb((u8)((sect_num >> 24) | MG_REG_HEAD_LBA_MODE), host->dev_base +
MG_REG_DRV_HEAD);
+	outb(cmd, host->dev_base + MG_REG_COMMAND);
+	return MG_ERR_NONE;
+}
+
+static void mg_read(struct request *req)
+{
+	u32 remains, j;
+	struct mg_host *host = req->rq_disk->private_data;
+
+	remains = req->nr_sectors;
+
+	if (host->reset) {
+		if (mg_disk_init(host)) {
+			end_request(req, 0);
+			return;
+		}
+		host->reset = 0;
+	}
+
+	if (mg_out(host, req->sector, req->nr_sectors, MG_CMD_RD, 0) != MG_ERR_NONE) {
+		mg_bad_rw_intr(host);
+	}
+
+	MG_DBG("requested %d sects (from %ld), buffer=0x%p\n", remains,
req->sector, req->buffer);
+
+	while (remains) {
+		if (mg_wait(host, MG_REG_STATUS_BIT_DATA_REQ, 3000) != MG_ERR_NONE) {
+			mg_bad_rw_intr(host);
+			return;
+		}
+		for (j = 0; j < MG_SECTOR_SIZE >> 1; j++) {
+			*(u16 *)req->buffer = inw(host->dev_base + MG_BUFF_OFFSET + (j << 1));
+			req->buffer += 2;
+		}
+
+		req->sector++;
+		req->errors = 0;
+		remains = --req->nr_sectors;
+		--req->current_nr_sectors;
+
+		if (req->current_nr_sectors <= 0) {
+			MG_DBG("remain : %d sects\n", remains);
+			end_request(req, 1);
+			if (remains > 0) {
+				req = elv_next_request(host->breq);
+			}
+		}
+
+		outb(MG_CMD_RD_CONF, host->dev_base + MG_REG_COMMAND);
+	}
+}
+
+static void mg_write(struct request *req)
+{
+	u32 remains, j;
+	struct mg_host *host = req->rq_disk->private_data;
+
+	remains = req->nr_sectors;
+
+	if (host->reset) {
+		if (mg_disk_init(host)) {
+			end_request(req, 0);
+			return;
+		}
+		host->reset = 0;
+	}
+
+	if (mg_out(host, req->sector, req->nr_sectors, MG_CMD_WR, 0) != MG_ERR_NONE) {
+		mg_bad_rw_intr(host);
+		return;
+	}
+
+
+	MG_DBG("requested %d sects (from %ld), buffer=0x%p\n", remains,
req->sector, req->buffer);
+	while (remains) {
+		if (mg_wait(host, MG_REG_STATUS_BIT_DATA_REQ, 3000) != MG_ERR_NONE) {
+			mg_bad_rw_intr(host);
+			return;
+		}
+		for (j = 0; j < MG_SECTOR_SIZE >> 1; j++) {
+			outw(*(u16 *)req->buffer, host->dev_base + MG_BUFF_OFFSET + (j << 1));
+			req->buffer += 2;
+		}
+		req->sector++;
+		remains = --req->nr_sectors;
+		--req->current_nr_sectors;
+
+		if (req->current_nr_sectors <= 0) {
+			MG_DBG("remain : %d sects\n", remains);
+			end_request(req, 1);
+			if (remains > 0) {
+				req = elv_next_request(host->breq);
+			}
+		}
+
+		outb(MG_CMD_WR_CONF, host->dev_base + MG_REG_COMMAND);
+	}
+}
+
+static void mg_read_intr(struct mg_host *host)
+{
+	u32 i;
+	struct request *req;
+
+	/* check status */
+	do {
+		i = inb(host->dev_base + MG_REG_STATUS);
+		if (i & MG_REG_STATUS_BIT_BUSY)
+			break;
+		if (!MG_READY_OK(i))
+			break;
+		if (i & MG_REG_STATUS_BIT_DATA_REQ)
+			goto ok_to_read;
+	} while (0);
+	mg_dump_status("mg_read_intr", i, host);
+	mg_bad_rw_intr(host);
+	mg_request(host->breq);
+	return;
+
+ok_to_read:
+	/* get current segment of request */
+	req = elv_next_request(host->breq);
+
+	/* read 1 sector */
+	for (i = 0; i < MG_SECTOR_SIZE >> 1; i++) {
+		*(u16 *)req->buffer = inw(host->dev_base + MG_BUFF_OFFSET + (i << 1));
+		req->buffer += 2;
+	}
+
+	/* manipulate request */
+	MG_DBG("sector %ld, remaining=%ld, buffer=0x%p\n", req->sector,
req->nr_sectors - 1, req->buffer);
+
+	req->sector++;
+	req->errors = 0;
+	i = --req->nr_sectors;
+	--req->current_nr_sectors;
+
+	/* let know if current segment done */
+	if (req->current_nr_sectors <= 0)
+		end_request(req, 1);
+
+	/* set handler if read remains */
+	if (i > 0) {
+		host->mg_do_intr = mg_read_intr;
+		mod_timer(&host->timer, jiffies + 3 * HZ);
+	}
+
+	/* send read confirm */
+	outb(MG_CMD_RD_CONF, host->dev_base + MG_REG_COMMAND);
+
+	/* goto next request */
+	if (!i) {
+		mg_request(host->breq);
+	}
+}
+
+static void mg_write_intr(struct mg_host *host)
+{
+	u32 i, j;
+	u16 *buff;
+	struct request *req;
+
+	/* get current segment of request */
+	req = elv_next_request(host->breq);
+
+	/* check status */
+	do {
+		i = inb(host->dev_base + MG_REG_STATUS);
+		if (i & MG_REG_STATUS_BIT_BUSY)
+			break;
+		if (!MG_READY_OK(i))
+			break;
+		if ((req->nr_sectors <= 1) || (i & MG_REG_STATUS_BIT_DATA_REQ))
+			goto ok_to_write;
+	} while (0);
+	mg_dump_status("mg_write_intr", i, host);
+	mg_bad_rw_intr(host);
+	mg_request(host->breq);
+	return;
+
+ok_to_write:
+	/* manipulate request */
+	req->sector++;
+	i = --req->nr_sectors;
+	--req->current_nr_sectors;
+	req->buffer += MG_SECTOR_SIZE;
+
+	/* let know if current segment or all done */
+	if (!i || (req->bio && req->current_nr_sectors <= 0))
+		end_request(req, 1);
+
+	/* write 1 sector and set handler if remains */
+	if (i > 0) {
+		buff = (u16 *)req->buffer;
+		for (j = 0; j < MG_STORAGE_BUFFER_SIZE >> 1; j++) {
+			outw(*buff, host->dev_base + MG_BUFF_OFFSET + (j << 1));
+			buff++;
+		}
+		MG_DBG("sector %ld, remaining=%ld, buffer=0x%p\n", req->sector,
req->nr_sectors, req->buffer);
+		host->mg_do_intr = mg_write_intr;
+		mod_timer(&host->timer, jiffies + 3 * HZ);
+	}
+
+	/* send write confirm */
+	outb(MG_CMD_WR_CONF, host->dev_base + MG_REG_COMMAND);
+
+	if (!i) {
+		mg_request(host->breq);
+	}
+}
+
+void mg_times_out(unsigned long data)
+{
+	struct mg_host *host = (struct mg_host *)data;
+	char *name;
+	struct request *req;
+
+	req = elv_next_request(host->breq);
+	if (!req)
+		return;
+
+	host->mg_do_intr = NULL;
+
+	name = req->rq_disk->disk_name;
+	printk("%s: timeout\n", name);
+
+	host->error = MG_ERR_TIMEOUT;
+	mg_bad_rw_intr(host);
+
+	mg_request(host->breq);
+}
+
+static void mg_request_poll(struct request_queue *q)
+{
+	struct request *req;
+	struct mg_host *host;
+
+	while ((req = elv_next_request(q)) != NULL) {
+
+		host = req->rq_disk->private_data;
+
+		if (blk_fs_request(req)) {
+			switch (rq_data_dir(req)) {
+			case READ:
+				mg_read(req);
+				break;
+			case WRITE:
+				mg_write(req);
+				break;
+			default:
+				printk(KERN_WARNING "%s:%d unknown command\n", __func__, __LINE__);
+				end_request(req, 0);
+				break;
+			}
+		}
+	}
+}
+
+static unsigned int mg_issue_req(struct request *req,
+					struct mg_host *host,
+					unsigned int sect_num,
+					unsigned int sect_cnt)
+{
+	u16 *buff;
+	u32 i;
+
+	switch (rq_data_dir(req)) {
+	case READ:
+		if (mg_out(host, sect_num, sect_cnt, MG_CMD_RD, &mg_read_intr) !=
MG_ERR_NONE) {
+			mg_bad_rw_intr(host);
+			return host->error;
+		}
+		break;
+	case WRITE:
+		/* TODO : handler */
+		outb(MG_REG_CTRL_INTR_DISABLE, host->dev_base + MG_REG_DRV_CTRL);
+		if (mg_out(host, sect_num, sect_cnt, MG_CMD_WR, &mg_write_intr) !=
MG_ERR_NONE) {
+			mg_bad_rw_intr(host);
+			return host->error;
+		}
+		del_timer(&host->timer);
+		mg_wait(host, MG_REG_STATUS_BIT_DATA_REQ, 3000);
+		outb(MG_REG_CTRL_INTR_ENABLE, host->dev_base + MG_REG_DRV_CTRL);
+		if (host->error) {
+			mg_bad_rw_intr(host);
+			return host->error;
+		}
+		buff = (u16 *)req->buffer;
+		for (i = 0; i < MG_SECTOR_SIZE >> 1; i++) {
+			outw(*buff, host->dev_base + MG_BUFF_OFFSET + (i << 1));
+			buff++;
+		}
+		mod_timer(&host->timer, jiffies + 3 * HZ);
+		outb(MG_CMD_WR_CONF, host->dev_base + MG_REG_COMMAND);
+		break;
+	default:
+		printk(KERN_WARNING "%s:%d unknown command\n", __func__, __LINE__);
+		end_request(req, 0);
+		break;
+	}
+	return MG_ERR_NONE;
+}
+
+/* This function also called from IRQ context */
+static void mg_request(struct request_queue *q)
+{
+	struct request *req;
+	struct mg_host *host;
+	u32 sect_num, sect_cnt;
+
+	while (1) {
+		req = elv_next_request(q);
+		if (!req)
+			return;
+
+		host = req->rq_disk->private_data;
+
+		/* check unwanted request call */
+		if (host->mg_do_intr)
+			return;
+
+		del_timer(&host->timer);
+
+		if (host->reset) {
+			if (mg_disk_init(host)) {
+				end_request(req, 0);
+				return;
+			}
+			host->reset = 0;
+		}
+
+		sect_num = req->sector;
+		/* deal whole segments */
+		sect_cnt = req->nr_sectors;
+
+		/* sanity check */
+		if (sect_num >= get_capacity(req->rq_disk) ||
+		    ((sect_num + sect_cnt) > get_capacity(req->rq_disk))) {
+			printk(KERN_WARNING "%s: bad access: sector=%d, count=%d\n",
+				 req->rq_disk->disk_name, sect_num, sect_cnt);
+			end_request(req, 0);
+			continue;
+		}
+
+		if (!blk_fs_request(req))
+			return;
+
+		if (!mg_issue_req(req, host, sect_num, sect_cnt))
+			return;
+	}
+}
+
+static int mg_ioctl(struct block_device *bdev, fmode_t fmode,
unsigned cmd, unsigned long arg)
+{
+	struct hd_geometry geo;
+	struct mg_host *host = bdev->bd_disk->private_data;
+
+	switch (cmd) {
+	case HDIO_GETGEO:
+		if (!access_ok(VERIFY_WRITE, arg, sizeof(geo))) {
+			return -EFAULT;
+		}
+
+		geo.cylinders = host->id_data.cyls;
+		geo.heads = host->id_data.heads;
+		geo.sectors = host->id_data.sectors;
+		geo.start = get_start_sect(bdev);
+
+		if (copy_to_user((void *)arg, &geo, sizeof(geo)))
+			return -EFAULT;
+
+		return 0;
+	}
+
+	return -ENOTTY;
+}
+
+static int mg_open(struct block_device *bd, fmode_t fmode)
+{
+	return 0;
+}
+
+static int mg_release(struct gendisk *gendisk, fmode_t fmode)
+{
+	return 0;
+}
+
+static struct block_device_operations mg_disk_ops = {
+	.owner = THIS_MODULE,
+	.open = mg_open,
+	.release = mg_release,
+	.ioctl = mg_ioctl
+};
+
+static int mg_probe(struct platform_device *plat_dev)
+{
+	struct mg_host *host;
+	struct resource *rsc;
+	struct mg_drv_data *prv_data = plat_dev->dev.platform_data;
+	int err = 0;
+
+	if (!prv_data) {
+		printk(KERN_ERR "%s:%d fail (no driver_data)\n", __func__, __LINE__);
+		err = -EINVAL;
+		goto probe_err;
+	}
+
+	/* alloc mg_host */
+	host = kmalloc(sizeof(struct mg_host), GFP_KERNEL);
+	if (!host) {
+		printk(KERN_ERR "%s:%d fail (no memory for mg_host)\n", __func__, __LINE__);
+		err = -ENOMEM;
+		goto probe_err;
+	}
+	memset(host, 0, sizeof(struct mg_host));
+	host->major = MG_DISK_MAJ;
+
+	/* link each other */
+	prv_data->host = host;
+	host->dev = &plat_dev->dev;
+
+	/* io remap */
+	rsc = platform_get_resource(plat_dev, IORESOURCE_MEM, 0);
+	if (!rsc) {
+		printk(KERN_ERR "%s:%d platform_get_resource fail\n", __func__, __LINE__);
+		err = -EINVAL;
+		goto probe_err_2;
+	}
+	host->dev_base = ioremap(rsc->start , rsc->end + 1);
+	if (!host->dev_base) {
+		printk(KERN_ERR "%s:%d ioremap fail\n", __func__, __LINE__);
+		err = -EIO;
+		goto probe_err_2;
+	}
+	MG_DBG("dev_base = 0x%x\n", (u32)host->dev_base);
+
+	/* disk init */
+	err = mg_disk_init(host);
+	if (err) {
+		printk(KERN_ERR "%s:%d fail (err code : %d)\n", __func__, __LINE__, err);
+		err = -EIO;
+		goto probe_err_3;
+	}
+
+	/* get irq resource */
+	if (!prv_data->use_polling) {
+		host->irq = platform_get_irq(plat_dev, 0);
+		if (host->irq == -ENXIO) {
+			err = host->irq;
+			goto probe_err_3;
+		}
+		err = request_irq(host->irq, mg_irq, IRQF_DISABLED |
IRQF_TRIGGER_RISING, MG_DEV_NAME, host);
+		if (err) {
+			printk(KERN_ERR "%s:%d fail (request_irq err=%d)\n", __func__,
__LINE__, err);
+			goto probe_err_3;
+		}
+
+	}
+
+	/* get disk id */
+	err = mg_get_disk_id(host);
+	if (err) {
+		printk(KERN_ERR "%s:%d fail (err code : %d)\n", __func__, __LINE__, err);
+		err = -EIO;
+		goto probe_err_4;
+	}
+
+	err = register_blkdev(host->major, MG_DISK_NAME);
+	if (err < 0) {
+		printk(KERN_ERR "%s:%d (register_blkdev) fail (err code : %d)\n",
__func__, __LINE__, err);
+		goto probe_err_4;
+	}
+	err = 0;
+	if (!host->major)
+		host->major = err;
+
+	spin_lock_init(&host->lock);
+
+	if (prv_data->use_polling) {
+		host->breq = blk_init_queue(mg_request_poll, &host->lock);
+	} else {
+		host->breq = blk_init_queue(mg_request, &host->lock);
+	}
+
+	if (!host->breq) {
+		err = -ENOMEM;
+		printk(KERN_ERR "%s:%d (blk_init_queue) fail\n", __func__, __LINE__);
+		goto probe_err_5;
+	}
+
+	/* mflash is random device, thanx for the noop */
+	elevator_exit(host->breq->elevator);
+	err = elevator_init(host->breq, "noop");
+	if (err) {
+		printk(KERN_ERR "%s:%d (elevator_init) fail\n", __func__, __LINE__);
+		goto probe_err_6;
+	}
+	blk_queue_max_sectors(host->breq, MG_MAX_SECTS);
+	blk_queue_hardsect_size(host->breq, MG_SECTOR_SIZE);
+
+	init_timer(&host->timer);
+	host->timer.function = mg_times_out;
+	host->timer.data = (unsigned long)host;
+
+	host->gd = alloc_disk(MG_DISK_MAX_PART);
+	if (!host->gd) {
+		printk(KERN_ERR "%s:%d (alloc_disk) fail\n", __func__, __LINE__);
+		err = -ENOMEM;
+		goto probe_err_7;
+	}
+	host->gd->major = MG_DISK_MAJ;
+	host->gd->first_minor = 0;
+	host->gd->fops = &mg_disk_ops;
+	host->gd->queue = host->breq;
+	host->gd->private_data = host;
+	sprintf(host->gd->disk_name, MG_DISK_NAME"a");
+
+	set_capacity(host->gd, host->tot_sectors);
+
+	add_disk(host->gd);
+
+	return err;
+
+probe_err_7:
+	del_timer_sync(&host->timer);
+probe_err_6:
+	blk_cleanup_queue(host->breq);
+probe_err_5:
+	unregister_blkdev(MG_DISK_MAJ, MG_DISK_NAME);
+probe_err_4:
+	if (!prv_data->use_polling)
+		free_irq(host->irq, host);
+probe_err_3:
+	iounmap(host->dev_base);
+probe_err_2:
+	kfree(host);
+probe_err:
+	return err;
+}
+
+static int mg_remove(struct platform_device *plat_dev)
+{
+	struct mg_drv_data *prv_data = plat_dev->dev.platform_data;
+	struct mg_host *host = prv_data->host;
+	int err = 0;
+
+	/* delete timer */
+	del_timer_sync(&host->timer);
+
+	/* remove disk */
+	if (host->gd) {
+		del_gendisk(host->gd);
+		put_disk(host->gd);
+	}
+	/* remove queue */
+	if (host->breq)
+		blk_cleanup_queue(host->breq);
+
+	/* unregister blk device */
+	unregister_blkdev(host->major, MG_DISK_NAME);
+
+	/* free irq */
+	if (!prv_data->use_polling)
+		free_irq(host->irq, host);
+
+	/* unmap io */
+	if (host->dev_base)
+		iounmap(host->dev_base);
+
+	/* free mg_host */
+	if (host)
+		kfree(host);
+
+	return err;
+}
+
+static struct platform_driver mg_disk_driver = {
+	.probe = mg_probe,
+	.remove = mg_remove,
+	.driver = {
+		.name = MG_DEV_NAME,
+		.owner = THIS_MODULE,
+	}
+};
+
+/****************************************************************************
+ *
+ * Module stuff
+ *
+ ****************************************************************************/
+
+static int __init mg_init(void)
+{
+	printk(KERN_INFO "mGine mflash driver, (c) 2008 mGine Co.\n");
+	return platform_driver_register(&mg_disk_driver);
+}
+
+static void __exit mg_exit(void)
+{
+	printk(KERN_INFO "mflash driver : bye bye\n");
+	platform_driver_unregister(&mg_disk_driver);
+}
+
+module_init(mg_init);
+module_exit(mg_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("unsik Kim <donari75@gmail.com>");
+MODULE_DESCRIPTION("mGine m[g]flash device driver");
diff --git a/include/linux/mg_disk.h b/include/linux/mg_disk.h
new file mode 100644
index 0000000..4e5701a
--- /dev/null
+++ b/include/linux/mg_disk.h
@@ -0,0 +1,174 @@
+/*
+ *  include/linux/mg_disk.c
+ *
+ *  Support for the mGine m[g]flash IO mode.
+ *  Based on legacy hd.c
+ *
+ * (c) 2008 mGine Co.,LTD
+ * (c) 2008 unsik Kim <donari75@gmail.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+
+#ifndef __MG_DISK_H__
+#define __MG_DISK_H__
+
+#include <linux/blkdev.h>
+#include <linux/hdreg.h>
+
+/* name for block device */
+#define MG_DISK_NAME "mgd"
+/* name for platform device */
+#define MG_DEV_NAME "mg_disk"
+
+#define MG_DISK_MAJ 240
+#define MG_DISK_MAX_PART 16
+#define MG_SECTOR_SIZE 512
+#define MG_MAX_SECTS 256
+
+/* Register offsets */
+#define MG_BUFF_OFFSET			0x8000
+#define MG_STORAGE_BUFFER_SIZE	0x200
+#define MG_REG_OFFSET			0xC000
+#define MG_REG_FEATURE			(MG_REG_OFFSET + 2)	/* write case */
+#define MG_REG_ERROR			(MG_REG_OFFSET + 2)	/* read case */
+#define MG_REG_SECT_CNT			(MG_REG_OFFSET + 4)
+#define MG_REG_SECT_NUM			(MG_REG_OFFSET + 6)
+#define MG_REG_CYL_LOW			(MG_REG_OFFSET + 8)
+#define MG_REG_CYL_HIGH			(MG_REG_OFFSET + 0xA)
+#define MG_REG_DRV_HEAD			(MG_REG_OFFSET + 0xC)
+#define MG_REG_COMMAND			(MG_REG_OFFSET + 0xE)	/* write case */
+#define MG_REG_STATUS			(MG_REG_OFFSET + 0xE)	/* read  case */
+#define MG_REG_DRV_CTRL			(MG_REG_OFFSET + 0x10)
+#define MG_REG_BURST_CTRL		(MG_REG_OFFSET + 0x12)
+
+/* "Drive Select/Head Register" bit values */
+#define MG_REG_HEAD_MUST_BE_ON	0xA0 /* These 2 bits are always on */
+#define MG_REG_HEAD_DRIVE_MASTER	(0x00 | MG_REG_HEAD_MUST_BE_ON)
+#define MG_REG_HEAD_DRIVE_SLAVE	(0x10 | MG_REG_HEAD_MUST_BE_ON)
+#define MG_REG_HEAD_LBA_MODE		(0x40 | MG_REG_HEAD_MUST_BE_ON)
+
+
+/* "Device Control Register" bit values */
+#define MG_REG_CTRL_INTR_ENABLE		0x0
+#define MG_REG_CTRL_INTR_DISABLE		(0x1<<1)
+#define MG_REG_CTRL_RESET			(0x1<<2)
+#define MG_REG_CTRL_INTR_POLA_ACTIVE_HIGH	0x0
+#define MG_REG_CTRL_INTR_POLA_ACTIVE_LOW	(0x1<<4)
+#define MG_REG_CTRL_DPD_POLA_ACTIVE_LOW	0x0
+#define MG_REG_CTRL_DPD_POLA_ACTIVE_HIGH	(0x1<<5)
+#define MG_REG_CTRL_DPD_DISABLE		0x0
+#define MG_REG_CTRL_DPD_ENABLE		(0x1<<6)
+
+/* Status register bit */
+#define MG_REG_STATUS_BIT_ERROR			0x01 /* error bit in status register */
+#define MG_REG_STATUS_BIT_CORRECTED_ERROR		0x04 /* corrected error in
status register */
+#define MG_REG_STATUS_BIT_DATA_REQ			0x08 /* data request bit in
status register */
+#define MG_REG_STATUS_BIT_SEEK_DONE			0x10 /* DSC - Drive Seek Complete */
+#define MG_REG_STATUS_BIT_WRITE_FAULT		0x20 /* DWF - Drive Write Fault */
+#define MG_REG_STATUS_BIT_READY			0x40
+#define MG_REG_STATUS_BIT_BUSY			0x80
+
+/* handy status */
+#define MG_STAT_READY		(MG_REG_STATUS_BIT_READY | MG_REG_STATUS_BIT_SEEK_DONE)
+#define MG_READY_OK(s)		(((s) & (MG_STAT_READY | \
+					(MG_REG_STATUS_BIT_BUSY | MG_REG_STATUS_BIT_WRITE_FAULT |
MG_REG_STATUS_BIT_ERROR))) \
+					== MG_STAT_READY)
+
+/* Error register */
+#define MG_REG_ERR_AMNF		0x01
+#define MG_REG_ERR_ABRT		0x04
+#define MG_REG_ERR_IDNF		0x10
+#define MG_REG_ERR_UNC		0x40
+#define MG_REG_ERR_BBK		0x80
+
+/* error code for others */
+#define MG_ERR_NONE 0
+#define MG_ERR_TIMEOUT 0x100
+#define MG_ERR_INIT_STAT 0x101
+#define MG_ERR_TRANSLATION 0x102
+#define MG_ERR_CTRL_RST 0x103
+
+#define MG_MAX_ERRORS	16	/* Max read/write errors/sector */
+#define MG_RESET_FREQ	4	/* Reset controller every 4th retry */
+
+/* command */
+#define MG_CMD_RD 0x20
+#define MG_CMD_WR 0x30
+#define MG_CMD_SLEEP 0x99
+#define MG_CMD_WAKEUP 0xC3
+#define MG_CMD_ID 0xEC
+#define MG_CMD_WR_CONF 0x3C
+#define MG_CMD_RD_CONF 0x40
+
+/* private driver data */
+struct mg_drv_data {
+	/* disk resource */
+	u32 nr_chips;
+	u32 op_mode;
+#define MG_OP_CASCADE (1 << 0)
+#define MG_OP_CASCADE_SYNC_RD (1 << 1)
+#define MG_OP_CASCADE_SYNC_WR (1 << 2)
+#define MG_OP_INTERLEAVE (1 << 3)
+
+	u32 use_polling;
+
+	/* synchronous mode */
+	u16	burst_latcy;
+#define MG_BURST_LAT_4 (3 << 4)
+#define MG_BURST_LAT_5 (4 << 4)
+#define MG_BURST_LAT_6 (5 << 4)
+#define MG_BURST_LAT_7 (6 << 4)
+#define MG_BURST_LAT_8 (7 << 4)
+	u16	burst_len;
+#define MG_BURST_LEN_4 (1 << 1)
+#define MG_BURST_LEN_8 (2 << 1)
+#define MG_BURST_LEN_16 (3 << 1)
+#define MG_BURST_LEN_32 (4 << 1)
+#define MG_BURST_LEN_CONT (0 << 1)
+
+	/* control pin resource */
+	int (*mg_ctrl_pin_init) (void); /* initialize hdrst, wd, dpd pin to
GPIO and output high */
+	void (*mg_hdrst_pin) (u8 level);
+	void (*mg_wp_pin) (u8 level);
+	void (*mg_dpd_pin) (u8 level);
+
+	/* internally used */
+	struct mg_host *host;
+};
+
+/* main structure for mflash driver */
+struct mg_host {
+	struct device *dev;
+
+	struct request_queue *breq;
+	spinlock_t lock;
+	struct gendisk *gd;
+
+	struct timer_list timer;
+	void (*mg_do_intr) (struct mg_host *);
+
+	struct hd_driveid id_data;
+	u32 tot_sectors;
+
+	void __iomem *dev_base;
+	unsigned int irq;
+
+	u32 major;
+	u32 error;
+	u32 reset;
+};
+
+/*
+ * Debugging macro and defines
+ */
+#undef DO_MG_DEBUG
+#ifdef DO_MG_DEBUG
+#  define MG_DBG(fmt, args...) printk(KERN_DEBUG "%s:%d "fmt,
__func__, __LINE__, ##args)
+#else /* CONFIG_MG_DEBUG */
+#  define MG_DBG(fmt, args...) do { } while (0)
+#endif /* CONFIG_MG_DEBUG */
+
+#endif
