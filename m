Return-Path: <linux-kernel-owner+w=401wt.eu-S934652AbZKYM6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934652AbZKYM6V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 07:58:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758746AbZKYM6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 07:58:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65191 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758723AbZKYM6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 07:58:19 -0500
Message-ID: <4B0D2A75.9000009@redhat.com>
Date: Wed, 25 Nov 2009 08:00:37 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] trace_kprobes: don't output zero offset
References: <4B0CEBCB.7080309@cn.fujitsu.com>
In-Reply-To: <4B0CEBCB.7080309@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lai,

Lai Jiangshan wrote:
> 
> "symbol_name+0" is not so friendly.
> It makes the output longer.

Hmm, I've added +0 just for convenience of parser programs.
But anyway, skipping it is not so costly option for them :-)

Acked-by: Masami Hiramatsu <mhiramat@redhat.com>

> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
> index 9e42f2a..e82bea3 100644
> --- a/kernel/trace/trace_kprobe.c
> +++ b/kernel/trace/trace_kprobe.c
> @@ -243,7 +243,11 @@ static int probe_arg_string(char *buf, size_t n, struct fetch_func *ff)
>  		ret = snprintf(buf, n, "@0x%p", ff->data);
>  	else if (ff->func == fetch_symbol) {
>  		struct symbol_cache *sc = ff->data;
> -		ret = snprintf(buf, n, "@%s%+ld", sc->symbol, sc->offset);
> +		if (sc->offset)
> +			ret = snprintf(buf, n, "@%s%+ld", sc->symbol,
> +					sc->offset);
> +		else
> +			ret = snprintf(buf, n, "@%s", sc->symbol);
>  	} else if (ff->func == fetch_retvalue)
>  		ret = snprintf(buf, n, "$retval");
>  	else if (ff->func == fetch_stack_address)
> @@ -760,10 +764,12 @@ static int probes_seq_show(struct seq_file *m, void *v)
>  	seq_printf(m, "%c", probe_is_return(tp) ? 'r' : 'p');
>  	seq_printf(m, ":%s/%s", tp->call.system, tp->call.name);
>  
> -	if (tp->symbol)
> +	if (!tp->symbol)
> +		seq_printf(m, " 0x%p", tp->rp.kp.addr);
> +	else if (tp->rp.kp.offset)
>  		seq_printf(m, " %s+%u", probe_symbol(tp), tp->rp.kp.offset);
>  	else
> -		seq_printf(m, " 0x%p", tp->rp.kp.addr);
> +		seq_printf(m, " %s", probe_symbol(tp));
>  
>  	for (i = 0; i < tp->nr_args; i++) {
>  		ret = probe_arg_string(buf, MAX_ARGSTR_LEN, &tp->args[i].fetch);
> 
> 

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

