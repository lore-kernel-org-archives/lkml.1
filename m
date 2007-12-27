Return-Path: <linux-kernel-owner+w=401wt.eu-S1753257AbXL0QxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257AbXL0QxT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 11:53:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751958AbXL0QxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 11:53:06 -0500
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:26212 "EHLO
	mk-filter-3-a-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751245AbXL0QxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 11:53:02 -0500
X-Trace: 663828233/mk-filter-3.mail.uk.tiscali.com/B2C/$THROTTLED-DYNAMIC/CUSTOMER-DYNAMIC-IP/81.1.89.80
X-SBRS: None
X-RemoteIP: 81.1.89.80
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAHhnc0dRAVlQ/2dsb2JhbACBV6o1
Subject: [PATCH] SH/Dreamcast - add support for GD-Rom device
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Paul Mundt <lethal@linux-sh.org>, Jens Axboe <jens.axboe@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-sh <linux-sh@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 27 Dec 2007 16:52:19 +0000
Message-Id: <1198774339.6170.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the CD-Rom drive on the SEGA Dreamcast.

The SEGA Dreamcast has a built in CD-Rom drive, electrically similar
to an ATA-3 drive, but implementing a proprietary packet interface -
the so-called Sega Packet Interface (SPI)- and also supporting a
proprietary format of disk - the Giga Disk Rom, with a 1GB capacity.
The drive is know as the "GD-Rom drive".

This patch partially implements the SPI and also supports reading GD
Rom disks. Unlike previous GD Rom drivers (which were never in the
mainline), this driver implements DMA and not PIO for reads. It is a
new driver, not a modified version of previous drivers.

This is the fifth iteration of this patch - which should work with
both 2.6-24-rc5 and Paul Mundt's 2.6.25 queue.

Signed-off by: Adrian McMenamin <adrian@mcmen.demon.co.uk>

----

diff -rupN linux-2.6-orig/drivers/block/Kconfig linux-2.6/drivers/block/Kconfig
--- linux-2.6-orig/drivers/block/Kconfig	2007-12-26 17:27:14.000000000 +0000
+++ linux-2.6/drivers/block/Kconfig	2007-12-27 16:39:05.000000000 +0000
@@ -105,6 +105,17 @@ config PARIDE
 	  "MicroSolutions backpack protocol", "DataStor Commuter protocol"
 	  etc.).
 
+config GDROM
+	tristate "SEGA Dreamcast GD-ROM drive"
+	depends on SH_DREAMCAST
+	help
+	  A standard SEGA Dreamcast comes with a modified CD ROM drive called a
+	  "GD-ROM" by SEGA to signify it is capable of reading special disks
+	  with up to 1 GB of data. This drive will also read standard CD ROM
+	  disks. Select this option to access any disks in your GD ROM drive.
+	  Most users will want to say "Y" here.
+	  You can also build this as a module which will be called gdrom.ko
+
 source "drivers/block/paride/Kconfig"
 
 config BLK_CPQ_DA
diff -rupN linux-2.6-orig/drivers/cdrom/gdrom.c linux-2.6/drivers/cdrom/gdrom.c
--- linux-2.6-orig/drivers/cdrom/gdrom.c	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6/drivers/cdrom/gdrom.c	2007-12-27 16:39:05.000000000 +0000
@@ -0,0 +1,776 @@
+/* GD ROM driver for the SEGA Dreamcast
+ * copyright Adrian McMenamin, 2007
+ * With thanks to Marcus Comstedt and Nathan Keynes
+ * for work in reversing PIO and DMA
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/slab.h>
+#include <linux/dma-mapping.h>
+#include <linux/cdrom.h>
+#include <linux/genhd.h>
+#include <linux/bio.h>
+#include <linux/blkdev.h>
+#include <linux/interrupt.h>
+#include <linux/device.h>
+#include <linux/wait.h>
+#include <linux/workqueue.h>
+#include <linux/platform_device.h>
+#include <scsi/scsi.h>
+#include <asm/io.h>
+#include <asm/dma.h>
+#include <asm/delay.h>
+#include <asm/mach/dma.h>
+#include <asm/mach/sysasic.h>
+
+#define GDROM_DEV_NAME "gdrom"
+#define GD_SESSION_OFFSET 150
+
+/* GD Rom commands */
+#define GDROM_COM_SOFTRESET 0x08
+#define GDROM_COM_EXECDIAG 0x90
+#define GDROM_COM_PACKET 0xA0
+#define GDROM_COM_IDDEV 0xA1
+
+/* GD Rom registers */
+#define GDROM_BASE_REG 			0xA05F7000
+#define GDROM_ALTSTATUS_REG 		(GDROM_BASE_REG + 0x18)
+#define GDROM_DATA_REG 			(GDROM_BASE_REG + 0x80)
+#define GDROM_ERROR_REG 		(GDROM_BASE_REG + 0x84)
+#define GDROM_INTSEC_REG 		(GDROM_BASE_REG + 0x88)
+#define GDROM_SECNUM_REG 		(GDROM_BASE_REG + 0x8C)
+#define GDROM_BCL_REG  			(GDROM_BASE_REG + 0x90)
+#define GDROM_BCH_REG 			(GDROM_BASE_REG + 0x94)
+#define GDROM_DSEL_REG 			(GDROM_BASE_REG + 0x98)
+#define GDROM_STATUSCOMMAND_REG 	(GDROM_BASE_REG + 0x9C)
+#define GDROM_RESET_REG 		(GDROM_BASE_REG + 0x4E4)
+
+#define GDROM_DMA_STARTADDR_REG 	(GDROM_BASE_REG + 0x404)
+#define GDROM_DMA_LENGTH_REG 		(GDROM_BASE_REG + 0x408)
+#define GDROM_DMA_DIRECTION_REG 	(GDROM_BASE_REG + 0x40C)
+#define GDROM_DMA_ENABLE_REG 		(GDROM_BASE_REG + 0x414)
+#define GDROM_DMA_STATUS_REG 		(GDROM_BASE_REG + 0x418)
+#define GDROM_DMA_WAIT_REG 		(GDROM_BASE_REG + 0x4A0)
+#define GDROM_DMA_ACCESS_CTRL_REG 	(GDROM_BASE_REG + 0x4B8)
+
+#define GDROM_HARD_SECTOR 	2048
+#define BLOCK_LAYER_SECTOR 	512
+#define GD_TO_BLK 		4
+
+static const struct {
+	int sense_key;
+	const char * const text;
+} sense_texts[] = {
+	{NO_SENSE, "GDROM: OK"},
+	{RECOVERED_ERROR, "GDROM: Recovered from error"},
+	{NOT_READY, "GDROM: Device not ready"},
+	{MEDIUM_ERROR, "GDROM: Disk not ready"},
+	{HARDWARE_ERROR, "GDROM: Hardware error"},
+	{ILLEGAL_REQUEST, "GDROM: Command has failed"},
+	{UNIT_ATTENTION, "GDROM: Device needs attention - disk may have been changed"},
+	{DATA_PROTECT, "GDROM: Data protection error"},
+	{ABORTED_COMMAND, "GDROM: Command aborted"},
+};
+
+static struct platform_device *pd;
+static int gdrom_major;
+static wait_queue_head_t command_queue;
+static wait_queue_head_t request_queue;
+
+static DEFINE_SPINLOCK(gdrom_lock);
+static void gdrom_readdisk_dma(struct work_struct *work);
+static DECLARE_WORK(work, gdrom_readdisk_dma);
+static LIST_HEAD(gdrom_deferred);
+
+struct gdromtoc {
+	unsigned int entry[99];
+	unsigned int first, last;
+	unsigned int leadout;
+};
+
+static struct gdrom_unit {
+	struct gendisk *disk;
+	struct cdrom_device_info *cd_info;
+	int status;
+	int pending;
+	int transfer;
+	char disk_type;
+	struct gdromtoc *toc;
+	struct request_queue *gdrom_rq;
+} gd;
+
+struct gdrom_id {
+	char mid;
+	char modid;
+	char verid;
+	char padA[13];
+	char mname[16];
+	char modname[16];
+	char firmver[16];
+	char padB[16];
+};
+
+static int gdrom_getsense(short *bufstring);
+static int gdrom_packetcommand(struct cdrom_device_info *cd_info, struct packet_command *command);
+static int gdrom_hardreset(struct cdrom_device_info *cd_info);
+
+static void gdrom_wait_clrbusy(void)
+{
+	/* long timeouts - typical for a CD Rom */
+	unsigned long timeout = jiffies + HZ * 60;
+	while ((ctrl_inb(GDROM_ALTSTATUS_REG) & 0x80) && (time_before(jiffies, timeout)))
+		cpu_relax();
+}
+
+static void gdrom_wait_busy_sleeps(void)
+{
+	unsigned long timeout;
+	/* Wait to get busy first */
+	timeout = jiffies + HZ * 60;
+	while (((ctrl_inb(GDROM_ALTSTATUS_REG) & 0x80) == 0) && (time_before(jiffies, timeout)))
+		cpu_relax();
+	/* Now wait for busy to clear */
+	gdrom_wait_clrbusy();
+}
+
+static void gdrom_identifydevice(void *buf)
+{
+	int c;
+	short *data = buf;
+	gdrom_wait_clrbusy();
+	ctrl_outb(GDROM_COM_IDDEV, GDROM_STATUSCOMMAND_REG);
+	gdrom_wait_busy_sleeps();
+	/* now read in the data */
+	for (c = 0; c < 40; c++)
+		data[c] = ctrl_inw(GDROM_DATA_REG);
+}
+
+static void gdrom_spicommand(void *spi_string, int buflen)
+{
+	short *cmd = spi_string;
+	/* ensure IRQ_WAIT is set */
+	ctrl_outb(0x08, GDROM_ALTSTATUS_REG);
+	/* specify how many bytes we expect back */
+	ctrl_outb(buflen & 0xFF, GDROM_BCL_REG);
+	ctrl_outb((buflen >> 8) & 0xFF, GDROM_BCH_REG);
+	/* other parameters */
+	ctrl_outb(0, GDROM_INTSEC_REG);
+	ctrl_outb(0, GDROM_SECNUM_REG);
+	ctrl_outb(0, GDROM_ERROR_REG);
+	/* Wait until we can go */
+	gdrom_wait_clrbusy();
+	ctrl_outb(GDROM_COM_PACKET, GDROM_STATUSCOMMAND_REG);
+	while ((ctrl_inb(GDROM_ALTSTATUS_REG) & 0x88) != 8)
+		cpu_relax(); /* wait for DRQ to be set to 1 */
+	outsw(PHYSADDR(GDROM_DATA_REG), cmd, 6);
+}
+
+/* gdrom_command_executediagnostic:
+ * Used to probe for presence of working GDROM
+ * Restarts GDROM device and then applies standard ATA 3
+ * Execute Diagnostic Command: a return of '1' indicates device 0
+ * present and device 1 absent
+ */
+static char gdrom_execute_diagnostic(void)
+{
+	gdrom_hardreset(gd.cd_info);
+	gdrom_wait_clrbusy();
+	ctrl_outb(GDROM_COM_EXECDIAG, GDROM_STATUSCOMMAND_REG);
+	gdrom_wait_busy_sleeps();
+	return ctrl_inb(GDROM_ERROR_REG);
+}
+
+/*
+ * Prepare disk command
+ * byte 0 = 0x70
+ * byte 1 = 0x1f
+ */
+static int gdrom_preparedisk_cmd(void)
+{
+	struct packet_command *spin_command;
+	spin_command = kzalloc(sizeof(struct packet_command), GFP_KERNEL);
+	if (!spin_command)
+		return -ENOMEM;
+	spin_command->cmd[0] = 0x70;
+	spin_command->cmd[2] = 0x1f;
+	spin_command->buflen = 0;
+	gd.pending = 1;
+	gdrom_packetcommand(gd.cd_info, spin_command);
+	/* 60 second timeout */
+	wait_event_interruptible_timeout(command_queue, gd.pending == 0, HZ * 60);
+	gd.pending = 0;
+	kfree(spin_command);
+	if (gd.status & 0x01) {
+		/* log an error */
+		gdrom_getsense(NULL);
+		return -EIO;
+	}
+	return 0;
+}
+
+/*
+ * Read TOC command
+ * byte 0 = 0x14
+ * byte 1 = session
+ * byte 3 = sizeof TOC >> 8  ie upper byte
+ * byte 4 = sizeof TOC & 0xff ie lower byte
+ */
+static int gdrom_readtoc_cmd(struct gdromtoc *toc, int session)
+{
+	int tocsize;
+	struct packet_command *toc_command;
+	toc_command = kzalloc(sizeof(struct packet_command), GFP_KERNEL);
+	if (!toc_command)
+		return -ENOMEM;
+	tocsize = sizeof(struct gdromtoc);
+	toc_command->cmd[0] = 0x14;
+	toc_command->cmd[1] = session;
+	toc_command->cmd[3] = tocsize >> 8;
+	toc_command->cmd[4] = tocsize & 0xff;
+	toc_command->buflen = tocsize;
+	gd.pending = 1;
+	gdrom_packetcommand(gd.cd_info, toc_command);
+	wait_event_interruptible_timeout(command_queue, gd.pending == 0, HZ * 60);
+	gd.pending = 0;
+	insw(PHYSADDR(GDROM_DATA_REG), toc, tocsize/2);
+	kfree(toc_command);
+	if (gd.status & 0x01)
+		return -EINVAL;
+	return 0;
+}
+
+/* TOC helpers */
+static int get_entry_lba(int track)
+{
+	return (cpu_to_be32(track & 0xffffff00) - GD_SESSION_OFFSET);
+}
+
+static int get_entry_q_ctrl(int track)
+{
+	return (track & 0x000000f0) >> 4;
+}
+
+static int get_entry_track(int track)
+{
+	return (track & 0x0000ff00) >> 8;
+}
+
+static int gdrom_get_last_session(struct cdrom_device_info *cd_info, struct cdrom_multisession *ms_info)
+{
+	int fentry, lentry, track, data, tocuse, err;
+	if (!gd.toc)
+		return -ENOMEM;
+	tocuse = 1;
+	/* Check if GD-ROM */
+	err = gdrom_readtoc_cmd(gd.toc, 1);
+	/* Not a GD-ROM so check if standard CD-ROM */
+	if (err) {
+		tocuse = 0;
+		err = gdrom_readtoc_cmd(gd.toc, 0);
+		if (err) {
+			printk(KERN_INFO "GDROM: Could not get CD table of contents\n");
+			return -ENXIO;
+		}
+	}
+
+	fentry = get_entry_track(gd.toc->first);
+	lentry = get_entry_track(gd.toc->last);
+	/* Find the first data track */
+	track = get_entry_track(gd.toc->last);
+	do {
+		data = gd.toc->entry[track - 1];
+		if (get_entry_q_ctrl(data))
+			break;	/* ie a real data track */
+		track--;
+	} while (track >= fentry);
+
+	if ((track > 100) || (track < get_entry_track(gd.toc->first))) {
+		gdrom_getsense(NULL);
+		printk(KERN_INFO "GDROM: No data on the last session of the CD\n");
+		return -ENXIO;
+	}
+
+	ms_info->addr_format = CDROM_LBA;
+	ms_info->addr.lba = get_entry_lba(data);
+	ms_info->xa_flag = 1;
+	return 0;
+}
+
+static int gdrom_open(struct cdrom_device_info *cd_info, int purpose)
+{
+	/* spin up the disk */
+	return gdrom_preparedisk_cmd();
+}
+
+/* this function is required even if empty */
+static void gdrom_release(struct cdrom_device_info *cd_info)
+{
+}
+
+static int gdrom_drivestatus(struct cdrom_device_info *cd_info, int ignore)
+{
+	/* read the sense key */
+	char sense = ctrl_inb(GDROM_ERROR_REG);
+	sense &= 0xF0;
+	if (sense == 0)
+		return CDS_DISC_OK;
+	if (sense == 0x20)
+		return CDS_DRIVE_NOT_READY;
+	/* default */
+	return CDS_NO_INFO;
+}
+
+static int gdrom_mediachanged(struct cdrom_device_info *cd_info, int ignore)
+{
+	/* check the sense key */
+	return ((ctrl_inb(GDROM_ERROR_REG) & 0xF0) == 0x60);
+}
+
+/* reset the G1 bus */
+static int gdrom_hardreset(struct cdrom_device_info *cd_info)
+{
+	int count;
+	ctrl_outl(0x1fffff, GDROM_RESET_REG);
+	for (count = 0xa0000000; count < 0xa0200000; count += 4)
+		ctrl_inl(count);
+	return 0;
+}
+
+/* keep the function looking like the universal CD Rom specification - returning int*/
+static int gdrom_packetcommand(struct cdrom_device_info *cd_info, struct packet_command *command)
+{
+	gdrom_spicommand(&command->cmd, command->buflen);
+	return 0;
+}
+
+/* Get Sense SPI command
+ * From Marcus Comstedt
+ * cmd = 0x13
+ * cmd + 4 = length of returned buffer
+ * Returns 5 16 bit words
+ */
+static int gdrom_getsense(short *bufstring)
+{
+	struct packet_command *sense_command;
+	short sense[5];
+	int sense_key;
+	if (gd.pending)
+		return -EIO;
+
+	/* allocate command and buffer */
+	sense_command = kzalloc(sizeof(struct packet_command), GFP_KERNEL);
+	if (!sense_command)
+		return -ENOMEM;
+
+	sense_command->cmd[0] = 0x13;
+	sense_command->cmd[4] = 10;
+	sense_command->buflen = 10;
+
+	gd.pending = 1;
+	gdrom_packetcommand(gd.cd_info, sense_command);
+	/* 60 second timeout */
+	wait_event_interruptible_timeout(command_queue, gd.pending == 0, HZ * 60);
+	gd.pending = 0;
+	kfree(sense_command);
+	insw(PHYSADDR(GDROM_DATA_REG), &sense, 5);
+	if (sense[1] & 40) {
+		printk(KERN_INFO "GDROM: Drive not ready - command aborted\n");
+		return -EIO;
+	}
+	sense_key = sense[1] & 0x0F;
+	printk(KERN_INFO "%s\n", sense_texts[sense_key].text);
+
+	if (bufstring)
+		memcpy(bufstring, &sense[4], 2); /* return additional sense data */
+
+	if (sense_key < 2)
+		return 0;
+	return -EIO;
+}
+
+static struct cdrom_device_ops gdrom_ops = {
+	.open			= gdrom_open,
+	.release		= gdrom_release,
+	.drive_status		= gdrom_drivestatus,
+	.media_changed		= gdrom_mediachanged,
+	.get_last_session	= gdrom_get_last_session,
+	.reset			= gdrom_hardreset,
+	.capability		= CDC_MULTI_SESSION | CDC_MEDIA_CHANGED |
+				  CDC_RESET | CDC_DRIVE_STATUS | CDC_CD_R,
+	.n_minors		= 1,
+};
+
+static int gdrom_bdops_open(struct inode *inode, struct file *file)
+{
+	return cdrom_open(gd.cd_info, inode, file);
+}
+
+static int gdrom_bdops_release(struct inode *inode, struct file *file)
+{
+	return cdrom_release(gd.cd_info, file);
+}
+
+static int gdrom_bdops_mediachanged(struct gendisk *disk)
+{
+	return cdrom_media_changed(gd.cd_info);
+}
+
+static int gdrom_bdops_ioctl(struct inode *inode, struct file *file, unsigned cmd, unsigned long arg)
+{
+	return cdrom_ioctl(file, gd.cd_info, inode, cmd, arg);
+}
+
+static struct block_device_operations gdrom_bdops = {
+	.owner			= THIS_MODULE,
+	.open			= gdrom_bdops_open,
+	.release		= gdrom_bdops_release,
+	.media_changed		= gdrom_bdops_mediachanged,
+	.ioctl			= gdrom_bdops_ioctl,
+};
+
+static irqreturn_t gdrom_command_interrupt(int irq, void *dev_id)
+{
+	gd.status = ctrl_inb(GDROM_STATUSCOMMAND_REG);
+	if (gd.pending != 1)
+		return IRQ_HANDLED;
+	gd.pending = 0;
+	wake_up_interruptible(&command_queue);
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t gdrom_dma_interrupt(int irq, void *dev_id)
+{
+	gd.status = ctrl_inb(GDROM_STATUSCOMMAND_REG);
+	if (gd.transfer != 1)
+		return IRQ_HANDLED;
+	gd.transfer = 0;
+	wake_up_interruptible(&request_queue);
+	return IRQ_HANDLED;
+}
+
+static int __devinit gdrom_set_interrupt_handlers(void)
+{
+	int err;
+	init_waitqueue_head(&command_queue);
+	err = request_irq(HW_EVENT_GDROM_CMD, gdrom_command_interrupt, IRQF_DISABLED, "gdrom_command", &gd);
+	if (err)
+		return err;
+	init_waitqueue_head(&request_queue);
+	err = request_irq(HW_EVENT_GDROM_DMA, gdrom_dma_interrupt, IRQF_DISABLED, "gdrom_dma", &gd);
+	if (err)
+		free_irq(HW_EVENT_GDROM_CMD, &gd);
+	return err;
+}
+
+/* Implement DMA read using SPI command
+ * 0 -> 0x30
+ * 1 -> mode
+ * 2 -> block >> 16
+ * 3 -> block >> 8
+ * 4 -> block
+ * 8 -> sectors >> 16
+ * 9 -> sectors >> 8
+ * 10 -> sectors
+ */
+static void gdrom_readdisk_dma(struct work_struct *work)
+{
+	int err, block, block_cnt;
+	struct packet_command *read_command;
+	struct list_head *elem, *next;
+	struct request *req;
+	unsigned long timeout;
+	if (list_empty(&gdrom_deferred))
+		return;
+	read_command = kzalloc(sizeof(struct packet_command), GFP_KERNEL);
+	if (!read_command)
+		return; /* get more memory later? */
+	read_command->cmd[0] = 0x30;
+	read_command->cmd[1] = 0x20;
+	spin_lock(&gdrom_lock);
+	list_for_each_safe(elem, next, &gdrom_deferred) {
+		req = list_entry(elem, struct request, queuelist);
+		spin_unlock(&gdrom_lock);
+		block = req->sector/GD_TO_BLK + GD_SESSION_OFFSET;
+		block_cnt = req->nr_sectors/GD_TO_BLK;
+		ctrl_outl(PHYSADDR(req->buffer), GDROM_DMA_STARTADDR_REG);
+		ctrl_outl(block_cnt * GDROM_HARD_SECTOR, GDROM_DMA_LENGTH_REG);
+		ctrl_outl(1, GDROM_DMA_DIRECTION_REG);
+		ctrl_outl(1, GDROM_DMA_ENABLE_REG);
+		read_command->cmd[2] = (block >> 16) & 0xFF;
+		read_command->cmd[3] = (block >> 8) & 0xFF;
+		read_command->cmd[4] = block & 0xFF;
+		read_command->cmd[8] = (block_cnt >> 16) & 0xFF;
+		read_command->cmd[9] = (block_cnt >> 8) & 0xFF;
+		read_command->cmd[10] = block_cnt & 0xFF;
+		/* set for DMA */
+		ctrl_outb(1, GDROM_ERROR_REG);
+		/* other registers */
+		ctrl_outb(0, GDROM_SECNUM_REG);
+		ctrl_outb(0, GDROM_BCL_REG);
+		ctrl_outb(0, GDROM_BCH_REG);
+		ctrl_outb(0, GDROM_DSEL_REG);
+		ctrl_outb(0, GDROM_INTSEC_REG);
+		/* In multiple DMA transfers need to wait */
+		timeout = jiffies + HZ / 2;
+		while ((ctrl_inb(GDROM_ALTSTATUS_REG) & 0x80) && (time_before(jiffies, timeout)))
+			cpu_relax();
+		ctrl_outb(GDROM_COM_PACKET, GDROM_STATUSCOMMAND_REG);
+		timeout = jiffies + HZ / 2;
+		while (((ctrl_inb(GDROM_ALTSTATUS_REG) & 0x88) != 8) && (time_before(jiffies, timeout)))
+			cpu_relax(); /* wait for DRQ to be set to 1 */
+		gd.pending = 1;
+		gd.transfer = 1;
+		outsw(PHYSADDR(GDROM_DATA_REG), &read_command->cmd, 6);
+		timeout = jiffies + HZ / 2;
+		while ((ctrl_inb(GDROM_DMA_STATUS_REG)) && (time_before(jiffies, timeout)))
+			cpu_relax();
+		ctrl_outb(1, GDROM_DMA_STATUS_REG);
+		/* 5 second error margin here seems more reasonable */
+		wait_event_interruptible_timeout(request_queue, gd.transfer == 0, HZ * 5);
+		err = ctrl_inb(GDROM_DMA_STATUS_REG);
+		err = gd.transfer;
+		gd.transfer = 0;
+		gd.pending = 0;
+		/* now seek to take the request spinlock
+ 		 * before handling ending the request */
+		spin_lock(&gdrom_lock);
+		list_del_init(&req->queuelist);
+		blk_requeue_request(gd.gdrom_rq, req);
+		if (err)
+			end_request(req, 0);
+		else
+			end_request(req, 1);
+	}
+	spin_unlock(&gdrom_lock);
+	kfree(read_command);
+}
+
+static void gdrom_request_handler_dma(struct request *req)
+{
+	/* dequeue, add to list of deferred work
+ 	 * and then schedule workqueue */
+	blkdev_dequeue_request(req);
+	list_add_tail(&req->queuelist, &gdrom_deferred);
+	schedule_work(&work);
+}
+
+static void gdrom_request(struct request_queue *rq)
+{
+	struct request *req;
+	while ((req = elv_next_request(rq)) != NULL) {
+		if (!blk_fs_request(req)) {
+			printk(KERN_DEBUG "GDROM: Non-fs request ignored\n");
+			end_request(req, 0);
+		}
+		if (rq_data_dir(req) != READ) {
+			printk(KERN_NOTICE "GDROM: Read only device - write request ignored\n");
+			end_request(req, 0);
+		}
+		if (req->nr_sectors)
+			gdrom_request_handler_dma(req);
+		else
+			end_request(req, 0);
+	}
+}
+
+/* Print string identifying GD ROM device */
+static int __devinit gdrom_outputversion(void)
+{
+	struct gdrom_id *id;
+	char *model_name, *manuf_name, *firmw_ver;
+	int err = -ENOMEM;
+	/* query device ID */
+	id = kzalloc(sizeof(struct gdrom_id), GFP_KERNEL);
+	if (!id)
+		return err;
+	gdrom_identifydevice(id);
+	model_name = kstrndup(id->modname, 16, GFP_KERNEL);
+	if (!model_name)
+		goto free_id;
+	manuf_name = kstrndup(id->mname, 16, GFP_KERNEL);
+	if (!manuf_name)
+		goto free_model_name;
+	firmw_ver = kstrndup(id->firmver, 16, GFP_KERNEL);
+	if (!firmw_ver)
+		goto free_manuf_name;
+	printk(KERN_INFO "GDROM: %s from %s with firmware %s\n", model_name, manuf_name, firmw_ver);
+	err = 0;
+	kfree(firmw_ver);
+free_manuf_name:
+	kfree(manuf_name);
+free_model_name:
+	kfree(model_name);
+free_id:
+	kfree(id);
+	return err;
+}
+
+/* set the default mode for DMA transfer */
+static void __devinit gdrom_init_dma_mode(void)
+{
+	ctrl_outb(0x13, GDROM_ERROR_REG);
+	ctrl_outb(0x22, GDROM_INTSEC_REG);
+	gdrom_wait_clrbusy();
+	ctrl_outb(0xEF, GDROM_STATUSCOMMAND_REG);
+	gdrom_wait_busy_sleeps();
+	ctrl_outl(0x8843407F, GDROM_DMA_ACCESS_CTRL_REG); /* memory setting */
+	ctrl_outl(9, GDROM_DMA_WAIT_REG); /* DMA word setting */
+}
+
+static void __devinit probe_gdrom_setupcd(void)
+{
+	gd.cd_info->ops = &gdrom_ops;
+	gd.cd_info->capacity = 1;
+	strcpy(gd.cd_info->name, GDROM_DEV_NAME);
+	gd.cd_info->mask = CDC_CLOSE_TRAY|CDC_OPEN_TRAY|CDC_LOCK|CDC_SELECT_DISC;
+}
+
+static void __devinit probe_gdrom_setupdisk(void)
+{
+	gd.disk->major = gdrom_major;
+	gd.disk->first_minor = 1;
+	gd.disk->minors = 1;
+	strcpy(gd.disk->disk_name, GDROM_DEV_NAME);
+}
+
+static void __devinit probe_gdrom_setupqueue(void)
+{
+	blk_queue_hardsect_size(gd.gdrom_rq, GDROM_HARD_SECTOR);
+	/* using DMA so memory will need to be contiguous */
+	blk_queue_max_hw_segments(gd.gdrom_rq, 1);
+	/* set a large max size to get most from DMA */
+	blk_queue_max_segment_size(gd.gdrom_rq, 0x40000);
+	gd.disk->queue = gd.gdrom_rq;
+	gdrom_init_dma_mode();
+}
+
+/*
+ * register this as a block device and as compliant with the
+ * universal CD Rom driver interface
+ */
+static int __devinit probe_gdrom(struct platform_device *devptr)
+{
+	int err;
+	if (gdrom_execute_diagnostic() != 1) {
+		printk(KERN_WARNING "GDROM: ATA Probe for GDROM failed.\n");
+		return -ENODEV;
+	}
+	if (gdrom_outputversion())
+		return -ENOMEM;
+	gdrom_major = register_blkdev(0, GDROM_DEV_NAME);
+	if (gdrom_major <= 0)
+		return gdrom_major;
+	printk(KERN_INFO "GDROM: Block device is registered with major number %d\n", gdrom_major);
+	gd.cd_info = kzalloc(sizeof(struct cdrom_device_info), GFP_KERNEL);
+	if (!gd.cd_info) {
+		err = -ENOMEM;
+		goto probe_fail_no_mem;
+	}
+	probe_gdrom_setupcd();
+	gd.disk = alloc_disk(1);
+	if (!gd.disk) {
+		err = -ENODEV;
+		goto probe_fail_no_disk;
+	}
+	probe_gdrom_setupdisk();
+	if (register_cdrom(gd.cd_info)) {
+		err = -ENODEV;
+		goto probe_fail_cdrom_register;
+	}
+	gd.disk->fops = &gdrom_bdops;
+	/* latch on to the interrupt */
+	err = gdrom_set_interrupt_handlers();
+	if (err)
+		goto probe_fail_cmdirq_register;
+	gd.gdrom_rq = blk_init_queue(gdrom_request, &gdrom_lock);
+	if (!gd.gdrom_rq)
+		goto probe_fail_requestq;
+	probe_gdrom_setupqueue();
+	gd.toc = kzalloc(sizeof(struct gdromtoc), GFP_KERNEL);
+	if (!gd.toc)
+		goto probe_fail_toc;
+	add_disk(gd.disk);
+	return 0;
+
+probe_fail_toc:
+	blk_cleanup_queue(gd.gdrom_rq);
+probe_fail_requestq:
+	free_irq(HW_EVENT_GDROM_DMA, &gd);
+	free_irq(HW_EVENT_GDROM_CMD, &gd);
+probe_fail_cmdirq_register:
+probe_fail_cdrom_register:
+	del_gendisk(gd.disk);
+probe_fail_no_disk:
+	kfree(gd.cd_info);
+	unregister_blkdev(gdrom_major, GDROM_DEV_NAME);
+	gdrom_major = 0;
+probe_fail_no_mem:
+	printk(KERN_WARNING "GDROM: Could not probe for device - error is 0x%X\n", err);
+	return err;
+}
+
+static int remove_gdrom(struct platform_device *devptr)
+{
+	blk_cleanup_queue(gd.gdrom_rq);
+	free_irq(HW_EVENT_GDROM_CMD, &gd);
+	free_irq(HW_EVENT_GDROM_DMA, &gd);
+	del_gendisk(gd.disk);
+	if (gdrom_major)
+		unregister_blkdev(gdrom_major, GDROM_DEV_NAME);
+	return unregister_cdrom(gd.cd_info);
+}
+
+static struct platform_driver gdrom_driver = {
+	.probe = probe_gdrom,
+	.remove = remove_gdrom,
+	.driver = {
+			.name = GDROM_DEV_NAME,
+	},
+};
+
+static int __init init_gdrom(void)
+{
+	int rc;
+	gd.toc = NULL;
+	rc = platform_driver_register(&gdrom_driver);
+	if (rc)
+		return rc;
+	pd = platform_device_register_simple(GDROM_DEV_NAME, -1, NULL, 0);
+	if (IS_ERR(pd)) {
+		platform_driver_unregister(&gdrom_driver);
+		return PTR_ERR(pd);
+	}
+	return 0;
+}
+
+static void __exit exit_gdrom(void)
+{
+	platform_device_unregister(pd);
+	platform_driver_unregister(&gdrom_driver);
+	kfree(gd.toc);
+}
+
+module_init(init_gdrom);
+module_exit(exit_gdrom);
+MODULE_AUTHOR("Adrian McMenamin <adrian@mcmen.demon.co.uk>");
+MODULE_DESCRIPTION("SEGA Dreamcast GD-ROM Driver");
+MODULE_LICENSE("GPL");
diff -rupN linux-2.6-orig/drivers/cdrom/Makefile linux-2.6/drivers/cdrom/Makefile
--- linux-2.6-orig/drivers/cdrom/Makefile	2007-12-26 17:27:15.000000000 +0000
+++ linux-2.6/drivers/cdrom/Makefile	2007-12-27 00:08:39.000000000 +0000
@@ -11,3 +11,4 @@ obj-$(CONFIG_PARIDE_PCD)	+=		cdrom.o
 obj-$(CONFIG_CDROM_PKTCDVD)	+=		cdrom.o
 
 obj-$(CONFIG_VIOCD)		+= viocd.o      cdrom.o
+obj-$(CONFIG_GDROM)		+= gdrom.o      cdrom.o


