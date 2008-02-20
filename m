Return-Path: <linux-kernel-owner+w=401wt.eu-S932890AbYBTVie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932890AbYBTVie (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 16:38:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755667AbYBTViY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 16:38:24 -0500
Received: from mga01.intel.com ([192.55.52.88]:12454 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752815AbYBTViW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 16:38:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,382,1199692800"; 
   d="scan'208";a="521873855"
From: Jesse Barnes <jesse.barnes@intel.com>
To: "Jeff Chua" <jeff.chua.linux@gmail.com>
Subject: Re: 2.6.25-rc2 System no longer powers off after suspend-to-disk. Screen becomes green.
Date: Wed, 20 Feb 2008 13:37:51 -0800
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, "Dave Airlie" <airlied@linux.ie>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
       "suspend-devel List" <suspend-devel@lists.sourceforge.net>,
       "Greg KH" <gregkh@suse.de>
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com> <200802201053.16218.jesse.barnes@intel.com> <b6a2187b0802201110k6e6c458dg6f48c586fff6187a@mail.gmail.com>
In-Reply-To: <b6a2187b0802201110k6e6c458dg6f48c586fff6187a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802201337.52247.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 20, 2008 11:10 am Jeff Chua wrote:
> On Feb 21, 2008 2:53 AM, Jesse Barnes <jesse.barnes@intel.com> wrote:
> > > So, next I'll try "shutdown" to see if it work. I was using "platform".
> >
> > Ok, that would be good to try.
>
> "shutdown" does power down properly. But still green on resume.
>
> > Looks like the AR registers are hosed, which is what I thought I fixed...
> >  Can you attach your i915_drv.c file just so I can sanity check it?
>
> Attached.

Ok, can you give this patch a try with the 'platform' method?  It should at 
least tell us what ACPI would like the device to do at suspend time, but it 
probably won't fix the hang.

Thanks,
Jesse

diff --git a/drivers/char/drm/i915_drv.c b/drivers/char/drm/i915_drv.c
index 4048f39..d8aa2c9 100644
--- a/drivers/char/drm/i915_drv.c
+++ b/drivers/char/drm/i915_drv.c
@@ -366,11 +366,11 @@ static int i915_suspend(struct drm_device *dev, 
pm_message_t state)
 
 	i915_save_vga(dev);
 
-	if (state.event == PM_EVENT_SUSPEND) {
-		/* Shut down the device */
-		pci_disable_device(dev->pdev);
-		pci_set_power_state(dev->pdev, PCI_D3hot);
-	}
+	/* Ask ACPI which state the device should be put in */
+	pci_disable_device(dev->pdev);
+	printk("calling pci_set_power_state with %d\n",
+	       acpi_pci_choose_state(dev, state));
+	pci_set_power_state(dev->pdev, acpi_pci_choose_state(dev, state));
 
 	return 0;
 }
@@ -380,7 +380,7 @@ static int i915_resume(struct drm_device *dev)
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	int i;
 
-	pci_set_power_state(dev->pdev, PCI_D0);
+	pci_set_power_state(dev->pdev, acpi_pci_choose_state(dev, state));
 	pci_restore_state(dev->pdev);
 	if (pci_enable_device(dev->pdev))
 		return -1;
