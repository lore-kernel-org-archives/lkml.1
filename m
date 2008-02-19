Return-Path: <linux-kernel-owner+w=401wt.eu-S1755714AbYBSQVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714AbYBSQVT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 11:21:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752825AbYBSQVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 11:21:12 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55742 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752930AbYBSQVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 11:21:10 -0500
Date: Tue, 19 Feb 2008 08:20:38 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Torsten Kaiser <just.for.lkml@googlemail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: Linux 2.6.25-rc2
In-Reply-To: <84144f020802190638i4a364d19o8986a457e76ec187@mail.gmail.com>
Message-ID: <alpine.LFD.1.00.0802190806330.7833@woody.linux-foundation.org>
References: <alpine.LFD.1.00.0802151302210.9496@woody.linux-foundation.org>  <64bb37e0802161338j306c1357m25bc224f09e6b7cd@mail.gmail.com>  <20080219061107.GA23229@elte.hu>  <64bb37e0802182254l49b10cbblc23f8a83d189ff8e@mail.gmail.com> 
 <84144f020802182321x452888bai639c71ea2a5067da@mail.gmail.com>  <20080219140230.GA32236@Krystal>  <84144f020802190621s509dbe7gc8e5609d94aca9b4@mail.gmail.com> <84144f020802190638i4a364d19o8986a457e76ec187@mail.gmail.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 19 Feb 2008, Pekka Enberg wrote:
> 
> Hmm. The barrier() in slab_free() looks fishy. The comment says it's
> there to make sure we've retrieved c->freelist before c->page but then
> it uses a _compiler barrier_ which doesn't affect the CPU and the
> reads may still be re-ordered... Not sure if that matters here though.

No, no. The comment says that it's purely there to serialize an 
*interrupt*, and as such, a compiler-only barrier is sufficient (or the 
comment is wrong).

Interrupts are "totally ordered" within a cpu (of course, in theory a CPU 
might have speculative work etc reordering, but the CPU also guarantees 
that interrupt acts _as_if_ it was exact), so a compiler barrier is 
sufficient.

Of course, if we're talking about interrupts on another CPU, that's a 
different issue, but the fact is, in that case it's not about interrupts 
any more (might as well be other code just running normally on another 
CPU), and a barrier doesn't help, it needs real locking.

So that barrier is fine per se. Of course, the whole code (and/or just the 
comment!) may be buggered, but any CPU SMP-aware barriers shouldn't be 
relevant.

What's much more likely to be an issue is simply the fact that since the 
fastpath now accesses the per-cpu freelist without any locking, if there 
is *any* sequence what-so-ever that does it from another CPU and assumes 
the old locking behaviour, the list will be corrupted. And from a quick 
look-through, I certainly cannot guarantee that isn't the case.

There's still a lot of cases that do direct assignments to "c->freelist" 
without using a guaranteed atomic sequence. They *should* be safe if it's 
guaranteed that 
 (a) they always run with interrupts disabled
AND
 (b) 'c' is _always_ the "current CPU" list

but I can't quickly see that guarantee for either.

I'd happily just revert this thing, but it would be really good to have 
confirmation that it seems to matter. But Torsten's partial bisection 
seems to say that the quicklist thing went into -mm before the crash even 
started.

So:
 - it might be something else entirely
 - it might still be the local cmpxchg, just Torsten didn't happen to 
   notice it until later.
 - it might still be the local cmpxchg, but something else changed its 
   patterns to actually make it start triggering.

and in general I don't think we should revert it unless we have stronger 
indications that it really is the problem (eg somebody finds the actual 
bug, or a reporter can confirm that it goes away when the local cmpxchg 
optimization is disabled).

		Linus
