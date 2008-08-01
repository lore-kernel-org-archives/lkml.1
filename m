Return-Path: <linux-kernel-owner+w=401wt.eu-S1753360AbYHAFMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360AbYHAFMz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 01:12:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752443AbYHAFMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 01:12:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56624 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750967AbYHAFMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 01:12:46 -0400
Date: Thu, 31 Jul 2008 22:11:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] ftrace: printk formatting infrastructure
Message-Id: <20080731221145.57c8d016.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.1.10.0808010021110.20407@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0808010021110.20407@gandalf.stny.rr.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Aug 2008 00:54:39 -0400 (EDT) Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> This patch adds a feature that can help kernel developers debug their
> code using ftrace.
> 
>   int ftrace_printk(const char *fmt, ...);
> 
> This records into the ftrace buffer using printf formatting. The entry
> size in the buffers are still a fixed length. A new type has been added
> that allows for more entries to be used for a single recording.
> 
> The start of the print is still the same as the other entries.
> 
> It returns the number of characters written to the ftrace buffer.
> 
> 
> For example:
> 
> Having a module with the following code:
> 
> static int __init ftrace_print_test(void)
> {
>         ftrace_printk("jiffies are %ld\n", jiffies);
> 	return 0;
> }
> 
> Gives me:
> 
>   insmod-5441  3...1 7569us : ftrace_print_test: jiffies are 4296626666
> 
> for the latency_trace file and:
> 
>           insmod-5441  [03]  1959.370498: ftrace_print_test jiffies are 4296626666
> 
> for the trace file.
> 
> Note: Only the infrastructure should go into the kernel. It is to help 
> facilitate debugging for other kernel developers. Calls to ftrace_printk 
> is not intended to be left in the kernel, and should be frowned upon just 
> like scattering printks around in the code.
> 
> But having this easily at your fingertips helps the debugging go faster 
> and bugs be solved quicker.
> 
> Maybe later on, we can hook this with markers and have their printf format 
> be sucked into ftrace output.
> 

Seems like it would be useful.

Do we have any evidence that reandom developers are using ftrace yet? 
And any feedback from them?

>
> ...
>
> +static void
> +trace_seq_print_cont(struct trace_seq *s, struct trace_iterator *iter)
> +{
> +	struct trace_array *tr = iter->tr;
> +	struct trace_array_cpu *data = tr->data[iter->cpu];
> +	struct trace_entry *ent;
> +	struct trace_cont *cont;
> +
> +	ent = trace_entry_idx(tr, data, iter, iter->cpu);
> +	if (!ent || ent->type != TRACE_CONT) {
> +		trace_seq_putc(s, '\n');
> +		return;
> +	}
> +
> +	do {
> +		cont = (struct trace_cont *)ent;

What you have here is umm, a variant record, or its in-memory equiv
which probably has a name.

> ...
>
> +/*
> + * When an item needs more than one entry to fill a buffer
> + * it can use this structure.
> + */
> +struct trace_cont {
> +	char type;
> +	char buf[];
> +};

Would it not be cleaner and clearer to do this:

struct trace_entry {
	char			type;
	union {
		struct {
			char			cpu;
			char			flags;
			char			preempt_count;
			int			pid;
			cycle_t			t;
			union {
				struct ftrace_entry		fn;
				struct ctx_switch_entry		ctx;
				struct special_entry		special;
				struct stack_entry		stack;
				struct mmiotrace_rw		mmiorw;
				struct mmiotrace_map		mmiomap;
			};
		};
		char buf[0];
		<other things here>
	}
};

So the first byte (`type') indicates which of the members of that union
are actually contained in the payload.

That way it's all typesafe and avoids casting.


Of course, rather than using the anonymous union/struct trickery it
would be much nicer and clearer to do it this way:

struct trace_field {
	char			cpu;
	char			flags;
	char			preempt_count;
	int			pid;
	cycle_t			t;
	union {
		struct ftrace_entry		fn;
		struct ctx_switch_entry		ctx;
		struct special_entry		special;
		struct stack_entry		stack;
		struct mmiotrace_rw		mmiorw;
		struct mmiotrace_map		mmiomap;
	};
};

struct trace_cont_field {
	char buf[];
};

...

struct trace_entry {
	char type;
	union {
		struct trace_field trace_field;
		struct trace_cont_field trace_cont_field;
		...
	};
};

however that would require a large (but very simple) edit to the
existing code.

In the long run, the larger patch would be better though.
