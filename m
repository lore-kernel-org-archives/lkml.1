Return-Path: <linux-kernel-owner+w=401wt.eu-S1757601AbXKAHSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757601AbXKAHSc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 03:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753549AbXKAHSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 03:18:22 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:39535 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075AbXKAHSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 03:18:20 -0400
Message-ID: <47297DA6.5070904@cosmosbay.com>
Date: Thu, 01 Nov 2007 08:17:58 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: akpm@linux-foundation.org, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [patch 0/7] [RFC] SLUB: Improve allocpercpu to reduce per cpu
 access overhead
References: <20071101000211.970501947@sgi.com>
In-Reply-To: <20071101000211.970501947@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [172.16.8.80]); Thu, 01 Nov 2007 08:18:05 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter a écrit :
> This patch increases the speed of the SLUB fastpath by
> improving the per cpu allocator and makes it usable for SLUB.
> 
> Currently allocpercpu manages arrays of pointer to per cpu objects.
> This means that is has to allocate the arrays and then populate them
> as needed with objects. Although these objects are called per cpu
> objects they cannot be handled in the same way as per cpu objects
> by adding the per cpu offset of the respective cpu.
> 
> The patch here changes that. We create a small memory pool in the
> percpu area and allocate from there if alloc per cpu is called.
> As a result we do not need the per cpu pointer arrays for each
> object. This reduces memory usage and also the cache foot print
> of allocpercpu users. Also the per cpu objects for a single processor
> are tightly packed next to each other decreasing cache footprint
> even further and making it possible to access multiple objects
> in the same cacheline.
> 
> SLUB has the same mechanism implemented. After fixing up the
> alloccpu stuff we throw the SLUB method out and use the new
> allocpercpu handling. Then we optimize allocpercpu addressing
> by adding a new function
> 
> 	this_cpu_ptr()
> 
> that allows the determination of the per cpu pointer for the
> current processor in an more efficient way on many platforms.
> 
> This increases the speed of SLUB (and likely other kernel subsystems
> that benefit from the allocpercpu enhancements):
> 
> 
>        SLAB    SLUB    SLUB+   SLUB-o	SLUB-a
>    8    96      86      45      44      38	3 *
>   16    84      92      49      48      43	2 *
>   32    84      106     61      59      53	+++
>   64    102     129     82      88      75	++
>  128    147     226     188     181     176	-
>  256    200     248     207     285     204	=
>  512    300     301     260     209     250	+
> 1024    416     440     398     264     391	++
> 2048    720     542     530     390     511	+++
> 4096    1254    342     342     336     376	3 *
> 
> alloc/free test
>       SLAB    SLUB    SLUB+   SLUB-o	SLUB-a
>       137-146 151     68-72   68-74	56-58	3 *
> 
> Note: The per cpu optimization are only half way there because of the screwed
> up way that x86_64 handles its cpu area that causes addditional cycles to be
> spend by retrieving a pointer from memory and adding it to the address.
> The i386 code is much less cycle intensive being able to get to per cpu
> data using a segment prefix and if we can get that to work on x86_64
> then we may be able to get the cycle count for the fastpath down to 20-30
> cycles.
> 

Really sounds good Christoph, not only for SLUB, so I guess the 32k limit is 
not enough because many things will use per_cpu if only per_cpu was reasonably 
fast (ie not so many dereferences)

I think this question already came in the past and Linus already answered it, 
but I again ask it. What about VM games with modern cpus (64 bits arches)

Say we reserve on x86_64 a really huge (2^32 bytes) area, and change VM layout 
so that each cpu maps its own per_cpu area on this area, so that the local 
per_cpu data sits in the same virtual address on each cpu. Then we dont need a 
segment prefix nor adding a 'per_cpu offset'. No need to write special asm 
functions to read/write/increment a per_cpu data and gcc could use normal 
rules for optimizations.

We only would need adding "per_cpu offset" to get data for a given cpu.

