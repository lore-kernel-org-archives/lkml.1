Return-Path: <linux-kernel-owner+w=401wt.eu-S1753250AbZAGLrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbZAGLrW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 06:47:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751647AbZAGLrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 06:47:07 -0500
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:33754 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbZAGLrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 06:47:05 -0500
Date: Wed, 7 Jan 2009 17:19:47 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [BUG] 2.6.28-git LOCKDEP: Possible recursive rq->lock
Message-ID: <20090107114947.GJ4574@dirshya.in.ibm.com>
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

I still get the following warning at the first kernel build (kernbench
run) but the entire tests complete without any lockups.

Please let me know if these make sense.  I have CONFIG_FRAME_POINTER=y
in these runs.

Test run on sched-tip on Jan 5 at commit 4c1ae1dfea7a5fcab3444220a38054dd50c08441

kernel: =============================================
kernel: [ INFO: possible recursive locking detected ]
kernel: 2.6.28-autotest-tip-sv #1
kernel: ---------------------------------------------
kernel: autotest/6019 is trying to acquire lock:
kernel:  (&rq->lock){++..}, at: [<ffffffff8022aca2>] task_rq_lock+0x45/0x7e
kernel:
kernel: but task is already holding lock:
kernel:  (&rq->lock){++..}, at: [<ffffffff805f7354>] schedule+0x158/0xa31
kernel:
kernel: other info that might help us debug this:
kernel: 1 lock held by autotest/6019:
kernel:  #0:  (&rq->lock){++..}, at: [<ffffffff805f7354>] schedule+0x158/0xa31
kernel:
kernel: stack backtrace:
kernel: Pid: 6019, comm: autotest Not tainted 2.6.28-autotest-tip-sv #1
kernel: Call Trace:
kernel:  [<ffffffff80259ef1>] __lock_acquire+0xeb9/0x16a4
kernel:  [<ffffffff8025a6c0>] ? __lock_acquire+0x1688/0x16a4
kernel:  [<ffffffff8025a761>] lock_acquire+0x85/0xa9
kernel:  [<ffffffff8022aca2>] ? task_rq_lock+0x45/0x7e
kernel:  [<ffffffff805fa4d4>] _spin_lock+0x31/0x66
kernel:  [<ffffffff8022aca2>] ? task_rq_lock+0x45/0x7e
kernel:  [<ffffffff8022aca2>] task_rq_lock+0x45/0x7e
kernel:  [<ffffffff80233363>] try_to_wake_up+0x88/0x27a
kernel:  [<ffffffff80233581>] wake_up_process+0x10/0x12
kernel:  [<ffffffff805f775c>] schedule+0x560/0xa31
kernel:  [<ffffffff805fa330>] ? _spin_unlock_irqrestore+0x3f/0x47
kernel:  [<ffffffff80258701>] ? trace_hardirqs_on_caller+0x11f/0x14a
kernel:  [<ffffffff8024d3dc>] ? hrtimer_start_range_ns+0x1ef/0x201
kernel:  [<ffffffff805f8fd6>] schedule_hrtimeout_range+0xd1/0x106
kernel:  [<ffffffff8024cb9a>] ? hrtimer_wakeup+0x0/0x21
kernel:  [<ffffffff805f8fbb>] ? schedule_hrtimeout_range+0xb6/0x106
kernel:  [<ffffffff802b3d34>] do_select+0x55a/0x5b6
kernel:  [<ffffffff802b37da>] ? do_select+0x0/0x5b6
kernel:  [<ffffffff802b42aa>] ? __pollwait+0x0/0xe2
kernel:  [<ffffffff80233555>] ? default_wake_function+0x0/0xf
kernel:  [<ffffffff80233555>] ? default_wake_function+0x0/0xf
kernel:  [<ffffffff8025a6c0>] ? __lock_acquire+0x1688/0x16a4
last message repeated 2 times
kernel:  [<ffffffff805fa35e>] ? _spin_unlock+0x26/0x2a
kernel:  [<ffffffff802b3dcd>] ? core_sys_select+0x3d/0x2b4
kernel:  [<ffffffff802b3f7a>] core_sys_select+0x1ea/0x2b4
kernel:  [<ffffffff802b3dcd>] ? core_sys_select+0x3d/0x2b4
kernel:  [<ffffffff8025a6c0>] ? __lock_acquire+0x1688/0x16a4
kernel:  [<ffffffff805fa330>] ? _spin_unlock_irqrestore+0x3f/0x47
kernel:  [<ffffffff80258701>] ? trace_hardirqs_on_caller+0x11f/0x14a
kernel:  [<ffffffff80258739>] ? trace_hardirqs_on+0xd/0xf
kernel:  [<ffffffff8024a865>] ? remove_wait_queue+0x48/0x4d
kernel:  [<ffffffff80250c7a>] ? getnstimeofday+0x58/0xb4
kernel:  [<ffffffff8024d5d4>] ? ktime_get_ts+0x49/0x4e
kernel:  [<ffffffff802b4282>] sys_select+0x94/0xbc
kernel:  [<ffffffff8020c05b>] system_call_fastpath+0x16/0x1b
kernel: hardirqs last  enabled at (19261): [<ffffffff805fa330>] _spin_unlock_irqrestore+0x3f/0x47
kernel: hardirqs last disabled at (19260): [<ffffffff805fa5f8>] _spin_lock_irqsave+0x19/0x74
kernel: softirqs last  enabled at (18668): [<ffffffff8023c30a>] __do_softirq+0x154/0x162
kernel: softirqs last disabled at (18657): [<ffffffff8020d1dc>] call_softirq+0x1c/0x34

--Vaidy

