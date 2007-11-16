Return-Path: <linux-kernel-owner+w=401wt.eu-S934719AbXKPXL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934719AbXKPXL3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 18:11:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761675AbXKPXLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 18:11:07 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51781 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757364AbXKPXLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 18:11:02 -0500
Message-Id: <20071116230920.278761667@sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 16 Nov 2007 15:09:20 -0800
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Subject: [patch 00/30] cpu alloc v2: Optimize by removing arrays of pointers to per cpu objects
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Note arch maintainers: Some configuration variables in arch/*/Kconfig needed
for large users of per cpu space (large NUMA mostly, or lots of processors)]
and in order to make optimal use of cpu_alloc.

V1->V2:
- Split off patch for virtualization. Patch has some instructions on
  how to configure an arch for cpu_alloc.
- uiuc patch is upstream so leave it out.
- There was an article on LWN.net on cpu_alloc.
- Add a sparc64 config
- Against current git that merged the Kconfigs for x86_64 and i386.

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

6. The VM knows where all the per cpu variables are and it could remove
   or add cpu areas as cpus come online or go offline.

5. There is no need for per cpu pointer arrays.

4. The lookup of a per cpu object is easy and requires memory access to:

   A) smp_processor_id()
   B) cpu pointer to the object
   C) the per cpu object itself.

3. So one access to the not very friendly cacheline that only contains
   a single useful pointer is avoided. The cache footprint is reduced.

2. Surrounding variables can be placed in the same cacheline.
   This allow f.e. in SLUB to avoid caching objects in per cpu structures
   since the kmem_cache structure is finally available without the need
   to access a cache cold cacheline.

1. A single pointer can be used regardless of the number of processors
   in the system.

The cpu allocator managed data beginning at CPU_AREA_BASE. The pointer to
access item DATA on processor X can then be calculated using

POINTER = CPU_AREA_BASE + DATA + (X << CPU_AREA_ORDER)

This makes the allocator rely on a fixed address of the cpu area and on
a fixed size of memory for each processor (similar to S/390s
way of addressing percpu variables).

The allocator can be configured in two ways:

1. Static configuration

	The cpu areas are directly mapped memory addresses. Thus
	the memory in the cpu areas is fixed and is allocated
	as a static variable.

	The default configuration of the cpu allocator (if no arch code
	changes the settings) is to reserve a 32k area for each processor.

2. Virtual configuration

	The cpu areas are virtualized. Memory in cpu areas is allocated
	on demand. The MMU is used to map memory allocated into the
	cpu areas (in same way that the virtual memmap functionality does it).

	The maximum sizes for the cpu areas is only dependent on the amount
	of virtual memory available. The virtualization can use large
	mappings (PMDs f.e.) in order to avoid TLB pressure that could occur
	on system that only have a small page when heavy use of cpu areas
	is made.


This patch increases the speed of the SLUB fastpath and it is likely that
similar results can be obtained for other kernel subsystems :


Allocation of 10000 objects of each size. Measurement of the cycles
for each action:

Size  SLUBmm	cpu alloc
-------------------------
   8  45	38
  16  49	43
  32  61	53
  64  82	75
 128  188	176
 256  207	204
 512  260	250
1024  398	391
2048  530	511
4096  342	376

Allocation and then immeidate freeing of an object. Measured in cycles
for each alloc/free action:

alloc/free test
    SLUBmm	cpu alloc
    68-72	56-58

The cpu allocator also removes the difference in handling SMP, UP and NUMA in
the slab and page allocate and simplifies code. It is advantageous even for UP
to place per cpu data from different zones or different slabs in the same
cacheline. Cpu alloc makes uniform handling of cpu data on all three different
types of configurations possible.

The cpu allocator also decreases the memory needs for per cpu storage.

On a classic configuration with SLAB, 32 processors and the allocation of a 4 byte
counter via allocpercpu one needs the following on a 64 bit platform:

32 * 8		256	Array indexed by processor
32 * 32		1024	32 objects. The minimum allocation size of SLAB is 32.
------------------------------------------------------------------------------
Total		1280 bytes

cpu alloc needs

32 * 4		128 bytes

This is one tenth of storage. Granted this is the worst case scenario for a
32 processor system but it shows the savings that can be had. cpu alloc can
allocate 10 counters in the same cacheline for the price of one with
allocpercpu. The allocpercpu counters are likely dispersed over all of
memory. So multiple cachelines (in the worst case 10) need to be kept in
memory if those counters need constant updating. cpu alloc will keep the
10 counter in a single cacheline. cpu alloc can keep up to 16 counters
in the same cacheline if the machine has a 64 byte cacheline size.

The use of the cpu area is usually pretty minimal. 32 bit SMP systems typicaly
use about 8k of cpu area space after bootup. 64 bit SMP around 16k. Small NUMA
systems (8p 4node) use about 64k. Large NUMA system may need a megabyte of
cpu area.

The usage of the per cpu areas typically increases by

1. New slabs being created (needs about 12 bytes per slab on 32 bit, 20 on 64 bit)
2. New devices being mounted that need cpu data for statistics
3. Network devices statistics
4. Special network features (Dave needs to run 100000 IP tunnels)

The current use of the cpu area can be seen in the field

	cpu_bytes

in /proc/vmstat

Drawbacks:

1. The per cpu area size is fixed

   If we use a virtually mapped area then this is not a problem if there
   is sufficient virtual space. The 100000 IP tunnels are only realistic
   with a virtually mapped cpu area.

2. The cpu allocator cannot control allocation of individual objects like
   allocpercpu may. This is in actuality never used except in net/iucv/iucv.c
   where we have a single case of a per cpu allocation being used to allocate
   GFP_DMA structures(!). A patch is provided that replaces the use of
   allocpercpu with explicit calls to allocators for each object in iucv.c

TODO:
- Currently only i386, ia64 and x86_64 arch definitions are provided.
  Other arches fall back to 64k static configurations.
- Cpu hotplug support. Current we simply allocate for all possible processors.
  We could reduce this to only online processors if we could allocate the
  cpu area for the new processor before the callbacks are run and if we could
  free the cpu areas for a processor going down after all the callbacks for
  that were run.

The patchset implements cpu alloc and then gradually replaces all uses of
allocpercpu in the kernel. The last patch removes the allocpercpu support.
If the last patch is not applied then allocpercpu can coexist with cpu alloc.

The patchset is available also via

git pull git://git.kernel.org/pub/scm/linux/kernel/git/christoph/slab.git cpu_alloc


The following patches are based on the linux-2.6 git tree +

git://git.kernel.org/pub/scm/linux/kernel/git/christoph/slab.git performance

(which is the mm version of SLUB)

-- 
