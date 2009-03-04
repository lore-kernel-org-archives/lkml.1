Return-Path: <linux-kernel-owner+w=401wt.eu-S1754456AbZCDQgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456AbZCDQgb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 11:36:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753145AbZCDQgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 11:36:23 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:34938 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082AbZCDQgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 11:36:22 -0500
Subject: percpu allocator vs reclaim
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 04 Mar 2009 17:36:03 +0100
Message-Id: <1236184563.5330.8074.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

Thomas hit the below on recent -tip kernels.

[  371.513742] ======================================================
[  371.514672] [ INFO: RECLAIM_FS-safe -> RECLAIM_FS-unsafe lock order detected ]
[  371.514672] 2.6.29-rc6-tip-02441-g4239438-dirty #36
[  371.514672] ------------------------------------------------------
[  371.514672] umount/19574 [HC0[0]:SC0[0]:HE1:SE1] is trying to acquire:
[  371.514672]  (pcpu_mutex){+.+.+.}, at: [<ffffffff810c589e>] free_percpu+0x2f/0x17e
[  371.514672]
[  371.514672] and this task is already holding:
[  371.514672]  (&type->s_lock_key#7){+.+...}, at: [<ffffffff810c9367>] lock_super+0x29/0x2b
[  371.514672] which would create a new lock dependency:
[  371.514672]  (&type->s_lock_key#7){+.+...} -> (pcpu_mutex){+.+.+.}
[  371.514672]
[  371.514672] but this new dependency connects a RECLAIM_FS-irq-safe lock:
[  371.514672]  (jbd_handle){+.+.-.}
[  371.514672] ... which became RECLAIM_FS-irq-safe at:
[  371.514672]   [<ffffffff8105f36a>] __lock_acquire+0x79a/0x160a
[  371.514672]   [<ffffffff8106022f>] lock_acquire+0x55/0x71
[  371.514672]   [<ffffffffa002ceb8>] journal_start+0x10e/0x11a [jbd]
[  371.514672]   [<ffffffffa004aa39>] ext3_journal_start_sb+0x4a/0x4c [ext3]
[  371.514672]   [<ffffffffa0040db2>] ext3_ordered_writepage+0x56/0x140 [ext3]
[  371.514672]   [<ffffffff8109f0f5>] shrink_page_list+0x37d/0x62d
[  371.514672]   [<ffffffff8109f9c0>] shrink_list+0x2a3/0x5a5
[  371.514672]   [<ffffffff8109ff41>] shrink_zone+0x27f/0x329
[  371.514672]   [<ffffffff810a086c>] kswapd+0x49e/0x684
[  371.514672]   [<ffffffff810502c5>] kthread+0x49/0x76
[  371.514672]   [<ffffffff8100cbfa>] child_rip+0xa/0x20
[  371.514672]   [<ffffffffffffffff>] 0xffffffffffffffff
[  371.514672]
[  371.514672] to a RECLAIM_FS-irq-unsafe lock:
[  371.514672]  (pcpu_mutex){+.+.+.}
[  371.514672] ... which became RECLAIM_FS-irq-unsafe at:
[  371.514672] ...  [<ffffffff8105dced>] mark_held_locks+0x4d/0x69
[  371.514672]   [<ffffffff8105dd7e>] lockdep_trace_alloc+0x75/0x77
[  371.514672]   [<ffffffff810c27b8>] __kmalloc+0x61/0xf8
[  371.514672]   [<ffffffff810c57cd>] pcpu_realloc+0x2e/0x91
[  371.514672]   [<ffffffff810c5a64>] pcpu_alloc_area+0x77/0x376
[  371.514672]   [<ffffffff810c5e25>] __alloc_percpu+0xc2/0x395
[  371.514672]   [<ffffffff8116dc04>] __percpu_counter_init+0x51/0x9c
[  371.514672]   [<ffffffff815579f9>] files_init+0x74/0x78
[  371.514672]   [<ffffffff81557bd6>] vfs_caches_init+0x10b/0x121
[  371.514672]   [<ffffffff8153dbf3>] start_kernel+0x340/0x383
[  371.514672]   [<ffffffff8153d29a>] x86_64_start_reservations+0xaa/0xae
[  371.514672]   [<ffffffff8153d36e>] x86_64_start_kernel+0xd0/0xd7
[  371.514672]   [<ffffffffffffffff>] 0xffffffffffffffff

<snip>

[  373.367127] stack backtrace:
[  373.367127] Pid: 19574, comm: umount Not tainted 2.6.29-rc6-tip-02441-g4239438-dirty #36
[  373.367127] Call Trace:
[  373.367127]  [<ffffffff8105eafa>] check_usage+0x3ca/0x3db
[  373.367127]  [<ffffffff8105eb6c>] check_irq_usage+0x61/0xc5
[  373.367127]  [<ffffffff8105fbe8>] __lock_acquire+0x1018/0x160a
[  373.367127]  [<ffffffff812df330>] ? io_schedule+0x82/0xa5
[  373.367127]  [<ffffffff8106022f>] lock_acquire+0x55/0x71
[  373.367127]  [<ffffffff810c589e>] ? free_percpu+0x2f/0x17e
[  373.367127]  [<ffffffff812dff40>] mutex_lock_nested+0x45/0x29e
[  373.367127]  [<ffffffff810c589e>] ? free_percpu+0x2f/0x17e
[  373.367127]  [<ffffffff812dfa79>] ? __mutex_unlock_slowpath+0x115/0x121
[  373.367127]  [<ffffffff8105df29>] ? trace_hardirqs_on_caller+0x114/0x138
[  373.367127]  [<ffffffff810c589e>] free_percpu+0x2f/0x17e
[  373.367127]  [<ffffffff8116dba7>] percpu_counter_destroy+0x3f/0x4b
[  373.367127]  [<ffffffffa0049056>] ext3_put_super+0xc7/0x21e [ext3]
[  373.367127]  [<ffffffff810ca04c>] generic_shutdown_super+0x73/0xe8
[  373.367127]  [<ffffffff810ca0e3>] kill_block_super+0x22/0x3a
[  373.367127]  [<ffffffff810ca1ca>] deactivate_super+0x68/0x7d
[  373.367127]  [<ffffffff810ddbeb>] mntput_no_expire+0x106/0x147
[  373.367127]  [<ffffffff810de1b9>] sys_umount+0x2dd/0x30c
[  373.367127]  [<ffffffff8100bb1b>] system_call_fastpath+0x16/0x1b

Which basically states that we could deadlock due to reclaim lock
recursion.

Looking at the code I don't see a quick solution, other than using
GFP_NOFS, which is a bit of a bother (as I suspect it might easily grow
__GFP_IO inversion too, if it doesn't already have it).

