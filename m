Return-Path: <linux-kernel-owner+w=401wt.eu-S1762216AbZCYSQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762216AbZCYSQm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 14:16:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754379AbZCYSQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 14:16:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:49454 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079AbZCYSQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 14:16:32 -0400
Date: Wed, 25 Mar 2009 14:16:29 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tim Bird <tim.bird@am.sony.com>, Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/5][RFC] tracing: move function profiler data out of
 function struct
In-Reply-To: <20090325180203.GB25518@elte.hu>
Message-ID: <alpine.DEB.2.00.0903251411260.5675@gandalf.stny.rr.com>
References: <20090325035646.662994901@goodmis.org> <20090325040832.443420395@goodmis.org> <20090325100746.GI2341@elte.hu> <alpine.DEB.2.00.0903251142470.5675@gandalf.stny.rr.com> <20090325174446.GE14250@elte.hu> <alpine.DEB.2.00.0903251354020.5675@gandalf.stny.rr.com>
 <20090325180203.GB25518@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 25 Mar 2009, Ingo Molnar wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > 
> > On Wed, 25 Mar 2009, Ingo Molnar wrote:
> > 
> > > > The atomic_inc_return protects against NMIs, since this is the only place 
> > > > the lock is taken.
> > > 
> > > i mean, if this code executes _ni_ an NMI. Or that cannot happen? We 
> > > trace nmis too, dont we?
> > 
> > Yes, it can execute in an NMI, but we have no issues there. If the 
> > lock was taken the atomic inc is set. If an NMI comes in, it will 
> > fail the atomic inc counter test and never try to take the lock.
> 
> You are misunderstanding me. Can this bit:

Ah thanks,

> 
> > > +   if (!profile_pages->next && alloc_safe)
> > > +           profile_pages->next = (void *)get_zeroed_page(GFP_ATOMIC);
> 
> run in NMI context?
> 
> or is alloc_safe false in that case? Even if it's safe it looks 
> really messy ...

alloc_safe is true only if interrupts were enabled, preemption is enabled 
and we are not in an interrupt or softirq.

So, it should fail when in NMI.

But I agree, it is messy, and I never liked it. I was trying to save 
space, but the space saving is probably not worth the messy code.

For every recorded function we have:

struct ftrace_profile {
	struct hlist_node	*node;
	unsigned long		ip;
	unsigned long		hit;
	unsigned long long	calltime;
};

on x86_64 that is 40 bytes. (node is 16, ip is 8, hit is 8, calltime is 8)

Thus, a normal distro kernel has 20,000 functions, and if we were to 
allocate for every function per online cpu, we have:

 20K * 40 = 800K per online CPU.

But we allocate only when we use it. Though it must be warned, because 
when we use it we must always be able to reference it, that memory stays 
allocated. If this becomes an issue, I can add a way to clean the results 
and free the memory.

I guess 800K per online CPU is not worth the messy code. I'll write up a 
patch to fix that.

-- Steve

