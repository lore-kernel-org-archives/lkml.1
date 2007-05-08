Return-Path: <linux-kernel-owner+w=401wt.eu-S967342AbXEHLhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967342AbXEHLhm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 07:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967335AbXEHLhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 07:37:41 -0400
Received: from alephnull.demon.nl ([83.160.184.112]:49932 "EHLO
	xi.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967333AbXEHLhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 07:37:40 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=1148133259;
	d=wantstofly.org;
	h=date:from:to:cc:subject:message-id:mime-version:content-type:
	content-disposition:in-reply-to:user-agent;
	b=mVyaR9p5Pxkg6a+2n4AA9p+L2slFY4UgHwq27wgiTyNidR8wfMYOBI7KFIdsb
	4VKj5UU21V+JT9gD6ko84+FeQ==
Date: Tue, 8 May 2007 13:37:35 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Michael-Luke Jones <mlj28@cam.ac.uk>, Jeff Garzik <jeff@garzik.org>,
       netdev@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
       Russell King <rmk@arm.linux.org.uk>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: [PATCH] Intel IXP4xx network drivers v.2 - Ethernet and HSS
Message-ID: <20070508113735.GB32055@xi.wantstofly.org>
References: <m3abwhcy74.fsf@maximus.localdomain> <m3vef5biob.fsf@maximus.localdomain> <5BB7E1AB-5CE1-43C8-8CE3-E0DE0236BD09@cam.ac.uk> <m3hcqoa772.fsf@maximus.localdomain> <86D26EBE-5899-468F-9C79-23E83E0DE04B@cam.ac.uk> <m33b289zku.fsf@maximus.localdomain> <m3zm4g3yed.fsf_-_@maximus.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3zm4g3yed.fsf_-_@maximus.localdomain>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 03:19:22AM +0200, Krzysztof Halasa wrote:

> diff --git a/arch/arm/mach-ixp4xx/ixdp425-setup.c b/arch/arm/mach-ixp4xx/ixdp425-setup.c
> index ec4f079..f20d39d 100644
> --- a/arch/arm/mach-ixp4xx/ixdp425-setup.c
> +++ b/arch/arm/mach-ixp4xx/ixdp425-setup.c
> @@ -101,10 +101,35 @@ static struct platform_device ixdp425_uart = {
>  	.resource		= ixdp425_uart_resources
>  };
>  
> +/* Built-in 10/100 Ethernet MAC interfaces */
> +static struct mac_plat_info ixdp425_plat_mac[] = {
> +	{
> +		.phy		= 0,
> +		.rxq		= 3,
> +	}, {
> +		.phy		= 1,
> +		.rxq		= 4,
> +	}
> +};

As with Christian's driver (I'm feeling like a bit of a broken record
here :-), putting knowledge of which queue to use (which is firmware-
specific) in the _board_ support file is almost certainly wrong.

I would just put the port number in there, and let the ethernet
driver map the port number to the hardware queue number.  After all,
the ethernet driver knows which queues the firmware uses, while the
board support code doesn't.


> +#ifndef __ARMEB__
> +#warning Little endian mode not supported
> +#endif

Yay. :-)  /me hides


> +static inline void set_regbits(u32 bits, u32 __iomem *reg)
> +{
> +	__raw_writel(__raw_readl(reg) | bits, reg);
> +}
> +static inline void clr_regbits(u32 bits, u32 __iomem *reg)
> +{
> +	__raw_writel(__raw_readl(reg) & ~bits, reg);
> +}

I generally discourage the use of such wrappers, as it often makes
people forget that the set and clear operations are not atomic, and
it ignores the fact that some of the other bits in the register you
are modifying might have side-effects.

Didn't review the rest -- not sure whether I'm looking at the latest
version.
