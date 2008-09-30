Return-Path: <linux-kernel-owner+w=401wt.eu-S1754186AbYI3Rpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186AbYI3Rpj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 13:45:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753254AbYI3RpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 13:45:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:63004 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179AbYI3RpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 13:45:09 -0400
Date: Tue, 30 Sep 2008 13:45:07 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Pekka Paalanen <pq@iki.fi>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 6/6] ftrace: take advantage of variable length entries
In-Reply-To: <20080930203342.5b5ca814@daedalus.pq.iki.fi>
Message-ID: <alpine.DEB.1.10.0809301341300.6224@gandalf.stny.rr.com>
References: <20080930030236.230994826@goodmis.org> <20080930030652.883661046@goodmis.org> <20080930203342.5b5ca814@daedalus.pq.iki.fi>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 30 Sep 2008, Pekka Paalanen wrote:

> Hi Steven,
> 
> This is great news. I have some questions below.

Thanks!

> On Mon, 29 Sep 2008 23:02:42 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > Now that the underlining ring buffer for ftrace now hold variable length
> > entries, we can take advantage of this by only storing the size of the
> > actual event into the buffer. This happens to increase the number of
> > entries in the buffer dramatically.
> 
> I've read this paragraph over and over, and I can't really understand
> "only storing the size of the ... event". Maybe you are trying to say
> that now we are not consuming more ring space than the actual size of
> the event?
> 
> Oh! I misunderstood also the last sentence, it's not generating extra
> entries but there is room for more entries than before.

Yeah, it means that we can now store more entries with the same space.

> >  
> > @@ -71,10 +89,34 @@ struct stack_entry {
> >   * ftrace_printk entry:
> >   */
> >  struct print_entry {
> > +	struct trace_entry	ent;
> >  	unsigned long		ip;
> >  	char			buf[];
> >  };
> >  
> > +#define TRACE_OLD_SIZE		88
> 
> I'm just wondering, does this hold for both 32- and 64-bit kernels?
> Long type is quite common in the structs. I realize this is going
> away, so maybe it doesn't even matter.

I believe 88 was what I came up with on x86_64. It was just a size to
pick out of the blue and has no real meaning. I'm not sure anyone uses it
but before I hacked it away, I wanted to make sure.

> > -/*
> > - * The trace field - the most basic unit of tracing. This is what
> > - * is printed in the end as a single line in the trace output, such as:
> > - *
> > - *     bash-15816 [01]   235.197585: idle_cpu <- irq_enter
> > - */
> > -struct trace_field {
> > -	char			cpu;
> > -	char			flags;
> > -	char			preempt_count;
> > -	int			pid;
> > -	union {
> > -		struct ftrace_entry		fn;
> > -		struct ctx_switch_entry		ctx;
> > -		struct special_entry		special;
> > -		struct stack_entry		stack;
> > -		struct print_entry		print;
> > -		struct mmiotrace_rw		mmiorw;
> > -		struct mmiotrace_map		mmiomap;
> > -		struct boot_trace		initcall;
> > -	};
> > -};
> 
> Finally we get rid of the union :-)

Yeah, this is my favorite part of the patch.

> >  		ret = trace_seq_printf(s,
> >  			"R %d %lu.%06lu %d 0x%llx 0x%lx 0x%lx %d\n",
> > @@ -220,14 +222,14 @@ static int mmio_print_rw(struct trace_it
> >  static int mmio_print_map(struct trace_iterator *iter)
> >  {
> >  	struct trace_entry *entry = iter->ent;
> > -	struct mmiotrace_map *m	= &entry->field.mmiomap;
> > +	struct mmiotrace_map *m	= (struct mmiotrace_map *)entry;
> 
> This is different style than above, missing the struct
> trace_mmiotrace_map intermediate step. Looks like a bug,
> since struct mmiotrace_map is not the first field in
> struct trace_mmiotrace_map.

Crap! yes this is a bug. Thanks for pointing this out.

> > @@ -252,7 +254,8 @@ static int mmio_print_map(struct trace_i
> >  static int mmio_print_mark(struct trace_iterator *iter)
> >  {
> >  	struct trace_entry *entry = iter->ent;
> > -	const char *msg		= entry->field.print.buf;
> > +	struct print_entry *print = (struct print_entry *)entry;
> > +	const char *msg		= print->buf;
> >  	struct trace_seq *s	= &iter->seq;
> >  	unsigned long long t	= ns2usecs(iter->ts);
> >  	unsigned long usec_rem	= do_div(t, 1000000ULL);
> > @@ -264,7 +267,7 @@ static int mmio_print_mark(struct trace_
> >  	if (!ret)
> >  		return 0;
> >  
> > -	if (entry->field.flags & TRACE_FLAG_CONT)
> > +	if (entry->flags & TRACE_FLAG_CONT)
> >  		trace_seq_print_cont(s, iter);
> 
> If we have variable length entries, doesn't that mean that
> print_entry::buf will always hold the full nil-terminated message,
> and that we could simply remove all the trace_seq_print_cont()
> calls?
> 
> In fact, TRACE_FLAG_CONT will never be set. I didn't dig up the
> other patches to verify, but trace_vprintk() isn't setting it
> anymore.

This patch is bringing us to the stage to get rid of the CONT flag.
I kept this in just to not break more than I need to ;-)

> > @@ -336,7 +339,7 @@ static void __trace_mmiotrace_map(struct
> >  				struct mmiotrace_map *map)
> >  {
> >  	struct ring_buffer_event *event;
> > -	struct trace_entry *entry;
> > +	struct trace_mmiotrace_map *entry;
> >  	unsigned long irq_flags;
> >  
> >  	event	= ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
> > @@ -344,9 +347,9 @@ static void __trace_mmiotrace_map(struct
> >  	if (!event)
> >  		return;
> >  	entry	= ring_buffer_event_data(event);
> > -	tracing_generic_entry_update(entry, 0);
> > -	entry->type			= TRACE_MMIO_MAP;
> > -	entry->field.mmiomap		= *map;
> > +	tracing_generic_entry_update(&entry->ent, 0);
> > +	entry->ent.type			= TRACE_MMIO_MAP;
> > +	entry->map			= *map;
> >  	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
> >  
> >  	trace_wake_up();
> 
> On the mmiotrace part, I don't see anything wrong here apart
> from that one bug.

Thanks, I'll add a patch to my coming queue to handle this.

-- Steve

