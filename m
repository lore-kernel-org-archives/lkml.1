Return-Path: <linux-kernel-owner+w=401wt.eu-S1755794AbZKIMyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794AbZKIMyA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 07:54:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755741AbZKIMx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 07:53:59 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:56875 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755738AbZKIMx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 07:53:59 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4AF810C5.4010505@jp.fujitsu.com>
Date: Mon, 09 Nov 2009 21:53:25 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: Kernel oops in resched_task() with 2.6.31.5
References: <4AF80B8B.8080203@jp.fujitsu.com> <1257770720.4108.195.camel@laptop>
In-Reply-To: <1257770720.4108.195.camel@laptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Mon, 2009-11-09 at 21:31 +0900, Kenji Kaneshige wrote:
>> Hi,
>>
>> I frequently encounter the kernel oops attached below in resched_task()
>> with 2.6.31.5. This kernel oops happens also with 2.6.32-rc5. I don't
>> know about other kernel.
>>
>> Here is my analysis:
>>
>> The immediate cause of this kernel oops is that NULL was passed to
>> resched_task() from resched_cpu(). From my investigation, this was
>> caused as follows:
>>
>> - trigger_load_balance() caluculated cpu number of idle load balancer
>>   using find_new_ilb(), and find_new_ilb() returned *offline* CPU
>>   number (16 in my case). Note that I didn't do any CPU hotplug
>>   operation. On my system, present, online and offline under
>>   /sys/devices/system/cpu/ are
>>
>>     [kanesige@localhost ~]$ cat /sys/devices/system/cpu/present
>>     0-15
>>     [kanesige@localhost ~]$ cat /sys/devices/system/cpu/online
>>     0-15
>>     [kanesige@localhost ~]$ cat /sys/devices/system/cpu/offline
>>     16-255
>>
>>   And nr_cpu_ids is 256.
>>
>> - resched_cpu() calculated current task by cpu_curr() with offline CPU
>>   number.
>>
>> So this kernel oops seems to be caused by invalid CPU number returned
>> from find_new_ilb(). I don't know the find_new_ilb() implementation,
>> but I suspect the initialization of cpumasks used by find_new_ilb().
>> The patch attached below seems to fix the problem (With this patch,
>> the kernel oops doesn't happen). But I don't know if this is the
>> correct fix.
> 
> Please send patches against -tip.
> 
> You might find that Rusty has already fixed a similar issue there in
> commit: 49557e620339cb134127b5bfbcfecc06b77d0232.
> 
> Now, Rusty's patch does not clear the ilb mask, so maybe it doesn't
> fully cover your issue, please test.
> 

Thank you for quick response.

I didn't notice Rusty's fix.
I'll look at and test it tomorrow.

Thanks,
Kenji Kaneshige


