Return-Path: <linux-kernel-owner+w=401wt.eu-S1751932AbZDUI6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932AbZDUI6X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 04:58:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752777AbZDUI6A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 04:58:00 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:39079 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbZDUI57 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 04:57:59 -0400
Message-ID: <49ED8A1F.7090506@cosmosbay.com>
Date: Tue, 21 Apr 2009 10:55:59 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Evgeniy Polyakov <zbr@ioremap.net>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Paul Mackerras <paulus@samba.org>, paulmck@linux.vnet.ibm.com,
       David Miller <davem@davemloft.net>, kaber@trash.net,
       torvalds@linux-foundation.org, jeff.chua.linux@gmail.com, mingo@elte.hu,
       jengelh@medozas.de, r000n@r000n.net, linux-kernel@vger.kernel.org,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
       benh@kernel.crashing.org, mathieu.desnoyers@polymtl.ca
Subject: Re: [PATCH] netfilter: use per-cpu recursive lock (v11)
References: <49ECBE0A.7010303@cosmosbay.com> <18924.59347.375292.102385@cargo.ozlabs.ibm.com> <20090420215827.GK6822@linux.vnet.ibm.com> <18924.64032.103954.171918@cargo.ozlabs.ibm.com> <20090420160121.268a8226@nehalam> <49ED406F.2040401@cn.fujitsu.com> <49ED4407.8010200@cosmosbay.com> <49ED5813.1000803@cn.fujitsu.com> <20090420224540.30d7b0ed@nehalam> <49ED6D2E.5060808@cn.fujitsu.com> <20090421081649.GA16782@ioremap.net>
In-Reply-To: <20090421081649.GA16782@ioremap.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 21 Apr 2009 10:55:59 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Evgeniy Polyakov a écrit :
> Hi.
> 
> On Tue, Apr 21, 2009 at 02:52:30PM +0800, Lai Jiangshan (laijs@cn.fujitsu.com) wrote:
>>> +void xt_info_rdlock_bh(void)
>>>> +{
>>>> +	struct xt_info_lock *lock;
>>>> +
>>>> +	preempt_disable();
>>>> +	lock = &__get_cpu_var(xt_info_locks);
>>>> +	if (likely(++lock->depth == 0))
>> So what happen when xt_info_rdlock_bh() called recursively here?
>>
>>>> +		spin_lock_bh(&lock->lock);
>>>> +	preempt_enable_no_resched();
>>>> +}
>>>> +EXPORT_SYMBOL_GPL(xt_info_rdlock_bh);
>>>> +
>> ----------
>> Is this OK? (Now I suppose we can enter the read-side critical region
>> in irq context)
>>
>> void xt_info_rdlock_bh(void)
>> {
>> 	unsigned long flags;
>> 	struct xt_info_lock *lock;
>>
>> 	local_irq_save(flags);
>> 	lock = &__get_cpu_var(xt_info_locks);
>> 	if (likely(++lock->depth == 0))
>> 		spin_lock_bh(&lock->lock);
>> 	local_irq_restore(flags);
>> }
> 
> Netfilter as long as other generic network pathes are never accessed
> from interrupt context, but your analysis looks right for the softirq
> case.
> 
> Stephen, should preempt_disable() be replaced with local_bh_disable() to
> prevent softirq to race on the same cpu for the lock's depth field? Or
> can it be made atomic?
> 


Maybe just dont care about calling several time local_bh_disable()
(since we were doing this in previous kernels anyway, we used to call read_lock_bh())

This shortens fastpath, is faster than local_irq_save()/local_irq_restore(),
and looks better.

void xt_info_rdlock_bh(void)
{
	struct xt_info_lock *lock;

	local_bh_disable();
 	lock = &__get_cpu_var(xt_info_locks);
 	if (likely(++lock->depth == 0))
 		spin_lock(&lock->lock);
}

void xt_info_rdunlock_bh(void)
{
	struct xt_info_lock *lock = &__get_cpu_var(xt_info_locks);

	BUG_ON(lock->depth < 0);
	if (likely(--lock->depth < 0))
		 spin_unlock(&lock->lock);
	local_bh_enable();
}



