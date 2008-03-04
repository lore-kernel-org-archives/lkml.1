Return-Path: <linux-kernel-owner+w=401wt.eu-S1759041AbYCDIeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759041AbYCDIeY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 03:34:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755300AbYCDIa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 03:30:57 -0500
Received: from de01egw01.freescale.net ([192.88.165.102]:46124 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754869AbYCDIay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 03:30:54 -0500
From: Zhang Wei <wei.zhang@freescale.com>
To: mporter@kernel.crashing.org, galak@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Zhang Wei <wei.zhang@freescale.com>
Subject: [PATCH 12/17] Add RapidIO space allocation bitmap arithmetic.
Date: Wed,  5 Mar 2008 00:29:57 +0800
Message-Id: <1204648202-5495-12-git-send-email-wei.zhang@freescale.com>
X-Mailer: git-send-email 1.5.4
In-Reply-To: <1204648202-5495-11-git-send-email-wei.zhang@freescale.com>
References: <1204648202-5495-1-git-send-email-wei.zhang@freescale.com>
 <1204648202-5495-2-git-send-email-wei.zhang@freescale.com>
 <1204648202-5495-3-git-send-email-wei.zhang@freescale.com>
 <1204648202-5495-4-git-send-email-wei.zhang@freescale.com>
 <1204648202-5495-5-git-send-email-wei.zhang@freescale.com>
 <1204648202-5495-6-git-send-email-wei.zhang@freescale.com>
 <1204648202-5495-7-git-send-email-wei.zhang@freescale.com>
 <1204648202-5495-8-git-send-email-wei.zhang@freescale.com>
 <1204648202-5495-9-git-send-email-wei.zhang@freescale.com>
 <1204648202-5495-10-git-send-email-wei.zhang@freescale.com>
 <1204648202-5495-11-git-send-email-wei.zhang@freescale.com>
X-OriginalArrivalTime: 04 Mar 2008 08:30:36.0532 (UTC) FILETIME=[0548CB40:01C87DD2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bitmap is the simplest RapidIO space allocation arithmetic.
It uses the fixed size space for each RapidIO device in the
inter-connection network.

Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
---
 arch/powerpc/sysdev/fsl_rio.c       |   11 +
 drivers/rapidio/Kconfig             |    2 +
 drivers/rapidio/Makefile            |    1 +
 drivers/rapidio/rio.c               |    1 +
 drivers/rapidio/sallocator/Kconfig  |    9 +
 drivers/rapidio/sallocator/Makefile |   12 +
 drivers/rapidio/sallocator/bitmap.c |  384 +++++++++++++++++++++++++++++++++++
 include/linux/rio.h                 |    6 +-
 8 files changed, 425 insertions(+), 1 deletions(-)
 create mode 100644 drivers/rapidio/sallocator/Kconfig
 create mode 100644 drivers/rapidio/sallocator/Makefile
 create mode 100644 drivers/rapidio/sallocator/bitmap.c

diff --git a/arch/powerpc/sysdev/fsl_rio.c b/arch/powerpc/sysdev/fsl_rio.c
index 068d822..d793084 100644
--- a/arch/powerpc/sysdev/fsl_rio.c
+++ b/arch/powerpc/sysdev/fsl_rio.c
@@ -923,6 +923,17 @@ static int fsl_rio_doorbell_init(struct rio_mport *mport)
 	return rc;
 }
 
+u32 rio_get_mport_id(struct rio_mport *mport)
+{
+	u32 mport_id;
+
+	rio_local_read_config_32(mport, 0x60, &mport_id);
+	mport_id = mport->sys_size ? (mport_id & 0xffff) :
+					((mport_id >> 16) & 0xff);
+	return mport_id;
+
+}
+
 static char *cmdline = NULL;
 
 static int fsl_rio_get_hdid(int index)
diff --git a/drivers/rapidio/Kconfig b/drivers/rapidio/Kconfig
index c32822a..fde2bb3 100644
--- a/drivers/rapidio/Kconfig
+++ b/drivers/rapidio/Kconfig
@@ -8,3 +8,5 @@ config RAPIDIO_DISC_TIMEOUT
 	---help---
 	  Amount of time a discovery node waits for a host to complete
 	  enumeration before giving up.
+
+source "drivers/rapidio/sallocator/Kconfig"
diff --git a/drivers/rapidio/Makefile b/drivers/rapidio/Makefile
index 7c0e181..e5b2f11 100644
--- a/drivers/rapidio/Makefile
+++ b/drivers/rapidio/Makefile
@@ -4,3 +4,4 @@
 obj-y += rio.o rio-access.o rio-driver.o rio-scan.o rio-sysfs.o
 
 obj-$(CONFIG_RAPIDIO)		+= switches/
+obj-$(CONFIG_RAPIDIO)		+= sallocator/
diff --git a/drivers/rapidio/rio.c b/drivers/rapidio/rio.c
index 0dc365d..afd4da6 100644
--- a/drivers/rapidio/rio.c
+++ b/drivers/rapidio/rio.c
@@ -844,6 +844,7 @@ int rio_init_mports(void)
 			rio_enum_mport(port);
 		else
 			rio_disc_mport(port);
+		rio_space_init(port);
 	}
 
       out:
diff --git a/drivers/rapidio/sallocator/Kconfig b/drivers/rapidio/sallocator/Kconfig
new file mode 100644
index 0000000..a33a1b8
--- /dev/null
+++ b/drivers/rapidio/sallocator/Kconfig
@@ -0,0 +1,9 @@
+choice
+	prompt "Default RapidIO Space Allocator"
+	depends on RAPIDIO
+	default RIO_SA_DEFAULT_BITMAP
+
+	config RIO_SA_DEFAULT_BITMAP
+		bool "Bitmap"
+
+endchoice
diff --git a/drivers/rapidio/sallocator/Makefile b/drivers/rapidio/sallocator/Makefile
new file mode 100644
index 0000000..437201c
--- /dev/null
+++ b/drivers/rapidio/sallocator/Makefile
@@ -0,0 +1,12 @@
+#
+# Copyright (C) 2007 Freescale Semiconductor, Inc. All rights reserved.
+#
+# Author: Zhang Wei, wei.zhang@freescale.com, Jun 2007
+#
+# This is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License as published by
+# the Free Software Foundation; either version 2 of the License, or
+# (at your option) any later version.
+#
+
+obj-$(CONFIG_RIO_SA_DEFAULT_BITMAP) += bitmap.o
diff --git a/drivers/rapidio/sallocator/bitmap.c b/drivers/rapidio/sallocator/bitmap.c
new file mode 100644
index 0000000..39a5250
--- /dev/null
+++ b/drivers/rapidio/sallocator/bitmap.c
@@ -0,0 +1,384 @@
+/*
+ * Copyright (C) 2007 Freescale Semiconductor, Inc. All rights reserved.
+ * Author: Zhang Wei, wei.zhang@freescale.com, Jun 2007
+ *
+ * Description:
+ * RapidIO space allocator bitmap arithmetic.
+ *
+ * The Bitmap allocator make the whole RapidIO device have the same fixed
+ * inbound memory window. And on the top of each device inbound window,
+ * there is a sect0 area, which will use for recording the individual
+ * driver owned memory space in device.
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ *
+ */
+
+#include <linux/types.h>
+#include <linux/kernel.h>
+
+#include <linux/delay.h>
+#include <linux/init.h>
+#include <linux/rio.h>
+#include <linux/rio_drv.h>
+#include <linux/rio_ids.h>
+#include <linux/rio_regs.h>
+#include <linux/module.h>
+#include <linux/spinlock.h>
+#include <linux/slab.h>
+#include <linux/seq_file.h>
+#include <linux/fs.h>
+#include <linux/proc_fs.h>
+#include <linux/dma-mapping.h>
+
+#include "../rio.h"
+
+#undef DEBUG
+
+#define RIO_SBLOCK_SIZE	4096
+
+#define ERR(fmt, arg...) \
+	printk(KERN_ERR "ERROR %s - %s: " fmt,  __FILE__, __FUNCTION__, ## arg)
+#ifdef DEBUG
+#define DBG(fmt...) printk(fmt)
+#else
+#define DBG(fmt...) do {} while (0)
+#endif
+
+#define IS_64BIT_RES ((sizeof(resource_size_t) == 8) ? 1 : 0)
+#define SA_BITMAP_DRV_ID	0x4249544d
+#define SA_RIO_RESERVE_SPACE	0x4000000
+
+/* Definition for struct rio_res:ctrl */
+#define SA_RIO_RES_CTRL_EN	0x80000000
+struct rio_res {
+	u32 ctrl;	/* Control words
+			 * Bit 31: Enable bit.
+			 */
+	u32 addr;	/* The start addr bits [0-31] of RapidIO window */
+	u32 extaddr;	/* The start addr bits [32-63] of RapidIO window */
+	u32 size;	/* The size bits [0-31] of RapidIO window */
+	u32 extsize;	/* The size bits [32-63] of RapidIO window */
+	u32 owner;	/* The owner driver id */
+	u32 rev[2];	/* For align 32 bytes */
+};
+
+#define SA_BITMAP_MAX_INB_RES	32
+struct rio_sect0 {
+	u32	id;		/* ID for Bitmap space allocater driver */
+	u32	rioid;		/* RapidIO device id */
+	u32	width;		/* The resource width for RIO space, 32 or 64 */
+	u8	rev1[56];	/* Align to 64 bytes */
+	struct rio_res inb_res[SA_BITMAP_MAX_INB_RES];
+	u8	rev2[4096 - 64 - SA_BITMAP_MAX_INB_RES * 32];
+				/* Fill for 4096 bytes */
+};
+
+/* if select 64bit resource, we can use 34-bit rio address, otherwise 32-bit */
+static int rio_addr_size;
+static struct resource *root;
+static struct rio_mem sect0mem;		/* Sect 0 memory data */
+static struct rio_sect0	*sect0;
+static struct rio_mem *sblock_buf;
+
+/**
+ * get_rio_addr_size -- get the RapidIO space address size.
+ *
+ * If it's a 64-bit system, the RapidIO space address size could be 34bit,
+ * otherwise, it should be 32 bit.
+ */
+static inline int get_rio_addr_size(void)
+{
+	return (sizeof(resource_size_t) == 8) ? 34 : 32;
+}
+
+/**
+ * rio_space_request -- request RapidIO space.
+ * @mport: RIO master port.
+ * @size: The request space size, must >= 4096.
+ * @new: The resource which required.
+ *
+ * Return:
+ *	0 -- Success
+ *	others -- return from allocate_resource()
+ *
+ * This function request a memory from RapidIO space.
+ */
+int rio_space_request(struct rio_mport *mport, resource_size_t size,
+			struct resource *new)
+{
+	int ret = 0;
+
+	/* Align the size to 2^N */
+	size = (size < 0x1000) ? 0x1000 : 1 << (__ilog2(size - 1) + 1);
+
+	memset(new, 0, sizeof(struct resource));
+
+	ret = allocate_resource(root, new, size, root->start, root->end,
+			size, NULL, 0);
+	return ret;
+}
+
+#ifdef DEBUG
+/**
+ * rio_sa_dump_sect0 -- Dump the sect0 content.
+ * @psect0: The point of sect0
+ */
+static void rio_sa_dump_sect0(struct rio_sect0 *psect0)
+{
+	int i;
+
+	if (!psect0)
+		return;
+
+	printk(KERN_DEBUG "Rio Sect0 %p dump:\n", psect0);
+	printk(KERN_DEBUG "...id = 0x%08x, width = %d, rioid = %d\n",
+			psect0->id, psect0->width, psect0->rioid);
+	for (i = 0; i < SA_BITMAP_MAX_INB_RES; i++)
+		if (psect0->inb_res[i].ctrl & SA_RIO_RES_CTRL_EN)
+			printk(KERN_DEBUG
+				"...inb_res[%d]: ctrl 0x%08x, owner 0x%08x\n"
+				"\t\textaddr 0x%08x, addr 0x%08x\n"
+				"\t\textsize 0x%08x, size 0x%08x\n", i,
+			       psect0->inb_res[i].ctrl,
+			       psect0->inb_res[i].owner,
+			       psect0->inb_res[i].extaddr,
+			       psect0->inb_res[i].addr,
+			       psect0->inb_res[i].extsize,
+			       psect0->inb_res[i].size);
+}
+#endif
+
+/**
+ * rio_space_claim -- Claim the memory in RapidIO space
+ * @mem: The memory should be claimed.
+ *
+ * When you get a memory space and get ready of it, you should claim it in
+ * RapidIO space. Then, the other device could get the memory by calling
+ * rio_space_find_mem().
+ */
+int rio_space_claim(struct rio_mem *mem)
+{
+	int i;
+
+	if (!sect0) {
+		ERR("Sect0 is NULL!\n");
+		return -EFAULT;
+	}
+#ifdef DEBUG
+	rio_sa_dump_sect0(sect0);
+#endif
+
+	for (i = 0; i < SA_BITMAP_MAX_INB_RES; i++)
+		if (!(sect0->inb_res[i].ctrl & SA_RIO_RES_CTRL_EN)) {
+			sect0->inb_res[i].ctrl |= SA_RIO_RES_CTRL_EN;
+			sect0->inb_res[i].addr = (u32)(mem->riores.start);
+			sect0->inb_res[i].size = (u32)(mem->riores.end
+					- mem->riores.start + 1);
+			if (IS_64BIT_RES) {
+				sect0->inb_res[i].extaddr =
+					(u64)mem->riores.start >> 32;
+				sect0->inb_res[i].extsize =
+					(u64)(mem->riores.end
+						- mem->riores.start + 1) >> 32;
+			}
+			sect0->inb_res[i].owner = mem->owner;
+			DBG("The new inbound rio mem added:\n");
+			DBG("...inb_res[%d]: ctrl 0x%08x, owner 0x%08x\n"
+				"\t\textaddr 0x%08x, addr 0x%08x\n"
+				"\t\textsize 0x%08x, size 0x%08x\n", i,
+			       sect0->inb_res[i].ctrl,
+			       sect0->inb_res[i].owner,
+			       sect0->inb_res[i].extaddr,
+			       sect0->inb_res[i].addr,
+			       sect0->inb_res[i].extsize,
+			       sect0->inb_res[i].size);
+			return 0;
+		}
+
+	ERR("No free inbound window!\n");
+	return -EBUSY;
+}
+
+/**
+ * rio_space_release -- remove the memory record from RapidIO space.
+ *		        It's the pair function of rio_space_claim().
+ *
+ * @inbmem: The memory should be release.
+ */
+void rio_space_release(struct rio_mem *inbmem)
+{
+	int i;
+
+	/* Remove it from sect0 inb_res array */
+	for (i = 0; i < SA_BITMAP_MAX_INB_RES; i++)
+		if ((sect0->inb_res[i].ctrl & SA_RIO_RES_CTRL_EN) &&
+				(((u64)sect0->inb_res[i].extaddr << 32 |
+				  sect0->inb_res[i].addr)
+				== (u64)inbmem->riores.start)) {
+			sect0->inb_res[i].ctrl = 0;
+			sect0->inb_res[i].addr = 0;
+			sect0->inb_res[i].extaddr = 0;
+			sect0->inb_res[i].size = 0;
+			sect0->inb_res[i].extsize = 0;
+		}
+}
+
+/**
+ * rio_space_get_dev_mem -- get the whole owned inbound space of
+ *			    RapidIO device with did.
+ */
+static int rio_space_get_dev_mem(struct rio_mport *mport,
+		u16 did, struct resource *res)
+{
+	if (!res)
+		return -EINVAL;
+
+	res->start = SA_RIO_RESERVE_SPACE + (did
+		<< (rio_addr_size - __ilog2(RIO_ANY_DESTID(mport->sys_size)
+						+ 1)));
+	res->end = res->start +
+		(1 << (rio_addr_size - __ilog2(RIO_ANY_DESTID(mport->sys_size)
+						+ 1))) - 1;
+	res->flags = RIO_RESOURCE_MEM;
+
+	return 0;
+}
+
+/**
+ * rio_space_find_mem -- Find the memory space (RIO) of the rio driver owned.
+ * @mport: RIO master port.
+ * @tid: The target RapidIO device id which will be searched.
+ * @owner: The driver id as the search keyword.
+ * @res: The result of finding.
+ *
+ * return:
+ *	0 -- Success
+ *	-EFAULT -- Remote sect0 is a bad address
+ *	-EPROTONOSUPPORT -- The remote space allocator protocol is not support
+ *
+ * This function will find the memory located in RapidIO space, which is owned
+ * by the driver. If the remote RapidIO device use the diffrent space allocator,
+ * it will return -EPROTONOSUPPORT.
+ */
+int rio_space_find_mem(struct rio_mport *mport, u16 tid,
+			u32 owner, struct resource *res)
+{
+	struct rio_sect0 __iomem *rsect0;
+	int i;
+	int ret = 0;
+	u32 width;
+
+	ret = rio_space_get_dev_mem(mport, tid, &sblock_buf->riores);
+	if (ret) {
+		ERR("Rio space get dev memory err!\n");
+		goto out;
+	}
+	sblock_buf->size = RIO_SBLOCK_SIZE;
+	rio_map_outb_region(mport, tid, sblock_buf, 0);
+
+	if (!sblock_buf->virt) {
+		ERR("Sect0 block buffer is NULL!\n");
+		ret = -EFAULT;
+		goto out;
+	}
+	rsect0 = sblock_buf->virt;
+
+	if (in_be32(&rsect0->id) != SA_BITMAP_DRV_ID) {
+		DBG("The target RapidIO space allocator is not rio_sa_bitmap! "
+				"id = 0x%x\n", rsect0->id);
+		ret = -EPROTONOSUPPORT;
+		goto out;
+	}
+
+#ifdef DEBUG
+	/* Dump remote sect0 for debug */
+	DBG("Dump the remote RIO dev %d sect0\n", tid);
+	rio_sa_dump_sect0(rsect0);
+#endif
+
+	width = in_be32(&rsect0->width);
+	if (sizeof(resource_size_t) * 8 < width)
+		printk(KERN_WARNING "WARNING: The system width %d is smaller "
+			"than the remote RapidIO space address width %d!",
+			sizeof(resource_size_t) * 8, width);
+
+	/* Find the rio space block */
+	for (i = 0; i < SA_BITMAP_MAX_INB_RES; i++)
+		if ((in_be32(&rsect0->inb_res[i].ctrl) & SA_RIO_RES_CTRL_EN)
+			  && (in_be32(&rsect0->inb_res[i].owner) == owner )) {
+			if (!res) {
+				ERR("Resource NULL error!\n");
+				ret = -EFAULT;
+				goto out;
+			}
+			memset(res, 0, sizeof(struct resource));
+			res->start = (IS_64BIT_RES && (width > 32)) ?
+				in_be32(&rsect0->inb_res[i].extaddr) << 32 : 0
+				| rsect0->inb_res[i].addr;
+			res->end = res->start - 1 +
+				  ((in_be32(&rsect0->inb_res[i].size)) |
+				  ((IS_64BIT_RES && (width > 32)) ?
+				  ((u64)(in_be32(&rsect0->inb_res[i].extsize))
+				   << 32) : 0));
+			goto out;
+		}
+
+out:
+	rio_unmap_outb_region(mport, sblock_buf);
+	return ret;
+}
+
+/**
+ * rio_space_init -- RapidIO space allocator initialization function.
+ * @mport: The master port.
+ */
+int rio_space_init(struct rio_mport *mport)
+{
+	int rc;
+
+	root = &mport->riores[RIO_INB_MEM_RESOURCE];
+	memset(root, 0, sizeof(struct resource));
+
+	rio_addr_size = get_rio_addr_size();
+
+	rc = rio_space_get_dev_mem(mport, rio_get_mport_id(mport), root);
+	if (rc) {
+		ERR("bitmap: get rio dev memory err, rc = %d\n", rc);
+		return rc;
+	}
+	root->name = "rio_space_inb";
+
+	/* Alloc the sect 0 for space managerment */
+	memset(&sect0mem, 0, sizeof(struct rio_mem));
+	sect0mem.virt = dma_alloc_coherent(NULL, RIO_SBLOCK_SIZE,
+					&sect0mem.iores.start, GFP_KERNEL);
+	if (!sect0mem.virt)
+		return -ENOMEM;
+
+	sect0mem.iores.end = sect0mem.iores.start + RIO_SBLOCK_SIZE - 1;
+	sect0mem.size = RIO_SBLOCK_SIZE;
+
+	if (rio_space_request(mport, RIO_SBLOCK_SIZE, &sect0mem.riores))
+		return -ENOMEM;
+
+	sect0mem.riores.name = "sect 0";
+	sect0 = sect0mem.virt;
+	sect0->id = SA_BITMAP_DRV_ID;
+	sect0->rioid = rio_get_mport_id(mport);
+	sect0->width = rio_addr_size;
+
+	/* map outbond window to access rio inb */
+	rio_map_inb_region(mport, &sect0mem, 0);
+
+	/* Init sblock buffer for block seeking */
+	sblock_buf = rio_prepare_io_mem(mport, NULL, RIO_SBLOCK_SIZE,
+			"sblock_buf");
+	if (!sblock_buf)
+		return -ENOMEM;
+
+	return 0;
+}
diff --git a/include/linux/rio.h b/include/linux/rio.h
index b306e53..d8ff4b8 100644
--- a/include/linux/rio.h
+++ b/include/linux/rio.h
@@ -60,11 +60,15 @@
  *
  *	0	RapidIO inbound doorbells
  *	1	RapidIO inbound mailboxes
- *	1	RapidIO outbound mailboxes
+ *	2	RapidIO outbound mailboxes
+ *	3	RapidIO inbound memory
+ *	4	RapidIO outbound memory
  */
 #define RIO_DOORBELL_RESOURCE	0
 #define RIO_INB_MBOX_RESOURCE	1
 #define RIO_OUTB_MBOX_RESOURCE	2
+#define RIO_INB_MEM_RESOURCE	3
+#define RIO_OUTB_MEM_RESOURCE	4
 
 extern struct bus_type rio_bus_type;
 extern struct list_head rio_devices;	/* list of all devices */
-- 
1.5.4

