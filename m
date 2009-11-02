Return-Path: <linux-kernel-owner+w=401wt.eu-S1757240AbZKBXC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757240AbZKBXC3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 18:02:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757193AbZKBXC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 18:02:28 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:47274 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757155AbZKBXC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 18:02:27 -0500
Message-ID: <c33e080dcc375d55a4dee1a1314e73f0.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <alpine.DEB.1.10.0911021159120.2028@V090114053VZO-1>
References: <20091102162244.9425e49b.kamezawa.hiroyu@jp.fujitsu.com>
    <20091102162412.107ff8ac.kamezawa.hiroyu@jp.fujitsu.com>
    <alpine.DEB.1.10.0911021159120.2028@V090114053VZO-1>
Date: Tue, 3 Nov 2009 08:02:28 +0900 (JST)
Subject: Re: [RFC][-mm][PATCH 1/6] oom-killer: updates for classification
 of OOM
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: "Christoph Lameter" <cl@linux-foundation.org>
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       aarcange@redhat.com, akpm@linux-foundation.org, minchan.kim@gmail.com,
       rientjes@google.com, vedran.furac@gmail.com,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>
User-Agent: SquirrelMail/1.4.16
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks! your review is very helpful around NUMA.

Christoph Lameter wrote:
> On Mon, 2 Nov 2009, KAMEZAWA Hiroyuki wrote:
>
>>  /*
>> - * Types of limitations to the nodes from which allocations may occur
>> + * Types of limitations to zones from which allocations may occur
>>   */
>
> "Types of limitations that may cause OOMs"? MEMCG limitations are not zone
> based.
>
ah, will rewrite.

>>   */
>>
>> -unsigned long badness(struct task_struct *p, unsigned long uptime)
>> +static unsigned long __badness(struct task_struct *p,
>> +		      unsigned long uptime, enum oom_constraint constraint,
>> +		      struct mem_cgroup *mem)
>>  {
>>  	unsigned long points, cpu_time, run_time;
>>  	struct mm_struct *mm;
>
> Why rename this function? You are adding a global_badness anyways.
>
just because of history of my own updates...i.e. mistake.
no reason. sorry.

>
>> +	/*
>> +	 * In numa environ, almost all allocation will be against NORMAL zone.
>
> The typical allocations will be against the policy_zone! SGI IA64 (and
> others) have policy_zone == GFP_DMA.
>
Hmm ? ok. I thought GPF_DMA for ia64 was below 4G zone.
If all memory are GFP_DMA(as ppc), that means no lowemem.
I'll just rewrite above comments as
"typical allocation will be against policy_zone".


>> +	 * But some small area, ex)GFP_DMA for ia64 or GFP_DMA32 for x86-64
>> +	 * can cause OOM. We can use policy_zone for checking lowmem.
>> +	 */
>
> Simply say that we are checking if the zone constraint is below the policy
> zone?
>
ok, will rewrite. Too verbose just bacause policy_zone isn't well unknown.


>> +	 * Now, only mempolicy specifies nodemask. But if nodemask
>> +	 * covers all nodes, this oom is global oom.
>> +	 */
>> +	if (nodemask && !nodes_equal(node_states[N_HIGH_MEMORY], *nodemask))
>> +		ret = CONSTRAINT_MEMORY_POLICY;
>
> Huh? A cpuset can also restrict the nodes?
>
cpuset doesn't pass nodemask for allocation(now).
It checks its nodemask in get_free_page_from_freelist(), internally.

>> +	/*
>> + 	 * If not __GFP_THISNODE, zonelist containes all nodes. And if
>
> Dont see any __GFP_THISNODE checks here.
>
If __GFP_THISNODE, zonelist includes local node only. Then zonelist/nodemask
check will hunt it and result will be CONSTRAINT_MEMPOLICY.
Then...hum....recommending CONSTRAINT_THISNODE ?

>>  		panic("out of memory from page fault. panic_on_oom is selected.\n");
>>
>>  	read_lock(&tasklist_lock);
>> -	__out_of_memory(0, 0); /* unknown gfp_mask and order */
>> +	/*
>> +	 * Considering nature of pages required for page-fault,this must be
>> +	 * global OOM (if not cpuset...). Then, CONSTRAINT_NONE is correct.
>> +	 * zonelist, nodemasks are unknown...
>> +	 */
>> +	__out_of_memory(0, CONSTRAINT_NONE, 0, NULL);
>>  	read_unlock(&tasklist_lock);
>
> Page faults can occur on processes that have memory restrictions.
>
yes. comments are bad. will rewrite. But we don't have any useful
information here.Fixing pagefault_out_of_memory is on my to-do-list.
It seems wrong.

But a condition unclear to me is when VM_FAULT_OOM can be returned
without oom-kill...so plz give me time.

Thanks,
-Kame


