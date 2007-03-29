Return-Path: <linux-kernel-owner+w=401wt.eu-S1753401AbXC2MjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401AbXC2MjO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 08:39:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753426AbXC2MjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 08:39:13 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:10334 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753401AbXC2MjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 08:39:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=ExhTuuJ9BCYyBQNLTuEd/lvdKwZUn0CPbJL/yAuZf8eqaRicnS10Ddw3fDhYlZUolYo7DTInW6s6R599ymEAbPB+k+uCsJwfZrDVOiazxg9CT+dSKlRflrQsaAqqIsjXzL5CXbvwXf2BQL+6KMlU9h3VH0BtqsdBXpBYugjlNIA=
Message-ID: <460BB361.1000002@googlemail.com>
Date: Thu, 29 Mar 2007 14:38:57 +0200
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.21-rc5-rt4 inconsistent lock state
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

artsd during kde start triggered this

=================================
[ INFO: inconsistent lock state ]
[ 2.6.21-rc5-rt4 #4
---------------------------------
inconsistent {hardirq-on-W} -> {in-hardirq-W} usage.
artsd/3454 [HC1[1]:SC0[0]:HE0:SE1] takes:
 ((raw_spinlock_t *)(&lock->wait_lock)){+-..}, at: [<c0358d1f>] rt_spin_lock_slowlock+0x29/0x1b4
{hardirq-on-W} state was registered at:
  [<c0143a91>] mark_lock+0x73/0x4a9
  [<c0143f19>] mark_held_locks+0x52/0x6f
  [<c0144115>] trace_hardirqs_on+0x116/0x162
  [<c035a616>] __spin_unlock_irqrestore+0x54/0x70
  [<c014a2a4>] task_blocks_on_rt_mutex+0x1d6/0x226
  [<c0358dc5>] rt_spin_lock_slowlock+0xcf/0x1b4
  [<c035959b>] rt_spin_lock+0x13/0x4b
  [<c035804f>] wait_for_completion+0x2e/0xab
  [<c012048d>] set_cpus_allowed+0x88/0xab
  [<c012055b>] measure_one+0xab/0x184
  [<c0120be5>] build_sched_domains+0x5b1/0xc19
  [<c0121272>] arch_init_sched_domains+0x25/0x27
  [<c04dccec>] sched_init_smp+0x1c/0x6a
  [<c04d0590>] init+0x121/0x361
  [<c0104ff7>] kernel_thread_helper+0x7/0x10
  [<ffffffff>] 0xffffffff
irq event stamp: 116668
hardirqs last  enabled at (116667): [<c035a616>] __spin_unlock_irqrestore+0x54/0x70
hardirqs last disabled at (116668): [<c0104de9>] apic_timer_interrupt+0x29/0x38
softirqs last  enabled at (0): [<c0123b51>] copy_process+0x542/0x1440
softirqs last disabled at (0): [<00000000>] 0x0

l *0xc0358d1f
0xc0358d1f is in rt_spin_lock_slowlock (kernel/rtmutex.c:640).
635             unsigned long saved_state, state, flags;
636
637             debug_rt_mutex_init_waiter(&waiter);
638             waiter.task = NULL;
639
640             spin_lock_irqsave(&lock->wait_lock, flags);
641             init_lists(lock);
642
643             /* Try to acquire the lock again: */
644             if (try_to_take_rt_mutex(lock)) {

 l *0xc035a616
0xc035a616 is in __spin_unlock_irqrestore (include/asm/irqflags.h:33).
28              return flags;
29      }
30
31      static inline void raw_local_irq_restore(unsigned long flags)
32      {
33              __asm__ __volatile__(
34                      "pushl %0 ; popfl"
35                      : /* no output */
36                      :"g" (flags)
37                      :"memory", "cc"

l *0xc0104de9
0xc0104de9 is at include/asm/bitops.h:246.
241     static int test_bit(int nr, const volatile void * addr);
242     #endif
243
244     static __always_inline int constant_test_bit(int nr, const volatile unsigned long *addr)
245     {
246             return ((1UL << (nr & 31)) & (addr[nr >> 5])) != 0;
247     }
248
249     static inline int variable_test_bit(int nr, const volatile unsigned long * addr)
250     {

 l *0xc0123b51
0xc0123b51 is in copy_process (kernel/fork.c:1129).
1124            p->hardirq_enable_ip = 0;
1125            p->hardirq_enable_event = 0;
1126            p->hardirq_disable_ip = _THIS_IP_;
1127            p->hardirq_disable_event = 0;
1128            p->softirqs_enabled = 1;
1129            p->softirq_enable_ip = _THIS_IP_;
1130            p->softirq_enable_event = 0;
1131            p->softirq_disable_ip = 0;
1132            p->softirq_disable_event = 0;
1133            p->hardirq_context = 0;


other info that might help us debug this:
1 lock held by artsd/3454:
 #0:  (&tu->tread_sem){--..}, at: [<f98abe00>] snd_timer_user_ioctl+0x618/0xb0d [snd_timer]

stack backtrace:
 [<c0105470>] dump_trace+0x78/0x21a
 [<c0105647>] show_trace_log_lvl+0x35/0x54
 [<c0105dcc>] show_trace+0x2c/0x2e
 [<c0105e93>] dump_stack+0x29/0x2b
 [<c014320b>] print_usage_bug+0x14d/0x157
 [<c0143ace>] mark_lock+0xb0/0x4a9
 [<c014498c>] __lock_acquire+0x3cf/0xc36
 [<c0145261>] lock_acquire+0x6e/0x86
 [<c035a10c>] __spin_lock_irqsave+0x55/0x65
 [<c0358d1f>] rt_spin_lock_slowlock+0x29/0x1b4
 [<c035959b>] rt_spin_lock+0x13/0x4b
 [<c0276d47>] serial8250_console_write+0x4e/0x155
 [<c0125c2f>] __call_console_drivers+0x73/0x88
 [<c0125cb8>] _call_console_drivers+0x74/0x7a
 [<c0125f4e>] release_console_sem+0x11e/0x1ad
 [<c0126644>] vprintk+0x2dc/0x32b
 [<c01266b3>] printk+0x20/0x22
 [<c011e39d>] task_running_tick+0x401/0x450
 [<c012180f>] scheduler_tick+0x188/0x1e3
 [<c012f964>] update_process_times+0x40/0x6d
 [<c01416c7>] tick_sched_timer+0x76/0xb6
 [<c013d5b6>] hrtimer_interrupt+0x15d/0x205
 [<c01161c5>] smp_apic_timer_interrupt+0x94/0xa7
 [<c0104df3>] apic_timer_interrupt+0x33/0x38
 [<c035a618>] __spin_unlock_irqrestore+0x56/0x70
 [<c014a325>] rt_mutex_adjust_prio+0x31/0x37
 [<c0358c36>] rt_spin_lock_slowunlock+0x6d/0x73
 [<c0359602>] rt_spin_unlock+0x2f/0x35
 [<c0182d71>] kfree+0x9d/0xa5
 [<f98abea9>] snd_timer_user_ioctl+0x6c1/0xb0d [snd_timer]
 [<c0193d5e>] do_ioctl+0x32/0x7f
 [<c019403c>] vfs_ioctl+0x291/0x2a4
 [<c01940af>] sys_ioctl+0x60/0x79
 [<c010432d>] syscall_call+0x7/0xb
 [<b7f28410>] 0xb7f28410
 =======================
---------------------------
| preempt count: 00010001 ]
| 1-level deep critical section nesting:
----------------------------------------
.. [<c035a0da>] .... __spin_lock_irqsave+0x23/0x65
.....[<c0358d1f>] ..   ( <= rt_spin_lock_slowlock+0x29/0x1b4)

 l *0xc035a0da
0xc035a0da is in __spin_lock_irqsave (kernel/spinlock.c:122).
117     {
118             unsigned long flags;
119
120             local_irq_save(flags);
121             preempt_disable();
122             spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
123             /*
124              * On lockdep we dont want the hand-coded irq-enable of
125              * _raw_spin_lock_flags() code, because lockdep assumes
126              * that interrupts are not re-enabled during lock-acquire:

l *0xc0358d1f
0xc0358d1f is in rt_spin_lock_slowlock (kernel/rtmutex.c:640).
635             unsigned long saved_state, state, flags;
636
637             debug_rt_mutex_init_waiter(&waiter);
638             waiter.task = NULL;
639
640             spin_lock_irqsave(&lock->wait_lock, flags);
641             init_lists(lock);
642
643             /* Try to acquire the lock again: */
644             if (try_to_take_rt_mutex(lock)) {

http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc5-rt4/rt-config
http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc5-rt4/rt-dmesg

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
