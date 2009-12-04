Return-Path: <linux-kernel-owner+w=401wt.eu-S1755775AbZLDLNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775AbZLDLNm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 06:13:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755897AbZLDLNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 06:13:42 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59775 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755901AbZLDLNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 06:13:41 -0500
Date: Fri, 4 Dec 2009 12:13:46 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Amit Kucheria <amit.kucheria@canonical.com>
Cc: List Linux Kernel <linux-kernel@vger.kernel.org>,
       Rob Herring <r.herring@freescale.com>,
       "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, valentin.longchamp@epfl.ch,
       daniel@caiaq.de, grant.likely@secretlab.ca, Dinh.Nguyen@freescale.com
Subject: Re: [RFC][PATCH 06/10] fec: fix uninitialized rx buffer usage
Message-ID: <20091204111346.GL15126@pengutronix.de>
References: <cover.1259893118.git.amit.kucheria@canonical.com> <7a49f4c0ea2f5030068729978c2cb173a6e15857.1259893118.git.amit.kucheria@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7a49f4c0ea2f5030068729978c2cb173a6e15857.1259893118.git.amit.kucheria@canonical.com>
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Linux Solutions for Science and Industry
	Handelsregister:  Amtsgericht Hildesheim, HRA 2686 Peiner Strasse
	6-8, 31137 Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax:
	+49-5121-206917-5555 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 12:09:45 up 52 days, 23:58, 61 users,  load average: 1.18, 2.41,
	2.62
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 04, 2009 at 04:47:06AM +0200, Amit Kucheria wrote:
> From: Rob Herring <r.herring@freescale.com>
> 
> The fec driver was enabling receive buffer descriptor without allocating
> the buffers. Make sure the buffer descriptors are initialized to not
> start receiving packets.
> 
> Signed-off-by: Rob Herring <r.herring@freescale.com>
> Signed-off-by: Amit Kucheria <amit.kucheria@canonical.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: netdev@vger.kernel.org
> ---
>  drivers/net/fec.c |   57 +++++++++++++++++++++++++++--------------------------
>  1 files changed, 29 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/net/fec.c b/drivers/net/fec.c
> index 16a1d58..9a8743d 100644
> --- a/drivers/net/fec.c
> +++ b/drivers/net/fec.c
> @@ -1658,6 +1658,7 @@ static int fec_enet_init(struct net_device *dev, int index)
>  {
>  	struct fec_enet_private *fep = netdev_priv(dev);
>  	struct bufdesc *cbd_base;
> +	struct bufdesc *bdp;
>  	int i;
>  
>  	/* Allocate memory for buffer descriptors. */
> @@ -1710,6 +1711,34 @@ static int fec_enet_init(struct net_device *dev, int index)
>  	/* Set MII speed to 2.5 MHz */
>  	fep->phy_speed = ((((clk_get_rate(fep->clk) / 2 + 4999999)
>  					/ 2500000) / 2) & 0x3F) << 1;
> +
> +	/* Initialize the receive buffer descriptors. */
> +	bdp = fep->rx_bd_base;
> +	for (i = 0; i < RX_RING_SIZE; i++) {
> +
> +		/* Initialize the BD for every fragment in the page. */
> +		bdp->cbd_sc = 0;
> +		bdp++;
> +	}
> +
> +	/* Set the last buffer to wrap */
> +	bdp--;
> +	bdp->cbd_sc |= BD_SC_WRAP;
> +
> +	/* ...and the same for transmit */
> +	bdp = fep->tx_bd_base;
> +	for (i = 0; i < TX_RING_SIZE; i++) {
> +
> +		/* Initialize the BD for every fragment in the page. */
> +		bdp->cbd_sc = 0;
> +		bdp->cbd_bufaddr = 0;
> +		bdp++;
> +	}
> +
> +	/* Set the last buffer to wrap */
> +	bdp--;
> +	bdp->cbd_sc |= BD_SC_WRAP;
> +
>  	fec_restart(dev, 0);

I do not really understand why this patch is needed. You move the buffer
initialisation from fec_restart to fec_enet_init, but fec_restart is
called directly after the initialisation, so this shouldn't change much.

I don't need this patch on my boards, so I wonder what is really going
wrong here.

Sascha


>  
>  	/* Queue up command to detect the PHY and initialize the
> @@ -1730,7 +1759,6 @@ static void
>  fec_restart(struct net_device *dev, int duplex)
>  {
>  	struct fec_enet_private *fep = netdev_priv(dev);
> -	struct bufdesc *bdp;
>  	int i;
>  
>  	/* Whack a reset.  We should wait for this. */
> @@ -1768,33 +1796,6 @@ fec_restart(struct net_device *dev, int duplex)
>  		}
>  	}
>  
> -	/* Initialize the receive buffer descriptors. */
> -	bdp = fep->rx_bd_base;
> -	for (i = 0; i < RX_RING_SIZE; i++) {
> -
> -		/* Initialize the BD for every fragment in the page. */
> -		bdp->cbd_sc = BD_ENET_RX_EMPTY;
> -		bdp++;
> -	}
> -
> -	/* Set the last buffer to wrap */
> -	bdp--;
> -	bdp->cbd_sc |= BD_SC_WRAP;
> -
> -	/* ...and the same for transmit */
> -	bdp = fep->tx_bd_base;
> -	for (i = 0; i < TX_RING_SIZE; i++) {
> -
> -		/* Initialize the BD for every fragment in the page. */
> -		bdp->cbd_sc = 0;
> -		bdp->cbd_bufaddr = 0;
> -		bdp++;
> -	}
> -
> -	/* Set the last buffer to wrap */
> -	bdp--;
> -	bdp->cbd_sc |= BD_SC_WRAP;
> -
>  	/* Enable MII mode */
>  	if (duplex) {
>  		/* MII enable / FD enable */
> -- 
> 1.6.3.3
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
