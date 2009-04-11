Return-Path: <linux-kernel-owner+w=401wt.eu-S1756133AbZDKOfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133AbZDKOfs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 10:35:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754775AbZDKOfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 10:35:39 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:10606 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754672AbZDKOfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 10:35:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wRgU8BppLQhBELvL4jb0aRd7dvlYHVPTO5c+jUtUCRqW9FxTk5q9cqOi5sPJ4zCEPt
         rSKUWmz2IQd46FnJHr6YykdVo8dsgj8+r3FoOrABms7u+n38AfEtQvv3O4sG5JDo7eKb
         iSAUBIrkGWTuyv5CK2NvkkvJ2tV887QNrFNgk=
Date: Sat, 11 Apr 2009 16:35:34 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Tom Zanussi <tzanussi@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/7] tracing/filters: allow user to specify a filter
	val to be string
Message-ID: <20090411143533.GA5977@nowhere>
References: <49E04C22.4040608@cn.fujitsu.com> <49E04C61.10209@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E04C61.10209@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Li,

On Sat, Apr 11, 2009 at 03:53:05PM +0800, Li Zefan wrote:
> Suppose we would like to trace all tasks named '123', but this
> will fail:
>  # echo 'parent_comm == 123' > events/sched/sched_process_fork/filter
>  bash: echo: write error: Invalid argument
> 
> With this patch, we allow it by:
>  # echo 'parent_comm == \123' > events/sched/sched_process_fork/filter
>  # cat events/sched/sched_process_fork/filter
>  parent_comm == 123



Well, IMHO, it would be rather better to just echo 'parent_comm == 123'
and let it answer depending of which filter_pred_*() callback we have
for the concerned field.

The culprit is this part in filter_parse():

pred->val = simple_strtoull(val_str, &tmp, 10);
if (tmp == val_str) {
	pred->str_val = kstrdup(val_str, GFP_KERNEL);
	if (!pred->str_val)
		return -ENOMEM;
}

The idea would be to not anymore base the check on simple_strtoull to
guess whether this is a number or a string, making it act subsequently
to this assumption, which is not the good assumption we must base our
parsing yet.

Instead, we could let filter_parse only do the job of extracting the tokens
and then fill the whole pred struct without yet bothering about the type
of the value.

Thereafter we may defer the real value type checking on filter_add_pred()
depending on the type of the concerned field:

if (is_string_field()) {
	add it as a string value;
} else {
	do the check with simple_strtoull
	looks good? Then go to the number size switch....
	...
}

You see?

I think it would be a saner basis of parsing.

Thanks,
Frederic.


> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/trace/trace_events_filter.c |   11 ++++++++++-
>  1 files changed, 10 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
> index 49b3ef5..2bf4481 100644
> --- a/kernel/trace/trace_events_filter.c
> +++ b/kernel/trace/trace_events_filter.c
> @@ -351,12 +351,19 @@ oom:
>  	return -ENOMEM;
>  }
>  
> +/*
> + * The filter format can be
> + *   - 0, which means remove all filter preds
> + *   - [||/&&] <field> ==/!= [\]<val>
> + *
> + * Note: '\' prevent a string type value beginning with a digit to
> + *       be treated as a number
> + */
>  int filter_parse(char **pbuf, struct filter_pred *pred)
>  {
>  	char *tmp, *tok, *val_str = NULL;
>  	int tok_n = 0;
>  
> -	/* field ==/!= number, or/and field ==/!= number, number */
>  	while ((tok = strsep(pbuf, " \n"))) {
>  		if (tok_n == 0) {
>  			if (!strcmp(tok, "0")) {
> @@ -421,6 +428,8 @@ int filter_parse(char **pbuf, struct filter_pred *pred)
>  
>  	pred->val = simple_strtoull(val_str, &tmp, 0);
>  	if (tmp == val_str) {
> +		if (*val_str == '\\')
> +			val_str++;
>  		pred->str_val = kstrdup(val_str, GFP_KERNEL);
>  		if (!pred->str_val)
>  			return -ENOMEM;
> -- 
> 1.5.4.rc3
> 

