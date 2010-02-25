Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932348Ab0BYEog (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 23:44:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43568 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932290Ab0BYEod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 23:44:33 -0500
From: Dave Airlie <airlied@gmail.com>
To: linux-fbdev@vger.kernel.org
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       Dave Airlie <airlied@linux.ie>
Subject: [PATCH 2/2] vga switch: hi my name is race condition
Date: Thu, 25 Feb 2010 14:44:27 +1000
Message-Id: <1267073067-23117-3-git-send-email-airlied@gmail.com>
In-Reply-To: <1267073067-23117-2-git-send-email-airlied@gmail.com>
References: <1267073067-23117-1-git-send-email-airlied@gmail.com>
 <1267073067-23117-2-git-send-email-airlied@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Airlie <airlied@linux.ie>

This adds a delayed switch mode, and also changes the debugfs file
to accept different parameters.
It also adds switch blocking by the drm if any devices are in use

echo:
DIS - immediate change to discrete
IGD - immediate change to IGD
DDIS - delayed change to discrete
DIGD - delayed change to IGD
ON - turn on not in use
OFF - turn off not in use

no more PCI IDs.
---
 drivers/gpu/drm/i915/i915_dma.c              |   16 ++++-
 drivers/gpu/drm/nouveau/nouveau_state.c      |   14 +++-
 drivers/gpu/drm/radeon/r600_audio.c          |    3 +
 drivers/gpu/drm/radeon/radeon.h              |    2 +
 drivers/gpu/drm/radeon/radeon_atpx_handler.c |    2 +
 drivers/gpu/drm/radeon/radeon_device.c       |   26 ++++++-
 drivers/gpu/drm/radeon/radeon_kms.c          |    3 +
 drivers/gpu/vga/vga_switcheroo.c             |  108 ++++++++++++++++++++++---
 include/linux/vga_switcheroo.h               |    5 +-
 9 files changed, 162 insertions(+), 17 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index 2e70292..3fb32fd 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -1202,6 +1202,17 @@ static void i915_switcheroo_set_state(struct pci_dev *pdev, enum vga_switcheroo_
 	}
 }
 
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
@@ -1271,7 +1282,9 @@ static int i915_load_modeset_init(struct drm_device *dev,
 	if (ret)
 		goto destroy_ringbuffer;
 
-	ret = vga_switcheroo_register_client(dev->pdev, i915_switcheroo_set_state);
+	ret = vga_switcheroo_register_client(dev->pdev,
+					     i915_switcheroo_set_state,
+					     i915_switcheroo_can_switch);
 	if (ret)
 		goto destroy_ringbuffer;
 
@@ -1624,6 +1637,7 @@ void i915_driver_lastclose(struct drm_device * dev)
 
 	if (!dev_priv || drm_core_check_feature(dev, DRIVER_MODESET)) {
 		drm_fb_helper_restore();
+		vga_switcheroo_process_delayed_switch();
 		return;
 	}
 
diff --git a/drivers/gpu/drm/nouveau/nouveau_state.c b/drivers/gpu/drm/nouveau/nouveau_state.c
index 940fdd3..afddcca 100644
--- a/drivers/gpu/drm/nouveau/nouveau_state.c
+++ b/drivers/gpu/drm/nouveau/nouveau_state.c
@@ -377,6 +377,17 @@ static void nouveau_switcheroo_set_state (struct pci_dev *pdev,
 	}
 }
 
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
@@ -390,7 +401,8 @@ nouveau_card_init(struct drm_device *dev)
 		return 0;
 
 	vga_client_register(dev->pdev, dev, NULL, nouveau_vga_set_decode);
-	vga_switcheroo_register_client(dev->pdev, nouveau_switcheroo_set_state);
+	vga_switcheroo_register_client(dev->pdev, nouveau_switcheroo_set_state,
+				       nouveau_switcheroo_can_switch);
 
 	/* Initialise internal driver API hooks */
 	ret = nouveau_init_engine_ptrs(dev);
diff --git a/drivers/gpu/drm/radeon/r600_audio.c b/drivers/gpu/drm/radeon/r600_audio.c
index 99e2c38..e880cd8 100644
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
index f7df1a7..694c453 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -829,6 +829,8 @@ struct radeon_device {
 	int			audio_bits_per_sample;
 	uint8_t			audio_status_bits;
 	uint8_t			audio_category_code;
+
+	bool powered_down;
 };
 
 int radeon_device_init(struct radeon_device *rdev,
diff --git a/drivers/gpu/drm/radeon/radeon_atpx_handler.c b/drivers/gpu/drm/radeon/radeon_atpx_handler.c
index 808d980..c614794 100644
--- a/drivers/gpu/drm/radeon/radeon_atpx_handler.c
+++ b/drivers/gpu/drm/radeon/radeon_atpx_handler.c
@@ -3,6 +3,8 @@
  * Author : Dave Airlie <airlied@redhat.com>
  * 
  * Licensed under GPLv2
+ *
+ * ATPX support for both Intel/ATI
  */
 
 #include <linux/vga_switcheroo.h>
diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index 3ad4aba..a9b87b4 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -620,16 +620,33 @@ void radeon_check_arguments(struct radeon_device *rdev)
 static void radeon_switcheroo_set_state(struct pci_dev *pdev, enum vga_switcheroo_state state)
 {
 	struct drm_device *dev = pci_get_drvdata(pdev);
+	struct radeon_device *rdev = dev->dev_private;
 	pm_message_t pmm = { .event = PM_EVENT_SUSPEND };
 	if (state == VGA_SWITCHEROO_ON) {
 		printk(KERN_ERR "VGA switched radeon on\n");
 		radeon_resume_kms(dev);
+		r600_audio_init(rdev);
 	} else {
 		printk(KERN_ERR "VGA switched radeon off\n");
+		r600_audio_fini(rdev);
 		radeon_suspend_kms(dev, pmm);
 	}
+	/* don't suspend or resume card normally */
+	rdev->powered_down = true;
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
 }
 
+
 int radeon_device_init(struct radeon_device *rdev,
 		       struct drm_device *ddev,
 		       struct pci_dev *pdev,
@@ -709,7 +726,9 @@ int radeon_device_init(struct radeon_device *rdev,
 	/* this will fail for cards that aren't VGA class devices, just
 	 * ignore it */
 	vga_client_register(rdev->pdev, rdev, NULL, radeon_vga_set_decode);
-	vga_switcheroo_register_client(rdev->pdev, radeon_switcheroo_set_state);
+	vga_switcheroo_register_client(rdev->pdev,
+				       radeon_switcheroo_set_state,
+				       radeon_switcheroo_can_switch);
 
 	r = radeon_init(rdev);
 	if (r)
@@ -764,6 +783,8 @@ int radeon_suspend_kms(struct drm_device *dev, pm_message_t state)
 	}
 	rdev = dev->dev_private;
 
+	if (rdev->powered_down)
+		return 0;
 	/* unpin the front buffers */
 	list_for_each_entry(crtc, &dev->mode_config.crtc_list, head) {
 		struct radeon_framebuffer *rfb = to_radeon_framebuffer(crtc->fb);
@@ -809,6 +830,9 @@ int radeon_resume_kms(struct drm_device *dev)
 {
 	struct radeon_device *rdev = dev->dev_private;
 
+	if (rdev->powered_down)
+		return 0;
+
 	acquire_console_sem();
 	pci_set_power_state(dev->pdev, PCI_D0);
 	pci_restore_state(dev->pdev);
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
diff --git a/drivers/gpu/vga/vga_switcheroo.c b/drivers/gpu/vga/vga_switcheroo.c
index c4779ab..6b4781a 100644
--- a/drivers/gpu/vga/vga_switcheroo.c
+++ b/drivers/gpu/vga/vga_switcheroo.c
@@ -36,21 +36,21 @@ struct vga_switcheroo_client {
 	struct pci_dev *pdev;
 	struct fb_info *fb_info;
 	int pwr_state;
-	/* TODO callbacks */
 	void (*set_gpu_state)(struct pci_dev *pdev, enum vga_switcheroo_state);
-	/* TODO callbacks */
-	void (*switch_check)(struct pci_dev *pdev);
+	bool (*can_switch)(struct pci_dev *pdev);
 };
 	
 struct vgasr_priv {
 
 	bool active;
+	bool delayed_switch_active;
+	enum vga_switcheroo_client_id delayed_client_id;
 
 	struct dentry *debugfs_root;
 	struct dentry *switch_file;
 
 	enum vga_switcheroo_method method;
-	int active_client;
+	enum vga_switcheroo_client_id active_client;
 
 	int registered_clients;
 	struct vga_switcheroo_client clients[VGA_SWITCHEROO_MAX_CLIENTS];
@@ -164,7 +164,8 @@ void vga_switcheroo_unregister_handler(void)
 EXPORT_SYMBOL(vga_switcheroo_unregister_handler);
 
 int vga_switcheroo_register_client(struct pci_dev *pdev,
-				   void (*set_gpu_state)(struct pci_dev *pdev, enum vga_switcheroo_state))
+				   void (*set_gpu_state)(struct pci_dev *pdev, enum vga_switcheroo_state),
+				   bool (*can_switch)(struct pci_dev *pdev))
 {
 	enum vga_switcheroo_client_id client_id;
 
@@ -178,6 +179,7 @@ int vga_switcheroo_register_client(struct pci_dev *pdev,
 	vgasr_priv.clients[client_id].pwr_state = VGA_SWITCHEROO_ON;
 	vgasr_priv.clients[client_id].pdev = pdev;
 	vgasr_priv.clients[client_id].set_gpu_state = set_gpu_state;
+	vgasr_priv.clients[client_id].can_switch = can_switch;
 	if (pdev->resource[PCI_ROM_RESOURCE].flags & IORESOURCE_ROM_SHADOW)
 		vgasr_priv.active_client = client_id;
 
@@ -305,8 +307,10 @@ vga_switcheroo_debugfs_write(struct file *filp, const char __user *ubuf,
 			     size_t cnt, loff_t *ppos)
 {
 	char pci_id[64];
-	char *pdev_name;
+	const char *pdev_name;
 	int i, ret;
+	enum vga_switcheroo_client_id client_id = -1;
+	bool delay = false, can_switch;
 
 	if (cnt > 63)
 		cnt = 63;
@@ -314,6 +318,7 @@ vga_switcheroo_debugfs_write(struct file *filp, const char __user *ubuf,
 	if (copy_from_user(pci_id, ubuf, cnt))
 		return -EFAULT;
 
+
 	/* pwr off the device not in use */
 	if (strncmp(pci_id, "OFF", 3) == 0) {
 		for (i = 0; i < VGA_SWITCHEROO_MAX_CLIENTS; i++) {
@@ -336,17 +341,60 @@ vga_switcheroo_debugfs_write(struct file *filp, const char __user *ubuf,
 		}
 		goto out;
 	}
-	/* switch devices */
+
+	/* request a delayed switch - test can we switch now */
+	if (strncmp(pci_id, "DIGD", 4) == 0) {
+		client_id = VGA_SWITCHEROO_IGD;
+		delay = true;
+	}
+
+	if (strncmp(pci_id, "DDIS", 4) == 0) {
+		client_id = VGA_SWITCHEROO_DIS;
+		delay = true;
+	}
+
+	if (strncmp(pci_id, "IGD", 3) == 0) {
+		client_id = VGA_SWITCHEROO_IGD;
+	}
+
+	if (strncmp(pci_id, "DIS", 3) == 0) {
+		client_id = VGA_SWITCHEROO_DIS;
+	}
+
+	if (client_id == -1)
+		goto out;
+
+	vgasr_priv.delayed_switch_active = false;
+	/* okay we want a switch - test if devices are willing to switch */
+	can_switch = true;
 	for (i = 0; i < VGA_SWITCHEROO_MAX_CLIENTS; i++) {
-		pdev_name = pci_name(vgasr_priv.clients[i].pdev);
-		if (strncmp(pci_id, pdev_name, strlen(pdev_name)) == 0) {
-			printk("switching to %d %s\n", i, pdev_name);
-			ret = vga_switchto(i);
-			if (ret)
-				printk("switching failed %d\n", ret);
+		can_switch = vgasr_priv.clients[i].can_switch(vgasr_priv.clients[i].pdev);
+		if (can_switch == false) {
+			printk(KERN_ERR "Client %d refused switch\n", i);
 			break;
 		}
 	}
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
 out:
 	return cnt;
 }
@@ -395,3 +443,37 @@ fail:
 	vga_switcheroo_debugfs_fini(priv);
 	return -1;
 }
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
diff --git a/include/linux/vga_switcheroo.h b/include/linux/vga_switcheroo.h
index 694cfc5..fc30f82 100644
--- a/include/linux/vga_switcheroo.h
+++ b/include/linux/vga_switcheroo.h
@@ -29,7 +29,8 @@ enum vga_switcheroo_client_id {
 
 void vga_switcheroo_unregister_client(struct pci_dev *dev);
 int vga_switcheroo_register_client(struct pci_dev *dev,
-				   void (*set_gpu_state)(struct pci_dev *dev, enum vga_switcheroo_state));
+				   void (*set_gpu_state)(struct pci_dev *dev, enum vga_switcheroo_state),
+				   bool (*can_switch)(struct pci_dev *dev));
 
 void vga_switcheroo_client_fb_set(struct pci_dev *dev,
 				  struct fb_info *info);
@@ -45,3 +46,5 @@ struct vga_switcheroo_handler {
 
 int vga_switcheroo_register_handler(struct vga_switcheroo_handler *handler);
 void vga_switcheroo_unregister_handler(void);
+
+int vga_switcheroo_process_delayed_switch(void);
-- 
1.6.5.2

