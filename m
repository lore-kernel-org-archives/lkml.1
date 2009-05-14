Return-Path: <linux-kernel-owner+w=401wt.eu-S1758950AbZENXSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758950AbZENXSg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 19:18:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755313AbZENXSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 19:18:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:35046 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601AbZENXSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 19:18:24 -0400
Date: Thu, 14 May 2009 19:18:23 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>,
       Ingo Molnar <mingo@elte.hu>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] tracing: adding flags to events
In-Reply-To: <20090514203351.GA5969@nowhere>
Message-ID: <alpine.DEB.2.00.0905141916000.30591@gandalf.stny.rr.com>
References: <alpine.DEB.2.00.0905141535360.30591@gandalf.stny.rr.com> <20090514203351.GA5969@nowhere>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 14 May 2009, Frederic Weisbecker wrote:

> On Thu, May 14, 2009 at 03:45:48PM -0400, Steven Rostedt wrote:
> > 
> > Christoph has been asking about processing flags in the output. He rather 
> > not see c2, and rather see what those three bits are. This patch is 
> > an RFC to do just that. To test it out, I added the previous task state to 
> > sched switch and used the flag processing to the printk of the 
> > sched_switch event.
> > 
> > 
> > To add a flag, just add __print_flags to the TP_printk arguments.
> > 
> > 	TP_STRUCT__entry(
> > 		__field(	unsigned int,	flags		)
> > 	),
> > 
> > 	TP_printk("flags are %s", __print_flags(__entry->flags,
> > 			0, "BIT0", 1, "BIT1", 2, "BIT2", -1))
> > 
> 
> 
> Nice idea!
> 
> Also, I wonder if that would be possible to get compounded
> bits such as GFP_KERNEL instead of __GFP_WAIT | __GFP_IO | __GFP_FS.
> 
> To perform that, we could just add two fields:
> 
> //__b for byte, __m for mask
> 
> #define __b(b)	(1 << b)
> #define __m(m)  m
> 
> And then you can compare using a mask.
> It also requires to clear the mask from the flags to avoid
> duplicate matches such as GFP_KERNEL | __GFP_WAIT | __GFP_IO | __GFP_FS
> and only have GFP_KERNEL, eg:
> 
> const char *
> ftrace_print_flags_seq(struct trace_seq *p, unsigned long flags, ...)
> {
> 	const char *str;
> 	va_list args;
> 	long mask;
> 
> 	trace_seq_init(p);
> 	va_start(args, flags);
> 	for (mask = va_arg(args, long) ; mask >= 0; mask = va_arg(args, long)) {
> 		str = va_arg(args, const char *);
> 
> 		if (flags & mask != mask)
> 			continue;
> 
> 		flags &= ~mask;
> 		if (p->len)
> 			trace_seq_putc(p, '|');
> 		trace_seq_puts(p, str);
> 	}
> 	va_end(args);
> 	trace_seq_putc(p, 0);
> 
> 	return p->buffer;
> }

Nice, I'll try that. I thought about doing something similar, but I 
figured to post the simplest algorithm first.


> > +#define __print_flags(flag, x...) ftrace_print_flags_seq(p, flag, x)


> > +
> >  #undef TRACE_EVENT
> >  #define TRACE_EVENT(call, proto, args, tstruct, assign, print)		\
> >  enum print_line_t							\
> > @@ -127,6 +132,7 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
> >  	struct trace_seq *s = &iter->seq;				\
> >  	struct ftrace_raw_##call *field;				\
> >  	struct trace_entry *entry;					\
> > +	struct trace_seq *p;						\
> >  	int ret;							\
> >  									\
> >  	entry = iter->ent;						\
> > @@ -138,7 +144,9 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
> >  									\
> >  	field = (typeof(field))entry;					\
> >  									\
> > +	p = &get_cpu_var(ftrace_event_seq);				\
> >  	ret = trace_seq_printf(s, #call ": " print);			\
> > +	put_cpu();							\
> 
> 
> 
> I don't understand the role of this per-cpu trace_seq variable.
> It doesn't seem to be used.

See it now? ;-)

-- Steve
