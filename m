Return-Path: <linux-kernel-owner+w=401wt.eu-S1753379AbZIAJJM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbZIAJJM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 05:09:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752719AbZIAJJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 05:09:12 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:51002 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013AbZIAJJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 05:09:10 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 1 Sep 2009 18:07:17 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, jens.axboe@oracle.com
Subject: [mmotm][BUG] lockdep warning block I/O (Was Re: mmotm
 2009-08-27-16-51 uploaded
Message-Id: <20090901180717.f707c58f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <200908272355.n7RNtghC019990@imap1.linux-foundation.org>
References: <200908272355.n7RNtghC019990@imap1.linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Here is mmont-Aug27's lockdep wanring. This was printed out when oom-kill happens.
I'm sorry if already fixed.

=
Sep  1 18:01:16 localhost kernel: [ 3012.503035] ======================================================
Sep  1 18:01:16 localhost kernel: [ 3012.503039] [ INFO: SOFTIRQ-safe -> SOFTIRQ-unsafe lock order detected ]
Sep  1 18:01:16 localhost kernel: [ 3012.503042] 2.6.31-rc7-mm1 #3
Sep  1 18:01:16 localhost kernel: [ 3012.503049] ------------------------------------------------------
Sep  1 18:01:16 localhost kernel: [ 3012.503052] kblockd/7/350 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
Sep  1 18:01:16 localhost kernel: [ 3012.503058]  (bdev_lock){+.+...}, at: [<ffffffff811458c7>] nr_blockdev_pages+0x1
7/0x80
Sep  1 18:01:16 localhost kernel: [ 3012.503069]
Sep  1 18:01:16 localhost kernel: [ 3012.503070] and this task is already holding:
Sep  1 18:01:16 localhost kernel: [ 3012.503075]  (&q->__queue_lock){..-.-.}, at: [<ffffffff811e9ff8>] cfq_kick_queue
+0x28/0x50
Sep  1 18:01:16 localhost kernel: [ 3012.503083] which would create a new lock dependency:
Sep  1 18:01:16 localhost kernel: [ 3012.503087]  (&q->__queue_lock){..-.-.} -> (bdev_lock){+.+...}
Sep  1 18:01:16 localhost kernel: [ 3012.503100]
Sep  1 18:01:16 localhost kernel: [ 3012.503102] but this new dependency connects a SOFTIRQ-irq-safe lock:
Sep  1 18:01:16 localhost kernel: [ 3012.503107]  (&q->__queue_lock){..-.-.}
Sep  1 18:01:16 localhost kernel: [ 3012.503110] ... which became SOFTIRQ-irq-safe at:
Sep  1 18:01:16 localhost kernel: [ 3012.503116]   [<ffffffff81079d36>] __lock_acquire+0x876/0x1ee0
Sep  1 18:01:16 localhost kernel: [ 3012.503123]   [<ffffffff8107b47e>] lock_acquire+0xde/0x110
Sep  1 18:01:16 localhost kernel: [ 3012.503128]   [<ffffffff813e6901>] _spin_lock+0x31/0x70
Sep  1 18:01:16 localhost kernel: [ 3012.503133]   [<ffffffffa006d7ed>] scsi_device_unbusy+0xad/0xe0 [scsi_mod]
Sep  1 18:01:16 localhost kernel: [ 3012.503147]   [<ffffffffa0065a54>] scsi_finish_command+0x34/0x130 [scsi_mod]
Sep  1 18:01:16 localhost kernel: [ 3012.503159]   [<ffffffffa006e025>] scsi_softirq_done+0x165/0x190 [scsi_mod]
Sep  1 18:01:16 localhost kernel: [ 3012.503168]   [<ffffffff811e24fd>] blk_done_softirq+0x7d/0x90
Sep  1 18:01:16 localhost kernel: [ 3012.503175]   [<ffffffff81051a9a>] __do_softirq+0xfa/0x1e0
Sep  1 18:01:16 localhost kernel: [ 3012.503185]   [<ffffffff8100d09c>] call_softirq+0x1c/0x50
Sep  1 18:01:16 localhost kernel: [ 3012.503193]   [<ffffffff8100e84d>] do_softirq+0x7d/0xc0
Sep  1 18:01:16 localhost kernel: [ 3012.503199]   [<ffffffff810510ad>] irq_exit+0x4d/0x60
Sep  1 18:01:16 localhost kernel: [ 3012.503204]   [<ffffffff8100dda3>] do_IRQ+0x73/0xf0
Sep  1 18:01:16 localhost kernel: [ 3012.503210]   [<ffffffff8100c893>] ret_from_intr+0x0/0xf
Sep  1 18:01:16 localhost kernel: [ 3012.503218]
Sep  1 18:01:16 localhost kernel: [ 3012.503219] to a SOFTIRQ-irq-unsafe lock:
Sep  1 18:01:16 localhost kernel: [ 3012.503223]  (bdev_lock){+.+...}
Sep  1 18:01:16 localhost kernel: [ 3012.503228] ... which became SOFTIRQ-irq-unsafe at:
Sep  1 18:01:16 localhost kernel: [ 3012.503232] ...  [<ffffffff81079dc4>] __lock_acquire+0x904/0x1ee0
Sep  1 18:01:16 localhost kernel: [ 3012.503242]   [<ffffffff8107b47e>] lock_acquire+0xde/0x110
Sep  1 18:01:16 localhost kernel: [ 3012.503249]   [<ffffffff813e6901>] _spin_lock+0x31/0x70
Sep  1 18:01:16 localhost kernel: [ 3012.503255]   [<ffffffff811458c7>] nr_blockdev_pages+0x17/0x80
Sep  1 18:01:16 localhost kernel: [ 3012.503261]   [<ffffffff810d2148>] si_meminfo+0x38/0x60
Sep  1 18:01:16 localhost kernel: [ 3012.503271]   [<ffffffff81a26185>] eventpoll_init+0x11/0xfb
Sep  1 18:01:16 localhost kernel: [ 3012.503281]   [<ffffffff81009048>] do_one_initcall+0x38/0x190
Sep  1 18:01:16 localhost kernel: [ 3012.503287]   [<ffffffff81a05fcd>] kernel_init+0x18a/0x1e2
Sep  1 18:01:16 localhost kernel: [ 3012.503295]   [<ffffffff8100cf9a>] child_rip+0xa/0x20
Sep  1 18:01:16 localhost kernel: [ 3012.503301]
Sep  1 18:01:16 localhost kernel: [ 3012.503302] other info that might help us debug this:
Sep  1 18:01:16 localhost kernel: [ 3012.503305]
Sep  1 18:01:16 localhost kernel: [ 3012.503309] 3 locks held by kblockd/7/350:
Sep  1 18:01:16 localhost kernel: [ 3012.503313]  #0:  (kblockd){+.+...}, at: [<ffffffff8105fedd>] worker_thread+0x1e
d/0x390
Sep  1 18:01:16 localhost kernel: [ 3012.503326]  #1:  (&cfqd->unplug_work){+.+...}, at: [<ffffffff8105fedd>] worker_
thread+0x1ed/0x390
Sep  1 18:01:16 localhost kernel: [ 3012.503343]  #2:  (&q->__queue_lock){..-.-.}, at: [<ffffffff811e9ff8>] cfq_kick_
queue+0x28/0x50
Sep  1 18:01:16 localhost kernel: [ 3012.503353]
Sep  1 18:01:16 localhost kernel: [ 3012.503354] the dependencies between SOFTIRQ-irq-safe lock and the holding lock:
Sep  1 18:01:16 localhost kernel: [ 3012.503367] -> (&q->__queue_lock){..-.-.} ops: 13498517 {
Sep  1 18:01:16 localhost kernel: [ 3012.503376]    IN-SOFTIRQ-W at:
Sep  1 18:01:16 localhost kernel: [ 3012.503381]                                        [<ffffffff81079d36>] __lock_a
cquire+0x876/0x1ee0
Sep  1 18:01:16 localhost kernel: [ 3012.503387]                                        [<ffffffff8107b47e>] lock_acq
uire+0xde/0x110
Sep  1 18:01:16 localhost kernel: [ 3012.503394]                                        [<ffffffff813e6901>] _spin_lo
ck+0x31/0x70
Sep  1 18:01:16 localhost kernel: [ 3012.503401]                                        [<ffffffffa006d7ed>] scsi_dev
ice_unbusy+0xad/0xe0 [scsi_mod]
Sep  1 18:01:16 localhost kernel: [ 3012.503415]                                        [<ffffffffa0065a54>] scsi_fin
ish_command+0x34/0x130 [scsi_mod]
Sep  1 18:01:16 localhost kernel: [ 3012.503428]                                        [<ffffffffa006e025>] scsi_sof
tirq_done+0x165/0x190 [scsi_mod]
Sep  1 18:01:16 localhost kernel: [ 3012.503440]                                        [<ffffffff811e24fd>] blk_done
_softirq+0x7d/0x90
Sep  1 18:01:16 localhost kernel: [ 3012.503440]                                        [<ffffffff81051a9a>] __do_sof
tirq+0xfa/0x1e0
Sep  1 18:01:16 localhost kernel: [ 3012.503440]                                        [<ffffffff8100d09c>] call_sof
tirq+0x1c/0x50
Sep  1 18:01:16 localhost kernel: [ 3012.503440]                                        [<ffffffff8100e84d>] do_softi
rq+0x7d/0xc0
Sep  1 18:01:16 localhost kernel: [ 3012.503440]                                        [<ffffffff810510ad>] irq_exit
+0x4d/0x60
Sep  1 18:01:16 localhost kernel: [ 3012.503440]                                        [<ffffffff8100dda3>] do_IRQ+0
x73/0xf0
Sep  1 18:01:16 localhost kernel: [ 3012.503440]                                        [<ffffffff8100c893>] ret_from
_intr+0x0/0xf
Sep  1 18:01:16 localhost kernel: [ 3012.503440]    IN-RECLAIM_FS-W at:
Sep  1 18:01:16 localhost kernel: [ 3012.503440]                                           [<ffffffff81079a2d>] __loc
k_acquire+0x56d/0x1ee0
Sep  1 18:01:16 localhost kernel: [ 3012.503440]                                           [<ffffffff8107b47e>] lock_
acquire+0xde/0x110
Sep  1 18:01:16 localhost kernel: [ 3012.503440]                                           [<ffffffff813e69e8>] _spin
_lock_irq+0x38/0x70
Sep  1 18:01:16 localhost kernel: [ 3012.503440]                                           [<ffffffff811dce44>] __mak
e_request+0x64/0x490
Sep  1 18:01:16 localhost kernel: [ 3012.503440]                                           [<ffffffff811daf94>] gener
ic_make_request+0x344/0x440
Sep  1 18:01:16 localhost kernel: [ 3012.503440]                                           [<ffffffff811db0f0>] submi
t_bio+0x60/0xe0
Sep  1 18:01:16 localhost kernel: [ 3012.503440]                                           [<ffffffff810f900d>] swap_
writepage+0x8d/0xd0
Sep  1 18:01:16 localhost kernel: [ 3012.503440]                                           [<ffffffff810da8c8>] shrin
k_page_list+0x728/0x8c0
Sep  1 18:01:16 localhost kernel: [ 3012.503440]                                           [<ffffffff810db557>] shrin
k_zone+0x6f7/0xda0
Sep  1 18:01:16 localhost kernel: [ 3012.503440]                                           [<ffffffff810dbcab>] mem_c
group_shrink_node_zone+0xab/0xc0
Sep  1 18:01:16 localhost kernel: [ 3012.503440]                                           [<ffffffff8111138e>] mem_c
group_hierarchical_reclaim+0x27e/0x380
Sep  1 18:01:16 localhost kernel: [ 3012.503440]                                           [<ffffffff81112a32>] mem_c
group_soft_limit_reclaim+0x82/0x230
Sep  1 18:01:16 localhost kernel: [ 3012.503440]                                           [<ffffffff810dc7b3>] kswap
d+0x5a3/0x840
Sep  1 18:01:16 localhost kernel: [ 3012.503440]                                           [<ffffffff81064fc6>] kthre
ad+0x96/0xb0
Sep  1 18:01:16 localhost kernel: [ 3012.503440]                                           [<ffffffff8100cf9a>] child
_rip+0xa/0x20
Sep  1 18:01:16 localhost kernel: [ 3012.503440]    INITIAL USE at:
Sep  1 18:01:16 localhost kernel: [ 3012.503440]                                       [<ffffffff810796c0>] __lock_ac
quire+0x200/0x1ee0
Sep  1 18:01:16 localhost kernel: [ 3012.503440]                                       [<ffffffff8107b47e>] lock_acqu
ire+0xde/0x110
Sep  1 18:01:16 localhost kernel: [ 3012.503440]                                       [<ffffffff813e6a64>] _spin_loc
k_irqsave+0x44/0x90
Sep  1 18:01:16 localhost kernel: [ 3012.503440]                                       [<ffffffffa0065838>] scsi_adju
st_queue_depth+0x38/0x150 [scsi_mod]
Sep  1 18:01:16 localhost kernel: [ 3012.503440]                                       [<ffffffffa006f13f>] scsi_allo
c_sdev+0x1cf/0x270 [scsi_mod]
Sep  1 18:01:16 localhost kernel: [ 3012.503440]                                       [<ffffffffa006fec3>] scsi_prob
e_and_add_lun+0xa93/0xf10 [scsi_mod]
Sep  1 18:01:16 localhost kernel: [ 3012.503440]                                       [<ffffffffa00706b7>] __scsi_sc
an_target+0xe7/0x750 [scsi_mod]
Sep  1 18:01:16 localhost kernel: [ 3012.503440]                                       [<ffffffffa0070d7e>] scsi_scan
_channel+0x5e/0xa0 [scsi_mod]
Sep  1 18:01:16 localhost kernel: [ 3012.503440]                                       [<ffffffffa0070ea7>] scsi_scan
_host_selected+0xe7/0x1a0 [scsi_mod]
Sep  1 18:01:16 localhost kernel: [ 3012.503440]                                       [<ffffffffa0070fde>] do_scsi_s
can_host+0x7e/0x80 [scsi_mod]
Sep  1 18:01:16 localhost kernel: [ 3012.503440]                                       [<ffffffffa0071370>] scsi_scan
_host+0x1e0/0x230 [scsi_mod]
Sep  1 18:01:16 localhost kernel: [ 3012.503440]                                       [<ffffffffa00ab563>] megasas_p
robe_one+0xd93/0x12b6 [megaraid_sas]
Sep  1 18:01:16 localhost kernel: [ 3012.503440]                                       [<ffffffff81209b32>] local_pci
_probe+0x12/0x20
Sep  1 18:01:16 localhost kernel: [ 3012.503440]                                       [<ffffffff8120a611>] pci_devic
e_probe+0x121/0x130
Sep  1 18:01:16 localhost kernel: [ 3012.503440]                                       [<ffffffff8129dc85>] driver_pr
obe_device+0x95/0x1a0
Sep  1 18:01:16 localhost kernel: [ 3012.503440]                                       [<ffffffff8129de23>] __driver_
attach+0x93/0xa0
Sep  1 18:01:16 localhost kernel: [ 3012.503440]                                       [<ffffffff8129d36b>] bus_for_e
ach_dev+0x6b/0xa0
Sep  1 18:01:16 localhost kernel: [ 3012.503440]                                       [<ffffffff8129dadc>] driver_at
tach+0x1c/0x20
Sep  1 18:01:16 localhost kernel: [ 3012.503440]                                       [<ffffffff8129cc08>] bus_add_d
river+0x248/0x2b0
Sep  1 18:01:17 localhost kernel: [ 3012.503440]                                       [<ffffffff8129e12c>] driver_re
gister+0x7c/0x170
Sep  1 18:01:17 localhost kernel: [ 3012.503440]                                       [<ffffffff8120aaaa>] __pci_reg
ister_driver+0x6a/0xf0
Sep  1 18:01:17 localhost kernel: [ 3012.503440]                                       [<ffffffffa00b407e>] 0xfffffff
fa00b407e
Sep  1 18:01:17 localhost kernel: [ 3012.503440]                                       [<ffffffff81009048>] do_one_in
itcall+0x38/0x190
Sep  1 18:01:17 localhost kernel: [ 3012.503440]                                       [<ffffffff81089c34>] sys_init_
module+0xe4/0x240
Sep  1 18:01:17 localhost kernel: [ 3012.503440]                                       [<ffffffff8100be6b>] system_ca
ll_fastpath+0x16/0x1b
Sep  1 18:01:17 localhost kernel: [ 3012.503440]  }
Sep  1 18:01:17 localhost kernel: [ 3012.503440]  ... key      at: [<ffffffff827b4ad8>] __key.35246+0x0/0x8
Sep  1 18:01:17 localhost kernel: [ 3012.503440]  ... acquired at:
Sep  1 18:01:17 localhost kernel: [ 3012.503440]    [<ffffffff81079424>] check_irq_usage+0x64/0x100
Sep  1 18:01:17 localhost kernel: [ 3012.503440]    [<ffffffff8107a6f9>] __lock_acquire+0x1239/0x1ee0
Sep  1 18:01:17 localhost kernel: [ 3012.503440]    [<ffffffff8107b47e>] lock_acquire+0xde/0x110
Sep  1 18:01:17 localhost kernel: [ 3012.503440]    [<ffffffff813e6901>] _spin_lock+0x31/0x70
Sep  1 18:01:17 localhost kernel: [ 3012.503440]    [<ffffffff811458c7>] nr_blockdev_pages+0x17/0x80
Sep  1 18:01:17 localhost kernel: [ 3012.503440]    [<ffffffff810d2202>] show_free_areas+0x92/0x7d0
Sep  1 18:01:17 localhost kernel: [ 3012.503440]    [<ffffffff811f43c4>] show_mem+0x24/0x210
Sep  1 18:01:17 localhost kernel: [ 3012.503440]    [<ffffffff810d4631>] __alloc_pages_nodemask+0x301/0x710
Sep  1 18:01:17 localhost kernel: [ 3012.503440]    [<ffffffff81103ae7>] alloc_pages_current+0x87/0xd0
Sep  1 18:01:17 localhost kernel: [ 3012.503440]    [<ffffffff81108ffe>] new_slab+0x2fe/0x310
Sep  1 18:01:17 localhost kernel: [ 3012.503440]    [<ffffffff811091d0>] __slab_alloc+0x1c0/0x500
Sep  1 18:01:17 localhost kernel: [ 3012.503440]    [<ffffffff81109896>] kmem_cache_alloc+0x156/0x160
Sep  1 18:01:17 localhost kernel: [ 3012.503440]    [<ffffffffa006636c>] scsi_pool_alloc_command+0x2c/0x80 [scsi_mod]
Sep  1 18:01:17 localhost kernel: [ 3012.503440]    [<ffffffffa006674c>] __scsi_get_command+0x1c/0xb0 [scsi_mod]
Sep  1 18:01:17 localhost kernel: [ 3012.503440]    [<ffffffffa0066821>] scsi_get_command+0x41/0xc0 [scsi_mod]
Sep  1 18:01:17 localhost kernel: [ 3012.503440]    [<ffffffffa006d4cd>] scsi_setup_fs_cmnd+0x9d/0x100 [scsi_mod]
Sep  1 18:01:17 localhost kernel: [ 3012.503440]    [<ffffffffa009d258>] sd_prep_fn+0x88/0xa40 [sd_mod]
Sep  1 18:01:17 localhost kernel: [ 3012.503440]    [<ffffffff811db7eb>] blk_peek_request+0x10b/0x200
Sep  1 18:01:17 localhost kernel: [ 3012.503440]    [<ffffffffa006c86a>] scsi_request_fn+0x6a/0x5b0 [scsi_mod]
Sep  1 18:01:17 localhost kernel: [ 3012.503440]    [<ffffffff811dc180>] __blk_run_queue+0x70/0x150
Sep  1 18:01:17 localhost kernel: [ 3012.503440]    [<ffffffff811ea004>] cfq_kick_queue+0x34/0x50
Sep  1 18:01:17 localhost kernel: [ 3012.503440]    [<ffffffff8105ff33>] worker_thread+0x243/0x390
Sep  1 18:01:17 localhost kernel: [ 3012.503440]    [<ffffffff81064fc6>] kthread+0x96/0xb0
Sep  1 18:01:17 localhost kernel: [ 3012.503440]    [<ffffffff8100cf9a>] child_rip+0xa/0x20
Sep  1 18:01:17 localhost kernel: [ 3012.503440]
Sep  1 18:01:17 localhost kernel: [ 3012.503440]
Sep  1 18:01:17 localhost kernel: [ 3012.503440] the dependencies between the lock to be acquired and SOFTIRQ-irq-uns
afe lock:
Sep  1 18:01:17 localhost kernel: [ 3012.503440] -> (bdev_lock){+.+...} ops: 1248 {
Sep  1 18:01:17 localhost kernel: [ 3012.503440]    HARDIRQ-ON-W at:
Sep  1 18:01:17 localhost kernel: [ 3012.503440]                                        [<ffffffff81079d92>] __lock_a
cquire+0x8d2/0x1ee0
Sep  1 18:01:17 localhost kernel: [ 3012.503440]                                        [<ffffffff8107b47e>] lock_acq
uire+0xde/0x110
Sep  1 18:01:17 localhost kernel: [ 3012.503440]                                        [<ffffffff813e6901>] _spin_lo
ck+0x31/0x70
Sep  1 18:01:17 localhost kernel: [ 3012.503440]                                        [<ffffffff811458c7>] nr_block
dev_pages+0x17/0x80
Sep  1 18:01:17 localhost kernel: [ 3012.503440]                                        [<ffffffff810d2148>] si_memin
fo+0x38/0x60
Sep  1 18:01:17 localhost kernel: [ 3012.503440]                                        [<ffffffff81a26185>] eventpol
l_init+0x11/0xfb
Sep  1 18:01:17 localhost kernel: [ 3012.503440]                                        [<ffffffff81009048>] do_one_i
nitcall+0x38/0x190
Sep  1 18:01:17 localhost kernel: [ 3012.503440]                                        [<ffffffff81a05fcd>] kernel_i
nit+0x18a/0x1e2
Sep  1 18:01:17 localhost kernel: [ 3012.503440]                                        [<ffffffff8100cf9a>] child_ri
p+0xa/0x20
Sep  1 18:01:17 localhost kernel: [ 3012.503440]    SOFTIRQ-ON-W at:
Sep  1 18:01:17 localhost kernel: [ 3012.503440]                                        [<ffffffff81079dc4>] __lock_a
cquire+0x904/0x1ee0
Sep  1 18:01:17 localhost kernel: [ 3012.503440]                                        [<ffffffff8107b47e>] lock_acq
uire+0xde/0x110
Sep  1 18:01:17 localhost kernel: [ 3012.503440]                                        [<ffffffff813e6901>] _spin_lo
ck+0x31/0x70
Sep  1 18:01:17 localhost kernel: [ 3012.503440]                                        [<ffffffff811458c7>] nr_block
dev_pages+0x17/0x80
Sep  1 18:01:17 localhost kernel: [ 3012.503440]                                        [<ffffffff810d2148>] si_memin
fo+0x38/0x60
Sep  1 18:01:17 localhost kernel: [ 3012.503440]                                        [<ffffffff81a26185>] eventpol
l_init+0x11/0xfb
Sep  1 18:01:17 localhost kernel: [ 3012.503440]                                        [<ffffffff81009048>] do_one_i
nitcall+0x38/0x190
Sep  1 18:01:17 localhost kernel: [ 3012.503440]                                        [<ffffffff81a05fcd>] kernel_i
nit+0x18a/0x1e2
Sep  1 18:01:17 localhost kernel: [ 3012.503440]                                        [<ffffffff8100cf9a>] child_ri
p+0xa/0x20
Sep  1 18:01:17 localhost kernel: [ 3012.503440]    INITIAL USE at:
Sep  1 18:01:17 localhost kernel: [ 3012.503440]                                       [<ffffffff810796c0>] __lock_ac
quire+0x200/0x1ee0
Sep  1 18:01:17 localhost kernel: [ 3012.503440]                                       [<ffffffff8107b47e>] lock_acqu
ire+0xde/0x110
Sep  1 18:01:17 localhost kernel: [ 3012.503440]                                       [<ffffffff813e6901>] _spin_loc
k+0x31/0x70
Sep  1 18:01:17 localhost kernel: [ 3012.503440]                                       [<ffffffff811458c7>] nr_blockd
ev_pages+0x17/0x80
Sep  1 18:01:17 localhost kernel: [ 3012.503440]                                       [<ffffffff810d2148>] si_meminf
o+0x38/0x60
Sep  1 18:01:17 localhost kernel: [ 3012.503440]                                       [<ffffffff81a26185>] eventpoll
_init+0x11/0xfb
Sep  1 18:01:17 localhost kernel: [ 3012.503440]                                       [<ffffffff81009048>] do_one_in
itcall+0x38/0x190
Sep  1 18:01:17 localhost kernel: [ 3012.503440]                                       [<ffffffff81a05fcd>] kernel_in
it+0x18a/0x1e2
Sep  1 18:01:17 localhost kernel: [ 3012.503440]                                       [<ffffffff8100cf9a>] child_rip
+0xa/0x20
Sep  1 18:01:17 localhost kernel: [ 3012.503440]  }
Sep  1 18:01:17 localhost kernel: [ 3012.503440]  ... key      at: [<ffffffff81754058>] bdev_lock+0x18/0x40
Sep  1 18:01:17 localhost kernel: [ 3012.503440]  ... acquired at:
Sep  1 18:01:17 localhost kernel: [ 3012.503440]    [<ffffffff81079424>] check_irq_usage+0x64/0x100
Sep  1 18:01:17 localhost kernel: [ 3012.503440]    [<ffffffff8107a6f9>] __lock_acquire+0x1239/0x1ee0
Sep  1 18:01:17 localhost kernel: [ 3012.503440]    [<ffffffff8107b47e>] lock_acquire+0xde/0x110
Sep  1 18:01:17 localhost kernel: [ 3012.503440]    [<ffffffff813e6901>] _spin_lock+0x31/0x70
Sep  1 18:01:17 localhost kernel: [ 3012.503440]    [<ffffffff811458c7>] nr_blockdev_pages+0x17/0x80
Sep  1 18:01:17 localhost kernel: [ 3012.503440]    [<ffffffff810d2202>] show_free_areas+0x92/0x7d0
Sep  1 18:01:17 localhost kernel: [ 3012.503440]    [<ffffffff811f43c4>] show_mem+0x24/0x210
Sep  1 18:01:17 localhost kernel: [ 3012.503440]    [<ffffffff810d4631>] __alloc_pages_nodemask+0x301/0x710
Sep  1 18:01:17 localhost kernel: [ 3012.503440]    [<ffffffff81103ae7>] alloc_pages_current+0x87/0xd0
Sep  1 18:01:17 localhost kernel: [ 3012.503440]    [<ffffffff81108ffe>] new_slab+0x2fe/0x310
Sep  1 18:01:17 localhost kernel: [ 3012.503440]    [<ffffffff811091d0>] __slab_alloc+0x1c0/0x500
Sep  1 18:01:17 localhost kernel: [ 3012.503440]    [<ffffffff81109896>] kmem_cache_alloc+0x156/0x160
Sep  1 18:01:17 localhost kernel: [ 3012.503440]    [<ffffffffa006636c>] scsi_pool_alloc_command+0x2c/0x80 [scsi_mod]
Sep  1 18:01:17 localhost kernel: [ 3012.503440]    [<ffffffffa00663e2>] scsi_host_alloc_command+0x22/0x80 [scsi_mod]
Sep  1 18:01:17 localhost kernel: [ 3012.503440]    [<ffffffffa006674c>] __scsi_get_command+0x1c/0xb0 [scsi_mod]
Sep  1 18:01:17 localhost kernel: [ 3012.503440]    [<ffffffffa0066821>] scsi_get_command+0x41/0xc0 [scsi_mod]
Sep  1 18:01:17 localhost kernel: [ 3012.503440]    [<ffffffffa006d4cd>] scsi_setup_fs_cmnd+0x9d/0x100 [scsi_mod]
Sep  1 18:01:17 localhost kernel: [ 3012.503440]    [<ffffffffa009d258>] sd_prep_fn+0x88/0xa40 [sd_mod]
Sep  1 18:01:17 localhost kernel: [ 3012.503440]    [<ffffffff811db7eb>] blk_peek_request+0x10b/0x200
Sep  1 18:01:17 localhost kernel: [ 3012.503440]    [<ffffffffa006c86a>] scsi_request_fn+0x6a/0x5b0 [scsi_mod]
Sep  1 18:01:17 localhost kernel: [ 3012.503440]    [<ffffffff811dc180>] __blk_run_queue+0x70/0x150
Sep  1 18:01:17 localhost kernel: [ 3012.503440]    [<ffffffff811ea004>] cfq_kick_queue+0x34/0x50
Sep  1 18:01:17 localhost kernel: [ 3012.503440]    [<ffffffff8105ff33>] worker_thread+0x243/0x390
Sep  1 18:01:17 localhost kernel: [ 3012.503440]    [<ffffffff81064fc6>] kthread+0x96/0xb0
Sep  1 18:01:17 localhost kernel: [ 3012.503440]    [<ffffffff8100cf9a>] child_rip+0xa/0x20
Sep  1 18:01:17 localhost kernel: [ 3012.503440]
Sep  1 18:01:17 localhost kernel: [ 3012.503440]
Sep  1 18:01:17 localhost kernel: [ 3012.503440] stack backtrace:
Sep  1 18:01:17 localhost kernel: [ 3012.503440] Pid: 350, comm: kblockd/7 Not tainted 2.6.31-rc7-mm1 #3
Sep  1 18:01:17 localhost kernel: [ 3012.503440] Call Trace:
Sep  1 18:01:17 localhost kernel: [ 3012.503440]  [<ffffffff810792f4>] check_usage+0x4c4/0x590
Sep  1 18:01:17 localhost kernel: [ 3012.503440]  [<ffffffff811f5321>] ? put_dec+0x101/0x110
Sep  1 18:01:17 localhost kernel: [ 3012.503440]  [<ffffffff81079424>] check_irq_usage+0x64/0x100
Sep  1 18:01:17 localhost kernel: [ 3012.503440]  [<ffffffff8107a6f9>] __lock_acquire+0x1239/0x1ee0
Sep  1 18:01:17 localhost kernel: [ 3012.503440]  [<ffffffff81069c29>] ? up+0x19/0x50
Sep  1 18:01:17 localhost kernel: [ 3012.503440]  [<ffffffff8107622d>] ? trace_hardirqs_off+0xd/0x10
Sep  1 18:01:17 localhost kernel: [ 3012.503440]  [<ffffffff8107b47e>] lock_acquire+0xde/0x110
Sep  1 18:01:17 localhost kernel: [ 3012.503440]  [<ffffffff811458c7>] ? nr_blockdev_pages+0x17/0x80
Sep  1 18:01:17 localhost kernel: [ 3012.503440]  [<ffffffff813e6901>] _spin_lock+0x31/0x70
Sep  1 18:01:17 localhost kernel: [ 3012.503440]  [<ffffffff811458c7>] ? nr_blockdev_pages+0x17/0x80
Sep  1 18:01:17 localhost kernel: [ 3012.503440]  [<ffffffff811458c7>] nr_blockdev_pages+0x17/0x80
Sep  1 18:01:17 localhost kernel: [ 3012.503440]  [<ffffffff810d2202>] show_free_areas+0x92/0x7d0
Sep  1 18:01:17 localhost kernel: [ 3012.503440]  [<ffffffff81069c29>] ? up+0x19/0x50
Sep  1 18:01:17 localhost kernel: [ 3012.503440]  [<ffffffff8107622d>] ? trace_hardirqs_off+0xd/0x10
Sep  1 18:01:17 localhost kernel: [ 3012.503440]  [<ffffffff813e6728>] ? _spin_unlock_irqrestore+0x58/0x60
Sep  1 18:01:17 localhost kernel: [ 3012.503440]  [<ffffffff8104ac45>] ? release_console_sem+0x1f5/0x240
Sep  1 18:01:17 localhost kernel: [ 3012.503440]  [<ffffffff8100f016>] ? dump_trace+0x116/0x2d0
Sep  1 18:01:17 localhost kernel: [ 3012.503440]  [<ffffffff813e2e0f>] ? printk+0x3c/0x45
Sep  1 18:01:17 localhost kernel: [ 3012.503440]  [<ffffffff811f43c4>] show_mem+0x24/0x210
Sep  1 18:01:17 localhost kernel: [ 3012.503440]  [<ffffffff8100fea0>] ? show_trace+0x10/0x20
Sep  1 18:01:17 localhost kernel: [ 3012.503440]  [<ffffffff813e2c85>] ? dump_stack+0x72/0x7b
Sep  1 18:01:17 localhost kernel: [ 3012.503440]  [<ffffffff810d4631>] __alloc_pages_nodemask+0x301/0x710
Sep  1 18:01:17 localhost kernel: [ 3012.503440]  [<ffffffff81108eed>] ? new_slab+0x1ed/0x310
Sep  1 18:01:17 localhost kernel: [ 3012.503440]  [<ffffffff810798f1>] ? __lock_acquire+0x431/0x1ee0
Sep  1 18:01:17 localhost kernel: [ 3012.503440]  [<ffffffff81103ae7>] alloc_pages_current+0x87/0xd0
Sep  1 18:01:17 localhost kernel: [ 3012.503440]  [<ffffffff81108ffe>] new_slab+0x2fe/0x310
Sep  1 18:01:17 localhost kernel: [ 3012.503440]  [<ffffffff811091d0>] __slab_alloc+0x1c0/0x500
Sep  1 18:01:17 localhost kernel: [ 3012.503440]  [<ffffffffa006636c>] ? scsi_pool_alloc_command+0x2c/0x80 [scsi_mod]
Sep  1 18:01:17 localhost kernel: [ 3012.503440]  [<ffffffffa006636c>] ? scsi_pool_alloc_command+0x2c/0x80 [scsi_mod]
Sep  1 18:01:17 localhost kernel: [ 3012.503440]  [<ffffffff81109896>] kmem_cache_alloc+0x156/0x160
Sep  1 18:01:17 localhost kernel: [ 3012.503440]  [<ffffffffa006636c>] scsi_pool_alloc_command+0x2c/0x80 [scsi_mod]
Sep  1 18:01:17 localhost kernel: [ 3012.503440]  [<ffffffffa00663e2>] scsi_host_alloc_command+0x22/0x80 [scsi_mod]
Sep  1 18:01:17 localhost kernel: [ 3012.503440]  [<ffffffffa006674c>] __scsi_get_command+0x1c/0xb0 [scsi_mod]
Sep  1 18:01:17 localhost kernel: [ 3012.503440]  [<ffffffffa0066821>] scsi_get_command+0x41/0xc0 [scsi_mod]
Sep  1 18:01:17 localhost kernel: [ 3012.503440]  [<ffffffffa006d4cd>] scsi_setup_fs_cmnd+0x9d/0x100 [scsi_mod]
Sep  1 18:01:17 localhost kernel: [ 3012.503440]  [<ffffffffa009d258>] sd_prep_fn+0x88/0xa40 [sd_mod]
Sep  1 18:01:17 localhost kernel: [ 3012.503440]  [<ffffffff811eb31c>] ? cfq_dispatch_insert+0x4c/0x70
Sep  1 18:01:17 localhost kernel: [ 3012.503440]  [<ffffffff811eb90b>] ? cfq_dispatch_requests+0x16b/0x470
Sep  1 18:01:17 localhost kernel: [ 3012.503440]  [<ffffffff811db7eb>] blk_peek_request+0x10b/0x200
Sep  1 18:01:17 localhost kernel: [ 3012.503440]  [<ffffffffa006c86a>] scsi_request_fn+0x6a/0x5b0 [scsi_mod]
Sep  1 18:01:17 localhost kernel: [ 3012.503440]  [<ffffffff811e9fd0>] ? cfq_kick_queue+0x0/0x50
Sep  1 18:01:17 localhost kernel: [ 3012.503440]  [<ffffffff811dc180>] __blk_run_queue+0x70/0x150
Sep  1 18:01:17 localhost kernel: [ 3012.503440]  [<ffffffff811ea004>] cfq_kick_queue+0x34/0x50
Sep  1 18:01:17 localhost kernel: [ 3012.503440]  [<ffffffff8105ff33>] worker_thread+0x243/0x390
Sep  1 18:01:17 localhost kernel: [ 3012.503440]  [<ffffffff8105fedd>] ? worker_thread+0x1ed/0x390
Sep  1 18:01:17 localhost kernel: [ 3012.503440]  [<ffffffff813e37bc>] ? thread_return+0x3e/0x7a2
Sep  1 18:01:17 localhost kernel: [ 3012.503440]  [<ffffffff810653f0>] ? autoremove_wake_function+0x0/0x40
Sep  1 18:01:17 localhost kernel: [ 3012.503440]  [<ffffffff8105fcf0>] ? worker_thread+0x0/0x390
Sep  1 18:01:17 localhost kernel: [ 3012.503440]  [<ffffffff81064fc6>] kthread+0x96/0xb0
Sep  1 18:01:17 localhost kernel: [ 3012.503440]  [<ffffffff8100cf9a>] child_rip+0xa/0x20
Sep  1 18:01:17 localhost kernel: [ 3012.503440]  [<ffffffff8100c93c>] ? restore_args+0x0/0x30
Sep  1 18:01:17 localhost kernel: [ 3012.503440]  [<ffffffff81064f30>] ? kthread+0x0/0xb0
Sep  1 18:01:17 localhost kernel: [ 3012.503440]  [<ffffffff8100cf90>] ? child_rip+0x0/0x20

