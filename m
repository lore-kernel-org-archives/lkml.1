Return-Path: <linux-kernel-owner+w=401wt.eu-S1760705AbXLPB0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760705AbXLPB0W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 20:26:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756631AbXLPB0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 20:26:10 -0500
Received: (root@vger.kernel.org) by vger.kernel.org id S1755106AbXLPB0H
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 20:26:07 -0500
Received: from py-out-1112.google.com ([64.233.166.183]:20061 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763125AbXLPAVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 19:21:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=f2g0J5DleDrNa0VJ7UZyZif7pLtBftPWpuhuFeMBIRSHQoqDDYNAlydPLlne+Vx6y6l1HlKoUSo+q7vYR1vxeYKpNBaOMfNHUUagc/F4mDRsEdn2VidAUjZJJwzyYn8yXzPHmcVyVNNNNG2lHufFVfwBuPjDe0q2NHIbIvxMoLI=
Message-ID: <8b67d60712151621j2101c411p19d75125c6d1c2f9@mail.gmail.com>
Date: Sun, 16 Dec 2007 00:21:21 +0000
From: "Adrian McMenamin" <lkmladrian@gmail.com>
To: "Paul Mundt" <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-sh@vger.kernel.org, axboe@kernel.dk
Subject: [PATCH 2/3] Add GD-Rom support to the SEGA Dreamcast
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff -ruN ./linux-2.6-orig/drivers/sh/gdrom/gdrom.c
./linux-2.6/drivers/sh/gdrom/gdrom.c
--- ./linux-2.6-orig/drivers/sh/gdrom/gdrom.c	1970-01-01
01:00:00.000000000 +0100
+++ ./linux-2.6/drivers/sh/gdrom/gdrom.c	2007-12-15 22:58:17.000000000 +0000
@@ -0,0 +1,793 @@
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
+#define GDROM_BASE_REG 0xA05F7000
+#define GDROM_ALTSTATUS_REG GDROM_BASE_REG + 0x18
+#define GDROM_DATA_REG GDROM_BASE_REG + 0x80
+#define GDROM_ERROR_REG GDROM_BASE_REG + 0x84
+#define GDROM_INTSEC_REG GDROM_BASE_REG + 0x88
+#define GDROM_SECNUM_REG GDROM_BASE_REG + 0x8C
+#define GDROM_BCL_REG  GDROM_BASE_REG + 0x90
+#define GDROM_BCH_REG GDROM_BASE_REG + 0x94
+#define GDROM_DSEL_REG GDROM_BASE_REG + 0x98
+#define GDROM_STATUSCOMMAND_REG GDROM_BASE_REG + 0x9C
+#define GDROM_RESET_REG GDROM_BASE_REG + 0x4E4
+
+#define GDROM_DATA_REG_P0 0x005F7080
+
+#define GDROM_DMA_STARTADDR_REG GDROM_BASE_REG + 0x404
+#define GDROM_DMA_LENGTH_REG GDROM_BASE_REG + 0x408
+#define GDROM_DMA_DIRECTION_REG GDROM_BASE_REG + 0x40C
+#define GDROM_DMA_ENABLE_REG GDROM_BASE_REG + 0x414
+#define GDROM_DMA_STATUS_REG GDROM_BASE_REG + 0x418
+#define GDROM_DMA_WAIT_REG GDROM_BASE_REG + 0x4A0
+#define GDROM_DMA_ACCESS_CTRL_REG GDROM_BASE_REG + 0x4B8
+
+#define GDROMDEBUG 0
+
+#define GDROM_HARD_SECTOR 2048
+#define BLOCK_LAYER_SECTOR 512
+#define GD_TO_BLK 4
+
+static struct platform_device *pd;
+static int gdrom_major;
+static wait_queue_head_t command_queue;
+static wait_queue_head_t request_queue;
+
+static DEFINE_SPINLOCK(gdrom_lock);
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
+static int gdrom_packetcommand(struct cdrom_device_info * cd_info,
struct packet_command *command);
+
+static void wait_clrbusy(void)
+{
+	while (ctrl_inb(GDROM_ALTSTATUS_REG) & 0x80)
+		schedule();
+}
+	
+static void gdrom_wait_busy_sleeps(void)
+{
+	/* Wait to get busy first */
+	while ((ctrl_inb(GDROM_ALTSTATUS_REG) & 0x80) == 0)
+		schedule();
+	/* Now wait for busy to clear */
+	wait_clrbusy();
+}		
+
+static void gdrom_identifydevice(void *buf)
+{
+	int c;
+	short *data = buf;
+	wait_clrbusy();
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
+	wait_clrbusy();
+	ctrl_outb(GDROM_COM_PACKET, GDROM_STATUSCOMMAND_REG);
+	while ((ctrl_inb(GDROM_ALTSTATUS_REG) & 0x88) != 8)
+		; /* wait for DRQ to be set to 1 */
+	outsw(GDROM_DATA_REG_P0, cmd, 6);
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
+	int count;
+	/* Restart the GDROM */
+	ctrl_outl(0x1fffff, GDROM_RESET_REG);
+	for (count = 0xa0000000; count < 0xa0200000; count += 4)
+		ctrl_inl(count);
+	wait_clrbusy();
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
+
+	gd.pending = 0;
+	kfree(spin_command);
+	if ((gd.status & 0x01) != 0)
+		return gdrom_getsense(NULL);
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
+	insw(GDROM_DATA_REG_P0, toc, tocsize/2);
+	kfree(toc_command);	
+	if ((gd.status & 0x01) != 0)
+		return gdrom_getsense(NULL);
+
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
+static int gdrom_get_last_session(struct cdrom_device_info *cd_info,
struct cdrom_multisession *ms_info)
+{
+	struct gdromtoc *tocA, *tocB;
+	int fentry, lentry, track, data, tocuse;
+	int err = -ENOMEM;
+	tocA = kzalloc(sizeof(struct gdromtoc), GFP_KERNEL);
+	if (!tocA)
+		goto exit;	
+	tocB = kzalloc(sizeof(struct gdromtoc), GFP_KERNEL);
+	if (!tocB)
+		goto clean_tocA;
+	tocuse = 1;
+	err = gdrom_readtoc_cmd(tocB, 1);
+	if (err) {
+		tocuse = 0;
+		err = gdrom_readtoc_cmd(tocA, 0);
+		if (err) {
+			err = -ENXIO;
+			printk(KERN_INFO "Could not get CD table of contents\n");
+			goto clean_tocB;
+		}	
+	}
+	else
+		printk(KERN_DEBUG "Disk is GDROM\n");
+	if (gd.toc)
+		kfree(gd.toc);
+	gd.toc = kzalloc(sizeof(struct gdromtoc), GFP_KERNEL);
+	if (!gd.toc) {
+		err = -ENOMEM;
+		goto clean_tocB;
+	}
+		if (tocuse)
+		memcpy(gd.toc, tocB, sizeof (struct gdromtoc));
+	else
+		memcpy(gd.toc, tocA, sizeof (struct gdromtoc));
+
+	fentry = get_entry_track(gd.toc->first);
+	lentry = get_entry_track(gd.toc->last);
+	
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
+		err = -ENXIO;
+		goto clean_tocB;
+	}
+
+	ms_info->addr_format = CDROM_LBA;
+	ms_info->addr.lba = get_entry_lba(data);
+	ms_info->xa_flag = 1;
+	err = 0;	
+clean_tocB:
+	kfree(tocB);
+clean_tocA:
+	kfree(tocA);
+exit:
+	return err;
+}
+		
+static int gdrom_open(struct cdrom_device_info *cd_info, int purpose)
+{
+	int err;
+	/* spin up the disk */
+	err = gdrom_preparedisk_cmd();
+	if (err)
+		return -EIO;
+	
+	return 0;
+}
+
+static void gdrom_release(struct cdrom_device_info *cd_info)
+{
+}
+
+static int gdrom_drivestatus(struct cdrom_device_info *cd_info, int ignore)
+{
+	/* read the sense key */
+	char sense = ctrl_inb(GDROM_ERROR_REG);
+	sense &=0xF0;
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
+	char sense = ctrl_inb(GDROM_ERROR_REG);
+	if ((sense & 0xF0) == 0x60)
+		return 1;
+	return 0;
+}
+
+static int gdrom_hardreset(struct cdrom_device_info * cd_info)
+{
+	int count;
+	ctrl_outl(0x1fffff, GDROM_RESET_REG);
+	for (count = 0xa0000000; count < 0xa0200000; count += 4)
+		ctrl_inl(count);
+	return 0;
+}
+
+static int gdrom_packetcommand(struct cdrom_device_info * cd_info,
struct packet_command *command)
+{
+	gdrom_spicommand(&command->cmd, command->buflen);
+	/* keep the function like the universal CD Rom one
+ 	 * though the return value is meaningless */	
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
+	char sense_key;
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
+	insw(GDROM_DATA_REG_P0, &sense, 5);
+	if (sense[1] & 40) {
+		printk(KERN_INFO "GDROM: Drive not ready - command aborted\n");
+		return -EIO;
+	}
+	sense_key = sense[1] & 0x0F;
+	switch (sense_key){
+	case 0xB:
+		printk(KERN_INFO "GDROM: Command aborted\n");
+		break;
+	case 0x7:
+		printk(KERN_INFO "GDROM: Data protection error\n");
+		break;
+	case 0x6:
+		printk(KERN_NOTICE "GDROM: Unit needs attention - possible disk switch\n");
+		break;
+	case 0x5:
+		printk(KERN_INFO "GDROM: Illegal request - command has failed\n");
+		break;
+	case 0x4:
+		printk(KERN_CRIT "GDROM: Hardware error\n");
+		break;
+	case 0x3:
+		printk(KERN_WARNING "GDROM: Disk read error\n");
+		break;
+	case 0x2:
+		printk(KERN_INFO "GDROM: Not ready\n");
+		break;
+	case 0x1:
+		printk(KERN_DEBUG "GDROM: Recovered from error\n");
+		break;
+	case 0x0:
+		/*success - stay silent*/
+		break;
+		
+	default:
+		printk(KERN_INFO "GDROM: Unknown error\n");
+	}
+
+	if (bufstring){
+		memcpy(bufstring, &sense[4], 2); /* return additional sense data */
+	}
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
+	.tray_move		= NULL,
+	.lock_door		= NULL,
+	.select_speed		= NULL,
+	.get_last_session	= gdrom_get_last_session,
+	.get_mcn		= NULL,
+	.reset			= gdrom_hardreset,
+	.audio_ioctl		= NULL,
+	.capability		= CDC_MULTI_SESSION | CDC_MEDIA_CHANGED |
+				  CDC_RESET | CDC_DRIVE_STATUS | CDC_CD_R,
+	.generic_packet		= NULL,
+	.n_minors		= 1,
+};
+
+int gdrom_bdops_open(struct inode *inode, struct file *file)
+{
+	return cdrom_open(gd.cd_info, inode, file);
+}
+
+int gdrom_bdops_release(struct inode *inode, struct file *file)
+{
+	return cdrom_release(gd.cd_info, file);
+}
+
+int gdrom_bdops_mediachanged(struct gendisk *disk)
+{
+	return cdrom_media_changed(gd.cd_info);
+}
+
+static int gdrom_bdops_ioctl(struct inode *inode, struct file *file,
unsigned cmd, unsigned long arg)
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
+	if (dev_id != &gd)
+		return IRQ_NONE;
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
+	if (dev_id != &gd)
+		return IRQ_NONE;
+	gd.status = ctrl_inb(GDROM_STATUSCOMMAND_REG);
+	if (gd.transfer != 1)
+		return IRQ_HANDLED;
+	gd.transfer = 0;
+	wake_up_interruptible(&request_queue);
+	return IRQ_HANDLED;
+}
+
+static int gdrom_set_command_interrupt_handler(void)
+{
+	/* need a queue to wait in */
+	init_waitqueue_head(&command_queue);	
+	return request_irq(HW_EVENT_GDROM_CMD, gdrom_command_interrupt,
IRQF_DISABLED, "gdrom_command", &gd);
+}
+
+static int gdrom_set_dma_interrupt_handler(void)
+{
+	init_waitqueue_head(&request_queue);
+	return request_irq(HW_EVENT_GDROM_DMA, gdrom_dma_interrupt,
IRQF_DISABLED, "gdrom_dma", &gd);
+}
+
+static int gdrom_readdisk_dma(int block, int block_cnt, char *buffer)
+{
+	int err;
+	struct packet_command *read_command;
+	/* release the spin lock but check later
+ 	 * we're not in the middle of some dma */
+	spin_unlock(&gdrom_lock);
+	ctrl_outl(0x8843407F, GDROM_DMA_ACCESS_CTRL_REG); /* memory setting */
+	ctrl_outl(9, GDROM_DMA_WAIT_REG); /* DMA word setting */
+	ctrl_outl(PHYSADDR(buffer), GDROM_DMA_STARTADDR_REG);
+	ctrl_outl(block_cnt * GDROM_HARD_SECTOR, GDROM_DMA_LENGTH_REG);
+	ctrl_outl(1, GDROM_DMA_DIRECTION_REG);
+	ctrl_outl(1, GDROM_DMA_ENABLE_REG);
+	/* send command */
+	read_command = kzalloc(sizeof(struct packet_command), GFP_KERNEL);
+	if (!read_command)
+		return -ENOMEM;
+	read_command->cmd[0] = 0x30;
+	read_command->cmd[1] = 0x20;
+	read_command->cmd[2] = (block >> 16) & 0xFF;
+	read_command->cmd[3] = (block >> 8) & 0xFF;
+	read_command->cmd[4] = block & 0xFF;
+	read_command->cmd[8] = (block_cnt >> 16) & 0xFF;
+	read_command->cmd[9] = (block_cnt >> 8) & 0xFF;
+	read_command->cmd[10] = block_cnt & 0xFF;
+	/* set for DMA */
+	ctrl_outb(1, GDROM_ERROR_REG);
+	/* other parameters */
+	ctrl_outb(0, GDROM_SECNUM_REG);
+	ctrl_outb(0, GDROM_BCL_REG);
+	ctrl_outb(0, GDROM_BCH_REG);
+	ctrl_outb(0, GDROM_DSEL_REG);
+	ctrl_outb(0, GDROM_INTSEC_REG);
+	/* In multiple DMA transfers need to wait */
+	while (ctrl_inb(GDROM_ALTSTATUS_REG) & 0x80)
+		cpu_relax();
+	ctrl_outb(GDROM_COM_PACKET, GDROM_STATUSCOMMAND_REG);
+	while ((ctrl_inb(GDROM_ALTSTATUS_REG) & 0x88) != 8)
+		cpu_relax(); /* wait for DRQ to be set to 1 */
+	gd.pending = 1;
+	gd.transfer = 1;
+	outsw(PHYSADDR(GDROM_DATA_REG), &read_command->cmd, 6);
+	while (ctrl_inb(GDROM_DMA_STATUS_REG))
+		cpu_relax();
+	ctrl_outb(1, GDROM_DMA_STATUS_REG);
+	/* 5 second error margin here seems more reasonable */
+	wait_event_interruptible_timeout(request_queue, gd.transfer == 0, HZ * 5);
+	err = ctrl_inb(GDROM_DMA_STATUS_REG);
+	err = gd.transfer;
+	gd.transfer = 0;
+	gd.pending = 0;
+	kfree(read_command);
+	spin_lock(&gdrom_lock);
+	return err;
+}	
+
+static void gdrom_request_handler_dma(struct request *req)
+{
+	int err, block, block_cnt;
+	err = 0;
+	block = req->sector/GD_TO_BLK + GD_SESSION_OFFSET;
+	block_cnt = req->nr_sectors/GD_TO_BLK;
+	err = gdrom_readdisk_dma(block, block_cnt, req->buffer);	
+	if (unlikely(err)) {
+		end_request(req, 0);
+		spin_unlock(&gdrom_lock);
+		gdrom_getsense(NULL);
+		spin_lock(&gdrom_lock);
+	}
+	else
+		end_request(req, 1);
+}
+
+static void gdrom_request(struct request_queue *rq)
+{
+	struct request *req;
+	unsigned long pages;
+	pages = rq->backing_dev_info.ra_pages;
+	while ((req = elv_next_request(rq)) != NULL) {
+		if (! blk_fs_request(req)) {
+			printk(KERN_DEBUG "GDROM: Non-fs request ignored\n");
+			end_request(req, 0);
+		}
+		if (rq_data_dir(req)) {
+			printk(KERN_NOTICE "GDROM: Read only device - write request ignored\n");
+			end_request(req, 0);
+		}
+		if (req->nr_sectors) {
+			gdrom_request_handler_dma(req);
+		}
+	}
+}
+
+/* Print string identifying GD ROM device */
+static void gdrom_outputversion(void)
+{
+	struct gdrom_id *id;
+	char *model_name, *manuf_name, *firmw_ver;
+	/* query device ID */
+	id = kzalloc(sizeof(struct gdrom_id), GFP_KERNEL);
+	gdrom_identifydevice(id);
+	model_name = kmalloc(17, GFP_KERNEL);
+	manuf_name = kmalloc(17, GFP_KERNEL);
+	firmw_ver = kmalloc(17, GFP_KERNEL);
+	snprintf(model_name, 16, id->modname);
+	snprintf(manuf_name, 16, id->mname);
+	snprintf(firmw_ver, 16, id->firmver);
+	printk(KERN_INFO "GDROM: %s from %s with firmware %s\n", model_name,
manuf_name, firmw_ver);
+	kfree(model_name);
+	kfree(manuf_name);
+	kfree(firmw_ver);
+	kfree(id);
+}
+
+/* set the default mode for DMA transfer */
+static void gdrom_init_dma_mode(void)
+{
+	ctrl_outb(0x13, GDROM_ERROR_REG);
+	ctrl_outb(0x22, GDROM_INTSEC_REG);
+	wait_clrbusy();
+	ctrl_outb(0xEF, GDROM_STATUSCOMMAND_REG);
+	gdrom_wait_busy_sleeps();
+}
+
+/*
+ * register this as a block device and as compliant with the
+ * universal CD Rom driver interface
+ */
+static int __init probe_gdrom(struct platform_device *devptr)
+{
+	char err;
+	gd.toc = NULL;
+	err = gdrom_execute_diagnostic();
+	if (err == 1)
+		gdrom_outputversion();	
+	else {
+		printk(KERN_WARNING "Probe for GDROM failed with error 0x%X\n", err);	
+		return -ENODEV;
+	}
+
+	gdrom_major = register_blkdev(0, GDROM_DEV_NAME);
+	if (gdrom_major <= 0)
+		return gdrom_major;
+	printk(KERN_INFO "GDROM: Block device is registered with major
number %d\n", gdrom_major);
+	gd.cd_info = kzalloc(sizeof(struct cdrom_device_info), GFP_KERNEL);
+	if (!gd.cd_info) {
+		err = -ENOMEM;
+		goto probe_fail_no_mem;
+	}
+	gd.cd_info->ops = &gdrom_ops;
+	gd.cd_info->capacity = 1;
+	sprintf(gd.cd_info->name, GDROM_DEV_NAME);
+	gd.cd_info->mask = CDC_CLOSE_TRAY|CDC_OPEN_TRAY|CDC_LOCK|CDC_SELECT_DISC;
+	gd.disk = alloc_disk(1);
+	if (!gd.disk) {
+		err = -ENODEV;
+		goto probe_fail_no_disk;
+	}
+	gd.disk->major = gdrom_major;
+	gd.disk->first_minor = 1;
+	gd.disk->minors = 1;
+	sprintf(gd.disk->disk_name, GDROM_DEV_NAME);
+
+	if (register_cdrom(gd.cd_info)){
+		err = -ENODEV;
+		goto probe_fail_cdrom_register;
+	}
+	gd.disk->fops = &gdrom_bdops;
+	/* latch on to the interrupt */
+	err = gdrom_set_command_interrupt_handler();
+	if (err)
+		goto probe_fail_cmdirq_register;
+	err = gdrom_set_dma_interrupt_handler();
+	if (err)
+		goto probe_fail_dmairq_register;
+	gd.gdrom_rq = blk_init_queue(gdrom_request, &gdrom_lock);
+	if (!gd.gdrom_rq)
+		goto probe_fail_requestq;
+	blk_queue_hardsect_size(gd.gdrom_rq, GDROM_HARD_SECTOR);
+	/* using DMA so memory will need to be contiguous */
+	blk_queue_max_hw_segments(gd.gdrom_rq, 1);
+	/* set a large max size to get most from DMA */
+	blk_queue_max_segment_size(gd.gdrom_rq, 0x40000);
+	gd.disk->queue = gd.gdrom_rq;
+	gdrom_init_dma_mode();
+	add_disk(gd.disk);
+	return 0;
+
+probe_fail_requestq:
+	free_irq(HW_EVENT_GDROM_DMA, &gd);
+probe_fail_dmairq_register:
+	free_irq(HW_EVENT_GDROM_CMD, &gd);
+probe_fail_cmdirq_register:
+probe_fail_cdrom_register:
+	del_gendisk(gd.disk);
+probe_fail_no_disk:
+	kfree(gd.cd_info);
+	unregister_blkdev(gdrom_major, GDROM_DEV_NAME);
+	gdrom_major = 0;
+probe_fail_no_mem:
+	printk(KERN_WARNING "GDROM: Could not probe for device - error is
0x%X\n", err);
+	return err;
+}
+
+static int remove_gdrom(struct platform_device *devptr)
+{
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
+
+	rc = platform_driver_register(&gdrom_driver);
+	if (rc) {
+		printk(KERN_INFO "Could not register GDROM driver - error 0x%X\n", rc);
+		return -EPERM;
+	}
+	pd = platform_device_register_simple(GDROM_DEV_NAME, -1, NULL, 0);
+	if (IS_ERR(pd)) {
+		platform_driver_unregister(&gdrom_driver);
+		return -ENODEV;
+	}
+	return 0;
+}
+
+static void __exit exit_gdrom(void)
+{
+	blk_cleanup_queue(gd.gdrom_rq);
+	free_irq(HW_EVENT_GDROM_CMD, &gd);
+	free_irq(HW_EVENT_GDROM_DMA, &gd);
+	del_gendisk(gd.disk);
+	if (gdrom_major)
+		unregister_blkdev(gdrom_major, GDROM_DEV_NAME);
+	platform_device_unregister(pd);
+	platform_driver_unregister(&gdrom_driver);
+	if (gd.toc)
+		kfree(gd.toc);
+}
+
+module_init(init_gdrom);
+module_exit(exit_gdrom);
+MODULE_AUTHOR("Adrian McMenamin <adrian@mcmen.demon.co.uk>");
+MODULE_DESCRIPTION("GD-ROM Driver");
+MODULE_LICENSE("GPL");
