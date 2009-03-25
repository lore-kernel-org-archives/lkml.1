Return-Path: <linux-kernel-owner+w=401wt.eu-S1755480AbZCYDDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480AbZCYDDb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 23:03:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752967AbZCYDDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 23:03:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:54826 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbZCYDDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 23:03:22 -0400
Date: Tue, 24 Mar 2009 23:03:18 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, maneesh@linux.vnet.ibm.com,
       Roland McGrath <roland@redhat.com>
Subject: Re: [Patch 11/11] ftrace plugin for kernel symbol tracing using HW
 Breakpoint interfaces - v2
In-Reply-To: <20090324152811.GL17918@in.ibm.com>
Message-ID: <alpine.DEB.2.00.0903242256280.22830@gandalf.stny.rr.com>
References: <20090324152028.754123712@K.Prasad> <20090324152811.GL17918@in.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Prasad,

On Tue, 24 Mar 2009, K.Prasad wrote:

> +
> +static void ksym_trace_print_header(struct seq_file *m)
> +{
> +
> +	seq_puts(m,
> +		 "#       TASK-PID      CPU#      Symbol         Type    "
> +		 "Function         \n");
> +	seq_puts(m,
> +		 "#          |           |          |              |         "
> +		 "|            \n");
> +}
> +
> +static enum print_line_t ksym_trace_output(struct trace_iterator *iter)
> +{
> +	struct trace_entry *entry = iter->ent;
> +	struct trace_seq *s = &iter->seq;
> +	struct trace_ksym *field;
> +	char str[KSYM_SYMBOL_LEN];
> +	int ret;
> +
> +	trace_assign_type(field, entry);

Looking at this, you do not test the iter->ent->type. If events or
trace_printk is running, this will fail your tracer.

You want to test for your types first, because all trace types will be 
called for "print_line" function below.

Thus you want something like

	if (entry->type != TRACE_KSYM)
		return TRACE_TYPE_UNHANDLED;

Then the tracer infrastructure could print out the trace event or 
trace_printk.

If you only want to print your events and ignore all others. Return
TRACE_TYPE_HANDLED.

Note, the if needs to be before the trace_assign_type.

-- Steve

> +
> +	ret = trace_seq_printf(s, "%-15s %-5d %-3d %-20s ", field->p_name,
> +				entry->pid, iter->cpu, field->ksym_name);
> +	if (!ret)
> +		return TRACE_TYPE_PARTIAL_LINE;
> +
> +	switch (field->ksym_hbp->info.type) {
> +	case HW_BREAKPOINT_WRITE:
> +		ret = trace_seq_printf(s, " W  ");
> +		break;
> +	case HW_BREAKPOINT_RW:
> +		ret = trace_seq_printf(s, " RW ");
> +		break;
> +	default:
> +		return TRACE_TYPE_PARTIAL_LINE;
> +	}
> +
> +	if (!ret)
> +		return TRACE_TYPE_PARTIAL_LINE;
> +
> +	sprint_symbol(str, field->ip);
> +	ret = trace_seq_printf(s, "%-20s\n", str);
> +	if (!ret)
> +		return TRACE_TYPE_PARTIAL_LINE;
> +
> +	return TRACE_TYPE_HANDLED;
> +}
> +
> +struct tracer ksym_tracer __read_mostly =
> +{
> +	.name		= "ksym_tracer",
> +	.init		= ksym_trace_init,
> +	.reset		= ksym_trace_reset,
> +#ifdef CONFIG_FTRACE_SELFTEST
> +	.selftest	= trace_selftest_startup_ksym,
> +#endif
> +	.print_header   = ksym_trace_print_header,
> +	.print_line	= ksym_trace_output
> +};
> +
