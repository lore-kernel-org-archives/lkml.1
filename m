Return-Path: <linux-kernel-owner+w=401wt.eu-S1750945AbXBXVzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750945AbXBXVzN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 16:55:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932420AbXBXVzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 16:55:13 -0500
Received: from smtp104.sbc.mail.re2.yahoo.com ([68.142.229.101]:31414 "HELO
	smtp104.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750945AbXBXVzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 16:55:11 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=hnWqC4VvSYAD+VvX4bLChg4cJoKo0QrGJFAl2XgQ0vhSqnFr/i9Zj6bUo/UkGBIW5Les9GDESm9Ae3EMQsqNmq7FoYx3QKtds9iZiOl8bS8VIhVQ6J9RUi0RQb+fWIBi83JUUVBc3daVGNMMIRdeFwNzIZ88CM/kEmo6k9qq1fo=  ;
X-YMail-OSG: aN1ZpKIVM1l5ETv_xhKBIthzM.wG6Hlb3UU7T_XN2ndThRvFaTS1oeMOn0hH2dk8RNP7LBrTZcfD6cD81vNV36HNwzmrRG7OwDhE2mdfZAfT4eRKc7QweQxpfS1eoL89HhwNzpuzktoXkPo-
From: David Brownell <david-b@pacbell.net>
To: Jean Delvare <khali@linux-fr.org>
Subject: Re: [patch/rfc 2.6.20-git] parport reports physical devices
Date: Sat, 24 Feb 2007 13:40:44 -0800
User-Agent: KMail/1.7.1
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
References: <200702182108.08217.david-b@pacbell.net> <200702190840.30643.david-b@pacbell.net> <20070220221043.ead0b744.khali@linux-fr.org>
In-Reply-To: <20070220221043.ead0b744.khali@linux-fr.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702241340.44804.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 February 2007 1:10 pm, Jean Delvare wrote:

> Here is the naive patch I have come up with. It does the job, even
> though it is not clean by any means. But as you said, it's certainly not
> worse than the current state, so I hope we can still apply it.

One glitch I noticed:  on driver rmmod it removes *any* parport platform
device, rather than just ones that it created.  So the minute any system
starts doing the Right Thing, registering platform devices itself, trouble
starts!  Minimally, stick a magic cookie in platform_data and don't remove
devices without that cookie.  (Cookie might be a pointer to something not
exported by that driver.)

Plus, that platform_driver won't work with a real platform_device ... but
that looks like it'd take more time to fix cleanly than I have time for.
(PowerPC and SPARC64 would probably be happier with real platform_device
setup, given what their <asm/parport.h> is doing.)

- Dave


> 
> * * * * *
> 
> Give legacy parallel ports a platform device in the device tree.
> This is a quick and dirty implementation, it doesn't actually convert
> the legacy parport code to the device driver model, but at least
> parallel port device drivers will have a device to work with.
> 
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> ---
>  drivers/parport/parport_pc.c |   39 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 39 insertions(+)
> 
> --- linux-2.6.21-pre.orig/drivers/parport/parport_pc.c	2007-02-19 12:03:44.000000000 +0100
> +++ linux-2.6.21-pre/drivers/parport/parport_pc.c	2007-02-19 18:15:41.000000000 +0100
> @@ -53,6 +53,7 @@
>  #include <linux/slab.h>
>  #include <linux/pci.h>
>  #include <linux/pnp.h>
> +#include <linux/platform_device.h>
>  #include <linux/sysctl.h>
>  
>  #include <asm/io.h>
> @@ -2156,6 +2157,17 @@ struct parport *parport_pc_probe_port (u
>  	struct resource *base_res;
>  	struct resource	*ECR_res = NULL;
>  	struct resource	*EPP_res = NULL;
> +	struct platform_device *pdev = NULL;
> +
> +	if (!dev) {
> +		/* We need a physical device to attach to, but none was
> +		   provided. Create our own. */
> +		pdev = platform_device_register_simple("parport_pc",
> +						       base, NULL, 0);
> +		if (IS_ERR(pdev))
> +			return NULL;
> +		dev = &pdev->dev;
> +	}
>  
>  	ops = kmalloc(sizeof (struct parport_operations), GFP_KERNEL);
>  	if (!ops)
> @@ -2359,6 +2371,8 @@ out3:
>  out2:
>  	kfree (ops);
>  out1:
> +	if (pdev)
> +		platform_device_unregister(pdev);
>  	return NULL;
>  }
>  
> @@ -3106,6 +3120,21 @@ static struct pnp_driver parport_pc_pnp_
>  };
>  
>  
> +static int __devinit parport_pc_platform_probe(struct platform_device *pdev)
> +{
> +	/* Always succeed, the actual probing is done in
> +	   parport_pc_probe_port(). */
> +	return 0;
> +}
> +
> +static struct platform_driver parport_pc_platform_driver = {
> +	.driver = {
> +		.owner	= THIS_MODULE,
> +		.name	= "parport_pc",
> +	},
> +	.probe		= parport_pc_platform_probe,
> +};
> +
>  /* This is called by parport_pc_find_nonpci_ports (in asm/parport.h) */
>  static int __devinit __attribute__((unused))
>  parport_pc_find_isa_ports (int autoirq, int autodma)
> @@ -3381,9 +3410,15 @@ __setup("parport_init_mode=",parport_ini
>  
>  static int __init parport_pc_init(void)
>  {
> +	int err;
> +
>  	if (parse_parport_params())
>  		return -EINVAL;
>  
> +	err = platform_driver_register(&parport_pc_platform_driver);
> +	if (err)
> +		return err;
> +
>  	if (io[0]) {
>  		int i;
>  		/* Only probe the ports we were given. */
> @@ -3408,6 +3443,7 @@ static void __exit parport_pc_exit(void)
>  		pci_unregister_driver (&parport_pc_pci_driver);
>  	if (pnp_registered_parport)
>  		pnp_unregister_driver (&parport_pc_pnp_driver);
> +	platform_driver_unregister(&parport_pc_platform_driver);
>  
>  	spin_lock(&ports_lock);
>  	while (!list_empty(&ports_list)) {
> @@ -3416,6 +3452,9 @@ static void __exit parport_pc_exit(void)
>  		priv = list_entry(ports_list.next,
>  				  struct parport_pc_private, list);
>  		port = priv->port;
> +		if (port->dev && port->dev->bus == &platform_bus_type)
> +			platform_device_unregister(
> +				to_platform_device(port->dev));
>  		spin_unlock(&ports_lock);
>  		parport_pc_unregister_port(port);
>  		spin_lock(&ports_lock);
> 
> * * * * *
> 
> > There are probably good reasons (== deep hardware braindamage on older
> > systems that are now hard to find) for the strange init sequencing in
> > that code, but I can't see why they should prevent splitting out
> > 
> > 	(a) device discovery via probing, PNP, or whatever; from
> > 
> > 	(b) the driver itself, getting handed a device node that's
> > 	    pre-configured with the resources reported by discovery.
> > 
> > Maybe the maintainers of the parport stack will have comments.  Though
> > the info in MAINTAINERS seems dated, if not obsolete.
> 
> Phil Blundell and Tim Waugh did not reply to me last time I sent a
> parport cleanup patch to them. I suspect they are indeed no longer
> maintaining parport in practice.
> 
> -- 
> Jean Delvare
> 
