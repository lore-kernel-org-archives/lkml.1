Return-Path: <linux-kernel-owner+w=401wt.eu-S1754897AbZEXUqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897AbZEXUqa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 16:46:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752096AbZEXUqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 16:46:23 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:48555 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbZEXUqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 16:46:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qm3U538b1nDQ3K3I6Yyo7wPL1xi77oDceE6ao12qGwfZCAc85Qzu+EMO4D+xhfYL2T
         /SHsXqZ84yVUQk3xfZNM5p9ElnJUC0N3jixyhadFQXyB1FafI/9DIdLqjAoCtTEk1U2U
         PSOhRHAeh4nin7924SQE1UZdBlCB3BUNbs9TQ=
Date: Sun, 24 May 2009 22:46:23 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Tom Zanussi <tzanussi@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] ftrace: clean up of using
	ftrace_event_enable_disable()
Message-ID: <20090524204620.GC6471@nowhere>
References: <4A14FDFE.2080402@cn.fujitsu.com> <4A16788F.2060802@cn.fujitsu.com> <4A16791C.8090501@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A16791C.8090501@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 22, 2009 at 06:06:20PM +0800, Zhaolei wrote:
> Always use tracing_stop_cmdline_record() to enable/disable a event.
> 
> Impact: cleanup, no functionality changed
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> ---
>  kernel/trace/trace_events.c |   44 +++++++++++++-----------------------------
>  1 files changed, 14 insertions(+), 30 deletions(-)
> 
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index df35e5e..16ef47a 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -76,26 +76,9 @@ static void trace_destroy_fields(struct ftrace_event_call *call)
>  
>  #endif /* CONFIG_MODULES */
>  
> -static void ftrace_clear_events(void)
> -{
> -	struct ftrace_event_call *call;
> -
> -	mutex_lock(&event_mutex);
> -	list_for_each_entry(call, &ftrace_events, list) {


Don't we have a "for_each_event" ?


> -
> -		if (call->enabled) {
> -			call->enabled = 0;
> -			tracing_stop_cmdline_record();
> -			call->unregfunc();
> -		}
> -	}
> -	mutex_unlock(&event_mutex);
> -}
> -
>  static void ftrace_event_enable_disable(struct ftrace_event_call *call,
>  					int enable)
>  {
> -
>  	switch (enable) {
>  	case 0:
>  		if (call->enabled) {
> @@ -114,6 +97,17 @@ static void ftrace_event_enable_disable(struct ftrace_event_call *call,
>  	}
>  }
>  
> +static void ftrace_clear_events(void)
> +{
> +	struct ftrace_event_call *call;
> +
> +	mutex_lock(&event_mutex);
> +	list_for_each_entry(call, &ftrace_events, list) {
> +		ftrace_event_enable_disable(call, 0);
> +	}
> +	mutex_unlock(&event_mutex);
> +}
> +
>  /*
>   * __ftrace_set_clr_event(NULL, NULL, NULL, set) will set/unset all events.
>   */
> @@ -1059,11 +1053,7 @@ static void trace_module_remove_events(struct module *mod)
>  	list_for_each_entry_safe(call, p, &ftrace_events, list) {
>  		if (call->mod == mod) {
>  			found = true;
> -			if (call->enabled) {
> -				call->enabled = 0;
> -				tracing_stop_cmdline_record();
> -				call->unregfunc();
> -			}
> +			ftrace_event_enable_disable(call, 0);
>  			if (call->event)
>  				unregister_ftrace_event(call->event);
>  			debugfs_remove_recursive(call->dir);
> @@ -1265,15 +1255,9 @@ static __init void event_trace_self_tests(void)
>  			continue;
>  		}
>  
> -		call->enabled = 1;
> -		tracing_start_cmdline_record();
> -		call->regfunc();
> -
> +		ftrace_event_enable_disable(call, 1);
>  		event_test_stuff();
> -
> -		call->unregfunc();
> -		tracing_stop_cmdline_record();
> -		call->enabled = 0;
> +		ftrace_event_enable_disable(call, 0);
>  
>  		pr_cont("OK\n");
>  	}


Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

