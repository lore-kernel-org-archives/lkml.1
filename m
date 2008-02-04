Return-Path: <linux-kernel-owner+w=401wt.eu-S1751881AbYBDKM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881AbYBDKM7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 05:12:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750891AbYBDKMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 05:12:51 -0500
Received: from brick.kernel.dk ([87.55.233.238]:13636 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885AbYBDKMu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 05:12:50 -0500
Date: Mon, 4 Feb 2008 11:12:44 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Nick Piggin <npiggin@suse.de>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       linux-kernel@vger.kernel.org, arjan@linux.intel.com, mingo@elte.hu,
       ak@suse.de, James.Bottomley@SteelEye.com, andrea@suse.de,
       clameter@sgi.com, akpm@linux-foundation.org, andrew.vasquez@qlogic.com,
       willy@linux.intel.com, Zach Brown <zach.brown@oracle.com>
Subject: Re: [rfc] direct IO submission and completion scalability issues
Message-ID: <20080204101243.GC15220@kernel.dk>
References: <20070728012128.GB10033@linux-os.sc.intel.com> <20080203095252.GA11043@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080203095252.GA11043@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 03 2008, Nick Piggin wrote:
> On Fri, Jul 27, 2007 at 06:21:28PM -0700, Suresh B wrote:
> > 
> > Second experiment which we did was migrating the IO submission to the
> > IO completion cpu. Instead of submitting the IO on the same cpu where the
> > request arrived, in this experiment  the IO submission gets migrated to the
> > cpu that is processing IO completions(interrupt). This will minimize the
> > access to remote cachelines (that happens in timers, slab, scsi layers). The
> > IO submission request is forwarded to the kblockd thread on the cpu receiving
> > the interrupts. As part of this, we also made kblockd thread on each cpu as the
> > highest priority thread, so that IO gets submitted as soon as possible on the
> > interrupt cpu with out any delay. On x86_64 SMP platform with 16 cores, this
> > resulted in 2% performance improvement and 3.3% improvement on two node ia64
> > platform.
> > 
> > Quick and dirty prototype patch(not meant for inclusion) for this io migration
> > experiment is appended to this e-mail.
> > 
> > Observation #1 mentioned above is also applicable to this experiment. CPU's
> > processing interrupts will now have to cater IO submission/processing
> > load aswell.
> > 
> > Observation #2: This introduces some migration overhead during IO submission.
> > With the current prototype, every incoming IO request results in an IPI and
> > context switch(to kblockd thread) on the interrupt processing cpu.
> > This issue needs to be addressed and main challenge to address is
> > the efficient mechanism of doing this IO migration(how much batching to do and
> > when to send the migrate request?), so that we don't delay the IO much and at
> > the same point, don't cause much overhead during migration.
> 
> Hi guys,
> 
> Just had another way we might do this. Migrate the completions out to
> the submitting CPUs rather than migrate submission into the completing
> CPU.
> 
> I've got a basic patch that passes some stress testing. It seems fairly
> simple to do at the block layer, and the bulk of the patch involves
> introducing a scalable smp_call_function for it.
> 
> Now it could be optimised more by looking at batching up IPIs or
> optimising the call function path or even mirating the completion event
> at a different level...
> 
> However, this is a first cut. It actually seems like it might be taking
> slightly more CPU to process block IO (~0.2%)... however, this is on my
> dual core system that shares an llc, which means that there are very few
> cache benefits to the migration, but non-zero overhead. So on multisocket
> systems hopefully it might get to positive territory.

That's pretty funny, I did pretty much the exact same thing last week!
The primary difference between yours and mine is that I used a more
private interface to signal a softirq raise on another CPU, instead of
allocating call data and exposing a generic interface. That put the
locking in blk-core instead, turning blk_cpu_done into a structure with
a lock and list_head instead of just being a list head, and intercepted
at blk_complete_request() time instead of waiting for an already raised
softirq on that CPU.

Didn't get around to any performance testing yet, though. Will try and
clean it up a bit and do that.

-- 
Jens Axboe

