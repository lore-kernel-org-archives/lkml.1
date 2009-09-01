Return-Path: <linux-kernel-owner+w=401wt.eu-S1753447AbZIAU4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447AbZIAU4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 16:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751842AbZIAU4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 16:56:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64069 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751774AbZIAU4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 16:56:17 -0400
Subject: INFO: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected for
 kmemleak_lock
From: Eric Paris <eparis@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: catalin.marinas@arm.com
Content-Type: text/plain
Date: Tue, 01 Sep 2009 16:55:45 -0400
Message-Id: <1251838545.2158.67.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote a multithreaded inotify syscall pounder intended to create
files, destroy files, create watches, and destroy watches with the
maximum number of races possible.  Instead after letting it run a while
I came upon this!  And then my system started to crash in all sorts of
fun and glorious ways (kmem_cache_alloc bugs/panics/whatever)

-Eric

[ 2235.913737] ======================================================
[ 2235.914084] [ INFO: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected ]
[ 2235.914084] 2.6.31-rc8-next-20090901 #64
[ 2235.914084] ------------------------------------------------------
[ 2235.914084] syscall_thrash/2516 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
[ 2235.914084]  (kthread_create_lock){+.+...}, at: [<ffffffff81091543>] kthread_create+0x73/0x180
[ 2235.914084] 
[ 2235.914084] and this task is already holding:
[ 2235.914084]  (kmemleak_lock){..----}, at: [<ffffffff81152611>] create_object+0x161/0x2e0
[ 2235.914084] which would create a new lock dependency:
[ 2235.914084]  (kmemleak_lock){..----} -> (kthread_create_lock){+.+...}
[ 2235.914084] 
[ 2235.914084] but this new dependency connects a HARDIRQ-irq-safe lock:
[ 2235.914084]  (shost->host_lock){-.-.-.}
[ 2235.914084] ... which became HARDIRQ-irq-safe at:
[ 2235.914084]   [<ffffffff810ae613>] __lock_acquire+0x623/0x6d0
[ 2235.914084]   [<ffffffff810ae780>] lock_acquire+0xc0/0x170
[ 2235.914084]   [<ffffffff8152c5ea>] _spin_lock_irqsave+0x6a/0xc0
[ 2235.914084]   [<ffffffff813768f0>] scsi_eh_scmd_add+0x50/0xf0
[ 2235.914084]   [<ffffffff81376a23>] scsi_times_out+0x93/0xc0
[ 2235.914084]   [<ffffffff81270dd5>] blk_rq_timed_out+0x25/0x90
[ 2235.914084]   [<ffffffff81270e74>] blk_abort_request+0x34/0x60
[ 2235.914084]   [<ffffffff813a1069>] ata_qc_schedule_eh+0x59/0x90
[ 2235.914084]   [<ffffffff81394867>] ata_qc_complete+0x1a7/0x210
[ 2235.914084]   [<ffffffff813a5ce5>] ata_hsm_qc_complete+0xe5/0x180
[ 2235.914084]   [<ffffffff813a7059>] ata_sff_hsm_move+0x1d9/0x730
[ 2235.914084]   [<ffffffff813a769a>] ata_sff_host_intr+0xea/0x1b0
[ 2235.914084]   [<ffffffff813a78ea>] ata_sff_interrupt+0xba/0x100
[ 2235.914084]   [<ffffffff810d8420>] handle_IRQ_event+0x70/0x200
[ 2235.914084]   [<ffffffff810db9e0>] handle_edge_irq+0xf0/0x1e0
[ 2235.914084]   [<ffffffff810177f5>] handle_irq+0x55/0xc0
[ 2235.914084]   [<ffffffff8101669a>] do_IRQ+0x7a/0x100
[ 2235.914084]   [<ffffffff81014c93>] ret_from_intr+0x0/0x16
[ 2235.914084] 
[ 2235.914084] to a HARDIRQ-irq-unsafe lock:
[ 2235.914084]  (kthread_create_lock){+.+...}
[ 2235.914084] ... which became HARDIRQ-irq-unsafe at:
[ 2235.914084] ...  [<ffffffff810ae5b0>] __lock_acquire+0x5c0/0x6d0
[ 2235.914084]   [<ffffffff810ae780>] lock_acquire+0xc0/0x170
[ 2235.914084]   [<ffffffff8152bf4b>] _spin_lock+0x4b/0xa0
[ 2235.914084]   [<ffffffff81091543>] kthread_create+0x73/0x180
[ 2235.914084]   [<ffffffff815254b5>] migration_call+0x255/0x650
[ 2235.914084]   [<ffffffff819ec503>] migration_init+0x33/0x80
[ 2235.914084]   [<ffffffff8100a070>] do_one_initcall+0x40/0x1b0
[ 2235.914084]   [<ffffffff819cb8bc>] kernel_init+0xec/0x2e0
[ 2235.914084]   [<ffffffff8101541a>] child_rip+0xa/0x20
[ 2235.914084] 
[ 2235.914084] other info that might help us debug this:
[ 2235.914084] 
[ 2235.914084] 1 lock held by syscall_thrash/2516:
[ 2235.914084]  #0:  (kmemleak_lock){..----}, at: [<ffffffff81152611>] create_object+0x161/0x2e0
[ 2235.914084] 
[ 2235.914084] the dependencies between HARDIRQ-irq-safe lock and the holding lock:
[ 2235.914084]  -> (shost->host_lock){-.-.-.} ops: 31846 {
[ 2235.914084]     IN-HARDIRQ-W at:
[ 2235.914084]                                          [<ffffffff810ae613>] __lock_acquire+0x623/0x6d0
[ 2235.914084]                                          [<ffffffff810ae780>] lock_acquire+0xc0/0x170
[ 2235.914084]                                          [<ffffffff8152c5ea>] _spin_lock_irqsave+0x6a/0xc0
[ 2235.914084]                                          [<ffffffff813768f0>] scsi_eh_scmd_add+0x50/0xf0
[ 2235.914084]                                          [<ffffffff81376a23>] scsi_times_out+0x93/0xc0
[ 2235.914084]                                          [<ffffffff81270dd5>] blk_rq_timed_out+0x25/0x90
[ 2235.914084]                                          [<ffffffff81270e74>] blk_abort_request+0x34/0x60
[ 2235.914084]                                          [<ffffffff813a1069>] ata_qc_schedule_eh+0x59/0x90
[ 2235.914084]                                          [<ffffffff81394867>] ata_qc_complete+0x1a7/0x210
[ 2235.914084]                                          [<ffffffff813a5ce5>] ata_hsm_qc_complete+0xe5/0x180
[ 2235.914084]                                          [<ffffffff813a7059>] ata_sff_hsm_move+0x1d9/0x730
[ 2235.914084]                                          [<ffffffff813a769a>] ata_sff_host_intr+0xea/0x1b0
[ 2235.914084]                                          [<ffffffff813a78ea>] ata_sff_interrupt+0xba/0x100
[ 2235.914084]                                          [<ffffffff810d8420>] handle_IRQ_event+0x70/0x200
[ 2235.914084]                                          [<ffffffff810db9e0>] handle_edge_irq+0xf0/0x1e0
[ 2235.914084]                                          [<ffffffff810177f5>] handle_irq+0x55/0xc0
[ 2235.914084]                                          [<ffffffff8101669a>] do_IRQ+0x7a/0x100
[ 2235.914084]                                          [<ffffffff81014c93>] ret_from_intr+0x0/0x16
[ 2235.914084]     IN-SOFTIRQ-W at:
[ 2235.914084]                                          [<ffffffff810ae523>] __lock_acquire+0x533/0x6d0
[ 2235.914084]                                          [<ffffffff810ae780>] lock_acquire+0xc0/0x170
[ 2235.914084]                                          [<ffffffff8152c5ea>] _spin_lock_irqsave+0x6a/0xc0
[ 2235.914084]                                          [<ffffffff81378f35>] scsi_device_unbusy+0x45/0x100
[ 2235.914084]                                          [<ffffffff813711b0>] scsi_finish_command+0x40/0x140
[ 2235.914084]                                          [<ffffffff8137a06d>] scsi_softirq_done+0x15d/0x190
[ 2235.914084]                                          [<ffffffff81270985>] blk_done_softirq+0x95/0xc0
[ 2235.914084]                                          [<ffffffff81078664>] __do_softirq+0xf4/0x280
[ 2235.914084]                                          [<ffffffff8101551c>] call_softirq+0x1c/0x30
[ 2235.914084]                                          [<ffffffff81017906>] do_softirq+0xa6/0xf0
[ 2235.914084]                                          [<ffffffff810788a7>] irq_exit+0xb7/0xd0
[ 2235.914084]                                          [<ffffffff810166a3>] do_IRQ+0x83/0x100
[ 2235.914084]                                          [<ffffffff81014c93>] ret_from_intr+0x0/0x16
[ 2235.914084]     IN-RECLAIM_FS-W at:
[ 2235.914084]                                             [<ffffffff810ae4a8>] __lock_acquire+0x4b8/0x6d0
[ 2235.914084]                                             [<ffffffff810ae780>] lock_acquire+0xc0/0x170
[ 2235.914084]                                             [<ffffffff8152c5ea>] _spin_lock_irqsave+0x6a/0xc0
[ 2235.914084]                                             [<ffffffff81378f35>] scsi_device_unbusy+0x45/0x100
[ 2235.914084]                                             [<ffffffff813711b0>] scsi_finish_command+0x40/0x140
[ 2235.914084]                                             [<ffffffff8137a06d>] scsi_softirq_done+0x15d/0x190
[ 2235.914084]                                             [<ffffffff81270985>] blk_done_softirq+0x95/0xc0
[ 2235.914084]                                             [<ffffffff81078664>] __do_softirq+0xf4/0x280
[ 2235.914084]                                             [<ffffffff8101551c>] call_softirq+0x1c/0x30
[ 2235.914084]                                             [<ffffffff81017906>] do_softirq+0xa6/0xf0
[ 2235.914084]                                             [<ffffffff810788a7>] irq_exit+0xb7/0xd0
[ 2235.914084]                                             [<ffffffff810166a3>] do_IRQ+0x83/0x100
[ 2235.914084]                                             [<ffffffff81014c93>] ret_from_intr+0x0/0x16
[ 2235.914084]     INITIAL USE at:
[ 2235.914084]                                         [<ffffffff810ae2e0>] __lock_acquire+0x2f0/0x6d0
[ 2235.914084]                                         [<ffffffff810ae780>] lock_acquire+0xc0/0x170
[ 2235.914084]                                         [<ffffffff8152c5ea>] _spin_lock_irqsave+0x6a/0xc0
[ 2235.914084]                                         [<ffffffff8137d78a>] scsi_scan_host+0x11a/0x280
[ 2235.914084]                                         [<ffffffffa00b6a6a>] mptspi_probe+0x3ea/0x450 [mptspi]
[ 2235.914084]                                         [<ffffffff812a3ee5>] local_pci_probe+0x25/0x40
[ 2235.914084]                                         [<ffffffff812a4f71>] pci_device_probe+0x121/0x130
[ 2235.914084]                                         [<ffffffff8135dd2b>] driver_probe_device+0xab/0x290
[ 2235.914084]                                         [<ffffffff8135e276>] __driver_attach+0xa6/0xb0
[ 2235.914084]                                         [<ffffffff8135c9fd>] bus_for_each_dev+0x6d/0xb0
[ 2235.914084]                                         [<ffffffff8135dabf>] driver_attach+0x2f/0x50
[ 2235.914084]                                         [<ffffffff8135d5d5>] bus_add_driver+0x235/0x360
[ 2235.914084]                                         [<ffffffff8135e439>] driver_register+0x79/0x180
[ 2235.914084]                                         [<ffffffff812a4c76>] __pci_register_driver+0x76/0x100
[ 2235.914084]                                         [<ffffffffa00be0d8>] 0xffffffffa00be0d8
[ 2235.914084]                                         [<ffffffff8100a070>] do_one_initcall+0x40/0x1b0
[ 2235.914084]                                         [<ffffffff810bea28>] sys_init_module+0x108/0x260
[ 2235.914084]                                         [<ffffffff81014282>] system_call_fastpath+0x16/0x1b
[ 2235.914084]   }
[ 2235.914084]   ... key      at: [<ffffffff82636604>] __key.30665+0x0/0x8
[ 2235.914084]   ... acquired at:
[ 2235.914084]    [<ffffffff810ad93c>] validate_chain+0xcec/0x13a0
[ 2235.914084]    [<ffffffff810ae397>] __lock_acquire+0x3a7/0x6d0
[ 2235.914084]    [<ffffffff810ae780>] lock_acquire+0xc0/0x170
[ 2235.914084]    [<ffffffff8152c28a>] _write_lock_irqsave+0x6a/0xc0
[ 2235.914084]    [<ffffffff81151e59>] __delete_object+0x29/0xf0
[ 2235.914084]    [<ffffffff8115212f>] delete_object_full+0x2f/0x60
[ 2235.914084]    [<ffffffff8151249d>] kmemleak_free+0x4d/0xc0
[ 2235.914084]    [<ffffffff81149a00>] kfree+0x180/0x220
[ 2235.914084]    [<ffffffffa00b61ac>] mptspi_target_destroy+0x2c/0x60 [mptspi]
[ 2235.914084]    [<ffffffff8137b259>] scsi_target_destroy+0x79/0xe0
[ 2235.914084]    [<ffffffff8137b3ab>] scsi_target_reap+0xeb/0x100
[ 2235.914084]    [<ffffffff8137cb46>] __scsi_scan_target+0xb6/0x740
[ 2235.914084]    [<ffffffff8137d269>] scsi_scan_channel+0x99/0xb0
[ 2235.914084]    [<ffffffff8137d36f>] scsi_scan_host_selected+0xef/0x1a0
[ 2235.914084]    [<ffffffff8137d4c2>] do_scsi_scan_host+0xa2/0xb0
[ 2235.914084]    [<ffffffff8137d4fc>] do_scan_async+0x2c/0x1a0
[ 2235.914084]    [<ffffffff810911cc>] kthread+0xac/0xc0
[ 2235.914084]    [<ffffffff8101541a>] child_rip+0xa/0x20
[ 2235.914084] 
[ 2235.914084] -> (kmemleak_lock){..----} ops: 55874890 {
[ 2235.914084]    IN-SOFTIRQ-W at:
[ 2235.914084]                                        [<ffffffff810ae523>] __lock_acquire+0x533/0x6d0
[ 2235.914084]                                        [<ffffffff810ae780>] lock_acquire+0xc0/0x170
[ 2235.914084]                                        [<ffffffff8152c28a>] _write_lock_irqsave+0x6a/0xc0
[ 2235.914084]                                        [<ffffffff81151e59>] __delete_object+0x29/0xf0
[ 2235.914084]                                        [<ffffffff8115212f>] delete_object_full+0x2f/0x60
[ 2235.914084]                                        [<ffffffff8151249d>] kmemleak_free+0x4d/0xc0
[ 2235.914084]                                        [<ffffffff81149a00>] kfree+0x180/0x220
[ 2235.914084]                                        [<ffffffff8121bb1b>] selinux_cred_free+0x2b/0x50
[ 2235.914084]                                        [<ffffffff812111f4>] security_cred_free+0x24/0x40
[ 2235.914084]                                        [<ffffffff81099490>] put_cred_rcu+0x30/0xb0
[ 2235.914084]                                        [<ffffffff810ddeda>] __rcu_process_callbacks+0x18a/0x320
[ 2235.914084]                                        [<ffffffff810de0b7>] rcu_process_callbacks+0x47/0x90
[ 2235.914084]                                        [<ffffffff81078664>] __do_softirq+0xf4/0x280
[ 2235.914084]                                        [<ffffffff8101551c>] call_softirq+0x1c/0x30
[ 2235.914084]                                        [<ffffffff81017906>] do_softirq+0xa6/0xf0
[ 2235.914084]                                        [<ffffffff810788a7>] irq_exit+0xb7/0xd0
[ 2235.914084]                                        [<ffffffff81031dbd>] smp_apic_timer_interrupt+0x7d/0xd0
[ 2235.914084]                                        [<ffffffff81014ee3>] apic_timer_interrupt+0x13/0x20
[ 2235.914084]    IN-SOFTIRQ-R at:
[ 2235.914084]                                        [<ffffffff810ae523>] __lock_acquire+0x533/0x6d0
[ 2235.914084]                                        [<ffffffff810ae780>] lock_acquire+0xc0/0x170
[ 2235.914084]                                        [<ffffffff8152c52d>] _read_lock_irqsave+0x6d/0xc0
[ 2235.914084]                                        [<ffffffff8115203e>] find_and_get_object+0x5e/0x120
[ 2235.914084]                                        [<ffffffff8115211f>] delete_object_full+0x1f/0x60
[ 2235.914084]                                        [<ffffffff8151249d>] kmemleak_free+0x4d/0xc0
[ 2235.914084]                                        [<ffffffff81149a00>] kfree+0x180/0x220
[ 2235.914084]                                        [<ffffffff8121bb1b>] selinux_cred_free+0x2b/0x50
[ 2235.914084]                                        [<ffffffff812111f4>] security_cred_free+0x24/0x40
[ 2235.914084]                                        [<ffffffff81099490>] put_cred_rcu+0x30/0xb0
[ 2235.914084]                                        [<ffffffff810ddeda>] __rcu_process_callbacks+0x18a/0x320
[ 2235.914084]                                        [<ffffffff810de0b7>] rcu_process_callbacks+0x47/0x90
[ 2235.914084]                                        [<ffffffff81078664>] __do_softirq+0xf4/0x280
[ 2235.914084]                                        [<ffffffff8101551c>] call_softirq+0x1c/0x30
[ 2235.914084]                                        [<ffffffff81017906>] do_softirq+0xa6/0xf0
[ 2235.914084]                                        [<ffffffff810788a7>] irq_exit+0xb7/0xd0
[ 2235.914084]                                        [<ffffffff81031dbd>] smp_apic_timer_interrupt+0x7d/0xd0
[ 2235.914084]                                        [<ffffffff81014ee3>] apic_timer_interrupt+0x13/0x20
[ 2235.914084]    IN-RECLAIM_FS-W at:
[ 2235.914084]                                           [<ffffffff810ae4a8>] __lock_acquire+0x4b8/0x6d0
[ 2235.914084]                                           [<ffffffff810ae780>] lock_acquire+0xc0/0x170
[ 2235.914084]                                           [<ffffffff8152c28a>] _write_lock_irqsave+0x6a/0xc0
[ 2235.914084]                                           [<ffffffff81151e59>] __delete_object+0x29/0xf0
[ 2235.914084]                                           [<ffffffff8115212f>] delete_object_full+0x2f/0x60
[ 2235.914084]                                           [<ffffffff8151249d>] kmemleak_free+0x4d/0xc0
[ 2235.914084]                                           [<ffffffff81149e8c>] kmem_cache_free+0x14c/0x1f0
[ 2235.914084]                                           [<ffffffff81157846>] file_free_rcu+0x46/0x70
[ 2235.914084]                                           [<ffffffff810ddeda>] __rcu_process_callbacks+0x18a/0x320
[ 2235.914084]                                           [<ffffffff810de0b7>] rcu_process_callbacks+0x47/0x90
[ 2235.914084]                                           [<ffffffff81078664>] __do_softirq+0xf4/0x280
[ 2235.914084]                                           [<ffffffff8101551c>] call_softirq+0x1c/0x30
[ 2235.914084]                                           [<ffffffff81017906>] do_softirq+0xa6/0xf0
[ 2235.914084]                                           [<ffffffff810788a7>] irq_exit+0xb7/0xd0
[ 2235.914084]                                           [<ffffffff81031dbd>] smp_apic_timer_interrupt+0x7d/0xd0
[ 2235.914084]                                           [<ffffffff81014ee3>] apic_timer_interrupt+0x13/0x20
[ 2235.914084]    IN-RECLAIM_FS-R at:
[ 2235.914084]                                           [<ffffffff810ae4a8>] __lock_acquire+0x4b8/0x6d0
[ 2235.914084]                                           [<ffffffff810ae780>] lock_acquire+0xc0/0x170
[ 2235.914084]                                           [<ffffffff8152c52d>] _read_lock_irqsave+0x6d/0xc0
[ 2235.914084]                                           [<ffffffff8115203e>] find_and_get_object+0x5e/0x120
[ 2235.914084]                                           [<ffffffff8115211f>] delete_object_full+0x1f/0x60
[ 2235.914084]                                           [<ffffffff8151249d>] kmemleak_free+0x4d/0xc0
[ 2235.914084]                                           [<ffffffff81149e8c>] kmem_cache_free+0x14c/0x1f0
[ 2235.914084]                                           [<ffffffff81157846>] file_free_rcu+0x46/0x70
[ 2235.914084]                                           [<ffffffff810ddeda>] __rcu_process_callbacks+0x18a/0x320
[ 2235.914084]                                           [<ffffffff810de0b7>] rcu_process_callbacks+0x47/0x90
[ 2235.914084]                                           [<ffffffff81078664>] __do_softirq+0xf4/0x280
[ 2235.914084]                                           [<ffffffff8101551c>] call_softirq+0x1c/0x30
[ 2235.914084]                                           [<ffffffff81017906>] do_softirq+0xa6/0xf0
[ 2235.914084]                                           [<ffffffff810788a7>] irq_exit+0xb7/0xd0
[ 2235.914084]                                           [<ffffffff81031dbd>] smp_apic_timer_interrupt+0x7d/0xd0
[ 2235.914084]                                           [<ffffffff81014ee3>] apic_timer_interrupt+0x13/0x20
[ 2235.914084]    INITIAL USE at:
[ 2235.914084]                                       [<ffffffff810ae2e0>] __lock_acquire+0x2f0/0x6d0
[ 2235.914084]                                       [<ffffffff810ae780>] lock_acquire+0xc0/0x170
[ 2235.914084]                                       [<ffffffff8152c52d>] _read_lock_irqsave+0x6d/0xc0
[ 2235.914084]                                       [<ffffffff8115203e>] find_and_get_object+0x5e/0x120
[ 2235.914084]                                       [<ffffffff81512358>] kmemleak_free_part+0x68/0x160
[ 2235.914084]                                       [<ffffffff819f8fc9>] kmemleak_init+0x279/0x300
[ 2235.914084]                                       [<ffffffff819cb60e>] start_kernel+0x2de/0x4a0
[ 2235.914084]                                       [<ffffffff819caa41>] x86_64_start_reservations+0xc1/0x100
[ 2235.914084]                                       [<ffffffff819cab88>] x86_64_start_kernel+0x108/0x150
[ 2235.914084]  }
[ 2235.914084]  ... key      at: [<ffffffff817810b8>] kmemleak_lock+0x18/0x40
[ 2235.914084]  ... acquired at:
[ 2235.914084]    [<ffffffff810acbbb>] check_irq_usage+0x6b/0x100
[ 2235.914084]    [<ffffffff810ad535>] validate_chain+0x8e5/0x13a0
[ 2235.914084]    [<ffffffff810ae397>] __lock_acquire+0x3a7/0x6d0
[ 2235.914084]    [<ffffffff810ae780>] lock_acquire+0xc0/0x170
[ 2235.914084]    [<ffffffff8152bf4b>] _spin_lock+0x4b/0xa0
[ 2235.914084]    [<ffffffff81091543>] kthread_create+0x73/0x180
[ 2235.914084]    [<ffffffff81151a4c>] kmemleak_cleanup+0x2c/0x70
[ 2235.914084]    [<ffffffff81151afa>] kmemleak_disable+0x6a/0x80
[ 2235.914084]    [<ffffffff81152671>] create_object+0x1c1/0x2e0
[ 2235.914084]    [<ffffffff81511d2e>] kmemleak_alloc+0x6e/0xf0
[ 2235.914084]    [<ffffffff8114adb3>] kmem_cache_alloc+0x153/0x200
[ 2235.914084]    [<ffffffff81194afc>] sys_inotify_add_watch+0x1dc/0x3a0
[ 2235.914084]    [<ffffffff81014282>] system_call_fastpath+0x16/0x1b
[ 2235.914084] 
[ 2235.914084] 
[ 2235.914084] the dependencies between the lock to be acquired and HARDIRQ-irq-unsafe lock:
[ 2235.914084] -> (kthread_create_lock){+.+...} ops: 167 {
[ 2235.914084]    HARDIRQ-ON-W at:
[ 2235.914084]                                        [<ffffffff810ae5b0>] __lock_acquire+0x5c0/0x6d0
[ 2235.914084]                                        [<ffffffff810ae780>] lock_acquire+0xc0/0x170
[ 2235.914084]                                        [<ffffffff8152bf4b>] _spin_lock+0x4b/0xa0
[ 2235.914084]                                        [<ffffffff81091543>] kthread_create+0x73/0x180
[ 2235.914084]                                        [<ffffffff815254b5>] migration_call+0x255/0x650
[ 2235.914084]                                        [<ffffffff819ec503>] migration_init+0x33/0x80
[ 2235.914084]                                        [<ffffffff8100a070>] do_one_initcall+0x40/0x1b0
[ 2235.914084]                                        [<ffffffff819cb8bc>] kernel_init+0xec/0x2e0
[ 2235.914084]                                        [<ffffffff8101541a>] child_rip+0xa/0x20
[ 2235.914084]    SOFTIRQ-ON-W at:
[ 2235.914084]                                        [<ffffffff810ae5d7>] __lock_acquire+0x5e7/0x6d0
[ 2235.914084]                                        [<ffffffff810ae780>] lock_acquire+0xc0/0x170
[ 2235.914084]                                        [<ffffffff8152bf4b>] _spin_lock+0x4b/0xa0
[ 2235.914084]                                        [<ffffffff81091543>] kthread_create+0x73/0x180
[ 2235.914084]                                        [<ffffffff815254b5>] migration_call+0x255/0x650
[ 2235.914084]                                        [<ffffffff819ec503>] migration_init+0x33/0x80
[ 2235.914084]                                        [<ffffffff8100a070>] do_one_initcall+0x40/0x1b0
[ 2235.914084]                                        [<ffffffff819cb8bc>] kernel_init+0xec/0x2e0
[ 2235.914084]                                        [<ffffffff8101541a>] child_rip+0xa/0x20
[ 2235.914084]    INITIAL USE at:
[ 2235.914084]                                       [<ffffffff810ae2e0>] __lock_acquire+0x2f0/0x6d0
[ 2235.914084]                                       [<ffffffff810ae780>] lock_acquire+0xc0/0x170
[ 2235.914084]                                       [<ffffffff8152bf4b>] _spin_lock+0x4b/0xa0
[ 2235.914084]                                       [<ffffffff81091543>] kthread_create+0x73/0x180
[ 2235.914084]                                       [<ffffffff815254b5>] migration_call+0x255/0x650
[ 2235.914084]                                       [<ffffffff819ec503>] migration_init+0x33/0x80
[ 2235.914084]                                       [<ffffffff8100a070>] do_one_initcall+0x40/0x1b0
[ 2235.914084]                                       [<ffffffff819cb8bc>] kernel_init+0xec/0x2e0
[ 2235.914084]                                       [<ffffffff8101541a>] child_rip+0xa/0x20
[ 2235.914084]  }
[ 2235.914084]  ... key      at: [<ffffffff817751f8>] kthread_create_lock+0x18/0x40
[ 2235.914084]  ... acquired at:
[ 2235.914084]    [<ffffffff810acbbb>] check_irq_usage+0x6b/0x100
[ 2235.914084]    [<ffffffff810ad535>] validate_chain+0x8e5/0x13a0
[ 2235.914084]    [<ffffffff810ae397>] __lock_acquire+0x3a7/0x6d0
[ 2235.914084]    [<ffffffff810ae780>] lock_acquire+0xc0/0x170
[ 2235.914084]    [<ffffffff8152bf4b>] _spin_lock+0x4b/0xa0
[ 2235.914084]    [<ffffffff81091543>] kthread_create+0x73/0x180
[ 2235.914084]    [<ffffffff81151a4c>] kmemleak_cleanup+0x2c/0x70
[ 2235.914084]    [<ffffffff81151afa>] kmemleak_disable+0x6a/0x80
[ 2235.914084]    [<ffffffff81152671>] create_object+0x1c1/0x2e0
[ 2235.914084]    [<ffffffff81511d2e>] kmemleak_alloc+0x6e/0xf0
[ 2235.914084]    [<ffffffff8114adb3>] kmem_cache_alloc+0x153/0x200
[ 2235.914084]    [<ffffffff81194afc>] sys_inotify_add_watch+0x1dc/0x3a0
[ 2235.914084]    [<ffffffff81014282>] system_call_fastpath+0x16/0x1b
[ 2235.914084] 
[ 2235.914084] 
[ 2235.914084] stack backtrace:
[ 2235.914084] Pid: 2516, comm: syscall_thrash Not tainted 2.6.31-rc8-next-20090901 #64
[ 2235.914084] Call Trace:
[ 2235.914084]  [<ffffffff810aca42>] check_usage+0x472/0x580
[ 2235.914084]  [<ffffffff810acbbb>] check_irq_usage+0x6b/0x100
[ 2235.914084]  [<ffffffff810ad535>] validate_chain+0x8e5/0x13a0
[ 2235.914084]  [<ffffffff81071be9>] ? vprintk+0x1b9/0x5a0
[ 2235.914084]  [<ffffffff810ae397>] __lock_acquire+0x3a7/0x6d0
[ 2235.914084]  [<ffffffff81091543>] ? kthread_create+0x73/0x180
[ 2235.914084]  [<ffffffff81091543>] ? kthread_create+0x73/0x180
[ 2235.914084]  [<ffffffff810ae780>] lock_acquire+0xc0/0x170
[ 2235.914084]  [<ffffffff81091543>] ? kthread_create+0x73/0x180
[ 2235.914084]  [<ffffffff8152bf4b>] _spin_lock+0x4b/0xa0
[ 2235.914084]  [<ffffffff81091543>] ? kthread_create+0x73/0x180
[ 2235.914084]  [<ffffffff81091d3d>] ? __init_waitqueue_head+0x4d/0x80
[ 2235.914084]  [<ffffffff81091543>] kthread_create+0x73/0x180
[ 2235.914084]  [<ffffffff81152ad0>] ? kmemleak_cleanup_thread+0x0/0x100
[ 2235.914084]  [<ffffffff81017cad>] ? dump_trace+0x13d/0x320
[ 2235.914084]  [<ffffffff81019004>] ? show_trace_log_lvl+0x64/0x90
[ 2235.914084]  [<ffffffff81019053>] ? show_trace+0x23/0x40
[ 2235.914084]  [<ffffffff81151a4c>] kmemleak_cleanup+0x2c/0x70
[ 2235.914084]  [<ffffffff81151afa>] kmemleak_disable+0x6a/0x80
[ 2235.914084]  [<ffffffff81152671>] create_object+0x1c1/0x2e0
[ 2235.914084]  [<ffffffff8104d711>] ? mark_shadow+0x61/0xf0
[ 2235.914084]  [<ffffffff81511d2e>] kmemleak_alloc+0x6e/0xf0
[ 2235.914084]  [<ffffffff8114adb3>] kmem_cache_alloc+0x153/0x200
[ 2235.914084]  [<ffffffff81194afc>] sys_inotify_add_watch+0x1dc/0x3a0
[ 2235.914084]  [<ffffffff810ac20d>] ? trace_hardirqs_on_caller+0x14d/0x1e0
[ 2235.914084]  [<ffffffff81014282>] system_call_fastpath+0x16/0x1b


