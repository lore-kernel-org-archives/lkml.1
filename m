Return-Path: <linux-kernel-owner+w=401wt.eu-S1756555AbXJ3Pcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555AbXJ3Pcx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 11:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754082AbXJ3Pcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 11:32:46 -0400
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:54809 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513AbXJ3Pcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 11:32:45 -0400
Message-ID: <47274E93.9030403@tiscali.nl>
Date: Tue, 30 Oct 2007 16:32:35 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Jesper Nilsson <jesper.nilsson@axis.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>, linux-kernel@vger.kernel.org,
       jgarzik@pobox.com
Subject: Re: [PATCH 9/16] CRIS architecture: Correct compile errors
References: <20071030093231.GL11960@axis.com>
In-Reply-To: <20071030093231.GL11960@axis.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Nilsson wrote:

>  static int
>  e100_probe_transceiver(struct net_device* dev)
>  {
> +#if !defined(CONFIG_ETRAX_NO_PHY)
>  	unsigned int phyid_high;
>  	unsigned int phyid_low;
>  	unsigned int oui;
>  	struct transceiver_ops* ops = NULL;
> +	struct net_local *np = netdev_priv(dev);
> +
> +	spin_lock(&np->transceiver_lock);
>  
>  	/* Probe MDIO physical address */
> -	for (mdio_phy_addr = 0; mdio_phy_addr <= 31; mdio_phy_addr++) {
> -		if (e100_get_mdio_reg(dev, mdio_phy_addr, MII_BMSR) != 0xffff)
> +	for (np->mii_if.phy_id = 0; np->mii_if.phy_id <= 31; 
> +	     np->mii_if.phy_id++) {
> +		if (e100_get_mdio_reg(dev, 
> +				      np->mii_if.phy_id, MII_BMSR) != 0xffff)
>  			break;
>  	}
> -	if (mdio_phy_addr == 32)
> +	if (np->mii_if.phy_id == 32)
>  		 return -ENODEV;
You need to unlock before this return.
>  
>  	/* Get manufacturer */
> -	phyid_high = e100_get_mdio_reg(dev, mdio_phy_addr, MII_PHYSID1);
> -	phyid_low = e100_get_mdio_reg(dev, mdio_phy_addr, MII_PHYSID2);
> +	phyid_high = e100_get_mdio_reg(dev, np->mii_if.phy_id, MII_PHYSID1);
> +	phyid_low = e100_get_mdio_reg(dev, np->mii_if.phy_id, MII_PHYSID2);
>  	oui = (phyid_high << 6) | (phyid_low >> 10);
>  
>  	for (ops = &transceivers[0]; ops->oui; ops++) {
> @@ -998,6 +912,8 @@
>  	}
>  	transceiver = ops;
>  
> +	spin_unlock(&np->transceiver_lock);
> +#endif
>  	return 0;
>  }
