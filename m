Return-Path: <linux-kernel-owner+w=401wt.eu-S1757200AbYHKT7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200AbYHKT7s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 15:59:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753091AbYHKT7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 15:59:40 -0400
Received: from relay2.sgi.com ([192.48.171.30]:42807 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751586AbYHKT7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 15:59:39 -0400
Message-ID: <48A09ADE.9080004@sgi.com>
Date: Mon, 11 Aug 2008 15:02:38 -0500
From: Alan Mayer <ajm@sgi.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Ingo Molnar <mingo@elte.hu>, jeremy@goop.org, rusty@rustcorp.com.au,
       suresh.b.siddha@intel.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, Dean Nelson <dcn@sgi.com>,
       Cliff Wickman <cpw@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <Yinghai.lu@amd.com>
Subject: Re: [PATCH] x86_64:  (NEW) Dynamically allocate arch specific	system
 vectors
References: <489C6844.9050902@sgi.com> <20080811165930.GI4524@elte.hu>	<48A0737F.9010207@sgi.com> <m1y733mjdh.fsf@frodo.ebiederm.org>
In-Reply-To: <m1y733mjdh.fsf@frodo.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Okay, so we'll wait for Eric to send out his patch and work off that.

Eric W. Biederman wrote:
> Alan Mayer <ajm@sgi.com> writes:
> 
>> Okay, here it is as an attachment.  I think my email client is munging it.
>> I haven't been able to fix it, apparently.
>>
>> I, too, would like to know what Eric thinks.
> 
> I think arch/x86 is about to fall over from accidental complexity of
> the irq handling.  Looking at your problem and the problem of killing
> NR_IRQS I spent way to much time playing with it this weekend then
> I should have, but I think I have found a path that works and is
> fairly easily verifiable.

I quite agree.

> 
> The short version is we make vector_irq the one repository of knowledge
> about what we are doing with vectors.
> 
> We create a common factor of assign_irq_vector that looks something like:
> 
> bool __grab_irq_vector(struct irq_desc *desc, unsigned vector, cpumask_t new_domain)
> {
>         /* Must be called with vector lock */
>         struct irq_cfg *cfg;
>         bool grabbed = false;
>         unsigned int old_vector;
>         cpumask_t mask;
>         int cpu;
> 
>         cfg = get_irqp_cfg(irq);
>         old_vector = cfg->vector;
>         cpus_and(mask, new_domain, cpu_online_map);
> 
>         for_each_cpu_mask_nr(cpu, mask) {
> 		if (per_cpu(vector_irq, cpu)[vector])
>                 	goto out;
>         }
>         /* Available reserve it */
>         for_each_cpu_mask_nr(cpu, mask)
>   	      per_cpu(vector_irq, cpu)[vector] = desc;
>         if (cfg->vector) {
>         	cfg->move_in_progress;
>                 cfg->old_domain = cfg->domain;
>         }
>         cfg->vector = vector;
>         cfg->domain = mask;
>         grabbed = true;
>         
> out:
>         return grabbed;
> }
> 
> Then in your allocator for per cpu irqs you can do:
> spin_lock(&vector_lock);
> for (vector = FIRST_VECTOR; vector != LAST_VECTOR, vector--) {
> 	if (__grab_irq_vector(desc, CPU_MASK_ALL))
>         	goto found;
> }
> spin_unlock(&vector_lock);
> 
> Although I am not at all convinced that dynamic allocation of
> the vector number (instead of statically reserving it makes sense).
> The only way I can see to guarantee all of the special is to
> statically allocate them with a lot of good comments.  I think
> the introduction of system_vectors quite likely defeated the
> errata work around we have the lapic timer in a separate priority.

Our system requires some extra system vectors.  They are meaningless on
other systems.  So, rather than statically allocate them for everyone
or clutter the code with ifdef's, we dynamically allocate them.

> 
> Still if we go in for dynamic allocation of the system vectors 
> the above looks much simpler and easier to work with than
> a lot of other possibilities.
> 
> I think used_vectors and system_vectors are data structures that
> we need to remove, as their interactions with assign_irq_vector
> are not at all well defined or nice.
> 
> I think vector_irq should return an irq_desc and have an entry for
> all of the static vectors as well (if we are going to do weird
> things with dynamic high priority vector allocation, and dynamic
> detection of which vectors assign_irq_vector may use).
> 
> I have a patch series that gets me 90% of the way there, and the
> rest appears easy but I don't have any time to mess with it right
> now.  I will try and post it something in the next couple of days.
> 
> Eric
> 

If I can get a sense of where you're headed with your patch and you don't mind,
maybe I can do the last 10%.

		--ajm

-- 
Somebody just stopped callin' you "Angel."
--
Alan J. Mayer
SGI
ajm@sgi.com
WORK: 651-683-3131
HOME: 651-407-0134
--
