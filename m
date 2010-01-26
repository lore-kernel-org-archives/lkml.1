Return-Path: <linux-kernel-owner+w=401wt.eu-S1752875Ab0AZDQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875Ab0AZDQd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 22:16:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487Ab0AZDQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 22:16:32 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:59852 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446Ab0AZDQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 22:16:31 -0500
Message-Id: <201001260316.o0Q3GQbR080648@www262.sakura.ne.jp>
Subject: [2.6.32.6] tty: possible irq lock inversion dependency in tty_fasync
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Tue, 26 Jan 2010 12:16:26 +0900
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 26012010 #3149598, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I got this on 2.6.32.6 .
Config is at http://I-love.SAKURA.ne.jp/tmp/config-2.6.32.6

# cat /proc/version
Linux version 2.6.32.6 (root@tomoyo) (gcc version 3.3.5 (Debian 1:3.3.5-13)) #1 SMP Tue Jan 26 11:35:08 JST 2010
# cat /proc/cmdline
root=/dev/sda1 ro ramdisk=16384 console=ttyS0,115200n8 console=tty kmemleak=off
# dmesg
=========================================================
[ INFO: possible irq lock inversion dependency detected ]
2.6.32.6 #1
---------------------------------------------------------
swapper/0 just changed the state of lock:
 (&sighand->siglock){-.....}, at: [<c10515bd>] lock_task_sighand+0x5d/0xa0
but this lock took another, HARDIRQ-unsafe lock in the past:
 (&tty->ctrl_lock){+.+...}

and interrupts could create inverse lock ordering between them.


other info that might help us debug this:
2 locks held by swapper/0:
 #0:  (rcu_read_lock){.+.+..}, at: [<c10516c0>] kill_pid_info+0x0/0x90
 #1:  (rcu_read_lock){.+.+..}, at: [<c1051560>] lock_task_sighand+0x0/0xa0

the shortest dependencies between 2nd lock and 1st lock:
 -> (&tty->ctrl_lock){+.+...} ops: 97 {
    HARDIRQ-ON-W at:
                          [<c106e5e2>] mark_held_locks+0x42/0x80
                          [<c106e6e6>] trace_hardirqs_on_caller+0xa6/0x160
                          [<c106e7ab>] trace_hardirqs_on+0xb/0x10
                          [<c1343487>] _write_unlock_irq+0x27/0x30
                          [<c10e517b>] f_modown+0x6b/0x80
                          [<c10e51d1>] __f_setown+0x41/0x50
                          [<c11e5e8c>] tty_fasync+0xbc/0x110
                          [<c10e50d8>] setfl+0x118/0x150
                          [<c10e557f>] do_fcntl+0xcf/0x1e0
                          [<c10e5788>] sys_fcntl64+0x88/0xa0
                          [<c1002f99>] syscall_call+0x7/0xb
    SOFTIRQ-ON-W at:
                          [<c106e5e2>] mark_held_locks+0x42/0x80
                          [<c106e737>] trace_hardirqs_on_caller+0xf7/0x160
                          [<c106e7ab>] trace_hardirqs_on+0xb/0x10
                          [<c1343487>] _write_unlock_irq+0x27/0x30
                          [<c10e517b>] f_modown+0x6b/0x80
                          [<c10e51d1>] __f_setown+0x41/0x50
                          [<c11e5e8c>] tty_fasync+0xbc/0x110
                          [<c10e50d8>] setfl+0x118/0x150
                          [<c10e557f>] do_fcntl+0xcf/0x1e0
                          [<c10e5788>] sys_fcntl64+0x88/0xa0
                          [<c1002f99>] syscall_call+0x7/0xb
    INITIAL USE at:
                         [<c106f6f4>] __lock_acquire+0x1b4/0x8a0
                         [<c1070ddd>] lock_acquire+0x7d/0xe0
                         [<c1342af9>] _spin_lock_irqsave+0x49/0x90
                         [<c11e7427>] __proc_set_tty+0x27/0xf0
                         [<c11e751f>] proc_set_tty+0x2f/0x50
                         [<c11e62cd>] tiocsctty+0xed/0x100
                         [<c11e6998>] tty_ioctl+0x1b8/0x320
                         [<c10e5e24>] vfs_ioctl+0x74/0x90
                         [<c10e6a90>] do_vfs_ioctl+0x60/0x1a0
                         [<c10e6c1f>] sys_ioctl+0x4f/0x70
                         [<c1002f99>] syscall_call+0x7/0xb
  }
  ... key      at: [<c1d31c5c>] __key.13+0x0/0x8
  ... acquired at:
   [<c106cfa2>] check_prev_add+0x212/0x7e0
   [<c106d614>] check_prevs_add+0xa4/0x100
   [<c106d99a>] validate_chain+0x2fa/0x520
   [<c106f7e1>] __lock_acquire+0x2a1/0x8a0
   [<c1070ddd>] lock_acquire+0x7d/0xe0
   [<c1342af9>] _spin_lock_irqsave+0x49/0x90
   [<c11e7427>] __proc_set_tty+0x27/0xf0
   [<c11e751f>] proc_set_tty+0x2f/0x50
   [<c11e62cd>] tiocsctty+0xed/0x100
   [<c11e6998>] tty_ioctl+0x1b8/0x320
   [<c10e5e24>] vfs_ioctl+0x74/0x90
   [<c10e6a90>] do_vfs_ioctl+0x60/0x1a0
   [<c10e6c1f>] sys_ioctl+0x4f/0x70
   [<c1002f99>] syscall_call+0x7/0xb

-> (&sighand->siglock){-.....} ops: 118136 {
   IN-HARDIRQ-W at:
                        [<c106ec48>] mark_irqflags+0x168/0x180
                        [<c106f8bc>] __lock_acquire+0x37c/0x8a0
                        [<c1070ddd>] lock_acquire+0x7d/0xe0
                        [<c1342af9>] _spin_lock_irqsave+0x49/0x90
                        [<c10515bd>] lock_task_sighand+0x5d/0xa0
                        [<c10513e1>] do_send_sig_info+0x31/0x70
                        [<c1051646>] group_send_sig_info+0x46/0x50
                        [<c1051726>] kill_pid_info+0x66/0x90
                        [<c10456d8>] it_real_fn+0x38/0x80
                        [<c105ef9f>] __run_hrtimer+0x7f/0x160
                        [<c105f11e>] hrtimer_run_queues+0x8e/0xb0
                        [<c104fa0d>] run_local_timers+0xd/0x20
                        [<c104f724>] update_process_times+0x34/0x60
                        [<c1068afa>] tick_periodic+0x2a/0x80
                        [<c1068b6e>] tick_handle_periodic+0x1e/0x80
                        [<c101880d>] local_apic_timer_interrupt+0x5d/0x60
                        [<c1343923>] smp_apic_timer_interrupt+0x33/0x42
                        [<c10038bb>] apic_timer_interrupt+0x2f/0x34
                        [<c10015ea>] cpu_idle+0x6a/0xc0
                        [<c132e168>] rest_init+0x58/0x60
                        [<c15129c6>] start_kernel+0x206/0x290
                        [<c1512095>] i386_start_kernel+0x65/0xa0
   INITIAL USE at:
                       [<c106f6f4>] __lock_acquire+0x1b4/0x8a0
                       [<c1070ddd>] lock_acquire+0x7d/0xe0
                       [<c1342af9>] _spin_lock_irqsave+0x49/0x90
                       [<c1050514>] flush_signals+0x24/0x50
                       [<c105068c>] ignore_signals+0x3c/0x40
                       [<c105b726>] kthreadd+0x26/0xd0
                       [<c1003a77>] kernel_thread_helper+0x7/0x10
 }
 ... key      at: [<c17130d8>] __key.12+0x0/0x8
 ... acquired at:
   [<c106e0f8>] check_usage_forwards+0x78/0xe0
   [<c106e3f9>] mark_lock_irq+0x99/0x240
   [<c106eeb6>] mark_lock+0x1d6/0x370
   [<c106ec48>] mark_irqflags+0x168/0x180
   [<c106f8bc>] __lock_acquire+0x37c/0x8a0
   [<c1070ddd>] lock_acquire+0x7d/0xe0
   [<c1342af9>] _spin_lock_irqsave+0x49/0x90
   [<c10515bd>] lock_task_sighand+0x5d/0xa0
   [<c10513e1>] do_send_sig_info+0x31/0x70
   [<c1051646>] group_send_sig_info+0x46/0x50
   [<c1051726>] kill_pid_info+0x66/0x90
   [<c10456d8>] it_real_fn+0x38/0x80
   [<c105ef9f>] __run_hrtimer+0x7f/0x160
   [<c105f11e>] hrtimer_run_queues+0x8e/0xb0
   [<c104fa0d>] run_local_timers+0xd/0x20
   [<c104f724>] update_process_times+0x34/0x60
   [<c1068afa>] tick_periodic+0x2a/0x80
   [<c1068b6e>] tick_handle_periodic+0x1e/0x80
   [<c101880d>] local_apic_timer_interrupt+0x5d/0x60
   [<c1343923>] smp_apic_timer_interrupt+0x33/0x42
   [<c10038bb>] apic_timer_interrupt+0x2f/0x34
   [<c10015ea>] cpu_idle+0x6a/0xc0
   [<c132e168>] rest_init+0x58/0x60
   [<c15129c6>] start_kernel+0x206/0x290
   [<c1512095>] i386_start_kernel+0x65/0xa0


stack backtrace:
Pid: 0, comm: swapper Not tainted 2.6.32.6 #1
Call Trace:
 [<c1041b7d>] ? printk+0x1d/0x30
 [<c106e068>] print_irq_inversion_bug+0x108/0x120
 [<c106e0f8>] check_usage_forwards+0x78/0xe0
 [<c106e3f9>] mark_lock_irq+0x99/0x240
 [<c106e080>] ? check_usage_forwards+0x0/0xe0
 [<c106eeb6>] mark_lock+0x1d6/0x370
 [<c106e7d0>] ? trace_hardirqs_off_caller+0x20/0xc0
 [<c106ec48>] mark_irqflags+0x168/0x180
 [<c106f8bc>] __lock_acquire+0x37c/0x8a0
 [<c106f81c>] ? __lock_acquire+0x2dc/0x8a0
 [<c1070ddd>] lock_acquire+0x7d/0xe0
 [<c10515bd>] ? lock_task_sighand+0x5d/0xa0
 [<c1342af9>] _spin_lock_irqsave+0x49/0x90
 [<c10515bd>] ? lock_task_sighand+0x5d/0xa0
 [<c10515bd>] lock_task_sighand+0x5d/0xa0
 [<c1051560>] ? lock_task_sighand+0x0/0xa0
 [<c10513e1>] do_send_sig_info+0x31/0x70
 [<c1051646>] group_send_sig_info+0x46/0x50
 [<c1051726>] kill_pid_info+0x66/0x90
 [<c10516c0>] ? kill_pid_info+0x0/0x90
 [<c105ef91>] ? __run_hrtimer+0x71/0x160
 [<c10456d8>] it_real_fn+0x38/0x80
 [<c105ef9f>] __run_hrtimer+0x7f/0x160
 [<c1342fb3>] ? _spin_lock+0x53/0x80
 [<c10456a0>] ? it_real_fn+0x0/0x80
 [<c105f11e>] hrtimer_run_queues+0x8e/0xb0
 [<c104fa0d>] run_local_timers+0xd/0x20
 [<c104f724>] update_process_times+0x34/0x60
 [<c1068afa>] tick_periodic+0x2a/0x80
 [<c1068b6e>] tick_handle_periodic+0x1e/0x80
 [<c101880d>] local_apic_timer_interrupt+0x5d/0x60
 [<c1343923>] smp_apic_timer_interrupt+0x33/0x42
 [<c10038bb>] apic_timer_interrupt+0x2f/0x34
 [<c100a902>] ? default_idle+0x42/0xa0
 [<c10015ea>] cpu_idle+0x6a/0xc0
 [<c132e168>] rest_init+0x58/0x60
 [<c15129c6>] start_kernel+0x206/0x290
 [<c15122c0>] ? unknown_bootoption+0x0/0x130
 [<c1512095>] i386_start_kernel+0x65/0xa0

