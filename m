Return-Path: <linux-kernel-owner+w=401wt.eu-S1755348AbYFHGAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348AbYFHGAk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 02:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752492AbYFHGA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 02:00:29 -0400
Received: from ozlabs.org ([203.10.76.45]:40675 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752177AbYFHGA2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 02:00:28 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [patch 00/41] cpu alloc / cpu ops v3: Optimize per cpu access
Date: Sun, 8 Jun 2008 16:00:12 +1000
User-Agent: KMail/1.9.9
Cc: Mike Travis <travis@sgi.com>, Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       Peter Zijlstra <peterz@infradead.org>
References: <20080530035620.587204923@sgi.com> <4846AFCF.30500@sgi.com> <4848CC22.6090109@cosmosbay.com>
In-Reply-To: <4848CC22.6090109@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806081600.13342.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 June 2008 15:33:22 Eric Dumazet wrote:
> 1) NUMA case
>
> For a 64 bit NUMA arch, chunk size of 2Mbytes
>
> Allocates 2Mb for each possible processor (on its preferred memory
> node), and compute values to setup offset_of_cpu[NR_CPUS] array.
>
> Chunk 0
> CPU 0 : virtual address XXXXXX
> CPU 1 : virtual address XXXXXX + offset_of_cpu[1]
> ...
> CPU n : virtual address XXXXXX + offset_of_cpu[n]
> + a shared bitmap
>
>
> For next chunks, we could use vmalloc() zone to find
> nr_possible_cpus virtual addresses ranges where you can map
> a 2Mb page per possible cpu, as long as we respect the relative
> delta between each cpu block, that was computed when
> chunk 0 was setup.
>
> Chunk 1..n
> CPU 0 : virtual address YYYYYYYYYYYYYY
> CPU 1 : virtual address YYYYYYYYYYYYYY + offset_of_cpu[1]
> ...
> CPU n : virtual address YYYYYYYYYYYYYY + offset_of_cpu[n]
> + a shared bitmap (32Kbytes if 8 bytes granularity in allocator)
>
> For a variable located in chunk 0, its 'address' relative to current
> cpu %gs will be some number between [0 and 2^20-1]
>
> For a variable located in chunk 1, its 'address' relative to current
> cpu %gs will be some number between
> [YYYYYYYYYYYYYY - XXXXXX  and YYYYYYYYYYYYYY - XXXXXX + 2^20 - 1],
> not necessarly [2^20 to 2^21 - 1]
>
>
> Chunk 0 would use normal memory (no vmap TLB cost), only next ones need
> vmalloc().
>
> So the extra TLB cost would only be taken for very special NUMA setups
> (only if using a lot of percpu allocations)
>
> Also, using a 2Mb page granularity probably wastes about 2Mb per cpu, but
> this is nothing for NUMA machines :)

If you're prepared to have mappings for chunk 0, you can simply make it 
virtually linear and creating a new chunk is simple.  If not, you need to 
reserve the virtual address space(s) for future mappings.  Otherwise you're 
unlikely to get the same layout for allocations.

This is not a show-stopper: we've lived with limited vmalloc room since 
forever.  It just has to be sufficient.

Otherwise, your analysis is correct, if a little verbose :)

Cheers,
Rusty.
