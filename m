Return-Path: <linux-kernel-owner+w=401wt.eu-S1752566AbYKRCIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566AbYKRCIu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 21:08:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751709AbYKRCIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 21:08:42 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38975 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751076AbYKRCIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 21:08:41 -0500
Date: Mon, 17 Nov 2008 18:08:13 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Paul Mackerras <paulus@samba.org>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Large stack usage in fs code (especially for PPC64)
In-Reply-To: <18722.2107.970887.768477@cargo.ozlabs.ibm.com>
Message-ID: <alpine.LFD.2.00.0811171752450.18283@nehalem.linux-foundation.org>
References: <alpine.DEB.1.10.0811171508300.8722@gandalf.stny.rr.com> <alpine.LFD.2.00.0811171300410.18283@nehalem.linux-foundation.org> <1226963596.7178.254.camel@pasglop> <alpine.LFD.2.00.0811171522030.18283@nehalem.linux-foundation.org>
 <18722.2107.970887.768477@cargo.ozlabs.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 18 Nov 2008, Paul Mackerras wrote:
> 
> Also, you didn't respond to my comments about the purely software
> benefits of a larger page size.

I realize that there are benefits. It's just that the downsides tend to 
swamp the upsides.

The fact is, Intel (and to a lesser degree, AMD) has shown how hardware 
can do good TLB's with essentially gang lookups, giving almost effective 
page sizes of 32kB with hardly any of the downsides. Couple that with 
low-latency fault handling (for not when you miss in the TLB, but when 
something really isn't in the page tables), and it seems to be seldom the 
biggest issue.

(Don't get me wrong - TLB's are not unimportant on x86 either. But on x86, 
things are generally much better).

Yes, we could prefill the page tables and do other things, and ultimately 
if you don't need to - by virtue of big pages, some loads will always 
benefit from just making the page size larger.

But the people who advocate large pages seem to never really face the 
downsides. They talk about their single loads, and optimize for that and 
nothing else. They don't seem to even acknowledge the fact that a 64kB 
page size is simply NOT EVEN REMOTELY ACCEPTABLE for other loads!

That's what gets to me. These absolute -idiots- talk about how they win 5% 
on some (important, for them) benchmark by doing large pages, but then 
ignore the fact that on other real-world loads they lose by sevaral 
HUNDRED percent because of the memory fragmentation costs.

(And btw, if they win more than 5%, it's because the hardware sucks really 
badly).

THAT is what irritates me.

What also irritates me is the ".. but AIX" argument. The fact is, the AIX 
memory management is very tightly tied to one particular broken MMU model. 
Linux supports something like thirty architectures, and while PPC may be 
one of the top ones, it is NOT EVEN CLOSE to be really relevant.

So ".. but AIX" simply doesn't matter. The Linux VM has other priorities.

And I _guarantee_ that in general, in the high-volume market (which is 
what drives things, like it or not), page sizes will not be growing. In 
that market, terabytes of RAM is not the primary case, and small files 
that want mmap are one _very_ common case.

To make things worse, the biggest performance market has another vendor 
that hasn't been saying ".. but AIX" for the last decade, and that 
actually listens to input. And, perhaps not incidentally, outperforms the 
highest-performance ppc64 chips mostly by a huge margin - while selling 
their chips for a fraction of the price.

I realize that this may be hard to accept for some people. But somebody 
who says "... but AIX" should be taking a damn hard look in the mirror, 
and ask themselves some really tough questions. Because quite frankly, the 
"..but AIX" market isn't the most interesting one.

			Linus
