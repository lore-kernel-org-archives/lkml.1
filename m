Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757004Ab0BEPHf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 10:07:35 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:64866 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756860Ab0BEPHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 10:07:34 -0500
X-Authority-Analysis: v=1.0 c=1 a=I-JJUczq-h8A:10 a=7U3hwN5JcxgA:10 a=cSO2TwNd55vs58XwrioA:9 a=ocU2zQ1OOGZc23lXetIA:7 a=7ln1613p3qGR1QhPpBNAC4lIXZUA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 02/11] tracing: Introduce TRACE_EVENT_INJECT
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>
In-Reply-To: <1265381604.22001.682.camel@laptop>
References: <1265188475-23509-1-git-send-regression-fweisbec@gmail.com>
	 <1265188475-23509-3-git-send-regression-fweisbec@gmail.com>
	 <1265381266.24386.32.camel@gandalf.stny.rr.com>
	 <1265381604.22001.682.camel@laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 05 Feb 2010 10:07:32 -0500
Message-ID: <1265382452.24386.38.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-05 at 15:53 +0100, Peter Zijlstra wrote:
> On Fri, 2010-02-05 at 09:47 -0500, Steven Rostedt wrote:
> > On Wed, 2010-02-03 at 10:14 +0100, Frederic Weisbecker wrote:
> > > TRACE_EVENT_INJECT macro is the same as TRACE_EVENT but takes one
> > 
> > >  #undef DEFINE_EVENT
> > >  #define DEFINE_EVENT(template, call, proto, args)		\
> > >  static void ftrace_profile_##call(proto)			\
> > > diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> > > index 189b09b..5c75cc7 100644
> > > --- a/kernel/trace/trace_events.c
> > > +++ b/kernel/trace/trace_events.c
> > > @@ -142,6 +142,9 @@ static int ftrace_event_enable_disable(struct ftrace_event_call *call,
> > >  				break;
> > >  			}
> > >  			call->enabled = 1;
> > > +
> > > +			if (call->inject)
> > > +				call->inject();
> > >  		}
> > >  		break;
> > >  	}
> > 
> > With the proposal I'm suggesting:
> > 
> > register_event_command(event, NULL, NULL, inject_me, inject_me, data);
> > 
> > The above would do basically what this patch does. When ever the event
> > is enabled or disabled the inject_me function will be called.
> > 
> > Would this work?
> 
> No, because a dump all inject sucks chunks.

How would it be dumping all?

You need to pick an event to register, not all events will do this.

How is this different than defining a TRACE_EVENT_INJECT()?  Now
lock_class_init will always call this inject.

What I am proposing is to add the lock_class_init just as TRACE_EVENT()
and then in a initcall, do:

register_event_command("lock_class_init", NULL, NULL, inject_me, 
			inject_me, data);

The above would have lock_class_init, when enabled or disabled call
inject_me. Isn't that exactly what the TRACE_EVENT_INJECT() is doing?

I have no qualms about adding lock_class_init, I just don't think we
need another TRACE_EVENT macro, that is very inflexible. I rather
consolidate the macros in ftrace.h than be adding new ones.

-- Steve


