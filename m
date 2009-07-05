Return-Path: <linux-kernel-owner+w=401wt.eu-S1757101AbZGESTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757101AbZGESTk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 14:19:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753601AbZGESTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 14:19:33 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:57437 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524AbZGESTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 14:19:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=JApWmprjX9agBgiPIFbADPT2VdAxRFg6oxi1pR3dEs6HnPswtXxqkngL8htuoXPuky
         J+V5rRovlAio9z7rPoxdjlqTLFr+xQxYkuXhzXzR6lUBdlRstEHNrx2/ynbolKEv6/He
         S5hT629yuqfqcM1rsgm26aE0QOwU0g9oQZF9M=
MIME-Version: 1.0
Date: Sun, 5 Jul 2009 19:19:34 +0100
Message-ID: <6278d2220907051119n7f27fff5u2b19a404a7544e82@mail.gmail.com>
Subject: [2.6.31-rc2] hitting lockdep limits...
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Running 2.6.31-rc2, lockdep hits it's 2^18 stack trace limit [1],
giving a warning [2]. It's clear the stacktrace here has no connection
to the root problem.

Nothing jumps out of the lockdep /proc files for what's eating up the
limit - what's best to check for?

Thanks,
  Daniel

--- [1]

# cat lockdep_stats
 lock-classes:                         2034 [max: 8191]
 direct dependencies:                  8142 [max: 16384]
 indirect dependencies:               41755
 all direct dependencies:            886855
 dependency chains:                    7094 [max: 32768]
 dependency chain hlocks:             18066 [max: 163840]
 in-hardirq chains:                    1477
 in-softirq chains:                     617
 in-process chains:                    4221
 stack-trace entries:                262144 [max: 262144]
 combined max dependencies:      3856391688
 hardirq-safe locks:                   1063
 hardirq-unsafe locks:                  407
 softirq-safe locks:                   1088
 softirq-unsafe locks:                  366
 irq-safe locks:                       1096
 irq-unsafe locks:                      407
 hardirq-read-safe locks:                 0
 hardirq-read-unsafe locks:              47
 softirq-read-safe locks:                 0
 softirq-read-unsafe locks:              47
 irq-read-safe locks:                     0
 irq-read-unsafe locks:                  47
 uncategorized locks:                   107
 unused locks:                            0
 max locking depth:                       9
 max recursion depth:                     9
 chain lookup misses:                  7094
 chain lookup hits:                 5316747
 cyclic checks:                       59293
 cyclic-check recursions:             39761
 find-mask forwards checks:           16333
 find-mask forwards recursions:        5897
 find-mask backwards checks:         305195
 find-mask backwards recursions:     363516
 hardirq on events:                 6449896
 hardirq off events:                6449901
 redundant hardirq ons:                   0
 redundant hardirq offs:            6903417
 softirq on events:                   22975
 softirq off events:                  23003
 redundant softirq ons:                   0
 redundant softirq offs:                  0
 debug_locks:                             0

--- [2]

BUG: MAX_STACK_TRACE_ENTRIES too low!

turning off the locking correctness validator.

Pid: 2677, comm: rpc.statd Not tainted 2.6.31-rc2-272c #1

Call Trace:

 [<ffffffff8101ad9f>] ? save_stack_trace+0x2f/0x50

 [<ffffffff8109c4be>] save_trace+0xbe/0xd0

 [<ffffffff8109c528>] add_lock_to_list+0x58/0xf0

 [<ffffffff81114d6b>] ? get_page_from_freelist+0x4db/0xa70

 [<ffffffff810a0870>] __lock_acquire+0xe40/0x1250

 [<ffffffff810a0d9e>] lock_acquire+0x11e/0x170

 [<ffffffff81114d6b>] ? get_page_from_freelist+0x4db/0xa70

 [<ffffffff81695110>] _spin_lock_irqsave+0x60/0xa0

 [<ffffffff81114d6b>] ? get_page_from_freelist+0x4db/0xa70

 [<ffffffff81114d6b>] get_page_from_freelist+0x4db/0xa70

 [<ffffffff8111556b>] __alloc_pages_nodemask+0x26b/0x880

 [<ffffffff81143bec>] alloc_pages_current+0x8c/0xe0

 [<ffffffff8114a922>] new_slab+0x382/0x390

 [<ffffffff8114c2d3>] __slab_alloc+0x203/0x6d0

 [<ffffffff815a7dce>] ? neigh_create+0x7e/0x690

 [<ffffffff815a7dce>] ? neigh_create+0x7e/0x690

 [<ffffffff8114d119>] kmem_cache_alloc+0x269/0x280

 [<ffffffff81071c69>] ? local_bh_enable_ip+0x119/0x1e0

 [<ffffffff815a7dce>] neigh_create+0x7e/0x690

 [<ffffffff81694cee>] ? _read_unlock_bh+0x3e/0x50

 [<ffffffff815a5a69>] ? neigh_lookup+0x179/0x190

 [<ffffffff81608dca>] arp_bind_neighbour+0xca/0xd0

 [<ffffffff815d9451>] rt_intern_hash+0x141/0x570

 [<ffffffff8109efbd>] ? trace_hardirqs_on+0xd/0x10

 [<ffffffff815dbcb7>] __ip_route_output_key+0x6b7/0xbc0

 [<ffffffff816990a2>] ? sub_preempt_count+0x142/0x150

 [<ffffffff815dc1e1>] ip_route_output_flow+0x21/0x70

 [<ffffffff816077e4>] udp_sendmsg+0x7c4/0x940

 [<ffffffff81322642>] ? debug_smp_processor_id+0x42/0x120

 [<ffffffff8160fb6a>] inet_sendmsg+0x4a/0x90

 [<ffffffff81587da4>] sock_sendmsg+0xe4/0x110

 [<ffffffff81086ea0>] ? autoremove_wake_function+0x0/0x40

 [<ffffffff8109fd08>] ? __lock_acquire+0x2d8/0x1250

 [<ffffffff810cd041>] ? audit_sockaddr+0x51/0x110

 [<ffffffff8158852c>] ? move_addr_to_kernel+0x5c/0x60

 [<ffffffff81588c0f>] sys_sendto+0x11f/0x190

 [<ffffffff8100d039>] ? retint_swapgs+0x13/0x1b

 [<ffffffff8109ef4d>] ? trace_hardirqs_on_caller+0x17d/0x1e0

 [<ffffffff81694a9e>] ? trace_hardirqs_on_thunk+0x3a/0x3f

 [<ffffffff8100c4f2>] system_call_fastpath+0x16/0x1b

-- 
Daniel J Blueman
