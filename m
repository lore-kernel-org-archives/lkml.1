Return-Path: <linux-kernel-owner+w=401wt.eu-S1758576AbZAGAoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758576AbZAGAoZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 19:44:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752247AbZAGAoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 19:44:16 -0500
Received: from ns1.suse.de ([195.135.220.2]:55505 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754514AbZAGAoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 19:44:14 -0500
Date: Tue, 6 Jan 2009 16:42:58 -0800
From: Greg KH <gregkh@suse.de>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pci: fix no_pci_devices() #2
Message-ID: <20090107004258.GA3223@suse.de>
References: <20081220111419.GA5367@localhost.localdomain> <200901051109.43953.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901051109.43953.jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2009 at 11:09:43AM -0800, Jesse Barnes wrote:
> On Saturday, December 20, 2008 3:14 am Vegard Nossum wrote:
> > On Sat, Dec 20, 2008 at 11:56 AM, Vegard Nossum <vegard.nossum@gmail.com> 
> wrote:
> > > On Sat, Dec 20, 2008 at 9:58 AM, Greg KH <gregkh@suse.de> wrote:
> > >> Care to make a patch for no_pci_devices() to work properly in this kind
> > >> of situation?
> > >
> > > How does this look?
> > >
> > > I have introduced a variable pci_is_initiated, which is set after the bus
> > > has been registered.
> >
> > This patch is simpler and also works for me. But I am not too fond of it
> > either...
> >
> >
> > Vegard
> >
> >
> > From 1f047c86fc7a831d85174452da92344a3582a158 Mon Sep 17 00:00:00 2001
> > From: Vegard Nossum <vegard.nossum@gmail.com>
> > Date: Sat, 20 Dec 2008 12:08:18 +0100
> > Subject: [PATCH] pci: fix no_pci_devices() #2
> >
> > In short, no_pci_devices() should not use bus_find_device() before
> > initcalls have run, because the pci bus structure has not been
> > initialized yet.
> >
> > Reference: http://lkml.org/lkml/2008/12/20/21
> >
> > Cc: Greg KH <gregkh@suse.de>
> > Cc: Pekka Enberg <penberg@cs.helsinki.fi>
> > Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
> > ---
> >  drivers/base/bus.c  |    1 +
> >  drivers/pci/probe.c |    3 +++
> >  2 files changed, 4 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/base/bus.c b/drivers/base/bus.c
> > index 5aee1c0..5e83faf 100644
> > --- a/drivers/base/bus.c
> > +++ b/drivers/base/bus.c
> > @@ -931,6 +931,7 @@ bus_devices_fail:
> >  bus_uevent_fail:
> >  	kset_unregister(&bus->p->subsys);
> >  	kfree(bus->p);
> > +	bus->p = NULL;
> >  out:
> >  	return retval;
> >  }
> > diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> > index 003a9b3..d561be7 100644
> > --- a/drivers/pci/probe.c
> > +++ b/drivers/pci/probe.c
> > @@ -35,6 +35,9 @@ int no_pci_devices(void)
> >  	struct device *dev;
> >  	int no_devices;
> >
> > +	if (!pci_bus_type.p)
> > +		return 1;
> > +
> >  	dev = bus_find_device(&pci_bus_type, NULL, NULL, find_anything);
> >  	no_devices = (dev == NULL);
> >  	put_device(dev);
> 
> Assuming Greg already took the generic part, can you resend the PCI part to 
> the linux-pci@vger.kernel.org list for review just in case anyone has a better 
> idea of how to do it?

Did I take the generic part?  I can't remember...

thanks,

greg k-h
