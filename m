Return-Path: <linux-kernel-owner+w=401wt.eu-S1760725AbZCTAIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760725AbZCTAIo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 20:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757100AbZCTAIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 20:08:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:37064 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756391AbZCTAId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 20:08:33 -0400
Date: Thu, 19 Mar 2009 20:08:30 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Masami Hiramatsu <mhiramat@redhat.com>
cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>,
       systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH -tip 9/9] tracing: kprobe-tracer plugin supports
 module_probe
In-Reply-To: <49C2B4D9.6040602@redhat.com>
Message-ID: <alpine.DEB.2.00.0903192007380.13615@gandalf.stny.rr.com>
References: <49C2B4D9.6040602@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 19 Mar 2009, Masami Hiramatsu wrote:

> Use register/unregister_module_*probe functions for tracing
> module .init/.exit functions.
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---
>  kernel/trace/trace_kprobe.c |   15 ++++++++++-----
>  1 files changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
> index e801e8c..7b7ab53 100644
> --- a/kernel/trace/trace_kprobe.c
> +++ b/kernel/trace/trace_kprobe.c
> @@ -226,6 +226,11 @@ static void free_trace_probe(struct trace_probe *tp)
>  	kfree(tp);
>  }
> 
> +static int activate_handler(void *offset, struct module *mod)
> +{
> +	return ((unsigned long)offset == 0) ? 1 : 0;

This is a strange way to implement:

	return !offset;

-- Steve

> +}
> +
>  static int register_trace_probe(struct trace_probe *tp)
>  {
>  	int ret;
> @@ -234,9 +239,10 @@ static int register_trace_probe(struct trace_probe *tp)
>  	list_add_tail(&tp->list, &probe_list);
> 
>  	if (probe_is_return(tp))
> -		ret = register_kretprobe(&tp->rp);
> +		ret = register_module_kretprobe(&tp->rp, activate_handler, 0);
>  	else
> -		ret = register_kprobe(&tp->kp);
> +		ret = register_module_kprobe(&tp->kp, activate_handler,
> +					     (void *)(tp->kp.offset));
> 
>  	if (ret) {
>  		pr_warning("Probe registering error: %d\n", ret);
> @@ -249,9 +255,9 @@ static int register_trace_probe(struct trace_probe *tp)
>  static void unregister_trace_probe(struct trace_probe *tp)
>  {
>  	if (probe_is_return(tp))
> -		unregister_kretprobe(&tp->rp);
> +		unregister_module_kretprobe(&tp->rp);
>  	else
> -		unregister_kprobe(&tp->kp);
> +		unregister_module_kprobe(&tp->kp);
>  	list_del(&tp->list);
>  }
> 
> @@ -301,7 +307,6 @@ static int create_trace_probe(int argc, char **argv)
>  	} else {
>  		/* a symbol specified */
>  		symbol = argv[1];
> -		/* TODO: support .init module functions */
>  		tmp = strchr(symbol, '+');
>  		if (!tmp)
>  			tmp = strchr(symbol, '-');
> -- 
> Masami Hiramatsu
> 
> Software Engineer
> Hitachi Computer Products (America) Inc.
> Software Solutions Division
> 
> e-mail: mhiramat@redhat.com
> 
> 
> 
