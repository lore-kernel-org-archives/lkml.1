Return-Path: <linux-kernel-owner+w=401wt.eu-S1761381AbYBHHun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761381AbYBHHun (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 02:50:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753445AbYBHHud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 02:50:33 -0500
Received: from mx1.suse.de ([195.135.220.2]:36454 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753376AbYBHHub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 02:50:31 -0500
Date: Fri, 8 Feb 2008 08:50:29 +0100
From: Nick Piggin <npiggin@suse.de>
To: David Chinner <dgc@sgi.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, ak@suse.de,
       jens.axboe@oracle.com, James.Bottomley@SteelEye.com, andrea@suse.de,
       clameter@sgi.com, akpm@linux-foundation.org, andrew.vasquez@qlogic.com,
       willy@linux.intel.com, Zach Brown <zach.brown@oracle.com>
Subject: Re: [rfc] direct IO submission and completion scalability issues
Message-ID: <20080208075029.GF9730@wotan.suse.de>
References: <20070728012128.GB10033@linux-os.sc.intel.com> <20080203095252.GA11043@wotan.suse.de> <20080204021052.GD155407@sgi.com> <47A69135.3060306@linux.intel.com> <20080204044020.GE155407@sgi.com> <20080204100959.GA15210@wotan.suse.de> <20080205001419.GG155407@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080205001419.GG155407@sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2008 at 11:14:19AM +1100, David Chinner wrote:
> On Mon, Feb 04, 2008 at 11:09:59AM +0100, Nick Piggin wrote:
> > You get better behaviour in the slab and page allocators and locality
> > and cache hotness of memory. For example, I guess in a filesystem /
> > pagecache heavy workload, you have to touch each struct page, buffer head,
> > fs private state, and also often have to wake the thread for completion.
> > Much of this data has just been touched at submit time, so doin this on
> > the same CPU is nice...
> 
> [....]
> 
> > I'm surprised that the xfs global state bouncing would outweigh the
> > bouncing of all the per-page/block/bio/request/etc data that gets touched
> > during completion. We'll see.
> 
> per-page/block.bio/request/etc is local to a single I/O. the only
> penalty is a cacheline bounce for each of the structures from one
> CPU to another.  That is, there is no global state modified by these
> completions.

Yeah, but it is going from _all_ submitting CPUs to the one completing
CPU. So you could bottleneck the interconnect at the completing CPU
just as much as if you had cachelines being pulled the other way (ie.
many CPUs trying to pull in a global cacheline).

 
> The real issue is metadata. The transaction log I/O completion
> funnels through a state machine protected by a single lock, which
> means completions on different CPUs pulls that lock to all
> completion CPUs. Given that the same lock is used during transaction
> completion for other state transitions (in task context, not intr),
> the more cpus active at once touches, the worse the problem gets.

OK, once you add locking (and not simply cacheline contention), then
the problem gets harder I agree. But I think that if the submitting
side takes the same locks as log completion (eg. maybe for starting a
new transaction), then it is not going to be a clear win either way,
and you'd have to measure it in the end.

