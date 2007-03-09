Return-Path: <linux-kernel-owner+w=401wt.eu-S965767AbXCIH4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965767AbXCIH4V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 02:56:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965771AbXCIH4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 02:56:21 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58667 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965767AbXCIH4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 02:56:20 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] swsusp: Disable nonboot CPUs before entering platform suspend
Date: Fri, 9 Mar 2007 08:58:55 +0100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <200703072044.12021.rjw@sisk.pl> <20070307210716.GA4913@ucw.cz>
In-Reply-To: <20070307210716.GA4913@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703090858.55632.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 7 March 2007 22:07, Pavel Machek wrote:
> Hi!
> 
> > Prevent the WARN_ON() in arch/x86_64/kernel/acpi/sleep.c:init_low_mapping()
> > from triggering by disabling nonboot CPUs before we finally enter the platform
> > suspend.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > ---
> >  kernel/power/disk.c |    1 +
> >  kernel/power/user.c |    2 +-
> >  2 files changed, 2 insertions(+), 1 deletion(-)
> > 
> > Index: linux-2.6.21-rc2-mm2/kernel/power/disk.c
> > ===================================================================
> > --- linux-2.6.21-rc2-mm2.orig/kernel/power/disk.c
> > +++ linux-2.6.21-rc2-mm2/kernel/power/disk.c
> > @@ -61,6 +61,7 @@ static void power_down(suspend_disk_meth
> >  	switch(mode) {
> >  	case PM_DISK_PLATFORM:
> >  		if (pm_ops && pm_ops->enter) {
> > +			disable_nonboot_cpus();
> >  			kernel_shutdown_prepare(SYSTEM_SUSPEND_DISK);
> >  			pm_ops->enter(PM_SUSPEND_DISK);
> >  			break;
> 
> ...so, if pm_ops is non-null, power_down does nonboot cpu disabling,
> otherwise we proceed with cpus enabled?
> 
> That looks ugly.
> 
> Is the warning bogus?

Well, maybe.  I'm not sure.

> Or maybe we should *always* disable nonboot cpus in powerdown path?

I think we should do that.

> > Index: linux-2.6.21-rc2-mm2/kernel/power/user.c
> > ===================================================================
> > --- linux-2.6.21-rc2-mm2.orig/kernel/power/user.c
> > +++ linux-2.6.21-rc2-mm2/kernel/power/user.c
> > @@ -398,9 +398,9 @@ static int snapshot_ioctl(struct inode *
> >  
> >  		case PMOPS_ENTER:
> >  			if (data->platform_suspend) {
> > +				disable_nonboot_cpus();
> >  				kernel_shutdown_prepare(SYSTEM_SUSPEND_DISK);
> >  				error = pm_ops->enter(PM_SUSPEND_DISK);
> > -				error = 0;
> >  			}
> >  			break;
> 
> Foe an userland application, disabling cpus during pmops_enter is at
> least surprising.......

Yes, but this is not a usual ioctl().  OTOH, we can call enable_nonboot_cpus()
if pm_ops->enter(PM_SUSPEND_DISK) returns an error (otherwise it souldn't
return at all, no?).

Rafael
