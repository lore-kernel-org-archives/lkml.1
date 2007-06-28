Return-Path: <linux-kernel-owner+w=401wt.eu-S1763703AbXF1AsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763703AbXF1AsR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 20:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752446AbXF1AsB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 20:48:01 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60914 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759482AbXF1AsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 20:48:00 -0400
Date: Wed, 27 Jun 2007 17:46:02 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
cc: Nick Piggin <nickpiggin@yahoo.com.au>, Eric Dumazet <dada1@cosmosbay.com>,
       Chuck Ebbert <cebbert@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Jarek Poplawski <jarkao2@o2.pl>, Miklos Szeredi <miklos@szeredi.hu>,
       chris@atlee.ca,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       tglx@linutronix.de, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG] long freezes on thinkpad t60
In-Reply-To: <Pine.LNX.4.64.0706271545490.3879@alien.or.mcafeemobile.com>
Message-ID: <alpine.LFD.0.98.0706271725050.8675@woody.linux-foundation.org>
References: <20070620093612.GA1626@ff.dom.local>
 <alpine.LFD.0.98.0706201018290.3593@woody.linux-foundation.org>
 <20070621073031.GA683@elte.hu> <alpine.LFD.0.98.0706210845090.3593@woody.linux-foundation.org>
 <20070621160817.GA22897@elte.hu> <467AAB04.2070409@redhat.com>
 <alpine.LFD.0.98.0706211024370.3593@woody.linux-foundation.org>
 <20070621202917.a2bfbfc7.dada1@cosmosbay.com>
 <alpine.LFD.0.98.0706211135360.3593@woody.linux-foundation.org>
 <4680D162.9050603@yahoo.com.au> <alpine.LFD.0.98.0706261016200.8675@woody.linux-foundation.org>
 <4681F448.3040201@yahoo.com.au> <alpine.LFD.0.98.0706262249590.8675@woody.linux-foundation.org>
 <alpine.LFD.0.98.0706271233300.8675@woody.linux-foundation.org>
 <Pine.LNX.4.64.0706271310550.5219@alien.or.mcafeemobile.com>
 <alpine.LFD.0.98.0706271500260.8675@woody.linux-foundation.org>
 <Pine.LNX.4.64.0706271545490.3879@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 27 Jun 2007, Davide Libenzi wrote:

> On Wed, 27 Jun 2007, Linus Torvalds wrote:
> > 
> > Stores never "leak up". They only ever leak down (ie past subsequent loads 
> > or stores), so you don't need to worry about them. That's actually already 
> > documented (although not in those terms), and if it wasn't true, then we 
> > couldn't do the spin unlock with just a regular store anyway.
> 
> Yes, Intel has never done that. They'll probably never do it since it'll 
> break a lot of system software (unless they use a new mode-bit that 
> allows system software to enable lose-ordering). Although I clearly 
> remember to have read in one of their P4 optimization manuals to not 
> assume this in the future.

That optimization manual was confused. 

The Intel memory ordering documentation *clearly* states that only reads 
pass writes, not the other way around.

Some very confused people have thought that "pass" is a two-way thing. 
It's not. "Passing" in the Intel memory ordering means "go _ahead_ of", 
exactly the same way it means in traffic. You don't "pass" people by 
falling behind them.

It's also obvious from reading the manual, because any other reading would 
be very strange: it says

 1. Reads can be carried out speculatively and in any order

 2. Reads can pass buffered writes, but the processor is self-consistent

 3. Writes to memory are always carried out in program order [.. and then 
    lists exceptions that are not interesting - it's clflush and the 
    non-temporal stores, not any normal writes ]

 4. Writes can be buffered

 5. Writes are not performed speculatively; they are only performed for 
    instructions that have actually been retired.

 6. Data from buffered writes can be forwarded to waiting reads within the 
    processor.

 7. Reads or writes cannot pass (be carried out ahead of) I/O 
    instructions, locked instructions or serializing instructions.

 8. Reads cannot pass LFENCE and MFENCE instructions.

 9. Writes cannot pass SFENCE or MFENCE instructions.

The thing to note is:

 a) in (1), Intel says that reads can occur in any order, but (2) makes it 
    clear that that is only relevant wrt other _reads_

 b) in (2), they say "pass", but then they actually explain that "pass" 
    means "be carried out ahead of" in (7). 

    HOWEVER, it should be obvious in (2) even _without_ the explicit 
    clarification in (7) that "pass" is a one-way thing, because otherwise 
    (2) is totally _meaningless_. It would be meaningless for two reasons:

     - (1) already said that reads can be done in any order, so if that 
       was a "any order wrt writes", then (2) would be pointless. So (2) 
       must mean something *else* than "any order", and the only sane 
       reading of it that isn't "any order" is that "pass" is a one-way 
       thing: you pass somebody when you go ahead of them, you do *not* 
       pass somebody when you fall behind them!

     - if (2) really meant that reads and writes can just be re-ordered, 
       then the choice of words makes no sense. It would be much more 
       sensible to say that "reads can be carried out in any order wrt 
       writes", instead of talking explicitly about "passing buffered 
       writes"

Anyway, I'm pretty damn sure my reading is correct. And no, it's not a "it 
happens to work". It's _architecturally_required_ to work, and nobody has 
ever complained about the use of a simple store to unlock a spinlock 
(which would only work if the "reads can pass" only means "*later* reads 
can pass *earlier* writes").

And it turns out that I think #1 is going away. Yes, the uarch will 
internally re-order reads, wrt each other, but if it isn't architecturally 
visible, then from an architectural standpoint #1 simply doesn't happen.

I can't guarantee that will happen, of course, but from talking to both 
AMD and Intel people, I think that they'll just document the stricter 
rules as the de-facto rules.

		Linus
