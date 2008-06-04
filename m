Return-Path: <linux-kernel-owner+w=401wt.eu-S1762452AbYFDW2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762452AbYFDW2i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 18:28:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753274AbYFDW2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 18:28:31 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36963 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbYFDW2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 18:28:30 -0400
Subject: Re: Kernel marker has no performance impact on ia64.
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Hideo AOKI <haoki@redhat.com>, mingo@elte.hu,
       Masami Hiramatsu <mhiramat@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20080602232135.GA20173@Krystal>
References: <48447052.3030300@redhat.com>
	 <1212445965.6269.22.camel@lappy.programming.kicks-ass.net>
	 <20080602232135.GA20173@Krystal>
Content-Type: text/plain
Date: Thu, 05 Jun 2008 00:27:29 +0200
Message-Id: <1212618449.19205.35.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-02 at 19:21 -0400, Mathieu Desnoyers wrote:
> * Peter Zijlstra (peterz@infradead.org) wrote:
> > On Mon, 2008-06-02 at 18:12 -0400, Hideo AOKI wrote:
> > > Hello,
> > > 
> > > I evaluated overhead of kernel marker using linux-2.6-sched-fixes
> > > git tree, which includes several markers for LTTng, using an ia64
> > > server.
> > > 
> > > While the immediate trace mark feature isn't implemented on ia64,
> > > there is no major performance regression. So, I think that we 
> > > don't have any issues to propose merging marker point patches 
> > > into Linus's tree from the viewpoint of performance impact.
> > 
> > Performance is atm the least of the concerns regarding this work.
> > 
> > I'm still convinced markers are too ugly to live.
> > 
> > I also worry greatly about the fact that its too easy to expose too much
> > to user-space. There are no clear rules and the free form marker format
> > just begs for an inconsistent mess to arise.
> > 
> > IMHO the current free-form trace_mark() should be removed from the tree
> > - its great for ad-hoc debugging but its a disaster waiting to happen
> > for anything else. Anybody doing ad-hoc debugging can patch it in
> > themselves if needed.
> > 
> > Regular trace points can be custom made; this has the advantages that it
> > raises the implementation barrier and hopefully that encourages some
> > thought in the process. It also avoid the code from growing into
> > something that looks like someone had a long night of debugging.
> > 
> 
> Maybe we could settle for an intermediate solution : I agree with you
> that defining the trace points in headers, like you did for the
> scheduler, makes the code much cleaner and makes things much easier to
> maintain afterward. However, having the trace_mark mechanism underneath
> helps a lot in plugging a generic tracer (actually, if we can settle the
> marker issue, I've got a kernel tracer, LTTng, that I've been waiting
> for quite a while to push to mainline that I would like to post someday).
> 
> So I would be in favor of requiring tracing statements to be described
> in static inline functions, in header files, that could preferably call
> trace_mark() and optionally also call other in-kernel tracers directly.
> 
> Ideally, we could re-use the immediate values infrastructure to control
> activation of these trace points with minimal impact on the system.
> 
> One of my goal is to provide a mechanism that can feed both non-debug
> and debug information to a generic tracing mechanism to allow
> system-wide analysis of the kernel, both for production system and
> kernel debugging.

So are you proposing something like:

static inline void 
trace_sched_switch(struct task_struct *prev, struct task_struct *next)
{
	trace_mark(sched_switch, prev, next);
}

dropping the silly fmt string but using the multiplex of trace_mark, and
then doing the stringify bit:

       "prev_pid %d next_pid %d prev_state %ld\n"

in the actual tracer?


IMHO the 'type safety' of the fmt string is over-rated, since it cannot
distinguish between a task_struct * or a bio *, both are a pointers -
and half arsed type safely is worse than no type safety.



