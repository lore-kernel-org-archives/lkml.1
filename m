Return-Path: <linux-kernel-owner+w=401wt.eu-S1755138AbYKQIpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138AbYKQIpt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 03:45:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752684AbYKQIpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 03:45:41 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59390 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752670AbYKQIpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 03:45:40 -0500
Date: Mon, 17 Nov 2008 09:45:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Steven Noonan <steven@uplinklabs.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] tracing/ftrace: implement a set_flag callback for
	tracers
Message-ID: <20081117084524.GB28786@elte.hu>
References: <4920D402.3000803@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4920D402.3000803@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


i've got some syntactic nits:

> +	/*
> +	 * Increase the size with names of options specific
> +	 * of the current tracer.
> +	 */
> +	if (trace_opts) {
> +		for (i = 0; trace_opts[i].name; i++) {
> +			len += strlen(trace_opts[i].name);
> +			len += 3;

magic constant '3' needs a comment at least.

> +	if (trace_opts) {
> +		for (i = 0; trace_opts[i].name; i++) {
> +			if (tracer_flags & trace_opts[i].bit)
> +				r += sprintf(buf + r, "%s ",
> +					trace_opts[i].name);
> +			else
> +				r += sprintf(buf + r, "no%s ",
> +					trace_opts[i].name);
> +		}
> +	}

how about making a dummy empty trace_opts for all tracers (set by 
plugin init if the init function finds a NULL there) - that way the 
'if (trace_opts)' can go away and you can just iterate away on that 
array of options.

> +		if (strncmp(cmp, opts->name, len) == 0) {
> +			if (trace->set_flag)
> +					ret = trace->set_flag(trace_flags->val,
> +							opts->bit, !neg);

one tab too much. Also, the condition can be avoided by creating a 
dummy ->set_flag() that just returns 0.

> @@ -2469,6 +2536,7 @@ tracing_trace_options_write(struct file *filp, const char __user *ubuf,
>  	char *cmp = buf;
>  	int neg = 0;
>  	int i;
> +	int ret;

variable should be one line higher, to not break the upside down 
christmas tree layout. [ :-) ]

> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -259,6 +259,29 @@ enum print_line_t {
>  	TRACE_TYPE_UNHANDLED	= 2	/* Relay to other output functions */
>  };
>  
> +
> +/*
> + * An option specific to a tracer. This is a boolean value.
> + * The bit is the bit index that sets its value on the
> + * flags value in struct tracer_flags.
> + */
> +struct tracer_opt {
> +	const char *name; /* Will appear on the trace_options file */
> +	u32 bit; /* The mask assigned in val field in tracer_flags */
> +};

> +
> +/*
> + * The set of specific options for a tracer. Your tracer
> + * have to set the initial value of the flags val.
> + */
> +struct tracer_flags {
> +	u32	val;
> +	struct tracer_opt *opts;
> +};

please look at the file you modify and try to clone the micro-style it 
follows. For example in this file it would be more standard to use 
vertical alignment for structure definitions:

> +struct tracer_flags {
> +	u32			val;
> +	struct tracer_opt	*opts;
> +};

> +
> +/* Makes more easy to define a tracer opt */
> +#define TRACER_OPT(s, b) .name = #s, .bit = b

ditto.

>  #endif
>  	enum print_line_t	(*print_line)(struct trace_iterator *iter);
> +	/* If you handled the flag setting, return 0 */
> +	int			(*set_flag)(u32 old_flags, u32 bit,
> +							int set);
>  	struct tracer		*next;
>  	int			print_max;
> +	struct tracer_flags *flags;

ditto - here the new field deviates from he existing style.

also note how the 'int set);' line is unnecessarily broken to a 
separate line - it could be in the same line where the set_flag field 
begins.

> @@ -484,6 +511,7 @@ enum trace_iterator_flags {
>  #define TRACE_ITER_SYM_MASK \
>  	(TRACE_ITER_PRINT_PARENT|TRACE_ITER_SYM_OFFSET|TRACE_ITER_SYM_ADDR)
>  
> +
>  extern struct tracer nop_trace;

spurious looking newline insertion.

	Ingo
