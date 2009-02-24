Return-Path: <linux-kernel-owner+w=401wt.eu-S1757867AbZBXOiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757867AbZBXOiP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 09:38:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755721AbZBXOh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 09:37:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:45901 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755330AbZBXOh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 09:37:58 -0500
Message-ID: <49A40624.4000100@kernel.org>
Date: Tue, 24 Feb 2009 23:37:24 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com, nickpiggin@yahoo.com.au, ink@jurassic.park.msu.ru
Subject: Re: [PATCHSET x86/core/percpu] improve the first percpu chunk	allocation
References: <1235445101-7882-1-git-send-email-tj@kernel.org> <20090224095708.GA20739@elte.hu> <49A3DE76.5010606@kernel.org> <20090224124042.GA31295@elte.hu> <49A3F5C5.4060107@kernel.org> <20090224141217.GA17287@elte.hu>
In-Reply-To: <20090224141217.GA17287@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 24 Feb 2009 14:37:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo.

Ingo Molnar wrote:
> * Tejun Heo <tj@kernel.org> wrote:
> 
>> What's missing is unification of static and dynamic accessors 
>> and thus the faster accessors - percpu_read() and friends - 
>> for dynamic ones. This will be the next round of patches.
> 
> Ok, good - we are in agreement then and i'll wait for those 
> patches.

Whooray!

> And i think i finally decoded the real source of the disconnect
> :-)
> 
> It's still about this restriction:
> 
> +       /*
> +        * If large page isn't supported, there's no benefit in doing
> +        * this.  Also, embedding allocation doesn't play well with
> +        * NUMA.
> +        */
> +       if (!cpu_has_pse || pcpu_need_numa())
> +               return -EINVAL;
> 
> This is what makes no sense (why force the static percpu area 
> into 4K mappings on NUMA).

No, the first allocator tried is remap allocator which will do the 2MB
remapping thing if NUMA.  If not, it gives its way to embedding
allocator which only kicks in for pse && !numa.  The 4k thing is just
the last resort.  We might as well kill it and make it

 if (numa)
	do remap
 else
	do embed
 panic if failed

The 4k thing is the final fallback for cases where pse isn't
supported.

> You do it because i think you misunderstood my original 2MB TLB 
> static area suggestion. setup_pcpu_embed() does this now:
> 
> +       pcpue_ptr = pcpu_alloc_bootmem(0, num_possible_cpus() * pcpue_unit_size,
> +                                      PAGE_SIZE);
> 
> That is not NUMA-friendly indeed.

NUMA uses 2MB remapping.  Non-NUMA uses embedding.  If you're annoyed
about the embedding allocator, we can drop it but given that most of
the machines in the wild are non-NUMA and the code to do the trick is
quite simple, I think it justifies its existence.

> What should be done instead is to up the unit size to 2MB as i 
> suggested, and to allocate 2MB sized and 2MB aligned 
> numa-correct area for each CPU, via bootmem.

YES, the posted code does EXACTLY that for NUMA!!!!

> To quote my original mail:
> 
>>> - allocate the static percpu area using bootmem-alloc, but
>>>   using a 2MB alignment parameter and a 2MB aligned size. Then
>>>   we can remap it to some convenient and undisturbed virtual
>>>   memory area, using 2MB TLBs. [*]
> 
> I.e. each individual 2MB allocated largepage can then be 
> remapped as a 2MB TLB to the high (vmalloc) area. Followed by 
> ordinary 4K mappings for regular percpu_alloc() pages.
> 
> ( and the partial, unused pages within this initial chunk are 
>   returned to bootmem. )

I did understand that the first time around.

> That will be NUMA-friendly and i suspect we should also use it 
> on SMP just to get that aspect of the code tested better.

For testing coverage, we can make a debug parameter or something but
think about it.  The embedding allocator is ~100 lines of well
commented code which is dropped once init is complete and it always
saves a 2MB TLB entry for all the non-NUMA machines out there.  It is
a very low cost optimization for >90% of machines out there.

> Do _not_ allocate the units together in one bootmem allocation 
> because that's not NUMA-friendly.

Again, it doesn't do that for NUMA.

-- 
tejun
