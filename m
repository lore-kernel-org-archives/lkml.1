Return-Path: <linux-kernel-owner+w=401wt.eu-S1757670AbZCBXC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757670AbZCBXC2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 18:02:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755187AbZCBXCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 18:02:18 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:48384 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239AbZCBXCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 18:02:17 -0500
Date: Mon, 2 Mar 2009 16:02:14 -0700 (MST)
From: Paul Walmsley <paul@pwsan.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: "Woodruff, Richard" <r-woodruff2@ti.com>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH E 11/14] OMAP clock: track child clocks
In-Reply-To: <20090223160349.GB27688@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.00.0903021558360.30037@utopia.booyaka.com>
References: <20090128192551.29333.82943.stgit@localhost.localdomain> <20090128192756.29333.41541.stgit@localhost.localdomain> <20090129151401.GC18233@n2100.arm.linux.org.uk> <20090129220608.GJ18233@n2100.arm.linux.org.uk> <20090219121932.GL6407@n2100.arm.linux.org.uk>
 <13B9B4C6EF24D648824FF11BE896716203772C3680@dlee02.ent.ti.com> <20090223160349.GB27688@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Russell,

On Mon, 23 Feb 2009, Russell King - ARM Linux wrote:

> On Thu, Feb 19, 2009 at 06:50:52PM -0600, Woodruff, Richard wrote:
> > The historic usage of this has been against single use leaf clocks (1st instance of gptimer).  When it was used it did:
> >         clk_get()
> >         clk_set_parent()
> >         clk_enable()
> > 
> > This usage was ok for that. Use on a disabled clock is needed.
> > 
> > If there are multiple users on the clock or it is enabled there are problems.
> 
> It sounds to me like clk_set_parent() needs this then to prevent enabled
> clocks being reparented.  By doing so, we no longer need to disable/enable
> the clock within the OMAP2/3 set_parent function since we are now
> guaranteed that the clock will be disabled.
> 
> Ack?

One suggestion on the patch:

> diff --git a/arch/arm/plat-omap/clock.c b/arch/arm/plat-omap/clock.c
> index 08baa18..b2d9e1f 100644
> --- a/arch/arm/plat-omap/clock.c
> +++ b/arch/arm/plat-omap/clock.c
> @@ -144,12 +144,14 @@ int clk_set_parent(struct clk *clk, struct clk *parent)
>  		return ret;
>  
>  	spin_lock_irqsave(&clockfw_lock, flags);
> -	if (arch_clock->clk_set_parent)
> -		ret = arch_clock->clk_set_parent(clk, parent);
> -	if (ret == 0) {
> -		if (clk->recalc)
> -			clk->rate = clk->recalc(clk);
> -		propagate_rate(clk);
> +	if (clk->usecount == 0) {
> +		if (arch_clock->clk_set_parent)
> +			ret = arch_clock->clk_set_parent(clk, parent);
> +		if (ret == 0) {
> +			if (clk->recalc)
> +				clk->rate = clk->recalc(clk);
> +			propagate_rate(clk);
> +		}
>  	}
>  	spin_unlock_irqrestore(&clockfw_lock, flags);

Suggest returning a more specific error than -EINVAL:

if (clk->usecount > 0)
        return -EBUSY;




- Paul
