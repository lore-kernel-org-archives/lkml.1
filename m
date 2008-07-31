Return-Path: <linux-kernel-owner+w=401wt.eu-S1755521AbYGaJlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521AbYGaJlJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 05:41:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754273AbYGaJkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 05:40:17 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:40350 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521AbYGaJkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 05:40:14 -0400
From: Sebastien Dugue <sebastien.dugue@bull.net>
To: linuxppc-dev@ozlabs.org
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       benh@kernel.crashing.org, paulus@samba.org, michael@ellerman.id.au,
       jean-pierre.dion@bull.net, gilles.carry@ext.bull.net,
       tinytim@us.ibm.com, tglx@linutronix.de, rostedt@goodmis.org
Subject: [PATCH 0/3] powerpc - Make the irq reverse mapping tree lockless
Date: Thu, 31 Jul 2008 11:40:38 +0200
Message-Id: <1217497241-10685-1-git-send-email-sebastien.dugue@bull.net>
X-Mailer: git-send-email 1.5.5.rc2.1.gc953.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi ,

  here is a respin of the patches I posted last week for the RT kernel now targeted
for mainline (http://lkml.org/lkml/2008/7/24/98). Thomas, steven, a note for you
at the end.

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

  The root cause of this bug lies in the fact that the XICS interrupt controller
uses a radix tree for its reverse irq mapping and that we cannot allocate the tree
nodes (even GFP_ATOMIC) with preemption disabled.

  In fact, we have 2 nested preemption disabling when we want to allocate
a new node:

  - setup_irq() does a spin_lock_irqsave() before calling xics_startup() which
    then calls irq_radix_revmap() to insert a new node in the tree

  - irq_radix_revmap() also does a spin_lock_irqsave() (in irq_radix_wrlock())
    before the radix_tree_insert()

  Also, if an IRQ gets registered before the tree is initialized (namely the
IPI), it will be inserted into the tree in interrupt context once the tree
have been initialized, hence the need for a spin_lock_irqsave() in the insertion
path.

  This serie is split into 3 patches:

  - The first patch moves the initialization of the radix tree earlier in the
    boot process before any IRQ gets registered, but after the mm is up.

  - The second patch splits irq_radix_revmap() into its 2 components: one
    for lookup and one for insertion into the radix tree.

  - And finally, the third patch makes the radix tree fully lockless on the 
    lookup side.


  Here is the diffstat for the whole patchset:

 arch/powerpc/kernel/irq.c             |  134 ++++++++-------------------------
 arch/powerpc/platforms/pseries/smp.c  |    1 +
 arch/powerpc/platforms/pseries/xics.c |   11 +--
 include/asm-powerpc/irq.h             |   24 +++++-
 4 files changed, 58 insertions(+), 112 deletions(-)


  Thomas, Steven, the first 2 patches can be applied seamlessly to 2.6.26-rt1
with offsets, the third patch has a trivial to fix reject in
arch/powerpc/kernel/irq.c because the irq_big_lock is changed to a raw spinlock
in preempt-rt. If you want those patches for RT, just flag me, I have those
sitting on my test box.



  Thanks,

  Sebastien.



