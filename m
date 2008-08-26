Return-Path: <linux-kernel-owner+w=401wt.eu-S1754480AbYHZUnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480AbYHZUnj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 16:43:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751285AbYHZUn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 16:43:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50102 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750821AbYHZUn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 16:43:28 -0400
Date: Tue, 26 Aug 2008 13:41:43 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
cc: Rusty Russell <rusty@rustcorp.com.au>,
       "Alan D. Brunelle" <Alan.Brunelle@hp.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       linux-embedded@vger.kernel.org
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c -
 bisected
In-Reply-To: <20080826202134.GA11734@cs181140183.pp.htv.fi>
Message-ID: <alpine.LFD.1.10.0808261332570.3363@nehalem.linux-foundation.org>
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik> <48B313E0.1000501@hp.com> <alpine.LFD.1.10.0808251326500.3363@nehalem.linux-foundation.org> <200808261111.19205.rusty@rustcorp.com.au> <alpine.LFD.1.10.0808261019450.3363@nehalem.linux-foundation.org>
 <20080826183051.GB10925@cs181140183.pp.htv.fi> <alpine.LFD.1.10.0808261134530.3363@nehalem.linux-foundation.org> <20080826202134.GA11734@cs181140183.pp.htv.fi>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 26 Aug 2008, Adrian Bunk wrote:
> 
> I had in mind that we anyway have to support it for tiny kernels.

I actually don't think that is true.

If we really were to decide to be stricter about it, and it makes a big 
size difference, we can probably also add a tool to warn about functions 
that really should be inline.

> > Inlining really isn't the great tool some people think it is. Especially 
> > not since gcc stack allocation is so horrid that it won't re-use stack 
> > slots etc (which I don't disagree with per se - it's _hard_ to re-use 
> > stack slots while still allowing code scheduling).
> 
> gcc's stack allocation has become better
> (that's why we disable unit-at-a-time only for gcc 3.4 on i386).


I agree that it has become better. But it still absolutely *sucks*.

For example, see the patch I just posted about e1000 stack usage. Even 
though the variables were all in completely separate scopes, they all got 
individual space on the stack over the whole lifetime of the function, 
causing an explosion of stack-space. As such, gcc used 500 bytes too much 
of stack, just because it didn't re-use the stackspace.

That was with gcc-4.3.0, and no, there were hardly any inlining issues 
involevd, although it is true that inlining actually did make it slightly 
worse in that case too (but since it was essentially a leaf function, that 
had little real life impact, since there were no deep callchains below it 
to care).

So the fact is, "better" simply is not "good enough". We still need to do 
a lot of optimizations _manually_, because gcc cannot see that it can 
re-use the stack-slots.

And sometimes those "optimizations" are actually performance 
pessimizations, because in order to make gcc not use all the stack at the 
same time, you simply have to break things out and force-disable inlining.

> Most LOCs of the kernel are not written by people like you or Al Viro or 
> David Miller, and the average kernel developer is unlikely to do it as 
> good as gcc.

Sure. But we do have tools. We do have checkstack.pl, it's just that it 
hasn't been an issue in a long time, so I suspect many people didn't even 
_realize_ we have it, and I certainly can attest to the fact that even 
people who remember it - like me - don't actually tend to run it all that 
often.

> For the average driver the choice is realistically between
> "inline's randomly sprinkled across the driver" and
> "no inline's, leave it to gcc".

And neither is likely to be a big problem.

> BTW:
> I just ran checkstack on a (roughly) allyesconfig kernel, and we have a 
> new driver that allocates "unsigned char recvbuf[1500];" on the stack...

Yeah, it's _way_ too easy to do bad things.

> With the "gcc inline's static functions" you complain about we have
> 4-5 years of experience.

Sure. And most of it isn't all that great.

But I do agree that lettign gcc make more decisions is _dangerous_. 
However, in this case, at least, the decisions it makes would at least 
make for less inlining, and thus less stack space explosion.

			Linus
