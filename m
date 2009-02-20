Return-Path: <linux-kernel-owner+w=401wt.eu-S1758539AbZBTDB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758539AbZBTDB4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 22:01:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757493AbZBTDBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 22:01:33 -0500
Received: from hera.kernel.org ([140.211.167.34]:45928 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757424AbZBTDBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 22:01:32 -0500
Message-ID: <499E1D01.2040408@kernel.org>
Date: Fri, 20 Feb 2009 12:01:21 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: tglx@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, jeremy@goop.org, cpw@sgi.com, mingo@elte.hu,
       tony.luck@intel.com
Subject: Re: [PATCH 09/10] percpu: implement new dynamic percpu allocator
References: <1234958676-27618-1-git-send-email-tj@kernel.org> <1234958676-27618-10-git-send-email-tj@kernel.org> <200902192221.52835.rusty@rustcorp.com.au>
In-Reply-To: <200902192221.52835.rusty@rustcorp.com.au>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 20 Feb 2009 03:01:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Rusty.

Rusty Russell wrote:
> On Wednesday 18 February 2009 22:34:35 Tejun Heo wrote:
>> Impact: new scalable dynamic percpu allocator which allows dynamic
>>         percpu areas to be accessed the same way as static ones
>>
>> Implement scalable dynamic percpu allocator which can be used for both
>> static and dynamic percpu areas.  This will allow static and dynamic
>> areas to share faster direct access methods.  This feature is optional
>> and enabled only when CONFIG_HAVE_DYNAMIC_PER_CPU_AREA is defined by
>> arch.  Please read comment on top of mm/percpu.c for details.
> 
> Hi Tejun,
> 
>    One question.  Are you thinking that to be defined by every SMP arch
> long-term?

Yeap, definitely.

> Because there are benefits in having &<percpuvar> == valid
> percpuptr, such as passing them around as parameters.  If so, IA64
> will want a dedicated per-cpu area for statics (tho it can probably
> just map it somehow, but it has to be 64k).

Hmmm...  Don't have much idea about ia64 and its magic 64k.  Can it
somehow be used for the first chunk?

>    It'd also be nice to use your generalised module_percpu allocator for the
> !CONFIG_HAVE_DYNAMIC_PER_CPU_AREA case, but doesn't really matter if that's
> temporary anyway.

Yeap, once the conversion is complete, the old allocator will go away
so there's no reason to put more work into it.

>> +#define PCPU_UNIT_PAGES_SHIFT	((int)__pcpu_unit_pages_shift)
>> +#define PCPU_UNIT_PAGES		((int)__pcpu_unit_pages)
>> +#define PCPU_UNIT_SHIFT		((int)__pcpu_unit_shift)
>> +#define PCPU_UNIT_SIZE		((int)__pcpu_unit_size)
>> +#define PCPU_CHUNK_SIZE		((int)__pcpu_chunk_size)
>> +#define PCPU_NR_SLOTS		((int)__pcpu_nr_slots)
> 
> These pseudo-constants seem like a really weird thing to do to me.

I explained this in the reply to Andrew's comment.  It's
non-really-constant-but-should-be-considered-so-by-users thing.  Is it
too weird?  Even if I add comment explaning it?

> And AFAICT you have the requirement that PCPU_UNIT_PAGES*PAGE_SIZE >=
> sizeof(.data.percpu).  Should probably note that somewhere.

__pcu_unit_pages_shift is adjusted automatically according to
sizeof(.data.percpu), so it will adapt as necessary.  After the
initial adjustment, it should be considered constant, so the above
seemingly weird hack.

>> +static DEFINE_MUTEX(pcpu_mutex);		/* one mutex to rule them all */
>> +static struct list_head *pcpu_slot;		/* chunk list slots */
>> +static struct rb_root pcpu_addr_root = RB_ROOT;	/* chunks by address */
> 
> rbtree might be overkill on first cut.  I'm bearing in mind that Christoph L
> had a nice patch to use dynamic percpu allocation in the sl*b allocators;
> which would mean this needs to only use get_free_page.

Hmmm... the reverse mapping can be piggy backed on vmalloc by adding a
private pointer to the vm_struct but rbtree isn't too difficult to use
so I just did it directly.  Nick, what do you think about adding
private field to vm_struct and providing a reverse map function?

As for the sl*b allocation thing, can you please explain in more
detail or point me to the patches / threads?

Thanks.  :-)

-- 
tejun
