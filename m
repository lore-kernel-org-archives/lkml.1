Return-Path: <linux-kernel-owner+w=401wt.eu-S1756077AbYGXKvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077AbYGXKvq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 06:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752296AbYGXKvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 06:51:37 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:60181 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbYGXKvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 06:51:35 -0400
Date: Thu, 24 Jul 2008 12:23:52 +0200
From: Sebastien Dugue <sebastien.dugue@bull.net>
To: Linux-rt <linux-rt-users@vger.kernel.org>
Cc: linux-ppc <linuxppc-dev@ozlabs.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Michael Ellerman <michael@ellerman.id.au>,
       Tim Chavez <tinytim@us.ibm.com>,
       Jean Pierre Dion <jean-pierre.dion@bull.net>,
       Gilles Carry <Gilles.Carry@ext.bull.net>
Subject: [PATCH 0/2][RT] powerpc - fix bug in irq reverse mapping radix tree
 (Resend)
Message-ID: <20080724122352.3bc76bda@bull.net>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(This is resend as vger dropped my previous attempt, sorry for the duplication)

  Hi,

  here are 2 patches for fixing the following bug occuring on IBM pSeries under
an RT kernel:

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

  The first patch moves the call to irq_radix_revmap() from xics_startup() out to
xics_host_map_direct() and xics_host_map_lpar() which are called with preemption
enabled.

  The second patch is a little more involved in that it takes advantage of
the concurrent radix tree to simplify the locking requirements and allows
to allocate a new node outside a preemption disabled section.

  I just hope I've correctly understood the concurrent radix trees semantic
and got the (absence of) locking right.

  Sebastien.
