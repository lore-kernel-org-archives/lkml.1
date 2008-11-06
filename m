Return-Path: <linux-kernel-owner+w=401wt.eu-S1751434AbYKFVxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434AbYKFVxh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 16:53:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752146AbYKFVxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 16:53:14 -0500
Received: from tomts10.bellnexxia.net ([209.226.175.54]:53048 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751422AbYKFVxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 16:53:13 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtcEALTzEklMQWxa/2dsb2JhbACBdspNg1Y
Date: Thu, 6 Nov 2008 16:53:11 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Frank Ch. Eigler" <fche@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, alan@redhat.com, jbaron@redhat.com
Subject: Re: [PATCH] ftrace: add an fsync tracer
Message-ID: <20081106215310.GA15163@Krystal>
References: <1225976138.7803.4485.camel@twins> <20081106060624.58a0f967@infradead.org> <1225981141.7803.4577.camel@twins> <20081106063108.02b4813d@infradead.org> <1225983052.7803.4623.camel@twins> <20081106070157.065b2dcc@infradead.org> <alpine.DEB.1.10.0811061020311.31011@gandalf.stny.rr.com> <20081106094558.50d94bcc@infradead.org> <y0mej1ofvyz.fsf@ton.toronto.redhat.com> <1226003343.31966.43.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1226003343.31966.43.camel@lappy.programming.kicks-ass.net>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:50:28 up 155 days,  2:30,  5 users,  load average: 4.26, 2.90,
	1.72
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
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
> 

Argh. No, please. Doing this would end up exposing the inner kernel API
(the tracepoints) directly to userspace.

I've done an addition to the markers which does approximately the same.
It's in the -lttng tree now, I should post it soon.

A new marker type, trace_mark_tp() also takes a tracepoint name as
parameter. When the tracepoint is enabled, it also enables the
associated tracepoint. And it makes sure tracepoints are not exposed to
userspace.

Mathieu



-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
