Return-Path: <linux-kernel-owner+w=401wt.eu-S1754905AbXEBHIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905AbXEBHIt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 03:08:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754907AbXEBHIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 03:08:49 -0400
Received: from S01060016b61d1226.cg.shawcable.net ([68.147.67.118]:50407 "EHLO
	sandbox.secretlab.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754898AbXEBHIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 03:08:45 -0400
X-Greylist: delayed 1501 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 May 2007 03:08:44 EDT
From: Grant Likely <grant.likely@secretlab.ca>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH] Add support for Xilinx SystemACE CompactFlash interface.
Date: Wed,  2 May 2007 00:43:16 -0600
Message-Id: <11780881962680-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.5.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tested on Xilinx Virtex ppc405, Katmai 440SPe, and Microblaze

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Acked-by: Stefan Roese <sr@denx.de>
Acked-by: John Williams <jwilliams@itee.uq.edu.au>
---
 drivers/block/Kconfig   |    6 +
 drivers/block/Makefile  |    1 +
 drivers/block/xsysace.c | 1191 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 1198 insertions(+), 0 deletions(-)
 create mode 100644 drivers/block/xsysace.c

diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index 17ee97f..2dc3f60 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -453,6 +453,12 @@ config ATA_OVER_ETH
 	This driver provides Support for ATA over Ethernet block
 	devices like the Coraid EtherDrive (R) Storage Blade.
 
+config XILINX_SYSACE
+	tristate "Xilinx SystemACE support"
+	depends on 4xx
+	help
+	  Include support for the Xilinx SystemACE CompactFlash interface
+
 endmenu
 
 endif
diff --git a/drivers/block/Makefile b/drivers/block/Makefile
index dd88e33..31ea323 100644
--- a/drivers/block/Makefile
+++ b/drivers/block/Makefile
@@ -28,4 +28,5 @@ obj-$(CONFIG_BLK_DEV_CRYPTOLOOP) += cryptoloop.o
 obj-$(CONFIG_VIODASD)		+= viodasd.o
 obj-$(CONFIG_BLK_DEV_SX8)	+= sx8.o
 obj-$(CONFIG_BLK_DEV_UB)	+= ub.o
+obj-$(CONFIG_XILINX_SYSACE)	+= xsysace.o
 
diff --git a/drivers/block/xsysace.c b/drivers/block/xsysace.c
new file mode 100644
index 0000000..1777529
--- /dev/null
+++ b/drivers/block/xsysace.c
@@ -0,0 +1,1191 @@
+/*
+ * Xilinx SystemACE device driver
+ *
+ * Copyright 2007 Secret Lab Technologies Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ */
+
+/*
+ * The SystemACE chip is designed to configure FPGAs by loading an FPGA
+ * bitstream from a file on a CF card and squirting it into FPGAs connected
+ * to the SystemACE JTAG chain.  It also has the advantage of providing an
+ * MPU interface which can be used to control the FPGA configuration process
+ * and to use the attached CF card for general purpose storage.
+ *
+ * This driver is a block device driver for the SystemACE.
+ *
+ * Initialization:
+ *    The driver registers itself as a platform_device driver at module
+ *    load time.  The platform bus will take care of calling the
+ *    ace_probe() method for all SystemACE instances in the system.  Any
+ *    number of SystemACE instances are supported.  ace_probe() calls
+ *    ace_setup() which initialized all data structures, reads the CF
+ *    id structure and registers the device.
+ *
+ * Processing:
+ *    Just about all of the heavy lifting in this driver is performed by
+ *    a Finite State Machine (FSM).  The driver needs to wait on a number
+ *    of events; some raised by interrupts, some which need to be polled
+ *    for.  Describing all of the behaviour in a FSM seems to be the
+ *    easiest way to keep the complexity low and make it easy to
+ *    understand what the driver is doing.  If the block ops or the
+ *    request function need to interact with the hardware, then they
+ *    simply need to flag the request and kick of FSM processing.
+ *
+ *    The FSM itself is atomic-safe code which can be run from any
+ *    context.  The general process flow is:
+ *    1. obtain the ace->lock spinlock.
+ *    2. loop on ace_fsm_dostate() until the ace->fsm_continue flag is
+ *       cleared.
+ *    3. release the lock.
+ *
+ *    Individual states do not sleep in any way.  If a condition needs to
+ *    be waited for then the state much clear the fsm_continue flag and
+ *    either schedule the FSM to be run again at a later time, or expect
+ *    an interrupt to call the FSM when the desired condition is met.
+ *
+ *    In normal operation, the FSM is processed at interrupt context
+ *    either when the driver's tasklet is scheduled, or when an irq is
+ *    raised by the hardware.  The tasklet can be scheduled at any time.
+ *    The request method in particular schedules the tasklet when a new
+ *    request has been indicated by the block layer.  Once started, the
+ *    FSM proceeds as far as it can processing the request until it
+ *    needs on a hardware event.  At this point, it must yield execution.
+ *
+ *    A state has two options when yielding execution:
+ *    1. ace_fsm_yield()
+ *       - Call if need to poll for event.
+ *       - clears the fsm_continue flag to exit the processing loop
+ *       - reschedules the tasklet to run again as soon as possible
+ *    2. ace_fsm_yieldirq()
+ *       - Call if an irq is expected from the HW
+ *       - clears the fsm_continue flag to exit the processing loop
+ *       - does not reschedule the tasklet so the FSM will not be processed
+ *         again until an irq is received.
+ *    After calling a yield function, the state must return control back
+ *    to the FSM main loop.
+ *
+ *    Additionally, the driver maintains a kernel timer which can process
+ *    the FSM.  If the FSM gets stalled, typically due to a missed
+ *    interrupt, then the kernel timer will expire and the driver can
+ *    continue where it left off.
+ *
+ * To Do:
+ *    - Add FPGA configuration control interface.
+ *    - Request major number from lanana
+ *    - Add legacy device geometry ioctl
+ */
+
+#undef DEBUG
+
+#include <linux/module.h>
+#include <linux/ctype.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/delay.h>
+#include <linux/slab.h>
+#include <linux/blkdev.h>
+#include <linux/hdreg.h>
+#include <linux/platform_device.h>
+
+MODULE_AUTHOR("Grant Likely <grant.likely@secretlab.ca>");
+MODULE_DESCRIPTION("Xilinx SystemACE device driver");
+MODULE_LICENSE("GPL");
+
+/* SystemACE register definitions */
+#define ACE_BUSMODE (0x00)
+
+#define ACE_STATUS (0x04)
+#define ACE_STATUS_CFGLOCK      (0x00000001)
+#define ACE_STATUS_MPULOCK      (0x00000002)
+#define ACE_STATUS_CFGERROR     (0x00000004) /* config controller error */
+#define ACE_STATUS_CFCERROR     (0x00000008) /* CF controller error */
+#define ACE_STATUS_CFDETECT     (0x00000010)
+#define ACE_STATUS_DATABUFRDY   (0x00000020)
+#define ACE_STATUS_DATABUFMODE  (0x00000040)
+#define ACE_STATUS_CFGDONE      (0x00000080)
+#define ACE_STATUS_RDYFORCFCMD  (0x00000100)
+#define ACE_STATUS_CFGMODEPIN   (0x00000200)
+#define ACE_STATUS_CFGADDR_MASK (0x0000e000)
+#define ACE_STATUS_CFBSY        (0x00020000)
+#define ACE_STATUS_CFRDY        (0x00040000)
+#define ACE_STATUS_CFDWF        (0x00080000)
+#define ACE_STATUS_CFDSC        (0x00100000)
+#define ACE_STATUS_CFDRQ        (0x00200000)
+#define ACE_STATUS_CFCORR       (0x00400000)
+#define ACE_STATUS_CFERR        (0x00800000)
+
+#define ACE_ERROR (0x08)
+#define ACE_CFGLBA (0x0c)
+#define ACE_MPULBA (0x10)
+
+#define ACE_SECCNTCMD (0x14)
+#define ACE_SECCNTCMD_RESET      (0x0100)
+#define ACE_SECCNTCMD_IDENTIFY   (0x0200)
+#define ACE_SECCNTCMD_READ_DATA  (0x0300)
+#define ACE_SECCNTCMD_WRITE_DATA (0x0400)
+#define ACE_SECCNTCMD_ABORT      (0x0600)
+
+#define ACE_VERSION (0x16)
+#define ACE_VERSION_REVISION_MASK (0x00FF)
+#define ACE_VERSION_MINOR_MASK    (0x0F00)
+#define ACE_VERSION_MAJOR_MASK    (0xF000)
+
+#define ACE_CTRL (0x18)
+#define ACE_CTRL_FORCELOCKREQ   (0x0001)
+#define ACE_CTRL_LOCKREQ        (0x0002)
+#define ACE_CTRL_FORCECFGADDR   (0x0004)
+#define ACE_CTRL_FORCECFGMODE   (0x0008)
+#define ACE_CTRL_CFGMODE        (0x0010)
+#define ACE_CTRL_CFGSTART       (0x0020)
+#define ACE_CTRL_CFGSEL         (0x0040)
+#define ACE_CTRL_CFGRESET       (0x0080)
+#define ACE_CTRL_DATABUFRDYIRQ  (0x0100)
+#define ACE_CTRL_ERRORIRQ       (0x0200)
+#define ACE_CTRL_CFGDONEIRQ     (0x0400)
+#define ACE_CTRL_RESETIRQ       (0x0800)
+#define ACE_CTRL_CFGPROG        (0x1000)
+#define ACE_CTRL_CFGADDR_MASK   (0xe000)
+
+#define ACE_FATSTAT (0x1c)
+
+#define ACE_NUM_MINORS 16
+#define ACE_SECTOR_SIZE (512)
+#define ACE_FIFO_SIZE (32)
+#define ACE_BUF_PER_SECTOR (ACE_SECTOR_SIZE / ACE_FIFO_SIZE)
+
+struct ace_reg_ops;
+
+struct ace_device {
+	/* driver state data */
+	int id;
+	int media_change;
+	int users;
+	struct list_head list;
+
+	/* finite state machine data */
+	struct tasklet_struct fsm_tasklet;
+	uint fsm_task;			/* Current activity (ACE_TASK_*) */
+	uint fsm_state;			/* Current state (ACE_FSM_STATE_*) */
+	uint fsm_continue_flag;		/* cleared to exit FSM mainloop */
+	uint fsm_iter_num;
+	struct timer_list stall_timer;
+
+	/* Transfer state/result, use for both id and block request */
+	struct request *req;		/* request being processed */
+	uint16_t* data_ptr;		/* pointer to I/O buffer */
+	int data_count;			/* number of buffers remaining */
+	int data_result;		/* Result of transfer; 0 := success */
+
+	int id_req_count;		/* count of id requests */
+	int id_result;
+	struct completion id_completion;/* used when id requests finish */
+	int in_irq;
+
+	/* Details of hardware device */
+	ulong physaddr;
+	void* baseaddr;
+	int irq;
+	int bus_width;  /* 0 := 8 bit; 1 := 16 bit */
+	struct ace_reg_ops *reg_ops;
+	int lock_count;
+
+	/* Block device data structures */
+	spinlock_t lock;
+	struct device *dev;
+	struct request_queue *queue;
+	struct gendisk *gd;
+
+	/* Inserted CF card parameters */
+	struct hd_driveid cf_id;
+};
+
+static LIST_HEAD(ace_instances);
+static int ace_major = 0;
+
+/* ---------------------------------------------------------------------
+ * Low level register access
+ */
+
+struct ace_reg_ops {
+	uint16_t (*in)(struct ace_device *ace, ulong reg);
+	void (*out)(struct ace_device *ace, ulong reg, uint16_t val);
+	void (*identin)(struct ace_device *ace);
+	void (*datain)(struct ace_device *ace);
+	void (*dataout)(struct ace_device *ace);
+};
+
+/* 8 Bit bus width */
+static uint16_t ace_in_8(struct ace_device *ace, ulong reg)
+{
+	void* r = ace->baseaddr + reg;
+	return in_8(r) | (in_8(r+1) << 8);
+}
+
+static void ace_out_8(struct ace_device *ace, ulong reg, uint16_t val)
+{
+	void* r = ace->baseaddr + reg;
+	out_8(r, val);
+	out_8(r+1, val >> 8);
+}
+
+static void ace_identin_8(struct ace_device *ace)
+{
+	void* r = ace->baseaddr + 0x40;
+	int i = ACE_FIFO_SIZE/2;
+	while (i--)
+#if defined(__BIG_ENDIAN)
+		*ace->data_ptr++ = (in_8(r)) | (in_8(r+1)<<8);
+#else
+		*ace->data_ptr++ = (in_8(r)<<8) | (in_8(r+1));
+#endif
+}
+
+static void ace_datain_8(struct ace_device *ace)
+{
+	void* r = ace->baseaddr + 0x40;
+	int i = ACE_FIFO_SIZE/2;
+	while (i--)
+#if defined(__BIG_ENDIAN)
+		*ace->data_ptr++ = (in_8(r)<<8) | (in_8(r+1));
+#else
+		*ace->data_ptr++ = (in_8(r)) | (in_8(r+1)<<8);
+#endif
+}
+
+static void ace_dataout_8(struct ace_device *ace)
+{
+	void* r = ace->baseaddr + 0x40;
+	int i = ACE_FIFO_SIZE/2;
+	while (i--) {
+#if defined(__BIG_ENDIAN)
+		out_8(r, *ace->data_ptr >> 8);
+		out_8(r+1, *ace->data_ptr);
+#else
+		out_8(r, *ace->data_ptr);
+		out_8(r+1, *ace->data_ptr >> 8);
+#endif
+		ace->data_ptr++;
+	}
+}
+
+static struct ace_reg_ops ace_reg_8_ops = {
+	.in = ace_in_8,
+	.out = ace_out_8,
+	.identin = ace_identin_8,
+	.datain = ace_datain_8,
+	.dataout = ace_dataout_8,
+};
+
+/* 16 bit big endian bus attachment */
+static uint16_t ace_in_be16(struct ace_device *ace, ulong reg)
+{
+	return in_be16(ace->baseaddr+reg);
+}
+
+static void ace_out_be16(struct ace_device *ace, ulong reg, uint16_t val)
+{
+	out_be16(ace->baseaddr+reg, val);
+}
+
+static void ace_fifoin_be16(struct ace_device *ace)
+{
+	int i = ACE_FIFO_SIZE/2;
+	while (i--)
+		*ace->data_ptr++ = in_be16(ace->baseaddr + 0x40);
+}
+
+static void ace_fifoout_be16(struct ace_device *ace)
+{
+	int i = ACE_FIFO_SIZE/2;
+	while (i--)
+		out_be16(ace->baseaddr + 0x40, *ace->data_ptr++);
+}
+
+/* 16 bit little endian bus attachment */
+static uint16_t ace_in_le16(struct ace_device *ace, ulong reg)
+{
+	return in_le16(ace->baseaddr+reg);
+}
+
+static void ace_out_le16(struct ace_device *ace, ulong reg, uint16_t val)
+{
+	out_le16(ace->baseaddr+reg, val);
+}
+
+static void ace_fifoin_le16(struct ace_device *ace)
+{
+	int i = ACE_FIFO_SIZE/2;
+	while (i--)
+		*ace->data_ptr++ = in_le16(ace->baseaddr + 0x40);
+}
+
+static void ace_fifoout_le16(struct ace_device *ace)
+{
+	int i = ACE_FIFO_SIZE/2;
+	while (i--)
+		out_le16(ace->baseaddr + 0x40, *ace->data_ptr++);
+}
+
+static struct ace_reg_ops ace_reg_be16_ops = {
+	.in = ace_in_be16,
+	.out = ace_out_be16,
+	.identin = ace_fifoin_be16,
+	.datain = ace_fifoin_le16, /* little endian! */
+	.dataout = ace_fifoout_le16, /* little endian! */
+};
+
+static struct ace_reg_ops ace_reg_le16_ops = {
+	.in = ace_in_le16,
+	.out = ace_out_le16,
+	.identin = ace_fifoin_le16,
+	.datain = ace_fifoin_be16, /* big endian! */
+	.dataout = ace_fifoout_be16, /* big endian! */
+};
+
+#define ace_in(ace, reg)		ace->reg_ops->in(ace, reg)
+static inline uint32_t ace_in32(struct ace_device *ace, ulong reg)
+{
+	return ace_in(ace, reg) | (ace_in(ace, reg+2) << 16);
+}
+#define ace_out(ace, reg, val)		ace->reg_ops->out(ace, reg, val)
+static inline void ace_out32(struct ace_device *ace, ulong reg, uint32_t val)
+{
+	ace_out(ace, reg, val);
+	ace_out(ace, reg+2, val >> 16);
+}
+#define ace_identin(ace)		ace->reg_ops->identin(ace)
+#define ace_datain(ace)			ace->reg_ops->datain(ace)
+#define ace_dataout(ace)		ace->reg_ops->dataout(ace)
+
+/* legacy macros, to be removed */
+#define ace_reg_read16(ace, reg)	ace_in(ace, reg)
+#define ace_reg_read32(ace, reg)	ace_in32(ace, reg)
+#define ace_reg_write16(ace, reg, val)	ace_out(ace, reg, val)
+#define ace_reg_write32(ace, reg, val)	ace_out32(ace, reg, val)
+
+/* ---------------------------------------------------------------------
+ * Debug support functions
+ */
+
+#define ace_dbg(ace, format, arg...) dev_dbg(ace->dev, format, ## arg)
+#define ace_err(ace, format, arg...) dev_err(ace->dev, format, ## arg)
+#define ace_info(ace, format, arg...) dev_info(ace->dev, format, ## arg)
+#define ace_warn(ace, format, arg...) dev_warn(ace->dev, format, ## arg)
+#define ace_notice(ace, format, arg...) dev_notice(ace->dev, format, ## arg)
+
+#if defined(DEBUG)
+static void ace_dump_mem(void* base, int len)
+{
+	const char* ptr = base;
+	int i, j;
+
+	for (i = 0; i < len; i += 16) {
+		printk(KERN_INFO "%.8x:", i);
+		for (j = 0; j < 16; j++) {
+			if (!(j % 4))
+				printk(" ");
+			printk("%.2x", ptr[i+j]);
+		}
+		printk(" ");
+		for (j = 0; j < 16; j++)
+			printk("%c", isprint(ptr[i+j]) ? ptr[i+j] : '.');
+		printk("\n");
+	}
+}
+#else
+static inline void ace_dump_mem(void* base, int len) {}
+#endif
+
+static void ace_dump_regs(struct ace_device *ace)
+{
+	ace_info(ace, "    ctrl:  %.8x  seccnt/cmd: %.4x      ver:%.4x\n"
+	              "    status:%.8x  mpu_lba:%.8x  busmode:%4x\n"
+	              "    error: %.8x  cfg_lba:%.8x  fatstat:%.4x\n",
+	         ace_reg_read32(ace, ACE_CTRL),
+	         ace_reg_read16(ace, ACE_SECCNTCMD),
+	         ace_reg_read16(ace, ACE_VERSION),
+	         ace_reg_read32(ace, ACE_STATUS),
+	         ace_reg_read32(ace, ACE_MPULBA),
+	         ace_reg_read16(ace, ACE_BUSMODE),
+	         ace_reg_read32(ace, ACE_ERROR),
+	         ace_reg_read32(ace, ACE_CFGLBA),
+	         ace_reg_read16(ace, ACE_FATSTAT));
+}
+
+void ace_fix_driveid (struct hd_driveid *id)
+{
+#ifndef __LITTLE_ENDIAN
+# ifdef __BIG_ENDIAN
+	/* The ace_reg_read16 macro handles 16 bit reads correctly, but
+	 * 32bit values are partially little endian; swap the words
+	 */
+	id->lba_capacity   = ((id->lba_capacity >> 16) & 0x0000FFFF) |
+	                     ((id->lba_capacity << 16) & 0xFFFF0000);
+	id->spg            = ((id->spg >> 16) & 0x0000FFFF) |
+	                     ((id->spg << 16) & 0xFFFF0000);
+# else
+#  error "Please fix <asm/byteorder.h>"
+# endif
+#endif
+}
+
+/* ---------------------------------------------------------------------
+ * Finite State Machine (FSM) implementation
+ */
+
+/* FSM tasks; used to direct state transitions */
+#define ACE_TASK_IDLE      0
+#define ACE_TASK_IDENTIFY  1
+#define ACE_TASK_READ      2
+#define ACE_TASK_WRITE     3
+#define ACE_FSM_NUM_TASKS  4
+
+/* FSM state definitions */
+#define ACE_FSM_STATE_IDLE               0
+#define ACE_FSM_STATE_REQ_LOCK           1
+#define ACE_FSM_STATE_WAIT_LOCK          2
+#define ACE_FSM_STATE_WAIT_CFREADY       3
+#define ACE_FSM_STATE_IDENTIFY_PREPARE   4
+#define ACE_FSM_STATE_IDENTIFY_TRANSFER  5
+#define ACE_FSM_STATE_IDENTIFY_COMPLETE  6
+#define ACE_FSM_STATE_REQ_PREPARE        7
+#define ACE_FSM_STATE_REQ_TRANSFER       8
+#define ACE_FSM_STATE_REQ_COMPLETE       9
+#define ACE_FSM_STATE_ERROR             10
+#define ACE_FSM_NUM_STATES              11
+
+#if defined(DEBUG)
+const char* ace_statenames[ACE_FSM_NUM_STATES] = {
+	"idle",
+	"req lock",
+	"wait lock",
+	"wait cf ready",
+	"identify prepare",
+	"identify transfer",
+	"identify complete",
+	"request prepare",
+	"request transfer",
+	"request complete",
+};
+#endif
+
+/* Set flag to exit FSM loop and reschedule tasklet */
+static void inline ace_fsm_yield(struct ace_device *ace)
+{
+	ace_dbg(ace, "ace_fsm_yield()\n");
+	tasklet_schedule(&ace->fsm_tasklet);
+	ace->fsm_continue_flag = 0;
+}
+
+/* Set flag to exit FSM loop and wait for IRQ to reschedule tasklet */
+static void inline ace_fsm_yieldirq(struct ace_device *ace)
+{
+	ace_dbg(ace, "ace_fsm_yieldirq()\n");
+	ace->fsm_continue_flag = 0;
+}
+
+/* Get the next read/write request; ending requests that we don't handle */
+struct request* ace_get_next_request(request_queue_t *q)
+{
+	struct request *req;
+
+	while ((req = elv_next_request(q)) != NULL) {
+		if (blk_fs_request(req))
+			break;
+		end_request(req, 0);
+	}
+	return req;
+}
+
+static void ace_fsm_dostate(struct ace_device *ace)
+{
+	struct request *req;
+	uint32_t status;
+	uint16_t val;
+	int count;
+	int i;
+
+#if defined(DEBUG)
+	const char *name = "invalid";
+	if (ace->fsm_state < ACE_FSM_NUM_STATES)
+		name = ace_statenames[ace->fsm_state];
+	ace_info(ace, "fsm_state=%i \"%s\", id_req_count=%i\n",
+	         ace->fsm_state, name, ace->id_req_count);
+#endif
+
+	switch (ace->fsm_state) {
+	    case ACE_FSM_STATE_IDLE:
+		/* See if there is anything to do */
+		if (ace->id_req_count || ace_get_next_request(ace->queue)) {
+			ace->fsm_iter_num++;
+			ace->fsm_state = ACE_FSM_STATE_REQ_LOCK;
+			mod_timer(&ace->stall_timer, jiffies + HZ);
+			if (!timer_pending(&ace->stall_timer))
+				add_timer(&ace->stall_timer);
+			break;
+		}
+		del_timer(&ace->stall_timer);
+		ace->fsm_continue_flag = 0;
+		break;
+
+	    case ACE_FSM_STATE_REQ_LOCK:
+		if (ace_reg_read16(ace, ACE_STATUS) & ACE_STATUS_MPULOCK) {
+			/* Already have the lock, jump to next state */
+			ace->fsm_state = ACE_FSM_STATE_WAIT_CFREADY;
+			break;
+		}
+
+		/* Request the lock */
+		val = ace_reg_read16(ace, ACE_CTRL);
+		ace_reg_write16(ace, ACE_CTRL, val | ACE_CTRL_LOCKREQ);
+		ace->fsm_state = ACE_FSM_STATE_WAIT_LOCK;
+		break;
+
+	    case ACE_FSM_STATE_WAIT_LOCK:
+		if (ace_reg_read16(ace, ACE_STATUS) & ACE_STATUS_MPULOCK) {
+			/* got the lock; move to next state */
+			ace->fsm_state = ACE_FSM_STATE_WAIT_CFREADY;
+			break;
+		}
+
+		/* wait a bit for the lock */
+		ace_fsm_yield(ace);
+		break;
+
+	    case ACE_FSM_STATE_WAIT_CFREADY:
+		status = ace_reg_read32(ace, ACE_STATUS);
+		if (!(status & ACE_STATUS_RDYFORCFCMD) ||
+		    (status & ACE_STATUS_CFBSY)) {
+			/* CF card isn't ready; it needs to be polled */
+			ace_fsm_yield(ace);
+			break;
+		}
+
+		/* Device is ready for command; determine what to do next */
+		if (ace->id_req_count)
+			ace->fsm_state = ACE_FSM_STATE_IDENTIFY_PREPARE;
+		else
+			ace->fsm_state = ACE_FSM_STATE_REQ_PREPARE;
+		break;
+
+	    case ACE_FSM_STATE_IDENTIFY_PREPARE:
+		/* Send identify command */
+		ace->fsm_task = ACE_TASK_IDENTIFY;
+		ace->data_ptr = (void*)&ace->cf_id;
+		ace->data_count = ACE_BUF_PER_SECTOR;
+		ace_reg_write16(ace, ACE_SECCNTCMD, ACE_SECCNTCMD_IDENTIFY);
+
+		/* As per datasheet, put config controller in reset */
+		val = ace_reg_read16(ace, ACE_CTRL);
+		ace_reg_write16(ace, ACE_CTRL, val | ACE_CTRL_CFGRESET);
+
+		/* irq handler takes over from this point; wait for the
+		 * transfer to complete */
+		ace->fsm_state = ACE_FSM_STATE_IDENTIFY_TRANSFER;
+		ace_fsm_yieldirq(ace);
+		break;
+
+	    case ACE_FSM_STATE_IDENTIFY_TRANSFER:
+		/* Check that the sysace is ready to receive data */
+		status = ace_reg_read32(ace, ACE_STATUS);
+		if (status & ACE_STATUS_CFBSY) {
+			ace_dbg(ace, "CFBSY set; t=%i iter=%i dc=%i\n",
+			        ace->fsm_task, ace->fsm_iter_num,
+			        ace->data_count);
+			ace_fsm_yield(ace);
+			break;
+		}
+		if (!(status & ACE_STATUS_DATABUFRDY)) {
+			ace_fsm_yield(ace);
+			break;
+		}
+
+		/* Transfer the next buffer */
+		ace_identin(ace);
+		ace->data_count--;
+
+		/* If there are still buffers to be transfers; jump out here */
+		if (ace->data_count != 0) {
+			ace_fsm_yieldirq(ace);
+			break;
+		}
+
+		/* transfer finished; kick state machine */
+		ace_dbg(ace, "identify finished\n");
+		ace->fsm_state = ACE_FSM_STATE_IDENTIFY_COMPLETE;
+		break;
+
+	    case ACE_FSM_STATE_IDENTIFY_COMPLETE:
+		ace_fix_driveid(&ace->cf_id);
+		ace_dump_mem(&ace->cf_id, 512); /* Debug: Dump out disk ID */
+
+		if (ace->data_result) {
+			/* Error occured, disable the disk */
+			ace->media_change = 1;
+			set_capacity(ace->gd, 0);
+			ace_err(ace, "error fetching CF id (%i)\n",
+			        ace->data_result);
+		} else {
+			ace->media_change = 0;
+
+			/* Record disk parameters */
+			set_capacity(ace->gd, ace->cf_id.lba_capacity);
+			ace_info(ace, "capacity: %i sectors\n",
+			         ace->cf_id.lba_capacity);
+		}
+
+		/* We're done, drop to IDLE state and notify waiters */
+		ace->fsm_state = ACE_FSM_STATE_IDLE;
+		ace->id_result = ace->data_result;
+		while (ace->id_req_count) {
+			complete(&ace->id_completion);
+			ace->id_req_count--;
+		}
+		break;
+
+	    case ACE_FSM_STATE_REQ_PREPARE:
+		req = ace_get_next_request(ace->queue);
+		if (!req) {
+			ace->fsm_state = ACE_FSM_STATE_IDLE;
+			break;
+		}
+
+		/* Okay, it's a data request, set it up for transfer */
+		ace_dbg(ace, "request: sec=%lx hcnt=%lx, ccnt=%x, dir=%i\n",
+			req->sector, req->hard_nr_sectors,
+			req->current_nr_sectors, rq_data_dir(req));
+
+		ace->req = req;
+		ace->data_ptr = (void*)req->buffer;
+		ace->data_count = req->current_nr_sectors * ACE_BUF_PER_SECTOR;
+		ace_reg_write32(ace, ACE_MPULBA, req->sector & 0x0FFFFFFF);
+
+		count = req->hard_nr_sectors;
+		if (rq_data_dir(req)) {
+			/* Kick off write request */
+			ace_dbg(ace, "write data\n");
+			ace->fsm_task = ACE_TASK_WRITE;
+			ace_reg_write16(ace, ACE_SECCNTCMD,
+					count | ACE_SECCNTCMD_WRITE_DATA);
+		} else {
+			/* Kick off read request */
+			ace_dbg(ace, "read data\n");
+			ace->fsm_task = ACE_TASK_READ;
+			ace_reg_write16(ace, ACE_SECCNTCMD,
+					count | ACE_SECCNTCMD_READ_DATA);
+		}
+
+		/* As per datasheet, put config controller in reset */
+		val = ace_reg_read16(ace, ACE_CTRL);
+		ace_reg_write16(ace, ACE_CTRL, val | ACE_CTRL_CFGRESET);
+
+		/* Move to the transfer state.  The systemace will raise
+		 * an interrupt once there is something to do
+		 */
+		ace->fsm_state = ACE_FSM_STATE_REQ_TRANSFER;
+		if (ace->fsm_task == ACE_TASK_READ)
+			ace_fsm_yieldirq(ace); /* wait for data ready */
+		break;
+
+	    case ACE_FSM_STATE_REQ_TRANSFER:
+		/* Check that the sysace is ready to receive data */
+		status = ace_reg_read32(ace, ACE_STATUS);
+		if (status & ACE_STATUS_CFBSY) {
+			ace_dbg(ace, "CFBSY set; t=%i iter=%i c=%i dc=%i irq=%i\n",
+				ace->fsm_task, ace->fsm_iter_num,
+				ace->req->current_nr_sectors*16,
+				ace->data_count, ace->in_irq);
+			ace_fsm_yield(ace); /* need to poll CFBSY bit */
+			break;
+		}
+		if (!(status & ACE_STATUS_DATABUFRDY)) {
+			ace_dbg(ace, "DATABUF not set; t=%i iter=%i c=%i dc=%i irq=%i\n",
+				ace->fsm_task, ace->fsm_iter_num,
+				ace->req->current_nr_sectors*16,
+				ace->data_count, ace->in_irq);
+			ace_fsm_yieldirq(ace);
+			break;
+		}
+
+		/* Transfer the next buffer */
+		i = 16;
+		if (ace->fsm_task == ACE_TASK_WRITE)
+			ace_dataout(ace);
+		else
+			ace_datain(ace);
+		ace->data_count--;
+
+		/* If there are still buffers to be transfers; jump out here */
+		if (ace->data_count != 0) {
+			ace_fsm_yieldirq(ace);
+			break;
+		}
+
+		/* bio finished; is there another one? */
+		i = ace->req->current_nr_sectors;
+		if (end_that_request_first(ace->req, 1, i)) {
+			/* ace_dbg(ace, "next block; h=%li c=%i\n",
+			 * 	ace->req->hard_nr_sectors,
+			 * 	ace->req->current_nr_sectors);
+			 */
+			ace->data_ptr = (void*)ace->req->buffer;
+			ace->data_count = ace->req->current_nr_sectors * 16;
+			ace_fsm_yieldirq(ace);
+			break;
+		}
+
+		ace->fsm_state = ACE_FSM_STATE_REQ_COMPLETE;
+		break;
+
+	    case ACE_FSM_STATE_REQ_COMPLETE:
+		/* Complete the block request */
+		blkdev_dequeue_request(ace->req);
+		end_that_request_last(ace->req, 1);
+		ace->req = NULL;
+
+		/* Finished request; go to idle state */
+		ace->fsm_state = ACE_FSM_STATE_IDLE;
+		break;
+
+	    default:
+		ace->fsm_state = ACE_FSM_STATE_IDLE;
+		break;
+	}
+}
+
+static void ace_fsm_tasklet(ulong data)
+{
+	struct ace_device *ace = (void*)data;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ace->lock, flags);
+
+	/* Loop over state machine until told to stop */
+	ace->fsm_continue_flag = 1;
+	while (ace->fsm_continue_flag)
+		ace_fsm_dostate(ace);
+
+	spin_unlock_irqrestore(&ace->lock, flags);
+}
+
+static void ace_stall_timer(ulong data)
+{
+	struct ace_device *ace = (void*)data;
+	unsigned long flags;
+
+	ace_warn(ace, "kicking stalled fsm; state=%i task=%i iter=%i dc=%i\n",
+	         ace->fsm_state, ace->fsm_task, ace->fsm_iter_num,
+	         ace->data_count);
+	spin_lock_irqsave(&ace->lock, flags);
+
+	/* Loop over state machine until told to stop */
+	ace->fsm_continue_flag = 1;
+	while (ace->fsm_continue_flag)
+		ace_fsm_dostate(ace);
+
+	/* Rearm the stall timer */
+	ace->stall_timer.expires = jiffies + HZ;
+	add_timer(&ace->stall_timer);
+
+	spin_unlock_irqrestore(&ace->lock, flags);
+}
+
+/* ---------------------------------------------------------------------
+ * Interrupt handling routines
+ */
+static int ace_interrupt_checkstate(struct ace_device *ace)
+{
+	uint32_t sreg = ace_reg_read32(ace, ACE_STATUS);
+	uint16_t creg = ace_reg_read16(ace, ACE_CTRL);
+
+	/* Check for error occurance */
+	if ((sreg & (ACE_STATUS_CFGERROR | ACE_STATUS_CFCERROR)) &&
+	    (creg & ACE_CTRL_ERRORIRQ)) {
+		ace_err(ace, "transfer failure\n");
+		ace_dump_regs(ace);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static irqreturn_t ace_interrupt(int irq, void *dev_id)
+{
+	uint16_t creg;
+	struct ace_device *ace = dev_id;
+	unsigned long flags;
+
+	/* be safe and get the lock */
+	spin_lock_irqsave(&ace->lock, flags);
+	ace->in_irq = 1;
+
+	/* clear the interrupt */
+	creg = ace_reg_read16(ace, ACE_CTRL);
+	ace_reg_write16(ace, ACE_CTRL, creg | ACE_CTRL_RESETIRQ);
+	ace_reg_write16(ace, ACE_CTRL, creg);
+
+	/* check for IO failures */
+	if (ace_interrupt_checkstate(ace))
+		ace->data_result = -EIO;
+
+	if (ace->fsm_task == 0) {
+		ace_err(ace, "spurious irq; stat=%.8x ctrl=%.8x cmd=%.4x\n",
+		        ace_reg_read32(ace, ACE_STATUS),
+		        ace_reg_read32(ace, ACE_CTRL),
+		        ace_reg_read16(ace, ACE_SECCNTCMD));
+		ace_err(ace, "fsm_task=%i fsm_state=%i data_count=%i\n",
+		        ace->fsm_task, ace->fsm_state, ace->data_count);
+	}
+
+	/* Loop over state machine until told to stop */
+	ace->fsm_continue_flag = 1;
+	while (ace->fsm_continue_flag)
+		ace_fsm_dostate(ace);
+
+	/* done with interrupt; drop the lock */
+	ace->in_irq = 0;
+	spin_unlock_irqrestore(&ace->lock, flags);
+
+	return IRQ_HANDLED;
+}
+
+/* ---------------------------------------------------------------------
+ * Block ops
+ */
+static void ace_request(request_queue_t *q)
+{
+	struct request *req;
+	struct ace_device *ace;
+
+	req = ace_get_next_request(q);
+
+	if (req) {
+		ace = req->rq_disk->private_data;
+		tasklet_schedule(&ace->fsm_tasklet);
+	}
+}
+
+static int ace_media_changed(struct gendisk *gd)
+{
+	struct ace_device *ace = gd->private_data;
+	ace_dbg(ace, "ace_media_changed(): %i\n", ace->media_change);
+
+	return ace->media_change;
+}
+
+static int ace_revalidate_disk(struct gendisk *gd)
+{
+	struct ace_device *ace = gd->private_data;
+	ulong flags;
+
+	ace_dbg(ace, "ace_revalidate_disk()\n");
+
+	if (ace->media_change) {
+		ace_dbg(ace, "requesting cf id and scheduling tasklet\n");
+
+		spin_lock_irqsave(&ace->lock, flags);
+		ace->id_req_count++;
+		spin_unlock_irqrestore(&ace->lock, flags);
+
+		tasklet_schedule(&ace->fsm_tasklet);
+		wait_for_completion(&ace->id_completion);
+	}
+
+	ace_dbg(ace, "revalidate complete\n");
+	return ace->id_result;
+}
+
+static int ace_open(struct inode *inode, struct file *filp)
+{
+	struct ace_device *ace = inode->i_bdev->bd_disk->private_data;
+	unsigned long flags;
+
+	ace_dbg(ace, "ace_open() users=%i\n", ace->users+1);
+
+	filp->private_data = ace;
+	spin_lock_irqsave(&ace->lock, flags);
+	ace->users++;
+	spin_unlock_irqrestore(&ace->lock, flags);
+
+	check_disk_change(inode->i_bdev);
+	return 0;
+}
+
+static int ace_release(struct inode *inode, struct file *filp)
+{
+	struct ace_device *ace = inode->i_bdev->bd_disk->private_data;
+	unsigned long flags;
+	uint16_t val;
+
+	ace_dbg(ace, "ace_release() users=%i\n", ace->users-1);
+
+	spin_lock_irqsave(&ace->lock, flags);
+	ace->users--;
+	if (ace->users == 0) {
+		val = ace_reg_read16(ace, ACE_CTRL);
+		ace_reg_write16(ace, ACE_CTRL, val & ~ACE_CTRL_LOCKREQ);
+	}
+	spin_unlock_irqrestore(&ace->lock, flags);
+	return 0;
+}
+
+static int ace_ioctl(struct inode *inode, struct file *filp,
+                         unsigned int cmd, unsigned long arg)
+{
+	struct ace_device *ace = inode->i_bdev->bd_disk->private_data;
+	ace_dbg(ace, "ace_ioctl()\n");
+
+	return -ENOTTY;
+}
+
+static struct block_device_operations ace_fops = {
+	.owner = THIS_MODULE,
+	.open = ace_open,
+	.release = ace_release,
+	.media_changed = ace_media_changed,
+	.revalidate_disk = ace_revalidate_disk,
+	.ioctl = ace_ioctl,
+};
+
+/* --------------------------------------------------------------------
+ * SystemACE device setup/teardown code
+ */
+static int ace_setup(struct ace_device *ace)
+{
+	uint16_t version;
+	uint16_t val;
+	int rc;
+
+	spin_lock_init(&ace->lock);
+	init_completion(&ace->id_completion);
+
+	/*
+	 * Map the device
+	 */
+	ace->baseaddr = ioremap(ace->physaddr, 0x80);
+	if (!ace->baseaddr)
+		goto err_ioremap;
+
+	if (ace->irq != NO_IRQ) {
+		rc = request_irq(ace->irq, ace_interrupt, 0, "systemace", ace);
+		if (rc) {
+			/* Failure - fall back to polled mode */
+			ace_err(ace, "request_irq failed\n");
+			ace->irq = NO_IRQ;
+		}
+	}
+
+	/*
+	 * Initialize the state machine tasklet and stall timer
+	 */
+	tasklet_init(&ace->fsm_tasklet, ace_fsm_tasklet, (ulong)ace);
+	init_timer(&ace->stall_timer);
+	ace->stall_timer.function = ace_stall_timer;
+	ace->stall_timer.data = (ulong)ace;
+
+	/*
+	 * Initialize the request queue
+	 */
+	ace->queue = blk_init_queue(ace_request, &ace->lock);
+	if (ace->queue == NULL)
+		goto err_blk_initq;
+	blk_queue_hardsect_size(ace->queue, 512);
+
+	/*
+	 * Allocate and initialize GD structure
+	 */
+	ace->gd = alloc_disk(ACE_NUM_MINORS);
+	if (!ace->gd)
+		goto err_alloc_disk;
+
+	ace->gd->major = ace_major;
+	ace->gd->first_minor = ace->id * ACE_NUM_MINORS;
+	ace->gd->fops = &ace_fops;
+	ace->gd->queue = ace->queue;
+	ace->gd->private_data = ace;
+	snprintf(ace->gd->disk_name, 32, "xs%c", ace->id + 'a');
+	device_rename(ace->dev, ace->gd->disk_name);
+
+	/* set bus width */
+	if (ace->bus_width == 1) {
+		/* 0x0101 should work regardless of endianess */
+		ace_out_le16(ace, ACE_BUSMODE, 0x0101);
+
+		/* read it back to determine endianess */
+		if (ace_in_le16(ace, ACE_BUSMODE) == 0x0001)
+			ace->reg_ops = &ace_reg_le16_ops;
+		else
+			ace->reg_ops = &ace_reg_be16_ops;
+	} else {
+		ace_out_8(ace, ACE_BUSMODE, 0x00);
+		ace->reg_ops = &ace_reg_8_ops;
+	}
+
+	/* Make sure version register is sane */
+	version = ace_reg_read16(ace, ACE_VERSION);
+	if ((version == 0) || (version == 0xFFFF))
+		goto err_read;
+
+	/* Put sysace in a sane state by clearing most control reg bits */
+	ace_reg_write16(ace, ACE_CTRL, ACE_CTRL_FORCECFGMODE |
+	                               ACE_CTRL_DATABUFRDYIRQ |
+	                               ACE_CTRL_ERRORIRQ);
+
+	/* Enable interrupts */
+	val = ace_reg_read16(ace, ACE_CTRL);
+	val |= ACE_CTRL_DATABUFRDYIRQ | ACE_CTRL_ERRORIRQ;
+	ace_reg_write16(ace, ACE_CTRL, val);
+
+	/* Print the identification */
+	ace_info(ace, "Xilinx SystemACE revision %i.%i.%i\n",
+	         (version>>12)&0xf, (version>>8)&0x0f, version&0xff);
+	ace_dbg(ace, "physaddr 0x%lx, mapped to 0x%p, irq=%i\n",
+	        ace->physaddr, ace->baseaddr, ace->irq);
+
+	ace->media_change = 1;
+	ace_revalidate_disk(ace->gd);
+
+	/* Make the sysace device 'live' */
+	list_add(&ace->list, &ace_instances);
+	add_disk(ace->gd);
+
+	return 0;
+
+err_read:
+	put_disk(ace->gd);
+err_alloc_disk:
+	blk_cleanup_queue(ace->queue);
+err_blk_initq:
+	iounmap(ace->baseaddr);
+	if (ace->irq != NO_IRQ)
+		free_irq(ace->irq, ace);
+err_ioremap:
+	printk(KERN_INFO "xsysace: error initializing device at 0x%lx\n",
+	      ace->physaddr);
+	return -ENOMEM;
+}
+
+static void ace_teardown(struct ace_device *ace)
+{
+	if (ace->gd) {
+		del_gendisk(ace->gd);
+		put_disk(ace->gd);
+	}
+
+	if (ace->queue)
+		blk_cleanup_queue(ace->queue);
+
+	tasklet_kill(&ace->fsm_tasklet);
+
+	if (ace->irq != NO_IRQ)
+		free_irq(ace->irq, ace);
+
+	iounmap(ace->baseaddr);
+}
+
+/* ---------------------------------------------------------------------
+ * Platform Bus Support
+ */
+
+static int ace_probe(struct device *device)
+{
+	struct platform_device *dev = to_platform_device(device);
+	struct ace_device *ace;
+	int i;
+
+	dev_dbg(device, "ace_probe(%p)\n", device);
+
+	/*
+	 * Allocate the ace device structure
+	 */
+	ace = kmalloc(sizeof(struct ace_device), GFP_KERNEL);
+	if (!ace)
+		goto err_alloc;
+	memset(ace, 0, sizeof(struct ace_device));
+
+	ace->dev = device;
+	ace->id = dev->id;
+	ace->irq = NO_IRQ;
+
+	for (i = 0; i < dev->num_resources; i++) {
+		if (dev->resource[i].flags & IORESOURCE_MEM)
+			ace->physaddr = dev->resource[i].start;
+		if (dev->resource[i].flags & IORESOURCE_IRQ)
+			ace->irq = dev->resource[i].start;
+	}
+	
+	/* FIXME: Should get bus_width from the platform_device struct */
+	ace->bus_width = 1;
+
+	dev_set_drvdata(&dev->dev, ace);
+
+	/* Call the bus-independant setup code */
+	if (ace_setup(ace) != 0)
+		goto err_setup;
+
+	return 0;
+
+err_setup:
+	dev_set_drvdata(&dev->dev, NULL);
+	kfree(ace);
+err_alloc:
+	printk(KERN_ERR "xsysace: could not initialize device\n");
+	return -ENOMEM;
+}
+
+/*
+ * Platform bus remove() method
+ */
+static int ace_remove(struct device *device)
+{
+	struct ace_device *ace = dev_get_drvdata(device);
+
+	dev_dbg(device, "ace_remove(%p)\n", device);
+
+	if (ace) {
+		ace_teardown(ace);
+		kfree(ace);
+	}
+
+	return 0;
+}
+
+static struct device_driver ace_driver = {
+	.name	= "xsysace",
+	.bus	= &platform_bus_type,
+	.probe	= ace_probe,
+	.remove	= ace_remove,
+};
+
+/* ---------------------------------------------------------------------
+ * Module init/exit routines
+ */
+static int __init ace_init(void)
+{
+	ace_major = register_blkdev(ace_major, "xsysace");
+	if (ace_major <= 0) {
+		printk(KERN_WARNING "xsysace: register_blkdev() failed\n");
+		return ace_major;
+	}
+
+	pr_debug("Registering Xilinx SystemACE driver, major=%i\n", ace_major);
+	return driver_register(&ace_driver);
+}
+
+static void __exit ace_exit(void)
+{
+	pr_debug("Unregistering Xilinx SystemACE driver\n");
+	driver_unregister(&ace_driver);
+	if (unregister_blkdev(ace_major, "xsysace"))
+		printk(KERN_WARNING "systemace unregister_blkdev(%i) failed\n",
+		       ace_major);
+}
+
+module_init(ace_init);
+module_exit(ace_exit);
-- 
1.5.1

