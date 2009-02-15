Return-Path: <linux-kernel-owner+w=401wt.eu-S1755391AbZBOWsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391AbZBOWsy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 17:48:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752960AbZBOWsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 17:48:45 -0500
Received: from gw.goop.org ([64.81.55.164]:42225 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752443AbZBOWsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 17:48:45 -0500
Message-ID: <49989BCA.9090606@goop.org>
Date: Sun, 15 Feb 2009 14:48:42 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       hpa <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: x86: unify genapic code, unify subarchitectures, remove	old	subarchitecture
 code
References: <1234102566.4244.7.camel@localhost.localdomain>	 <498F0ED9.1080906@goop.org> <1234719693.3299.7.camel@localhost.localdomain>
In-Reply-To: <1234719693.3299.7.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> Agree this is a nasty problem.   However, I can't see any reason why
> smp_call_function_many() needs to allocate in the wait case ... and the
> tlb flushing code would be using the wait case.  What about this fix to
> the generic SMP code (cc'd Jens) that would allow us to take on stack
> data and the fast path all the time?
>   

That's how it used to be, but there's a subtle race.  When using 
allocated list elements, the lifetime of the allocated blocks is managed 
via rcu.  When an element is deleted with list_del_rcu(), another cpu 
can still be using its ->next pointer, and so the memory for that list 
entry can't be freed early.  If it is stack-allocated, then the memory 
will get re-allocated when the calling function returns, which will 
trash the ->next pointer that another cpu is still relying on.

> By the way, I can see us building up stack runoff danger for the large
> CPU machines, so the on stack piece could be limited to a maximal CPU
> cap beyond which it has to kmalloc ... the large CPU machines would
> still probably pick up scaling benefits in that case ... thoughts?
>   

It looks like Peter Z just posted some patches to remove kmalloc from 
this path ("generic smp helpers vs kmalloc").  Ah, he's addressed the 
point above:

    Also, since we cannot simply remove an item from the global queue
    (another
    cpu might be observing it), a quiesence of sorts needs to be
    observed. The
    current code uses regular RCU for that purpose.

    However, since we'll be wanting to quickly reuse an item, we need
    something
    with a much faster turn-around. We do this by simply observing the
    global
    queue quiesence. Since there are a limited number of elements, it
    will auto
    force a quiecent state if we wait for it.

(Haven't read the patches in detail yet.)

> Yes ... will do.  If we can't make the unified non-IPI version work fast
> enough, then both of us can share the call function version.
>   

Xen does cross-cpu tlb flush via hypercall, because Xen knows which real 
CPUs (if any) have stale  vcpu tlb state (there's no point scheduling a 
non-running vcpu just to flush its tlb).

    J


> -	data = kmalloc(sizeof(*data) + cpumask_size(), GFP_ATOMIC);
> +	if (wait)
> +		data = &stack_data.d;
> +	else
> +		data = kmalloc(sizeof(*data) + cpumask_size(), GFP_ATOMIC);
>   
You're still leaving CSD_FLAG_ALLOC set?

>  	if (unlikely(!data)) {
>  		/* Slow path. */
>  		for_each_online_cpu(cpu) {
>
>   

