Return-Path: <linux-kernel-owner+w=401wt.eu-S1761096AbYFQWJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761096AbYFQWJP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 18:09:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760387AbYFQWHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 18:07:10 -0400
Received: from outbound-mail-31.bluehost.com ([69.89.18.151]:49553 "HELO
	outbound-mail-31.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758557AbYFQWHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 18:07:05 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] DRM support for new pm_ops hooks
Date: Tue, 17 Jun 2008 15:06:58 -0700
User-Agent: KMail/1.9.9
Cc: Rafael Wysocki <rjw@sisk.pl>, Dave Airlie <airlied@linux.ie>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_CWDWIpcbbM33O5y"
Message-Id: <200806171506.58345.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_CWDWIpcbbM33O5y
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

The PCI linux-next branch has support for the new PM ops hooks, so I thought I 
should refresh the DRM support for suspend/resume based on the new stuff.

I think we can get away with having drivers provide just save/restore hooks 
and let the core take care of the rest.  When we flesh out the 
prepare/complete hooks we may need another driver callback, not sure yet.

How does it look?

Thanks,
Jesse


--Boundary-00=_CWDWIpcbbM33O5y
Content-Type: text/x-diff;
  charset="us-ascii";
  name="i915-new-pm-ops-2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="i915-new-pm-ops-2.patch"

diff --git a/drivers/char/drm/drmP.h b/drivers/char/drm/drmP.h
index 0764b66..f9d3eae 100644
--- a/drivers/char/drm/drmP.h
+++ b/drivers/char/drm/drmP.h
@@ -570,8 +570,8 @@ struct drm_driver {
 	void (*postclose) (struct drm_device *, struct drm_file *);
 	void (*lastclose) (struct drm_device *);
 	int (*unload) (struct drm_device *);
-	int (*suspend) (struct drm_device *, pm_message_t state);
-	int (*resume) (struct drm_device *);
+	int (*save) (struct drm_device *);
+	int (*restore) (struct drm_device *);
 	int (*dma_ioctl) (struct drm_device *dev, void *data, struct drm_file *file_priv);
 	void (*dma_ready) (struct drm_device *);
 	int (*dma_quiescent) (struct drm_device *);
diff --git a/drivers/char/drm/drm_sysfs.c b/drivers/char/drm/drm_sysfs.c
index af211a0..1cf426e 100644
--- a/drivers/char/drm/drm_sysfs.c
+++ b/drivers/char/drm/drm_sysfs.c
@@ -22,42 +22,107 @@
 #define to_drm_minor(d) container_of(d, struct drm_minor, kdev)
 
 /**
- * drm_sysfs_suspend - DRM class suspend hook
+ * drm_prepare - DRM class prepare hook
  * @dev: Linux device to suspend
- * @state: power state to enter
  *
- * Just figures out what the actual struct drm_device associated with
- * @dev is and calls its suspend hook, if present.
+ * Suspend any DRM activity by putting clients to sleep, but don't touch
+ * hardware.
+ *
+ * Gets called before suspend, freeze, and poweroff.  Sleeping ok (though
+ * don't rely on userspace).
+ *
+ * Should prevent new DMA requests, device registration, etc., as well
+ * as wait for any outstanding requests to complete (except for maybe
+ * distant vblank events).
+ */
+static int drm_prepare(struct device *dev)
+{
+	/* FIXME: call into drivers etc. as needed */
+	return 0;
+}
+
+/**
+ * drm_complete - DRM class complete hook
+ * @dev: Linux device to suspend
+ *
+ * Finish a resume or restore.  Called after resume, thaw, and restore (or
+ * if suspend, freeze or poweroff fail).
  */
-static int drm_sysfs_suspend(struct device *dev, pm_message_t state)
+static void drm_complete(struct device *dev)
+{
+}
+
+static int drm_sysfs_save(struct device *dev)
 {
 	struct drm_minor *drm_minor = to_drm_minor(dev);
 	struct drm_device *drm_dev = drm_minor->dev;
 
-	if (drm_dev->driver->suspend)
-		return drm_dev->driver->suspend(drm_dev, state);
+	if (drm_dev->driver->save)
+		return drm_dev->driver->save(drm_dev);
+
+	return 0;
+}
+
+static int drm_sysfs_restore(struct device *dev)
+{
+	struct drm_minor *drm_minor = to_drm_minor(dev);
+	struct drm_device *drm_dev = drm_minor->dev;
+
+	if (drm_dev->driver->restore)
+		return drm_dev->driver->restore(drm_dev);
 
 	return 0;
 }
 
 /**
- * drm_sysfs_resume - DRM class resume hook
- * @dev: Linux device to resume
+ * drm_sysfs_poweroff - DRM class poweroff hook
+ * @dev: Linux device to power off
  *
- * Just figures out what the actual struct drm_device associated with
- * @dev is and calls its resume hook, if present.
+ * Put a device into low power state for suspend or hibernate
  */
-static int drm_sysfs_resume(struct device *dev)
+static int drm_sysfs_poweroff(struct device *dev)
 {
 	struct drm_minor *drm_minor = to_drm_minor(dev);
 	struct drm_device *drm_dev = drm_minor->dev;
 
-	if (drm_dev->driver->resume)
-		return drm_dev->driver->resume(drm_dev);
+	/* Shut down the device */
+	pci_disable_device(drm_dev->pdev);
+	pci_set_power_state(drm_dev->pdev, PCI_D3hot);
 
 	return 0;
 }
 
+/**
+ * drm_sysfs_suspend - DRM class suspend hook
+ * @dev: Linux device to suspend
+ *
+ * Just figures out what the actual struct drm_device associated with
+ * @dev is and calls its suspend hook, if present.
+ */
+static int drm_sysfs_suspend(struct device *dev)
+{
+	int ret = 0;
+
+	/* Suspend is just save, poweroff */
+	ret = drm_sysfs_save(dev);
+	if (ret)
+		return ret;
+
+	return drm_sysfs_poweroff(dev);
+}
+
+/**
+ * drm_sysfs_resume - DRM class resume hook
+ * @dev: Linux device to resume
+ *
+ * Just figures out what the actual struct drm_device associated with
+ * @dev is and calls its resume hook, if present.
+ */
+static int drm_sysfs_resume(struct device *dev)
+{
+	return drm_sysfs_restore(dev);
+}
+
 /* Display the version of drm_core. This doesn't work right in current design */
 static ssize_t version_show(struct class *dev, char *buf)
 {
@@ -67,6 +132,16 @@ static ssize_t version_show(struct class *dev, char *buf)
 
 static CLASS_ATTR(version, S_IRUGO, version_show, NULL);
 
+static struct pm_ops drm_pm_ops = {
+	.prepare = drm_prepare,
+	.complete = drm_complete,
+	.poweroff = drm_sysfs_poweroff,
+	.suspend = drm_sysfs_suspend,
+	.resume = drm_sysfs_resume,
+	.freeze = drm_sysfs_save,
+	.restore = drm_sysfs_restore,
+};
+
 /**
  * drm_sysfs_create - create a struct drm_sysfs_class structure
  * @owner: pointer to the module that is to "own" this struct drm_sysfs_class
@@ -89,8 +164,7 @@ struct class *drm_sysfs_create(struct module *owner, char *name)
 		goto err_out;
 	}
 
-	class->suspend = drm_sysfs_suspend;
-	class->resume = drm_sysfs_resume;
+	class->pm = &drm_pm_ops;
 
 	err = class_create_file(class, &class_attr_version);
 	if (err)
diff --git a/drivers/char/drm/i915_drv.c b/drivers/char/drm/i915_drv.c
index e8f3d68..a014aa9 100644
--- a/drivers/char/drm/i915_drv.c
+++ b/drivers/char/drm/i915_drv.c
@@ -239,7 +239,7 @@ static void i915_restore_vga(struct drm_device *dev)
 
 }
 
-static int i915_suspend(struct drm_device *dev, pm_message_t state)
+static int i915_save(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	int i;
@@ -250,10 +250,6 @@ static int i915_suspend(struct drm_device *dev, pm_message_t state)
 		return -ENODEV;
 	}
 
-	if (state.event == PM_EVENT_PRETHAW)
-		return 0;
-
-	pci_save_state(dev->pdev);
 	pci_read_config_byte(dev->pdev, LBB, &dev_priv->saveLBB);
 
 	/* Display arbitration control */
@@ -371,24 +367,15 @@ static int i915_suspend(struct drm_device *dev, pm_message_t state)
 
 	i915_save_vga(dev);
 
-	if (state.event == PM_EVENT_SUSPEND) {
-		/* Shut down the device */
-		pci_disable_device(dev->pdev);
-		pci_set_power_state(dev->pdev, PCI_D3hot);
-	}
-
 	return 0;
 }
 
-static int i915_resume(struct drm_device *dev)
+static int i915_restore(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	int i;
 
 	pci_set_power_state(dev->pdev, PCI_D0);
-	pci_restore_state(dev->pdev);
-	if (pci_enable_device(dev->pdev))
-		return -1;
 
 	pci_write_config_byte(dev->pdev, LBB, dev_priv->saveLBB);
 
@@ -544,10 +531,10 @@ static struct drm_driver driver = {
 	    DRIVER_IRQ_VBL2,
 	.load = i915_driver_load,
 	.unload = i915_driver_unload,
+	.save = i915_save,
+	.restore = i915_restore,
 	.lastclose = i915_driver_lastclose,
 	.preclose = i915_driver_preclose,
-	.suspend = i915_suspend,
-	.resume = i915_resume,
 	.device_is_agp = i915_driver_device_is_agp,
 	.vblank_wait = i915_driver_vblank_wait,
 	.vblank_wait2 = i915_driver_vblank_wait2,

--Boundary-00=_CWDWIpcbbM33O5y--
