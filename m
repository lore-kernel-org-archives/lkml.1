Return-Path: <linux-kernel-owner+w=401wt.eu-S1760521AbYDKKyP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760521AbYDKKyP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 06:54:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759324AbYDKKx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 06:53:59 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:59974 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759138AbYDKKx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 06:53:58 -0400
Date: Fri, 11 Apr 2008 12:54:45 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Kosina <jkosina@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andi Kleen <andi@firstfloor.org>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: BUG: using smp_processor_id() during suspend with 2.6.25-rc8
Message-ID: <20080411105445.GB18770@elf.ucw.cz>
References: <c4e36d110804070625n17eb44e1nbb5558f500f13438@mail.gmail.com> <Pine.LNX.4.64.0804080008420.3896@jikos.suse.cz> <20080407222352.GG16647@one.firstfloor.org> <200804080029.31102.rjw@sisk.pl> <Pine.LNX.4.64.0804080030500.3896@jikos.suse.cz> <20080410094554.GA10321@ucw.cz> <Pine.LNX.4.64.0804110122470.3896@jikos.suse.cz> <20080411104902.GA8734@elf.ucw.cz> <20080411105108.GA1844@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080411105108.GA1844@elte.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-04-11 12:51:09, Ingo Molnar wrote:
> 
> * Pavel Machek <pavel@ucw.cz> wrote:
> 
> > diff --git a/lib/smp_processor_id.c b/lib/smp_processor_id.c
> > index 6c90fb9..8195c37 100644
> > --- a/lib/smp_processor_id.c
> > +++ b/lib/smp_processor_id.c
> > @@ -35,6 +35,13 @@ unsigned int debug_smp_processor_id(void
> >  		goto out;
> >  
> >  	/*
> > +	 * It is valid to assume CPU-locality if there's just one
> > +	 * CPU active
> > +	 */
> > +	if (num_online_cpus() == 1)
> > +		goto out;
> 
> thanks Pavel, i picked this up into sched-devel.git - it makes sense 
> independently of whether it solves the warning.

Thanks!

(I just want to fix the underlying problem in suspend, too. I guess
I'll just do something like

diff --git a/drivers/base/sys.c b/drivers/base/sys.c
index 8e13fd9..adb7850 100644
--- a/drivers/base/sys.c
+++ b/drivers/base/sys.c
@@ -367,6 +367,7 @@ int sysdev_suspend(pm_message_t state)
 			/* Call auxillary drivers first */
 			list_for_each_entry(drv, &cls->drivers, entry) {
 				if (drv->suspend) {
+					BUG_ON(!in_interrupt());
 					ret = drv->suspend(sysdev, state);
 					if (ret)
 						goto aux_driver;
@@ -442,6 +443,7 @@ int sysdev_resume(void)
 		list_for_each_entry(sysdev, &cls->kset.list, kobj.entry) {
 			pr_debug(" %s\n", kobject_name(&sysdev->kobj));
 
+			BUG_ON(!in_interrupt());
 			__sysdev_resume(sysdev);
 		}
 	}

...to catch this kind of problems early).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
