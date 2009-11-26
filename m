Return-Path: <linux-kernel-owner+w=401wt.eu-S1759663AbZKZLXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759663AbZKZLXn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 06:23:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758958AbZKZLXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 06:23:43 -0500
Received: from casper.infradead.org ([85.118.1.10]:42700 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758946AbZKZLXm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 06:23:42 -0500
Subject: Re: [PATCH 1/4 tip/sched/core] sched: rename preempt_notifier to
 sched_notifier and always enable it
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tejun Heo <tj@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <1259231565.4273.31.camel@twins>
References: <20091126190018.88a6dd77.sfr@canb.auug.org.au>
	 <20091126081237.GA31034@elte.hu> <4B0E4741.10509@kernel.org>
	 <20091126092631.GA17253@elte.hu> <4B0E4EFB.2070705@kernel.org>
	 <20091126095154.GE32275@elte.hu> <4B0E5458.30303@kernel.org>
	 <20091126102936.GA1196@elte.hu>  <1259231565.4273.31.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 26 Nov 2009 12:23:39 +0100
Message-ID: <1259234619.4273.32.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-26 at 11:32 +0100, Peter Zijlstra wrote:
> On Thu, 2009-11-26 at 11:29 +0100, Ingo Molnar wrote:
> > * Tejun Heo <tj@kernel.org> wrote:
> > 
> > > Rename preempt_notifier to sched_notifier, move it from preempt.h to 
> > > sched.h, drop sched_ prefixes from ops names and make sched_notifier 
> > > always enabled.
> > > 
> > > This is to prepare for adding more notification hooks.  This patch 
> > > doesn't make any functional changes.
> > 
> > The sched notifiers and the various event notifiers we have in the same 
> > codepaths should really be unified into a single callback framework.
> > 
> > We have these _5_ callbacks:
> > 
> > ....
> >         perf_event_task_sched_out(prev, next, cpu);
> > ....
> >         fire_sched_out_notifiers(prev, next);
> > ....
> >         trace_sched_switch(rq, prev, next);
> > ....
> >         perf_event_task_sched_in(current, cpu_of(rq));
> > 	fire_sched_in_notifiers(current);
> > ....
> > 
> > That could be done with just two callbacks - one for sched-out, one for 
> > sched-in.
> > 
> > The best way to do that would be to use two TRACE_EVENT() callbacks, 
> > make them unconditional and register to them. (with wrappers to make it 
> > all convenient to use)
> > 
> > This requires some work but needs to be done.
> 
> Ugh,.. it also makes TRACE_EVENT unconditional.
> 
> That really wants a separate option.. What we could do is take regular
> notifier lists and extend them to auto-generate a tracepoint when the
> trace stuff is enabled or something.

Also, there is this thing about direct and indirect function calls.
