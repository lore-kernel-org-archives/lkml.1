Return-Path: <linux-kernel-owner+w=401wt.eu-S1752358AbZHaL7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358AbZHaL7X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 07:59:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752334AbZHaL7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 07:59:21 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56418 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbZHaL7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 07:59:19 -0400
Message-ID: <119e8331d1210b1f56d0f6416863bfbc.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <20090831110204.GG4770@balbir.in.ibm.com>
References: <20090828132015.10a42e40.kamezawa.hiroyu@jp.fujitsu.com>
    <20090828132438.b33828bc.kamezawa.hiroyu@jp.fujitsu.com>
    <20090831110204.GG4770@balbir.in.ibm.com>
Date: Mon, 31 Aug 2009 20:59:18 +0900 (JST)
Subject: Re: [RFC][PATCH 2/5] memcg: uncharge in batched manner
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
User-Agent: SquirrelMail/1.4.16
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-08-28
> 13:24:38]:

>> +	}
>> +	if (!batch || batch->memcg != mem) {
>> +		res_counter_uncharge(&mem->res, PAGE_SIZE);
>> +		if (uncharge_memsw)
>> +			res_counter_uncharge(&mem->memsw, PAGE_SIZE);
>
> Could you please add a comment stating that if memcg is different that
> we do a direct uncharge else we batch.
>
really necessary ?. ok. I'll do.

>> +	} else {
>> +		batch->pages += PAGE_SIZE;
>> +		if (uncharge_memsw)
>> +			batch->memsw += PAGE_SIZE;
>> +	}
>> +	return soft_limit_excess;
>> +}
>>  /*
>>   * uncharge if !page_mapped(page)
>>   */
>> @@ -1886,12 +1914,8 @@ __mem_cgroup_uncharge_common(struct page
>>  		break;
>>  	}
>>
>> -	if (!mem_cgroup_is_root(mem)) {
>> -		res_counter_uncharge(&mem->res, PAGE_SIZE);
>> -		if (do_swap_account &&
>> -				(ctype != MEM_CGROUP_CHARGE_TYPE_SWAPOUT))
>> -			res_counter_uncharge(&mem->memsw, PAGE_SIZE);
>> -	}
>> +	if (!mem_cgroup_is_root(mem))
>> +		__do_batch_uncharge(mem, ctype);
>
> Now I am beginning to think we need a cond_mem_cgroup_is_not_root()
> function.
>
I can't catch waht cond_mem_cgroup_is_not_root() means.


>>  	if (ctype == MEM_CGROUP_CHARGE_TYPE_SWAPOUT)
>>  		mem_cgroup_swap_statistics(mem, true);
>>  	mem_cgroup_charge_statistics(mem, pc, false);
>> @@ -1938,6 +1962,40 @@ void mem_cgroup_uncharge_cache_page(stru
>>  	__mem_cgroup_uncharge_common(page, MEM_CGROUP_CHARGE_TYPE_CACHE);
>>  }
>>
>> +void mem_cgroup_uncharge_batch_start(void)
>> +{
>> +	VM_BUG_ON(current->memcg_batch.do_batch);
>> +	/* avoid batch if killed by OOM */
>> +	if (test_thread_flag(TIF_MEMDIE))
>> +		return;
>> +	current->memcg_batch.do_batch = 1;
>> +	current->memcg_batch.memcg = NULL;
>> +	current->memcg_batch.pages = 0;
>> +	current->memcg_batch.memsw = 0;
>> +}
>> +
>> +void mem_cgroup_uncharge_batch_end(void)
>> +{
>> +	struct mem_cgroup *mem;
>> +
>> +	if (!current->memcg_batch.do_batch)
>> +		return;
>> +
>> +	current->memcg_batch.do_batch = 0;
>> +
>> +	mem = current->memcg_batch.memcg;
>> +	if (!mem)
>> +		return;
>> +	if (current->memcg_batch.pages)
>> +		res_counter_uncharge(&mem->res,
>> +				     current->memcg_batch.pages, NULL);
>> +	if (current->memcg_batch.memsw)
>> +		res_counter_uncharge(&mem->memsw,
>> +				     current->memcg_batch.memsw, NULL);
>> +	/* we got css's refcnt */
>> +	cgroup_release_and_wakeup_rmdir(&mem->css);
>
>
> Does this effect deleting of a group and delay it by a large amount?
>
plz see what cgroup_release_and_xxxx  fixed. This is not for delay
but for race-condition, which makes rmdir sleep permanently.

Thanks,
-Kame

