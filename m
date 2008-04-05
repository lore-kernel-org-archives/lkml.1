Return-Path: <linux-kernel-owner+w=401wt.eu-S1753773AbYDERGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773AbYDERGh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 13:06:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752489AbYDERG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 13:06:28 -0400
Received: from ns.suse.de ([195.135.220.2]:43952 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752428AbYDERG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 13:06:27 -0400
Date: Sat, 5 Apr 2008 10:12:09 -0700
From: Greg KH <gregkh@suse.de>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: pci: add to global list before sysfs?
Message-ID: <20080405171209.GA28388@suse.de>
References: <20080404191350.7f0183a5@mjolnir.drzeus.cx> <20080404210132.GA14418@suse.de> <20080405115727.1265e8a9@mjolnir.drzeus.cx> <20080405155323.GA27252@suse.de> <20080405185501.41ec42a7@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080405185501.41ec42a7@mjolnir.drzeus.cx>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 05, 2008 at 06:55:01PM +0200, Pierre Ossman wrote:
> On Sat, 5 Apr 2008 08:53:23 -0700
> Greg KH <gregkh@suse.de> wrote:
> 
> > On Sat, Apr 05, 2008 at 11:57:27AM +0200, Pierre Ossman wrote:
> > > 
> > > Yes. Things work fine when the driver is loaded after the entire PCI
> > > bus has been scanned, but not when new cards are hotplugged with the
> > > driver already present. I'd like the behaviour to be the same in both
> > > cases.
> > 
> > Why not just create a thread in your driver, or timer, and sleep until
> > you see the other devices?  If after a certian time you never do, then
> > bail out.
> > 
> > That should work properly for you for both cases (startup and loading
> > later.)
> > 
> 
> I'm not sure how that could be done in a clean way. Right now I have
> the following:
> 
>                 sd_dev = NULL;
>                 while ((sd_dev = pci_get_device(PCI_VENDOR_ID_JMICRON,
>                         PCI_DEVICE_ID_JMICRON_JMB38X_SD, sd_dev)) != NULL) {
>                         if ((PCI_SLOT(chip->pdev->devfn) ==
>                                 PCI_SLOT(sd_dev->devfn)) &&
>                                 (chip->pdev->bus == sd_dev->bus))
>                                 break;
>                 }
> 
>                 if (sd_dev) {
>                         pci_dev_put(sd_dev);
>                         dev_info(&chip->pdev->dev, "Refusing to bind to "
>                                 "secondary interface.\n");
>                         return -ENODEV;
>                 }
> 
> If I do this threaded, I'd have to return success to the driver core
> and then act like a possum later.

Yes.

> Doable, but not very clean.

Hey, take it up with the hardware designers compensating for an
"unclean" operating system :)

> It could be solved if it was possible to sleep in probe functions, but
> from what I can tell that will stop the probing of subsequent devices.

Yes, you can sleep, but it will stop the probe of subsequent devices.  I
did implement multiple threads for pci probing, but it ended up not
saving any time and causing more problems than it was worth.

> Also, the timeout would introduce an inherent race. Which means either
> putting a high timeout to make the race insignificant, or a low timeout
> so users don't have to wait for their device to actually become usable.
> 
> Is it possible to write some routines that can walk the PCI device tree
> without having any pci_dev structures to hang on to? To solve my basic
> problem I just need to know how the tree looks like, not actually poke
> any of the other devices.

No, not in a sane way as all arches walk the pci device tree for
discovery in many different ways.

I don't think that a time-out would be a big deal, it shouldn't be very
long (a second or two).  Also note that all distros would not have this
problem as they do pci discovery first, and then start loading all of
the modules in the initramfs after the pci tree has been properly
scanned.  So the very large majority of users would not have a problem.

Or are you doing this on an embedded system?

thanks,

greg k-h
