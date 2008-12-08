Return-Path: <linux-kernel-owner+w=401wt.eu-S1753752AbYLHXJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752AbYLHXJX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 18:09:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753243AbYLHXJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 18:09:04 -0500
Received: from relay1.sgi.com ([192.48.179.29]:49052 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754515AbYLHXJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 18:09:03 -0500
Date: Mon, 8 Dec 2008 17:09:01 -0600 (CST)
From: Brent Casavant <bcasavan@sgi.com>
Reply-To: Brent Casavant <bcasavan@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, mdr@sgi.com, rw@novell.com,
       kasievers@novell.com
Subject: Re: [PATCH] ioc4: automatically load sgiioc4 subordinate module
In-Reply-To: <20081208145507.8d03834e.akpm@linux-foundation.org>
Message-ID: <alpine.BSF.1.10.0812081707110.1046@pkunk.americas.sgi.com>
References: <alpine.BSF.1.10.0812051601060.388@pkunk.americas.sgi.com> <20081208145507.8d03834e.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (BSF 962 2008-03-14)
Organization: "Silicon Graphics, Inc."
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike, Raymond, or Kay, could you take this question?

I mostly just passed along Mike's patch, so I'm not 100% familiar with
why those other mechanisms Andrew mentions aren't being employed.

Brent

On Mon, 8 Dec 2008, Andrew Morton wrote:

> On Fri, 5 Dec 2008 16:04:37 -0600 (CST)
> Brent Casavant <bcasavan@sgi.com> wrote:
> 
> > The main ioc4 driver which manages ownership of the SGI IOC4 PCI device
> > does not automatically load any of the ioc4 submodules (the sgiioc4 IDE
> > and ioc4_serial serial drivers) during PCI device probing.  This causes
> > problems when the root device is a DVD-ROM attached to the IOC4 IDE
> > interface (e.g. during system installation) as the sgiioc4 module
> > will not be loaded and thus the DVD-ROM device will not be available.
> > 
> > Modify ioc4 to always load the sgiioc4 IDE module if the board carrying
> > the IOC4 hardware actually implements the IDE interface (not all boards
> > bring this functionality off the IOC4 chip).
> > 
> > The use of a work procedure is necessary as request_module() cannot be
> > called from the device probe path as it eventually calls out to userspace.
> > 
> 
> This is a fairly common problem, isn't it?  Other drivers handle it via
> appropriate udev magic and initrd/initramfs setups.
> 
> Is there something special about ioc4 which requires that it have this
> magical special handling?
> 
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
> 
> 

-- 
Brent Casavant                          All music is folk music.  I ain't
bcasavan@sgi.com                        never heard a horse sing a song.
Silicon Graphics, Inc.                    -- Louis Armstrong
