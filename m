Return-Path: <linux-kernel-owner+w=401wt.eu-S1754007AbYKQX3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007AbYKQX3y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 18:29:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751793AbYKQX3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 18:29:45 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35436 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751630AbYKQX3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 18:29:44 -0500
Date: Mon, 17 Nov 2008 15:28:41 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Large stack usage in fs code (especially for PPC64)
In-Reply-To: <1226963596.7178.254.camel@pasglop>
Message-ID: <alpine.LFD.2.00.0811171522030.18283@nehalem.linux-foundation.org>
References: <alpine.DEB.1.10.0811171508300.8722@gandalf.stny.rr.com>  <alpine.LFD.2.00.0811171300410.18283@nehalem.linux-foundation.org> <1226963596.7178.254.camel@pasglop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 18 Nov 2008, Benjamin Herrenschmidt wrote:
> 
> Guess who is pushing for larger page sizes nowadays ? Embedded
> people :-) In fact, we have patches submited on the list to offer the
> option for ... 256K pages on some 44x embedded CPUs :-)
> 
> It makes some sort of sense I suppose on very static embedded workloads
> with no swap nor demand paging.

It makes perfect sense for anything that doesn't use any MMU. 

The hugepage support seems to cover many of the relevant cases, ie 
databases and things like big static mappings (frame buffers etc).

> > It's made worse by the fact that they 
> > also have horribly bad TLB fills on their broken CPU's, and years and 
> > years of telling people that the MMU on ppc's are sh*t has only been 
> > reacted to with "talk to the hand, we know better".
> 
> Who are you talking about here precisely ? I don't think either Paul or
> I every said something nearly around those lines ... Oh well.

Every single time I've complained about it, somebody from IBM has said ".. 
but but AIX".

This time it was Paul. Sometimes it has been software people who agree, 
but point to hardware designers who "know better". If it's not some insane 
database person, it's a Fortran program that runs for days.

> But there is also pressure to get larger page sizes from small embedded
> field, where CPUs have even poorer TLB refill (software loaded
> basically) :-)

Yeah, I agree that you _can_ have even worse MMU's. I'm not saying that 
PPC64 is absolutely pessimal and cannot be made worse. Software fill is 
indeed even worse from a performance angle, despite the fact that it's 
really "nice" from a conceptual angle.

Of course, of thesw fill users that remain, many do seem to be ppc.. It's 
like the architecture brings out the worst in hardware designers.

> > Quite frankly, 64kB pages are INSANE. But yes, in this case they actually 
> > cause bugs. With a sane page-size, that *arr[MAX_BUF_PER_PAGE] thing uses 
> > 64 bytes, not 1kB.
> 
> Come on, the code is crap to allocate that on the stack anyway :-)

Why? We do actually expect to be able to use stack-space for small 
structures. We do it for a lot of things, including stuff like select() 
optimistically using arrays allocated on the stack for the common small 
case, just because it's, oh, about infinitely faster to do than to use 
kmalloc().

Many of the page cache functions also have the added twist that they get 
called from low-memory setups (eg write_whole_page()), and so try to 
minimize allocations for that reason too.

			Linus
