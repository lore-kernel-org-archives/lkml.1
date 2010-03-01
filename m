Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751257Ab0CAPdj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 10:33:39 -0500
Received: from hera.kernel.org ([140.211.167.34]:35218 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033Ab0CAPdi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 10:33:38 -0500
Message-ID: <4B8BDE02.1050208@kernel.org>
Date: Tue, 02 Mar 2010 00:32:18 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-3.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
Subject: Re: [PATCH 16/43] workqueue: kill cpu_populated_map
References: <1267187000-18791-1-git-send-email-tj@kernel.org> <1267187000-18791-17-git-send-email-tj@kernel.org> <20100228160005.GA16144@redhat.com>
In-Reply-To: <20100228160005.GA16144@redhat.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 01 Mar 2010 15:29:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 03/01/2010 01:00 AM, Oleg Nesterov wrote:
> On 02/26, Tejun Heo wrote:
>>
>> @@ -1023,41 +991,40 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
>> ...
>> +	cpu_maps_update_done();
>> ...
>> +
>> +	spin_lock(&workqueue_lock);
>> +	list_add(&wq->list, &workqueues);
>> +	spin_unlock(&workqueue_lock);
> 
> OK, but if cpu_up() happens right after we drop cpu_maps_update_done(),
> cwq->thread on the new CPU will run unbound?

Indeed, looks like I was too impatient with cpu_maps_update_done().

>> @@ -1127,47 +1091,30 @@ static int __devinit workqueue_cpu_callback(struct notifier_block *nfb,
>> ...
>>  	list_for_each_entry(wq, &workqueues, list) {
> 
> this becomes unsafe. create/destroy can modify workqueues list
> in parallel.

Yeap, has always been like that.  Will be fixed by later changes.

>>  		case CPU_ONLINE:
>> -			start_workqueue_thread(cwq, cpu);
>> +			__set_cpus_allowed(cwq->thread, get_cpu_mask(cpu),
>> +					   true);
> 
> if the thread doesn't have PF_THREAD_BOUND, who will set it?

Indeed will update the worker function to set PF_THREAD_BOUND itself
but again this problem is gone with later patches.

>>  		case CPU_POST_DEAD:
>> -			cleanup_workqueue_thread(cwq);
>> +			lock_map_acquire(&cwq->wq->lockdep_map);
>> +			lock_map_release(&cwq->wq->lockdep_map);
>> +			flush_cpu_workqueue(cwq);
> 
> This can race with destroy_workqueue(), no?

Yes, it can and, again, has been always like that and will be fixed by
later patches.

> I guess this patch is preparation, probably these problems should
> go away later...

I'll fix the new problems but leave the existing ones alone.  I don't
think it's worth fixing them at this point with all the pending
changes.

Thanks.

-- 
tejun
