Return-Path: <linux-kernel-owner+w=401wt.eu-S1757896AbZAGOUE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757896AbZAGOUE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 09:20:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752866AbZAGOTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 09:19:53 -0500
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:59260 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbZAGOTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 09:19:53 -0500
Date: Wed, 7 Jan 2009 19:50:09 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [BUG] 2.6.28-git LOCKDEP: Possible recursive rq->lock
Message-ID: <20090107142009.GM4574@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20090104174450.GB4301@dirshya.in.ibm.com> <1231092523.29980.4.camel@twins> <20090105040635.GF4301@dirshya.in.ibm.com> <20090105130638.GB6014@elte.hu> <20090107114947.GJ4574@dirshya.in.ibm.com> <20090107122913.GL4574@dirshya.in.ibm.com> <1231333963.11687.288.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1231333963.11687.288.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <a.p.zijlstra@chello.nl> [2009-01-07 14:12:43]:

> On Wed, 2009-01-07 at 17:59 +0530, Vaidyanathan Srinivasan wrote:
> 
> > =============================================
> > [ INFO: possible recursive locking detected ]
> > 2.6.28-autotest-tip-sv #1
> > ---------------------------------------------
> > klogd/5062 is trying to acquire lock:
> >  (&rq->lock){++..}, at: [<ffffffff8022aca2>] task_rq_lock+0x45/0x7e
> > 
> > but task is already holding lock:
> >  (&rq->lock){++..}, at: [<ffffffff805f7354>] schedule+0x158/0xa31
> > 
> > other info that might help us debug this:
> > 1 lock held by klogd/5062:
> >  #0:  (&rq->lock){++..}, at: [<ffffffff805f7354>] schedule+0x158/0xa31
> > 
> > stack backtrace:
> > Pid: 5062, comm: klogd Not tainted 2.6.28-autotest-tip-sv #1
> > Call Trace:
> >  [<ffffffff80259ef1>] __lock_acquire+0xeb9/0x16a4
> >  [<ffffffff8025a6c0>] ? __lock_acquire+0x1688/0x16a4
> >  [<ffffffff8025a761>] lock_acquire+0x85/0xa9
> >  [<ffffffff8022aca2>] ? task_rq_lock+0x45/0x7e
> >  [<ffffffff805fa4d4>] _spin_lock+0x31/0x66
> >  [<ffffffff8022aca2>] ? task_rq_lock+0x45/0x7e
> >  [<ffffffff8022aca2>] task_rq_lock+0x45/0x7e
> >  [<ffffffff80233363>] try_to_wake_up+0x88/0x27a
> >  [<ffffffff80233581>] wake_up_process+0x10/0x12
> >  [<ffffffff805f775c>] schedule+0x560/0xa31
> 
> I'd be most curious to know where in schedule we are.

ok, we are in sched.c:3777

                double_unlock_balance(this_rq, busiest);
                if (active_balance)
>>>>>>>>>>>              wake_up_process(busiest->migration_thread);

        } else  

In active balance in newidle.  This implies sched_mc was 2 at that time.
let me trace this and debug further.

--Vaidy

