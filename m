Return-Path: <linux-kernel-owner+w=401wt.eu-S1755587AbZAVBGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587AbZAVBGS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 20:06:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754633AbZAVBGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 20:06:04 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57899 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753518AbZAVBGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 20:06:03 -0500
Message-ID: <4977C654.7010906@cn.fujitsu.com>
Date: Thu, 22 Jan 2009 09:05:24 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Oleg Nesterov <oleg@tv-sign.ru>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] workqueue: don't alloc_percpu for single workqueue
References: <4976EE0B.5090200@cn.fujitsu.com> <20090121104811.GB25531@elte.hu>
In-Reply-To: <20090121104811.GB25531@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> 
>> allocating memory for every cpu for single workqueue is waste.
> 
> good idea.
> 
> One detail:
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
>> +
>>  	cpu_maps_update_begin();
>>  	spin_lock(&workqueue_lock);
>>  	list_del(&wq->list);
> 
> Arent we forgetting to remove the workqueue from the &workqueues list in 
> the new single-thread case?

Single-thread workqueue is not inserted into &workqueues list.

See also the single thread case in __create_workqueue_key():
.....
	if (singlethread) {
		cwq = wq->cpu_wq;
		init_cpu_workqueue(wq, cwq);
		err = create_workqueue_thread(cwq, singlethread_cpu);
		start_workqueue_thread(cwq, -1);
	}
.....

> 
> Also, see the checkpatch output from kernel/workqueue.c - the warnings 
> below are correct and should be cleaned up.
> 
> 	Ingo
> 
> WARNING: printk() should include KERN_ facility level
> #268: FILE: workqueue.c:268:
> +		printk("%s: recursion depth exceeded: %d\n",
> 
> ERROR: code indent should use tabs where possible
> #304: FILE: workqueue.c:304:
> +^I^I^I^I       ^Itask_pid_nr(current));$
> 
> ERROR: "foo* bar" should be "foo *bar"
> #555: FILE: workqueue.c:555:
> +				struct timer_list* timer)
> 
> ERROR: code indent should use tabs where possible
> #916: FILE: workqueue.c:916:
> + ^Icpu_maps_update_done();$
> 
> kernel/workqueue.c has style problems, please review.  If any of these errors
> are false positives report them to the maintainer, see
> CHECKPATCH in MAINTAINERS.
> 
> 
> 


