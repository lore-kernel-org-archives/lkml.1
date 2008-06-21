Return-Path: <linux-kernel-owner+w=401wt.eu-S1754107AbYFUPHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107AbYFUPHq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 11:07:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751145AbYFUPHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 11:07:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:63879 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbYFUPHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 11:07:37 -0400
Date: Sat, 21 Jun 2008 11:07:35 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: "Frank Ch. Eigler" <fche@redhat.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>,
       Hideo AOKI <haoki@redhat.com>
Subject: Re: [RFC][Patch 2/2] markers: example of irq regular kernel markers
In-Reply-To: <y0mwskiyh36.fsf@ton.toronto.redhat.com>
Message-ID: <Pine.LNX.4.58.0806211058510.28481@gandalf.stny.rr.com>
References: <20080620174529.GB10943@Krystal> <485C064E.5020705@redhat.com>
 <20080621190132.E835.KOSAKI.MOTOHIRO@jp.fujitsu.com>
 <Pine.LNX.4.58.0806211013300.32694@gandalf.stny.rr.com>
 <y0mwskiyh36.fsf@ton.toronto.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 21 Jun 2008, Frank Ch. Eigler wrote:
> Steven Rostedt <rostedt@goodmis.org> writes:
>
> > [...]  Format strings only help for printf like operations. [...]
>
> That is not so.  They are far from panaceanic, but printf formats are
> useful for type checked simple scalars, which we can extract and use
> for purposes other than printf like operations.

It doesn't help much if you mix a pid and prio of a task_struct, and then
use the prio to find the actual task, or try setting another task priority
to the pid.

>
> > The best example of this is the sched_switch code. LTTng and friends
> > just want a pid and comm to show. But there's tracers that want more
> > info from the task_struct. We also like to see the priority of the
> > task.  [...]
>
> This is the sort of information that can help generate a compromise.
> For this case, pass a few raw pointers that a compiled-in tracing
> engine can dereference at will, and *also pass* a few user-level
> scalars that a separately-compiled tracing engine can use.

I definitely want the raw pointers for my tracers, but I understand
why other tracers don't want them.  And yes I would like a compromise
here.  I'm hoping for something where I don't need to skip over the
scalers to get to the needed pointers. Things that Masami is suggesting
is looking promising.


>
> > Passing in a pointer to the structure being traced should be enough
> > for all tracers.
>
> On the contrary, we have explained why *this is not so*.  Using raw
> general structure pointers in impractical for some tracers.

The thing that those tracers need is something that can be stored in the
kernel that can easily extract the needed information.

>
> > Now back to your question, why don't we like the printf
> > format. Simply because it does nothing for pointers. It might help
> > you with a %d and number of parameters, but a %p can not tell the
> > difference between a struct tasks_struct *, and a int *, which can
> > have even more devastating results.
>
> Indeed.  Unfortunately, C is not kind to us in the way that perhaps
> C++ templates could be.  We have not yet seen a single mechanism that
> does all of:
>
> - type-safe passing of arbitrary pointer/etc. types (so compiled-in
>   trace data consumers can go wild with data passing)
> - declarative / separately-compiled consumption of types
>   (so lttng/systemtap/userspace can hook in without heroics)
> - parsimonious implementation
>
> Maybe a solution could involve some restrictions on the generalities.
> For example, can we narrow down the number of different scalar +
> pointer types to a fixed handful?  Can we tolerate type-safety being
> provided by families of function declarations rather than one generic
> one?

I'm all for restricting this, I even suggested something similar a while
ago (http://lists.openwall.net/linux-kernel/2006/10/07/21). No, I'm not
pushing that solution, that solution was only to bring out more ideas.

>
>
> > It also just looks like a debug session instead of a trace marker.
>
> Why do you think the difference between those is profound?

Not that profound but I do find:

  trace_sched_switch(prev, next);

much nicer to look at than

  trace_mark("%p %p", prev, next);


The trace_sched_switch seems a bit more informative with a simple glance
than the trace_mark.

-- Steve

