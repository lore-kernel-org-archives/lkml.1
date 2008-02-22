Return-Path: <linux-kernel-owner+w=401wt.eu-S935086AbYBVULU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935086AbYBVULU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 15:11:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933675AbYBVUKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 15:10:07 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:53597 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934240AbYBVUJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 15:09:53 -0500
Date: Fri, 22 Feb 2008 13:09:52 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: ata_ram driver
Message-ID: <20080222200951.GI16995@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've ported the scsi_ram driver [1] to libata.  It could use a lot more
work -- there's a lot of stuff in the identify page that I haven't
filled in, and there's a lot of commands it doesn't even try to execute.

For example, when you unload the driver, you get the mildly disturbing
messages:

sd 12:0:0:0: [sdb] Stopping disk
sd 12:0:0:0: [sdb] START_STOP FAILED
sd 12:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK

However, it's still useful at the current stage of development, so I
thought it was worth posting to get some feedback.

[1] http://marc.info/?l=linux-scsi&m=120331663227540&w=2

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index ba8f7f4..a3dfb50 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -40,6 +40,9 @@ config ATA_ACPI
 	  You can disable this at kernel boot time by using the
 	  option libata.noacpi=1
 
+config ATA_RAM
+	tristate "ATA RAM driver"
+
 config SATA_AHCI
 	tristate "AHCI SATA support"
 	depends on PCI
diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
index 701651e..a0a5a8c 100644
--- a/drivers/ata/Makefile
+++ b/drivers/ata/Makefile
@@ -77,6 +77,9 @@ obj-$(CONFIG_ATA_GENERIC)	+= ata_generic.o
 # Should be last libata driver
 obj-$(CONFIG_PATA_LEGACY)	+= pata_legacy.o
 
+# A fake ata driver.  Can it be postultimate?
+obj-$(CONFIG_ATA_RAM)		+= ata_ram.o
+
 libata-objs	:= libata-core.o libata-scsi.o libata-sff.o libata-eh.o \
 		   libata-pmp.o
 libata-$(CONFIG_ATA_ACPI)	+= libata-acpi.o
diff --git a/drivers/ata/ata_ram.c b/drivers/ata/ata_ram.c
new file mode 100644
index 0000000..7935bd1
--- /dev/null
+++ b/drivers/ata/ata_ram.c
@@ -0,0 +1,674 @@
+/*
+ * ata_ram.c - A RAM-based ATA driver for Linux
+ *
+ * This driver is intended to run as fast as possible, hence the options
+ * to discard writes and reads.
+ * By default, it'll allocate half a gigabyte of RAM to use as a ramdisc;
+ * you can change this with the `capacity' module parameter.
+ *
+ * (C) Copyright 2007-2008 Intel Corporation
+ * Author: Matthew Wilcox <willy@linux.intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#undef DEBUG
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/kthread.h>
+#include <linux/libata.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/scatterlist.h>
+#include <linux/spinlock.h>
+
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_dbg.h>
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Matthew Wilcox <willy@linux.intel.com>");
+
+#define DRV_NAME "ata_ram"
+
+static unsigned int sector_size = 512;
+module_param(sector_size, uint, 0444);
+MODULE_PARM_DESC(sector_size, "Size of sectors");
+
+static unsigned int capacity = 1024 * 1024;
+module_param(capacity, uint, 0444);
+MODULE_PARM_DESC(capacity, "Number of logical blocks in device");
+
+static int throw_away_writes;
+module_param(throw_away_writes, int, 0644);
+MODULE_PARM_DESC(throw_away_writes, "Discard all writes to the device");
+
+static int throw_away_reads;
+module_param(throw_away_reads, int, 0644);
+MODULE_PARM_DESC(throw_away_reads, "Don't actually read data from the device");
+
+
+struct ata_ram_host {
+	struct ata_host *host;
+	struct ata_queued_cmd *cmds[ATA_MAX_QUEUE];
+	int first, last;
+	struct task_struct *thread;
+	struct ata_taskfile shadow_tf;
+};
+
+static void copy_buffer(struct ata_queued_cmd *qc, char *buf, int len)
+{
+	char *p;
+	struct scatterlist *sg;
+	unsigned int i;
+
+	for_each_sg(qc->sg, sg, qc->n_elem, i) {
+		int tocopy = sg->length;
+		if (tocopy > len)
+			tocopy = len;
+
+		p = kmap_atomic(sg_page(sg), KM_USER0);
+		memcpy(p + sg->offset, buf, tocopy);
+		kunmap_atomic(p, KM_USER0);
+
+		len -= tocopy;
+		if (!len)
+			break;
+		buf += tocopy;
+	}
+}
+
+static void ata_ram_setup_result(struct ata_queued_cmd *qc)
+{
+	struct ata_ram_host *arhost = qc->ap->private_data;
+	arhost->shadow_tf.flags = ATA_TFLAG_LBA48 | ATA_TFLAG_LBA;
+	arhost->shadow_tf.protocol = ATA_PROT_DMA;
+	arhost->shadow_tf.ctl = 0;
+	arhost->shadow_tf.feature = 0;
+	arhost->shadow_tf.device = 0;
+	arhost->shadow_tf.command = 0;
+}
+
+static void ata_put_dword(u16 *d, u32 v)
+{
+	d[0] = cpu_to_le16(v & 0xffff);
+	d[1] = cpu_to_le16(v >> 16);
+}
+
+static u32 ata_get_lba_28(struct ata_taskfile *tf)
+{
+	return tf->lbal | (tf->lbam << 8) | (tf->lbah << 16);
+}
+
+static u64 ata_get_lba_48(struct ata_taskfile *tf)
+{
+	return tf->lbal | (tf->hob_lbal << 8) |
+		(tf->lbam << 16) | (tf->hob_lbam << 24) |
+		((u64)tf->lbah << 32) | ((u64)tf->hob_lbah << 40);
+}
+
+/*
+ * ATA strings swap alternate bytes from an ascii string.  Like SCSI
+ * strings, they are space-padded, not nul-terminated.  libata has
+ * functions for decoding, but not encoding them.
+ */
+static void ata_put_string(u16 *d, int limit, char *s)
+{
+	int i;
+
+	for (i = 0; i < limit; i++) {
+		u16 c, w;
+
+		c = *s;
+		if (c)
+			s++;
+		else
+			c = ' ';
+		w = c << 8;
+
+		c = *s;
+		if (c)
+			s++;
+		else
+			c = ' ';
+		w |= c;
+
+		d[i] = cpu_to_le16(w);
+	}
+}
+
+static struct page **ata_ram_data_array;
+
+/*
+ * We can use highmem, but we don't want to OOM the box looking for memory.
+ * We also don't want a warning if we fail to allocate the page
+ */
+#define GFP_DATA_PAGE	(GFP_KERNEL | __GFP_HIGHMEM | __GFP_NORETRY | \
+			 __GFP_NOWARN)
+
+/*
+ * We could steal the pages we need from the requests as they come in, which
+ * is what rd.c does.  However, that's not a realistic simulator of how a
+ * device would work.  We want the request pages to get freed and go back into
+ * the page allocator.
+ */
+static int ata_ram_alloc_data(void)
+{
+	unsigned long pages = capacity / PAGE_SIZE * sector_size;
+	unsigned int i;
+
+	ata_ram_data_array = kmalloc(pages * sizeof(void *), GFP_KERNEL);
+	if (!ata_ram_data_array)
+		return -ENOMEM;
+
+	for (i = 0; i < pages; i++) {
+		struct page *page = alloc_page(GFP_DATA_PAGE);
+		ata_ram_data_array[i] = page;
+
+		/* ata_ram_free_data will be called on failure */
+		if (!page)
+			return -ENOMEM;
+		clear_highpage(page);
+	}
+
+	return 0;
+}
+
+static void ata_ram_free_data(void)
+{
+	unsigned long pages = capacity / PAGE_SIZE * sector_size;
+	unsigned int i;
+
+	if (!ata_ram_data_array)
+		return;
+
+	for (i = 0; i < pages; i++) {
+		struct page *page = ata_ram_data_array[i];
+		if (!page)
+			break;
+		__free_page(page);
+	}
+
+	kfree(ata_ram_data_array);
+}
+
+static void ata_ram_too_big(struct ata_queued_cmd *qc, u64 start,
+							unsigned int len)
+{
+	printk("Request exceeded device capacity! %llu %u\n", start, len);
+//	scsi_ram_setup_sense(cmnd, ILLEGAL_REQUEST, 0x21, 0);
+//	cmnd->result = SAM_STAT_CHECK_CONDITION;
+}
+
+static void *get_data_page(unsigned int pfn)
+{
+	return kmap_atomic(ata_ram_data_array[pfn], KM_USER0);
+}
+
+static void put_data_page(void *addr)
+{
+	kunmap_atomic(addr, KM_USER0);
+}
+
+static void *get_sg_page(struct page *page)
+{
+	return kmap_atomic(page, KM_USER1);
+}
+
+static void put_sg_page(void *addr)
+{
+	kunmap_atomic(addr, KM_USER1);
+}
+
+static void ata_ram_read(struct ata_queued_cmd *qc, u64 startB,
+							unsigned int lenB)
+{
+	u64 start = startB * sector_size;
+	unsigned long len = lenB * sector_size;
+	struct scatterlist *sg;
+	unsigned i, from_off = start % PAGE_SIZE, data_pfn = start / PAGE_SIZE;
+
+	if (startB > capacity || (startB + lenB) > capacity)
+		return ata_ram_too_big(qc, startB, lenB);
+
+	if (throw_away_reads)
+		return;
+
+	for_each_sg(qc->sg, sg, qc->n_elem, i) {
+		struct page *sgpage = sg_page(sg);
+		unsigned int to_off = sg->offset;
+		unsigned int sg_copy = sg->length;
+		if (sg_copy > len)
+			sg_copy = len;
+		len -= sg_copy;
+
+		while (sg_copy > 0) {
+			char *vto, *vfrom;
+			unsigned int page_copy;
+
+			if (from_off > to_off)
+				page_copy = PAGE_SIZE - from_off;
+			else
+				page_copy = PAGE_SIZE - to_off;
+			if (page_copy > sg_copy)
+				page_copy = sg_copy;
+
+			vfrom = get_data_page(data_pfn);
+			vto = get_sg_page(sgpage);
+			memcpy(vto + to_off, vfrom + from_off, page_copy);
+			put_sg_page(vto);
+			put_data_page(vfrom);
+
+			from_off += page_copy;
+			if (from_off == PAGE_SIZE) {
+				from_off = 0;
+				data_pfn++;
+			}
+			to_off += page_copy;
+			if (to_off == PAGE_SIZE) {
+				to_off = 0;
+				sgpage++;
+			}
+			sg_copy -= page_copy;
+		}
+		if (!len)
+			break;
+	}
+}
+
+static void ata_ram_write(struct ata_queued_cmd *qc, u64 startB,
+							unsigned int lenB)
+{
+	u64 start = startB * sector_size;
+	unsigned long len = lenB * sector_size;
+	struct scatterlist *sg;
+	unsigned i, to_off = start % PAGE_SIZE, data_pfn = start / PAGE_SIZE;
+
+	if (startB > capacity || (startB + lenB) > capacity)
+		return ata_ram_too_big(qc, startB, lenB);
+
+	if (throw_away_writes)
+		return;
+
+	for_each_sg(qc->sg, sg, qc->n_elem, i) {
+		struct page *sgpage = sg_page(sg);
+		unsigned int from_off = sg->offset;
+		unsigned int sg_copy = sg->length;
+		if (sg_copy > len)
+			sg_copy = len;
+		len -= sg_copy;
+
+		while (sg_copy > 0) {
+			char *vto, *vfrom;
+			unsigned int page_copy;
+
+			if (from_off > to_off)
+				page_copy = PAGE_SIZE - from_off;
+			else
+				page_copy = PAGE_SIZE - to_off;
+			if (page_copy > sg_copy)
+				page_copy = sg_copy;
+
+			vfrom = get_sg_page(sgpage);
+			vto = get_data_page(data_pfn);
+			memcpy(vto + to_off, vfrom + from_off, page_copy);
+			put_data_page(vto);
+			put_sg_page(vfrom);
+
+			from_off += page_copy;
+			if (from_off == PAGE_SIZE) {
+				from_off = 0;
+				sgpage++;
+			}
+			to_off += page_copy;
+			if (to_off == PAGE_SIZE) {
+				to_off = 0;
+				data_pfn++;
+			}
+			sg_copy -= page_copy;
+		}
+		if (!len)
+			break;
+	}
+}
+
+static void ata_ram_read_28(struct ata_queued_cmd *qc)
+{
+	u64 first_block = ata_get_lba_28(&qc->tf);
+	unsigned int length = qc->tf.nsect;
+	if (!length)
+		length = 256;
+	ata_ram_read(qc, first_block, length);
+}
+
+static void ata_ram_read_48(struct ata_queued_cmd *qc)
+{
+	u64 first_block = ata_get_lba_48(&qc->tf);
+	unsigned int length = qc->tf.nsect | qc->tf.hob_nsect << 8;
+	if (!length)
+		length = 65536;
+	ata_ram_read(qc, first_block, length);
+}
+
+static void ata_ram_write_28(struct ata_queued_cmd *qc)
+{
+	u64 first_block = ata_get_lba_28(&qc->tf);
+	unsigned int length = qc->tf.nsect;
+	if (!length)
+		length = 256;
+	ata_ram_write(qc, first_block, length);
+}
+
+static void ata_ram_write_48(struct ata_queued_cmd *qc)
+{
+	u64 first_block = ata_get_lba_48(&qc->tf);
+	unsigned int length = qc->tf.nsect | qc->tf.hob_nsect << 8;
+	if (!length)
+		length = 65536;
+	ata_ram_write(qc, first_block, length);
+}
+
+static void ata_ram_tf_read(struct ata_port *ap, struct ata_taskfile *tf)
+{
+	struct ata_ram_host *arhost = ap->private_data;
+	pr_debug("%s called\n", __func__);
+	memcpy(tf, &arhost->shadow_tf, sizeof(tf));
+}
+
+static void ata_ram_identify(struct ata_queued_cmd *qc)
+{
+	u16 id[256];
+	pr_debug("%s called\n", __func__);
+	ata_ram_setup_result(qc);
+
+	memset(id, 0, 512);
+
+	ata_put_string(id + 10, 10, "50656e6775696e");
+	ata_put_string(id + 23, 4, "0.01");
+	ata_put_string(id + 27, 20, "Linux RAM Drive");
+	id[49] = cpu_to_le16(0x0f00);			/* DMA, LBA & IORDY */
+	id[53] = cpu_to_le16(0x0006);			/* 64,88 are valid */
+	ata_put_dword(id + 60, capacity);
+	id[64] = cpu_to_le16(0x00ff);			/* PIO modes */
+	id[80] = cpu_to_le16(0x01f0);			/* ATA 4,5,6,7,8 */
+	id[88] = cpu_to_le16(0x40ef);			/* UDMA modes */
+	id[117] = cpu_to_le16(sector_size);
+
+	copy_buffer(qc, (char *)id, 512);
+
+	qc->err_mask = 0;
+}
+
+static void ata_ram_set_features(struct ata_queued_cmd *qc)
+{
+	pr_debug("%s called\n", __func__);
+
+	switch (qc->tf.feature) {
+	case 3:
+		ata_ram_setup_result(qc);
+		qc->err_mask = 0;
+		break;
+	default:
+		pr_debug("Declining to set feature 0x%x\n", qc->tf.feature);
+		qc->err_mask = AC_ERR_DEV;
+		break;
+	}
+}
+
+static void ata_ram_execute_command(struct ata_queued_cmd *qc)
+{
+#ifdef DEBUG
+	ata_print_command(qc);
+#endif
+
+	switch (qc->tf.command) {
+	case ATA_CMD_ID_ATA:
+		ata_ram_identify(qc);
+		break;
+	case ATA_CMD_SET_FEATURES:
+		ata_ram_set_features(qc);
+		break;
+	case ATA_CMD_READ:
+		ata_ram_read_28(qc);
+		break;
+	case ATA_CMD_READ_EXT:
+		ata_ram_read_48(qc);
+		break;
+	case ATA_CMD_WRITE:
+		ata_ram_write_28(qc);
+		break;
+	case ATA_CMD_WRITE_EXT:
+		ata_ram_write_48(qc);
+		break;
+	default:
+		pr_debug("Declining to execute command 0x%x\n", qc->tf.command);
+		qc->err_mask = AC_ERR_DEV;
+		break;
+	}
+
+	ata_ram_tf_read(qc->ap, &qc->result_tf);
+	ata_qc_complete(qc);
+}
+
+static int ata_ram_add_cmd(struct ata_ram_host *arhost, struct ata_queued_cmd *qc)
+{
+	int next = arhost->last + 1;
+	if (next == ATA_MAX_QUEUE)
+		next = 0;
+	if (next == arhost->first)
+		return 0;
+	arhost->cmds[arhost->last] = qc;
+	arhost->last = next;
+	return 1;
+}
+
+static struct ata_queued_cmd *ata_ram_next_cmd(struct ata_ram_host *arhost)
+{
+	struct ata_queued_cmd *qc;
+	if (arhost->first == arhost->last)
+		return NULL;
+	qc = arhost->cmds[arhost->first];
+	arhost->first++;
+	if (arhost->first == ATA_MAX_QUEUE)
+		arhost->first = 0;
+	return qc;
+}
+
+static int ata_ram_device_thread(void *data)
+{
+	struct ata_ram_host *arhost = data;
+	struct ata_port *ap = arhost->host->ports[0];
+
+	while (!kthread_should_stop()) {
+		struct ata_queued_cmd *qc;
+
+		spin_lock_irq(ap->lock);
+		qc = ata_ram_next_cmd(arhost);
+		if (!qc) {
+			set_current_state(TASK_INTERRUPTIBLE);
+			spin_unlock_irq(ap->lock);
+			schedule();
+			continue;
+		}
+		spin_unlock_irq(ap->lock);
+
+		ata_ram_execute_command(qc);
+	}
+	__set_current_state(TASK_RUNNING);
+
+	return 0;
+}
+
+static void ata_ram_qc_prep(struct ata_queued_cmd *qc)
+{
+	pr_debug("%s called\n", __func__);
+}
+
+static unsigned int ata_ram_qc_issue(struct ata_queued_cmd *qc)
+{
+	int success;
+	struct ata_ram_host *arhost = qc->ap->private_data;
+
+	pr_debug("%s called\n", __func__);
+
+	success = ata_ram_add_cmd(arhost, qc);
+	if (!success)
+		return -EBUSY;
+
+	wake_up_process(arhost->thread);
+	return 0;
+}
+
+static int ata_ram_softreset(struct ata_link *link, unsigned int *class,
+							unsigned long deadline)
+{
+	pr_debug("%s called\n", __func__);
+	return 0;
+}
+
+static int ata_ram_hardreset(struct ata_link *link, unsigned int *class,
+							unsigned long deadline)
+{
+	pr_debug("%s called\n", __func__);
+	class[0] = ATA_DEV_ATA;
+	return 0;
+}
+
+static void ata_ram_postreset(struct ata_link *link, unsigned int *class)
+{
+	pr_debug("%s called\n", __func__);
+}
+
+static void ata_ram_error_handler(struct ata_port *ap)
+{
+	pr_debug("%s called\n", __func__);
+	ata_do_eh(ap, ata_std_prereset, ata_ram_softreset, ata_ram_hardreset,
+							ata_ram_postreset);
+}
+
+static u8 ata_ram_check_status(struct ata_port *ap)
+{
+	pr_debug("%s called\n", __func__);
+	return 0;
+}
+
+static void ata_ram_dev_select(struct ata_port *ap, unsigned int device)
+{
+	pr_debug("%s called\n", __func__);
+}
+
+static const struct ata_port_operations ata_ram_port_ops = {
+	.tf_read = ata_ram_tf_read,
+	.check_status = ata_ram_check_status,
+	.dev_select = ata_ram_dev_select,
+	.qc_prep = ata_ram_qc_prep,
+	.qc_issue = ata_ram_qc_issue,
+	.error_handler = ata_ram_error_handler,
+//	.check_altstatus = ata_ram_check_altstatus,
+};
+
+static struct scsi_host_template ata_ram_template = {
+	.module = THIS_MODULE,
+	.name = DRV_NAME,
+	.ioctl = ata_scsi_ioctl,
+	.queuecommand = ata_scsi_queuecmd,
+	.can_queue = ATA_DEF_QUEUE,
+	.this_id = ATA_SHT_THIS_ID,
+	.sg_tablesize = LIBATA_MAX_PRD,
+	.cmd_per_lun = ATA_SHT_CMD_PER_LUN,
+	.emulated = ATA_SHT_EMULATED,
+	.use_clustering = ATA_SHT_USE_CLUSTERING,
+	.proc_name = DRV_NAME,
+	.dma_boundary = ATA_DMA_BOUNDARY,
+	.slave_configure = ata_scsi_slave_config,
+	.slave_destroy = ata_scsi_slave_destroy,
+	.bios_param = ata_std_bios_param,
+};
+
+static struct platform_device *pdev;
+
+static int __init ata_ram_init(void)
+{
+	int error;
+	struct ata_port *ap;
+	struct ata_ram_host *arhost;
+	struct ata_host *host;
+
+	error = ata_ram_alloc_data();
+	if (error)
+		goto out;
+
+	pdev = platform_device_register_simple(DRV_NAME, -1, NULL, 0);
+	if (IS_ERR(pdev)) {
+		error = PTR_ERR(pdev);
+		goto out;
+	}
+	pdev->dev.coherent_dma_mask = DMA_64BIT_MASK;
+	pdev->dev.dma_mask = &pdev->dev.coherent_dma_mask;
+
+	error = -ENOMEM;
+	arhost = kzalloc(sizeof(*arhost), GFP_KERNEL);
+	if (!arhost)
+		goto unregister_pdev;
+	platform_set_drvdata(pdev, arhost);
+
+	host = ata_host_alloc(&pdev->dev, 1);
+	if (!host)
+		goto unregister_pdev;
+	arhost->host = host;
+	host->ops = &ata_ram_port_ops;
+	ap = host->ports[0];
+	ap->private_data = arhost;
+
+	ap->ops = &ata_ram_port_ops;
+	ap->flags = ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY | ATA_FLAG_NCQ;
+	ap->pio_mask = ATA_PIO6;
+	ap->mwdma_mask = ATA_MWDMA2;
+	ap->udma_mask = ATA_UDMA6;
+	strncpy(ap->link.eh_info.desc, "ata_ram", ATA_EH_DESC_LEN);
+
+	arhost->thread = kthread_run(ata_ram_device_thread, arhost, "ata_ram");
+	if (IS_ERR(arhost->thread)) {
+		error = PTR_ERR(arhost->thread);
+		goto free_host;
+	}
+
+	error = ata_host_start(host);
+	if (error)
+		goto stop_thread;
+	error = ata_host_register(host, &ata_ram_template);
+	if (error)
+		goto stop_thread;
+
+	return 0;
+
+ stop_thread:
+	kthread_stop(arhost->thread);
+ free_host:
+	ata_host_detach(host);
+ unregister_pdev:
+	kfree(arhost);
+	platform_device_unregister(pdev);
+ out:
+	ata_ram_free_data();
+	return error;
+}
+
+static void __exit ata_ram_exit(void)
+{
+	struct ata_ram_host *arhost = platform_get_drvdata(pdev);
+	ata_host_detach(arhost->host);
+	kfree(arhost);
+	platform_device_unregister(pdev);
+	ata_ram_free_data();
+}
+
+module_init(ata_ram_init);
+module_exit(ata_ram_exit);
-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
