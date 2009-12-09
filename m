Return-Path: <linux-kernel-owner+w=401wt.eu-S1756342AbZLIRyF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756342AbZLIRyF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 12:54:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756316AbZLIRyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 12:54:05 -0500
Received: from casper.infradead.org ([85.118.1.10]:44381 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756222AbZLIRyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 12:54:04 -0500
Subject: Re: [PATCH] sched: Memory leak in two error corner cases
From: Peter Zijlstra <peterz@infradead.org>
To: Phil Carmody <ext-phil.2.carmody@nokia.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <1260380746-4856-1-git-send-email-ext-phil.2.carmody@nokia.com>
References: <1260380746-4856-1-git-send-email-ext-phil.2.carmody@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Dec 2009 18:54:04 +0100
Message-ID: <1260381244.5489.1065.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-09 at 19:45 +0200, Phil Carmody wrote:
> From: Phil Carmody <ext-phil.2.carmody@nokia.com>
> 
> If the second in each of these pairs of allocations fails, then
> the first one will not be freed in the error route out.
> 
> Found by a static code analysis tool.

nice find.

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

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


