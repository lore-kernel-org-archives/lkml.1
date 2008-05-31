Return-Path: <linux-kernel-owner+w=401wt.eu-S1753345AbYEaLWK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345AbYEaLWK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 07:22:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751906AbYEaLVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 07:21:55 -0400
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:40720 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbYEaLVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 07:21:54 -0400
Message-ID: <48413482.5080409@linux.vnet.ibm.com>
Date: Sat, 31 May 2008 16:50:34 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: kamezawa.hiroyu@jp.fujitsu.com
CC: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, xemul@openvz.org,
       menage@google.com, yamamoto@valinux.co.jp, lizf@cn.fujitsu.com
Subject: Re: [RFC][PATCH 1/2] memcg: res_counter hierarchy
References: <48407DC3.8060001@linux.vnet.ibm.com> <20080530104312.4b20cc60.kamezawa.hiroyu@jp.fujitsu.com> <20080530104515.9afefdbb.kamezawa.hiroyu@jp.fujitsu.com> <25360008.1212199156779.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <25360008.1212199156779.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kamezawa.hiroyu@jp.fujitsu.com wrote:
>> KAMEZAWA Hiroyuki wrote:
>>> This patch tries to implements _simple_ 'hierarchy policy' in res_counter.
>>>
>>> While several policy of hierarchy can be considered, this patch implements
>>> simple one 
>>>    - the parent includes, over-commits the child
>>>    - there are no shared resource
>> I am not sure if this is desirable. The concept of a hierarchy applies really
>> well when there are shared resources.
>>
>>>    - dynamic hierarchy resource usage management in the kernel is not neces
> sary
>> Could you please elaborate as to why? I am not sure I understand your point
>>
> 
> ok, let's consider a _miiddleware_ wchich has following paramater.
> 
> An expoterd param to the user.
>    - user_memory_limit
> parameters for co-operation with the kernel
>    - kernel_memory_limit
> 
> And here,
>    user_memory_limit >= kernel_memory_limit == cgroup's memory.limits_in_bytes
> 
> When a user ask the miidleware to set limit to 1Gbytes
>    user_memory_limit = 1G
>    kernel_memory_limit = 0-1G.
> It moves kernel_memory_limit dynamically 0 to 1Gbytes and reset limits_in_byte
> s in dynamic way with checking memory cgroup's statistics.
> Of course, we can add some kind of interdace , as following
>   - failure_notifier - triggered at failcnt increment.
>   - threshhold_notifier - triggered as usage > threshold.
> 
>>> works as following.
>>>
>>>  1. create a child. set default child limits to be 0.
>>>  2. set limit to child.
>>>     2-a. before setting limit to child, prepare enough room in parent.
>>>     2-b. increase 'usage' of parent by child's limit.
>> The problem with this is that you are forcing the parent will run into a recl
> aim
>> loop even if the child is not using the assigned limit to it.
>>
> That's not problem because it's avoildable by users.
> But it's ok to limit the sum of child's limit to be below XX % ot the parent.
> 
>>>  3. the child sets its limit to the val moved from the parent.
>>>     the parent remembers what amount of resource is to the children.
>>>
>> All of this needs to be dynamic
>>
> As explained, this can be dynamic by middleware.
> 
>>>  Above means that
>>> 	- a directory's usage implies the sum of all sub directories +
>>>           own usage.
>>> 	- there are no shared resource between parent <-> child.
>>>
>>>  Pros.
>>>   - simple and easy policy.
>>>   - no hierarchy overhead.
>>>   - no resource share among child <-> parent. very suitable for multilevel
>>>     resource isolation.
>> Sharing is an important aspect of hierachies. I am not convinced of this
>> approach. Did you look at the patches I sent out? Was there something
>> fundamentally broken in them?
>>
> 
> Yes, I read. And tried to make it faster and found it will be complicated.
> One problem is overhead of counter itself.
> Another problem is overhead of shrinking multi-level LRU with feedback.
> One more problem is that it's hard to implement various kinds of hierarchy
> policy. I believe there are other hierarhcy policies rather than OpenVZ
> want to use. Kicking out functions to middleware AMAP is what I'm thinking
> now.

One way to manage hierarchies other than via limits is to use shares (please see
the shares used by the cpu controller). Basically, what you've done with limits
is done with shares

If a parent has 100 shares, then it can decide how many to pass on to it's  children
based on the shares of the child and your logic would work well. I propose
assigning top level (high resolution) shares to the root of the cgroup and in a
hierarchy passing them down to children and sharing it with them. Based on the
shares, deduce the limit of each node in the hierarchy.

What do you think?


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
