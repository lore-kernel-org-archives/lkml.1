Return-Path: <linux-kernel-owner+w=401wt.eu-S1753359AbZESEqB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359AbZESEqB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 00:46:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbZESEpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 00:45:54 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55702 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099AbZESEpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 00:45:53 -0400
Date: Tue, 19 May 2009 01:43:44 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
       paulus@samba.org, acme@redhat.com, a.p.zijlstra@chello.nl,
       vatsa@in.ibm.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: Fix counter inheritance
Message-ID: <20090519044344.GA21588@amt.cnet>
References: <tip-856d56b9e5de650a64a6c41c17aaed702b55d578@git.kernel.org> <20090517074310.GA12268@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090517074310.GA12268@elte.hu>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 17, 2009 at 09:43:10AM +0200, Ingo Molnar wrote:
> 
> * tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > Commit-ID:  856d56b9e5de650a64a6c41c17aaed702b55d578
> > Gitweb:     http://git.kernel.org/tip/856d56b9e5de650a64a6c41c17aaed702b55d578
> > Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> > AuthorDate: Fri, 15 May 2009 20:45:59 +0200
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Sun, 17 May 2009 07:52:24 +0200
> > 
> > perf_counter: Fix counter inheritance
> > 
> > Srivatsa Vaddagiri reported that a Java workload triggers this
> > warning in kernel/exit.c:
> > 
> >    WARN_ON_ONCE(!list_empty(&tsk->perf_counter_ctx.counter_list));
> > 
> > Add the inherited counter propagation on self-detach, this could
> > cause counter leaks and incomplete stats in threaded code like
> > the below:
> > 
> >   #include <pthread.h>
> >   #include <unistd.h>
> > 
> >   void *thread(void *arg)
> >   {
> >           sleep(5);
> >           return NULL;
> >   }
> > 
> >   void main(void)
> >   {
> >           pthread_t thr;
> >           pthread_create(&thr, NULL, thread, NULL);
> >   }
> > 
> > Reported-by: Srivatsa Vaddagiri <vatsa@in.ibm.com>
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Paul Mackerras <paulus@samba.org>
> > Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> > Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> > Cc: Marcelo Tosatti <mtosatti@redhat.com>
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > 
> > 
> > ---
> >  kernel/exit.c |    6 ++++++
> >  1 files changed, 6 insertions(+), 0 deletions(-)
> > 
> > diff --git a/kernel/exit.c b/kernel/exit.c
> > index 4741376..16d74f1 100644
> > --- a/kernel/exit.c
> > +++ b/kernel/exit.c
> > @@ -128,6 +128,12 @@ static void __exit_signal(struct task_struct *tsk)
> >  		sig = NULL; /* Marker for below. */
> >  	}
> >  
> > +	/*
> > +	 * Flush inherited counters to the parent - before the parent
> > +	 * gets woken up by child-exit notifications.
> > +	 */
> > +	perf_counter_exit_task(tsk);
> 
> Causes:
> 
> [  447.882292] BUG: sleeping function called from invalid context at kernel/mutex.c:94
> [  447.890094] in_atomic(): 0, irqs_disabled(): 1, pid: 23597, name: hackbench_pth
> [  447.897587] Pid: 23597, comm: hackbench_pth Not tainted 2.6.30-rc6-tip #188
> [  447.904678] Call Trace:
> [  447.907158]  [<ffffffff814cdd0b>] ? mutex_lock+0x15/0x37
> [  447.912518]  [<ffffffff8108f1e3>] ? perf_counter_exit_task+0x170/0x1e9
> [  447.919134]  [<ffffffff81046182>] ? release_task+0x22c/0x402
> [  447.924859]  [<ffffffff8104789d>] ? do_exit+0x655/0x6e7
> [  447.930144]  [<ffffffff810479ea>] ? complete_and_exit+0x0/0x16
> [  447.936054]  [<ffffffff8100baab>] ? system_call_fastpath+0x16/0x1b
> 
> when running:
> 
>    perf stat ./hackbench_pth 20
> 
> release_task() is a deep-atomic context, we cannot acquire a mutex 
> there. I'm not sure we can change that lock to a spinlock straight 
> away.
> 
> 	Ingo


Reverting this patch (0203026b58b4299ba7281c0b4b417207c1f05d0e) fixes
the following oops for me:

general protection fault: 0000 [#2] PREEMPT SMP DEBUG_PAGEALLOC
last sysfs file:
/sys/devices/system/cpu/cpu7/cache/index2/shared_cpu_map
CPU 2
Pid: 4648, comm: bash Tainted: G      D
2.6.30-rc6-tip-01582-g1acb813-dirty #6 PowerEdge 1900
RIP: 0010:[<ffffffff8029c492>]  [<ffffffff8029c492>]
list_del_counter+0x46/0xad
RSP: 0018:ffff88022e96fd58  EFLAGS: 00010296
RAX: dead000000200200 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff880229065448 RSI: ffff880229065390 RDI: ffff88021acd3bf0
RBP: ffff88022e96fd88 R08: dead000000200200 R09: ffff88022e96fcf8
R10: 0000000000000292 R11: 0000000000000282 R12: ffff88021acd3bf0
R13: ffff880229065390 R14: ffff880229064480 R15: ffff880229065438
FS:  00007f6456a656f0(0000) GS:ffff8800280b8000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000003697414948 CR3: 0000000228d76000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process bash (pid: 4648, threadinfo ffff88022e96e000, task
ffff88021c5d8640)
Stack:
 0000000000000287 0000000000000000 ffff88021acd3bf0 ffff880229064480
 ffff880229064480 ffff880229065438 ffff88022e96fdd8 ffffffff8029ddea
 000000000000e930 ffff880229065438 ffff880229065390 0000000000000000
Call Trace:
 [<ffffffff8029ddea>] perf_counter_exit_task+0xbc/0x221
 [<ffffffff80243f2f>] wait_consider_task+0x30d/0x971
 [<ffffffff802446c8>] ? do_wait+0x135/0x403
 [<ffffffff805f30a7>] ? _read_lock+0x1b/0x4b
 [<ffffffff80244728>] do_wait+0x195/0x403
 [<ffffffff80239dda>] ? default_wake_function+0x0/0x14
 [<ffffffff80244a20>] sys_wait4+0x8a/0xa5
 [<ffffffff8020b21b>] system_call_fastpath+0x16/0x1b
Code: 00 49 b8 00 02 20 00 00 00 ad de 48 8b 17 48 8b 47 08 49 89 f5 48
89 42 08 48 89 10 48 8b 47 18 48 8b 57 10 48 89 3f 48 89 7f 08 <48> 89
10 48 89 42 08 48 8b 47 38 4c 89 47 18 48 39 f8 74 03 ff
RIP  [<ffffffff8029c492>] list_del_counter+0x46/0xad
 RSP <ffff88022e96fd58>
---[ end trace 71d51ad4e24097f6 ]---

