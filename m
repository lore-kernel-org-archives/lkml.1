Return-Path: <linux-kernel-owner+w=401wt.eu-S1751878AbZHPExU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878AbZHPExU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 00:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750915AbZHPExT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 00:53:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35940 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765AbZHPExT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 00:53:19 -0400
Date: Sun, 16 Aug 2009 06:53:16 +0200
From: Nick Piggin <npiggin@suse.de>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Nadia Derbey <Nadia.Derbey@bull.net>,
       Pierre Peiffer <peifferp@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [patch 4a/4] ipc: sem optimise simple operations
Message-ID: <20090816045316.GA11115@wotan.suse.de>
References: <200908141946.n7EJkh7B018160@mail.q-ag.de> <20090815045237.GC19195@wotan.suse.de> <4A86899A.6050502@colorfullife.com> <20090815103820.GC8954@wotan.suse.de> <4A86ABF0.2070207@colorfullife.com> <20090815144908.GA30951@wotan.suse.de> <4A86E30E.8030208@colorfullife.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A86E30E.8030208@colorfullife.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 15, 2009 at 06:32:14PM +0200, Manfred Spraul wrote:
> On 08/15/2009 04:49 PM, Nick Piggin wrote:
> >
> >I don't see how you've argued that yours is better.
> >
> >   

OK, but I'll add some context too.

> Lower number of new code lines,

Downside is you further complicate the already complex path.

> Lower total code size increase.

Downside is simple ops run in the complex path too so icache
footprint could be higher

> Lower number of seperate codepaths.

But they are independently all simpler. Combining them doesn't
add copmlexity together.

> Lower runtime memory consumption.

I'll fix this with hlists.

> Two seperate patches for the two algorithm improvements.
> 
> The main advantage of your version is that you optimize more cases.

And it is simpler.

> >If you are worried about memory consumption, we can add _rcu variants
> >to hlists and use them.
> There is no need for _rcu, the whole code runs under a spinlock.

Ah, yeah I was thinking of the undo list I think. Great then that
wil lbe easy.

> Thus the wait_for_zero queue could be converted to a hlist immediately.

Both queues can be.

> 
> Hmm: Did you track my proposals for your version?
> 
> - exit_sem() is not a hot path.
> I would propose to tread every exit_sem as update_queue, not an 
> update_queue_simple for every individual UNDO.

I don't think it matters too much, but ok. 

> - create an unlink_queue() helper that contains the updates to q->lists 
> and sma->complex_count.
> Three copies ask for errors.

Yes this is a good idea.

> - now: use a hlist for the zero queue.
> 
> >  And if you are worried about text size, then
> >I would bet my version actually uses less icache in the case of
> >simple ops being used.
> >   
> It depends. After disabling inlining, including all helper functions 
> that differ:
> 
> My proposal: 301 bytes for update_queue.
> 
> "simple", only negv: 226 bytes
> "simple, negv+zero: 354 bytes
> simple+complex: 526 bytes.
> 
> Thus with only +-1 simple ops, your version uses less icache. If both 
> +-1 and 0 ops are used, your version uses more icache.

I'll get rid of some of the BUG_ONs too, they're mostly there just
to verify correctness when I was developing it.

> Could you please send me your benchmark app?

Yeah I'll dig it out. It iterally was just lock, spin, unlock with
lots of processes.

