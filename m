Return-Path: <linux-kernel-owner+w=401wt.eu-S1753510AbZBHNR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510AbZBHNR6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 08:17:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751872AbZBHNRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 08:17:48 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51349 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091AbZBHNRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 08:17:47 -0500
Date: Sun, 8 Feb 2009 13:17:34 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Paul Walmsley <paul@pwsan.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH E 10/14] OMAP clock: support "dry run" rate and parent changes
Message-ID: <20090208131734.GA21434@n2100.arm.linux.org.uk>
References: <20090128192551.29333.82943.stgit@localhost.localdomain> <20090128192753.29333.56931.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090128192753.29333.56931.stgit@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2009 at 12:27:56PM -0700, Paul Walmsley wrote:
> For upcoming notifier support, modify the rate recalculation code to
> take parent rate and rate storage parameters.  The goal here is to
> allow the clock code to determine what the clock's rate would be after
> a parent change or a rate change, without actually changing the
> hardware registers.  This is used by the upcoming notifier patches to
> pass a clock's current and planned rates to the notifier callbacks.

NAK.  I'm not sure whether you've realised, but this is exactly what the
'round_rate' method is supposed to be doing.  It provides a method by
which you can find out what the clock rate would be if you asked for
'set_rate' to set the hardware to the requested rate.

A far better way to approach this would be to split the set_rate/recalc
functionality into two parts:

1. a method which returns the both the new clock rate and the hardware
   programming information
2. a method to commit the hardware programming information to the registers

(1) can be used for implementing clk_round_rate() (which is totally lacking
in OMAP2+, yet is implemented in OMAP1), clk_set_rate(), clk_set_parent()
etc.

(2) can be used when it's required to actually reprogram the hardware.

So, rather than the current situation where we have recalc, round_rate
and set_rate methods, we have calc_rate() and commit() methods instead
and have the core clock code sort out calling these.

IOW, clk_set_rate() and clk_round_rate() becomes:

int clk_set_rate(struct clk *clk, unsigned long rate)
{
	unsigned long flags;
	int ret = -EINVAL;

        spin_lock_irqsave(&clockfw_lock, flags);
	if (clk->calc_rate) {
		unsigned long parent_rate = 0;
		struct clk_hw hw;

		if (clk->parent)
			parent_rate = clk->parent->rate;

		ret = clk->calc_rate(clk, parent_rate, &rate, &hw);
		if (ret == 0) {
			clk->rate = rate;
			clk->commit(clk, &hw);
		}
	}
        spin_unlock_irqrestore(&clockfw_lock, flags);

	return ret;
}

long clk_round_rate(struct clk *clk, unsigned long rate)
{
	unsigned long flags;
	long ret;

        spin_lock_irqsave(&clockfw_lock, flags);
	if (clk->calc_rate) {
		unsigned long parent_rate = 0;
		struct clk_hw hw;

		if (clk->parent)
			parent_rate = clk->parent->rate;

		ret = clk->calc_rate(clk, parent_rate, &rate, &hw);
		if (ret == 0)
			ret = rate;
	}
        spin_unlock_irqrestore(&clockfw_lock, flags);

	return ret;
}
