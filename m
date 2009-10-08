Return-Path: <linux-kernel-owner+w=401wt.eu-S1757137AbZJHB7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757137AbZJHB7R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 21:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757100AbZJHB7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 21:59:16 -0400
Received: from mga03.intel.com ([143.182.124.21]:33683 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757096AbZJHB7P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 21:59:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,522,1249282800"; 
   d="scan'208";a="196353749"
Date: Thu, 8 Oct 2009 09:58:22 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       Christoph Hellwig <hch@infradead.org>,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       Myklebust Trond <Trond.Myklebust@netapp.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       Jan Kara <jack@suse.cz>, Nick Piggin <npiggin@suse.de>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 18/45] writeback: introduce wait queue for
	balance_dirty_pages()
Message-ID: <20091008015822.GB14224@localhost>
References: <20091007073818.318088777@intel.com> <20091007074903.422089703@intel.com> <20091008100159.fb6770cf.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091008100159.fb6770cf.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 08, 2009 at 09:01:59AM +0800, KAMEZAWA Hiroyuki wrote:
> tatus: RO
> Content-Length: 12481
> Lines: 332
> 
> On Wed, 07 Oct 2009 15:38:36 +0800
> Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> > As proposed by Chris, Dave and Jan, let balance_dirty_pages() wait for
> > the per-bdi flusher to writeback enough pages for it, instead of
> > starting foreground writeback by itself. By doing so we harvest two
> > benefits:
> > - avoid concurrent writeback of multiple inodes (Dave Chinner)
> >   If every thread doing writes and being throttled start foreground
> >   writeback, it leads to N IO submitters from at least N different
> >   inodes at the same time, end up with N different sets of IO being
> >   issued with potentially zero locality to each other, resulting in
> >   much lower elevator sort/merge efficiency and hence we seek the disk
> >   all over the place to service the different sets of IO.
> >   OTOH, if there is only one submission thread, it doesn't jump between
> >   inodes in the same way when congestion clears - it keeps writing to
> >   the same inode, resulting in large related chunks of sequential IOs
> >   being issued to the disk. This is more efficient than the above
> >   foreground writeback because the elevator works better and the disk
> >   seeks less.
> > - avoid one constraint torwards huge per-file nr_to_write
> >   The write_chunk used by balance_dirty_pages() should be small enough to
> >   prevent user noticeable one-shot latency. Ie. each sleep/wait inside
> >   balance_dirty_pages() shall be small enough. When it starts its own
> >   writeback, it must specify a small nr_to_write. The throttle wait queue
> >   removes this dependancy by the way.
> >
> 
> May I ask a question ? (maybe not directly related to this patch itself, sorry)

Sure :)

> Recent works as "writeback: switch to per-bdi threads for flushing data"
> removed congestion_wait() from balance_dirty_pages() and added
> schedule_timeout_interruptible().
> 
> And this one replaces it with wake_up+wait_queue.

Right. 

> IIUC, "iowait" cpustat data was calculated by runqueue->nr_iowait as
> == kernel/schec.c
> void account_idle_time(cputime_t cputime)
> {
>         struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
>         cputime64_t cputime64 = cputime_to_cputime64(cputime);
>         struct rq *rq = this_rq();
> 
>         if (atomic_read(&rq->nr_iowait) > 0)
>                 cpustat->iowait = cputime64_add(cpustat->iowait, cputime64);
>         else
>                 cpustat->idle = cputime64_add(cpustat->idle, cputime64);
> }
> ==
> Then, for showing "cpu is in iowait", runqueue->nr_iowait should be modified
> at some places. In old kernel, congestion_wait() at el did that by calling
> io_schedule_timeout().
> 
> How this runqueue->nr_iowait is handled now ?

Good question. io_schedule() has an old comment for throttling IO wait:

         * But don't do that if it is a deliberate, throttling IO wait (this task
         * has set its backing_dev_info: the queue against which it should throttle)
         */
        void __sched io_schedule(void)

So it looks both Jens' and this patch behaves right in ignoring the
iowait accounting for balance_dirty_pages() :)

Thanks,
Fengguang

