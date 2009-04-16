Return-Path: <linux-kernel-owner+w=401wt.eu-S1752990AbZDPIcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990AbZDPIcw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 04:32:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752039AbZDPIcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 04:32:43 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49424 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751931AbZDPIcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 04:32:42 -0400
Message-ID: <49E6ED5A.6080003@cn.fujitsu.com>
Date: Thu, 16 Apr 2009 16:33:30 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Tom Zanussi <tzanussi@gmail.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH] tracing/filters: add filter_mutex to protect filter predicates
References: <1239863904.6903.12.camel@tropicana>
In-Reply-To: <1239863904.6903.12.camel@tropicana>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tom Zanussi wrote:
> This patch adds a filter_mutex to prevent the filter predicates from
> being accessed concurrently by various external functions.
> 
> It's based on a previous patch by Li Zefan:
>         "[PATCH 7/7] tracing/filters: make filter preds RCU safe"
> 
> but any problems with it were added by me. ;-)
> 
> Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
> 

Reviewed-and-tested-by: Li Zefan <lizf@cn.fujitsu.com>

except:

> @@ -348,17 +399,15 @@ int filter_add_subsystem_pred(struct event_subsystem *system,
>  		if (strcmp(call->system, system->name))
>  			continue;
>  
> -		if (!find_event_field(call, pred->field_name))
> -			continue;
> -
> -		err = filter_add_pred(call, pred);
> +		err = __filter_add_pred(call, pred);
>  		if (err == -ENOMEM) {
>  			system->preds[system->n_preds] = NULL;
> -			return err;
> +			system->n_preds--;
> +			break;

now we return 0 but not ENOMEM in this failure case.

>  		}
>  	}
>  
> -	system->n_preds++;
> +	mutex_unlock(&filter_mutex);
>  
>  	return 0;
>  }

