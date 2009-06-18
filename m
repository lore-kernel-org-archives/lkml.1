Return-Path: <linux-kernel-owner+w=401wt.eu-S1760192AbZFRGE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760192AbZFRGE7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 02:04:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757448AbZFRGEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 02:04:50 -0400
Received: from mail-yx0-f180.google.com ([209.85.210.180]:55765 "EHLO
	mail-yx0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757433AbZFRGEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 02:04:49 -0400
X-Greylist: delayed 384 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Jun 2009 02:04:49 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=MLQUrauZWVkf0BTei1tW+HPzcIWWtHROhUvZPXDt02qwApLD0kOHDKYlcqZW1uIUrW
         KpocE1/f1kyH6vGPblxXOzQ4C9c2wlsV1n3izMuuUh8eFteq11KduvyiugbZeR35+VnU
         ih+WHKwnMhmkwj4tbkx2tvxfoac+Z2fxwi6kY=
Subject: Re: [PATCH 1/2] tracing/filters: restore orignal filter when new
 filter isn't applicable
From: Tom Zanussi <tzanussi@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4A38AD7F.2070408@cn.fujitsu.com>
References: <4A38AD7F.2070408@cn.fujitsu.com>
Content-Type: text/plain
Date: Thu, 18 Jun 2009 00:58:25 -0500
Message-Id: <1245304705.6207.78.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 2009-06-17 at 16:46 +0800, Li Zefan wrote:
> | commit 7ce7e4249921d5073e764f7ff7ad83cfa9894bd7
> | Author: Tom Zanussi <tzanussi@gmail.com>
> | Date:   Sun Mar 22 03:31:04 2009 -0500
> |
> |     tracing: add per-event filtering
> |     ...
> |
> |     Filters can also be set or cleared for a complete subsystem by writing
> |     the same filter as would be written to an individual event to the
> |     filter file at the root of the subsytem.  Note however, that if any
> |     event in the subsystem lacks a field specified in the filter being
> |     set, the set will fail and all filters in the subsytem are
> |     automatically cleared.  This change from the previous version was made
> |     because using only the fields that happen to exist for a given event
> |     would most likely result in a meaningless filter.
> 
> I really don't like this change. It is inconvenient, and makes subsystem
> filter much less useful:
> 
>   # echo 'vec == 1' > irq/softirq_entry/filter
>   # echo 'irq == 5' > irq/filter
>   bash: echo: write error: Invalid argument
>   # cat irq/softirq_entry/filter
>   none
> 
> I'd expect this will set the filter for irq_handler_entry and
> irq_handler_exit, and won't touch softirq_entry and softirq_exit.
> 
> But it just failed, and what's worse, each event's filter was
> cleared.
> 

The idea behind the change was that after setting a subsystem filter,
you'd be guaranteed that all or none of the events in the subsystem
would have the same filter at that point, and not some mix of different
filters depending on which ones failed or not, which to me seemed
nonintuitive.

If I set a filter like "vec == 1 && irq == 5", which really has no
overall meaning, I wouldn't expect softirq_entry to get "vec == 1" and
irq_handler_entry to get "irq == 5" - I'd rather get an error, but
that's just me.

So if it makes more sense to users to have subsystem filters propagate
to whichever events will take them, this patch would be fine with me.

Tom 


> The basic idea of this patch is, save the filter before applying
> the new one, and fall back to it if the new one can't be applied:
> 
>   # echo 'vec == 1' > softirq_entry/filter
>   # echo 'irq == 5' > filter
>   # cat irq_handler_entry/filter
>   irq == 5
>   # cat softirq_entry/filter
>   vec == 1
> 
> [ Impact: allow subsystem filter be applied to parts of the subsys ]
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/trace/trace.h               |    2 +
>  kernel/trace/trace_events_filter.c |  138 +++++++++++++++++++++++++++++-------
>  2 files changed, 114 insertions(+), 26 deletions(-)
> 
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index 7d5cc37..b5153e9 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -763,6 +763,8 @@ struct event_filter {
>  	int			n_preds;
>  	struct filter_pred	**preds;
>  	char			*filter_string;
> +	char			*old_filter;
> +	bool			need_reset;
>  };
>  
>  struct event_subsystem {
> diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
> index 936c621..2f706e5 100644
> --- a/kernel/trace/trace_events_filter.c
> +++ b/kernel/trace/trace_events_filter.c
> @@ -246,6 +246,29 @@ static int replace_filter_string(struct event_filter *filter,
>  	return 0;
>  }
>  
> +static int save_old_filter(struct event_filter *filter)
> +{
> +	char *old = filter->old_filter;
> +
> +	kfree(old);
> +
> +	if (filter->filter_string)
> +		old = kstrdup(filter->filter_string, GFP_KERNEL);
> +	else
> +		old = kstrdup("0", GFP_KERNEL);
> +	filter->old_filter = old;
> +
> +	if (!old)
> +		return -ENOMEM;
> +	return 0;
> +}
> +
> +static void free_old_filter(struct event_filter *filter)
> +{
> +	kfree(filter->old_filter);
> +	filter->old_filter = NULL;
> +}
> +
>  static int append_filter_string(struct event_filter *filter,
>  				char *string)
>  {
> @@ -374,6 +397,8 @@ void destroy_preds(struct ftrace_event_call *call)
>  	struct event_filter *filter = call->filter;
>  	int i;
>  
> +	WARN_ON(filter->old_filter);
> +
>  	for (i = 0; i < MAX_FILTER_PRED; i++) {
>  		if (filter->preds[i])
>  			filter_free_pred(filter->preds[i]);
> @@ -418,10 +443,9 @@ oom:
>  }
>  EXPORT_SYMBOL_GPL(init_preds);
>  
> -static void filter_free_subsystem_preds(struct event_subsystem *system)
> +static void __filter_free_subsystem_preds(struct event_subsystem *system)
>  {
>  	struct event_filter *filter = system->filter;
> -	struct ftrace_event_call *call;
>  	int i;
>  
>  	if (filter->n_preds) {
> @@ -431,11 +455,22 @@ static void filter_free_subsystem_preds(struct event_subsystem *system)
>  		filter->preds = NULL;
>  		filter->n_preds = 0;
>  	}
> +}
> +
> +static void filter_free_subsystem_preds(struct event_subsystem *system,
> +					bool save_old)
> +{
> +	struct ftrace_event_call *call;
> +
> +	__filter_free_subsystem_preds(system);
>  
>  	list_for_each_entry(call, &ftrace_events, list) {
>  		if (!call->define_fields)
>  			continue;
>  
> +		if (save_old)
> +			save_old_filter(call->filter);
> +
>  		if (!strcmp(call->system, system->name)) {
>  			filter_disable_preds(call);
>  			remove_filter_string(call->filter);
> @@ -608,8 +643,9 @@ static int filter_add_subsystem_pred(struct filter_parse_state *ps,
>  				     char *filter_string)
>  {
>  	struct event_filter *filter = system->filter;
> +	struct event_filter *call_filter;
>  	struct ftrace_event_call *call;
> -	int err = 0;
> +	int err;
>  
>  	if (!filter->preds) {
>  		filter->preds = kzalloc(MAX_FILTER_PRED * sizeof(pred),
> @@ -629,22 +665,23 @@ static int filter_add_subsystem_pred(struct filter_parse_state *ps,
>  
>  	list_for_each_entry(call, &ftrace_events, list) {
>  
> +		call_filter = call->filter;
> +
>  		if (!call->define_fields)
>  			continue;
>  
>  		if (strcmp(call->system, system->name))
>  			continue;
>  
> +		if (call_filter->need_reset)
> +			continue;
> +
>  		err = filter_add_pred(ps, call, pred);
> -		if (err) {
> -			filter_free_subsystem_preds(system);
> -			parse_error(ps, FILT_ERR_BAD_SUBSYS_FILTER, 0);
> -			goto out;
> -		}
> -		replace_filter_string(call->filter, filter_string);
> +		if (err)
> +			call_filter->need_reset = true;
>  	}
> -out:
> -	return err;
> +
> +	return 0;
>  }
>  
>  static void parse_init(struct filter_parse_state *ps,
> @@ -1063,25 +1100,21 @@ static int replace_preds(struct event_subsystem *system,
>  	return 0;
>  }
>  
> -int apply_event_filter(struct ftrace_event_call *call, char *filter_string)
> +int __apply_event_filter(struct ftrace_event_call *call, char *filter_string)
>  {
>  	int err;
>  
>  	struct filter_parse_state *ps;
>  
> -	mutex_lock(&event_mutex);
> -
>  	if (!strcmp(strstrip(filter_string), "0")) {
>  		filter_disable_preds(call);
>  		remove_filter_string(call->filter);
> -		mutex_unlock(&event_mutex);
>  		return 0;
>  	}
>  
> -	err = -ENOMEM;
>  	ps = kzalloc(sizeof(*ps), GFP_KERNEL);
>  	if (!ps)
> -		goto out_unlock;
> +		return -ENOMEM;
>  
>  	filter_disable_preds(call);
>  	replace_filter_string(call->filter, filter_string);
> @@ -1101,23 +1134,52 @@ out:
>  	filter_opstack_clear(ps);
>  	postfix_clear(ps);
>  	kfree(ps);
> -out_unlock:
> -	mutex_unlock(&event_mutex);
>  
>  	return err;
>  }
>  
> +void __apply_event_old_filter(struct ftrace_event_call *call)
> +{
> +	struct event_filter *filter = call->filter;
> +	int ret;
> +
> +	ret = __apply_event_filter(call, filter->old_filter);
> +	if (ret) {
> +		ret = __apply_event_filter(call, "0");
> +		WARN_ON(ret);
> +	}
> +}
> +
> +int apply_event_filter(struct ftrace_event_call *call, char *filter_string)
> +{
> +	int ret;
> +
> +	ret = save_old_filter(call->filter);
> +	if (ret)
> +		return ret;
> +
> +	mutex_lock(&event_mutex);
> +	ret = __apply_event_filter(call, filter_string);
> +	if (ret)
> +		__apply_event_old_filter(call);
> +	mutex_unlock(&event_mutex);
> +
> +	free_old_filter(call->filter);
> +	return ret;
> +}
> +
>  int apply_subsystem_event_filter(struct event_subsystem *system,
>  				 char *filter_string)
>  {
> -	int err;
> -
> +	struct event_filter *filter;
> +	struct ftrace_event_call *call;
>  	struct filter_parse_state *ps;
> +	int err;
>  
>  	mutex_lock(&event_mutex);
>  
>  	if (!strcmp(strstrip(filter_string), "0")) {
> -		filter_free_subsystem_preds(system);
> +		filter_free_subsystem_preds(system, false);
>  		remove_filter_string(system->filter);
>  		mutex_unlock(&event_mutex);
>  		return 0;
> @@ -1128,24 +1190,48 @@ int apply_subsystem_event_filter(struct event_subsystem *system,
>  	if (!ps)
>  		goto out_unlock;
>  
> -	filter_free_subsystem_preds(system);
> -	replace_filter_string(system->filter, filter_string);
> +	filter = system->filter;
> +	filter_free_subsystem_preds(system, true);
> +	save_old_filter(filter);
> +	replace_filter_string(filter, filter_string);
>  
>  	parse_init(ps, filter_ops, filter_string);
>  	err = filter_parse(ps);
>  	if (err) {
> -		append_filter_err(ps, system->filter);
> +		replace_filter_string(filter, filter->old_filter);
>  		goto out;
>  	}
>  
>  	err = replace_preds(system, NULL, ps, filter_string);
>  	if (err)
> -		append_filter_err(ps, system->filter);
> +		replace_filter_string(filter, filter->old_filter);
> +
> +	/*
> +	 * For those events that the filter can't be applied to,
> +	 * reset them with their original filters.
> +	 */
> +	list_for_each_entry(call, &ftrace_events, list) {
> +		if (!call->define_fields)
> +			continue;
> +
> +		if (strcmp(call->system, system->name) != 0)
> +			continue;
> +
> +		filter = call->filter;
> +		if (filter->need_reset || err) {
> +			filter->need_reset = false;
> +			__apply_event_old_filter(call);
> +		} else
> +			replace_filter_string(filter, filter_string);
> +
> +		free_old_filter(filter);
> +	}
>  
>  out:
>  	filter_opstack_clear(ps);
>  	postfix_clear(ps);
>  	kfree(ps);
> +	free_old_filter(system->filter);
>  out_unlock:
>  	mutex_unlock(&event_mutex);
>  
> -- 1.5.4.rc3 

