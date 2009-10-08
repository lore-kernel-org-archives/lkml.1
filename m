Return-Path: <linux-kernel-owner+w=401wt.eu-S1755824AbZJHCnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824AbZJHCnr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 22:43:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755253AbZJHCnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 22:43:47 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59507 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754900AbZJHCnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 22:43:46 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 8 Oct 2009 11:40:37 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
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
Message-Id: <20091008114037.56f78b0e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20091008015822.GB14224@localhost>
References: <20091007073818.318088777@intel.com>
	<20091007074903.422089703@intel.com>
	<20091008100159.fb6770cf.kamezawa.hiroyu@jp.fujitsu.com>
	<20091008015822.GB14224@localhost>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Oct 2009 09:58:22 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:
> On Thu, Oct 08, 2009 at 09:01:59AM +0800, KAMEZAWA Hiroyuki wrote:
> > IIUC, "iowait" cpustat data was calculated by runqueue->nr_iowait as
> > == kernel/schec.c
> > void account_idle_time(cputime_t cputime)
> > {
> >         struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
> >         cputime64_t cputime64 = cputime_to_cputime64(cputime);
> >         struct rq *rq = this_rq();
> > 
> >         if (atomic_read(&rq->nr_iowait) > 0)
> >                 cpustat->iowait = cputime64_add(cpustat->iowait, cputime64);
> >         else
> >                 cpustat->idle = cputime64_add(cpustat->idle, cputime64);
> > }
> > ==
> > Then, for showing "cpu is in iowait", runqueue->nr_iowait should be modified
> > at some places. In old kernel, congestion_wait() at el did that by calling
> > io_schedule_timeout().
> > 
> > How this runqueue->nr_iowait is handled now ?
> 
> Good question. io_schedule() has an old comment for throttling IO wait:
> 
>          * But don't do that if it is a deliberate, throttling IO wait (this task
>          * has set its backing_dev_info: the queue against which it should throttle)
>          */
>         void __sched io_schedule(void)
> 
> So it looks both Jens' and this patch behaves right in ignoring the
> iowait accounting for balance_dirty_pages() :)
> 
Thank you for clarification.
Then, hmm, %iotwait (which 'top' shows) didn't work as desgined and we need
to update throttle_vm_writeout() and some in vmscan.c. Thanks for input.

BTW, I'm glad if I can know "how many threads/ios are throttoled now" per bdi.

Regards,
-Kame






