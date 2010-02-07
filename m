Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751439Ab0BGFwe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 00:52:34 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:51085 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250Ab0BGFwc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 00:52:32 -0500
To: gregkh@suse.de, taviso@google.com, viro@ZenIV.linux.org.uk
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com,
       alan@lxorguk.ukuu.org.uk, torvalds@linux-foundation.org,
       jdike@addtoit.com, jln@google.com, mpm@selenic.com
Subject: [2.6.33-rc5] tty: possible irq lock inversion dependency in tty_fasync
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <201002071452.IIF73922.VtFOJOHSFFLOQM@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sun, 7 Feb 2010 14:52:28 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Below problem (which was introduced between 2.6.33-rc4 and 2.6.33-rc5) is
not yet fixed as of 2.6.33-rc7.
"git bisect start v2.6.33-rc5 v2.6.33-rc4" reported that
703625118069f9f8960d356676662d3db5a9d116 tty: fix race in tty_fasync
is first bad commit.

Config is at http://I-love.SAKURA.ne.jp/tmp/config-2.6.33-rc7

Regards.

=========================================================
[ INFO: possible irq lock inversion dependency detected ]
2.6.33-rc5 #2
---------------------------------------------------------
emacs-x/3230 just changed the state of lock:
 (&(&tty->ctrl_lock)->rlock){+.....}, at: [<c05916f8>] tty_fasync+0x92/0x10b
but this lock took another, HARDIRQ-unsafe lock in the past:
 (&(&sighand->siglock)->rlock){-.....}

and interrupts could create inverse lock ordering between them.


other info that might help us debug this:
1 lock held by emacs-x/3230:
 #0:  (&(&tty->ctrl_lock)->rlock){+.....}, at: [<c05916f8>] tty_fasync+0x92/0x10b

the shortest dependencies between 2nd lock and 1st lock:
 -> (&(&sighand->siglock)->rlock){-.....} ops: 78599 {
    IN-HARDIRQ-W at:
                          [<c045d865>] __lock_acquire+0x275/0xb28
                          [<c045e1a8>] lock_acquire+0x90/0xa7
                          [<c066e76d>] _raw_spin_lock_irqsave+0x2c/0x5f
                          [<c0445d0d>] lock_task_sighand+0x2f/0x54
                          [<c0446571>] do_send_sig_info+0x23/0x56
                          [<c04467c5>] group_send_sig_info+0x2b/0x34
                          [<c0446806>] kill_pid_info+0x38/0x4c
                          [<c043b2ee>] it_real_fn+0x4c/0x53
                          [<c0451704>] hrtimer_run_queues+0x169/0x1e1
                          [<c044378b>] run_local_timers+0xd/0x1e
                          [<c0443a99>] update_process_times+0x29/0x4d
                          [<c0458c99>] tick_periodic+0x6b/0x77
                          [<c0458cc3>] tick_handle_periodic+0x1e/0x6b
                          [<c041994c>] smp_apic_timer_interrupt+0x61/0x75
                          [<c066f3b7>] apic_timer_interrupt+0x2f/0x34
                          [<c0401d08>] cpu_idle+0x6d/0x91
                          [<c066919a>] start_secondary+0x255/0x295
    INITIAL USE at:
                         [<c045d94d>] __lock_acquire+0x35d/0xb28
                         [<c045e1a8>] lock_acquire+0x90/0xa7
                         [<c066e76d>] _raw_spin_lock_irqsave+0x2c/0x5f
                         [<c0445d4e>] flush_signals+0x1c/0x3b
                         [<c0445d9b>] ignore_signals+0x2e/0x31
                         [<c044e1fc>] kthreadd+0x27/0xcf
                         [<c0402fba>] kernel_thread_helper+0x6/0x10
  }
  ... key      at: [<c0a0d375>] __key.43588+0x0/0x8
  ... acquired at:
   [<c045dfc2>] __lock_acquire+0x9d2/0xb28
   [<c045e1a8>] lock_acquire+0x90/0xa7
   [<c066e76d>] _raw_spin_lock_irqsave+0x2c/0x5f
   [<c0591a14>] __proc_set_tty+0x27/0xe3
   [<c05940b2>] tty_ioctl+0x36b/0x711
   [<c04cf8ce>] vfs_ioctl+0x27/0x8a
   [<c04cfe27>] do_vfs_ioctl+0x461/0x4ac
   [<c04cfeb7>] sys_ioctl+0x45/0x5f
   [<c0402a0c>] sysenter_do_call+0x12/0x32

-> (&(&tty->ctrl_lock)->rlock){+.....} ops: 712 {
   HARDIRQ-ON-W at:
                        [<c045c185>] mark_held_locks+0x3d/0x58
                        [<c045c298>] trace_hardirqs_on_caller+0xf8/0x139
                        [<c045c2e4>] trace_hardirqs_on+0xb/0xd
                        [<c066e819>] _raw_write_unlock_irq+0x27/0x2b
                        [<c04cf1a4>] f_modown+0x66/0x6b
                        [<c04cf1ee>] __f_setown+0x2f/0x3a
                        [<c0591721>] tty_fasync+0xbb/0x10b
                        [<c04cf44d>] do_fcntl+0x209/0x39e
                        [<c04cf64e>] sys_fcntl64+0x6c/0x80
                        [<c0402a0c>] sysenter_do_call+0x12/0x32
   INITIAL USE at:
                       [<c045d94d>] __lock_acquire+0x35d/0xb28
                       [<c045e1a8>] lock_acquire+0x90/0xa7
                       [<c066e76d>] _raw_spin_lock_irqsave+0x2c/0x5f
                       [<c0591a14>] __proc_set_tty+0x27/0xe3
                       [<c05940b2>] tty_ioctl+0x36b/0x711
                       [<c04cf8ce>] vfs_ioctl+0x27/0x8a
                       [<c04cfe27>] do_vfs_ioctl+0x461/0x4ac
                       [<c04cfeb7>] sys_ioctl+0x45/0x5f
                       [<c0402a0c>] sysenter_do_call+0x12/0x32
 }
 ... key      at: [<c103df74>] __key.28645+0x0/0x8
 ... acquired at:
   [<c045bde5>] check_usage_backwards+0x53/0x5e
   [<c045c06d>] mark_lock+0xe2/0x1bd
   [<c045c185>] mark_held_locks+0x3d/0x58
   [<c045c298>] trace_hardirqs_on_caller+0xf8/0x139
   [<c045c2e4>] trace_hardirqs_on+0xb/0xd
   [<c066e819>] _raw_write_unlock_irq+0x27/0x2b
   [<c04cf1a4>] f_modown+0x66/0x6b
   [<c04cf1ee>] __f_setown+0x2f/0x3a
   [<c0591721>] tty_fasync+0xbb/0x10b
   [<c04cf44d>] do_fcntl+0x209/0x39e
   [<c04cf64e>] sys_fcntl64+0x6c/0x80
   [<c0402a0c>] sysenter_do_call+0x12/0x32


stack backtrace:
Pid: 3230, comm: emacs-x Not tainted 2.6.33-rc5 #2
Call Trace:
 [<c045bd87>] print_irq_inversion_bug+0xe5/0xf0
 [<c045bde5>] check_usage_backwards+0x53/0x5e
 [<c045b744>] ? trace_hardirqs_off+0xb/0xd
 [<c045c06d>] mark_lock+0xe2/0x1bd
 [<c045bd92>] ? check_usage_backwards+0x0/0x5e
 [<c045c185>] mark_held_locks+0x3d/0x58
 [<c066e819>] ? _raw_write_unlock_irq+0x27/0x2b
 [<c045c298>] trace_hardirqs_on_caller+0xf8/0x139
 [<c045c2e4>] trace_hardirqs_on+0xb/0xd
 [<c066e819>] _raw_write_unlock_irq+0x27/0x2b
 [<c04cf1a4>] f_modown+0x66/0x6b
 [<c04cf1ee>] __f_setown+0x2f/0x3a
 [<c0591721>] tty_fasync+0xbb/0x10b
 [<c0591666>] ? tty_fasync+0x0/0x10b
 [<c04cf44d>] do_fcntl+0x209/0x39e
 [<c04c5a11>] ? rcu_read_unlock+0x1c/0x1e
 [<c04cf64e>] sys_fcntl64+0x6c/0x80
 [<c0402a0c>] sysenter_do_call+0x12/0x32


Here is another one (probably same problem).

[   81.651199] =========================================================
[   81.651199] [ INFO: possible irq lock inversion dependency detected ]
[   81.651199] 2.6.33-rc7 #11
[   81.651199] ---------------------------------------------------------
[   81.651199] swapper/0 just changed the state of lock:
[   81.651199]  (&(&sighand->siglock)->rlock){-.....}, at: [<c0445ed9>] lock_task_sighand+0x2f/0x54
[   81.651199] but this lock took another, HARDIRQ-READ-unsafe lock in the past:
[   81.651199]  (&f->f_owner.lock){.+.+..}
[   81.651199]
[   81.651199] and interrupts could create inverse lock ordering between them.
[   81.651199]
[   81.651199]
[   81.651199] other info that might help us debug this:
[   81.651199] 2 locks held by swapper/0:
[   81.651199]  #0:  (rcu_read_lock){.+.+..}, at: [<c0445b4e>] rcu_read_lock+0x0/0x26
[   81.651199]  #1:  (rcu_read_lock){.+.+..}, at: [<c0445b4e>] rcu_read_lock+0x0/0x26
[   81.651199]
[   81.651199] the shortest dependencies between 2nd lock and 1st lock:
[   81.651199]   -> (&f->f_owner.lock){.+.+..} ops: 101 {
[   81.651199]      HARDIRQ-ON-R at:
[   81.651199]                                            [<c045daa5>] __lock_acquire+0x2bd/0xb28
[   81.651199]                                            [<c045e3a0>] lock_acquire+0x90/0xa7
[   81.651199]                                            [<c066f374>] _raw_read_lock+0x23/0x53
[   81.651199]                                            [<c04cf655>] f_getown+0x17/0x38
[   81.651199]                                            [<c04cf9ea>] do_fcntl+0x264/0x39e
[   81.651199]                                            [<c04cfb90>] sys_fcntl64+0x6c/0x80
[   81.651199]                                            [<c0402a0c>] sysenter_do_call+0x12/0x32
[   81.651199]      SOFTIRQ-ON-R at:
[   81.651199]                                            [<c045daf5>] __lock_acquire+0x30d/0xb28
[   81.651199]                                            [<c045e3a0>] lock_acquire+0x90/0xa7
[   81.651199]                                            [<c066f374>] _raw_read_lock+0x23/0x53
[   81.651199]                                            [<c04cf655>] f_getown+0x17/0x38
[   81.651199]                                            [<c04cf9ea>] do_fcntl+0x264/0x39e
[   81.651199]                                            [<c04cfb90>] sys_fcntl64+0x6c/0x80
[   81.651199]                                            [<c0402a0c>] sysenter_do_call+0x12/0x32
[   81.651199]      INITIAL USE at:
[   81.651199]                                           [<c045db45>] __lock_acquire+0x35d/0xb28
[   81.651199]                                           [<c045e3a0>] lock_acquire+0x90/0xa7
[   81.651199]                                           [<c066f374>] _raw_read_lock+0x23/0x53
[   81.651199]                                           [<c04cf655>] f_getown+0x17/0x38
[   81.651199]                                           [<c04cf9ea>] do_fcntl+0x264/0x39e
[   81.651199]                                           [<c04cfb90>] sys_fcntl64+0x6c/0x80
[   81.651199]                                           [<c0402a0c>] sysenter_do_call+0x12/0x32
[   81.651199]    }
[   81.651199]    ... key      at: [<c0f896b0>] __key.26175+0x0/0x8
[   81.651199]    ... acquired at:
[   81.651199]    [<c045e17e>] __lock_acquire+0x996/0xb28
[   81.651199]    [<c045e3a0>] lock_acquire+0x90/0xa7
[   81.651199]    [<c066f115>] _raw_write_lock_irqsave+0x2c/0x5f
[   81.651199]    [<c04cf692>] f_modown+0x1c/0x75
[   81.651199]    [<c04cf730>] __f_setown+0x2f/0x3a
[   81.651199]    [<c0591cb9>] tty_fasync+0xbb/0x10b
[   81.651199]    [<c04cf98f>] do_fcntl+0x209/0x39e
[   81.651199]    [<c04cfb90>] sys_fcntl64+0x6c/0x80
[   81.651199]    [<c0402a0c>] sysenter_do_call+0x12/0x32
[   81.651199]
[   81.651199]  -> (&(&tty->ctrl_lock)->rlock){......} ops: 662 {
[   81.651199]     INITIAL USE at:
[   81.651199]                                         [<c045db45>] __lock_acquire+0x35d/0xb28
[   81.651199]                                         [<c045e3a0>] lock_acquire+0x90/0xa7
[   81.651199]                                         [<c066ee15>] _raw_spin_lock_irqsave+0x2c/0x5f
[   81.651199]                                         [<c0591fac>] __proc_set_tty+0x27/0xe3
[   81.651199]                                         [<c059464a>] tty_ioctl+0x36b/0x711
[   81.651199]                                         [<c04cfe12>] vfs_ioctl+0x27/0x8a
[   81.651199]                                         [<c04d036b>] do_vfs_ioctl+0x461/0x4ac
[   81.651199]                                         [<c04d03fb>] sys_ioctl+0x45/0x5f
[   81.651199]                                         [<c0402a0c>] sysenter_do_call+0x12/0x32
[   81.651199]   }
[   81.651199]   ... key      at: [<c103df74>] __key.28647+0x0/0x8
[   81.651199]   ... acquired at:
[   81.651199]    [<c045e17e>] __lock_acquire+0x996/0xb28
[   81.651199]    [<c045e3a0>] lock_acquire+0x90/0xa7
[   81.651199]    [<c066ee15>] _raw_spin_lock_irqsave+0x2c/0x5f
[   81.651199]    [<c0591fac>] __proc_set_tty+0x27/0xe3
[   81.651199]    [<c059464a>] tty_ioctl+0x36b/0x711
[   81.651199]    [<c04cfe12>] vfs_ioctl+0x27/0x8a
[   81.651199]    [<c04d036b>] do_vfs_ioctl+0x461/0x4ac
[   81.651199]    [<c04d03fb>] sys_ioctl+0x45/0x5f
[   81.651199]    [<c0402a0c>] sysenter_do_call+0x12/0x32
[   81.651199]
[   81.651199] -> (&(&sighand->siglock)->rlock){-.....} ops: 80027 {
[   81.651199]    IN-HARDIRQ-W at:
[   81.651199]                                        [<c045da5d>] __lock_acquire+0x275/0xb28
[   81.651199]                                        [<c045e3a0>] lock_acquire+0x90/0xa7
[   81.651199]                                        [<c066ee15>] _raw_spin_lock_irqsave+0x2c/0x5f
[   81.651199]                                        [<c0445ed9>] lock_task_sighand+0x2f/0x54
[   81.651199]                                        [<c044673d>] do_send_sig_info+0x23/0x56
[   81.651199]                                        [<c0446991>] group_send_sig_info+0x2b/0x34
[   81.651199]                                        [<c04469d2>] kill_pid_info+0x38/0x4c
[   81.651199]                                        [<c043b4ba>] it_real_fn+0x4c/0x53
[   81.651199]                                        [<c04518d0>] hrtimer_run_queues+0x169/0x1e1
[   81.651199]                                        [<c0443957>] run_local_timers+0xd/0x1e
[   81.651199]                                        [<c0443c65>] update_process_times+0x29/0x4d
[   81.651199]                                        [<c0458e95>] tick_periodic+0x6b/0x77
[   81.651199]                                        [<c0458ebf>] tick_handle_periodic+0x1e/0x6b
[   81.651199]                                        [<c0419958>] smp_apic_timer_interrupt+0x61/0x75
[   81.651199]                                        [<c066fa5f>] apic_timer_interrupt+0x2f/0x34
[   81.651199]                                        [<c0401d08>] cpu_idle+0x6d/0x91
[   81.651199]                                        [<c065be03>] rest_init+0x67/0x69
[   81.651199]                                        [<c08448be>] start_kernel+0x323/0x32a
[   81.651199]                                        [<c084408f>] i386_start_kernel+0x8f/0x94
[   81.651199]    INITIAL USE at:
[   81.651199]                                       [<c045db45>] __lock_acquire+0x35d/0xb28
[   81.651199]                                       [<c045e3a0>] lock_acquire+0x90/0xa7
[   81.651199]                                       [<c066ee15>] _raw_spin_lock_irqsave+0x2c/0x5f
[   81.651199]                                       [<c0445f1a>] flush_signals+0x1c/0x3b
[   81.651199]                                       [<c0445f67>] ignore_signals+0x2e/0x31
[   81.651199]                                       [<c044e3c8>] kthreadd+0x27/0xcf
[   81.651199]                                       [<c0402fba>] kernel_thread_helper+0x6/0x10
[   81.651199]  }
[   81.651199]  ... key      at: [<c0a0d375>] __key.43570+0x0/0x8
[   81.651199]  ... acquired at:
[   81.651199]    [<c045c03b>] check_usage_forwards+0x53/0x5e
[   81.651199]    [<c045c2ae>] mark_lock+0x12b/0x1bd
[   81.651199]    [<c045da5d>] __lock_acquire+0x275/0xb28
[   81.651199]    [<c045e3a0>] lock_acquire+0x90/0xa7
[   81.651199]    [<c066ee15>] _raw_spin_lock_irqsave+0x2c/0x5f
[   81.651199]    [<c0445ed9>] lock_task_sighand+0x2f/0x54
[   81.651199]    [<c044673d>] do_send_sig_info+0x23/0x56
[   81.651199]    [<c0446991>] group_send_sig_info+0x2b/0x34
[   81.651199]    [<c04469d2>] kill_pid_info+0x38/0x4c
[   81.651199]    [<c043b4ba>] it_real_fn+0x4c/0x53
[   81.651199]    [<c04518d0>] hrtimer_run_queues+0x169/0x1e1
[   81.651199]    [<c0443957>] run_local_timers+0xd/0x1e
[   81.651199]    [<c0443c65>] update_process_times+0x29/0x4d
[   81.651199]    [<c0458e95>] tick_periodic+0x6b/0x77
[   81.651199]    [<c0458ebf>] tick_handle_periodic+0x1e/0x6b
[   81.651199]    [<c0419958>] smp_apic_timer_interrupt+0x61/0x75
[   81.651199]    [<c066fa5f>] apic_timer_interrupt+0x2f/0x34
[   81.651199]    [<c0401d08>] cpu_idle+0x6d/0x91
[   81.651199]    [<c065be03>] rest_init+0x67/0x69
[   81.651199]    [<c08448be>] start_kernel+0x323/0x32a
[   81.651199]    [<c084408f>] i386_start_kernel+0x8f/0x94
[   81.651199]
[   81.651199]
[   81.651199] stack backtrace:
[   81.651199] Pid: 0, comm: swapper Not tainted 2.6.33-rc7 #11
[   81.651199] Call Trace:
[   81.651199]  [<c045bf7f>] print_irq_inversion_bug+0xe5/0xf0
[   81.651199]  [<c045c03b>] check_usage_forwards+0x53/0x5e
[   81.651199]  [<c0452f50>] ? cpu_clock+0x2e/0x46
[   81.651199]  [<c045c2ae>] mark_lock+0x12b/0x1bd
[   81.651199]  [<c045bfe8>] ? check_usage_forwards+0x0/0x5e
[   81.651199]  [<c045da5d>] __lock_acquire+0x275/0xb28
[   81.651199]  [<c045b93c>] ? trace_hardirqs_off+0xb/0xd
[   81.651199]  [<c045e2c3>] ? __lock_acquire+0xadb/0xb28
[   81.651199]  [<c045e3a0>] lock_acquire+0x90/0xa7
[   81.651199]  [<c0445ed9>] ? lock_task_sighand+0x2f/0x54
[   81.651199]  [<c066ee15>] _raw_spin_lock_irqsave+0x2c/0x5f
[   81.651199]  [<c0445ed9>] ? lock_task_sighand+0x2f/0x54
[   81.651199]  [<c0445ed9>] lock_task_sighand+0x2f/0x54
[   81.651199]  [<c044673d>] do_send_sig_info+0x23/0x56
[   81.651199]  [<c0446991>] group_send_sig_info+0x2b/0x34
[   81.651199]  [<c04469d2>] kill_pid_info+0x38/0x4c
[   81.651199]  [<c043b4ba>] it_real_fn+0x4c/0x53
[   81.651199]  [<c04518d0>] hrtimer_run_queues+0x169/0x1e1
[   81.651199]  [<c043b46e>] ? it_real_fn+0x0/0x53
[   81.651199]  [<c0443957>] run_local_timers+0xd/0x1e
[   81.651199]  [<c0443c65>] update_process_times+0x29/0x4d
[   81.651199]  [<c0458e95>] tick_periodic+0x6b/0x77
[   81.651199]  [<c0458ebf>] tick_handle_periodic+0x1e/0x6b
[   81.651199]  [<c0419958>] smp_apic_timer_interrupt+0x61/0x75
[   81.651199]  [<c066fa5f>] apic_timer_interrupt+0x2f/0x34
[   81.651199]  [<c04087d6>] ? default_idle+0x49/0x68
[   81.651199]  [<c0401d08>] cpu_idle+0x6d/0x91
[   81.651199]  [<c065be03>] rest_init+0x67/0x69
[   81.651199]  [<c08448be>] start_kernel+0x323/0x32a
[   81.651199]  [<c084408f>] i386_start_kernel+0x8f/0x94
