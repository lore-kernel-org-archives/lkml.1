Return-Path: <linux-kernel-owner+w=401wt.eu-S933793AbZJNOmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933793AbZJNOmy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 10:42:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756763AbZJNOmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 10:42:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14187 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755552AbZJNOmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 10:42:53 -0400
Date: Wed, 14 Oct 2009 10:41:15 -0400
From: Jason Baron <jbaron@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH RFC] sched: add notifier for process migration
Message-ID: <20091014144115.GA2657@redhat.com>
References: <1255125738.7439.17.camel@laptop> <4ACFBC98.4070701@goop.org> <1255158863.7866.25.camel@twins> <4AD04E50.7060001@redhat.com> <1255166662.7866.28.camel@twins> <4AD055B3.8070705@goop.org> <1255169528.7521.3.camel@laptop> <4AD4F02C.9060203@goop.org> <20091014070508.GI784@elte.hu> <1255512370.8392.373.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255512370.8392.373.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 14, 2009 at 11:26:10AM +0200, Peter Zijlstra wrote:
> On Wed, 2009-10-14 at 09:05 +0200, Ingo Molnar wrote:
> > * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> > 
> > > @@ -1981,6 +1989,12 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
> > >  #endif
> > >  		perf_swcounter_event(PERF_COUNT_SW_CPU_MIGRATIONS,
> > >  				     1, 1, NULL, 0);
> > > +
> > > +		tmn.task = p;
> > > +		tmn.from_cpu = old_cpu;
> > > +		tmn.to_cpu = new_cpu;
> > > +
> > > +		atomic_notifier_call_chain(&task_migration_notifier, 0, &tmn);
> > 
> > We already have one event notifier there - look at the 
> > perf_swcounter_event() callback. Why add a second one for essentially 
> > the same thing?
> > 
> > We should only put a single callback there - a tracepoint defined via 
> > TRACE_EVENT() - and any secondary users can register a callback to the 
> > tracepoint itself.
> > 
> > There's many similar places in the kernel - with notifier chains and 
> > also with a need to get tracepoints there. The fastest (and most 
> > consistent) solution is to add just a single event callback facility.
> 
> But that would basically mandate tracepoints to be always enabled, do we
> want to go there?
> 
> I don't think the overhead of tracepoints is understood well enough,
> Jason you poked at that, do you have anything solid on that?
> 

Currently, the cost of the tracepoint is the global memory read, and
compare, and then a jump. On x86 systems that I've tested this can average
anywhere b/w 40 - 100 cycles per tracepoints. Plus, there is the
icache overhead of the extra instructions that we skip over. I'm not
sure how to measure that beyond looking at their size.

I've proposed a 'jump label' set of patches, which essentially hard
codes a jump around the disabled code (avoiding the memory reference).
However, this introduces a high 'write' cost in that we code patch the
jmp to a 'jmp 0' to enable the code.

Along with this optimization I'm also looking into a method for moving
the disabled text to a 'cold' text section, to reduce the icache
overhead. Using these techniques we can reduce the disabled case to
essentially a couple of cycles per tracepoint.

In this case, where the tracepoint is always on, we wouldn't want to
move the tracepoint text to a cold section. Thus, I could introduce a
default enabled/disabled bias to the tracepoint.

However, in introducing such a feature, we are essentially forcing an
always on, or always off usage pattern, since the switch cost is high.
So I want to be careful not limit usefullness of tracepoints with such
an optimization.

thanks,

-Jason
