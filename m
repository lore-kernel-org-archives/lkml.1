Return-Path: <linux-kernel-owner+w=401wt.eu-S1753016AbXDRE3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016AbXDRE3X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 00:29:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753018AbXDRE3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 00:29:23 -0400
Received: from holomorphy.com ([66.93.40.71]:50258 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752985AbXDRE3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 00:29:22 -0400
Date: Tue, 17 Apr 2007 21:29:04 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Ingo Molnar <mingo@elte.hu>, Davide Libenzi <davidel@xmailserver.org>,
       Nick Piggin <npiggin@suse.de>, Peter Williams <pwil3058@bigpond.net.au>,
       Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       ck list <ck@vds.kolivas.org>, Bill Huey <billh@gnuppy.monkey.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070418042904.GY8915@holomorphy.com>
References: <Pine.LNX.4.64.0704162317330.30516@alien.or.mcafeemobile.com> <20070417070949.GR8915@holomorphy.com> <20070417073308.GB30559@elte.hu> <20070417090538.GU8915@holomorphy.com> <20070417092422.GA19414@elte.hu> <20070417220809.GF11166@waste.org> <20070417223256.GP2986@holomorphy.com> <20070417223909.GO11115@waste.org> <20070417225902.GQ2986@holomorphy.com> <20070417225723.GP11115@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070417225723.GP11115@waste.org>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2007 at 09:07:49AM -0400, James Bruce wrote:
>>> Nonlinear is a must IMO.  I would suggest X = exp(ln(10)/10) ~= 1.2589
>>> That value has the property that a nice=10 task gets 1/10th the cpu of a
>>> nice=0 task, and a nice=20 task gets 1/100 of nice=0.  I think that
>>> would be fairly easy to explain to admins and users so that they can
>>> know what to expect from nicing tasks.

On Tue, Apr 17, 2007 at 03:59:02PM -0700, William Lee Irwin III wrote:
>> I'm not likely to write the testcase until this upcoming weekend, though.

On Tue, Apr 17, 2007 at 05:57:23PM -0500, Matt Mackall wrote:
> So that means there's a 10000:1 ratio between nice 20 and nice -19. In
> that sort of dynamic range, you're likely to have non-trivial
> numerical accuracy issues in integer/fixed-point math.
> (Especially if your clock is jiffies-scale, which a significant number
> of machines will continue to be.)
> I really think if we want to have vastly different ratios, we probably
> want to be looking at BATCH and RT scheduling classes instead.

100**(1/39.0) ~= 1.12534 may do if so, but it seems a little weak, and
even 1000**(1/39.0) ~= 1.19378 still seems weak.

I suspect that in order to get low nice numbers strong enough without
making high nice numbers too strong something sub-exponential may need
to be used. Maybe just picking percentages outright as opposed to some
particular function.

We may also be better off defining it in terms of a share weighting as
opposed to two tasks in competition. In such a manner the extension to
N tasks is more automatic. f(n) would be a univariate function of nice
numbers and two tasks in competition with nice numbers n_1 and n_2
would get shares f(n_1)/(f(n_1)+f(n_2)) and f(n_2)/(f(n_1)+f(n_2)). In
the exponential case f(n) = K*e**(r*n) this ends up as
1/(1+e**(r*(n_2-n_1))) which is indeed a function of n_1-n_2 but for
other choices it's not so. f(n) = n+K for K >= 20 results in a share
weighting of (n_1+K,n_2+K)/(n_1+n_2+2*K), which is not entirely clear
in its impact. My guess is that f(n)=1/(n+1) when n >= 0 and f(n)=1-n
when n <= 0 is highly plausible. An exponent or an additive constant
may be worthwhile to throw in. In this case, f(-19) = 20, f(20) = 1/21,
and the ratio of shares is 420, which is still arithmeticaly feasible.
-10 vs. 0 and 0 vs. 10 are both 10:1.


-- wli
