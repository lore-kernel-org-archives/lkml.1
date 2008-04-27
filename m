Return-Path: <linux-kernel-owner+w=401wt.eu-S1755992AbYD0I7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992AbYD0I7i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 04:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752394AbYD0I72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 04:59:28 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:9853 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131AbYD0I71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 04:59:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=wmyyO3HH7DiI7oLE4QY4im5dcSXdHPTeBtRcTDiSG7WB1j0Vljj0p+Sq9sshnZoLkMa/OrhcRFfteiNq3uUVkBZr5YW2okDxOeQP7ARwErLxOFMuOnApekgVFOaD7HlJmdssbouni4aKVr7WKjJ1CGv5DkKTJEF7w2nSxOYd1Lo=
Message-ID: <4814406B.8000907@gmail.com>
Date: Sun, 27 Apr 2008 10:59:23 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Ondrej Zajicek <santiago@crfreenet.org>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, rl@hellgate.ch
Subject: Re: [PATCH] via-rhine: suspend/resume bugfix
References: <20080427071351.GA20561@localhost.localdomain>
In-Reply-To: <20080427071351.GA20561@localhost.localdomain>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2008 09:13 AM, Ondrej Zajicek wrote:
> There is a bug in via-rhine driver - the driver don't disable
> interrupts during suspend, which sometimes leads to globally
> disabled interrupt line.
> 
> This patch disables interrupts (and Rx/Tx) during suspend.
> 
> Signed-off-by: Ondrej Zajicek <santiago@crfreenet.org>
> 
> ---
> 
> diff -uprN -X linux-2.6.25/Documentation/dontdiff linux-2.6.25/drivers/net/via-rhine.c linux-2.6.25-feanor/drivers/net/via-rhine.c
> --- linux-2.6.25/drivers/net/via-rhine.c	2008-04-17 04:49:44.000000000 +0200
> +++ linux-2.6.25-feanor/drivers/net/via-rhine.c	2008-04-26 14:08:44.000000000 +0200
> @@ -1886,6 +1886,15 @@ static void rhine_shutdown (struct pci_d
>  	struct rhine_private *rp = netdev_priv(dev);
>  	void __iomem *ioaddr = rp->base;
>  
> +	/* Switch to loopback mode to avoid hardware races. */
> +	iowrite8(rp->tx_thresh | 0x02, ioaddr + TxConfig);
> +
> +	/* Disable interrupts by clearing the interrupt mask. */
> +	iowrite16(0x0000, ioaddr + IntrEnable);
> +
> +	/* Stop the chip's Tx and Rx processes. */
> +	iowrite16(CmdStop, ioaddr + ChipCmd);
> +
>  	if (!(rp->quirks & rqWOL))
>  		return; /* Nothing to do for non-WOL adapters */

What about PCI posting?
