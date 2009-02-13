Return-Path: <linux-kernel-owner+w=401wt.eu-S1758053AbZBMMs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053AbZBMMs3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 07:48:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752283AbZBMMsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 07:48:21 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:36172 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbZBMMsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 07:48:20 -0500
Subject: irq-disabled vs vmap vs text_poke
From: Peter Zijlstra <peterz@infradead.org>
To: Nick Piggin <npiggin@suse.de>, akpm <akpm@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 13 Feb 2009 13:50:07 +0100
Message-Id: <1234529407.6519.28.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Ingo got the following splat:

[    5.101748] ------------[ cut here ]------------
[    5.104305] WARNING: at kernel/smp.c:329 smp_call_function_many+0x34/0x1ea()
[    5.104305] Hardware name: P4DC6
[    5.104305] Modules linked in:
[    5.104305] Pid: 1, comm: swapper Not tainted 2.6.29-rc4-tip-01766-g1757c19-dirty #2
[    5.104305] Call Trace:
[    5.104305]  [<c012b5d6>] warn_slowpath+0x79/0x8f
[    5.104305]  [<c0104d24>] ? dump_trace+0x7d/0xac
[    5.104305]  [<c014805a>] ? __lock_acquire+0x319/0x382
[    5.104305]  [<c014d6a1>] smp_call_function_many+0x34/0x1ea
[    5.104305]  [<c011b59e>] ? do_flush_tlb_all+0x0/0x48
[    5.104305]  [<c011b59e>] ? do_flush_tlb_all+0x0/0x48
[    5.104305]  [<c014d878>] smp_call_function+0x21/0x28
[    5.104305]  [<c012fa56>] on_each_cpu+0x14/0x23
[    5.104305]  [<c011b56d>] flush_tlb_all+0x19/0x1b
[    5.104305]  [<c018dcbe>] flush_tlb_kernel_range+0xd/0xf
[    5.104305]  [<c018dd00>] vmap_debug_free_range+0x1c/0x20
[    5.104305]  [<c018e386>] remove_vm_area+0x28/0x67
[    5.104305]  [<c018e468>] __vunmap+0x30/0xab
[    5.104305]  [<c018e50a>] vunmap+0x27/0x29
[    5.104305]  [<c06421b6>] text_poke+0xd6/0x104
[    5.104305]  [<c015687c>] ? kprobe_target+0x0/0x15
[    5.104305]  [<c0642a82>] arch_disarm_kprobe+0x13/0x15
[    5.104305]  [<c06434f9>] __unregister_kprobe_top+0x68/0xe8
[    5.104305]  [<c06436d2>] unregister_kretprobes+0x2c/0xb9
[    5.104305]  [<c0643775>] unregister_kretprobe+0x16/0x18
[    5.104305]  [<c0156d0b>] init_test_probes+0x2ed/0x40c
[    5.104305]  [<c09d451c>] init_kprobes+0x127/0x131
[    5.104305]  [<c01476bf>] ? lock_release_holdtime+0x43/0x48
[    5.104305]  [<c0192e48>] ? __slab_alloc+0x5d/0x27a
[    5.104305]  [<c0147a2a>] ? lockdep_init_map+0x80/0xe7
[    5.104305]  [<c0141c0d>] ? clocksource_read+0xd/0xf
[    5.104305]  [<c0142542>] ? getnstimeofday+0x5e/0xe9
[    5.104305]  [<c013e01e>] ? timespec_to_ktime+0xe/0x11
[    5.104305]  [<c09d43f5>] ? init_kprobes+0x0/0x131
[    5.104305]  [<c010115c>] do_one_initcall+0x6a/0x169
[    5.104305]  [<c029ad2f>] ? number+0x10d/0x1cf
[    5.104305]  [<c0147799>] ? register_lock_class+0x17/0x228
[    5.104305]  [<c014805a>] ? __lock_acquire+0x319/0x382
[    5.104305]  [<c029fa91>] ? debug_check_no_obj_freed+0xda/0x126
[    5.104305]  [<c014805a>] ? __lock_acquire+0x319/0x382
[    5.104305]  [<c01476bf>] ? lock_release_holdtime+0x43/0x48
[    5.104305]  [<c0640ec0>] ? _spin_unlock+0x22/0x25
[    5.104305]  [<c01cc0f0>] ? proc_register+0x14b/0x15c
[    5.104305]  [<c01cc20f>] ? create_proc_entry+0x76/0x8c
[    5.104305]  [<c0162900>] ? default_affinity_write+0x3f/0x8a
[    5.104305]  [<c0162a6a>] ? init_irq_proc+0x58/0x65
[    5.104305]  [<c09bf52d>] kernel_init+0x118/0x169
[    5.104305]  [<c09bf415>] ? kernel_init+0x0/0x169
[    5.104305]  [<c0103adf>] kernel_thread_helper+0x7/0x10
[    5.104305] ---[ end trace e93713a9d40cd06c ]---

Which points to vunmap() being called with interrupts disabled.

Which made me look at the vmap/vunmap calls, and they appear to not be
irq-safe, therefore this would be a bug in text_poke().

[ that is, vmap() can end up calling get_vm_area_caller() which in turn
  calls __get_vm_area_node() with GFP_KERNEL, ergo, don't do this from
  an atomic context. ]

Now text_poke() uses local_irq_save/restore(), which conveys that it can
be called with IRQs disabled, which is exactly what happens in the trace
above, however we just established that vmap/vunmap() are not irq-safe.

Anybody got an idea on how to fix this?
