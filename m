Return-Path: <linux-kernel-owner+w=401wt.eu-S1758044AbZCZJJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758044AbZCZJJs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 05:09:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757340AbZCZJIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 05:08:51 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:62404 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757138AbZCZJIq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 05:08:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=fltCltMQY8UVc2kZOBjFjoCYplrgjtiPnYzuXEsGOQTOOha2l5Km78kuVwWvNMwOnn
         i7YJFoPUbe3B311lRaFGTV3VkyZwVxHizeZOfx/ed5GVCyfOiFsTOLboJwHuGpu0sy+W
         WbuF5R1OIjIXGpDUXfExiv9la4j2dLDSyC3O8=
From: Florian Fainelli <florian@openwrt.org>
To: Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: [PATCH] net: Add support for the OpenCores 10/100 Mbps Ethernet MAC.
Date: Wed, 25 Mar 2009 22:00:22 +0100
User-Agent: KMail/1.9.9
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1237889923-32257-1-git-send-email-thierry.reding@avionic-design.de> <200903241132.12836.florian@openwrt.org> <20090325144310.GA11710@avionic-design.de>
In-Reply-To: <20090325144310.GA11710@avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903252200.24365.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Thierry,

Le Wednesday 25 March 2009 15:43:10 Thierry Reding, vous avez écrit :
> I did look at the uClinux driver at some point, but decided to rewrite it-
> from scratch. But to be honest it's been quite some time since I started
> work on this and I'm not a 100% certain that one part or another may not be
> borrowed from it.

Sure my concern was more about the original authors somehow claiming copyright 
on this sooner or later. That's fine with me.

>
> Would it be enough to mention that it is loosely based on the uClinux
> driver?
>
> > > +/* function prototypes */
> > > +static int ethoc_set_mac_address(struct net_device *dev, void *addr);
> > > +static int ethoc_get_mac_address(struct net_device *dev, void *addr);
> > > +static int ethoc_rx(struct net_device *dev, int budget);
> > > +static void ethoc_tx(struct net_device *dev);
> > > +static irqreturn_t ethoc_interrupt(int irq, void *dev_id);
> >
> > Why do you need these declarations ? Are not your functions properly
> > ordered already ?
>
> I'll reply to the first patch with an updated version shortly.
>
> > > +/**
> > > + * ethoc_probe() - initialize OpenCores ethernet MAC
> > > + * pdev:	platform device
> > > + */
> > > +static int ethoc_probe(struct platform_device *pdev)
> > > +{
> > > +	struct net_device *netdev = NULL;
> > > +	struct resource *res = NULL;
> > > +	struct resource *mmio = NULL;
> > > +	struct resource *mem = NULL;
> > > +	struct ethoc *priv = NULL;
> > > +	unsigned int phy;
> > > +	int ret = 0;
> > > +
> > > +	/* allocate networking device */
> > > +	netdev = alloc_etherdev(sizeof(struct ethoc));
> > > +	if (!netdev) {
> > > +		dev_err(&pdev->dev, "cannot allocate network device\n");
> > > +		ret = -ENOMEM;
> > > +		goto out;
> > > +	}
> > > +
> > > +	SET_NETDEV_DEV(netdev, &pdev->dev);
> > > +	platform_set_drvdata(pdev, netdev);
> > > +
> > > +	/* obtain I/O memory space */
> > > +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > > +	if (!res) {
> > > +		dev_err(&pdev->dev, "cannot obtain I/O memory space\n");
> > > +		ret = -ENXIO;
> > > +		goto free;
> > > +	}
> > > +
> > > +	mmio = devm_request_mem_region(&pdev->dev, res->start,
> > > +			res->end - res->start + 1, res->name);
> > > +	if (!res) {
> > > +		dev_err(&pdev->dev, "cannot request I/O memory space\n");
> > > +		ret = -ENXIO;
> > > +		goto free;
> > > +	}
> > > +
> > > +	netdev->base_addr = mmio->start;
> > > +
> > > +	/* obtain buffer memory space */
> > > +	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> > > +	if (!res) {
> > > +		dev_err(&pdev->dev, "cannot obtain memory space\n");
> > > +		ret = -ENXIO;
> > > +		goto free;
> > > +	}
> >
> > That's what uClinux driver calls SRAM right ?
>
> Right.
>
> > > +	/* setup the net_device structure */
> > > +	netdev->open = ethoc_open;
> > > +	netdev->stop = ethoc_stop;
> > > +	netdev->do_ioctl = ethoc_ioctl;
> > > +	netdev->set_config = ethoc_config;
> > > +	netdev->set_mac_address = ethoc_set_mac_address;
> > > +	netdev->set_multicast_list = ethoc_set_multicast_list;
> > > +	netdev->change_mtu = ethoc_change_mtu;
> > > +	netdev->tx_timeout = ethoc_tx_timeout;
> > > +	netdev->get_stats = ethoc_stats;
> > > +	netdev->hard_start_xmit = ethoc_start_xmit;
> > > +	netdev->watchdog_timeo = ETHOC_TIMEOUT;
> > > +	netdev->features |= NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_HIGHDMA;
> >
> > Please use netdev_ops.
>
> Done.
>
> > > +#ifndef LINUX_NET_ETHOC_H
> > > +#define LINUX_NET_ETHOC_H 1
> > > +
> > > +struct ethoc_platform_data {
> > > +	u8 hwaddr[IFHWADDRLEN];
> > > +	s8 phy_id;
> >
> > What about allowing platform configuration of the RX/TX buffers size and
> > number of them ?
>
> I think this is a good idea, but I'm not quite sure about how this should
> be implemented. The total number of buffers is dependent on the total
> buffer size as defined by the second IORESOURCE_MEM resource. That really
> only leaves the option for allowing the individual buffer size to be
> defined by the platform configuration. Furthermore the network controller
> can only handle fixed-sized buffers (at least for reception), so perhaps
> defining some kind of RX/TX buffer number ratio would be useful. Or perhaps
> defining a minimum or maximum number of TX buffers and leaving the rest up
> for RX for instance.

I like the idea of defining ratios but for now let's just stick to what you 
proposed and we can later agree on getting more parameters being passed to 
the driver using platform_data I am not sure yet how I will tune these 
parameters on my design.
-- 
Best regards, Florian Fainelli
Email : florian@openwrt.org
http://openwrt.org
-------------------------------
