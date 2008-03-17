Return-Path: <linux-kernel-owner+w=401wt.eu-S1754210AbYCQNDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210AbYCQNDV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 09:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752181AbYCQNDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 09:03:13 -0400
Received: from sacred.ru ([62.205.161.221]:52828 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114AbYCQNDN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 09:03:13 -0400
Message-ID: <47DE6B8D.5090302@openvz.org>
Date: Mon, 17 Mar 2008 16:01:01 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
CC: linux-mm@kvack.org, Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC][2/3] Account and control virtual address space allocations
References: <20080316172942.8812.56051.sendpatchset@localhost.localdomain> <20080316173005.8812.88290.sendpatchset@localhost.localdomain> <47DE57C2.5060206@openvz.org> <47DE640F.3070601@linux.vnet.ibm.com> <47DE66BE.30904@openvz.org> <47DE695D.3080605@linux.vnet.ibm.com>
In-Reply-To: <47DE695D.3080605@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Mon, 17 Mar 2008 16:00:57 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
> Pavel Emelyanov wrote:
>> Balbir Singh wrote:
>>> Pavel Emelyanov wrote:
>>>> [snip]
>>>>
>>>>> +int mem_cgroup_update_as(struct mm_struct *mm, long nr_pages)
>>>>> +{
>>>>> +	int ret = 0;
>>>>> +	struct mem_cgroup *mem;
>>>>> +	if (mem_cgroup_subsys.disabled)
>>>>> +		return ret;
>>>>> +
>>>>> +	rcu_read_lock();
>>>>> +	mem = rcu_dereference(mm->mem_cgroup);
>>>>> +	css_get(&mem->css);
>>>>> +	rcu_read_unlock();
>>>>> +
>>>>> +	if (nr_pages > 0) {
>>>>> +		if (res_counter_charge(&mem->as_res, (nr_pages * PAGE_SIZE)))
>>>>> +			ret = 1;
>>>>> +	} else
>>>>> +		res_counter_uncharge(&mem->as_res, (-nr_pages * PAGE_SIZE));
>>>> No, please, no. Let's make two calls - mem_cgroup_charge_as and mem_cgroup_uncharge_as.
>>>>
>>>> [snip]
>>>>
>>> Yes, sure :)
>> Thanks :)
>>
>>>>> @@ -1117,6 +1117,9 @@ munmap_back:
>>>>>  		}
>>>>>  	}
>>>>>  
>>>>> +	if (mem_cgroup_update_as(mm, len >> PAGE_SHIFT))
>>>>> +		return -ENOMEM;
>>>>> +
>>>> Why not use existintg cap_vm_enough_memory and co?
>>>>
>>> I thought about it and almost used may_expand_vm(), but there is a slight catch
>>> there. With cap_vm_enough_memory() or security_vm_enough_memory(), they are
>>> called after total_vm has been calculated. In our case we need to keep the
>>> cgroups equivalent of total_vm up to date, and we do this in mem_cgorup_update_as.
>> So? What prevents us from using these hooks? :)
> 
> 1. We need to account total_vm usage of the task anyway. So why have two places,
>    one for accounting and second for control?

We still have two of them even placing hooks in each place manually.

Besides, putting the mem_cgroup_(un)charge_as() in these vm hooks will
1. save the number of places to patch
2. help keeping memcgroup consistent in case someone adds more places
   that expand tasks vm (arches, drivers) - in case we have our hooks
   celled from inside vm ones, we won't have to patch more.

> 2. These hooks are activated for conditionally invoked for vma's with VM_ACCOUNT
>    set.

This is a good point against. But, wrt my previous comment, can we handle 
this somehow?
