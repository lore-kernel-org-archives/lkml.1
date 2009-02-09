Return-Path: <linux-kernel-owner+w=401wt.eu-S1755929AbZBIOMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929AbZBIOMU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 09:12:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753951AbZBIOMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 09:12:10 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49861 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464AbZBIOMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 09:12:08 -0500
Date: Mon, 9 Feb 2009 14:11:56 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Paul Walmsley <paul@pwsan.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH E 11/14] OMAP clock: track child clocks
Message-ID: <20090209141156.GB16626@n2100.arm.linux.org.uk>
References: <20090128192551.29333.82943.stgit@localhost.localdomain> <20090128192756.29333.41541.stgit@localhost.localdomain> <20090129151401.GC18233@n2100.arm.linux.org.uk> <20090129220608.GJ18233@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090129220608.GJ18233@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29, 2009 at 10:06:08PM +0000, Russell King - ARM Linux wrote:
> @@ -780,7 +780,7 @@ int omap2_clk_set_parent(struct clk *clk, struct clk *new_parent)
>  	if (clk->usecount > 0)
>  		_omap2_clk_enable(clk);
>  
> -	clk->parent = new_parent;
> +	clk_reparent(clk, new_parent);

While looking at the DPLL patches, I've realised that omap2_clk_set_parent()
is buggy, as are any other places which reparent the clock (thankfully
the only other place is in the initialisation code where it doesn't
matter.)

Consider what happens when a clock is enabled - we walk up the tree
enabling all parents.  If we then change the clock's parent, and
then disable the child, we will again walk up the tree, but since
we've reparented it, it will be a different clock tree.  The result
is that the ancestors clock usage counts, and therefore their enable
status, will end up getting screwed up.

So, this has revealed a logical bug here.  We need to walk the
parent tree before and after the switch to ensure that things stay
sane.

This brings up a question: what we currently do here is:

- disable the child
- program clksel
- enable the child
- change child->parent

If we add in the parent handling, there are two possibilities:

- disable the child
- enable the new parent tree
- program clksel
- change child->parent
- disable the old parent tree
- enable the child

OR

- disable the child and the old parent tree
- program clksel
- change child->parent
- enable the new parent tree and the child

(note those 'and's have implied ordering).

Is there anything which dictates one approach over the other?
Obviously the latter approach results in something smaller and
cleaner, but might not be technically correct.
