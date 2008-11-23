Return-Path: <linux-kernel-owner+w=401wt.eu-S1757535AbYKWIiI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535AbYKWIiI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 03:38:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752651AbYKWIhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 03:37:54 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56908 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752411AbYKWIhy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 03:37:54 -0500
Date: Sun, 23 Nov 2008 09:37:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?B?VPZy9ms=?= Edwin <edwintorok@gmail.com>
Cc: srostedt@redhat.com, a.p.zijlstra@chello.nl, sandmann@daimi.au.dk,
       linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk
Subject: Re: [PATCH 1/2] tracing: add support for userspace stacktraces in
	tracing/iter_ctrl
Message-ID: <20081123083740.GD30453@elte.hu>
References: <1227353328-16104-1-git-send-email-edwintorok@gmail.com> <1227353328-16104-2-git-send-email-edwintorok@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1227353328-16104-2-git-send-email-edwintorok@gmail.com>
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


* Török Edwin <edwintorok@gmail.com> wrote:

> +struct stack_frame {
> +     const void __user	*next_fp;
> +     unsigned long           return_address;
> +};

Small detail: please s/return_address/ret_addr - its expressive power 
is the same but as a bonus it will cause less col-80 related 
linebreaks in usage sites.

> +void save_stack_trace_user(struct stack_trace *trace)
> +{
> +	/*
> +	 * Trace user stack if we are not a kernel thread
> +	 */
> +	if (current->mm) {
> +		const struct pt_regs *regs = task_pt_regs(current);
> +		const void __user *fp = (const void __user *)regs->bp;
> +
> +		if (trace->nr_entries < trace->max_entries)
> +			trace->entries[trace->nr_entries++] = regs->ip;
> +
> +		while (trace->nr_entries < trace->max_entries) {
> +			struct stack_frame frame;
> +			frame.next_fp = NULL;

Style: put a newline after variable definitions please.

> +			frame.return_address = 0;
> +			if (!copy_stack_frame(fp, &frame))
> +				break;
> +			if ((unsigned long)fp < regs->sp)
> +				break;
> +			if (frame.return_address)
> +				trace->entries[trace->nr_entries++] =
> +					frame.return_address;

Style: please use curly braces around multi-line conditional 
statements.

> +			if (fp == frame.next_fp)
> +				break;
> +			fp = frame.next_fp;
> +		}
> +	}

Detail: please move the whole "if (current->mm)" into a 
__save_stack_trace_user() helper function - that way it reads cleaner.

> +++ b/include/linux/stacktrace.h
> @@ -18,9 +18,17 @@ extern void save_stack_trace_tsk(struct task_struct *tsk,
>  				struct stack_trace *trace);
>  
>  extern void print_stack_trace(struct stack_trace *trace, int spaces);
> +
> +#ifdef CONFIG_X86
> +extern void save_stack_trace_user(struct stack_trace *trace);
> +#else
> +# define save_stack_trace_user(trace)              do { } while (0)
> +#endif

Bug: this should not be CONFIG_X86. Please introduce (in a separate 
patch from other cleanups) a CONFIG_USER_STACKTRACE_SUPPORT in 
arch/x86/Kconfig and use that instead.

> +
>  #else
>  # define save_stack_trace(trace)			do { } while (0)
>  # define save_stack_trace_tsk(tsk, trace)		do { } while (0)
> +# define save_stack_trace_user(trace)              do { } while (0)

Style: these should be tabs, not spaces ^^^^^^^^^^^^

> +static void ftrace_trace_userstack(struct trace_array *tr,
> +		   struct trace_array_cpu *data,
> +		   unsigned long flags, int pc)
> +{
> +	struct userstack_entry *entry;
> +	struct stack_trace trace;
> +	struct ring_buffer_event *event;
> +	unsigned long irq_flags;

Detail: please use the customary ftrace variable definitions style:

> +	struct ring_buffer_event *event;
> +	struct userstack_entry *entry;
> +	struct stack_trace trace;
> +	unsigned long irq_flags;

note how it's ordered by line length.

> +static int
> +seq_print_userip_objs(const struct userstack_entry *entry, struct trace_seq *s,
> +		unsigned long sym_flags)
> +{
> +	int ret = 1;
> +	unsigned i;

Detail: please use "unsigned int" so that we have less type patterns 
to look for.

> +
> +	for (i = 0; i < FTRACE_STACK_ENTRIES; i++) {
> +		unsigned long ip = entry->caller[i];
> +
> +		if (ip == ULONG_MAX || !ret)
> +			break;
> +		if (i)
> +			ret = trace_seq_puts(s, " <- ");
> +		if (!ip) {
> +			ret = trace_seq_puts(s, "??");
> +			continue;
> +		}
> +		if (ret /*&& (sym_flags & TRACE_ITER_SYM_ADDR)*/)
> +			ret = trace_seq_printf(s, " <" IP_FMT ">", ip);

Detail: do we need that commented-out condition?

	Ingo
