Return-Path: <linux-kernel-owner+w=401wt.eu-S1752148AbZBNLXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148AbZBNLXs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 06:23:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751227AbZBNLXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 06:23:38 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48217 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbZBNLXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 06:23:37 -0500
Date: Sat, 14 Feb 2009 11:23:25 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Paul Walmsley <paul@pwsan.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, r-woodruff2@ti.com,
       Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH E 11/14] OMAP clock: track child clocks
Message-ID: <20090214112325.GA17965@n2100.arm.linux.org.uk>
References: <20090128192551.29333.82943.stgit@localhost.localdomain> <20090128192756.29333.41541.stgit@localhost.localdomain> <20090129151401.GC18233@n2100.arm.linux.org.uk> <20090129220608.GJ18233@n2100.arm.linux.org.uk> <20090209141156.GB16626@n2100.arm.linux.org.uk> <alpine.DEB.2.00.0902122345160.14667@utopia.booyaka.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0902122345160.14667@utopia.booyaka.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 13, 2009 at 12:01:37AM -0700, Paul Walmsley wrote:
> (cc'ing Richard Woodruff)
> 
> Hello Russell,
> 
> On Mon, 9 Feb 2009, Russell King - ARM Linux wrote:
> 
> > On Thu, Jan 29, 2009 at 10:06:08PM +0000, Russell King - ARM Linux wrote:
> > > @@ -780,7 +780,7 @@ int omap2_clk_set_parent(struct clk *clk, struct clk *new_parent)
> > >  	if (clk->usecount > 0)
> > >  		_omap2_clk_enable(clk);
> > >  
> > > -	clk->parent = new_parent;
> > > +	clk_reparent(clk, new_parent);
> > 
> > While looking at the DPLL patches, I've realised that omap2_clk_set_parent()
> > is buggy, as are any other places which reparent the clock (thankfully
> > the only other place is in the initialisation code where it doesn't
> > matter.)
> > 
> > Consider what happens when a clock is enabled - we walk up the tree
> > enabling all parents.  If we then change the clock's parent, and
> > then disable the child, we will again walk up the tree, but since
> > we've reparented it, it will be a different clock tree.  The result
> > is that the ancestors clock usage counts, and therefore their enable
> > status, will end up getting screwed up.
> 
> Agreed.
> 
> > This brings up a question: what we currently do here is:
> > 
> > - disable the child
> > - program clksel
> > - enable the child
> > - change child->parent
> > 
> > If we add in the parent handling, there are two possibilities:
> > 
> > - disable the child
> > - enable the new parent tree
> > - program clksel
> > - change child->parent
> > - disable the old parent tree
> > - enable the child
> > 
> > OR
> > 
> > - disable the child and the old parent tree
> > - program clksel
> > - change child->parent
> > - enable the new parent tree and the child
> > 
> > (note those 'and's have implied ordering).
> > 
> > Is there anything which dictates one approach over the other?
> > Obviously the latter approach results in something smaller and
> > cleaner, but might not be technically correct.
> 
> I don't know of any hardware reason to prefer one approach over the other, 
> but Richard might know better.

I'll need an answer on this before I can commit the updated bypass clock
support patch.

However, looking a little deeper, there's more issues in the reparenting
area.  I don't think this code has been tested at all...  In
_omap2_clksel_get_src_field, there is this:

	for (clkr = clks->rates; clkr->div; clkr++) {
		if (clkr->flags & (cpu_mask | DEFAULT_RATE))
			break; /* Found the default rate for this platform */
	}

which is bogus - it will find the first entry which is _either_ marked
as a default rate _or_ is supported by the SoC.  This means (for
instance) that:

static const struct clksel_rate core_l3_core_rates[] = {
        { .div = 1, .val = 1, .flags = RATE_IN_24XX },
        { .div = 2, .val = 2, .flags = RATE_IN_242X },
        { .div = 4, .val = 4, .flags = RATE_IN_24XX | DEFAULT_RATE },

will give us divisor 1 rather than presumably the one we want, that being
divisor 4.  I think the test above should be:

	for (clkr = clks->rates; clkr->div; clkr++) {
		if (clkr->flags & cpu_mask &&
		    clkr->flags & DEFAULT_RATE)
			break; /* Found the default rate for this platform */
	}

so we find an entry which is supported _and_ is the default for the SoC.

There's also a second issue - the comments before omap2_divisor_to_clksel()
indicate that this function returns 0xffffffff on error.  Unfortunately,
this is not so, it actually returns zero on error.  Moreover, we test
the result of the function against ~0, so we'll never deal with the error
case.  This really should be fixed so that we return the right value for
the error case.  (Further comments on this in a follow up.)

So, below is a patch which fixes both of these issues.

diff --git a/arch/arm/mach-omap2/clock.c b/arch/arm/mach-omap2/clock.c
index 5020cb1..f87501b 100644
--- a/arch/arm/mach-omap2/clock.c
+++ b/arch/arm/mach-omap2/clock.c
@@ -636,7 +636,7 @@ u32 omap2_clksel_to_divisor(struct clk *clk, u32 field_val)
  *
  * Given a struct clk of a rate-selectable clksel clock, and a clock divisor,
  * find the corresponding register field value.  The return register value is
- * the value before left-shifting.  Returns 0xffffffff on error
+ * the value before left-shifting.  Returns ~0 on error
  */
 u32 omap2_divisor_to_clksel(struct clk *clk, u32 div)
 {
@@ -648,7 +648,7 @@ u32 omap2_divisor_to_clksel(struct clk *clk, u32 div)
 
 	clks = omap2_get_clksel_by_parent(clk, clk->parent);
 	if (!clks)
-		return 0;
+		return ~0;
 
 	for (clkr = clks->rates; clkr->div; clkr++) {
 		if ((clkr->flags & cpu_mask) && (clkr->div == div))
@@ -659,7 +659,7 @@ u32 omap2_divisor_to_clksel(struct clk *clk, u32 div)
 		printk(KERN_ERR "clock: Could not find divisor %d for "
 		       "clock %s parent %s\n", div, clk->name,
 		       clk->parent->name);
-		return 0;
+		return ~0;
 	}
 
 	return clkr->val;
@@ -747,7 +747,7 @@ static u32 _omap2_clksel_get_src_field(struct clk *src_clk, struct clk *clk,
 		return 0;
 
 	for (clkr = clks->rates; clkr->div; clkr++) {
-		if (clkr->flags & (cpu_mask | DEFAULT_RATE))
+		if (clkr->flags & cpu_mask && clkr->flags & DEFAULT_RATE)
 			break; /* Found the default rate for this platform */
 	}
 
