Return-Path: <linux-kernel-owner+w=401wt.eu-S1758073AbYEVRxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073AbYEVRxR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 13:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755507AbYEVRxD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 13:53:03 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:40540 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755443AbYEVRxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 13:53:01 -0400
Date: Thu, 22 May 2008 13:52:59 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: trace_mark ugliness
In-Reply-To: <20080522171602.GB22806@Krystal>
Message-ID: <Pine.LNX.4.58.0805221346170.14724@gandalf.stny.rr.com>
References: <Pine.LNX.4.58.0805220949560.14724@gandalf.stny.rr.com>
 <20080522171602.GB22806@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 22 May 2008, Mathieu Desnoyers wrote:
> > The thing that bothers us the most is the force use of the "pretty print"
> > interface. There's got to be a better way. I'd much rather see a
> > file_marker.h file that has the interfaces defined, like what we have for
> > sched.c.
> >
> > Where we have a sched_trace.h that has the defined prototypes. That is
> > what the tracers should use too.
> >
> > The trace_mark should just have the string to find the tracer, but get rid
> > of the "pretty print" aspect of it. Sorry, but the more I think about it,
> > the nastier it seems. It forces all the users to do a va_start.
> >
> > I know you developed trace_mark for LTT, and that's great. But where I'm
> > disagreeing is that you should not force all other users of trace_mark to
> > conform to the LTT way when it can be easier to have LTT conform to a more
> > generic way.
> >
> > Hence, this is what I propose.
> >
> > Remove the format part altogether, the format should be checked via the
> > prototype. I know that you are afraid of changes to markers and that
> > breaking code, but honestly, that is up to the developers of the tracers
> > to fix. This should not be placed in the code itself. The markers
> > shouldn't change anyway. If there is to be a check, it should be a compile
> > time check (i.e. prototype compare) not a runtime check (as it is now).
> >
>
> Hrm, hrm, ok, let's brainstorm along these lines. So we would like to

Great! This is what I wanted to hear. I sent this email out to start up
a brainstorming session.

> have :
> - Multiple tracers
> - Each tracer can connect either to one or more different markers
> - Each marker should support many tracers connected to it
> - Checking for marker/tracer probe compatibility should be done via
>   function prototypes.

>
> The main issue here seems to be to support multiple probes connected at
> once on a given marker. With the current markers, I deal with this by
> taking a pointer on the va_list and go through as many va_start/va_end
> as required (one pair for each connected probe). By the way, the probes
> does not have to issue va_start/end; marker.c deals with this.

Interesting.

>
> Also, given that I want to support SystemTAP, it adds the following
> constraint : we cannot expect the probes to be there at compile-time,
> since they can be provided by modules built much later. Therefore, we
> have to provide support for dynamic connection of an arbitrary number of
> probes on any given marker.

Yep understood.

>
> So while I *could* remove the format string easily, it's the variable
> argument list which I don't see clearly how to drop while still
> providing flexible argument types -and- compile-time type verification.
>
> What currently looks like (this is a simplified pseudo-code) :
>
> void marker_probe_cb(const struct marker *mdata, void *call_private, ...)
> {
>   va_list args;
>   int i;
>
>   preempt_disable();
>   for (i = 0; multi[i].func; i++)  {
>     va_start(args, call_private);
>     multi[i].func(multi[i].probe_private, call_private,
>       mdata->format, &args);
>     va_end(args);
>   }
>   preempt_enable();
> }
>
> Would have to be changed into specialized functions for each marker,
> involving quite a lot of code to be generated, e.g. :
>
> void marker_XXnameXX_probe_cb(const struct marker *mdata,
>     int arg1, void *arg2, struct mystruct *arg3)
> {
>   int i;
>
>   preempt_disable();
>   for (i = 0; multi[i].func; i++)
>     multi[i].func(multi[i].probe_private, arg1, arg2, arg3);
>   preempt_enable();
> }
>
> That would imply that the struct marker_probe_closure, currently defined
> as :
>
> typedef void marker_probe_func(void *probe_private, void *call_private,
>                 const char *fmt, va_list *args);
>
> struct marker_probe_closure {
>         marker_probe_func *func;        /* Callback */
>         void *probe_private;            /* Private probe data */
> };
>
> Would have to be duplicated for each marker prototype so we can provide
> compile-time check of these prototypes. The registration functions would
> also have to be duplicated to take parameters which include all those
> various prototypes. They are required so that kernel modules can provide
> probes (e.g. systemtap and LTTng).
>
> I don't really see how your proposal deals with these constraints
> without duplicating much of the marker code on a per marker basis.
> However, if we can find a clever way to do it without the code
> duplication, I'm all in.
>
> Ideas/insights are welcome,

Thanks for explaining this more. I'll try to think of some tricks to
handle this. It may end up that we have to have the format after all, but
it still just seems a bit messy. If we can encapsulate this into some
compile time tricks, without duplicating code all over the place, then
this that would be the way I would like to go.

I CC'd others in hoping that they too might have some clever tricks to
solve this.

Thanks Mathieu!

-- Steve

