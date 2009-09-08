Return-Path: <linux-kernel-owner+w=401wt.eu-S1754336AbZIHLlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336AbZIHLlj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 07:41:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754111AbZIHLli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 07:41:38 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41678 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093AbZIHLlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 07:41:37 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [rfc] lru_add_drain_all() vs isolation
Cc: kosaki.motohiro@jp.fujitsu.com, Mike Galbraith <efault@gmx.de>,
       Ingo Molnar <mingo@elte.hu>, linux-mm <linux-mm@kvack.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Oleg Nesterov <onestero@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1252405209.7746.38.camel@twins>
References: <20090908190148.0CC9.A69D9226@jp.fujitsu.com> <1252405209.7746.38.camel@twins>
Message-Id: <20090908193712.0CCF.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  8 Sep 2009 20:41:36 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 2009-09-08 at 19:06 +0900, KOSAKI Motohiro wrote:
> > > On Tue, 2009-09-08 at 08:56 +0900, KOSAKI Motohiro wrote:
> > > > Hi Peter,
> > > > 
> > > > > On Mon, 2009-09-07 at 10:17 +0200, Mike Galbraith wrote:
> > > > > 
> > > > > > [  774.651779] SysRq : Show Blocked State
> > > > > > [  774.655770]   task                        PC stack   pid father
> > > > > > [  774.655770] evolution.bin D ffff8800bc1575f0     0  7349   6459 0x00000000
> > > > > > [  774.676008]  ffff8800bc3c9d68 0000000000000086 ffff8800015d9340 ffff8800bb91b780
> > > > > > [  774.676008]  000000000000dd28 ffff8800bc3c9fd8 0000000000013340 0000000000013340
> > > > > > [  774.676008]  00000000000000fd ffff8800015d9340 ffff8800bc1575f0 ffff8800bc157888
> > > > > > [  774.676008] Call Trace:
> > > > > > [  774.676008]  [<ffffffff812c4a11>] schedule_timeout+0x2d/0x20c
> > > > > > [  774.676008]  [<ffffffff812c4891>] wait_for_common+0xde/0x155
> > > > > > [  774.676008]  [<ffffffff8103f1cd>] ? default_wake_function+0x0/0x14
> > > > > > [  774.676008]  [<ffffffff810c0e63>] ? lru_add_drain_per_cpu+0x0/0x10
> > > > > > [  774.676008]  [<ffffffff810c0e63>] ? lru_add_drain_per_cpu+0x0/0x10
> > > > > > [  774.676008]  [<ffffffff812c49ab>] wait_for_completion+0x1d/0x1f
> > > > > > [  774.676008]  [<ffffffff8105fdf5>] flush_work+0x7f/0x93
> > > > > > [  774.676008]  [<ffffffff8105f870>] ? wq_barrier_func+0x0/0x14
> > > > > > [  774.676008]  [<ffffffff81060109>] schedule_on_each_cpu+0xb4/0xed
> > > > > > [  774.676008]  [<ffffffff810c0c78>] lru_add_drain_all+0x15/0x17
> > > > > > [  774.676008]  [<ffffffff810d1dbd>] sys_mlock+0x2e/0xde
> > > > > > [  774.676008]  [<ffffffff8100bc1b>] system_call_fastpath+0x16/0x1b
> > > > > 
> > > > > FWIW, something like the below (prone to explode since its utterly
> > > > > untested) should (mostly) fix that one case. Something similar needs to
> > > > > be done for pretty much all machine wide workqueue thingies, possibly
> > > > > also flush_workqueue().
> > > > 
> > > > Can you please explain reproduce way and problem detail?
> > > > 
> > > > AFAIK, mlock() call lru_add_drain_all() _before_ grab semaphoe. Then,
> > > > it doesn't cause any deadlock.
> > > 
> > > Suppose you have 2 cpus, cpu1 is busy doing a SCHED_FIFO-99 while(1),
> > > cpu0 does mlock()->lru_add_drain_all(), which does
> > > schedule_on_each_cpu(), which then waits for all cpus to complete the
> > > work. Except that cpu1, which is busy with the RT task, will never run
> > > keventd until the RT load goes away.
> > > 
> > > This is not so much an actual deadlock as a serious starvation case.
> > 
> > This seems flush_work vs RT-thread problem, not only lru_add_drain_all().
> > Why other workqueue flusher doesn't affect this issue?
> 
> flush_work() will only flush workqueues on which work has been enqueued
> as Oleg pointed out.
> 
> The problem is with lru_add_drain_all() enqueueing work on all
> workqueues.

Thank you for kindly explanation. I gradually become to understand this isssue.
Yes, lru_add_drain_all() use schedule_on_each_cpu() and it have following code

        for_each_online_cpu(cpu)
                flush_work(per_cpu_ptr(works, cpu));

However, I don't think your approach solve this issue.
lru_add_drain_all() flush lru_add_pvecs and lru_rotate_pvecs.

lru_add_pvecs is accounted when
  - lru move
      e.g. read(2), write(2), page fault, vmscan, page migration, et al

lru_rotate_pves is accounted when
  - page writeback

IOW, if RT-thread call write(2) syscall or page fault, we face the same
problem. I don't think we can assume RT-thread don't make page fault....

hmm, this seems difficult problem. I guess any mm code should use
schedule_on_each_cpu(). I continue to think this issue awhile.


> There is nothing that makes lru_add_drain_all() the only such site, its
> the one Mike posted to me, and my patch was a way to deal with that.

Well, schedule_on_each_cpu() is very limited used function.
Practically we can ignore other caller.


> I also explained that its not only RT related in that the HPC folks also
> want to avoid unneeded work -- for them its not starvation but a
> performance issue.

I think you talked about OS jitter issue. if so, I don't think this issue
make serious problem.  OS jitter mainly be caused by periodic action
 (e.g. tick update, timer, vmstat update). it's because
	little-delay x plenty-times = large-delay

lru_add_drain_all() is called from very limited point. e.g. mlock, shm-lock,
page-migration, memory-hotplug. all caller is not periodic.


> In generic we should avoid doing work when there is no work to be done.

Probably. but I'm not sure ;)



