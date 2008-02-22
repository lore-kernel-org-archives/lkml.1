Return-Path: <linux-kernel-owner+w=401wt.eu-S936361AbYBVAcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936361AbYBVAcr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 19:32:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763569AbYBVAcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 19:32:35 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39380 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761860AbYBVAce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 19:32:34 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Jeff Chua" <jeff.chua.linux@gmail.com>
Subject: Re: [Suspend-devel] 2.6.25-rc2 System no longer powers off aftersuspend-to-disk. Screen becomes green.
Date: Fri, 22 Feb 2008 01:31:08 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Jesse Barnes" <jesse.barnes@intel.com>,
       "Romano Giannetti" <romano@dea.icai.upcomillas.es>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "suspend-devel List" <suspend-devel@lists.sourceforge.net>,
       "Dave Airlie" <airlied@linux.ie>, "Greg KH" <gregkh@suse.de>,
       lkml <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com> <200802211302.27002.jesse.barnes@intel.com> <b6a2187b0802211620q47f6601fuf7e88395d89b90c8@mail.gmail.com>
In-Reply-To: <b6a2187b0802211620q47f6601fuf7e88395d89b90c8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802220131.09525.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 22 of February 2008, Jeff Chua wrote:
> On Fri, Feb 22, 2008 at 5:02 AM, Jesse Barnes <jesse.barnes@intel.com> wrote:
> > On Thursday, February 21, 2008 11:43 am Romano Giannetti wrote:
> >  > > > Let's try to narrow it down to what the interaction is. Are you using
> >  > > > something like acpi_sleep=s3_bios or similar?
> >  > >
> >  > > No. Not additional command line option except for resume=/dev/sda3
> >  > > reboot=bios
> >  >
> >  > My laptop (a Toshiba satellite U305, intel 945GM chipset, used to need
> >  > s2ram -f -p -m to STR correctly. In 2.6.25-rc2 I can simply STR with
> >  > echo mem > /sys/power/state.
> >
> >  Cool, glad to hear at least one success report. :)
> 
> STR is always working on my X60s. No green screen, no hang. Both s2ram
> and "echo mem > /sys/power/state". It's STD that's having problem.
> 
> But strange thing is I could even restore console after STD even
> without agp and i915 module loaded, so I don't know how the console
> vga got saved and restored.

Jeff, can you please test hibernation with the patch I've just sent to Jesse
(reproduced below for convenience)?

Thanks,
Rafael

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
