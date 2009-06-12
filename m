Return-Path: <linux-kernel-owner+w=401wt.eu-S1762913AbZFLAjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762913AbZFLAjX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 20:39:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756023AbZFLAjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 20:39:15 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51882 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755971AbZFLAjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 20:39:14 -0400
Message-ID: <4A31A345.50705@cn.fujitsu.com>
Date: Fri, 12 Jun 2009 08:37:25 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, jbaron@redhat.com,
       agk@redhat.com, snitzer@redhat.com, akpm@linux-foundation.org,
       peterz@infradead.org
Subject: Re: [PATCH 10/19] io-conroller: Prepare elevator layer for single
 queue schedulers
References: <1244513342-11758-1-git-send-email-vgoyal@redhat.com> <1244513342-11758-11-git-send-email-vgoyal@redhat.com> <4A30BC0F.3000401@cn.fujitsu.com> <20090611144136.GC27892@redhat.com>
In-Reply-To: <20090611144136.GC27892@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> On Thu, Jun 11, 2009 at 04:10:55PM +0800, Gui Jianfeng wrote:
>> Vivek Goyal wrote:
>> ...
>>>  
>>>  /*
>>> @@ -1296,6 +1302,13 @@ void io_group_chain_link(struct request_queue *q, void *key,
>>>  		iog = io_cgroup_lookup_group(iocg, key);
>>>  		io_group_set_parent(prev, iog);
>>>  	}
>>> +
>>> +	if (unlikely(efqd->only_root_group))
>>> +		/*
>>> +		 * TODO: Take care of force expiry of existing queue before
>>> +		 * new queue is queued.
>>> +		 */
>>> +		efqd->only_root_group = 0;
>>   Hi Vivek,
>>
>>   This flag isn't set back when all child groups go away. Am i missing something?
>>   BTW, why not just determine "only root group" by cgroup itself? Although there might be 
>>   some impact if cgroup is built but no request goes into it. but i think this isn't a big
>>   deal. How about the following patch?
>>
> 
> Hi Gui,
> 
> Determining if there are any children present or not from cgroup sounds like
> a good idea. Just that cost of the operation now has increased. I am not
> sure how significant that is. But for the time being we can stick to your
> implementation. 

  I don't introduce any extra locking here, so i guess the cost is very limited.

> 
> One question inline below.
> 
>> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
>> ---
>>  block/elevator-fq.c |   21 ++++++++++-----------
>>  block/elevator-fq.h |    1 -
>>  2 files changed, 10 insertions(+), 12 deletions(-)
>>
>> diff --git a/block/elevator-fq.c b/block/elevator-fq.c
>> index a516dce..f33155c 100644
>> --- a/block/elevator-fq.c
>> +++ b/block/elevator-fq.c
>> @@ -76,7 +76,6 @@ void elv_del_ioq_busy(struct elevator_queue *e, struct io_queue *ioq,
>>  void elv_activate_ioq(struct io_queue *ioq, int add_front);
>>  void elv_deactivate_ioq(struct elv_fq_data *efqd, struct io_queue *ioq,
>>  					int requeue);
>> -
>>  static int bfq_update_next_active(struct io_sched_data *sd)
>>  {
>>  	struct io_group *iog;
>> @@ -1131,6 +1130,14 @@ struct io_cgroup io_root_cgroup = {
>>  	.ioprio_class = IO_DEFAULT_GRP_CLASS,
>>  };
>>  
>> +static int is_only_root_group(void)
>> +{
>> +	if (list_empty(&io_root_cgroup.css.cgroup->children))
>> +		return 1;
>> +
> 
> Do we need some kind of locking here to make sure cgroup->children list is not
> being modified?

  Even if the children list is modified, i think this is not a big problem, and just
  get a mis-judgement for one time. Anyway, children list changing is rarely happens.
  For this corner case, IMHO, there's no need to introduce the cgroup lock, for this 
  lock costs too much.


-- 
Regards
Gui Jianfeng

