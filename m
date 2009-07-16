Return-Path: <linux-kernel-owner+w=401wt.eu-S1756906AbZGPBM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906AbZGPBM1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 21:12:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756868AbZGPBM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 21:12:26 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38083 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756867AbZGPBM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 21:12:26 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 2/3] profile: Suppress warning about large allocations when profile=1 is specified
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linux Memory Management List <linux-mm@kvack.org>,
       Heinz Diehl <htd@fancy-poultry.org>, David Miller <davem@davemloft.net>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <1247656992-19846-3-git-send-email-mel@csn.ul.ie>
References: <1247656992-19846-1-git-send-email-mel@csn.ul.ie> <1247656992-19846-3-git-send-email-mel@csn.ul.ie>
Message-Id: <20090716100305.9D16.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 16 Jul 2009 10:12:20 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> When profile= is used, a large buffer is allocated early at boot. This
> can be larger than what the page allocator can provide so it prints a
> warning. However, the caller is able to handle the situation so this patch
> suppresses the warning.

I'm confused.

Currently caller doesn't handle error return.

----------------------------------------------------------
asmlinkage void __init start_kernel(void)
{
(snip)
        init_timers();
        hrtimers_init();
        softirq_init();
        timekeeping_init();
        time_init();
        sched_clock_init();
        profile_init();           <-- ignore return value
------------------------------------------------------------

and, if user want to use linus profiler, the user should choice select
proper bucket size by boot parameter.
Currently, allocation failure message tell user about specified bucket size
is wrong.
I think this patch hide it.


> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> ---
>  kernel/profile.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/profile.c b/kernel/profile.c
> index 69911b5..419250e 100644
> --- a/kernel/profile.c
> +++ b/kernel/profile.c
> @@ -117,11 +117,12 @@ int __ref profile_init(void)
>  
>  	cpumask_copy(prof_cpu_mask, cpu_possible_mask);
>  
> -	prof_buffer = kzalloc(buffer_bytes, GFP_KERNEL);
> +	prof_buffer = kzalloc(buffer_bytes, GFP_KERNEL|__GFP_NOWARN);
>  	if (prof_buffer)
>  		return 0;
>  
> -	prof_buffer = alloc_pages_exact(buffer_bytes, GFP_KERNEL|__GFP_ZERO);
> +	prof_buffer = alloc_pages_exact(buffer_bytes,
> +					GFP_KERNEL|__GFP_ZERO|__GFP_NOWARN);
>  	if (prof_buffer)
>  		return 0;



