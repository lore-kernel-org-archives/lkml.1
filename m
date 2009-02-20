Return-Path: <linux-kernel-owner+w=401wt.eu-S1755910AbZBTXvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910AbZBTXvf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 18:51:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754044AbZBTXv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 18:51:27 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:52118 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016AbZBTXv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 18:51:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GrFfgCx1/Ja8U78p4xJKpz66Lb3RJpDQpOqzBaCb7Bw9JHJSNjO4YSrE6kGWbMCS0L
         dZPPuCXGrRZ76OEE5f2BVc0oL1vhJqL7qoqoSO/2es55mgSy/O1Aqfrr8/7xZFHAXadI
         hM79ups7DPrb9rT6szZKQM8EZCR8ZPrgzTiuI=
MIME-Version: 1.0
In-Reply-To: <20090220154619.GC6960@linux.vnet.ibm.com>
References: <20090220134121.GA19575@damson.getinternet.no>
	 <20090220135000.GA9616@elte.hu> <20090220140157.GA12799@elte.hu>
	 <19f34abd0902200651k7e86aebay5398ef5ac0578561@mail.gmail.com>
	 <20090220154619.GC6960@linux.vnet.ibm.com>
Date: Sat, 21 Feb 2009 00:51:23 +0100
Message-ID: <19f34abd0902201551o65a3650egf29d81e8b6823d67@mail.gmail.com>
Subject: Re: [PATCH] mm: fix lazy vmap purging (use-after-free error)
From: Vegard Nossum <vegard.nossum@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Ingo Molnar <mingo@elte.hu>, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/2/20 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
> On Fri, Feb 20, 2009 at 03:51:28PM +0100, Vegard Nossum wrote:
>>
>> I added some printks to __free_vmap_area() and rcu_free_va(), and it
>> shows that the kfree() is being called immediately (inside the list
>> traversal). So the call_rcu() is happening immediately (or almost
>> immediately).
>>
>> If I've understood correctly, the RCU processing can happen inside a
>> spinlock, as long as interrupts are enabled. (Won't the timer IRQ
>> trigger softirq processing, which triggers RCU callback processing,
>> for example?)
>>
>> And interrupts are enabled when this happens: EFLAGS: 00000292
>>
>> Please correct me if I am wrong!
>
> If you are using preemptable RCU, and if the read side accesses are not
> protected by rcu_read_lock(), this can happen.  At least for values of
> "immediately" in the millisecond range.
>
> If you were using classic or hierarchical RCU, the fact that the
> call_rcu() is within a spinlock (as opposed to mutex) critical section
> should prevent the grace period from ending.
>
> So, what flavor of RCU were you using?

$ grep RCU .config
# RCU Subsystem
# CONFIG_CLASSIC_RCU is not set
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
# CONFIG_RCU_TRACE is not set
CONFIG_RCU_FANOUT=32
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_PREEMPT_RCU_TRACE is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_CPU_STALL_DETECTOR is not set

And at boot:

[    0.000000] Initializing CPU#0
[    0.000000] Experimental hierarchical RCU implementation.
[    0.000000] Experimental hierarchical RCU init done.

What I did for this list traversal was to put one print-out in front
of the traversal, one after the traversal, one inside (so it would be
called on each iteration), and one in the RCU callback. It looks
something like this:

[  449.670460] __purge_vmap_area_lazy() list:
[  449.671332] __free_vmap_area(c7806a40)
[  449.674736] __free_vmap_area(c7806a80)
[  449.675441] rcu_free_va(c7806a40)
[  449.677407] __free_vmap_area(c7806ac0)
[  449.680113] rcu_free_va(c7806a80)
[  449.682821] __free_vmap_area(c7806b00)
[  449.684264] rcu_free_va(c7806ac0)
[  449.686525] __free_vmap_area(c7806b40)
[  449.688205] rcu_free_va(c7806b00)

...and goes on for a long time, until something triggers this:

[  449.902253] rcu_free_va(c7839d00)
[  449.903247] WARNING: kmemcheck: Caught 32-bit read from freed
memory (c7839d20)

...and finally:

[  457.580253] __purge_vmap_area_lazy() end
[  457.581201] rcu_free_va(c78974c0)

So this is also what I meant by "immediately": The RCU callbacks are
getting called inside the loop, and they're almost always paired with
the list removal, or lagging one object behind.

My guess is that this code posts "too many callbacks", which would
"force the grace period" according to __call_rcu() in
kernel/rcutree.c. What do you think about this?


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
