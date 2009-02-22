Return-Path: <linux-kernel-owner+w=401wt.eu-S1755617AbZBVXho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617AbZBVXho (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 18:37:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754086AbZBVXhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 18:37:34 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:43907 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601AbZBVXhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 18:37:33 -0500
Date: Sun, 22 Feb 2009 16:37:31 -0700 (MST)
From: Paul Walmsley <paul@pwsan.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, r-woodruff2@ti.com,
       Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH E 11/14] OMAP clock: track child clocks
In-Reply-To: <20090214112325.GA17965@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.00.0902221635530.16648@utopia.booyaka.com>
References: <20090128192551.29333.82943.stgit@localhost.localdomain> <20090128192756.29333.41541.stgit@localhost.localdomain> <20090129151401.GC18233@n2100.arm.linux.org.uk> <20090129220608.GJ18233@n2100.arm.linux.org.uk> <20090209141156.GB16626@n2100.arm.linux.org.uk>
 <alpine.DEB.2.00.0902122345160.14667@utopia.booyaka.com> <20090214112325.GA17965@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Russell,

On Sat, 14 Feb 2009, Russell King - ARM Linux wrote:

> However, looking a little deeper, there's more issues in the reparenting
> area.  I don't think this code has been tested at all...  In
> _omap2_clksel_get_src_field, there is this:
> 
> 	for (clkr = clks->rates; clkr->div; clkr++) {
> 		if (clkr->flags & (cpu_mask | DEFAULT_RATE))
> 			break; /* Found the default rate for this platform */
> 	}
> 
> which is bogus - it will find the first entry which is _either_ marked
> as a default rate _or_ is supported by the SoC.  This means (for
> instance) that:
> 
> static const struct clksel_rate core_l3_core_rates[] = {
>         { .div = 1, .val = 1, .flags = RATE_IN_24XX },
>         { .div = 2, .val = 2, .flags = RATE_IN_242X },
>         { .div = 4, .val = 4, .flags = RATE_IN_24XX | DEFAULT_RATE },
> 
> will give us divisor 1 rather than presumably the one we want, that being
> divisor 4.  I think the test above should be:
> 
> 	for (clkr = clks->rates; clkr->div; clkr++) {
> 		if (clkr->flags & cpu_mask &&
> 		    clkr->flags & DEFAULT_RATE)
> 			break; /* Found the default rate for this platform */
> 	}
> 
> so we find an entry which is supported _and_ is the default for the SoC.

Agreed.

> There's also a second issue - the comments before omap2_divisor_to_clksel()
> indicate that this function returns 0xffffffff on error.  Unfortunately,
> this is not so, it actually returns zero on error.  Moreover, we test
> the result of the function against ~0, so we'll never deal with the error
> case.  This really should be fixed so that we return the right value for
> the error case.  (Further comments on this in a follow up.)

Agreed here also.

> So, below is a patch which fixes both of these issues.

Looks good, thanks Russell.

Acked-by: Paul Walmsley <paul@pwsan.com>


- Paul
