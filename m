Return-Path: <linux-kernel-owner+w=401wt.eu-S1755976AbZGGIms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976AbZGGIms (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 04:42:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754371AbZGGImk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 04:42:40 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:62122 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756647AbZGGImi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 04:42:38 -0400
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org
Subject: Re: [RFC PATCH 1/3] kmemleak: Allow partial freeing of memory blocks
References: <20090706104654.16051.44029.stgit@pc1117.cambridge.arm.com>
	<20090706105149.16051.99106.stgit@pc1117.cambridge.arm.com>
	<1246950733.24285.10.camel@penberg-laptop>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Tue, 07 Jul 2009 09:42:14 +0100
In-Reply-To: <1246950733.24285.10.camel@penberg-laptop> (Pekka Enberg's message of "Tue\, 07 Jul 2009 10\:12\:13 +0300")
Message-ID: <tnxtz1ovq8p.fsf@pc1117.cambridge.arm.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 07 Jul 2009 08:42:16.0391 (UTC) FILETIME=[D4D84D70:01C9FEDE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> On Mon, 2009-07-06 at 11:51 +0100, Catalin Marinas wrote:
>> @@ -552,8 +558,29 @@ static void delete_object(unsigned long ptr)
>>  	 */
>>  	spin_lock_irqsave(&object->lock, flags);
>>  	object->flags &= ~OBJECT_ALLOCATED;
>> +	start = object->pointer;
>> +	end = object->pointer + object->size;
>> +	min_count = object->min_count;
>>  	spin_unlock_irqrestore(&object->lock, flags);
>>  	put_object(object);
>> +
>> +	if (!size)
>> +		return;
>> +
>> +	/*
>> +	 * Partial freeing. Just create one or two objects that may result
>> +	 * from the memory block split.
>> +	 */
>> +	if (in_atomic())
>> +		gfp_flags = GFP_ATOMIC;
>> +	else
>> +		gfp_flags = GFP_KERNEL;
>
> Are you sure we can do this? There's a big fat comment on top of
> in_atomic() that suggest this is not safe.

It's not safe but I thought it's slightly better than not checking it.

> Why do we need to create the
> object here anyway and not in the _alloc_ paths where gfp flags are
> explicitly passed?

That's the free_bootmem case where Linux can only partially free a
block previously allocated with alloc_bootmem (that's why I haven't
tracked this from the beginning). So if it only frees some part in the
middle of a block, I would have to create two separate
kmemleak_objects (well, I can reuse one but I preferred fewer
modifications as this is not on a fast path anyway).

In the tests I did, free_bootmem is called before the slab allocator
is initialised and therefore before kmemleak is initialised, which
means that the requests are just logged and the kmemleak_* functions
are called later from the kmemleak_init() function. All allocations
via this function are fine to only use GFP_KERNEL.

If my reasoning above is correct, I'll only pass GFP_KERNEL and add a
comment in the code clarifying when the partial freeing happen.

Thanks.

-- 
Catalin
