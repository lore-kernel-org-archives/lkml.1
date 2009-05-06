Return-Path: <linux-kernel-owner+w=401wt.eu-S1756399AbZEFCna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756399AbZEFCna (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 22:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbZEFCnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 22:43:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:60806 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbZEFCnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 22:43:21 -0400
Date: Tue, 5 May 2009 22:43:20 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Li Zefan <lizf@cn.fujitsu.com>
cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH 3/4] tracing/events: fix memory leak when unloading
 module
In-Reply-To: <4A00F6E0.3040503@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0905052243000.3239@gandalf.stny.rr.com>
References: <4A00F6AD.2070008@cn.fujitsu.com> <4A00F6E0.3040503@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On Wed, 6 May 2009, Li Zefan wrote:

> When unloading a module, memory allocated by init_preds() and
> trace_define_field() is not freed.
> 
> [ Impact: fix memory leak ]
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Nice catch!

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> ---
>  include/linux/ftrace_event.h       |    1 +
>  kernel/trace/trace_events.c        |   18 ++++++++++++++++++
>  kernel/trace/trace_events_filter.c |   22 +++++++++++++++-------
>  3 files changed, 34 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
> index 5fff40c..662c1be 100644
> --- a/include/linux/ftrace_event.h
> +++ b/include/linux/ftrace_event.h
> @@ -116,6 +116,7 @@ struct ftrace_event_call {
>  #define MAX_FILTER_STR_VAL	128
>  
>  extern int init_preds(struct ftrace_event_call *call);
> +extern void destroy_preds(struct ftrace_event_call *call);
>  extern int filter_match_preds(struct ftrace_event_call *call, void *rec);
>  extern int filter_current_check_discard(struct ftrace_event_call *call,
>  					void *rec,
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 9998cc8..72d619d 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -60,6 +60,22 @@ err:
>  }
>  EXPORT_SYMBOL_GPL(trace_define_field);
>  
> +#ifdef CONFIG_MODULES
> +
> +static void trace_destroy_fields(struct ftrace_event_call *call)
> +{
> +	struct ftrace_event_field *field, *next;
> +
> +	list_for_each_entry_safe(field, next, &call->fields, link) {
> +		list_del(&field->link);
> +		kfree(field->type);
> +		kfree(field->name);
> +		kfree(field);
> +	}
> +}
> +
> +#endif /* CONFIG_MODULES */
> +
>  static void ftrace_clear_events(void)
>  {
>  	struct ftrace_event_call *call;
> @@ -925,6 +941,8 @@ static void trace_module_remove_events(struct module *mod)
>  				unregister_ftrace_event(call->event);
>  			debugfs_remove_recursive(call->dir);
>  			list_del(&call->list);
> +			trace_destroy_fields(call);
> +			destroy_preds(call);
>  		}
>  	}
>  
> diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
> index ac30de3..97bd140 100644
> --- a/kernel/trace/trace_events_filter.c
> +++ b/kernel/trace/trace_events_filter.c
> @@ -371,6 +371,20 @@ static void filter_disable_preds(struct ftrace_event_call *call)
>  		filter->preds[i]->fn = filter_pred_none;
>  }
>  
> +void destroy_preds(struct ftrace_event_call *call)
> +{
> +	struct event_filter *filter = call->filter;
> +	int i;
> +
> +	for (i = 0; i < MAX_FILTER_PRED; i++) {
> +		if (filter->preds[i])
> +			filter_free_pred(filter->preds[i]);
> +	}
> +	kfree(filter->preds);
> +	kfree(filter);
> +	call->filter = NULL;
> +}
> +
>  int init_preds(struct ftrace_event_call *call)
>  {
>  	struct event_filter *filter;
> @@ -399,13 +413,7 @@ int init_preds(struct ftrace_event_call *call)
>  	return 0;
>  
>  oom:
> -	for (i = 0; i < MAX_FILTER_PRED; i++) {
> -		if (filter->preds[i])
> -			filter_free_pred(filter->preds[i]);
> -	}
> -	kfree(filter->preds);
> -	kfree(call->filter);
> -	call->filter = NULL;
> +	destroy_preds(call);
>  
>  	return -ENOMEM;
>  }
> -- 
> 1.5.4.rc3
> 
> 
> 
