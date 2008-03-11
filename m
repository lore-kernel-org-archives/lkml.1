Return-Path: <linux-kernel-owner+w=401wt.eu-S1754568AbYCKTGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568AbYCKTGv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 15:06:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752699AbYCKTGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 15:06:40 -0400
Received: from sp604003av.neufgp.fr ([84.96.92.124]:43565 "EHLO
	neuf-infra-smtp-out-sp604003av.neufgp.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751617AbYCKTGj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 15:06:39 -0400
Message-ID: <47D6D24D.2080007@cosmosbay.com>
Date: Tue, 11 Mar 2008 19:41:17 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Mike Snitzer <snitzer@gmail.com>
CC: "David S. Miller" <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       Christoph Lameter <clameter@sgi.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, stable@kernel.org
Subject: Re: [PATCH] alloc_percpu() fails to allocate percpu data
References: <47BDBC23.10605@cosmosbay.com> <170fa0d20803111115n3e8eb438s9b1ad7fff2fb8672@mail.gmail.com>
In-Reply-To: <170fa0d20803111115n3e8eb438s9b1ad7fff2fb8672@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Snitzer a écrit :
> On 2/21/08, Eric Dumazet <dada1@cosmosbay.com> wrote:
>   
>> Some oprofile results obtained while using tbench on a 2x2 cpu machine
>>  were very surprising.
>>
>>  For example, loopback_xmit() function was using high number of cpu
>>  cycles to perform
>>  the statistic updates, supposed to be real cheap since they use percpu data
>>
>>         pcpu_lstats = netdev_priv(dev);
>>         lb_stats = per_cpu_ptr(pcpu_lstats, smp_processor_id());
>>         lb_stats->packets++;  /* HERE : serious contention */
>>         lb_stats->bytes += skb->len;
>>
>>
>>  struct pcpu_lstats is a small structure containing two longs. It appears
>>  that on my 32bits platform,
>>  alloc_percpu(8) allocates a single cache line,  instead of giving to
>>  each cpu a separate
>>  cache line.
>>
>>  Using the following patch gave me impressive boost in various benchmarks
>>  ( 6 % in tbench)
>>  (all percpu_counters hit this bug too)
>>
>>  Long term fix (ie >= 2.6.26) would be to let each CPU allocate their own
>>  block of memory, so that we
>>  dont need to roudup sizes to L1_CACHE_BYTES, or merging the SGI stuffof
>>  course...
>>
>>  Note : SLUB vs SLAB is important here to *show* the improvement, since
>>  they dont have the same minimum
>>  allocation sizes (8 bytes vs 32 bytes).
>>  This could very well explain regressions some guys reported when they
>>  switched to SLUB.
>>     
>
>
> I see that this fix was committed to mainline as commit
> be852795e1c8d3829ddf3cb1ce806113611fa555
>
> The commit didn't "Cc: <stable@kernel.org>", and it doesn't appear to
> be queued for 2.6.24.x.  Should it be?
>
>   
Yes, it should be queued fo 2.6.24.x

> If I understand you correctly, SLAB doesn't create this particular
> cache thrashing on 32bit systems?  Is SLAB ok on other architectures
> too?  Can you (or others) comment on the importance of this fix
> relative to x86_64 (64byte cacheline) and SLAB?
>
>   

Fix is important both for 32 and 64 bits kernels, SLAB or SLUB.

SLAB does have this problem, but less prevalent than SLUB, because these
allocators dont have the same minimal size allocation (32 vs 8)

So with SLUB, it is possible that 8 CPUS share the same 64 bytes
cacheline to store their percpu counters, while only 2 cpus can share
this same cache line with SLAB allocator.

> I'm particularly interested in this given the use of percpu_counters
> with the per bdi write throttling.
>
> Mike
> --
>   



