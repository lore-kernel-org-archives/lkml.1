Return-Path: <linux-kernel-owner+w=401wt.eu-S1757364AbZA2Twf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364AbZA2Twf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 14:52:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752479AbZA2TwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 14:52:25 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50911 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750AbZA2TwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 14:52:25 -0500
Date: Thu, 29 Jan 2009 19:52:11 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Paul Walmsley <paul@pwsan.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH E 11/14] OMAP clock: track child clocks
Message-ID: <20090129195211.GI18233@n2100.arm.linux.org.uk>
References: <20090128192551.29333.82943.stgit@localhost.localdomain> <20090128192756.29333.41541.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090128192756.29333.41541.stgit@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2009 at 12:27:59PM -0700, Paul Walmsley wrote:
> +static int omap_clk_for_each_child(struct clk *clk, unsigned long parent_rate,
> +		   u8 rate_storage, int (*cb)(struct clk *, unsigned long, u8))
> +{
> +	struct clk_child *child;
> +	int ret;
> +
> +	list_for_each_entry(child, &clk->children, node) {
> +		ret = (*cb)(child->clk, parent_rate, rate_storage);
> +		if (ret)
> +			break;
> +	}
> +
> +	return ret;
> +}

> +static int _do_propagate_rate(struct clk *clk, unsigned long parent_rate,
> +			      u8 rate_storage)
> +{
> +	if (clk->recalc)
> +		clk->recalc(clk, parent_rate, rate_storage);
> +	if (omap_clk_has_children(clk))
> +		propagate_rate(clk, rate_storage);
> +	return 0;
> +}

>  /* Propagate rate to children */
>  void propagate_rate(struct clk *tclk, u8 rate_storage)
>  {
>  	unsigned long parent_rate = 0;
>  
>  	if (tclk == NULL || IS_ERR(tclk))
>  		return;
>  
> +	if (rate_storage == CURRENT_RATE)
> +		parent_rate = tclk->rate;
> +	else if (rate_storage == TEMP_RATE)
> +		parent_rate = tclk->temp_rate;
>  
> +	omap_clk_for_each_child(tclk, parent_rate, rate_storage,
> +				_do_propagate_rate);
>  }

This worries me.  Calling this puts onto the stack:

- a frame for propagate_rate()
- a frame for omap_clk_for_each_child
- a frame for _do_propagate_rate

for every level of children.  How close we get to overflowing the kernels
depends on how much each of those functions puts on the kernel stack.
However, since this is recursive, minimising the number of stack frames
is a good idea.

That's why I have in my patch:

 [ARM] omap: move propagate_rate() calls into generic omap clock code

I've arranged for there to be the minimum of function nesting here.
I suggest keeping this.
