Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862Ab0CDJDm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 04:03:42 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49194 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752575Ab0CDJDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 04:03:39 -0500
Message-ID: <4B8F7758.9020500@cn.fujitsu.com>
Date: Thu, 04 Mar 2010 17:03:20 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: David Rientjes <rientjes@google.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Paul Menage <menage@google.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH 4/4] cpuset,mm: use rwlock to protect task->mempolicy
 and mems_allowed
References: <4B8E3F77.6070201@cn.fujitsu.com> <20100303155004.5f9e793e.akpm@linux-foundation.org>
In-Reply-To: <20100303155004.5f9e793e.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on 2010-3-4 7:50, Andrew Morton wrote:
> On Wed, 03 Mar 2010 18:52:39 +0800
> Miao Xie <miaox@cn.fujitsu.com> wrote:
> 
>> if MAX_NUMNODES > BITS_PER_LONG, loading/storing task->mems_allowed or mems_allowed in
>> task->mempolicy are not atomic operations, and the kernel page allocator gets an empty
>> mems_allowed when updating task->mems_allowed or mems_allowed in task->mempolicy. So we
>> use a rwlock to protect them to fix this probelm.
> 
> Boy, that is one big ugly patch.  Is there no other way of doing this?

Let me consider!

> 
>>
>> ...
>>
>> --- a/include/linux/mempolicy.h
>> +++ b/include/linux/mempolicy.h
>> @@ -51,6 +51,7 @@ enum {
>>   */
>>  #define MPOL_F_SHARED  (1 << 0)	/* identify shared policies */
>>  #define MPOL_F_LOCAL   (1 << 1)	/* preferred local allocation */
>> +#define MPOL_F_TASK    (1 << 2)	/* identify tasks' policies */
> 
> What's this?  It wasn't mentioned in the changelog - I suspect it
> should have been?

I hope task->mempolicy has the same get/put operation just like shared mempolicy,
this new feature is used when the kernel memory allocater accesses
task->mempolicy.

I'll rewrite the changelog in the next version of the patch if I still
use this flag.

>> +int cpuset_mems_allowed_intersects(struct task_struct *tsk1,
>> +				   struct task_struct *tsk2)
>>  {
>> -	return nodes_intersects(tsk1->mems_allowed, tsk2->mems_allowed);
>> +	unsigned long flags1, flags2;
>> +	int retval;
>> +
>> +	read_mem_lock_irqsave(tsk1, flags1);
>> +	read_mem_lock_irqsave(tsk2, flags2);
>> +	retval = nodes_intersects(tsk1->mems_allowed, tsk2->mems_allowed);
>> +	read_mem_unlock_irqrestore(tsk2, flags2);
>> +	read_mem_unlock_irqrestore(tsk1, flags1);
> 
> I suspect this is deadlockable in sufficiently arcane circumstances:
> one task takes the locks in a,b order, another task takes them in b,a
> order and a third task gets in at the right time and does a
> write_lock().  Probably that's not possible for some reason, dunno.  The usual
> way of solving this is to always take the locks in
> sorted-by-ascending-virtual-address order.

Don't worry about this problem, because rwlock is read_preference lock.

But your advice is very good, I'll change it in the next version of the patch.

Thanks!

> 
> 
> 
> 
> 


