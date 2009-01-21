Return-Path: <linux-kernel-owner+w=401wt.eu-S1763594AbZAUIdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763594AbZAUIdT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 03:33:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754774AbZAUIc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 03:32:59 -0500
Received: from one.firstfloor.org ([213.235.205.2]:35695 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754608AbZAUIc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 03:32:59 -0500
Date: Wed, 21 Jan 2009 09:48:08 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Mike Waychison <mikew@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v1 0/8] Deferred dput() and iput() -- reducing lock contention
Message-ID: <20090121084808.GC15750@one.firstfloor.org>
References: <20090117022936.20425.43248.stgit@crlf.corp.google.com> <877i4pdx4f.fsf@basil.nowhere.org> <4976BF08.90306@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4976BF08.90306@google.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2009 at 10:22:00PM -0800, Mike Waychison wrote:
> Andi Kleen wrote:
> >Mike Waychison <mikew@google.com> writes:
> >
> >>livelock on dcache_lock/inode_lock (specifically in 
> >>atomic_dec_and_lock()) 
> >
> >I'm not sure how something can livelock in atomic_dec_and_lock which
> >doesn't take a spinlock itself? Are you saying you run into NUMA memory
> >unfairness here? Or did I misparse you?
> 
> By atomic_dec_and_lock, I really meant to say _atomic_dec_and_lock(). 

Ok. So it's basically just the lock that is taken? 

In theory one could likely provide an x86 specific dec-and_lock that
might perform better and doesn't lock if the count is still > 0, but that 
would only help if the reference count is still > 0. Is that a common
situation in your test?

> It takes the spinlock if the cmpxchg hidden inside atomic_dec_unless fails.
> 
> There are likely NUMA unfairness issues at play, but it's not the main 
> worry at this point.
> 
> >
> >>This patchset is an attempt to try and reduce the locking overheads 
> >>associated
> >>with final dput() and final iput().  This is done by batching dentries and
> >>inodes into per-process queues and processing them in 'parallel' to 
> >>consolidate
> >>some of the locking.
> >
> >I was wondering what this does to the latencies when dput/iput
> >is only done for very objects. Does it increase costs then
> >significantly?
> 
> very objects?

Sorry.

"is only done for very few objects". Somnhow the few got lost.
Basically latency in the unloaded case.

I always worry when people do complicated things for the high
load case how the more usual "do it for a single object" workload
fares.

> 
> >
> >As a high level comment it seems like a lot of work to work
> >around global locks, like the inode_lock, where it might be better to 
> >just split the lock up? Mind you I don't have a clear proposal
> >how to do that, but surely it's doable somehow.
> >
> 
> Perhaps.. the only plausible way I can think this would be doable would 
> be to rework the global resources (like the global inode_unused LRU list 

One simple way would be to just use multiple lists with an own lock 
each. I doubt that would impact the LRU behaviour very much.

> and deal with inode state transitions), but even then, some sort of 
> consistency needs to happen at the super_block level,

The sb could also look at multiple lists?

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
