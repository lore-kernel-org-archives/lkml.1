Return-Path: <linux-kernel-owner+w=401wt.eu-S1756889AbZDTVOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889AbZDTVOZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 17:14:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbZDTVOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 17:14:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:49358 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbZDTVOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 17:14:15 -0400
Date: Mon, 20 Apr 2009 17:14:14 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/4] [GIT PULL] tracing: recursion and compile fixes
In-Reply-To: <20090420210152.GF5974@nowhere>
Message-ID: <alpine.DEB.2.00.0904201711150.10097@gandalf.stny.rr.com>
References: <20090420173819.957332585@goodmis.org> <20090420175533.GA22449@elte.hu> <20090420192803.GA25629@elte.hu> <20090420194542.GB5974@nowhere> <alpine.DEB.2.00.0904201616430.10097@gandalf.stny.rr.com> <20090420203347.GD5974@nowhere>
 <alpine.DEB.2.00.0904201641570.10097@gandalf.stny.rr.com> <20090420210152.GF5974@nowhere>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 20 Apr 2009, Frederic Weisbecker wrote:

> On Mon, Apr 20, 2009 at 04:44:46PM -0400, Steven Rostedt wrote:
> > 
> > On Mon, 20 Apr 2009, Frederic Weisbecker wrote:
> > > > > 
> > > > 
> > > > Hmm, doesn't the trace wakeup test if the runqueue lock is locked or not?
> > > > 
> > > > -- Steve
> > > > 
> > > 
> > > 
> > > Hmm, yes it does but that's not the first time we meet this problem
> > > (sched switch event tracing recursions by the past). So either the
> > > test doesn't work well or this is about another lock that
> > > wake_up_common takes...
> > 
> > Ug, it is the task's rq lock. Not the current rq lock. wakeup takes the 
> > runqueue lock of the task. The "runqueue_is_locked" only tests the lock of 
> > current CPU, which is not what we can have.
> 
> 
> You mean the lock held on the wait_queue for wake_up_trace() ?
> 
> void __wake_up(wait_queue_head_t *q, unsigned int mode,
> 			int nr_exclusive, void *key)
> {
> 	unsigned long flags;
> 
> 	spin_lock_irqsave(&q->lock, flags);
> 	__wake_up_common(q, mode, nr_exclusive, 0, key);
> 	spin_unlock_irqrestore(&q->lock, flags);
> }
> 

No, I mean that we check the runqueue lock on the current CPU (there's a 
runqueue for each CPU). The runqueue_is_locked tests only the lock for the 
current cpu. But the wake up of a task grabs the runqueue of the lock the 
task is on.

If we are on CPU0 and hold the runqueue lock of CPU1, and we wake up a 
task on CPU1, we will deadlock. Even thought runqueue_is_locked passed. 
Because the current runqueue lock is not part of this equation.

-- Steve

