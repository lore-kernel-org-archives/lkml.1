Return-Path: <linux-kernel-owner+w=401wt.eu-S1753532AbZIWAW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532AbZIWAW2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 20:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752872AbZIWAW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 20:22:27 -0400
Received: from mga03.intel.com ([143.182.124.21]:3835 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752867AbZIWAW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 20:22:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,434,1249282800"; 
   d="scan'208";a="190559721"
Date: Wed, 23 Sep 2009 08:22:20 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "richard@rsk.demon.co.uk" <richard@rsk.demon.co.uk>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: regression in page writeback
Message-ID: <20090923002220.GA6382@localhost>
References: <20090922054913.GA27260@sli10-desk.sh.intel.com> <1253601612.8439.274.camel@twins> <20090922080505.GB9192@localhost> <1253606965.8439.281.camel@twins> <20090922082427.GA24888@localhost> <1253608335.8439.283.camel@twins> <20090922155259.GL10825@think>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090922155259.GL10825@think>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 22, 2009 at 11:52:59PM +0800, Chris Mason wrote:
> On Tue, Sep 22, 2009 at 10:32:14AM +0200, Peter Zijlstra wrote:
> > On Tue, 2009-09-22 at 16:24 +0800, Wu Fengguang wrote:
> > > On Tue, Sep 22, 2009 at 04:09:25PM +0800, Peter Zijlstra wrote:
> > > > On Tue, 2009-09-22 at 16:05 +0800, Wu Fengguang wrote:
> > > > > 
> > > > > I'm not sure how this patch stopped the "overshooting" behavior.
> > > > > Maybe it managed to not start the background pdflush, or the started
> > > > > pdflush thread exited because it found writeback is in progress by
> > > > > someone else?
> > > > > 
> > > > > -               if (bdi_nr_reclaimable) {
> > > > > +               if (bdi_nr_reclaimable > bdi_thresh) {
> > > > 
> > > > The idea is that we shouldn't move more pages from dirty -> writeback
> > > > when there's not actually that much dirty left.
> > > 
> > > IMHO this makes little sense given that pdflush will move all dirty
> > > pages anyway. pdflush should already be started to do background
> > > writeback before the process is throttled, and it is designed to sync
> > > all current dirty pages as quick as possible and as much as possible.
> > 
> > Not so, pdflush (or now the bdi writer thread thingies) should not
> > deplete all dirty pages but should stop writing once they are below the
> > background limit.
> > 
> > > > Now, I'm not sure about the > bdi_thresh part, I've suggested to maybe
> > > > use bdi_thresh/2 a few times, but it generally didn't seem to make much
> > > > of a difference.
> > > 
> > > One possible difference is, the process may end up waiting longer time
> > > in order to sync write_chunk pages and quit the throttle. This could
> > > hurt the responsiveness of the throttled process.
> > 
> > Well, that's all because this congestion_wait stuff is borken..
> > 
> 
> I'd suggest retesting with a new baseline against the code in Linus' git
> today.  Overall I think the change to make balance_dirty_pages() sleep
> instead of kick more IO out is a very good one.  It helps in most
> workloads here.
> 
> The congestion_wait() from 2.6.31 may just be too long to sleep waiting
> for progress on very fast IO rigs.  Try switching to
> schedule_timeout_interruptible(1);

Jens' per-bdi writeback has another improvement. In 2.6.31, when
superblocks A and B both have 100000 dirty pages, it will first
exhaust A's 100000 dirty pages before going on to sync B's.
In latest git, A and B will roughly make progress at the same time.

So for 2.6.31 without this patch, it is possible for pdflush to sync
A's most dirty pages and for balance_dirty_pages() to sync B's most
dirty pages because B is over its bdi thresh.

Thanks,
Fengguang
