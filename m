Return-Path: <linux-kernel-owner+w=401wt.eu-S1754540AbZDPNxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540AbZDPNxh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 09:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753079AbZDPNxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 09:53:22 -0400
Received: from stinky.trash.net ([213.144.137.162]:57048 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282AbZDPNxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 09:53:21 -0400
Message-ID: <49E7384B.5020707@trash.net>
Date: Thu, 16 Apr 2009 15:53:15 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: Stephen Hemminger <shemminger@vyatta.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, jeff.chua.linux@gmail.com,
       paulmck@linux.vnet.ibm.com, paulus@samba.org, mingo@elte.hu,
       laijs@cn.fujitsu.com, jengelh@medozas.de, r000n@r000n.net,
       linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
       netdev@vger.kernel.org, benh@kernel.crashing.org
Subject: Re: [PATCH] netfilter: use per-cpu spinlock and RCU (v5)
References: <49E5BDF7.8090502@trash.net>	<20090415135526.2afc4d18@nehalam>	<49E64C91.5020708@cosmosbay.com>	<20090415.164811.19905145.davem@davemloft.net>	<20090415170111.6e1ca264@nehalam>	<alpine.LFD.2.00.0904151705120.4042@localhost.localdomain> <20090415174551.529d241c@nehalam> <49E6BBA9.2030701@cosmosbay.com>
In-Reply-To: <49E6BBA9.2030701@cosmosbay.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
> Stephen Hemminger a écrit :
>> This is an alternative version of ip/ip6/arp tables locking using
>> per-cpu locks.  This avoids the overhead of synchronize_net() during
>> update but still removes the expensive rwlock in earlier versions.
>>
>> The idea for this came from an earlier version done by Eric Dumazet.
>> Locking is done per-cpu, the fast path locks on the current cpu
>> and updates counters.  The slow case involves acquiring the locks on
>> all cpu's. This version uses RCU for the table->base reference
>> but per-cpu-lock for counters.

> This version is a regression over 2.6.2[0-9], because of two points
> 
> 1) Much more atomic ops :
> 
> Because of additional
> 
>> +			spin_lock(&__get_cpu_var(ip_tables_lock));
>>  			ADD_COUNTER(e->counters, ntohs(ip->tot_len), 1);
>> +			spin_unlock(&__get_cpu_var(ip_tables_lock));
> 
> added on each counter updates.
> 
> On many setups, each packet coming in or out of the machine has
> to update between 2 to 20 rule counters. So to avoid *one* atomic ops
> of read_unlock(), this v4 version adds 2 to 20 atomic ops...

I agree, this seems to be a step backwards.

> I still not see the problem between the previous version (2.6.2[0-8]) that had a central
>  rwlock, that hurted performance on SMP because of cache line ping pong, and the solution
> having one rwlock per cpu.
> 
> We wanted to reduce the cache line ping pong first. This *is* the hurting point,
> by an order of magnitude.

Dave doesn't seem to like the rwlock approach. I don't see a way to
do anything asynchronously like call_rcu() to improve this, so to
bring up one of Stephens suggestions again:

>> >   * use on_each_cpu() somehow to do grace periood?

We could use this to replace the counters, presuming it is
indeed faster than waiting for a RCU grace period.

> 2) Second problem : Potential OOM
> 
> About freeing old rules with call_rcu() and/or schedule_work(), this is going
> to OOM pretty fast on small appliances with basic firewall setups loading
> rules one by one, as done by original topic reporter.
> 
> We had reports from guys using linux with 4MB of available ram (French provider free.fr on
> their applicance box), and we had to use SLAB_DESTROY_BY_RCU thing on conntrack
>  to avoid OOM for their setups. We dont want to use call_rcu() and queue 100 or 200 vfree().

Agreed.
