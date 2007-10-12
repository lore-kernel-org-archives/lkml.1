Return-Path: <linux-kernel-owner+w=401wt.eu-S1759789AbXJLI6F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759789AbXJLI6F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 04:58:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754488AbXJLI5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 04:57:40 -0400
Received: from ns1.suse.de ([195.135.220.2]:40777 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754148AbXJLI5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 04:57:35 -0400
Date: Fri, 12 Oct 2007 10:57:33 +0200
From: Nick Piggin <npiggin@suse.de>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>
Subject: Re: [rfc][patch 3/3] x86: optimise barriers
Message-ID: <20071012085733.GA19237@wotan.suse.de>
References: <20071004052348.GC15131@wotan.suse.de> <20071012082534.GB1962@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071012082534.GB1962@ff.dom.local>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2007 at 10:25:34AM +0200, Jarek Poplawski wrote:
> On 04-10-2007 07:23, Nick Piggin wrote:
> > According to latest memory ordering specification documents from Intel and
> > AMD, both manufacturers are committed to in-order loads from cacheable memory
> > for the x86 architecture. Hence, smp_rmb() may be a simple barrier.
> ...
> 
> Great news!
> 
> First it looks like a really great thing that it's revealed at last.
> But then... there is probably some confusion: did we have to use
> ineffective code for so long?

I'm not sure exactly what the situation is with the manufacturers,
but maybe they (at least Intel) wanted to keep their options open
WRT their barrier semantics, even if current implementations were
not taking full liberty of them.

 
> First again, we could try to blame Intel etc. But then, wait a minute:
> is it such a mystery knowledge? If this reordering is done there are
> some easy rules broken (just like in examples from these manuals). And
> if somebody cared to do this for optimization, then this is probably
> noticeable optimization, let's say 5 or 10%. Then any test shouldn't
> need to take very long to tell the truth in less than 100 loops!

I don't know quite what you're saying... the CPUs could probably get
performance by having weakly ordered loads, OTOH I think the Intel
ones might already do this speculatively so they appear in order but
essentially have the performance of weak order.

If you're just talking about this patch, then it probably isn't much
performance gain. I'm guessing you'd be lucky to measure it from
userspace.


> So, maybe linux needs something like this, instead of waiting few
> years with each new model for vendors goodwill? IMHO, even for less
> popular processors, this could be checked under some debugging option
> at the system start (after disabling suspicios barrier for a while
> plus some WARN_ONs).

I don't know if that would be worthwhile. It actually isn't always
trivial to trigger reordering. For example, on my dual-core core2,
in order to see reads pass writes, I have to do work on a set that
exceeds the cache size and does a huge amount of work to ensure it
is going to trigger that. If you can actually come up with a test
case that triggers load/load or store/store reordering, I'm sure
Intel / AMD would like to see it ;)

All existing processors as far as we know are in-order WRT loads vs
loads and stores vs stores. It was just a matter of getting the docs
clarified, which gives us more confidence that we're correct and a
reasonable guarnatee of forward compatibility.

So, I think the plan is just to merge these 3 patches during the
current window.

