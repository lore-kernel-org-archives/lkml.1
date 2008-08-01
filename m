Return-Path: <linux-kernel-owner+w=401wt.eu-S1759204AbYHAMMF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759204AbYHAMMF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 08:12:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758774AbYHAMLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 08:11:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:34391 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758737AbYHAMLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 08:11:47 -0400
Date: Fri, 1 Aug 2008 08:11:44 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] ftrace: printk formatting infrastructure
In-Reply-To: <20080731221145.57c8d016.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0808010807260.27680@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0808010021110.20407@gandalf.stny.rr.com> <20080731221145.57c8d016.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 31 Jul 2008, Andrew Morton wrote:

> 
> Seems like it would be useful.
> 
> Do we have any evidence that reandom developers are using ftrace yet? 
> And any feedback from them?

It's still new. I've had a lot of interest in this at OLS from various 
developers. One person asked me about this feature during my tutorial.

One thing on my todo list is to back port ftrace to previous kernels. I 
had a few requests to do just that, since a lot of driver developers and 
embedded programmers are using older kernels.

> 
> >
> > ...
> >
> > +static void
> > +trace_seq_print_cont(struct trace_seq *s, struct trace_iterator *iter)
> > +{
> > +	struct trace_array *tr = iter->tr;
> > +	struct trace_array_cpu *data = tr->data[iter->cpu];
> > +	struct trace_entry *ent;
> > +	struct trace_cont *cont;
> > +
> > +	ent = trace_entry_idx(tr, data, iter, iter->cpu);
> > +	if (!ent || ent->type != TRACE_CONT) {
> > +		trace_seq_putc(s, '\n');
> > +		return;
> > +	}
> > +
> > +	do {
> > +		cont = (struct trace_cont *)ent;
> 
> What you have here is umm, a variant record, or its in-memory equiv
> which probably has a name.

Yeah I know, I didn't like that.

> 
> > ...
> >
> > +/*
> > + * When an item needs more than one entry to fill a buffer
> > + * it can use this structure.
> > + */
> > +struct trace_cont {
> > +	char type;
> > +	char buf[];
> > +};
> 
> Would it not be cleaner and clearer to do this:
> 
> struct trace_entry {
> 	char			type;
> 	union {
> 		struct {
> 			char			cpu;
> 			char			flags;
> 			char			preempt_count;
> 			int			pid;
> 			cycle_t			t;
> 			union {
> 				struct ftrace_entry		fn;
> 				struct ctx_switch_entry		ctx;
> 				struct special_entry		special;
> 				struct stack_entry		stack;
> 				struct mmiotrace_rw		mmiorw;
> 				struct mmiotrace_map		mmiomap;
> 			};
> 		};
> 		char buf[0];
> 		<other things here>
> 	}
> };
> 
> So the first byte (`type') indicates which of the members of that union
> are actually contained in the payload.
> 
> That way it's all typesafe and avoids casting.
> 
> 
> Of course, rather than using the anonymous union/struct trickery it
> would be much nicer and clearer to do it this way:
> 
> struct trace_field {
> 	char			cpu;
> 	char			flags;
> 	char			preempt_count;
> 	int			pid;
> 	cycle_t			t;
> 	union {
> 		struct ftrace_entry		fn;
> 		struct ctx_switch_entry		ctx;
> 		struct special_entry		special;
> 		struct stack_entry		stack;
> 		struct mmiotrace_rw		mmiorw;
> 		struct mmiotrace_map		mmiomap;
> 	};
> };
> 
> struct trace_cont_field {
> 	char buf[];
> };
> 
> ...
> 
> struct trace_entry {
> 	char type;
> 	union {
> 		struct trace_field trace_field;
> 		struct trace_cont_field trace_cont_field;
> 		...
> 	};
> };
> 
> however that would require a large (but very simple) edit to the
> existing code.

Hehe, that was actually the reason I didn't do it this way.  I didn't want 
this patch to "blow up" in size.

> 
> In the long run, the larger patch would be better though.
> 

I agree. I'll rewrite the patch and to hell with the diff size ;-)

Hmm, Perhaps I'll rewrite this in two patches. One with the struct change, 
and the other with the meat of the change.

-- Steve

