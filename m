Return-Path: <linux-kernel-owner+w=401wt.eu-S1753979AbZIWChX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979AbZIWChX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 22:37:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753891AbZIWChW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 22:37:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46038 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753883AbZIWChW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 22:37:22 -0400
Date: Tue, 22 Sep 2009 19:36:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "richard@rsk.demon.co.uk" <richard@rsk.demon.co.uk>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>
Subject: Re: regression in page writeback
Message-Id: <20090922193622.42c00012.akpm@linux-foundation.org>
In-Reply-To: <20090923022622.GB11918@localhost>
References: <1253606965.8439.281.camel@twins>
	<20090922082427.GA24888@localhost>
	<1253608335.8439.283.camel@twins>
	<20090922155259.GL10825@think>
	<20090923002220.GA6382@localhost>
	<20090922175452.d66400dd.akpm@linux-foundation.org>
	<20090923011758.GC6382@localhost>
	<20090922182832.28e7f73a.akpm@linux-foundation.org>
	<20090923014500.GA11076@localhost>
	<20090922185941.1118e011.akpm@linux-foundation.org>
	<20090923022622.GB11918@localhost>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Sep 2009 10:26:22 +0800 Wu Fengguang <fengguang.wu@intel.com> wrote:

> On Wed, Sep 23, 2009 at 09:59:41AM +0800, Andrew Morton wrote:
> > On Wed, 23 Sep 2009 09:45:00 +0800 Wu Fengguang <fengguang.wu@intel.com> wrote:
> > 
> > > On Wed, Sep 23, 2009 at 09:28:32AM +0800, Andrew Morton wrote:
> > > > On Wed, 23 Sep 2009 09:17:58 +0800 Wu Fengguang <fengguang.wu@intel.com> wrote:
> > > > 
> > > > > On Wed, Sep 23, 2009 at 08:54:52AM +0800, Andrew Morton wrote:
> > > > > > On Wed, 23 Sep 2009 08:22:20 +0800 Wu Fengguang <fengguang.wu@intel.com> wrote:
> > > > > > 
> > > > > > > Jens' per-bdi writeback has another improvement. In 2.6.31, when
> > > > > > > superblocks A and B both have 100000 dirty pages, it will first
> > > > > > > exhaust A's 100000 dirty pages before going on to sync B's.
> > > > > > 
> > > > > > That would only be true if someone broke 2.6.31.  Did they?
> > > > > > 
> > > > > > SYSCALL_DEFINE0(sync)
> > > > > > {
> > > > > > 	wakeup_pdflush(0);
> > > > > > 	sync_filesystems(0);
> > > > > > 	sync_filesystems(1);
> > > > > > 	if (unlikely(laptop_mode))
> > > > > > 		laptop_sync_completion();
> > > > > > 	return 0;
> > > > > > }
> > > > > > 
> > > > > > the sync_filesystems(0) is supposed to non-blockingly start IO against
> > > > > > all devices.  It used to do that correctly.  But people mucked with it
> > > > > > so perhaps it no longer does.
> > > > > 
> > > > > I'm referring to writeback_inodes(). Each invocation of which (to sync
> > > > > 4MB) will do the same iteration over superblocks A => B => C ... So if
> > > > > A has dirty pages, it will always be served first.
> > > > > 
> > > > > So if wbc->bdi == NULL (which is true for kupdate/background sync), it
> > > > > will have to first exhaust A before going on to B and C.
> > > > 
> > > > But that works OK.  We fill the first device's queue, then it gets
> > > > congested and sync_sb_inodes() does nothing and we advance to the next
> > > > queue.
> > > 
> > > So in common cases "exhaust" is a bit exaggerated, but A does receive
> > > much more opportunity than B. Computation resources for IO submission
> > > are unbalanced for A, and there are pointless overheads in rechecking A.
> > 
> > That's unquantified handwaving.  One CPU can do a *lot* of IO.
> 
> Yes.. I had the impression that the writeback submission can be pretty slow.
> It should be because of the congestion_wait. Now that it is removed,
> things are going faster when queue is not full.

What?  The wait is short.  The design intent there is that we repoll
all previously-congested queues well before they start to run empty.

> > > > If a device has more than a queue's worth of dirty data then we'll
> > > > probably leave some of that dirty memory un-queued, so there's some
> > > > lack of concurrency in that situation.
> > > 
> > > Good insight.
> > 
> > It was wrong.  See the other email.
> 
> No your first insight is correct. Because the (unnecessary) teeny
> sleeps is independent of the A=>B=>C traversing order. Only queue
> congestion could help skip A.

The sleeps are completely necessary!  Otherwise we end up busywaiting.

After the sleep we repoll all queues.
