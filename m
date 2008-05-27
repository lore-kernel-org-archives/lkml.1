Return-Path: <linux-kernel-owner+w=401wt.eu-S1758271AbYE0NhE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758271AbYE0NhE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 09:37:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757307AbYE0Ngz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 09:36:55 -0400
Received: from tomts5.bellnexxia.net ([209.226.175.25]:64488 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756581AbYE0Ngy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 09:36:54 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlAFAH+lO0hMQWqh/2dsb2JhbACBVawJ
Date: Tue, 27 May 2008 09:36:51 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: trace_mark ugliness
Message-ID: <20080527133651.GA9428@Krystal>
References: <Pine.LNX.4.58.0805220949560.14724@gandalf.stny.rr.com> <20080522171602.GB22806@Krystal> <1211714403.6463.294.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1211714403.6463.294.camel@lappy.programming.kicks-ass.net>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:33:45 up 88 days,  9:44,  4 users,  load average: 0.31, 0.58,
	0.58
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Thu, 2008-05-22 at 13:16 -0400, Mathieu Desnoyers wrote:
> 
> > > The thing that bothers us the most is the force use of the "pretty print"
> > > interface. There's got to be a better way. I'd much rather see a
> > > file_marker.h file that has the interfaces defined, like what we have for
> > > sched.c.
> > > 
> > > Where we have a sched_trace.h that has the defined prototypes. That is
> > > what the tracers should use too.
> > > 
> > > The trace_mark should just have the string to find the tracer, but get rid
> > > of the "pretty print" aspect of it. Sorry, but the more I think about it,
> > > the nastier it seems. It forces all the users to do a va_start.
> > > 
> > > I know you developed trace_mark for LTT, and that's great. But where I'm
> > > disagreeing is that you should not force all other users of trace_mark to
> > > conform to the LTT way when it can be easier to have LTT conform to a more
> > > generic way.
> > > 
> > > Hence, this is what I propose.
> > > 
> > > Remove the format part altogether, the format should be checked via the
> > > prototype. I know that you are afraid of changes to markers and that
> > > breaking code, but honestly, that is up to the developers of the tracers
> > > to fix. This should not be placed in the code itself. The markers
> > > shouldn't change anyway. If there is to be a check, it should be a compile
> > > time check (i.e. prototype compare) not a runtime check (as it is now).
> > > 
> > 
> > Hrm, hrm, ok, let's brainstorm along these lines. So we would like to
> > have :
> > - Multiple tracers
> > - Each tracer can connect either to one or more different markers
> > - Each marker should support many tracers connected to it
> > - Checking for marker/tracer probe compatibility should be done via
> >   function prototypes.
> > 
> > The main issue here seems to be to support multiple probes connected at
> > once on a given marker. With the current markers, I deal with this by
> > taking a pointer on the va_list and go through as many va_start/va_end
> > as required (one pair for each connected probe). By the way, the probes
> > does not have to issue va_start/end; marker.c deals with this.
> > 
> > Also, given that I want to support SystemTAP, it adds the following
> > constraint : we cannot expect the probes to be there at compile-time,
> > since they can be provided by modules built much later. Therefore, we
> > have to provide support for dynamic connection of an arbitrary number of
> > probes on any given marker.
> > 
> > So while I *could* remove the format string easily, it's the variable
> > argument list which I don't see clearly how to drop while still
> > providing flexible argument types -and- compile-time type verification.
> > 
> > What currently looks like (this is a simplified pseudo-code) :
> > 
> > void marker_probe_cb(const struct marker *mdata, void *call_private, ...)
> > {
> >   va_list args;
> >   int i;
> > 
> >   preempt_disable();
> >   for (i = 0; multi[i].func; i++)  {
> >     va_start(args, call_private);
> >     multi[i].func(multi[i].probe_private, call_private,
> >       mdata->format, &args);
> >     va_end(args);
> >   }
> >   preempt_enable();
> > }
> > 
> > Would have to be changed into specialized functions for each marker,
> > involving quite a lot of code to be generated, e.g. :
> > 
> > void marker_XXnameXX_probe_cb(const struct marker *mdata,
> >     int arg1, void *arg2, struct mystruct *arg3)
> > {
> >   int i;
> > 
> >   preempt_disable();
> >   for (i = 0; multi[i].func; i++)
> >     multi[i].func(multi[i].probe_private, arg1, arg2, arg3);
> >   preempt_enable();
> > }
> > 
> > That would imply that the struct marker_probe_closure, currently defined
> > as :
> > 
> > typedef void marker_probe_func(void *probe_private, void *call_private,
> >                 const char *fmt, va_list *args);
> > 
> > struct marker_probe_closure {
> >         marker_probe_func *func;        /* Callback */
> >         void *probe_private;            /* Private probe data */
> > };
> > 
> > Would have to be duplicated for each marker prototype so we can provide
> > compile-time check of these prototypes. The registration functions would
> > also have to be duplicated to take parameters which include all those
> > various prototypes. They are required so that kernel modules can provide
> > probes (e.g. systemtap and LTTng).
> > 
> > I don't really see how your proposal deals with these constraints
> > without duplicating much of the marker code on a per marker basis.
> > However, if we can find a clever way to do it without the code
> > duplication, I'm all in.
> > 
> > Ideas/insights are welcome,
> 
> How about something like:
> 
> marker.c:
> 
> void __trace_mark(const struct marker *mdata, va_list *args)
> {
> 	int i;
> 
> 	preempt_disable();
> 	for (i = 0; multi[i].func; i++) {
> 		va_list l;
> 
> 		va_copy(l, *args);
> 		multi[i].func(multi[i].probe_private, &l);
> 		va_end(l);
> 	}
> 	preempt_enable();
> }
> 
> 
> marker.h:
> 
> #define TRACE_FUNC(name, args...)				\
> static inline void trace_##name(const struct marker *mdata, ## args) \
> {								\
> 	va_list l;						\
> 	va_start(l, mdata);					\
> 	__trace_mark(mdata, &l);				\
> 	va_end(l);						\
> }
> 
> #define TRACE_MARK(name, args...)				\
> 	trace_##name(trace_##name##_data, ## args)
> 
> TRACE_FUNC(sched_switch, const struct task_struct *prev, const struct task_struct *next)
> 
> 
> sched.c:
> 
> 	TRACE_MARK(sched_switch, prev, next);
> 

Hi Peter,

Thanks for looking into this. There seems that there are a few problems
with the solution you propose. The first problem being that there is a
va_start in a function taking fixed arguments (the generated
trace_##name function).

The second problem I see is that the callback registered to be called by
multi[i].func(multi[i].probe_private, &l); will have no type checking at
all, so the type checking problem is still present.

Mathieu



-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
