Return-Path: <linux-kernel-owner+w=401wt.eu-S1752914Ab0AMBRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914Ab0AMBRv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 20:17:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752001Ab0AMBRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 20:17:51 -0500
Received: from adelie.canonical.com ([91.189.90.139]:37521 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535Ab0AMBRu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 20:17:50 -0500
From: Jeremy Kerr <jeremy.kerr@canonical.com>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC,PATCH 0/7 v2] Common struct clk implementation
Date: Wed, 13 Jan 2010 12:17:36 +1100
User-Agent: KMail/1.12.2 (Linux/2.6.31-16-generic; KDE/4.3.2; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
       linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
References: <1263279511.160127.576969496193.0.gpush@pororo> <20100112091324.GC26435@n2100.arm.linux.org.uk>
In-Reply-To: <20100112091324.GC26435@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201001131217.36575.jeremy.kerr@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

> But the point I was trying to convey is that OMAP doesn't work with
> _either_ a pure operations struct _or_ a bunch of per-clock function
> pointers - it currently uses a mixture of the two.

With the common clk, you can do exactly that:

struct clk_foo {
	/* ->ops provides functions common to clk_foo */
	struct clk;

	/* provides a function for only this clock */
	int (*single_clock_func)(struct clk_foo *);
}

The only real difference is that the public API is provided through struct clk 
rather than redefined clk_* functions; whatever is implementing the clock-
type-specific struct clk can add whatever fields necessary.

>From your earlier mail about sizes on omap:

> There are two function pointers in the struct clk which would be
> identical to the versions proposed in this generic struct clk.
> There's a total of 219 clk structures in OMAP3.  So, 219 * (4 + 8)
> = 2628.  Switching OMAP means 219 * (4 + 32) = 7884, which is an
> increase in overhead of 3x.

But we also can reduce the size of the struct clk in most cases; I believe the 
separate clk_operations in v2 of this series will help with this.

Taking OMAP3 for example (I'm not very familiar with that platform, so am 
basing this on a brief look through the clock code), the first step to a 
common clk port would be to wrap the existing struct clk:

struct clk_omap {
	struct clk			clk;
	struct list_head		node;
	const struct clkops	*ops;
    [...]
};

and define the clk_operations to be the current omap clk_* functions.

This results in one extra pointer per clock, plus the clk_operations, so 908 
bytes (4 * 219 + 32) overhead.

Next, we can start removing fields that are not used by all clocks; the fixed 
top-level clocks would be a good start; it looks like we can represent those 
with a:

struct clk_omap_fixed {
	struct clk	clk;
	char			*name;
	unsigned long	rate;
}

[For these fixed clocks, we don't need to propagate changes to children, hence 
I'm assuming no child/sibling members]

The original struct clk is 96 bytes; clk_omap_fixed is 12, but we still need 
one clk_operations (32 bytes). Since there are 8 of these, we save 640 bytes 
((96 - 12) * 8 - 32).

If we then take the 'follow parent' clocks, it looks like we can represent 
those with something like:

struct clk_omap_followparent = {
	struct clk	clk;
	char			*name;
	struct clk	*parent;
	struct list_head children, siblings;
	unsigned long	rate;
	void __iomem	*enable_reg;
	__u8			enable_bit;
	char			*clkdm_name;
	int			flags;
};

This would be 48 bytes, there are 140 of these, saving 6688 bytes ( (96 - 48) 
* 140 - 32).

Now, we could stop here, or keep looking for common usage patterns of struct 
clk to find cases where creating another clock type makes sense.

I know I've only looked at the easy OMAP cases here, but the principle still 
applies: keep the original struct clk around as a fallback, but use the 
smaller struct clks where possible.

Cheers,


Jeremy
