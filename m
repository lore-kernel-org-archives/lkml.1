Return-Path: <linux-kernel-owner+w=401wt.eu-S1755589AbYDJHBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589AbYDJHBR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 03:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752256AbYDJHBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 03:01:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47464 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744AbYDJHBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 03:01:05 -0400
Date: Thu, 10 Apr 2008 09:00:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, akpm@osdl.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Jan Beulich <jbeulich@novell.com>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>, pinskia@gcc.gnu.org
Subject: Re: [PATCH] pop previous section in alternative.c
Message-ID: <20080410070008.GC30066@elte.hu>
References: <Pine.LNX.4.58.0804091859400.31879@gandalf.stny.rr.com> <Pine.LNX.4.58.0804091906040.31970@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0804091906040.31970@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



* Steven Rostedt <rostedt@goodmis.org> wrote:



> On Wed, 9 Apr 2008, Steven Rostedt wrote:

> 

> > gcc expects all toplevel assembly to return to the original section 

> > type. The code in alteranative.c does not do this. This caused some 

> > strange bugs in sched-devel where code would end up in the .rodata 

> > section and when the kernel sets the NX bit on all .rodata, the 

> > kernel would crash when executing this code.

> >

> > This patch adds a .previous marker to return the code back to the 

> > original section.

> 

> Oh, and this would not be complete without giving Andrew Pinski 

> complete credit for telling me it wasn't a gcc bug but a bug in the 

> toplevel asm code in the kernel. ;-)



thanks Steve and Andrew for resolving this so quickly! For the record, 

here's the original, mysterious-looking crash that Peter saw with ftrace 

enabled, under sched-devel:



---------->

ACPI: PCI Interrupt 0000:01:0e.1[A] -> GSI 11 (level, low) -> IRQ 11

Waiting for driver initialization.

Loading shpchp.ko module

BUG: unable to handle kernel paging request at ffffffff8054f06a

IP: [<ffffffff8054f06a>] constant_test_bit+0x0/0x26

PGD 203067 PUD 207063 PMD 7f81d163 PTE 800000000054f161

Oops: 0011 [1] PREEMPT SMP 

CPU 0 

Modules linked in: sata_svw ata_generic

Pid: 565, comm: insmod Not tainted 2.6.25-rc8-sched-devel.git-x86-latest.git #177

RIP: 0010:[<ffffffff8054f06a>]  [<ffffffff8054f06a>] constant_test_bit+0x0/0x26

RSP: 0018:ffff81007d693d40  EFLAGS: 00010246

RAX: ffff81007f805db0 RBX: ffff81007d4e5b80 RCX: 0000000000000000

RDX: ffff81007d4e5bb0 RSI: ffffffff8074c114 RDI: 0000000000000069

RBP: ffff81007d693d88 R08: ffffffff80964770 R09: 0000000000000000

R10: 000000037d693c78 R11: ffff81007d693cd8 R12: ffffffffa000b464

R13: ffffffffa0008000 R14: ffffffffa000cdc0 R15: ffffffffa000cda0

FS:  00007f96cec7d6f0(0000) GS:ffffffff8072a000(0000) knlGS:0000000000000000

CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b

CR2: ffffffff8054f06a CR3: 000000007d5c8000 CR4: 00000000000006e0

DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000

DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400

Process insmod (pid: 565, threadinfo ffff81007d692000, task ffff81007d690000)

Stack:  ffffffff802125c9 ffff81007d693d78 ffffffffa0010998 ffffffffa0010980

 ffffc20000032790 ffffc20000031f1d 0000000000000000 ffffc20000032010

 ffffc2000002b000 ffff81007d693de8 ffffffff8022359f ffffffffa0010980

Call Trace:

 [<ffffffff802125c9>] ? alternatives_smp_module_add+0x117/0x14e

 [<ffffffff8022359f>] module_finalize+0x118/0x136

 [<ffffffff80268b08>] sys_init_module+0x1496/0x1a79

 [<ffffffff8053c61a>] ? _spin_unlock_irqrestore+0x6b/0x79

 [<ffffffff80383ba5>] ? acpi_get_hp_params_from_firmware+0x0/0x50b

 [<ffffffff8053b88d>] ? trace_hardirqs_on_thunk+0x3a/0x3f

 [<ffffffff8053b88d>] ? trace_hardirqs_on_thunk+0x3a/0x3f

 [<ffffffff8025ee36>] ? trace_hardirqs_on_caller+0x109/0x12d

 [<ffffffff8053b88d>] ? trace_hardirqs_on_thunk+0x3a/0x3f

 [<ffffffff8020c41b>] system_call_after_swapgs+0x7b/0x80



Code: 00 00 0f 1f 80 00 00 00 00 0f 1f 84 00 00 00 00 00 55 48 89 e5 e8 d7 d1 cb ff 89 f8 c1 f8 05 48 98 48 8d 04 86 f0 0f b3 3e c9 c3 <55> 48 89 e5 e8 bd d1 cb ff 89 f9 bf 40 00 00 00 89 c8 99 f7 ff 

RIP  [<ffffffff8054f06a>] constant_test_bit+0x0/0x26

 RSP <ffff81007d693d40>

CR2: ffffffff8054f06a

---[ end trace 778e504de7e3b1e3 ]---

note: insmod[565] exited with preempt_count 1

BUG: sleeping function called from invalid context at /mnt/md0/src/linux-2.6-2/kernel/rwsem.c:21



(it only triggered on Peter's hardware)



	Ingo

