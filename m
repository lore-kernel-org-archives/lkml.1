Return-Path: <linux-kernel-owner+w=401wt.eu-S1760584AbZCYOn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760584AbZCYOn0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 10:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752168AbZCYOnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 10:43:15 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:56264 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156AbZCYOnN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 10:43:13 -0400
Date: Wed, 25 Mar 2009 15:43:10 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Florian Fainelli <florian@openwrt.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: Add support for the OpenCores 10/100 Mbps
	Ethernet MAC.
Message-ID: <20090325144310.GA11710@avionic-design.de>
References: <1237889923-32257-1-git-send-email-thierry.reding@avionic-design.de> <200903241132.12836.florian@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <200903241132.12836.florian@openwrt.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Provags-ID: V01U2FsdGVkX1+xy4+h7nYSSzLleehuekgwg/R4nN5907C2heH
 j66Sy8XZMpgnSjQ6qN2fbMrbHtPXRv/dfu9DJXuRNwMRR7NYuJ
 Ls5qZkiHPL20x1/3ejHRg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Florian Fainelli wrote:
> Hi Thierry,
> 
> Le Tuesday 24 March 2009 11:18:43 Thierry Reding, vous avez écrit :
> > This patch adds a platform device driver that supports the OpenCores 10/100
> > Mbps Ethernet MAC.
> >
> > The driver expects three resources: one IORESOURCE_MEM resource defines the
> > memory region for the core's memory-mapped registers while a second
> > IORESOURCE_MEM resource defines the network packet buffer space. The third
> > resource, of type IORESOURCE_IRQ, associates an interrupt with the driver.
> 
> I am glad someone updated and submitted this driver, excellent work !. Few 
> comments below.
> 
> > + * Copyright (C) 2007-2008 Avionic Design Development GmbH
> > + * Copyright (C) 2008-2009 Avionic Design GmbH
> 
> I think there are some other authors like Simon Srot and Tensilica, unless you 
> did wrote this completely from scratch and did not look at the uClincu 
> open_eth driver at all ?

I did look at the uClinux driver at some point, but decided to rewrite it-
from scratch. But to be honest it's been quite some time since I started work
on this and I'm not a 100% certain that one part or another may not be
borrowed from it.

Would it be enough to mention that it is loosely based on the uClinux driver?

> > +/* function prototypes */
> > +static int ethoc_set_mac_address(struct net_device *dev, void *addr);
> > +static int ethoc_get_mac_address(struct net_device *dev, void *addr);
> > +static int ethoc_rx(struct net_device *dev, int budget);
> > +static void ethoc_tx(struct net_device *dev);
> > +static irqreturn_t ethoc_interrupt(int irq, void *dev_id);
> 
> Why do you need these declarations ? Are not your functions properly ordered 
> already ?

I'll reply to the first patch with an updated version shortly.

> > +/**
> > + * ethoc_probe() - initialize OpenCores ethernet MAC
> > + * pdev:	platform device
> > + */
> > +static int ethoc_probe(struct platform_device *pdev)
> > +{
> > +	struct net_device *netdev = NULL;
> > +	struct resource *res = NULL;
> > +	struct resource *mmio = NULL;
> > +	struct resource *mem = NULL;
> > +	struct ethoc *priv = NULL;
> > +	unsigned int phy;
> > +	int ret = 0;
> > +
> > +	/* allocate networking device */
> > +	netdev = alloc_etherdev(sizeof(struct ethoc));
> > +	if (!netdev) {
> > +		dev_err(&pdev->dev, "cannot allocate network device\n");
> > +		ret = -ENOMEM;
> > +		goto out;
> > +	}
> > +
> > +	SET_NETDEV_DEV(netdev, &pdev->dev);
> > +	platform_set_drvdata(pdev, netdev);
> > +
> > +	/* obtain I/O memory space */
> > +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +	if (!res) {
> > +		dev_err(&pdev->dev, "cannot obtain I/O memory space\n");
> > +		ret = -ENXIO;
> > +		goto free;
> > +	}
> > +
> > +	mmio = devm_request_mem_region(&pdev->dev, res->start,
> > +			res->end - res->start + 1, res->name);
> > +	if (!res) {
> > +		dev_err(&pdev->dev, "cannot request I/O memory space\n");
> > +		ret = -ENXIO;
> > +		goto free;
> > +	}
> > +
> > +	netdev->base_addr = mmio->start;
> > +
> > +	/* obtain buffer memory space */
> > +	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> > +	if (!res) {
> > +		dev_err(&pdev->dev, "cannot obtain memory space\n");
> > +		ret = -ENXIO;
> > +		goto free;
> > +	}
> 
> That's what uClinux driver calls SRAM right ?

Right.

> > +	/* setup the net_device structure */
> > +	netdev->open = ethoc_open;
> > +	netdev->stop = ethoc_stop;
> > +	netdev->do_ioctl = ethoc_ioctl;
> > +	netdev->set_config = ethoc_config;
> > +	netdev->set_mac_address = ethoc_set_mac_address;
> > +	netdev->set_multicast_list = ethoc_set_multicast_list;
> > +	netdev->change_mtu = ethoc_change_mtu;
> > +	netdev->tx_timeout = ethoc_tx_timeout;
> > +	netdev->get_stats = ethoc_stats;
> > +	netdev->hard_start_xmit = ethoc_start_xmit;
> > +	netdev->watchdog_timeo = ETHOC_TIMEOUT;
> > +	netdev->features |= NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_HIGHDMA;
> 
> Please use netdev_ops.

Done.

> > +#ifndef LINUX_NET_ETHOC_H
> > +#define LINUX_NET_ETHOC_H 1
> > +
> > +struct ethoc_platform_data {
> > +	u8 hwaddr[IFHWADDRLEN];
> > +	s8 phy_id;
> 
> What about allowing platform configuration of the RX/TX buffers size and 
> number of them ?

I think this is a good idea, but I'm not quite sure about how this should be
implemented. The total number of buffers is dependent on the total buffer size
as defined by the second IORESOURCE_MEM resource. That really only leaves the
option for allowing the individual buffer size to be defined by the platform
configuration. Furthermore the network controller can only handle fixed-sized
buffers (at least for reception), so perhaps defining some kind of RX/TX
buffer number ratio would be useful. Or perhaps defining a minimum or maximum
number of TX buffers and leaving the rest up for RX for instance.

Any suggestions?

Cheers,
Thierry

