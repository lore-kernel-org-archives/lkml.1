Return-Path: <linux-kernel-owner+w=401wt.eu-S1752453AbYKMKJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453AbYKMKJl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 05:09:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751006AbYKMKJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 05:09:29 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:34773 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbYKMKJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 05:09:27 -0500
Subject: Re: [PATCH] SYSVIPC - Fix the ipc structures initialization
From: Nadia Derbey <Nadia.Derbey@bull.net>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, cboulte@gmail.com,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Nadia Derbey <Nadia.Derbey@bull.net>
In-Reply-To: <491BC4B8.1050406@colorfullife.com>
References: <20081028145952.620752409@bull.net>
	 <20081028150041.857635775@bull.net>
	 <4f3ee3290810290211y75a2d0eaoe666496e25496260@mail.gmail.com>
	 <20081111141603.f0e7fa8d.akpm@linux-foundation.org>
	 <491BC4B8.1050406@colorfullife.com>
Content-Type: text/plain
Date: Thu, 13 Nov 2008 11:08:00 +0100
Message-Id: <1226570880.2585.41.camel@frecb000730.frec.bull.fr>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-11-13 at 07:10 +0100, Manfred Spraul wrote:
> Andrew Morton wrote:
> > Time is starting to press on this one.  Is there something which we can
> > revert which would fix this bug?
> >   
> My previous analysis was bogus, let's start from scratch:
> 
> 1) the initial oops report:
> http://bugzilla.kernel.org/show_bug.cgi?id=11796#c0
> 
> - lockdep is enabled, the oops is somewhere in __lock_acquire
> - the instruction that oopses is
> 
>  >>>  lock incl 0x138(%r12)
> R12 is 0x0038004000000000
> 
> That could be an debug_atomic_inc() in __lock_acquire. The class pointer 
> in the spinlock_t is not initialized, thus it crashes.
> Ingo - is that possible?
> 
> 2) the latest oops was actually a soft lockup:
> 
> It starts with:
> > [  400.393024] INFO: trying to register non-static key.
> > [  400.397005] the code is fine but needs lockdep annotation.
> > [  400.397005] turning off the locking correctness validator.
> > [  400.397005] Pid: 4207, comm: sysv_test2 Not tainted 2.6.27-ipc_lock #1
> > [  400.397005] Call Trace:
> > [  400.397005]  [<ffffffff80257055>] static_obj+0x60/0x77
> > [  400.397005]  [<ffffffff8025af59>] __lock_acquire+0x1c8/0x779
> > [  400.397005]  [<ffffffff8025b59f>] lock_acquire+0x95/0xc2
> > [  400.397005]  [<ffffffff802feb07>] ipc_lock+0x62/0x99
> > [  400.397005]  [<ffffffff8045117d>] _spin_lock+0x2d/0x5a
> > [  400.397005]  [<ffffffff802feb07>] ipc_lock+0x62/0x99
> > [  400.397005]  [<ffffffff802feb07>] ipc_lock+0x62/0x99
> > [  400.397005]  [<ffffffff802feaa5>] ipc_lock+0x0/0x99
> > [  400.397005]  [<ffffffff802feb46>] ipc_lock_check+0x8/0x53
> > [  400.397005]  [<ffffffff803002c3>] sys_msgctl+0x188/0x461
> > [  400.397005]  [<ffffffff80259ac7>] trace_hardirqs_on_caller+0x100/0x12a
> > [  400.397005]  [<ffffffff80450d49>] trace_hardirqs_on_thunk+0x3a/0x3f
> > [  400.397005]  [<ffffffff80259ac7>] trace_hardirqs_on_caller+0x100/0x12a
> > [  400.397005]  [<ffffffff80212e09>] sched_clock+0x5/0x7
> > [  400.397005]  [<ffffffff80450d49>] trace_hardirqs_on_thunk+0x3a/0x3f
> > [  400.397005]  [<ffffffff80213021>] native_sched_clock+0x8c/0xa5
> > [  400.397005]  [<ffffffff80212e09>] sched_clock+0x5/0x7
> > [  400.397005]  [<ffffffff8020bf7a>] system_call_fastpath+0x16/0x1b
> > [  400.397005]
> > [  464.933003] BUG: soft lockup - CPU#2 stuck for 61s! [sysv_test2:4207]
> > [  464.933006] Call Trace:
> > [  464.933006]  [<ffffffff8033dc6b>] _raw_spin_lock+0x98/0x100
> > [  464.933006]  [<ffffffff8045119e>] _spin_lock+0x4e/0x5a
> > [  464.933006]  [<ffffffff802feb07>] ipc_lock+0x62/0x99
> 
> For me, it reads like an uninitialized spinlock_t:

That's what the patch I sent at the beginning of this thread
(http://lkml.org/lkml/2008/10/28/177) fixes: the ipc structure is not
completely initialized before being inserted in the tree.

The patched kernel has been running for 4 days on my victim without any
problem, but Clement is still facing a problem (that comes later).

I think this patch should be included anyways, because ipc structures
initialization is not correct the way it is done today.

I'm still reviewing the code to see what else could be wrong.

Regards,
Nadia

> The static_obj test in kernel/lockdep.c notices that something is wrong and disables itself.
> But then _raw_spin_lock() tries to acquire the uninitialized spinlock and loops forever, because noone does spin_unlock().
> after 60 seconds, the soft lockup detection notices the problem and oopses.
> 
> 
> 
> 
-- 
Nadia Derbey <Nadia.Derbey@bull.net>

