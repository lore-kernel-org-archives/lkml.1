Return-Path: <linux-kernel-owner+w=401wt.eu-S1753746AbZEQPeH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746AbZEQPeH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 11:34:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751349AbZEQPdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 11:33:53 -0400
Received: from cantor.suse.de ([195.135.220.2]:35680 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751442AbZEQPdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 11:33:53 -0400
Date: Sun, 17 May 2009 08:33:46 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: 2.6.30-rc6: Reported regressions from 2.6.29
Message-ID: <20090517153346.GA1536@suse.de>
References: <_AjETDMbIoL.A.DcH.RYzDKB@chimera> <alpine.LFD.2.01.0905161644350.3301@localhost.localdomain> <ac3eb2510905161715m7d42879bqdc0d59c465521e99@mail.gmail.com> <1242522109.2635.6.camel@poy> <alpine.LFD.2.01.0905161908100.3301@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0905161908100.3301@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 16, 2009 at 07:13:59PM -0700, Linus Torvalds wrote:
> 
> 
> On Sun, 17 May 2009, Kay Sievers wrote:
> > 
> > This makes the oops in the driver-core, caused by the rtc driver
> > unregister, go away. The original issue is also fixed in the rtc driver
> > itself.
> 
> I don't think this is sufficient.
> 
> > --- a/drivers/base/driver.c
> > +++ b/drivers/base/driver.c
> > @@ -257,6 +257,8 @@ EXPORT_SYMBOL_GPL(driver_register);
> >   */
> >  void driver_unregister(struct device_driver *drv)
> >  {
> > +	if (!drv || !drv->p)
> > +		return;
> >  	driver_remove_groups(drv, drv->groups);
> >  	bus_remove_driver(drv);
> >  }
> 
> Ok, fine so far, but look at "driver_register()".
> 
> It will set drv->p, but then not unset it if it fails! (For a certain 
> class of failures)
> 
> So for a certain failure pattern, drv->p will point to some stale value. 
> Should we not clear drv->p in the "out_unregister" patch?
> 
> To confuse the thing more, there are actually "half-way failures" that 
> _succeed_ in driver registration, but then return an error code. See that 
> whole
> 
> 
> 	kobject_uevent(&priv->kobj, KOBJ_ADD);
> 	return error;
> 
> case in the "success" path driver_register(). We may return an error 
> despite the fact that we actually attached the driver to bus, but 
> "add_bind_files()" failed. A caller would be understandable very unhappy.
> 
> So I suspect we should do something like the appended (in addition to your 
> patch). Comments?

That looks good.  I'll add the WARN_ON that Ingo pointed out, and merge
this with Kay's patch.  Give me a few hours to wake up...

thanks,

greg k-h
