Return-Path: <linux-kernel-owner+w=401wt.eu-S933938AbYBBTsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933938AbYBBTsx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 14:48:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933517AbYBBTsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 14:48:39 -0500
Received: from qb-out-0506.google.com ([72.14.204.227]:51010 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759602AbYBBTsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 14:48:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=Smhvvyaa2d/w7RC/FaS/bKBGQMwGrfaV4KwzNtibJfscWPUDd83xi20Yl7HTeXIGxGYqWBK0K8egNlNJGPemDjBGMQYEdYwmu8B3NeQkJtPyn7JuxxrMe5nFLAcxv5XHI6C7gTa3tMF69VKwO81WC6dQ8thoyD/gNeOxDI3W1OA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: PCI: Remove users of pci_enable_device_bars()
Date: Sat, 2 Feb 2008 21:01:10 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
References: <200802020506.m1256FVn024064@hera.kernel.org> <47A40D54.70509@garzik.org>
In-Reply-To: <47A40D54.70509@garzik.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802022101.11095.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 02 February 2008, Jeff Garzik wrote:
> Linux Kernel Mailing List wrote:
> > Commit:     0948391641918b95d8d96c15089eb5ac156850b3
> 
> >     PCI: Remove users of pci_enable_device_bars()
> >     
> >     This patch converts users of pci_enable_device_bars() to the new
> >     pci_enable_device_{io,mem} interface.
> >     
> >     The new API fits nicely, except maybe for the QLA case where a bit of
> >     code re-organization might be a good idea but I prefer sticking to the
> >     simple patch as I don't have hardware to test on.
> >     
> >     I'll also need some feedback on the cs5520 change.
> >     
> >     Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> >     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> > --- a/drivers/ata/pata_cs5520.c
> > +++ b/drivers/ata/pata_cs5520.c
> > @@ -229,7 +229,7 @@ static int __devinit cs5520_init_one(struct pci_dev *pdev, const struct pci_devi
> >  		return -ENOMEM;
> >  
> >  	/* Perform set up for DMA */
> > -	if (pci_enable_device_bars(pdev, 1<<2)) {
> > +	if (pci_enable_device_io(pdev)) {
> >  		printk(KERN_ERR DRV_NAME ": unable to configure BAR2.\n");
> >  		return -ENODEV;
> >  	}
> > diff --git a/drivers/ide/pci/cs5520.c b/drivers/ide/pci/cs5520.c
> > index 6ec00b8..10adc49 100644
> > --- a/drivers/ide/pci/cs5520.c
> > +++ b/drivers/ide/pci/cs5520.c
> > @@ -156,8 +156,14 @@ static int __devinit cs5520_init_one(struct pci_dev *dev, const struct pci_devic
> >  	ide_setup_pci_noise(dev, d);
> >  
> >  	/* We must not grab the entire device, it has 'ISA' space in its
> > -	   BARS too and we will freak out other bits of the kernel */
> > -	if (pci_enable_device_bars(dev, 1<<2)) {
> > +	 * BARS too and we will freak out other bits of the kernel
> > +	 *
> > +	 * pci_enable_device_bars() is going away. I replaced it with
> > +	 * IO only enable for now but I'll need confirmation this is
> > +	 * allright for that device. If not, it will need some kind of
> > +	 * quirk. --BenH.
> > +	 */
> > +	if (pci_enable_device_io(dev)) {
> >  		printk(KERN_WARNING "%s: Unable to enable 55x0.\n", d->name);
> >  		return -ENODEV;
> >  	}
> 
> So...  did the feedback mentioned in the commit log ever appear?  :)

Since Alan has commented on it:

http://lkml.org/lkml/2007/12/17/422

"5520 in fact is always enabled as it is the host bridge.
pci_enable_device_io will do just fine. The 5520 fun is if you disable it
the system hangs."

I moved on assuming that either submitter or integrator would follow up...
but it seems that it didn't happen. :(

PS Could somebody remove the stale comment from cs5520.c?

Thanks,
Bart
