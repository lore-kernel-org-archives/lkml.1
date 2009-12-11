Return-Path: <linux-kernel-owner+w=401wt.eu-S1761926AbZLKAfC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761926AbZLKAfC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 19:35:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758032AbZLKAfB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 19:35:01 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:45195 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757350AbZLKAfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 19:35:00 -0500
X-Authority-Analysis: v=1.0 c=1 a=nFhjYqsp-egA:10 a=7U3hwN5JcxgA:10 a=omOdbC7AAAAA:8 a=o1JJNZZYVEd3fTa8J8sA:9 a=uE7RtLlhIR0Hhl4nDRcpI8BUXO8A:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 07/10] trace_syscalls: init print_fmt
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Jason Baron <jbaron@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B1F4EA6.5080105@cn.fujitsu.com>
References: <4B1F4EA6.5080105@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 10 Dec 2009 19:34:58 -0500
Message-ID: <1260491698.2146.322.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-09 at 15:15 +0800, Lai Jiangshan wrote:
> Init print_fmt for trace_syscalls.
> It will be used for replacing ->show_format().

This needs more explanation too.

> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
> index 75289f3..dcd8699 100644
> --- a/kernel/trace/trace_syscalls.c
> +++ b/kernel/trace/trace_syscalls.c
> @@ -191,6 +191,61 @@ int syscall_enter_format(struct ftrace_event_call *call, struct trace_seq *s)
>  	return trace_seq_putc(s, '\n');
>  }
>  
> +static
> +int  __set_enter_print_fmt(struct syscall_metadata *entry, char *buf, int len)
> +{
> +	int i;
> +	int pos = 0;
> +
> +	pos += snprintf(buf + pos, len > pos ? len - pos : 0, "\"");
> +	for (i = 0; i < entry->nb_args; i++) {
> +		pos += snprintf(buf + pos, len > pos ? len - pos : 0,
> +				"%s: 0x%%0%zulx%s", entry->args[i],
> +				sizeof(unsigned long),
> +				i == entry->nb_args - 1 ? "" : ", ");
> +	}
> +	pos += snprintf(buf + pos, len > pos ? len - pos : 0, "\"");
> +
> +	for (i = 0; i < entry->nb_args; i++) {
> +		pos += snprintf(buf + pos, len > pos ? len - pos : 0,
> +				", ((unsigned long)(REC->%s))", entry->args[i]);

Yuck! 4 snprintf(buf + pos, len > pos ? len - pos: 0 ...

Please make a wrapper for that.

Actually, this could use the new trace_seq code if I separate the
buffer. You would just need to do:

	struct trace_seq s;

	trace_seq_init(&s, buf, len);

	trace_seq_putc(&s, '"');
	for (i = 0; i < entry->nb_args; i++)
		trace_seq_printf(&s, "%s: 0x%%0%zulx%s", entry->args[i],
				sizeof(unsigned long),
				i == entry->nb_args - 1 ? "" : ", ");

	trace_seq_putc(&s, '"');

	for (i = 0; i < entry->nb_args; i++)
		trace_seq_printf(&s, ", ((unsigned long)(REC->%s)",
				entry->args[i]);

	return s.len;


Looks much better, and less error prone.

-- Steve

> +	}
> +
> +	/* return the length of print_fmt */
> +	return pos;
> +}
> +
> +static int set_syscall_print_fmt(struct ftrace_event_call *call)
> +{
> +	char *print_fmt;
> +	int len;
> +	struct syscall_metadata *entry = call->data;
> +
> +	if (entry->enter_event != call) {
> +		call->print_fmt = "\"0x%lx\", REC->ret";
> +		return 0;
> +	}
> +
> +	len = __set_enter_print_fmt(entry, NULL, 0);
> +
> +	print_fmt = kmalloc(len + 1, GFP_KERNEL);
> +	if (!print_fmt)
> +		return -ENOMEM;
> +
> +	__set_enter_print_fmt(entry, print_fmt, len + 1);
> +	call->print_fmt = print_fmt;
> +
> +	return 0;
> +}
> +
> +static void free_syscall_print_fmt(struct ftrace_event_call *call)
> +{
> +	struct syscall_metadata *entry = call->data;
> +
> +	if (entry->enter_event == call)
> +		kfree(call->print_fmt);
> +}
> +
>  int syscall_exit_format(struct ftrace_event_call *call, struct trace_seq *s)
>  {
>  	int ret;
> @@ -386,9 +441,14 @@ int init_syscall_trace(struct ftrace_event_call *call)
>  {
>  	int id;
>  
> +	if (set_syscall_print_fmt(call) < 0)
> +		return -ENOMEM;
> +
>  	id = register_ftrace_event(call->event);
> -	if (!id)
> +	if (!id) {
> +		free_syscall_print_fmt(call);
>  		return -ENODEV;
> +	}
>  	call->id = id;
>  	INIT_LIST_HEAD(&call->fields);
>  	return 0;
> 
> 


