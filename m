Return-Path: <linux-kernel-owner+w=401wt.eu-S1758948AbZIPORi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758948AbZIPORi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 10:17:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753879AbZIPORh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 10:17:37 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:58230 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752712AbZIPORg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 10:17:36 -0400
Subject: RCU callbacks and TREE_PREEMPT_RCU
From: Catalin Marinas <catalin.marinas@arm.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Eric Sesterhenn <eric.sesterhenn@lsexperts.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: ARM Ltd
Date: Wed, 16 Sep 2009 15:17:21 +0100
Message-Id: <1253110641.31751.92.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Sep 2009 14:17:22.0498 (UTC) FILETIME=[68590220:01CA36D8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Eric was reporting some issues with kmemleak on 2.6.31 accessing freed
memory under heavy stress (using the "stress" application). Basically,
the system gets into an oom state (because of "stress -m 1000") and
kmemleak fails to allocate its metadata (correct behaviour so far). At
that point, it disables itself and schedules the clean-up work which
does this (among other locking, the kmemleak_do_cleanup function the
latest mainline):

	rcu_read_lock();
	list_for_each_entry_rcu(object, &object_list, object_list)
		delete_object_full(object->pointer);
	rcu_read_unlock();

The kmemleak objects are freed via put_object() with:

	call_rcu(&object->rcu, free_object_rcu);

(the free_object_rcu calls kmem_cache_free).

When TREE_PREEMPT_RCU is enabled, the rcu list traversing above fails
with access to 0x6b6b6b6b but it is fine with TREE_PREEMPT_RCU=n and
TREE_RCU=y. During clean-up, kmemleak objects should no longer be freed
by other means since kmemleak was disabled and all callbacks are
ignored. The system is a 900Mhz P3, 256MB RAM, CONFIG_SMP=n.

Is there something I'm doing wrong in kmemleak or a bug with RCU
preemption? The kernel oops looks like this:

[ 5346.582119] kmemleak: Cannot allocate a kmemleak_object structure
[ 5346.582208] Pid: 31302, comm: stress Not tainted 2.6.31-01335-g86d7101 #5
[ 5346.582313] Call Trace:
[ 5346.582414]  [<c01c4125>] create_object+0x215/0x220
[ 5346.582529]  [<c0d3e660>] ? alloc_arch_preferred_bootmem+0x30/0x50
[ 5346.582628]  [<c0157532>] ? mark_held_locks+0x52/0x70
[ 5346.582734]  [<c0d3e660>] ? alloc_arch_preferred_bootmem+0x30/0x50
[ 5346.582823]  [<c0d3e6b8>] ? __free+0x38/0x90
[ 5346.582941]  [<c08ea9cb>] kmemleak_alloc+0x2b/0x60
[ 5346.705312]  [<c01c075c>] kmem_cache_alloc+0x11c/0x1a0
[ 5346.705453]  [<c05b7313>] ? cfq_set_request+0xf3/0x310
[ 5346.705573]  [<c0d3e660>] ? alloc_arch_preferred_bootmem+0x30/0x50
[ 5346.705660]  [<c05aeed3>] ? get_io_context+0x13/0x40
[ 5346.705765]  [<c05b7220>] ? cfq_set_request+0x0/0x310
[ 5346.705850]  [<c05b7313>] cfq_set_request+0xf3/0x310
[ 5346.705968]  [<c015767c>] ? trace_hardirqs_on_caller+0x12c/0x180
[ 5346.706133]  [<c05b7220>] ? cfq_set_request+0x0/0x310
[ 5346.706230]  [<c05a3fcf>] elv_set_request+0x1f/0x50
[ 5346.706342]  [<c05a8bbc>] get_request+0x27c/0x2f0
[ 5346.706426]  [<c05a91c2>] get_request_wait+0xe2/0x140
[ 5346.706545]  [<c0146290>] ? autoremove_wake_function+0x0/0x40
[ 5346.706638]  [<c05abd79>] __make_request+0x89/0x3e0
[ 5346.706744]  [<c05a7fe2>] generic_make_request+0x192/0x400
[ 5346.706835]  [<c05ad011>] submit_bio+0x71/0x110
[ 5346.706939]  [<c015767c>] ? trace_hardirqs_on_caller+0x12c/0x180
[ 5346.797327]  [<c01576db>] ? trace_hardirqs_on+0xb/0x10
[ 5346.797478]  [<c08fa239>] ? _spin_unlock_irqrestore+0x39/0x70
[ 5346.797597]  [<c019d55d>] ? test_set_page_writeback+0x6d/0x140
[ 5346.797699]  [<c01b607a>] swap_writepage+0x9a/0xd0
[ 5346.797804]  [<c01b60b0>] ? end_swap_bio_write+0x0/0x80
[ 5346.797895]  [<c01a0706>] shrink_page_list+0x316/0x700
[ 5346.798003]  [<c015aa9f>] ? __lock_acquire+0x40f/0xab0
[ 5346.798170]  [<c0159749>] ? validate_chain+0xe9/0x1030
[ 5346.798260]  [<c01a0cca>] shrink_list+0x1da/0x4e0
[ 5346.798370]  [<c01a1267>] shrink_zone+0x297/0x310
[ 5346.798454]  [<c01a1441>] ? shrink_slab+0x161/0x1a0
[ 5346.798563]  [<c01a1661>] try_to_free_pages+0x1e1/0x2e0
[ 5346.798650]  [<c019f5f0>] ? isolate_pages_global+0x0/0x1e0
[ 5346.798774]  [<c019b76e>] __alloc_pages_nodemask+0x35e/0x5d0
[ 5346.798864]  [<c01aa957>] do_wp_page+0xb7/0x690
[ 5346.798968]  [<c01abf83>] ? handle_mm_fault+0x263/0x600
[ 5346.929240]  [<c08fa4b5>] ? _spin_lock+0x65/0x70
[ 5346.929378]  [<c01ac185>] handle_mm_fault+0x465/0x600
[ 5346.929496]  [<c08fc7fb>] ? do_page_fault+0x14b/0x390
[ 5346.929589]  [<c014a4fc>] ? down_read_trylock+0x5c/0x70
[ 5346.929696]  [<c08fc860>] do_page_fault+0x1b0/0x390
[ 5346.929780]  [<c08fc6b0>] ? do_page_fault+0x0/0x390
[ 5346.929884]  [<c08fad18>] error_code+0x70/0x78
[ 5347.889442] BUG: unable to handle kernel paging request at 6b6b6b6b
[ 5347.889626] IP: [<c01c31e0>] kmemleak_do_cleanup+0x60/0xa0
[ 5347.889835] *pde = 00000000 
[ 5347.889933] Oops: 0000 [#1] PREEMPT 
[ 5347.890038] last sysfs file: /sys/class/vc/vcsa9/dev
[ 5347.890038] Modules linked in: [last unloaded: rcutorture]
[ 5347.890038] 
[ 5347.890038] Pid: 5, comm: events/0 Not tainted (2.6.31-01335-g86d7101 #5)
System Name
[ 5347.890038] EIP: 0060:[<c01c31e0>] EFLAGS: 00010286 CPU: 0
[ 5347.890038] EIP is at kmemleak_do_cleanup+0x60/0xa0
[ 5347.890038] EAX: 002ed661 EBX: 6b6b6b43 ECX: 00000007 EDX: 6b6b6b6b
[ 5347.890038] ESI: cf8b40b0 EDI: 00000002 EBP: cf8b8f3c ESP: cf8b8f28
[ 5347.890038]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
[ 5347.890038] Process events/0 (pid: 5, ti=cf8b8000 task=cf8c3500
task.ti=cf8b8000)
[ 5347.890038] Stack:
[ 5347.890038]  00000002 00000001 00000000 c01c3180 c0cd6640 cf8b8f98 c0142857
00000000
[ 5347.890038] <0> 00000002 00000000 c01427f6 cf8b40d4 cf8b40dc cf8c3500
c01c3180 c0cd6640
[ 5347.890038] <0> c0f938b0 c0a89514 00000000 00000000 00000000 cf8c3500
c0146290 cf8b8f84
[ 5347.890038] Call Trace:
[ 5347.890038]  [<c01c3180>] ? kmemleak_do_cleanup+0x0/0xa0
[ 5347.890038]  [<c0142857>] ? worker_thread+0x1d7/0x300
[ 5347.890038]  [<c01427f6>] ? worker_thread+0x176/0x300
[ 5347.890038]  [<c01c3180>] ? kmemleak_do_cleanup+0x0/0xa0
[ 5347.890038]  [<c0146290>] ? autoremove_wake_function+0x0/0x40
[ 5347.890038]  [<c0142680>] ? worker_thread+0x0/0x300
[ 5347.890038]  [<c01461b7>] ? kthread+0x77/0x80
[ 5347.890038]  [<c0146140>] ? kthread+0x0/0x80
[ 5347.890038]  [<c010356b>] ? kernel_thread_helper+0x7/0x1c
[ 5347.890038] Code: 89 44 24 04 b8 e0 2c cd c0 c7 04 24 02 00 00 00 e8 76 7f
f9 ff 8b 15 d0 66 cd c0 eb 0b 8b 43 58 e8 76 ff ff ff 8b 53 28 8d 5a d8 <8b>
43 28 0f 18 00 90 81 fa d0 66 cd c0 75 e3 b9 ef 31 1c c0 ba 
[ 5347.890038] EIP: [<c01c31e0>] kmemleak_do_cleanup+0x60/0xa0 SS:ESP
0068:cf8b8f28
[ 5347.890038] CR2: 000000006b6b6b6b


Thanks.

-- 
Catalin

