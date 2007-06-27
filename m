Return-Path: <linux-kernel-owner+w=401wt.eu-S1759931AbXF0ATT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759931AbXF0ATT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 20:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753295AbXF0ATE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 20:19:04 -0400
Received: from imf22aec.mail.bellsouth.net ([205.152.59.70]:34958 "EHLO
	imf22aec.mail.bellsouth.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753260AbXF0ATB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 20:19:01 -0400
Date: Tue, 26 Jun 2007 19:16:01 -0500
From: Jay Cliburn <jacliburn@bellsouth.net>
To: Luca Tettamanti <kronos.it@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, "Jay L. T. Cornwall" <jay@esuna.co.uk>,
       linux-kernel@vger.kernel.org, Chris Snook <csnook@redhat.com>,
       netdev@vger.kernel.org
Subject: Re: [PATCH] atl1: disable 64bit DMA
Message-ID: <20070626191601.5c4c4808@osprey.hogchain.net>
In-Reply-To: <20070625211855.GA19275@dreamland.darkstar.lan>
References: <467B12CA.5060405@esuna.co.uk>
	<467BE118.4090308@redhat.com>
	<467BE4F1.7040308@esuna.co.uk>
	<467D0EB0.9030100@esuna.co.uk>
	<20070624125957.2e27820c@osprey.hogchain.net>
	<467ED4A8.4080500@esuna.co.uk>
	<20070624164519.04f215b8@osprey.hogchain.net>
	<467FB237.2030703@esuna.co.uk>
	<467FB844.6060702@bellsouth.net>
	<20070625211855.GA19275@dreamland.darkstar.lan>
X-Mailer: Claws Mail 2.9.2 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jun 2007 23:18:55 +0200
Luca Tettamanti <kronos.it@gmail.com> wrote:

> Il Mon, Jun 25, 2007 at 07:42:44AM -0500, Jay Cliburn ha scritto: 
> > Jay L. T. Cornwall wrote:
> > >Jay Cliburn wrote:
> > >
> > >>For reasons not yet clear to me, it appears the L1 driver has a
> > >>bug or the device itself has trouble with DMA in high memory.
> > >>This patch, drafted by Luca Tettamanti, is being explored as a
> > >>workaround.  I'd be interested to know if it fixes your problem.
> > >
> > >Yes, it certainly seems to. Now running with this patch and 4GB
> > >active, I've transferred about 15GB with no problem so far. It
> > >usually oopses after a GB or two.
> > >
> > >I guess it's not an ideal solution, architecturally speaking, but
> > >it's a good deal better than an unstable driver. If there's any
> > >other patches you'd like me to test or traces to capture, I'm
> > >happy to help out. Otherwise I'll run with this one for now since
> > >it does the job!
> > 
> > Okay Jay, thanks.
> > 
> > Luca, would you please submit your patch to Jeff Garzik and netdev?
> 
> Hi Jeff,
> a couple of users reported hard lockups when using L1 NICs on machines
> with 4GB or more of RAM. We're still waiting official confirmation
> from the vendor, but it seems that L1 has problems doing DMA to/from
> high memory (physical address above the 4GB limit). Passing 32bit DMA
> mask cures the problem.
> 
> Signed-Off-By: Luca Tettamanti <kronos.it@gmail.com>
> 
> ---
> I think that the patch should be included in 2.6.22.
> 
>  drivers/net/atl1/atl1_main.c |   15 +++------------
>  1 file changed, 3 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/net/atl1/atl1_main.c
> b/drivers/net/atl1/atl1_main.c index 6862c11..a730f15 100644
> --- a/drivers/net/atl1/atl1_main.c
> +++ b/drivers/net/atl1/atl1_main.c
> @@ -2097,21 +2097,16 @@ static int __devinit atl1_probe(struct
> pci_dev *pdev, struct net_device *netdev;
>  	struct atl1_adapter *adapter;
>  	static int cards_found = 0;
> -	bool pci_using_64 = true;
>  	int err;
>  
>  	err = pci_enable_device(pdev);
>  	if (err)
>  		return err;
>  
> -	err = pci_set_dma_mask(pdev, DMA_64BIT_MASK);
> +	err = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
>  	if (err) {
> -		err = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
> -		if (err) {
> -			dev_err(&pdev->dev, "no usable DMA
> configuration\n");
> -			goto err_dma;
> -		}
> -		pci_using_64 = false;
> +		dev_err(&pdev->dev, "no usable DMA configuration\n");
> +		goto err_dma;
>  	}
>  	/* Mark all PCI regions associated with PCI device
>  	 * pdev as being reserved by owner atl1_driver_name
> @@ -2176,7 +2171,6 @@ static int __devinit atl1_probe(struct pci_dev
> *pdev, 
>  	netdev->ethtool_ops = &atl1_ethtool_ops;
>  	adapter->bd_number = cards_found;
> -	adapter->pci_using_64 = pci_using_64;
>  
>  	/* setup the private structure */
>  	err = atl1_sw_init(adapter);
> @@ -2193,9 +2187,6 @@ static int __devinit atl1_probe(struct pci_dev
> *pdev, */
>  	/* netdev->features |= NETIF_F_TSO; */
>  
> -	if (pci_using_64)
> -		netdev->features |= NETIF_F_HIGHDMA;
> -
>  	netdev->features |= NETIF_F_LLTX;
>  
>  	/*

Acked-by: Jay Cliburn <jacliburn@bellsouth.net>
