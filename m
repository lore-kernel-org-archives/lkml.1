Return-Path: <linux-kernel-owner+w=401wt.eu-S1761063AbXKPPwN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761063AbXKPPwN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 10:52:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760045AbXKPPv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 10:51:57 -0500
Received: from ik-out-1112.google.com ([66.249.90.177]:17526 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758778AbXKPPvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 10:51:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=WwefKOox1yxZlj4Pt4dMpAPP89O1FE1lGo1tW9hx3qokIBT3lYb4r4IPKraY9/xBUY06jrNDqEyk7V2VH5xjT4IgG7Fef45roo8YKNbSE/6EoLAfyMhmExyAaOtSHKYaTsR9PU7VlgMmODtUYLbPbJe3h2DLEhnbV7qsp1+oyR0=
Message-ID: <3efb10970711160751l279fe99dl9f3a130a4373a449@mail.gmail.com>
Date: Fri, 16 Nov 2007 16:51:49 +0100
From: "Remy Bohmer" <linux@bohmer.net>
To: "Steven Rostedt" <rostedt@goodmis.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>
Subject: [BUG on PREEMPT_RT, 2.6.23.1-rt5] in rt-mutex code and signals
Cc: RT <linux-rt-users@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 1013bed55701d27e
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All,

I have a problem with the RT-mutex code and signals. The problem is
very easily reproducible, but I do not have found the root-cause yet.
I hope someone can help me on this one.

This is what I am doing:
* I have a simple character driver with a read call.(called spi_read()
in the logging below )
* The read call blocks on a semaphore until some condition in hardware
is reached. (in the routine wait_for_io_level(), see logging below)
* I use a down_interruptible() call on a 'struct semaphore' type
semaphore, which eventually blocks on a mutex. (the semaphore is, of
course, initialised with sema_init() )

What happens is that when a user-space RT-thread is waiting on the
semaphore through the spi_read() call, and a signal arrives during the
wait at this thread (like e.g. CTRL-C), the kernel starts oopsing
until it is as good as brain-dead.

If I do NOT sent a posix-signal the code/mutex/semaphore is working
properly for days,
So, it seems to be related by waking up from a blocking situation,
because of a pending posix-signal.

I tried also the types 'struct compat_semaphore', and mutexes; none of
them work.
In fact the real Mutex type, declared with init_MUTEX() has the same problem.

Anyone an idea?
Below the kernel oops output. (I run on ARM, but I think that should
not matter for this problem)

Kind Regards,

Remy Bohmer

[   52.113254] WARNING: at kernel/rtmutex.c:585 remove_waiter()
[   52.113254] [<c0022d88>] (dump_stack+0x0/0x14) from [<c004db84>]
(remove_waiter+0x14c/0x1e0)
[   52.113254] [<c004da38>] (remove_waiter+0x0/0x1e0) from
[<c0172ef4>] (rt_mutex_slowlock+0x278/0x2ec)
[   52.113254] [<c0172c7c>] (rt_mutex_slowlock+0x0/0x2ec) from
[<c0172b20>] (rt_mutex_lock_interruptible+0x58/0x5c)
[   52.113254] [<c0172ac8>] (rt_mutex_lock_interruptible+0x0/0x5c)
from [<c004e458>] (rt_down_interruptible+0x24/0x5c)
[   52.113254] [<c004e434>] (rt_down_interruptible+0x0/0x5c) from
[<c00fd9a4>] (wait_for_io_level+0x7c/0xcc)
[   52.113254]  r6:00000000 r5:00000024 r4:c01d5a34
[   52.113254] [<c00fd928>] (wait_for_io_level+0x0/0xcc) from
[<c00fe20c>] (spi_read+0x60/0x198)
[   52.113254]  r6:c3823f78 r5:c01d59b0 r4:00000000
[   52.113254] [<c00fe1ac>] (spi_read+0x0/0x198) from [<c006e750>]
(vfs_read+0xb4/0xf4)
[   52.113254]  r8:c001f044 r7:c3823f78 r6:40967c29 r5:c3e2ae80 r4:000001ff
[   52.113254] [<c006e69c>] (vfs_read+0x0/0xf4) from [<c006eb4c>]
(sys_read+0x4c/0x7c)
[   52.113254]  r7:00000003 r6:c3e2ae80 r5:00000000 r4:00000000
[   52.113254] [<c006eb00>] (sys_read+0x0/0x7c) from [<c001eec0>]
(ret_fast_syscall+0x0/0x2c)
[   52.113254]  r6:40042000 r5:40969490 r4:409694d8
[   52.791965] Unable to handle kernel NULL pointer dereference at
virtual address 00000000
[   52.791965] pgd = c3ff4000
[   52.791965] [00000000] *pgd=23e3b031, *pte=00000000, *ppte=00000000
[   52.791965] stopped custom tracer.
[   52.791965] Internal error: Oops: 817 [#1] PREEMPT
[   52.791965] CPU: 0    Not tainted  (2.6.23.1-rt5 #23)
[   52.791965] PC is at task_setprio+0x18/0x17c
[   52.791965] LR is at __rt_mutex_adjust_prio+0x30/0x34
[   52.791965] pc : [<c002a95c>]    lr : [<c004d488>]    psr: a0000093
[   52.791965] sp : c3823d80  ip : c3823db0  fp : c3823dac
[   52.791965] r10: ffffffff  r9 : a0000013  r8 : c3823ed0
[   52.791965] r7 : c036f544  r6 : c3823e08  r5 : a0000013  r4 : c02b6ca0
[   52.791965] r3 : 00000000  r2 : c02b6ec4  r1 : c02b6ec4  r0 : c02b6ca0
[   52.791965] Flags: NzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM
Segment user
[   52.791965] Control: c000717f  Table: 23ff4000  DAC: 00000015
[   52.791965] Process ceidrvtest (pid: 301, stack limit = 0xc3822260)
[   52.791965] Stack: (0xc3823d80 to 0xc3824000)
[   52.791965] 3d80: 00000002 00000001 c3823da4 c02b6ca0 a0000013
c3823e08 c036f544 c3823ed0
[   52.791965] 3da0: c3823dc4 c3823db0 c004d488 c002a954 c3823dd4
c3822000 c3823e04 c3823dc8
[   52.791965] 3dc0: c004dc60 c004d468 c0298000 ffffffff 00000000
c02b63a0 c3823e0c c3822000
[   52.791965] 3de0: a0000013 c036f544 00000000 c3823ed0 00000004
ffffffff c3823e64 c3823e08
[   52.791965] 3e00: c017309c c004dc28 c003c144 c003c0e0 00000000
c01b5ff0 c3823e44 c3823e28
[   52.791965] 3e20: c001eea8 c003c134 c3823e4c c3823e38 00000000
c004d128 c3823e64 c3822000
[   52.791965] 3e40: 00000000 c3823fb0 c3822000 c3823ed0 00000000
c3823f50 c3823e74 c3823e68
[   52.791965] 3e60: c0173420 c0172fc8 c3823e84 c3823e78 c0173434
c01733f0 c3823ebc c3823e88
[   52.791965] 3e80: c003ac84 c0173434 c3823fb0 c02b6ec4 c02b6f28
c3822000 00000000 c3823fb0
[   52.791965] 3ea0: c001f044 c001f044 c3822000 400298a8 c3823f9c
c3823ec0 c0021558 c003ac4c
[   52.791965] 3ec0: c3822000 400298a8 c02b6ec4 c3823ed8 c0172b20
c0172c8c c3823f04 c3823ee8
[   52.791965] 3ee0: c004e458 c0172ad8 c0171d70 c01d5a34 00000024
00000000 c3823f24 c3823f08
[   52.791965] 3f00: c00fd9a4 c004e444 c3823f54 00000000 c01d59b0
c3823f78 c3823f54 c3823f28
[   52.791965] 3f20: c00fe20c c00fd938 00000000 00000000 c001f044
000001ff c3e2ae80 40967c29
[   52.791965] 3f40: c3823f78 c001f044 c3823f74 c3823f58 c006e750
c00fe1bc 00000000 00000000
[   52.791965] 3f60: c3e2ae80 00000003 c3823fa4 c3823f78 c006eb70
409694d8 40969490 40042000
[   52.791965] 3f80: 00000003 c001f044 c3822000 400298a8 c3823fac
c3823fa0 c00219a0 c00214fc
[   52.791965] 3fa0: 00000000 c3823fb0 c001ef0c c0021984 fffffffc
40967c29 000001ff 000001ff
[   52.791965] 3fc0: 409694d8 40969490 40042000 00000003 40042000
003d0f00 400298a8 40967c0c
[   52.791965] 3fe0: 00000000 40967bd8 40033ea4 40033eb4 80000010
00000003 20002031 20002431
[   52.791965] Backtrace:
[   52.791965] [<c002a944>] (task_setprio+0x0/0x17c) from [<c004d488>]
(__rt_mutex_adjust_prio+0x30/0x34)
[   52.791965]  r8:c3823ed0 r7:c036f544 r6:c3823e08 r5:a0000013 r4:c02b6ca0
[   52.791965] [<c004d458>] (__rt_mutex_adjust_prio+0x0/0x34) from
[<c004dc60>] (task_blocks_on_rt_mutex+0x48/0x204)
[   52.791965]  r4:c3822000
[   52.791965] [<c004dc18>] (task_blocks_on_rt_mutex+0x0/0x204) from
[<c017309c>] (rt_spin_lock_slowlock+0xe4/0x1e8)
[   52.791965] [<c0172fb8>] (rt_spin_lock_slowlock+0x0/0x1e8) from
[<c0173420>] (__rt_spin_lock+0x40/0x44)
[   52.791965] [<c01733e0>] (__rt_spin_lock+0x0/0x44) from
[<c0173434>] (rt_spin_lock+0x10/0x14)
[   52.791965] [<c0173424>] (rt_spin_lock+0x0/0x14) from [<c003ac84>]
(get_signal_to_deliver+0x48/0x3e8)
[   52.791965] [<c003ac3c>] (get_signal_to_deliver+0x0/0x3e8) from
[<c0021558>] (do_signal+0x6c/0x488)
[   52.791965] [<c00214ec>] (do_signal+0x0/0x488) from [<c00219a0>]
(do_notify_resume+0x2c/0x30)
[   52.791965] [<c0021974>] (do_notify_resume+0x0/0x30) from
[<c001ef0c>] (work_pending+0x1c/0x20)
[   52.791965] Code: e24cb004 e24dd00c e351008c 83a03000 (85833000)
[   54.968721] note: ceidrvtest[301] exited with preempt_count 2
[   55.002901] Unable to handle kernel NULL pointer dereference at
virtual address 00000000
[   55.002901] pgd = c0004000
[   55.002901] [00000000] *pgd=00000000
[   55.002901] Internal error: Oops: 817 [#2] PREEMPT
[   55.002901] CPU: 0    Tainted: G      D  (2.6.23.1-rt5 #23)
[   55.002901] PC is at task_setprio+0x18/0x17c
[   55.002901] LR is at __rt_mutex_adjust_prio+0x30/0x34
[   55.002901] pc : [<c002a95c>]    lr : [<c004d488>]    psr: a0000093
[   55.002901] sp : c3823ae8  ip : c3823b18  fp : c3823b14
[   55.002901] r10: ffffffff  r9 : a0000013  r8 : 00000000
[   55.002901] r7 : c01b2000  r6 : c3823b70  r5 : a0000013  r4 : c02b6ca0
[   55.002901] r3 : 00000000  r2 : c02b6ec4  r1 : c02b6ec4  r0 : c02b6ca0
[   55.002901] Flags: NzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM
Segment user
[   55.002901] Control: c000717f  Table: 23ff4000  DAC: 00000015
[   55.002901] Process ceidrvtest (pid: 301, stack limit = 0xc3822260)
[   55.002901] Stack: (0xc3823ae8 to 0xc3824000)
[   55.002901] 3ae0:                   c3822000 000028cd 000028cd
c02b6ca0 a0000013 c3823b70
[   55.002901] 3b00: c01b2000 00000000 c3823b2c c3823b18 c004d488
c002a954 c002e7c8 c3822000
[   55.002901] 3b20: c3823b6c c3823b30 c004dc60 c004d468 00000001
00000000 00000000 c02b63a0
[   55.002901] 3b40: c004cb38 c3822000 a0000013 c01b2000 00000004
00000000 00000004 ffffffff
[   55.002901] 3b60: c3823bcc c3823b70 c017309c c004dc28 37383639
205d3132 c0033c00 00000000
[   55.002901] 3b80: c02b6ca0 409694d8 c0018674 c0018674 c02b6ca0
00000000 00000000 c0018674
[   55.002901] 3ba0: c02b6ca0 c02b6f10 c02b6ca0 c01b763c 00000000
00000000 c0018640 00000000
[   55.002901] 3bc0: c3823bdc c3823bd0 c0173420 c0172fc8 c3823bec
c3823be0 c0173618 c01733f0
[   55.002901] 3be0: c3823c0c c3823bf0 c00318e4 c0173618 c3823c0c
c3823c00 c002e0a4 c002dfe8
[   55.002901] 3c00: c3823c1c c3823c10 c0022c8c c00314f0 c3823c3c
c3823c20 c0023f9c c0022acc
[   55.002901] 3c20: ffffffff c01b422c c02b6ca0 c3823d38 c3823c84
c3823c40 c00241c8 c0023f40
[   55.002901] 3c40: c3823c64 c3823c50 c0028b08 c00289b8 c3823d38
00000817 c3823c7c ffffffff
[   55.002901] 3c60: c01b422c 00000817 c3823d38 00000000 a0000093
ffffffff c3823d34 c3823c88
[   55.002901] 3c80: c001e264 c0023fbc c3823cc4 c3823c98 c002abcc
c0171db0 c3823ca4 80000093
[   55.002901] 3ca0: c3823cec c028a040 00000000 c01ce5a8 c01b4d28
c01b4d50 c3823cd4 c3823cc8
[   55.002901] 3cc0: c002ac94 c002aad0 c3823cec c3823cd8 c00337a8
c002ac88 c01c7b80 20000093
[   55.002901] 3ce0: c3823d04 c3823cf0 c0034280 c0033740 c3823d14
c3823d00 c0051d50 c0052410
[   55.002901] 3d00: c0038120 c02b6ca0 c3823d2c c3823d18 c00382d4
ffffffff c3823d6c c3823e08
[   55.002901] 3d20: c036f544 c3823ed0 c3823dac c3823d38 c001ea80
c001e238 c02b6ca0 c02b6ec4
[   55.002901] 3d40: c02b6ec4 00000000 c02b6ca0 a0000013 c3823e08
c036f544 c3823ed0 a0000013
[   55.002901] 3d60: ffffffff c3823dac c3823db0 c3823d80 c004d488
c002a95c a0000093 ffffffff
[   55.002901] 3d80: 00000002 00000001 c3823da4 c02b6ca0 a0000013
c3823e08 c036f544 c3823ed0
[   55.002901] 3da0: c3823dc4 c3823db0 c004d488 c002a954 c3823dd4
c3822000 c3823e04 c3823dc8
[   55.002901] 3dc0: c004dc60 c004d468 c0298000 ffffffff 00000000
c02b63a0 c3823e0c c3822000
[   55.002901] 3de0: a0000013 c036f544 00000000 c3823ed0 00000004
ffffffff c3823e64 c3823e08
[   55.002901] 3e00: c017309c c004dc28 c003c144 c003c0e0 00000000
c01b5ff0 c3823e44 c3823e28
[   55.002901] 3e20: c001eea8 c003c134 c3823e4c c3823e38 00000000
c004d128 c3823e64 c3822000
[   55.002901] 3e40: 00000000 c3823fb0 c3822000 c3823ed0 00000000
c3823f50 c3823e74 c3823e68
[   55.002901] 3e60: c0173420 c0172fc8 c3823e84 c3823e78 c0173434
c01733f0 c3823ebc c3823e88
[   55.002901] 3e80: c003ac84 c0173434 c3823fb0 c02b6ec4 c02b6f28
c3822000 00000000 c3823fb0
[   55.002901] 3ea0: c001f044 c001f044 c3822000 400298a8 c3823f9c
c3823ec0 c0021558 c003ac4c
[   55.002901] 3ec0: c3822000 400298a8 c02b6ec4 c3823ed8 c0172b20
c0172c8c c3823f04 c3823ee8
[   55.002901] 3ee0: c004e458 c0172ad8 c0171d70 c01d5a34 00000024
00000000 c3823f24 c3823f08
[   55.002901] 3f00: c00fd9a4 c004e444 c3823f54 00000000 c01d59b0
c3823f78 c3823f54 c3823f28
[   55.002901] 3f20: c00fe20c c00fd938 00000000 00000000 c001f044
000001ff c3e2ae80 40967c29
[   55.002901] 3f40: c3823f78 c001f044 c3823f74 c3823f58 c006e750
c00fe1bc 00000000 00000000
[   55.002901] 3f60: c3e2ae80 00000003 c3823fa4 c3823f78 c006eb70
409694d8 40969490 40042000
[   55.002901] 3f80: 00000003 c001f044 c3822000 400298a8 c3823fac
c3823fa0 c00219a0 c00214fc
[   55.002901] 3fa0: 00000000 c3823fb0 c001ef0c c0021984 fffffffc
40967c29 000001ff 000001ff
[   55.002901] 3fc0: 409694d8 40969490 40042000 00000003 40042000
003d0f00 400298a8 40967c0c
[   55.002901] 3fe0: 00000000 40967bd8 40033ea4 40033eb4 80000010
00000003 20002031 20002431
[   55.002901] Backtrace:
[   55.002901] [<c002a944>] (task_setprio+0x0/0x17c) from [<c004d488>]
(__rt_mutex_adjust_prio+0x30/0x34)
[   55.002901]  r8:00000000 r7:c01b2000 r6:c3823b70 r5:a0000013 r4:c02b6ca0
[   55.002901] [<c004d458>] (__rt_mutex_adjust_prio+0x0/0x34) from
[<c004dc60>] (task_blocks_on_rt_mutex+0x48/0x204)
[   55.002901]  r4:c3822000
[   55.002901] [<c004dc18>] (task_blocks_on_rt_mutex+0x0/0x204) from
[<c017309c>] (rt_spin_lock_slowlock+0xe4/0x1e8)
[   55.002901] [<c0172fb8>] (rt_spin_lock_slowlock+0x0/0x1e8) from
[<c0173420>] (__rt_spin_lock+0x40/0x44)
[   55.002901] [<c01733e0>] (__rt_spin_lock+0x0/0x44) from
[<c0173618>] (rt_write_lock+0x10/0x14)
[   55.002901] [<c0173608>] (rt_write_lock+0x0/0x14) from [<c00318e4>]
(do_exit+0x404/0x7fc)
[   55.002901] [<c00314e0>] (do_exit+0x0/0x7fc) from [<c0022c8c>]
(die+0x1d0/0x21c)
[   55.002901] [<c0022abc>] (die+0x0/0x21c) from [<c0023f9c>]
(__do_kernel_fault+0x6c/0x7c)
[   55.002901] [<c0023f30>] (__do_kernel_fault+0x0/0x7c) from
[<c00241c8>] (do_page_fault+0x21c/0x238)
[   55.002901]  r7:c3823d38 r6:c02b6ca0 r5:c01b422c r4:ffffffff
[   55.002901] [<c0023fac>] (do_page_fault+0x0/0x238) from
[<c001e264>] (do_DataAbort+0x3c/0xa0)
[   55.002901] [<c001e228>] (do_DataAbort+0x0/0xa0) from [<c001ea80>]
(__dabt_svc+0x40/0x60)
[   55.002901] Exception stack(0xc3823d38 to 0xc3823d80)
[   55.002901] 3d20:
    c02b6ca0 c02b6ec4
[   55.002901] 3d40: c02b6ec4 00000000 c02b6ca0 a0000013 c3823e08
c036f544 c3823ed0 a0000013
[   55.002901] 3d60: ffffffff c3823dac c3823db0 c3823d80 c004d488
c002a95c a0000093 ffffffff
[   55.002901]  r8:c3823ed0 r7:c036f544 r6:c3823e08 r5:c3823d6c r4:ffffffff
[   55.002901] [<c002a944>] (task_setprio+0x0/0x17c) from [<c004d488>]
(__rt_mutex_adjust_prio+0x30/0x34)
[   55.002901]  r8:c3823ed0 r7:c036f544 r6:c3823e08 r5:a0000013 r4:c02b6ca0
[   55.002901] [<c004d458>] (__rt_mutex_adjust_prio+0x0/0x34) from
[<c004dc60>] (task_blocks_on_rt_mutex+0x48/0x204)
[   55.002901]  r4:c3822000
[   55.002901] [<c004dc18>] (task_blocks_on_rt_mutex+0x0/0x204) from
[<c017309c>] (rt_spin_lock_slowlock+0xe4/0x1e8)
[   55.002901] [<c0172fb8>] (rt_spin_lock_slowlock+0x0/0x1e8) from
[<c0173420>] (__rt_spin_lock+0x40/0x44)
[   55.002901] [<c01733e0>] (__rt_spin_lock+0x0/0x44) from
[<c0173434>] (rt_spin_lock+0x10/0x14)
[   55.002901] [<c0173424>] (rt_spin_lock+0x0/0x14) from [<c003ac84>]
(get_signal_to_deliver+0x48/0x3e8)
[   55.002901] [<c003ac3c>] (get_signal_to_deliver+0x0/0x3e8) from
[<c0021558>] (do_signal+0x6c/0x488)
[   55.002901] [<c00214ec>] (do_signal+0x0/0x488) from [<c00219a0>]
(do_notify_resume+0x2c/0x30)
[   55.002901] [<c0021974>] (do_notify_resume+0x0/0x30) from
[<c001ef0c>] (work_pending+0x1c/0x20)
[   55.002901] Code: e24cb004 e24dd00c e351008c 83a03000 (85833000)
[   59.099579] Fixing recursive fault but reboot is needed!
[   59.130829] BUG: scheduling while atomic: ceidrvtest/0x00000005/301, CPU#0
[   59.130829] [<c0022d88>] (dump_stack+0x0/0x14) from [<c0029bec>]
(__schedule_bug+0x3c/0x48)
[   59.130829] [<c0029bb0>] (__schedule_bug+0x0/0x48) from
[<c0171820>] (__schedule+0x90/0x44c)
[   59.130829] [<c0171790>] (__schedule+0x0/0x44c) from [<c0171fa4>]
(schedule+0xd0/0x118)
[   59.130829]  r7:00000817 r6:0000000b r5:c02b6ca0 r4:c3822000
[   59.130829] [<c0171ed4>] (schedule+0x0/0x118) from [<c00315ec>]
(do_exit+0x10c/0x7fc)
[   59.130829]  r4:c3822000
[   59.130829] [<c00314e0>] (do_exit+0x0/0x7fc) from [<c0022c8c>]
(die+0x1d0/0x21c)
[   59.130829] [<c0022abc>] (die+0x0/0x21c) from [<c0023f9c>]
(__do_kernel_fault+0x6c/0x7c)
[   59.130829] [<c0023f30>] (__do_kernel_fault+0x0/0x7c) from
[<c00241c8>] (do_page_fault+0x21c/0x238)
[   59.130829]  r7:c3823aa0 r6:c02b6ca0 r5:c01b422c r4:ffffffff
[   59.130829] [<c0023fac>] (do_page_fault+0x0/0x238) from
[<c001e264>] (do_DataAbort+0x3c/0xa0)
[   59.130829] [<c001e228>] (do_DataAbort+0x0/0xa0) from [<c001ea80>]
(__dabt_svc+0x40/0x60)
[   59.130829] Exception stack(0xc3823aa0 to 0xc3823ae8)
[   59.130829] 3aa0: c02b6ca0 c02b6ec4 c02b6ec4 00000000 c02b6ca0
a0000013 c3823b70 c01b2000
[   59.130829] 3ac0: 00000000 a0000013 ffffffff c3823b14 c3823b18
c3823ae8 c004d488 c002a95c
[   59.130829] 3ae0: a0000093 ffffffff
[   59.130829]  r8:00000000 r7:c01b2000 r6:c3823b70 r5:c3823ad4 r4:ffffffff
[   59.130829] [<c002a944>] (task_setprio+0x0/0x17c) from [<c004d488>]
(__rt_mutex_adjust_prio+0x30/0x34)
[   59.130829]  r8:00000000 r7:c01b2000 r6:c3823b70 r5:a0000013 r4:c02b6ca0
[   59.130829] [<c004d458>] (__rt_mutex_adjust_prio+0x0/0x34) from
[<c004dc60>] (task_blocks_on_rt_mutex+0x48/0x204)
[   59.130829]  r4:c3822000
[   59.130829] [<c004dc18>] (task_blocks_on_rt_mutex+0x0/0x204) from
[<c017309c>] (rt_spin_lock_slowlock+0xe4/0x1e8)
[   59.130829] [<c0172fb8>] (rt_spin_lock_slowlock+0x0/0x1e8) from
[<c0173420>] (__rt_spin_lock+0x40/0x44)
[   59.130829] [<c01733e0>] (__rt_spin_lock+0x0/0x44) from
[<c0173618>] (rt_write_lock+0x10/0x14)
[   59.130829] [<c0173608>] (rt_write_lock+0x0/0x14) from [<c00318e4>]
(do_exit+0x404/0x7fc)
[   59.130829] [<c00314e0>] (do_exit+0x0/0x7fc) from [<c0022c8c>]
(die+0x1d0/0x21c)
[   59.130829] [<c0022abc>] (die+0x0/0x21c) from [<c0023f9c>]
(__do_kernel_fault+0x6c/0x7c)
[   59.130829] [<c0023f30>] (__do_kernel_fault+0x0/0x7c) from
[<c00241c8>] (do_page_fault+0x21c/0x238)
[   59.130829]  r7:c3823d38 r6:c02b6ca0 r5:c01b422c r4:ffffffff
[   59.130829] [<c0023fac>] (do_page_fault+0x0/0x238) from
[<c001e264>] (do_DataAbort+0x3c/0xa0)
[   59.130829] [<c001e228>] (do_DataAbort+0x0/0xa0) from [<c001ea80>]
(__dabt_svc+0x40/0x60)
[   59.130829] Exception stack(0xc3823d38 to 0xc3823d80)
[   59.130829] 3d20:
    c02b6ca0 c02b6ec4
[   59.130829] 3d40: c02b6ec4 00000000 c02b6ca0 a0000013 c3823e08
c036f544 c3823ed0 a0000013
[   59.130829] 3d60: ffffffff c3823dac c3823db0 c3823d80 c004d488
c002a95c a0000093 ffffffff
[   59.130829]  r8:c3823ed0 r7:c036f544 r6:c3823e08 r5:c3823d6c r4:ffffffff
[   59.130829] [<c002a944>] (task_setprio+0x0/0x17c) from [<c004d488>]
(__rt_mutex_adjust_prio+0x30/0x34)
[   59.130829]  r8:c3823ed0 r7:c036f544 r6:c3823e08 r5:a0000013 r4:c02b6ca0
[   59.130829] [<c004d458>] (__rt_mutex_adjust_prio+0x0/0x34) from
[<c004dc60>] (task_blocks_on_rt_mutex+0x48/0x204)
[   59.130829]  r4:c3822000
[   59.130829] [<c004dc18>] (task_blocks_on_rt_mutex+0x0/0x204) from
[<c017309c>] (rt_spin_lock_slowlock+0xe4/0x1e8)
[   59.130829] [<c0172fb8>] (rt_spin_lock_slowlock+0x0/0x1e8) from
[<c0173420>] (__rt_spin_lock+0x40/0x44)
[   59.130829] [<c01733e0>] (__rt_spin_lock+0x0/0x44) from
[<c0173434>] (rt_spin_lock+0x10/0x14)
[   59.130829] [<c0173424>] (rt_spin_lock+0x0/0x14) from [<c003ac84>]
(get_signal_to_deliver+0x48/0x3e8)
[   59.130829] [<c003ac3c>] (get_signal_to_deliver+0x0/0x3e8) from
[<c0021558>] (do_signal+0x6c/0x488)
[   59.130829] [<c00214ec>] (do_signal+0x0/0x488) from [<c00219a0>]
(do_notify_resume+0x2c/0x30)
[   59.130829] [<c0021974>] (do_notify_resume+0x0/0x30) from
[<c001ef0c>] (work_pending+0x1c/0x20)
