Return-Path: <linux-kernel-owner+w=401wt.eu-S1752984AbZIWOCM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984AbZIWOCM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 10:02:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752988AbZIWOCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 10:02:11 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:37749 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919AbZIWOCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 10:02:08 -0400
Date: Wed, 23 Sep 2009 10:00:58 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "richard@rsk.demon.co.uk" <richard@rsk.demon.co.uk>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>
Subject: Re: regression in page writeback
Message-ID: <20090923140058.GA2794@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Wu Fengguang <fengguang.wu@intel.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	"Li, Shaohua" <shaohua.li@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"richard@rsk.demon.co.uk" <richard@rsk.demon.co.uk>,
	"jens.axboe@oracle.com" <jens.axboe@oracle.com>
References: <1253608335.8439.283.camel@twins>
 <20090922155259.GL10825@think>
 <20090923002220.GA6382@localhost>
 <20090922175452.d66400dd.akpm@linux-foundation.org>
 <20090923011758.GC6382@localhost>
 <20090922182832.28e7f73a.akpm@linux-foundation.org>
 <20090923014500.GA11076@localhost>
 <20090922185941.1118e011.akpm@linux-foundation.org>
 <20090923022622.GB11918@localhost>
 <20090922193622.42c00012.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090922193622.42c00012.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: abhmt013.oracle.com [141.146.116.22]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4ABA2A1E.0103:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 22, 2009 at 07:36:22PM -0700, Andrew Morton wrote:
> On Wed, 23 Sep 2009 10:26:22 +0800 Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> > On Wed, Sep 23, 2009 at 09:59:41AM +0800, Andrew Morton wrote:
> > > On Wed, 23 Sep 2009 09:45:00 +0800 Wu Fengguang <fengguang.wu@intel.com> wrote:
> > > 
> > > > On Wed, Sep 23, 2009 at 09:28:32AM +0800, Andrew Morton wrote:
> > > > > On Wed, 23 Sep 2009 09:17:58 +0800 Wu Fengguang <fengguang.wu@intel.com> wrote:
> > > > > 
> > > > > > On Wed, Sep 23, 2009 at 08:54:52AM +0800, Andrew Morton wrote:
> > > > > > > On Wed, 23 Sep 2009 08:22:20 +0800 Wu Fengguang <fengguang.wu@intel.com> wrote:
> > > > > > > 
> > > > > > > > Jens' per-bdi writeback has another improvement. In 2.6.31, when
> > > > > > > > superblocks A and B both have 100000 dirty pages, it will first
> > > > > > > > exhaust A's 100000 dirty pages before going on to sync B's.
> > > > > > > 
> > > > > > > That would only be true if someone broke 2.6.31.  Did they?
> > > > > > > 
> > > > > > > SYSCALL_DEFINE0(sync)
> > > > > > > {
> > > > > > > 	wakeup_pdflush(0);
> > > > > > > 	sync_filesystems(0);
> > > > > > > 	sync_filesystems(1);
> > > > > > > 	if (unlikely(laptop_mode))
> > > > > > > 		laptop_sync_completion();
> > > > > > > 	return 0;
> > > > > > > }
> > > > > > > 
> > > > > > > the sync_filesystems(0) is supposed to non-blockingly start IO against
> > > > > > > all devices.  It used to do that correctly.  But people mucked with it
> > > > > > > so perhaps it no longer does.
> > > > > > 
> > > > > > I'm referring to writeback_inodes(). Each invocation of which (to sync
> > > > > > 4MB) will do the same iteration over superblocks A => B => C ... So if
> > > > > > A has dirty pages, it will always be served first.
> > > > > > 
> > > > > > So if wbc->bdi == NULL (which is true for kupdate/background sync), it
> > > > > > will have to first exhaust A before going on to B and C.
> > > > > 
> > > > > But that works OK.  We fill the first device's queue, then it gets
> > > > > congested and sync_sb_inodes() does nothing and we advance to the next
> > > > > queue.
> > > > 
> > > > So in common cases "exhaust" is a bit exaggerated, but A does receive
> > > > much more opportunity than B. Computation resources for IO submission
> > > > are unbalanced for A, and there are pointless overheads in rechecking A.
> > > 
> > > That's unquantified handwaving.  One CPU can do a *lot* of IO.
> > 
> > Yes.. I had the impression that the writeback submission can be pretty slow.
> > It should be because of the congestion_wait. Now that it is removed,
> > things are going faster when queue is not full.
> 
> What?  The wait is short.  The design intent there is that we repoll
> all previously-congested queues well before they start to run empty.

The congestion code was the big reason I got behind Jens' patches.  When
working on btrfs I tried to tune the existing congestion based setup to
scale well.  What we had before is basically a poll interface hiding
behind a queue flag and a wait.  

The only place that actually honors the congestion flag is pdflush.
It's trivial to get pdflush backed up and make it sit down without
making any progress because once the queue congests, pdflush goes away.

Nothing stops other procs from keeping the queue congested forever.
This can only be fixed by making everyone wait for congestion, at which
point we might as well wait for requests.

Here are some graphs comparing 2.6.31 and 2.6.31 with Jens' latest code.
The workload is two procs doing streaming writes to 32GB files.  I've
used deadline and bumped nr_requests to 2048, so pdflush should be able
to do a significant amount of work between congestion cycles.

The hardware is 5 sata drives pushed into an LVM stripe set.

http://oss.oracle.com/~mason/seekwatcher/bdi-writeback/xfs-streaming-compare.png
http://oss.oracle.com/~mason/seekwatcher/bdi-writeback/btrfs-streaming-compare.png

In the mainline graphs, pdflush is actually doing the vast majority of
the IO thanks to Richard's fix:

http://oss.oracle.com/~mason/seekwatcher/bdi-writeback/xfs-mainline-per-process.png

We can see there are two different pdflush procs hopping in and out
of the work.  This isn't a huge problem, except that we're also hopping
between files.

I don't think this is because anyone broke pdflush, I think this is
because very fast hardware goes from congested to uncongested 
very quickly, even when we bump nr_requests to 2048 like I did in the
graphs above.

The pdflush congestion backoffs skip the batching optimizations done by
the elevator.  pdflush could easily have waited in get_request_wait,
been given a nice fat batch of requests and then said oh no, the queue
is congested, I'll just sleep for a while without submitting any more
IO.

The congestion checks prevent any attempts from the filesystem to write
a whole extent (or a large portion of an extent) at a time.

The pdflush system tried to be async, but at the end of the day it
wasn't async enough to effectively drive the hardware.  Threads did get
tied up in FS locking, metadata reads and get_request_wait.  The end
result is that not enough time was spent keeping all the drives on the
box busy.

This isn't handwaving, my harddrive is littered with pdflush patches
trying to make it scale well, and I just couldn't work it out.

-chris

