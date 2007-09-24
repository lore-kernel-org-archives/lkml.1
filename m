Return-Path: <linux-kernel-owner+w=401wt.eu-S1755814AbXIXGVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814AbXIXGVg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 02:21:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751436AbXIXGV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 02:21:28 -0400
Received: from mga03.intel.com ([143.182.124.21]:9676 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751203AbXIXGV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 02:21:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,289,1186383600"; 
   d="scan'208";a="285239531"
Date: Sun, 23 Sep 2007 23:21:26 -0700 (PDT)
From: Tong Li <tong.n.li@intel.com>
X-X-Sender: tongli@tongli.jf.intel.com
To: Mike Galbraith <efault@gmx.de>
cc: Ingo Molnar <mingo@elte.hu>, dimm <dmitry.adamushko@gmail.com>,
       linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [git] CFS-devel, group scheduler, fixes
In-Reply-To: <1190531662.11524.15.camel@Homer.simpson.net>
Message-ID: <Pine.LNX.4.64.0709232259150.23861@tongli.jf.intel.com>
References: <1190144190.5204.24.camel@earth> <20070918201622.GA1632@elte.hu>
  <Pine.LNX.4.64.0709182250120.9990@tongli.jf.intel.com> 
 <1190183324.9737.7.camel@Homer.simpson.net>  <1190188261.9185.21.camel@Homer.simpson.net>
  <1190191368.8687.5.camel@Homer.simpson.net>  <Pine.LNX.4.64.0709190944560.11561@tongli.jf.intel.com>
  <1190264114.6411.4.camel@Homer.simpson.net>  <1190272507.27867.20.camel@Homer.simpson.net>
  <20070920075155.GA31641@elte.hu>  <1190275870.9232.6.camel@Homer.simpson.net>
  <Pine.LNX.4.64.0709212018480.16240@tongli.jf.intel.com> 
 <1190455308.7404.19.camel@Homer.simpson.net> <1190531662.11524.15.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Sep 2007, Mike Galbraith wrote:

> On Sat, 2007-09-22 at 12:01 +0200, Mike Galbraith wrote:
>> On Fri, 2007-09-21 at 20:27 -0700, Tong Li wrote:
>>> Mike,
>>>
>>> Could you try this patch to see if it solves the latency problem?
>>
>> No, but it helps some when running two un-pinned busy loops, one at nice
>> 0, and the other at nice 19.  Yesterday I hit latencies of up to 1.2
>> _seconds_ doing this, and logging sched_debug and /proc/`pidof
>> Xorg`/sched from SCHED_RR shells.
>
> Looking at a log (snippet attached) from this morning with the last hunk
> of your patch still intact, it looks like min_vruntime is being modified
> after a task is queued.  If you look at the snippet, you'll see the nice
> 19 bash busy loop on CPU1 with a vruntime of 3010385.345325, and one
> second later on CPU1 with it's vruntime at 2814952.425082, but
> min_vruntime is 3061874.838356.

I think this could be what was happening: between the two seconds, CPU 0 
becomes idle and it pulls the nice 19 task over via pull_task(), which 
calls set_task_cpu(), which changes the task's vruntime to the current 
min_vruntime of CPU 0 (in my patch). Then, after set_task_cpu(), CPU 0 
calls activate_task(), which calls enqueue_task() and in turn 
update_curr(). Now, nr_running on CPU 0 is 0, so sync_vruntime() gets 
called and CPU 0's min_vruntime gets synced to the system max. Thus, the 
nice 19 task now has a vruntime less than CPU 0's min_vruntime. I think 
this can be fixed by adding the following code in set_task_cpu() before we 
adjust p->vruntime:

if (!new_rq->cfs.nr_running)
 	sync_vruntime(new_rq);

> static void sync_vruntime(struct cfs_rq *cfs_rq)
> {
> 	struct rq *rq;
> -	int cpu;
> +	int cpu, wrote = 0;
>
> 	for_each_online_cpu(cpu) {
> 		rq = &per_cpu(runqueues, cpu);
> +		if (spin_is_locked(&rq->lock))
> +			continue;
> +		smp_wmb();
> 		cfs_rq->min_vruntime = max_vruntime(cfs_rq->min_vruntime,
> 				rq->cfs.min_vruntime);
> +		wrote++;
> 	}
> -	schedstat_inc(cfs_rq, nr_sync_min_vruntime);
> +	if (wrote)
> +		schedstat_inc(cfs_rq, nr_sync_min_vruntime);
> }

I think this rq->lock check works because it prevents the above scenario 
(CPU 0 is in pull_task so it must hold the rq lock). But my concern is 
that it may be too conservative, since sync_vruntime is called by 
update_curr, which mostly gets called in enqueue_task() and 
dequeue_task(), both of which are often invoked with the rq lock being 
held. Thus, if we don't allow sync_vruntime when rq lock is held, the sync 
will occur much less frequently and thus weaken cross-CPU fairness.

   tong
