Return-Path: <linux-kernel-owner+w=401wt.eu-S1753647AbYI3ReD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647AbYI3ReD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 13:34:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752359AbYI3Rdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 13:33:53 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:8135 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbYI3Rdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 13:33:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding:sender;
        b=PCkIzTUgg2dAJlW1XdBosrHtqpus8ifzlwiWIFizHVMABYm+Ofq390rop5kavsrf8f
         O7Cre1lOq7XI4A7CS5DzepSIlYK0TpOls9wC3STWeSxPejnc2WMZjfKKiT8eBB5W2K7E
         n4HxWBALBprsWiBvz2R/JhDOQVngiVG/4Kd94=
Date: Tue, 30 Sep 2008 20:33:42 +0300
From: Pekka Paalanen <pq@iki.fi>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 6/6] ftrace: take advantage of variable length entries
Message-ID: <20080930203342.5b5ca814@daedalus.pq.iki.fi>
In-Reply-To: <20080930030652.883661046@goodmis.org>
References: <20080930030236.230994826@goodmis.org>
	<20080930030652.883661046@goodmis.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

This is great news. I have some questions below.


On Mon, 29 Sep 2008 23:02:42 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> Now that the underlining ring buffer for ftrace now hold variable length
> entries, we can take advantage of this by only storing the size of the
> actual event into the buffer. This happens to increase the number of
> entries in the buffer dramatically.

I've read this paragraph over and over, and I can't really understand
"only storing the size of the ... event". Maybe you are trying to say
that now we are not consuming more ring space than the actual size of
the event?

Oh! I misunderstood also the last sentence, it's not generating extra
entries but there is room for more entries than before.


> We can also get rid of the "trace_cont" operation, but I'm keeping that
> until we have no more users. Some of the ftrace tracers can now change
> their code to adapt to this new feature.
> 
> CC: Pekka Paalanen <pq@iki.fi>
> CC: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  kernel/trace/trace.c           |  441 +++++++++++++++++++++--------------------
>  kernel/trace/trace.h           |   81 +++----
>  kernel/trace/trace_boot.c      |   13 -
>  kernel/trace/trace_mmiotrace.c |   31 +-
>  4 files changed, 302 insertions(+), 264 deletions(-)
> 
...
> Index: linux-tip.git/kernel/trace/trace.h
> ===================================================================
> --- linux-tip.git.orig/kernel/trace/trace.h	2008-09-29 22:27:59.000000000 -0400
> +++ linux-tip.git/kernel/trace/trace.h	2008-09-29 22:32:54.000000000 -0400
> @@ -27,9 +27,24 @@ enum trace_type {
>  };
>  
>  /*
> + * The trace entry - the most basic unit of tracing. This is what
> + * is printed in the end as a single line in the trace output, such as:
> + *
> + *     bash-15816 [01]   235.197585: idle_cpu <- irq_enter
> + */
> +struct trace_entry {
> +	unsigned char		type;
> +	unsigned char		cpu;
> +	unsigned char		flags;
> +	unsigned char		preempt_count;
> +	int			pid;
> +};
> +
> +/*
>   * Function trace entry - function address and parent function addres:
>   */
>  struct ftrace_entry {
> +	struct trace_entry	ent;
>  	unsigned long		ip;
>  	unsigned long		parent_ip;
>  };
> @@ -39,6 +54,7 @@ extern struct tracer boot_tracer;
>   * Context switch trace entry - which task (and prio) we switched from/to:
>   */
>  struct ctx_switch_entry {
> +	struct trace_entry	ent;
>  	unsigned int		prev_pid;
>  	unsigned char		prev_prio;
>  	unsigned char		prev_state;
> @@ -52,6 +68,7 @@ struct ctx_switch_entry {
>   * Special (free-form) trace entry:
>   */
>  struct special_entry {
> +	struct trace_entry	ent;
>  	unsigned long		arg1;
>  	unsigned long		arg2;
>  	unsigned long		arg3;
> @@ -64,6 +81,7 @@ struct special_entry {
>  #define FTRACE_STACK_ENTRIES	8
>  
>  struct stack_entry {
> +	struct trace_entry	ent;
>  	unsigned long		caller[FTRACE_STACK_ENTRIES];
>  };
>  
> @@ -71,10 +89,34 @@ struct stack_entry {
>   * ftrace_printk entry:
>   */
>  struct print_entry {
> +	struct trace_entry	ent;
>  	unsigned long		ip;
>  	char			buf[];
>  };
>  
> +#define TRACE_OLD_SIZE		88

I'm just wondering, does this hold for both 32- and 64-bit kernels?
Long type is quite common in the structs. I realize this is going
away, so maybe it doesn't even matter.


> +
> +struct trace_field_cont {
> +	unsigned char		type;
> +	/* Temporary till we get rid of this completely */
> +	char			buf[TRACE_OLD_SIZE - 1];
> +};
> +
> +struct trace_mmiotrace_rw {
> +	struct trace_entry	ent;
> +	struct mmiotrace_rw	rw;
> +};
> +
> +struct trace_mmiotrace_map {
> +	struct trace_entry	ent;
> +	struct mmiotrace_map	map;
> +};
> +
> +struct trace_boot {
> +	struct trace_entry	ent;
> +	struct boot_trace	initcall;
> +};
> +
>  /*
>   * trace_flag_type is an enumeration that holds different
>   * states when a trace occurs. These are:
> @@ -92,46 +134,7 @@ enum trace_flag_type {
>  	TRACE_FLAG_CONT			= 0x10,
>  };
>  
> -/*
> - * The trace field - the most basic unit of tracing. This is what
> - * is printed in the end as a single line in the trace output, such as:
> - *
> - *     bash-15816 [01]   235.197585: idle_cpu <- irq_enter
> - */
> -struct trace_field {
> -	char			cpu;
> -	char			flags;
> -	char			preempt_count;
> -	int			pid;
> -	union {
> -		struct ftrace_entry		fn;
> -		struct ctx_switch_entry		ctx;
> -		struct special_entry		special;
> -		struct stack_entry		stack;
> -		struct print_entry		print;
> -		struct mmiotrace_rw		mmiorw;
> -		struct mmiotrace_map		mmiomap;
> -		struct boot_trace		initcall;
> -	};
> -};

Finally we get rid of the union :-)


> -
> -struct trace_field_cont {
> -	char				buf[sizeof(struct trace_field)];
> -};
> -
> -struct trace_entry {
> -	char 				type;
> -	union {
> -		struct trace_field	field;
> -		struct trace_field_cont	cont;
> -	};
> -};
> -
> -#define TRACE_ENTRY_SIZE	sizeof(struct trace_entry)
>  #define TRACE_BUF_SIZE		1024
> -#define TRACE_PRINT_BUF_SIZE \
> -	(sizeof(struct trace_field) - offsetof(struct trace_field, print.buf))
> -#define TRACE_CONT_BUF_SIZE	sizeof(struct trace_field)
>  
>  /*
>   * The CPU trace array - it consists of thousands of trace entries
> Index: linux-tip.git/kernel/trace/trace_mmiotrace.c
> ===================================================================
> --- linux-tip.git.orig/kernel/trace/trace_mmiotrace.c	2008-09-29 22:27:59.000000000 -0400
> +++ linux-tip.git/kernel/trace/trace_mmiotrace.c	2008-09-29 22:32:54.000000000 -0400
> @@ -178,14 +178,16 @@ print_out:
>  static int mmio_print_rw(struct trace_iterator *iter)
>  {
>  	struct trace_entry *entry = iter->ent;
> -	struct mmiotrace_rw *rw	= &entry->field.mmiorw;
> +	struct trace_mmiotrace_rw *field =
> +		(struct trace_mmiotrace_rw *)entry;
> +	struct mmiotrace_rw *rw	= &field->rw;
>  	struct trace_seq *s	= &iter->seq;
>  	unsigned long long t	= ns2usecs(iter->ts);
>  	unsigned long usec_rem	= do_div(t, 1000000ULL);
>  	unsigned secs		= (unsigned long)t;
>  	int ret = 1;
>  
> -	switch (entry->field.mmiorw.opcode) {
> +	switch (rw->opcode) {
>  	case MMIO_READ:
>  		ret = trace_seq_printf(s,
>  			"R %d %lu.%06lu %d 0x%llx 0x%lx 0x%lx %d\n",
> @@ -220,14 +222,14 @@ static int mmio_print_rw(struct trace_it
>  static int mmio_print_map(struct trace_iterator *iter)
>  {
>  	struct trace_entry *entry = iter->ent;
> -	struct mmiotrace_map *m	= &entry->field.mmiomap;
> +	struct mmiotrace_map *m	= (struct mmiotrace_map *)entry;

This is different style than above, missing the struct
trace_mmiotrace_map intermediate step. Looks like a bug,
since struct mmiotrace_map is not the first field in
struct trace_mmiotrace_map.


>  	struct trace_seq *s	= &iter->seq;
>  	unsigned long long t	= ns2usecs(iter->ts);
>  	unsigned long usec_rem	= do_div(t, 1000000ULL);
>  	unsigned secs		= (unsigned long)t;
>  	int ret = 1;
>  
> -	switch (entry->field.mmiorw.opcode) {
> +	switch (m->opcode) {
>  	case MMIO_PROBE:
>  		ret = trace_seq_printf(s,
>  			"MAP %lu.%06lu %d 0x%llx 0x%lx 0x%lx 0x%lx %d\n",
> @@ -252,7 +254,8 @@ static int mmio_print_map(struct trace_i
>  static int mmio_print_mark(struct trace_iterator *iter)
>  {
>  	struct trace_entry *entry = iter->ent;
> -	const char *msg		= entry->field.print.buf;
> +	struct print_entry *print = (struct print_entry *)entry;
> +	const char *msg		= print->buf;
>  	struct trace_seq *s	= &iter->seq;
>  	unsigned long long t	= ns2usecs(iter->ts);
>  	unsigned long usec_rem	= do_div(t, 1000000ULL);
> @@ -264,7 +267,7 @@ static int mmio_print_mark(struct trace_
>  	if (!ret)
>  		return 0;
>  
> -	if (entry->field.flags & TRACE_FLAG_CONT)
> +	if (entry->flags & TRACE_FLAG_CONT)
>  		trace_seq_print_cont(s, iter);

If we have variable length entries, doesn't that mean that
print_entry::buf will always hold the full nil-terminated message,
and that we could simply remove all the trace_seq_print_cont()
calls?

In fact, TRACE_FLAG_CONT will never be set. I didn't dig up the
other patches to verify, but trace_vprintk() isn't setting it
anymore.


>  
>  	return 1;
> @@ -308,7 +311,7 @@ static void __trace_mmiotrace_rw(struct 
>  				struct mmiotrace_rw *rw)
>  {
>  	struct ring_buffer_event *event;
> -	struct trace_entry *entry;
> +	struct trace_mmiotrace_rw *entry;
>  	unsigned long irq_flags;
>  
>  	event	= ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
> @@ -316,9 +319,9 @@ static void __trace_mmiotrace_rw(struct 
>  	if (!event)
>  		return;
>  	entry	= ring_buffer_event_data(event);
> -	tracing_generic_entry_update(entry, 0);
> -	entry->type			= TRACE_MMIO_RW;
> -	entry->field.mmiorw		= *rw;
> +	tracing_generic_entry_update(&entry->ent, 0);
> +	entry->ent.type			= TRACE_MMIO_RW;
> +	entry->rw			= *rw;
>  	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
>  
>  	trace_wake_up();
> @@ -336,7 +339,7 @@ static void __trace_mmiotrace_map(struct
>  				struct mmiotrace_map *map)
>  {
>  	struct ring_buffer_event *event;
> -	struct trace_entry *entry;
> +	struct trace_mmiotrace_map *entry;
>  	unsigned long irq_flags;
>  
>  	event	= ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
> @@ -344,9 +347,9 @@ static void __trace_mmiotrace_map(struct
>  	if (!event)
>  		return;
>  	entry	= ring_buffer_event_data(event);
> -	tracing_generic_entry_update(entry, 0);
> -	entry->type			= TRACE_MMIO_MAP;
> -	entry->field.mmiomap		= *map;
> +	tracing_generic_entry_update(&entry->ent, 0);
> +	entry->ent.type			= TRACE_MMIO_MAP;
> +	entry->map			= *map;
>  	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
>  
>  	trace_wake_up();

On the mmiotrace part, I don't see anything wrong here apart
from that one bug.


Thanks.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
