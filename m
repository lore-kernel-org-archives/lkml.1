Return-Path: <linux-kernel-owner+w=401wt.eu-S1753101AbZBBH5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101AbZBBH5y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 02:57:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751424AbZBBH5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 02:57:42 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:55455 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbZBBH5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 02:57:41 -0500
Date: Mon, 2 Feb 2009 00:57:39 -0700 (MST)
From: Paul Walmsley <paul@pwsan.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH E 11/14] OMAP clock: track child clocks
In-Reply-To: <20090129195211.GI18233@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.00.0902020033260.888@utopia.booyaka.com>
References: <20090128192551.29333.82943.stgit@localhost.localdomain> <20090128192756.29333.41541.stgit@localhost.localdomain> <20090129195211.GI18233@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Russell,

On Thu, 29 Jan 2009, Russell King - ARM Linux wrote:

> On Wed, Jan 28, 2009 at 12:27:59PM -0700, Paul Walmsley wrote:
> > +static int omap_clk_for_each_child(struct clk *clk, unsigned long parent_rate,
> > +		   u8 rate_storage, int (*cb)(struct clk *, unsigned long, u8))
> > +{
> > +	struct clk_child *child;
> > +	int ret;
> > +
> > +	list_for_each_entry(child, &clk->children, node) {
> > +		ret = (*cb)(child->clk, parent_rate, rate_storage);
> > +		if (ret)
> > +			break;
> > +	}
> > +
> > +	return ret;
> > +}
> 
> > +static int _do_propagate_rate(struct clk *clk, unsigned long parent_rate,
> > +			      u8 rate_storage)
> > +{
> > +	if (clk->recalc)
> > +		clk->recalc(clk, parent_rate, rate_storage);
> > +	if (omap_clk_has_children(clk))
> > +		propagate_rate(clk, rate_storage);
> > +	return 0;
> > +}
> 
> >  /* Propagate rate to children */
> >  void propagate_rate(struct clk *tclk, u8 rate_storage)
> >  {
> >  	unsigned long parent_rate = 0;
> >  
> >  	if (tclk == NULL || IS_ERR(tclk))
> >  		return;
> >  
> > +	if (rate_storage == CURRENT_RATE)
> > +		parent_rate = tclk->rate;
> > +	else if (rate_storage == TEMP_RATE)
> > +		parent_rate = tclk->temp_rate;
> >  
> > +	omap_clk_for_each_child(tclk, parent_rate, rate_storage,
> > +				_do_propagate_rate);
> >  }
> 
> This worries me.  Calling this puts onto the stack:
> 
> - a frame for propagate_rate()
> - a frame for omap_clk_for_each_child
> - a frame for _do_propagate_rate
> 
> for every level of children.  How close we get to overflowing the kernels
> depends on how much each of those functions puts on the kernel stack.
> However, since this is recursive, minimising the number of stack frames
> is a good idea.
> 
> That's why I have in my patch:
> 
>  [ARM] omap: move propagate_rate() calls into generic omap clock code
> 
> I've arranged for there to be the minimum of function nesting here.
> I suggest keeping this.

Those two new function calls are probaby not necessary for rate 
propagation, so, keeping the original single-function recursion should be 
fine.  The original motivation behind using them was to share the clock 
tree traversal code with the clock notifier patches, e.g.,
 
http://www.mail-archive.com/linux-omap@vger.kernel.org/msg08068.html

Would you like a patch to remove _do_propagate_rate() and 
omap_clk_for_each_child()?


- Paul
