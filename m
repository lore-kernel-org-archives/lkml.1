Return-Path: <linux-kernel-owner+w=401wt.eu-S1161133AbXCVWM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161133AbXCVWM6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 18:12:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161141AbXCVWM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 18:12:57 -0400
Received: from www.cosmosbay.com ([86.65.150.131]:52523 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161133AbXCVWM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 18:12:57 -0400
Message-ID: <4602FF57.7030001@cosmosbay.com>
Date: Thu, 22 Mar 2007 23:12:39 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
CC: Christoph Lameter <christoph@lameter.com>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: non-NUMA cache_free_alien() (was Re: [RFC] SLAB : NUMA cache_free_alien()
 very expensive because of virt_to_slab(objp); nodeid = slabp->nodeid;)
References: <20070320181235.77d28864.dada1@cosmosbay.com> <Pine.LNX.4.64.0703201248530.12664@graphe.net> <20070320213218.GA13952@one.firstfloor.org> <Pine.LNX.4.64.0703201716440.17799@graphe.net> <20070321024452.GA17532@one.firstfloor.org> <Pine.LNX.4.64.0703202006230.20568@graphe.net> <20070322212831.GA25665@linux-os.sc.intel.com>
In-Reply-To: <20070322212831.GA25665@linux-os.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Thu, 22 Mar 2007 23:12:44 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Siddha, Suresh B a écrit :
> Christoph,
> 
> While we are at this topic, recently I had reports that
> cache_free_alien() is costly on non NUMA platforms too (similar
> to the cache miss issues that Eric was referring to on NUMA)
> and the appended patch seems to fix it for non NUMA atleast.
> 
> Appended patch gives a nice 1% perf improvement on non-NUMA platform
> with database workload.
> 
> Please comment or Ack for mainline :)

I have one comment :)

> @@ -1394,6 +1394,9 @@ void __init kmem_cache_init(void)
>  	int order;
>  	int node;
>  
> +	if (num_online_nodes() == 1)
> +		use_alien_caches = 0;
> +

Unfortunatly this part is wrong.

You should check num_possible_nodes(), or nr_node_ids (this one is cheaper, 
its a variable instead of a function call)

I wonder if we could add a new SLAB_NUMA_BYPASS, so that we can declare some 
kmem_cache as non NUMA aware (for example, I feel network skb dont need the 
NUMA overhead)


