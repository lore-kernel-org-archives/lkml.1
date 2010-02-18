Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758751Ab0BRWGA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 17:06:00 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50486 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758483Ab0BRWF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 17:05:58 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pedro Ribeiro <pedrib@gmail.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Eric Anholt <eric@anholt.net>
Subject: [PATCH] i915 / PM: Fix hibernate regression caused by suspend/resume splitting
Date: Thu, 18 Feb 2010 23:06:27 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc8-rjw; KDE/4.3.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <74fd948d1002171047g70d2bba0l957e264dfbc8ea23@mail.gmail.com> <201002172320.57491.rjw@sisk.pl> <74fd948d1002171629v7e86371cna4441e8feb27c326@mail.gmail.com>
In-Reply-To: <74fd948d1002171629v7e86371cna4441e8feb27c326@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002182306.28052.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 February 2010, Pedro Ribeiro wrote:
> On 17 February 2010 22:20, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Wednesday 17 February 2010, Pedro Ribeiro wrote:
> >> 2010/2/17 Rafael J. Wysocki <rjw@sisk.pl>:
> >> > On Wednesday 17 February 2010, Rafael J. Wysocki wrote:
> >> >> On Wednesday 17 February 2010, Pedro Ribeiro wrote:
> >> >> > Hi,
> >> >> >
> >> >> > commit 84b79f8d2882b0a84330c04839ed4d3cefd2ff77 (drm/i915: Fix crash
> >> >> > while aborting hibernation) introduced two new issues which were not
> >> >> > present in 2.6.33-rc7:
> >> >> >
> >> >> > - every second resume from hibernate results in a blank screen
> >> >> > - the annoying flash at the end of atomic copy/restore during the
> >> >> > hibernate process is back (present in kernels < 2.6.33)
> >> >> >
> >> >> > The first issue is serious, the second is just an annoyance.
> >> >>
> >> >> The second one is an expected price of fixing the aborted hibernation
> >> >> regression.
> >> >>
> >> >> The first one shouldn't happen, though.
> >> >>
> >> >> I'll see if I can reproduce that locally.
> >> >
> >> > No, I can't.
> >> >
> >> > Is the driver compiled directly into the kernel or modular?
> >>
> >> The driver is modular.
> >> And sorry, I forgot to tell you I'm using TuxOnIce, it certainly makes
> >> a difference.
> >
> > It shouldn't in fact, although I'm not sure.
> >
> >> However, every since I reverted that commit I've done 10 test
> >> hibernations and no hang so far.
> >
> > First, please try if you can reproduce it with non-modular driver.
> >
> > Second, please check if the appended patch helps.
> >
> > Rafael
> >
> > ---
> >  drivers/gpu/drm/i915/i915_drv.c |   30 +++++++++---------------------
> >  1 file changed, 9 insertions(+), 21 deletions(-)
> >
> > Index: linux-2.6/drivers/gpu/drm/i915/i915_drv.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/gpu/drm/i915/i915_drv.c
> > +++ linux-2.6/drivers/gpu/drm/i915/i915_drv.c
> > @@ -177,6 +177,8 @@ MODULE_DEVICE_TABLE(pci, pciidlist);
> >
> >  static int i915_drm_freeze(struct drm_device *dev)
> >  {
> > +       struct drm_i915_private *dev_priv = dev->dev_private;
> > +
> >        pci_save_state(dev->pdev);
> >
> >        /* If KMS is active, we do the leavevt stuff here */
> > @@ -192,17 +194,12 @@ static int i915_drm_freeze(struct drm_de
> >
> >        i915_save_state(dev);
> >
> > -       return 0;
> > -}
> > -
> > -static void i915_drm_suspend(struct drm_device *dev)
> > -{
> > -       struct drm_i915_private *dev_priv = dev->dev_private;
> > -
> >        intel_opregion_free(dev, 1);
> >
> >        /* Modeset on resume, not lid events */
> >        dev_priv->modeset_on_lid = 0;
> > +
> > +       return 0;
> >  }
> >
> >  static int i915_suspend(struct drm_device *dev, pm_message_t state)
> > @@ -222,8 +219,6 @@ static int i915_suspend(struct drm_devic
> >        if (error)
> >                return error;
> >
> > -       i915_drm_suspend(dev);
> > -
> >        if (state.event == PM_EVENT_SUSPEND) {
> >                /* Shut down the device */
> >                pci_disable_device(dev->pdev);
> > @@ -238,6 +233,10 @@ static int i915_drm_thaw(struct drm_devi
> >        struct drm_i915_private *dev_priv = dev->dev_private;
> >        int error = 0;
> >
> > +       i915_restore_state(dev);
> > +
> > +       intel_opregion_init(dev, 1);
> > +
> >        /* KMS EnterVT equivalent */
> >        if (drm_core_check_feature(dev, DRIVER_MODESET)) {
> >                mutex_lock(&dev->struct_mutex);
> > @@ -264,10 +263,6 @@ static int i915_resume(struct drm_device
> >
> >        pci_set_master(dev->pdev);
> >
> > -       i915_restore_state(dev);
> > -
> > -       intel_opregion_init(dev, 1);
> > -
> >        return i915_drm_thaw(dev);
> >  }
> >
> > @@ -424,8 +419,6 @@ static int i915_pm_suspend(struct device
> >        if (error)
> >                return error;
> >
> > -       i915_drm_suspend(drm_dev);
> > -
> >        pci_disable_device(pdev);
> >        pci_set_power_state(pdev, PCI_D3hot);
> >
> > @@ -465,13 +458,8 @@ static int i915_pm_poweroff(struct devic
> >  {
> >        struct pci_dev *pdev = to_pci_dev(dev);
> >        struct drm_device *drm_dev = pci_get_drvdata(pdev);
> > -       int error;
> > -
> > -       error = i915_drm_freeze(drm_dev);
> > -       if (!error)
> > -               i915_drm_suspend(drm_dev);
> >
> > -       return error;
> > +       return i915_drm_freeze(drm_dev);
> >  }
> >
> >  const struct dev_pm_ops i915_pm_ops = {
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
> 
> The patch fixes this issue for me.
> 
> Thanks for your help.

OK, thanks for testing, let's submit it appropriately.

Jesse, Eric, the appended patch fixes a very recent hibernate regression in
i915, please push it to Linus ASAP.

Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: i915 / PM: Fix hibernate regression caused by suspend/resume splitting

Commit 84b79f8d2882b0a84330c04839ed4d3cefd2ff77 (drm/i915: Fix crash
while aborting hibernation) attempted to fix a regression introduced
by commit cbda12d77ea590082edb6d30bd342a67ebc459e0 (drm/i915:
implement new pm ops for i915), but it went too far trying to split
the freeze/suspend and resume/thaw parts of the code.  As a result,
it introduced another regression, which only is visible on some systems.

Fix the problem by merging i915_drm_suspend() with
i915_drm_freeze() and moving some code from i915_resume()
into i915_drm_thaw(), so that intel_opregion_free() and
intel_opregion_init() are also executed in the freeze and thaw code
paths, respectively.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Reported-and-tested-by: Pedro Ribeiro <pedrib@gmail.com>
---
 drivers/gpu/drm/i915/i915_drv.c |   30 +++++++++---------------------
 1 file changed, 9 insertions(+), 21 deletions(-)

Index: linux-2.6/drivers/gpu/drm/i915/i915_drv.c
===================================================================
--- linux-2.6.orig/drivers/gpu/drm/i915/i915_drv.c
+++ linux-2.6/drivers/gpu/drm/i915/i915_drv.c
@@ -177,6 +177,8 @@ MODULE_DEVICE_TABLE(pci, pciidlist);
 
 static int i915_drm_freeze(struct drm_device *dev)
 {
+	struct drm_i915_private *dev_priv = dev->dev_private;
+
 	pci_save_state(dev->pdev);
 
 	/* If KMS is active, we do the leavevt stuff here */
@@ -192,17 +194,12 @@ static int i915_drm_freeze(struct drm_de
 
 	i915_save_state(dev);
 
-	return 0;
-}
-
-static void i915_drm_suspend(struct drm_device *dev)
-{
-	struct drm_i915_private *dev_priv = dev->dev_private;
-
 	intel_opregion_free(dev, 1);
 
 	/* Modeset on resume, not lid events */
 	dev_priv->modeset_on_lid = 0;
+
+	return 0;
 }
 
 static int i915_suspend(struct drm_device *dev, pm_message_t state)
@@ -222,8 +219,6 @@ static int i915_suspend(struct drm_devic
 	if (error)
 		return error;
 
-	i915_drm_suspend(dev);
-
 	if (state.event == PM_EVENT_SUSPEND) {
 		/* Shut down the device */
 		pci_disable_device(dev->pdev);
@@ -238,6 +233,10 @@ static int i915_drm_thaw(struct drm_devi
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	int error = 0;
 
+	i915_restore_state(dev);
+
+	intel_opregion_init(dev, 1);
+
 	/* KMS EnterVT equivalent */
 	if (drm_core_check_feature(dev, DRIVER_MODESET)) {
 		mutex_lock(&dev->struct_mutex);
@@ -264,10 +263,6 @@ static int i915_resume(struct drm_device
 
 	pci_set_master(dev->pdev);
 
-	i915_restore_state(dev);
-
-	intel_opregion_init(dev, 1);
-
 	return i915_drm_thaw(dev);
 }
 
@@ -424,8 +419,6 @@ static int i915_pm_suspend(struct device
 	if (error)
 		return error;
 
-	i915_drm_suspend(drm_dev);
-
 	pci_disable_device(pdev);
 	pci_set_power_state(pdev, PCI_D3hot);
 
@@ -465,13 +458,8 @@ static int i915_pm_poweroff(struct devic
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct drm_device *drm_dev = pci_get_drvdata(pdev);
-	int error;
-
-	error = i915_drm_freeze(drm_dev);
-	if (!error)
-		i915_drm_suspend(drm_dev);
 
-	return error;
+	return i915_drm_freeze(drm_dev);
 }
 
 const struct dev_pm_ops i915_pm_ops = {
