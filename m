Return-Path: <linux-kernel-owner+w=401wt.eu-S1760524AbXEYIiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760524AbXEYIiy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 04:38:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760445AbXEYIhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 04:37:36 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:40508 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759075AbXEYIha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 04:37:30 -0400
Message-Id: <20070525083632.380701000@sonycom.com>
References: <20070525083607.784351000@sonycom.com>
User-Agent: quilt/0.46-1
Date: Fri, 25 May 2007 10:36:10 +0200
From: Geert.Uytterhoeven@sonycom.com
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [patch 3/7] ps3: Storage Driver Core
Content-Disposition: inline; filename=ps3stor_bus.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add storage driver core support for the PS3.
PS3 storage devices are a special kind of PS3 system bus devices.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 arch/powerpc/platforms/ps3/Kconfig    |    4 
 arch/powerpc/platforms/ps3/platform.h |    1 
 drivers/ps3/Makefile                  |    1 
 drivers/ps3/ps3stor_lib.c             |  333 ++++++++++++++++++++++++++++++++++
 include/asm-powerpc/ps3stor.h         |   72 +++++++
 5 files changed, 411 insertions(+)

--- a/arch/powerpc/platforms/ps3/Kconfig
+++ b/arch/powerpc/platforms/ps3/Kconfig
@@ -97,4 +97,8 @@ config PS3_SYS_MANAGER
 	  This support is required for system control.  In
 	  general, all users will say Y or M.
 
+config PS3_STORAGE
+	depends on PPC_PS3
+	tristate
+
 endmenu
--- a/arch/powerpc/platforms/ps3/platform.h
+++ b/arch/powerpc/platforms/ps3/platform.h
@@ -82,6 +82,7 @@ enum ps3_dev_type {
 	PS3_DEV_TYPE_STOR_ROM = TYPE_ROM,	/* 5 */
 	PS3_DEV_TYPE_SB_GPIO = 6,
 	PS3_DEV_TYPE_STOR_FLASH = TYPE_RBC,	/* 14 */
+	PS3_DEV_TYPE_NONE = 255,
 };
 
 int ps3_repository_read_bus_str(unsigned int bus_index, const char *bus_str,
--- a/drivers/ps3/Makefile
+++ b/drivers/ps3/Makefile
@@ -3,3 +3,4 @@ obj-$(CONFIG_PS3_PS3AV) += ps3av_mod.o
 ps3av_mod-objs		+= ps3av.o ps3av_cmd.o
 obj-$(CONFIG_PPC_PS3) += sys-manager-core.o
 obj-$(CONFIG_PS3_SYS_MANAGER) += sys-manager.o
+obj-$(CONFIG_PS3_STORAGE) += ps3stor_lib.o
--- /dev/null
+++ b/drivers/ps3/ps3stor_lib.c
@@ -0,0 +1,333 @@
+/*
+ * PS3 Storage Library
+ *
+ * Copyright (C) 2007 Sony Computer Entertainment Inc.
+ * Copyright 2007 Sony Corp.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published
+ * by the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#include <linux/dma-mapping.h>
+#include <linux/interrupt.h>
+
+#include <asm/lv1call.h>
+#include <asm/ps3stor.h>
+
+
+static irqreturn_t ps3stor_interrupt(int irq, void *data)
+{
+	struct ps3_storage_device *dev = data;
+
+	dev->lv1_res = lv1_storage_get_async_status(dev->sbd.did.dev_id,
+						    &dev->lv1_tag,
+						    &dev->lv1_status);
+	/*
+	 * lv1_status = -1 may mean that ATAPI transport completed OK, but
+	 * ATAPI command itself resulted CHECK CONDITION
+	 * so, upper layer should issue REQUEST_SENSE to check the sense data
+	 */
+
+	if (dev->lv1_tag != dev->tag)
+		dev_err(&dev->sbd.core,
+			"%s:%u: tag mismatch, got %lx, expected %lx\n",
+			__func__, __LINE__, dev->lv1_tag, dev->tag);
+	if (dev->lv1_res)
+		dev_err(&dev->sbd.core, "%s:%u: res=%d status=0x%lx\n",
+			__func__, __LINE__, dev->lv1_res, dev->lv1_status);
+	else
+		complete(&dev->irq_done);
+	return IRQ_HANDLED;
+}
+
+
+static int ps3stor_probe_access(struct ps3_storage_device *dev)
+{
+	int res, error;
+	unsigned int i;
+	unsigned long n;
+
+	if (dev->sbd.match_id == PS3_MATCH_ID_STOR_ROM) {
+		/* special case: CD-ROM is assumed always accessible */
+		dev->accessible_regions = 1;
+		return 0;
+	}
+
+	error = -EPERM;
+	for (i = 0; i < dev->num_regions; i++) {
+		dev_dbg(&dev->sbd.core,
+			"%s:%u: checking accessibility of region %u\n",
+			__func__, __LINE__, i);
+
+		dev->region_idx = i;
+		res = ps3stor_read_write_sectors(dev, dev->bounce_lpar, 0, 1,
+						 0);
+		if (res) {
+			dev_dbg(&dev->sbd.core,
+				"%s:%u: read failed, region %u is not accessible\n",
+				__func__, __LINE__, i);
+			continue;
+		}
+
+		dev_dbg(&dev->sbd.core, "%s:%u: region %u is accessible\n",
+			__func__, __LINE__, i);
+		set_bit(i, &dev->accessible_regions);
+
+		/* We can access at least one region */
+		error = 0;
+	}
+	if (error)
+		return error;
+
+	n = hweight_long(dev->accessible_regions);
+	if (n > 1)
+		dev_info(&dev->sbd.core,
+			 "%s:%u: %lu accessible regions found. Only the first "
+			 "one will be used",
+			 __func__, __LINE__, n);
+	dev->region_idx = __ffs(dev->accessible_regions);
+	dev_dbg(&dev->sbd.core,
+		"First accessible region has index %u start %lu size %lu\n",
+		dev->region_idx, dev->regions[dev->region_idx].start,
+		dev->regions[dev->region_idx].size);
+
+	return 0;
+}
+
+
+/**
+ *	ps3stor_setup - Setup a storage device before use
+ *	@dev: Pointer to a struct ps3_storage_device
+ *	@name: Name of the storage driver
+ *
+ *	Returns 0 for success, or an error code
+ */
+int ps3stor_setup(struct ps3_storage_device *dev, const char *name)
+{
+	int error, res, alignment;
+	enum ps3_dma_page_size page_size;
+
+	error = ps3_open_hv_device(&dev->sbd);
+	if (error) {
+		dev_err(&dev->sbd.core,
+			"%s:%u: ps3_open_hv_device failed %d\n", __func__,
+			__LINE__, error);
+		goto fail;
+	}
+
+	error = ps3_sb_event_receive_port_setup(PS3_BINDING_CPU_ANY,
+						&dev->sbd.did,
+						dev->sbd.interrupt_id,
+						&dev->irq);
+	if (error) {
+		dev_err(&dev->sbd.core,
+			"%s:%u: ps3_sb_event_receive_port_setup failed %d\n",
+		       __func__, __LINE__, error);
+		goto fail_close_device;
+	}
+
+	error = request_irq(dev->irq, ps3stor_interrupt, IRQF_DISABLED, name,
+			    dev);
+	if (error) {
+		dev_err(&dev->sbd.core, "%s:%u: request_irq failed %d\n",
+			__func__, __LINE__, error);
+		goto fail_sb_event_receive_port_destroy;
+	}
+
+	alignment = min(__ffs(dev->bounce_size),
+			__ffs((unsigned long)dev->bounce_buf));
+	if (alignment < 12) {
+		dev_err(&dev->sbd.core,
+			"%s:%u: bounce buffer not aligned (%lx at 0x%p)\n",
+			__func__, __LINE__, dev->bounce_size, dev->bounce_buf);
+		error = -EINVAL;
+		goto fail_free_irq;
+	} else if (alignment < 16)
+		page_size = PS3_DMA_4K;
+	else
+		page_size = PS3_DMA_64K;
+	dev->sbd.d_region = &dev->dma_region;
+	ps3_dma_region_init(&dev->dma_region, &dev->sbd.did, page_size,
+			    PS3_DMA_OTHER, dev->bounce_buf, dev->bounce_size,
+			    PS3_IOBUS_SB);
+	res = ps3_dma_region_create(&dev->dma_region);
+	if (res) {
+		dev_err(&dev->sbd.core, "%s:%u: cannot create DMA region\n",
+			__func__, __LINE__);
+		error = -ENOMEM;
+		goto fail_free_irq;
+	}
+
+	dev->bounce_lpar = ps3_mm_phys_to_lpar(__pa(dev->bounce_buf));
+	dev->bounce_dma = dma_map_single(&dev->sbd.core, dev->bounce_buf,
+					 dev->bounce_size, DMA_BIDIRECTIONAL);
+	if (!dev->bounce_dma) {
+		dev_err(&dev->sbd.core, "%s:%u: map DMA region failed\n",
+			__func__, __LINE__);
+		error = -ENODEV;
+		goto fail_free_dma;
+	}
+
+	error = ps3stor_probe_access(dev);
+	if (error) {
+		dev_err(&dev->sbd.core, "%s:%u: No accessible regions found\n",
+			__func__, __LINE__);
+		goto fail_unmap_dma;
+	}
+	return 0;
+
+fail_unmap_dma:
+	dma_unmap_single(&dev->sbd.core, dev->bounce_dma, dev->bounce_size,
+			 DMA_BIDIRECTIONAL);
+fail_free_dma:
+	ps3_dma_region_free(&dev->dma_region);
+fail_free_irq:
+	free_irq(dev->irq, dev);
+fail_sb_event_receive_port_destroy:
+	ps3_sb_event_receive_port_destroy(&dev->sbd.did, dev->sbd.interrupt_id,
+					  dev->irq);
+fail_close_device:
+	ps3_close_hv_device(&dev->sbd);
+fail:
+	return error;
+}
+EXPORT_SYMBOL_GPL(ps3stor_setup);
+
+
+/**
+ *	ps3stor_teardown - Tear down a storage device after use
+ *	@dev: Pointer to a struct ps3_storage_device
+ */
+void ps3stor_teardown(struct ps3_storage_device *dev)
+{
+	int error;
+
+	dma_unmap_single(&dev->sbd.core, dev->bounce_dma, dev->bounce_size,
+			 DMA_BIDIRECTIONAL);
+	ps3_dma_region_free(&dev->dma_region);
+
+	free_irq(dev->irq, dev);
+
+	error = ps3_sb_event_receive_port_destroy(&dev->sbd.did,
+						  dev->sbd.interrupt_id,
+						  dev->irq);
+	if (error)
+		dev_err(&dev->sbd.core,
+			"%s:%u: destroy event receive port failed %d\n",
+			__func__, __LINE__, error);
+
+	error = ps3_close_hv_device(&dev->sbd);
+	if (error)
+		dev_err(&dev->sbd.core,
+			"%s:%u: ps3_close_hv_device failed %d\n", __func__,
+			__LINE__, error);
+}
+EXPORT_SYMBOL_GPL(ps3stor_teardown);
+
+
+/**
+ *	ps3stor_read_write_sectors - read/write from/to a storage device
+ *	@dev: Pointer to a struct ps3_storage_device
+ *	@lpar: HV logical partition address
+ *	@start_sector: First sector to read/write
+ *	@sectors: Number of sectors to read/write
+ *	@write: Flag indicating write (non-zero) or read (zero)
+ *
+ *	Returns 0 for success, -1 in case of failure to submit the command, or
+ *	an LV1 status value in case of other errors
+ */
+u64 ps3stor_read_write_sectors(struct ps3_storage_device *dev, u64 lpar,
+			       u64 start_sector, u64 sectors, int write)
+{
+	unsigned int region_id = dev->regions[dev->region_idx].id;
+	const char *op = write ? "write" : "read";
+	int res;
+
+	dev_dbg(&dev->sbd.core, "%s:%u: %s %lu sectors starting at %lu\n",
+		__func__, __LINE__, op, sectors, start_sector);
+
+	init_completion(&dev->irq_done);
+	res = write ? lv1_storage_write(dev->sbd.did.dev_id, region_id,
+					start_sector, sectors, 0, lpar,
+					&dev->tag)
+		    : lv1_storage_read(dev->sbd.did.dev_id, region_id,
+				       start_sector, sectors, 0, lpar,
+				       &dev->tag);
+	if (res) {
+		dev_dbg(&dev->sbd.core, "%s:%u: %s failed %d\n", __func__,
+			__LINE__, op, res);
+		return -1;
+	}
+
+	wait_for_completion(&dev->irq_done);
+	if (dev->lv1_status) {
+		dev_dbg(&dev->sbd.core, "%s:%u: %s failed 0x%lx\n", __func__,
+			__LINE__, op, dev->lv1_status);
+		return dev->lv1_status;
+	}
+
+	dev_dbg(&dev->sbd.core, "%s:%u: %s completed\n", __func__, __LINE__,
+		op);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ps3stor_read_write_sectors);
+
+
+/**
+ *	ps3stor_send_command - send a device command to a storage device
+ *	@dev: Pointer to a struct ps3_storage_device
+ *	@cmd: Command number
+ *	@arg1: First command argument
+ *	@arg2: Second command argument
+ *	@arg3: Third command argument
+ *	@arg4: Fourth command argument
+ *
+ *	Returns 0 for success, -1 in case of failure to submit the command, or
+ *	an LV1 status value in case of other errors
+ */
+u64 ps3stor_send_command(struct ps3_storage_device *dev, u64 cmd, u64 arg1,
+			 u64 arg2, u64 arg3, u64 arg4)
+{
+	int res;
+
+	dev_dbg(&dev->sbd.core, "%s:%u: send device command 0x%lx\n", __func__,
+		__LINE__, cmd);
+
+	init_completion(&dev->irq_done);
+
+	res = lv1_storage_send_device_command(dev->sbd.did.dev_id, cmd, arg1,
+					      arg2, arg3, arg4, &dev->tag);
+	if (res) {
+		dev_err(&dev->sbd.core,
+			"%s:%u: send_device_command 0x%lx failed %d\n",
+			__func__, __LINE__, cmd, res);
+		return -1;
+	}
+
+	wait_for_completion(&dev->irq_done);
+	if (dev->lv1_status)
+		dev_dbg(&dev->sbd.core, "%s:%u: command 0x%lx failed 0x%lx\n",
+			__func__, __LINE__, cmd, dev->lv1_status);
+	else
+		dev_dbg(&dev->sbd.core, "%s:%u: command 0x%lx completed\n",
+			__func__, __LINE__, cmd);
+
+	return dev->lv1_status;
+}
+EXPORT_SYMBOL_GPL(ps3stor_send_command);
+
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("PS3 Storage Bus Library");
+MODULE_AUTHOR("Sony Corporation");
--- /dev/null
+++ b/include/asm-powerpc/ps3stor.h
@@ -0,0 +1,72 @@
+/*
+ * PS3 Storage Devices
+ *
+ * Copyright (C) 2007 Sony Computer Entertainment Inc.
+ * Copyright 2007 Sony Corp.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published
+ * by the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#ifndef _ASM_POWERPC_PS3STOR_H_
+#define _ASM_POWERPC_PS3STOR_H_
+
+#include <linux/irqreturn.h>
+
+#include <asm/ps3.h>
+
+
+struct ps3_storage_region {
+	unsigned int id;
+	u64 start;
+	u64 size;
+};
+
+struct ps3_storage_device {
+	struct ps3_system_bus_device sbd;
+
+	struct ps3_dma_region dma_region;
+	unsigned int irq;
+	u64 blk_size;
+
+	u64 tag;
+	int lv1_res;
+	u64 lv1_tag;
+	u64 lv1_status;
+	struct completion irq_done;
+
+	unsigned long bounce_size;
+	void *bounce_buf;
+	u64 bounce_lpar;
+	dma_addr_t bounce_dma;
+
+	unsigned int num_regions;
+	unsigned long accessible_regions;
+	unsigned int region_idx;		/* first accessible region */
+	struct ps3_storage_region regions[0];	/* Must be last */
+};
+
+static inline struct ps3_storage_device *to_ps3_storage_device(struct device *dev)
+{
+	return container_of(dev, struct ps3_storage_device, sbd.core);
+}
+
+extern int ps3stor_setup(struct ps3_storage_device *dev, const char *name);
+extern void ps3stor_teardown(struct ps3_storage_device *dev);
+extern u64 ps3stor_read_write_sectors(struct ps3_storage_device *dev, u64 lpar,
+				      u64 start_sector, u64 sectors,
+				      int write);
+extern u64 ps3stor_send_command(struct ps3_storage_device *dev, u64 cmd,
+				u64 arg1, u64 arg2, u64 arg3, u64 arg4);
+
+#endif /* _ASM_POWERPC_PS3STOR_H_ */

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- Sony Network and Software Technology Center Europe (NSCE)
Geert.Uytterhoeven@sonycom.com ------- The Corporate Village, Da Vincilaan 7-D1
Voice +32-2-7008453 Fax +32-2-7008622 ---------------- B-1935 Zaventem, Belgium

