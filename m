Return-Path: <linux-kernel-owner+w=401wt.eu-S1753762AbYKMT0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762AbYKMT0j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 14:26:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751817AbYKMT03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 14:26:29 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:7816 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbYKMT01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 14:26:27 -0500
Message-ID: <491C7F28.2070507@caviumnetworks.com>
Date: Thu, 13 Nov 2008 11:25:28 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-mips <linux-mips@linux-mips.org>
Subject: [PATCH] New IDE/block driver for OCTEON SOC Compact Flash interface.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Nov 2008 19:25:28.0569 (UTC) FILETIME=[96165690:01C945C5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As part of our efforts to get the Cavium OCTEON processor support
merged (see: http://marc.info/?l=linux-mips&m=122600487218824), we
have this CF driver for your consideration.

Most OCTEON variants have *no* DMA or interrupt support on the CF
interface so a simple bit-banging approach is taken.  Although if DMA is
available, we do take advantage of it.

The register definitions are part of the chip support patch set
mentioned above, and are not included here.

At this point I would like to get feedback as to whether this is a
good approach for the CF driver, or perhaps generate ideas about other
possible approaches.

Thanks,

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
---
 drivers/ide/Kconfig     |    8 +
 drivers/ide/Makefile    |    1 +
 drivers/ide/octeon-cf.c | 1102 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 1111 insertions(+), 0 deletions(-)

diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index 6d74017..5bd28d0 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -720,6 +720,14 @@ config BLK_DEV_IDE_AU1XXX_SEQTS_PER_RQ
        default "128"
        depends on BLK_DEV_IDE_AU1XXX
 
+config BLK_DEV_OCTEON_BOOTBUS_CF
+	tristate "Support for OCTEON Boot Bus Compact Flash"
+	depends on CPU_CAVIUM_OCTEON
+	default "y"
+	help
+	  This option enables a polled compact flash driver for use with
+	  compact flash cards attached to the OCTEON boot bus.
+
 config BLK_DEV_IDE_TX4938
 	tristate "TX4938 internal IDE support"
 	depends on SOC_TX4938
diff --git a/drivers/ide/Makefile b/drivers/ide/Makefile
index 7818d40..b17f633 100644
--- a/drivers/ide/Makefile
+++ b/drivers/ide/Makefile
@@ -113,3 +113,4 @@ obj-$(CONFIG_BLK_DEV_IDE_AU1XXX)	+= au1xxx-ide.o
 
 obj-$(CONFIG_BLK_DEV_IDE_TX4938)	+= tx4938ide.o
 obj-$(CONFIG_BLK_DEV_IDE_TX4939)	+= tx4939ide.o
+obj-$(CONFIG_BLK_DEV_OCTEON_BOOTBUS_CF)	+= octeon-cf.o
diff --git a/drivers/ide/octeon-cf.c b/drivers/ide/octeon-cf.c
new file mode 100644
index 0000000..84fccc1
--- /dev/null
+++ b/drivers/ide/octeon-cf.c
@@ -0,0 +1,1102 @@
+/*
+ * Extra-simple block driver for the Octeon bootbus compact flash.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2005-2008 Cavium Networks
+ * Copyright (C) 2008 Wind River Systems
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/init.h>
+
+#include <linux/kernel.h>
+#include <linux/fs.h>
+#include <linux/errno.h>
+#include <linux/types.h>
+#include <linux/vmalloc.h>
+#include <linux/genhd.h>
+#include <linux/platform_device.h>
+#include <linux/blkdev.h>
+#include <linux/ata.h>
+#include <linux/hdreg.h>
+#include <linux/ide.h>
+#include <linux/delay.h>
+#include <linux/slab.h>
+#include <linux/jiffies.h>
+#include <linux/wait.h>
+#include <linux/workqueue.h>
+
+#include <asm/octeon/octeon.h>
+
+#define DEVICE_NAME "cf"
+MODULE_LICENSE("GPL");
+
+/*
+ * We can tweak our hardware sector size, but the kernel talks to us
+ * in terms of small sectors, always.
+ */
+#define KERNEL_SECTOR_SIZE 512
+
+/* Timing multiple used for configuring the boot bus DMA engine */
+#define CF_DMA_TIMING_MULT	4
+
+/*
+ * The internal representation of our device.
+ */
+struct cf_device {
+	void *base_ptr;
+	int irq;
+	unsigned long num_sectors;
+	unsigned long sector_size;
+	struct gendisk *gd;
+	struct hd_geometry geo;
+	spinlock_t lock;
+	struct request_queue *queue;
+	struct workqueue_struct *workqueue;
+	struct work_struct cf_work;
+	struct platform_device *pdev;
+	int is16bit;
+	int is_true_ide;	/* is16bit must also be set */
+	int use_dma;
+	int dma_channel;
+	int dma_mode;		/* CF mwdma mode */
+	wait_queue_head_t waitq;
+	int dma_done;		/* Set to true when finished.  */
+};
+
+static struct cf_device STATIC_DEVICE;
+
+static int use_cf_dma = 1;
+
+/**
+ * Called to enable the use of DMA based on kernel command line.
+ */
+void octeon_cf_enable_dma(void)
+{
+	use_cf_dma = 1;
+}
+
+static irqreturn_t octeon_cf_interrupt(int cpl, void *dev_id)
+{
+	cvmx_mio_boot_dma_intx_t dma_int;
+	struct cf_device *cf = dev_id;
+	/* Check to see if DMA channel 0 is done */
+	dma_int.u64 = cvmx_read_csr(CVMX_MIO_BOOT_DMA_INTX(cf->dma_channel));
+	if (dma_int.s.done) {
+		cvmx_write_csr(CVMX_MIO_BOOT_DMA_INTX(cf->dma_channel),
+			       dma_int.u64);
+		cf->dma_done = 1;
+		wake_up_all(&cf->waitq);
+		return IRQ_HANDLED;
+	}
+	return IRQ_NONE;
+}
+
+/**
+ * Check if the Compact flash is idle and doesn't have any
+ * errors.
+ *
+ * @cf:     Device to check
+ * Returns Zero on success
+ */
+static inline int octeon_cf_wait_idle(struct cf_device *cf)
+{
+	unsigned char status;
+	unsigned long timeout = jiffies + HZ;
+
+	if (cf->is_true_ide) {
+		status = __raw_readw(cf->base_ptr + 14) & 0xff;
+		while (status & 0x80) {
+			if (unlikely(time_after(jiffies, timeout)))
+				break;
+			udelay(5);
+			status = __raw_readw(cf->base_ptr + 14) & 0xff;
+		}
+	} else if (cf->is16bit) {
+		status = __raw_readw(cf->base_ptr + 6) >> 8;
+		while (status & 0x80) {
+			if (unlikely(time_after(jiffies, timeout)))
+				break;
+			udelay(5);
+			status = __raw_readw(cf->base_ptr + 6) >> 8;
+		}
+	} else {
+		status = __raw_readb(cf->base_ptr + 7);
+		while (status & 0x80) {
+			if (unlikely(time_after(jiffies, timeout)))
+				break;
+			udelay(5);
+			status = __raw_readb(cf->base_ptr + 7);
+		}
+	}
+
+	if (unlikely(status & 0x80)) {
+		if (cf->gd)
+			pr_warning("%s: Timeout\n", cf->gd->disk_name);
+		return -1;
+	} else if (unlikely(status & 1)) {
+		if (cf->gd)
+			pr_err("%s: Error\n", cf->gd->disk_name);
+		return -1;
+	} else
+		return 0;
+}
+
+
+/**
+ * Wait for data request ready
+ *
+ * @cf:     Device to check
+ * Returns Zero on success
+ */
+static inline int octeon_cf_wait_drq_ready(struct cf_device *cf)
+{
+	unsigned char status;
+	unsigned long timeout = jiffies + HZ;
+
+	if (cf->is_true_ide) {
+		status = __raw_readw(cf->base_ptr + 14) & 0xff;
+		while ((status & 0x08) == 0) {
+			if (unlikely(time_after(jiffies, timeout)))
+				break;
+			udelay(1);
+			status = __raw_readw(cf->base_ptr + 14) & 0xff;
+		}
+	} else if (cf->is16bit) {
+		status = __raw_readw(cf->base_ptr + 6) >> 8;
+		while ((status & 0x08) == 0) {
+			if (unlikely(time_after(jiffies, timeout)))
+				break;
+			udelay(1);
+			status = __raw_readw(cf->base_ptr + 6) >> 8;
+		}
+	} else {
+		status = __raw_readb(cf->base_ptr + 7);
+		while ((status & 0x08) == 0) {
+			if (unlikely(time_after(jiffies, timeout)))
+				break;
+			udelay(1);
+			status = __raw_readb(cf->base_ptr + 7);
+		}
+	}
+
+	if (unlikely((status & 0x08) == 0)) {
+		if (cf->gd)
+			pr_warning("%s: Timeout\n", cf->gd->disk_name);
+		return -1;
+	} else
+		return 0;
+}
+
+/**
+ * Send low level ATA command to the device
+ *
+ * @cf:      Device to send commadn to
+ * @sectors: Number of sectors for access
+ * @lba:     Logical block address
+ * @command: ATA command
+ * @features: feature for set feature command, only used
+ * 		   in true IDE mode
+ * Returns Zero on success
+ */
+static int octeon_cf_command(struct cf_device *cf, int sectors,
+			     unsigned long lba, int command, int features)
+{
+	/* Wait to not be busy before we start */
+	if (octeon_cf_wait_idle(cf))
+		return -1;
+
+	if (cf->is_true_ide) {
+		if (features)  /* Feature 0 is not valid */
+			__raw_writew(features & 0xff, cf->base_ptr + 2);
+		__raw_writew(sectors, cf->base_ptr + 4);
+		__raw_writew(lba & 0xff, cf->base_ptr + 6);
+		__raw_writew((lba >> 8) & 0xff, cf->base_ptr + 8);
+		__raw_writew((lba >> 16) & 0xff, cf->base_ptr + 10);
+		__raw_writew(((lba >> 24) & 0x0f) | 0xe0, cf->base_ptr + 12);
+		__raw_writew(command, cf->base_ptr + 14);
+	} else if (cf->is16bit) {
+		__raw_writew(sectors | ((lba & 0xff) << 8), cf->base_ptr + 2);
+		__raw_writew(lba >> 8, cf->base_ptr + 4);
+		__raw_writew(((lba >> 24) & 0x0f) | 0xe0 | command << 8,
+			     cf->base_ptr + 6);
+	} else {
+		__raw_writeb(sectors, cf->base_ptr + 2);
+		__raw_writeb(lba & 0xff, cf->base_ptr + 3);
+		__raw_writeb((lba >> 8) & 0xff, cf->base_ptr + 4);
+		__raw_writeb((lba >> 16) & 0xff, cf->base_ptr + 5);
+		__raw_writeb(((lba >> 24) & 0x0f) | 0xe0, cf->base_ptr + 6);
+		__raw_writeb(command, cf->base_ptr + 7);
+	}
+
+	return 0;
+}
+
+/**
+ * Identify the compact flash
+ *
+ * @cf:         Device to access
+ * @drive_info: IDE drive information
+ * Returns Zero on success
+ */
+static int octeon_cf_identify_drive(struct cf_device *cf,
+				    struct hd_driveid *drive_info)
+{
+	if (octeon_cf_command(cf, 0, 0, ATA_CMD_ID_ATA, 0))
+		return -1;
+
+	/* Wait for read to complete (BSY clear) */
+	if (octeon_cf_wait_idle(cf))
+		return -1;
+	if (cf->is16bit) {
+		uint16_t *ptr = (uint16_t *)drive_info;
+		int count;
+		for (count = 0; count < sizeof(*drive_info); count += 2)
+			*ptr++ = readw(cf->base_ptr);	/* Swaps internally */
+	} else {
+		unsigned char *ptr = (unsigned char *) drive_info;
+		int count;
+		for (count = 0; count < sizeof(*drive_info); count++)
+			*ptr++ = readb(cf->base_ptr);
+	}
+	ide_fix_driveid((uint16_t *)drive_info);
+	ide_fixstring(drive_info->model, sizeof(drive_info->model), 0);
+	ide_fixstring(drive_info->fw_rev, sizeof(drive_info->fw_rev), 0);
+	ide_fixstring(drive_info->serial_no, sizeof(drive_info->serial_no), 0);
+	return 0;
+}
+
+/**
+ * Read sectors from the device
+ *
+ * @cf:        Device to read from
+ * @lba_start: Start sector
+ * @num_sectors:
+ *                  Number of sectors to read
+ * @buffer:    Buffer to put the results in
+ * Returns Number of sectors read
+ */
+static unsigned int octeon_cf_read(struct cf_device *cf,
+				   unsigned long lba_start,
+				   unsigned long num_sectors,
+				   char *buffer)
+{
+	unsigned int sectors_read = 0;
+
+	while (sectors_read < num_sectors) {
+		int count;
+		int sectors_to_read = num_sectors;
+
+		if (sectors_to_read > 256)
+			sectors_to_read = 256;
+
+		if (octeon_cf_command(cf, sectors_to_read & 0xff,
+				      lba_start, ATA_CMD_PIO_READ, 0))
+			goto done;
+		lba_start += sectors_to_read;
+
+		while (sectors_to_read--) {
+			/* Wait for read to complete (BSY clear) */
+			if (octeon_cf_wait_idle(cf))
+				goto done;
+			if (octeon_cf_wait_drq_ready(cf))
+				goto done;
+
+			if (cf->is16bit) {
+				uint16_t *ptr = (uint16_t *) buffer;
+				for (count = 0; count < cf->sector_size;
+				     count += 2)
+					*ptr++ = readw(cf->base_ptr);
+				buffer += cf->sector_size;
+			} else {
+				for (count = 0; count < cf->sector_size;
+				     count++)
+					*buffer++ = readb(cf->base_ptr);
+			}
+			sectors_read++;
+		}
+	}
+done:
+	return sectors_read;
+}
+
+
+/**
+ * Read sectors from the device, using DMA
+ *
+ * @cf:        Device to read from
+ * @lba_start: Start sector
+ * @num_sectors:
+ *                  Number of sectors to read
+ * @buffer:    Buffer to put the results in
+ * Returns Number of sectors read
+ */
+static unsigned int octeon_cf_read_dma(struct cf_device *cf,
+				       unsigned long lba_start,
+				       unsigned long num_sectors,
+				       char *buffer)
+{
+	unsigned int sectors_read = 0;
+	cvmx_mio_boot_dma_cfgx_t dma_cfg;
+	dma_addr_t dma_addr;
+	long to;
+
+	dma_addr = dma_map_single(&cf->pdev->dev, buffer,
+				  num_sectors * KERNEL_SECTOR_SIZE,
+				  DMA_FROM_DEVICE);
+
+	while (sectors_read < num_sectors) {
+		int sectors_to_read = num_sectors - sectors_read;
+
+		/* Wait for read to complete (BSY clear) */
+		if (octeon_cf_wait_idle(cf)) {
+			pr_warning("CF not idle....\n");
+			goto done;
+		}
+
+		if (cf->dma_mode < 4)
+			udelay(10); /* 10 OK,   5 bad
+				       1, 0 OK with lexar */
+
+		if (sectors_to_read > 256)
+			sectors_to_read = 256;
+
+
+		cf->dma_done = 0;
+
+		/* Setup DMA engine */
+		dma_cfg.u64 = 0;
+		dma_cfg.s.en = 1;
+		dma_cfg.s.rw = 0;
+		dma_cfg.s.swap8 = 1;
+		dma_cfg.s.adr = cvmx_ptr_to_phys((void *)dma_addr);
+		dma_cfg.s.size = sectors_to_read * (KERNEL_SECTOR_SIZE / 2) - 1;
+		cvmx_write_csr(CVMX_MIO_BOOT_DMA_CFGX(cf->dma_channel),
+			       dma_cfg.u64);
+
+		/* Send CF read DMA command */
+		if (octeon_cf_command(cf, sectors_to_read & 0xff,
+				      lba_start, ATA_CMD_READ, 0)) {
+			pr_err("ATA command failed\n");
+			goto done;
+		}
+
+		to = wait_event_timeout(cf->waitq, cf->dma_done,
+					msecs_to_jiffies(2000));
+
+		if (to == 0) {
+			pr_err("Timeout waiting for DMA completion\n");
+			goto done;
+		}
+		sectors_read += sectors_to_read;
+		buffer += sectors_to_read * KERNEL_SECTOR_SIZE;
+		lba_start += sectors_to_read;
+
+
+	}
+done:
+	cvmx_write_csr(CVMX_MIO_BOOT_DMA_CFGX(cf->dma_channel), 0ull);
+
+	dma_unmap_single(&cf->pdev->dev, dma_addr,
+			 num_sectors * KERNEL_SECTOR_SIZE, DMA_FROM_DEVICE);
+
+	if (octeon_cf_wait_idle(cf))
+		pr_warning("CF not idle....\n");
+
+	if (cf->dma_mode < 4)
+		udelay(10); /* 10 works on sandisk @ 700 Mhz */
+	return sectors_read;
+}
+
+
+/**
+ * Write sectors to the device
+ *
+ * @cf:        Device to write to
+ * @lba_start: Starting sector number
+ * @num_sectors:
+ *                  Number of sectors to write
+ * @buffer:    Data buffer to write
+ * Returns Number of sectors written
+ */
+static unsigned int octeon_cf_write_dma(struct cf_device *cf,
+					unsigned long lba_start,
+					unsigned long num_sectors,
+					char *buffer)
+{
+	unsigned int sectors_written = 0;
+	cvmx_mio_boot_dma_cfgx_t dma_cfg;
+	dma_addr_t dma_addr;
+	long to;
+
+	dma_addr = dma_map_single(&cf->pdev->dev, buffer,
+				  num_sectors * KERNEL_SECTOR_SIZE,
+				  DMA_TO_DEVICE);
+	while (sectors_written < num_sectors) {
+		int sectors_to_write = num_sectors - sectors_written;
+
+		/* Wait for read to complete (BSY clear) */
+		if (octeon_cf_wait_idle(cf)) {
+			pr_warning("CF not idle....\n");
+			goto done;
+		}
+
+		if (cf->dma_mode < 4)
+			udelay(10); /* 10 OK, 5 bad with sandisk
+					1 OK with lexar */
+
+		if (sectors_to_write > 256)
+			sectors_to_write = 256;
+
+
+		cf->dma_done = 0;
+
+		/* Setup DMA engine */
+		dma_cfg.u64 = 0;
+		dma_cfg.s.en = 1;
+		dma_cfg.s.rw = 1;
+		dma_cfg.s.swap8 = 1;
+		dma_cfg.s.adr = cvmx_ptr_to_phys((void *)dma_addr);
+		dma_cfg.s.size = sectors_to_write * (KERNEL_SECTOR_SIZE / 2) - 1;
+		cvmx_write_csr(CVMX_MIO_BOOT_DMA_CFGX(cf->dma_channel),
+			       dma_cfg.u64);
+
+		/* Send CF read DMA command */
+		if (octeon_cf_command(cf, sectors_to_write & 0xff,
+				      lba_start, ATA_CMD_WRITE, 0)) {
+			pr_err("ATA command failed\n");
+			goto done;
+		}
+
+		to = wait_event_timeout(cf->waitq, cf->dma_done,
+					msecs_to_jiffies(2000));
+
+		if (to == 0) {
+			pr_err("Timeout waiting for DMA completion\n");
+			goto done;
+		}
+		sectors_written += sectors_to_write;
+		buffer += sectors_to_write * KERNEL_SECTOR_SIZE;
+		lba_start += sectors_to_write;
+
+
+	}
+done:
+
+	cvmx_write_csr(CVMX_MIO_BOOT_DMA_CFGX(cf->dma_channel), 0ull);
+	dma_unmap_single(&cf->pdev->dev, dma_addr,
+			 num_sectors * KERNEL_SECTOR_SIZE, DMA_TO_DEVICE);
+	if (octeon_cf_wait_idle(cf))
+		pr_warning("CF not idle....\n");
+
+	return sectors_written;
+}
+/**
+ * Write sectors to the device
+ *
+ * @cf:        Device to write to
+ * @lba_start: Starting sector number
+ * @num_sectors:
+ *                  Number of sectors to write
+ * @buffer:    Data buffer to write
+ * Returns Number of sectors written
+ */
+static unsigned int octeon_cf_write(struct cf_device *cf,
+				unsigned long lba_start,
+				unsigned long num_sectors,
+				const char *buffer)
+{
+	unsigned int sectors_written = 0;
+
+	while (sectors_written < num_sectors) {
+		int count;
+		int sectors_to_write = num_sectors;
+
+		if (sectors_to_write > 256)
+			sectors_to_write = 256;
+
+		if (octeon_cf_command(cf, sectors_to_write & 0xff,
+				      lba_start, ATA_CMD_PIO_WRITE, 0))
+			goto done;
+		lba_start += sectors_to_write;
+
+		while (sectors_to_write--) {
+			/*
+			 * Wait for write command to be ready for data
+			 * (BSY clear).
+			 */
+			if (octeon_cf_wait_idle(cf))
+				goto done;
+			if (octeon_cf_wait_drq_ready(cf))
+				goto done;
+
+			if (cf->is16bit) {
+				const uint16_t *ptr = (const uint16_t *) buffer;
+				for (count = 0; count < cf->sector_size;
+				     count += 2) {
+					writew(*ptr++, cf->base_ptr);
+					/* Every 16 writes do a read so the
+					   bootbus FIFO doesn't fill up */
+					if (count && ((count & 0x1f) == 0))
+						__raw_readw(cf->base_ptr + 6);
+				}
+				buffer += cf->sector_size;
+			} else {
+				for (count = 0; count < cf->sector_size;
+				     count++) {
+					writeb(*buffer++, cf->base_ptr);
+					/* Every 16 writes do a read so the
+					   bootbus FIFO doesn't fill up */
+					if (count && ((count & 0xf) == 0))
+						__raw_readb(cf->base_ptr + 7);
+				}
+			}
+			sectors_written++;
+		}
+	}
+done:
+	return sectors_written;
+}
+
+static unsigned int div_roundup(unsigned int n, unsigned int d)
+{
+	return (n + d - 1) / d;
+}
+
+/**
+ * Convert nanosecond based time to setting used in the
+ * boot bus timing register, based on timing multiple
+ */
+static unsigned int ns_to_tim_reg(int tim_mult, uint32_t nsecs)
+{
+	unsigned int val;
+
+	/*
+	 * Compute # of eclock periods to get desired duration in
+	 * nanoseconds.
+	 */
+	val = div_roundup(nsecs * (cvmx_sysinfo_get()->cpu_clock_hz / 1000000),
+			  1000);
+
+	/* Factor in timing multiple, if not 1 */
+	if (tim_mult != 1)
+		val = div_roundup(val, tim_mult);
+
+	return val;
+}
+
+static uint64_t octeon_cf_generate_dma_tim(int tim_mult, uint16_t *ident_data,
+					   int *mwdma_mode_ptr)
+{
+
+	cvmx_mio_boot_dma_timx_t dma_tim;
+	int oe_a;
+	int oe_n;
+	int dma_acks;
+	int dma_ackh;
+	int dma_arq;
+	int pause;
+	int To, Tkr, Td;
+	int mwdma_mode = -1;
+	uint16_t word53_field_valid;
+	uint16_t word63_mwdma;
+	uint16_t word163_adv_timing_info;
+
+	if (!ident_data)
+		return 0;
+
+	word53_field_valid = ident_data[53];
+	word63_mwdma = ident_data[63];
+	word163_adv_timing_info = ident_data[163];
+
+	dma_tim.u64 = 0;
+
+	/* Check for basic MWDMA modes */
+	if (word53_field_valid & 0x2) {
+		if (word63_mwdma & 0x4)
+			mwdma_mode = 2;
+		else if (word63_mwdma & 0x2)
+			mwdma_mode = 1;
+		else if (word63_mwdma & 0x1)
+			mwdma_mode = 0;
+	}
+
+	/* Check for advanced MWDMA modes */
+	switch ((word163_adv_timing_info >> 3) & 0x7) {
+	case 1:
+		mwdma_mode = 3;
+		break;
+	case 2:
+		mwdma_mode = 4;
+		break;
+	default:
+		break;
+
+	}
+	/* DMA is not supported by this card */
+	if (mwdma_mode < 0)
+		return 0;
+
+	/* Now set up the DMA timing */
+	switch (tim_mult) {
+	case 1:
+		dma_tim.s.tim_mult = 1;
+		break;
+	case 2:
+		dma_tim.s.tim_mult = 2;
+		break;
+	case 4:
+		dma_tim.s.tim_mult = 0;
+		break;
+	case 8:
+		dma_tim.s.tim_mult = 3;
+		break;
+	default:
+		cvmx_dprintf("ERROR: invalid boot bus dma tim_mult setting\n");
+		break;
+	}
+
+	switch (mwdma_mode) {
+	case 4:
+		To = 80;
+		Td = 55;
+		Tkr = 20;
+		/* Td (Seem to need more margin here.... */
+		oe_a = Td + 20;
+		/* Tkr from cf spec, lengthened to meet To */
+		oe_n = max(To - oe_a, Tkr);
+
+		/* oe_n + oe_h must be >= To (cycle time) */
+		dma_acks = 0;	/*Ti */
+		dma_ackh = 5;	/* Tj */
+		/* not spec'ed, value in eclocks, not affected by tim_mult */
+		dma_arq = 8;
+		pause = 25 - dma_arq * 1000 /
+			(cvmx_sysinfo_get()->cpu_clock_hz / 1000000); /* Tz */
+		break;
+	case 3:
+		To = 100;
+		Td = 65;
+		Tkr = 20;
+		/* Td (Seem to need more margin here.... */
+		oe_a = Td + 20;
+		/* Tkr from cf spec, lengthened to meet To */
+		oe_n = max(To - oe_a, Tkr);
+
+		/* oe_n + oe_h must be >= To (cycle time) */
+		dma_acks = 0;	/*Ti */
+		dma_ackh = 5;	/* Tj */
+		/* not spec'ed, value in eclocks, not affected by tim_mult */
+		dma_arq = 8;
+		pause = 25 - dma_arq * 1000 /
+			(cvmx_sysinfo_get()->cpu_clock_hz / 1000000);	/* Tz */
+		break;
+	case 2:
+		/* +20 works */
+		/* +10 works */
+		/* + 10 + 0 fails */
+		/* n=40, a=80 works */
+		To = 120;
+		Td = 70;
+		Tkr = 25;
+
+		/* oe_a 0 fudge doesn't work; 10 seems to */
+		oe_a = Td + 20 + 10; /* Td Seem to need more margin here. */
+		/* Tkr from cf spec, lengthened to meet To */
+		oe_n = max(To - oe_a, Tkr) + 10;
+		/* oe_n 0 fudge fails;;; 10 boots */
+
+		/* 20 ns fudge needed on dma_acks */
+		/* oe_n + oe_h must be >= To (cycle time) */
+		dma_acks = 0 + 20;	/*Ti */
+		dma_ackh = 5;	/* Tj */
+
+		/* not spec'ed, value in eclocks, not affected by tim_mult */
+		dma_arq = 8;
+		pause = 25 - dma_arq * 1000 /
+			(cvmx_sysinfo_get()->cpu_clock_hz / 1000000);	/* Tz */
+		/* no fudge needed on pause */
+
+		break;
+	case 1:
+	case 0:
+	default:
+		pr_err("ERROR: Unsupported DMA mode: %d\n", mwdma_mode);
+		return -1;
+		break;
+	}
+
+	if (mwdma_mode_ptr)
+		*mwdma_mode_ptr = mwdma_mode;
+
+	dma_tim.s.dmack_pi = 1;
+
+	dma_tim.s.oe_n = ns_to_tim_reg(tim_mult, oe_n);
+	dma_tim.s.oe_a = ns_to_tim_reg(tim_mult, oe_a);
+
+	dma_tim.s.dmack_s = ns_to_tim_reg(tim_mult, dma_acks);
+	dma_tim.s.dmack_h = ns_to_tim_reg(tim_mult, dma_ackh);
+
+	dma_tim.s.dmarq = dma_arq;
+	dma_tim.s.pause = ns_to_tim_reg(tim_mult, pause);
+
+	dma_tim.s.rd_dly = 0;	/* Sample right on edge */
+
+	/*  writes only */
+	dma_tim.s.we_n = ns_to_tim_reg(tim_mult, oe_n);
+	dma_tim.s.we_a = ns_to_tim_reg(tim_mult, oe_a);
+
+#if 0
+	pr_info("ns to ticks (mult %d) of %d is: %d\n", TIM_MULT, 60,
+		     ns_to_tim_reg(60));
+	pr_info("oe_n: %d, oe_a: %d, dmack_s: %d, dmack_h: "
+		"%d, dmarq: %d, pause: %d\n",
+		dma_tim.s.oe_n, dma_tim.s.oe_a, dma_tim.s.dmack_s,
+		dma_tim.s.dmack_h, dma_tim.s.dmarq, dma_tim.s.pause);
+#endif
+
+	return dma_tim.u64;
+}
+
+/**
+ * Identify a compact flash disk
+ *
+ * @cf:     Device to check and update
+ * Returns Zero on success. Failure will result in a device of zero
+ *         size and a -1 return code.
+ */
+static int octeon_cf_identify(struct cf_device *cf)
+{
+	struct hd_driveid drive_info;
+	cvmx_mio_boot_dma_int_enx_t dma_int_en;
+	int result;
+	uint64_t dma_tim;
+
+	memset(&drive_info, 0, sizeof(drive_info));
+
+	result = octeon_cf_identify_drive(cf, &drive_info);
+	if (result == 0) {
+		/* Sandisk 1G reports the wrong sector size */
+		drive_info.sector_bytes = KERNEL_SECTOR_SIZE;
+		pr_info("%s: %s Serial %s (%u sectors, %u bytes/sector)\n",
+		       (cf->gd) ? cf->gd->disk_name : DEVICE_NAME,
+		       drive_info.model, drive_info.serial_no,
+		       drive_info.lba_capacity, (int) drive_info.sector_bytes);
+		cf->num_sectors = drive_info.lba_capacity;
+		cf->sector_size = drive_info.sector_bytes;
+		cf->geo.cylinders = drive_info.cyls;
+		cf->geo.heads = drive_info.heads;
+		cf->geo.sectors = drive_info.sectors;
+		cf->geo.start = 0;
+	} else {
+		cf->num_sectors = 0;
+		cf->sector_size = KERNEL_SECTOR_SIZE;
+	}
+
+	if (!use_cf_dma || !cf->is_true_ide)
+		goto out;
+
+	dma_tim = octeon_cf_generate_dma_tim(CF_DMA_TIMING_MULT,
+					     (void *)&drive_info,
+					     &(cf->dma_mode));
+	if (dma_tim) {
+		/* Request the interrupt */
+		if (request_irq(cf->irq, octeon_cf_interrupt,
+				IRQF_SHARED, DEVICE_NAME, cf)) {
+			pr_err("%s: Could not obtain irq %d.  DMA disabled.\n",
+				DEVICE_NAME, cf->irq);
+			goto out;
+		}
+
+		/* CF slot on ebh5200, ebh5600 wired to channel 0 */
+		cf->dma_channel = 0;
+		cf->use_dma = 1;
+
+		pr_info("%s: using MWDMA mode %d, dma channel %d\n",
+			(cf->gd) ? cf->gd->disk_name : DEVICE_NAME,
+			 cf->dma_mode, cf->dma_channel);
+		cvmx_write_csr(CVMX_MIO_BOOT_DMA_TIMX(cf->dma_channel),
+			       dma_tim);
+
+		/*
+		 * Select the DMA mode that we want to use (this does
+		 * not seem to be needed or help).
+		 */
+		if (octeon_cf_command(cf, (0x4 << 3) | cf->dma_mode,
+				      0, ATA_CMD_SET_FEATURES, 0x3)) {
+			pr_err("ERROR setting DMA mode\n");
+		}
+
+		/*
+		 * Get the drive info again to verify setting
+		 * of DMA mode.
+		 */
+		result = octeon_cf_identify_drive(cf, &drive_info);
+		if (0 && result == 0) {
+			pr_info("%s: MWDMA after set: 0x%x, w163: 0x%x\n",
+				(cf->gd) ? cf->gd->disk_name : DEVICE_NAME,
+				drive_info.dma_mword,
+				drive_info.words161_175[2]);
+		}
+		/* Enable interrupts for DMA completion */
+		dma_int_en.u64 = cvmx_read_csr(CVMX_MIO_BOOT_DMA_INT_ENX(cf->dma_channel));
+		dma_int_en.s.done = 1;
+		cvmx_write_csr(CVMX_MIO_BOOT_DMA_INT_ENX(cf->dma_channel),
+			       dma_int_en.u64);
+		pr_info("%s: using IRQ DMA completion notification\n",
+			(cf->gd) ? cf->gd->disk_name : DEVICE_NAME);
+	} else
+		pr_warning("%s: MWDMA not supported.\n",
+			   (cf->gd) ? cf->gd->disk_name : DEVICE_NAME);
+out:
+	return result;
+}
+
+
+/**
+ * Handle an I/O request.
+ *
+ * @cf:         Device to access
+ * @lba_sector: Starting sector
+ * @num_sectors:
+ *                   Number of sectors to transfer
+ * @buffer:     Data buffer
+ * @write:      Is the a write. Default to a read
+ */
+static unsigned int octeon_cf_transfer(struct cf_device *cf,
+				unsigned long lba_sector,
+				unsigned long num_sectors, char *buffer,
+				int write)
+{
+	if ((lba_sector + num_sectors) > cf->num_sectors) {
+		pr_err("%s: Attempt to access beyond end of device "
+		       "(%ld > %ld)\n", cf->gd->disk_name,
+			lba_sector + num_sectors - 1, cf->num_sectors - 1);
+		num_sectors = cf->num_sectors - lba_sector;
+		if (num_sectors <= 0)
+			return 0;
+	}
+
+	if (write)
+		if (cf->use_dma)
+			return octeon_cf_write_dma(cf, lba_sector,
+						   num_sectors, buffer);
+		else
+			return octeon_cf_write(cf, lba_sector,
+					       num_sectors, buffer);
+	else
+		if (cf->use_dma)
+			return octeon_cf_read_dma(cf, lba_sector,
+						  num_sectors, buffer);
+		else
+			return octeon_cf_read(cf, lba_sector,
+					      num_sectors, buffer);
+}
+
+/**
+ * Handle queued IO requests
+ *
+ * @q:      queue of requests
+ */
+static void octeon_cf_request(struct request_queue *q)
+{
+	/*
+	 * The CF can be slow.  Execute the requests on their own thread.
+	 */
+	struct request *req = elv_next_request(q);
+	if (req) {
+		struct cf_device *cf = req->rq_disk->private_data;
+		queue_work(cf->workqueue, &cf->cf_work);
+	}
+}
+
+/**
+ * Do the real work here on the workqueue thread.
+ */
+static void octeon_cf_work(struct work_struct *work)
+{
+	struct cf_device *cf;
+	struct request *req;
+	int count;
+	int error;
+	unsigned long flags;
+
+	cf = container_of(work, struct cf_device, cf_work);
+
+	/* We need the queue lock */
+	spin_lock_irqsave(&cf->lock, flags);
+	while ((req = elv_next_request(cf->queue)) != NULL) {
+		if (!blk_fs_request(req)) {
+			pr_warning("%s: Skip non-CMD request\n",
+				   req->rq_disk->disk_name);
+			end_request(req, 0);
+			continue;
+		}
+		/*
+		 * Drop the lock and enable interrupts while we
+		 * process the request.
+		 */
+		spin_unlock_irqrestore(&cf->lock, flags);
+		count = octeon_cf_transfer(cf, req->sector,
+					   req->current_nr_sectors,
+					   req->buffer,
+					   rq_data_dir(req));
+		/* Reacquire the lock.  */
+		spin_lock_irqsave(&cf->lock, flags);
+		error = (count == req->current_nr_sectors) ? 0 : -EIO;
+		__blk_end_request(req, error, count * KERNEL_SECTOR_SIZE);
+	}
+	spin_unlock_irqrestore(&cf->lock, flags);
+}
+
+int octeon_cf_ioctl(struct block_device *bdev, fmode_t mode,
+		     unsigned int cmd, unsigned long arg)
+{
+	struct gendisk *disk = bdev->bd_disk;
+	struct cf_device *cf = disk->private_data;
+	struct hd_geometry geo;
+	switch (cmd) {
+	case HDIO_GETGEO:
+		if (!arg)
+			return -EINVAL;
+		memcpy(&geo, &cf->geo, sizeof(geo));
+		geo.start = get_start_sect(bdev);
+		if (copy_to_user((struct hd_geometry __user *) arg,
+				 &geo, sizeof(geo)))
+			return -EFAULT;
+		return 0;
+	}
+	return -ENOTTY;		/* unknown command */
+}
+
+
+static struct block_device_operations octeon_cf_ops = {
+	.owner = THIS_MODULE,
+	.ioctl = octeon_cf_ioctl
+};
+
+static int __devinit octeon_cf_probe(struct platform_device *dev)
+{
+	struct resource *res;
+
+	struct cf_device *cf = &STATIC_DEVICE;
+	unsigned long base_addr;
+	int major_num;
+	int region;
+
+	memset(cf, 0, sizeof(*cf));
+	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
+	if (!res)
+		goto out;
+
+	cf->pdev = dev;
+	base_addr = res->start;
+	cf->base_ptr = (void *)PHYS_TO_XKSEG_UNCACHED(base_addr);
+
+	cf->irq = platform_get_irq(dev, 0);
+
+	/* Determine from base address is in true IDE mode or not */
+	if (cf->irq >= 0)
+		cf->is_true_ide = 1;
+
+	cf->workqueue = create_singlethread_workqueue(DEVICE_NAME "-worker");
+	if (cf->workqueue == NULL) {
+		pr_err(DEVICE_NAME ": unable to create workqueue\n");
+		goto out;
+	}
+	cf->dma_done = 0;
+	init_waitqueue_head(&cf->waitq);
+	INIT_WORK(&cf->cf_work, octeon_cf_work);
+
+	/* Get a request queue. */
+	spin_lock_init(&cf->lock);
+	cf->queue = blk_init_queue(octeon_cf_request, &cf->lock);
+	if (cf->queue == NULL) {
+		pr_err(DEVICE_NAME
+		       ": unable to allocate block request queue\n");
+		goto out;
+	}
+	blk_queue_hardsect_size(cf->queue, KERNEL_SECTOR_SIZE);
+
+	/* None of the following seem to make the request sizes larger
+	** than 8 blocks (8*512 bytes = 4K = page size) */
+	blk_queue_max_sectors(cf->queue, 256);
+	blk_queue_max_segment_size(cf->queue, 128*1024);
+	blk_queue_max_phys_segments(cf->queue, 32);
+	blk_queue_max_hw_segments(cf->queue, 32);
+
+	/* Get registered. */
+	major_num = register_blkdev(0, DEVICE_NAME);
+	if (major_num <= 0) {
+		pr_err(DEVICE_NAME ": unable to get major number\n");
+		goto out;
+	}
+
+	/* And the gendisk structure. */
+	cf->gd = alloc_disk(64);
+	if (cf->gd == NULL) {
+		pr_err(DEVICE_NAME ": unable to allocate disk\n");
+		goto out_unregister;
+	}
+
+	/* Find the bootbus region for the CF to determine 16 or 8 bit */
+	for (region = 0; region < 8; region++) {
+		cvmx_mio_boot_reg_cfgx_t cfg;
+		cfg.u64 = cvmx_read_csr(CVMX_MIO_BOOT_REG_CFGX(region));
+		if (cfg.s.base == base_addr >> 16) {
+			cf->is16bit = cfg.s.width;
+			pr_notice(DEVICE_NAME
+				  ": Compact flash found in bootbus region %d (%d bit%s).\n",
+				  region, (cf->is16bit) ? 16 : 8,
+				  (cf->is_true_ide) ? ", ide" : "");
+			break;
+		}
+	}
+
+	cf->gd->major = major_num;
+	cf->gd->first_minor = 0;
+	cf->gd->fops = &octeon_cf_ops;
+	cf->gd->private_data = cf;
+	cf->gd->queue = cf->queue;
+	strcpy(cf->gd->disk_name, DEVICE_NAME "a");
+
+	/*
+	 * Set a size to make sure the kernel trys to find
+	 * partitions. The real size will be set when the thread
+	 * starts processing.
+	 */
+
+	/* Identify the compact flash. We need its size */
+	octeon_cf_identify(cf);
+	set_capacity(cf->gd,
+		     cf->num_sectors * (cf->sector_size / KERNEL_SECTOR_SIZE));
+
+	add_disk(cf->gd);
+
+	return 0;
+out_unregister:
+	unregister_blkdev(major_num, DEVICE_NAME);
+out:
+	return -ENOMEM;
+}
+
+static struct platform_driver octeon_cf_driver = {
+	.probe		= octeon_cf_probe,
+	.driver		= {
+		.name	= "octeon-cf",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init octeon_cf_init(void)
+{
+	pr_info(DEVICE_NAME ": Octeon bootbus compact flash driver\n");
+
+	return platform_driver_register(&octeon_cf_driver);
+}
+
+module_init(octeon_cf_init);
