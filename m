Return-Path: <linux-kernel-owner+w=401wt.eu-S1752557AbYKFVUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557AbYKFVUk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 16:20:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447AbYKFVUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 16:20:09 -0500
Received: from mx2.redhat.com ([66.187.237.31]:58773 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005AbYKFVUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 16:20:07 -0500
Date: Thu, 6 Nov 2008 16:18:56 -0500
From: Jason Baron <jbaron@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Frank Ch. Eigler" <fche@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, alan@redhat.com,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH] ftrace: add an fsync tracer
Message-ID: <20081106211856.GC3167@redhat.com>
References: <1225976138.7803.4485.camel@twins> <20081106060624.58a0f967@infradead.org> <1225981141.7803.4577.camel@twins> <20081106063108.02b4813d@infradead.org> <1225983052.7803.4623.camel@twins> <20081106070157.065b2dcc@infradead.org> <alpine.DEB.1.10.0811061020311.31011@gandalf.stny.rr.com> <20081106094558.50d94bcc@infradead.org> <y0mej1ofvyz.fsf@ton.toronto.redhat.com> <1226003343.31966.43.camel@lappy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226003343.31966.43.camel@lappy.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2008 at 09:29:03PM +0100, Peter Zijlstra wrote:
> On Thu, 2008-11-06 at 15:19 -0500, Frank Ch. Eigler wrote:
> > Arjan van de Ven <arjan@infradead.org> writes:
> > 
> > > [...]
> > > what is the real need is
> > > 1) Have a trace point in the source
> > > 2) Associate a "formatting function" with that point 
> > >    (which basically transforms the trace parameters to, say, a string)
> > > 3) A way to turn the trace point on/off.
> > 
> > For 1 and 2, it may be worth considering a plain trace_mark() in
> > do_sync().  The complication that makes this uglier than a one-liner
> > is d_path()'s buffer and error handling.
> > 
> >     {
> >     char *buffer = kzalloc (4096, GFP_KERNEL);
> >     trace_mark(fsync, "Process %s is calling fsync on %s\n",
> >                        current->comm,
> >                        ({char *err = d_path (...);
> >                          IS_ERR(err) ? "?" : err;}));
> >     kfree (buffer);
> >     }
> > 
> > With a bit of extension on the marker front, the allocation could be
> > made conditional on the marker being enabled.
> > 
> > 
> > For 3, the kernel could merge a backend that connects arbitrary
> > markers to an ftrace (or whatever) buffer.  Several compact prototypes
> > for the latter exist.
> 
> 
> I prefer we keep using trace points but do what jason has been proposing
> for a while, which is add a format and arg list to the trace point
> definition.
> 
> Something like
> 
> DEFINE_TRACE_FMT(sched_switch,
> 	TPPROTO(struct rq *rq, struct task_struct *prev,
> 		 struct task_struct *next),
> 	TPARGS(rq, prev, next),
> 	TPFMT("%d to %d\n", prev->pid, next->pid));
> 
> Which would be similar to attaching a trace_mark() to the trace point
> and can in these cases save a lot of lines of code.
> 
> Both lttng and the ftrace event tracer can use these default text
> strings.
> 

indeed...done this way I believe marker registration could then be
done directly with the tracepoint itself. That is, callers that
want the tracepoint interface register directly with the tracepoint and get 
called as before. However, callers that want the marker interface register 
directly with the tracepoint and get passed the associated marker string and 
arguments. Then, we could consolidate kernel/marker.c into kernel/tracepoint.c,
which would simlify things, and reduce code duplication.

thanks,

-Jason
