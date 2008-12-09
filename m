Return-Path: <linux-kernel-owner+w=401wt.eu-S1753178AbYLICBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178AbYLICBm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 21:01:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751444AbYLICBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 21:01:33 -0500
Received: from relay1.sgi.com ([192.48.179.29]:33358 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751086AbYLICBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 21:01:33 -0500
Date: Mon, 8 Dec 2008 20:01:31 -0600 (CST)
From: Brent Casavant <bcasavan@sgi.com>
Reply-To: Brent Casavant <bcasavan@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, mdr@sgi.com, rw@novell.com,
       kasievers@novell.com
Subject: Re: [PATCH] ioc4: automatically load sgiioc4 subordinate module
In-Reply-To: <20081208145507.8d03834e.akpm@linux-foundation.org>
Message-ID: <alpine.BSF.1.10.0812081932180.1046@pkunk.americas.sgi.com>
References: <alpine.BSF.1.10.0812051601060.388@pkunk.americas.sgi.com> <20081208145507.8d03834e.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (BSF 962 2008-03-14)
Organization: "Silicon Graphics, Inc."
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Dec 2008, Andrew Morton wrote:

> On Fri, 5 Dec 2008 16:04:37 -0600 (CST)
> Brent Casavant <bcasavan@sgi.com> wrote:

> > ---
> >  ioc4.c |   26 ++++++++++++++++++++++++++
> >  1 file changed, 26 insertions(+)
> > 
> > diff --git a/drivers/misc/ioc4.c b/drivers/misc/ioc4.c
> > index 6f76573..36320bd 100644
> > --- a/drivers/misc/ioc4.c
> > +++ b/drivers/misc/ioc4.c
> > @@ -269,6 +269,16 @@ ioc4_variant(struct ioc4_driver_data *idd)
> >  	return IOC4_VARIANT_PCI_RT;
> >  }
> >  
> > +static void
> > +ioc4_load_modules(struct work_struct *work)
> > +{
> > +	/* arg just has to be freed */
> > +
> > +	request_module("sgiioc4");
> > +
> > +	kfree(work);
> > +}
> > +
> >  /* Adds a new instance of an IOC4 card */
> >  static int
> >  ioc4_probe(struct pci_dev *pdev, const struct pci_device_id *pci_id)
> > @@ -378,6 +388,22 @@ ioc4_probe(struct pci_dev *pdev, const struct pci_device_id *pci_id)
> >  	}
> >  	mutex_unlock(&ioc4_mutex);
> >  
> > +	if (idd->idd_variant != IOC4_VARIANT_PCI_RT) {
> > +		struct work_struct *work;
> > +		work = kzalloc(sizeof(struct work_struct), GFP_KERNEL);
> > +		if (!work) {
> > +			printk(KERN_WARNING
> > +			       "%s: IOC4 unable to allocate memory for "
> > +			       "load of sub-modules.\n",
> > +			       __FUNCTION__);
> > +		}
> > +		else {
> > +			printk(KERN_INFO "IOC4 loading ioc4 submodule\n");
> > +			INIT_WORK(work, ioc4_load_modules);
> > +			schedule_work(work);
> > +		}
> > +	}
> > +
> >  	return 0;
> >  
> 
> ioc4 can be compiled as a module.  So if someone does an `rmmod ioc4' after
> the schedule_work() and before or during the execution of the work
> function, dead machine.
> 
> This race is fixable by adding a flush_scheduled_work() into
> ioc4_exit(), I expect.

In this case I believe a better spot for the flush_schedule_work() is
immediately after calling schedule_work(), for two reasons.

First, and something I should have realized earlier, with the work
scheduled but not guaranteed to have completed, we're not sure
exactly when the IDE device will show up, and thus have no guarantee
when the desired root device will appear.  Thus it would be good to
make sure sgiioc4 has completed loading before ioc4_probe() returns.

Second, if ioc4_exit() can be invoked at an unfortunate time as
mentioned, that implies the following sequence is possible:

	
	Thread A			Thread B
					ioc4_probe();
					schedule_work();
	ioc4_exit();
	flush_scheduled_work();
					request_module("sgiioc4");
					... sgiioc4 loads ...
					ioc4_register_submodule();
	pci_unregister_driver();

This leaves us with sgiioc4 loaded and containing references to the
now removed IOC4 driver.  I must assume badness ensues. :(

This is normally prevented by the module reference counting mechanism,
but in this case the reference count on ioc4 wouldn't bump until sgiioc4
loads, which is after we're in the ioc4_exit() path.  I suppose some
reference count tricks could work around this (i.e. bump ioc4's refcount
before schedule_work(), and de-bump it when sgiioc4 is finished loading),
but that has a hackish flavor.

Anyway, I think both of these argue for putting the flush_scheduled_work()
immediatley after the schedule_work() call.  I'll test this idea after
a test system is configured overnight and should have a patch available
tomorrow.

Brent

-- 
Brent Casavant                          All music is folk music.  I ain't
bcasavan@sgi.com                        never heard a horse sing a song.
Silicon Graphics, Inc.                    -- Louis Armstrong
