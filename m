Return-Path: <linux-kernel-owner+w=401wt.eu-S1752984Ab0AZDU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984Ab0AZDU2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 22:20:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751755Ab0AZDU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 22:20:27 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:56069 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147Ab0AZDU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 22:20:26 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>
Subject: [2.6.33-rc5] starting emacs makes lockdep warning
Cc: kosaki.motohiro@jp.fujitsu.com, Alan Cox <alan@lxorguk.ukuu.org.uk>
Message-Id: <20100126121618.5AA5.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 26 Jan 2010 12:20:21 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Current linus tree made following lockdep warning when starting emacs command.
Is this known issue?


=========================================================
[ INFO: possible irq lock inversion dependency detected ]
2.6.33-rc5 #77
---------------------------------------------------------
emacs/1609 just changed the state of lock:
 (&(&tty->ctrl_lock)->rlock){+.....}, at: [<ffffffff8127c648>] tty_fasync+0xe8/0x190
but this lock took another, HARDIRQ-unsafe lock in the past:
 (&(&sighand->siglock)->rlock){-.....}

and interrupts could create inverse lock ordering between them.


other info that might help us debug this:
1 lock held by emacs/1609:
 #0:  (&(&tty->ctrl_lock)->rlock){+.....}, at: [<ffffffff8127c648>] tty_fasync+0xe8/0x190

the shortest dependencies between 2nd lock and 1st lock:
 -> (&(&sighand->siglock)->rlock){-.....} ops: 50393 {
    IN-HARDIRQ-W at:
                          [<ffffffff8108924e>] __lock_acquire+0x7ae/0x15a0
                          [<ffffffff8108a0df>] lock_acquire+0x9f/0x120
                          [<ffffffff81423012>] _raw_spin_lock_irqsave+0x52/0x90
                          [<ffffffff81065799>] lock_task_sighand+0x79/0x100
                          [<ffffffff8106600f>] do_send_sig_info+0x3f/0x90
                          [<ffffffff810660f0>] group_send_sig_info+0x40/0x50
                          [<ffffffff81066703>] kill_pid_info+0x73/0xe0
                          [<ffffffff81054014>] it_real_fn+0x44/0xa0
                          [<ffffffff81075d1e>] __run_hrtimer+0x8e/0x1e0
                          [<ffffffff81076116>] hrtimer_interrupt+0xe6/0x250
                          [<ffffffff8142a0b9>] smp_apic_timer_interrupt+0x69/0x9b
                          [<ffffffff81003a93>] apic_timer_interrupt+0x13/0x20
                          [<ffffffff81001956>] cpu_idle+0x66/0xd0
                          [<ffffffff814082e2>] rest_init+0x92/0xa0
                          [<ffffffff81b4cd84>] start_kernel+0x3b9/0x3c5
                          [<ffffffff81b4c310>] x86_64_start_reservations+0x120/0x124
                          [<ffffffff81b4c3f8>] x86_64_start_kernel+0xe4/0xeb
    INITIAL USE at:
                         [<ffffffff81088e86>] __lock_acquire+0x3e6/0x15a0
                         [<ffffffff8108a0df>] lock_acquire+0x9f/0x120
                         [<ffffffff81423012>] _raw_spin_lock_irqsave+0x52/0x90
                         [<ffffffff810646dc>] flush_signals+0x2c/0x60
                         [<ffffffff81064743>] ignore_signals+0x33/0x40
                         [<ffffffff81071067>] kthreadd+0x37/0x180
                         [<ffffffff81003ed4>] kernel_thread_helper+0x4/0x10
  }
  ... key      at: [<ffffffff81c054a4>] __key.46539+0x0/0x8
  ... acquired at:
   [<ffffffff81089af6>] __lock_acquire+0x1056/0x15a0
   [<ffffffff8108a0df>] lock_acquire+0x9f/0x120
   [<ffffffff81423012>] _raw_spin_lock_irqsave+0x52/0x90
   [<ffffffff8127c1be>] __proc_set_tty+0x3e/0x150
   [<ffffffff8127e01d>] tty_open+0x51d/0x5e0
   [<ffffffff81142400>] chrdev_open+0x170/0x290
   [<ffffffff8113c561>] __dentry_open+0x131/0x3a0
   [<ffffffff8113c8e4>] nameidata_to_filp+0x54/0x70
   [<ffffffff8114c098>] do_filp_open+0x948/0xcd0
   [<ffffffff8113c2e9>] do_sys_open+0x69/0x140
   [<ffffffff8113c400>] sys_open+0x20/0x30
   [<ffffffff8100309b>] system_call_fastpath+0x16/0x1b

-> (&(&tty->ctrl_lock)->rlock){+.....} ops: 191 {
   HARDIRQ-ON-W at:
                        [<ffffffff81087e63>] mark_held_locks+0x73/0xa0
                        [<ffffffff810880bb>] trace_hardirqs_on_caller+0x7b/0x1c0
                        [<ffffffff8108820d>] trace_hardirqs_on+0xd/0x10
                        [<ffffffff81423730>] _raw_write_unlock_irq+0x30/0x60
                        [<ffffffff8114cc63>] f_modown+0x53/0xe0
                        [<ffffffff8114cd1e>] __f_setown+0xe/0x20
                        [<ffffffff8127c667>] tty_fasync+0x107/0x190
                        [<ffffffff8114d842>] sys_fcntl+0x222/0x580
                        [<ffffffff8100309b>] system_call_fastpath+0x16/0x1b
   INITIAL USE at:
                       [<ffffffff81088e86>] __lock_acquire+0x3e6/0x15a0
                       [<ffffffff8108a0df>] lock_acquire+0x9f/0x120
                       [<ffffffff81423012>] _raw_spin_lock_irqsave+0x52/0x90
                       [<ffffffff8127c1be>] __proc_set_tty+0x3e/0x150
                       [<ffffffff8127e01d>] tty_open+0x51d/0x5e0
                       [<ffffffff81142400>] chrdev_open+0x170/0x290
                       [<ffffffff8113c561>] __dentry_open+0x131/0x3a0
                       [<ffffffff8113c8e4>] nameidata_to_filp+0x54/0x70
                       [<ffffffff8114c098>] do_filp_open+0x948/0xcd0
                       [<ffffffff8113c2e9>] do_sys_open+0x69/0x140
                       [<ffffffff8113c400>] sys_open+0x20/0x30
                       [<ffffffff8100309b>] system_call_fastpath+0x16/0x1b
 }
 ... key      at: [<ffffffff82533fb8>] __key.30033+0x0/0x8
 ... acquired at:
   [<ffffffff81087263>] check_usage_backwards+0x93/0x100
   [<ffffffff81087b9a>] mark_lock+0x1ca/0x420
   [<ffffffff81087e63>] mark_held_locks+0x73/0xa0
   [<ffffffff810880bb>] trace_hardirqs_on_caller+0x7b/0x1c0
   [<ffffffff8108820d>] trace_hardirqs_on+0xd/0x10
   [<ffffffff81423730>] _raw_write_unlock_irq+0x30/0x60
   [<ffffffff8114cc63>] f_modown+0x53/0xe0
   [<ffffffff8114cd1e>] __f_setown+0xe/0x20
   [<ffffffff8127c667>] tty_fasync+0x107/0x190
   [<ffffffff8114d842>] sys_fcntl+0x222/0x580
   [<ffffffff8100309b>] system_call_fastpath+0x16/0x1b


stack backtrace:
Pid: 1609, comm: emacs Not tainted 2.6.33-rc5 #77
Call Trace:
 [<ffffffff810870bd>] print_irq_inversion_bug.clone.0+0x12d/0x140
 [<ffffffff810871d0>] ? check_usage_backwards+0x0/0x100
 [<ffffffff81087263>] check_usage_backwards+0x93/0x100
 [<ffffffff8114cc4c>] ? f_modown+0x3c/0xe0
 [<ffffffff81087b9a>] mark_lock+0x1ca/0x420
 [<ffffffff81087e63>] mark_held_locks+0x73/0xa0
 [<ffffffff81423730>] ? _raw_write_unlock_irq+0x30/0x60
 [<ffffffff810880bb>] trace_hardirqs_on_caller+0x7b/0x1c0
 [<ffffffff8108820d>] trace_hardirqs_on+0xd/0x10
 [<ffffffff81423730>] _raw_write_unlock_irq+0x30/0x60
 [<ffffffff8114cc63>] f_modown+0x53/0xe0
 [<ffffffff8114cd1e>] __f_setown+0xe/0x20
 [<ffffffff8127c667>] tty_fasync+0x107/0x190
 [<ffffffff8114d842>] sys_fcntl+0x222/0x580
 [<ffffffff8100309b>] system_call_fastpath+0x16/0x1b

