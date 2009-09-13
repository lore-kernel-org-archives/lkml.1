Return-Path: <linux-kernel-owner+w=401wt.eu-S1752077AbZIMIhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077AbZIMIhh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 04:37:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751036AbZIMIhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 04:37:31 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60311 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbZIMIh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 04:37:27 -0400
Date: Sun, 13 Sep 2009 10:37:19 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Greg KH <greg@kroah.com>, arve@android.com, swetland@google.com,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [patch] Re: newer version of HTC Dream support
Message-ID: <20090913083719.GA6645@elf.ucw.cz>
References: <20090824092204.GB25591@elf.ucw.cz> <20090901131832.GA1835@ucw.cz> <20090904090303.024e981a.randy.dunlap@oracle.com> <20090911071155.GA1386@ucw.cz> <20090911075847.2fb7210a.randy.dunlap@oracle.com> <20090911161335.GA8137@elf.ucw.cz> <20090911092157.ba202b0a.randy.dunlap@oracle.com> <20090911212751.GA25544@elf.ucw.cz> <20090911153422.7d523a73.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090911153422.7d523a73.randy.dunlap@oracle.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Fix compilation of gpio_* input drivers on -next kernel. Adds needed
> > headers and removes unprotected wakelock/earlysuspend dependencies.
> >     
> > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> 
> Still doesn't build for me, but if it builds for you, that's great.
> (could be a tool chain problem on my side)

No, it does not look like toolchain problem :-(. I had parts disabled
in Kconfig. This should make it _compile_ (but not link); somehow
MSM_ADSP is neccessary for camera to link and I can't see how to
enable it.

Thanks for the patience.
								Pavel

---

Add pieces neccessary for compilation of msm_camera.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/arch/arm/mach-msm/include/mach/board.h b/arch/arm/mach-msm/include/mach/board.h
index 264d62e..271256c 100644
--- a/arch/arm/mach-msm/include/mach/board.h
+++ b/arch/arm/mach-msm/include/mach/board.h
@@ -35,4 +35,40 @@ void __init msm_init_irq(void);
 void __init msm_init_gpio(void);
 void __init msm_clock_init(void);
 
+struct msm_camera_io_ext {
+	uint32_t mdcphy;
+	uint32_t mdcsz;
+	uint32_t appphy;
+	uint32_t appsz;
+};
+
+struct msm_camera_device_platform_data {
+	void (*camera_gpio_on) (void);
+	void (*camera_gpio_off)(void);
+	struct msm_camera_io_ext ioext;
+};
+
+#ifdef CONFIG_SENSORS_MT9T013
+struct msm_camera_legacy_device_platform_data {
+	int sensor_reset;
+	int sensor_pwd;
+	int vcm_pwd;
+	void (*config_gpio_on) (void);
+	void (*config_gpio_off)(void);
+};
+#endif
+
+#define MSM_CAMERA_FLASH_NONE 0
+#define MSM_CAMERA_FLASH_LED  1
+
+struct msm_camera_sensor_info {
+	const char *sensor_name;
+	int sensor_reset;
+	int sensor_pwd;
+	int vcm_pwd;
+	int mclk;
+	int flash_type;
+	struct msm_camera_device_platform_data *pdata;
+};
+
 #endif
diff --git a/arch/arm/mach-msm/include/mach/camera.h b/arch/arm/mach-msm/include/mach/camera.h
new file mode 100644
index 0000000..c20f042
--- /dev/null
+++ b/arch/arm/mach-msm/include/mach/camera.h
@@ -0,0 +1,279 @@
+/*
+ * Copyright (C) 2008-2009 QUALCOMM Incorporated.
+ */
+
+#ifndef __ASM__ARCH_CAMERA_H
+#define __ASM__ARCH_CAMERA_H
+
+#include <linux/list.h>
+#include <linux/poll.h>
+#include <linux/cdev.h>
+#include <linux/platform_device.h>
+#include "linux/types.h"
+
+#include <mach/board.h>
+#include <media/msm_camera.h>
+
+#ifdef CONFIG_MSM_CAMERA_DEBUG
+#define CDBG(fmt, args...) printk(KERN_INFO "msm_camera: " fmt, ##args)
+#else
+#define CDBG(fmt, args...) do { } while (0)
+#endif
+
+#define MSM_CAMERA_MSG 0
+#define MSM_CAMERA_EVT 1
+#define NUM_WB_EXP_NEUTRAL_REGION_LINES 4
+#define NUM_WB_EXP_STAT_OUTPUT_BUFFERS  3
+#define NUM_AUTOFOCUS_MULTI_WINDOW_GRIDS 16
+#define NUM_AF_STAT_OUTPUT_BUFFERS      3
+
+enum msm_queue {
+	MSM_CAM_Q_CTRL,     /* control command or control command status */
+	MSM_CAM_Q_VFE_EVT,  /* adsp event */
+	MSM_CAM_Q_VFE_MSG,  /* adsp message */
+	MSM_CAM_Q_V4L2_REQ, /* v4l2 request */
+};
+
+enum vfe_resp_msg {
+	VFE_EVENT,
+	VFE_MSG_GENERAL,
+	VFE_MSG_SNAPSHOT,
+	VFE_MSG_OUTPUT1,
+	VFE_MSG_OUTPUT2,
+	VFE_MSG_STATS_AF,
+	VFE_MSG_STATS_WE,
+};
+
+struct msm_vfe_phy_info {
+	uint32_t sbuf_phy;
+	uint32_t y_phy;
+	uint32_t cbcr_phy;
+};
+
+struct msm_vfe_resp {
+	enum vfe_resp_msg type;
+	struct msm_vfe_evt_msg evt_msg;
+	struct msm_vfe_phy_info phy;
+	void    *extdata;
+	int32_t extlen;
+};
+
+struct msm_vfe_callback {
+	void (*vfe_resp)(struct msm_vfe_resp *,
+		enum msm_queue, void *syncdata);
+	void* (*vfe_alloc)(int, void *syncdata);
+};
+
+struct msm_camvfe_fn {
+	int (*vfe_init)(struct msm_vfe_callback *, struct platform_device *);
+	int (*vfe_enable)(struct camera_enable_cmd *);
+	int (*vfe_config)(struct msm_vfe_cfg_cmd *, void *);
+	int (*vfe_disable)(struct camera_enable_cmd *,
+		struct platform_device *dev);
+	void (*vfe_release)(struct platform_device *);
+};
+
+struct msm_sensor_ctrl {
+	int (*s_init)(const struct msm_camera_sensor_info *);
+	int (*s_release)(void);
+	int (*s_config)(void __user *);
+};
+
+struct msm_sync {
+	/* These two queues are accessed from a process context only. */
+	struct hlist_head frame; /* most-frequently accessed */
+	struct hlist_head stats;
+
+	/* The message queue is used by the control thread to send commands
+	 * to the config thread, and also by the DSP to send messages to the
+	 * config thread.  Thus it is the only queue that is accessed from
+	 * both interrupt and process context.
+	 */
+	spinlock_t msg_event_q_lock;
+	struct list_head msg_event_q;
+	wait_queue_head_t msg_event_wait;
+
+	/* This queue contains preview frames. It is accessed by the DSP (in
+	 * in interrupt context, and by the frame thread.
+	 */
+	spinlock_t prev_frame_q_lock;
+	struct list_head prev_frame_q;
+	wait_queue_head_t prev_frame_wait;
+	int unblock_poll_frame;
+
+	/* This queue contains snapshot frames.  It is accessed by the DSP (in
+	 * interrupt context, and by the control thread.
+	 */
+	spinlock_t pict_frame_q_lock;
+	struct list_head pict_frame_q;
+	wait_queue_head_t pict_frame_wait;
+
+	struct msm_camera_sensor_info *sdata;
+	struct msm_camvfe_fn vfefn;
+	struct msm_sensor_ctrl sctrl;
+	struct platform_device *pdev;
+	uint8_t opencnt;
+	void *cropinfo;
+	int  croplen;
+	unsigned pict_pp;
+
+	const char *apps_id;
+
+	struct mutex lock;
+	struct list_head list;
+};
+
+#define MSM_APPS_ID_V4L2 "msm_v4l2"
+#define MSM_APPS_ID_PROP "msm_qct"
+
+struct msm_device {
+	struct msm_sync *sync; /* most-frequently accessed */
+	struct device *device;
+	struct cdev cdev;
+	/* opened is meaningful only for the config and frame nodes,
+	 * which may be opened only once.
+	 */
+	atomic_t opened;
+};
+
+struct msm_control_device_queue {
+	spinlock_t ctrl_status_q_lock;
+	struct list_head ctrl_status_q;
+	wait_queue_head_t ctrl_status_wait;
+};
+
+struct msm_control_device {
+	struct msm_device *pmsm;
+
+	/* This queue used by the config thread to send responses back to the
+	 * control thread.  It is accessed only from a process context.
+	 */
+	struct msm_control_device_queue ctrl_q;
+};
+
+/* this structure is used in kernel */
+struct msm_queue_cmd {
+	struct list_head list;
+	enum msm_queue type;
+	void *command;
+};
+
+struct register_address_value_pair {
+	uint16_t register_address;
+	uint16_t register_value;
+};
+
+struct msm_pmem_region {
+	struct hlist_node list;
+	int type;
+	void *vaddr;
+	unsigned long paddr;
+	unsigned long len;
+	struct file *file;
+	uint32_t y_off;
+	uint32_t cbcr_off;
+	int fd;
+	uint8_t  active;
+};
+
+struct axidata {
+	uint32_t bufnum1;
+	uint32_t bufnum2;
+	struct msm_pmem_region *region;
+};
+
+#ifdef CONFIG_MSM_CAMERA_FLASH
+int msm_camera_flash_set_led_state(unsigned led_state);
+#else
+static inline int msm_camera_flash_set_led_state(unsigned led_state)
+{
+	return -ENOTSUPP;
+}
+#endif
+
+/* Below functions are added for V4L2 kernel APIs */
+struct msm_v4l2_driver {
+	struct msm_sync *sync;
+	int (*open)(struct msm_sync *, const char *apps_id);
+	int (*release)(struct msm_sync *);
+	int (*ctrl)(struct msm_sync *, struct msm_ctrl_cmd *);
+	int (*reg_pmem)(struct msm_sync *, struct msm_pmem_info *);
+	int (*get_frame) (struct msm_sync *, struct msm_frame *);
+	int (*put_frame) (struct msm_sync *, struct msm_frame *);
+	int (*get_pict) (struct msm_sync *, struct msm_ctrl_cmd *);
+	unsigned int (*drv_poll) (struct msm_sync *, struct file *,
+				struct poll_table_struct *);
+};
+
+int msm_v4l2_register(struct msm_v4l2_driver *);
+int msm_v4l2_unregister(struct msm_v4l2_driver *);
+
+void msm_camvfe_init(void);
+int msm_camvfe_check(void *);
+void msm_camvfe_fn_init(struct msm_camvfe_fn *, void *);
+int msm_camera_drv_start(struct platform_device *dev,
+		int (*sensor_probe)(const struct msm_camera_sensor_info *,
+					struct msm_sensor_ctrl *));
+
+enum msm_camio_clk_type {
+	CAMIO_VFE_MDC_CLK,
+	CAMIO_MDC_CLK,
+	CAMIO_VFE_CLK,
+	CAMIO_VFE_AXI_CLK,
+
+	CAMIO_MAX_CLK
+};
+
+enum msm_camio_clk_src_type {
+	MSM_CAMIO_CLK_SRC_INTERNAL,
+	MSM_CAMIO_CLK_SRC_EXTERNAL,
+	MSM_CAMIO_CLK_SRC_MAX
+};
+
+enum msm_s_test_mode {
+	S_TEST_OFF,
+	S_TEST_1,
+	S_TEST_2,
+	S_TEST_3
+};
+
+enum msm_s_resolution {
+	S_QTR_SIZE,
+	S_FULL_SIZE,
+	S_INVALID_SIZE
+};
+
+enum msm_s_reg_update {
+	/* Sensor egisters that need to be updated during initialization */
+	S_REG_INIT,
+	/* Sensor egisters that needs periodic I2C writes */
+	S_UPDATE_PERIODIC,
+	/* All the sensor Registers will be updated */
+	S_UPDATE_ALL,
+	/* Not valid update */
+	S_UPDATE_INVALID
+};
+
+enum msm_s_setting {
+	S_RES_PREVIEW,
+	S_RES_CAPTURE
+};
+
+int msm_camio_enable(struct platform_device *dev);
+
+int  msm_camio_clk_enable(enum msm_camio_clk_type clk);
+int  msm_camio_clk_disable(enum msm_camio_clk_type clk);
+int  msm_camio_clk_config(uint32_t freq);
+void msm_camio_clk_rate_set(int rate);
+void msm_camio_clk_axi_rate_set(int rate);
+
+void msm_camio_camif_pad_reg_reset(void);
+void msm_camio_camif_pad_reg_reset_2(void);
+
+void msm_camio_vfe_blk_reset(void);
+
+void msm_camio_clk_sel(enum msm_camio_clk_src_type);
+void msm_camio_disable(struct platform_device *);
+int msm_camio_probe_on(struct platform_device *);
+int msm_camio_probe_off(struct platform_device *);
+#endif
diff --git a/arch/arm/mach-msm/include/mach/gpio.h b/arch/arm/mach-msm/include/mach/gpio.h
new file mode 100644
index 0000000..590573f
--- /dev/null
+++ b/arch/arm/mach-msm/include/mach/gpio.h
@@ -0,0 +1,47 @@
+/* linux/include/asm-arm/arch-msm/gpio.h
+ *
+ * Copyright (C) 2007 Google, Inc.
+ * Author: Mike Lockwood <lockwood@android.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef __ASM_ARCH_MSM_GPIO_H
+#define __ASM_ARCH_MSM_GPIO_H
+
+#include <linux/interrupt.h>
+
+int gpio_request(unsigned gpio, const char *label);
+void gpio_free(unsigned gpio);
+int gpio_direction_input(unsigned gpio);
+int gpio_direction_output(unsigned gpio, int value);
+int gpio_get_value(unsigned gpio);
+void gpio_set_value(unsigned gpio, int value);
+int gpio_to_irq(unsigned gpio);
+
+#include <asm-generic/gpio.h>
+
+/* extended gpio api */
+
+#define GPIOF_IRQF_MASK         0x0000ffff /* use to specify edge detection without */
+#define GPIOF_IRQF_TRIGGER_NONE 0x00010000 /* IRQF_TRIGGER_NONE is 0 which also means "as already configured" */
+#define GPIOF_INPUT             0x00020000
+#define GPIOF_DRIVE_OUTPUT      0x00040000
+#define GPIOF_OUTPUT_LOW        0x00080000
+#define GPIOF_OUTPUT_HIGH       0x00100000
+
+#define GPIOIRQF_SHARED         0x00000001 /* the irq line is shared with other inputs */
+
+extern int gpio_configure(unsigned int gpio, unsigned long flags);
+extern int gpio_read_detect_status(unsigned int gpio);
+extern int gpio_clear_detect_status(unsigned int gpio);
+
+#endif
diff --git a/arch/arm/mach-msm/include/mach/msm_adsp.h b/arch/arm/mach-msm/include/mach/msm_adsp.h
new file mode 100644
index 0000000..a081683
--- /dev/null
+++ b/arch/arm/mach-msm/include/mach/msm_adsp.h
@@ -0,0 +1,112 @@
+/* include/asm-arm/arch-msm/msm_adsp.h
+ *
+ * Copyright (C) 2008 Google, Inc.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef __ASM__ARCH_MSM_ADSP_H
+#define __ASM__ARCH_MSM_ADSP_H
+
+struct msm_adsp_module;
+
+struct msm_adsp_ops {
+	/* event is called from interrupt context when a message
+	 * arrives from the DSP.  Use the provided function pointer
+	 * to copy the message into a local buffer.  Do NOT call
+	 * it multiple times.
+	 */
+	void (*event)(void *driver_data, unsigned id, size_t len,
+		      void (*getevent)(void *ptr, size_t len));
+};
+
+/* Get, Put, Enable, and Disable are synchronous and must only
+ * be called from thread context.  Enable and Disable will block
+ * up to one second in the event of a fatal DSP error but are
+ * much faster otherwise.
+ */
+int msm_adsp_get(const char *name, struct msm_adsp_module **module,
+		 struct msm_adsp_ops *ops, void *driver_data);
+void msm_adsp_put(struct msm_adsp_module *module);
+int msm_adsp_enable(struct msm_adsp_module *module);
+int msm_adsp_disable(struct msm_adsp_module *module);
+int adsp_set_clkrate(struct msm_adsp_module *module, unsigned long clk_rate);
+
+/* Write is safe to call from interrupt context.
+ */
+int msm_adsp_write(struct msm_adsp_module *module,
+		   unsigned queue_id,
+		   void *data, size_t len);
+
+#if CONFIG_MSM_AMSS_VERSION >= 6350
+/* Command Queue Indexes */
+#define QDSP_lpmCommandQueue              0
+#define QDSP_mpuAfeQueue                  1
+#define QDSP_mpuGraphicsCmdQueue          2
+#define QDSP_mpuModmathCmdQueue           3
+#define QDSP_mpuVDecCmdQueue              4
+#define QDSP_mpuVDecPktQueue              5
+#define QDSP_mpuVEncCmdQueue              6
+#define QDSP_rxMpuDecCmdQueue             7
+#define QDSP_rxMpuDecPktQueue             8
+#define QDSP_txMpuEncQueue                9
+#define QDSP_uPAudPPCmd1Queue             10
+#define QDSP_uPAudPPCmd2Queue             11
+#define QDSP_uPAudPPCmd3Queue             12
+#define QDSP_uPAudPlay0BitStreamCtrlQueue 13
+#define QDSP_uPAudPlay1BitStreamCtrlQueue 14
+#define QDSP_uPAudPlay2BitStreamCtrlQueue 15
+#define QDSP_uPAudPlay3BitStreamCtrlQueue 16
+#define QDSP_uPAudPlay4BitStreamCtrlQueue 17
+#define QDSP_uPAudPreProcCmdQueue         18
+#define QDSP_uPAudRecBitStreamQueue       19
+#define QDSP_uPAudRecCmdQueue             20
+#define QDSP_uPDiagQueue                  21
+#define QDSP_uPJpegActionCmdQueue         22
+#define QDSP_uPJpegCfgCmdQueue            23
+#define QDSP_uPVocProcQueue               24
+#define QDSP_vfeCommandQueue              25
+#define QDSP_vfeCommandScaleQueue         26
+#define QDSP_vfeCommandTableQueue         27
+#define QDSP_MAX_NUM_QUEUES               28
+#else
+/* Command Queue Indexes */
+#define QDSP_lpmCommandQueue              0
+#define QDSP_mpuAfeQueue                  1
+#define QDSP_mpuGraphicsCmdQueue          2
+#define QDSP_mpuModmathCmdQueue           3
+#define QDSP_mpuVDecCmdQueue              4
+#define QDSP_mpuVDecPktQueue              5
+#define QDSP_mpuVEncCmdQueue              6
+#define QDSP_rxMpuDecCmdQueue             7
+#define QDSP_rxMpuDecPktQueue             8
+#define QDSP_txMpuEncQueue                9
+#define QDSP_uPAudPPCmd1Queue             10
+#define QDSP_uPAudPPCmd2Queue             11
+#define QDSP_uPAudPPCmd3Queue             12
+#define QDSP_uPAudPlay0BitStreamCtrlQueue 13
+#define QDSP_uPAudPlay1BitStreamCtrlQueue 14
+#define QDSP_uPAudPlay2BitStreamCtrlQueue 15
+#define QDSP_uPAudPlay3BitStreamCtrlQueue 16
+#define QDSP_uPAudPlay4BitStreamCtrlQueue 17
+#define QDSP_uPAudPreProcCmdQueue         18
+#define QDSP_uPAudRecBitStreamQueue       19
+#define QDSP_uPAudRecCmdQueue             20
+#define QDSP_uPJpegActionCmdQueue         21
+#define QDSP_uPJpegCfgCmdQueue            22
+#define QDSP_uPVocProcQueue               23
+#define QDSP_vfeCommandQueue              24
+#define QDSP_vfeCommandScaleQueue         25
+#define QDSP_vfeCommandTableQueue         26
+#define QDSP_QUEUE_MAX                    26
+#endif
+
+#endif
diff --git a/drivers/staging/dream/camera/msm_camera.c b/drivers/staging/dream/camera/msm_camera.c
index 8816599..423fa7e 100644
--- a/drivers/staging/dream/camera/msm_camera.c
+++ b/drivers/staging/dream/camera/msm_camera.c
@@ -1597,7 +1597,6 @@ static int __msm_release(struct msm_sync *sync)
 		MSM_DRAIN_QUEUE(sync, pict_frame_q);
 
 		sync->sctrl.s_release();
-		wake_unlock(&sync->wake_lock);
 
 		sync->apps_id = NULL;
 		CDBG("msm_release completed!\n");
@@ -1806,7 +1805,6 @@ static int __msm_open(struct msm_sync *sync, const char *const apps_id)
 	sync->apps_id = apps_id;
 
 	if (!sync->opencnt) {
-		wake_lock(&sync->wake_lock);
 
 		msm_camvfe_fn_init(&sync->vfefn, sync);
 		if (sync->vfefn.vfe_init) {
@@ -2044,8 +2042,6 @@ static int msm_sync_init(struct msm_sync *sync,
 	INIT_LIST_HEAD(&sync->pict_frame_q);
 	init_waitqueue_head(&sync->pict_frame_wait);
 
-	wake_lock_init(&sync->wake_lock, WAKE_LOCK_IDLE, "msm_camera");
-
 	rc = msm_camio_probe_on(pdev);
 	if (rc < 0)
 		return rc;
@@ -2058,7 +2054,6 @@ static int msm_sync_init(struct msm_sync *sync,
 	if (rc < 0) {
 		pr_err("msm_camera: failed to initialize %s\n",
 			sync->sdata->sensor_name);
-		wake_lock_destroy(&sync->wake_lock);
 		return rc;
 	}
 
@@ -2070,7 +2065,6 @@ static int msm_sync_init(struct msm_sync *sync,
 
 static int msm_sync_destroy(struct msm_sync *sync)
 {
-	wake_lock_destroy(&sync->wake_lock);
 	return 0;
 }
 
diff --git a/include/linux/android_pmem.h b/include/linux/android_pmem.h
new file mode 100644
index 0000000..d845483
--- /dev/null
+++ b/include/linux/android_pmem.h
@@ -0,0 +1,80 @@
+/* include/linux/android_pmem.h
+ *
+ * Copyright (C) 2007 Google, Inc.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of 
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef _ANDROID_PMEM_H_
+#define _ANDROID_PMEM_H_
+
+#define PMEM_IOCTL_MAGIC 'p'
+#define PMEM_GET_PHYS		_IOW(PMEM_IOCTL_MAGIC, 1, unsigned int)
+#define PMEM_MAP		_IOW(PMEM_IOCTL_MAGIC, 2, unsigned int)
+#define PMEM_GET_SIZE		_IOW(PMEM_IOCTL_MAGIC, 3, unsigned int)
+#define PMEM_UNMAP		_IOW(PMEM_IOCTL_MAGIC, 4, unsigned int)
+/* This ioctl will allocate pmem space, backing the file, it will fail
+ * if the file already has an allocation, pass it the len as the argument
+ * to the ioctl */
+#define PMEM_ALLOCATE		_IOW(PMEM_IOCTL_MAGIC, 5, unsigned int)
+/* This will connect a one pmem file to another, pass the file that is already
+ * backed in memory as the argument to the ioctl
+ */
+#define PMEM_CONNECT		_IOW(PMEM_IOCTL_MAGIC, 6, unsigned int)
+/* Returns the total size of the pmem region it is sent to as a pmem_region
+ * struct (with offset set to 0). 
+ */
+#define PMEM_GET_TOTAL_SIZE	_IOW(PMEM_IOCTL_MAGIC, 7, unsigned int)
+/* Revokes gpu registers and resets the gpu.  Pass a pointer to the
+ * start of the mapped gpu regs (the vaddr returned by mmap) as the argument.
+ */
+#define HW3D_REVOKE_GPU		_IOW(PMEM_IOCTL_MAGIC, 8, unsigned int)
+#define HW3D_GRANT_GPU		_IOW(PMEM_IOCTL_MAGIC, 9, unsigned int)
+#define HW3D_WAIT_FOR_INTERRUPT	_IOW(PMEM_IOCTL_MAGIC, 10, unsigned int)
+
+int get_pmem_file(int fd, unsigned long *start, unsigned long *vstart,
+		  unsigned long *end, struct file **filp);
+int get_pmem_user_addr(struct file *file, unsigned long *start,
+		       unsigned long *end);
+void put_pmem_file(struct file* file);
+void flush_pmem_file(struct file *file, unsigned long start, unsigned long len);
+
+struct android_pmem_platform_data
+{
+	const char* name;
+	/* starting physical address of memory region */
+	unsigned long start;
+	/* size of memory region */
+	unsigned long size;
+	/* set to indicate the region should not be managed with an allocator */
+	unsigned no_allocator;
+	/* set to indicate maps of this region should be cached, if a mix of
+	 * cached and uncached is desired, set this and open the device with
+	 * O_SYNC to get an uncached region */
+	unsigned cached;
+	/* The MSM7k has bits to enable a write buffer in the bus controller*/
+	unsigned buffered;
+};
+
+struct pmem_region {
+	unsigned long offset;
+	unsigned long len;
+};
+
+int pmem_setup(struct android_pmem_platform_data *pdata,
+	       long (*ioctl)(struct file *, unsigned int, unsigned long),
+	       int (*release)(struct inode *, struct file *));
+
+int pmem_remap(struct pmem_region *region, struct file *file,
+	       unsigned operation);
+
+#endif //_ANDROID_PPP_H_
+
diff --git a/include/linux/msm_adsp.h b/include/linux/msm_adsp.h
new file mode 100644
index 0000000..12f219e
--- /dev/null
+++ b/include/linux/msm_adsp.h
@@ -0,0 +1,84 @@
+/* include/linux/msm_adsp.h
+ *
+ * Copyright (c) QUALCOMM Incorporated
+ * Copyright (C) 2007 Google, Inc.
+ * Author: Iliyan Malchev <ibm@android.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+#ifndef __LINUX_MSM_ADSP_H
+#define __LINUX_MSM_ADSP_H
+
+#include <linux/types.h>
+#include <linux/ioctl.h>
+
+#define ADSP_IOCTL_MAGIC 'q'
+
+/* ADSP_IOCTL_WRITE_COMMAND */
+struct adsp_command_t {
+	uint16_t queue;
+	uint32_t len;		/* bytes */
+	uint8_t *data;
+};
+
+/* ADSP_IOCTL_GET_EVENT */
+struct adsp_event_t {
+	uint16_t type;		/* 1 == event (RPC), 0 == message (adsp) */
+	uint32_t timeout_ms;	/* -1 for infinite, 0 for immediate return */
+	uint16_t msg_id;
+	uint16_t flags;		/* 1 == 16--bit event, 0 == 32-bit event */
+	uint32_t len;		/* size in, number of bytes out */
+	uint8_t *data;
+};
+
+#define ADSP_IOCTL_ENABLE \
+	_IOR(ADSP_IOCTL_MAGIC, 1, unsigned)
+
+#define ADSP_IOCTL_DISABLE \
+	_IOR(ADSP_IOCTL_MAGIC, 2, unsigned)
+
+#define ADSP_IOCTL_DISABLE_ACK \
+	_IOR(ADSP_IOCTL_MAGIC, 3, unsigned)
+
+#define ADSP_IOCTL_WRITE_COMMAND \
+	_IOR(ADSP_IOCTL_MAGIC, 4, struct adsp_command_t *)
+
+#define ADSP_IOCTL_GET_EVENT \
+	_IOWR(ADSP_IOCTL_MAGIC, 5, struct adsp_event_data_t *)
+
+#define ADSP_IOCTL_SET_CLKRATE \
+	_IOR(ADSP_IOCTL_MAGIC, 6, unsigned)
+
+#define ADSP_IOCTL_DISABLE_EVENT_RSP \
+	_IOR(ADSP_IOCTL_MAGIC, 10, unsigned)
+
+struct adsp_pmem_info {
+        int fd;
+        void *vaddr;
+};
+
+#define ADSP_IOCTL_REGISTER_PMEM \
+	_IOW(ADSP_IOCTL_MAGIC, 13, unsigned)
+
+#define ADSP_IOCTL_UNREGISTER_PMEM \
+	_IOW(ADSP_IOCTL_MAGIC, 14, unsigned)
+
+/* Cause any further GET_EVENT ioctls to fail (-ENODEV)
+ * until the device is closed and reopened.  Useful for
+ * terminating event dispatch threads
+ */
+#define ADSP_IOCTL_ABORT_EVENT_READ \
+	_IOW(ADSP_IOCTL_MAGIC, 15, unsigned)
+
+#define ADSP_IOCTL_LINK_TASK \
+	_IOW(ADSP_IOCTL_MAGIC, 16, unsigned)
+
+#endif
diff --git a/include/media/msm_camera.h b/include/media/msm_camera.h
new file mode 100644
index 0000000..09812d6
--- /dev/null
+++ b/include/media/msm_camera.h
@@ -0,0 +1,388 @@
+/*
+ * Copyright (C) 2008-2009 QUALCOMM Incorporated.
+ */
+#ifndef __LINUX_MSM_CAMERA_H
+#define __LINUX_MSM_CAMERA_H
+
+#include <linux/types.h>
+#include <asm/sizes.h>
+#include <linux/ioctl.h>
+
+#define MSM_CAM_IOCTL_MAGIC 'm'
+
+#define MSM_CAM_IOCTL_GET_SENSOR_INFO \
+	_IOR(MSM_CAM_IOCTL_MAGIC, 1, struct msm_camsensor_info *)
+
+#define MSM_CAM_IOCTL_REGISTER_PMEM \
+	_IOW(MSM_CAM_IOCTL_MAGIC, 2, struct msm_pmem_info *)
+
+#define MSM_CAM_IOCTL_UNREGISTER_PMEM \
+	_IOW(MSM_CAM_IOCTL_MAGIC, 3, unsigned)
+
+#define MSM_CAM_IOCTL_CTRL_COMMAND \
+	_IOW(MSM_CAM_IOCTL_MAGIC, 4, struct msm_ctrl_cmd *)
+
+#define MSM_CAM_IOCTL_CONFIG_VFE  \
+	_IOW(MSM_CAM_IOCTL_MAGIC, 5, struct msm_camera_vfe_cfg_cmd *)
+
+#define MSM_CAM_IOCTL_GET_STATS \
+	_IOR(MSM_CAM_IOCTL_MAGIC, 6, struct msm_camera_stats_event_ctrl *)
+
+#define MSM_CAM_IOCTL_GETFRAME \
+	_IOR(MSM_CAM_IOCTL_MAGIC, 7, struct msm_camera_get_frame *)
+
+#define MSM_CAM_IOCTL_ENABLE_VFE \
+	_IOW(MSM_CAM_IOCTL_MAGIC, 8, struct camera_enable_cmd *)
+
+#define MSM_CAM_IOCTL_CTRL_CMD_DONE \
+	_IOW(MSM_CAM_IOCTL_MAGIC, 9, struct camera_cmd *)
+
+#define MSM_CAM_IOCTL_CONFIG_CMD \
+	_IOW(MSM_CAM_IOCTL_MAGIC, 10, struct camera_cmd *)
+
+#define MSM_CAM_IOCTL_DISABLE_VFE \
+	_IOW(MSM_CAM_IOCTL_MAGIC, 11, struct camera_enable_cmd *)
+
+#define MSM_CAM_IOCTL_PAD_REG_RESET2 \
+	_IOW(MSM_CAM_IOCTL_MAGIC, 12, struct camera_enable_cmd *)
+
+#define MSM_CAM_IOCTL_VFE_APPS_RESET \
+	_IOW(MSM_CAM_IOCTL_MAGIC, 13, struct camera_enable_cmd *)
+
+#define MSM_CAM_IOCTL_RELEASE_FRAME_BUFFER \
+	_IOW(MSM_CAM_IOCTL_MAGIC, 14, struct camera_enable_cmd *)
+
+#define MSM_CAM_IOCTL_RELEASE_STATS_BUFFER \
+	_IOW(MSM_CAM_IOCTL_MAGIC, 15, struct msm_stats_buf *)
+
+#define MSM_CAM_IOCTL_AXI_CONFIG \
+	_IOW(MSM_CAM_IOCTL_MAGIC, 16, struct msm_camera_vfe_cfg_cmd *)
+
+#define MSM_CAM_IOCTL_GET_PICTURE \
+	_IOW(MSM_CAM_IOCTL_MAGIC, 17, struct msm_camera_ctrl_cmd *)
+
+#define MSM_CAM_IOCTL_SET_CROP \
+	_IOW(MSM_CAM_IOCTL_MAGIC, 18, struct crop_info *)
+
+#define MSM_CAM_IOCTL_PICT_PP \
+	_IOW(MSM_CAM_IOCTL_MAGIC, 19, uint8_t *)
+
+#define MSM_CAM_IOCTL_PICT_PP_DONE \
+	_IOW(MSM_CAM_IOCTL_MAGIC, 20, struct msm_snapshot_pp_status *)
+
+#define MSM_CAM_IOCTL_SENSOR_IO_CFG \
+	_IOW(MSM_CAM_IOCTL_MAGIC, 21, struct sensor_cfg_data *)
+
+#define MSM_CAMERA_LED_OFF  0
+#define MSM_CAMERA_LED_LOW  1
+#define MSM_CAMERA_LED_HIGH 2
+
+#define MSM_CAM_IOCTL_FLASH_LED_CFG \
+	_IOW(MSM_CAM_IOCTL_MAGIC, 22, unsigned *)
+
+#define MSM_CAM_IOCTL_UNBLOCK_POLL_FRAME \
+	_IO(MSM_CAM_IOCTL_MAGIC, 23)
+
+#define MSM_CAM_IOCTL_CTRL_COMMAND_2 \
+	_IOW(MSM_CAM_IOCTL_MAGIC, 24, struct msm_ctrl_cmd *)
+
+#define MAX_SENSOR_NUM  3
+#define MAX_SENSOR_NAME 32
+
+#define MSM_CAM_CTRL_CMD_DONE  0
+#define MSM_CAM_SENSOR_VFE_CMD 1
+
+/*****************************************************
+ *  structure
+ *****************************************************/
+
+/* define five type of structures for userspace <==> kernel
+ * space communication:
+ * command 1 - 2 are from userspace ==> kernel
+ * command 3 - 4 are from kernel ==> userspace
+ *
+ * 1. control command: control command(from control thread),
+ *                     control status (from config thread);
+ */
+struct msm_ctrl_cmd {
+	uint16_t type;
+	uint16_t length;
+	void *value;
+	uint16_t status;
+	uint32_t timeout_ms;
+	int resp_fd; /* FIXME: to be used by the kernel, pass-through for now */
+};
+
+struct msm_vfe_evt_msg {
+	unsigned short type; /* 1 == event (RPC), 0 == message (adsp) */
+	unsigned short msg_id;
+	unsigned int len; /* size in, number of bytes out */
+	void *data;
+};
+
+#define MSM_CAM_RESP_CTRL         0
+#define MSM_CAM_RESP_STAT_EVT_MSG 1
+#define MSM_CAM_RESP_V4L2         2
+#define MSM_CAM_RESP_MAX          3
+
+/* this one is used to send ctrl/status up to config thread */
+struct msm_stats_event_ctrl {
+	/* 0 - ctrl_cmd from control thread,
+	 * 1 - stats/event kernel,
+	 * 2 - V4L control or read request */
+	int resptype;
+	int timeout_ms;
+	struct msm_ctrl_cmd ctrl_cmd;
+	/* struct  vfe_event_t  stats_event; */
+	struct msm_vfe_evt_msg stats_event;
+};
+
+/* 2. config command: config command(from config thread); */
+struct msm_camera_cfg_cmd {
+	/* what to config:
+	 * 1 - sensor config, 2 - vfe config */
+	uint16_t cfg_type;
+
+	/* sensor config type */
+	uint16_t cmd_type;
+	uint16_t queue;
+	uint16_t length;
+	void *value;
+};
+
+#define CMD_GENERAL			0
+#define CMD_AXI_CFG_OUT1		1
+#define CMD_AXI_CFG_SNAP_O1_AND_O2	2
+#define CMD_AXI_CFG_OUT2		3
+#define CMD_PICT_T_AXI_CFG		4
+#define CMD_PICT_M_AXI_CFG		5
+#define CMD_RAW_PICT_AXI_CFG		6
+#define CMD_STATS_AXI_CFG		7
+#define CMD_STATS_AF_AXI_CFG		8
+#define CMD_FRAME_BUF_RELEASE		9
+#define CMD_PREV_BUF_CFG		10
+#define CMD_SNAP_BUF_RELEASE		11
+#define CMD_SNAP_BUF_CFG		12
+#define CMD_STATS_DISABLE		13
+#define CMD_STATS_ENABLE		14
+#define CMD_STATS_AF_ENABLE		15
+#define CMD_STATS_BUF_RELEASE		16
+#define CMD_STATS_AF_BUF_RELEASE	17
+#define UPDATE_STATS_INVALID		18
+
+/* vfe config command: config command(from config thread)*/
+struct msm_vfe_cfg_cmd {
+	int cmd_type;
+	uint16_t length;
+	void *value;
+};
+
+#define MAX_CAMERA_ENABLE_NAME_LEN 32
+struct camera_enable_cmd {
+	char name[MAX_CAMERA_ENABLE_NAME_LEN];
+};
+
+#define MSM_PMEM_OUTPUT1		0
+#define MSM_PMEM_OUTPUT2		1
+#define MSM_PMEM_OUTPUT1_OUTPUT2	2
+#define MSM_PMEM_THUMBAIL		3
+#define MSM_PMEM_MAINIMG		4
+#define MSM_PMEM_RAW_MAINIMG		5
+#define MSM_PMEM_AEC_AWB		6
+#define MSM_PMEM_AF			7
+#define MSM_PMEM_MAX			8
+
+#define FRAME_PREVIEW_OUTPUT1		0
+#define FRAME_PREVIEW_OUTPUT2		1
+#define FRAME_SNAPSHOT			2
+#define FRAME_THUMBAIL			3
+#define FRAME_RAW_SNAPSHOT		4
+#define FRAME_MAX			5
+
+struct msm_pmem_info {
+	int type;
+	int fd;
+	void *vaddr;
+	uint32_t y_off;
+	uint32_t cbcr_off;
+	uint8_t active;
+};
+
+struct outputCfg {
+	uint32_t height;
+	uint32_t width;
+
+	uint32_t window_height_firstline;
+	uint32_t window_height_lastline;
+};
+
+#define OUTPUT_1	0
+#define OUTPUT_2	1
+#define OUTPUT_1_AND_2	2
+#define CAMIF_TO_AXI_VIA_OUTPUT_2		3
+#define OUTPUT_1_AND_CAMIF_TO_AXI_VIA_OUTPUT_2	4
+#define OUTPUT_2_AND_CAMIF_TO_AXI_VIA_OUTPUT_1	5
+#define LAST_AXI_OUTPUT_MODE_ENUM = OUTPUT_2_AND_CAMIF_TO_AXI_VIA_OUTPUT_1 6
+
+#define MSM_FRAME_PREV_1	0
+#define MSM_FRAME_PREV_2	1
+#define MSM_FRAME_ENC		2
+
+struct msm_frame {
+	int path;
+	unsigned long buffer;
+	uint32_t y_off;
+	uint32_t cbcr_off;
+	int fd;
+
+	void *cropinfo;
+	int croplen;
+};
+
+#define STAT_AEAW	0
+#define STAT_AF		1
+#define STAT_MAX	2
+
+struct msm_stats_buf {
+	int type;
+	unsigned long buffer;
+	int fd;
+};
+
+#define MSM_V4L2_VID_CAP_TYPE	0
+#define MSM_V4L2_STREAM_ON	1
+#define MSM_V4L2_STREAM_OFF	2
+#define MSM_V4L2_SNAPSHOT	3
+#define MSM_V4L2_QUERY_CTRL	4
+#define MSM_V4L2_GET_CTRL	5
+#define MSM_V4L2_SET_CTRL	6
+#define MSM_V4L2_QUERY		7
+#define MSM_V4L2_MAX		8
+
+struct crop_info {
+	void *info;
+	int len;
+};
+
+struct msm_postproc {
+	int ftnum;
+	struct msm_frame fthumnail;
+	int fmnum;
+	struct msm_frame fmain;
+};
+
+struct msm_snapshot_pp_status {
+	void *status;
+};
+
+#define CFG_SET_MODE			0
+#define CFG_SET_EFFECT			1
+#define CFG_START			2
+#define CFG_PWR_UP			3
+#define CFG_PWR_DOWN			4
+#define CFG_WRITE_EXPOSURE_GAIN		5
+#define CFG_SET_DEFAULT_FOCUS		6
+#define CFG_MOVE_FOCUS			7
+#define CFG_REGISTER_TO_REAL_GAIN	8
+#define CFG_REAL_TO_REGISTER_GAIN	9
+#define CFG_SET_FPS			10
+#define CFG_SET_PICT_FPS		11
+#define CFG_SET_BRIGHTNESS		12
+#define CFG_SET_CONTRAST		13
+#define CFG_SET_ZOOM			14
+#define CFG_SET_EXPOSURE_MODE		15
+#define CFG_SET_WB			16
+#define CFG_SET_ANTIBANDING		17
+#define CFG_SET_EXP_GAIN		18
+#define CFG_SET_PICT_EXP_GAIN		19
+#define CFG_SET_LENS_SHADING		20
+#define CFG_GET_PICT_FPS		21
+#define CFG_GET_PREV_L_PF		22
+#define CFG_GET_PREV_P_PL		23
+#define CFG_GET_PICT_L_PF		24
+#define CFG_GET_PICT_P_PL		25
+#define CFG_GET_AF_MAX_STEPS		26
+#define CFG_GET_PICT_MAX_EXP_LC		27
+#define CFG_MAX				28
+
+#define MOVE_NEAR	0
+#define MOVE_FAR	1
+
+#define SENSOR_PREVIEW_MODE		0
+#define SENSOR_SNAPSHOT_MODE		1
+#define SENSOR_RAW_SNAPSHOT_MODE	2
+
+#define SENSOR_QTR_SIZE			0
+#define SENSOR_FULL_SIZE		1
+#define SENSOR_INVALID_SIZE		2
+
+#define CAMERA_EFFECT_OFF		0
+#define CAMERA_EFFECT_MONO		1
+#define CAMERA_EFFECT_NEGATIVE		2
+#define CAMERA_EFFECT_SOLARIZE		3
+#define CAMERA_EFFECT_PASTEL		4
+#define CAMERA_EFFECT_MOSAIC		5
+#define CAMERA_EFFECT_RESIZE		6
+#define CAMERA_EFFECT_SEPIA		7
+#define CAMERA_EFFECT_POSTERIZE		8
+#define CAMERA_EFFECT_WHITEBOARD	9
+#define CAMERA_EFFECT_BLACKBOARD	10
+#define CAMERA_EFFECT_AQUA		11
+#define CAMERA_EFFECT_MAX		12
+
+struct sensor_pict_fps {
+	uint16_t prevfps;
+	uint16_t pictfps;
+};
+
+struct exp_gain_cfg {
+	uint16_t gain;
+	uint32_t line;
+};
+
+struct focus_cfg {
+	int32_t steps;
+	int dir;
+};
+
+struct fps_cfg {
+	uint16_t f_mult;
+	uint16_t fps_div;
+	uint32_t pict_fps_div;
+};
+
+struct sensor_cfg_data {
+	int cfgtype;
+	int mode;
+	int rs;
+	uint8_t max_steps;
+
+	union {
+		int8_t effect;
+		uint8_t lens_shading;
+		uint16_t prevl_pf;
+		uint16_t prevp_pl;
+		uint16_t pictl_pf;
+		uint16_t pictp_pl;
+		uint32_t pict_max_exp_lc;
+		uint16_t p_fps;
+		struct sensor_pict_fps gfps;
+		struct exp_gain_cfg exp_gain;
+		struct focus_cfg focus;
+		struct fps_cfg fps;
+	} cfg;
+};
+
+#define GET_NAME			0
+#define GET_PREVIEW_LINE_PER_FRAME	1
+#define GET_PREVIEW_PIXELS_PER_LINE	2
+#define GET_SNAPSHOT_LINE_PER_FRAME	3
+#define GET_SNAPSHOT_PIXELS_PER_LINE	4
+#define GET_SNAPSHOT_FPS		5
+#define GET_SNAPSHOT_MAX_EP_LINE_CNT	6
+
+struct msm_camsensor_info {
+	char name[MAX_SENSOR_NAME];
+	uint8_t flash_enabled;
+};
+#endif /* __LINUX_MSM_CAMERA_H */


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
