Return-Path: <linux-kernel-owner+w=401wt.eu-S1753303AbYKQPmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303AbYKQPmX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 10:42:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752141AbYKQPmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 10:42:15 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:48259 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbYKQPmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 10:42:14 -0500
Date: Mon, 17 Nov 2008 10:42:11 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Paul Mackerras <paulus@samba.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Pekka Paalanen <pq@iki.fi>,
       linuxppc-dev@ozlabs.org, Rusty Russell <rusty@rustcorp.com.au>,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 0/7] Porting dynmaic ftrace to PowerPC
In-Reply-To: <18720.42209.880409.297291@cargo.ozlabs.ibm.com>
Message-ID: <alpine.DEB.1.10.0811171035530.2919@gandalf.stny.rr.com>
References: <20081116212428.938752312@goodmis.org> <18720.42209.880409.297291@cargo.ozlabs.ibm.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 17 Nov 2008, Paul Mackerras wrote:

> Steven Rostedt writes:
> 
> > The following patches are for my work on porting the new dynamic ftrace
> > framework to PowerPC.  The issue I had with both PPC64 and PPC32 is
> > that the calls to mcount are 24 bit jumps. Since the modules are
> > loaded in vmalloc address space, the call to mcount is farther than
> > what a 24 bit jump can make. The way PPC solves this is with the use
> > of trampolines. The trampoline is a memory space allocated within the
> > 24 bit region of the module. The code in the trampoline that the
> > jump is made to does a far jump to the core kernel code.
> 
> Thanks for doing this work.  I'll go through the patches in detail
> today, but first I'd like to clear up a couple of things for you.  The
> first is that unconditional branches on PowerPC effectively have a
> 26-bit sign-extended offset, not 24-bit.  The offset field in the
> instruction is 24 bits long, but because all instructions are 4 bytes
> long, two extra 0 bits get appended to the offset field, giving a
> 26-bit offset and a range of +/- 32MB from the branch instruction.

Ah yes, thanks for the clarification.

> 
> > PPC64, although works with 64 bit registers, the op codes are still
> > 32 bit in length.  PPC64 uses table of contents (TOC) fields
> > to make their calls to functions. A function name is really a pointer
> > into the TOC table that stores the actual address of the function
> > along with the TOC of that function. The r2 register plays as the
> > TOC pointer. The actual name of the function is the function name
> > with a dot '.' prefix.  The reference name "schedule" is really
> > to the TOC entry, which calls the actual code with the reference
> > name ".schedule". This also explains why the list of available filter
> > functions on PPC64 all have a dot prefix.
> 
> A little more detail: the TOC mainly stores addresses and other
> constants.  Functions have a descriptor that is stored in a .opd
> section (not the TOC, though the TOC may contain pointers to procedure
> descriptors).  Each descriptor has the address of the code, the
> address of the TOC for the function, and a static chain pointer (not
> used for C, but can used for other languages).  As you note, the
> symbol for a function will be the address of the descriptor rather
> than the address of the function code.
> 
> > When a funtion is called, it uses the 'bl' command which is a 24
> > bit function jump (saving the return address in the link register).
> > The next operation after all 'bl' calls is a nop. What the module
> > load code does when one of these 'bl' calls is farther than 24 bits
> > can handle, it creates a entry in the TOC and has the 'bl' call to
> 
> The module loader allocates some memory for these trampolines, but
> that's a distinct area from the TOC and the OPD section.

Ah, yes, my mistake. It is a trampoline entry, not part of the TOC.

> 
> > that entry. The entry in the TOC will save the r2 register on the
> > stack "40(r1)" load the actually function into the ctrl register
> 
> "counter" register, actually, not "ctrl".

Oops, I still make that mistake :-/  I use to do a lot of PPC work several 
years ago, and I would always call that the control register, and my 
colleagues would always correct me and say its the counter register. I 
guess some things just don't change ;-)


> 
> > The work for PPC32 is very much the same as the PPC64 code but the 32
> > version does not need to deal with TOCS. This makes the code much
> > simpler. Pretty much everything as PPC64 is done, except it does not
> > need to index a TOC.
> 
> Right.
> 
> > I've tested the following patches on both PPC64 and PPC32. I will
> > admit that the PPC64 does not seem that stable, but neither does the
> > code when all this is not enabled ;-)  I'll debug it more to see if
> > I can find the cause of my crashes, which may or may not be related
> > to the dynamic ftrace code. But the use of TOCS in PPC64 make me
> > a bit nervious that I did not do this correctly. Any help in reviewing
> > my code for mistakes would be greatly appreciated.
> 
> Hmmm.  What sort of crashes are you seeing?

This code is in tip, which is mainly used to develop for x86. I've hit a 
few crashes, and I think I hit a couple without this code. But here's an 
example:

huh, entered softirq 4 c000000000846ad8 preempt_count 10000103, exited 
with fffefffe?
------------[ cut here ]------------
Badness at kernel/sched_fair.c:875
NIP: c00000000004bfb8 LR: c00000000004bf7c CTR: c0000000000b5830
REGS: c00000003929cce0 TRAP: 0700   Not tainted  (2.6.28-rc4-tip)
MSR: 9000000000021032 <ME,IR,DR>  CR: 28822842  XER: 20000000
TASK = c00000003d93cd10[2061] 'remove-trailing' THREAD: c00000003929c000 
CPU: 1
GPR00: 0000000000000001 c00000003929cf60 c000000000887070 c000000000ae2d00 
GPR04: c00000000004c2c0 0000000000003320 c00000003929cb70 000000000000080d 
GPR08: c00000000079333c 000000000002ffff c000000000903380 c000000000903380 
GPR12: 0000000048822848 c000000000903580 c000000000794000 0000000000000000 
GPR16: c000000000903380 0000000000000001 c000000000909f7c 7fffffffffffffff 
GPR20: c00000003929d8e0 c000000000ae2f20 00000086b6e84cc0 0000000000000001 
GPR24: 0000000000000001 c000000000794000 c00000003d93cd10 c00000003d934f20 
GPR28: c000000000ae4000 c00000003d93cd48 c000000000803550 c00000003929cf60 
cpu 0x1: Vector: 400 (Instruction Access) at [c00000003929be1f]
    pc: 01c0000000000ae8
    lr: 01c0000000000aeb
    sp: c00000003929c09f
   msr: 9000000040001032
  current = 0xc00000003d93cd10
  paca    = 0xc000000000903580
    pid   = 2061, comm = remove-trailing


Then it went into the monitor that is loaded. When I fix the rest of my 
patches, I'll see if it is not my code that is crashing this, and then 
I'll see if I can figure out what is causing some of these crashes.

Thanks Paul for all the feedback!

-- Steve

