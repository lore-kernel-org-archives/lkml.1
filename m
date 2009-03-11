Return-Path: <linux-kernel-owner+w=401wt.eu-S1755370AbZCKM5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370AbZCKM5d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 08:57:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753288AbZCKM5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 08:57:19 -0400
Received: from e28smtp09.in.ibm.com ([59.145.155.9]:37024 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604AbZCKM5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 08:57:18 -0400
Date: Wed, 11 Mar 2009 18:27:05 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [patch 01/11] Introducing generic hardware breakpoint handler
	interfaces
Message-ID: <20090311125705.GB9547@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20090310135018.GB3850@elte.hu> <Pine.LNX.4.44L0.0903101017040.2962-100000@iolanthe.rowland.org> <20090310145036.GI3850@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090310145036.GI3850@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 10, 2009 at 03:50:36PM +0100, Ingo Molnar wrote:
> 
> * Alan Stern <stern@rowland.harvard.edu> wrote:
> 
> > On Tue, 10 Mar 2009, Ingo Molnar wrote:
> > 
> > > * prasad@linux.vnet.ibm.com <prasad@linux.vnet.ibm.com> wrote:
> > > 
> > > 
> > > > +static u8			tprio[HB_NUM];	/* Thread bp max priorities */
> > > > +LIST_HEAD(kernel_bps);			/* Kernel breakpoint list */
> > > > +static LIST_HEAD(thread_list);			/* thread_hw_breakpoint list */
> > > > +DEFINE_PER_CPU(struct cpu_hw_breakpoint, cpu_bp);
> > 
> > If nobody minds, I'll answer some of these questions on 
> > Prasad's behalf because they address parts of the code that 
> > were written before he took over the project.
> > 
> > > hm, why do we need the whole 'priority' mechanism? It seems 
> > > very over-designed to me.
> > 
> > This was done at Roland McGrath's express request.  We should 
> > see what he has to say about it.
> > 
> > > The likelyhood of both user-space and kernel-space to use 
> > > hw-breakpoints is very low to begin with. And if they use 
> > > them, the likelyhood of there being more than 4 debugregs 
> > > required in the same context is even lower.
> > 
> > Not all architectures have 4 debug registers.  Most have only 
> > one.
> >
> > > If that happens we shouldnt try to be too smart about them - 
> > > just override user-space ones with kernel space ones and 
> > > that's it. No explicit priorities are needed.
> > 
> > Roland really did not want it done this way.
> 
> Well i guess i'll have to wait for Roland's reply then.
> 
> 	Ingo

For the benefit of continuing discussion on this topic, here's an
extract from an old mail (http://lkml.org/lkml/2007/2/5/465) from
Roland, explaining the need for prioritisation of requests. It must have
been utrace as a potential user that made him suggest this.

"I am all in favor of a facility to manage shared use of the debug
registers, such as your debugreg.h additions.  I just think it needs to be
a little more flexible.  An unobtrusive kernel facility has to get out of
the way when user-mode decides to use all its debug registers.  It's not
immediately important what it's going to about it when contention arises,
but there has to be a way for the user-mode facilities to say they need to
allocate debugregs with priority and evict other squatters.  So, something
like code allocating a debugreg can supply a callback that's made when its
allocation has to taken by something with higher priority.  

Even after utrace, there will always be the possibility of a traditional
uncoordinated user of the raw debug registers, if nothing else ptrace
compatibility will always be there for old users.  So anything new and
fancy needs to be prepared to back out of the way gracefully.  In the case
of kwatch, it can just have a handler function given by the caller to start
with.  It's OK if individual callers can specially declare "I am not
well-behaved" and eat debugregs so that well-behaved high-priority users
like ptrace just have to lose (breaking compatibility).  But no
well-behaved caller of kwatch will do that.

I certainly intend for later features based on utrace to include
higher-level treatment of watchpoints so that user debugging facilities can
also become responsive to debugreg allocation pressure.  (Eventually, the
user facilities might have easier ways of falling back to other methods and
getting out of the way of kernel debugreg consumers, than can be done for
the kernel-mode-tracing facilities.)  To that end, I'd like to see a clear
and robust interface for debugreg sharing, below the level of kwatch."

Thanks,
K.Prasad


