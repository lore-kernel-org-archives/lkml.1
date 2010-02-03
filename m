Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203Ab0BCLyj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 06:54:39 -0500
Received: from mtagate1.de.ibm.com ([195.212.17.161]:34350 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757172Ab0BCLyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 06:54:37 -0500
Date: Wed, 3 Feb 2010 12:54:32 +0100 (CET)
From: Sebastian Ott <sebott@linux.vnet.ibm.com>
X-X-Sender: sebott@localhost
To: linux-kernel@vger.kernel.org
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: lockdep: irq lock inversion dependency
Message-ID: <alpine.LFD.2.00.1002031251380.2108@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Organization: "IBM Deutschland Research & Development GmbH Vorsitzender des Aufsichtsrats: Martin Jetter Geschaeftsfuehrung: Dirk Wittkopp Sitz der Gesellschaft: Boeblingen Registergericht: Amtsgericht Stuttgart, HRB 243294"
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

today this appeared on s390 running 2.6.32.7:
[21767.804859] =========================================================
[21767.804871] [ INFO: possible irq lock inversion dependency detected ]
[21767.804877] 2.6.32.7 #2
[21767.804882] ---------------------------------------------------------
[21767.804887] swapper/0 just changed the state of lock:
[21767.804893]  (&sighand->siglock){-.-.-.}, at: [<000000000016af86>] lock_task_sighand+0x7e/0xfc
[21767.804917] but this lock took another, SOFTIRQ-READ-unsafe lock in the past:
[21767.804925]  (&f->f_owner.lock){.+.+..}
[21767.804932] 
[21767.804933] and interrupts could create inverse lock ordering between them.
[21767.804934] 
[21767.804953] 
[21767.804954] other info that might help us debug this:
[21767.804968] 2 locks held by swapper/0:
[21767.804976]  #0:  (rcu_read_lock){.+.+..}, at: [<000000000016c128>] kill_pid_info+0x0/0xe8
[21767.805002]  #1:  (rcu_read_lock){.+.+..}, at: [<000000000016af08>] lock_task_sighand+0x0/0xfc
[21767.805030] 
[21767.805030] the shortest dependencies between 2nd lock and 1st lock:
[21767.805066]   -> (&f->f_owner.lock){.+.+..} ops: 12296491368448 {
[21767.805074]      HARDIRQ-ON-R at:
[21767.805078]                                            [<0000000000193bde>] __lock_acquire+0x38e/0x192c
[21767.805088]                                            [<00000000001952cc>] lock_acquire+0x150/0x180
[21767.805094]                                            [<000000000058bafa>] _read_lock+0x5a/0x98
[21767.805104]                                            [<00000000002507ba>] f_getown+0x36/0x6c
[21767.805112]                                            [<0000000000250fc0>] SyS_fcntl+0x590/0x698
[21767.805119]                                            [<0000000000118f1e>] sysc_noemu+0x10/0x16
[21767.805128]                                            [<0000004467253b48>] 0x4467253b48
[21767.805141]      SOFTIRQ-ON-R at:
[21767.805145]                                            [<0000000000194464>] __lock_acquire+0xc14/0x192c
[21767.805151]                                            [<00000000001952cc>] lock_acquire+0x150/0x180
[21767.805191]                                            [<000000000058bafa>] _read_lock+0x5a/0x98
[21767.805197]                                            [<00000000002507ba>] f_getown+0x36/0x6c
[21767.805203]                                            [<0000000000250fc0>] SyS_fcntl+0x590/0x698
[21767.805209]                                            [<0000000000118f1e>] sysc_noemu+0x10/0x16
[21767.805215]                                            [<0000004467253b48>] 0x4467253b48
[21767.805230]      INITIAL USE at:
[21767.805239]                                           [<0000000000193a5e>] __lock_acquire+0x20e/0x192c
[21767.805251]                                           [<00000000001952cc>] lock_acquire+0x150/0x180
[21767.805265]                                           [<000000000058bafa>] _read_lock+0x5a/0x98
[21767.805279]                                           [<00000000002507ba>] f_getown+0x36/0x6c
[21767.805294]                                           [<0000000000250fc0>] SyS_fcntl+0x590/0x698
[21767.805312]                                           [<0000000000118f1e>] sysc_noemu+0x10/0x16
[21767.805318]                                           [<0000004467253b48>] 0x4467253b48
[21767.805324]    }
[21767.805326]    ... key      at: [<00000000013abc18>] __key.23635+0x0/0x8
[21767.805334]    ... acquired at:
[21767.805336]    [<0000000000194850>] __lock_acquire+0x1000/0x192c
[21767.805352]    [<00000000001952cc>] lock_acquire+0x150/0x180
[21767.805361]    [<000000000058b7a2>] _write_lock_irqsave+0x6a/0xb4
[21767.805372]    [<0000000000250832>] f_modown+0x42/0xe4
[21767.805383]    [<0000000000250938>] __f_setown+0x50/0x64
[21767.805394]    [<00000000003b7e9c>] tty_fasync+0xe4/0x154
[21767.805410]    [<0000000000250f5e>] SyS_fcntl+0x52e/0x698
[21767.805423]    [<0000000000118f1e>] sysc_noemu+0x10/0x16
[21767.805437]    [<0000004467253b48>] 0x4467253b48
[21767.805450] 
[21767.805458]  -> (&tty->ctrl_lock){......} ops: 8233452306432 {
[21767.805485]     INITIAL USE at:
[21767.805499]                                         [<0000000000193a5e>] __lock_acquire+0x20e/0x192c
[21767.805519]                                         [<00000000001952cc>] lock_acquire+0x150/0x180
[21767.805525]                                         [<000000000058b456>] _spin_lock_irqsave+0x6a/0xb4
[21767.805532]                                         [<00000000003b8466>] __proc_set_tty+0x3e/0x158
[21767.805538]                                         [<00000000003bac2a>] tty_ioctl+0x7ae/0xa68
[21767.805543]                                         [<00000000002515f6>] vfs_ioctl+0x4e/0xdc
[21767.805549]                                         [<0000000000251ae4>] do_vfs_ioctl+0x388/0x5bc
[21767.805555]                                         [<0000000000251dc0>] SyS_ioctl+0xa8/0xb0
[21767.805561]                                         [<0000000000118f1e>] sysc_noemu+0x10/0x16
[21767.805567]                                         [<00000044670bdb46>] 0x44670bdb46
[21767.805572]   }
[21767.805574]   ... key      at: [<00000000014d0c18>] __key.25620+0x0/0x8
[21767.805583]   ... acquired at:
[21767.805586]    [<0000000000194850>] __lock_acquire+0x1000/0x192c
[21767.805591]    [<00000000001952cc>] lock_acquire+0x150/0x180
[21767.805674]    [<000000000058b456>] _spin_lock_irqsave+0x6a/0xb4
[21767.805680]    [<00000000003b8466>] __proc_set_tty+0x3e/0x158
[21767.805687]    [<00000000003bac2a>] tty_ioctl+0x7ae/0xa68
[21767.805694]    [<00000000002515f6>] vfs_ioctl+0x4e/0xdc
[21767.805702]    [<0000000000251ae4>] do_vfs_ioctl+0x388/0x5bc
[21767.805711]    [<0000000000251dc0>] SyS_ioctl+0xa8/0xb0
[21767.805720]    [<0000000000118f1e>] sysc_noemu+0x10/0x16
[21767.805730]    [<00000044670bdb46>] 0x44670bdb46
[21767.805740] 
[21767.805746] -> (&sighand->siglock){-.-.-.} ops: 902754880978944 {
[21767.805766]    IN-HARDIRQ-W at:
[21767.805776]                                        [<0000000000194320>] __lock_acquire+0xad0/0x192c
[21767.805790]                                        [<00000000001952cc>] lock_acquire+0x150/0x180
[21767.805805]                                        [<000000000058b456>] _spin_lock_irqsave+0x6a/0xb4
[21767.805820]                                        [<000000000016af86>] lock_task_sighand+0x7e/0xfc
[21767.805838]                                        [<000000000016bcb8>] do_send_sig_info+0x3c/0xa0
[21767.805844]                                        [<000000000016c1b2>] kill_pid_info+0x8a/0xe8
[21767.805850]                                        [<00000000001595b6>] it_real_fn+0xce/0xec
[21767.805858]                                        [<000000000017d92a>] __run_hrtimer+0x19a/0x2c8
[21767.805868]                                        [<000000000017dd2e>] hrtimer_interrupt+0x102/0x1f4
[21767.805874]                                        [<0000000000107ca0>] clock_comparator_work+0x60/0x68
[21767.805897]                                        [<000000000010f02c>] do_extint+0x18c/0x190
[21767.805911]                                        [<000000000011974c>] ext_no_vtime+0x1e/0x22
[21767.805926]                                        [<00000000001164f8>] vtime_stop_cpu+0xac/0x100
[21767.805942]    IN-SOFTIRQ-W at:
[21767.805955]                                        [<0000000000194060>] __lock_acquire+0x810/0x192c
[21767.805973]                                        [<00000000001952cc>] lock_acquire+0x150/0x180
[21767.805979]                                        [<000000000058b456>] _spin_lock_irqsave+0x6a/0xb4
[21767.805985]                                        [<000000000016af86>] lock_task_sighand+0x7e/0xfc
[21767.805991]                                        [<000000000016bcb8>] do_send_sig_info+0x3c/0xa0
[21767.805997]                                        [<000000000016c1b2>] kill_pid_info+0x8a/0xe8
[21767.806012]                                        [<00000000001595b6>] it_real_fn+0xce/0xec
[21767.806024]                                        [<000000000017d92a>] __run_hrtimer+0x19a/0x2c8
[21767.806037]                                        [<000000000017dd2e>] hrtimer_interrupt+0x102/0x1f4
[21767.806050]                                        [<0000000000107ca0>] clock_comparator_work+0x60/0x68
[21767.806066]                                        [<000000000010f02c>] do_extint+0x18c/0x190
[21767.806082]                                        [<000000000011974c>] ext_no_vtime+0x1e/0x22
[21767.806098]                                        [<000000000058afa4>] _spin_unlock_irqrestore+0x9c/0xa0
[21767.806104]                                        [<000000000058af9a>] _spin_unlock_irqrestore+0x92/0xa0
[21767.806110]                                        [<00000000001c1f28>] __rcu_process_callbacks+0x3a0/0x3c4
[21767.806120]                                        [<00000000001c1fa0>] rcu_process_callbacks+0x54/0x8c
[21767.806135]                                        [<000000000015ce24>] __do_softirq+0x184/0x2e8
[21767.806147]                                        [<0000000000111f68>] do_softirq+0xe4/0xe8
[21767.806160]                                        [<000000000015c814>] irq_exit+0xc0/0xe0
[21767.806173]                                        [<000000000010efe6>] do_extint+0x146/0x190
[21767.806188]                                        [<000000000011974c>] ext_no_vtime+0x1e/0x22
[21767.806204]                                        [<00000000001164f8>] vtime_stop_cpu+0xac/0x100
[21767.806222]    IN-RECLAIM_FS-W at:
[21767.806226]                                           [<000000000019433c>] __lock_acquire+0xaec/0x192c
[21767.806232]                                           [<00000000001952cc>] lock_acquire+0x150/0x180
[21767.806238]                                           [<000000000058b3a8>] _spin_lock_irq+0x64/0xa8
[21767.806244]                                           [<0000000000184032>] refrigerator+0xae/0x15c
[21767.806263]                                           [<00000000001fe066>] kswapd+0x736/0x74c
[21767.806276]                                           [<00000000001796c4>] kthread+0x9c/0xa4
[21767.806289]                                           [<000000000010a5d2>] kernel_thread_starter+0x6/0xc
[21767.806303]                                           [<000000000010a5cc>] kernel_thread_starter+0x0/0xc
[21767.806318]    INITIAL USE at:
[21767.806330]                                       [<0000000000193a5e>] __lock_acquire+0x20e/0x192c
[21767.806347]                                       [<00000000001952cc>] lock_acquire+0x150/0x180
[21767.806362]                                       [<000000000058b456>] _spin_lock_irqsave+0x6a/0xb4
[21767.806368]                                       [<000000000016b1aa>] flush_signals+0x32/0x5c
[21767.806373]                                       [<000000000017950e>] kthreadd+0x4a/0x164
[21767.806379]                                       [<000000000010a5d2>] kernel_thread_starter+0x6/0xc
[21767.806385]                                       [<000000000010a5cc>] kernel_thread_starter+0x0/0xc
[21767.806391]  }
[21767.806393]  ... key      at: [<0000000000a88244>] __key.39171+0x0/0x8
[21767.806419]  ... acquired at:
[21767.806427]    [<0000000000192e0e>] check_usage_forwards+0xde/0x134
[21767.806439]    [<0000000000191c5c>] mark_lock+0x50c/0x648
[21767.806452]    [<0000000000194060>] __lock_acquire+0x810/0x192c
[21767.806466]    [<00000000001952cc>] lock_acquire+0x150/0x180
[21767.806481]    [<000000000058b456>] _spin_lock_irqsave+0x6a/0xb4
[21767.806496]    [<000000000016af86>] lock_task_sighand+0x7e/0xfc
[21767.806514]    [<000000000016bcb8>] do_send_sig_info+0x3c/0xa0
[21767.806519]    [<000000000016c1b2>] kill_pid_info+0x8a/0xe8
[21767.806524]    [<00000000001595b6>] it_real_fn+0xce/0xec
[21767.806529]    [<000000000017d92a>] __run_hrtimer+0x19a/0x2c8
[21767.806535]    [<000000000017dd2e>] hrtimer_interrupt+0x102/0x1f4
[21767.806549]    [<0000000000107ca0>] clock_comparator_work+0x60/0x68
[21767.806558]    [<000000000010f02c>] do_extint+0x18c/0x190
[21767.806568]    [<000000000011974c>] ext_no_vtime+0x1e/0x22
[21767.806578]    [<000000000058afa4>] _spin_unlock_irqrestore+0x9c/0xa0
[21767.806590]    [<000000000058af9a>] _spin_unlock_irqrestore+0x92/0xa0
[21767.806602]    [<00000000001c1f28>] __rcu_process_callbacks+0x3a0/0x3c4
[21767.806615]    [<00000000001c1fa0>] rcu_process_callbacks+0x54/0x8c
[21767.806628]    [<000000000015ce24>] __do_softirq+0x184/0x2e8
[21767.806642]    [<0000000000111f68>] do_softirq+0xe4/0xe8
[21767.806656]    [<000000000015c814>] irq_exit+0xc0/0xe0
[21767.806671]    [<000000000010efe6>] do_extint+0x146/0x190
[21767.806959]    [<000000000011974c>] ext_no_vtime+0x1e/0x22
[21767.806964]    [<00000000001164f8>] vtime_stop_cpu+0xac/0x100
[21767.806970] 
[21767.806972] 
[21767.806973] stack backtrace:
[21767.806977] CPU: 0 Not tainted 2.6.32.7 #2
[21767.806981] Process swapper (pid: 0, task: 0000000000810d18, ksp: 0000000000807da0)
[21767.806985] 0000000000000000 000000003fedf4f0 0000000000000002 0000000000000000 
[21767.806992]        000000003fedf590 000000003fedf508 000000003fedf508 0000000000586638 
[21767.807016]        0000000000000001 0000000000000001 0000000000000006 0000000000000000 
[21767.807036]        000000000000000d 0000000000000000 000000003fedf560 000000000000000e 
[21767.807057]        000000000059ef38 0000000000105670 000000003fedf4f0 000000003fedf538 
[21767.807083] Call Trace:
[21767.807092] ([<00000000001055be>] show_trace+0x142/0x148)
[21767.807106]  [<0000000000192d16>] print_irq_inversion_bug+0x13a/0x154
[21767.807121]  [<0000000000192e0e>] check_usage_forwards+0xde/0x134
[21767.807136]  [<0000000000191c5c>] mark_lock+0x50c/0x648
[21767.807151]  [<0000000000194060>] __lock_acquire+0x810/0x192c
[21767.807156]  [<00000000001952cc>] lock_acquire+0x150/0x180
[21767.807161]  [<000000000058b456>] _spin_lock_irqsave+0x6a/0xb4
[21767.807166]  [<000000000016af86>] lock_task_sighand+0x7e/0xfc
[21767.807171]  [<000000000016bcb8>] do_send_sig_info+0x3c/0xa0
[21767.807185]  [<000000000016c1b2>] kill_pid_info+0x8a/0xe8
[21767.807194]  [<00000000001595b6>] it_real_fn+0xce/0xec
[21767.807203]  [<000000000017d92a>] __run_hrtimer+0x19a/0x2c8
[21767.807214]  [<000000000017dd2e>] hrtimer_interrupt+0x102/0x1f4
[21767.807225]  [<0000000000107ca0>] clock_comparator_work+0x60/0x68
[21767.807237]  [<000000000010f02c>] do_extint+0x18c/0x190
[21767.807249]  [<000000000011974c>] ext_no_vtime+0x1e/0x22
[21767.807262]  [<000000000058afa4>] _spin_unlock_irqrestore+0x9c/0xa0
[21767.807276] ([<000000000058af9a>] _spin_unlock_irqrestore+0x92/0xa0)
[21767.807291]  [<00000000001c1f28>] __rcu_process_callbacks+0x3a0/0x3c4
[21767.807306]  [<00000000001c1fa0>] rcu_process_callbacks+0x54/0x8c
[21767.807320]  [<000000000015ce24>] __do_softirq+0x184/0x2e8
[21767.807325]  [<0000000000111f68>] do_softirq+0xe4/0xe8
[21767.807330]  [<000000000015c814>] irq_exit+0xc0/0xe0
[21767.807335]  [<000000000010efe6>] do_extint+0x146/0x190
[21767.807340]  [<000000000011974c>] ext_no_vtime+0x1e/0x22
[21767.807352]  [<00000000001164f8>] vtime_stop_cpu+0xac/0x100
[21767.807362] ([<000000000011649e>] vtime_stop_cpu+0x52/0x100)
[21767.807371]  [<000000000010abfc>] cpu_idle+0xf8/0x194
[21767.807382]  [<0000000000870c38>] start_kernel+0x390/0x3f4
[21767.807395]  [<0000000000100020>] _stext+0x20/0x80
[21767.807406] INFO: lockdep is turned off.
