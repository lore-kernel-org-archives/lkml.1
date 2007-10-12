Return-Path: <linux-kernel-owner+w=401wt.eu-S1760138AbXJLJwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760138AbXJLJwW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 05:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757321AbXJLJwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 05:52:14 -0400
Received: from mx10.go2.pl ([193.17.41.74]:51969 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756976AbXJLJwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 05:52:13 -0400
Date: Fri, 12 Oct 2007 11:55:05 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>
Subject: Re: [rfc][patch 3/3] x86: optimise barriers
Message-ID: <20071012095505.GD1962@ff.dom.local>
References: <20071004052348.GC15131@wotan.suse.de> <20071012082534.GB1962@ff.dom.local> <20071012085733.GA19237@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071012085733.GA19237@wotan.suse.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2007 at 10:57:33AM +0200, Nick Piggin wrote:
> On Fri, Oct 12, 2007 at 10:25:34AM +0200, Jarek Poplawski wrote:
> > On 04-10-2007 07:23, Nick Piggin wrote:
> > > According to latest memory ordering specification documents from Intel and
> > > AMD, both manufacturers are committed to in-order loads from cacheable memory
> > > for the x86 architecture. Hence, smp_rmb() may be a simple barrier.
> > ...
> > 
> > Great news!
> > 
> > First it looks like a really great thing that it's revealed at last.
> > But then... there is probably some confusion: did we have to use
> > ineffective code for so long?
> 
> I'm not sure exactly what the situation is with the manufacturers,
> but maybe they (at least Intel) wanted to keep their options open
> WRT their barrier semantics, even if current implementations were
> not taking full liberty of them.
> 
>  
> > First again, we could try to blame Intel etc. But then, wait a minute:
> > is it such a mystery knowledge? If this reordering is done there are
> > some easy rules broken (just like in examples from these manuals). And
> > if somebody cared to do this for optimization, then this is probably
> > noticeable optimization, let's say 5 or 10%. Then any test shouldn't
> > need to take very long to tell the truth in less than 100 loops!
> 
> I don't know quite what you're saying... the CPUs could probably get
> performance by having weakly ordered loads, OTOH I think the Intel
> ones might already do this speculatively so they appear in order but
> essentially have the performance of weak order.

I meant: if there is any reordering possible this should be quite
distinctly visible, because why would any vendor enable such nasty
things if not for performance. But now I start to doubt: of course
there is such a possibility someone makes this reordering for some
other reasons which could be so rare it's hard to check. And this
someone knows it's processors are seen less efficient because of eg.
mostly unneeded read barriers used by operating systems...

> 
> If you're just talking about this patch, then it probably isn't much
> performance gain. I'm guessing you'd be lucky to measure it from
> userspace.

No, it's only about the comment to this patch: "Hence, smp_rmb() may be
a simple barrier".

> 
> 
> > So, maybe linux needs something like this, instead of waiting few
> > years with each new model for vendors goodwill? IMHO, even for less
> > popular processors, this could be checked under some debugging option
> > at the system start (after disabling suspicios barrier for a while
> > plus some WARN_ONs).
> 
> I don't know if that would be worthwhile. It actually isn't always
> trivial to trigger reordering. For example, on my dual-core core2,
> in order to see reads pass writes, I have to do work on a set that
> exceeds the cache size and does a huge amount of work to ensure it
> is going to trigger that. If you can actually come up with a test
> case that triggers load/load or store/store reordering, I'm sure
> Intel / AMD would like to see it ;)

Anyway, it seems any heavy testing such as yours, should give us the
same informations years earlier than any vendors manual and then any
gain is multiplied by millions of users. Then only still doubtful
cases could be treated with additional caution and some debugging
code.

> 
> All existing processors as far as we know are in-order WRT loads vs
> loads and stores vs stores. It was just a matter of getting the docs
> clarified, which gives us more confidence that we're correct and a
> reasonable guarnatee of forward compatibility.

After reading this Intel's legal information I don't think you should
feel so much more forward confident...

> 
> So, I think the plan is just to merge these 3 patches during the
> current window.
> 

And they really should be!

Jarek P.
