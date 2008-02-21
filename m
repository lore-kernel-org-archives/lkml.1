Return-Path: <linux-kernel-owner+w=401wt.eu-S935255AbYBUWN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935255AbYBUWN5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 17:13:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934495AbYBUWNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 17:13:18 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38760 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765887AbYBUWNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 17:13:15 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jesse.barnes@intel.com>
Subject: Re: [Suspend-devel] 2.6.25-rc2 System no longer powers off after suspend-to-disk. Screen becomes green.
Date: Thu, 21 Feb 2008 23:11:43 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Jeff Chua" <jeff.chua.linux@gmail.com>, Dave Airlie <airlied@linux.ie>,
       Greg KH <gregkh@suse.de>, lkml <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com> <200802211727.21593.rjw@sisk.pl> <200802211034.22056.jesse.barnes@intel.com>
In-Reply-To: <200802211034.22056.jesse.barnes@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802212311.44319.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 21 of February 2008, Jesse Barnes wrote:
> On Thursday, February 21, 2008 8:27 am Rafael J. Wysocki wrote:
> > On Thursday, 21 of February 2008, Jeff Chua wrote:
> > > On Thu, Feb 21, 2008 at 8:39 AM, Jesse Barnes <jesse.barnes@intel.com> 
> wrote:
> > > > On Wednesday, February 20, 2008 4:35 pm Jeff Chua wrote:
> > > >  > On Thu, Feb 21, 2008 at 5:37 AM, Jesse Barnes
> > > >  > <jesse.barnes@intel.com>
> > > >
> > > >  wrote:
> > > >  > >  Ok, can you give this patch a try with the 'platform' method?  It
> > > >  > > should at least tell us what ACPI would like the device to do at
> > > >  > > suspend time, but it probably won't fix the hang.
> > >
> > > It says "calling pci_set_power_state with 3". Then after all then it
> > > still hangs, and then resume with Mr Green.
> > >
> > > PM: Syncing filesystems ... done.
> > > Freezing user space processes ... (elapsed 0.00 seconds) done.
> > > Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
> > > PM: Shrinking memory...  ^H-^Hdone (0 pages freed)
> > > PM: Freed 0 kbytes in 0.20 seconds (0.00 MB/s)
> > > ACPI: Preparing to enter system sleep state S4
> > > Suspending console(s)
> > > sd 0:0:0:0: [sda] Synchronizing SCSI cache
> > > drm_sysfs_suspend
> > > ACPI: PCI interrupt for device 0000:00:02.0 disabled
> > > calling pci_set_power_state with 3
> >
> > So it returns the right value.
> >
> > Jeff, Jesse, please check one thing for me.

Below is a patch that should work around the issue.  Please try it and let me
know if it helps.

Thanks,
Rafael

---
 drivers/char/drm/i915_drv.c |    3 +++
 include/linux/suspend.h     |    2 ++
 kernel/power/disk.c         |    9 ++++++++-
 3 files changed, 13 insertions(+), 1 deletion(-)

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
@@ -427,6 +429,11 @@ int hibernation_platform_enter(void)
 	return error;
 }
 
+bool in_hibernation_power_off(void)
+{
+	return entering_sleep_state;
+}
+
 /**
  *	power_down - Shut the machine down for hibernation.
  *
Index: linux-2.6/drivers/char/drm/i915_drv.c
===================================================================
--- linux-2.6.orig/drivers/char/drm/i915_drv.c
+++ linux-2.6/drivers/char/drm/i915_drv.c
@@ -247,6 +247,9 @@ static int i915_suspend(struct drm_devic
 		return -ENODEV;
 	}
 
+	if (in_hibernation_power_off())
+		return 0;
+
 	pci_save_state(dev->pdev);
 	pci_read_config_byte(dev->pdev, LBB, &dev_priv->saveLBB);
 
