Return-Path: <linux-kernel-owner+w=401wt.eu-S1754276AbYC1K4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276AbYC1K4m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 06:56:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752122AbYC1K4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 06:56:34 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:47757 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023AbYC1K4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 06:56:33 -0400
Message-ID: <47ECCE00.70803@linux.vnet.ibm.com>
Date: Fri, 28 Mar 2008 16:22:48 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Paul Menage <menage@google.com>, Pavel Emelianov <xemul@openvz.org>,
       Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [-mm] Add an owner to the mm_struct (v2)
References: <20080328082316.6961.29044.sendpatchset@localhost.localdomain> <20080328195516.494edde3.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080328195516.494edde3.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Fri, 28 Mar 2008 13:53:16 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>> -static struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p)
>> +struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p)
>>  {
>>  	return container_of(task_subsys_state(p, mem_cgroup_subsys_id),
>>  				struct mem_cgroup, css);
>> @@ -250,12 +250,17 @@ void mm_init_cgroup(struct mm_struct *mm
>>  
>>  	mem = mem_cgroup_from_task(p);
>>  	css_get(&mem->css);
>> -	mm->mem_cgroup = mem;
>>  }
>>  
>>  void mm_free_cgroup(struct mm_struct *mm)
>>  {
>> -	css_put(&mm->mem_cgroup->css);
>> +	struct mem_cgroup *mem;
>> +
>> +	/*
>> +	 * TODO: Should we assign mm->owner to NULL here?
>> +	 */
>> +	mem = mem_cgroup_from_task(rcu_dereference(mm->owner));
>> +	css_put(&mem->css);
>>  }
>>  
> How about changing this css_get()/css_put() from accounting against mm_struct
> to accouting against task_struct ?
> It seems simpler way after this mm->owner change.

But the reason why we account the mem_cgroup is that we don't want the
mem_cgroup to be deleted. I hope you meant mem_cgroup instead of mm_struct.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
