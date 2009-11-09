Return-Path: <linux-kernel-owner+w=401wt.eu-S1754853AbZKIVO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853AbZKIVO0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 16:14:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754747AbZKIVOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 16:14:25 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:49959 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754675AbZKIVOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 16:14:24 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18Bvxh+7ZDgNiK62FG8sb3u
Date: Mon, 9 Nov 2009 13:14:24 -0800
From: Tony Lindgren <tony@atomide.com>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: linux-omap@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] OMAP: DMA: Fix omapfb/lcdc on OMAP1510 broken when
 PM set
Message-ID: <20091109211424.GF23952@atomide.com>
References: <200911051951.32020.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911051951.32020.jkrzyszt@tis.icnet.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> [091105 10:52]:
> With CONFIG_PM=y, the omapfb/lcdc device on Amstrad Delta, after initially
> starting correctly, breaks with the following error messages:
> 
> omapfb omapfb: resetting (status 0xffffff96,reset count 1)
> ...
> omapfb omapfb: resetting (status 0xffffff96,reset count 100)
> omapfb omapfb: too many reset attempts, giving up.
> 
> Looking closer at this I have found that it had been broken almost 2 years ago
> with commit 2418996e3b100114edb2ae110d5d4acb928909d2, PM fixes for OMAP1.
> 
> The definite reason for broken omapfb/lcdc behavoiur in PM mode
> appeared to be ARM_IDLECT1:IDLIF_ARM (bit 6) put into idle regardless of LCD
> DMA possibly running. The bit were set based on return value of the
> omap_dma_running() function that did not check for dedicated LCD DMA
> channel status. The patch below fixes this.
> 
> Created against linux-2.6.32-rc6
> 
> Tested on Amstrad Delta
> 
> Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
> 
> ---
> Tuesday 03 November 2009 21:10:48 Tony Lindgren wrote:
> > * Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> [091103 12:05]:
> > > Sorry, I've not checked for new mail before posting this one and missed
> > > your acceptance for my idea of fixing all omap1510, not only ams_delta.
> > > If there are no more comments, I'll submit v3 with cpu_is_omap1510()
> > > replacing machine_is_ams_delta().
> >
> > Sounds good to me.
> >
> > Tony
> 
> --- linux-2.6.32-rc6/arch/arm/plat-omap/dma.c.orig	2009-11-03 20:37:49.000000000 +0100
> +++ linux-2.6.32-rc6/arch/arm/plat-omap/dma.c	2009-11-05 19:30:39.000000000 +0100
> @@ -1108,6 +1108,14 @@ int omap_dma_running(void)
>  {
>  	int lch;
>  
> +	/*
> +	 * On OMAP1510, internal LCD controller will start the transfer
> +	 * when it gets enabled, so assume DMA running if LCD enabled.
> +	 */
> +	if (cpu_is_omap1510())
> +		if (omap_readw(0xfffec000 + 0x00) & (1 << 0))
> +			return 1;
> +
>  	/* Check if LCD DMA is running */
>  	if (cpu_is_omap16xx())
>  		if (omap_readw(OMAP1610_DMA_LCD_CCR) & OMAP_DMA_CCR_EN)

Can you please use some define rather than the 0xfffec000 register
above?

Regards,

Tony
