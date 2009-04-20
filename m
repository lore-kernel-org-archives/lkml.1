Return-Path: <linux-kernel-owner+w=401wt.eu-S1755826AbZDTS0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826AbZDTS0g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 14:26:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754340AbZDTS0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 14:26:23 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:44030 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229AbZDTS0V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 14:26:21 -0400
Message-ID: <49ECBE0A.7010303@cosmosbay.com>
Date: Mon, 20 Apr 2009 20:25:14 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@vyatta.com>
CC: paulmck@linux.vnet.ibm.com, Evgeniy Polyakov <zbr@ioremap.net>,
       David Miller <davem@davemloft.net>, kaber@trash.net,
       torvalds@linux-foundation.org, jeff.chua.linux@gmail.com,
       paulus@samba.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       jengelh@medozas.de, r000n@r000n.net, linux-kernel@vger.kernel.org,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
       benh@kernel.crashing.org, mathieu.desnoyers@polymtl.ca
Subject: Re: [PATCH] netfilter: use per-cpu recursive lock (v10)
References: <20090415170111.6e1ca264@nehalam>	<alpine.LFD.2.00.0904151705120.4042@localhost.localdomain>	<49E72E83.50702@trash.net>	<20090416.153354.170676392.davem@davemloft.net>	<20090416234955.GL6924@linux.vnet.ibm.com>	<20090417012812.GA25534@linux.vnet.ibm.com>	<20090418094001.GA2369@ioremap.net>	<20090418141455.GA7082@linux.vnet.ibm.com> <20090420103414.1b4c490f@nehalam>
In-Reply-To: <20090420103414.1b4c490f@nehalam>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Mon, 20 Apr 2009 20:25:15 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger a écrit :
> This version of x_tables (ip/ip6/arp) locking uses a per-cpu
> recursive lock that can be nested. It is sort of like existing kernel_lock,
> rwlock_t and even old 2.4 brlock.
> 
> "Reader" is ip/arp/ip6 tables rule processing which runs per-cpu.
> It needs to ensure that the rules are not being changed while packet
> is being processed.
> 
> "Writer" is used in two cases: first is replacing rules in which case
> all packets in flight have to be processed before rules are swapped,
> then counters are read from the old (stale) info. Second case is where
> counters need to be read on the fly, in this case all CPU's are blocked
> from further rule processing until values are aggregated.
> 
> The idea for this came from an earlier version done by Eric Dumazet.
> Locking is done per-cpu, the fast path locks on the current cpu
> and updates counters.  This reduces the contention of a
> single reader lock (in 2.6.29) without the delay of synchronize_net()
> (in 2.6.30-rc2). 
> 
> The mutex that was added for 2.6.30 in xt_table is unnecessary since
> there already is a mutex for xt[af].mutex that is held.
> 
> Signed-off-by: Stephen Hemminger <shemminger@vyatta.com
> 
> ---
> Changes from earlier patches.
>   - function name changes
>   - disable bottom half in info_rdlock

OK, but we still have a problem on machines with >= 250 cpus,
because calling 250 times spin_lock() is going to overflow preempt_count,
as each spin_lock() increases preempt_count by one.

PREEMPT_MASK: 0x000000ff

add_preempt_count() should warn us about this overflow if CONFIG_DEBUG_PREEMPT is set

#ifdef CONFIG_DEBUG_PREEMPT
        /*
         * Spinlock count overflowing soon?
         */
        DEBUG_LOCKS_WARN_ON((preempt_count() & PREEMPT_MASK) >=
                                PREEMPT_MASK - 10);
#endif


My suggestion (in a previous mail) was to call preempt_disable() after each spin_lock(),
and of course doing the reverse on unlock path.


> +/**
> + * xt_info_wrlock_bh - lock xt table info for update
> + *
> + * Locks out all readers, and blocks bottom half
> + */
> +void xt_info_wrlock_bh(void)
> +{
> +	int i;
> +
> +	local_bh_disable();
 
/* at this point , preemption is disabled... */


> +	for_each_possible_cpu(i) {
> +		struct xt_info_lock *lock = &per_cpu(xt_info_locks, i);
> +		spin_lock(&lock->lock);
	
		preempt_enable(); /* avoid preempt count overflow */
		
> +		BUG_ON(lock->depth != -1);
> +	}
> +}
> +EXPORT_SYMBOL_GPL(xt_info_wrlock_bh);
> +
> +/**
> + * xt_info_wrunlock_bh - lock xt table info for update
> + *
> + * Unlocks all readers, and unblocks bottom half
> + */
> +void xt_info_wrunlock_bh(void) __releases(&lock->lock)
> +{
> +	int i;
> +
> +	for_each_possible_cpu(i) {
> +		struct xt_info_lock *lock = &per_cpu(xt_info_locks, i);
> +		BUG_ON(lock->depth != -1);

		preempt_disable() /* restore preempt count lowered in xt_info_wrlock_bh */

> +		spin_unlock(&lock->lock);
> +	}
> +	local_bh_enable();
> +}
> +EXPORT_SYMBOL_GPL(xt_info_wrunlock_bh);

