Return-Path: <linux-kernel-owner+w=401wt.eu-S932398AbXBSQke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398AbXBSQke (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 11:40:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932402AbXBSQke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 11:40:34 -0500
Received: from smtp107.sbc.mail.mud.yahoo.com ([68.142.198.206]:24308 "HELO
	smtp107.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932398AbXBSQkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 11:40:33 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=OwESS6N0D7z6MsPLPKwdfiIgdtKOcCS1ljwY/VN4ZjuVMJzVzBCqWgS29s7G+Z69NpjMUEa9cbrEPIC70t6srrqLLvjkIilv+42/UvxgcExViKGHnlHZwUP8FYIRcrGzQNVTQhO0LabIlbyFQWa3eip025ng0EJR9Xs16FHPxg8=  ;
X-YMail-OSG: qivsUFkVM1kurtueF7avWQmRR3HHYRKshO0yZR89DBYshDVZwET7vC36U056RmQDUcZoyep9_p3fEQWg729zoTC_cyKzH3GjxmoAt1ouo8M.rNVTUzOxyBoiEo7CALSIxhjIr6NO_3NWm7k-
From: David Brownell <david-b@pacbell.net>
To: Jean Delvare <khali@linux-fr.org>
Subject: Re: [patch/rfc 2.6.20-git] parport reports physical devices
Date: Mon, 19 Feb 2007 08:40:30 -0800
User-Agent: KMail/1.7.1
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
References: <200702182108.08217.david-b@pacbell.net> <20070219151847.853c7035.khali@linux-fr.org>
In-Reply-To: <20070219151847.853c7035.khali@linux-fr.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702190840.30643.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 February 2007 6:18 am, Jean Delvare wrote:
> Hi David,
> 
> On Sun, 18 Feb 2007 21:08:07 -0800, David Brownell wrote:
> > Currently a parport_driver can't get a handle on the device node for the
> > underlying parport (PNPACPI, PCI, etc).  That prevents correct placement
> > of sysfs child nodes, which can affect things like power management.
> > 
> > This patch resolves that issue for non-legacy configurations:
> > 
> >     * "struct parport" now has a field pointing to that device node,
> >       and non-legacy port drivers now initialize that device pointer:
> > 	- parport_mfc3 (can't test or build; no Amiga + Zorro here)
> > 	- parport_pc (and stop using only pci_device internally)
> 
> Only in the PCI and PNP cases. Super-I/O and legacy cases still don't
> have a valid device pointer to pass. This annoys me because the laptop
> I'm using for my daily work has such a legacy parallel port, 

And SuperIO precludes PNP support?  I guess that's one of the Mysteries.

Well, as I said, "non-legacy" configs.  One must start somewhere, and
I have no (working) legacy hardware to even try!


> > 	- parport_serial
> > 	- parport_sunbpp (can't test or build, no SPARC + SBUS here)
> > 
> >     * pnp now initializes device dma masks (24bits), preventing oopses
> >       when generic dma calls are made using pnp device nodes
> 
> The patch is quite large and I fail to see the relation between the dma
> mask bug and the original purpose of the patch.

Preventing that oopsing, while letting me have a single patch to work with.


> Can you possibly split 
> the dma fixes to a separate patch? So we can get this part in the
> kernel faster.

Certainly could; that's one of the comments I expected. 

But someone who knows PNP better than I do should confirm that part is
correct; I'm not sure a 24bit mask is correct for *all* PNP devices.
(And while it shouldn't hurt for devices that don't support DMA, it might
still be better not to set DMA masks for such devices...)


> >     * some of the layered parport_driver code now uses that pointer:
> > 	- i2c-parport (parent of i2c_adapter)
> > 	- spi_butterfly (parent of spi_master, allowing cruft removal)
> 
> Yes, the cleanups in the spi_butterfly driver are quite nice :) They
> didn't apply cleanly on my tree though, I guess you have some local
> changes.

Yes, removal of class_device and friends from the SPI stack.  That's a
case where a "struct class" adds no value.

 
> > 	- lp (creating class_device)
> > 	- ppdev (parent of parportN device)
> > 	- tipar (creating class_device)
> > 
> > Sanity tested on a PC, where PNPACPI provides the device to parport_pc,
> > using spi_butterfly.  But I've got to wonder about parport DMA...
> 
> Tested on my other machine with has a PNP parallel port too, and it
> worked fine. Great :)

Good!  Did you happen to try parport printing, with DMA?


> > @@ -2180,9 +2181,10 @@ struct parport *parport_pc_probe_port (u
> >  	priv->fifo_depth = 0;
> >  	priv->dma_buf = NULL;
> >  	priv->dma_handle = 0;
> > -	priv->dev = dev;
> >  	INIT_LIST_HEAD(&priv->list);
> >  	priv->port = p;
> > +
> > +	p->dev = dev;
> 
> This might be the right place to add some warning if dev == NULL, so
> that the remaining drivers can be spotted and ported over time? Or even
> lower in the stack, in parport_announce_port()?

Lower would be better, if there's going to be such a warning; the issue
isn't specific to parport_pc.  This version doesn't add such a warning.


> > --- g26.orig/drivers/i2c/busses/i2c-parport.c	2006-12-12 19:25:43.000000000 -0800
> > +++ g26/drivers/i2c/busses/i2c-parport.c	2007-02-18 09:13:34.000000000 -0800
> > @@ -143,7 +143,7 @@ static struct i2c_algo_bit_data parport_
> >  
> >  /* ----- I2c and parallel port call-back functions and structures --------- */
> >  
> > -static struct i2c_adapter parport_adapter = {
> > +static const struct i2c_adapter parport_adapter = {
> >  	.owner		= THIS_MODULE,
> >  	.class		= I2C_CLASS_HWMON,
> >  	.id		= I2C_HW_B_LP,
> 
> This change doesn't belong to this patch at all, although it is
> correct. I'll be happy to apply it if you send it to me separately.
> 
> (Or it might be even better to get rid of this static structure
> altogether and intialize the fields of the dynamically allocated
> structure individually instead. This would make the driver smaller.)

Smaller is better.  ;)


> > @@ -175,6 +175,7 @@ static void i2c_parport_attach (struct p
> >  		adapter->algo_data.getscl = NULL;
> >  	adapter->algo_data.data = port;
> >  	adapter->adapter.algo_data = &adapter->algo_data;
> > +	adapter->adapter.dev.parent = port->physport->dev;
> >  
> >  	if (parport_claim_or_block(adapter->pdev) < 0) {
> >  		printk(KERN_ERR "i2c-parport: Could not claim parallel port\n");
> 
> Maybe we should even fail if the physical device is missing, as you did
> in spi_butterfly?

I didn't want to make that call for the I2C stack, certainly not as
part of this patch!  The goal here wasn't "fix everything"; rather
to start the fixing, by providing the API and making the most common
cases behave.


> As you know, some i2c subsystem changes are not 
> possible until all i2c-adapter drivers have a valid physical parent
> device. I don't want to wait that all parport drivers have been
> updating before we can clean up i2c-core itself.
> 
> Which means that I will have to fix the legacy parport_pc case right
> now, otherwise I will no longer be able to use i2c-parport and this
> isn't an option for me.

I admire your enthusiasm.  :)


> What do you think would be the right way to do 
> it? A platform driver I guess, and we create a platform device for
> every successful call to parport_pc_probe_port() with a NULL dev
> pointer? That would be a fake driver, as the probe() and remove()
> methods would do nothing as far as I can see, but that's all I can
> think of at the moment.

Yes, a platform_driver ... and ideally, moving all that hardware probing
and scanning code into a separate file.  Probe/scan steps shouldn't really
be part of *any* driver.

There are probably good reasons (== deep hardware braindamage on older
systems that are now hard to find) for the strange init sequencing in
that code, but I can't see why they should prevent splitting out

	(a) device discovery via probing, PNP, or whatever; from

	(b) the driver itself, getting handed a device node that's
	    pre-configured with the resources reported by discovery.

Maybe the maintainers of the parport stack will have comments.  Though
the info in MAINTAINERS seems dated, if not obsolete.

- Dave

