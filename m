Return-Path: <linux-kernel-owner+w=401wt.eu-S1757457AbZLONrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457AbZLONrj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 08:47:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755932AbZLONrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 08:47:37 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:49708 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755344AbZLONrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 08:47:36 -0500
Message-ID: <4B279370.5050800@in.ibm.com>
Date: Tue, 15 Dec 2009 19:17:28 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, linux-next@vger.kernel.org
Subject: Re: [Next] CPU Hotplug test failures on powerpc
References: <4B2224C7.1020908@in.ibm.com> <1260786122.4165.142.camel@twins> <4B261D7A.9040802@in.ibm.com>  <1260793182.4165.223.camel@twins> <1260825420.2217.40.camel@pasglop>  <4B275A6B.9030200@in.ibm.com> <1260873827.4165.362.camel@twins>
In-Reply-To: <1260873827.4165.362.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
>> I added some debug statements within the above code. 
>> This is a 2 cpu machine.
>>
>> XMON dest_cpu = 1024 . dead_cpu = 1 . nr_cpu_ids = 2
>> XMON dest_cpu = 1024 
>> XMON dest_cpu = 1024 . dead_cpu = 1
>> XMON dest_cpu = 1024 . dead_cpu = 1 . nr_cpu_ids = 2
>> XMON dest_cpu = 1024 
>> XMON dest_cpu = 1024 . dead_cpu = 1
>> XMON dest_cpu = 1024 . dead_cpu = 1 . nr_cpu_ids = 2
>> XMON dest_cpu = 1024 
>> XMON dest_cpu = 1024 . dead_cpu = 1
>>
>> Seems to me that the control is stuck in an infinite loop and hence the
>> machine appears to be in hung state. The dest_cpu value is always 1024
>> and never changes, which result in an infinite loop.
>>
>> In working scenario the o/p is something on the following lines
>>
>> XMON dest_cpu = 1024 . dead_cpu = 1 . nr_cpu_ids = 2
>> XMON dest_cpu = 0 
>> XMON dest_cpu = 1024 . dead_cpu = 1 . nr_cpu_ids = 2
>> XMON dest_cpu = 0 
>> XMON dest_cpu = 1024 . dead_cpu = 1 . nr_cpu_ids = 2
>> XMON dest_cpu = 0 
>>
>> Let me know if i should try to record any specific value ?
>>     
>
> Could you possibly print the two masks themselves? cpumask_scnprintf()
> and friend come in handy for this.
>
> The dest_cpu=1024 thing seem to suggest the intersection between
> p->cpus_allowed and cpu_active_mask is empty for some reason, even
> though we forcefully reset p->cpus_allowed to the full set using
> cpuset_cpus_allowed_locked().
>   
So here is the data related to the two masks.

cpu_active_mask = 00000000,00000000,00000000,00000000,00000000,00000000,
00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,
00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,
00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,
00000000,00000000
XMON dest_cpu = 1024

while p->cpus_allowed =  00000000,00000000,00000000,00000000,00000000,
00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,
00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,
00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,
00000000,00000000,00000001
XMON dest_cpu = 1024

In working scenario the above data looks like

cpu_active_mask = 00000000,00000000,00000000,00000000,00000000,00000000,
00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,
00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,
00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,
00000000,00000002
XMON dest_cpu = 1

while p->cpus_allowed =  00000000,00000000,00000000,00000000,00000000,
00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,
00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,
00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,
00000000,00000000,00000002
XMON dest_cpu = 1


hope i got the data correct.

Thanks
-Sachin


-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

