Return-Path: <linux-kernel-owner+w=401wt.eu-S1755926AbZBYNup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926AbZBYNup (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 08:50:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751662AbZBYNug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 08:50:36 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:34475 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbZBYNuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 08:50:35 -0500
Date: Wed, 25 Feb 2009 08:50:31 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Lai Jiangshan <laijs@cn.fujitsu.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jason Baron <jbaron@redhat.com>, Martin Bligh <mbligh@google.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/4] tracing: add event trace infrastructure
In-Reply-To: <49A50A36.8000305@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0902250821190.12697@gandalf.stny.rr.com>
References: <20090225025608.956691460@goodmis.org> <20090225025753.798204550@goodmis.org> <49A50A36.8000305@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 25 Feb 2009, Lai Jiangshan wrote:

> a very nice infrastructure!
> 
> Two comments about format:
> 
> Steven Rostedt ??:
> > From: Steven Rostedt <srostedt@redhat.com>
> > +#undef TPFMT
> > +#define TPFMT(fmt, args...)	fmt "\n", ##args
> 
> Where is other TPFMT's definition?
> I think TPFMT should be defined in tracepoint.h, because trace/<type>.h
> uses it.

I was thinking that. But in may just end up being a nop.

#define TPFMT(fmt, args)	/* define me */


> 
> > +#define DEFINE_TRACE_FMT(call, proto, args, fmt)			\
> > +static void ftrace_event_##call(proto)					\
> > +{									\
> > +	event_trace_printk(_RET_IP_, "(" #call ") " fmt);		\
> > +}									\
> > +									\
> > +static int ftrace_reg_event_##call(void)				\
> > +{									\
> > +	int ret;							\
> > +									\
> > +	ret = register_trace_##call(ftrace_event_##call);		\
> > +	if (!ret)							\
> > +		pr_info("event trace: Could not activate trace point "	\
> > +			"probe to " #call);				\
> > +	return ret;							\
> > +}									\
> > +									\
> > +static void ftrace_unreg_event_##call(void)				\
> > +{									\
> > +	unregister_trace_##call(ftrace_event_##call);			\
> > +}									\
> > +									\
> > +static struct ftrace_event_call __used					\
> > +__attribute__((section("_ftrace_events"))) event_##call = {		\
> > +	.name 			= #call,				\
> > +	.regfunc		= ftrace_reg_event_##call,		\
> > +	.unregfunc		= ftrace_unreg_event_##call,		\
> > +}
> > +
> > +void event_trace_printk(unsigned long ip, const char *fmt, ...);
> 
> add format checking here:
> __attribute__ ((format (printf, 2, 3)))
> 
> If user does not use this infrastructure(he uses trace/<type>.h only),
> this checking is not work, so I think we can add format checking
> in DEFINE_TRACE_FMT in tracepoint.h

Darn! You are correct. That was what I forgot to fix since the RFC
announcement. I had that on my TODO list and simply forgot.

Thanks!

> 
> --------example:
> 
> static inline void  __tp_check_format(const char *fmt, ...)
> 		__attribute__ ((format (printf, 1, 2)));
> static inline void __tp_check_format(const char *fmt, ...) {}
> 
> #define DECLARE_TRACE_FORMAT_CHECK(name, proto, fmt, fmt_args...)	\
> static inline void ftrace_event_check_format_##name(proto)		\
> {									\
> 	__tp_check_format(fmt, ##fmt_args);				\

Cool, thanks, I'll add that.

-- Steve

> }
> 
> #define DEFINE_TRACE_FMT(name, proto, args, fmt)			\
> 	DECLARE_TRACE_FORMAT_CHECK(name, TPPROTO(proto), fmt)		\
> 	DECLARE_TRACE(name, TPPROTO(proto), TPARGS(args))
> 
> ---------
> 
> Thanks, Lai
> 
> 
> 
