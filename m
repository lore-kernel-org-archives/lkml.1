Return-Path: <linux-kernel-owner+w=401wt.eu-S1754830AbYK2KOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbYK2KOP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 05:14:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751082AbYK2KN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 05:13:59 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36961 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751041AbYK2KN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 05:13:58 -0500
Date: Sat, 29 Nov 2008 11:13:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jirka Pirko <jirka@pirko.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] get rid of some "may be used uninitialized" compiler
	warnings
Message-ID: <20081129101346.GE26691@elte.hu>
References: <20081129003347.2295622f@jirka.pirko.cz> <20081129092601.GA26691@elte.hu> <20081129013928.1bb41320.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081129013928.1bb41320.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sat, 29 Nov 2008 10:26:01 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> 
> >  196 files changed, 545 insertions(+), 436 deletions(-)
> 
> Is any of this going anywhere?

We are using it to allow -tip to build without a single warning in 
allyes/allno/allmod and randconfig kernels with -Werror, on 32-bit and 
64-bit x86. Hence we use it to filter out our own bogosities that come in 
via -tip maintained subsystems. (The fact that we need to look at _all_ 
warnings all across the kernel is a side effect.)

> There's a lot of resistance to fixing these things with 
> uninitialized_var() (usually bogus resistance, IMO, but one gets tired 
> of repeating oneself).

The networking tree picked up a whole bunch of them a few days ago. Most 
of the maintainers of actively maintained subsystems are reasonable about 
these things.

The only really contentious ones are the ones i kept separated out in 
tip/warnings/bug: they are the warnings that are triggered by 
!CONFIG_BUG.

> Many of these warnings can be fixed by restructuring the code, and 
> often the end result is better overall.

i can give you the identity of more than 1 million separate lines of code 
in the kernel where we have tool output that somehow tells us: "this code 
sucks and could be improved by restructuring it".

So the cleanup effect is there, but by far not as important as the other, 
reverse effect: a baseline of ~200 warnings obscures _nasty_ bugs that 
the compiler does point out. So we need to reach a zero baseline - and 
all the _new_ warnings tend to be very interesting.

We saw that in the x86 tree which reached a zero baseline -Werror a few 
months ago: out of 10 warnings fixed after we reached the baseline 9 were 
real fixes, only one is a GCC annotation.

I.e. we have amassed 100+ sites in the kernel that needs annotations - 
then we could move to the next phase and reliably enforce a -Werror build 
by subsystems who care about that. I know you care about it in -mm.

> But it's a lot more work.  It would be much more scalable to, umm, 
> motivate the various code-owners to fix their stuff independently.  I 
> don't know how, really - people just don't seem to appreciate how 
> irritating and damaging that great warning spew is.
> 
> Is there any prospect that some of these things will be fixed by newer 
> gcc versions?  If so, we could just ignore those warnings and 
> concentrate on the ones which newer gcc emits.

Some go away with new GCC versions - that is why i'm always testing with 
the very latest GCC version.

Would you be interested in picking up the ones in tip/warnings/complex 
and tip/warnings/simple [but not tip/warnings/bug] into -mm? You could 
pick up auto-warning-next tree into -mm straight away - it's well-tested 
on x86, it is -git based and kept uptodate. Then you could do 
!CONFIG_ALLOW_WARNINGS builds yourself.

	Ingo
