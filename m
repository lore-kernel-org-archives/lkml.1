Return-Path: <linux-kernel-owner+w=401wt.eu-S1752722AbYKOQZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722AbYKOQZ4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 11:25:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751469AbYKOQZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 11:25:47 -0500
Received: from one.firstfloor.org ([213.235.205.2]:55708 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbYKOQZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 11:25:47 -0500
Message-ID: <491EF805.1030709@firstfloor.org>
Date: Sat, 15 Nov 2008 17:25:41 +0100
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.14 (X11/20060911)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Ingo Molnar <mingo@elte.hu>, Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, jh@suse.cz
Subject: Re: CONFIG_OPTIMIZE_INLINING fun
References: <Pine.LNX.4.64.0811141804030.29883@blonde.site> <87zlk1yvjk.fsf@basil.nowhere.org> <Pine.LNX.4.64.0811151504580.10293@blonde.site>
In-Reply-To: <Pine.LNX.4.64.0811151504580.10293@blonde.site>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> gcc 4.3.2 wasn't doing well enough: it was still generating lots
> of constant_test_bits, even without CONFIG_CC_OPTIMIZE_FOR_SIZE.

Hmm I thought the heuristics had been improved in 4.3, or maybe it
was 4.4 only.

> Mind you, I've just checked its __delete_from_swap_cache is okay,
> doing efficient tests without calling anything else.  Maybe 4.3.2
> is actually making a good judgement of when constant_test_bit is
> appropriate (maybe: I don't know) 

constant_test_bit is supposed to be optimized away, so it
should never be inline ideally. The problem with the older
gcc heuristics was that it just counted code to
determine if a function is suitable for inlining
or not, without checking how much of it can be constant
evaluated first.

- and the problem is rather that
> we get so many copies of the same code, one per compilation unit.
> 
> I'd have liked to try 4.4, but seem unable to download what's needed
> for it today: maybe someone else has a snapshot already and can say
> whether it too puts lots of constant_test_bit lines in System.map
> when the kernel is built with CONFIG_OPTIMIZE_INLINING=y (with and
> without CONFIG_CC_OPTIMIZE_FOR_SIZE=y).

I tried with the older gcc 4.4 snapshot I had around, but it
ICEed on setup_percpu.c unfortunately.

> I did follow Sam's advice, and once I'd changed all the inlines
> in include/linux/page-flags.h and include/linux/page_cgroup.h
> and arch/x86/include/asm/bitops.h to __always_inline, then yes,
> gcc 4.2.1 stopped giving me lots of constant_test_bits and " Page"
> functions with CC_OPTIMIZE_FOR_SIZE=y and OPTIMIZE_INLINING=y, and
> the code generated for __delete_from_swap_cache was reasonable.
> 
> But how do we know to stop there?  that's just as far as I'd
> noticed.  It is quite conceivable that constant_test_bit poses the
> biggest challenge to gcc, but there may be other bad examples too.

As long as there isn't significant code in the inline that
is expected to be optimized away then this shouldn't be needed.

BTW an alternative would be to also tweak the respective
thresholds in gcc using --param, but the problem is that
the behaviour of those changes between options so I don't
think it's a good idea.

> If we're reduced to adding __always_inline in lots of places,
> doesn't that mean CONFIG_OPTIMIZE_INLINING just isn't working?

It's not working for the case when a lot of code in the inline
is expected to be optimized away (as is the case with constant_test_bit
which is expected to be 100% optimized). Otherwise it should work.

BTW that is why it is also not needed to mark
all of bitops.h, but only a few functions there (see my patch)


> that we'd be better just to switch it off?  Because later on
> some other improvement will be made, and we'll want the things
> already marked __always_inline to become __usually_inline_but_
> _not_if_new_gcc_knows_better, etc.  Our unceasing inline battles.
> 
> I'd have thought it better to leave the "inline"s as they are,
> but retune the __GNUC__ version in compiler-gcc.h, and reflect
> what's known in the advice in the OPTIMIZE_INLINING help text.

If we had a lot of inlines like that I would I agree with you,
but I think there are few enough of them that manually
marking them is better.

-Andi
