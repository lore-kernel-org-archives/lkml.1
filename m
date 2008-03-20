Return-Path: <linux-kernel-owner+w=401wt.eu-S1759273AbYCTWXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759273AbYCTWXt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 18:23:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758882AbYCTWXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 18:23:37 -0400
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:44273 "EHLO
	mk-filter-3-a-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754309AbYCTWXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 18:23:35 -0400
X-Trace: 700696699/mk-filter-3.mail.uk.tiscali.com/B2C/$THROTTLED-DYNAMIC/CUSTOMER-DYNAMIC-IP/81.1.89.66
X-SBRS: None
X-RemoteIP: 81.1.89.66
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: As4EACqA4kdRAVlC/2dsb2JhbACBWql9
Subject: Re: [PATCH] 1/2 Maple: Update bus driver to allow support of VMU
	device
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dwmw2@infradead.org, greg@kroah.com, lethal@linux-sh.org,
       linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
       linux-mtd@vger.kernel.org
In-Reply-To: <20080320135618.1a283b3e.akpm@linux-foundation.org>
References: <1205879413.6250.13.camel@localhost.localdomain>
	 <1205880554.6250.25.camel@localhost.localdomain>
	 <20080320135618.1a283b3e.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 20 Mar 2008 22:23:17 +0000
Message-Id: <1206051797.6274.17.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-03-20 at 13:56 -0700, Andrew Morton wrote:

> urgh, down_trylock().  And a secret, undocumented one too.
> 
> A trylock is always an exceptional thing.  How is *any* reader of this code
> supposed to work out what the heck it's doing there?  Convert it into
> down(), run the code and decrypt the lockdep warnings, I suspect.
> 
> <looks>
> 
> Nope, I can't see any other lock being held when we call this function.
> 
> The trylocks are an utter mystery to me.  Please don't write mysterious
> code.
> 

OK, I am sure this is my problem but I have no idea why you are
describing down_trylock as undocumented - I simply took it out of page
111 of the "Linux Device Drivers" book - hardly the canonical source but
why are you telling me that it is undocumented?

The down_trylock is used here so that a passed in packet and the regular
every second check that the device has not been hot-unplugged don't
deadlock. If I used down then a deadlock is a near certainty. It simply
bounces the 1 second test here if the lock is already down. Is that a
big problem?



> > @@ -398,32 +403,38 @@ static int setup_maple_commands(struct device *device, void *ignored)
> >  /* VBLANK bottom half - implemented via workqueue */
> >  static void maple_vblank_handler(struct work_struct *work)
> >  {
> > -	if (!maple_dma_done())
> > -		return;
> >  	if (!list_empty(&maple_sentq))
> >  		return;
> > +	if (!maple_dma_done())
> > +		return;
> >  	ctrl_outl(0, MAPLE_ENABLE);
> > -	liststatus = 0;
> >  	bus_for_each_dev(&maple_bus_type, NULL, NULL,
> >  			 setup_maple_commands);
> >  	if (time_after(jiffies, maple_pnp_time))
> >  		maple_pnp_time = jiffies + MAPLE_PNP_INTERVAL;
> > -	if (liststatus && list_empty(&maple_sentq)) {
> > +	mutex_lock(&maple_wlist_lock);
> > +	if (!list_empty(&maple_waitq) && list_empty(&maple_sentq)) {
> > +		mutex_unlock(&maple_wlist_lock);
> > +		mutex_lock(&maple_list_lock);
> >  		INIT_LIST_HEAD(&maple_sentq);
> > +		mutex_unlock(&maple_list_lock);
> >  		maple_send();
> > +	} else {
> > +		mutex_unlock(&maple_wlist_lock);
> >  	}
> > +
> >  	maplebus_dma_reset();
> >  }
> 
> This locking looks like a mess.  I'd suggest that maple_list_lock and
> maple_wlist_lock now need documentation.  Describe what data they protect
> and what their ranking rules are.


Well, they don't seem a mess to me, but I can document them, though I
thought thety were pretty self-documenting :( One locks the waiting
queue of packets, one the queue of output packets.

> 
> >  /* handle devices added via hotplugs - placing them on queue for DEVINFO*/
> >  static void maple_map_subunits(struct maple_device *mdev, int submask)
> >  {
> > -	int retval, k, devcheck;
> > +	int retval, k, devcheck, locking;
> >  	struct maple_device *mdev_add;
> >  	struct maple_device_specify ds;
> >  
> > +	ds.port = mdev->port;
> >  	for (k = 0; k < 5; k++) {
> > -		ds.port = mdev->port;
> >  		ds.unit = k + 1;
> >  		retval =
> >  		    bus_for_each_dev(&maple_bus_type, NULL, &ds,
> > @@ -437,9 +448,15 @@ static void maple_map_subunits(struct maple_device *mdev, int submask)
> >  			mdev_add = maple_alloc_dev(mdev->port, k + 1);
> >  			if (!mdev_add)
> >  				return;
> > +			locking = down_trylock(&mdev_add->mq->sem);
> > +			if (locking) {
> > +				up(&mdev_add->mq->sem);
> > +				down_interruptible(&mdev_add->mq->sem);
> > +			}
> 
> What the heck is that trying to do?!?!?!


Again, it is trying to avoid a deadlock between injected packets and
scans for hotplug events.

> 
> And it's buggy.  The return value of down_interruptible() is ignored, so
> the driver has lost track of whether or not the semphore was taken.



You are right about that and it should be fixed
> 


