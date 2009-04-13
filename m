Return-Path: <linux-kernel-owner+w=401wt.eu-S1754148AbZDMOpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148AbZDMOpa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 10:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863AbZDMOpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 10:45:21 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:51643 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbZDMOpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 10:45:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=aJIt/pdlyGfPZTLJyFJewVjsTXk6lZd04Mr6NvyyqQDT96GX5slxmsbxMGmhipQ+Sq
         7PEkMOoA4dkzzLnVsTfY4c6CQ7uvKJHIzzjxEYh/iUK410RN1c738/wanvGqcLIPE2lN
         UBoMZJZXTE5GRVvV7yDpGuh5uoGnscMdpr4yU=
Date: Mon, 13 Apr 2009 16:45:15 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Tom Zanussi <tzanussi@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] tracing/filters: allow user-input to be
	integer-like string
Message-ID: <20090413144513.GF5977@nowhere>
References: <49E2A594.4060306@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E2A594.4060306@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 13, 2009 at 10:38:12AM +0800, Li Zefan wrote:
> Suppose we would like to trace all tasks named '123', but this
> will fail:
>  # echo 'parent_comm == 123' > events/sched/sched_process_fork/filter
>  bash: echo: write error: Invalid argument
> 
> Don't guess the type of the filter pred in filter_parse(), but instead
> we check it in filter_add_pred().
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/trace/trace_events_filter.c |   26 +++++++++++++-------------
>  1 files changed, 13 insertions(+), 13 deletions(-)
> 
> diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
> index 9f8ecca..a63f965 100644
> --- a/kernel/trace/trace_events_filter.c
> +++ b/kernel/trace/trace_events_filter.c
> @@ -229,6 +229,7 @@ static int is_string_field(const char *type)
>  int filter_add_pred(struct ftrace_event_call *call, struct filter_pred *pred)
>  {
>  	struct ftrace_event_field *field;
> +	unsigned long long val;
>  
>  	field = find_event_field(call, pred->field_name);
>  	if (!field)
> @@ -237,14 +238,14 @@ int filter_add_pred(struct ftrace_event_call *call, struct filter_pred *pred)
>  	pred->offset = field->offset;
>  
>  	if (is_string_field(field->type)) {
> -		if (!pred->str_val)
> -			return -EINVAL;
>  		pred->fn = filter_pred_string;
>  		pred->str_len = field->size;
>  		return __filter_add_pred(call, pred);
>  	} else {
> -		if (pred->str_val)
> +		if (strict_strtoull(pred->str_val, 0, &val))
>  			return -EINVAL;
> +		pred->val = val;
> +		kfree(pred->str_val);


And you might also want to do
pred->str_val = NULL;
Otherwise filter_free_pred() may crash later:

void filter_free_pred(struct filter_pred *pred)
{
	if (!pred)
		return;

	kfree(pred->field_name);
	kfree(pred->str_val);
	kfree(pred);
}


Other than that, it looks good.

Thanks,
Frederic.



>  	}
>  
>  	switch (field->size) {
> @@ -351,12 +352,16 @@ oom:
>  	return -ENOMEM;
>  }
>  
> +/*
> + * The filter format can be
> + *   - 0, which means remove all filter preds
> + *   - [||/&&] <field> ==/!= <val>
> + */
>  int filter_parse(char **pbuf, struct filter_pred *pred)
>  {
> -	char *tmp, *tok, *val_str = NULL;
> +	char *tok, *val_str = NULL;
>  	int tok_n = 0;
>  
> -	/* field ==/!= number, or/and field ==/!= number, number */
>  	while ((tok = strsep(pbuf, " \n"))) {
>  		if (tok_n == 0) {
>  			if (!strcmp(tok, "0")) {
> @@ -419,15 +424,10 @@ int filter_parse(char **pbuf, struct filter_pred *pred)
>  	if (!pred->field_name)
>  		return -ENOMEM;
>  
> -	pred->val = simple_strtoull(val_str, &tmp, 0);
> -	if (tmp == val_str) {
> -		pred->str_val = kstrdup(val_str, GFP_KERNEL);
> -		if (!pred->str_val)
> -			return -ENOMEM;
> -	} else if (*tmp != '\0')
> -		return -EINVAL;
> +	pred->str_val = kstrdup(val_str, GFP_KERNEL);
> +	if (!pred->str_val)
> +		return -ENOMEM;
>  
>  	return 0;
>  }
>  
> -
> -- 
> 1.5.4.rc3
> 

