Return-Path: <linux-kernel-owner+w=401wt.eu-S933741AbZHHJHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933741AbZHHJHe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 05:07:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933653AbZHHJHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 05:07:33 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:57906 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933603AbZHHJHc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 05:07:32 -0400
x-mimeole: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [RESEND PATCH] gianfar: keep vlan related state when restart
Date: Sat, 8 Aug 2009 02:07:12 -0700
Message-ID: <18AEF66AFDF06F4CAAA1D419D000FD33031B485B@az33exm24.fsl.freescale.net>
In-Reply-To: <1249699012-26379-1-git-send-email-yong.zhang0@gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [RESEND PATCH] gianfar: keep vlan related state when restart
Thread-Index: AcoX0UcgbTdRmCAFSUu0vrg+N97BsQANTA5w
References: <1249699012-26379-1-git-send-email-yong.zhang0@gmail.com>
From: "Haruki Dai-R35557" <Dai.Haruki@freescale.com>
To: "Yong Zhang" <yong.zhang0@gmail.com>, <davem@davemloft.net>,
       "Fleming Andy-AFLEMING" <afleming@freescale.com>
Cc: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
X-Brightmail-Tracker: AAAAAQAAAWE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Yong Zhang [mailto:yong.zhang0@gmail.com]
> Sent: Friday, August 07, 2009 9:37 PM
> To: davem@davemloft.net; Fleming Andy-AFLEMING; Haruki Dai-R35557
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [RESEND PATCH] gianfar: keep vlan related state when restart
> 
> If vlan has been enabled. ifdown followed by ifup will lost hardware
> related state.
> 
> Also remove duplicated operation in gfar_vlan_rx_register().
> 
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>


Thanks for the catch. This patch looks fine to me.

Acked-by: Dai Haruki <dai.haruki@freescale.com>




> ---
>  drivers/net/gianfar.c |   12 ++++++++++--
>  1 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/gianfar.c b/drivers/net/gianfar.c
> index f8ffcbf..e212f2c 100644
> --- a/drivers/net/gianfar.c
> +++ b/drivers/net/gianfar.c
> @@ -936,6 +936,7 @@ int startup_gfar(struct net_device *dev)
>  	struct gfar __iomem *regs = priv->regs;
>  	int err = 0;
>  	u32 rctrl = 0;
> +	u32 tctrl = 0;
>  	u32 attrs = 0;
> 
>  	gfar_write(&regs->imask, IMASK_INIT_CLEAR);
> @@ -1111,11 +1112,19 @@ int startup_gfar(struct net_device *dev)
>  		rctrl |= RCTRL_PADDING(priv->padding);
>  	}
> 
> +	/* keep vlan related bits if it's enabled */
> +	if (priv->vlgrp) {
> +		rctrl |= RCTRL_VLEX | RCTRL_PRSDEP_INIT;
> +		tctrl |= TCTRL_VLINS;
> +	}
> +
>  	/* Init rctrl based on our settings */
>  	gfar_write(&priv->regs->rctrl, rctrl);
> 
>  	if (dev->features & NETIF_F_IP_CSUM)
> -		gfar_write(&priv->regs->tctrl, TCTRL_INIT_CSUM);
> +		tctrl |= TCTRL_INIT_CSUM;
> +
> +	gfar_write(&priv->regs->tctrl, tctrl);
> 
>  	/* Set the extraction length and index */
>  	attrs = ATTRELI_EL(priv->rx_stash_size) |
> @@ -1450,7 +1459,6 @@ static void gfar_vlan_rx_register(struct
net_device *dev,
> 
>  		/* Enable VLAN tag extraction */
>  		tempval = gfar_read(&priv->regs->rctrl);
> -		tempval |= RCTRL_VLEX;
>  		tempval |= (RCTRL_VLEX | RCTRL_PRSDEP_INIT);
>  		gfar_write(&priv->regs->rctrl, tempval);
>  	} else {
> --
> 1.6.0.4

