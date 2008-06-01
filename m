Return-Path: <linux-kernel-owner+w=401wt.eu-S1753571AbYFARKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571AbYFARKo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 13:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751601AbYFARKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 13:10:37 -0400
Received: from smtp.cs.aau.dk ([130.225.194.6]:51612 "EHLO smtp.cs.aau.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751530AbYFARKf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 13:10:35 -0400
Subject: Re: CONFIG_PREEMPT causes corruption of application's FPU stack
From: Simon Holm =?ISO-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
To: j.mell@t-online.de
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       ak@suse.de
In-Reply-To: <200806011101.06491.j.mell@t-online.de>
References: <200806011101.06491.j.mell@t-online.de>
Content-Type: text/plain; charset=utf-8
Date: Sun, 01 Jun 2008 19:11:02 +0200
Message-Id: <1212340262.5802.8.camel@odie.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

søn, 01 06 2008 kl. 11:01 +0200, skrev j.mell@t-online.de:
[...]
> 
> 3. If I revert the patch
>  
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=acc207616a91a413a50fdd8847a747c4a7324167
> 
> in 2.6.20, Einstein does not crash anymore (program was run for more than 
> 30 hours while system was in normal use with programming, multi-media 
> etc.). Unfortunately git refuses to revert this patch in 2.6.26-rc4.
[...]

I don't think the bisected commit is responsible for anything, but
triggering a bug elsewhere with your workload. I've been chasing the
same problem I think, but with other symptoms.

I'm triggering the following by running an lguest guest, but I guess the
workload just need to have the right scheduler intensity to trigger the
bug.

BUG: sleeping function called from invalid context at mm/slab.c:3052
in_atomic():1, irqs_disabled():0
Pid: 4771, comm: lguest Not tainted
2.6.26-rc4-debug-only-preemptible-00103-g1beee8d #3
 [<c01146ee>] __might_sleep+0xe4/0xeb
 [<c01605d9>] kmem_cache_alloc+0x22/0xb4
 [<c0108479>] init_fpu+0xb0/0x14d
 [<c0104768>] math_state_restore+0x26/0x5d
 [<c01045ab>] device_not_available+0x43/0x48
 [<c011007b>] ? handle_vm86_fault+0x213/0x6b8
 [<c01029ad>] ? __switch_to+0x23/0x113
 [<c02d6c9f>] schedule+0x221/0x2a4
 [<c02d716a>] ? schedule_timeout+0x16/0x89
 [<c016ed36>] ? __pollwait+0xaa/0xb0
 [<c0168358>] ? pipe_poll+0x29/0x89
 [<c016e79a>] ? do_select+0x478/0x4cd
 [<c016ec8c>] ? __pollwait+0x0/0xb0
 [<c0116657>] ? default_wake_function+0x0/0xd
 [<c0116657>] ? default_wake_function+0x0/0xd
 [<c0116657>] ? default_wake_function+0x0/0xd
 [<c0116657>] ? default_wake_function+0x0/0xd
 [<c0116657>] ? default_wake_function+0x0/0xd
 [<c012f49d>] ? getnstimeofday+0x37/0xb7
 [<c012d810>] ? ktime_get_ts+0x40/0x44
 [<c012d827>] ? ktime_get+0x13/0x2f
 [<c011406f>] ? hrtick_start_fair+0xd5/0x111
 [<c01216f6>] ? internal_add_timer+0x8e/0x92
 [<c01f27b7>] ? delay_tsc+0x4f/0x68
 [<c025b05b>] ? ide_dma_intr+0x0/0x79
 [<c01f274d>] ? __delay+0x9/0xb
 [<c01f2766>] ? __const_udelay+0x17/0x19
 [<c0256df7>] ? ide_execute_command+0x7b/0x95
 [<c025a7a2>] ? ide_dma_start+0x24/0x36
 [<c0259ebb>] ? do_rw_taskfile+0x1be/0x1cf
 [<c025c31a>] ? ide_do_rw_disk+0x19a/0x1dd
 [<c01f2766>] ? __const_udelay+0x17/0x19
 [<c025554e>] ? ide_do_request+0x838/0x875
 [<c0254941>] ? ide_end_request+0x7d/0x99
 [<c016e9d8>] ? core_sys_select+0x1e9/0x2c7
 [<c0146aa4>] ? find_lock_page+0xa1/0xbb
 [<c01489a2>] ? filemap_fault+0x21c/0x382
 [<c0146942>] ? unlock_page+0x24/0x27
 [<c0151bac>] ? __do_fault+0x314/0x34c
 [<c0153a56>] ? handle_mm_fault+0x291/0x65a
 [<c016edcb>] ? sys_select+0x8f/0x143
 [<c02d9dc8>] ? do_page_fault+0x33c/0x616
 [<c0103a67>] ? sysenter_past_esp+0x78/0xb1
 [<c02d0000>] ? packet_rcv+0x159/0x2c7
 =======================
BUG: sleeping function called from invalid context at mm/slab.c:3052
in_atomic():1, irqs_disabled():0
Pid: 4771, comm: lguest Not tainted
2.6.26-rc4-debug-only-preemptible-00103-g1beee8d #3
 [<c01146ee>] __might_sleep+0xe4/0xeb
 [<c01605d9>] kmem_cache_alloc+0x22/0xb4
 [<c012f49d>] ? getnstimeofday+0x37/0xb7
 [<c012f49d>] ? getnstimeofday+0x37/0xb7
 [<c0108479>] init_fpu+0xb0/0x14d
 [<c0104768>] math_state_restore+0x26/0x5d
 [<c01045ab>] device_not_available+0x43/0x48
 [<c0110000>] ? handle_vm86_fault+0x198/0x6b8
 [<c01029ad>] ? __switch_to+0x23/0x113
 [<c02d6c9f>] schedule+0x221/0x2a4
 [<c012a95b>] ? prepare_to_wait+0x6c/0x84
 [<c0168bdd>] ? pipe_wait+0x53/0x72
 [<c012a76f>] ? autoremove_wake_function+0x0/0x30
 [<c01692b9>] ? pipe_read+0x29a/0x302
 [<c012d6ae>] ? hrtimer_start+0xcc/0xf8
 [<c0115efd>] ? hrtick_set+0xcc/0x140
 [<c01630b0>] ? do_sync_read+0xba/0xf8
 [<c012a76f>] ? autoremove_wake_function+0x0/0x30
 [<c01638b8>] ? default_llseek+0xa7/0xb5
 [<c0162ff6>] ? do_sync_read+0x0/0xf8
 [<c0163795>] ? vfs_read+0x8a/0x106
 [<c0163ada>] ? sys_read+0x3b/0x60
 [<c0103a67>] ? sysenter_past_esp+0x78/0xb1
 =======================

I'm getting the traces with CONFIG_DEBUG_PREEMPT=y and no
CONFIG_DEBUG_SPINLOCK, since otherwise I'd just get 

BUG: sleeping function called from invalid context at mm/slab.c:3052
BUG: spinlock recursion on CPU#0, lguest/5428

and nothing further. Using CONFIG_DEBUG_PREEMPT=y,
CONFIG_DEBUG_SPINLOCK=y and booting with "lapic nmi_watchdog=2" I was
also able to grab the following over netconsole though

BUG: sleeping function called from invalid context at mm/slab.c:3052
BUG: spinlock recursion on CPU#0, lguest/5428
BUG: NMI Watchdog detected LOCKUP on CPU0, ip c01f1f76, registers:
Modules linked in: lg tun arc4 ecb crypto_blkcipher cryptomgr
crypto_algapi ieee80211_crypt_wep bridge llc snd_seq snd_seq_device
radeonfb uhci_hcd snd_intel8x0 ehci_hcd snd_ac97_codec ipw2200 usbcore
fb ac97_bus fb_ddc backlight snd_pcm ieee80211 firewire_ohci
firewire_core i2c_algo_bit snd_timer intel_agp cfbcopyarea snd agpgart
i2c_i801 ieee80211_crypt firmware_class cfbimgblt soundcore crc_itu_t
cfbfillrect rtc iTCO_wdt snd_page_alloc i2c_core

Pid: 5428, comm: lguest Not tainted
(2.6.26-rc4debug-locks-extended-00103-g1beee8d #2)
EIP: 0060:[<c01f1f76>] EFLAGS: 00000002 CPU: 0
EIP is at delay_tsc+0x2e/0x68
EAX: 100a8436 EBX: c03acd84 ECX: 00000000 EDX: 0000004c
ESI: 100a83fb EDI: 00000001 EBP: e9651738 ESP: e9651724
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process lguest (pid: 5428, ti=e9650000 task=efbc92c0 task.ti=e964c000)
Stack: 00000001 100a83fb c03acd84 02df69af 00000001 e9651740 c01f1f2d
e9651758 
       c01ff481 593ac9e8 c03acd84 00000092 000078cf e9651774 c02d4968
00000000 
       00000002 c01141c4 c03acd84 00000001 e965178c c01141c4 00000001
00007892 
Call Trace:
 [<c01f1f2d>] ? __delay+0x9/0xb
 [<c01ff481>] ? _raw_spin_lock+0x83/0xcb
 [<c02d4968>] ? _spin_lock_irqsave+0x46/0x4f
 [<c01141c4>] ? __wake_up+0x15/0x3b
 [<c01141c4>] ? __wake_up+0x15/0x3b
 [<c0119cf0>] ? wake_up_klogd+0x2e/0x31
 [<c0119ea0>] ? release_console_sem+0x1ad/0x1b5
 [<c011a3d1>] ? vprintk+0x383/0x3c2
 [<c0134276>] ? debug_check_no_locks_freed+0x111/0x13c
 [<c0134276>] ? debug_check_no_locks_freed+0x111/0x13c
 [<c011a425>] ? printk+0x15/0x17
 [<c01ff286>] ? spin_bug+0x3f/0x80
 [<c01ff432>] ? _raw_spin_lock+0x34/0xcb
 [<c02d474e>] ? _spin_lock+0x2a/0x32
 [<c011471b>] ? task_rq_lock+0x2a/0x31
 [<c011471b>] ? task_rq_lock+0x2a/0x31
 [<c0114dc8>] ? try_to_wake_up+0x15/0x81
 [<c0114e3f>] ? default_wake_function+0xb/0xd
 [<c012985f>] ? autoremove_wake_function+0xe/0x30
 [<c0113626>] ? __wake_up_common+0x35/0x5b
 [<c01141d7>] ? __wake_up+0x28/0x3b
 [<c0119cf0>] ? wake_up_klogd+0x2e/0x31
 [<c0119ea0>] ? release_console_sem+0x1ad/0x1b5
 [<c011a3d1>] ? vprintk+0x383/0x3c2
 [<c011a425>] ? printk+0x15/0x17
 [<c0115232>] ? __might_sleep+0x8c/0x108
 [<c0160c37>] ? kmem_cache_alloc+0x22/0xd6
 [<c0108441>] ? init_fpu+0xb0/0x14d
 [<c01047fd>] ? math_state_restore+0x2b/0x67
 [<c010463a>] ? device_not_available+0x4e/0x53
 [<c02d2b8a>] ? schedule+0x1fe/0x2a1
 [<c011007b>] ? handle_vm86_fault+0x31f/0x6b8
 [<c01029c1>] ? __switch_to+0x23/0x113
 [<c02d2bc6>] ? schedule+0x23a/0x2a1
 [<c0134130>] ? trace_hardirqs_on+0xe6/0x11b
 [<c02d4c3f>] ? _spin_unlock_irqrestore+0x56/0x6c
 [<c02d2db8>] ? schedule_timeout+0x16/0x89
 [<c016ee08>] ? __pollwait+0xaa/0xb0
 [<c0168604>] ? pipe_poll+0x29/0x89
 [<c016e844>] ? do_select+0x4a6/0x4f8
 [<c016ed5e>] ? __pollwait+0x0/0xb0
 [<c0114e34>] ? default_wake_function+0x0/0xd
 [<c0114e34>] ? default_wake_function+0x0/0xd
 [<c0114e34>] ? default_wake_function+0x0/0xd
 [<c0114e34>] ? default_wake_function+0x0/0xd
 [<c0114e34>] ? default_wake_function+0x0/0xd
 [<c0113dfa>] ? hrtick_start_fair+0x117/0x11f
 [<c01607a8>] ? kfree+0xad/0xc0
 [<c0160833>] ? kmem_cache_free+0x78/0x8a
 [<c0134130>] ? trace_hardirqs_on+0xe6/0x11b
 [<c0133fac>] ? mark_held_locks+0x4e/0x66
 [<c01349ae>] ? __lock_acquire+0x488/0xb4c
 [<c016eaad>] ? core_sys_select+0x217/0x2f2
 [<c02d4d42>] ? _read_unlock_irq+0x36/0x4b
 [<c0147fab>] ? unlock_page+0x24/0x27
 [<c0152c7f>] ? __do_fault+0x31e/0x356
 [<c0153fb3>] ? handle_mm_fault+0x2a0/0x637
 [<c016ee9d>] ? sys_select+0x8f/0x143
 [<c02d67d3>] ? do_page_fault+0x352/0x631
 [<c0103b59>] ? restore_nocheck+0x12/0x15
 [<c02d6481>] ? do_page_fault+0x0/0x631
 [<c0134130>] ? trace_hardirqs_on+0xe6/0x11b
 [<c0103a4f>] ? sysenter_past_esp+0x78/0xd1
 =======================
Code: 57 56 53 83 ec 08 89 45 ec b8 01 00 00 00 e8 b8 4b 0e 00 0f 31 0f
1f 40 00 b9 00 00 00 00 89 c6 89 c8 09 f0 89 45 f0 f3 90 0f 31 <0f> 1f
40 00 b9 00 00 00 00 89 c6 89 c8 09 f0 2b 45 f0 3b 45 ec 


Let us take a closer look at __switch_to. I'm using test data from yet
another trace (that I actually captured before all the other traces
presented here).

BUG: unable to handle kernel NULL pointer dereference at 000001ff
IP: [<c0102964>] __switch_to+0x19/0xff

That is the only part of the trace I've got; there wasn't produced more.
Anyway, for that particular kernel I used, __switch_to disassembled to

0xc0102955 <__switch_to+10>: mov    0x4(%eax),%eax
0xc0102958 <__switch_to+13>: testb  $0x1,0xc(%eax)
0xc010295c <__switch_to+17>: je     0xc0102995 <__switch_to+74>
0xc010295e <__switch_to+19>: mov    0x26c(%edi),%eax
0xc0102964 <__switch_to+25>: fnsave (%eax)

with corresponding source code

struct task_struct * __switch_to(struct task_struct *prev_p, struct
task_struct *next_p)
{
[...]
        __unlazy_fpu(prev_p);
[...]
}

static inline void __unlazy_fpu(struct task_struct *tsk)
{
        if (task_thread_info(tsk)->status & TS_USEDFPU) {
                __save_init_fpu(tsk);
                stts();
        } else
                tsk->fpu_counter = 0;
}

where __save_init_fpu(tsk) accesses
	tsk->thread.xstate->fxsave

The first mov, testb and je of the disassembly are the if statement, and
the second mov and fnsave are part of __save_init_fpu that access
tsk->thread.xstate->fxsave. %eax (initially) and %edi hold prev_p from
__switch_to.

Hope that was readable and not too confusing. Now comes some partly
guesswork from my side that could be wrong. As far as I can tell
%eax (initially) and %edi / prev_p must hold 0xffffff93. Why the first
mov is valid then I'm not sure, but the if statement must be true by
chance.  It is not by pure chance though, since prev_p always has the
same value (i.e. it is consistently "dereference at 000001ff" I get
across multiple runs).

So I'd say some sort of corruption caused by very fast context switch
between the launcher and switcher (or-whatever-their-names-are)
processes in lguest.

That is as far as I have been able to debug this, suggestions are
welcome. I guess I should note that I haven't tried with preemption
disabled, but I don't think there's much point in it.


﻿Simon Holm Thøgersen

