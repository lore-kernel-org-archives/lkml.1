Return-Path: <linux-kernel-owner+w=401wt.eu-S1760976AbYFDOss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760976AbYFDOss (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 10:48:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754337AbYFDOsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 10:48:38 -0400
Received: from relay2.sgi.com ([192.48.171.30]:41676 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753342AbYFDOsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 10:48:37 -0400
Message-ID: <4846AB42.5070402@sgi.com>
Date: Wed, 04 Jun 2008 07:48:34 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Christoph Lameter <clameter@sgi.com>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 02/41] cpu alloc: The allocator
References: <20080530035620.587204923@sgi.com>	<20080530040011.084909898@sgi.com> <20080529215833.469c3cbe.akpm@linux-foundation.org>
In-Reply-To: <20080529215833.469c3cbe.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Andrew Morton wrote:
...
>> +/*
>> + * Mark an object as used in the cpu_alloc_map
>> + *
>> + * Must hold cpu_alloc_map_lock
>> + */
>> +static void set_map(int start, int length)
>> +{
>> +	while (length-- > 0)
>> +		__set_bit(start++, cpu_alloc_map);
>> +}
> 
> bitmap_fill()?
> 
>> +/*
>> + * Mark an area as freed.
>> + *
>> + * Must hold cpu_alloc_map_lock
>> + */
>> +static void clear_map(int start, int length)
>> +{
>> +	while (length-- > 0)
>> +		__clear_bit(start++, cpu_alloc_map);
>> +}
> 
> bitmap_zero()?
...
>> +void *cpu_alloc(unsigned long size, gfp_t gfpflags, unsigned long align)
>> +{
>> +	unsigned long start;
>> +	int units = size_to_units(size);
>> +	void *ptr;
>> +	int first;
>> +	unsigned long flags;
>> +
>> +	if (!size)
>> +		return ZERO_SIZE_PTR;
> 
> OK, so we reuse ZERO_SIZE_PTR from kmalloc.
> 
>> +	spin_lock_irqsave(&cpu_alloc_map_lock, flags);
>> +
>> +	first = 1;
>> +	start = first_free;
>> +
>> +	for ( ; ; ) {
>> +
>> +		start = find_next_zero_bit(cpu_alloc_map, UNITS, start);
>> +		if (start >= UNITS)
>> +			goto out_of_memory;
>> +
>> +		if (first)
>> +			first_free = start;
>> +
>> +		/*
>> +		 * Check alignment and that there is enough space after
>> +		 * the starting unit.
>> +		 */
>> +		if (start % (align / UNIT_SIZE) == 0 &&
>> +			find_next_bit(cpu_alloc_map, UNITS, start + 1)
>> +							>= start + units)
>> +				break;
>> +		start++;
>> +		first = 0;
>> +	}
> 
> This is kinda bitmap_find_free_region(), only bitmap_find_free_region()
> isn't quite strong enough.
> 
> Generally I think it would have been better if you had added new
> primitives to the bitmap library (or enhanced existing ones) and used
> them here, rather than implementing private functionality.

Hi Andrew,

I've sort of inherited this now...

So are you suggesting that we add new bitmap primitives to:

	bitmap_fill_offset(bitmap, start, nbits)   /* start at bitmap[start] */
	bitmap_zero_offset(bitmap, start, nbits)
	bitmap_find_free_area(bitmap, nbits, size, align)  /* size not order */

Thanks,
Mike 
