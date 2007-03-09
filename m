Return-Path: <linux-kernel-owner+w=401wt.eu-S2993151AbXCIVVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993151AbXCIVVz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 16:21:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993149AbXCIVVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 16:21:55 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33757 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993148AbXCIVVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 16:21:53 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] swsusp: Disable nonboot CPUs before entering platform suspend
Date: Fri, 9 Mar 2007 22:24:19 +0100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <200703072044.12021.rjw@sisk.pl> <200703092107.23820.rjw@sisk.pl> <20070309210746.GA6374@ucw.cz>
In-Reply-To: <20070309210746.GA6374@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703092224.20432.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 9 March 2007 22:07, Pavel Machek wrote:
> Hi!
> 
> > > > > > Index: linux-2.6.21-rc2-mm2/kernel/power/disk.c
> > > > > > ===================================================================
> > > > > > --- linux-2.6.21-rc2-mm2.orig/kernel/power/disk.c
> > > > > > +++ linux-2.6.21-rc2-mm2/kernel/power/disk.c
> > > > > > @@ -61,6 +61,7 @@ static void power_down(suspend_disk_meth
> > > > > >  	switch(mode) {
> > > > > >  	case PM_DISK_PLATFORM:
> > > > > >  		if (pm_ops && pm_ops->enter) {
> > > > > > +			disable_nonboot_cpus();
> > > > > >  			kernel_shutdown_prepare(SYSTEM_SUSPEND_DISK);
> > > > > >  			pm_ops->enter(PM_SUSPEND_DISK);
> > > > > >  			break;
> > > > > 
> > > > > ...so, if pm_ops is non-null, power_down does nonboot cpu disabling,
> > > > > otherwise we proceed with cpus enabled?
> > > > > 
> > > > > That looks ugly.
> > > > > 
> > > > > Is the warning bogus?
> > > > 
> > > > Well, maybe.  I'm not sure.
> > > > 
> > > > > Or maybe we should *always* disable nonboot cpus in powerdown path?
> > > > 
> > > > I think we should do that.
> > > 
> > > That would be acceptable.
> > > 
> > > > > > Index: linux-2.6.21-rc2-mm2/kernel/power/user.c
> > > > > > ===================================================================
> > > > > > --- linux-2.6.21-rc2-mm2.orig/kernel/power/user.c
> > > > > > +++ linux-2.6.21-rc2-mm2/kernel/power/user.c
> > > > > > @@ -398,9 +398,9 @@ static int snapshot_ioctl(struct inode *
> > > > > >  
> > > > > >  		case PMOPS_ENTER:
> > > > > >  			if (data->platform_suspend) {
> > > > > > +				disable_nonboot_cpus();
> > > > > >  				kernel_shutdown_prepare(SYSTEM_SUSPEND_DISK);
> > > > > >  				error = pm_ops->enter(PM_SUSPEND_DISK);
> > > > > > -				error = 0;
> > > > > >  			}
> > > > > >  			break;
> > > > > 
> > > > > Foe an userland application, disabling cpus during pmops_enter is at
> > > > > least surprising.......
> > > > 
> > > > Yes, but this is not a usual ioctl().  OTOH, we can call enable_nonboot_cpus()
> > > > if pm_ops->enter(PM_SUSPEND_DISK) returns an error (otherwise it souldn't
> > > > return at all, no?).
> > > 
> > > Ok.
> > 
> > Well, does the appended patch look better?
> 
> Yes.
> 
> > ---
> >  kernel/power/disk.c |    1 +
> >  kernel/power/user.c |    3 ++-
> >  2 files changed, 3 insertions(+), 1 deletion(-)
> > 
> > Index: linux-2.6.21-rc3/kernel/power/disk.c
> > ===================================================================
> > --- linux-2.6.21-rc3.orig/kernel/power/disk.c
> > +++ linux-2.6.21-rc3/kernel/power/disk.c
> > @@ -58,6 +58,7 @@ static inline int platform_prepare(void)
> >  
> >  static void power_down(suspend_disk_method_t mode)
> >  {
> > +	disable_nonboot_cpus();
> >  	switch(mode) {
> >  	case PM_DISK_PLATFORM:
> >  		if (pm_ops && pm_ops->enter) {
> > Index: linux-2.6.21-rc3/kernel/power/user.c
> > ===================================================================
> > --- linux-2.6.21-rc3.orig/kernel/power/user.c
> > +++ linux-2.6.21-rc3/kernel/power/user.c
> > @@ -402,9 +402,10 @@ static int snapshot_ioctl(struct inode *
> >  
> >  		case PMOPS_ENTER:
> >  			if (data->platform_suspend) {
> > +				disable_nonboot_cpus();
> >  				kernel_shutdown_prepare(SYSTEM_SUSPEND_DISK);
> >  				error = pm_ops->enter(PM_SUSPEND_DISK);
> > -				error = 0;
> > +				enable_nonboot_cpus();
> 
> Why did we discard return code in previous versions? Do we still want
> to do that?

I think it was a mistake.

Rafael
