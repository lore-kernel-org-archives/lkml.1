Return-Path: <linux-kernel-owner+w=401wt.eu-S1755963AbYHDN6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963AbYHDN6Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 09:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753905AbYHDN6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 09:58:07 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:42191 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869AbYHDN6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 09:58:04 -0400
From: Sebastien Dugue <sebastien.dugue@bull.net>
To: linuxppc-dev@ozlabs.org
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       benh@kernel.crashing.org, paulus@samba.org, michael@ellerman.id.au,
       jean-pierre.dion@bull.net, gilles.carry@ext.bull.net,
       tinytim@us.ibm.com, tglx@linutronix.de, rostedt@goodmis.org
Subject: [PATCH 0/3 V2] powerpc - Make the irq reverse mapping tree lockless
Date: Mon,  4 Aug 2008 13:08:41 +0200
Message-Id: <1217848124-3719-1-git-send-email-sebastien.dugue@bull.net>
X-Mailer: git-send-email 1.5.5.rc2.1.gc953.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



  Hi ,

  here is V2 of the patchset posted on July 31st updated from the comments
made by Michael Ellerman.

  V1 -> V2:

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

  This serie is split into 3 patches:

  - The first patch moves the initialization of the radix tree earlier in the
    boot process before any IRQ gets registered, but after the mm is up.

  - The second patch splits irq_radix_revmap() into its 2 components: one
    for lookup and one for insertion into the radix tree.

  - And finally, the third patch makes the radix tree fully lockless on the 
    lookup side.


  Here is the diffstat for the whole patchset:

 arch/powerpc/include/asm/irq.h        |   19 ++++-
 arch/powerpc/kernel/irq.c             |  130 +++++++--------------------------
 arch/powerpc/platforms/pseries/smp.c  |    1 +
 arch/powerpc/platforms/pseries/xics.c |   17 +++--
 arch/powerpc/platforms/pseries/xics.h |    1 +
 5 files changed, 56 insertions(+), 112 deletions(-)

  Thanks,

  Sebastien.


