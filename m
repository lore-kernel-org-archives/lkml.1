Return-Path: <linux-kernel-owner+w=401wt.eu-S1752462AbZG1ASw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462AbZG1ASw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 20:18:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbZG1ASv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 20:18:51 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:51590 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbZG1ASu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 20:18:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=H+nRvgZ8vKfK6qaBprWrcLBT1H4+mh810YXVM6kX+k2gHy6GbUzkJA+67WkxJg3a7G
         XsEieKPRR7agWFrC8vqRkvEa7hijDQa/paIQFnmY/83sNGFBRItBtrCyA62wqLT2sKuS
         oT8MisMmtG8QHLUKfO0MKxbgDKSDtXLqWvKGo=
Date: Tue, 28 Jul 2009 02:18:46 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Anton Blanchard <anton@samba.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "K . Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH 5/5] perfcounter: Add support for kernel hardware
	breakpoints
Message-ID: <20090728001844.GA5147@nowhere>
References: <1248109687-7808-1-git-send-email-fweisbec@gmail.com> <1248109687-7808-6-git-send-email-fweisbec@gmail.com> <1248354493.26273.2.camel@twins> <c62985530907240702h2b2de14bw2f0d475f46067e4e@mail.gmail.com> <1248445569.6987.74.camel@twins> <20090724174723.GA11985@nowhere> <1248519416.5780.12.camel@laptop> <20090725141918.GA5295@nowhere> <1248538972.5780.25.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248538972.5780.25.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 25, 2009 at 06:22:52PM +0200, Peter Zijlstra wrote:
> On Sat, 2009-07-25 at 16:19 +0200, Frederic Weisbecker wrote:
> 
> > > Ah, but that is sub-optimal, perf counters doesn't actually change the
> > > state if both tasks have the same counter configuration. Yielding a
> > > great performance benefit on scheduling intensive workloads. Poking at
> > > these MSRs, esp. writing to them is very expensive.
> > 
> > 
> > Ah ok.
> > 
> >  
> > > So I would suggest not using that feature of the breakpoint API for the
> > > perf counter integration.
> > 
> > 
> > That would forbid some kinds of profiling (explanations below).
> > 
> > 
> > > > However, this patchset only deals with kernel breakpoint for now (wide
> > > > tracing).
> > > 
> > > Right, and that's all you would need for perf counter support, please
> > > don't use whatever task state handling you have in place.
> > 
> > 
> > I would actually propose to have a separate layer that manages
> > the hardware registers <-> per thread virtual registers handling
> > for things like breakpoint api and perfcounter.
> > 
> > I know a simple RR of registers is not that hard to write, but at
> > least that can allow simultaneous use of perfcounter and other users
> > of breakpoint API without having  two different versions of register
> > management.
> 
> I simply cannot see how you would be able to multiplex userspace/debug
> breakpoints. I'd utterly hate it if I'd missed a breakpoint simply
> because someone else also wanted to make use of it.


What I mean by multiplexing is that, say in x86, each task can have
4 breakpoints maximum. Once the task is scheduled out, its breakpoints
are saved and the hardware debug registers are used for the next task.
Once a task registers a breakpoint, it never looses it.

 
> I'd declare the system broken and useless.
> 
> Counters OTOH can be multiplexed because of their statistical nature,
> you can simply scale them back up based on their time share.
> 
> Therefore you'll have to deal with hard reservations anyway.
> 
> Also, you don't need to a-priory reserve all breakpoints, you'll simply
> need as many as the largest group (wrt breakpoints) has.

I still don't understand why it is needed to reserve breakpoints for
a group of monitored tasks. Once they have registered their breakpoints,
the number of necessary hardware registers for these will be available
every time the task is scheduled.

By nature, MAX_NR (4 in x86) breakpoints are available for every tasks, minus
the number of wide kernel breakpoints in use.

I don't see the need of a reservation here (which is already done by the API),
I feel a bit confused in this debate.

