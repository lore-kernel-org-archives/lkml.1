Return-Path: <linux-kernel-owner+w=401wt.eu-S1753731AbYJAKFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731AbYJAKFa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 06:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752612AbYJAKFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 06:05:22 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:53189 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591AbYJAKFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 06:05:21 -0400
From: kamezawa.hiroyu@jp.fujitsu.com
Message-ID: <4885269.1222855496500.kamezawa.hiroyu@jp.fujitsu.com>
Date: Wed, 1 Oct 2008 19:04:56 +0900 (JST)
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: Re: [PATCH 3/6] memcg: charge-commit-cancel protocl
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       nishimura@mxp.nes.nec.co.jp, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>, balbir@linux.vnet.ibm.com
In-Reply-To: <20081001173313.69fb8c74.nishimura@mxp.nes.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: @nifty Webmail 2.0
References: <20081001173313.69fb8c74.nishimura@mxp.nes.nec.co.jp>
 <20081001165233.404c8b9c.kamezawa.hiroyu@jp.fujitsu.com>
	<20081001165734.e484cfe4.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
>> @@ -531,18 +529,33 @@ static int mem_cgroup_charge_common(stru
>>  
>>  		if (!nr_retries--) {
>>  			mem_cgroup_out_of_memory(mem, gfp_mask);
>> -			goto out;
>> +			goto nomem;
>>  		}
>>  	}
>> +	return 0;
>> +nomem:
>> +	css_put(&mem->css);
>> +	return -ENOMEM;
>> +}
>>  
>> +/*
>> + * commit a charge got by mem_cgroup_try_charge() and makes page_cgroup to
 be
>> + * USED state. If already USED, uncharge and return.
>> + */
>> +
>> +static void __mem_cgroup_commit_charge(struct mem_cgroup *mem,
>> +				     struct page_cgroup *pc,
>> +				     enum charge_type ctype)
>> +{
>> +	struct mem_cgroup_per_zone *mz;
>> +	unsigned long flags;
>>  
>>  	lock_page_cgroup(pc);
>>  	if (unlikely(PageCgroupUsed(pc))) {
>>  		unlock_page_cgroup(pc);
>>  		res_counter_uncharge(&mem->res, PAGE_SIZE);
>>  		css_put(&mem->css);
>> -
>> -		goto done;
>> +		return;
>>  	}
>>  	pc->mem_cgroup = mem;
>>  	/*
>
>Hmm, this patch cannot be applied because of this part.
>
>After [2/6], mem_cgroup_charge_common looks like:
>
>---
>                if (!nr_retries--) {
>                        mem_cgroup_out_of_memory(mem, gfp_mask);
>                        goto out;
>                }
>        }
>
>
>        lock_page_cgroup(pc);
>
>        if (unlikely(PageCgroupUsed(pc))) {
>                unlock_page_cgroup(pc);
>                res_counter_uncharge(&mem->res, PAGE_SIZE);
>                css_put(&mem->css);
>
>                goto done;
>        }
>        pc->mem_cgroup = mem;
>        /*
>---
>
>There is an empty line after lock_page_cgroup.
>
>After removing this line, I can appliy this patch(and [4-6/6]).
>
Ah, sorry. maybe refresh miss..

I'll check it again tomorrow.

Thanks,
-Kame


>
>Thanks,
>Daisuke Nishimura.
>

