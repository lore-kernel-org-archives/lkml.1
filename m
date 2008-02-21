Return-Path: <linux-kernel-owner+w=401wt.eu-S933601AbYBUUcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933601AbYBUUcr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 15:32:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761435AbYBUUcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 15:32:14 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38217 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760078AbYBUUcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 15:32:12 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jesse.barnes@intel.com>
Subject: Re: [Suspend-devel] 2.6.25-rc2 System no longer powers off after suspend-to-disk. Screen becomes green.
Date: Thu, 21 Feb 2008 21:30:46 +0100
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
Message-Id: <200802212130.47630.rjw@sisk.pl>
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
> >
> > Please boot 2.6.25-rc2 (or better, the current head of the Linus' tree)
> > with no_console_suspend and try to do the following:
> >
> > # echo 8 > /proc/sys/kernel/printk
> > # echo core > /sys/power/pm_test
> > # echo disk > /sys/power/state
> >
> > (that will run a test of the freeze/unfreeze code without creating the
> > image) and then
> 
> That comes back for me, without creating the green screen.  There's a long 
> delay between it saying "entering S4" and actually resuming back to my 
> console though.

There's an intentional 5 sec. wait.  If the delay is longer that 5 sec., that's a
bit strange.
 
> > # echo mem > /sys/power/state
> >
> > (that will run a test of the suspend/resume code without actually
> > suspending).
> >
> > I'd like to know if that works.
> 
> This also works (after doing the echo disk > ...) above.

That's what I wanted to know, thanks.

> There's still a delay between "entering S3" and the resume to my console
> though. 

If that's 5 sec., it's fine.

Please apply the appended patch and try to hibernate.  I wonder if you get the
reboot or it hangs earlier.

Thanks,
Rafael

---
 kernel/power/disk.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

Index: linux-2.6/kernel/power/disk.c
===================================================================
--- linux-2.6.orig/kernel/power/disk.c
+++ linux-2.6/kernel/power/disk.c
@@ -405,11 +405,7 @@ int hibernation_platform_enter(void)
 
 	local_irq_disable();
 	error = device_power_down(PMSG_SUSPEND);
-	if (!error) {
-		hibernation_ops->enter();
-		/* We should never get here */
-		while (1);
-	}
+	mdelay(1000);
 	local_irq_enable();
 
 	/*
@@ -424,6 +420,7 @@ int hibernation_platform_enter(void)
 	resume_console();
  Close:
 	hibernation_ops->end();
+	kernel_restart(NULL);
 	return error;
 }
 
