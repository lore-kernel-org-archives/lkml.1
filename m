Return-Path: <linux-kernel-owner+w=401wt.eu-S1754884AbZBKHxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884AbZBKHxa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 02:53:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752728AbZBKHxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 02:53:20 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:50780 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbZBKHxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 02:53:19 -0500
Date: Wed, 11 Feb 2009 00:53:18 -0700 (MST)
From: Paul Walmsley <paul@pwsan.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH E 10/14] OMAP clock: support "dry run" rate and parent
 changes
In-Reply-To: <20090208131734.GA21434@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.00.0902102346260.12013@utopia.booyaka.com>
References: <20090128192551.29333.82943.stgit@localhost.localdomain> <20090128192753.29333.56931.stgit@localhost.localdomain> <20090208131734.GA21434@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Russell,

On Sun, 8 Feb 2009, Russell King - ARM Linux wrote:

> On Wed, Jan 28, 2009 at 12:27:56PM -0700, Paul Walmsley wrote:
> > For upcoming notifier support, modify the rate recalculation code to
> > take parent rate and rate storage parameters.  The goal here is to
> > allow the clock code to determine what the clock's rate would be after
> > a parent change or a rate change, without actually changing the
> > hardware registers.  This is used by the upcoming notifier patches to
> > pass a clock's current and planned rates to the notifier callbacks.
> 
> NAK.  I'm not sure whether you've realised, but this is exactly what the
> 'round_rate' method is supposed to be doing.  It provides a method by
> which you can find out what the clock rate would be if you asked for
> 'set_rate' to set the hardware to the requested rate.

There's been some miscommunication about the purpose of this patch - most 
likely my fault for not grouping this patch with the clock notifier patch 
set, which has not yet been submitted for upstream merging.  Most of this 
patch is not needed until notifiers are implemented, so I'd propose that 
we defer consideration of most of this patch until the clock notifiers are 
submitted.  What would be useful, though, is to split out the 
RECALC_ON_ENABLE portion of this patch and merge that.  That is a bug fix, 
and I should have sent that as a separate patch.

For the sake of the current discussion though, here's what this patch was 
intended to accomplish.  We have some patches under development that 
implement clock rate change notifiers, allowing drivers to register for 
pre- and post-notification on clock rate changes.  The notifier callbacks 
are passed the old clock rate and the new clock rate.  Since a rate change 
on a clock in the middle of the clock tree (e.g., dpll3_m2_ck) can affect 
all clocks downstream, the clock code must compute the new rate for not 
only dpll3_m2_ck, but also all downstream clocks, before clk->rate is 
updated and the hardware registers are actually changed.

This presents a problem with the current code.  Consider the 
pre-notification case, in which the clock code needs to compute the target 
clock rate without actually updating clk->rate.  But the round_rate() 
functions assume that the parent clock's current rate is what should be 
used.  If the parent clock's rate would also change as part of the 
clk_set_rate(), the target rate computation will return an incorrect rate.

So this patch allows temporary rates to be computed for all of the clocks 
that would be affected by the rate or parent change, so the correct target 
rates can be passed to each clock's notifier (assuming one exists for the 
clock).

N.B., this temporary rate computation is also the motivation behind the 
recursive propagate_rate() calls that we discussed earlier.

It also may turn out that it's unnecessary to pass the new rate to the 
notifiers, in which case most of this code won't need to reappear.

> A far better way to approach this would be to split the set_rate/recalc
> functionality into two parts:
> 
> 1. a method which returns the both the new clock rate and the hardware
>    programming information
> 2. a method to commit the hardware programming information to the registers
> 
> (1) can be used for implementing clk_round_rate() (which is totally lacking
> in OMAP2+, yet is implemented in OMAP1), clk_set_rate(), clk_set_parent()
> etc.

The OMAP2/3 clock code does implement clk_round_rate() - most commonly via 
mach-omap2/clock.c:omap2_clksel_round_rate().  There are a few special 
cases which use other round_rate() functions.

> (2) can be used when it's required to actually reprogram the hardware.
> 
> So, rather than the current situation where we have recalc, round_rate
> and set_rate methods, we have calc_rate() and commit() methods instead
> and have the core clock code sort out calling these.

I haven't yet spent much time thinking about this new arrangement -- it 
seems to be orthogonal to the problem that this patch is intended to solve 
-- but it might make sense for a different purpose.  Many of our 
set_rate() functions wind up calling round_rate() first to determine 
whether the passed-in rate is valid and to return the hardware programming 
data from the clksel structures.  This extra call to round_rate() just 
wastes cycles.  So this new layout might be more efficient, although it 
appears that calc_rate() is called twice in the new arrangement as well.


I appreciate the ongoing technical review,

- Paul
