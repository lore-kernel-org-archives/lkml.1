Return-Path: <linux-kernel-owner+w=401wt.eu-S1753892AbZAGM0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892AbZAGM0f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 07:26:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbZAGM0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 07:26:22 -0500
Received: from e28smtp08.in.ibm.com ([59.145.155.8]:54053 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371AbZAGM0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 07:26:21 -0500
Date: Wed, 7 Jan 2009 17:59:13 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [BUG] 2.6.28-git LOCKDEP: Possible recursive rq->lock
Message-ID: <20090107122913.GL4574@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20090104174450.GB4301@dirshya.in.ibm.com> <1231092523.29980.4.camel@twins> <20090105040635.GF4301@dirshya.in.ibm.com> <20090105130638.GB6014@elte.hu> <20090107114947.GJ4574@dirshya.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090107114947.GJ4574@dirshya.in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> [2009-01-07 17:19:47]:

> * Ingo Molnar <mingo@elte.hu> [2009-01-05 14:06:38]:
> 
> > 
> > * Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> wrote:
> > 
> > > * Peter Zijlstra <a.p.zijlstra@chello.nl> [2009-01-04 19:08:43]:
> > > 
> > > > On Sun, 2009-01-04 at 23:14 +0530, Vaidyanathan Srinivasan wrote:
> > > > > Hi Ingo,
> > > > > 
> > > > > Kernbench runs on latest Linux git tree stalled with the following
> > > > > lockdep warning.
> > > > > 
> > > > > Lockdep warning and lockup on Jan 3 Linus git tree
> > > > > commit 7d3b56ba37a95f1f370f50258ed3954c304c524b
> > > > > 
> > > > > kernbench run with two threads stalled.  sched_mc was zero.
> > > > > x86_64 system with 8 logical CPUs in dual socket quad core
> > > > > configuration.
> > > > > 
> > > > > I will post more information as I debug this warning/bug.  
> > > > 
> > > > Its ca109491f612aab5c8152207631c0444f63da97f, I've some ideas on how to
> > > > fix this, just haven't gotten around to actually doing anything --
> > > > seeing how it was holidays and such..
> > > 
> > > Hi Peter,
> > > 
> > > I can definitely test your fix when you have them.  I have an
> > > autotest job that hits this bug.
> > 
> > could you check latest tip/master, it has Peter's and Thomas's hrtimer 
> > fixes.
> 
> Hi Peter,
> 
> I still get the following warning at the first kernel build (kernbench
> run) but the entire tests complete without any lockups.
> 
> Please let me know if these make sense.  I have CONFIG_FRAME_POINTER=y
> in these runs.
> 
> Test run on sched-tip on Jan 5 at commit 4c1ae1dfea7a5fcab3444220a38054dd50c08441

Another one...

=============================================
[ INFO: possible recursive locking detected ]
2.6.28-autotest-tip-sv #1
---------------------------------------------
klogd/5062 is trying to acquire lock:
 (&rq->lock){++..}, at: [<ffffffff8022aca2>] task_rq_lock+0x45/0x7e

but task is already holding lock:
 (&rq->lock){++..}, at: [<ffffffff805f7354>] schedule+0x158/0xa31

other info that might help us debug this:
1 lock held by klogd/5062:
 #0:  (&rq->lock){++..}, at: [<ffffffff805f7354>] schedule+0x158/0xa31

stack backtrace:
Pid: 5062, comm: klogd Not tainted 2.6.28-autotest-tip-sv #1
Call Trace:
 [<ffffffff80259ef1>] __lock_acquire+0xeb9/0x16a4
 [<ffffffff8025a6c0>] ? __lock_acquire+0x1688/0x16a4
 [<ffffffff8025a761>] lock_acquire+0x85/0xa9
 [<ffffffff8022aca2>] ? task_rq_lock+0x45/0x7e
 [<ffffffff805fa4d4>] _spin_lock+0x31/0x66
 [<ffffffff8022aca2>] ? task_rq_lock+0x45/0x7e
 [<ffffffff8022aca2>] task_rq_lock+0x45/0x7e
 [<ffffffff80233363>] try_to_wake_up+0x88/0x27a
 [<ffffffff80233581>] wake_up_process+0x10/0x12
 [<ffffffff805f775c>] schedule+0x560/0xa31
 [<ffffffff805f805f>] schedule_timeout+0x22/0xb4
 [<ffffffff805fa35e>] ? _spin_unlock+0x26/0x2a
 [<ffffffff805961e0>] unix_wait_for_peer+0x9c/0xbb
 [<ffffffff8024a686>] ? autoremove_wake_function+0x0/0x38
 [<ffffffff805fa500>] ? _spin_lock+0x5d/0x66
 [<ffffffff8059679e>] unix_dgram_sendmsg+0x3a8/0x4a3
 [<ffffffff8053661f>] sock_aio_write+0x107/0x117
 [<ffffffff802a6377>] do_sync_write+0xe7/0x12d
 [<ffffffff802a98c6>] ? cp_new_stat+0xe2/0xef
 [<ffffffff8024a686>] ? autoremove_wake_function+0x0/0x38
 [<ffffffff802a6c23>] vfs_write+0xc1/0x137
 [<ffffffff802a6d5d>] sys_write+0x47/0x70
 [<ffffffff8020c05b>] system_call_fastpath+0x16/0x1b


I have debug info enabled, I can lookup any address you would like.

--Vaidy

