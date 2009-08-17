Return-Path: <linux-kernel-owner+w=401wt.eu-S1756921AbZHQGov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921AbZHQGov (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 02:44:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756890AbZHQGou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 02:44:50 -0400
Received: from cantor.suse.de ([195.135.220.2]:59124 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419AbZHQGou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 02:44:50 -0400
Date: Mon, 17 Aug 2009 08:44:46 +0200
From: Nick Piggin <npiggin@suse.de>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Nadia Derbey <Nadia.Derbey@bull.net>,
       Pierre Peiffer <peifferp@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [patch 4a/4] ipc: sem optimise simple operations
Message-ID: <20090817064446.GD9962@wotan.suse.de>
References: <200908141946.n7EJkh7B018160@mail.q-ag.de> <20090815045237.GC19195@wotan.suse.de> <4A86899A.6050502@colorfullife.com> <20090815103820.GC8954@wotan.suse.de> <4A86ABF0.2070207@colorfullife.com> <20090815144908.GA30951@wotan.suse.de> <4A86E30E.8030208@colorfullife.com> <20090816103127.GB8644@wotan.suse.de> <4A87ED93.5060104@colorfullife.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A87ED93.5060104@colorfullife.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 16, 2009 at 01:29:23PM +0200, Manfred Spraul wrote:
> On 08/16/2009 12:31 PM, Nick Piggin wrote:
> >On Sat, Aug 15, 2009 at 06:32:14PM +0200, Manfred Spraul wrote:
> >   
> >>It depends. After disabling inlining, including all helper functions
> >>that differ:
> >>
> >>My proposal: 301 bytes for update_queue.
> >>
> >>"simple", only negv: 226 bytes
> >>"simple, negv+zero: 354 bytes
> >>simple+complex: 526 bytes.
> >>
> >>Thus with only +-1 simple ops, your version uses less icache. If both
> >>+-1 and 0 ops are used, your version uses more icache.
> >>     
> >Don't forget that in that case, your version is badly suboptimal
> >due to the algorithmic complexity.
> >   
> I know, I mentioned it in the change log:
> Waking up one "decrement by one" task is O(1) with your code and 
> O(1+<number of waiting-for-zero tasks>) with my code.
> 
> This is the price paid for saving memory:
> Your version keeps three pointers per semaphore (waiting-for-zero, 
> oldest decrement, newest decrement)
> My version keeps only two pointers (newest decrement, waiting-for-zero). 
> The "oldest decrement" is reconstructed on the fly, and that operation 
> is O(<number of waiting-for-zero tasks>).

OK, well let's just get something in.

I kind of liked to optimise both cases because it took this long to
uncover this suboptimal behaviour (and the problem isn't even
completely due to suboptimal semaphore but also userspace contention),
so even if there are some workloads with a little problem I don't know
if they will ever get reported/diagnosed.

That said, I'm not too unhappy with your version if you feel strongly
about it.

Thanks for reviewing the other patches too.

