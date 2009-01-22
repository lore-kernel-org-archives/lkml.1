Return-Path: <linux-kernel-owner+w=401wt.eu-S1757216AbZAVDnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757216AbZAVDnA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 22:43:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756418AbZAVDmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 22:42:51 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59310 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756401AbZAVDmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 22:42:50 -0500
Message-ID: <4977EB1C.4030405@cn.fujitsu.com>
Date: Thu, 22 Jan 2009 11:42:20 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] workqueue: don't alloc_percpu for single workqueue
References: <4976EE0B.5090200@cn.fujitsu.com> <20090121121756.GA11942@redhat.com>
In-Reply-To: <20090121121756.GA11942@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> On 01/21, Lai Jiangshan wrote:
>> allocating memory for every cpu for single workqueue is waste.
> 
> Yes, perhaps this makes sense, we can save a bit of per-cpu memory
> for each single-threaded wq, and the patch looks correct.
> 
>> -static struct cpu_workqueue_struct *
>> -init_cpu_workqueue(struct workqueue_struct *wq, int cpu)
>> +static void init_cpu_workqueue(struct workqueue_struct *wq,
>> +		struct cpu_workqueue_struct *cwq)
>>  {
>> -	struct cpu_workqueue_struct *cwq = per_cpu_ptr(wq->cpu_wq, cpu);
>> -
>>  	cwq->wq = wq;
>>  	spin_lock_init(&cwq->lock);
>>  	INIT_LIST_HEAD(&cwq->worklist);
>>  	init_waitqueue_head(&cwq->more_work);
>> -
>> -	return cwq;
>>  }
> 
> Do we really need to change the prototype of init_cpu_workqueue()
> and change then change __create_workqueue_key() accordingly?
> Afaics, the only change in init_cpu_workqueue() we need is
> 
> 	-	struct cpu_workqueue_struct *cwq = per_cpu_ptr(wq->cpu_wq, cpu);
> 	+	struct cpu_workqueue_struct *cwq = wq_per_cpu(wq, cpu);
> 
> no?

Thanks, it is simpler.

> 
>> @@ -906,6 +907,13 @@ void destroy_workqueue(struct workqueue_struct *wq)
>>  	const struct cpumask *cpu_map = wq_cpu_map(wq);
>>  	int cpu;
>>
>> +	if (is_wq_single_threaded(wq)) {
>> +		cleanup_workqueue_thread(wq->cpu_wq);
>> +		kfree(wq->cpu_wq);
>> +		kfree(wq);
>> +		return;
>> +	}
> 
> again, not sure I understand why this change is needed. Afaics we
> only need to use kfree(wq->cpu_wq) instead of free_percpu() if
> it is single-threaded.
> 

I think this change is needed.
In the single thread case, we don't need
1) cpu_maps_update_begin(). --> require cpu_add_remove_lock
2) remove workqueue from the list. (we did not inserted it)

It is indeed that there is no bad result occurred when we do these
things for single thread. But I think the destroying should not
do things more than the creating.

Thanks, Lai


