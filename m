Return-Path: <linux-kernel-owner+w=401wt.eu-S1760701AbYDKP31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760701AbYDKP31 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 11:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759960AbYDKP3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 11:29:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55790 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759781AbYDKP3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 11:29:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: BUG: using smp_processor_id() during suspend with 2.6.25-rc8
Date: Fri, 11 Apr 2008 17:29:46 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Ingo Molnar <mingo@elte.hu>, Jiri Kosina <jkosina@suse.cz>,
       Andi Kleen <andi@firstfloor.org>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <c4e36d110804070625n17eb44e1nbb5558f500f13438@mail.gmail.com> <20080411105108.GA1844@elte.hu> <20080411105445.GB18770@elf.ucw.cz>
In-Reply-To: <20080411105445.GB18770@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804111729.47190.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 11 of April 2008, Pavel Machek wrote:
> On Fri 2008-04-11 12:51:09, Ingo Molnar wrote:
> > 
> > * Pavel Machek <pavel@ucw.cz> wrote:
> > 
> > > diff --git a/lib/smp_processor_id.c b/lib/smp_processor_id.c
> > > index 6c90fb9..8195c37 100644
> > > --- a/lib/smp_processor_id.c
> > > +++ b/lib/smp_processor_id.c
> > > @@ -35,6 +35,13 @@ unsigned int debug_smp_processor_id(void
> > >  		goto out;
> > >  
> > >  	/*
> > > +	 * It is valid to assume CPU-locality if there's just one
> > > +	 * CPU active
> > > +	 */
> > > +	if (num_online_cpus() == 1)
> > > +		goto out;
> > 
> > thanks Pavel, i picked this up into sched-devel.git - it makes sense 
> > independently of whether it solves the warning.
> 
> Thanks!
> 
> (I just want to fix the underlying problem in suspend, too. I guess
> I'll just do something like
> 
> diff --git a/drivers/base/sys.c b/drivers/base/sys.c
> index 8e13fd9..adb7850 100644
> --- a/drivers/base/sys.c
> +++ b/drivers/base/sys.c
> @@ -367,6 +367,7 @@ int sysdev_suspend(pm_message_t state)
>  			/* Call auxillary drivers first */
>  			list_for_each_entry(drv, &cls->drivers, entry) {
>  				if (drv->suspend) {
> +					BUG_ON(!in_interrupt());
>  					ret = drv->suspend(sysdev, state);
>  					if (ret)
>  						goto aux_driver;
> @@ -442,6 +443,7 @@ int sysdev_resume(void)
>  		list_for_each_entry(sysdev, &cls->kset.list, kobj.entry) {
>  			pr_debug(" %s\n", kobject_name(&sysdev->kobj));
>  
> +			BUG_ON(!in_interrupt());
>  			__sysdev_resume(sysdev);
>  		}
>  	}
> 
> ...to catch this kind of problems early).

Well, I'd say the BUG_ON()s are over the top in here (why to crash the system
even if it wouldn't have crashed otherwise?).

WARN_ON_ONCE() should be enough.

Thanks,
Rafael
