Return-Path: <linux-kernel-owner+w=401wt.eu-S934594AbYBBUIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934594AbYBBUIY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 15:08:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933951AbYBBUIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 15:08:10 -0500
Received: from mx2.suse.de ([195.135.220.15]:40102 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933784AbYBBUII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 15:08:08 -0500
Date: Sat, 2 Feb 2008 12:05:31 -0800
From: Greg KH <gregkh@suse.de>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: PCI: Remove users of pci_enable_device_bars()
Message-ID: <20080202200531.GC24717@suse.de>
References: <200802020506.m1256FVn024064@hera.kernel.org> <47A40D54.70509@garzik.org> <200802022101.11095.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802022101.11095.bzolnier@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 02, 2008 at 09:01:10PM +0100, Bartlomiej Zolnierkiewicz wrote:
> On Saturday 02 February 2008, Jeff Garzik wrote:
> > Linux Kernel Mailing List wrote:
> > > Commit:     0948391641918b95d8d96c15089eb5ac156850b3
> > 
> > >     PCI: Remove users of pci_enable_device_bars()
> > >     
> > >     This patch converts users of pci_enable_device_bars() to the new
> > >     pci_enable_device_{io,mem} interface.
> > >     
> > >     The new API fits nicely, except maybe for the QLA case where a bit of
> > >     code re-organization might be a good idea but I prefer sticking to the
> > >     simple patch as I don't have hardware to test on.
> > >     
> > >     I'll also need some feedback on the cs5520 change.
> > >     
> > >     Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > >     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > 
> > > --- a/drivers/ata/pata_cs5520.c
> > > +++ b/drivers/ata/pata_cs5520.c
> > > @@ -229,7 +229,7 @@ static int __devinit cs5520_init_one(struct pci_dev *pdev, const struct pci_devi
> > >  		return -ENOMEM;
> > >  
> > >  	/* Perform set up for DMA */
> > > -	if (pci_enable_device_bars(pdev, 1<<2)) {
> > > +	if (pci_enable_device_io(pdev)) {
> > >  		printk(KERN_ERR DRV_NAME ": unable to configure BAR2.\n");
> > >  		return -ENODEV;
> > >  	}
> > > diff --git a/drivers/ide/pci/cs5520.c b/drivers/ide/pci/cs5520.c
> > > index 6ec00b8..10adc49 100644
> > > --- a/drivers/ide/pci/cs5520.c
> > > +++ b/drivers/ide/pci/cs5520.c
> > > @@ -156,8 +156,14 @@ static int __devinit cs5520_init_one(struct pci_dev *dev, const struct pci_devic
> > >  	ide_setup_pci_noise(dev, d);
> > >  
> > >  	/* We must not grab the entire device, it has 'ISA' space in its
> > > -	   BARS too and we will freak out other bits of the kernel */
> > > -	if (pci_enable_device_bars(dev, 1<<2)) {
> > > +	 * BARS too and we will freak out other bits of the kernel
> > > +	 *
> > > +	 * pci_enable_device_bars() is going away. I replaced it with
> > > +	 * IO only enable for now but I'll need confirmation this is
> > > +	 * allright for that device. If not, it will need some kind of
> > > +	 * quirk. --BenH.
> > > +	 */
> > > +	if (pci_enable_device_io(dev)) {
> > >  		printk(KERN_WARNING "%s: Unable to enable 55x0.\n", d->name);
> > >  		return -ENODEV;
> > >  	}
> > 
> > So...  did the feedback mentioned in the commit log ever appear?  :)
> 
> Since Alan has commented on it:
> 
> http://lkml.org/lkml/2007/12/17/422
> 
> "5520 in fact is always enabled as it is the host bridge.
> pci_enable_device_io will do just fine. The 5520 fun is if you disable it
> the system hangs."
> 
> I moved on assuming that either submitter or integrator would follow up...
> but it seems that it didn't happen. :(
> 
> PS Could somebody remove the stale comment from cs5520.c?

Ben, care to send me a patch for this, as it's your change?

thanks,

greg k-h
