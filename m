Return-Path: <linux-kernel-owner+w=401wt.eu-S1764839AbXHWRRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764839AbXHWRRj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 13:17:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752678AbXHWRRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 13:17:32 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:44144 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089AbXHWRRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 13:17:31 -0400
Message-ID: <46CDC11E.2010008@linux.vnet.ibm.com>
Date: Thu, 23 Aug 2007 22:47:18 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Mel Gorman <mel@skynet.ie>, linux-kernel@vger.kernel.org,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org
Subject: Re: [BUG] 2.6.23-rc3-mm1 kernel BUG at mm/page_alloc.c:2876!
References: <46CC9A7A.2030404@linux.vnet.ibm.com> <20070822134800.ce5a5a69.akpm@linux-foundation.org> <20070822135024.dde8ef5a.akpm@linux-foundation.org> <20070823130732.GC18456@skynet.ie>
In-Reply-To: <20070823130732.GC18456@skynet.ie>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman wrote:
> On (22/08/07 13:50), Andrew Morton didst pronounce:
>   
>> On Wed, 22 Aug 2007 13:48:00 -0700
>> Andrew Morton <akpm@linux-foundation.org> wrote:
>>
>>     
>>> This:
>>>
>>> --- a/mm/page_alloc.c~a
>>> +++ a/mm/page_alloc.c
>>> @@ -2814,6 +2814,8 @@ static int __cpuinit process_zones(int c
>>>  	return 0;
>>>  bad:
>>>  	for_each_zone(dzone) {
>>> +		if (!populated_zone(zone))
>>> +			continue;		
>>>  		if (dzone == zone)
>>>  			break;
>>>  		kfree(zone_pcp(dzone, cpu));
>>> _
>>>
>>> might help avoid the crash
>>>       
>> err, make that
>>
>>     
>
> We're already in the error path at this point and it's going to blow up.
> The real problem is kmalloc_node() returning NULL for whatever reason.
>
>   
>> --- a/mm/page_alloc.c~a
>> +++ a/mm/page_alloc.c
>> @@ -2814,6 +2814,8 @@ static int __cpuinit process_zones(int c
>>  	return 0;
>>  bad:
>>  	for_each_zone(dzone) {
>> +		if (!populated_zone(dzone))
>> +			continue;
>>  		if (dzone == zone)
>>  			break;
>>  		kfree(zone_pcp(dzone, cpu));
>> _
>>
>>
>>     
>
>   
After applying the patch, the call trace is gone but the kernel bug
is still hit


Memory: 4105840k/4194304k available (4964k kernel code, 88464k reserved, 
948k data, 571k bss, 264k init)
SLUB: Genslabs=12, HWalign=128, Order=0-1, MinObjects=4, CPUs=4, Nodes=16
------------[ cut here ]------------
kernel BUG at mm/page_alloc.c:2878!
cpu 0x0: Vector: 700 (Program Check) at [c0000000005cbbe0]
pc: c0000000004b5160: .setup_per_cpu_pageset+0x24/0x48
lr: c0000000004b5160: .setup_per_cpu_pageset+0x24/0x48
sp: c0000000005cbe60
msr: 8000000000029032
current = 0xc0000000004fd1b0
paca = 0xc0000000004fdd80
pid = 0, comm = swapper
kernel BUG at mm/page_alloc.c:2878!
enter ? for help
[c0000000005cbee0] c0000000004978d8 .start_kernel+0x304/0x3f4
[c0000000005cbf90] c0000000003bef1c .start_here_common+0x54/0x58

-
Kamalesh Babulal




