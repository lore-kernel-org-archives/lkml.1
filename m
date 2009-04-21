Return-Path: <linux-kernel-owner+w=401wt.eu-S1755524AbZDUJh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524AbZDUJh0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 05:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752915AbZDUJhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 05:37:07 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63859 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751644AbZDUJhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 05:37:05 -0400
Message-ID: <49ED932C.4070709@cn.fujitsu.com>
Date: Tue, 21 Apr 2009 17:34:36 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: Evgeniy Polyakov <zbr@ioremap.net>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Paul Mackerras <paulus@samba.org>, paulmck@linux.vnet.ibm.com,
       David Miller <davem@davemloft.net>, kaber@trash.net,
       torvalds@linux-foundation.org, jeff.chua.linux@gmail.com, mingo@elte.hu,
       jengelh@medozas.de, r000n@r000n.net, linux-kernel@vger.kernel.org,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
       benh@kernel.crashing.org, mathieu.desnoyers@polymtl.ca
Subject: Re: [PATCH] netfilter: use per-cpu recursive lock (v11)
References: <49ECBE0A.7010303@cosmosbay.com> <18924.59347.375292.102385@cargo.ozlabs.ibm.com> <20090420215827.GK6822@linux.vnet.ibm.com> <18924.64032.103954.171918@cargo.ozlabs.ibm.com> <20090420160121.268a8226@nehalam> <49ED406F.2040401@cn.fujitsu.com> <49ED4407.8010200@cosmosbay.com> <49ED5813.1000803@cn.fujitsu.com> <20090420224540.30d7b0ed@nehalam> <49ED6D2E.5060808@cn.fujitsu.com> <20090421081649.GA16782@ioremap.net> <49ED8A1F.7090506@cosmosbay.com>
In-Reply-To: <49ED8A1F.7090506@cosmosbay.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
> Evgeniy Polyakov a écrit :
>> Hi.
>>
>> On Tue, Apr 21, 2009 at 02:52:30PM +0800, Lai Jiangshan (laijs@cn.fujitsu.com) wrote:
>>>> +void xt_info_rdlock_bh(void)
>>>>> +{
>>>>> +	struct xt_info_lock *lock;
>>>>> +
>>>>> +	preempt_disable();
>>>>> +	lock = &__get_cpu_var(xt_info_locks);
>>>>> +	if (likely(++lock->depth == 0))
>>> So what happen when xt_info_rdlock_bh() called recursively here?
>>>
>>>>> +		spin_lock_bh(&lock->lock);
>>>>> +	preempt_enable_no_resched();
>>>>> +}
>>>>> +EXPORT_SYMBOL_GPL(xt_info_rdlock_bh);
>>>>> +
>>> ----------
>>> Is this OK? (Now I suppose we can enter the read-side critical region
>>> in irq context)
>>>
>>> void xt_info_rdlock_bh(void)
>>> {
>>> 	unsigned long flags;
>>> 	struct xt_info_lock *lock;
>>>
>>> 	local_irq_save(flags);
>>> 	lock = &__get_cpu_var(xt_info_locks);
>>> 	if (likely(++lock->depth == 0))
>>> 		spin_lock_bh(&lock->lock);
>>> 	local_irq_restore(flags);
>>> }
>> Netfilter as long as other generic network pathes are never accessed
>> from interrupt context, but your analysis looks right for the softirq
>> case.
>>
>> Stephen, should preempt_disable() be replaced with local_bh_disable() to
>> prevent softirq to race on the same cpu for the lock's depth field? Or
>> can it be made atomic?
>>
> 
> 
> Maybe just dont care about calling several time local_bh_disable()
> (since we were doing this in previous kernels anyway, we used to call read_lock_bh())
> 
> This shortens fastpath, is faster than local_irq_save()/local_irq_restore(),
> and looks better.
> 
> void xt_info_rdlock_bh(void)
> {
> 	struct xt_info_lock *lock;
> 
> 	local_bh_disable();
>  	lock = &__get_cpu_var(xt_info_locks);
>  	if (likely(++lock->depth == 0))
>  		spin_lock(&lock->lock);
> }

This two functions is OK. But...

> 
> void xt_info_rdunlock_bh(void)
> {
> 	struct xt_info_lock *lock = &__get_cpu_var(xt_info_locks);
> 
> 	BUG_ON(lock->depth < 0);
> 	if (likely(--lock->depth < 0))
> 		 spin_unlock(&lock->lock);
> 	local_bh_enable();
> }
> 
> 


David said:
Netfilter itself, is nesting.

When using bridging netfilter, iptables can be entered twice
in the same call chain.

And Stephen said:
In this version, I was trying to use/preserve the optimizations that
are done in spin_unlock_bh().

So:

void xt_info_rdlock_bh(void)
{
	struct xt_info_lock *lock;

	preempt_disable();
 	lock = &__get_cpu_var(xt_info_locks);
 	if (likely(lock->depth < 0))
 		spin_lock_bh(&lock->lock);
	/* softirq is disabled now */
	++lock->depth;
	preempt_enable_no_resched();
}

xt_info_rdunlock_bh() is the same as v11.

