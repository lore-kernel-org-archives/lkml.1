Return-Path: <linux-kernel-owner+w=401wt.eu-S1753709AbZIWBcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709AbZIWBcn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 21:32:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753557AbZIWBcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 21:32:43 -0400
Received: from mga03.intel.com ([143.182.124.21]:25922 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752966AbZIWBcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 21:32:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,434,1249282800"; 
   d="scan'208";a="190576594"
Date: Wed, 23 Sep 2009 09:32:36 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "richard@rsk.demon.co.uk" <richard@rsk.demon.co.uk>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>
Subject: Re: regression in page writeback
Message-ID: <20090923013236.GA10885@localhost>
References: <1253601612.8439.274.camel@twins> <20090922080505.GB9192@localhost> <1253606965.8439.281.camel@twins> <20090922082427.GA24888@localhost> <1253608335.8439.283.camel@twins> <20090922155259.GL10825@think> <20090923002220.GA6382@localhost> <20090922175452.d66400dd.akpm@linux-foundation.org> <20090923011758.GC6382@localhost> <20090922182832.28e7f73a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090922182832.28e7f73a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 23, 2009 at 09:28:32AM +0800, Andrew Morton wrote:
> On Wed, 23 Sep 2009 09:17:58 +0800 Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> > On Wed, Sep 23, 2009 at 08:54:52AM +0800, Andrew Morton wrote:
> > > On Wed, 23 Sep 2009 08:22:20 +0800 Wu Fengguang <fengguang.wu@intel.com> wrote:
> > > 
> > > > Jens' per-bdi writeback has another improvement. In 2.6.31, when
> > > > superblocks A and B both have 100000 dirty pages, it will first
> > > > exhaust A's 100000 dirty pages before going on to sync B's.
> > > 
> > > That would only be true if someone broke 2.6.31.  Did they?
> > > 
> > > SYSCALL_DEFINE0(sync)
> > > {
> > > 	wakeup_pdflush(0);
> > > 	sync_filesystems(0);
> > > 	sync_filesystems(1);
> > > 	if (unlikely(laptop_mode))
> > > 		laptop_sync_completion();
> > > 	return 0;
> > > }
> > > 
> > > the sync_filesystems(0) is supposed to non-blockingly start IO against
> > > all devices.  It used to do that correctly.  But people mucked with it
> > > so perhaps it no longer does.
> > 
> > I'm referring to writeback_inodes(). Each invocation of which (to sync
> > 4MB) will do the same iteration over superblocks A => B => C ... So if
> > A has dirty pages, it will always be served first.
> > 
> > So if wbc->bdi == NULL (which is true for kupdate/background sync), it
> > will have to first exhaust A before going on to B and C.
> 
> But that works OK.  We fill the first device's queue, then it gets
> congested and sync_sb_inodes() does nothing and we advance to the next
> queue.
> 
> If a device has more than a queue's worth of dirty data then we'll
> probably leave some of that dirty memory un-queued, so there's some
> lack of concurrency in that situation.

Yes, exactly if block device is not fast enough. In that case
balance_dirty_pages() may also kick in with non-NULL bdi.

Thanks,
Fengguang
