Return-Path: <linux-kernel-owner+w=401wt.eu-S1759504AbXJOIJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759504AbXJOIJj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 04:09:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754916AbXJOIJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 04:09:27 -0400
Received: from mail.suse.de ([195.135.220.2]:45448 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751746AbXJOIJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 04:09:26 -0400
Date: Mon, 15 Oct 2007 10:09:24 +0200
From: Nick Piggin <npiggin@suse.de>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Helge Hafting <helge.hafting@aitel.hist.no>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>
Subject: Re: [rfc][patch 3/3] x86: optimise barriers
Message-ID: <20071015080924.GA32562@wotan.suse.de>
References: <20071012082534.GB1962@ff.dom.local> <alpine.LFD.0.999.0710120802160.6887@woody.linux-foundation.org> <20071015074405.GA1875@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071015074405.GA1875@ff.dom.local>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2007 at 09:44:05AM +0200, Jarek Poplawski wrote:
> On Fri, Oct 12, 2007 at 08:13:52AM -0700, Linus Torvalds wrote:
> > 
> > 
> > On Fri, 12 Oct 2007, Jarek Poplawski wrote:
> ...
> > So no, there's no way a software person could have afforded to say "it 
> > seems to work on my setup even without the barrier". On a dual-socket 
> > setup with s shared bus, that says absolutely *nothing* about the 
> > behaviour of the exact same CPU when used with a multi-bus chipset. Not to 
> > mention another revisions of the same CPU - much less a whole other 
> > microarchitecture.
> 
> Yes, I still can't believe this, but after some more reading I start
> to admit such things can happen in computer "science" too... I've
> mentioned a lost performance, but as a matter of fact I've been more
> concerned with the problem of truth:
> 
> From: Intel(R) 64 and IA-32 Architectures Software Developer's Manual
> Volume 3A:
> 
>    "7.2.2 Memory Ordering in P6 and More Recent Processor Families
>     ...
>     1. Reads can be carried out speculatively and in any order.
>     ..."
> 
> So, it looks to me like almost the 1-st Commandment. Some people (like
> me) did believe this, others tried to check, and it was respected for
> years notwithstanding nobody had ever seen such an event.

I'd say that's exactly what Intel wanted. It's pretty common (we do
it all the time in the kernel too) to create an API which places a
stronger requirement on the caller than is actually required. It can
make changes much less painful.

Has performance really been much problem for you? (even before the
lfence instruction, when you theoretically had to use a locked op)?
I mean, I'd struggle to find a place in the Linux kernel where there
is actually a measurable difference anywhere... and we're pretty
performance critical and I think we have a reasonable amount of lockless
code (I guess we may not have a lot of tight computational loops, though).
I'd be interested to know what, if any, application had found these
barriers to be problematic...

 
> And then, a few years later, we have this:
> 
> From: Intel(R) 64 Architecture Memory Ordering White Paper
> 
>     "2 Memory ordering for write-back (WB) memory
>      ...
>      Intel 64 memory ordering obeys the following principles:
>      1. Loads are not reordered with other loads.
>      ..."
> 
> I know, technically this doesn't have to be a contradiction (for not
> WB), but to me it's something like: "OK, Elvis lives and this guy is
> not real Paul McCartney too" in an official CIA statement!

The thing is that those documents are not defining what a particular
implementation does, but how the architecture is defined (ie. what
must some arbitrary software/hardware provide and what may it expect).

It's pretty natural that Intel started out with a weaker guarantee
than their CPUs of the time actually supported, and tightened it up
after (presumably) deciding not to implement such relaxed semantics
for the forseeable future.

