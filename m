Return-Path: <linux-kernel-owner+w=401wt.eu-S1752681AbZAFN73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681AbZAFN73 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 08:59:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751003AbZAFN7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 08:59:20 -0500
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:50573 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbZAFN7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 08:59:19 -0500
Date: Tue, 6 Jan 2009 19:32:07 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [BUG] 2.6.28-git LOCKDEP: Possible recursive rq->lock
Message-ID: <20090106140207.GE4574@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20090104174450.GB4301@dirshya.in.ibm.com> <1231092523.29980.4.camel@twins> <20090105040635.GF4301@dirshya.in.ibm.com> <20090105130638.GB6014@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090105130638.GB6014@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar <mingo@elte.hu> [2009-01-05 14:06:38]:

> 
> * Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> wrote:
> 
> > * Peter Zijlstra <a.p.zijlstra@chello.nl> [2009-01-04 19:08:43]:
> > 
> > > On Sun, 2009-01-04 at 23:14 +0530, Vaidyanathan Srinivasan wrote:
> > > > Hi Ingo,
> > > > 
> > > > Kernbench runs on latest Linux git tree stalled with the following
> > > > lockdep warning.
> > > > 
> > > > Lockdep warning and lockup on Jan 3 Linus git tree
> > > > commit 7d3b56ba37a95f1f370f50258ed3954c304c524b
> > > > 
> > > > kernbench run with two threads stalled.  sched_mc was zero.
> > > > x86_64 system with 8 logical CPUs in dual socket quad core
> > > > configuration.
> > > > 
> > > > I will post more information as I debug this warning/bug.  
> > > 
> > > Its ca109491f612aab5c8152207631c0444f63da97f, I've some ideas on how to
> > > fix this, just haven't gotten around to actually doing anything --
> > > seeing how it was holidays and such..
> > 
> > Hi Peter,
> > 
> > I can definitely test your fix when you have them.  I have an
> > autotest job that hits this bug.
> 
> could you check latest tip/master, it has Peter's and Thomas's hrtimer 
> fixes.

Hi Peter,

I queued the same kernbench runs with the latest tip.  The run
completed without any lockups, but I still got one lockdep warning.

sched-tip date Jan 5 commit:4c1ae1dfea7a5fcab3444220a38054dd50c08441

kernel: =============================================
kernel: [ INFO: possible recursive locking detected ]
kernel: 2.6.28-autotest-tip-sv #1
kernel: ---------------------------------------------
kernel: autotest/6012 is trying to acquire lock:
kernel:  (&rq->lock){++..}, at: [<ffffffff8022a4dd>] task_rq_lock+0x44/0x7e
kernel:
kernel: but task is already holding lock:
kernel:  (&rq->lock){++..}, at: [<ffffffff805d6000>] schedule+0x144/0x9e5
kernel:
kernel: other info that might help us debug this:
kernel: 1 lock held by autotest/6012:
kernel:  #0:  (&rq->lock){++..}, at: [<ffffffff805d6000>] schedule+0x144/0x9e5
kernel:
kernel: stack backtrace:
kernel: Pid: 6012, comm: autotest Not tainted 2.6.28-autotest-tip-sv #1
kernel: Call Trace:
kernel:  [<ffffffff80257a0c>] __lock_acquire+0xe2a/0x15ed
kernel:  [<ffffffff80258254>] lock_acquire+0x85/0xa9
kernel:  [<ffffffff8022a4dd>] task_rq_lock+0x44/0x7e
kernel:  [<ffffffff805d8fac>] _spin_lock+0x2d/0x5f
kernel:  [<ffffffff8022a4dd>] task_rq_lock+0x44/0x7e
kernel:  [<ffffffff8022a4dd>] task_rq_lock+0x44/0x7e
kernel:  [<ffffffff80232947>] try_to_wake_up+0x83/0x26f
kernel:  [<ffffffff805d6000>] schedule+0x144/0x9e5
kernel:  [<ffffffff805d6415>] schedule+0x559/0x9e5
kernel:  [<ffffffff802562fc>] trace_hardirqs_on_caller+0x120/0x14a
kernel:  [<ffffffff8024b721>] hrtimer_start_range_ns+0x1e4/0x1f7
kernel:  [<ffffffff805d7bda>] schedule_hrtimeout_range+0xcc/0xff
kernel:  [<ffffffff8024af3d>] hrtimer_wakeup+0x0/0x22
kernel:  [<ffffffff805d7bbc>] schedule_hrtimeout_range+0xae/0xff
kernel:  [<ffffffff802ae194>] do_select+0x502/0x55d
kernel:  [<ffffffff802adc92>] do_select+0x0/0x55d
kernel:  [<ffffffff802ae70b>] __pollwait+0x0/0xe5
kernel:  [<ffffffff80232b33>] default_wake_function+0x0/0x9
kernel:  [<ffffffff80232b33>] default_wake_function+0x0/0x9
kernel:  [<ffffffff80254211>] lock_release_holdtime+0x1b/0x16c
kernel:  [<ffffffff802581b6>] __lock_acquire+0x15d4/0x15ed
last message repeated 2 times
kernel:  [<ffffffff80254211>] lock_release_holdtime+0x1b/0x16c
kernel:  [<ffffffff80254211>] lock_release_holdtime+0x1b/0x16c
kernel:  [<ffffffff802ae220>] core_sys_select+0x31/0x2b0
kernel:  [<ffffffff802ae3db>] core_sys_select+0x1ec/0x2b0
kernel:  [<ffffffff802ae220>] core_sys_select+0x31/0x2b0
kernel:  [<ffffffff80248d47>] remove_wait_queue+0x12/0x4d
kernel:  [<ffffffff80254211>] lock_release_holdtime+0x1b/0x16c
kernel:  [<ffffffff805d8e29>] _spin_unlock_irqrestore+0x3e/0x44
kernel:  [<ffffffff802562fc>] trace_hardirqs_on_caller+0x120/0x14a
kernel:  [<ffffffff8023909b>] do_wait+0x2a4/0x395
kernel:  [<ffffffff8024ec91>] getnstimeofday+0x56/0xb0
kernel:  [<ffffffff802ae6e2>] sys_select+0x92/0xbb
kernel:  [<ffffffff8020bedb>] system_call_fastpath+0x16/0x1b

I will rerun and check again.

--Vaidy

