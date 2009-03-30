Return-Path: <linux-kernel-owner+w=401wt.eu-S1755558AbZC3BLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558AbZC3BLm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 21:11:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755067AbZC3BLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 21:11:30 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58479 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755011AbZC3BL3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 21:11:29 -0400
Message-ID: <49D01BCE.8010409@cn.fujitsu.com>
Date: Mon, 30 Mar 2009 09:09:34 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       jens.axboe@oracle.com, ryov@valinux.co.jp, fernando@intellilink.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, arozansk@redhat.com,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       akpm@linux-foundation.org, menage@google.com, peterz@infradead.org
Subject: Re: [PATCH] IO Controller: No need to stop idling in as
References: <1236823015-4183-1-git-send-email-vgoyal@redhat.com> <1236823015-4183-11-git-send-email-vgoyal@redhat.com> <49CC791A.10008@cn.fujitsu.com> <20090327140530.GE30476@redhat.com>
In-Reply-To: <20090327140530.GE30476@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> On Fri, Mar 27, 2009 at 02:58:34PM +0800, Gui Jianfeng wrote:
>> Vivek Goyal wrote:
>>
>>>  		.elevator_alloc_sched_queue_fn = as_alloc_as_queue,
>>>  		.elevator_free_sched_queue_fn = as_free_as_queue,
>>> +#ifdef CONFIG_IOSCHED_AS_HIER
>>> +		.elevator_expire_ioq_fn =       as_expire_ioq,
>>> +		.elevator_active_ioq_set_fn =   as_active_ioq_set,
>>>  	},
>>> -
>>> +	.elevator_features = ELV_IOSCHED_NEED_FQ | ELV_IOSCHED_SINGLE_IOQ | ELV_IOSCHED_DONT_IDLE,
>>   Hi Vivek,
>>
>>   I found the IO Controller doesn't work in as.
>>   I dig into this issue, and notice that you stop idling in as. IMHO, this will cause
>>   active ioq is always expired when tring to choose a new ioq to serve(elv_fq_select_ioq). 
>>   Because idling is disabled, active ioq can't be kept anymore.
>>   So i just get rid of ELV_IOSCHED_DONT_IDLE, and it works fine this time.
>>
> 
> Hi Gui,
> 
> Thanks for the testing. I have not enabled idling for AS in common layer
> becuase AS has its own idling/anticipation logic. I think we should not have
> anticipation going on at two places, common layer as well as individual
> io scheduler. That's the reason I have implemented a function
> elv_iosched_expire_ioq(), which calls io scheduler to find out if an ioq
> can be expired now. 

  Hi Vivek,

  If an user chooses fairness rather than throughput just like what your fairness
  patch is tring to do. Do we need to enable the common idling logic for as in 
  this scenario.

> 
> So in elv_fq_select_ioq(), we call elv_iosched_expire_ioq() and if
> ioschduler denies expiration, then we don't expire the queue. In this case
> AS can deny the expiration if it is anticipating for next request.
> 
> Actually AS is very different and its little tricky to make it work with
> common layer, especially in terms of anticipation. This is on my TODO list
> but before I fix AS, I wanted to get other things right with common layer,
> cfq, noop and deadline.
> 
> Thanks
> Vivek
> 
> 
>> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
>> ---
>>  block/as-iosched.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/block/as-iosched.c b/block/as-iosched.c
>> index 27c14a7..499c521 100644
>> --- a/block/as-iosched.c
>> +++ b/block/as-iosched.c
>> @@ -1689,7 +1689,7 @@ static struct elevator_type iosched_as = {
>>  		.elevator_expire_ioq_fn =       as_expire_ioq,
>>  		.elevator_active_ioq_set_fn =   as_active_ioq_set,
>>  	},
>> -	.elevator_features = ELV_IOSCHED_NEED_FQ | ELV_IOSCHED_SINGLE_IOQ | ELV_IOSCHED_DONT_IDLE,
>> +	.elevator_features = ELV_IOSCHED_NEED_FQ | ELV_IOSCHED_SINGLE_IOQ,
>>  #else
>>  	},
>>  #endif
>> -- 
>> 1.5.4.rc3
>>
> 
> 
> 

-- 
Regards
Gui Jianfeng

