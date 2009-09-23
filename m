Return-Path: <linux-kernel-owner+w=401wt.eu-S1754073AbZIWDHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073AbZIWDHR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 23:07:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753860AbZIWDHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 23:07:16 -0400
Received: from mga03.intel.com ([143.182.124.21]:62540 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753846AbZIWDHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 23:07:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,435,1249282800"; 
   d="scan'208";a="190598936"
Date: Wed, 23 Sep 2009 11:07:07 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "richard@rsk.demon.co.uk" <richard@rsk.demon.co.uk>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>
Subject: Re: regression in page writeback
Message-ID: <20090923030707.GA26530@localhost>
References: <1253608335.8439.283.camel@twins> <20090922155259.GL10825@think> <20090923002220.GA6382@localhost> <20090922175452.d66400dd.akpm@linux-foundation.org> <20090923011758.GC6382@localhost> <20090922182832.28e7f73a.akpm@linux-foundation.org> <20090923013236.GA10885@localhost> <20090922184726.b3669515.akpm@linux-foundation.org> <20090923020104.GA11918@localhost> <20090922190915.a472fb7c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090922190915.a472fb7c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 23, 2009 at 10:09:15AM +0800, Andrew Morton wrote:
> On Wed, 23 Sep 2009 10:01:04 +0800 Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> > > If there's still outstanding dirty data for any of those queues, both
> > > wb_kupdate() and background_writeout() will take a teeny sleep and then
> > > will re-poll the queues.
> > > 
> > > Did that logic get broken?
> > 
> > No, but the "teeny sleep" is normally much smaller. When io queue is
> > not congested, every io completion event will wakeup the congestion
> > waiters. Also A's event could wake up B's waiters.
> > 
> > __freed_request() always calls blk_clear_queue_congested() if under
> > congestion threshold which in turn wakes up congestion waiters:
> > 
> >         if (rl->count[sync] < queue_congestion_off_threshold(q))
> >                 blk_clear_queue_congested(q, sync);
> > 
> 
> Yes.  Have any problems been demonstrated due to that?

Hmm, I was merely clarifying a fact.

Chris Mason listed some reasons to convert the congestion_wait() based
polls to the some queue waiting:
 
  http://lkml.org/lkml/2009/9/8/210

My impression is, it changed obviously too fast without enough discussions.

> And what's _sufficiently_ wrong with that to justify adding potentially
> thousands of kernel threads?  It was always a design objective to avoid
> doing that.

Yeah, the number of threads could be a problem. 

I guess the per-bdi threads and congestion_wait are mostly two
independent changes.  congestion_wait is not the reason to do per-bdi
threads.  Just that Jens piggy backed some changes to congestion_wait.

Thanks,
Fengguang
