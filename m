Return-Path: <linux-kernel-owner+w=401wt.eu-S1759203AbZCXKch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759203AbZCXKch (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 06:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758662AbZCXKcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 06:32:22 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:50608 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756975AbZCXKcU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 06:32:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=sfDtMjxoNu3EK46hhlWoG7l11T1bFgpX3ZBe7/rUvmwPeZTdpCitDrKBUz8GQ+p0AX
         hmCKhVPnh8jSrmwhDTevFpKYlW+V1lxM5g+1ZttDXaDNiN5EkcDb298bm7yTjZ3yU0lH
         Ll+z2nZqnV0o88VTswRj/e/MWMEGjFCQSSLBc=
From: Florian Fainelli <florian@openwrt.org>
To: Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: [PATCH] net: Add support for the OpenCores 10/100 Mbps Ethernet MAC.
Date: Tue, 24 Mar 2009 11:32:11 +0100
User-Agent: KMail/1.9.9
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1237889923-32257-1-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1237889923-32257-1-git-send-email-thierry.reding@avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903241132.12836.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry,

Le Tuesday 24 March 2009 11:18:43 Thierry Reding, vous avez écrit :
> This patch adds a platform device driver that supports the OpenCores 10/100
> Mbps Ethernet MAC.
>
> The driver expects three resources: one IORESOURCE_MEM resource defines the
> memory region for the core's memory-mapped registers while a second
> IORESOURCE_MEM resource defines the network packet buffer space. The third
> resource, of type IORESOURCE_IRQ, associates an interrupt with the driver.

I am glad someone updated and submitted this driver, excellent work !. Few 
comments below.

> + * Copyright (C) 2007-2008 Avionic Design Development GmbH
> + * Copyright (C) 2008-2009 Avionic Design GmbH

I think there are some other authors like Simon Srot and Tensilica, unless you 
did wrote this completely from scratch and did not look at the uClincu 
open_eth driver at all ?

[snip]

> +/* function prototypes */
> +static int ethoc_set_mac_address(struct net_device *dev, void *addr);
> +static int ethoc_get_mac_address(struct net_device *dev, void *addr);
> +static int ethoc_rx(struct net_device *dev, int budget);
> +static void ethoc_tx(struct net_device *dev);
> +static irqreturn_t ethoc_interrupt(int irq, void *dev_id);

Why do you need these declarations ? Are not your functions properly ordered 
already ?

> +/**
> + * ethoc_probe() - initialize OpenCores ethernet MAC
> + * pdev:	platform device
> + */
> +static int ethoc_probe(struct platform_device *pdev)
> +{
> +	struct net_device *netdev = NULL;
> +	struct resource *res = NULL;
> +	struct resource *mmio = NULL;
> +	struct resource *mem = NULL;
> +	struct ethoc *priv = NULL;
> +	unsigned int phy;
> +	int ret = 0;
> +
> +	/* allocate networking device */
> +	netdev = alloc_etherdev(sizeof(struct ethoc));
> +	if (!netdev) {
> +		dev_err(&pdev->dev, "cannot allocate network device\n");
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
> +	SET_NETDEV_DEV(netdev, &pdev->dev);
> +	platform_set_drvdata(pdev, netdev);
> +
> +	/* obtain I/O memory space */
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res) {
> +		dev_err(&pdev->dev, "cannot obtain I/O memory space\n");
> +		ret = -ENXIO;
> +		goto free;
> +	}
> +
> +	mmio = devm_request_mem_region(&pdev->dev, res->start,
> +			res->end - res->start + 1, res->name);
> +	if (!res) {
> +		dev_err(&pdev->dev, "cannot request I/O memory space\n");
> +		ret = -ENXIO;
> +		goto free;
> +	}
> +
> +	netdev->base_addr = mmio->start;
> +
> +	/* obtain buffer memory space */
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> +	if (!res) {
> +		dev_err(&pdev->dev, "cannot obtain memory space\n");
> +		ret = -ENXIO;
> +		goto free;
> +	}

That's what uClinux driver calls SRAM right ?

[snip]

> +	/* setup the net_device structure */
> +	netdev->open = ethoc_open;
> +	netdev->stop = ethoc_stop;
> +	netdev->do_ioctl = ethoc_ioctl;
> +	netdev->set_config = ethoc_config;
> +	netdev->set_mac_address = ethoc_set_mac_address;
> +	netdev->set_multicast_list = ethoc_set_multicast_list;
> +	netdev->change_mtu = ethoc_change_mtu;
> +	netdev->tx_timeout = ethoc_tx_timeout;
> +	netdev->get_stats = ethoc_stats;
> +	netdev->hard_start_xmit = ethoc_start_xmit;
> +	netdev->watchdog_timeo = ETHOC_TIMEOUT;
> +	netdev->features |= NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_HIGHDMA;

Please use netdev_ops.

[snip]

> +#ifndef LINUX_NET_ETHOC_H
> +#define LINUX_NET_ETHOC_H 1
> +
> +struct ethoc_platform_data {
> +	u8 hwaddr[IFHWADDRLEN];
> +	s8 phy_id;

What about allowing platform configuration of the RX/TX buffers size and 
number of them ?

Otherwise

Acked-by: Florian Fainelli <florian@openwrt.org>
-- 
Best regards, Florian Fainelli
Email : florian@openwrt.org
http://openwrt.org
-------------------------------
