Return-Path: <linux-kernel-owner+w=401wt.eu-S1753548AbZJGVSC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548AbZJGVSC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 17:18:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753478AbZJGVSB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 17:18:01 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:33423 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753293AbZJGVR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 17:17:59 -0400
X-Amavis-Alert: BAD HEADER, Header field occurs more than once: "Cc" occurs 4
	times
Message-Id: <20091007211024.442168959@gentwo.org>
User-Agent: quilt/0.46-1
Date: Wed, 07 Oct 2009 17:10:24 -0400
From: cl@linux-foundation.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
CC: Mel Gorman <mel@csn.ul.ie>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [this_cpu_xx V6 0/7] Introduce per cpu atomic operations and avoid per cpu address arithmetic
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

V5->V6:
- Drop patches merged by Tejun.
- Drop irqless slub fastpath for now.
- Patches against Tejun percpu for-next branch.

V4->V5:
- Avoid setup_per_cpu_area() modifications and fold the remainder of the
  patch into the page allocator patch.
- Irq disable / per cpu ptr fixes for page allocator patch.

V3->V4:
- Fix various macro definitions.
- Provide experimental percpu based fastpath that does not disable
  interrupts for SLUB.

V2->V3:
- Available via git tree against latest upstream from
	 git://git.kernel.org/pub/scm/linux/kernel/git/christoph/percpu.git linus
- Rework SLUB per cpu operations. Get rid of dynamic DMA slab creation
  for CONFIG_ZONE_DMA
- Create fallback framework so that 64 bit ops on 32 bit platforms
  can fallback to the use of preempt or interrupt disable. 64 bit
  platforms can use 64 bit atomic per cpu ops.

V1->V2:
- Various minor fixes
- Add SLUB conversion
- Add Page allocator conversion
- Patch against the git tree of today

The patchset introduces various operations to allow efficient access
to per cpu variables for the current processor. Currently there is
no way in the core to calculate the address of the instance
of a per cpu variable without a table lookup. So we see a lot of

	per_cpu_ptr(x, smp_processor_id())

The patchset introduces a way to calculate the address using the offset
that is available in arch specific ways (register or special memory
locations) using

	this_cpu_ptr(x)

In addition macros are provided that can operate on per cpu
variables in a per cpu atomic way. With that scalars in structures
allocated with the new percpu allocator can be modified without disabling
preempt or interrupts. This works by generating a single instruction that
does both the relocation of the address to the proper percpu area and
the RMW action.

F.e.

	this_cpu_add(x->var, 20)

can be used to generate an instruction that uses a segment register for the
relocation of the per cpu address into the per cpu area of the current processor
and then increments the variable by 20. The instruction cannot be interrupted
and therefore the modification is atomic vs the cpu (it either happens or not).
Rescheduling or interrupt can only happen before or after the instruction.

Per cpu atomicness does not provide protection from concurrent modifications from
other processors. In general per cpu data is modified only from the processor
that the per cpu area is associated with. So per cpu atomicness provides a fast
and effective means of dealing with concurrency. It may allow development of
better fastpaths for allocators and other important subsystems.

The per cpu atomic RMW operations can be used to avoid having to dimension pointer
arrays in the allocators (patches for page allocator and slub are provided) and
avoid pointer lookups in the hot paths of the allocators thereby decreasing
latency of critical OS paths. The macros could be used to revise the critical
paths in the allocators to no longer need to disable interrupts (not included).

Per cpu atomic RMW operations are useful to decrease the overhead of counter
maintenance in the kernel. A this_cpu_inc() f.e. can generate a single
instruction that has no needs for registers on x86. preempt on / off can
be avoided in many places.

Patchset will reduce the code size and increase speed of operations for
dynamically allocated per cpu based statistics. A set of patches modifies
the fastpaths of the SLUB allocator reducing code size and cache footprint
through the per cpu atomic operations.

---

