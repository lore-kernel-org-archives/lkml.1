Return-Path: <linux-kernel-owner+w=401wt.eu-S1753381AbYJBJox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381AbYJBJox (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 05:44:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753424AbYJBJog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 05:44:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55931 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753368AbYJBJof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 05:44:35 -0400
Date: Thu, 2 Oct 2008 11:38:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Jonathan Corbet <corbet@lwn.net>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Martin Bligh <mbligh@google.com>,
       Christoph Hellwig <hch@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [boot crash] Re: [PATCH] ring-buffer: fix build error
Message-ID: <20081002093835.GA17699@elte.hu>
References: <alpine.DEB.1.10.0809292359030.19533@gandalf.stny.rr.com> <20080930092001.69849210@bike.lwn.net> <1222790072.24384.21.camel@twins> <alpine.LFD.2.00.0809300930090.3389@nehalem.linux-foundation.org> <alpine.DEB.1.10.0809301242550.1984@gandalf.stny.rr.com> <alpine.LFD.2.00.0809300958120.3389@nehalem.linux-foundation.org> <alpine.DEB.1.10.0810011114000.30777@gandalf.stny.rr.com> <20081002085030.GF26084@elte.hu> <20081002085145.GA3202@elte.hu> <20081002090517.GA8708@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081002090517.GA8708@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > that was for the type filter commit. The 3 patches i've picked up into 
> > tip/tracing/ring-buffer are:
> > 
> >  b6eeea4: ftrace: preempt disable over interrupt disable
> >  52abc82: ring_buffer: allocate buffer page pointer
> >  da78331: ftrace: type cast filter+verifier
> 
> trivial build fix below.

ok, these latest ring-buffer updates cause more serious trouble, i just 
got this boot crash on a testbox:

[    0.324003] calling  tracer_alloc_buffers+0x0/0x14a @ 1
[    0.328008] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
[    0.332001] IP: [<ffffffff8027d28b>] ring_buffer_alloc+0x207/0x3fc
[    0.332001] PGD 0 
[    0.332001] Oops: 0000 [1] SMP 
[    0.332001] CPU 0 
[    0.332001] Modules linked in:
[    0.332001] Pid: 1, comm: swapper Not tainted 2.6.27-rc8-tip-01064-gd163d6b-dirty #1
[    0.332001] RIP: 0010:[<ffffffff8027d28b>]  [<ffffffff8027d28b>] ring_buffer_alloc+0x207/0x3fc
[    0.332001] RSP: 0018:ffff88003f9d7de0  EFLAGS: 00010287
[    0.332001] RAX: 0000000000000000 RBX: ffffffff80b08404 RCX: 0000000000000067
[    0.332001] RDX: 0000000000000004 RSI: 00000000000080d0 RDI: ffffffffffffffc0
[    0.332001] RBP: ffff88003f9d7e80 R08: ffff88003f8010b4 R09: 000000000003db02
[    0.332001] R10: 0000000000000000 R11: 0000000000000001 R12: ffff88003f801600
[    0.332001] R13: 0000000000000004 R14: ffff88003f801580 R15: ffff88003f801618
[    0.332001] FS:  0000000000000000(0000) GS:ffffffff80a68280(0000) knlGS:0000000000000000
[    0.332001] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[    0.332001] CR2: 0000000000000008 CR3: 0000000000201000 CR4: 00000000000006e0
[    0.332001] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    0.332001] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    0.332001] Process swapper (pid: 1, threadinfo ffff88003f9d6000, task ffff88003f9d8000)
[    0.332001] Stack:  ffff88003f9d7df0 ffff88003f9d7e40 0000000000000283 ffffffff80b08404
[    0.332001]  ffffffff80b08404 ffff88003f801598 0000000000000000 ffff88003f801598
[    0.332001]  ffff88003f801580 0000016000000000 ffff88003f801600 ffff88003f9a2a40
[    0.332001] Call Trace:
[    0.332001]  [<ffffffff80a95f41>] ? tracer_alloc_buffers+0x0/0x14a
[    0.332001]  [<ffffffff80a95f67>] tracer_alloc_buffers+0x26/0x14a
[    0.332001]  [<ffffffff80a95f41>] ? tracer_alloc_buffers+0x0/0x14a
[    0.332001]  [<ffffffff80209056>] do_one_initcall+0x56/0x144
[    0.332001]  [<ffffffff80a87d4a>] ? native_smp_prepare_cpus+0x2aa/0x2ef
[    0.332001]  [<ffffffff80a7c8ce>] kernel_init+0x69/0x20e
[    0.332001]  [<ffffffff8020d4e9>] child_rip+0xa/0x11
[    0.332001]  [<ffffffff80257896>] ? __atomic_notifier_call_chain+0xd/0xf
[    0.332001]  [<ffffffff80a7c865>] ? kernel_init+0x0/0x20e
[    0.332001]  [<ffffffff8020d4df>] ? child_rip+0x0/0x11
[    0.332001] Code: 48 8b 05 d9 b2 7e 00 49 63 d5 48 63 0d 1b b2 7e 00 48 8b 9d 78 ff ff ff be d0 80 00 00 48 8b 04 d0 48 89 cf 48 83 c1 27 48 f7 df <48> 8b 40 08 48 21 cf 8b 14 03 e8 4e b5 02 00 48 85 c0 48 89 c3 
[    0.332001] RIP  [<ffffffff8027d28b>] ring_buffer_alloc+0x207/0x3fc
[    0.332001]  RSP <ffff88003f9d7de0>
[    0.332001] CR2: 0000000000000008
[    0.332002] Kernel panic - not syncing: Fatal exception

full serial log and config attached. I'm excluding these latest commits 
from tip/master for now:

 339ce9a: ring-buffer: fix build error
 b6eeea4: ftrace: preempt disable over interrupt disable
 52abc82: ring_buffer: allocate buffer page pointer
 da78331: ftrace: type cast filter+verifier

i'm quite sure 52abc82 causes this problem.

Another 64-bit testbox crashed too meanwhile.

	Ingo
