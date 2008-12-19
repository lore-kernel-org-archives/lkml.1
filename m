Return-Path: <linux-kernel-owner+w=401wt.eu-S1753369AbYLSVtK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369AbYLSVtK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 16:49:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751645AbYLSVs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 16:48:57 -0500
Received: from www.tglx.de ([62.245.132.106]:45640 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479AbYLSVs4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 16:48:56 -0500
Date: Fri, 19 Dec 2008 22:48:19 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Eric Sesterhenn <snakebyte@gmx.de>
cc: LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [BUG] Null pointer deref with hrtimer_try_to_cancel()
In-Reply-To: <20081219172549.GA25722@alice>
Message-ID: <alpine.LFD.2.00.0812192243350.3376@localhost.localdomain>
References: <20081219172549.GA25722@alice>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Dec 2008, Eric Sesterhenn wrote:
> hi,

CC'ed Oleg

> I was running the strace-test from ltp 20081130 with 2.6.28-rc9, when i got the following bug
> (I can reproduce the bug by simply running the testcase timer_create04)
>
> [ 2460.441441] BUG: unable to handle kernel NULL pointer dereference at
> 00000003
> [ 2460.441749] IP: [<c02a78c1>] _raw_spin_lock+0x11/0x110
> [ 2460.442012] *pde = 00000000 
> [ 2460.442161] Oops: 0000 [#2] DEBUG_PAGEALLOC
> [ 2460.442420] last sysfs file: /sys/block/sda/size
> [ 2460.442541] Modules linked in: sctp nfsd auth_rpcgss exportfs nfs
> lockd nfs_acl sunrpc ipv6 fuse unix
> [ 2460.443471] 
> [ 2460.443628] Pid: 14406, comm: timer_create04 Tainted: G      D W
> (2.6.28-rc9 #71) 
> [ 2460.443811] EIP: 0060:[<c02a78c1>] EFLAGS: 00010096 CPU: 0
> [ 2460.443941] EIP is at _raw_spin_lock+0x11/0x110
> [ 2460.444044] EAX: ffffffff EBX: ffffffff ECX: 00000000 EDX: 00000000
> [ 2460.444044] ESI: 00000096 EDI: c08337ec EBP: c8fc7ee0 ESP: c8fc7eb8
> [ 2460.444044]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> [ 2460.444044] Process timer_create04 (pid: 14406, ti=c8fc7000
> task=c8db5710 task.ti=c8fc7000)
> [ 2460.444044] Stack:
> [ 2460.444044]  00000046 00000000 00000002 00000001 00000000 c0141070
> 0000000f ffffffff
> [ 2460.444044]  00000096 c08337ec c8fc7f00 c05ac067 00000000 00000002
> 00000000 c0141070
> [ 2460.444044]  ffffffff c1956aa4 c8fc7f1c c0141070 00000002 00000000
> c1956a60 c1956a68
> [ 2460.444044] Call Trace:
> [ 2460.444044]  [<c0141070>] ? hrtimer_try_to_cancel+0x20/0x90
> [ 2460.444044]  [<c05ac067>] ? _spin_lock_irqsave+0x47/0x60
> [ 2460.444044]  [<c0141070>] ? hrtimer_try_to_cancel+0x20/0x90
> [ 2460.444044]  [<c0141070>] ? hrtimer_try_to_cancel+0x20/0x90
> [ 2460.444044]  [<c013cf94>] ? exit_itimers+0x94/0xf0
> [ 2460.444044]  [<c012cab2>] ? do_exit+0x602/0x810
> [ 2460.444044]  [<c05abe5d>] ? _spin_unlock+0x1d/0x20
> [ 2460.444044]  [<c01a245e>] ? vfs_write+0xfe/0x160
> [ 2460.444044]  [<c0319090>] ? tty_write+0x0/0x1f0
> [ 2460.444044]  [<c012ccef>] ? do_group_exit+0x2f/0x90
> [ 2460.444044]  [<c012cd63>] ? sys_exit_group+0x13/0x20
> [ 2460.444044]  [<c01035a9>] ? sysenter_do_call+0x12/0x31
> [ 2460.444044] Code: 00 a1 00 c0 82 c0 89 41 0c 89 d8 5b 5d c3 8d b6 00
> 00 00 00 8d bf 00 00 00 00 55 89 e5 83 ec 28 89 5d f4 89 c3 89 75 f8 89
> 7d fc <81> 78 04 ad 4e ad de 74 0a ba 77 3f 79 c0 e8 2c fe ff ff a1 00 
> [ 2460.444044] EIP: [<c02a78c1>] _raw_spin_lock+0x11/0x110 SS:ESP
> 0068:c8fc7eb8
> [ 2460.444044] ---[ end trace 85ae5af0da78d5d7 ]---
> [ 2460.444044] Fixing recursive fault but reboot is needed!
> 
> 
> 
> (gdb) l *(_raw_spin_lock+0x11)
> 0xc02a78c1 is in _raw_spin_lock (lib/spinlock_debug.c:78).
> 73	#define SPIN_BUG_ON(cond, lock, msg) if (unlikely(cond))
> spin_bug(lock, msg)
> 74	
> 75	static inline void
> 76	debug_spin_lock_before(spinlock_t *lock)
> 77	{
> 78		SPIN_BUG_ON(lock->magic != SPINLOCK_MAGIC, lock, "bad
> magic");
> 79		SPIN_BUG_ON(lock->owner == current, lock, "recursion");
> 80		SPIN_BUG_ON(lock->owner_cpu == raw_smp_processor_id(),
> 81								lock,
> "cpu recursion");
> 82	}
> (gdb) q
> 
> (gdb) l *(hrtimer_try_to_cancel+0x20)
> 0xc0141070 is in hrtimer_try_to_cancel (kernel/hrtimer.c:234).
> 229	static inline struct hrtimer_clock_base *
> 230	lock_hrtimer_base(const struct hrtimer *timer, unsigned long
> *flags)
> 231	{
> 232		struct hrtimer_clock_base *base = timer->base;
> 233	
> 234		spin_lock_irqsave(&base->cpu_base->lock, *flags);
> 235	
> 236		return base;
> 237	}
> 238	
> (gdb) 
> 
> The testcase aborts in pass number 6:
> 
> root@computer-desktop:~/testing/ltp-full-20081130/tools/strace_test#
> ./timer_create04 
> timer_create04    1  FAIL  :  timer_create(2) failed to produce expected
> error; 22 , errno : EINVAL and got 0
> timer_create04    2  PASS  :  timer_create(2) expected failure; Got
> errno - EINVAL : Invalid parameter
> timer_create04    3  PASS  :  timer_create(2) expected failure; Got
> errno - EFAULT : Bad address
> timer_create04    4  PASS  :  timer_create(2) expected failure; Got
> errno - EFAULT : Bad address
> timer_create04    5  PASS  :  timer_create(2) expected failure; Got
> errno - EFAULT : Bad address
> timer_create04    6  PASS  :  timer_create(2) expected failure; Got
> errno - EFAULT : Bad address
> 
> Greetings, Eric
> 
