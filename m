Return-Path: <linux-kernel-owner+w=401wt.eu-S1751748AbXJUIid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751748AbXJUIid (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 04:38:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751205AbXJUIi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 04:38:26 -0400
Received: from hu-out-0506.google.com ([72.14.214.227]:56220 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbXJUIiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 04:38:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:in-reply-to:references:organization:x-mailer:mime-version:content-type:content-transfer-encoding:from;
        b=mnd9YNYnnLWEIhTjidtsVsnEWGn3cKR9p+OvOFDUnqGf5B3/bOCRi/XRN3w3HjuE94G0WDrEEEnlKoT5GDYJe2z7eGo9rIGUpMJFJbnZ73fm1pRLK0dFQ5iaGDLwQtrymIi6xeEC2nkQFhh7mOtxL0KCKxxl6FKPmXfgrDZZ9rQ=
Date: Sun, 21 Oct 2007 10:46:17 -0700
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, linux-pcmcia@lists.infradead.org,
       linux-kernel@vger.kernel.org,
       Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: PCMCIA driver resource allocation
Message-Id: <20071021104617.e2834c54.Kristoffer.Ericson@Gmail.com>
In-Reply-To: <20071019224022.GA29738@flint.arm.linux.org.uk>
References: <200710191051.51686.bjorn.helgaas@hp.com>
	<20071019224022.GA29738@flint.arm.linux.org.uk>
Organization: JLime
X-Mailer: Sylpheed 2.4.5 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2007 23:40:22 +0100
Russell King <rmk+lkml@arm.linux.org.uk> wrote:

Ive been meaning to talk to dominik about some hp6xx pcmcia issues Im having, but seem to be quite hard to get in touch with him or the linux-pcmcia list.

> On Fri, Oct 19, 2007 at 10:51:51AM -0600, Bjorn Helgaas wrote:
> > Question 1: Does the linux-pcmcia list still exist?  It's in MAINTAINERS:
> > 
> >   PCMCIA SUBSYSTEM
> >   P:      Linux PCMCIA Team
> >   L:      linux-pcmcia@lists.infradead.org
> >   L:      http://lists.infradead.org/mailman/listinfo/linux-pcmcia
> >   T:      git kernel.org:/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git
> >   S:      Maintained
> > 
> > but the archive: http://lists.infradead.org/mailman/listinfo/linux-pcmcia
> > seems dead.
> 
> The list is still around, but Dominik seems to have vanished.
Ive tried to subscribbe to the list, but with no luck.

> 
> > Question 2: Documentation/pcmcia/driver-changes.txt says drivers should
> > now claim their own resources:
> > 
> >   * Resource management. (as of 2.6.8)
> >      Although the PCMCIA subsystem will allocate resources for cards,
> >      it no longer marks these resources busy. This means that driver
> >      authors are now responsible for claiming your resources as per
> >      other drivers in Linux.
> > 
> > But I don't see any drivers that do that.  It looks like there should
> > be a bunch of changes like the one below.  Is there a reason these
> > changes didn't happen, other than just lack of interest?
> 
> That's from around the time that I handed PCMCIA over to Dominik, and was
> a to-do item.  I had some drivers converted over - mainly the few that I
> was using, those being serial and pcnet_cs (serial is converted over but
> the patch I had for pcnet_cs is below.)
> 
> However, in spite of me pointing Dominik at my remaining patch sets several
> times, as far as I could tell they got ignored.  So essentially I all lost
> interest in helping out with PCMCIA.
> 
> > Index: work3/drivers/net/wireless/orinoco_cs.c
> > ===================================================================
> > --- work3.orig/drivers/net/wireless/orinoco_cs.c	2007-10-18 10:56:34.000000000 -0600
> > +++ work3/drivers/net/wireless/orinoco_cs.c	2007-10-18 13:22:44.000000000 -0600
> > @@ -296,6 +296,10 @@
> >  	/* We initialize the hermes structure before completing PCMCIA
> >  	 * configuration just in case the interrupt handler gets
> >  	 * called. */
> > +	priv->io_resource = request_region(link->io.BasePort1,
> > +					   link->io.NumPorts1, DRIVER_NAME);
> > +	if (!priv->io_resource)
> > +		goto cs_failed;
> >  	mem = ioport_map(link->io.BasePort1, link->io.NumPorts1);
> >  	if (!mem)
> >  		goto cs_failed;
> > @@ -366,6 +370,10 @@
> >  	pcmcia_disable_device(link);
> >  	if (priv->hw.iobase)
> >  		ioport_unmap(priv->hw.iobase);
> > +	if (priv->io_resource) {
> > +		release_resource(priv->io_resource);
> > +		priv->io_resource = NULL;
> 
> Wrong function.  release_resource() doesn't pair with request_region().
> request_region() allocates memory for the struct resource.
> release_resource() merely removes the struct resource from the tree.
> release_region() on the other hand removes the struct resource and
> frees it.
> 
> ---
> 
> Convert pcnet_cs and serial_cs to request their IO regions, thereby
> marking them busy.  These are only two of many drivers which need this
> update.
> 
> diff -u -x BitKeeper -x ChangeSet -x SCCS -x _xlk -x '*.orig' -x '*.rej' ref/drivers/net/pcmcia/pcnet_cs.c linux/drivers/net/pcmcia/pcnet_cs.c
> --- ref/drivers/net/pcmcia/pcnet_cs.c	Sun Nov 16 19:12:33 2003
> +++ linux/drivers/net/pcmcia/pcnet_cs.c	Tue Dec 23 09:43:22 2003
> @@ -687,8 +687,15 @@
>      dev->poll_controller = ei_poll;
>  #endif
>  
> +    if (!request_region(dev->base_addr, link->io.NumPorts1, "pcnet_cs")) {
> +	printk(KERN_NOTICE "pcnet_cs: request_region() failed\n");
> +	link->dev = NULL;
> +	goto failed;
> +    }
> +
>      if (register_netdev(dev) != 0) {
>  	printk(KERN_NOTICE "pcnet_cs: register_netdev() failed\n");
> +	release_region(dev->base_addr, link->io.NumPorts1);
>  	link->dev = NULL;
>  	goto failed;
>      }
> @@ -736,6 +743,9 @@
>  
>      DEBUG(0, "pcnet_release(0x%p)\n", link);
>  
> +    if (link->dev)
> +	release_region(link->io.BasePort1, link->io.NumPorts1);
> +
>      if (info->flags & USE_SHMEM) {
>  	iounmap(info->base);
>  	pcmcia_release_window(link->win);
> 
> 
> -- 
> Russell King
>  Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
>  maintainer of:
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Kristoffer Ericson <Kristoffer.Ericson@Gmail.com>
