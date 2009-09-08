Return-Path: <linux-kernel-owner+w=401wt.eu-S1753463AbZIHCsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463AbZIHCsV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 22:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753291AbZIHCsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 22:48:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:46353 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282AbZIHCsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 22:48:20 -0400
Subject: Re: [PATCH] tracing/filters: use strcmp() instead of strncmp()
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4A221B41.4030907@cn.fujitsu.com>
References: <4A221B41.4030907@cn.fujitsu.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Mon, 07 Sep 2009 22:48:21 -0400
Message-Id: <1252378101.21261.2057.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li,

I'm going through some old email, and I came across this patch. It seems
that it never got applied. Could you port this to the latest -tip tree
and resend it.

Sorry about missing it.

Thanks,

-- Steve


On Sun, 2009-05-31 at 13:53 +0800, Li Zefan wrote:
> Trace filter is not working normally:
> 
>   # echo 'name == et' > tracing/events/irq/irq_handler_entry/filter
>   # echo 1 > tracing/events/irq/irq_handler_entry/enable
>   # cat trace_pipe
>       <idle>-0     [001]  1363.423175: irq_handler_entry: irq=18 handler=eth0
>       <idle>-0     [001]  1363.934528: irq_handler_entry: irq=18 handler=eth0
> 
> It's because we pass to trace_define_field() the information of
> __str_loc_##item, but not the actual string, so pred->str_len == field->size
> == sizeof(unsigned short), thus it always compare at most 2 bytes when
> filtering on __string() field.
> 
> Since __string() is dynamic size, we are not able to set field->size to
> string length. Alternatively this patch uses strcmp() instead of strncmp(),
> for both static strings and dynamic strings. strncmp() is not necessary,
> since strings passed to it are already guaranteed to be NULL-terminated.
> 
> [ Impact: make filter facility working normally for dynamic strings ]
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/trace/trace.h               |    1 -
>  kernel/trace/trace_events_filter.c |    7 ++-----
>  2 files changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index 6e735d4..ec8970b 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -758,7 +758,6 @@ struct filter_pred {
>  	filter_pred_fn_t fn;
>  	u64 val;
>  	char str_val[MAX_FILTER_STR_VAL];
> -	int str_len;
>  	char *field_name;
>  	int offset;
>  	int not;
> diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
> index a854eed..8362586 100644
> --- a/kernel/trace/trace_events_filter.c
> +++ b/kernel/trace/trace_events_filter.c
> @@ -158,7 +158,7 @@ static int filter_pred_string(struct filter_pred *pred, void *event,
>  	char *addr = (char *)(event + pred->offset);
>  	int cmp, match;
>  
> -	cmp = strncmp(addr, pred->str_val, pred->str_len);
> +	cmp = strcmp(addr, pred->str_val);
>  
>  	match = (!cmp) ^ pred->not;
>  
> @@ -182,7 +182,7 @@ static int filter_pred_strloc(struct filter_pred *pred, void *event,
>  	char *addr = (char *)(event + str_loc);
>  	int cmp, match;
>  
> -	cmp = strncmp(addr, pred->str_val, pred->str_len);
> +	cmp = strcmp(addr, pred->str_val);
>  
>  	match = (!cmp) ^ pred->not;
>  
> @@ -341,7 +341,6 @@ static void filter_clear_pred(struct filter_pred *pred)
>  {
>  	kfree(pred->field_name);
>  	pred->field_name = NULL;
> -	pred->str_len = 0;
>  }
>  
>  static int filter_set_pred(struct filter_pred *dest,
> @@ -576,7 +575,6 @@ static int filter_add_pred(struct filter_parse_state *ps,
>  			fn = filter_pred_string;
>  		else
>  			fn = filter_pred_strloc;
> -		pred->str_len = field->size;
>  		if (pred->op == OP_NE)
>  			pred->not = 1;
>  		return filter_add_pred_fn(ps, call, pred, fn);
> @@ -957,7 +955,6 @@ static struct filter_pred *create_pred(int op, char *operand1, char *operand2)
>  	}
>  
>  	strcpy(pred->str_val, operand2);
> -	pred->str_len = strlen(operand2);
>  
>  	pred->op = op;
>  

