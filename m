Return-Path: <linux-kernel-owner+w=401wt.eu-S964821AbXEEHh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964821AbXEEHh7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 03:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754646AbXEEHh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 03:37:59 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:36159 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754488AbXEEHh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 03:37:58 -0400
Message-ID: <463C3448.3040506@cosmosbay.com>
Date: Sat, 05 May 2007 09:37:44 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, dgc@sgi.com, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [RFC 0/3] Slab Defrag / Slab Targeted Reclaim and general Slab
 API changes
References: <20070504221555.642061626@sgi.com> <463C10F8.4040803@cosmosbay.com> <Pine.LNX.4.64.0705042209050.14211@schroedinger.engr.sgi.com> <463C1900.7060409@cosmosbay.com>
In-Reply-To: <463C1900.7060409@cosmosbay.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Sat, 05 May 2007 09:37:51 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet a écrit :
> Christoph Lameter a écrit :
> 
>>
>>> G. Being able to track the number of pages in a kmem_cache
>>>
>>>
>>> If you look at fs/buffer.c, you'll notice the bh_accounting, 
>>> recalc_bh_state()
>>> that might be overkill for large SMP configurations, when the real 
>>> concern is
>>> to be able to limit the bh's not to exceed 10% of LOWMEM.
>>>
>>> Adding a callback in slab_ops to track total number of pages in use 
>>> by a given
>>> kmem_cache would be good.
>>
>> Such functionality exists internal to SLUB and in the reporting tool. 
>> I can export that function if you need it.
>>
>>> Same thing for fs/file_table.c : nr_file logic
>>> (percpu_counter_dec()/percpu_counter_inc() for each file open/close) 
>>> could be
>>> simplified if we could just count the pages in use by filp_cachep 
>>> kmem_cache.
>>> The get_nr_files() thing is not worth the pain.
>>
>> Sure. What exactly do you want? The absolute number of pages of memory 
>> that the slab is using?
>>
>>     kmem_cache_pages_in_use(struct kmem_cache *) ?
>>
>> The call will not be too lightweight since we will have to loop over 
>> all nodes and add the counters in each per node struct for allocates 
>> slabs.
>>
>>
> 
> On a typical system, number of pages for 'filp' kmem_cache tends to be 
> stable
> 
> -bash-2.05b# grep filp /proc/slabinfo
> filp              234727 374100    256   15    1 : tunables  120   60    
> 8 : slabdata  24940  24940    135
> -bash-2.05b# grep filp /proc/slabinfo
> filp              234776 374100    256   15    1 : tunables  120   60    
> 8 : slabdata  24940  24940    168
> -bash-2.05b# grep filp /proc/slabinfo
> filp              234728 374100    256   15    1 : tunables  120   60    
> 8 : slabdata  24940  24940    180
> -bash-2.05b# grep filp /proc/slabinfo
> filp              234724 374100    256   15    1 : tunables  120   60    
> 8 : slabdata  24940  24940    174
> 
> So revert nr_files logic to a single integer would be enough, even for NUMA
> 
> int nr_pages_used_by_filp;
> int nr_pages_filp_limit;
> int filp_in_danger __read_mostly;
> 
> static void callback_pages_in_use_by_filp(int inc)
> {
>     int in_danger;
> 
>     nr_pages_used_by_filp += inc;
> 
>     in_danger = nr_pages_used_by_filp >= nr_pages_filp_limit;
>     if (in_danger != filp_in_danger)
>         filp_in_danger = in_danger;
> }
> 
> struct file *get_empty_filp(void)
> {
> ...
> if (filp_in_danger && !capable(CAP_SYS_ADMIN))
>     goto over;
> 
> ...
> }
> 
> 
> void __init files_init(unsigned long mempages)
> {
> ...
> nr_pages_filp_limit = (mempages * 10) / 100; /* 10% for filp use */
> ...
> }


This wont work of course : Once the pages limit is hit, file allocations would 
be forbidden until cache is shrinked.

Maybe callback should return a status, so that SLAB / SLUB can return ENOMEM

static int callback_pages_in_use_by_filp(int inc)
{
     int in_danger;

     nr_pages_used_by_filp += inc;

     in_danger = nr_pages_used_by_filp >= nr_pages_filp_limit;
     if (unlikely(in_danger != filp_in_danger))
         filp_in_danger = in_danger;
     if (unlikely(in_danger && inc > 0 && !capable(CAP_SYS_ADMIN))) {
         nr_pages_used_by_filp -= inc;
         return -1;
     }
     return 0;
}

No more tests in get_empty_filp() : just call kmem_cache_alloc()

struct file *get_empty_filp(void)
{
...
f = kmem_cache_alloc(filp_cachep, GFP_KERNEL);
...
}

