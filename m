Return-Path: <linux-kernel-owner+w=401wt.eu-S1757389AbZCYOh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389AbZCYOh3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 10:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751966AbZCYOhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 10:37:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49322 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351AbZCYOhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 10:37:17 -0400
Subject: Re: [PATCH 1/2] trace_stat: keep original order
From: Steven Rostedt <srostedt@redhat.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <49C9F23F.5040307@cn.fujitsu.com>
References: <49C9F23F.5040307@cn.fujitsu.com>
Content-Type: text/plain
Organization: Red Hat
Date: Wed, 25 Mar 2009 10:36:38 -0400
Message-Id: <1237991798.22033.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2009-03-25 at 16:58 +0800, Lai Jiangshan wrote:
> Impact: make trace_stat files show items with the original order
> 
> trace_stat tracer reverse the items, it makes the output
> looks a little ugly.
> 
> Example, when we read trace_stat/workqueues, we get cpu#7's stat.
> at first, and then cpu#6... cpu#0.
> 

This doesn't reverse the order of the annotated branch profiler, does
it?

-- Steve

> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/kernel/trace/trace_stat.c b/kernel/trace/trace_stat.c
> index f71b85b..c08e7f1 100644
> --- a/kernel/trace/trace_stat.c
> +++ b/kernel/trace/trace_stat.c
> @@ -125,23 +125,21 @@ static int stat_seq_init(struct tracer_stat_session *session)
>  		INIT_LIST_HEAD(&new_entry->list);
>  		new_entry->stat = stat;
>  
> -		list_for_each_entry(iter_entry, &session->stat_list, list) {
> +		list_for_each_entry_reverse(iter_entry, &session->stat_list,
> +				list) {
>  
>  			/* Insertion with a descendent sorting */
> -			if (ts->stat_cmp(new_entry->stat,
> -						iter_entry->stat) > 0) {
> +			if (ts->stat_cmp(iter_entry->stat,
> +					new_entry->stat) >= 0) {
>  
> -				list_add_tail(&new_entry->list,
> -						&iter_entry->list);
> -				break;
> -
> -			/* The current smaller value */
> -			} else if (list_is_last(&iter_entry->list,
> -						&session->stat_list)) {
>  				list_add(&new_entry->list, &iter_entry->list);
>  				break;
>  			}
>  		}
> +
> +		/* The current larger value */
> +		if (list_empty(&new_entry->list))
> +			list_add(&new_entry->list, &session->stat_list);
>  	}
>  exit:
>  	mutex_unlock(&session->stat_mutex);
> 
> 

