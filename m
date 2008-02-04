Return-Path: <linux-kernel-owner+w=401wt.eu-S1752710AbYBDKeI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710AbYBDKeI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 05:34:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750848AbYBDKd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 05:33:57 -0500
Received: from brick.kernel.dk ([87.55.233.238]:8575 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772AbYBDKd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 05:33:56 -0500
Date: Mon, 4 Feb 2008 11:33:52 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Nick Piggin <npiggin@suse.de>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       linux-kernel@vger.kernel.org, arjan@linux.intel.com, mingo@elte.hu,
       ak@suse.de, James.Bottomley@SteelEye.com, andrea@suse.de,
       clameter@sgi.com, akpm@linux-foundation.org, andrew.vasquez@qlogic.com,
       willy@linux.intel.com, Zach Brown <zach.brown@oracle.com>
Subject: Re: [rfc] direct IO submission and completion scalability issues
Message-ID: <20080204103352.GD15220@kernel.dk>
References: <20070728012128.GB10033@linux-os.sc.intel.com> <20080203095252.GA11043@wotan.suse.de> <20080204101243.GC15220@kernel.dk> <20080204103135.GB15210@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080204103135.GB15210@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04 2008, Nick Piggin wrote:
> On Mon, Feb 04, 2008 at 11:12:44AM +0100, Jens Axboe wrote:
> > On Sun, Feb 03 2008, Nick Piggin wrote:
> > > On Fri, Jul 27, 2007 at 06:21:28PM -0700, Suresh B wrote:
> > > 
> > > Hi guys,
> > > 
> > > Just had another way we might do this. Migrate the completions out to
> > > the submitting CPUs rather than migrate submission into the completing
> > > CPU.
> > > 
> > > I've got a basic patch that passes some stress testing. It seems fairly
> > > simple to do at the block layer, and the bulk of the patch involves
> > > introducing a scalable smp_call_function for it.
> > > 
> > > Now it could be optimised more by looking at batching up IPIs or
> > > optimising the call function path or even mirating the completion event
> > > at a different level...
> > > 
> > > However, this is a first cut. It actually seems like it might be taking
> > > slightly more CPU to process block IO (~0.2%)... however, this is on my
> > > dual core system that shares an llc, which means that there are very few
> > > cache benefits to the migration, but non-zero overhead. So on multisocket
> > > systems hopefully it might get to positive territory.
> > 
> > That's pretty funny, I did pretty much the exact same thing last week!
> 
> Oh nice ;)
> 
> 
> > The primary difference between yours and mine is that I used a more
> > private interface to signal a softirq raise on another CPU, instead of
> > allocating call data and exposing a generic interface. That put the
> > locking in blk-core instead, turning blk_cpu_done into a structure with
> > a lock and list_head instead of just being a list head, and intercepted
> > at blk_complete_request() time instead of waiting for an already raised
> > softirq on that CPU.
> 
> Yeah I was looking at that... didn't really want to add the spinlock
> overhead to the non-migration case. Anyway, I guess that sort of
> fine implementation details is going to have to be sorted out with
> results.

As Andi mentions, we can look into making that lockless. For the initial
implementation I didn't really care, just wanted something to play with
that would nicely allow me to control both the submit and complete side
of the affinity issue.

-- 
Jens Axboe

