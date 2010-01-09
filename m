Return-Path: <linux-kernel-owner+w=401wt.eu-S1754087Ab0AINfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab0AINfg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 08:35:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752410Ab0AINff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 08:35:35 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54310 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869Ab0AINfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 08:35:34 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH] i915: Always register as a PCI driver (was: Re: [PATCH] DRM / i915: Fix resume regression on MSI Wind U100 w/o KMS)
Date: Sat, 9 Jan 2010 14:35:56 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc3-rjw; KDE/4.3.3; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Eric Anholt <eric@anholt.net>, Zhenyu Wang <zhenyuw@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.sourceforge.net
References: <201001090045.33784.rjw@sisk.pl> <alpine.LFD.2.00.1001081648490.7821@localhost.localdomain> <20100108171311.128c43d0@jbarnes-piketon>
In-Reply-To: <20100108171311.128c43d0@jbarnes-piketon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001091435.56157.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 09 January 2010, Jesse Barnes wrote:
> On Fri, 8 Jan 2010 16:50:57 -0800 (PST)
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > 
> > 
> > On Sat, 9 Jan 2010, Rafael J. Wysocki wrote:
> > > 
> > > Which is functionally equivalent to my patch, because
> > > i915_suspend/resume() won't be called by drm_class_suspend/resume()
> > > in the KMS case anyway.
> > 
> > Ahh, right you are - that class suspend function does a check for 
> > DRIVER_MODESET, and only does the suspend/resume if it's not a
> > MODESET driver.
> > 
> > Ok, so I withdraw my objections to your original patch - it's
> > confusing, but that's just because DRM is such a horrible mess with
> > subtle things.
> 
> Yeah the non-KMS paths just suck.
> 
> Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
> 
> Though hopefully you can get the PCI driver registration working w/o
> too much trouble; that would be even better.

Actually, I have a working patch, with one tiny detail I'm not sure of.

Namely, I need to call pci_set_drvdata(pdev, dev) unconditionally in drm_stub.c
for the things to work, but I _think_ it won't hurt even if we're not going to
use the pdev's private data.

The benefit of this is having just one code path for suspend/resume instead of
two different code paths depending on whether the driver is using the KMS or
not, which is well worth it IMO.

The patch is appended.

Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: DRM / i915: Always register as a PCI driver

Commit cbda12d77ea590082edb6d30bd342a67ebc459e0 (drm/i915: implement
new pm ops for i915), among other things, removed the .suspend and
.resume pointers from the struct drm_driver object in i915_drv.c,
which broke resume without KMS on my MSI Wind U100.

The reason of the breakage is that in the non-KMS case i915 is
not registered as a PCI driver and uses device class suspend and
resume callbacks that, in turn, execute the callbacks defined in the
struct drm_driver object.  Consequently, after commit cbda12d77ea59,
the driver's suspend and resume callbacks are not executed at all in
the non-KMS case.

To prevent this from happening, set DRIVER_MODESET unconditinally
in driver.driver_features before calling drm_init(), so that it
always registeres us as a PCI driver, and make i915_pci_probe()
reset DRIVER_MODESET in the non-KMS case.  This way the driver's PCI
suspend and resume callbacks will always be used and the problem
will be avoided.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/gpu/drm/drm_stub.c      |    3 +-
 drivers/gpu/drm/i915/i915_drv.c |   44 +++++++++++++++++++++-------------------
 2 files changed, 26 insertions(+), 21 deletions(-)

Index: linux-2.6/drivers/gpu/drm/i915/i915_drv.c
===================================================================
--- linux-2.6.orig/drivers/gpu/drm/i915/i915_drv.c
+++ linux-2.6/drivers/gpu/drm/i915/i915_drv.c
@@ -372,6 +372,28 @@ int i965_reset(struct drm_device *dev, u
 static int __devinit
 i915_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
+	/*
+	 * If CONFIG_DRM_I915_KMS is set, default to KMS unless
+	 * explicitly disabled with the module pararmeter.
+	 *
+	 * Otherwise, just follow the parameter (defaulting to off).
+	 *
+	 * Allow optional vga_text_mode_force boot option to override
+	 * the default behavior.
+	 */
+	if (i915_modeset == 0)
+		driver.driver_features &= ~DRIVER_MODESET;
+
+#ifndef CONFIG_DRM_I915_KMS
+	if (i915_modeset != 1)
+		driver.driver_features &= ~DRIVER_MODESET;
+#endif
+
+#ifdef CONFIG_VGA_CONSOLE
+	if (vgacon_text_force() && i915_modeset == -1)
+		driver.driver_features &= ~DRIVER_MODESET;
+#endif
+
 	return drm_get_dev(pdev, ent, &driver);
 }
 
@@ -520,26 +542,8 @@ static int __init i915_init(void)
 
 	i915_gem_shrinker_init();
 
-	/*
-	 * If CONFIG_DRM_I915_KMS is set, default to KMS unless
-	 * explicitly disabled with the module pararmeter.
-	 *
-	 * Otherwise, just follow the parameter (defaulting to off).
-	 *
-	 * Allow optional vga_text_mode_force boot option to override
-	 * the default behavior.
-	 */
-#if defined(CONFIG_DRM_I915_KMS)
-	if (i915_modeset != 0)
-		driver.driver_features |= DRIVER_MODESET;
-#endif
-	if (i915_modeset == 1)
-		driver.driver_features |= DRIVER_MODESET;
-
-#ifdef CONFIG_VGA_CONSOLE
-	if (vgacon_text_force() && i915_modeset == -1)
-		driver.driver_features &= ~DRIVER_MODESET;
-#endif
+	/* Make drm_init() always register us as a PCI driver. */
+	driver.driver_features |= DRIVER_MODESET;
 
 	return drm_init(&driver);
 }
Index: linux-2.6/drivers/gpu/drm/drm_stub.c
===================================================================
--- linux-2.6.orig/drivers/gpu/drm/drm_stub.c
+++ linux-2.6/drivers/gpu/drm/drm_stub.c
@@ -419,8 +419,9 @@ int drm_get_dev(struct pci_dev *pdev, co
 		goto err_g2;
 	}
 
+	pci_set_drvdata(pdev, dev);
+
 	if (drm_core_check_feature(dev, DRIVER_MODESET)) {
-		pci_set_drvdata(pdev, dev);
 		ret = drm_get_minor(dev, &dev->control, DRM_MINOR_CONTROL);
 		if (ret)
 			goto err_g2;
