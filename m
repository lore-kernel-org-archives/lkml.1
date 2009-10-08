Return-Path: <linux-kernel-owner+w=401wt.eu-S1755208AbZJHICa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208AbZJHICa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 04:02:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754775AbZJHIC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 04:02:29 -0400
Received: from viefep17-int.chello.at ([62.179.121.37]:18219 "EHLO
	viefep17-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754636AbZJHIC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 04:02:26 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 18/45] writeback: introduce wait queue for
 balance_dirty_pages()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       Christoph Hellwig <hch@infradead.org>,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Li Shaohua <shaohua.li@intel.com>,
       Myklebust Trond <Trond.Myklebust@netapp.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       Jan Kara <jack@suse.cz>, Nick Piggin <npiggin@suse.de>,
       linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20091008100159.fb6770cf.kamezawa.hiroyu@jp.fujitsu.com>
References: <20091007073818.318088777@intel.com>
	 <20091007074903.422089703@intel.com>
	 <20091008100159.fb6770cf.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain
Date: Thu, 08 Oct 2009 10:05:26 +0200
Message-Id: <1254989126.26976.258.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-08 at 10:01 +0900, KAMEZAWA Hiroyuki wrote:

> May I ask a question ? (maybe not directly related to this patch itself, sorry)
> 
> Recent works as "writeback: switch to per-bdi threads for flushing data"
> removed congestion_wait() from balance_dirty_pages() and added
> schedule_timeout_interruptible(). 
> 
> And this one replaces it with wake_up+wait_queue.
> 
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

Ah, I think you've got a good point, we need a io_schedule() there.



