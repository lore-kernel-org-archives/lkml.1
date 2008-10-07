Return-Path: <linux-kernel-owner+w=401wt.eu-S1755196AbYJGOJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196AbYJGOJA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 10:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753622AbYJGOIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 10:08:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46433 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753582AbYJGOIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 10:08:50 -0400
Message-ID: <48EB6D2C.30806@linux-foundation.org>
Date: Tue, 07 Oct 2008 09:07:40 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Matt Mackall <mpm@selenic.com>, linux-mm <linux-mm@kvack.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] SLOB's krealloc() seems bust
References: <1223387841.26330.36.camel@lappy.programming.kicks-ass.net>
In-Reply-To: <1223387841.26330.36.camel@lappy.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Which basically shows us that the content of the pcpu_size[] array got
> corrupted after the krealloc() call in split_block().
> 
> Which made me look at which slab allocator I had selected, which turned
> out to be SLOB (from testing the network swap stuff).

krealloc() is in generic core code (mm/util.c) and is the same for all allocators.

krealloc uses ksize() which is somewhat dicey for SLOB because it only works
on kmalloc'ed memory. Is the krealloc used on memory allocated with kmalloc()?
Slob's ksize could use a BUG_ON for the case in which ksize() is used on
kmem_cache_alloc'd memory.

/* can't use ksize for kmem_cache_alloc memory, only kmalloc */
size_t ksize(const void *block)
{
        struct slob_page *sp;

        BUG_ON(!block);
        if (unlikely(block == ZERO_SIZE_PTR))
                return 0;

        sp = (struct slob_page *)virt_to_page(block);


Add a BUG_ON(!kmalloc_cache(sp))?


        if (slob_page(sp))
                return ((slob_t *)block - 1)->units + SLOB_UNIT;
			^^^^^^^ Is this correct?
			
        else
                return sp->page.private;
}

