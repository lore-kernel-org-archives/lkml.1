Return-Path: <linux-kernel-owner+w=401wt.eu-S1752653AbXCIIyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653AbXCIIyX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 03:54:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752655AbXCIIyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 03:54:23 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:41062 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653AbXCIIyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 03:54:21 -0500
Date: Fri, 9 Mar 2007 09:54:20 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] swsusp: Disable nonboot CPUs before entering platform suspend
Message-ID: <20070309085420.GA26786@atrey.karlin.mff.cuni.cz>
References: <200703072044.12021.rjw@sisk.pl> <20070307210716.GA4913@ucw.cz> <200703090858.55632.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703090858.55632.rjw@sisk.pl>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Index: linux-2.6.21-rc2-mm2/kernel/power/disk.c
> > > ===================================================================
> > > --- linux-2.6.21-rc2-mm2.orig/kernel/power/disk.c
> > > +++ linux-2.6.21-rc2-mm2/kernel/power/disk.c
> > > @@ -61,6 +61,7 @@ static void power_down(suspend_disk_meth
> > >  	switch(mode) {
> > >  	case PM_DISK_PLATFORM:
> > >  		if (pm_ops && pm_ops->enter) {
> > > +			disable_nonboot_cpus();
> > >  			kernel_shutdown_prepare(SYSTEM_SUSPEND_DISK);
> > >  			pm_ops->enter(PM_SUSPEND_DISK);
> > >  			break;
> > 
> > ...so, if pm_ops is non-null, power_down does nonboot cpu disabling,
> > otherwise we proceed with cpus enabled?
> > 
> > That looks ugly.
> > 
> > Is the warning bogus?
> 
> Well, maybe.  I'm not sure.
> 
> > Or maybe we should *always* disable nonboot cpus in powerdown path?
> 
> I think we should do that.

That would be acceptable.

> > > Index: linux-2.6.21-rc2-mm2/kernel/power/user.c
> > > ===================================================================
> > > --- linux-2.6.21-rc2-mm2.orig/kernel/power/user.c
> > > +++ linux-2.6.21-rc2-mm2/kernel/power/user.c
> > > @@ -398,9 +398,9 @@ static int snapshot_ioctl(struct inode *
> > >  
> > >  		case PMOPS_ENTER:
> > >  			if (data->platform_suspend) {
> > > +				disable_nonboot_cpus();
> > >  				kernel_shutdown_prepare(SYSTEM_SUSPEND_DISK);
> > >  				error = pm_ops->enter(PM_SUSPEND_DISK);
> > > -				error = 0;
> > >  			}
> > >  			break;
> > 
> > Foe an userland application, disabling cpus during pmops_enter is at
> > least surprising.......
> 
> Yes, but this is not a usual ioctl().  OTOH, we can call enable_nonboot_cpus()
> if pm_ops->enter(PM_SUSPEND_DISK) returns an error (otherwise it souldn't
> return at all, no?).

Ok.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
