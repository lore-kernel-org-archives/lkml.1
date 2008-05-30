Return-Path: <linux-kernel-owner+w=401wt.eu-S1759428AbYE3FK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759428AbYE3FK6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 01:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756259AbYE3FK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 01:10:27 -0400
Received: from relay1.sgi.com ([192.48.171.29]:34209 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755968AbYE3FK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 01:10:26 -0400
Date: Thu, 29 May 2008 22:10:25 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>, Eric Dumazet <dada1@cosmosbay.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>
Subject: Re: [patch 02/41] cpu alloc: The allocator
In-Reply-To: <20080529215833.469c3cbe.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0805292203240.12107@schroedinger.engr.sgi.com>
References: <20080530035620.587204923@sgi.com> <20080530040011.084909898@sgi.com>
 <20080529215833.469c3cbe.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008, Andrew Morton wrote:

> > +config CPU_ALLOC_SIZE
> > +	int "Size of cpu alloc area"
> > +	default "30000"
> 
> strange choice of a default?  I guess it makes it clear that there's no
> particular advantage in making it a power-of-two or anything like that.

The cpu alloc has a cpu_bytes field in vmstat that shows how much memory 
is being used. 30000 seemed to be reasonable after staring at these 
numbers for awhile.

> > +static int size_to_units(unsigned long size)
> > +{
> > +	return DIV_ROUND_UP(size, UNIT_SIZE);
> > +}
> 
> Perhaps it should return UNIT_TYPE? (ugh).

No. The UNIT_TYPE is the basic allocation unit. This returns the number of 
allocation units.
 
> I guess there's no need to ever change that type, so no?

We could go to finer or coarser grained someday? Maybe if the area becomes 
1M of size of so we could go to 8 bytes?

> > +static DEFINE_SPINLOCK(cpu_alloc_map_lock);
> > +static DECLARE_BITMAP(cpu_alloc_map, UNITS);
> > +static int first_free;		/* First known free unit */
> 
> Would be nicer to move these above size_to_units(), IMO.

size_to_units is fairly basic for most of the logic. These are variaables 
that manage the allocator state.

> > +static void set_map(int start, int length)
> > +{
> > +	while (length-- > 0)
> > +		__set_bit(start++, cpu_alloc_map);
> > +}
> 
> bitmap_fill()?

Good idea.

> > + */
> > +static void clear_map(int start, int length)
> > +{
> > +	while (length-- > 0)
> > +		__clear_bit(start++, cpu_alloc_map);
> > +}
> 
> bitmap_zero()?

Ditto.

> > +	if (!size)
> > +		return ZERO_SIZE_PTR;
> 
> OK, so we reuse ZERO_SIZE_PTR from kmalloc.

Well yes slab convention...

> > +		start++;
> > +		first = 0;
> > +	}
> 
> This is kinda bitmap_find_free_region(), only bitmap_find_free_region()
> isn't quite strong enough.
> 
> Generally I think it would have been better if you had added new
> primitives to the bitmap library (or enhanced existing ones) and used
> them here, rather than implementing private functionality.

The scope of the patchset is already fairly large. The search here is 
different and not performance critical. Not sure if this is useful for 
other purposes.

> > +
> > +	BUG_ON(index >= UNITS ||
> > +		!test_bit(index, cpu_alloc_map) ||
> > +		!test_bit(index + units - 1, cpu_alloc_map));
> 
> If this assertion triggers for someone, you'll wish like hell that it
> had been implemented as three separate BUG_ONs.

Ok. But in all cases we have an invalid index.

> > + */
> > +
> > +/* Return a pointer to the instance of a object for a particular processor */
> > +#define CPU_PTR(__p, __cpu)	SHIFT_PERCPU_PTR((__p), per_cpu_offset(__cpu))
> 
> eek, a major interface function which is ALL IN CAPS!
> 
> can we do this in lower-case?  In a C function?

No. This is a macro and therefore uppercase (there is macro magic going on 
that ppl need to be aware of). AFAICR you wanted it this way last year. C 
function not possible because of the type checking.

