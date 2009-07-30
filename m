Return-Path: <linux-kernel-owner+w=401wt.eu-S1754157AbZG3Dbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157AbZG3Dbu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 23:31:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753986AbZG3Dbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 23:31:50 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61991 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753724AbZG3Dbt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 23:31:49 -0400
Message-ID: <4A711415.2020308@cn.fujitsu.com>
Date: Thu, 30 Jul 2009 11:31:33 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: mingo@elte.hu, jens.axboe@oracle.com, nickpiggin@yahoo.com.au,
       peterz@infradead.org, rusty@rustcorp.com.au,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3 -mm] generic-ipi: fix the race between generic_smp_call_function_*()
 and hotplug_cfd()
References: <4A6983D8.8090805@cn.fujitsu.com>	<4A6FFFE9.5070204@cn.fujitsu.com>	<4A7000FF.6040402@cn.fujitsu.com> <20090729163120.2e27be41.akpm@linux-foundation.org>
In-Reply-To: <20090729163120.2e27be41.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Andrew Morton wrote:
> On Wed, 29 Jul 2009 15:57:51 +0800
> Xiao Guangrong <xiaoguangrong@cn.fujitsu.com> wrote:
> 
>> It have race between generic_smp_call_function_*() and hotplug_cfd()
>> in many cases, see below examples:
>>
>> 1: hotplug_cfd() can free cfd->cpumask, the system will crash if the
>>    cpu's cfd still in the call_function list:
>>   
>>   
>>       CPU A:                         CPU B
>>    
>>  smp_call_function_many()	    ......
>>    cpu_down()                      ......
>>   hotplug_cfd() ->                 ......
>>  free_cpumask_var(cfd->cpumask)  (receive function IPI interrupte)
>>                                 /* read cfd->cpumask */           
>>                           generic_smp_call_function_interrupt() ->
>>                          cpumask_test_and_clear_cpu(cpu, data->cpumask)
>>
>>                          	CRASH!!!
>>
>> 2: It's not handle call_function list when cpu down, It's will lead to
>>    dead-wait if other path is waiting this cpu to execute function
>>    
>>     CPU A:                           CPU B
>>
>>  smp_call_function_many(wait=0)					
>>         ......			    CPU B down
>>    smp_call_function_many() -->  (cpu down before recevie function
>>     csd_lock(&data->csd);         IPI interrupte)
>>
>>     DEAD-WAIT!!!!
>>        
>>   So, CPU A will dead-wait in csd_lock(), the same as
>>   smp_call_function_single()
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
>> ---
>>  kernel/smp.c |  140 ++++++++++++++++++++++++++++++++-------------------------
>>  1 files changed, 79 insertions(+), 61 deletions(-)
>>
> 
> It was unfortunate that this patch moved a screenful of code around and
> changed that code at the same time - it makes it hard to see what the
> functional change was.
> 
> So I split this patch into two.  The first patch simply moves
> hotplug_cfd() to the end of the file and the second makes the
> functional changes.  The second patch is below, for easier review.
> 
> Do we think that this patch should be merged into 2.6.31?  2.6.30.x?
>

This bug is conceal from v2.6.26 when kernel/smp.c created and be
found by my review, no one is bothered by it and sends us a bug
report, besides, this patch can't be applied to <= 2.6.30 cleanly,
so I think we can just fix it for .31

Thanks,
Xiao
