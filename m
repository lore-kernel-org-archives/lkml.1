Return-Path: <linux-kernel-owner+w=401wt.eu-S1756390AbZLIRyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756390AbZLIRyX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 12:54:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756368AbZLIRyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 12:54:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37878 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756363AbZLIRyU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 12:54:20 -0500
Message-ID: <4B1FE43B.4090800@redhat.com>
Date: Wed, 09 Dec 2009 12:54:03 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jason Baron <jbaron@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 08/10] trace_kprobe: init print_fmt
References: <4B1F4EAB.9020403@cn.fujitsu.com>
In-Reply-To: <4B1F4EAB.9020403@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lai Jiangshan wrote:
> Init print_fmt for trace_kprobe.
> It will be used for replacing ->show_format().
>
> Signed-off-by: Lai Jiangshan<laijs@cn.fujitsu.com>

Looks good to me.

Acked-by: Masami Hiramatsu <mhiramat@redhat.com>

> ---
> diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
> index 3ef66d4..a12d39b 100644
> --- a/kernel/trace/trace_kprobe.c
> +++ b/kernel/trace/trace_kprobe.c
> @@ -1212,6 +1212,55 @@ static int kretprobe_event_show_format(struct ftrace_event_call *call,
>   					 ", REC->" FIELD_STRING_RETIP);
>   }
>
> +static int __set_print_fmt(struct trace_probe *tp, char *buf, int len)
> +{
> +	int i;
> +	int pos = 0;
> +
> +	const char *fmt, *arg;
> +
> +	if (!probe_is_return(tp)) {
> +		fmt = "(%lx)";
> +		arg = "REC->" FIELD_STRING_IP;
> +	} else {
> +		fmt = "(%lx<- %lx)";
> +		arg = "REC->" FIELD_STRING_FUNC ", REC->" FIELD_STRING_RETIP;
> +	}
> +
> +	pos += snprintf(buf + pos, len>  pos ? len - pos : 0, "\"%s", fmt);
> +
> +	for (i = 0; i<  tp->nr_args; i++) {
> +		pos += snprintf(buf + pos, len>  pos ? len - pos : 0,
> +				" %s=%%lx", tp->args[i].name);
> +	}
> +
> +	pos += snprintf(buf + pos, len>  pos ? len - pos : 0, "\", %s", arg);
> +
> +	for (i = 0; i<  tp->nr_args; i++) {
> +		pos += snprintf(buf + pos, len>  pos ? len - pos : 0,
> +				", REC->%s", tp->args[i].name);
> +	}
> +
> +	/* return the length of print_fmt */
> +	return pos;
> +}
> +
> +static int set_print_fmt(struct trace_probe *tp)
> +{
> +	int len;
> +	char *print_fmt;
> +
> +	len = __set_print_fmt(tp, NULL, 0);
> +	print_fmt = kmalloc(len + 1, GFP_KERNEL);
> +	if (!print_fmt)
> +		return -ENOMEM;
> +
> +	__set_print_fmt(tp, print_fmt, len + 1);
> +	tp->call.print_fmt = print_fmt;
> +
> +	return 0;
> +}
> +
>   #ifdef CONFIG_EVENT_PROFILE
>
>   /* Kprobe profile handler */
> @@ -1418,10 +1467,14 @@ static int register_probe_event(struct trace_probe *tp)
>   		call->show_format = kprobe_event_show_format;
>   		call->define_fields = kprobe_event_define_fields;
>   	}
> +	if (set_print_fmt(tp)<  0)
> +		return -ENOMEM;
>   	call->event =&tp->event;
>   	call->id = register_ftrace_event(&tp->event);
> -	if (!call->id)
> +	if (!call->id) {
> +		kfree(call->print_fmt);
>   		return -ENODEV;
> +	}
>   	call->enabled = 0;
>   	call->regfunc = probe_event_enable;
>   	call->unregfunc = probe_event_disable;
> @@ -1435,6 +1488,7 @@ static int register_probe_event(struct trace_probe *tp)
>   	ret = trace_add_event_call(call);
>   	if (ret) {
>   		pr_info("Failed to register kprobe event: %s\n", call->name);
> +		kfree(call->print_fmt);
>   		unregister_ftrace_event(&tp->event);
>   	}
>   	return ret;
> @@ -1444,6 +1498,7 @@ static void unregister_probe_event(struct trace_probe *tp)
>   {
>   	/* tp->event is unregistered in trace_remove_event_call() */
>   	trace_remove_event_call(&tp->call);
> +	kfree(tp->call.print_fmt);
>   }
>
>   /* Make a debugfs interface for controling probe points */
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

