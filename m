Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751684Ab0BYFIH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 00:08:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20706 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231Ab0BYFIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 00:08:00 -0500
From: Dave Airlie <airlied@gmail.com>
To: linux-fbdev@vger.kernel.org
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       Dave Airlie <airlied@linux.ie>
Subject: [PATCH 2/2] vga_switcheroo: initial implementation (v8)
Date: Thu, 25 Feb 2010 15:07:56 +1000
Message-Id: <1267074476-28347-3-git-send-email-airlied@gmail.com>
In-Reply-To: <1267074476-28347-2-git-send-email-airlied@gmail.com>
References: <1267074476-28347-1-git-send-email-airlied@gmail.com>
 <1267074476-28347-2-git-send-email-airlied@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Airlie <airlied@linux.ie>

Many new laptops now come with 2 gpus, one to be used for low power
modes and one for gaming/on-ac applications. These GPUs are typically
wired to the laptop panel and VGA ports via a multiplexer unit which
is controlled via ACPI methods.

4 combinations of systems typically exist - with 2 ACPI methods.
Intel/ATI - Lenovo W500/T500 - use ATPX ACPI method
ATI/ATI - some ASUS - use ATPX ACPI Method
Intel/Nvidia - - use _DSM ACPI method
Nvidia/Nvidia -  - use _DSM ACPI method.

TODO:
This patch adds support for the ATPX method and initial bits
for the _DSM methods that need to written by someone with
access to the hardware.
Add a proper non-debugfs interface - need to get some proper
testing first.

v2: add power up/down support for both devices
on W500 puts i915/radeon into D3 and cuts power to radeon.

v3: redo probing methods, no DMI list, drm devices call to
register with switcheroo, it tries to find an ATPX method on
any device and once there is two devices + ATPX it inits the
switcher.

v4: ATPX msg handling using buffers - should work on more machines

v5: rearchitect after more mjg59 discussion - move ATPX handling to
    radeon driver.

v6: add file headers + initial nouveau bits (to be filled out).

v7: merge delayed switcher code.

v8: avoid suspend/resume of gpu that is off

mount debugfs

/sys/kernel/debug/vgaswitcheroo/switch - should exist if ATPX detected
 + 2 cards.

DIS - immediate change to discrete
IGD - immediate change to IGD
DDIS - delayed change to discrete
DIGD - delayed change to IGD
ON - turn on not in use
OFF - turn off not in use

Tested on W500 (Intel/ATI) and T500 (Intel/ATI)

Signed-off-by: Dave Airlie <airlied@redhat.com>
---
 drivers/gpu/drm/i915/i915_dma.c              |   32 ++
 drivers/gpu/drm/i915/i915_drv.c              |    4 +-
 drivers/gpu/drm/i915/i915_drv.h              |    2 +
 drivers/gpu/drm/i915/intel_fb.c              |    3 +
 drivers/gpu/drm/nouveau/nouveau_acpi.c       |   31 ++
 drivers/gpu/drm/nouveau/nouveau_drv.c        |    4 +-
 drivers/gpu/drm/nouveau/nouveau_drv.h        |    3 +
 drivers/gpu/drm/nouveau/nouveau_fbcon.c      |    3 +
 drivers/gpu/drm/nouveau/nouveau_state.c      |   27 ++
 drivers/gpu/drm/radeon/Makefile              |    3 +-
 drivers/gpu/drm/radeon/r600_audio.c          |    3 +
 drivers/gpu/drm/radeon/radeon.h              |    4 +
 drivers/gpu/drm/radeon/radeon_atpx_handler.c |  132 +++++++
 drivers/gpu/drm/radeon/radeon_bios.c         |   10 +-
 drivers/gpu/drm/radeon/radeon_device.c       |   41 +++
 drivers/gpu/drm/radeon/radeon_drv.c          |    4 +-
 drivers/gpu/drm/radeon/radeon_drv.h          |    3 +
 drivers/gpu/drm/radeon/radeon_fb.c           |    3 +
 drivers/gpu/drm/radeon/radeon_kms.c          |    3 +
 drivers/gpu/vga/Kconfig                      |   11 +
 drivers/gpu/vga/Makefile                     |    1 +
 drivers/gpu/vga/vga_switcheroo.c             |  472 ++++++++++++++++++++++++++
 drivers/video/console/fbcon.c                |   18 +
 include/linux/fb.h                           |    2 +
 include/linux/vga_switcheroo.h               |   65 ++++
 25 files changed, 872 insertions(+), 12 deletions(-)
 create mode 100644 drivers/gpu/drm/radeon/radeon_atpx_handler.c
 create mode 100644 drivers/gpu/vga/vga_switcheroo.c
 create mode 100644 include/linux/vga_switcheroo.h

diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index 2307f98..fb91532 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -35,6 +35,7 @@
 #include "i915_drv.h"
 #include "i915_trace.h"
 #include <linux/vgaarb.h>
+#include <linux/vga_switcheroo.h>
 
 /* Really want an OS-independent resettable timer.  Would like to have
  * this loop run for (eg) 3 sec, but have the timer reset every time
@@ -1199,6 +1200,30 @@ static unsigned int i915_vga_set_decode(void *cookie, bool state)
 		return VGA_RSRC_NORMAL_IO | VGA_RSRC_NORMAL_MEM;
 }
 
+static void i915_switcheroo_set_state(struct pci_dev *pdev, enum vga_switcheroo_state state)
+{
+	struct drm_device *dev = pci_get_drvdata(pdev);
+	pm_message_t pmm = { .event = PM_EVENT_SUSPEND };
+	if (state == VGA_SWITCHEROO_ON) {
+		printk(KERN_ERR "VGA switched i915 on\n");
+		i915_resume(dev);
+	} else {
+		printk(KERN_ERR "VGA switched i915 off\n");
+		i915_suspend(dev, pmm);
+	}
+}
+
+static bool i915_switcheroo_can_switch(struct pci_dev *pdev)
+{
+	struct drm_device *dev = pci_get_drvdata(pdev);
+	bool can_switch;
+
+	spin_lock(&dev->count_lock);
+	can_switch = (dev->open_count == 0);
+	spin_unlock(&dev->count_lock);
+	return can_switch;
+}
+
 static int i915_load_modeset_init(struct drm_device *dev,
 				  unsigned long prealloc_start,
 				  unsigned long prealloc_size,
@@ -1260,6 +1285,12 @@ static int i915_load_modeset_init(struct drm_device *dev,
 	if (ret)
 		goto destroy_ringbuffer;
 
+	ret = vga_switcheroo_register_client(dev->pdev,
+					     i915_switcheroo_set_state,
+					     i915_switcheroo_can_switch);
+	if (ret)
+		goto destroy_ringbuffer;
+
 	intel_modeset_init(dev);
 
 	ret = drm_irq_install(dev);
@@ -1611,6 +1642,7 @@ void i915_driver_lastclose(struct drm_device * dev)
 
 	if (!dev_priv || drm_core_check_feature(dev, DRIVER_MODESET)) {
 		drm_fb_helper_restore();
+		vga_switcheroo_process_delayed_switch();
 		return;
 	}
 
diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
index cf4cb3e..fd739ef 100644
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -201,7 +201,7 @@ static int i915_drm_freeze(struct drm_device *dev)
 	return 0;
 }
 
-static int i915_suspend(struct drm_device *dev, pm_message_t state)
+int i915_suspend(struct drm_device *dev, pm_message_t state)
 {
 	int error;
 
@@ -255,7 +255,7 @@ static int i915_drm_thaw(struct drm_device *dev)
 	return error;
 }
 
-static int i915_resume(struct drm_device *dev)
+int i915_resume(struct drm_device *dev)
 {
 	if (pci_enable_device(dev->pdev))
 		return -EIO;
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index b99b6a8..d77e566 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -736,6 +736,8 @@ extern unsigned int i915_fbpercrtc;
 extern unsigned int i915_powersave;
 extern unsigned int i915_lvds_downclock;
 
+extern int i915_suspend(struct drm_device *dev, pm_message_t state);
+extern int i915_resume(struct drm_device *dev);
 extern void i915_save_display(struct drm_device *dev);
 extern void i915_restore_display(struct drm_device *dev);
 extern int i915_master_create(struct drm_device *dev, struct drm_master *master);
diff --git a/drivers/gpu/drm/i915/intel_fb.c b/drivers/gpu/drm/i915/intel_fb.c
index aaabbcb..6d370c2 100644
--- a/drivers/gpu/drm/i915/intel_fb.c
+++ b/drivers/gpu/drm/i915/intel_fb.c
@@ -35,6 +35,7 @@
 #include <linux/delay.h>
 #include <linux/fb.h>
 #include <linux/init.h>
+#include <linux/vga_switcheroo.h>
 
 #include "drmP.h"
 #include "drm.h"
@@ -234,6 +235,8 @@ static int intelfb_create(struct drm_device *dev, uint32_t fb_width,
 			intel_fb->base.width, intel_fb->base.height,
 			obj_priv->gtt_offset, fbo);
 
+	vga_switcheroo_client_fb_set(dev->pdev, info);
+
 	mutex_unlock(&dev->struct_mutex);
 	return 0;
 
diff --git a/drivers/gpu/drm/nouveau/nouveau_acpi.c b/drivers/gpu/drm/nouveau/nouveau_acpi.c
index 48227e7..7a6f0e5 100644
--- a/drivers/gpu/drm/nouveau/nouveau_acpi.c
+++ b/drivers/gpu/drm/nouveau/nouveau_acpi.c
@@ -11,6 +11,8 @@
 #include "nouveau_drm.h"
 #include "nv50_display.h"
 
+#include <linux/vga_switcheroo.h>
+
 #define NOUVEAU_DSM_SUPPORTED 0x00
 #define NOUVEAU_DSM_SUPPORTED_FUNCTIONS 0x00
 
@@ -123,3 +125,32 @@ bool nouveau_dsm_probe(struct drm_device *dev)
 
 	return true;
 }
+
+static int nouveau_dsm_switchto(acpi_handle handle,
+				enum vga_switcheroo_client_id id)
+{
+	return 0;
+}
+
+static int nouveau_dsm_power_state(acpi_handle handle,
+				   enum vga_switcheroo_client_id id,
+				   enum vga_switcheroo_state state)
+{
+	return 0;
+}
+
+static struct vga_switcheroo_handler nouveau_dsm_handler = {
+	.method_id = VGA_SWITCHEROO_DSM,
+	.switchto = nouveau_dsm_switchto,
+	.power_state = nouveau_dsm_power_state,
+};
+
+void nouveau_register_dsm_handler(void)
+{
+	vga_switcheroo_register_handler(&nouveau_dsm_handler);
+}
+
+void nouveau_unregister_dsm_handler(void)
+{
+	vga_switcheroo_unregister_handler();
+}
diff --git a/drivers/gpu/drm/nouveau/nouveau_drv.c b/drivers/gpu/drm/nouveau/nouveau_drv.c
index da3b93b..e73476c 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drv.c
+++ b/drivers/gpu/drm/nouveau/nouveau_drv.c
@@ -135,7 +135,7 @@ nouveau_pci_remove(struct pci_dev *pdev)
 	drm_put_dev(dev);
 }
 
-static int
+int
 nouveau_pci_suspend(struct pci_dev *pdev, pm_message_t pm_state)
 {
 	struct drm_device *dev = pci_get_drvdata(pdev);
@@ -233,7 +233,7 @@ out_abort:
 	return ret;
 }
 
-static int
+int
 nouveau_pci_resume(struct pci_dev *pdev)
 {
 	struct drm_device *dev = pci_get_drvdata(pdev);
diff --git a/drivers/gpu/drm/nouveau/nouveau_drv.h b/drivers/gpu/drm/nouveau/nouveau_drv.h
index 1c15ef3..0517a93 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drv.h
+++ b/drivers/gpu/drm/nouveau/nouveau_drv.h
@@ -682,6 +682,9 @@ extern int nouveau_ignorelid;
 extern int nouveau_nofbaccel;
 extern int nouveau_noaccel;
 
+extern int nouveau_pci_suspend(struct pci_dev *pdev, pm_message_t pm_state);
+extern int nouveau_pci_resume(struct pci_dev *pdev);
+
 /* nouveau_state.c */
 extern void nouveau_preclose(struct drm_device *dev, struct drm_file *);
 extern int  nouveau_load(struct drm_device *, unsigned long flags);
diff --git a/drivers/gpu/drm/nouveau/nouveau_fbcon.c b/drivers/gpu/drm/nouveau/nouveau_fbcon.c
index ea879a2..f2c9d24 100644
--- a/drivers/gpu/drm/nouveau/nouveau_fbcon.c
+++ b/drivers/gpu/drm/nouveau/nouveau_fbcon.c
@@ -36,6 +36,7 @@
 #include <linux/fb.h>
 #include <linux/init.h>
 #include <linux/screen_info.h>
+#include <linux/vga_switcheroo.h>
 
 #include "drmP.h"
 #include "drm.h"
@@ -369,6 +370,8 @@ nouveau_fbcon_create(struct drm_device *dev, uint32_t fb_width,
 						nouveau_fb->base.height,
 						nvbo->bo.offset, nvbo);
 
+	vga_switcheroo_client_fb_set(dev->pdev, info);
+
 	mutex_unlock(&dev->struct_mutex);
 	return 0;
 
diff --git a/drivers/gpu/drm/nouveau/nouveau_state.c b/drivers/gpu/drm/nouveau/nouveau_state.c
index a4851af..330c763 100644
--- a/drivers/gpu/drm/nouveau/nouveau_state.c
+++ b/drivers/gpu/drm/nouveau/nouveau_state.c
@@ -29,6 +29,7 @@
 #include "drm_sarea.h"
 #include "drm_crtc_helper.h"
 #include <linux/vgaarb.h>
+#include <linux/vga_switcheroo.h>
 
 #include "nouveau_drv.h"
 #include "nouveau_drm.h"
@@ -371,6 +372,30 @@ out_err:
 	return ret;
 }
 
+static void nouveau_switcheroo_set_state(struct pci_dev *pdev,
+					 enum vga_switcheroo_state state)
+{
+	pm_message_t pmm = { .event = PM_EVENT_SUSPEND };
+	if (state == VGA_SWITCHEROO_ON) {
+		printk(KERN_ERR "VGA switcheroo: switched nouveau on\n");
+		nouveau_pci_resume(pdev);
+	} else {
+		printk(KERN_ERR "VGA switcheroo: switched nouveau off\n");
+		nouveau_pci_suspend(pdev, pmm);
+	}
+}
+
+static bool nouveau_switcheroo_can_switch(struct pci_dev *pdev)
+{
+	struct drm_device *dev = pci_get_drvdata(pdev);
+	bool can_switch;
+
+	spin_lock(&dev->count_lock);
+	can_switch = (dev->open_count == 0);
+	spin_unlock(&dev->count_lock);
+	return can_switch;
+}
+
 int
 nouveau_card_init(struct drm_device *dev)
 {
@@ -384,6 +409,8 @@ nouveau_card_init(struct drm_device *dev)
 		return 0;
 
 	vga_client_register(dev->pdev, dev, NULL, nouveau_vga_set_decode);
+	vga_switcheroo_register_client(dev->pdev, nouveau_switcheroo_set_state,
+				       nouveau_switcheroo_can_switch);
 
 	/* Initialise internal driver API hooks */
 	ret = nouveau_init_engine_ptrs(dev);
diff --git a/drivers/gpu/drm/radeon/Makefile b/drivers/gpu/drm/radeon/Makefile
index 1cc7b93..8e62fe1 100644
--- a/drivers/gpu/drm/radeon/Makefile
+++ b/drivers/gpu/drm/radeon/Makefile
@@ -54,7 +54,8 @@ radeon-y += radeon_device.o radeon_kms.o \
 	radeon_cs.o radeon_bios.o radeon_benchmark.o r100.o r300.o r420.o \
 	rs400.o rs600.o rs690.o rv515.o r520.o r600.o rv770.o radeon_test.o \
 	r200.o radeon_legacy_tv.o r600_cs.o r600_blit.o r600_blit_shaders.o \
-	r600_blit_kms.o radeon_pm.o atombios_dp.o r600_audio.o r600_hdmi.o
+	r600_blit_kms.o radeon_pm.o atombios_dp.o r600_audio.o r600_hdmi.o \
+	radeon_atpx_handler.o
 
 radeon-$(CONFIG_COMPAT) += radeon_ioc32.o
 
diff --git a/drivers/gpu/drm/radeon/r600_audio.c b/drivers/gpu/drm/radeon/r600_audio.c
index 0dcb690..7def989 100644
--- a/drivers/gpu/drm/radeon/r600_audio.c
+++ b/drivers/gpu/drm/radeon/r600_audio.c
@@ -163,6 +163,9 @@ int r600_audio_init(struct radeon_device *rdev)
 	rdev->audio_status_bits = 0;
 	rdev->audio_category_code = 0;
 
+	if (!radeon_audio)
+		return 0;
+
 	setup_timer(
 		&rdev->audio_timer,
 		r600_audio_update_hdmi,
diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index c0356bb..8d9132b 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -838,6 +838,8 @@ struct radeon_device {
 	int			audio_bits_per_sample;
 	uint8_t			audio_status_bits;
 	uint8_t			audio_category_code;
+
+	bool powered_down;
 };
 
 int radeon_device_init(struct radeon_device *rdev,
@@ -1042,6 +1044,8 @@ extern void radeon_legacy_set_clock_gating(struct radeon_device *rdev, int enabl
 extern void radeon_atom_set_clock_gating(struct radeon_device *rdev, int enable);
 extern void radeon_ttm_placement_from_domain(struct radeon_bo *rbo, u32 domain);
 extern bool radeon_ttm_bo_is_radeon_bo(struct ttm_buffer_object *bo);
+extern int radeon_resume_kms(struct drm_device *dev);
+extern int radeon_suspend_kms(struct drm_device *dev, pm_message_t state);
 
 /* r100,rv100,rs100,rv200,rs200,r200,rv250,rs300,rv280 */
 struct r100_mc_save {
diff --git a/drivers/gpu/drm/radeon/radeon_atpx_handler.c b/drivers/gpu/drm/radeon/radeon_atpx_handler.c
new file mode 100644
index 0000000..6cb8340
--- /dev/null
+++ b/drivers/gpu/drm/radeon/radeon_atpx_handler.c
@@ -0,0 +1,132 @@
+/*
+ * Copyright (c) 2010 Red Hat Inc.
+ * Author : Dave Airlie <airlied@redhat.com>
+ *
+ * Licensed under GPLv2
+ *
+ * ATPX support for both Intel/ATI
+ */
+
+#include <linux/vga_switcheroo.h>
+
+#define ATPX_VERSION 0
+#define ATPX_GPU_PWR 2
+#define ATPX_MUX_SELECT 3
+
+#define ATPX_INTEGRATED 0
+#define ATPX_DISCRETE 1
+
+#define ATPX_MUX_IGD 0
+#define ATPX_MUX_DISCRETE 1
+
+#if 0 /* TODO - use this for some laptops */
+static int radeon_atpx_get_version(acpi_handle handle)
+{
+	acpi_status status;
+	union acpi_object atpx_arg_elements[2], *obj;
+	struct acpi_object_list atpx_arg;
+	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
+
+	atpx_arg.count = 2;
+	atpx_arg.pointer = &atpx_arg_elements[0];
+
+	atpx_arg_elements[0].type = ACPI_TYPE_INTEGER;
+	atpx_arg_elements[0].integer.value = ATPX_VERSION;
+
+	atpx_arg_elements[1].type = ACPI_TYPE_INTEGER;
+	atpx_arg_elements[1].integer.value = ATPX_VERSION;
+
+	status = acpi_evaluate_object(handle, NULL, &atpx_arg, &buffer);
+	if (ACPI_FAILURE(status)) {
+		printk("%s: failed to call ATPX: %s\n", __func__, acpi_format_exception(status));
+		return -ENOSYS;
+	}
+	obj = (union acpi_object *)buffer.pointer;
+	if (obj && (obj->type == ACPI_TYPE_BUFFER))
+		printk(KERN_INFO "atpx: VERN is %d\n", *((u8 *)(obj->buffer.pointer) + 2));
+	kfree(buffer.pointer);
+	return 0;
+}
+#endif
+
+static int radeon_atpx_execute(acpi_handle handle, int cmd_id, u16 value)
+{
+	acpi_status status;
+	union acpi_object atpx_arg_elements[2];
+	struct acpi_object_list atpx_arg;
+	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
+	uint8_t buf[4] = {0};
+
+	if (!handle)
+		return -EINVAL;
+
+	atpx_arg.count = 2;
+	atpx_arg.pointer = &atpx_arg_elements[0];
+
+	atpx_arg_elements[0].type = ACPI_TYPE_INTEGER;
+	atpx_arg_elements[0].integer.value = cmd_id;
+
+	buf[2] = value & 0xff;
+	buf[3] = (value >> 8) & 0xff;
+
+	atpx_arg_elements[1].type = ACPI_TYPE_BUFFER;
+	atpx_arg_elements[1].buffer.length = 4;
+	atpx_arg_elements[1].buffer.pointer = buf;
+
+	status = acpi_evaluate_object(handle, NULL, &atpx_arg, &buffer);
+	if (ACPI_FAILURE(status)) {
+		printk("%s: failed to call ATPX: %s\n", __func__, acpi_format_exception(status));
+		return -ENOSYS;
+	}
+	kfree(buffer.pointer);
+
+	return 0;
+}
+
+static int radeon_atpx_set_discrete_state(acpi_handle handle, int state)
+{
+	return radeon_atpx_execute(handle, ATPX_GPU_PWR, state);
+}
+
+static int radeon_atpx_switch_mux(acpi_handle handle, int mux_id)
+{
+	return radeon_atpx_execute(handle, ATPX_MUX_SELECT, mux_id);
+}
+
+
+static int radeon_atpx_switchto(acpi_handle handle, enum vga_switcheroo_client_id id)
+{
+	if (id == VGA_SWITCHEROO_IGD)
+		radeon_atpx_switch_mux(handle, 0);
+	else
+		radeon_atpx_switch_mux(handle, 1);
+	return 0;
+}
+
+static int radeon_atpx_power_state(acpi_handle handle,
+				   enum vga_switcheroo_client_id id,
+				   enum vga_switcheroo_state state)
+{
+	/* on w500 ACPI can't change intel gpu state */
+	if (id == VGA_SWITCHEROO_IGD)
+		return 0;
+
+	radeon_atpx_set_discrete_state(handle, state);
+	return 0;
+}
+
+static struct vga_switcheroo_handler radeon_atpx_handler = {
+	.method_id = VGA_SWITCHEROO_ATPX,
+	.switchto = radeon_atpx_switchto,
+	.power_state = radeon_atpx_power_state,
+};
+
+void radeon_register_atpx_handler(void)
+{
+	vga_switcheroo_register_handler(&radeon_atpx_handler);
+}
+
+void radeon_unregister_atpx_handler(void)
+{
+	vga_switcheroo_unregister_handler();
+}
diff --git a/drivers/gpu/drm/radeon/radeon_bios.c b/drivers/gpu/drm/radeon/radeon_bios.c
index 9069217..a6f1da3 100644
--- a/drivers/gpu/drm/radeon/radeon_bios.c
+++ b/drivers/gpu/drm/radeon/radeon_bios.c
@@ -50,6 +50,7 @@ static bool igp_read_bios_from_vram(struct radeon_device *rdev)
 	vram_base = drm_get_resource_start(rdev->ddev, 0);
 	bios = ioremap(vram_base, size);
 	if (!bios) {
+		DRM_ERROR("unable to ioremap %x %d\n", (unsigned int)vram_base, (unsigned int)size);
 		return false;
 	}
 
@@ -62,7 +63,7 @@ static bool igp_read_bios_from_vram(struct radeon_device *rdev)
 		iounmap(bios);
 		return false;
 	}
-	memcpy(rdev->bios, bios, size);
+	memcpy_fromio(rdev->bios, bios, size);
 	iounmap(bios);
 	return true;
 }
@@ -393,11 +394,8 @@ bool radeon_get_bios(struct radeon_device *rdev)
 	bool r;
 	uint16_t tmp;
 
-	if (rdev->flags & RADEON_IS_IGP) {
-		r = igp_read_bios_from_vram(rdev);
-		if (r == false)
-			r = radeon_read_bios(rdev);
-	} else
+	r = igp_read_bios_from_vram(rdev);
+	if (r == false)
 		r = radeon_read_bios(rdev);
 	if (r == false) {
 		r = radeon_read_disabled_bios(rdev);
diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index 768b150..c58591a 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -30,6 +30,7 @@
 #include <drm/drm_crtc_helper.h>
 #include <drm/radeon_drm.h>
 #include <linux/vgaarb.h>
+#include <linux/vga_switcheroo.h>
 #include "radeon_reg.h"
 #include "radeon.h"
 #include "radeon_asic.h"
@@ -613,6 +614,38 @@ void radeon_check_arguments(struct radeon_device *rdev)
 	}
 }
 
+static void radeon_switcheroo_set_state(struct pci_dev *pdev, enum vga_switcheroo_state state)
+{
+	struct drm_device *dev = pci_get_drvdata(pdev);
+	struct radeon_device *rdev = dev->dev_private;
+	pm_message_t pmm = { .event = PM_EVENT_SUSPEND };
+	if (state == VGA_SWITCHEROO_ON) {
+		printk(KERN_ERR "VGA switched radeon on\n");
+		/* don't suspend or resume card normally */
+		rdev->powered_down = false;
+		radeon_resume_kms(dev);
+		r600_audio_init(rdev);
+	} else {
+		printk(KERN_ERR "VGA switched radeon off\n");
+		r600_audio_fini(rdev);
+		radeon_suspend_kms(dev, pmm);
+		/* don't suspend or resume card normally */
+		rdev->powered_down = true;
+	}
+}
+
+static bool radeon_switcheroo_can_switch(struct pci_dev *pdev)
+{
+	struct drm_device *dev = pci_get_drvdata(pdev);
+	bool can_switch;
+
+	spin_lock(&dev->count_lock);
+	can_switch = (dev->open_count == 0);
+	spin_unlock(&dev->count_lock);
+	return can_switch;
+}
+
+
 int radeon_device_init(struct radeon_device *rdev,
 		       struct drm_device *ddev,
 		       struct pci_dev *pdev,
@@ -692,6 +725,9 @@ int radeon_device_init(struct radeon_device *rdev,
 	/* this will fail for cards that aren't VGA class devices, just
 	 * ignore it */
 	vga_client_register(rdev->pdev, rdev, NULL, radeon_vga_set_decode);
+	vga_switcheroo_register_client(rdev->pdev,
+				       radeon_switcheroo_set_state,
+				       radeon_switcheroo_can_switch);
 
 	r = radeon_init(rdev);
 	if (r)
@@ -746,6 +782,8 @@ int radeon_suspend_kms(struct drm_device *dev, pm_message_t state)
 	}
 	rdev = dev->dev_private;
 
+	if (rdev->powered_down)
+		return 0;
 	/* unpin the front buffers */
 	list_for_each_entry(crtc, &dev->mode_config.crtc_list, head) {
 		struct radeon_framebuffer *rfb = to_radeon_framebuffer(crtc->fb);
@@ -791,6 +829,9 @@ int radeon_resume_kms(struct drm_device *dev)
 {
 	struct radeon_device *rdev = dev->dev_private;
 
+	if (rdev->powered_down)
+		return 0;
+
 	acquire_console_sem();
 	pci_set_power_state(dev->pdev, PCI_D0);
 	pci_restore_state(dev->pdev);
diff --git a/drivers/gpu/drm/radeon/radeon_drv.c b/drivers/gpu/drm/radeon/radeon_drv.c
index 8ba3de7..69017f2 100644
--- a/drivers/gpu/drm/radeon/radeon_drv.c
+++ b/drivers/gpu/drm/radeon/radeon_drv.c
@@ -87,7 +87,7 @@ int radeon_testing = 0;
 int radeon_connector_table = 0;
 int radeon_tv = 1;
 int radeon_new_pll = 1;
-int radeon_audio = 1;
+int radeon_audio = 0;
 
 MODULE_PARM_DESC(no_wb, "Disable AGP writeback for scratch registers");
 module_param_named(no_wb, radeon_no_wb, int, 0444);
@@ -339,6 +339,7 @@ static int __init radeon_init(void)
 		driver = &kms_driver;
 		driver->driver_features |= DRIVER_MODESET;
 		driver->num_ioctls = radeon_max_kms_ioctl;
+		radeon_register_atpx_handler();
 	}
 	/* if the vga console setting is enabled still
 	 * let modprobe override it */
@@ -348,6 +349,7 @@ static int __init radeon_init(void)
 static void __exit radeon_exit(void)
 {
 	drm_exit(driver);
+	radeon_unregister_atpx_handler();
 }
 
 module_init(radeon_init);
diff --git a/drivers/gpu/drm/radeon/radeon_drv.h b/drivers/gpu/drm/radeon/radeon_drv.h
index c57ad60..7362371 100644
--- a/drivers/gpu/drm/radeon/radeon_drv.h
+++ b/drivers/gpu/drm/radeon/radeon_drv.h
@@ -455,6 +455,9 @@ extern void r600_blit_swap(struct drm_device *dev,
 			   int sx, int sy, int dx, int dy,
 			   int w, int h, int src_pitch, int dst_pitch, int cpp);
 
+/* atpx handler */
+void radeon_register_atpx_handler(void);
+void radeon_unregister_atpx_handler(void);
 /* Flags for stats.boxes
  */
 #define RADEON_BOX_DMA_IDLE      0x1
diff --git a/drivers/gpu/drm/radeon/radeon_fb.c b/drivers/gpu/drm/radeon/radeon_fb.c
index d71e346..4e1e179 100644
--- a/drivers/gpu/drm/radeon/radeon_fb.c
+++ b/drivers/gpu/drm/radeon/radeon_fb.c
@@ -39,6 +39,8 @@
 
 #include "drm_fb_helper.h"
 
+#include <linux/vga_switcheroo.h>
+
 struct radeon_fb_device {
 	struct drm_fb_helper helper;
 	struct radeon_framebuffer	*rfb;
@@ -290,6 +292,7 @@ int radeonfb_create(struct drm_device *dev,
 	rfbdev->rfb = rfb;
 	rfbdev->rdev = rdev;
 
+	vga_switcheroo_client_fb_set(rdev->ddev->pdev, info);
 	mutex_unlock(&rdev->ddev->struct_mutex);
 	return 0;
 
diff --git a/drivers/gpu/drm/radeon/radeon_kms.c b/drivers/gpu/drm/radeon/radeon_kms.c
index f23b056..5db7af6 100644
--- a/drivers/gpu/drm/radeon/radeon_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_kms.c
@@ -30,6 +30,8 @@
 #include "radeon.h"
 #include "radeon_drm.h"
 
+#include <linux/vga_switcheroo.h>
+
 int radeon_driver_unload_kms(struct drm_device *dev)
 {
 	struct radeon_device *rdev = dev->dev_private;
@@ -136,6 +138,7 @@ int radeon_driver_firstopen_kms(struct drm_device *dev)
 
 void radeon_driver_lastclose_kms(struct drm_device *dev)
 {
+	vga_switcheroo_process_delayed_switch();
 }
 
 int radeon_driver_open_kms(struct drm_device *dev, struct drm_file *file_priv)
diff --git a/drivers/gpu/vga/Kconfig b/drivers/gpu/vga/Kconfig
index 790e675..66b4abc 100644
--- a/drivers/gpu/vga/Kconfig
+++ b/drivers/gpu/vga/Kconfig
@@ -8,3 +8,14 @@ config VGA_ARB
 	  are accessed at same time they need some kind of coordination. Please
 	  see Documentation/vgaarbiter.txt for more details. Select this to
 	  enable VGA arbiter.
+
+config VGA_SWITCHEROO
+	bool "Laptop GPU switching support"
+	default y
+	depends on X86
+	depends on ACPI
+	help
+	  Many laptops released in 2008/9/10 have two gpus with a multiplxer
+	  to switch between them. This adds support for dynamic switching when
+          X isn't running and delayed switching until the next logoff.
+
diff --git a/drivers/gpu/vga/Makefile b/drivers/gpu/vga/Makefile
index 7cc8c1e..14ca30b 100644
--- a/drivers/gpu/vga/Makefile
+++ b/drivers/gpu/vga/Makefile
@@ -1 +1,2 @@
 obj-$(CONFIG_VGA_ARB)  += vgaarb.o
+obj-$(CONFIG_VGA_SWITCHEROO) += vga_switcheroo.o
diff --git a/drivers/gpu/vga/vga_switcheroo.c b/drivers/gpu/vga/vga_switcheroo.c
new file mode 100644
index 0000000..3d36524
--- /dev/null
+++ b/drivers/gpu/vga/vga_switcheroo.c
@@ -0,0 +1,472 @@
+/*
+ * Copyright (c) 2010 Red Hat Inc.
+ * Author : Dave Airlie <airlied@redhat.com>
+ *
+ *
+ * Licensed under GPLv2
+ *
+ * vga_switcheroo.c - Support for laptop with dual GPU using one set of outputs
+
+ Switcher interface - methods require for ATPX and DCM
+ - switchto - this throws the output MUX switch
+ - discrete_set_power - sets the power state for the discrete card
+
+ GPU driver interface
+ - set_gpu_state - this should do the equiv of s/r for the card
+		  - this should *not* set the discrete power state
+ - switch_check  - check if the device is in a position to switch now
+ */
+
+#include <linux/module.h>
+#include <linux/dmi.h>
+#include <linux/seq_file.h>
+#include <linux/uaccess.h>
+#include <linux/fs.h>
+#include <linux/debugfs.h>
+#include <linux/fb.h>
+
+#include <acpi/acpi.h>
+#include <acpi/acpi_bus.h>
+
+#include <linux/pci.h>
+#include <linux/vga_switcheroo.h>
+
+
+struct vga_switcheroo_client {
+	struct pci_dev *pdev;
+	struct fb_info *fb_info;
+	int pwr_state;
+	void (*set_gpu_state)(struct pci_dev *pdev, enum vga_switcheroo_state);
+	bool (*can_switch)(struct pci_dev *pdev);
+};
+
+struct vgasr_priv {
+
+	bool active;
+	bool delayed_switch_active;
+	enum vga_switcheroo_client_id delayed_client_id;
+
+	struct dentry *debugfs_root;
+	struct dentry *switch_file;
+
+	enum vga_switcheroo_method method;
+	enum vga_switcheroo_client_id active_client;
+
+	int registered_clients;
+	struct vga_switcheroo_client clients[VGA_SWITCHEROO_MAX_CLIENTS];
+
+	struct vga_switcheroo_handler *handler;
+	acpi_handle handle;
+};
+
+static int vga_switcheroo_debugfs_init(struct vgasr_priv *priv);
+static void vga_switcheroo_debugfs_fini(struct vgasr_priv *priv);
+
+/* only one switcheroo per system */
+static struct vgasr_priv vgasr_priv;
+
+/*
+ * it would be nice to have these in the drivers - but it gets messy
+ * since Intel can load before radeon, and we'd have to reprobe on
+ * both client and handler registration
+ * though with Intel I suppose we always know its going to be the IGD
+ */
+static bool vga_switcheroo_detect_atpx(struct pci_dev *pdev, acpi_handle *handle,
+				       enum vga_switcheroo_client_id *client_id)
+{
+	acpi_handle dhandle, atpx_handle;
+	acpi_status status;
+
+	*client_id = VGA_SWITCHEROO_DIS;
+	dhandle = DEVICE_ACPI_HANDLE(&pdev->dev);
+	if (dhandle) {
+		status = acpi_get_handle(dhandle, "ATPX", &atpx_handle);
+		if (ACPI_SUCCESS(status)) {
+			WARN((vgasr_priv.method != VGA_SWITCHEROO_NONE &&
+			      vgasr_priv.method != VGA_SWITCHEROO_ATPX),
+			     "Inconsistent VGA switcher state detected\n");
+			/* ATPX defines IGD to have this method */
+			*client_id = VGA_SWITCHEROO_IGD;
+			*handle = atpx_handle;
+			return true;
+		}
+	}
+	return false;
+}
+
+static bool vga_switcheroo_detect_dsm(struct pci_dev *pdev, acpi_handle *handle,
+				      enum vga_switcheroo_client_id *client_id)
+{
+	acpi_handle dhandle, dsm_handle;
+	acpi_status status;
+
+	/* TODO client ID for DSM when both are nvidia */
+	if (pdev->vendor == PCI_VENDOR_ID_INTEL)
+		*client_id = VGA_SWITCHEROO_IGD;
+	else
+		*client_id = VGA_SWITCHEROO_DIS;
+	dhandle = DEVICE_ACPI_HANDLE(&pdev->dev);
+	if (dhandle) {
+		status = acpi_get_handle(dhandle, "_DSM", &dsm_handle);
+		if (ACPI_SUCCESS(status)) {
+			WARN((vgasr_priv.method != VGA_SWITCHEROO_NONE &&
+			      vgasr_priv.method != VGA_SWITCHEROO_DSM),
+			     "Inconsistent VGA switcher state detected\n");
+			*handle = dsm_handle;
+			return true;
+		}
+	}
+	return false;
+}
+
+static bool vga_switcheroo_detect_acpi_method(struct pci_dev *pdev, acpi_handle *handle,
+					      enum vga_switcheroo_client_id *client_id)
+{
+	bool ret;
+	char acpi_method_name[255] = { 0 };
+	struct acpi_buffer buffer = {sizeof(acpi_method_name), acpi_method_name};
+
+	ret = vga_switcheroo_detect_atpx(pdev, handle, client_id);
+	if (ret == true)
+		goto out_print;
+
+	ret = vga_switcheroo_detect_dsm(pdev, handle, client_id);
+	if (ret == true)
+		goto out_print;
+
+	return false;
+
+out_print:
+	acpi_get_name(*handle, ACPI_FULL_PATHNAME, &buffer);
+	printk(KERN_INFO "VGA switcheroo: detected switching method %s handle on PCI device %s\n",
+	       acpi_method_name,
+	       pci_name(pdev));
+	return true;
+}
+
+
+int vga_switcheroo_register_handler(struct vga_switcheroo_handler *handler)
+{
+	if (vgasr_priv.handler)
+		return -EINVAL;
+
+	vgasr_priv.method = handler->method_id;
+	vgasr_priv.handler = handler;
+	return 0;
+}
+EXPORT_SYMBOL(vga_switcheroo_register_handler);
+
+void vga_switcheroo_unregister_handler(void)
+{
+	vgasr_priv.method = VGA_SWITCHEROO_NONE;
+	vgasr_priv.handler = NULL;
+}
+EXPORT_SYMBOL(vga_switcheroo_unregister_handler);
+
+int vga_switcheroo_register_client(struct pci_dev *pdev,
+				   void (*set_gpu_state)(struct pci_dev *pdev, enum vga_switcheroo_state),
+				   bool (*can_switch)(struct pci_dev *pdev))
+{
+	enum vga_switcheroo_client_id client_id;
+
+	vga_switcheroo_detect_acpi_method(pdev, &vgasr_priv.handle, &client_id);
+	if (vgasr_priv.registered_clients & (1 << client_id)) {
+		WARN(1, "VGA switcheroo: Double registration for %s client\n",
+		     client_id == VGA_SWITCHEROO_IGD ? "Integrated" : "Discrete");
+		return -EINVAL;
+	}
+
+	vgasr_priv.clients[client_id].pwr_state = VGA_SWITCHEROO_ON;
+	vgasr_priv.clients[client_id].pdev = pdev;
+	vgasr_priv.clients[client_id].set_gpu_state = set_gpu_state;
+	vgasr_priv.clients[client_id].can_switch = can_switch;
+	if (pdev->resource[PCI_ROM_RESOURCE].flags & IORESOURCE_ROM_SHADOW)
+		vgasr_priv.active_client = client_id;
+
+	vgasr_priv.registered_clients |= (1 << client_id);
+
+	if (vgasr_priv.registered_clients == 0x3 && vgasr_priv.handle) {
+		printk(KERN_INFO "VGA switcheroo enabled\n");
+		vga_switcheroo_debugfs_init(&vgasr_priv);
+		vgasr_priv.active = true;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(vga_switcheroo_register_client);
+
+void vga_switcheroo_unregister_client(struct pci_dev *pdev)
+{
+	int i;
+
+	for (i = 0; i < VGA_SWITCHEROO_MAX_CLIENTS; i++) {
+		if (vgasr_priv.clients[i].pdev == pdev) {
+			vgasr_priv.registered_clients &= ~(1 << i);
+			break;
+		}
+	}
+
+	printk(KERN_INFO "VGA switcheroo disabled\n");
+	vga_switcheroo_debugfs_fini(&vgasr_priv);
+	vgasr_priv.active = false;
+}
+EXPORT_SYMBOL(vga_switcheroo_unregister_client);
+
+void vga_switcheroo_client_fb_set(struct pci_dev *pdev,
+				 struct fb_info *info)
+{
+	int i;
+
+	for (i = 0; i < VGA_SWITCHEROO_MAX_CLIENTS; i++) {
+		if (vgasr_priv.clients[i].pdev == pdev) {
+			vgasr_priv.clients[i].fb_info = info;
+			break;
+		}
+	}
+}
+EXPORT_SYMBOL(vga_switcheroo_client_fb_set);
+
+static int vga_switcheroo_show(struct seq_file *m, void *v)
+{
+	int i;
+	for (i = 0; i < VGA_SWITCHEROO_MAX_CLIENTS; i++) {
+		seq_printf(m, "%d:%c:%s:%s\n", i,
+			   (i == vgasr_priv.active_client ? '+' : ' '),
+			   vgasr_priv.clients[i].pwr_state ? "Pwr" : "Off",
+			   pci_name(vgasr_priv.clients[i].pdev));
+	}
+	return 0;
+}
+
+static int vga_switcheroo_debugfs_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, vga_switcheroo_show, NULL);
+}
+
+static int vga_switchon(int index)
+{
+	int ret;
+
+	ret = vgasr_priv.handler->power_state(vgasr_priv.handle, index, VGA_SWITCHEROO_ON);
+	/* call the driver callback to turn on device */
+	vgasr_priv.clients[index].set_gpu_state(vgasr_priv.clients[index].pdev, VGA_SWITCHEROO_ON);
+	vgasr_priv.clients[index].pwr_state = VGA_SWITCHEROO_ON;
+	return 0;
+}
+
+static int vga_switchoff(int index)
+{
+	/* call the driver callback to turn off device */
+	vgasr_priv.clients[index].set_gpu_state(vgasr_priv.clients[index].pdev, VGA_SWITCHEROO_OFF);
+	vgasr_priv.handler->power_state(vgasr_priv.handle, index, VGA_SWITCHEROO_OFF);
+	vgasr_priv.clients[index].pwr_state = VGA_SWITCHEROO_OFF;
+	return 0;
+}
+
+static int vga_switchto(int index)
+{
+	int cur = vgasr_priv.active_client;
+	int ret;
+
+	if (cur == index)
+		return 0;
+
+	/* power up the first device */
+	if (vgasr_priv.clients[index].pwr_state == VGA_SWITCHEROO_OFF)
+		vga_switchon(index);
+
+	ret = pci_enable_device(vgasr_priv.clients[index].pdev);
+	if (ret)
+		return ret;
+
+	/* swap shadow resource to denote boot VGA device has changed so X starts on new device */
+	vgasr_priv.clients[cur].pdev->resource[PCI_ROM_RESOURCE].flags &= ~IORESOURCE_ROM_SHADOW;
+	vgasr_priv.clients[index].pdev->resource[PCI_ROM_RESOURCE].flags |= IORESOURCE_ROM_SHADOW;
+
+	if (vgasr_priv.clients[index].fb_info) {
+		struct fb_event event;
+		event.info = vgasr_priv.clients[index].fb_info;
+		fb_notifier_call_chain(FB_EVENT_REMAP_ALL_CONSOLE, &event);
+	}
+
+	ret = vgasr_priv.handler->switchto(vgasr_priv.handle, index);
+	if (ret)
+		return ret;
+
+	if (vgasr_priv.clients[cur].pwr_state == VGA_SWITCHEROO_ON)
+		vga_switchoff(cur);
+
+	vgasr_priv.active_client = index;
+	return 0;
+}
+
+static ssize_t
+vga_switcheroo_debugfs_write(struct file *filp, const char __user *ubuf,
+			     size_t cnt, loff_t *ppos)
+{
+	char usercmd[64];
+	const char *pdev_name;
+	int i, ret;
+	enum vga_switcheroo_client_id client_id = -1;
+	bool delay = false, can_switch;
+
+	if (cnt > 63)
+		cnt = 63;
+
+	if (copy_from_user(usercmd, ubuf, cnt))
+		return -EFAULT;
+
+
+	/* pwr off the device not in use */
+	if (strncmp(usercmd, "OFF", 3) == 0) {
+		for (i = 0; i < VGA_SWITCHEROO_MAX_CLIENTS; i++) {
+			if (vgasr_priv.active_client == i)
+				continue;
+			if (vgasr_priv.clients[i].pwr_state == VGA_SWITCHEROO_ON)
+				vga_switchoff(i);
+		}
+		goto out;
+	}
+	/* pwr on the device not in use */
+	if (strncmp(usercmd, "ON", 2) == 0) {
+		for (i = 0; i < VGA_SWITCHEROO_MAX_CLIENTS; i++) {
+			if (vgasr_priv.active_client == i)
+				continue;
+			if (vgasr_priv.clients[i].pwr_state == VGA_SWITCHEROO_OFF)
+				vga_switchon(i);
+		}
+		goto out;
+	}
+
+	/* request a delayed switch - test can we switch now */
+	if (strncmp(usercmd, "DIGD", 4) == 0) {
+		client_id = VGA_SWITCHEROO_IGD;
+		delay = true;
+	}
+
+	if (strncmp(usercmd, "DDIS", 4) == 0) {
+		client_id = VGA_SWITCHEROO_DIS;
+		delay = true;
+	}
+
+	if (strncmp(usercmd, "IGD", 3) == 0)
+		client_id = VGA_SWITCHEROO_IGD;
+
+	if (strncmp(usercmd, "DIS", 3) == 0)
+		client_id = VGA_SWITCHEROO_DIS;
+
+	if (client_id == -1)
+		goto out;
+
+	vgasr_priv.delayed_switch_active = false;
+	/* okay we want a switch - test if devices are willing to switch */
+	can_switch = true;
+	for (i = 0; i < VGA_SWITCHEROO_MAX_CLIENTS; i++) {
+		can_switch = vgasr_priv.clients[i].can_switch(vgasr_priv.clients[i].pdev);
+		if (can_switch == false) {
+			printk(KERN_ERR "Client %d refused switch\n", i);
+			break;
+		}
+	}
+
+	if (can_switch == false && delay == false)
+		goto out;
+
+	if (can_switch == true) {
+		pdev_name = pci_name(vgasr_priv.clients[client_id].pdev);
+		printk("switching to %s\n", pdev_name);
+		ret = vga_switchto(client_id);
+		if (ret)
+			printk("switching failed %d\n", ret);
+	} else {
+		printk(KERN_ERR "setting delayed switch to client %d\n", client_id);
+		vgasr_priv.delayed_switch_active = true;
+		vgasr_priv.delayed_client_id = client_id;
+
+		/* we should at least power up the card to
+		   make the switch faster */
+		if (vgasr_priv.clients[client_id].pwr_state == VGA_SWITCHEROO_OFF)
+			vga_switchon(client_id);
+	}
+
+out:
+	return cnt;
+}
+
+static const struct file_operations vga_switcheroo_debugfs_fops = {
+	.owner = THIS_MODULE,
+	.open = vga_switcheroo_debugfs_open,
+	.write = vga_switcheroo_debugfs_write,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+static void vga_switcheroo_debugfs_fini(struct vgasr_priv *priv)
+{
+	if (priv->switch_file) {
+		debugfs_remove(priv->switch_file);
+		priv->switch_file = NULL;
+	}
+	if (priv->debugfs_root) {
+		debugfs_remove(priv->debugfs_root);
+		priv->debugfs_root = NULL;
+	}
+}
+
+static int vga_switcheroo_debugfs_init(struct vgasr_priv *priv)
+{
+	/* already initialised */
+	if (priv->debugfs_root)
+		return 0;
+	priv->debugfs_root = debugfs_create_dir("vgaswitcheroo", NULL);
+
+	if (!priv->debugfs_root) {
+		printk(KERN_ERR "Cannot create /sys/kernel/debug/vgaswitcheroo\n");
+		goto fail;
+	}
+
+	priv->switch_file = debugfs_create_file("switch", 0644,
+						priv->debugfs_root, NULL, &vga_switcheroo_debugfs_fops);
+	if (!priv->switch_file) {
+		printk(KERN_ERR "cannot create /sys/kernel/debug/vgaswitcheroo/switch\n");
+		goto fail;
+	}
+	return 0;
+fail:
+	vga_switcheroo_debugfs_fini(priv);
+	return -1;
+}
+
+int vga_switcheroo_process_delayed_switch(void)
+{
+	const char *pdev_name;
+	bool can_switch = true;
+	int i;
+	int ret;
+
+	if (!vgasr_priv.delayed_switch_active)
+		return -EINVAL;
+
+	printk(KERN_ERR "processing delayed switch to %d\n", vgasr_priv.delayed_client_id);
+
+	for (i = 0; i < VGA_SWITCHEROO_MAX_CLIENTS; i++) {
+		can_switch = vgasr_priv.clients[i].can_switch(vgasr_priv.clients[i].pdev);
+		if (can_switch == false) {
+			printk(KERN_ERR "Client %d refused switch\n", i);
+			break;
+		}
+	}
+
+	if (can_switch == false)
+		return -EINVAL;
+
+	pdev_name = pci_name(vgasr_priv.clients[vgasr_priv.delayed_client_id].pdev);
+	printk("delayed switching to %s\n", pdev_name);
+	ret = vga_switchto(vgasr_priv.delayed_client_id);
+	if (ret)
+		printk("switching failed %d\n", ret);
+
+	vgasr_priv.delayed_switch_active = false;
+	return 0;
+}
+EXPORT_SYMBOL(vga_switcheroo_process_delayed_switch);
diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index 3681c6a..b0a3fa0 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -3025,6 +3025,20 @@ static int fbcon_fb_unregistered(struct fb_info *info)
 	return 0;
 }
 
+static void fbcon_remap_all(int idx)
+{
+	int i;
+	for (i = first_fb_vc; i <= last_fb_vc; i++)
+		set_con2fb_map(i, idx, 0);
+
+	if (con_is_bound(&fb_con)) {
+		printk(KERN_INFO "fbcon: Remapping primary device, "
+		       "fb%i, to tty %i-%i\n", idx,
+		       first_fb_vc + 1, last_fb_vc + 1);
+		info_idx = idx;
+	}
+}
+
 #ifdef CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY
 static void fbcon_select_primary(struct fb_info *info)
 {
@@ -3225,6 +3239,10 @@ static int fbcon_event_notify(struct notifier_block *self,
 		caps = event->data;
 		fbcon_get_requirement(info, caps);
 		break;
+	case FB_EVENT_REMAP_ALL_CONSOLE:
+		idx = info->node;
+		fbcon_remap_all(idx);
+		break;
 	}
 done:
 	return ret;
diff --git a/include/linux/fb.h b/include/linux/fb.h
index 369767b..c10163b 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -543,6 +543,8 @@ struct fb_cursor_user {
 #define FB_EVENT_GET_REQ                0x0D
 /*      Unbind from the console if possible */
 #define FB_EVENT_FB_UNBIND              0x0E
+/*      CONSOLE-SPECIFIC: remap all consoles to new fb - for vga switcheroo */
+#define FB_EVENT_REMAP_ALL_CONSOLE      0x0F
 
 struct fb_event {
 	struct fb_info *info;
diff --git a/include/linux/vga_switcheroo.h b/include/linux/vga_switcheroo.h
new file mode 100644
index 0000000..ffde472
--- /dev/null
+++ b/include/linux/vga_switcheroo.h
@@ -0,0 +1,65 @@
+/*
+ * Copyright (c) 2010 Red Hat Inc.
+ * Author : Dave Airlie <airlied@redhat.com>
+ *
+ * Licensed under GPLv2
+ *
+ * vga_switcheroo.h - Support for laptop with dual GPU using one set of outputs
+ */
+
+#include <acpi/acpi.h>
+#include <linux/fb.h>
+
+enum vga_switcheroo_state {
+	VGA_SWITCHEROO_OFF,
+	VGA_SWITCHEROO_ON,
+};
+
+enum vga_switcheroo_method {
+	VGA_SWITCHEROO_NONE,
+	VGA_SWITCHEROO_ATPX,
+	VGA_SWITCHEROO_DSM,
+};
+
+enum vga_switcheroo_client_id {
+	VGA_SWITCHEROO_IGD,
+	VGA_SWITCHEROO_DIS,
+	VGA_SWITCHEROO_MAX_CLIENTS,
+};
+
+struct vga_switcheroo_handler {
+	enum vga_switcheroo_method method_id;
+	int (*switchto)(acpi_handle handle,
+			enum vga_switcheroo_client_id id);
+	int (*power_state)(acpi_handle handle,
+			   enum vga_switcheroo_client_id id,
+			   enum vga_switcheroo_state state);
+};
+
+
+#if defined(CONFIG_VGA_SWITCHEROO)
+void vga_switcheroo_unregister_client(struct pci_dev *dev);
+int vga_switcheroo_register_client(struct pci_dev *dev,
+				   void (*set_gpu_state)(struct pci_dev *dev, enum vga_switcheroo_state),
+				   bool (*can_switch)(struct pci_dev *dev));
+
+void vga_switcheroo_client_fb_set(struct pci_dev *dev,
+				  struct fb_info *info);
+
+int vga_switcheroo_register_handler(struct vga_switcheroo_handler *handler);
+void vga_switcheroo_unregister_handler(void);
+
+int vga_switcheroo_process_delayed_switch(void);
+
+#else
+
+static inline void vga_switcheroo_unregister_client(struct pci_dev *dev) {}
+static inline int vga_switcheroo_register_client(struct pci_dev *dev,
+					  void (*set_gpu_state)(struct pci_dev *dev, enum vga_switcheroo_state),
+					  bool (*can_switch)(struct pci_dev *dev)) { return 0; }
+static inline void vga_switcheroo_client_fb_set(struct pci_dev *dev, struct fb_info *info) {}
+static inline int vga_switcheroo_register_handler(struct vga_switcheroo_handler *handler) { return 0; }
+static inline void vga_switcheroo_unregister_handler(void) {}
+static inline int vga_switcheroo_process_delayed_switch(void) { return 0; }
+
+#endif
-- 
1.6.5.2

