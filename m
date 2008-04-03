Return-Path: <linux-kernel-owner+w=401wt.eu-S1759754AbYDCSwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759754AbYDCSwv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 14:52:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755926AbYDCSwm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 14:52:42 -0400
Received: from outbound-mail-38.bluehost.com ([69.89.20.192]:43290 "HELO
	outbound-mail-38.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755894AbYDCSwl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 14:52:41 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC][PATCH 1/3] use new pm_ops in DRM drivers
Date: Thu, 3 Apr 2008 11:50:55 -0700
User-Agent: KMail/1.9.9
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Oliver Neukum <oliver@neukum.org>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       Dave Airlie <airlied@linux.ie>
References: <200804020207.40278.rjw@sisk.pl> <200804020209.47207.rjw@sisk.pl>
In-Reply-To: <200804020209.47207.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200804031150.55967.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 01, 2008 5:09 pm Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
>
> Introduce 'struct pm_ops' and 'struct pm_ext_ops' ('ext' meaning
> 'extended') representing suspend and hibernation operations for bus
> types, device classes, device types and device drivers.
>
> Modify the PM core to use 'struct pm_ops' and 'struct pm_ext_ops'
> objects, if defined, instead of the ->suspend() and ->resume(),
> ->suspend_late(), and ->resume_early() callbacks (the old callbacks
> will be considered as legacy and gradually phased out).
>
> The main purpose of doing this is to separate suspend (aka S2RAM and
> standby) callbacks from hibernation callbacks in such a way that the
> new callbacks won't take arguments and the semantics of each of them
> will be clearly specified.  This has been requested for multiple
> times by many people, including Linus himself, and the reason is that
> within the current scheme if ->resume() is called, for example, it's
> difficult to say why it's been called (ie. is it a resume from RAM or
> from hibernation or a suspend/hibernation failure etc.?).

I like the new ops much better; their purpose is clearer and better separated 
than before.  I think the i915 changes should look something like this?

Also, what about class devices?  Right now, they just have suspend & resume 
callbacks, not full pm_ops structures.  But maybe they're not really 
necessary anyway, I could set the pm_ops.prepare & complete callbacks to DRM 
core routines in order to suspend & resume DRM client requests...

Also, it looks like the PCI bits I had in i915 aren't really necessary?

Thanks,
Jesse

diff --git a/drivers/char/drm/i915_drv.c b/drivers/char/drm/i915_drv.c
index b2b451d..ec6356a 100644
--- a/drivers/char/drm/i915_drv.c
+++ b/drivers/char/drm/i915_drv.c
@@ -239,8 +239,9 @@ static void i915_restore_vga(struct drm_device *dev)
 
 }
 
-static int i915_suspend(struct drm_device *dev, pm_message_t state)
+static int i915_save(struct device *device)
 {
+	struct drm_device *dev = container_of(device, struct drm_device, dev);
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	int i;
 
@@ -250,10 +251,6 @@ static int i915_suspend(struct drm_device *dev, 
pm_message_t state)
 		return -ENODEV;
 	}
 
-	if (state.event == PM_EVENT_PRETHAW)
-		return 0;
-
-	pci_save_state(dev->pdev);
 	pci_read_config_byte(dev->pdev, LBB, &dev_priv->saveLBB);
 
 	/* Pipe & plane A info */
@@ -367,24 +364,16 @@ static int i915_suspend(struct drm_device *dev, 
pm_message_t state)
 
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
+static int i915_restore(struct device *device)
 {
+	struct drm_device *dev = container_of(device, struct drm_device, dev);
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	int i;
 
 	pci_set_power_state(dev->pdev, PCI_D0);
-	pci_restore_state(dev->pdev);
-	if (pci_enable_device(dev->pdev))
-		return -1;
 
 	pci_write_config_byte(dev->pdev, LBB, dev_priv->saveLBB);
 
@@ -527,6 +516,23 @@ static int i915_resume(struct drm_device *dev)
 	return 0;
 }
 
+static int i915_poweroff(struct device *dev)
+{
+	/* Shut down the device */
+	pci_disable_device(dev->pdev);
+	pci_set_power_state(dev->pdev, PCI_D3hot);
+}
+
+static struct pm_ops i915_pm_ops = {
+	.prepare = NULL, /* DRM core should prevent any new ioctls? */
+	.complete = NULL, /* required to re-enable DRM client requests */
+	.suspend = i915_save,
+	.resume = i915_restore,
+	.freeze = i915_save,
+	.restore = i915_restore,
+	.poweroff = i915_poweroff,
+};
+
 static struct drm_driver driver = {
 	/* don't use mtrr's here, the Xserver or user space app should
 	 * deal with them for intel hardware.
@@ -539,8 +545,6 @@ static struct drm_driver driver = {
 	.unload = i915_driver_unload,
 	.lastclose = i915_driver_lastclose,
 	.preclose = i915_driver_preclose,
-	.suspend = i915_suspend,
-	.resume = i915_resume,
 	.device_is_agp = i915_driver_device_is_agp,
 	.vblank_wait = i915_driver_vblank_wait,
 	.vblank_wait2 = i915_driver_vblank_wait2,
@@ -581,6 +585,7 @@ static struct drm_driver driver = {
 static int __init i915_init(void)
 {
 	driver.num_ioctls = i915_max_ioctl;
+	driver->dev.pm_ops = &i915_pm_ops;
 	return drm_init(&driver);
 }
 
