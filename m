Return-Path: <linux-kernel-owner+w=401wt.eu-S1758766AbZDQGEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758766AbZDQGEi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 02:04:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752944AbZDQGEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 02:04:25 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:38771 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483AbZDQGEX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 02:04:23 -0400
Message-ID: <49E81B9D.3030807@cosmosbay.com>
Date: Fri, 17 Apr 2009 08:03:09 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@vyatta.com>
CC: paulmck@linux.vnet.ibm.com, David Miller <davem@davemloft.net>,
       kaber@trash.net, torvalds@linux-foundation.org,
       jeff.chua.linux@gmail.com, paulus@samba.org, mingo@elte.hu,
       laijs@cn.fujitsu.com, jengelh@medozas.de, r000n@r000n.net,
       linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
       netdev@vger.kernel.org, benh@kernel.crashing.org
Subject: Re: [PATCH] netfilter: per-cpu spin-lock with recursion (v0.8)
References: <20090415170111.6e1ca264@nehalam>	<alpine.LFD.2.00.0904151705120.4042@localhost.localdomain>	<49E72E83.50702@trash.net>	<20090416.153354.170676392.davem@davemloft.net>	<20090416234955.GL6924@linux.vnet.ibm.com> <20090416165233.5d8bbfb5@nehalam>
In-Reply-To: <20090416165233.5d8bbfb5@nehalam>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Fri, 17 Apr 2009 08:03:11 +0200 (CEST)
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
> 
> The mutex that was added for 2.6.30 in xt_table is unnecessary since
> there already is a mutex for xt[af].mutex that is held.
> 
> Future optimizations possible:
>   - Lockdep doesn't really handle this well
>   - hot plug CPU case, if kernel is built with large # of CPU's, skip
>     the inactive ones; migrate values when CPU is removed.
>   - reading counters could be incremental by CPU.
> 
> Signed-off-by: Stephen Hemminger <shemminger@vyatta.com
> 

I like this version 8 of the patch, as it mixes all ideas we had,
but have two questions.

Previous netfilter code (and 2.6.30-rc2 one too) disable BH, not only preemption.

I see xt_table_info_lock_all(void) does block BH, so this one is safe.

I let Patrick or other tell us if its safe to run ipt_do_table()
with preemption disabled but BH enabled, I really dont know.

Also, please dont call this a 'recursive lock', since it is not a general
recursive lock, as pointed by Linus and Paul.

Second question is about MAX_LOCK_DEPTH

Why dont use this kind of construct to get rid of this limit ?

+void xt_table_info_lock_all(void)
> +{
> +	int i;
> +
> +	local_bh_disable();
> +	for_each_possible_cpu(i) {
> +		struct xt_lock *lock = &per_cpu(xt_info_locks, i);
> +		spin_lock(&lock->lock);
> +		preempt_enable_no_resched();
> +	}
> +}
> +EXPORT_SYMBOL_GPL(xt_table_info_lock_all);

