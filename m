Return-Path: <linux-kernel-owner+w=401wt.eu-S1753793AbZHaRlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793AbZHaRlL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 13:41:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752278AbZHaRlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 13:41:11 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:37669 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbZHaRlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 13:41:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sBThIrKhw4YmIshQ/SkOw+E0C6E1+WSuUQHeEpyEP8XubBItz9KDZWBsInvaum1iWP
         sH1SEmz4P+WAtn7hEJFshqqKEeG1yJNekA74F7hB1mQosEc78o0aJBpa7K9fY5Sm3iHd
         cpK2df6QVrvB7lf8Y4hFI+6hMwwh7XShYT0jw=
Date: Mon, 31 Aug 2009 19:41:08 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/filters: Defer pred allocation
Message-ID: <20090831174107.GB6048@nowhere>
References: <4A9B8EA5.6020700@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A9B8EA5.6020700@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 31, 2009 at 04:49:41PM +0800, Li Zefan wrote:
> @@ -1094,6 +1118,10 @@ int apply_event_filter(struct ftrace_event_call *call, char *filter_string)
>  
>  	mutex_lock(&event_mutex);
>  
> +	err = init_preds(call);
> +	if (err)
> +		goto out_unlock;



Hmm, but what happens if the filter already has its preds initialized
by a previous filter?

The first thing that init_preds() does is:

filter = call->filter = kzalloc(sizeof(*filter), GFP_KERNEL);

That looks like a memory leak.


>  	if (!strcmp(strstrip(filter_string), "0")) {
>  		filter_disable_preds(call);
>  		remove_filter_string(call->filter);
> @@ -1139,6 +1167,10 @@ int apply_subsystem_event_filter(struct event_subsystem *system,
>  
>  	mutex_lock(&event_mutex);
>  
> +	err = init_subsystem_preds(system);


Whereas this one has a check:
	if (!call->filter)
		alloc...



> +	if (err)
> +		goto out_unlock;
> +
>  	if (!strcmp(strstrip(filter_string), "0")) {
>  		filter_free_subsystem_preds(system, FILTER_DISABLE_ALL);
>  		remove_filter_string(system->filter);
> diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
> index 029a91f..df1bf6e 100644
> --- a/kernel/trace/trace_export.c
> +++ b/kernel/trace/trace_export.c
> @@ -135,7 +135,6 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
>  static int ftrace_raw_init_event_##call(void)				\
>  {									\
>  	INIT_LIST_HEAD(&event_##call.fields);				\
> -	init_preds(&event_##call);					\
>  	return 0;							\
>  }									\
>  
> -- 
> 1.6.3
> 


Other than the above doubts, that looks good.

