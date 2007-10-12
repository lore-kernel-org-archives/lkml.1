Return-Path: <linux-kernel-owner+w=401wt.eu-S1757511AbXJLPOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511AbXJLPOS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 11:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752283AbXJLPOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 11:14:09 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48709 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750845AbXJLPOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 11:14:08 -0400
Date: Fri, 12 Oct 2007 08:13:52 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jarek Poplawski <jarkao2@o2.pl>
cc: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>
Subject: Re: [rfc][patch 3/3] x86: optimise barriers
In-Reply-To: <20071012082534.GB1962@ff.dom.local>
Message-ID: <alpine.LFD.0.999.0710120802160.6887@woody.linux-foundation.org>
References: <20071012082534.GB1962@ff.dom.local>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 12 Oct 2007, Jarek Poplawski wrote:
> 
> First it looks like a really great thing that it's revealed at last.
> But then... there is probably some confusion: did we have to use
> ineffective code for so long?

I think the chip manufacturers really wanted to keep their options open.

Having the option to re-order loads in architecturally visible ways was 
something that they probably felt they really wanted to have. On the other 
hand:

 - I bet they had noticed that things break, and some applications depend 
   on fairly strong ordering (not necessarily in Linux-land, but..)

   I suspect hw manufacturers go through life hoping that "software 
   improves". They probably thought that getting rid of the old 16-bit 
   windows would mean that less people depended on undefined behaviour. 

   And I suspect that they started noticing that no, with threads and 
   JVM's and things, *more* people started depending on fairly strong 
   memory ordering.

 - I suspect Intel in particular noticed that they can do a lot of very 
   aggressive re-ordering at a microarchitectural level, but can still 
   guarantee that *architecturally* they never show it (dynamic detection 
   of reordered loads being replayed on cache dirty events etc).

IOW, I suspect that both Intel and AMD noticed that while they had wanted 
to keep their options open, those options weren't really realistic, and 
not something that the market wanted (aggressive use of threading wants 
*stricter* memory ordering, not looser), and they could work well enough 
with a fairly strict memory model.

> So, maybe linux needs something like this, instead of waiting few
> years with each new model for vendors goodwill? IMHO, even for less
> popular processors, this could be checked under some debugging option
> at the system start (after disabling suspicios barrier for a while
> plus some WARN_ONs).

Quite frankly, even *within* Intel and AMD, there are damn few people who 
understand exactly what the memory ordering requirements and guarantees 
are and historically were for the different CPU's.

I would bet that had you asked a random (but still competent) Intel/AMD 
engineer that wasn't really intimately involved with the actual design of 
the cache protocols and memory pipelines, they would absolutely not have 
been able to tell you how the CPU actually worked.

So no, there's no way a software person could have afforded to say "it 
seems to work on my setup even without the barrier". On a dual-socket 
setup with s shared bus, that says absolutely *nothing* about the 
behaviour of the exact same CPU when used with a multi-bus chipset. Not to 
mention another revisions of the same CPU - much less a whole other 
microarchitecture.

So yes, I've personally been aware for about a year that the memory 
ordering was going to likely be documented, but no way was I going to 
depend on it until Intel and AMD were ready to state so *publicly*. 
Because before that happens, they may have noticed errata etc that made it 
not work out.

Also, please note that we didn't even just change the barriers immediately 
when the docs came out. I want to do it soon - still *early* in the 2.6.24 
development cycle - exactly because bugs happen, and if somebody notices 
something strange, we'll have more time to perhaps decide that "oops, 
there's something bad going on, let's undo this for the real 2.6.24 
release until we can figure out the exact pattern".

		Linus
