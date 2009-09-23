Return-Path: <linux-kernel-owner+w=401wt.eu-S1753069AbZIWJT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069AbZIWJT5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 05:19:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbZIWJT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 05:19:57 -0400
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:42705 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751457AbZIWJT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 05:19:56 -0400
Subject: Re: regression in page writeback
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>
In-Reply-To: <20090922185941.1118e011.akpm@linux-foundation.org>
References: <1253601612.8439.274.camel@twins>
	 <20090922080505.GB9192@localhost> <1253606965.8439.281.camel@twins>
	 <20090922082427.GA24888@localhost> <1253608335.8439.283.camel@twins>
	 <20090922155259.GL10825@think> <20090923002220.GA6382@localhost>
	 <20090922175452.d66400dd.akpm@linux-foundation.org>
	 <20090923011758.GC6382@localhost>
	 <20090922182832.28e7f73a.akpm@linux-foundation.org>
	 <20090923014500.GA11076@localhost>
	 <20090922185941.1118e011.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 23 Sep 2009 10:19:58 +0100
Message-Id: <1253697598.2277.13.camel@castor>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-22 at 18:59 -0700, Andrew Morton wrote:
> On Wed, 23 Sep 2009 09:45:00 +0800 Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> > On Wed, Sep 23, 2009 at 09:28:32AM +0800, Andrew Morton wrote:
> > > On Wed, 23 Sep 2009 09:17:58 +0800 Wu Fengguang <fengguang.wu@intel.com> wrote:
> > > 
> > > > On Wed, Sep 23, 2009 at 08:54:52AM +0800, Andrew Morton wrote:
> > > > > On Wed, 23 Sep 2009 08:22:20 +0800 Wu Fengguang <fengguang.wu@intel.com> wrote:
> > > > > 
> > > > > > Jens' per-bdi writeback has another improvement. In 2.6.31, when
> > > > > > superblocks A and B both have 100000 dirty pages, it will first
> > > > > > exhaust A's 100000 dirty pages before going on to sync B's.
> > > > > 
> > > > > That would only be true if someone broke 2.6.31.  Did they?
> > > > > 
> > > > > SYSCALL_DEFINE0(sync)
> > > > > {
> > > > > 	wakeup_pdflush(0);
> > > > > 	sync_filesystems(0);
> > > > > 	sync_filesystems(1);
> > > > > 	if (unlikely(laptop_mode))
> > > > > 		laptop_sync_completion();
> > > > > 	return 0;
> > > > > }
> > > > > 
> > > > > the sync_filesystems(0) is supposed to non-blockingly start IO against
> > > > > all devices.  It used to do that correctly.  But people mucked with it
> > > > > so perhaps it no longer does.
> > > > 
> > > > I'm referring to writeback_inodes(). Each invocation of which (to sync
> > > > 4MB) will do the same iteration over superblocks A => B => C ... So if
> > > > A has dirty pages, it will always be served first.
> > > > 
> > > > So if wbc->bdi == NULL (which is true for kupdate/background sync), it
> > > > will have to first exhaust A before going on to B and C.
> > > 
> > > But that works OK.  We fill the first device's queue, then it gets
> > > congested and sync_sb_inodes() does nothing and we advance to the next
> > > queue.
> > 
> > So in common cases "exhaust" is a bit exaggerated, but A does receive
> > much more opportunity than B. Computation resources for IO submission
> > are unbalanced for A, and there are pointless overheads in rechecking A.
> 
> That's unquantified handwaving.  One CPU can do a *lot* of IO.
> 
> > > If a device has more than a queue's worth of dirty data then we'll
> > > probably leave some of that dirty memory un-queued, so there's some
> > > lack of concurrency in that situation.
> > 
> > Good insight.
> 
> It was wrong.  See the other email.
> 
> > That possibly explains one major factor of the
> > performance gains of Jens' per-bdi writeback.
> 
> I've yet to see any believable and complete explanation for these
> gains.  I've asked about these things multiple times and nothing happened.
> 
> I suspect that what happened over time was that previously-working code
> got broken, then later people noticed the breakage but failed to
> analyse and fix it in favour of simply ripping everything out and
> starting again.
> 
> So for the want of analysing and fixing several possible regressions,
> we've tossed away some very sensitive core kernel code which had tens
> of millions of machine-years testing.  I find this incredibly rash.

FWIW I agree, I don't think the new per-bdi code has had enough testing
yet.

On my desktop setup I have not been able to measure any significant
change in performance of linear writes.

I am concerned that the background writeout no longer stops when it
reaches the background threshold, as balance_dirty_pages requests all
dirty pages to be written. No doubt this is good for large linear writes
but what about more random write workloads? 

regards
Richard

