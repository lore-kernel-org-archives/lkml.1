Return-Path: <linux-kernel-owner+w=401wt.eu-S1757112AbZLJCiM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757112AbZLJCiM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 21:38:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754070AbZLJCiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 21:38:08 -0500
Received: from mail-yw0-f198.google.com ([209.85.211.198]:55489 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815AbZLJCiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 21:38:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=uJ7FpnCInBR/WNDHNK6LpMhpSNf8Ld5n/eiQMqSr7/bno1iBmhIg2smfvbLOeOi1Fs
         wfDufW7gNMRB/cO3wlD+LcJQaY0/DfPLhHwCfaKWcrVI7UN3CxkV03m+fWbFzWcbYOiE
         9Ew0HMVxHxEVI8gPrXm8KdK2SGNUW+O93j/tU=
Message-ID: <4B205F73.90704@gmail.com>
Date: Thu, 10 Dec 2009 10:39:47 +0800
From: "Helight.Xu" <helight.xu@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20091109)
MIME-Version: 1.0
To: Phil Carmody <ext-phil.2.carmody@nokia.com>
CC: mingo@elte.hu, peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: Memory leak in two error corner cases
References: <1260380746-4856-1-git-send-email-ext-phil.2.carmody@nokia.com>
In-Reply-To: <1260380746-4856-1-git-send-email-ext-phil.2.carmody@nokia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Phil Carmody wrote:
> From: Phil Carmody <ext-phil.2.carmody@nokia.com>
>
> If the second in each of these pairs of allocations fails, then
> the first one will not be freed in the error route out.
>
> Found by a static code analysis tool.
>
> Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
> ---
>  kernel/sched.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/sched.c b/kernel/sched.c
> index e7f2cfa..29ebc4a 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -9841,8 +9841,10 @@ int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent)
>  
>  		se = kzalloc_node(sizeof(struct sched_entity),
>  				  GFP_KERNEL, cpu_to_node(i));
> -		if (!se)
> +		if (!se) {
> +			kfree(cfs_rq);
>  			goto err;
> +		}
>   
if here has menory leak, why not  here!

    tg->cfs_rq = kzalloc(sizeof(cfs_rq) * nr_cpu_ids, GFP_KERNEL);
    if (!tg->cfs_rq)
         goto err;
    tg->se = kzalloc(sizeof(se) * nr_cpu_ids, GFP_KERNEL);
    if (!tg->se)
         goto err;
should I fix here?
>  
>  		init_tg_cfs_entry(tg, cfs_rq, se, i, 0, parent->se[i]);
>  	}
> @@ -9929,8 +9931,10 @@ int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
>  
>  		rt_se = kzalloc_node(sizeof(struct sched_rt_entity),
>  				     GFP_KERNEL, cpu_to_node(i));
> -		if (!rt_se)
> +		if (!rt_se) {
> +			kfree(rt_rq);
>  			goto err;
> +		}
>  
>  		init_tg_rt_entry(tg, rt_rq, rt_se, i, 0, parent->rt_se[i]);
>  	}
>   


-- 
---------------------------------
Zhenwen Xu - Open and Free
Home Page:	http://zhwen.org

