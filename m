Return-Path: <linux-kernel-owner+w=401wt.eu-S936065AbYBVAba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936065AbYBVAba (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 19:31:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936089AbYBVAaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 19:30:15 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39349 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936079AbYBVAaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 19:30:12 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jesse.barnes@intel.com>
Subject: Re: [Suspend-devel] 2.6.25-rc2 System no longer powers off after suspend-to-disk. Screen becomes green.
Date: Fri, 22 Feb 2008 01:28:34 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Jeff Chua" <jeff.chua.linux@gmail.com>, Dave Airlie <airlied@linux.ie>,
       Greg KH <gregkh@suse.de>, lkml <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com> <200802212311.44319.rjw@sisk.pl> <200802211545.05794.jesse.barnes@intel.com>
In-Reply-To: <200802211545.05794.jesse.barnes@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802220128.35457.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 22 of February 2008, Jesse Barnes wrote:
> On Thursday, February 21, 2008 2:11 pm Rafael J. Wysocki wrote:
> > Below is a patch that should work around the issue.  Please try it and let
> > me know if it helps.
> 
> I ended up applying the below patch instead, so it would build, and 
> unfortunately it still hung at suspend time.

Hmm.

> So at this point, the known workarounds to the hang at suspend time are to 
> remove the device power down call or to boot with 'no_console_suspend'.  
> The 'screen turns green' problem is fixed by the extra 'inb' added in the 
> patch below (at least for me).

That is suspicious (see below).

> 
> diff --git a/drivers/char/drm/i915_drv.c b/drivers/char/drm/i915_drv.c
> index 35758a6..35b5a60 100644
> --- a/drivers/char/drm/i915_drv.c
> +++ b/drivers/char/drm/i915_drv.c
> @@ -27,6 +27,7 @@
>   *
>   */
>  
> +#include <linux/suspend.h>
>  #include "drmP.h"
>  #include "drm.h"
>  #include "i915_drm.h"
> @@ -222,6 +223,7 @@ static void i915_restore_vga(struct drm_device *dev)
>  			   dev_priv->saveGR[0x18]);
>  
>  	/* Attribute controller registers */
> +	inb(st01); /* switch back to index mode */
>  	for (i = 0; i < 20; i++)
>  		i915_write_ar(st01, i, dev_priv->saveAR[i], 0);
>  	inb(st01); /* switch back to index mode */
> @@ -249,6 +251,9 @@ static int i915_suspend(struct drm_device *dev)
>  		return -ENODEV;
>  	}
>  
> +	if (in_hibernation_power_off())
> +		return 0;
> +

This thing should make i915_suspend() a noop in the last phase of hibernation,
so if it still only works when you remove the
pci_set_power_state(dev->pdev, PCI_D3hot), then I don't get it.

Can you please try the pach below instead?

Thanks,
Rafael


On Thursday, February 21, 2008 2:11 pm Rafael J. Wysocki wrote:
> Below is a patch that should work around the issue.  Please try it and let
> me know if it helps.

I ended up applying the below patch instead, so it would build, and 
unfortunately it still hung at suspend time.

So at this point, the known workarounds to the hang at suspend time are to 
remove the device power down call or to boot with 'no_console_suspend'.  
The 'screen turns green' problem is fixed by the extra 'inb' added in the 
patch below (at least for me).

Jesse

---
 drivers/char/drm/i915_drv.c |    5 +++--
 include/linux/suspend.h     |    2 ++
 kernel/power/disk.c         |   10 +++++++++-
 3 files changed, 14 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/char/drm/i915_drv.c
===================================================================
--- linux-2.6.orig/drivers/char/drm/i915_drv.c
+++ linux-2.6/drivers/char/drm/i915_drv.c
@@ -27,6 +27,7 @@
  *
  */
 
+#include <linux/suspend.h>
 #include "drmP.h"
 #include "drm.h"
 #include "i915_drm.h"
@@ -222,6 +223,7 @@ static void i915_restore_vga(struct drm_
 			   dev_priv->saveGR[0x18]);
 
 	/* Attribute controller registers */
+	inb(st01); /* switch back to index mode */
 	for (i = 0; i < 20; i++)
 		i915_write_ar(st01, i, dev_priv->saveAR[i], 0);
 	inb(st01); /* switch back to index mode */
@@ -366,9 +368,8 @@ static int i915_suspend(struct drm_devic
 
 	i915_save_vga(dev);
 
-	if (state.event == PM_EVENT_SUSPEND) {
+	if (state.event == PM_EVENT_SUSPEND && !in_hibernation_power_off()) {
 		/* Shut down the device */
-		pci_disable_device(dev->pdev);
 		pci_set_power_state(dev->pdev, PCI_D3hot);
 	}
 
Index: linux-2.6/include/linux/suspend.h
===================================================================
--- linux-2.6.orig/include/linux/suspend.h
+++ linux-2.6/include/linux/suspend.h
@@ -209,6 +209,7 @@ extern unsigned long get_safe_page(gfp_t
 
 extern void hibernation_set_ops(struct platform_hibernation_ops *ops);
 extern int hibernate(void);
+extern bool in_hibernation_power_off(void);
 #else /* CONFIG_HIBERNATION */
 static inline int swsusp_page_is_forbidden(struct page *p) { return 0; }
 static inline void swsusp_set_page_free(struct page *p) {}
@@ -216,6 +217,7 @@ static inline void swsusp_unset_page_fre
 
 static inline void hibernation_set_ops(struct platform_hibernation_ops *ops) {}
 static inline int hibernate(void) { return -ENOSYS; }
+static inline bool in_hibernation_power_off(void) { return false; }
 #endif /* CONFIG_HIBERNATION */
 
 #ifdef CONFIG_PM_SLEEP
Index: linux-2.6/kernel/power/disk.c
===================================================================
--- linux-2.6.orig/kernel/power/disk.c
+++ linux-2.6/kernel/power/disk.c
@@ -24,7 +24,7 @@
 
 #include "power.h"
 
-
+static bool entering_sleep_state;
 static int noresume = 0;
 static char resume_file[256] = CONFIG_PM_STD_PARTITION;
 dev_t swsusp_resume_device;
@@ -381,6 +381,7 @@ int hibernation_platform_enter(void)
 	if (!hibernation_ops)
 		return -ENOSYS;
 
+	entering_sleep_state = true;
 	/*
 	 * We have cancelled the power transition by running
 	 * hibernation_ops->finish() before saving the image, so we should let
@@ -412,6 +413,7 @@ int hibernation_platform_enter(void)
 	}
 	local_irq_enable();
 
+	entering_sleep_state = false;
 	/*
 	 * We don't need to reenable the nonboot CPUs or resume consoles, since
 	 * the system is going to be halted anyway.
@@ -427,6 +429,12 @@ int hibernation_platform_enter(void)
 	return error;
 }
 
+bool in_hibernation_power_off(void)
+{
+	return entering_sleep_state;
+}
+EXPORT_SYMBOL(in_hibernation_power_off);
+
 /**
  *	power_down - Shut the machine down for hibernation.
  *
