Return-Path: <linux-kernel-owner+w=401wt.eu-S1753519AbYBDKbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519AbYBDKbq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 05:31:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750890AbYBDKbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 05:31:39 -0500
Received: from ns2.suse.de ([195.135.220.15]:45799 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772AbYBDKbi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 05:31:38 -0500
Date: Mon, 4 Feb 2008 11:31:35 +0100
From: Nick Piggin <npiggin@suse.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       linux-kernel@vger.kernel.org, arjan@linux.intel.com, mingo@elte.hu,
       ak@suse.de, James.Bottomley@SteelEye.com, andrea@suse.de,
       clameter@sgi.com, akpm@linux-foundation.org, andrew.vasquez@qlogic.com,
       willy@linux.intel.com, Zach Brown <zach.brown@oracle.com>
Subject: Re: [rfc] direct IO submission and completion scalability issues
Message-ID: <20080204103135.GB15210@wotan.suse.de>
References: <20070728012128.GB10033@linux-os.sc.intel.com> <20080203095252.GA11043@wotan.suse.de> <20080204101243.GC15220@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080204101243.GC15220@kernel.dk>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2008 at 11:12:44AM +0100, Jens Axboe wrote:
> On Sun, Feb 03 2008, Nick Piggin wrote:
> > On Fri, Jul 27, 2007 at 06:21:28PM -0700, Suresh B wrote:
> > 
> > Hi guys,
> > 
> > Just had another way we might do this. Migrate the completions out to
> > the submitting CPUs rather than migrate submission into the completing
> > CPU.
> > 
> > I've got a basic patch that passes some stress testing. It seems fairly
> > simple to do at the block layer, and the bulk of the patch involves
> > introducing a scalable smp_call_function for it.
> > 
> > Now it could be optimised more by looking at batching up IPIs or
> > optimising the call function path or even mirating the completion event
> > at a different level...
> > 
> > However, this is a first cut. It actually seems like it might be taking
> > slightly more CPU to process block IO (~0.2%)... however, this is on my
> > dual core system that shares an llc, which means that there are very few
> > cache benefits to the migration, but non-zero overhead. So on multisocket
> > systems hopefully it might get to positive territory.
> 
> That's pretty funny, I did pretty much the exact same thing last week!

Oh nice ;)


> The primary difference between yours and mine is that I used a more
> private interface to signal a softirq raise on another CPU, instead of
> allocating call data and exposing a generic interface. That put the
> locking in blk-core instead, turning blk_cpu_done into a structure with
> a lock and list_head instead of just being a list head, and intercepted
> at blk_complete_request() time instead of waiting for an already raised
> softirq on that CPU.

Yeah I was looking at that... didn't really want to add the spinlock
overhead to the non-migration case. Anyway, I guess that sort of
fine implementation details is going to have to be sorted out with
results.
