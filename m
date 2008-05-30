Return-Path: <linux-kernel-owner+w=401wt.eu-S1756890AbYE3EBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890AbYE3EBr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 00:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752101AbYE3EAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 00:00:19 -0400
Received: from relay1.sgi.com ([192.48.171.29]:45433 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750799AbYE3EAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 00:00:14 -0400
Message-Id: <20080530035620.587204923@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 29 May 2008 20:56:20 -0700
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mike Travis <travis@sgi.com>
Subject: [patch 00/41] cpu alloc / cpu ops v3: Optimize per cpu access
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In various places the kernel maintains arrays of pointers indexed by
processor numbers. These are used to locate objects that need to be used
when executing on a specirfic processor. Both the slab allocator
and the page allocator use these arrays and there the arrays are used in
performance critical code. The allocpercpu functionality is a simple
allocator to provide these arrays. However, there are certain drawbacks
in using such arrays:

1. The arrays become huge for large systems and may be very sparsely
   populated (if they are dimensionied for NR_CPUS) on an architecture
   like IA64 that allows up to 4k cpus if a kernel is then booted on a
   machine that only supports 8 processors. We could nr_cpu_ids there
   but we would still have to allocate all possible processors up to
   the number of processor ids. cpu_alloc can deal with sparse cpu_maps.

2. The arrays cause surrounding variables to no longer fit into a single
   cacheline. The layout of core data structure is typically optimized so
   that variables frequently used together are placed in the same cacheline.
   Arrays of pointers move these variables far apart and destroy this effect.

3. A processor frequently follows only one pointer for its own use. Thus
   that cacheline with that pointer has to be kept in memory. The neighboring
   pointers are all to other processors that are rarely used. So a whole
   cacheline of 128 bytes may be consumed but only 8 bytes of information
   is constant use. It would be better to be able to place more information
   in this cacheline.

4. The lookup of the per cpu object is expensive and requires multiple
   memory accesses to:

   A) smp_processor_id()
   B) pointer to the base of the per cpu pointer array
   C) pointer to the per cpu object in the pointer array
   D) the per cpu object itself.

5. Each use of allocper requires its own per cpu array. On large
   system large arrays have to be allocated again and again.

6. Processor hotplug cannot effectively track the per cpu objects
   since the VM cannot find all memory that was allocated for
   a specific cpu. It is impossible to add or remove objects in
   a consistent way. Although the allocpercpu subsystem was extended
   to add that capability is not used since use would require adding
   cpu hotplug callbacks to each and every use of allocpercpu in
   the kernel.

The patchset here provides an cpu allocator that arranges data differently.
Objects are placed tightly in linear areas reserved for each processor.
The areas are of a fixed size so that address calculation can be used
instead of a lookup. This means that

1. The VM knows where all the per cpu variables are and it could remove
   or add cpu areas as cpus come online or go offline.

2. There is only a single per cpu array that is used for the percpu area
   and all per cpu allocations.

3. The lookup of a per cpu object is easy and requires memory access to
	(worst case: architecture does not provide cpu ops):

   A) per cpu offset from the per cpu pointer table
      (if its the current processor then there is usually some
      more efficient means of retrieving the offset)
   B) cpu pointer to the object
   C) the per cpu object itself.

4. Surrounding variables can be placed in the same cacheline.
   This allow f.e. in SLUB to avoid caching objects in per cpu structures
   since the kmem_cache structure is finally available without the need
   to access a cache cold cacheline.

5. A single pointer can be used regardless of the number of processors
   in the system.

The cpu allocator manages a fixed size data per cpu data area. The size
can be configured as needed.

The current usage of the cpu area can be seen in the field

	cpu_bytes

in /proc/vmstat

The patchset is agsinst 2.6.26-rc4.

There are two arch implementation of cpu ops provides.

1. x86. Another version of the zero based x86 patches
   exist by Mike.

2. IA64. Limited implementation since IA64 has
   no fast RMV ops. But we can avoid the addition of the
   my_cpu_offset in hotpaths.

This is a rather complex patchset and I am not sure how to merge it.
Maybe it would be best to merge a piece at a time beginning with the
basic infrastructure in the first few patches?

-- 
