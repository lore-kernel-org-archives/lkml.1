Return-Path: <linux-kernel-owner+w=401wt.eu-S1752419AbZDSVqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419AbZDSVqo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 17:46:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751017AbZDSVqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 17:46:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39577 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbZDSVqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 17:46:34 -0400
Date: Sun, 19 Apr 2009 23:46:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roland Dreier <rdreier@cisco.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Hitoshi Mitake <h.mitake@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: arch/x86/Kconfig selects invalid HAVE_READQ, HAVE_WRITEQ vars
Message-ID: <20090419214602.GA21527@elte.hu>
References: <alpine.LFD.2.00.0904191543530.11789@localhost.localdomain> <adaab6c1h7c.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adaab6c1h7c.fsf@cisco.com>
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


* Roland Dreier <rdreier@cisco.com> wrote:

>  > from arch/x86/Kconfig:
>  > 	...
>  >         select HAVE_READQ
>  >         select HAVE_WRITEQ
>  > 	...
>  > 
>  > yet there are no such defined Kconfig vars anywhere.  thoughts?
> 
> git blame shows that this came in from 2c5643b1 ("x86: provide 
> readq()/writeq() on 32-bit too").  And that commit looks very 
> dubious indeed to me -- it defines readq() and writeq() in a way 
> that is not atomic and probably won't generate single 64-bit bus 
> cycles.

Look at the drivers that define their own wrappers:

#ifndef readq
static inline unsigned long long readq(void __iomem *addr)
{
        return readl(addr) | (((unsigned long long)readl(addr + 4)) << 32LL);
}
#endif

... it's the obvious 32-bit semantics for reading a 64-bit value 
from an mmio address. We made that available on 32-bit too.

It's being used ... and has been in use for some time. Where's the 
problem? readl is serializing on all default-ioremap mmio targets on 
x86 so there's no ambiguity in ordering.

> Now, many drivers do "#ifndef readq <define my own implementation>
> #endif" but exactly what is required is very hardware-dependent,
> and accessing 32-bit halves in the wrong order may lead to very 
> subtle bugs. For example, the changelog for e23a59e1 ("niu: Fix 
> readq implementation when architecture does not provide one.") 
> says:
> 
>     In particular one of the issues is whether the top 32-bits
>     or the bottom 32-bits of the 64-bit register should be read
>     first.  There could be side effects, and in fact that is
>     exactly the problem here.
> 
> By coincidence, the 32-bit x86 implementation is actually OK for 
> niu, but I didn't audit every similar driver, and I don't think 
> any implementation of readq()/writeq() that generates multiple bus 
> cycles is suitable in general -- it doesn't meet the requirements 
> of the API.
>
> So I would strongly suggest reverting 2c5643b1 since as far as I 
> can tell it just sets a trap for subtle bugs that only show up on 
> 32-bit x86 [...]

Heh. It "only" shows up on the platform that ~80% of all our kernel 
testers use? ;-)

> [...] -- any portable driver still needs to provide 
> readq()/writeq() for other 32-bit architectures, so it doesn't 
> really help anyone.

So, are you arguing for a per driver definition of readq/writeq? If 
so then that does not make much technical sense. If not ... then 
what is your technical point?

Your complains are unfounded i think:

Firstly, any such bug would have shown up already.

Secondly, currently there's about 4 drivers in mainline that define 
readq/writeq methods: one of them is a very popular x86 driver and 
works fine, the other one is niu.c that you just mentioned is fine - 
the other two are for PARISC.

Thirdly, a driver simply has no business defining such a low-level 
hardware API that just happens not to be implemented on 32-bit (but 
is implemented on 64-bit).

Unless you can point to a real breakage that happened in the past ~6 
months since this commit has been upstream, i'm not sure what the 
fuss is about. Drivers found a hole in our APIs and filled it in an 
ad-hoc way - we plugged the hole on x86.

Pretty much the only valid argument to make here is that it should 
be filled in on all the other platforms as well - but you cant blame 
the x86 commit for that, can you?

So the only beef i have with that commit at the moment is that the 
HAVE_READQ / HAVE_WRITEQ Kconfig symbols are still orphan - this 
stuff should have been implemented in a tree-wide way long ago. 
Note, there's ongoing work regarding that in -mm - i saw related 
threads about that, recently. Obviously it take a lot of time to 
propagate something across a space of 20 architectures.

	Ingo
