Return-Path: <linux-kernel-owner+w=401wt.eu-S1760845AbZCYNar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760845AbZCYNar (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 09:30:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756157AbZCYNai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 09:30:38 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:47481 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396AbZCYNah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 09:30:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kdoXaRd65bHQCRINRIbh++ZTUXBEsWfibvCPME9+Pbp9x2w1ubmQcCRdlobawAoAev
         94jPL8TZ1qM5qFOFMEx5vO0hvMCMEf81HJ4QezNvO5tsKUwhJ9Li1YMNbhFSye3Mo4zL
         sttb4Ro24OZtYQbtY5T3dIWwDQeHIuTmI/kao=
Date: Wed, 25 Mar 2009 14:30:29 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <srostedt@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] trace_stat: keep original order
Message-ID: <20090325133028.GE5976@nowhere>
References: <49C9F23F.5040307@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C9F23F.5040307@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25, 2009 at 04:58:39PM +0800, Lai Jiangshan wrote:
> 
> Impact: make trace_stat files show items with the original order
> 
> trace_stat tracer reverse the items, it makes the output
> looks a little ugly.
> 
> Example, when we read trace_stat/workqueues, we get cpu#7's stat.
> at first, and then cpu#6... cpu#0.
> 
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


Nice!

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

