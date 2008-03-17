Return-Path: <linux-kernel-owner+w=401wt.eu-S1754092AbYCQMaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092AbYCQMaz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 08:30:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752142AbYCQMar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 08:30:47 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:37876 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbYCQMaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 08:30:46 -0400
Message-ID: <47DE640F.3070601@linux.vnet.ibm.com>
Date: Mon, 17 Mar 2008 17:59:03 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Pavel Emelyanov <xemul@openvz.org>
CC: linux-mm@kvack.org, Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC][2/3] Account and control virtual address space allocations
References: <20080316172942.8812.56051.sendpatchset@localhost.localdomain> <20080316173005.8812.88290.sendpatchset@localhost.localdomain> <47DE57C2.5060206@openvz.org>
In-Reply-To: <47DE57C2.5060206@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Emelyanov wrote:
> [snip]
> 
>> +int mem_cgroup_update_as(struct mm_struct *mm, long nr_pages)
>> +{
>> +	int ret = 0;
>> +	struct mem_cgroup *mem;
>> +	if (mem_cgroup_subsys.disabled)
>> +		return ret;
>> +
>> +	rcu_read_lock();
>> +	mem = rcu_dereference(mm->mem_cgroup);
>> +	css_get(&mem->css);
>> +	rcu_read_unlock();
>> +
>> +	if (nr_pages > 0) {
>> +		if (res_counter_charge(&mem->as_res, (nr_pages * PAGE_SIZE)))
>> +			ret = 1;
>> +	} else
>> +		res_counter_uncharge(&mem->as_res, (-nr_pages * PAGE_SIZE));
> 
> No, please, no. Let's make two calls - mem_cgroup_charge_as and mem_cgroup_uncharge_as.
> 
> [snip]
> 

Yes, sure :)

>> @@ -1117,6 +1117,9 @@ munmap_back:
>>  		}
>>  	}
>>  
>> +	if (mem_cgroup_update_as(mm, len >> PAGE_SHIFT))
>> +		return -ENOMEM;
>> +
> 
> Why not use existintg cap_vm_enough_memory and co?
> 

I thought about it and almost used may_expand_vm(), but there is a slight catch
there. With cap_vm_enough_memory() or security_vm_enough_memory(), they are
called after total_vm has been calculated. In our case we need to keep the
cgroups equivalent of total_vm up to date, and we do this in mem_cgorup_update_as.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
