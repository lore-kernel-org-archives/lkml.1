Return-Path: <linux-kernel-owner+w=401wt.eu-S1762152AbYBHCSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762152AbYBHCSP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 21:18:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754847AbYBHCR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 21:17:58 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:31654 "EHLO
	outbound2-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753275AbYBHCRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 21:17:54 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 149.199.60.83;Service: EHS
From: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
To: grant.likely@secretlab.ca, linuxppc-dev@ozlabs.org, jirislaby@gmail.com,
       linux-kernel@vger.kernel.org
Cc: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Subject: [PATCH] [POWERPC] Xilinx: hwicap driver
Date: Thu,  7 Feb 2008 18:17:41 -0800
X-Mailer: git-send-email 1.5.3.4-dirty
In-Reply-To: <47AB6552.7040503@gmail.com>
References: <47AB6552.7040503@gmail.com>
Message-Id: <20080208021747.92253161805C@mail10-sin.bigfish.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This includes code for new fifo-based xps_hwicap in addition to the
older opb_hwicap, which has a significantly different interface.  The
common code between the two drivers is largely shared.

Significant differences exists between this driver and what is
supported in the EDK drivers.  In particular, most of the
architecture-specific code for reconfiguring individual FPGA resources
has been removed.  This functionality is likely better provided in a
user-space support library.  In addition, read and write access is
supported.  In addition, although the xps_hwicap cores support
interrupt-driver mode, this driver only supports polled operation, in
order to make the code simpler, and since the interrupt processing
overhead is likely to slow down the throughput under Linux.

Signed-off-by: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>

Fixed to add mutexes, and a few style issues.

Acked-by: Grant Likely <grant.likely@secretlab.ca>

The final update to xilinx_hwicap.h was missing.

fix some missing __user tags and incorrect section tags.
convert semaphores to mutexes.
make probed_devices re-entrancy and error condition safe.
fix some backwards memcpys.
some other minor cleanups.

Signed-off-by: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
---
 drivers/char/Kconfig                       |    7 +
 drivers/char/Makefile                      |    1 +
 drivers/char/xilinx_hwicap/Makefile        |    7 +
 drivers/char/xilinx_hwicap/buffer_icap.c   |  380 ++++++++++++
 drivers/char/xilinx_hwicap/buffer_icap.h   |   57 ++
 drivers/char/xilinx_hwicap/fifo_icap.c     |  381 ++++++++++++
 drivers/char/xilinx_hwicap/fifo_icap.h     |   62 ++
 drivers/char/xilinx_hwicap/xilinx_hwicap.c |  923 ++++++++++++++++++++++++++++
 drivers/char/xilinx_hwicap/xilinx_hwicap.h |  193 ++++++
 9 files changed, 2011 insertions(+), 0 deletions(-)
 create mode 100644 drivers/char/xilinx_hwicap/Makefile
 create mode 100644 drivers/char/xilinx_hwicap/buffer_icap.c
 create mode 100644 drivers/char/xilinx_hwicap/buffer_icap.h
 create mode 100644 drivers/char/xilinx_hwicap/fifo_icap.c
 create mode 100644 drivers/char/xilinx_hwicap/fifo_icap.h
 create mode 100644 drivers/char/xilinx_hwicap/xilinx_hwicap.c
 create mode 100644 drivers/char/xilinx_hwicap/xilinx_hwicap.h

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index ef1ed5d..157ae2a 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -831,6 +831,13 @@ config DTLK
 	  To compile this driver as a module, choose M here: the
 	  module will be called dtlk.
 
+config XILINX_HWICAP
+	tristate "Xilinx HWICAP Support"
+	depends on XILINX_VIRTEX
+	help
+	  This option enables support for Xilinx Internal Configuration
+	  Access Port (ICAP) driver.
+
 config R3964
 	tristate "Siemens R3964 line discipline"
 	---help---
diff --git a/drivers/char/Makefile b/drivers/char/Makefile
index 07304d5..3a278a0 100644
--- a/drivers/char/Makefile
+++ b/drivers/char/Makefile
@@ -76,6 +76,7 @@ obj-$(CONFIG_EFI_RTC)		+= efirtc.o
 obj-$(CONFIG_SGI_DS1286)	+= ds1286.o
 obj-$(CONFIG_SGI_IP27_RTC)	+= ip27-rtc.o
 obj-$(CONFIG_DS1302)		+= ds1302.o
+obj-$(CONFIG_XILINX_HWICAP)    += xilinx_hwicap/
 ifeq ($(CONFIG_GENERIC_NVRAM),y)
   obj-$(CONFIG_NVRAM)	+= generic_nvram.o
 else
diff --git a/drivers/char/xilinx_hwicap/Makefile b/drivers/char/xilinx_hwicap/Makefile
new file mode 100644
index 0000000..5491cbc
--- /dev/null
+++ b/drivers/char/xilinx_hwicap/Makefile
@@ -0,0 +1,7 @@
+#
+# Makefile for the Xilinx OPB hwicap driver
+#
+
+obj-$(CONFIG_XILINX_HWICAP) += xilinx_hwicap_m.o 
+ 
+xilinx_hwicap_m-y := xilinx_hwicap.o fifo_icap.o buffer_icap.o
diff --git a/drivers/char/xilinx_hwicap/buffer_icap.c b/drivers/char/xilinx_hwicap/buffer_icap.c
new file mode 100644
index 0000000..dfea2bd
--- /dev/null
+++ b/drivers/char/xilinx_hwicap/buffer_icap.c
@@ -0,0 +1,380 @@
+/*****************************************************************************
+ *
+ *     Author: Xilinx, Inc.
+ *
+ *     This program is free software; you can redistribute it and/or modify it
+ *     under the terms of the GNU General Public License as published by the
+ *     Free Software Foundation; either version 2 of the License, or (at your
+ *     option) any later version.
+ *
+ *     XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"
+ *     AS A COURTESY TO YOU, SOLELY FOR USE IN DEVELOPING PROGRAMS AND
+ *     SOLUTIONS FOR XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE,
+ *     OR INFORMATION AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,
+ *     APPLICATION OR STANDARD, XILINX IS MAKING NO REPRESENTATION
+ *     THAT THIS IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,
+ *     AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE
+ *     FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY
+ *     WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE
+ *     IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR
+ *     REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF
+ *     INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
+ *     FOR A PARTICULAR PURPOSE.
+ *
+ *     Xilinx products are not intended for use in life support appliances,
+ *     devices, or systems. Use in such applications is expressly prohibited.
+ *
+ *     (c) Copyright 2003-2008 Xilinx Inc.
+ *     All rights reserved.
+ *
+ *     You should have received a copy of the GNU General Public License along
+ *     with this program; if not, write to the Free Software Foundation, Inc.,
+ *     675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ *****************************************************************************/
+
+#include "buffer_icap.h"
+
+/* Indicates how many bytes will fit in a buffer. (1 BRAM) */
+#define XHI_MAX_BUFFER_BYTES        2048
+#define XHI_MAX_BUFFER_INTS         (XHI_MAX_BUFFER_BYTES >> 2)
+
+/* File access and error constants */
+#define XHI_DEVICE_READ_ERROR       -1
+#define XHI_DEVICE_WRITE_ERROR      -2
+#define XHI_BUFFER_OVERFLOW_ERROR   -3
+
+#define XHI_DEVICE_READ             0x1
+#define XHI_DEVICE_WRITE            0x0
+
+/* Constants for checking transfer status */
+#define XHI_CYCLE_DONE              0
+#define XHI_CYCLE_EXECUTING         1
+
+/* buffer_icap register offsets */
+
+/* Size of transfer, read & write */
+#define XHI_SIZE_REG_OFFSET        0x800L
+/* offset into bram, read & write */
+#define XHI_BRAM_OFFSET_REG_OFFSET 0x804L
+/* Read not Configure, direction of transfer.  Write only */
+#define XHI_RNC_REG_OFFSET         0x808L
+/* Indicates transfer complete. Read only */
+#define XHI_STATUS_REG_OFFSET      0x80CL
+
+/* Constants for setting the RNC register */
+#define XHI_CONFIGURE              0x0UL
+#define XHI_READBACK               0x1UL
+
+/* Constants for the Done register */
+#define XHI_NOT_FINISHED           0x0UL
+#define XHI_FINISHED               0x1UL
+
+#define XHI_BUFFER_START 0
+
+/**
+ * buffer_icap_get_status: Get the contents of the status register.
+ * @parameter base_address: is the base address of the device
+ *
+ * The status register contains the ICAP status and the done bit.
+ *
+ * D8 - cfgerr
+ * D7 - dalign
+ * D6 - rip
+ * D5 - in_abort_l
+ * D4 - Always 1
+ * D3 - Always 1
+ * D2 - Always 1
+ * D1 - Always 1
+ * D0 - Done bit
+ **/
+static inline u32 buffer_icap_get_status(void __iomem *base_address)
+{
+	return in_be32(base_address + XHI_STATUS_REG_OFFSET);
+}
+
+/**
+ * buffer_icap_get_bram: Reads data from the storage buffer bram.
+ * @parameter base_address: contains the base address of the component.
+ * @parameter offset: The word offset from which the data should be read.
+ *
+ * A bram is used as a configuration memory cache.  One frame of data can
+ * be stored in this "storage buffer".
+ **/
+static inline u32 buffer_icap_get_bram(void __iomem *base_address,
+		u32 offset)
+{
+	return in_be32(base_address + (offset << 2));
+}
+
+/**
+ * buffer_icap_busy: Return true if the icap device is busy
+ * @parameter base_address: is the base address of the device
+ *
+ * The queries the low order bit of the status register, which
+ * indicates whether the current configuration or readback operation
+ * has completed.
+ **/
+static inline bool buffer_icap_busy(void __iomem *base_address)
+{
+	return (buffer_icap_get_status(base_address) & 1) == XHI_NOT_FINISHED;
+}
+
+/**
+ * buffer_icap_busy: Return true if the icap device is not busy
+ * @parameter base_address: is the base address of the device
+ *
+ * The queries the low order bit of the status register, which
+ * indicates whether the current configuration or readback operation
+ * has completed.
+ **/
+static inline bool buffer_icap_done(void __iomem *base_address)
+{
+	return (buffer_icap_get_status(base_address) & 1) == XHI_FINISHED;
+}
+
+/**
+ * buffer_icap_set_size: Set the size register.
+ * @parameter base_address: is the base address of the device
+ * @parameter data: The size in bytes.
+ *
+ * The size register holds the number of 8 bit bytes to transfer between
+ * bram and the icap (or icap to bram).
+ **/
+static inline void buffer_icap_set_size(void __iomem *base_address,
+		u32 data)
+{
+	out_be32(base_address + XHI_SIZE_REG_OFFSET, data);
+}
+
+/**
+ * buffer_icap_mSetoffsetReg: Set the bram offset register.
+ * @parameter base_address: contains the base address of the device.
+ * @parameter data: is the value to be written to the data register.
+ *
+ * The bram offset register holds the starting bram address to transfer
+ * data from during configuration or write data to during readback.
+ **/
+static inline void buffer_icap_set_offset(void __iomem *base_address,
+		u32 data)
+{
+	out_be32(base_address + XHI_BRAM_OFFSET_REG_OFFSET, data);
+}
+
+/**
+ * buffer_icap_set_rnc: Set the RNC (Readback not Configure) register.
+ * @parameter base_address: contains the base address of the device.
+ * @parameter data: is the value to be written to the data register.
+ *
+ * The RNC register determines the direction of the data transfer.  It
+ * controls whether a configuration or readback take place.  Writing to
+ * this register initiates the transfer.  A value of 1 initiates a
+ * readback while writing a value of 0 initiates a configuration.
+ **/
+static inline void buffer_icap_set_rnc(void __iomem *base_address,
+		u32 data)
+{
+	out_be32(base_address + XHI_RNC_REG_OFFSET, data);
+}
+
+/**
+ * buffer_icap_set_bram: Write data to the storage buffer bram.
+ * @parameter base_address: contains the base address of the component.
+ * @parameter offset: The word offset at which the data should be written.
+ * @parameter data: The value to be written to the bram offset.
+ *
+ * A bram is used as a configuration memory cache.  One frame of data can
+ * be stored in this "storage buffer".
+ **/
+static inline void buffer_icap_set_bram(void __iomem *base_address,
+		u32 offset, u32 data)
+{
+	out_be32(base_address + (offset << 2), data);
+}
+
+/**
+ * buffer_icap_device_read: Transfer bytes from ICAP to the storage buffer.
+ * @parameter drvdata: a pointer to the drvdata.
+ * @parameter offset: The storage buffer start address.
+ * @parameter count: The number of words (32 bit) to read from the
+ *           device (ICAP).
+ **/
+static int buffer_icap_device_read(struct hwicap_drvdata *drvdata,
+		u32 offset, u32 count)
+{
+
+	s32 retries = 0;
+	void __iomem *base_address = drvdata->base_address;
+
+	if (buffer_icap_busy(base_address))
+		return -EBUSY;
+
+	if ((offset + count) > XHI_MAX_BUFFER_INTS)
+		return -EINVAL;
+
+	/* setSize count*4 to get bytes. */
+	buffer_icap_set_size(base_address, (count << 2));
+	buffer_icap_set_offset(base_address, offset);
+	buffer_icap_set_rnc(base_address, XHI_READBACK);
+
+	while (buffer_icap_busy(base_address)) {
+		retries++;
+		if (retries > XHI_MAX_RETRIES)
+			return -EBUSY;
+	}
+	return 0;
+
+};
+
+/**
+ * buffer_icap_device_write: Transfer bytes from ICAP to the storage buffer.
+ * @parameter drvdata: a pointer to the drvdata.
+ * @parameter offset: The storage buffer start address.
+ * @parameter count: The number of words (32 bit) to read from the
+ *           device (ICAP).
+ **/
+static int buffer_icap_device_write(struct hwicap_drvdata *drvdata,
+		u32 offset, u32 count)
+{
+
+	s32 retries = 0;
+	void __iomem *base_address = drvdata->base_address;
+
+	if (buffer_icap_busy(base_address))
+		return -EBUSY;
+
+	if ((offset + count) > XHI_MAX_BUFFER_INTS)
+		return -EINVAL;
+
+	/* setSize count*4 to get bytes. */
+	buffer_icap_set_size(base_address, count << 2);
+	buffer_icap_set_offset(base_address, offset);
+	buffer_icap_set_rnc(base_address, XHI_CONFIGURE);
+
+	while (buffer_icap_busy(base_address)) {
+		retries++;
+		if (retries > XHI_MAX_RETRIES)
+			return -EBUSY;
+	}
+	return 0;
+
+};
+
+/**
+ * buffer_icap_reset: Reset the logic of the icap device.
+ * @parameter drvdata: a pointer to the drvdata.
+ *
+ * Writing to the status register resets the ICAP logic in an internal
+ * version of the core.  For the version of the core published in EDK,
+ * this is a noop.
+ **/
+void buffer_icap_reset(struct hwicap_drvdata *drvdata)
+{
+    out_be32(drvdata->base_address + XHI_STATUS_REG_OFFSET, 0xFEFE);
+}
+
+/**
+ * buffer_icap_set_configuration: Load a partial bitstream from system memory.
+ * @parameter drvdata: a pointer to the drvdata.
+ * @parameter data: Kernel address of the partial bitstream.
+ * @parameter size: the size of the partial bitstream in 32 bit words.
+ **/
+int buffer_icap_set_configuration(struct hwicap_drvdata *drvdata, u32 *data,
+			     u32 size)
+{
+	int status;
+	s32 buffer_count = 0;
+	s32 num_writes = 0;
+	bool dirty = 0;
+	u32 i;
+	void __iomem *base_address = drvdata->base_address;
+
+	/* Loop through all the data */
+	for (i = 0, buffer_count = 0; i < size; i++) {
+
+		/* Copy data to bram */
+		buffer_icap_set_bram(base_address, buffer_count, data[i]);
+		dirty = 1;
+
+		if (buffer_count < XHI_MAX_BUFFER_INTS - 1) {
+			buffer_count++;
+			continue;
+		}
+
+		/* Write data to ICAP */
+		status = buffer_icap_device_write(
+				drvdata,
+				XHI_BUFFER_START,
+				XHI_MAX_BUFFER_INTS);
+		if (status != 0) {
+			/* abort. */
+			buffer_icap_reset(drvdata);
+			return status;
+		}
+
+		buffer_count = 0;
+		num_writes++;
+		dirty = 0;
+	}
+
+	/* Write unwritten data to ICAP */
+	if (dirty) {
+		/* Write data to ICAP */
+		status = buffer_icap_device_write(drvdata, XHI_BUFFER_START,
+					     buffer_count);
+		if (status != 0) {
+			/* abort. */
+			buffer_icap_reset(drvdata);
+		}
+		return status;
+	}
+
+	return 0;
+};
+
+/**
+ * buffer_icap_get_configuration: Read configuration data from the device.
+ * @parameter drvdata: a pointer to the drvdata.
+ * @parameter data: Address of the data representing the partial bitstream
+ * @parameter size: the size of the partial bitstream in 32 bit words.
+ **/
+int buffer_icap_get_configuration(struct hwicap_drvdata *drvdata, u32 *data,
+			     u32 size)
+{
+	int status;
+	s32 buffer_count = 0;
+	s32 read_count = 0;
+	u32 i;
+	void __iomem *base_address = drvdata->base_address;
+
+	/* Loop through all the data */
+	for (i = 0, buffer_count = XHI_MAX_BUFFER_INTS; i < size; i++) {
+		if (buffer_count == XHI_MAX_BUFFER_INTS) {
+			u32 words_remaining = size - i;
+			u32 words_to_read =
+				words_remaining <
+				XHI_MAX_BUFFER_INTS ? words_remaining :
+				XHI_MAX_BUFFER_INTS;
+
+			/* Read data from ICAP */
+			status = buffer_icap_device_read(
+					drvdata,
+					XHI_BUFFER_START,
+					words_to_read);
+			if (status != 0) {
+				/* abort. */
+				buffer_icap_reset(drvdata);
+				return status;
+			}
+
+			buffer_count = 0;
+			read_count++;
+		}
+
+		/* Copy data from bram */
+		data[i] = buffer_icap_get_bram(base_address, buffer_count);
+		buffer_count++;
+	}
+
+	return 0;
+};
diff --git a/drivers/char/xilinx_hwicap/buffer_icap.h b/drivers/char/xilinx_hwicap/buffer_icap.h
new file mode 100644
index 0000000..0318495
--- /dev/null
+++ b/drivers/char/xilinx_hwicap/buffer_icap.h
@@ -0,0 +1,57 @@
+/*****************************************************************************
+ *
+ *     Author: Xilinx, Inc.
+ *
+ *     This program is free software; you can redistribute it and/or modify it
+ *     under the terms of the GNU General Public License as published by the
+ *     Free Software Foundation; either version 2 of the License, or (at your
+ *     option) any later version.
+ *
+ *     XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"
+ *     AS A COURTESY TO YOU, SOLELY FOR USE IN DEVELOPING PROGRAMS AND
+ *     SOLUTIONS FOR XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE,
+ *     OR INFORMATION AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,
+ *     APPLICATION OR STANDARD, XILINX IS MAKING NO REPRESENTATION
+ *     THAT THIS IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,
+ *     AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE
+ *     FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY
+ *     WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE
+ *     IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR
+ *     REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF
+ *     INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
+ *     FOR A PARTICULAR PURPOSE.
+ *
+ *     Xilinx products are not intended for use in life support appliances,
+ *     devices, or systems. Use in such applications is expressly prohibited.
+ *
+ *     (c) Copyright 2003-2008 Xilinx Inc.
+ *     All rights reserved.
+ *
+ *     You should have received a copy of the GNU General Public License along
+ *     with this program; if not, write to the Free Software Foundation, Inc.,
+ *     675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ *****************************************************************************/
+
+#ifndef XILINX_BUFFER_ICAP_H_	/* prevent circular inclusions */
+#define XILINX_BUFFER_ICAP_H_	/* by using protection macros */
+
+#include <linux/types.h>
+#include <linux/cdev.h>
+#include <linux/version.h>
+#include <linux/platform_device.h>
+
+#include <asm/io.h>
+#include "xilinx_hwicap.h"
+
+void buffer_icap_reset(struct hwicap_drvdata *drvdata);
+
+/* Loads a partial bitstream from system memory. */
+int buffer_icap_set_configuration(struct hwicap_drvdata *drvdata, u32 *data,
+			     u32 Size);
+
+/* Loads a partial bitstream from system memory. */
+int buffer_icap_get_configuration(struct hwicap_drvdata *drvdata, u32 *data,
+			     u32 Size);
+
+#endif
diff --git a/drivers/char/xilinx_hwicap/fifo_icap.c b/drivers/char/xilinx_hwicap/fifo_icap.c
new file mode 100644
index 0000000..0988314
--- /dev/null
+++ b/drivers/char/xilinx_hwicap/fifo_icap.c
@@ -0,0 +1,381 @@
+/*****************************************************************************
+ *
+ *     Author: Xilinx, Inc.
+ *
+ *     This program is free software; you can redistribute it and/or modify it
+ *     under the terms of the GNU General Public License as published by the
+ *     Free Software Foundation; either version 2 of the License, or (at your
+ *     option) any later version.
+ *
+ *     XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"
+ *     AS A COURTESY TO YOU, SOLELY FOR USE IN DEVELOPING PROGRAMS AND
+ *     SOLUTIONS FOR XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE,
+ *     OR INFORMATION AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,
+ *     APPLICATION OR STANDARD, XILINX IS MAKING NO REPRESENTATION
+ *     THAT THIS IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,
+ *     AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE
+ *     FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY
+ *     WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE
+ *     IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR
+ *     REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF
+ *     INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
+ *     FOR A PARTICULAR PURPOSE.
+ *
+ *     Xilinx products are not intended for use in life support appliances,
+ *     devices, or systems. Use in such applications is expressly prohibited.
+ *
+ *     (c) Copyright 2007-2008 Xilinx Inc.
+ *     All rights reserved.
+ *
+ *     You should have received a copy of the GNU General Public License along
+ *     with this program; if not, write to the Free Software Foundation, Inc.,
+ *     675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ *****************************************************************************/
+
+#include "fifo_icap.h"
+
+/* Register offsets for the XHwIcap device. */
+#define XHI_GIER_OFFSET	0x1C  /* Device Global Interrupt Enable Reg */
+#define XHI_IPISR_OFFSET 0x20  /* Interrupt Status Register */
+#define XHI_IPIER_OFFSET 0x28  /* Interrupt Enable Register */
+#define XHI_WF_OFFSET 0x100 /* Write FIFO */
+#define XHI_RF_OFFSET 0x104 /* Read FIFO */
+#define XHI_SZ_OFFSET 0x108 /* Size Register */
+#define XHI_CR_OFFSET 0x10C /* Control Register */
+#define XHI_SR_OFFSET 0x110 /* Status Register */
+#define XHI_WFV_OFFSET 0x114 /* Write FIFO Vacancy Register */
+#define XHI_RFO_OFFSET 0x118 /* Read FIFO Occupancy Register */
+
+/* Device Global Interrupt Enable Register (GIER) bit definitions */
+
+#define XHI_GIER_GIE_MASK 0x80000000 /* Global Interrupt enable Mask */
+
+/**
+ * HwIcap Device Interrupt Status/Enable Registers
+ *
+ * Interrupt Status Register (IPISR) : This register holds the
+ * interrupt status flags for the device. These bits are toggle on
+ * write.
+ *
+ * Interrupt Enable Register (IPIER) : This register is used to enable
+ * interrupt sources for the device.
+ * Writing a '1' to a bit enables the corresponding interrupt.
+ * Writing a '0' to a bit disables the corresponding interrupt.
+ *
+ * IPISR/IPIER registers have the same bit definitions and are only defined
+ * once.
+ */
+#define XHI_IPIXR_RFULL_MASK 0x00000008 /* Read FIFO Full */
+#define XHI_IPIXR_WEMPTY_MASK 0x00000004 /* Write FIFO Empty */
+#define XHI_IPIXR_RDP_MASK 0x00000002 /* Read FIFO half full */
+#define XHI_IPIXR_WRP_MASK 0x00000001 /* Write FIFO half full */
+#define XHI_IPIXR_ALL_MASK 0x0000000F /* Mask of all interrupts */
+
+/* Control Register (CR) */
+#define XHI_CR_SW_RESET_MASK 0x00000008 /* SW Reset Mask */
+#define XHI_CR_FIFO_CLR_MASK 0x00000004 /* FIFO Clear Mask */
+#define XHI_CR_READ_MASK 0x00000002 /* Read from ICAP to FIFO */
+#define XHI_CR_WRITE_MASK 0x00000001 /* Write from FIFO to ICAP */
+
+/* Status Register (SR) */
+#define XHI_SR_CFGERR_N_MASK 0x00000100 /* Config Error Mask */
+#define XHI_SR_DALIGN_MASK 0x00000080 /* Data Alignment Mask */
+#define XHI_SR_RIP_MASK 0x00000040 /* Read back Mask */
+#define XHI_SR_IN_ABORT_N_MASK 0x00000020 /* Select Map Abort Mask */
+#define XHI_SR_DONE_MASK 0x00000001 /* Done bit Mask  */
+
+
+#define XHI_WFO_MAX_VACANCY 1024 /* Max Write FIFO Vacancy, in words */
+#define XHI_RFO_MAX_OCCUPANCY 256 /* Max Read FIFO Occupancy, in words */
+/* The maximum amount we can request from fifo_icap_get_configuration
+   at once, in bytes. */
+#define XHI_MAX_READ_TRANSACTION_WORDS 0xFFF
+
+
+/**
+ * fifo_icap_fifo_write: Write data to the write FIFO.
+ * @parameter drvdata: a pointer to the drvdata.
+ * @parameter data: the 32-bit value to be written to the FIFO.
+ *
+ * This function will silently fail if the fifo is full.
+ **/
+static inline void fifo_icap_fifo_write(struct hwicap_drvdata *drvdata,
+		u32 data)
+{
+	dev_dbg(drvdata->dev, "fifo_write: %x\n", data);
+	out_be32(drvdata->base_address + XHI_WF_OFFSET, data);
+}
+
+/**
+ * fifo_icap_fifo_read: Read data from the Read FIFO.
+ * @parameter drvdata: a pointer to the drvdata.
+ *
+ * This function will silently fail if the fifo is empty.
+ **/
+static inline u32 fifo_icap_fifo_read(struct hwicap_drvdata *drvdata)
+{
+	u32 data = in_be32(drvdata->base_address + XHI_RF_OFFSET);
+	dev_dbg(drvdata->dev, "fifo_read: %x\n", data);
+	return data;
+}
+
+/**
+ * fifo_icap_set_read_size: Set the the size register.
+ * @parameter drvdata: a pointer to the drvdata.
+ * @parameter data: the size of the following read transaction, in words.
+ **/
+static inline void fifo_icap_set_read_size(struct hwicap_drvdata *drvdata,
+		u32 data)
+{
+	out_be32(drvdata->base_address + XHI_SZ_OFFSET, data);
+}
+
+/**
+ * fifo_icap_start_config: Initiate a configuration (write) to the device.
+ * @parameter drvdata: a pointer to the drvdata.
+ **/
+static inline void fifo_icap_start_config(struct hwicap_drvdata *drvdata)
+{
+	out_be32(drvdata->base_address + XHI_CR_OFFSET, XHI_CR_WRITE_MASK);
+	dev_dbg(drvdata->dev, "configuration started\n");
+}
+
+/**
+ * fifo_icap_start_readback: Initiate a readback from the device.
+ * @parameter drvdata: a pointer to the drvdata.
+ **/
+static inline void fifo_icap_start_readback(struct hwicap_drvdata *drvdata)
+{
+	out_be32(drvdata->base_address + XHI_CR_OFFSET, XHI_CR_READ_MASK);
+	dev_dbg(drvdata->dev, "readback started\n");
+}
+
+/**
+ * fifo_icap_busy: Return true if the ICAP is still processing a transaction.
+ * @parameter drvdata: a pointer to the drvdata.
+ **/
+static inline u32 fifo_icap_busy(struct hwicap_drvdata *drvdata)
+{
+	u32 status = in_be32(drvdata->base_address + XHI_SR_OFFSET);
+	dev_dbg(drvdata->dev, "Getting status = %x\n", status);
+	return (status & XHI_SR_DONE_MASK) ? 0 : 1;
+}
+
+/**
+ * fifo_icap_write_fifo_vacancy: Query the write fifo available space.
+ * @parameter drvdata: a pointer to the drvdata.
+ *
+ * Return the number of words that can be safely pushed into the write fifo.
+ **/
+static inline u32 fifo_icap_write_fifo_vacancy(
+		struct hwicap_drvdata *drvdata)
+{
+	return in_be32(drvdata->base_address + XHI_WFV_OFFSET);
+}
+
+/**
+ * fifo_icap_read_fifo_occupancy: Query the read fifo available data.
+ * @parameter drvdata: a pointer to the drvdata.
+ *
+ * Return the number of words that can be safely read from the read fifo.
+ **/
+static inline u32 fifo_icap_read_fifo_occupancy(
+		struct hwicap_drvdata *drvdata)
+{
+	return in_be32(drvdata->base_address + XHI_RFO_OFFSET);
+}
+
+/**
+ * fifo_icap_set_configuration: Send configuration data to the ICAP.
+ * @parameter drvdata: a pointer to the drvdata.
+ * @parameter frame_buffer: a pointer to the data to be written to the
+ *		ICAP device.
+ * @parameter num_words: the number of words (32 bit) to write to the ICAP
+ *		device.
+
+ * This function writes the given user data to the Write FIFO in
+ * polled mode and starts the transfer of the data to
+ * the ICAP device.
+ **/
+int fifo_icap_set_configuration(struct hwicap_drvdata *drvdata,
+		u32 *frame_buffer, u32 num_words)
+{
+
+	u32 write_fifo_vacancy = 0;
+	u32 retries = 0;
+	u32 remaining_words;
+
+	dev_dbg(drvdata->dev, "fifo_set_configuration\n");
+
+	/*
+	 * Check if the ICAP device is Busy with the last Read/Write
+	 */
+	if (fifo_icap_busy(drvdata))
+		return -EBUSY;
+
+	/*
+	 * Set up the buffer pointer and the words to be transferred.
+	 */
+	remaining_words = num_words;
+
+	while (remaining_words > 0) {
+		/*
+		 * Wait until we have some data in the fifo.
+		 */
+		while (write_fifo_vacancy == 0) {
+			write_fifo_vacancy =
+				fifo_icap_write_fifo_vacancy(drvdata);
+			retries++;
+			if (retries > XHI_MAX_RETRIES)
+				return -EIO;
+		}
+
+		/*
+		 * Write data into the Write FIFO.
+		 */
+		while ((write_fifo_vacancy != 0) &&
+				(remaining_words > 0)) {
+			fifo_icap_fifo_write(drvdata, *frame_buffer);
+
+			remaining_words--;
+			write_fifo_vacancy--;
+			frame_buffer++;
+		}
+		/* Start pushing whatever is in the FIFO into the ICAP. */
+		fifo_icap_start_config(drvdata);
+	}
+
+	/* Wait until the write has finished. */
+	while (fifo_icap_busy(drvdata)) {
+		retries++;
+		if (retries > XHI_MAX_RETRIES)
+			break;
+	}
+
+	dev_dbg(drvdata->dev, "done fifo_set_configuration\n");
+
+	/*
+	 * If the requested number of words have not been read from
+	 * the device then indicate failure.
+	 */
+	if (remaining_words != 0)
+		return -EIO;
+
+	return 0;
+}
+
+/**
+ * fifo_icap_get_configuration: Read configuration data from the device.
+ * @parameter drvdata: a pointer to the drvdata.
+ * @parameter data: Address of the data representing the partial bitstream
+ * @parameter size: the size of the partial bitstream in 32 bit words.
+ *
+ * This function reads the specified number of words from the ICAP device in
+ * the polled mode.
+ */
+int fifo_icap_get_configuration(struct hwicap_drvdata *drvdata,
+		u32 *frame_buffer, u32 num_words)
+{
+
+	u32 read_fifo_occupancy = 0;
+	u32 retries = 0;
+	u32 *data = frame_buffer;
+	u32 remaining_words;
+	u32 words_to_read;
+
+	dev_dbg(drvdata->dev, "fifo_get_configuration\n");
+
+	/*
+	 * Check if the ICAP device is Busy with the last Write/Read
+	 */
+	if (fifo_icap_busy(drvdata))
+		return -EBUSY;
+
+	remaining_words = num_words;
+
+	while (remaining_words > 0) {
+		words_to_read = remaining_words;
+		/* The hardware has a limit on the number of words
+		   that can be read at one time.  */
+		if (words_to_read > XHI_MAX_READ_TRANSACTION_WORDS)
+			words_to_read = XHI_MAX_READ_TRANSACTION_WORDS;
+
+		remaining_words -= words_to_read;
+
+		fifo_icap_set_read_size(drvdata, words_to_read);
+		fifo_icap_start_readback(drvdata);
+
+		while (words_to_read > 0) {
+			/* Wait until we have some data in the fifo. */
+			while (read_fifo_occupancy == 0) {
+				read_fifo_occupancy =
+					fifo_icap_read_fifo_occupancy(drvdata);
+				retries++;
+				if (retries > XHI_MAX_RETRIES)
+					return -EIO;
+			}
+
+			if (read_fifo_occupancy > words_to_read)
+				read_fifo_occupancy = words_to_read;
+
+			words_to_read -= read_fifo_occupancy;
+
+			/* Read the data from the Read FIFO. */
+			while (read_fifo_occupancy != 0) {
+				*data++ = fifo_icap_fifo_read(drvdata);
+				read_fifo_occupancy--;
+			}
+		}
+	}
+
+	dev_dbg(drvdata->dev, "done fifo_get_configuration\n");
+
+	return 0;
+}
+
+/**
+ * buffer_icap_reset: Reset the logic of the icap device.
+ * @parameter drvdata: a pointer to the drvdata.
+ *
+ * This function forces the software reset of the complete HWICAP device.
+ * All the registers will return to the default value and the FIFO is also
+ * flushed as a part of this software reset.
+ */
+void fifo_icap_reset(struct hwicap_drvdata *drvdata)
+{
+	u32 reg_data;
+	/*
+	 * Reset the device by setting/clearing the RESET bit in the
+	 * Control Register.
+	 */
+	reg_data = in_be32(drvdata->base_address + XHI_CR_OFFSET);
+
+	out_be32(drvdata->base_address + XHI_CR_OFFSET,
+				reg_data | XHI_CR_SW_RESET_MASK);
+
+	out_be32(drvdata->base_address + XHI_CR_OFFSET,
+				reg_data & (~XHI_CR_SW_RESET_MASK));
+
+}
+
+/**
+ * fifo_icap_flush_fifo: This function flushes the FIFOs in the device.
+ * @parameter drvdata: a pointer to the drvdata.
+ */
+void fifo_icap_flush_fifo(struct hwicap_drvdata *drvdata)
+{
+	u32 reg_data;
+	/*
+	 * Flush the FIFO by setting/clearing the FIFO Clear bit in the
+	 * Control Register.
+	 */
+	reg_data = in_be32(drvdata->base_address + XHI_CR_OFFSET);
+
+	out_be32(drvdata->base_address + XHI_CR_OFFSET,
+				reg_data | XHI_CR_FIFO_CLR_MASK);
+
+	out_be32(drvdata->base_address + XHI_CR_OFFSET,
+				reg_data & (~XHI_CR_FIFO_CLR_MASK));
+}
+
diff --git a/drivers/char/xilinx_hwicap/fifo_icap.h b/drivers/char/xilinx_hwicap/fifo_icap.h
new file mode 100644
index 0000000..4d3068d
--- /dev/null
+++ b/drivers/char/xilinx_hwicap/fifo_icap.h
@@ -0,0 +1,62 @@
+/*****************************************************************************
+ *
+ *     Author: Xilinx, Inc.
+ *
+ *     This program is free software; you can redistribute it and/or modify it
+ *     under the terms of the GNU General Public License as published by the
+ *     Free Software Foundation; either version 2 of the License, or (at your
+ *     option) any later version.
+ *
+ *     XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"
+ *     AS A COURTESY TO YOU, SOLELY FOR USE IN DEVELOPING PROGRAMS AND
+ *     SOLUTIONS FOR XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE,
+ *     OR INFORMATION AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,
+ *     APPLICATION OR STANDARD, XILINX IS MAKING NO REPRESENTATION
+ *     THAT THIS IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,
+ *     AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE
+ *     FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY
+ *     WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE
+ *     IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR
+ *     REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF
+ *     INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
+ *     FOR A PARTICULAR PURPOSE.
+ *
+ *     Xilinx products are not intended for use in life support appliances,
+ *     devices, or systems. Use in such applications is expressly prohibited.
+ *
+ *     (c) Copyright 2007-2008 Xilinx Inc.
+ *     All rights reserved.
+ *
+ *     You should have received a copy of the GNU General Public License along
+ *     with this program; if not, write to the Free Software Foundation, Inc.,
+ *     675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ *****************************************************************************/
+
+#ifndef XILINX_FIFO_ICAP_H_	/* prevent circular inclusions */
+#define XILINX_FIFO_ICAP_H_	/* by using protection macros */
+
+#include <linux/types.h>
+#include <linux/cdev.h>
+#include <linux/version.h>
+#include <linux/platform_device.h>
+
+#include <asm/io.h>
+#include "xilinx_hwicap.h"
+
+/* Reads integers from the device into the storage buffer. */
+int fifo_icap_get_configuration(
+		struct hwicap_drvdata *drvdata,
+		u32 *FrameBuffer,
+		u32 NumWords);
+
+/* Writes integers to the device from the storage buffer. */
+int fifo_icap_set_configuration(
+		struct hwicap_drvdata *drvdata,
+		u32 *FrameBuffer,
+		u32 NumWords);
+
+void fifo_icap_reset(struct hwicap_drvdata *drvdata);
+void fifo_icap_flush_fifo(struct hwicap_drvdata *drvdata);
+
+#endif
diff --git a/drivers/char/xilinx_hwicap/xilinx_hwicap.c b/drivers/char/xilinx_hwicap/xilinx_hwicap.c
new file mode 100644
index 0000000..2caac31
--- /dev/null
+++ b/drivers/char/xilinx_hwicap/xilinx_hwicap.c
@@ -0,0 +1,923 @@
+/*****************************************************************************
+ *
+ *     Author: Xilinx, Inc.
+ *
+ *     This program is free software; you can redistribute it and/or modify it
+ *     under the terms of the GNU General Public License as published by the
+ *     Free Software Foundation; either version 2 of the License, or (at your
+ *     option) any later version.
+ *
+ *     XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"
+ *     AS A COURTESY TO YOU, SOLELY FOR USE IN DEVELOPING PROGRAMS AND
+ *     SOLUTIONS FOR XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE,
+ *     OR INFORMATION AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,
+ *     APPLICATION OR STANDARD, XILINX IS MAKING NO REPRESENTATION
+ *     THAT THIS IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,
+ *     AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE
+ *     FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY
+ *     WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE
+ *     IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR
+ *     REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF
+ *     INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
+ *     FOR A PARTICULAR PURPOSE.
+ *
+ *     Xilinx products are not intended for use in life support appliances,
+ *     devices, or systems. Use in such applications is expressly prohibited.
+ *
+ *     (c) Copyright 2002 Xilinx Inc., Systems Engineering Group
+ *     (c) Copyright 2004 Xilinx Inc., Systems Engineering Group
+ *     (c) Copyright 2007-2008 Xilinx Inc.
+ *     All rights reserved.
+ *
+ *     You should have received a copy of the GNU General Public License along
+ *     with this program; if not, write to the Free Software Foundation, Inc.,
+ *     675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ *****************************************************************************/
+
+/*
+ * This is the code behind /dev/xilinx_icap -- it allows a user-space
+ * application to use the Xilinx ICAP subsystem.
+ *
+ * The following operations are possible:
+ *
+ * open         open the port and initialize for access.
+ * release      release port
+ * write        Write a bitstream to the configuration processor.
+ * read         Read a data stream from the configuration processor.
+ *
+ * After being opened, the port is initialized and accessed to avoid a
+ * corrupted first read which may occur with some hardware.  The port
+ * is left in a desynched state, requiring that a synch sequence be
+ * transmitted before any valid configuration data.  A user will have
+ * exclusive access to the device while it remains open, and the state
+ * of the ICAP cannot be guaranteed after the device is closed.  Note
+ * that a complete reset of the core and the state of the ICAP cannot
+ * be performed on many versions of the cores, hence users of this
+ * device should avoid making inconsistent accesses to the device.  In
+ * particular, accessing the read interface, without first generating
+ * a write containing a readback packet can leave the ICAP in an
+ * inaccessible state.
+ *
+ * Note that in order to use the read interface, it is first necessary
+ * to write a request packet to the write interface.  i.e., it is not
+ * possible to simply readback the bitstream (or any configuration
+ * bits) from a device without specifically requesting them first.
+ * The code to craft such packets is intended to be part of the
+ * user-space application code that uses this device.  The simplest
+ * way to use this interface is simply:
+ *
+ * cp foo.bit /dev/xilinx_icap
+ *
+ * Note that unless foo.bit is an appropriately constructed partial
+ * bitstream, this has a high likelyhood of overwriting the design
+ * currently programmed in the FPGA.
+ */
+
+#include <linux/version.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/ioport.h>
+#include <linux/interrupt.h>
+#include <linux/fcntl.h>
+#include <linux/init.h>
+#include <linux/poll.h>
+#include <linux/proc_fs.h>
+#include <linux/mutex.h>
+#include <linux/sysctl.h>
+#include <linux/version.h>
+#include <linux/fs.h>
+#include <linux/cdev.h>
+#include <linux/platform_device.h>
+
+#include <asm/io.h>
+#include <asm/uaccess.h>
+#include <asm/system.h>
+
+#ifdef CONFIG_OF
+/* For open firmware. */
+#include <linux/of_device.h>
+#include <linux/of_platform.h>
+#endif
+
+#include "xilinx_hwicap.h"
+#include "buffer_icap.h"
+#include "fifo_icap.h"
+
+#define DRIVER_NAME "xilinx_icap"
+
+#define HWICAP_REGS   (0x10000)
+
+/* dynamically allocate device number */
+static int xhwicap_major;
+static int xhwicap_minor;
+#define HWICAP_DEVICES 1
+
+module_param(xhwicap_major, int, S_IRUGO);
+module_param(xhwicap_minor, int, S_IRUGO);
+
+/* An array, which is set to true when the device is registered. */
+static bool probed_devices[HWICAP_DEVICES];
+static struct mutex icap_sem;
+
+static struct class *icap_class;
+
+#define UNIMPLEMENTED 0xFFFF
+
+static const struct config_registers v2_config_registers = {
+	.CRC = 0,
+	.FAR = 1,
+	.FDRI = 2,
+	.FDRO = 3,
+	.CMD = 4,
+	.CTL = 5,
+	.MASK = 6,
+	.STAT = 7,
+	.LOUT = 8,
+	.COR = 9,
+	.MFWR = 10,
+	.FLR = 11,
+	.KEY = 12,
+	.CBC = 13,
+	.IDCODE = 14,
+	.AXSS = UNIMPLEMENTED,
+	.C0R_1 = UNIMPLEMENTED,
+	.CSOB = UNIMPLEMENTED,
+	.WBSTAR = UNIMPLEMENTED,
+	.TIMER = UNIMPLEMENTED,
+	.BOOTSTS = UNIMPLEMENTED,
+	.CTL_1 = UNIMPLEMENTED,
+};
+
+static const struct config_registers v4_config_registers = {
+	.CRC = 0,
+	.FAR = 1,
+	.FDRI = 2,
+	.FDRO = 3,
+	.CMD = 4,
+	.CTL = 5,
+	.MASK = 6,
+	.STAT = 7,
+	.LOUT = 8,
+	.COR = 9,
+	.MFWR = 10,
+	.FLR = UNIMPLEMENTED,
+	.KEY = UNIMPLEMENTED,
+	.CBC = 11,
+	.IDCODE = 12,
+	.AXSS = 13,
+	.C0R_1 = UNIMPLEMENTED,
+	.CSOB = UNIMPLEMENTED,
+	.WBSTAR = UNIMPLEMENTED,
+	.TIMER = UNIMPLEMENTED,
+	.BOOTSTS = UNIMPLEMENTED,
+	.CTL_1 = UNIMPLEMENTED,
+};
+static const struct config_registers v5_config_registers = {
+	.CRC = 0,
+	.FAR = 1,
+	.FDRI = 2,
+	.FDRO = 3,
+	.CMD = 4,
+	.CTL = 5,
+	.MASK = 6,
+	.STAT = 7,
+	.LOUT = 8,
+	.COR = 9,
+	.MFWR = 10,
+	.FLR = UNIMPLEMENTED,
+	.KEY = UNIMPLEMENTED,
+	.CBC = 11,
+	.IDCODE = 12,
+	.AXSS = 13,
+	.C0R_1 = 14,
+	.CSOB = 15,
+	.WBSTAR = 16,
+	.TIMER = 17,
+	.BOOTSTS = 18,
+	.CTL_1 = 19,
+};
+
+/**
+ * hwicap_command_desync: Send a DESYNC command to the ICAP port.
+ * @parameter drvdata: a pointer to the drvdata.
+ *
+ * This command desynchronizes the ICAP After this command, a
+ * bitstream containing a NULL packet, followed by a SYNCH packet is
+ * required before the ICAP will recognize commands.
+ */
+static int hwicap_command_desync(struct hwicap_drvdata *drvdata)
+{
+	u32 buffer[4];
+	u32 index = 0;
+
+	/*
+	 * Create the data to be written to the ICAP.
+	 */
+	buffer[index++] = hwicap_type_1_write(drvdata->config_regs->CMD) | 1;
+	buffer[index++] = XHI_CMD_DESYNCH;
+	buffer[index++] = XHI_NOOP_PACKET;
+	buffer[index++] = XHI_NOOP_PACKET;
+
+	/*
+	 * Write the data to the FIFO and intiate the transfer of data present
+	 * in the FIFO to the ICAP device.
+	 */
+	return drvdata->config->set_configuration(drvdata,
+			&buffer[0], index);
+}
+
+/**
+ * hwicap_command_capture: Send a CAPTURE command to the ICAP port.
+ * @parameter drvdata: a pointer to the drvdata.
+ *
+ * This command captures all of the flip flop states so they will be
+ * available during readback.  One can use this command instead of
+ * enabling the CAPTURE block in the design.
+ */
+static int hwicap_command_capture(struct hwicap_drvdata *drvdata)
+{
+	u32 buffer[7];
+	u32 index = 0;
+
+	/*
+	 * Create the data to be written to the ICAP.
+	 */
+	buffer[index++] = XHI_DUMMY_PACKET;
+	buffer[index++] = XHI_SYNC_PACKET;
+	buffer[index++] = XHI_NOOP_PACKET;
+	buffer[index++] = hwicap_type_1_write(drvdata->config_regs->CMD) | 1;
+	buffer[index++] = XHI_CMD_GCAPTURE;
+	buffer[index++] = XHI_DUMMY_PACKET;
+	buffer[index++] = XHI_DUMMY_PACKET;
+
+	/*
+	 * Write the data to the FIFO and initiate the transfer of data
+	 * present in the FIFO to the ICAP device.
+	 */
+	return drvdata->config->set_configuration(drvdata,
+			&buffer[0], index);
+
+}
+
+/**
+ * hwicap_get_configuration_register: Query a configuration register.
+ * @parameter drvdata: a pointer to the drvdata.
+ * @parameter reg: a constant which represents the configuration
+ *		register value to be returned.
+ * 		Examples:  XHI_IDCODE, XHI_FLR.
+ * @parameter RegData: returns the value of the register.
+ *
+ * Sends a query packet to the ICAP and then receives the response.
+ * The icap is left in Synched state.
+ */
+static int hwicap_get_configuration_register(struct hwicap_drvdata *drvdata,
+		u32 reg, u32 *RegData)
+{
+	int status;
+	u32 buffer[6];
+	u32 index = 0;
+
+	/*
+	 * Create the data to be written to the ICAP.
+	 */
+	buffer[index++] = XHI_DUMMY_PACKET;
+	buffer[index++] = XHI_SYNC_PACKET;
+	buffer[index++] = XHI_NOOP_PACKET;
+	buffer[index++] = hwicap_type_1_read(reg) | 1;
+	buffer[index++] = XHI_NOOP_PACKET;
+	buffer[index++] = XHI_NOOP_PACKET;
+
+	/*
+	 * Write the data to the FIFO and intiate the transfer of data present
+	 * in the FIFO to the ICAP device.
+	 */
+	status = drvdata->config->set_configuration(drvdata,
+			&buffer[0], index);
+	if (status)
+		return status;
+
+	/*
+	 * Read the configuration register
+	 */
+	status = drvdata->config->get_configuration(drvdata, RegData, 1);
+	if (status)
+		return status;
+
+	return 0;
+}
+
+static int hwicap_initialize_hwicap(struct hwicap_drvdata *drvdata)
+{
+	int status;
+	u32 idcode;
+
+	dev_dbg(drvdata->dev, "initializing\n");
+
+	/* Abort any current transaction, to make sure we have the
+	 * ICAP in a good state. */
+	dev_dbg(drvdata->dev, "Reset...\n");
+	drvdata->config->reset(drvdata);
+
+	dev_dbg(drvdata->dev, "Desync...\n");
+	status = hwicap_command_desync(drvdata);
+	if (status)
+		return status;
+
+	/* Attempt to read the IDCODE from ICAP.  This
+	 * may not be returned correctly, due to the design of the
+	 * hardware.
+	 */
+	dev_dbg(drvdata->dev, "Reading IDCODE...\n");
+	status = hwicap_get_configuration_register(
+			drvdata, drvdata->config_regs->IDCODE, &idcode);
+	dev_dbg(drvdata->dev, "IDCODE = %x\n", idcode);
+	if (status)
+		return status;
+
+	dev_dbg(drvdata->dev, "Desync...\n");
+	status = hwicap_command_desync(drvdata);
+	if (status)
+		return status;
+
+	return 0;
+}
+
+static ssize_t
+hwicap_read(struct file *file, __user char *buf, size_t count, loff_t *ppos)
+{
+	struct hwicap_drvdata *drvdata = file->private_data;
+	ssize_t bytes_to_read = 0;
+	u32 *kbuf;
+	u32 words;
+	u32 bytes_remaining;
+	int status;
+
+	status = mutex_lock_interruptible(&drvdata->sem);
+	if (status)
+		return status;
+
+	if (drvdata->read_buffer_in_use) {
+		/* If there are leftover bytes in the buffer, just */
+		/* return them and don't try to read more from the */
+		/* ICAP device. */
+		bytes_to_read =
+			(count < drvdata->read_buffer_in_use) ? count :
+			drvdata->read_buffer_in_use;
+
+		/* Return the data currently in the read buffer. */
+		if (copy_to_user(buf, drvdata->read_buffer, bytes_to_read)) {
+			status = -EFAULT;
+			goto error;
+		}
+		drvdata->read_buffer_in_use -= bytes_to_read;
+		memmove(drvdata->read_buffer,
+		       drvdata->read_buffer + bytes_to_read,
+		       4 - bytes_to_read);
+	} else {
+		/* Get new data from the ICAP, and return was was requested. */
+		kbuf = (u32 *) get_zeroed_page(GFP_KERNEL);
+		if (!kbuf) {
+			status = -ENOMEM;
+			goto error;
+		}
+
+		/* The ICAP device is only able to read complete */
+		/* words.  If a number of bytes that do not correspond */
+		/* to complete words is requested, then we read enough */
+		/* words to get the required number of bytes, and then */
+		/* save the remaining bytes for the next read. */
+
+		/* Determine the number of words to read, rounding up */
+		/* if necessary. */
+		words = ((count + 3) >> 2);
+		bytes_to_read = words << 2;
+
+		if (bytes_to_read > PAGE_SIZE)
+			bytes_to_read = PAGE_SIZE;
+
+		/* Ensure we only read a complete number of words. */
+		bytes_remaining = bytes_to_read & 3;
+		bytes_to_read &= ~3;
+		words = bytes_to_read >> 2;
+
+		status = drvdata->config->get_configuration(drvdata,
+				kbuf, words);
+
+		/* If we didn't read correctly, then bail out. */
+		if (status) {
+			free_page((unsigned long)kbuf);
+			goto error;
+		}
+
+		/* If we fail to return the data to the user, then bail out. */
+		if (copy_to_user(buf, kbuf, bytes_to_read)) {
+			free_page((unsigned long)kbuf);
+			status = -EFAULT;
+			goto error;
+		}
+		memcpy(drvdata->read_buffer,
+		       kbuf,
+		       bytes_remaining);
+		drvdata->read_buffer_in_use = bytes_remaining;
+		free_page((unsigned long)kbuf);
+	}
+	status = bytes_to_read;
+ error:
+	mutex_unlock(&drvdata->sem);
+	return status;
+}
+
+static ssize_t
+hwicap_write(struct file *file, const __user char *buf,
+		size_t count, loff_t *ppos)
+{
+	struct hwicap_drvdata *drvdata = file->private_data;
+	ssize_t written = 0;
+	ssize_t left = count;
+	u32 *kbuf;
+	ssize_t len;
+	ssize_t status;
+
+	status = mutex_lock_interruptible(&drvdata->sem);
+	if (status)
+		return status;
+
+	left += drvdata->write_buffer_in_use;
+
+	/* Only write multiples of 4 bytes. */
+	if (left < 4) {
+		status = 0;
+		goto error;
+	}
+
+	kbuf = (u32 *) __get_free_page(GFP_KERNEL);
+	if (!kbuf) {
+		status = -ENOMEM;
+		goto error;
+	}
+
+	while (left > 3) {
+		/* only write multiples of 4 bytes, so there might */
+		/* be as many as 3 bytes left (at the end). */
+		len = left;
+
+		if (len > PAGE_SIZE)
+			len = PAGE_SIZE;
+		len &= ~3;
+
+		if (drvdata->write_buffer_in_use) {
+			memcpy(kbuf, drvdata->write_buffer,
+					drvdata->write_buffer_in_use);
+			if (copy_from_user(
+			    (((char *)kbuf) + drvdata->write_buffer_in_use),
+			    buf + written,
+			    len - (drvdata->write_buffer_in_use))) {
+				free_page((unsigned long)kbuf);
+				status = -EFAULT;
+				goto error;
+			}
+		} else {
+			if (copy_from_user(kbuf, buf + written, len)) {
+				free_page((unsigned long)kbuf);
+				status = -EFAULT;
+				goto error;
+			}
+		}
+
+		status = drvdata->config->set_configuration(drvdata,
+				kbuf, len >> 2);
+
+		if (status) {
+			free_page((unsigned long)kbuf);
+			status = -EFAULT;
+			goto error;
+		}
+		if (drvdata->write_buffer_in_use) {
+			len -= drvdata->write_buffer_in_use;
+			left -= drvdata->write_buffer_in_use;
+			drvdata->write_buffer_in_use = 0;
+		}
+		written += len;
+		left -= len;
+	}
+	if ((left > 0) && (left < 4)) {
+		if (!copy_from_user(drvdata->write_buffer,
+						buf + written, left)) {
+			drvdata->write_buffer_in_use = left;
+			written += left;
+			left = 0;
+		}
+	}
+
+	free_page((unsigned long)kbuf);
+	status = written;
+ error:
+	mutex_unlock(&drvdata->sem);
+	return status;
+}
+
+static int hwicap_open(struct inode *inode, struct file *file)
+{
+	struct hwicap_drvdata *drvdata;
+	int status;
+
+	drvdata = container_of(inode->i_cdev, struct hwicap_drvdata, cdev);
+
+	status = mutex_lock_interruptible(&drvdata->sem);
+	if (status)
+		return status;
+
+	if (drvdata->is_open) {
+		status = -EBUSY;
+		goto error;
+	}
+
+	status = hwicap_initialize_hwicap(drvdata);
+	if (status) {
+		dev_err(drvdata->dev, "Failed to open file");
+		goto error;
+	}
+
+	file->private_data = drvdata;
+	drvdata->write_buffer_in_use = 0;
+	drvdata->read_buffer_in_use = 0;
+	drvdata->is_open = 1;
+
+ error:
+	mutex_unlock(&drvdata->sem);
+	return status;
+}
+
+static int hwicap_release(struct inode *inode, struct file *file)
+{
+	struct hwicap_drvdata *drvdata = file->private_data;
+	int i;
+	int status = 0;
+
+	mutex_lock(&drvdata->sem);
+
+	if (drvdata->write_buffer_in_use) {
+		/* Flush write buffer. */
+		for (i = drvdata->write_buffer_in_use; i < 4; i++)
+			drvdata->write_buffer[i] = 0;
+
+		status = drvdata->config->set_configuration(drvdata,
+				(u32 *) drvdata->write_buffer, 1);
+		if (status)
+			goto error;
+	}
+
+	status = hwicap_command_desync(drvdata);
+	if (status)
+		goto error;
+
+ error:
+	drvdata->is_open = 0;
+	mutex_unlock(&drvdata->sem);
+	return status;
+}
+
+static struct file_operations hwicap_fops = {
+	.owner = THIS_MODULE,
+	.write = hwicap_write,
+	.read = hwicap_read,
+	.open = hwicap_open,
+	.release = hwicap_release,
+};
+
+static int __devinit hwicap_setup(struct device *dev, int id,
+		const struct resource *regs_res,
+		const struct hwicap_driver_config *config,
+		const struct config_registers *config_regs)
+{
+	dev_t devt;
+	struct hwicap_drvdata *drvdata = NULL;
+	int retval = 0;
+
+	dev_info(dev, "Xilinx icap port driver\n");
+
+	mutex_lock(&icap_sem);
+
+	if (id < 0) {
+		for (id = 0; id < HWICAP_DEVICES; id++)
+			if (!probed_devices[id])
+				break;
+	}
+	if (id < 0 || id >= HWICAP_DEVICES) {
+		mutex_unlock(&icap_sem);
+		dev_err(dev, "%s%i too large\n", DRIVER_NAME, id);
+		return -EINVAL;
+	}
+	if (probed_devices[id]) {
+		mutex_unlock(&icap_sem);
+		dev_err(dev, "cannot assign to %s%i; it is already in use\n",
+			DRIVER_NAME, id);
+		return -EBUSY;
+	}
+
+	probed_devices[id] = 1;
+	mutex_unlock(&icap_sem);
+
+	devt = MKDEV(xhwicap_major, xhwicap_minor + id);
+
+	drvdata = kzalloc(sizeof(struct hwicap_drvdata), GFP_KERNEL);
+	if (!drvdata) {
+		dev_err(dev, "Couldn't allocate device private record\n");
+		retval = -ENOMEM;
+		goto failed0;
+	}
+	dev_set_drvdata(dev, (void *)drvdata);
+
+	if (!regs_res) {
+		dev_err(dev, "Couldn't get registers resource\n");
+		retval = -EFAULT;
+		goto failed1;
+	}
+
+	drvdata->mem_start = regs_res->start;
+	drvdata->mem_end = regs_res->end;
+	drvdata->mem_size = regs_res->end - regs_res->start + 1;
+
+	if (!request_mem_region(drvdata->mem_start,
+					drvdata->mem_size, DRIVER_NAME)) {
+		dev_err(dev, "Couldn't lock memory region at %p\n",
+			(void *)regs_res->start);
+		retval = -EBUSY;
+		goto failed1;
+	}
+
+	drvdata->devt = devt;
+	drvdata->dev = dev;
+	drvdata->base_address = ioremap(drvdata->mem_start, drvdata->mem_size);
+	if (!drvdata->base_address) {
+		dev_err(dev, "ioremap() failed\n");
+		goto failed2;
+	}
+
+	drvdata->config = config;
+	drvdata->config_regs = config_regs;
+
+	mutex_init(&drvdata->sem);
+	drvdata->is_open = 0;
+
+	dev_info(dev, "ioremap %lx to %p with size %x\n",
+		 (unsigned long int)drvdata->mem_start,
+			drvdata->base_address, drvdata->mem_size);
+
+	cdev_init(&drvdata->cdev, &hwicap_fops);
+	drvdata->cdev.owner = THIS_MODULE;
+	retval = cdev_add(&drvdata->cdev, devt, 1);
+	if (retval) {
+		dev_err(dev, "cdev_add() failed\n");
+		goto failed3;
+	}
+	/*  devfs_mk_cdev(devt, S_IFCHR|S_IRUGO|S_IWUGO, DRIVER_NAME); */
+	device_create(icap_class, dev, devt, "%s%d", DRIVER_NAME, id);
+	return 0;		/* success */
+
+ failed3:
+	iounmap(drvdata->base_address);
+
+ failed2:
+	release_mem_region(regs_res->start, drvdata->mem_size);
+
+ failed1:
+	kfree(drvdata);
+
+ failed0:
+	mutex_lock(&icap_sem);
+	probed_devices[id] = 0;
+	mutex_unlock(&icap_sem);
+
+	return retval;
+}
+
+static struct hwicap_driver_config buffer_icap_config = {
+	.get_configuration = buffer_icap_get_configuration,
+	.set_configuration = buffer_icap_set_configuration,
+	.reset = buffer_icap_reset,
+};
+
+static struct hwicap_driver_config fifo_icap_config = {
+	.get_configuration = fifo_icap_get_configuration,
+	.set_configuration = fifo_icap_set_configuration,
+	.reset = fifo_icap_reset,
+};
+
+static int __devexit hwicap_remove(struct device *dev)
+{
+	struct hwicap_drvdata *drvdata;
+
+	drvdata = (struct hwicap_drvdata *)dev_get_drvdata(dev);
+
+	if (!drvdata)
+		return 0;
+
+	device_destroy(icap_class, drvdata->devt);
+	cdev_del(&drvdata->cdev);
+	iounmap(drvdata->base_address);
+	release_mem_region(drvdata->mem_start, drvdata->mem_size);
+	kfree(drvdata);
+	dev_set_drvdata(dev, NULL);
+
+	mutex_lock(&icap_sem);
+	probed_devices[MINOR(dev->devt)-xhwicap_minor] = 0;
+	mutex_unlock(&icap_sem);
+	return 0;		/* success */
+}
+
+static int __devinit hwicap_drv_probe(struct platform_device *pdev)
+{
+	struct resource *res;
+	const struct config_registers *regs;
+	const char *family;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -ENODEV;
+
+	/* It's most likely that we're using V4, if the family is not
+	   specified */
+	regs = &v4_config_registers;
+	family = pdev->dev.platform_data;
+
+	if (family) {
+		if (!strcmp(family, "virtex2p")) {
+			regs = &v2_config_registers;
+		} else if (!strcmp(family, "virtex4")) {
+			regs = &v4_config_registers;
+		} else if (!strcmp(family, "virtex5")) {
+			regs = &v5_config_registers;
+		}
+	}
+
+	return hwicap_setup(&pdev->dev, pdev->id, res,
+			&buffer_icap_config, regs);
+}
+
+static int __devexit hwicap_drv_remove(struct platform_device *pdev)
+{
+	return hwicap_remove(&pdev->dev);
+}
+
+static struct platform_driver hwicap_platform_driver = {
+	.probe = hwicap_drv_probe,
+	.remove = hwicap_drv_remove,
+	.driver = {
+		.owner = THIS_MODULE,
+		.name = DRIVER_NAME,
+	},
+};
+
+/* ---------------------------------------------------------------------
+ * OF bus binding
+ */
+
+#if defined(CONFIG_OF)
+static int __devinit
+hwicap_of_probe(struct of_device *op, const struct of_device_id *match)
+{
+	struct resource res;
+	const unsigned int *id;
+	const char *family;
+	int rc;
+	const struct hwicap_driver_config *config = match->data;
+	const struct config_registers *regs;
+
+	dev_dbg(&op->dev, "hwicap_of_probe(%p, %p)\n", op, match);
+
+	rc = of_address_to_resource(op->node, 0, &res);
+	if (rc) {
+		dev_err(&op->dev, "invalid address\n");
+		return rc;
+	}
+
+	id = of_get_property(op->node, "port-number", NULL);
+
+	/* It's most likely that we're using V4, if the family is not
+	   specified */
+	regs = &v4_config_registers;
+	family = of_get_property(op->node, "xlnx,family", NULL);
+
+	if (family) {
+		if (!strcmp(family, "virtex2p")) {
+			regs = &v2_config_registers;
+		} else if (!strcmp(family, "virtex4")) {
+			regs = &v4_config_registers;
+		} else if (!strcmp(family, "virtex5")) {
+			regs = &v5_config_registers;
+		}
+	}
+	return hwicap_setup(&op->dev, id ? *id : -1, &res, config,
+			regs);
+}
+
+static int __devexit hwicap_of_remove(struct of_device *op)
+{
+	return hwicap_remove(&op->dev);
+}
+
+/* Match table for of_platform binding */
+static const struct of_device_id __devinit hwicap_of_match[] = {
+	{ .compatible = "xlnx,opb-hwicap-1.00.b", .data = &buffer_icap_config},
+	{ .compatible = "xlnx,xps-hwicap-1.00.a", .data = &fifo_icap_config},
+	{},
+};
+MODULE_DEVICE_TABLE(of, hwicap_of_match);
+
+static struct of_platform_driver hwicap_of_driver = {
+	.owner = THIS_MODULE,
+	.name = DRIVER_NAME,
+	.match_table = hwicap_of_match,
+	.probe = hwicap_of_probe,
+	.remove = __devexit_p(hwicap_of_remove),
+	.driver = {
+		.name = DRIVER_NAME,
+	},
+};
+
+/* Registration helpers to keep the number of #ifdefs to a minimum */
+static inline int __init hwicap_of_register(void)
+{
+	pr_debug("hwicap: calling of_register_platform_driver()\n");
+	return of_register_platform_driver(&hwicap_of_driver);
+}
+
+static inline void __exit hwicap_of_unregister(void)
+{
+	of_unregister_platform_driver(&hwicap_of_driver);
+}
+#else /* CONFIG_OF */
+/* CONFIG_OF not enabled; do nothing helpers */
+static inline int __init hwicap_of_register(void) { return 0; }
+static inline void __exit hwicap_of_unregister(void) { }
+#endif /* CONFIG_OF */
+
+static int __init hwicap_module_init(void)
+{
+	dev_t devt;
+	int retval;
+
+	icap_class = class_create(THIS_MODULE, "xilinx_config");
+	mutex_init(&icap_sem);
+
+	if (xhwicap_major) {
+		devt = MKDEV(xhwicap_major, xhwicap_minor);
+		retval = register_chrdev_region(
+				devt,
+				HWICAP_DEVICES,
+				DRIVER_NAME);
+		if (retval < 0)
+			return retval;
+	} else {
+		retval = alloc_chrdev_region(&devt,
+				xhwicap_minor,
+				HWICAP_DEVICES,
+				DRIVER_NAME);
+		if (retval < 0)
+			return retval;
+		xhwicap_major = MAJOR(devt);
+	}
+
+	retval = platform_driver_register(&hwicap_platform_driver);
+
+	if (retval)
+		goto failed1;
+
+	retval = hwicap_of_register();
+
+	if (retval)
+		goto failed2;
+
+	return retval;
+
+ failed2:
+	platform_driver_unregister(&hwicap_platform_driver);
+
+ failed1:
+	unregister_chrdev_region(devt, HWICAP_DEVICES);
+
+	return retval;
+}
+
+static void __exit hwicap_module_cleanup(void)
+{
+	dev_t devt = MKDEV(xhwicap_major, xhwicap_minor);
+
+	class_destroy(icap_class);
+
+	platform_driver_unregister(&hwicap_platform_driver);
+
+	hwicap_of_unregister();
+
+	unregister_chrdev_region(devt, HWICAP_DEVICES);
+}
+
+module_init(hwicap_module_init);
+module_exit(hwicap_module_cleanup);
+
+MODULE_AUTHOR("Xilinx, Inc; Xilinx Research Labs Group");
+MODULE_DESCRIPTION("Xilinx ICAP Port Driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/char/xilinx_hwicap/xilinx_hwicap.h b/drivers/char/xilinx_hwicap/xilinx_hwicap.h
new file mode 100644
index 0000000..5718679
--- /dev/null
+++ b/drivers/char/xilinx_hwicap/xilinx_hwicap.h
@@ -0,0 +1,193 @@
+/*****************************************************************************
+ *
+ *     Author: Xilinx, Inc.
+ *
+ *     This program is free software; you can redistribute it and/or modify it
+ *     under the terms of the GNU General Public License as published by the
+ *     Free Software Foundation; either version 2 of the License, or (at your
+ *     option) any later version.
+ *
+ *     XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"
+ *     AS A COURTESY TO YOU, SOLELY FOR USE IN DEVELOPING PROGRAMS AND
+ *     SOLUTIONS FOR XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE,
+ *     OR INFORMATION AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,
+ *     APPLICATION OR STANDARD, XILINX IS MAKING NO REPRESENTATION
+ *     THAT THIS IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,
+ *     AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE
+ *     FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY
+ *     WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE
+ *     IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR
+ *     REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF
+ *     INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
+ *     FOR A PARTICULAR PURPOSE.
+ *
+ *     Xilinx products are not intended for use in life support appliances,
+ *     devices, or systems. Use in such applications is expressly prohibited.
+ *
+ *     (c) Copyright 2003-2007 Xilinx Inc.
+ *     All rights reserved.
+ *
+ *     You should have received a copy of the GNU General Public License along
+ *     with this program; if not, write to the Free Software Foundation, Inc.,
+ *     675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ *****************************************************************************/
+
+#ifndef XILINX_HWICAP_H_	/* prevent circular inclusions */
+#define XILINX_HWICAP_H_	/* by using protection macros */
+
+#include <linux/types.h>
+#include <linux/cdev.h>
+#include <linux/version.h>
+#include <linux/platform_device.h>
+
+#include <asm/io.h>
+
+struct hwicap_drvdata {
+	u32 write_buffer_in_use;  /* Always in [0,3] */
+	u8 write_buffer[4];
+	u32 read_buffer_in_use;	  /* Always in [0,3] */
+	u8 read_buffer[4];
+	resource_size_t mem_start;/* phys. address of the control registers */
+	resource_size_t mem_end;  /* phys. address of the control registers */
+	resource_size_t mem_size;
+	void __iomem *base_address;/* virt. address of the control registers */
+
+	struct device *dev;
+	struct cdev cdev;	/* Char device structure */
+	dev_t devt;
+
+	const struct hwicap_driver_config *config;
+	const struct config_registers *config_regs;
+	void *private_data;
+	bool is_open;
+	struct mutex sem;
+};
+
+struct hwicap_driver_config {
+	int (*get_configuration)(struct hwicap_drvdata *drvdata, u32 *data,
+			u32 size);
+	int (*set_configuration)(struct hwicap_drvdata *drvdata, u32 *data,
+			u32 size);
+	void (*reset)(struct hwicap_drvdata *drvdata);
+};
+
+/* Number of times to poll the done regsiter */
+#define XHI_MAX_RETRIES     10
+
+/************ Constant Definitions *************/
+
+#define XHI_PAD_FRAMES              0x1
+
+/* Mask for calculating configuration packet headers */
+#define XHI_WORD_COUNT_MASK_TYPE_1  0x7FFUL
+#define XHI_WORD_COUNT_MASK_TYPE_2  0x1FFFFFUL
+#define XHI_TYPE_MASK               0x7
+#define XHI_REGISTER_MASK           0xF
+#define XHI_OP_MASK                 0x3
+
+#define XHI_TYPE_SHIFT              29
+#define XHI_REGISTER_SHIFT          13
+#define XHI_OP_SHIFT                27
+
+#define XHI_TYPE_1                  1
+#define XHI_TYPE_2                  2
+#define XHI_OP_WRITE                2
+#define XHI_OP_READ                 1
+
+/* Address Block Types */
+#define XHI_FAR_CLB_BLOCK           0
+#define XHI_FAR_BRAM_BLOCK          1
+#define XHI_FAR_BRAM_INT_BLOCK      2
+
+struct config_registers {
+	u32 CRC;
+	u32 FAR;
+	u32 FDRI;
+	u32 FDRO;
+	u32 CMD;
+	u32 CTL;
+	u32 MASK;
+	u32 STAT;
+	u32 LOUT;
+	u32 COR;
+	u32 MFWR;
+	u32 FLR;
+	u32 KEY;
+	u32 CBC;
+	u32 IDCODE;
+	u32 AXSS;
+	u32 C0R_1;
+	u32 CSOB;
+	u32 WBSTAR;
+	u32 TIMER;
+	u32 BOOTSTS;
+	u32 CTL_1;
+};
+
+/* Configuration Commands */
+#define XHI_CMD_NULL                0
+#define XHI_CMD_WCFG                1
+#define XHI_CMD_MFW                 2
+#define XHI_CMD_DGHIGH              3
+#define XHI_CMD_RCFG                4
+#define XHI_CMD_START               5
+#define XHI_CMD_RCAP                6
+#define XHI_CMD_RCRC                7
+#define XHI_CMD_AGHIGH              8
+#define XHI_CMD_SWITCH              9
+#define XHI_CMD_GRESTORE            10
+#define XHI_CMD_SHUTDOWN            11
+#define XHI_CMD_GCAPTURE            12
+#define XHI_CMD_DESYNCH             13
+#define XHI_CMD_IPROG               15 /* Only in Virtex5 */
+#define XHI_CMD_CRCC                16 /* Only in Virtex5 */
+#define XHI_CMD_LTIMER              17 /* Only in Virtex5 */
+
+/* Packet constants */
+#define XHI_SYNC_PACKET             0xAA995566UL
+#define XHI_DUMMY_PACKET            0xFFFFFFFFUL
+#define XHI_NOOP_PACKET             (XHI_TYPE_1 << XHI_TYPE_SHIFT)
+#define XHI_TYPE_2_READ ((XHI_TYPE_2 << XHI_TYPE_SHIFT) | \
+			(XHI_OP_READ << XHI_OP_SHIFT))
+
+#define XHI_TYPE_2_WRITE ((XHI_TYPE_2 << XHI_TYPE_SHIFT) | \
+			(XHI_OP_WRITE << XHI_OP_SHIFT))
+
+#define XHI_TYPE2_CNT_MASK          0x07FFFFFF
+
+#define XHI_TYPE_1_PACKET_MAX_WORDS 2047UL
+#define XHI_TYPE_1_HEADER_BYTES     4
+#define XHI_TYPE_2_HEADER_BYTES     8
+
+/* Constant to use for CRC check when CRC has been disabled */
+#define XHI_DISABLED_AUTO_CRC       0x0000DEFCUL
+
+/**
+ * hwicap_type_1_read: Generates a Type 1 read packet header.
+ * @parameter: Register is the address of the register to be read back.
+ *
+ * Generates a Type 1 read packet header, which is used to indirectly
+ * read registers in the configuration logic.  This packet must then
+ * be sent through the icap device, and a return packet received with
+ * the information.
+ **/
+static inline u32 hwicap_type_1_read(u32 Register)
+{
+	return (XHI_TYPE_1 << XHI_TYPE_SHIFT) |
+		(Register << XHI_REGISTER_SHIFT) |
+		(XHI_OP_READ << XHI_OP_SHIFT);
+}
+
+/**
+ * hwicap_type_1_write: Generates a Type 1 write packet header
+ * @parameter: Register is the address of the register to be read back.
+ **/
+static inline u32 hwicap_type_1_write(u32 Register)
+{
+	return (XHI_TYPE_1 << XHI_TYPE_SHIFT) |
+		(Register << XHI_REGISTER_SHIFT) |
+		(XHI_OP_WRITE << XHI_OP_SHIFT);
+}
+
+#endif
-- 
1.5.3.4-dirty



