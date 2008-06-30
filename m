Return-Path: <linux-kernel-owner+w=401wt.eu-S1762061AbYF3PkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762061AbYF3PkW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 11:40:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbYF3PkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 11:40:08 -0400
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:50780 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbYF3PkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 11:40:06 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsYFAK2XaEhMQWVt/2dsb2JhbACBWq8C
Date: Mon, 30 Jun 2008 11:40:02 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       "'Alexey Dobriyan'" <adobriyan@gmail.com>,
       "'Peter Zijlstra'" <peterz@infradead.org>,
       "'Steven Rostedt'" <rostedt@goodmis.org>,
       "'Frank Ch. Eigler'" <fche@redhat.com>, "'Ingo Molnar'" <mingo@elte.hu>,
       "'LKML'" <linux-kernel@vger.kernel.org>,
       "'systemtap-ml'" <systemtap@sources.redhat.com>,
       "'Hideo AOKI'" <haoki@redhat.com>
Subject: Re: [RFC PATCH] Kernel Tracepoints
Message-ID: <20080630154002.GE17388@Krystal>
References: <007601c8d5ca$18fa0e10$4aee2a30$@css.fujitsu.com> <48611B03.1000003@redhat.com> <20080625011951.D83E.KOSAKI.MOTOHIRO@jp.fujitsu.com> <48612879.5090809@redhat.com> <20080625235214.GA14249@Krystal> <486403F0.4020801@redhat.com> <20080627133009.GC13751@Krystal> <48655464.5040000@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <48655464.5040000@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:30:36 up 25 days, 20:11,  5 users,  load average: 0.57, 1.41,
	1.34
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Masami Hiramatsu (mhiramat@redhat.com) wrote:
> Mathieu Desnoyers wrote:
> > * Masami Hiramatsu (mhiramat@redhat.com) wrote:
> >  >
> >>> Implementation of kernel tracepoints. Inspired from the Linux Kernel Markers.
> >> What would you think redesigning markers on tracepoints? because most of the
> >> logic (scaning sections, multiple probe and activation) seems very similar
> >> to markers.
> >>
> > 
> > We could, although markers, because they use var args, allow to put the
> > iteration on the multi probe array out-of-line. Tracepoints cannot
> > afford this and the iteration must be done at the initial call-site.
> > 
> > From what I see in your proposal, it's mostly to extract the if() call()
> > code from the inner __trace_mark() macro and to put it in a separate
> > macro, am I correct ? This would make the macro more readable.
> 
> Sure, I think marker and tracepoint can share below functions;
> - definition of static local variables in specific sections

Given that we could want to keep activation of tracepoints and markers
separate (so they don't share the same namespace), declaring the static
variables in separated sections seems to make sense to me.

> - probe activation code (if() call())
> - multi probe handling

Hrm, the thing here is that because markers allow to do the iteration on
the multiple probe callbacks within an internal wrapper (instead of
doing it on-site as in the tracepoints), it allows to do some further
optimizations (less memory allocation and less pointer dereference in
the single probe case, not having to prepare the va_args in the
MARK_NOARGS case) which are only done because it does not have to add
code to the instrumentation site. However, tracepoints cannot have such
"generic" wrapper and we have to do the iteration on callbacks in the
code added to the instrumented object. Therefore, I keep it as small as
possible in terms of bytes of instructions.

> Then, marker just exports marker_strings sections.
> 
> >> For example, (not complete, I just thought :-))
> >>
> >>  struct tracepoint {
> >>  	const char *name;		/* Tracepoint name */
> >>  	DEFINE_IMV(char, state);	/* Immediate value state. */
> >>  	struct tracepoint_probe_closure *multi;	/* Closures */
> >> 	void * callsite_data;		/* private date from call site */
> >>  } __attribute__((aligned(8)));
> >>
> >>  #define __tracepoint_block(generic, name, data, func, args)
> >>  	static const char __tpstrtab_##name[]			\
> >>  	__attribute__((section("__tracepoints_strings")))	\
> >>  	= #name;						\
> >>  	static struct tracepoint __tracepoint_##name		\
> >>  	__attribute__((section("__tracepoints"), aligned(8))) =	\
> >>  	{ __tpstrtab_##name, 0, NULL, data};			\
> >>  	if (!generic) {						\
> >>  		if (unlikely(imv_cond(__tracepoint_##name.state))) { \
> >>  			imv_cond_end();				\
> >>  			func(&__tracepoint_##name, args); \
> >>  		} else						\
> >>  			imv_cond_end();				\
> >>  	} else {						\
> >>  		if (unlikely(_imv_read(__tracepoint_##name.state))) \
> >>  			func(&__tracepoint_##name, args); \
> >>  	}
> 
> 
> So, in my idea, __trace_##name() also uses __tracepoint_block() for
> avoiding code duplication.
> 
> 
> > [...]
> >>> +	static inline int register_trace_##name(			\
> >>> +		void (*probe)(void *private_data, proto),		\
> >>> +		void *private_data)					\
> >>> +	{								\
> >>> +		return tracepoint_probe_register(#name, (void *)probe,	\
> >>> +			private_data);					\
> >>> +	}								\
> >>> +	static inline void unregister_trace_##name(			\
> >>> +		void (*probe)(void *private_data, proto),		\
> >>> +		void *private_data)					\
> >>> +	{								\
> >>> +		tracepoint_probe_unregister(#name, (void *)probe,	\
> >>> +			private_data);					\
> >>> +	}
> >> Out of curiousity, what the private_data is for?
> >>
> > 
> > When a probe is registered, it gives more flexibility to be able to pass
> > a pointer to private data associated with that probe. For instance, if a
> > tracer needs to register the same probe to many different tracepoints,
> > but having a different context associated with each, it will pass the
> > same function pointer with different private_data to the registration
> > function.
> 
> Hmm, only for tracepoint, it might be not so useful, because
> most of tracepoint's prototypes are different and so we can't
> use same probe to those tracepoints.
> Anyway, it is useful for more general probe(ex. markers) if that
> is implemented on tracepoint ;-)
> 

The usefulness of private_data in the tracepoints is indeed
debatable, but given that we may have scenarios where code allocates its
own data structure and has to pass it efficiently to the tracepoint
callback, I think private_data can become quite useful at that point.
It's useful whenever you have a tracer which can generate more than one
trace, or collect more than one type of statistics depending on the
user's needs.

Mathieu

> 
> Thank you,
> 
> -- 
> Masami Hiramatsu
> 
> Software Engineer
> Hitachi Computer Products (America) Inc.
> Software Solutions Division
> 
> e-mail: mhiramat@redhat.com
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
