Return-Path: <linux-kernel-owner+w=401wt.eu-S1757000AbYLLIXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757000AbYLLIXs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 03:23:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750870AbYLLIXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 03:23:37 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:36419 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbYLLIXg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 03:23:36 -0500
Message-ID: <49421F62.8000401@cosmosbay.com>
Date: Fri, 12 Dec 2008 09:22:58 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Theodore Tso <tytso@mit.edu>,
       linux kernel <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>, Mingming Cao <cmm@us.ibm.com>,
       linux-ext4@vger.kernel.org, Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH] percpu_counter: Fix __percpu_counter_sum()
References: <4936D287.6090206@cosmosbay.com> <20081209214921.b3944687.akpm@linux-foundation.org> <49404925.7090902@cosmosbay.com> <200812121847.06432.rusty@rustcorp.com.au>
In-Reply-To: <200812121847.06432.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Fri, 12 Dec 2008 09:22:58 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell a écrit :
> On Thursday 11 December 2008 09:26:37 Eric Dumazet wrote:
>> But then, some (all but x86 ;) ) arches dont have true local_t and we fallback
>> to plain atomic_long_t, and this is wrong because it would add a LOCKED
>> instruction in fast path.
>>
>> I remember Christoph added FAST_CMPXCHG_LOCAL, but no more uses of it in current
>> tree.
>>
>> Ie : using local_t only if CONFIG_FAST_CMPXCHG_LOCAL, else something like :
>>
>> void __percpu_counter_add_irqsafe(struct percpu_counter *fbc, s64 amount, s32 batch)
>> {
>>         s64 count;
>>         s32 *pcount = per_cpu_ptr(fbc->counters, get_cpu());
>>         unsigned long flags;
>>
>>         local_irq_save(flags);
>>         count = *pcount + amount;
> 
> This is dumb though.  If local_irq_save(), add, local_irq_restore() is faster
> than atomic_long_add on some arch, *that* is what that arch's local_add()
> should do!
> 
> Open coding it like this is obviously wrong.

Hum... so you vote for using local_t instead of s32 then ?

> 
> Now, archs local.h need attention (x86-32 can be optimized today, for
> example), but that's not directly related.
> 
> Hope that clarifies,
> Rusty.
> PS.  Yes, I should produce a documentation patch and fix the x86 version.
> Added to TODO list.
> 

Thanks


