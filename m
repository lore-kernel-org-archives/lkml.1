Return-Path: <linux-kernel-owner+w=401wt.eu-S1753877AbZBBHNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877AbZBBHNU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 02:13:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752131AbZBBHNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 02:13:05 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:53966 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791AbZBBHNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 02:13:04 -0500
Date: Mon, 2 Feb 2009 00:13:02 -0700 (MST)
From: Paul Walmsley <paul@pwsan.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH E 08/14] OMAP clock: move rate recalc, propagation code
 up to plat-omap/clock.c
In-Reply-To: <alpine.DEB.2.00.0901300135560.26985@utopia.booyaka.com>
Message-ID: <alpine.DEB.2.00.0902012355320.888@utopia.booyaka.com>
References: <20090128192551.29333.82943.stgit@localhost.localdomain> <20090128192748.29333.5856.stgit@localhost.localdomain> <20090129174153.GH18233@n2100.arm.linux.org.uk> <alpine.DEB.2.00.0901300135560.26985@utopia.booyaka.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Russell,

On Fri, 30 Jan 2009, Paul Walmsley wrote:

> On Thu, 29 Jan 2009, Russell King - ARM Linux wrote:
> 
> > I must say that this commit looks very much like a combination of
> > my commits from November:
> > 
> > [ARM] omap: move clock propagation into core omap clock code
> > [ARM] omap: remove unnecessary calls to propagate_rate()
> > [ARM] omap: move propagate_rate() calls into generic omap clock code
> > 
> > which do basically the same thing a little more efficiently, and an
> > additional patch from you to call ->recalc after set_rate or
> > reparenting a clock.
> > 
> > So I think I can drop everything from this apart from the additional
> > recalc calls, and the removal of those omap2_dpllcore_recalc() calls.
> > 
> > Please confirm my suspicions.
> 
> I haven't looked closely at your above three patches for this, but plan to 
> do so later today.
> 
> Regarding provenance, the patches that I sent you were developed 
> independently, for clock notifier support.  Ultimately, I have no personal 
> attachment as to whose patches for this go in, if all technical aspects 
> are equal.

Based on a comparison of E 08 with the three omap-clks1 commits you 
mentioned above, here are some differences that would merit further 
attention.  Some of these you've mentioned in subsequent E-mails.

If you use your patches, I would suggest making the following changes:

1. "remove unnecessary calls to propagate_rate()" should keep the 
propagate_rate(&ck_dpll1) call in omap1_select_table_rate(), since this 
function is only used by struct clk virtual_clk_mpu.  virtual_clk_mpu is 
farther away from the root of the clock tree than struct clk ck_dpll1.

2. In plat-omap2/clock.c, clk_set_rate() and clk_set_parent() should call 
propagate_rate() after recalc.

3. Several internal calls to *_recalc() functions can be dropped - 
specifically, in omap2_reprogram_dpllcore(), omap2_select_table_rate(), 
omap3_noncore_dpll_set_rate(), and omap3_core_dpll_m2_set_rate().


If you merge E 08, I'd suggest the following changes:

1. In clock24xx.c:omap2_clk_init(), your patches call propagate_rate() on 
osc_ck and sys_ck immediately after recalcs, which looks like a good 
idea to me.

2. The mach-omap1/clock.c:omap1_clk_init() change to consolidate the two 
propagate_rate(&ck_dpll1) calls also is good.


Please let me know if you'd like any followup patches here.

- Paul
