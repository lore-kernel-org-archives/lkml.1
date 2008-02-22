Return-Path: <linux-kernel-owner+w=401wt.eu-S936233AbYBVBpM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936233AbYBVBpM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 20:45:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760732AbYBVBo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 20:44:56 -0500
Received: from mga02.intel.com ([134.134.136.20]:17198 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254AbYBVBoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 20:44:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,388,1199692800"; 
   d="scan'208";a="343858992"
From: Jesse Barnes <jesse.barnes@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Suspend-devel] 2.6.25-rc2 System no longer powers off aftersuspend-to-disk. Screen becomes green.
Date: Thu, 21 Feb 2008 17:44:35 -0800
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Chua <jeff.chua.linux@gmail.com>,
       Romano Giannetti <romano@dea.icai.upcomillas.es>,
       suspend-devel List <suspend-devel@lists.sourceforge.net>,
       Dave Airlie <airlied@linux.ie>, Greg KH <gregkh@suse.de>,
       lkml <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com> <200802220154.57051.rjw@sisk.pl> <200802211713.20713.jesse.barnes@intel.com>
In-Reply-To: <200802211713.20713.jesse.barnes@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802211744.35563.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 21, 2008 5:13 pm Jesse Barnes wrote:
> On Thursday, February 21, 2008 4:54 pm Rafael J. Wysocki wrote:
> > On Friday, 22 of February 2008, Linus Torvalds wrote:
> > > On Fri, 22 Feb 2008, Rafael J. Wysocki wrote:
> > > > -	if (state.event == PM_EVENT_SUSPEND) {
> > > > +	if (state.event == PM_EVENT_SUSPEND && !in_hibernation_power_off())
> > > > {
> > >
> > > I don't understand why hibernation just doesn't use a
> > > PM_EVENT_HIBERNATE, and be done with it?
> > >
> > > Why should it be called PM_EVENT_SUSPEND when it isn't?
> > >
> > > Adding some external global variables is absolutely the wrong way to
> > > fix this.
> > >
> > > It's not even like there are very many drivers who actually care about
> > > "state.event" anyway: a 'git grep' returns just 35 users in the whole
> > > tree, so if this was done this ugly way just to avoid double-chcking
> > > the other cases that compare against PM_EVENT_SUSPEND, then it really
> > > wasn't worth it.
> >
> > Please relax, we're debugging the thing right now and the patch doesn't
> > even seem to help on the other affected box.
>
> Actually, looks like I forgot to reboot between tests (just rmmod'd &
> modprobed i915), your patch actually does work.
>
> However, making new PM event messages might be a good thing anyway,
> assuming Linus takes it for 2.6.25, since it should make the migration to
> ->hibernate callbacks easier.

Rafael, I'd actually prefer these changes to the i915 driver.  One is to avoid 
the "green screen" problem and the other is to actually save state at 
hibernate time in case we don't do a POST coming out of S4 (probably not 
common but hey).

Jesse

Make sure hibernation works by not shutting down the video device during 
hibernation power off.  This is important because later stages of the 
hibernation cycle end up touching the video device, which may cause a hang if 
it was disabled early on.  Also make sure the restoration correctly restores 
the AR registers by flipping the ARX register into index mode before doing 
anything.

Depends on Rafael's patch which exports hibernation state to drivers.

Signed-off-by:  Jesse Barnes <jesse.barnes@intel.com>

diff --git a/drivers/char/drm/i915_drv.c b/drivers/char/drm/i915_drv.c
index 35758a6..5e73869 100644
--- a/drivers/char/drm/i915_drv.c
+++ b/drivers/char/drm/i915_drv.c
@@ -27,6 +27,7 @@
  *
  */
 
+#include <linux/suspend.h>
 #include "drmP.h"
 #include "drm.h"
 #include "i915_drm.h"
@@ -222,6 +223,7 @@ static void i915_restore_vga(struct drm_device *dev)
 			   dev_priv->saveGR[0x18]);
 
 	/* Attribute controller registers */
+	inb(st01);
 	for (i = 0; i < 20; i++)
 		i915_write_ar(st01, i, dev_priv->saveAR[i], 0);
 	inb(st01); /* switch back to index mode */
@@ -364,8 +366,8 @@ static int i915_suspend(struct drm_device *dev)
 	i915_save_vga(dev);
 
 	/* Shut down the device */
-	pci_disable_device(dev->pdev);
-	pci_set_power_state(dev->pdev, PCI_D3hot);
+	if (!in_hibernation_power_off())
+		pci_set_power_state(dev->pdev, PCI_D3hot);
 
 	return 0;
 }

