Return-Path: <linux-kernel-owner+w=401wt.eu-S1752832AbZJ2MmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832AbZJ2MmS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 08:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752525AbZJ2MmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 08:42:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1541 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752392AbZJ2MmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 08:42:17 -0400
Subject: Re: [patch] Re: [regression bisect -next] BUG: using
 smp_processor_id() in preemptible [00000000] code: rmmod
From: Eric Paris <eparis@redhat.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org, hpa@zytor.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de
In-Reply-To: <1256813310.7574.3.camel@marge.simson.net>
References: <1256784158.2848.8.camel@dhcp231-106.rdu.redhat.com>
	 <1256805552.7158.22.camel@marge.simson.net>
	 <20091029091411.GE22963@elte.hu>
	 <1256807967.7158.58.camel@marge.simson.net>
	 <1256813310.7574.3.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Oct 2009 08:41:45 -0400
Message-Id: <1256820105.2848.14.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-29 at 11:48 +0100, Mike Galbraith wrote:
> On Thu, 2009-10-29 at 10:19 +0100, Mike Galbraith wrote:
> > On Thu, 2009-10-29 at 10:14 +0100, Ingo Molnar wrote:
> > 
> > > hm, the problem is kthread_bind(). It is rummaging around in scheduler 
> > > internals without holding the runqueue lock - and this now got exposed. 
> > > Even though it is operating on (supposedly ...) inactive tasks, the guts 
> > > of that function should be moved into sched.c and it should be fixed to 
> > > have proper locking.
> > 
> > Yeah, I was thinking that nobody should ever be able to hit that without
> > it being a bug.. but wimped out.
> 
> How about so?
> 
> sched: Move the body of kthread_bind() to sched.c.
> 
> Eric Paris reported that commit f685ceacab07d3f6c236f04803e2f2f0dbcc5afb
> causes boot time PREEMPT_DEBUG complaints.
> 
> [    4.590699] BUG: using smp_processor_id() in preemptible [00000000] code: rmmod/1314
> [    4.593043] caller is task_hot+0x86/0xd0
> [    4.593872] Pid: 1314, comm: rmmod Tainted: G        W  2.6.32-rc3-fanotify #127
> [    4.595443] Call Trace:
> [    4.596177]  [<ffffffff812ad35b>] debug_smp_processor_id+0x11b/0x120
> [    4.597337]  [<ffffffff81051d66>] task_hot+0x86/0xd0
> [    4.598320]  [<ffffffff81066275>] set_task_cpu+0x115/0x270
> [    4.599368]  [<ffffffff810985ab>] kthread_bind+0x6b/0x100
> [    4.600354]  [<ffffffff810914f0>] start_workqueue_thread+0x30/0x60
> [    4.601545]  [<ffffffff810941dd>] __create_workqueue_key+0x18d/0x2f0
> [    4.602526]  [<ffffffff810d9bee>] stop_machine_create+0x4e/0xd0
> [    4.603811]  [<ffffffff810c5818>] sys_delete_module+0x98/0x250
> [    4.604922]  [<ffffffff810e2505>] ? audit_syscall_entry+0x205/0x290
> [    4.606202]  [<ffffffff81013202>] system_call_fastpath+0x16/0x1b
> 
> Since kthread_bind() messes with scheduler internals, move the body to sched.c,
> and lock the runqueue.
> 
> Signed-off-by: Mike Galbraith <efault@gmx.de>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Reported-by: Eric Paris <eparis@redhat.com>

Nothing complains.

Tested-by: Eric Paris <eparis@redhat.com>

Now if I just knew why -next kernels under kvm seem to randomly corrupt
memory and eventually start taking NMI's, then I'd be happy.

-Eric

