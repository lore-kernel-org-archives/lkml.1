Return-Path: <linux-kernel-owner+w=401wt.eu-S1755049AbYHYSsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049AbYHYSsg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 14:48:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751144AbYHYSs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 14:48:27 -0400
Received: from relay2.sgi.com ([192.48.171.30]:41219 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750769AbYHYSs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 14:48:27 -0400
Message-ID: <48B2FE79.8060709@sgi.com>
Date: Mon, 25 Aug 2008 11:48:25 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, cl@linux-foundation.org,
       tokunaga.keiich@jp.fujitsu.com
Subject: Re: [RFC][PATCH 2/2] quicklist shouldn't be proportional to # of
 CPUs
References: <20080821002757.b7c807ad.akpm@linux-foundation.org> <1219311154.8651.96.camel@twins> <20080821183648.22AF.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20080821183648.22AF.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> Hi Peter,
> 
> Thank you good point out!
> 
>>> @@ -41,8 +41,8 @@ static unsigned long max_pages(unsigned 
>>>  
>>>  	max = node_free_pages / FRACTION_OF_NODE_MEM;
>>>  
>>> -	num_cpus_per_node = cpus_weight_nr(node_to_cpumask(node));
>>> -	max /= num_cpus_per_node;
>>> +	node_cpumask = node_to_cpumask(node);
>>> +	max /= cpus_weight_nr(node_cpumask);
>>>  
>>>  	return max(max, min_pages);
>>>  }
>> humm, I thought we wanted to keep cpumask_t stuff away from our stack -
>> since on insanely large SGI boxen (/me looks at mike) the thing becomes
>> 512 bytes.
> 
> Hm, interesting.
> I think following patch fill your point, right?
> 
> but I worry about it works on sparc64...
> 
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> 
> ---
>  mm/quicklist.c |    9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> Index: b/mm/quicklist.c
> ===================================================================
> --- a/mm/quicklist.c
> +++ b/mm/quicklist.c
> @@ -26,7 +26,10 @@ DEFINE_PER_CPU(struct quicklist, quickli
>  static unsigned long max_pages(unsigned long min_pages)
>  {
>  	unsigned long node_free_pages, max;
> -	struct zone *zones = NODE_DATA(numa_node_id())->node_zones;
> +	int node = numa_node_id();
> +	struct zone *zones = NODE_DATA(node)->node_zones;
> +	int num_cpus_on_node;
> +	node_to_cpumask_ptr(cpumask_on_node, node);
>  
>  	node_free_pages =
>  #ifdef CONFIG_ZONE_DMA
> @@ -38,6 +41,10 @@ static unsigned long max_pages(unsigned 
>  		zone_page_state(&zones[ZONE_NORMAL], NR_FREE_PAGES);
>  
>  	max = node_free_pages / FRACTION_OF_NODE_MEM;
> +
> +	num_cpus_on_node = cpus_weight_nr(*cpumask_on_node);
> +	max /= num_cpus_on_node;
> +
>  	return max(max, min_pages);
>  }
>  
> 

Exactly!  And (many thanks to them!) the sparc maintainers have
implemented a similar internal function definition for node_to_cpumask_ptr().

Mike
