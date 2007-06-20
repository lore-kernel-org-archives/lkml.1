Return-Path: <linux-kernel-owner+w=401wt.eu-S1762615AbXFTJTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762615AbXFTJTk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 05:19:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753122AbXFTJTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 05:19:34 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58969 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733AbXFTJTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 05:19:33 -0400
Subject: Re: Change in default vm_dirty_ratio
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: davej@redhat.com, tim.c.chen@linux.intel.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, David Miller <davem@davemloft.net>
In-Reply-To: <20070620015826.03f1d71a.akpm@linux-foundation.org>
References: <1182201271.4883.22.camel@localhost.localdomain>
	 <20070618164711.9de1c38e.akpm@linux-foundation.org>
	 <20070620042434.GC12096@redhat.com>
	 <20070619214407.dfff0ca6.akpm@linux-foundation.org>
	 <1182328536.21117.24.camel@twins>
	 <20070620015826.03f1d71a.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 20 Jun 2007 11:19:27 +0200
Message-Id: <1182331167.21117.38.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-20 at 01:58 -0700, Andrew Morton wrote:
> > On Wed, 20 Jun 2007 10:35:36 +0200 Peter Zijlstra <peterz@infradead.org> wrote:
> > On Tue, 2007-06-19 at 21:44 -0700, Andrew Morton wrote:
> > 
> > > Anyway, this is all arse-about.  What is the design?  What algorithms
> > > do we need to implement to do this successfully?  Answer me that, then
> > > we can decide upon these implementation details.
> > 
> > Building on the per BDI patches, how about integrating feedback from the
> > full-ness of device queues. That is, when we are happily doing IO and we
> > cannot possibly saturate the active devices (as measured by their queue
> > never reaching 75%?) then we can safely increase the total dirty limit.
> > 
> > OTOH, when even with the per BDI dirty limit the device queue is
> > constantly saturated (contended) we ought to lower the total dirty
> > limit.
> > 
> > Lots of detail here to work out, but does this sound workable?
> 
> It's pretty easy to fill the queues - I'd expect that there are a lot of
> not-very-heavy workloads which cause the kernel to shove a lot of little
> writes into the queue when it visits the blockdev mapping: a shower of
> inodes, directory entries, indirect blocks, etc.  With very little dirty
> memory associated with it.
> 
> But back away further.
> 
> What do we actually want the kernel to *do*?  Stated in terms of "when the
> dirty memory state is A, do B" and "when userspace does C, the kernel should
> do D".
> 
> Top-level statement: "when userspace does anything, the kernel should not
> suck" ;)  Some refinement is needed there.
> 
> I _think_ the problem is basically one of latency: a) writes starving reads
> and b) dirty memory causing page reclaim to stall and c) inter-device
> contention on the global memory limits.

well, I hope to have solved c)... :-)

> Hard.  If the device isn't doing anything else then we can shove data at it
> freely.  If reads (or synchronous writes) come in then perhaps the VM
> should back off and permit dirty memory to go higher.
> 
> The anticipatory scheduler(s) are supposed to fix this.

I must plead ignorance here, I'll try to fill this hole in my
knowledge :-/

> Perhaps our queues are too long - if the VFS _does_ back off, it'll take
> some time for that to have an effect.
> 
> Perhaps the fact that the queue size knows nothing about the _size_ of the
> requests in the queue is a problem.

Yes this would be an issue. By not knowing that, the queue limit is
basically useless. It doesn't limit very much.

> Back away even further here.
> 
> What user-visible problem(s) are we attemping to fix?

Good point, the only report so far is DaveM saying git sucked on his
sparc64 box...

Dave, do you have any idea what caused that? could it be this global
fsync ext3 suffers from?

But the basic problem is balancing under-utilisation of disks vs.
keeping too much in memory.

