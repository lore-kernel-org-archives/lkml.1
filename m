Return-Path: <linux-kernel-owner+w=401wt.eu-S1754615AbYLIPP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615AbYLIPP7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 10:15:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753377AbYLIPPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 10:15:52 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:35501 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254AbYLIPPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 10:15:51 -0500
Message-ID: <493E8B68.2030007@linux.vnet.ibm.com>
Date: Tue, 09 Dec 2008 09:14:48 -0600
From: Brian King <brking@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14 (X11/20060911)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@elte.hu, efault@gmx.de, balbir@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] sched: CPU remove deadlock fix
References: <200812091548.mB9Fm0sm011959@d01av04.pok.ibm.com> <1228834342.8684.5.camel@twins> <1228834794.8684.6.camel@twins>
In-Reply-To: <1228834794.8684.6.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Tue, 2008-12-09 at 15:52 +0100, Peter Zijlstra wrote:
>> On Tue, 2008-12-09 at 08:47 -0600, Brian King wrote:
>>> This patch fixes a possible deadlock scenario in the CPU remove path.
>>> migration_call grabs rq->lock, then wakes up everything on rq->migration_queue
>>> with the lock held. Then one of the tasks on the migration queue ends up
>>> calling tg_shares_up which then also tries to acquire the same rq->lock.
>> Looks ok, does lockdep agree?
> 
> On second thought, I'm not seeing it at all..
> 
> why doesn't every wakeup deadlock?

>From what I can tell, the only other place that does a complete(&req->done)
is in migration_thread, and there the lock is released before doing the wakeup.

-Brian

> 
>>> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
>>> ---
>>>
>>>  kernel/sched.c |    2 ++
>>>  1 file changed, 2 insertions(+)
>>>
>>> diff -puN kernel/sched.c~sched_cpu_down_deadlock_fix kernel/sched.c
>>> --- linux-2.6/kernel/sched.c~sched_cpu_down_deadlock_fix	2008-12-09 08:42:09.000000000 -0600
>>> +++ linux-2.6-bjking1/kernel/sched.c	2008-12-09 08:42:09.000000000 -0600
>>> @@ -6587,7 +6587,9 @@ migration_call(struct notifier_block *nf
>>>  			req = list_entry(rq->migration_queue.next,
>>>  					 struct migration_req, list);
>>>  			list_del_init(&req->list);
>>> +			spin_unlock_irq(&rq->lock);
>>>  			complete(&req->done);
>>> +			spin_lock_irq(&rq->lock);
>>>  		}
>>>  		spin_unlock_irq(&rq->lock);
>>>  		break;
>>> _


-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


