Return-Path: <linux-kernel-owner+w=401wt.eu-S1764149AbXFSS4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764149AbXFSS4t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 14:56:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763783AbXFSS4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 14:56:42 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:56125 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763781AbXFSS4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 14:56:41 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: Device hang when offlining a CPU due to IRQ misrouting
References: <20070605235707.GB16074@tree.beaverton.ibm.com>
	<20070606013759.GI17143@linux-os.sc.intel.com>
	<20070606185829.GA26062@tree.beaverton.ibm.com>
	<20070606193514.GN17143@linux-os.sc.intel.com>
	<20070606231642.GH13751@tree.beaverton.ibm.com>
	<20070608005726.GO17143@linux-os.sc.intel.com>
	<20070618223819.GD9751@tree.beaverton.ibm.com>
	<20070618235434.GB7160@linux-os.sc.intel.com>
	<20070619005136.GF9751@tree.beaverton.ibm.com>
	<m1sl8nn82i.fsf@ebiederm.dsl.xmission.com>
	<20070619180003.GE7160@linux-os.sc.intel.com>
Date: Tue, 19 Jun 2007 12:55:28 -0600
In-Reply-To: <20070619180003.GE7160@linux-os.sc.intel.com> (Suresh B. Siddha's
	message of "Tue, 19 Jun 2007 11:00:03 -0700")
Message-ID: <m1myyvn59b.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Siddha, Suresh B" <suresh.b.siddha@intel.com> writes:

> On Tue, Jun 19, 2007 at 11:54:45AM -0600, Eric W. Biederman wrote:
>> "Darrick J. Wong" <djwong@us.ibm.com> writes:
>> 
>> > On Mon, Jun 18, 2007 at 04:54:34PM -0700, Siddha, Suresh B wrote:
>> >
>> >> > <call to set_affinity>
>> >> > [  256.298787] irq=4341 affinity=d
>> >> > <ethernet on irq 4341 stops working>
>> >> 
>> >> And just to make sure, at this point, your MSI irq 4341 affinity
>> >> (/proc/irq/4341/smp_affinity) still points to '2'?
>> >
>> > Actually, it's 0xD.  From the kernel's perspective the mask has been
>> > updated (and I even stuck a printk into set_msi_irq_affinity to verify
>> > that the writes are happening) but ... the hardware doesn't seem to
>> > reflect this.  I also tried putting read_msi_msg right afterwards to
>> > compare contents, though it complained about all the MSIs _except_ for
>> > 4341.  (Of course, I could just be way off on the effectiveness of
>> > that.)
>> 
>> The fact that MSI interrupts are having problems is odd.  It is possible
>> that we still have a bug in there somewhere but msi interrupts should
>> be safe to migrate outside of irq context (no known hardware bugs).
>> As we can actually synchronize with the irq source and eliminate all
>> of the migration races.
>> 
>> The non-msi case requires hitting a hardware race that is rare enough
>> you should not normally have problems.
>
> Yep. But Darrick's seems to say, problem happens consistently.
>
> Anyhow, Darrick there is a general bug in this area, can you try this and
> see if it helps?

There are several general bugs in this area.  But yes your patch
should help things, especially for MSI where masking the irq before
migration is required.  Adding locking the proper locking and masking
should make things quite a bit more how set_affinity is expected to be
called.

I just gave up on fixing these things because we can't eliminate
the races, so the real problem is the existence of this code path
with it's unsupportable semantics in the first place.

> diff --git a/arch/x86_64/kernel/irq.c b/arch/x86_64/kernel/irq.c
> index 3eaceac..a0e11c9 100644
> --- a/arch/x86_64/kernel/irq.c
> +++ b/arch/x86_64/kernel/irq.c
> @@ -144,17 +144,35 @@ void fixup_irqs(cpumask_t map)
>  
>  	for (irq = 0; irq < NR_IRQS; irq++) {
>  		cpumask_t mask;
> +		int break_affinity = 0;
> +		int set_affinity = 1;
> +
>  		if (irq == 2)
>  			continue;
>  
> +		/* irq's are disabled at this point */
> +		spin_lock(&irq_desc[irq].lock);
> +
>  		cpus_and(mask, irq_desc[irq].affinity, map);
>  		if (any_online_cpu(mask) == NR_CPUS) {
> -			printk("Breaking affinity for irq %i\n", irq);
> +			break_affinity = 1;
>  			mask = map;
>  		}

We should really express the "any_online_cpu(mask) == NR_CPUS" test as:
"cpus_empty(mask)" it would be much clearer.

Further we should skip the migration if "cpus_equal(mask,
irq_desc[irq].affinity)" or "!irq_has_action(irq)" because no one has
called request_irq.


> +		irq_desc[irq].chip->mask(irq);
> +
>  		if (irq_desc[irq].chip->set_affinity)
>  			irq_desc[irq].chip->set_affinity(irq, mask);
>  		else if (irq_desc[irq].action && !(warned++))
> +			set_affinity = 0;
> +
> +		irq_desc[irq].chip->unmask(irq);
> +
> +		spin_unlock(&irq_desc[irq].lock);
> +
> +		if (break_affinity && set_affinity)
> +			printk("Broke affinity for irq %i\n", irq);
> +		else if (!set_affinity)
>  			printk("Cannot set affinity for irq %i\n", irq);
>  	}
>  
