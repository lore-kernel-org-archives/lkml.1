Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab0BGUr4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 15:47:56 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54923 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568Ab0BGUrx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 15:47:53 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Zhenyu Wang <zhenyuw@linux.intel.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Eric Anholt <eric@anholt.net>
Subject: [PATCH] i915 / PM: Fix crash while aborting hibernation (Re: [linux-pm] [regression] "drm/i915: implement new pm ops" disables irq on aborted s2disk)
Date: Sun, 7 Feb 2010 21:48:24 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc7-rjw; KDE/4.3.5; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, dri-devel@lists.sourceforge.net,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <4B695BA0.4000007@tuffmail.co.uk> <201002032344.41915.rjw@sisk.pl> <20100204013157.GA30011@zhen-devel.sh.intel.com>
In-Reply-To: <20100204013157.GA30011@zhen-devel.sh.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201002072148.24588.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 February 2010, Zhenyu Wang wrote:
> On 2010.02.03 23:44:41 +0100, Rafael J. Wysocki wrote:
> > On Wednesday 03 February 2010, Alan Jenkins wrote:
> > > Hi
> > > 
> > > I found this regression on my EeePC 701 with modesetting enabled.  When 
> > > I hibernate using s2disk, I can abort the hibernation by pressing the 
> > > backspace key.  Doing so breaks X on 2.6.32-rc6 (but not 2.6.32).
> > 
> > Yeah.
> > 
> > To be honest, I knew that's going to happen, but didn't have the time to take
> > care of it.
> > 
> > The problem is that i915 does literally _nothing_ in its .thaw() callback,
> > although it should at least reverse whatever .freeze() did to the hardware
> > (and memory allocations and so on), so that the adapter is functional
> > after creating the image.
> > 
> > Fixing this requires some thought, though, because at the moment .freeze()
> > thinks it's .suspend(), which is not the case as this report clearly shows.
> > So, in fact i915_pci_suspend() has to be split into the .freeze() part and
> > the poweroff part cleanly and that's not  so simple (at least to me).
> > 
> 
> Right, I think that'll be more clean, stuff in i915_save/restore_state() need
> to be splited too, especially isolate stuff for mode setting and other device
> state, as what my original purpose for this is to remove extra mode setting 
> cycle in old behavior so not waste time for hibernate.

We can't really do that, because we'll need to restore the saved state at the
resume-from-hibernation stage.

The appended patch fixes the issue for me, although it's been only tested
a little.  It sort of defeats the purpose of commit
cbda12d77ea590082edb6d30bd342a67ebc459e0, but I don't see any less invasive
way to fix this except maybe for reverting that commit entirely.

Note that the drm_irq_[un]install() thing may be unnecessary, but I wasn't sure
about that and surely wouldn't suggest doing that for 2.6.33.  Also it looks like
some things from the freeze and thaw parts may be moved to the "low-level"
suspend and resume parts, respectively, but that would require some
i915_gem_* surgery I was too scared to do.

Alan, please test, i915 guys, please review.

Rafael

---
Subject: i915 / PM: Fix crash while aborting hibernation
From: Rafael J. Wysocki <rjw@sisk.pl>

Commit cbda12d77ea590082edb6d30bd342a67ebc459e0 (drm/i915: implement
new pm ops for i915) introduced the problem that if s2disk
hibernation is aborted, the system will crash, because
i915_pm_freeze() does nothing, while it should at least reverse some
operations carried out by i915_suspend().

Fix this issue by splitting the i915 suspend into a freeze part a
suspend part, where the latter is not executed before creating a
hibernation image, and the i915 resume into a "low-level" resume
part and a thaw part, where the former is not executed after the
image has been created.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/gpu/drm/i915/i915_drv.c |  168 ++++++++++++++++++++++++----------------
 1 file changed, 101 insertions(+), 67 deletions(-)

Index: linux-2.6/drivers/gpu/drm/i915/i915_drv.c
===================================================================
--- linux-2.6.orig/drivers/gpu/drm/i915/i915_drv.c
+++ linux-2.6/drivers/gpu/drm/i915/i915_drv.c
@@ -175,78 +175,100 @@ const static struct pci_device_id pciidl
 MODULE_DEVICE_TABLE(pci, pciidlist);
 #endif
 
-static int i915_suspend(struct drm_device *dev, pm_message_t state)
+static int i915_drm_freeze(struct drm_device *dev)
 {
-	struct drm_i915_private *dev_priv = dev->dev_private;
-
-	if (!dev || !dev_priv) {
-		DRM_ERROR("dev: %p, dev_priv: %p\n", dev, dev_priv);
-		DRM_ERROR("DRM not initialized, aborting suspend.\n");
-		return -ENODEV;
-	}
-
-	if (state.event == PM_EVENT_PRETHAW)
-		return 0;
-
 	pci_save_state(dev->pdev);
 
 	/* If KMS is active, we do the leavevt stuff here */
 	if (drm_core_check_feature(dev, DRIVER_MODESET)) {
-		if (i915_gem_idle(dev))
+		int error = i915_gem_idle(dev);
+		if (error) {
 			dev_err(&dev->pdev->dev,
-				"GEM idle failed, resume may fail\n");
+				"GEM idle failed, resume might fail\n");
+			return error;
+		}
 		drm_irq_uninstall(dev);
 	}
 
 	i915_save_state(dev);
 
+	return 0;
+}
+
+static void i915_drm_suspend(struct drm_device *dev)
+{
+	struct drm_i915_private *dev_priv = dev->dev_private;
+
 	intel_opregion_free(dev, 1);
 
+	/* Modeset on resume, not lid events */
+	dev_priv->modeset_on_lid = 0;
+}
+
+static int i915_suspend(struct drm_device *dev, pm_message_t state)
+{
+	int error;
+
+	if (!dev || !dev->dev_private) {
+		DRM_ERROR("dev: %p\n", dev);
+		DRM_ERROR("DRM not initialized, aborting suspend.\n");
+		return -ENODEV;
+	}
+
+	if (state.event == PM_EVENT_PRETHAW)
+		return 0;
+
+	error = i915_drm_freeze(dev);
+	if (error)
+		return error;
+
+	i915_drm_suspend(dev);
+
 	if (state.event == PM_EVENT_SUSPEND) {
 		/* Shut down the device */
 		pci_disable_device(dev->pdev);
 		pci_set_power_state(dev->pdev, PCI_D3hot);
 	}
 
-	/* Modeset on resume, not lid events */
-	dev_priv->modeset_on_lid = 0;
-
 	return 0;
 }
 
-static int i915_resume(struct drm_device *dev)
+static int i915_drm_thaw(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
-	int ret = 0;
-
-	if (pci_enable_device(dev->pdev))
-		return -1;
-	pci_set_master(dev->pdev);
-
-	i915_restore_state(dev);
-
-	intel_opregion_init(dev, 1);
+	int error = 0;
 
 	/* KMS EnterVT equivalent */
 	if (drm_core_check_feature(dev, DRIVER_MODESET)) {
 		mutex_lock(&dev->struct_mutex);
 		dev_priv->mm.suspended = 0;
 
-		ret = i915_gem_init_ringbuffer(dev);
-		if (ret != 0)
-			ret = -1;
+		error = i915_gem_init_ringbuffer(dev);
 		mutex_unlock(&dev->struct_mutex);
 
 		drm_irq_install(dev);
-	}
-	if (drm_core_check_feature(dev, DRIVER_MODESET)) {
+
 		/* Resume the modeset for every activated CRTC */
 		drm_helper_resume_force_mode(dev);
 	}
 
 	dev_priv->modeset_on_lid = 0;
 
-	return ret;
+	return error;
+}
+
+static int i915_resume(struct drm_device *dev)
+{
+	if (pci_enable_device(dev->pdev))
+		return -EIO;
+
+	pci_set_master(dev->pdev);
+
+	i915_restore_state(dev);
+
+	intel_opregion_init(dev, 1);
+
+	return i915_drm_thaw(dev);
 }
 
 /**
@@ -387,57 +409,69 @@ i915_pci_remove(struct pci_dev *pdev)
 	drm_put_dev(dev);
 }
 
-static int
-i915_pci_suspend(struct pci_dev *pdev, pm_message_t state)
+static int i915_pm_suspend(struct device *dev)
 {
-	struct drm_device *dev = pci_get_drvdata(pdev);
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct drm_device *drm_dev = pci_get_drvdata(pdev);
+	int error;
 
-	return i915_suspend(dev, state);
-}
+	if (!drm_dev || !drm_dev->dev_private) {
+		dev_err(dev, "DRM not initialized, aborting suspend.\n");
+		return -ENODEV;
+	}
 
-static int
-i915_pci_resume(struct pci_dev *pdev)
-{
-	struct drm_device *dev = pci_get_drvdata(pdev);
+	error = i915_drm_freeze(drm_dev);
+	if (error)
+		return error;
 
-	return i915_resume(dev);
-}
+	i915_drm_suspend(drm_dev);
 
-static int
-i915_pm_suspend(struct device *dev)
-{
-	return i915_pci_suspend(to_pci_dev(dev), PMSG_SUSPEND);
-}
+	pci_disable_device(pdev);
+	pci_set_power_state(pdev, PCI_D3hot);
 
-static int
-i915_pm_resume(struct device *dev)
-{
-	return i915_pci_resume(to_pci_dev(dev));
+	return 0;
 }
 
-static int
-i915_pm_freeze(struct device *dev)
+static int i915_pm_resume(struct device *dev)
 {
-	return i915_pci_suspend(to_pci_dev(dev), PMSG_FREEZE);
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct drm_device *drm_dev = pci_get_drvdata(pdev);
+
+	return i915_resume(drm_dev);
 }
 
-static int
-i915_pm_thaw(struct device *dev)
+static int i915_pm_freeze(struct device *dev)
 {
-	/* thaw during hibernate, do nothing! */
-	return 0;
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct drm_device *drm_dev = pci_get_drvdata(pdev);
+
+	if (!drm_dev || !drm_dev->dev_private) {
+		dev_err(dev, "DRM not initialized, aborting suspend.\n");
+		return -ENODEV;
+	}
+
+	return i915_drm_freeze(drm_dev);
 }
 
-static int
-i915_pm_poweroff(struct device *dev)
+static int i915_pm_thaw(struct device *dev)
 {
-	return i915_pci_suspend(to_pci_dev(dev), PMSG_HIBERNATE);
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct drm_device *drm_dev = pci_get_drvdata(pdev);
+
+	return i915_drm_thaw(drm_dev);
 }
 
-static int
-i915_pm_restore(struct device *dev)
+static int i915_pm_poweroff(struct device *dev)
 {
-	return i915_pci_resume(to_pci_dev(dev));
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct drm_device *drm_dev = pci_get_drvdata(pdev);
+	int error;
+
+	error = i915_drm_freeze(drm_dev);
+	if (!error)
+		i915_drm_suspend(drm_dev);
+
+	return error;
 }
 
 const struct dev_pm_ops i915_pm_ops = {
@@ -446,7 +480,7 @@ const struct dev_pm_ops i915_pm_ops = {
      .freeze = i915_pm_freeze,
      .thaw = i915_pm_thaw,
      .poweroff = i915_pm_poweroff,
-     .restore = i915_pm_restore,
+     .restore = i915_pm_resume,
 };
 
 static struct vm_operations_struct i915_gem_vm_ops = {
