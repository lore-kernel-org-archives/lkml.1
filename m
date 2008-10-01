Return-Path: <linux-kernel-owner+w=401wt.eu-S1754178AbYJAHyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178AbYJAHyq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 03:54:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752395AbYJAHyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 03:54:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44034 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752132AbYJAHyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 03:54:36 -0400
Date: Wed, 1 Oct 2008 09:54:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Pekka Paalanen <pq@iki.fi>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 6/6] ftrace: take advantage of variable length entries
Message-ID: <20081001075419.GA24509@elte.hu>
References: <20080930030236.230994826@goodmis.org> <20080930030652.883661046@goodmis.org> <20080930203342.5b5ca814@daedalus.pq.iki.fi> <alpine.DEB.1.10.0809301341300.6224@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0809301341300.6224@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> > >  	struct trace_entry *entry = iter->ent;
> > > -	struct mmiotrace_map *m	= &entry->field.mmiomap;
> > > +	struct mmiotrace_map *m	= (struct mmiotrace_map *)entry;
> > 
> > This is different style than above, missing the struct
> > trace_mmiotrace_map intermediate step. Looks like a bug,
> > since struct mmiotrace_map is not the first field in
> > struct trace_mmiotrace_map.
> 
> Crap! yes this is a bug. Thanks for pointing this out.

hm, there's a significant amount of type casts, see the grep below.

The ringbuffer becoming type-opaque has exactly these kinds of dangers, 
and as i suggested a few days ago, please think about a debug mode that 
stores the record type in the trace entry and validates it on extraction 
or something like that.

That might even be a robustness feature: the tracer should not crash if 
the trace buffer gets corrupted. ftrace had that invariant before, i 
think we should try to keep as many aspects of it as possible.

	Ingo

------------->
ring_buffer.c:		page = (struct buffer_page *)virt_to_page(addr);
ring_buffer.c:	cpu_buffer->reader_page = (struct buffer_page *)virt_to_page(addr);
ring_buffer.c:static void rb_reset_cpu(struct ring_buffer_per_cpu *cpu_buffer);
ring_buffer.c:			page = (struct buffer_page *)virt_to_page(addr);
trace_boot.c:	struct trace_boot *field = (struct trace_boot *)entry;
trace.c:static DEFINE_PER_CPU(struct trace_array_cpu, global_trace_cpu);
trace.c:static DEFINE_PER_CPU(struct trace_array_cpu, max_data);
trace.c:		cont = (struct trace_field_cont *)ent;
trace.c:		struct ftrace_entry *field = (struct ftrace_entry *)entry;
trace.c:			(struct ctx_switch_entry *)entry;
trace.c:		struct special_entry *field = (struct special_entry *)entry;
trace.c:		struct stack_entry *field = (struct stack_entry *)entry;
trace.c:		struct print_entry *field = (struct print_entry *)entry;
trace.c:		struct ftrace_entry *field = (struct ftrace_entry *)entry;
trace.c:			(struct ctx_switch_entry *)entry;
trace.c:		struct special_entry *field = (struct special_entry *)entry;
trace.c:		struct stack_entry *field = (struct stack_entry *)entry;
trace.c:		struct print_entry *field = (struct print_entry *)entry;
trace.c:		struct ftrace_entry *field = (struct ftrace_entry *)entry;
trace.c:			(struct ctx_switch_entry *)entry;
trace.c:		struct special_entry *field = (struct special_entry *)entry;
trace.c:		struct print_entry *field = (struct print_entry *)entry;
trace.c:		struct ftrace_entry *field = (struct ftrace_entry *)entry;
trace.c:			(struct ctx_switch_entry *)entry;
trace.c:		struct special_entry *field = (struct special_entry *)entry;
trace.c:		struct ftrace_entry *field = (struct ftrace_entry *)entry;
trace.c:			(struct ctx_switch_entry *)entry;
trace.c:		struct special_entry *field = (struct special_entry *)entry;
trace.c:	struct seq_file *m = (struct seq_file *)file->private_data;
trace.c:	       offsetof(struct trace_iterator, seq));
trace.c:		       offsetof(struct trace_iterator, seq));
trace_mmiotrace.c:		(struct trace_mmiotrace_rw *)entry;
trace_mmiotrace.c:	struct mmiotrace_map *m	= (struct mmiotrace_map *)entry;
trace_mmiotrace.c:	struct print_entry *print = (struct print_entry *)entry;
trace_sched_wakeup.c:static void __wakeup_reset(struct trace_array *tr);
trace_sysprof.c:static DEFINE_PER_CPU(struct hrtimer, stack_trace_hrtimer);
trace_sysprof.c:	stack = ((char *)regs + sizeof(struct pt_regs));
trace_sysprof.c:		regs = (struct pt_regs *)current->thread.sp0 - 1;
