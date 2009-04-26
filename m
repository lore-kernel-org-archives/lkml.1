Return-Path: <linux-kernel-owner+w=401wt.eu-S1756094AbZDZU56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094AbZDZU56 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 16:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752498AbZDZU5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 16:57:45 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:49457 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbZDZU5n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 16:57:43 -0400
Message-ID: <49F4CA55.8020705@cosmosbay.com>
Date: Sun, 26 Apr 2009 22:55:49 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Stephen Hemminger <shemminger@vyatta.com>,
       David Miller <davem@davemloft.net>, Jarek Poplawski <jarkao2@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       paulmck@linux.vnet.ibm.com, Evgeniy Polyakov <zbr@ioremap.net>,
       kaber@trash.net, jeff.chua.linux@gmail.com, laijs@cn.fujitsu.com,
       jengelh@medozas.de, r000n@r000n.net, linux-kernel@vger.kernel.org,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
       benh@kernel.crashing.org
Subject: Re: [PATCH] netfilter: use per-CPU recursive lock {XV}
References: <20090421111541.228e977a@nehalam> <20090421193924.GA24404@elte.hu> <20090421143927.52d7d89d@nehalam> <alpine.LFD.2.00.0904220821240.3101@localhost.localdomain> <20090423210938.1501507b@nehalam> <49F146FF.5050200@cosmosbay.com> <20090424091839.6e13ebec@nehalam> <49F22465.80305@gmail.com> <20090425133052.4cb711f5@nehalam> <49F4A6E3.7080102@cosmosbay.com> <20090426193135.GA30851@Krystal>
In-Reply-To: <20090426193135.GA30851@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Sun, 26 Apr 2009 22:55:51 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers a écrit :
> * Eric Dumazet (dada1@cosmosbay.com) wrote:
>> From: Stephen Hemminger <shemminger@vyatta.com>
>>
>>> Epilogue due to master Jarek. Lockdep carest not about the locking
>>> doth bestowed. Therefore no keys are needed.
>>>
>>> Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
>> So far, so good, should be ready for inclusion now, nobody complained :)
>>
>> I include the final patch, merge of your last two patches.
>>
>> David, could you please review it once again and apply it if it's OK ?
>>
> [...]
>> +/*
>> + * Per-CPU read/write lock associated with per-cpu table entries.
>> + * This is not a general solution but makes reader locking fast since
>> + * there is no shared variable to cause cache ping-pong; but adds an
>> + * additional write-side penalty since update must lock all
>> + * possible CPU's.
>> + *
>> + * Read lock is used by ip/arp/ip6 tables rule processing which runs per-cpu.
>> + * It needs to ensure that the rules are not being changed while packet
>> + * is being processed. In some cases, the read lock will be acquired
>> + * twice on the same CPU; this is okay because read locks handle nesting.
>> + *
>> + * Write lock is used in two cases:
>> + *    1. reading counter values
>> + *       all readers need to be stopped and the per-CPU values are summed.
>> + *
>> + *    2. replacing tables
>> + *       any readers that are using the old tables have to complete
>> + *       before freeing the old table. This is handled by reading
>> + *	  as a side effect of reading counters
>> + */
>> +DECLARE_PER_CPU(rwlock_t, xt_info_locks);
>> +
>> +static inline void xt_info_rdlock_bh(void)
>> +{
>> +	/*
>> +	 * Note: can not use read_lock_bh(&__get_cpu_var(xt_info_locks))
>> +	 * because need to ensure that preemption is disable before
>> +	 * acquiring per-cpu-variable, so do it as a two step process
>> +	 */
>> +	local_bh_disable();
> 
> Why do you need to disable bottom halves on the read-side ? You could
> probably just disable preemption, given this lock is nestable on the
> read-side anyway. Or I'm missing something obvious ?

It may not be obvious, but subject already raised on this list, so I'll
try to be as precise as possible (But may be wrong on some points, I'll
let Patrick correct me if necessary)

ipt_do_table() is not a readonly function returning a verdict.

1) It handles a stack (check how is used next->comefrom) that seems to
be stored on rules themselves. (This is how I understand this code)
This is safe as each cpu has its own copy of rules/counters, and BH protected.

2) It also updates two 64 bit counters (bytes/packets) on each matched rule.

3) Some netfilter matches/targets probably rely on the fact their handlers
are run with BH disabled by their caller (ipt_do_table()/arp/ip6...)

These must be BH protected (and preempt disabled too), or else :

1) A softirq could interrupt a process in the middle of ipt_do_table()
and corrupt its "stack".

2) A softirq could interrupt a process in ipt_do_table() in the middle
 of the ADD_COUNTER(). Some counters could be corrupted.

3) Some netfiler extensions would break.

Previous linux versions already used a read_lock_bh() here, on a single
and shared rwlock, there is nothing new on this BH locking AFAIK.

Thank you

