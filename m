Return-Path: <linux-kernel-owner+w=401wt.eu-S1753299AbZK3VNH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299AbZK3VNH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 16:13:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753156AbZK3VNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 16:13:06 -0500
Received: from www.tglx.de ([62.245.132.106]:54369 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753149AbZK3VNF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 16:13:05 -0500
Date: Mon, 30 Nov 2009 22:12:45 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc] "fair" rw spinlocks
In-Reply-To: <20091130174638.GA9782@elte.hu>
Message-ID: <alpine.LFD.2.00.0911302206370.24119@localhost.localdomain>
References: <20091123145409.GA29627@wotan.suse.de> <alpine.LFD.2.00.0911280927180.2561@localhost> <20091130100041.GA29610@infradead.org> <alpine.LFD.2.00.0911300722370.2872@localhost.localdomain> <20091130174638.GA9782@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Nov 2009, Ingo Molnar wrote:
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > On Mon, 30 Nov 2009, Christoph Hellwig wrote:
> > > 
> > > How long will this use be around?  I've seen some slow progress toward
> > > replacing most read side uses of the task list lock with RCU.  While we
> > > still have lots of read side users now I wonder when they'll go away.
> > 
> > tasklist_lock is pretty nasty. I threw out "replace it with RCU" 
> > because it would be nice, but the data structures used are not just 
> > simple linked lists that we have RCU helpers for traversing.
> > 
> > There are various real exclusion rules about things like 
> > 'tsk->exit_state' etc, which do not translate directly to RCU usage. 
> > Of course, _maybe_ all the places that care already take the thing for 
> > writing and would just automatically have exclusion anyway.
> > 
> > So I'd love to see somebody try to do the conversion. To a first 
> > approximation, you probably could do
> > 
> >  - turn tasklist_lock into a spinlock
> > 
> >  - sed 's/write_lock_irq(&tasklist_lock)/spin_lock(&tasklist_lock)/g'
> >    sed 's/write_unlock_irq(&tasklist_lock)/spin_unlock(&tasklist_lock)/g'
> > 
> >  - sed 's/read_lock(&tasklist_lock)/rcu_read_lock()/g'
> >    sed 's/read_unlock(&tasklist_lock)/rcu_read_unlock()/g'
> > 
> >  - make all the task lists use the RCU versions of the list routines
> > 
> >  - free the task structure using RCU
> > 
> > and you'd be _pretty_ close to a working system.
> 
> In -rt we've got that in essence, and it's indeed working fine (with a 
> few caveats). A few RCU conversions of tasklist_lock usage in that area 
> even trickled upstream, because the simple lock would hurt so much under 
> -rt.

I think the conversion Linus proposed is pretty feasible. I went
through the read_lock sites and most of them are protecting function
calls which we already use under rcu_read_lock() in other places like
find_task* and thread or pid iterators.

There are a few non obvious ones in signal.c and posix-cpu-timers.c
(what a surprise) but nothing looks too scary.

If nobody beats me I'm going to let sed loose on the kernel, lift the
task_struct rcu free code from -rt and figure out what explodes.

Thanks,

	tglx
