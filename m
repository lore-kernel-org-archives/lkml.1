Return-Path: <linux-kernel-owner+w=401wt.eu-S933786AbXHVU5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933786AbXHVU5y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 16:57:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763803AbXHVU5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 16:57:41 -0400
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:37339 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762371AbXHVU5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 16:57:40 -0400
Message-ID: <46CCA33E.5060905@linux.vnet.ibm.com>
Date: Thu, 23 Aug 2007 02:27:34 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Pavel Emelyanov <xemul@openvz.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Alexey Dobriyan <adobriyan@openvz.org>
Subject: Re: [BUG] 2.6.23-rc3-mm1 Kernel panic - not syncing: Can't create
 pid_1 cachep
References: <46CC3F94.4050609@linux.vnet.ibm.com> <46CC4AD2.2080306@openvz.org>
In-Reply-To: <46CC4AD2.2080306@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Emelyanov wrote:
> Kamalesh Babulal wrote:
>
> The creation of this cache consists of allocating ~30
> bytes and creating a new kmem cache. This looks strange
> that one of these allocation falied...
>
> Could you please check what has happened with this patch:
>
> diff --git a/kernel/pid.c b/kernel/pid.c
> index d267775..9d594eb 100644
> --- a/kernel/pid.c
> +++ b/kernel/pid.c
> @@ -458,15 +458,22 @@ static struct kmem_cache *create_pid_cac
>             goto out;
>
>     pcache = kmalloc(sizeof(struct pid_cache), GFP_KERNEL);
> -    if (pcache == NULL)
> +    if (pcache == NULL) {
> +        printk("Can't alloc pcache size %d\n",
> +                sizeof(struct pid_cache));
>         goto err_alloc;
> +    }
>
>     snprintf(pcache->name, sizeof(pcache->name), "pid_%d", nr_ids);
>     cachep = kmem_cache_create(pcache->name,
>             sizeof(struct pid) + (nr_ids - 1) * sizeof(struct upid),
>             0, SLAB_HWCACHE_ALIGN, NULL);
> -    if (cachep == NULL)
> +    if (cachep == NULL) {
> +        printk("Can't create cachep size %d\n",
> +                sizeof(struct pid) +
> +                (nr_ids - 1) * sizeof(struct upid));
>         goto err_cachep;
> +    }
>
>     pcache->nr_ids = nr_ids;
>     pcache->cachep = cachep;
>
>
>
>> Hi Andrew,
>>
>> Following Kernel panic is raised while booting up with 2.6.23-rc3-mm1 
>> kernel.
>>
>> ============================================================
>> Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
>> Initializing HighMem for node 0 (00038000:001fbe00)
>> Initializing HighMem for node 1 (00200000:003fbe00)
>> Initializing HighMem for node 2 (00400000:005fbe00)
>> Initializing HighMem for node 3 (00600000:007fbe00)
>> Memory: 32480436k/33554432k available (2146k kernel code, 278984k 
>> reserved, 1203k data, 216k init, 31842304k highmem)
>> virtual kernel memory layout:
>>    fixmap  : 0xffe1a000 - 0xfffff000   (1940 kB)
>>    pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
>>    vmalloc : 0xf8800000 - 0xffbfe000   ( 115 MB)
>>    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
>>      .init : 0xc134c000 - 0xc1382000   ( 216 kB)
>>      .data : 0xc12189e1 - 0xc1345758   (1203 kB)
>>      .text : 0xc1000000 - 0xc12189e1   (2146 kB)
>> Checking if this processor honours the WP bit even in supervisor 
>> mode... Ok.
>> SLUB: Genslabs=12, HWalign=32, Order=0-3, MinObjects=16, CPUs=16, 
>> Nodes=16
>> Calibrating delay using timer specific routine.. 1401.55 BogoMIPS 
>> (lpj=2803105)
>> Kernel panic - not syncing: Can't create pid_1 cachep
>>
>>
>> Thanks & Regards,
>> Kamalesh Babulal.
>> -
>> To unsubscribe from this list: send the line "unsubscribe 
>> linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
after applying the patch, kernel panic looks like this
===============================================================================
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Initializing HighMem for node 0 (00038000:001fbe00)
Initializing HighMem for node 1 (00200000:003fbe00)
Initializing HighMem for node 2 (00400000:005fbe00)
Initializing HighMem for node 3 (00600000:007fbe00)
Memory: 32479372k/33554432k available (2635k kernel code, 280048k 
reserved, 1282k data, 216k init, 31842304k highmem)
virtual kernel memory layout:
    fixmap  : 0xffe1a000 - 0xfffff000   (1940 kB)
    pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
    vmalloc : 0xf8800000 - 0xffbfe000   ( 115 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc13da000 - 0xc1410000   ( 216 kB)
      .data : 0xc1292f51 - 0xc13d3758   (1282 kB)
      .text : 0xc1000000 - 0xc1292f51   (2635 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
SLUB: Genslabs=12, HWalign=32, Order=0-3, MinObjects=16, CPUs=16, Nodes=16
Calibrating delay using timer specific routine.. 1401.55 BogoMIPS 
(lpj=2803109)
Can't alloc pcache size 32
Kernel panic - not syncing: Can't create pid_1 cachep


