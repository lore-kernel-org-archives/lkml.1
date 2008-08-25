Return-Path: <linux-kernel-owner+w=401wt.eu-S1756038AbYHYND1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038AbYHYND1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 09:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754219AbYHYNDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 09:03:19 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:45427 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889AbYHYNDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 09:03:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=CLRLVMyH56JEC0H9FsM4UzDkC/Qh5TpsiVuuMp0/TJpOuliTcXMnFREu1G595AYdOd
         zPUdSEIUqA2x6Q+WKMfU0i1tWllVMpUUC8BWT+LEeg67+qixXjqOx4Uki4XtuUM22A4w
         2D0zpV2Ck2t5KmsTosKxAI7YBv5gRPxs1+K14=
Message-ID: <6278d2220808250603p3e96ffau2fc26e50ad70c204@mail.gmail.com>
Date: Mon, 25 Aug 2008 14:03:15 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: 2.6.27-rc4-git1: Reported regressions from 2.6.26
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Adrian Bunk" <bunk@kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Natalie Protasevich" <protasnb@gmail.com>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.10.0808241152370.3363@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik>
	 <alpine.LFD.1.10.0808241050180.3363@nehalem.linux-foundation.org>
	 <19f34abd0808241143t6f5239d7o679135e9e974fe63@mail.gmail.com>
	 <alpine.LFD.1.10.0808241152370.3363@nehalem.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus, Vegard,

On Sun, Aug 24, 2008 at 7:58 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Sun, 24 Aug 2008, Vegard Nossum wrote:
[snip]
> Anyway, I think your patch is likely fine, I just thought it looked a bit
> odd to have a loop to move a list from one head pointer to another.
>
> But regardless, it would need some testing. Daniel?

This opens another lockdep report at boot-time [1] - promoting
pool_lock may not be the best fix?

We then see a new deadlock condition (on the pool_lock spinlock) [2],
which seemingly was avoided by taking the debug-bucket lock first.

We reproduce this by booting with debug_objects=1 and causing a lot of activity.

Daniel

--- [1]

[ INFO: possible irq lock inversion dependency detected ]
2.6.27-rc4-225c-debug #3
---------------------------------------------------------
rcu_sched_grace/9 just changed the state of lock:
 (pool_lock){-...}, at: [<ffffffff80466c2c>] free_object+0x7c/0xc0
but this lock was taken by another, hard-irq-safe lock in the past:
 (xtime_lock){++..}

and interrupts could create inverse lock ordering between them.


other info that might help us debug this:
no locks held by rcu_sched_grace/9.

the first lock's dependencies:
-> (pool_lock){-...} ops: 59 {
   initial-use  at:
                                       [<ffffffff8026f795>]
__lock_acquire+0x1a5/0x1160
                                       [<ffffffff802707e1>]
lock_acquire+0x91/0xc0
                                       [<ffffffff806a2bb1>] _spin_lock+0x41/0x80
                                       [<ffffffff804675fa>]
__debug_object_init+0x14a/0x3e0
                                       [<ffffffff804678df>]
debug_object_init+0x1f/0x30
                                       [<ffffffff80260eee>]
hrtimer_init+0x2e/0x50
                                       [<ffffffff80237571>]
init_rt_bandwidth+0x41/0x60
                                       [<ffffffff812f3810>]
sched_init+0x72/0x63d
                                       [<ffffffff812e17e2>]
start_kernel+0x19c/0x456
                                       [<ffffffff812e10a9>]
x86_64_start_reservations+0x99/0xb6
                                       [<ffffffff812e11d0>]
x86_64_start_kernel+0xe2/0xe9
                                       [<ffffffffffffffff>] 0xffffffffffffffff
   hardirq-on-W at:
                                       [<ffffffff8026fae9>]
__lock_acquire+0x4f9/0x1160
                                       [<ffffffff802707e1>]
lock_acquire+0x91/0xc0
                                       [<ffffffff806a2bb1>] _spin_lock+0x41/0x80
                                       [<ffffffff80466c2c>]
free_object+0x7c/0xc0
                                       [<ffffffff8046707e>]
debug_object_free+0xbe/0x130
                                       [<ffffffff806a070e>]
schedule_timeout+0x7e/0xe0
                                       [<ffffffff806a07ce>]
schedule_timeout_interruptible+0x1e/0x20
                                       [<ffffffff8029cfb2>]
rcu_sched_grace_period+0xa2/0x3a0
                                       [<ffffffff8025d50e>] kthread+0x4e/0x90
                                       [<ffffffff8020d919>] child_rip+0xa/0x11
                                       [<ffffffffffffffff>] 0xffffffffffffffff
 }
 ... key      at: [<ffffffff8088f5d8>] pool_lock+0x18/0x40

the second lock's dependencies:
-> (xtime_lock){++..} ops: 211 {
   initial-use  at:
                                       [<ffffffff8026f795>]
__lock_acquire+0x1a5/0x1160
                                       [<ffffffff802707e1>]
lock_acquire+0x91/0xc0
                                       [<ffffffff806a2bb1>] _spin_lock+0x41/0x80
                                       [<ffffffff812f5628>]
timekeeping_init+0x2f/0x144
                                       [<ffffffff812e189d>]
start_kernel+0x257/0x456
                                       [<ffffffff812e10a9>]
x86_64_start_reservations+0x99/0xb6
                                       [<ffffffff812e11d0>]
x86_64_start_kernel+0xe2/0xe9
                                       [<ffffffffffffffff>] 0xffffffffffffffff
   in-hardirq-W at:
                                       [<ffffffffffffffff>] 0xffffffffffffffff
   in-softirq-W at:
                                       [<ffffffffffffffff>] 0xffffffffffffffff
 }
 ... key      at: [<ffffffff80907220>] xtime_lock+0x20/0x40
 -> (&obj_hash[i].lock){.+..} ops: 1003901 {
    initial-use  at:
                                         [<ffffffff8026f795>]
__lock_acquire+0x1a5/0x1160
                                         [<ffffffff802707e1>]
lock_acquire+0x91/0xc0
                                         [<ffffffff806a2d43>]
_spin_lock_irqsave+0x53/0x90
                                         [<ffffffff80467567>]
__debug_object_init+0xb7/0x3e0
                                         [<ffffffff804678df>]
debug_object_init+0x1f/0x30
                                         [<ffffffff80260eee>]
hrtimer_init+0x2e/0x50
                                         [<ffffffff80237571>]
init_rt_bandwidth+0x41/0x60
                                         [<ffffffff812f3810>]
sched_init+0x72/0x63d
                                         [<ffffffff812e17e2>]
start_kernel+0x19c/0x456
                                         [<ffffffff812e10a9>]
x86_64_start_reservations+0x99/0xb6
                                         [<ffffffff812e11d0>]
x86_64_start_kernel+0xe2/0xe9
                                         [<ffffffffffffffff>] 0xffffffffffffffff
    in-softirq-W at:
                                         [<ffffffffffffffff>] 0xffffffffffffffff
  }
  ... key      at: [<ffffffff81cd2eb0>] __key.16550+0x0/0x8
  -> (pool_lock){-...} ops: 59 {
     initial-use  at:
                                           [<ffffffff8026f795>]
__lock_acquire+0x1a5/0x1160
                                           [<ffffffff802707e1>]
lock_acquire+0x91/0xc0
                                           [<ffffffff806a2bb1>]
_spin_lock+0x41/0x80
                                           [<ffffffff804675fa>]
__debug_object_init+0x14a/0x3e0
                                           [<ffffffff804678df>]
debug_object_init+0x1f/0x30
                                           [<ffffffff80260eee>]
hrtimer_init+0x2e/0x50
                                           [<ffffffff80237571>]
init_rt_bandwidth+0x41/0x60
                                           [<ffffffff812f3810>]
sched_init+0x72/0x63d
                                           [<ffffffff812e17e2>]
start_kernel+0x19c/0x456
                                           [<ffffffff812e10a9>]
x86_64_start_reservations+0x99/0xb6
                                           [<ffffffff812e11d0>]
x86_64_start_kernel+0xe2/0xe9
                                           [<ffffffffffffffff>]
0xffffffffffffffff
     hardirq-on-W at:
                                           [<ffffffff8026fae9>]
__lock_acquire+0x4f9/0x1160
                                           [<ffffffff802707e1>]
lock_acquire+0x91/0xc0
                                           [<ffffffff806a2bb1>]
_spin_lock+0x41/0x80
                                           [<ffffffff80466c2c>]
free_object+0x7c/0xc0
                                           [<ffffffff8046707e>]
debug_object_free+0xbe/0x130
                                           [<ffffffff806a070e>]
schedule_timeout+0x7e/0xe0
                                           [<ffffffff806a07ce>]
schedule_timeout_interruptible+0x1e/0x20
                                           [<ffffffff8029cfb2>]
rcu_sched_grace_period+0xa2/0x3a0
                                           [<ffffffff8025d50e>]
kthread+0x4e/0x90
                                           [<ffffffff8020d919>]
child_rip+0xa/0x11
                                           [<ffffffffffffffff>]
0xffffffffffffffff
   }
   ... key      at: [<ffffffff8088f5d8>] pool_lock+0x18/0x40
  ... acquired at:
   [<ffffffff802703b1>] __lock_acquire+0xdc1/0x1160
   [<ffffffff802707e1>] lock_acquire+0x91/0xc0
   [<ffffffff806a2bb1>] _spin_lock+0x41/0x80
   [<ffffffff804675fa>] __debug_object_init+0x14a/0x3e0
   [<ffffffff804678df>] debug_object_init+0x1f/0x30
   [<ffffffff80260eee>] hrtimer_init+0x2e/0x50
   [<ffffffff80237571>] init_rt_bandwidth+0x41/0x60
   [<ffffffff812f3810>] sched_init+0x72/0x63d
   [<ffffffff812e17e2>] start_kernel+0x19c/0x456
   [<ffffffff812e10a9>] x86_64_start_reservations+0x99/0xb6
   [<ffffffff812e11d0>] x86_64_start_kernel+0xe2/0xe9
   [<ffffffffffffffff>] 0xffffffffffffffff

 ... acquired at:
   [<ffffffff802703b1>] __lock_acquire+0xdc1/0x1160
   [<ffffffff802707e1>] lock_acquire+0x91/0xc0
   [<ffffffff806a2d43>] _spin_lock_irqsave+0x53/0x90
   [<ffffffff80467567>] __debug_object_init+0xb7/0x3e0
   [<ffffffff804678df>] debug_object_init+0x1f/0x30
   [<ffffffff80260eee>] hrtimer_init+0x2e/0x50
   [<ffffffff812f577b>] ntp_init+0x1e/0x2b
   [<ffffffff812f5633>] timekeeping_init+0x3a/0x144
   [<ffffffff812e189d>] start_kernel+0x257/0x456
   [<ffffffff812e10a9>] x86_64_start_reservations+0x99/0xb6
   [<ffffffff812e11d0>] x86_64_start_kernel+0xe2/0xe9
   [<ffffffffffffffff>] 0xffffffffffffffff

 -> (clocksource_lock){++..} ops: 214 {
    initial-use  at:
                                         [<ffffffff8026f795>]
__lock_acquire+0x1a5/0x1160
                                         [<ffffffff802707e1>]
lock_acquire+0x91/0xc0
                                         [<ffffffff806a2d43>]
_spin_lock_irqsave+0x53/0x90
                                         [<ffffffff80266245>]
clocksource_get_next+0x15/0x60
                                         [<ffffffff812f5638>]
timekeeping_init+0x3f/0x144
                                         [<ffffffff812e189d>]
start_kernel+0x257/0x456
                                         [<ffffffff812e10a9>]
x86_64_start_reservations+0x99/0xb6
                                         [<ffffffff812e11d0>]
x86_64_start_kernel+0xe2/0xe9
                                         [<ffffffffffffffff>] 0xffffffffffffffff
    in-hardirq-W at:
                                         [<ffffffffffffffff>] 0xffffffffffffffff
    in-softirq-W at:
                                         [<ffffffffffffffff>] 0xffffffffffffffff
  }
  ... key      at: [<ffffffff80877bb8>] clocksource_lock+0x18/0x40
 ... acquired at:
   [<ffffffff802703b1>] __lock_acquire+0xdc1/0x1160
   [<ffffffff802707e1>] lock_acquire+0x91/0xc0
   [<ffffffff806a2d43>] _spin_lock_irqsave+0x53/0x90
   [<ffffffff80266245>] clocksource_get_next+0x15/0x60
   [<ffffffff812f5638>] timekeeping_init+0x3f/0x144
   [<ffffffff812e189d>] start_kernel+0x257/0x456
   [<ffffffff812e10a9>] x86_64_start_reservations+0x99/0xb6
   [<ffffffff812e11d0>] x86_64_start_kernel+0xe2/0xe9
   [<ffffffffffffffff>] 0xffffffffffffffff

 -> (old_style_seqlock_init){++..} ops: 210 {
    initial-use  at:
                                         [<ffffffffffffffff>] 0xffffffffffffffff
    in-hardirq-W at:
                                         [<ffffffffffffffff>] 0xffffffffffffffff
    in-softirq-W at:
                                         [<ffffffffffffffff>] 0xffffffffffffffff
  }
  ... key      at: [<ffffffff812d61a0>] nl80211_policy+0xda0/0x2c00
 ... acquired at:
   [<ffffffffffffffff>] 0xffffffffffffffff

 -> (ftrace_shutdown_lock){++..} ops: 480 {
    initial-use  at:
                                         [<ffffffff8026f795>]
__lock_acquire+0x1a5/0x1160
                                         [<ffffffff802707e1>]
lock_acquire+0x91/0xc0
                                         [<ffffffff806a2d43>]
_spin_lock_irqsave+0x53/0x90
                                         [<ffffffff802a4216>]
ftrace_record_ip+0x196/0x2f0
                                         [<ffffffff8020c6b4>]
mcount_call+0x5/0x31
                                         [<ffffffff812e1c9b>]
kernel_init+0x14d/0x1b2
                                         [<ffffffff8020d919>] child_rip+0xa/0x11
                                         [<ffffffffffffffff>] 0xffffffffffffffff
    in-hardirq-W at:
                                         [<ffffffffffffffff>] 0xffffffffffffffff
    in-softirq-W at:
                                         [<ffffffffffffffff>] 0xffffffffffffffff
  }
  ... key      at: [<ffffffff8087c1b8>] ftrace_shutdown_lock+0x18/0x40
 ... acquired at:
   [<ffffffffffffffff>] 0xffffffffffffffff


stack backtrace:
Pid: 9, comm: rcu_sched_grace Not tainted 2.6.27-rc4-225c-debug #3

Call Trace:
 [<ffffffff8026d8b2>] print_irq_inversion_bug+0x142/0x160
 [<ffffffff8026dd27>] check_usage_backwards+0x67/0xb0
 [<ffffffff8026ebd3>] mark_lock+0x363/0x7f0
 [<ffffffff8026fae9>] __lock_acquire+0x4f9/0x1160
 [<ffffffff802707e1>] lock_acquire+0x91/0xc0
 [<ffffffff80466c2c>] ? free_object+0x7c/0xc0
 [<ffffffff806a2bb1>] _spin_lock+0x41/0x80
 [<ffffffff80466c2c>] ? free_object+0x7c/0xc0
 [<ffffffff806a6bc9>] ? sub_preempt_count+0x69/0xd0
 [<ffffffff80466c2c>] free_object+0x7c/0xc0
 [<ffffffff8046707e>] debug_object_free+0xbe/0x130
 [<ffffffff806a070e>] schedule_timeout+0x7e/0xe0
 [<ffffffff802503a0>] ? process_timeout+0x0/0x10
 [<ffffffff806a06f2>] ? schedule_timeout+0x62/0xe0
 [<ffffffff8029cf10>] ? rcu_sched_grace_period+0x0/0x3a0
 [<ffffffff806a07ce>] schedule_timeout_interruptible+0x1e/0x20
 [<ffffffff8029cfb2>] rcu_sched_grace_period+0xa2/0x3a0
 [<ffffffff8029cf10>] ? rcu_sched_grace_period+0x0/0x3a0
 [<ffffffff8025d50e>] kthread+0x4e/0x90
 [<ffffffff8020d919>] child_rip+0xa/0x11
 [<ffffffff80239b8f>] ? finish_task_switch+0x5f/0x120
 [<ffffffff806a356b>] ? _spin_unlock_irq+0x3b/0x70
 [<ffffffff8020cf23>] ? restore_args+0x0/0x30
 [<ffffffff8025d4c0>] ? kthread+0x0/0x90
 [<ffffffff8020d90f>] ? child_rip+0x0/0x11

--- [2]

procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
58  0  63972  17316     16 145172  128 21176   128 21176 6054 8662 79 21  0  0
47  2  81020  14380     16 139472 1120 17052  1240 17052 6106 9532 77 23  0  0
52  1  86276  33656     16 137140  604 5304   796  5304 5349 7954 81 19  0  0
94  0  86276  32192     16 137484  480    0   772     0 5418 7618 84 16  0  0
88  0  86264  22416     16 137800   96    0   396     0 4746 5937 87 13  0  0
63  1  86200  54636     16 137932 1380    0  1408     0 5472 8007 82 18  0  0
47  0  86020  22848     16 138132  256    0   312     0 6126 12227 72 28  0  0
75  2 103828  20252     16 135500  528 17836   592 17836 6655 12862 69 31  0  0
21  0 128568  17536     16 128888 2336 24732  2336 24732 6762 12891 66 34  0  0
159  0 154996  16888     16 124808  480 26236   504 26236 5930 7689 80 20  0  0
45  0 165616  40108     16 120544  192 10696   248 10696 6136 9163 77 23  0  0
95  0 165616  27296     16 120632  924    0   940     0 5293 7468 82 18  0  0
BUG: NMI Watchdog detected LOCKUP on CPU0, ip ffffffff80214407, registers:
CPU 0
Modules linked in: rfcomm l2cap bluetooth kvm_intel kvm microcode
dvb_usb_dtt200u dvb_usb uvcvideo dvb_core compat_ioctl32 i2c_core
videodev v4l1_compat shpchp pcig
Pid: 6948, comm: spiral Not tainted 2.6.27-rc4-225c-debug #3
RIP: 0010:[<ffffffff80214407>]  [<ffffffff80214407>] native_read_tsc+0x7/0x30
RSP: 0018:ffffffff8153ab70  EFLAGS: 00000002
RAX: 00000467c85cb001 RBX: ffffffff8088f5c0 RCX: 00000000c85cb001
RDX: 00000000c85cb001 RSI: 0000000000000103 RDI: 0000000000000001
RBP: ffffffff8153ab70 R08: 0000000000000000 R09: 0000000000000001
R10: 0000000000000000 R11: ffff8800cf978000 R12: 00000000c85cb001
R13: 0000000000000001 R14: 0000000000000000 R15: ffff88012a61c8c0
FS:  00007fb48cb796e0(0000) GS:ffffffff80e82dc0(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000075212e6 CR3: 00000000cc1e6000 CR4: 00000000000026e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
Process spiral (pid: 6948, threadinfo ffff8800cf950000, task ffff8800cf978000)
Stack:  ffffffff8153aba0 ffffffff804560c7 ffffffff8088f5c0 0000000005b61b94
 00000000d6915628 0000000000000001 ffffffff8153abb0 ffffffff80455fff
 ffffffff8153abe0 ffffffff80466302 ffffffff8088f5d8 ffffffff8088f5c0
Call Trace:
 <IRQ>  [<ffffffff804560c7>] delay_tsc+0x67/0xd0
 [<ffffffff80455fff>] __delay+0xf/0x20
 [<ffffffff80466302>] _raw_spin_lock+0x122/0x170
 [<ffffffff806a2bd1>] _spin_lock+0x61/0x80
 [<ffffffff80466c2c>] ? free_object+0x7c/0xc0
 [<ffffffff80466c2c>] free_object+0x7c/0xc0
 [<ffffffff80466e0f>] __debug_check_no_obj_freed+0x19f/0x1e0
 [<ffffffff80466e65>] debug_check_no_obj_freed+0x15/0x20
 [<ffffffff802dff0c>] kmem_cache_free+0xec/0x110
 [<ffffffff80517fa1>] ? scsi_pool_free_command+0x51/0x60
 [<ffffffff80517fa1>] scsi_pool_free_command+0x51/0x60
 [<ffffffff805184bf>] __scsi_put_command+0x5f/0xa0
 [<ffffffff80518561>] scsi_put_command+0x61/0x70
 [<ffffffff8051e47a>] scsi_next_command+0x3a/0x60
 [<ffffffff8051e544>] scsi_end_request+0xa4/0xc0
 [<ffffffff8051e68f>] scsi_io_completion+0x12f/0x440
 [<ffffffff80517bf5>] scsi_finish_command+0x95/0xd0
 [<ffffffff8051eb36>] scsi_softirq_done+0x86/0x110
 [<ffffffff8043bbed>] blk_done_softirq+0x8d/0xa0
 [<ffffffff8024ba04>] __do_softirq+0x74/0xf0
 [<ffffffff8020dc7c>] call_softirq+0x1c/0x30
 [<ffffffff8020f485>] do_softirq+0x75/0xb0
 [<ffffffff8024b155>] irq_exit+0xa5/0xb0
 [<ffffffff8020f7d3>] do_IRQ+0xe3/0x1d0
 [<ffffffff80466c66>] ? free_object+0xb6/0xc0
 [<ffffffff8020ce76>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff80270ba0>] ? lock_release+0xe0/0x210
 [<ffffffff806a3253>] ? _spin_unlock+0x23/0x60
 [<ffffffff80466c66>] ? free_object+0xb6/0xc0
 [<ffffffff8046707e>] ? debug_object_free+0xbe/0x130
 [<ffffffff806a070e>] ? schedule_timeout+0x7e/0xe0
 [<ffffffff802503a0>] ? process_timeout+0x0/0x10
 [<ffffffff806a06f2>] ? schedule_timeout+0x62/0xe0
 [<ffffffff802f8b3e>] ? do_select+0x4be/0x610
 [<ffffffff802f8c90>] ? __pollwait+0x0/0x120
 [<ffffffff8026f1d9>] ? trace_hardirqs_on_caller+0x29/0x1b0
 [<ffffffff8026f1d9>] ? trace_hardirqs_on_caller+0x29/0x1b0
 [<ffffffff8026f36d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff806a0b9e>] ? mutex_unlock+0xe/0x10
 [<ffffffff8065919e>] ? unix_stream_recvmsg+0x32e/0x6d0
 [<ffffffff8026f1d9>] ? trace_hardirqs_on_caller+0x29/0x1b0
 [<ffffffff8026f36d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff802f8f4b>] ? core_sys_select+0x19b/0x2e0
 [<ffffffff802e89e9>] ? do_sync_read+0xf9/0x140
 [<ffffffff8025d8e0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff806a6bc9>] ? sub_preempt_count+0x69/0xd0
 [<ffffffff802f94b0>] ? sys_select+0xd0/0x1c0
 [<ffffffff8020c86b>] ? system_call_fastpath+0x16/0x1b


Code: 90 90 90 90 55 89 f8 48 89 e5 e6 70 e4 71 c9 c3 0f 1f 40 00 55
89 f0 48 89 e5 e6 70 89 f8 e6 71 c9 c3 66 90 55 48 89 e5 0f 1f 00 <0f>
ae e8 0f 31 89 c1 0f 1f
BUG: NMI Watchdog detected LOCKUP<4>---[ end trace fd851c3db62e5044 ]---
Kernel panic - not syncing: Aiee, killing interrupt handler!
 on CPU1, ip ffffffff80214407, registers:
CPU 1
Modules linked in: rfcomm l2cap bluetooth kvm_intel kvm microcode
dvb_usb_dtt200u dvb_usb uvcvideo dvb_core compat_ioctl32 i2c_core
videodev v4l1_compat shpchp pcig
Pid: 10150, comm: gcc Not tainted 2.6.27-rc4-225c-debug #3
RIP: 0010:[<ffffffff80214407>]  [<ffffffff80214407>] native_read_tsc+0x7/0x30
RSP: 0018:ffff8800b6269c28  EFLAGS: 00000092
RAX: 0000000000000001 RBX: ffffffff8088f5c0 RCX: 00000000c85cafc2
RDX: 000000008b468b00 RSI: 0000000000000002 RDI: 0000000000000001
RBP: ffff8800b6269c28 R08: 0000000000000000 R09: 0000000000000001
R10: 0000000000000000 R11: ffff8800a65047e0 R12: 0000000005d22695
R13: 0000000000000001 R14: 0000000000000001 R15: ffff88009e9be940
FS:  00002b124e4fc6e0(0000) GS:ffff88012fa644b0(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00002b8a265f5960 CR3: 00000000b61e9000 CR4: 00000000000026e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process gcc (pid: 10150, threadinfo ffff8800b6268000, task ffff8800a65047e0)
Stack:  ffff8800b6269c58 ffffffff8045608a ffffffff8088f5c0 0000000005d22695
 00000000d6915628 0000000000000001 ffff8800b6269c68 ffffffff80455fff
 ffff8800b6269c98 ffffffff80466302 ffffffff8088f5d8 ffffffff8088f5c0
Call Trace:
 [<ffffffff8045608a>] delay_tsc+0x2a/0xd0
 [<ffffffff80455fff>] __delay+0xf/0x20
 [<ffffffff80466302>] _raw_spin_lock+0x122/0x170
 [<ffffffff806a2bd1>] _spin_lock+0x61/0x80
 [<ffffffff80466c2c>] ? free_object+0x7c/0xc0
 [<ffffffff80466c2c>] free_object+0x7c/0xc0
 [<ffffffff80466e0f>] __debug_check_no_obj_freed+0x19f/0x1e0
 [<ffffffff80466e65>] debug_check_no_obj_freed+0x15/0x20
 [<ffffffff802dff0c>] kmem_cache_free+0xec/0x110
 [<ffffffff8024264b>] ? __cleanup_signal+0x1b/0x20
 [<ffffffff8024264b>] __cleanup_signal+0x1b/0x20
 [<ffffffff80248273>] release_task+0x233/0x3d0
 [<ffffffff80248960>] wait_consider_task+0x550/0x8b0
 [<ffffffff80248e16>] do_wait+0x156/0x350
 [<ffffffff8023b6f0>] ? default_wake_function+0x0/0x10
 [<ffffffff802490a6>] sys_wait4+0x96/0xf0
 [<ffffffff8020c86b>] system_call_fastpath+0x16/0x1b


Code: 90 90 90 90 55 89 f8 48 89 e5 e6 70 e4 71 c9 c3 0f 1f 40 00 55
89 f0 48 89 e5 e6 70 89 f8 e6 71 c9 c3 66 90 55 48 89 e5 0f 1f 00 <0f>
ae e8 0f 31 89 c1 0f 1f
---[ end trace fd851c3db62e5044 ]---
-- 
Daniel J Blueman
