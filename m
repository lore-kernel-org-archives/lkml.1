Return-Path: <linux-kernel-owner+w=401wt.eu-S1755132AbYKEC5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132AbYKEC5X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 21:57:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753726AbYKEC5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 21:57:14 -0500
Received: from nlpi025.sbcis.sbc.com ([207.115.36.54]:38274 "EHLO
	nlpi025.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425AbYKEC5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 21:57:13 -0500
Date: Tue, 4 Nov 2008 20:56:52 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, travis@sgi.com
Subject: Git next: Second stage of cpu_alloc patches
Message-ID: <Pine.LNX.4.64.0811042053510.31638@quilx.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The second stage of the cpu_alloc patchset can be pulled from

kernel.org/pub/scm/linux/kernel/git/christoph/work.git cpu_alloc_stage2

Stage 2 includes the conversion of the page allocator, vm statistics 
and slub allocator to the use of the cpu allocator and it includes the 
core of the atomic vs. interrupt cpu ops.

commit c9112914d224fbead980438877212c0f003c624e
Author: Christoph Lameter <clameter@sgi.com>
Date:   Tue Nov 6 11:33:51 2007 -0800

     cpu alloc: page allocator conversion

     Use the new cpu_alloc functionality to avoid per cpu arrays in struct zone.
     This drastically reduces the size of struct zone for systems with a large
     amounts of processors and allows placement of critical variables of struct
     zone in one cacheline even on very large systems.

     Another effect is that the pagesets of one processor are placed near one
     another. If multiple pagesets from different zones fit into one cacheline
     then additional cacheline fetches can be avoided on the hot paths when
     allocating memory from multiple zones.

     Surprisingly this clears up much of the painful NUMA bringup. Bootstrap
     becomes simpler if we use the same scheme for UP, SMP, NUMA. #ifdefs are
     reduced and we can drop the zone_pcp macro.

     Hotplug handling is also simplified since cpu alloc can bring up and
     shut down cpu areas for a specific cpu as a whole. So there is no need to
     allocate or free individual pagesets.

     Signed-off-by: Christoph Lameter <clameter@sgi.com>

commit 8a6784bb0da03ea87bab414e9f8de51dcd399490
Author: Christoph Lameter <cl@linux-foundation.org>
Date:   Tue Nov 4 16:32:39 2008 -0600

     x86_64: Support for cpu ops

     Support fast cpu ops in x86_64 by providing a series of functions that
     generate the proper instructions.

     Define CONFIG_HAVE_CPU_OPS so that core code
     can exploit the availability of fast per cpu operations.

     Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

commit e872b7e4dc22f746df8435f1b4b7208b56a68fd6
Author: Christoph Lameter <cl@linux-foundation.org>
Date:   Tue Nov 4 16:32:39 2008 -0600

     VM statistics: Use CPU ops

     The use of CPU ops here avoids the offset calculations that we used to have
     to do with per cpu operations. The result of this patch is that event counters
     are coded with a single instruction the following way:

     	incq   %gs:offset(%rip)

     Without these patches this was:

     	mov    %gs:0x8,%rdx
     	mov    %eax,0x38(%rsp)
     	mov    xxx(%rip),%eax
     	mov    %eax,0x48(%rsp)
     	mov    varoffset,%rax
     	incq   0x110(%rax,%rdx,1)

     Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

commit a81123720c0786d2847f4eaa145da61348f369ab
Author: Christoph Lameter <cl@linux-foundation.org>
Date:   Tue Nov 4 16:32:38 2008 -0600

     cpu ops: Core piece for generic atomic per cpu operations

     Currently the per cpu subsystem is not able to use the atomic capabilities
     that are provided by many of the available processors.

     This patch adds new functionality that allows the optimizing of per cpu
     variable handling. In particular it provides a simple way to exploit
     atomic operations in order to avoid having to disable interrupts or
     performing address calculation to access per cpu data.

     F.e. Using our current methods we may do

     	unsigned long flags;
     	struct stat_struct *p;

     	local_irq_save(flags);
     	/* Calculate address of per processor area */
     	p = CPU_PTR(stat, smp_processor_id());
     	p->counter++;
     	local_irq_restore(flags);

     The segment can be replaced by a single atomic CPU operation:

     	CPU_INC(stat->counter);

     Most processors have instructions to perform the increment using a
     a single atomic instruction. Processors may have segment registers,
     global registers or per cpu mappings of per cpu areas that can be used
     to generate atomic instructions that combine the following in a single
     operation:

     1. Adding of an offset / register to a base address
     2. Read modify write operation on the address calculated by
        the instruction.

     If 1+2 are combined in an instruction then the instruction is atomic
     vs interrupts. This means that percpu atomic operations do not need
     to disable interrupts to increments counters etc.

     The existing methods in use in the kernel cannot utilize the power of
     these atomic instructions. local_t is not really addressing the issue
     since the offset calculation performed before the atomic operation. The
     operation is therefor not atomic. Disabling interrupt or preemption is
     required in order to use local_t.

     local_t is also very specific to the x86 processor. The solution here can
     utilize other methods than just those provided by the x86 instruction set.



     On x86 the above CPU_INC translated into a single instruction:

     	inc %%gs:(&stat->counter)

     This instruction is interrupt safe since it can either be completed
     or not. Both adding of the offset and the read modify write are combined
     in one instruction.

     The determination of the correct per cpu area for the current processor
     does not require access to smp_processor_id() (expensive...). The gs
     register is used to provide a processor specific offset to the respective
     per cpu area where the per cpu variable resides.

     Note that the counter offset into the struct was added *before* the segment
     selector was added. This is necessary to avoid calculations.  In the past
     we first determine the address of the stats structure on the respective
     processor and then added the field offset. However, the offset may as
     well be added earlier. The adding of the per cpu offset (here through the
     gs register) must be done by the instruction used for atomic per cpu
     access.



     If "stat" was declared via DECLARE_PER_CPU then this patchset is capable of
     convincing the linker to provide the proper base address. In that case
     no calculations are necessary.

     Should the stat structure be reachable via a register then the address
     calculation capabilities can be leveraged to avoid calculations.

     On IA64 we can get the same combination of operations in a single instruction
     by using the virtual address that always maps to the local per cpu area:

     	fetchadd &stat->counter + (VCPU_BASE - __per_cpu_start)

     The access is forced into the per cpu address reachable via the virtualized
     address. IA64 allows the embedding of an offset into the instruction. So the
     fetchadd can perform both the relocation of the pointer into the per cpu
     area as well as the atomic read modify write cycle.



     In order to be able to exploit the atomicity of these instructions we
     introduce a series of new functions that take either:

     1. A per cpu pointer as returned by cpu_alloc() or CPU_ALLOC().

     2. A per cpu variable address as returned by per_cpu_var(<percpuvarname>).

     CPU_READ()
     CPU_WRITE()
     CPU_INC
     CPU_DEC
     CPU_ADD
     CPU_SUB
     CPU_XCHG
     CPU_CMPXCHG

     Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

commit bf49f4db6d6582675dbcb38189fc943e2dc8ba8d
Author: Christoph Lameter <cl@linux-foundation.org>
Date:   Tue Nov 4 16:32:38 2008 -0600

     cpu alloc: Remove slub fields

     Remove the fields in kmem_cache_cpu that were used to cache data from
     kmem_cache when they were in different cachelines. The cacheline that holds
     the per cpu array pointer now also holds these values. We can cut down the
     struct kmem_cache_cpu size to almost half.

     The get_freepointer() and set_freepointer() functions that used to be only
     intended for the slow path now are also useful for the hot path since access
     to the field does not require accessing an additional cacheline anymore. This
     results in consistent use of setting the freepointer for objects throughout
     SLUB.

     Also we initialize all possible kmem_cache_cpu structures when a slab is
     created. No need to initialize them when a processor or node comes online.
     And all fields are set to zero. So just use __GFP_ZERO on cpu alloc.

     Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

commit e88a3b4cf66e40d81e8fcda870260a237a58a920
Author: Christoph Lameter <cl@linux-foundation.org>
Date:   Tue Nov 4 16:32:38 2008 -0600

     cpu alloc: Use in slub

     Using cpu alloc removes the needs for the per cpu arrays in the kmem_cache struct.
     These could get quite big if we have to support system of up to thousands of cpus.
     The use of cpu_alloc means that:

     1. The size of kmem_cache for SMP configuration shrinks since we will only
        need 1 pointer instead of NR_CPUS. The same pointer can be used by all
        processors. Reduces cache footprint of the allocator.

     2. We can dynamically size kmem_cache according to the actual nodes in the
        system meaning less memory overhead for configurations that may potentially
        support up to 1k NUMA nodes / 4k cpus.

     3. We can remove the diddle widdle with allocating and releasing of
        kmem_cache_cpu structures when bringing up and shutting down cpus. The cpu
        alloc logic will do it all for us. Removes some portions of the cpu hotplug
        functionality.

     4. Fastpath performance increases.

     Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

commit 240314584fcc19042c6d016954f3b9971d94bf2f
Author: Christoph Lameter <cl@linux-foundation.org>
Date:   Tue Nov 4 16:32:38 2008 -0600

     Increase default reserve percpu area

     SLUB now requires a portion of the per cpu reserve. There are on average
     about 70 real slabs on a system (aliases do not count) and each needs 12 bytes
     of per cpu space. Thats 840 bytes. In debug mode all slabs will be real slabs
     which will make us end up with 150 -> 1800.

     Things work fine without this patch but then slub will reduce the percpu reserve
     for modules.

     Percpu data must be available regardless if modules are in use or not. So get
     rid of the #ifdef CONFIG_MODULES.

     Make the size of the percpu area dependant on the size of a machine word. That
     way we have larger sizes for 64 bit machines. 64 bit machines need more percpu
     memory since the pointer and counters may have double the size. Plus there is
     lots of memory available on 64 bit.

     Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

