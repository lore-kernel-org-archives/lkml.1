Return-Path: <linux-kernel-owner+w=401wt.eu-S1756318AbYIDMhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318AbYIDMhd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 08:37:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbYIDMhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 08:37:20 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:41991 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288AbYIDMhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 08:37:18 -0400
From: Sebastien Dugue <sebastien.dugue@bull.net>
To: linuxppc-dev@ozlabs.org
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       benh@kernel.crashing.org, paulus@samba.org, michael@ellerman.id.au,
       jean-pierre.dion@bull.net, gilles.carry@ext.bull.net,
       tinytim@us.ibm.com, tglx@linutronix.de, rostedt@goodmis.org,
       dwalker@mvista.com, sebastien.dugue@bull.net
Subject: [PATCH 0/2 V4] powerpc - Make the irq reverse mapping tree lockless
Date: Thu,  4 Sep 2008 14:37:06 +0200
Message-Id: <1220531828-9732-1-git-send-email-sebastien.dugue@bull.net>
X-Mailer: git-send-email 1.5.5.rc2.1.gc953.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  Hi ,

  here is V4 for the powerpc IRQ radix tree reverse mapping rework.
Big thanks to Benjamin Herrenschmidt for his most useful comments.


  V3 -> V4: from comments by Benjamin Herrenschmidt

  - Dump the use of a global atomic variable for synchronization between the
    radix tree initialization path and the insert/remove/lookup path.
    Instead use a state variable to distinguish between the phases of tree
    initialization:

      - 0 tree not allocated
      - 1 tree allocated but not intialized
      - 2 tree allocated and initialized 

  - turn the radix tree nodes GFP_ATOMIC allocations into GFP_KERNEL allocations.

  - Use a global mutex to handle writers concurrency instead of a spinlock
    embedded into the irq_host struct.


  V2 -> V3: from comments by Benjamin Herrenschmidt and Daniel Walker

  - Move the initialization of the radix tree back into irq_late_init() and
    insert pre-existing irqs into the tree at that time.

  - One whitespace cleanup.


  V1 -> V2: from comments by Michael Ellerman

  - Initialize the XICS radix tree in xics code and only for that irq_host
    rather than doing it for all the hosts in the powerpc irq generic code
    (although the hosts list only contain one entry at the moment).

  - Add a comment in irq_radix_revmap_lookup() stating why it is safe to
    perform a lookup even if the radix tree has not been initialized yet.




  The goal of this patchset is to simplify the locking constraints on the radix
tree used for IRQ reverse mapping on the pSeries machines and provide lockless
access to this tree.

  This also solves the following BUG under preempt-rt:

BUG: sleeping function called from invalid context swapper(1) at kernel/rtmutex.c:739
in_atomic():1 [00000002], irqs_disabled():1
Call Trace:
[c0000001e20f3340] [c000000000010370] .show_stack+0x70/0x1bc (unreliable)
[c0000001e20f33f0] [c000000000049380] .__might_sleep+0x11c/0x138
[c0000001e20f3470] [c0000000002a2f64] .__rt_spin_lock+0x3c/0x98
[c0000001e20f34f0] [c0000000000c3f20] .kmem_cache_alloc+0x68/0x184
[c0000001e20f3590] [c000000000193f3c] .radix_tree_node_alloc+0xf0/0x144
[c0000001e20f3630] [c000000000195190] .radix_tree_insert+0x18c/0x2fc
[c0000001e20f36f0] [c00000000000c710] .irq_radix_revmap+0x1a4/0x1e4
[c0000001e20f37b0] [c00000000003b3f0] .xics_startup+0x30/0x54
[c0000001e20f3840] [c00000000008b864] .setup_irq+0x26c/0x370
[c0000001e20f38f0] [c00000000008ba68] .request_irq+0x100/0x158
[c0000001e20f39a0] [c0000000001ee9c0] .hvc_open+0xb4/0x148
[c0000001e20f3a40] [c0000000001d72ec] .tty_open+0x200/0x368
[c0000001e20f3af0] [c0000000000ce928] .chrdev_open+0x1f4/0x25c
[c0000001e20f3ba0] [c0000000000c8bf0] .__dentry_open+0x188/0x2c8
[c0000001e20f3c50] [c0000000000c8dec] .do_filp_open+0x50/0x70
[c0000001e20f3d70] [c0000000000c8e8c] .do_sys_open+0x80/0x148
[c0000001e20f3e20] [c00000000000928c] .init_post+0x4c/0x100
[c0000001e20f3ea0] [c0000000003c0e0c] .kernel_init+0x428/0x478
[c0000001e20f3f90] [c000000000027448] .kernel_thread+0x4c/0x68

  The root cause of this bug lies in the fact that the XICS interrupt
controller uses a radix tree for its reverse irq mapping and that we cannot
allocate the tree nodes (even GFP_ATOMIC) with preemption disabled.

  In fact, we have 2 nested preemption disabling when we want to allocate
a new node:

  - setup_irq() does a spin_lock_irqsave() before calling xics_startup() which
    then calls irq_radix_revmap() to insert a new node in the tree

  - irq_radix_revmap() also does a spin_lock_irqsave() (in irq_radix_wrlock())
    before the radix_tree_insert()

  Also, if an IRQ gets registered before the tree is initialized (namely the
IPI), it will be inserted into the tree in interrupt context once the tree
have been initialized, hence the need for a spin_lock_irqsave() in the
insertion path.

  This serie is split into 2 patches:

  - The first patch splits irq_radix_revmap() into its 2 components: one
    for lookup and one for insertion into the radix tree and moves the
    insertion of pre-existing irq into the tree at irq_late_init() time.

  - The second patch makes the radix tree fully lockless on the 
    lookup side.


  And the diffstat for the whole patchset:

 arch/powerpc/include/asm/irq.h        |   18 +++-
 arch/powerpc/kernel/irq.c             |  169 +++++++++++++++++----------------
 arch/powerpc/platforms/pseries/xics.c |   11 +--
 3 files changed, 104 insertions(+), 94 deletions(-)


  Thanks,

  Sebastien.


