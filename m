Return-Path: <linux-kernel-owner+w=401wt.eu-S1753155AbZAEED4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155AbZAEED4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 23:03:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752123AbZAEEDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 23:03:48 -0500
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:50454 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbZAEEDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 23:03:47 -0500
Date: Mon, 5 Jan 2009 09:36:35 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [BUG] 2.6.28-git LOCKDEP: Possible recursive rq->lock
Message-ID: <20090105040635.GF4301@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20090104174450.GB4301@dirshya.in.ibm.com> <1231092523.29980.4.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1231092523.29980.4.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <a.p.zijlstra@chello.nl> [2009-01-04 19:08:43]:

> On Sun, 2009-01-04 at 23:14 +0530, Vaidyanathan Srinivasan wrote:
> > Hi Ingo,
> > 
> > Kernbench runs on latest Linux git tree stalled with the following
> > lockdep warning.
> > 
> > Lockdep warning and lockup on Jan 3 Linus git tree
> > commit 7d3b56ba37a95f1f370f50258ed3954c304c524b
> > 
> > kernbench run with two threads stalled.  sched_mc was zero.
> > x86_64 system with 8 logical CPUs in dual socket quad core
> > configuration.
> > 
> > I will post more information as I debug this warning/bug.  
> 
> Its ca109491f612aab5c8152207631c0444f63da97f, I've some ideas on how to
> fix this, just haven't gotten around to actually doing anything --
> seeing how it was holidays and such..

Hi Peter,

I can definitely test your fix when you have them.  I have an
autotest job that hits this bug.

Another one... if that helps you.

kernel: =============================================
kernel: [ INFO: possible recursive locking detected ]
kernel: 2.6.28-autotest-sv #1 
kernel: ---------------------------------------------
kernel: dd/5069 is trying to acquire lock:
kernel:  (&rq->lock){++..}, at: [<ffffffff80229240>] task_rq_lock+0x44/0x7e
kernel:
kernel: but task is already holding lock: 
kernel:  (&rq->lock){++..}, at: [<ffffffff805d0fd4>] schedule+0x144/0x9d6
kernel:
kernel: other info that might help us debug this:
kernel: 2 locks held by dd/5069:
kernel:  #0:  (&sb->s_type->i_mutex_key#3){--..}, at: [<ffffffff802a3b71>] pipe_write+0x65/0x4f6 
kernel:  #1:  (&rq->lock){++..}, at: [<ffffffff805d0fd4>] schedule+0x144/0x9d6
kernel:
kernel: stack backtrace:
kernel: Pid: 5069, comm: dd Not tainted 2.6.28-autotest-sv #1 
kernel: Call Trace:
kernel:  [<ffffffff802560d8>] __lock_acquire+0xe2a/0x15ed
kernel:  [<ffffffff80279618>] get_page_from_freelist+0x45d/0x531
kernel:  [<ffffffff80256920>] lock_acquire+0x85/0xa9
kernel:  [<ffffffff80229240>] task_rq_lock+0x44/0x7e
kernel:  [<ffffffff805d3f4c>] _spin_lock+0x2d/0x5f
kernel:  [<ffffffff80229240>] task_rq_lock+0x44/0x7e
kernel:  [<ffffffff80229240>] task_rq_lock+0x44/0x7e
kernel:  [<ffffffff8022de2e>] try_to_wake_up+0x83/0x26f
kernel:  [<ffffffff805d0fd4>] schedule+0x144/0x9d6
kernel:  [<ffffffff805d13e8>] schedule+0x558/0x9d6
kernel:  [<ffffffff80252913>] lock_release_holdtime+0x1b/0x16c
kernel:  [<ffffffff805d2646>] mutex_lock_nested+0x1ae/0x2d1
kernel:  [<ffffffff802a3b71>] pipe_write+0x65/0x4f6 
kernel:  [<ffffffff802a3b71>] pipe_write+0x65/0x4f6 
kernel:  [<ffffffff80256882>] __lock_acquire+0x15d4/0x15ed
kernel:  [<ffffffff802a3b71>] pipe_write+0x65/0x4f6 
kernel:  [<ffffffff80256882>] __lock_acquire+0x15d4/0x15ed
kernel:  [<ffffffff8029d83f>] do_sync_write+0xce/0x113
kernel:  [<ffffffff802476e9>] autoremove_wake_function+0x0/0x2e
kernel:  [<ffffffff802c2652>] dnotify_parent+0x1f/0x6d
kernel:  [<ffffffff80252913>] lock_release_holdtime+0x1b/0x16c
kernel:  [<ffffffff8029e085>] vfs_write+0xad/0x136
kernel:  [<ffffffff8029e1ca>] sys_write+0x45/0x6e
kernel:  [<ffffffff8020bedb>] system_call_fastpath+0x16/0x1b

--Vaidy

