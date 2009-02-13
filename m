Return-Path: <linux-kernel-owner+w=401wt.eu-S1761599AbZBMHBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761599AbZBMHBu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 02:01:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751894AbZBMHBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 02:01:39 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:33233 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbZBMHBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 02:01:38 -0500
Date: Fri, 13 Feb 2009 00:01:37 -0700 (MST)
From: Paul Walmsley <paul@pwsan.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, r-woodruff2@ti.com,
       Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH E 11/14] OMAP clock: track child clocks
In-Reply-To: <20090209141156.GB16626@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.00.0902122345160.14667@utopia.booyaka.com>
References: <20090128192551.29333.82943.stgit@localhost.localdomain> <20090128192756.29333.41541.stgit@localhost.localdomain> <20090129151401.GC18233@n2100.arm.linux.org.uk> <20090129220608.GJ18233@n2100.arm.linux.org.uk>
 <20090209141156.GB16626@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing Richard Woodruff)

Hello Russell,

On Mon, 9 Feb 2009, Russell King - ARM Linux wrote:

> On Thu, Jan 29, 2009 at 10:06:08PM +0000, Russell King - ARM Linux wrote:
> > @@ -780,7 +780,7 @@ int omap2_clk_set_parent(struct clk *clk, struct clk *new_parent)
> >  	if (clk->usecount > 0)
> >  		_omap2_clk_enable(clk);
> >  
> > -	clk->parent = new_parent;
> > +	clk_reparent(clk, new_parent);
> 
> While looking at the DPLL patches, I've realised that omap2_clk_set_parent()
> is buggy, as are any other places which reparent the clock (thankfully
> the only other place is in the initialisation code where it doesn't
> matter.)
> 
> Consider what happens when a clock is enabled - we walk up the tree
> enabling all parents.  If we then change the clock's parent, and
> then disable the child, we will again walk up the tree, but since
> we've reparented it, it will be a different clock tree.  The result
> is that the ancestors clock usage counts, and therefore their enable
> status, will end up getting screwed up.

Agreed.

> This brings up a question: what we currently do here is:
> 
> - disable the child
> - program clksel
> - enable the child
> - change child->parent
> 
> If we add in the parent handling, there are two possibilities:
> 
> - disable the child
> - enable the new parent tree
> - program clksel
> - change child->parent
> - disable the old parent tree
> - enable the child
> 
> OR
> 
> - disable the child and the old parent tree
> - program clksel
> - change child->parent
> - enable the new parent tree and the child
> 
> (note those 'and's have implied ordering).
> 
> Is there anything which dictates one approach over the other?
> Obviously the latter approach results in something smaller and
> cleaner, but might not be technically correct.

I don't know of any hardware reason to prefer one approach over the other, 
but Richard might know better.


- Paul
