Return-Path: <linux-kernel-owner+w=401wt.eu-S1752977AbZIXQz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977AbZIXQz4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 12:55:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752231AbZIXQzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 12:55:55 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:47420 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041AbZIXQzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 12:55:54 -0400
Message-ID: <4ABBA45A.8010305@vflare.org>
Date: Thu, 24 Sep 2009 22:24:50 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Marcin Slusarz <marcin.slusarz@gmail.com>, Ed Tomlinson <edt@aei.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, linux-mm-cc <linux-mm-cc@laptop.org>
Subject: Re: [PATCH 2/3] virtual block device driver (ramzswap)
References: <1253595414-2855-1-git-send-email-ngupta@vflare.org>	<1253595414-2855-3-git-send-email-ngupta@vflare.org> <20090924141135.833474ad.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090924141135.833474ad.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 09/24/2009 10:41 AM, KAMEZAWA Hiroyuki wrote:
> On Tue, 22 Sep 2009 10:26:53 +0530
> Nitin Gupta <ngupta@vflare.org> wrote:
> 
> <snip>
>> +	if (unlikely(clen > max_zpage_size)) {
>> +		if (rzs->backing_swap) {
>> +			mutex_unlock(&rzs->lock);
>> +			fwd_write_request = 1;
>> +			goto out;
>> +		}
>> +
>> +		clen = PAGE_SIZE;
>> +		page_store = alloc_page(GFP_NOIO | __GFP_HIGHMEM);
> Here, and...
> 
>> +		if (unlikely(!page_store)) {
>> +			mutex_unlock(&rzs->lock);
>> +			pr_info("Error allocating memory for incompressible "
>> +				"page: %u\n", index);
>> +			stat_inc(rzs->stats.failed_writes);
>> +			goto out;
>> +		}
>> +
>> +		offset = 0;
>> +		rzs_set_flag(rzs, index, RZS_UNCOMPRESSED);
>> +		stat_inc(rzs->stats.pages_expand);
>> +		rzs->table[index].page = page_store;
>> +		src = kmap_atomic(page, KM_USER0);
>> +		goto memstore;
>> +	}
>> +
>> +	if (xv_malloc(rzs->mem_pool, clen + sizeof(*zheader),
>> +			&rzs->table[index].page, &offset,
>> +			GFP_NOIO | __GFP_HIGHMEM)) {
> 
> Here.
>     
> Do we need to wait until here for detecting page-allocation-failure ?
> Detecting it here means -EIO for end_swap_bio_write()....unhappy
> ALERT messages etc..
> 
> Can't we add a hook to get_swap_page() for preparing this ("do we have
> enough pool?") and use only GFP_ATOMIC throughout codes ?
> (memory pool for this swap should be big to some extent.)
>

Yes, we do need to wait until this step for detecting alloc failure since
we don't really know when pool grow will (almost) surely wail.
What we can probably do is, hook into OOM notify chain (oom_notify_list)
and whenever we get this callback, we can start sending pages directly
to backing swap and do not even attempt to do any allocation.


 
>>From my user support experience for heavy swap customers,  extra memory allocation for swapping out is just bad...in many cases.
> (*) I know GFP_IO works well to some extent.
> 

We cannot use GFP_IO here as it can cause a deadlock:
ramzswap alloc() --> not enough memory, try to reclaim some --> swap out ...
... some pages to ramzswap --> ramzswap alloc()

Thanks,
Nitin
